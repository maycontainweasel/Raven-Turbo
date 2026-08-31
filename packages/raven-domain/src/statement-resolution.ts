import { RavenDomainError } from "./errors.js";
import {
  canonicalStatementJson,
  statementSha256,
} from "./statement-adapters.js";
import type { TransactionRecord } from "./contracts.js";
import type {
  StatementImportRecord,
  StatementIssueRecord,
  StatementRowComponentRecord,
  StatementRowRecord,
} from "./statement-contracts.js";
import {
  STATEMENT_MATCH_DATE_WINDOW_DAYS,
  type StatementComponentResolution,
  type StatementMatchMethod,
  type StatementMatchReasonCode,
  type StatementReconciliationRecord,
  type StatementTransactionCandidate,
  type StatementTransactionMatchRecord,
} from "./statement-resolution-contracts.js";

const DAY_MS = 86_400_000;

export function statementCheckedAdd(
  left: number,
  right: number,
  label: string,
): number {
  const result = left + right;
  if (!Number.isSafeInteger(result)) {
    throw new RavenDomainError(
      "STATEMENT_COMPONENT_TOTAL_MISMATCH",
      `${label} exceeds the safe integer range`,
    );
  }
  return result;
}

export async function retryStatementReconciliationMutation<
  TCalculation,
  TResult,
>(
  calculate: () => Promise<TCalculation>,
  persist: (calculated: TCalculation) => Promise<TResult>,
): Promise<TResult> {
  for (let attempt = 0; attempt < 2; attempt += 1) {
    const calculated = await calculate();
    try {
      return await persist(calculated);
    } catch (error) {
      if (
        attempt === 0 &&
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_RECONCILIATION_STALE"
      ) {
        continue;
      }
      throw error;
    }
  }
  throw new RavenDomainError(
    "STATEMENT_RECONCILIATION_STALE",
    "Reconciliation authority changed during the bounded retry",
  );
}

export function statementComponentFinancialDate(
  component: StatementRowComponentRecord,
): string | null {
  return (
    component.transactionDate ?? component.postingDate ?? component.valueDate
  );
}

export function assertStatementComponentBundle(
  components: readonly StatementRowComponentRecord[],
): Readonly<{ sourceRowId: string; canonicalFinancialDate: string }> {
  const sourceRows = new Set(
    components.map((component) => component.statementRowId),
  );
  const financialDates = new Set(
    components.map(statementComponentFinancialDate).filter(Boolean),
  );
  if (
    components.length === 0 ||
    sourceRows.size !== 1 ||
    financialDates.size !== 1 ||
    components.some((component) => !statementComponentFinancialDate(component))
  ) {
    throw new RavenDomainError(
      "STATEMENT_COMPONENT_GROUP_INVALID",
      "Statement component groups must belong to one source row and one canonical financial date",
    );
  }
  return {
    sourceRowId: components[0]!.statementRowId,
    canonicalFinancialDate: [...financialDates][0]!,
  };
}

export function statementMatchAcceptedDates(
  components: readonly StatementRowComponentRecord[],
  dateWindowDays = STATEMENT_MATCH_DATE_WINDOW_DAYS,
): string[] {
  const accepted = new Set<string>();
  for (const component of components) {
    const financialDate = statementComponentFinancialDate(component);
    if (!financialDate) continue;
    const timestamp = Date.parse(`${financialDate}T00:00:00.000Z`);
    if (!Number.isFinite(timestamp)) continue;
    for (let offset = -dateWindowDays; offset <= dateWindowDays; offset += 1) {
      accepted.add(
        new Date(timestamp + offset * DAY_MS).toISOString().slice(0, 10),
      );
    }
  }
  return [...accepted].sort();
}

function normalizedEvidence(value: string): string {
  return value
    .normalize("NFKC")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim();
}

function dateDistance(left: string, right: string): number {
  const leftTime = Date.parse(`${left}T00:00:00.000Z`);
  const rightTime = Date.parse(`${right}T00:00:00.000Z`);
  if (!Number.isFinite(leftTime) || !Number.isFinite(rightTime)) {
    return Number.POSITIVE_INFINITY;
  }
  return Math.abs(Math.round((leftTime - rightTime) / DAY_MS));
}

function signedComponentTotal(
  components: readonly StatementRowComponentRecord[],
): number {
  return components.reduce(
    (total, component) =>
      statementCheckedAdd(
        total,
        component.balanceEffectMinor,
        "Statement component total",
      ),
    0,
  );
}

function sourceFlowForTotal(total: number): "inflow" | "outflow" | null {
  if (total > 0) return "inflow";
  if (total < 0) return "outflow";
  return null;
}

function transactionEligible(
  transaction: TransactionRecord,
  componentIds: readonly string[],
): boolean {
  return (
    transaction.amountMinor !== null &&
    transaction.amountMinor > 0 &&
    transaction.postedAt !== null &&
    transaction.flowDirection !== null &&
    transaction.kind !== "unresolved" &&
    transaction.status !== "ignored" &&
    (transaction.entrySource === "manual" ||
      transaction.entrySource === "generated") &&
    !transaction.sourceRowId &&
    !transaction.statementMatchId &&
    !transaction.hasActiveStatementClaim &&
    !transaction.transferId &&
    componentIds.length > 0
  );
}

function candidateMethod(input: {
  exactReference: boolean;
  exactDescription: boolean;
  distance: number;
  grouped: boolean;
  explicit: boolean;
}): {
  method: StatementMatchMethod;
  reasonCodes: StatementMatchReasonCode[];
  confidence: number;
} {
  if (input.explicit) {
    return {
      method: "explicit",
      reasonCodes: ["EXPLICIT_OPERATOR_SELECTION"],
      confidence: 1,
    };
  }
  if (input.grouped) {
    return {
      method: "grouped_exact",
      reasonCodes: ["EXACT_COMPONENT_GROUP_TOTAL"],
      confidence: 0.94,
    };
  }
  if (input.exactReference && input.distance === 0) {
    return {
      method: "exact_reference",
      reasonCodes: ["EXACT_SOURCE_REFERENCE", "EXACT_FINANCIAL_DATE"],
      confidence: 0.99,
    };
  }
  if (input.exactDescription && input.distance === 0) {
    return {
      method: "exact_description",
      reasonCodes: ["EXACT_NORMALIZED_DESCRIPTION", "EXACT_FINANCIAL_DATE"],
      confidence: 0.97,
    };
  }
  if (input.distance === 0) {
    return {
      method: "exact_date",
      reasonCodes: ["EXACT_FINANCIAL_DATE"],
      confidence: 0.9,
    };
  }
  return {
    method: "bounded_date",
    reasonCodes: ["BOUNDED_FINANCIAL_DATE"],
    confidence: Math.max(0.6, 0.86 - input.distance * 0.08),
  };
}

export function generateStatementMatchCandidates(input: {
  components: readonly StatementRowComponentRecord[];
  transactions: readonly TransactionRecord[];
  matches?: readonly StatementTransactionMatchRecord[];
  explicitTransactionId?: string;
  dateWindowDays?: number;
}): StatementTransactionCandidate[] {
  const components = [...input.components].sort((a, b) =>
    a.id.localeCompare(b.id),
  );
  if (components.length === 0) return [];
  assertStatementComponentBundle(components);
  if (
    components.some(
      (component) =>
        component.componentRole !== "movement" ||
        component.sourceState !== "committed",
    )
  ) {
    return [];
  }
  const accountId = components[0]!.accountId;
  const currency = components[0]!.currency;
  if (
    components.some(
      (component) =>
        component.accountId !== accountId || component.currency !== currency,
    )
  ) {
    return [];
  }
  const total = signedComponentTotal(components);
  const flow = sourceFlowForTotal(total);
  if (!flow) return [];
  const amountMinor = Math.abs(total);
  const componentIds = components.map((component) => component.id);
  const dates = components
    .map(statementComponentFinancialDate)
    .filter((value): value is string => value !== null);
  const sourceReferences = new Set(
    components
      .map((component) => normalizedEvidence(component.sourceReference ?? ""))
      .filter(Boolean),
  );
  const descriptions = new Set(
    components.map((component) => normalizedEvidence(component.description)),
  );
  const dateWindow = input.dateWindowDays ?? STATEMENT_MATCH_DATE_WINDOW_DAYS;
  const candidates: StatementTransactionCandidate[] = [];

  for (const transaction of input.transactions) {
    if (
      transaction.currency !== currency ||
      transaction.amountMinor !== amountMinor ||
      !transaction.postedAt
    ) {
      continue;
    }
    const distance = dates.length
      ? Math.min(
          ...dates.map((date) => dateDistance(date, transaction.postedAt!)),
        )
      : Number.POSITIVE_INFINITY;
    const activeReplay = input.matches?.find(
      (match) =>
        match.transactionId === transaction.id &&
        match.state === "confirmed" &&
        match.sourceState === "committed" &&
        match.componentIds.length === componentIds.length &&
        match.componentIds.every((id) => componentIds.includes(id)),
    );
    if (
      activeReplay &&
      transaction.accountId === accountId &&
      transaction.flowDirection === flow &&
      distance <= dateWindow
    ) {
      candidates.push({
        transactionId: transaction.id,
        account: {
          spaceKey: transaction.spaceKey,
          accountKey: transaction.accountKey,
        },
        financialDate: transaction.postedAt,
        description: transaction.description,
        amountMinor,
        currency,
        kind: transaction.kind,
        flowDirection: transaction.flowDirection,
        evidenceState: "statement_backed",
        method: "exact_reference",
        reasonCodes: ["ACTIVE_CONFIRMED_SOURCE_LINK"],
        confidence: 1,
        dateDistanceDays: distance,
        transferCandidate: false,
        componentIds,
        signedComponentTotalMinor: total,
      });
      continue;
    }
    if (!transactionEligible(transaction, componentIds)) continue;
    const counterpart = transaction.accountId !== accountId;
    if (counterpart) {
      if (
        distance > dateWindow ||
        transaction.flowDirection === flow ||
        transaction.transferId
      ) {
        continue;
      }
      candidates.push({
        transactionId: transaction.id,
        account: {
          spaceKey: transaction.spaceKey,
          accountKey: transaction.accountKey,
        },
        financialDate: transaction.postedAt,
        description: transaction.description,
        amountMinor,
        currency,
        kind: transaction.kind,
        flowDirection: transaction.flowDirection,
        evidenceState: transaction.statementMatchId
          ? "statement_backed"
          : "provisional",
        method: "transfer_candidate",
        reasonCodes: ["OPPOSITE_ACCOUNT_EFFECT"],
        confidence: 0.55,
        dateDistanceDays: distance,
        transferCandidate: true,
        componentIds,
        signedComponentTotalMinor: total,
      });
      continue;
    }
    if (transaction.flowDirection !== flow || distance > dateWindow) continue;
    const explicit = transaction.id === input.explicitTransactionId;
    const normalizedDescription = normalizedEvidence(transaction.description);
    const exactReference = sourceReferences.has(normalizedDescription);
    const exactDescription = descriptions.has(normalizedDescription);
    const ranked = candidateMethod({
      exactReference,
      exactDescription,
      distance,
      grouped: components.length > 1,
      explicit,
    });
    candidates.push({
      transactionId: transaction.id,
      account: {
        spaceKey: transaction.spaceKey,
        accountKey: transaction.accountKey,
      },
      financialDate: transaction.postedAt,
      description: transaction.description,
      amountMinor,
      currency,
      kind: transaction.kind,
      flowDirection: transaction.flowDirection,
      evidenceState: transaction.statementMatchId
        ? "statement_backed"
        : "provisional",
      method: ranked.method,
      reasonCodes: ranked.reasonCodes,
      confidence: ranked.confidence,
      dateDistanceDays: distance,
      transferCandidate: false,
      componentIds,
      signedComponentTotalMinor: total,
    });
  }
  return candidates.sort(
    (left, right) =>
      Number(left.transferCandidate) - Number(right.transferCandidate) ||
      right.confidence - left.confidence ||
      left.dateDistanceDays - right.dateDistanceDays ||
      left.transactionId.localeCompare(right.transactionId),
  );
}

export function deriveStatementComponentResolutions(input: {
  components: readonly StatementRowComponentRecord[];
  matches: readonly StatementTransactionMatchRecord[];
}): StatementComponentResolution[] {
  return [...input.components]
    .sort((a, b) => a.id.localeCompare(b.id))
    .map((component) => {
      const matches = input.matches
        .filter((match) => match.componentIds.includes(component.id))
        .sort((a, b) => b.revision - a.revision || b.id.localeCompare(a.id));
      const active = matches.find(
        (match) =>
          match.state === "confirmed" && match.sourceState === "committed",
      );
      const proposals = matches.filter((match) => match.state === "proposed");
      const rejected = matches.some((match) => match.state === "rejected");
      const conflict =
        matches.filter(
          (match) =>
            match.state === "confirmed" && match.sourceState === "committed",
        ).length > 1;
      const disposition =
        component.sourceState === "superseded"
          ? "superseded_source"
          : component.componentRole === "informational_breakdown"
            ? "informational"
            : conflict
              ? "conflict"
              : active?.method === "created_from_component"
                ? "materialized_imported"
                : active
                  ? "matched_existing"
                  : proposals.length > 0
                    ? "proposed"
                    : rejected
                      ? "rejected_proposal_present"
                      : "pending";
      return {
        component,
        disposition,
        activeMatch: active ?? null,
        proposals,
      } satisfies StatementComponentResolution;
    });
}

export function calculateStatementReconciliation(input: {
  statementImport: StatementImportRecord;
  rows: readonly StatementRowRecord[];
  components: readonly StatementRowComponentRecord[];
  issues: readonly StatementIssueRecord[];
  matches: readonly StatementTransactionMatchRecord[];
  previous: StatementReconciliationRecord | null;
  operationId: string;
  calculatedAt: string;
  transferCandidateComponentIds?: readonly string[];
}): Omit<StatementReconciliationRecord, "id"> {
  const resolutions = deriveStatementComponentResolutions({
    components: input.components,
    matches: input.matches,
  });
  const activeComponents = input.components.filter(
    (component) => component.sourceState === "committed",
  );
  const movements = activeComponents.filter(
    (component) => component.componentRole === "movement",
  );
  const signedMovementEffectMinor = movements.reduce(
    (total, component) =>
      statementCheckedAdd(
        total,
        component.balanceEffectMinor,
        "Statement reconciliation movement total",
      ),
    0,
  );
  const expectedClosingBalanceMinor =
    input.statementImport.openingBalanceMinor === null
      ? null
      : statementCheckedAdd(
          input.statementImport.openingBalanceMinor,
          signedMovementEffectMinor,
          "Statement reconciliation expected closing balance",
        );
  const differenceMinor =
    expectedClosingBalanceMinor === null ||
    input.statementImport.closingBalanceMinor === null
      ? null
      : statementCheckedAdd(
          input.statementImport.closingBalanceMinor,
          -expectedClosingBalanceMinor,
          "Statement reconciliation difference",
        );
  const pending = resolutions.filter((item) => item.disposition === "pending");
  const proposed = resolutions.filter(
    (item) => item.disposition === "proposed",
  );
  const confirmed = resolutions.filter(
    (item) => item.disposition === "matched_existing",
  );
  const materialized = resolutions.filter(
    (item) => item.disposition === "materialized_imported",
  );
  const conflicts = resolutions.filter(
    (item) => item.disposition === "conflict",
  );
  const activeIssues = input.issues.filter(
    (issue) => issue.state === "open" || issue.state === "acknowledged",
  );
  const blockingIssues = activeIssues.filter((issue) => issue.blocking);
  const coverageComplete =
    input.statementImport.sourceState === "committed" &&
    input.statementImport.coverage?.status === "complete" &&
    input.statementImport.rowCount === input.rows.length &&
    input.statementImport.componentCount === activeComponents.length &&
    (input.statementImport.coverage.printedRowCount === null ||
      input.statementImport.coverage.printedRowCount === input.rows.length);
  const resolvedMovementCount = confirmed.length + materialized.length;
  const unresolvedCount = Math.max(0, movements.length - resolvedMovementCount);
  const counts = {
    printedRowCount: input.statementImport.coverage?.printedRowCount ?? 0,
    extractedRowCount: input.rows.length,
    movementComponentCount: movements.length,
    informationalComponentCount: activeComponents.length - movements.length,
    pendingCount: pending.length,
    proposedCount: proposed.length,
    confirmedExistingCount: confirmed.length,
    newlyMaterializedCount: materialized.length,
    unresolvedCount,
    transferCandidateCount: new Set(input.transferCandidateComponentIds ?? [])
      .size,
    activeIssueCount: activeIssues.length,
    blockingIssueCount: blockingIssues.length,
  };
  const calculationState =
    differenceMinor === null
      ? "unavailable"
      : differenceMinor === 0
        ? "balanced"
        : "difference";
  const ready =
    coverageComplete &&
    movements.length === resolvedMovementCount &&
    unresolvedCount === 0 &&
    conflicts.length === 0 &&
    blockingIssues.length === 0 &&
    calculationState === "balanced";
  const authority = {
    statementImport: {
      id: input.statementImport.id,
      revision: input.statementImport.revision,
      sourceState: input.statementImport.sourceState,
      originalFileSha256: input.statementImport.originalFileSha256,
      canonicalExtractionSha256:
        input.statementImport.canonicalExtractionSha256,
      previewHash: input.statementImport.previewHash,
      accountContextFingerprint:
        input.statementImport.accountContextFingerprint,
      periodStart: input.statementImport.periodStart,
      periodEnd: input.statementImport.periodEnd,
      currency: input.statementImport.currency,
    },
    components: movements.map((component) => ({
      id: component.id,
      sourceChecksum: component.sourceChecksum,
      balanceEffectMinor: component.balanceEffectMinor,
      sourceState: component.sourceState,
    })),
    matches: input.matches
      .filter(
        (match) =>
          match.state === "confirmed" && match.sourceState === "committed",
      )
      .map((match) => ({
        id: match.id,
        revision: match.revision,
        componentIds: match.componentIds,
        transactionId: match.transactionId,
        signedComponentTotalMinor: match.signedComponentTotalMinor,
      })),
    issues: input.issues.map((issue) => ({
      id: issue.id,
      revision: issue.revision,
      state: issue.state,
      blocking: issue.blocking,
    })),
    equation: {
      openingBalanceMinor: input.statementImport.openingBalanceMinor,
      signedMovementEffectMinor,
      expectedClosingBalanceMinor,
      reportedClosingBalanceMinor: input.statementImport.closingBalanceMinor,
      differenceMinor,
    },
    counts,
  };
  const calculationHash = statementSha256(canonicalStatementJson(authority));
  const previousState = input.previous?.attestationState;
  const sameAttestedCalculation =
    previousState === "reconciled" &&
    input.previous?.calculationHash === calculationHash;
  return {
    key: "current",
    spaceId: input.statementImport.spaceId,
    accountId: input.statementImport.accountId,
    statementImportId: input.statementImport.id,
    periodStart: input.statementImport.periodStart,
    periodEnd: input.statementImport.periodEnd,
    currency: input.statementImport.currency,
    openingBalanceMinor: input.statementImport.openingBalanceMinor,
    signedMovementEffectMinor,
    expectedClosingBalanceMinor,
    reportedClosingBalanceMinor: input.statementImport.closingBalanceMinor,
    differenceMinor,
    counts,
    calculationState,
    coverageState: coverageComplete ? "complete" : "incomplete",
    attestationState: sameAttestedCalculation
      ? "reconciled"
      : previousState === "reconciled"
        ? "reopened"
        : ready
          ? "ready"
          : previousState === "reopened"
            ? "reopened"
            : "open",
    calculationHash,
    revision: (input.previous?.revision ?? 0) + 1,
    calculatedAt: input.calculatedAt,
    calculationOperationId: input.operationId,
    latestAttestationOperationId:
      input.previous?.latestAttestationOperationId ?? null,
    latestReopeningOperationId:
      input.previous?.latestReopeningOperationId ?? null,
    attestedAt: input.previous?.attestedAt ?? null,
    reopenedAt:
      previousState === "reconciled" && !sameAttestedCalculation
        ? input.calculatedAt
        : (input.previous?.reopenedAt ?? null),
    provenance: {
      contractVersion: "statement-truth-v0.1",
      sourceRevision: input.statementImport.revision,
      componentIds: movements.map((component) => component.id),
      activeMatchIds: input.matches
        .filter(
          (match) =>
            match.state === "confirmed" && match.sourceState === "committed",
        )
        .map((match) => match.id),
      activeIssueIds: activeIssues.map((issue) => issue.id),
    },
  };
}
