import { RavenDomainError } from "@raven/domain";
import type {
  FinancialOperationRecord,
  RavenErrorCode,
  StatementAttestationDraft,
  StatementConfirmationDraft,
  StatementIssueAcknowledgementDraft,
  StatementIssueRepositoryResult,
  StatementImportRecord,
  StatementImportSupersessionDraft,
  StatementSupersessionRepositoryResult,
  StatementMatchMutationDraft,
  StatementMatchReadFilter,
  StatementMatchRepositoryResult,
  StatementMatchSupersessionDraft,
  StatementMaterializationDraft,
  StatementMaterializationRepositoryResult,
  StatementReconciliationEventRecord,
  StatementReconciliationMutationDraft,
  StatementReconciliationRecord,
  StatementReconciliationRepositoryResult,
  StatementRejectionDraft,
  StatementReopeningDraft,
  StatementResolutionCommand,
  StatementResolutionOperation,
  StatementResolutionRepository,
  StatementTransactionMatchRecord,
  TransactionRecord,
} from "@raven/domain/server";
import { normalizeTransaction, type SurrealQueryClient } from "./repository.js";

type Raw = Record<string, unknown>;
type Statement = {
  status?: string;
  success?: boolean;
  result?: unknown;
  detail?: string;
  error?: unknown;
};

function statementError(statement: Statement): string {
  return (
    statement.detail ||
    (typeof statement.error === "string"
      ? statement.error
      : JSON.stringify(statement.error ?? "")) ||
    (typeof statement.result === "string"
      ? statement.result
      : JSON.stringify(statement.result ?? "")) ||
    ""
  );
}

function unwrap(response: unknown): unknown[] {
  if (!Array.isArray(response)) return response == null ? [] : [response];
  const failed = response.filter((item): item is Statement =>
    Boolean(
      item &&
      typeof item === "object" &&
      (("status" in item && (item as Statement).status !== "OK") ||
        ("success" in item && (item as Statement).success === false)),
    ),
  );
  if (failed.length > 0) {
    throw new Error(
      failed.map(statementError).filter(Boolean).join("\n") ||
        "Statement resolution persistence failed",
    );
  }
  return response.map((item) =>
    item && typeof item === "object" && "result" in item
      ? (item as Statement).result
      : item,
  );
}

async function queryWithResponses(
  client: SurrealQueryClient,
  query: string,
  vars?: Record<string, unknown>,
): Promise<unknown> {
  const pending = client.query(query, vars) as Promise<unknown> & {
    responses?: () => Promise<unknown>;
  };
  return typeof pending.responses === "function"
    ? pending.responses()
    : pending;
}

function rows<T>(response: unknown): T[] {
  const values = unwrap(response);
  for (let index = values.length - 1; index >= 0; index -= 1) {
    const value = values[index];
    if (Array.isArray(value)) return value as T[];
    if (value && typeof value === "object") return [value as T];
  }
  return [];
}

function transactionResult<T extends object>(
  response: unknown,
  key: keyof T,
): T {
  for (const value of unwrap(response).reverse()) {
    for (const candidate of Array.isArray(value) ? value : [value]) {
      if (candidate && typeof candidate === "object" && key in candidate) {
        return candidate as T;
      }
    }
  }
  throw new RavenDomainError(
    "INTERNAL",
    "Statement resolution transaction result was missing",
  );
}

function recordId(value: unknown): string {
  if (typeof value === "string") {
    return value
      .replace(/^([^:]+):`([\s\S]*)`$/, "$1:$2")
      .replace(/^([^:]+):⟨([\s\S]*)⟩$/, "$1:$2");
  }
  if (!value || typeof value !== "object") return String(value ?? "");
  const input = value as Raw;
  const table = input.tb ?? input.table;
  const tableName =
    typeof table === "string"
      ? table
      : (table as { name?: string } | undefined)?.name;
  const key = String(input.id ?? "")
    .replace(/^`([\s\S]*)`$/, "$1")
    .replace(/^⟨([\s\S]*)⟩$/, "$1");
  return tableName ? `${tableName}:${key}` : key;
}

function recordKey(value: string): string {
  return recordId(value).split(":").slice(1).join(":");
}

function nullableString(value: unknown): string | null {
  return value === null ||
    value === undefined ||
    value === "" ||
    value === "NONE"
    ? null
    : String(value);
}

export function normalizeStatementResolutionOperation(
  raw: Raw,
): StatementResolutionOperation {
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? ""),
    command: raw.command as StatementResolutionCommand,
    idempotencyKey: String(raw.idempotencyKey ?? ""),
    requestHash: String(raw.requestHash ?? ""),
    channel: raw.channel as FinancialOperationRecord["channel"],
    actorId: nullableString(raw.actorId),
    status: raw.status as FinancialOperationRecord["status"],
    resultRefs: Array.isArray(raw.resultRefs)
      ? raw.resultRefs.map(recordId)
      : [],
    warningCodes: Array.isArray(raw.warningCodes)
      ? (raw.warningCodes.map(
          String,
        ) as FinancialOperationRecord["warningCodes"])
      : [],
    auditMeta:
      raw.auditMeta && typeof raw.auditMeta === "object"
        ? (raw.auditMeta as Record<string, unknown>)
        : {},
    recordedAt: String(raw.recordedAt ?? ""),
    completedAt: nullableString(raw.completedAt),
    failureCode: nullableString(raw.failureCode),
  };
}

export function normalizeStatementTransactionMatch(
  raw: Raw,
): StatementTransactionMatchRecord {
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? ""),
    spaceId: recordId(raw.space),
    accountId: recordId(raw.account),
    statementImportId: recordId(raw.statementImport),
    primaryComponentId: recordId(raw.primaryComponent),
    componentIds: Array.isArray(raw.componentIds)
      ? raw.componentIds.map(recordId)
      : [],
    transactionId: recordId(raw.transaction),
    state: raw.state as StatementTransactionMatchRecord["state"],
    method: raw.method as StatementTransactionMatchRecord["method"],
    reasonCodes: Array.isArray(raw.reasonCodes)
      ? (raw.reasonCodes.map(
          String,
        ) as StatementTransactionMatchRecord["reasonCodes"])
      : [],
    confidence: Number(raw.confidence ?? 0),
    signedComponentTotalMinor: Number(raw.signedComponentTotalMinor ?? 0),
    currency: String(raw.currency ?? "ZAR"),
    revision: Number(raw.revision ?? 1),
    proposedOperationId: recordId(raw.proposedOperation),
    confirmedOperationId: raw.confirmedOperation
      ? recordId(raw.confirmedOperation)
      : null,
    rejectedOperationId: raw.rejectedOperation
      ? recordId(raw.rejectedOperation)
      : null,
    supersededOperationId: raw.supersededOperation
      ? recordId(raw.supersededOperation)
      : null,
    proposedBy: nullableString(raw.proposedBy),
    reviewedBy: nullableString(raw.reviewedBy),
    proposedAt: String(raw.proposedAt ?? ""),
    confirmedAt: nullableString(raw.confirmedAt),
    rejectedAt: nullableString(raw.rejectedAt),
    supersededAt: nullableString(raw.supersededAt),
    rejectionReason: nullableString(raw.rejectionReason),
    supersessionReason: nullableString(raw.supersessionReason),
    supersedesId: raw.supersedes ? recordId(raw.supersedes) : null,
    supersededById: raw.supersededBy ? recordId(raw.supersededBy) : null,
    sourceState: raw.sourceState === "superseded" ? "superseded" : "committed",
  };
}

export function normalizeStatementReconciliation(
  raw: Raw,
): StatementReconciliationRecord {
  const counts =
    raw.counts && typeof raw.counts === "object" ? (raw.counts as Raw) : raw;
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? "current"),
    spaceId: recordId(raw.space),
    accountId: recordId(raw.account),
    statementImportId: recordId(raw.statementImport),
    periodStart: String(raw.periodStart ?? ""),
    periodEnd: String(raw.periodEnd ?? ""),
    currency: String(raw.currency ?? "ZAR"),
    openingBalanceMinor: Number.isSafeInteger(raw.openingBalanceMinor)
      ? Number(raw.openingBalanceMinor)
      : null,
    signedMovementEffectMinor: Number(raw.signedMovementEffectMinor ?? 0),
    expectedClosingBalanceMinor: Number.isSafeInteger(
      raw.expectedClosingBalanceMinor,
    )
      ? Number(raw.expectedClosingBalanceMinor)
      : null,
    reportedClosingBalanceMinor: Number.isSafeInteger(
      raw.reportedClosingBalanceMinor,
    )
      ? Number(raw.reportedClosingBalanceMinor)
      : null,
    differenceMinor: Number.isSafeInteger(raw.differenceMinor)
      ? Number(raw.differenceMinor)
      : null,
    counts: {
      printedRowCount: Number(counts.printedRowCount ?? 0),
      extractedRowCount: Number(counts.extractedRowCount ?? 0),
      movementComponentCount: Number(counts.movementComponentCount ?? 0),
      informationalComponentCount: Number(
        counts.informationalComponentCount ?? 0,
      ),
      pendingCount: Number(counts.pendingCount ?? 0),
      proposedCount: Number(counts.proposedCount ?? 0),
      confirmedExistingCount: Number(counts.confirmedExistingCount ?? 0),
      newlyMaterializedCount: Number(counts.newlyMaterializedCount ?? 0),
      unresolvedCount: Number(counts.unresolvedCount ?? 0),
      transferCandidateCount: Number(counts.transferCandidateCount ?? 0),
      activeIssueCount: Number(counts.activeIssueCount ?? 0),
      blockingIssueCount: Number(counts.blockingIssueCount ?? 0),
    },
    calculationState:
      raw.calculationState as StatementReconciliationRecord["calculationState"],
    coverageState:
      raw.coverageState as StatementReconciliationRecord["coverageState"],
    attestationState:
      raw.attestationState as StatementReconciliationRecord["attestationState"],
    calculationHash: String(raw.calculationHash ?? ""),
    revision: Number(raw.revision ?? 1),
    calculatedAt: String(raw.calculatedAt ?? ""),
    calculationOperationId: recordId(raw.calculationOperation),
    latestAttestationOperationId: raw.latestAttestationOperation
      ? recordId(raw.latestAttestationOperation)
      : null,
    latestReopeningOperationId: raw.latestReopeningOperation
      ? recordId(raw.latestReopeningOperation)
      : null,
    attestedAt: nullableString(raw.attestedAt),
    reopenedAt: nullableString(raw.reopenedAt),
    provenance:
      raw.provenance && typeof raw.provenance === "object"
        ? (raw.provenance as Record<string, unknown>)
        : {},
  };
}

function normalizeEvent(raw: Raw): StatementReconciliationEventRecord {
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? ""),
    spaceId: recordId(raw.space),
    accountId: recordId(raw.account),
    statementImportId: recordId(raw.statementImport),
    statementReconciliationId: recordId(raw.statementReconciliation),
    eventType: raw.eventType as StatementReconciliationEventRecord["eventType"],
    reconciliationRevision: Number(raw.reconciliationRevision ?? 1),
    calculationHash: String(raw.calculationHash ?? ""),
    calculationSnapshot:
      raw.calculationSnapshot && typeof raw.calculationSnapshot === "object"
        ? (raw.calculationSnapshot as Record<string, unknown>)
        : {},
    reason: nullableString(raw.reason),
    actorId: nullableString(raw.actorId),
    channel: raw.channel as StatementReconciliationEventRecord["channel"],
    operationId: recordId(raw.operation),
    recordedAt: String(raw.recordedAt ?? ""),
  };
}

function operationVars(operation: StatementMatchMutationDraft["operation"]) {
  return {
    ...operation,
    actorId: operation.actorId ?? "",
    hasActorId: Boolean(operation.actorId),
    warningCodes: operation.warningCodes ?? [],
    auditMeta: operation.auditMeta ?? {},
  };
}

function reconciliationVars(
  value:
    | StatementReconciliationRecord
    | Omit<StatementReconciliationRecord, "id">
    | null,
) {
  if (!value) return null;
  return {
    ...value,
    openingBalanceMinor: value.openingBalanceMinor ?? 0,
    hasOpeningBalance: value.openingBalanceMinor !== null,
    expectedClosingBalanceMinor: value.expectedClosingBalanceMinor ?? 0,
    hasExpectedClosingBalance: value.expectedClosingBalanceMinor !== null,
    reportedClosingBalanceMinor: value.reportedClosingBalanceMinor ?? 0,
    hasReportedClosingBalance: value.reportedClosingBalanceMinor !== null,
    differenceMinor: value.differenceMinor ?? 0,
    hasDifference: value.differenceMinor !== null,
    latestAttestationOperationId: value.latestAttestationOperationId
      ? recordKey(value.latestAttestationOperationId)
      : "",
    hasLatestAttestationOperation: Boolean(value.latestAttestationOperationId),
    latestReopeningOperationId: value.latestReopeningOperationId
      ? recordKey(value.latestReopeningOperationId)
      : "",
    hasLatestReopeningOperation: Boolean(value.latestReopeningOperationId),
    attestedAt: value.attestedAt ?? "",
    hasAttestedAt: Boolean(value.attestedAt),
    reopenedAt: value.reopenedAt ?? "",
    hasReopenedAt: Boolean(value.reopenedAt),
  };
}

const CREATE_OPERATION = `
  LET $operationId = type::record("financialOperation", $operation.key);
  LET $operationRecord = CREATE ONLY $operationId CONTENT {
    key: $operation.key,
    command: $operation.command,
    idempotencyKey: $operation.idempotencyKey,
    requestHash: $operation.requestHash,
    channel: $operation.channel,
    actorId: IF $operation.hasActorId THEN $operation.actorId ELSE NONE END,
    status: "applied",
    resultRefs: $resultRefs,
    warningCodes: $operation.warningCodes,
    auditMeta: $operation.auditMeta,
    recordedAt: $operation.recordedAt,
    completedAt: $operation.recordedAt,
    failureCode: ""
  };
`;

const UPSERT_RECONCILIATION = `
  LET $reconciliationImport = SELECT * FROM ONLY $statementImportId;
  IF !$reconciliationImport OR $reconciliationImport.sourceState != "committed" {
    THROW "STATEMENT_IMPORT_SUPERSEDED";
  };
  LET $reconciliationId = type::record(
    "statementReconciliation",
    fn::stringID([$statementImportId, "current"])
  );
  LET $previousReconciliation = SELECT * FROM ONLY $reconciliationId;
  IF ($hasExpectedReconciliation
      AND (!$previousReconciliation
        OR $previousReconciliation.revision != <int> $expectedReconciliationRevision
        OR $previousReconciliation.calculationHash != $expectedReconciliationHash))
    OR (!$hasExpectedReconciliation AND $previousReconciliation) {
    THROW "STATEMENT_RECONCILIATION_STALE";
  };
  LET $autoReopening = $previousReconciliation.attestationState = "reconciled"
    AND $reconciliation.attestationState = "reopened";
  LET $reconciliationRecord = UPSERT ONLY $reconciliationId CONTENT {
    space: type::record("financialSpace", $reconciliation.spaceKey),
    account: type::record("account", $reconciliation.accountKey),
    statementImport: $statementImportId,
    key: "current",
    periodStart: $reconciliation.periodStart,
    periodEnd: $reconciliation.periodEnd,
    currency: $reconciliation.currency,
    openingBalanceMinor: IF $reconciliation.hasOpeningBalance THEN <int> $reconciliation.openingBalanceMinor ELSE NONE END,
    signedMovementEffectMinor: <int> $reconciliation.signedMovementEffectMinor,
    expectedClosingBalanceMinor: IF $reconciliation.hasExpectedClosingBalance THEN <int> $reconciliation.expectedClosingBalanceMinor ELSE NONE END,
    reportedClosingBalanceMinor: IF $reconciliation.hasReportedClosingBalance THEN <int> $reconciliation.reportedClosingBalanceMinor ELSE NONE END,
    differenceMinor: IF $reconciliation.hasDifference THEN <int> $reconciliation.differenceMinor ELSE NONE END,
    printedRowCount: <int> $reconciliation.counts.printedRowCount,
    extractedRowCount: <int> $reconciliation.counts.extractedRowCount,
    movementComponentCount: <int> $reconciliation.counts.movementComponentCount,
    informationalComponentCount: <int> $reconciliation.counts.informationalComponentCount,
    pendingCount: <int> $reconciliation.counts.pendingCount,
    proposedCount: <int> $reconciliation.counts.proposedCount,
    confirmedExistingCount: <int> $reconciliation.counts.confirmedExistingCount,
    newlyMaterializedCount: <int> $reconciliation.counts.newlyMaterializedCount,
    unresolvedCount: <int> $reconciliation.counts.unresolvedCount,
    transferCandidateCount: <int> $reconciliation.counts.transferCandidateCount,
    activeIssueCount: <int> $reconciliation.counts.activeIssueCount,
    blockingIssueCount: <int> $reconciliation.counts.blockingIssueCount,
    calculationState: $reconciliation.calculationState,
    coverageState: $reconciliation.coverageState,
    attestationState: $reconciliation.attestationState,
    calculationHash: $reconciliation.calculationHash,
    revision: <int> $reconciliation.revision,
    calculatedAt: $reconciliation.calculatedAt,
    calculationOperation: $operationId,
    latestAttestationOperation: IF $reconciliation.hasLatestAttestationOperation
      THEN type::record("financialOperation", $reconciliation.latestAttestationOperationId)
      ELSE NONE END,
    latestReopeningOperation: IF $autoReopening THEN $operationId
      ELSE (IF $reconciliation.hasLatestReopeningOperation
        THEN type::record("financialOperation", $reconciliation.latestReopeningOperationId)
        ELSE NONE END) END,
    attestedAt: IF $reconciliation.hasAttestedAt THEN $reconciliation.attestedAt ELSE NONE END,
    reopenedAt: IF $autoReopening THEN $operation.recordedAt
      ELSE (IF $reconciliation.hasReopenedAt THEN $reconciliation.reopenedAt ELSE NONE END) END,
    provenance: $reconciliation.provenance
  };
  LET $automaticReopeningEvent = IF $autoReopening {
    LET $eventKey = string::concat("automatic-", $operation.key);
    LET $eventId = type::record(
      "statementReconciliationEvent",
      fn::stringID([$reconciliationId, $eventKey])
    );
    CREATE ONLY $eventId CONTENT {
      space: type::record("financialSpace", $reconciliation.spaceKey),
      account: type::record("account", $reconciliation.accountKey),
      statementImport: $statementImportId,
      statementReconciliation: $reconciliationId,
      key: $eventKey,
      eventType: "reopened",
      reconciliationRevision: <int> $reconciliation.revision,
      calculationHash: $reconciliation.calculationHash,
      calculationSnapshot: $previousReconciliation,
      reason: "Resolution authority changed after attestation",
      actorId: IF $operation.hasActorId THEN $operation.actorId ELSE NONE END,
      channel: $operation.channel,
      operation: $operationId,
      recordedAt: $operation.recordedAt
    }
  } ELSE { NONE };
`;

function matchVars(match: StatementMatchMutationDraft["match"]) {
  return {
    ...match,
    spaceKey: recordKey(match.spaceId),
    accountKey: recordKey(match.accountId),
    statementImportKey: recordKey(match.statementImportId),
    componentKeys: match.componentIds.map(recordKey),
    transactionKey: recordKey(match.transactionId),
    supersedesKey: match.supersedesId ? recordKey(match.supersedesId) : "",
    hasSupersedes: Boolean(match.supersedesId),
    proposedBy: match.proposedBy ?? "",
    hasProposedBy: Boolean(match.proposedBy),
  };
}

function validationVars(validation: StatementMatchMutationDraft["validation"]) {
  return {
    ...validation,
    componentKeys: validation.componentIds.map(recordKey),
    transactionKey: recordKey(validation.transactionId),
    accountKey: recordKey(validation.accountId),
    sourceRowKey: recordKey(validation.sourceRowId),
  };
}

function reconciliationExpectationVars(value: {
  expectedReconciliationRevision: number | null;
  expectedReconciliationHash: string | null;
}) {
  const hasExpectedReconciliation =
    value.expectedReconciliationRevision !== null &&
    value.expectedReconciliationHash !== null;
  return {
    hasExpectedReconciliation,
    expectedReconciliationRevision: value.expectedReconciliationRevision ?? 0,
    expectedReconciliationHash: value.expectedReconciliationHash ?? "",
  };
}

function reconciliationWithKeys(
  value: Parameters<typeof reconciliationVars>[0],
) {
  const normalized = reconciliationVars(value);
  if (!normalized || !value) return null;
  return {
    ...normalized,
    spaceKey: recordKey(value.spaceId),
    accountKey: recordKey(value.accountId),
  };
}

function rethrowResolutionError(error: unknown): never {
  const message = error instanceof Error ? error.message : String(error);
  const mappings: Array<[RegExp, RavenErrorCode]> = [
    [
      /STATEMENT_COMPONENT_ALREADY_DISPOSED/,
      "STATEMENT_COMPONENT_ALREADY_DISPOSED",
    ],
    [
      /STATEMENT_TRANSACTION_ALREADY_MATCHED/,
      "STATEMENT_TRANSACTION_ALREADY_MATCHED",
    ],
    [/STATEMENT_TRANSACTION_INELIGIBLE/, "STATEMENT_TRANSACTION_INELIGIBLE"],
    [/STATEMENT_COMPONENT_GROUP_INVALID/, "STATEMENT_COMPONENT_GROUP_INVALID"],
    [
      /STATEMENT_TRANSFER_REVIEW_REQUIRED/,
      "STATEMENT_TRANSFER_REVIEW_REQUIRED",
    ],
    [
      /STATEMENT_COMPONENT_TOTAL_MISMATCH/,
      "STATEMENT_COMPONENT_TOTAL_MISMATCH",
    ],
    [/STATEMENT_MATCH_CONFLICT/, "STATEMENT_MATCH_CONFLICT"],
    [/STATEMENT_RECONCILIATION_STALE/, "STATEMENT_RECONCILIATION_STALE"],
    [
      /STATEMENT_RECONCILIATION_INCOMPLETE/,
      "STATEMENT_RECONCILIATION_INCOMPLETE",
    ],
    [
      /STATEMENT_RECONCILIATION_DIFFERENCE/,
      "STATEMENT_RECONCILIATION_DIFFERENCE",
    ],
    [
      /STATEMENT_RECONCILIATION_ALREADY_ATTESTED/,
      "STATEMENT_RECONCILIATION_ALREADY_ATTESTED",
    ],
    [/STATEMENT_BLOCKING_ISSUE_ACTIVE/, "STATEMENT_BLOCKING_ISSUE_ACTIVE"],
    [/STATEMENT_IMPORT_SUPERSEDED/, "STATEMENT_IMPORT_SUPERSEDED"],
    [
      /STATEMENT_SOURCE_SUPERSESSION_CONFLICT/,
      "STATEMENT_SOURCE_SUPERSESSION_CONFLICT",
    ],
    [/STATEMENT_SOURCE_CLAIM_CONFLICT/, "STATEMENT_SOURCE_CLAIM_CONFLICT"],
    [/STATEMENT_PERIOD_CLAIM_CONFLICT/, "STATEMENT_PERIOD_CLAIM_CONFLICT"],
    [/STATEMENT_ACCOUNT_CONTEXT_STALE/, "STATEMENT_ACCOUNT_CONTEXT_STALE"],
    [
      /Transaction conflict: Write conflict, retry the transaction/i,
      "STATEMENT_RECONCILIATION_STALE",
    ],
    [
      /query was not executed due to a failed transaction/i,
      "STATEMENT_RECONCILIATION_STALE",
    ],
  ];
  for (const [pattern, code] of mappings) {
    if (pattern.test(message)) throw new RavenDomainError(code, message);
  }
  throw new RavenDomainError(
    "INTERNAL",
    message || "Statement resolution persistence failed",
  );
}

export class SurrealStatementResolutionRepository implements StatementResolutionRepository {
  constructor(private readonly client: SurrealQueryClient) {}

  async getStatementTransactionMatchIdentity(
    statementImportId: string,
    key: string,
  ): Promise<string> {
    const response = await this.client.query(
      `RETURN type::string(type::record("statementTransactionMatch", fn::stringID([
        type::record("statementImport", $statementImportKey), $key
      ])));`,
      { statementImportKey: recordKey(statementImportId), key },
    );
    return String(unwrap(response).flat(Infinity).find(Boolean) ?? "");
  }

  async getImportedTransactionIdentity(
    accountId: string,
    key: string,
  ): Promise<string> {
    const response = await this.client.query(
      `RETURN type::string(type::record("transaction", fn::stringID([
        type::record("account", $accountKey), $key
      ])));`,
      { accountKey: recordKey(accountId), key },
    );
    return String(unwrap(response).flat(Infinity).find(Boolean) ?? "");
  }

  async getResolutionOperation(
    command: StatementResolutionCommand,
    idempotencyKey: string,
  ): Promise<StatementResolutionOperation | null> {
    const response = await this.client.query(
      `SELECT * FROM financialOperation
       WHERE command = $command AND idempotencyKey = $idempotencyKey LIMIT 1;`,
      { command, idempotencyKey },
    );
    const value = rows<Raw>(response)[0];
    return value ? normalizeStatementResolutionOperation(value) : null;
  }

  async listCandidateTransactions(filter: {
    spaceId: string;
    accountId: string;
    periodStart: string;
    periodEnd: string;
    includeCounterpartAccounts: boolean;
  }): Promise<TransactionRecord[]> {
    const response = await this.client.query(
      `SELECT id, key, space AS spaceId, space.key AS spaceKey,
          account AS accountId, account.key AS accountKey, postedAt, effectiveAt, recordedAt,
          description, amount, amountMinor, currency, direction, transactionKind,
          flowDirection, entrySource, category AS categoryId,
          category.key AS categoryKey, category.name AS categoryName,
          category.categoryKind AS categoryKind, status, merchantName, notes,
          sourceRow AS sourceRowId, statementMatch AS statementMatchId,
          statementMatch.statementImport AS statementImportId,
          statementMatch.state AS statementMatchState,
          statementMatch.sourceState AS statementMatchSourceState,
          statementMatch.statementImport.sourceState AS statementImportSourceState,
          operation AS operationId, transfer AS transferId, isTransfer
       FROM transaction
       WHERE account.active = true AND account.space.active = true
         AND ($includeCounterparts OR (
           space = type::record("financialSpace", $spaceKey)
           AND account = type::record("account", $accountKey)
         ))
         AND postedAt >= $windowStart AND postedAt <= $windowEnd
       ORDER BY postedAt ASC, id ASC;`,
      {
        spaceKey: recordKey(filter.spaceId),
        accountKey: recordKey(filter.accountId),
        includeCounterparts: filter.includeCounterpartAccounts,
        windowStart: offsetDate(filter.periodStart, -3),
        windowEnd: offsetDate(filter.periodEnd, 3),
      },
    );
    const transactions = rows<Raw>(response).map(normalizeTransaction);
    if (transactions.length === 0) return [];
    const claimResponse = await this.client.query(
      `SELECT VALUE type::string(transaction)
       FROM statementTransactionResolutionClaim
       WHERE state = "active";`,
    );
    const activelyClaimed = new Set(
      unwrap(claimResponse).flat(Infinity).map(String),
    );
    return transactions.map((transaction) => ({
      ...transaction,
      hasActiveStatementClaim:
        transaction.hasActiveStatementClaim ||
        activelyClaimed.has(transaction.id),
    }));
  }

  async getResolutionTransaction(
    id: string,
  ): Promise<TransactionRecord | null> {
    const response = await this.client.query(
      `SELECT id, key, space AS spaceId, space.key AS spaceKey,
          account AS accountId, account.key AS accountKey, postedAt, effectiveAt, recordedAt,
          description, amount, amountMinor, currency, direction, transactionKind,
          flowDirection, entrySource, category AS categoryId,
          category.key AS categoryKey, category.name AS categoryName,
          category.categoryKind AS categoryKind, status, merchantName, notes,
          sourceRow AS sourceRowId, statementMatch AS statementMatchId,
          statementMatch.statementImport AS statementImportId,
          statementMatch.state AS statementMatchState,
          statementMatch.sourceState AS statementMatchSourceState,
          statementMatch.statementImport.sourceState AS statementImportSourceState,
          operation AS operationId, transfer AS transferId, isTransfer
       FROM type::record("transaction", $key) LIMIT 1;`,
      { key: recordKey(id) },
    );
    const value = rows<Raw>(response)[0];
    return value ? normalizeTransaction(value) : null;
  }

  async listStatementTransactionMatches(
    filter: StatementMatchReadFilter,
  ): Promise<StatementTransactionMatchRecord[]> {
    const response = await this.client.query(
      `SELECT * FROM statementTransactionMatch
       WHERE statementImport = type::record("statementImport", $importKey)
         AND ($componentId = "" OR componentIds CONTAINS $componentId)
         AND ($transactionKey = "" OR transaction = type::record("transaction", $transactionKey))
         AND ($includeSuperseded OR state != "superseded")
       ORDER BY proposedAt ASC, id ASC;`,
      {
        importKey: recordKey(filter.statementImportId),
        componentId: filter.statementRowComponentId ?? "",
        transactionKey: filter.transactionId
          ? recordKey(filter.transactionId)
          : "",
        includeSuperseded: filter.includeSuperseded ?? false,
      },
    );
    return rows<Raw>(response).map(normalizeStatementTransactionMatch);
  }

  async getStatementTransactionMatch(
    id: string,
  ): Promise<StatementTransactionMatchRecord | null> {
    const response = await this.client.query(
      `SELECT * FROM type::record("statementTransactionMatch", $key) LIMIT 1;`,
      { key: recordKey(id) },
    );
    const value = rows<Raw>(response)[0];
    return value ? normalizeStatementTransactionMatch(value) : null;
  }

  async getStatementReconciliation(
    statementImportId: string,
  ): Promise<StatementReconciliationRecord | null> {
    const response = await this.client.query(
      `SELECT * FROM statementReconciliation
       WHERE statementImport = type::record("statementImport", $key) LIMIT 1;`,
      { key: recordKey(statementImportId) },
    );
    const value = rows<Raw>(response)[0];
    return value ? normalizeStatementReconciliation(value) : null;
  }

  async listStatementReconciliationEvents(
    statementImportId: string,
  ): Promise<StatementReconciliationEventRecord[]> {
    const response = await this.client.query(
      `SELECT * FROM statementReconciliationEvent
       WHERE statementImport = type::record("statementImport", $key)
       ORDER BY recordedAt ASC, id ASC;`,
      { key: recordKey(statementImportId) },
    );
    return rows<Raw>(response).map(normalizeEvent);
  }

  async proposeStatementTransactionMatch(
    draft: StatementMatchMutationDraft,
  ): Promise<StatementMatchRepositoryResult> {
    const matchId = await this.getStatementTransactionMatchIdentity(
      draft.match.statementImportId,
      draft.match.key,
    );
    try {
      const response = await this.client.query(
        `BEGIN TRANSACTION;
         LET $statementImportId = type::record("statementImport", $match.statementImportKey);
         LET $matchId = type::record("statementTransactionMatch", $matchKey);
         LET $resultRefs = [type::string($matchId)];
         ${CREATE_OPERATION}
         LET $activeImport = SELECT * FROM ONLY $statementImportId;
         IF !$activeImport OR $activeImport.sourceState != "committed" { THROW "STATEMENT_IMPORT_SUPERSEDED"; };
         IF record::exists($matchId) { THROW "STATEMENT_MATCH_CONFLICT"; };
         LET $components = SELECT * FROM statementRowComponent
           WHERE record::id(id) IN $validation.componentKeys;
         IF $components.any(|$component|
           $component.statementRow != type::record("statementRow", $validation.sourceRowKey)
           OR (IF $component.transactionDate != NONE THEN $component.transactionDate
             ELSE (IF $component.postingDate != NONE THEN $component.postingDate
               ELSE $component.valueDate END) END) != $validation.canonicalFinancialDate) {
           THROW "STATEMENT_COMPONENT_GROUP_INVALID";
         };
         LET $componentTotal = math::sum($components.balanceEffectMinor);
         IF array::len($components) != array::len($validation.componentIds)
           OR $components.any(|$component| $component.sourceState != "committed"
             OR $component.componentRole != "movement"
             OR $component.account != type::record("account", $validation.accountKey)
             OR $component.statementRow != type::record("statementRow", $validation.sourceRowKey)
             OR $component.currency != $validation.currency
             OR (IF $component.transactionDate != NONE THEN $component.transactionDate
               ELSE (IF $component.postingDate != NONE THEN $component.postingDate
                 ELSE $component.valueDate END) END) != $validation.canonicalFinancialDate
             OR !($component.sourceChecksum IN $validation.componentChecksums))
           OR $componentTotal != <int> $validation.signedComponentTotalMinor {
           THROW "STATEMENT_TRANSACTION_INELIGIBLE";
         };
         LET $transaction = SELECT * FROM ONLY type::record("transaction", $validation.transactionKey);
         IF !$transaction OR $transaction.status = "ignored"
           OR $transaction.transactionKind = "unresolved"
           OR !($transaction.entrySource IN ["manual", "generated"])
           OR $transaction.sourceRow != NONE
           OR $transaction.transfer != NONE OR $transaction.isTransfer = true
           OR $transaction.account != type::record("account", $validation.accountKey)
           OR $transaction.currency != $validation.currency
           OR $transaction.amountMinor != <int> $validation.transactionAmountMinor
           OR $transaction.flowDirection != $validation.flowDirection
           OR !($transaction.postedAt IN $validation.acceptedTransactionDates) {
           THROW "STATEMENT_TRANSACTION_INELIGIBLE";
         };
         IF $transaction.statementMatch != NONE { THROW "STATEMENT_TRANSACTION_ALREADY_MATCHED"; };
         FOR $componentKey IN $validation.componentKeys {
           LET $componentId = type::record("statementRowComponent", $componentKey);
           LET $claimId = type::record("statementComponentResolutionClaim", fn::stringID([$componentId, "active"]));
           LET $claim = SELECT * FROM ONLY $claimId;
           IF $claim AND $claim.state = "active" { THROW "STATEMENT_COMPONENT_ALREADY_DISPOSED"; };
         };
         LET $transactionClaimId = type::record("statementTransactionResolutionClaim", fn::stringID([$transaction.id, "active"]));
         LET $transactionClaim = SELECT * FROM ONLY $transactionClaimId;
         IF $transactionClaim AND $transactionClaim.state = "active" { THROW "STATEMENT_TRANSACTION_ALREADY_MATCHED"; };
         LET $matchRecord = CREATE ONLY $matchId CONTENT {
           space: type::record("financialSpace", $match.spaceKey),
           account: type::record("account", $match.accountKey),
           statementImport: $statementImportId,
           primaryComponent: type::record("statementRowComponent", $match.componentKeys[0]),
           componentIds: $match.componentIds,
           transaction: type::record("transaction", $match.transactionKey),
           key: $match.key, state: "proposed", method: $match.method,
           reasonCodes: $match.reasonCodes, confidence: $match.confidence,
           signedComponentTotalMinor: <int> $match.signedComponentTotalMinor,
           currency: $match.currency, revision: 1,
           proposedOperation: $operationId,
           proposedBy: IF $match.hasProposedBy THEN $match.proposedBy ELSE NONE END,
           proposedAt: $match.proposedAt, sourceState: "committed", notes: ""
         };
         ${UPSERT_RECONCILIATION}
         RETURN { match: $matchRecord, reconciliation: $reconciliationRecord, operation: $operationRecord };
         COMMIT TRANSACTION;`,
        {
          matchKey: recordKey(matchId),
          match: matchVars(draft.match),
          validation: validationVars(draft.validation),
          operation: operationVars(draft.operation),
          reconciliation: reconciliationWithKeys(draft.reconciliation),
          ...reconciliationExpectationVars(draft),
        },
      );
      return normalizeMatchResult(response);
    } catch (error) {
      return this.recoverMatchMutation(
        draft.operation,
        error,
        draft.validation,
      );
    }
  }

  async confirmStatementTransactionMatch(
    draft: StatementConfirmationDraft,
  ): Promise<StatementMatchRepositoryResult> {
    try {
      const response = await this.client.query(
        `BEGIN TRANSACTION;
         LET $matchId = type::record("statementTransactionMatch", $matchKey);
         LET $current = SELECT * FROM ONLY $matchId;
         IF !$current OR $current.state != "proposed" OR $current.revision != <int> $expectedRevision {
           THROW "STATEMENT_MATCH_CONFLICT";
         };
         LET $statementImportId = $current.statementImport;
         LET $activeImport = SELECT * FROM ONLY $statementImportId;
         IF !$activeImport OR $activeImport.sourceState != "committed" { THROW "STATEMENT_IMPORT_SUPERSEDED"; };
         LET $transaction = SELECT * FROM ONLY $current.transaction;
         IF !$transaction OR $transaction.status = "ignored"
           OR $transaction.transactionKind = "unresolved"
           OR !($transaction.entrySource IN ["manual", "generated"])
           OR $transaction.sourceRow != NONE
           OR $transaction.transfer != NONE OR $transaction.isTransfer = true
           OR $transaction.account != type::record("account", $validation.accountKey)
           OR $transaction.currency != $validation.currency
           OR $transaction.amountMinor != <int> $validation.transactionAmountMinor
           OR $transaction.flowDirection != $validation.flowDirection
           OR !($transaction.postedAt IN $validation.acceptedTransactionDates) {
           THROW "STATEMENT_TRANSACTION_INELIGIBLE";
         };
         IF $transaction.statementMatch != NONE { THROW "STATEMENT_TRANSACTION_ALREADY_MATCHED"; };
         LET $components = SELECT * FROM statementRowComponent WHERE record::id(id) IN $validation.componentKeys;
         IF $components.any(|$component|
           $component.statementRow != type::record("statementRow", $validation.sourceRowKey)
           OR (IF $component.transactionDate != NONE THEN $component.transactionDate
             ELSE (IF $component.postingDate != NONE THEN $component.postingDate
               ELSE $component.valueDate END) END) != $validation.canonicalFinancialDate) {
           THROW "STATEMENT_COMPONENT_GROUP_INVALID";
         };
         LET $componentTotal = math::sum($components.balanceEffectMinor);
         IF array::len($components) != array::len($current.componentIds)
           OR $components.any(|$component| $component.sourceState != "committed"
             OR $component.componentRole != "movement"
             OR $component.account != $current.account
             OR $component.statementRow != type::record("statementRow", $validation.sourceRowKey)
             OR $component.currency != $current.currency
             OR (IF $component.transactionDate != NONE THEN $component.transactionDate
               ELSE (IF $component.postingDate != NONE THEN $component.postingDate
                 ELSE $component.valueDate END) END) != $validation.canonicalFinancialDate
             OR !($component.sourceChecksum IN $validation.componentChecksums))
           OR $componentTotal != <int> $validation.signedComponentTotalMinor
           OR $current.transaction != $transaction.id
           OR $current.signedComponentTotalMinor != <int> $validation.signedComponentTotalMinor {
           THROW "STATEMENT_TRANSACTION_INELIGIBLE";
         };
         LET $resultRefs = [type::string($matchId)];
         ${CREATE_OPERATION}
         FOR $componentKey IN $componentKeys {
           LET $componentId = type::record("statementRowComponent", $componentKey);
           LET $claimId = type::record("statementComponentResolutionClaim", fn::stringID([$componentId, "active"]));
           LET $claim = SELECT * FROM ONLY $claimId;
           IF $claim AND $claim.state = "active" { THROW "STATEMENT_COMPONENT_ALREADY_DISPOSED"; };
           UPSERT ONLY $claimId CONTENT {
             space: $current.space, account: $current.account,
             statementImport: $statementImportId,
             statementRowComponent: $componentId,
             statementTransactionMatch: $matchId,
             transaction: $current.transaction, key: "active", state: "active",
             claimedAt: $confirmedAt, operation: $operationId
           };
         };
         LET $transactionClaimId = type::record("statementTransactionResolutionClaim", fn::stringID([$current.transaction, "active"]));
         LET $transactionClaim = SELECT * FROM ONLY $transactionClaimId;
         IF $transactionClaim AND $transactionClaim.state = "active" { THROW "STATEMENT_TRANSACTION_ALREADY_MATCHED"; };
         UPSERT ONLY $transactionClaimId CONTENT {
           space: $current.space, account: $current.account,
           statementImport: $statementImportId,
           statementTransactionMatch: $matchId,
           transaction: $current.transaction, key: "active",
           periodStart: $activeImport.periodStart, periodEnd: $activeImport.periodEnd,
           state: "active", claimedAt: $confirmedAt, operation: $operationId
         };
         LET $matchRecord = UPDATE ONLY $matchId SET
           state = "confirmed", revision += 1, confirmedOperation = $operationId,
           confirmedAt = $confirmedAt,
           reviewedBy = IF $hasActorId THEN $actorId ELSE NONE END;
         UPDATE ONLY $current.transaction SET
           statementMatch = $matchId,
           effectiveAt = $validation.canonicalFinancialDate;
         ${UPSERT_RECONCILIATION}
         RETURN { match: $matchRecord, reconciliation: $reconciliationRecord, operation: $operationRecord };
         COMMIT TRANSACTION;`,
        {
          matchKey: recordKey(draft.matchId),
          expectedRevision: draft.expectedRevision,
          componentKeys: draft.validation.componentIds.map(recordKey),
          validation: validationVars(draft.validation),
          confirmedAt: draft.confirmedAt,
          hasActorId: Boolean(draft.actorId),
          actorId: draft.actorId ?? "",
          operation: operationVars(draft.operation),
          reconciliation: reconciliationWithKeys(draft.reconciliation),
          ...reconciliationExpectationVars(draft),
        },
      );
      return normalizeMatchResult(response);
    } catch (error) {
      return this.recoverMatchMutation(
        draft.operation,
        error,
        draft.validation,
      );
    }
  }

  async materializeStatementComponentTransaction(
    draft: StatementMaterializationDraft,
  ): Promise<StatementMaterializationRepositoryResult> {
    const matchId = await this.getStatementTransactionMatchIdentity(
      draft.match.statementImportId,
      draft.match.key,
    );
    const transactionId = await this.getImportedTransactionIdentity(
      draft.transaction.accountId,
      draft.transaction.key,
    );
    try {
      const response = await this.client.query(
        `BEGIN TRANSACTION;
         LET $statementImportId = type::record("statementImport", $importKey);
         LET $activeImport = SELECT * FROM ONLY $statementImportId;
         IF !$activeImport OR $activeImport.sourceState != "committed" { THROW "STATEMENT_IMPORT_SUPERSEDED"; };
         LET $matchId = type::record("statementTransactionMatch", $matchKey);
         LET $transactionId = type::record("transaction", $transactionKey);
         IF record::exists($matchId) OR record::exists($transactionId) { THROW "STATEMENT_COMPONENT_ALREADY_DISPOSED"; };
         LET $components = SELECT * FROM statementRowComponent WHERE record::id(id) IN $componentKeys;
         IF $components.any(|$component|
           $component.statementRow != type::record("statementRow", $transaction.sourceRowKey)
           OR (IF $component.transactionDate != NONE THEN $component.transactionDate
             ELSE (IF $component.postingDate != NONE THEN $component.postingDate
               ELSE $component.valueDate END) END) != $transaction.effectiveAt) {
           THROW "STATEMENT_COMPONENT_GROUP_INVALID";
         };
         LET $componentTotal = math::sum($components.balanceEffectMinor);
         IF array::len($components) != array::len($componentIds)
           OR $components.any(|$component| $component.sourceState != "committed"
             OR $component.componentRole != "movement"
             OR $component.account != type::record("account", $transaction.accountKey)
             OR $component.statementRow != type::record("statementRow", $transaction.sourceRowKey)
             OR $component.currency != $transaction.currency
             OR (IF $component.transactionDate != NONE THEN $component.transactionDate
               ELSE (IF $component.postingDate != NONE THEN $component.postingDate
                 ELSE $component.valueDate END) END) != $transaction.effectiveAt
             OR !($component.sourceChecksum IN $componentChecksums))
           OR $componentTotal != <int> $match.signedComponentTotalMinor
           OR $transaction.amountMinor != (IF $componentTotal < 0 THEN -$componentTotal ELSE $componentTotal END)
           OR $transaction.flowDirection != (IF $componentTotal > 0 THEN "inflow" ELSE "outflow" END) {
           THROW "STATEMENT_TRANSACTION_INELIGIBLE";
         };
         FOR $candidate IN (SELECT * FROM transaction
           WHERE account != type::record("account", $transaction.accountKey)
             AND account.active = true AND account.space.active = true
             AND currency = $transaction.currency
             AND amountMinor = <int> $transaction.amountMinor
             AND flowDirection != $transaction.flowDirection
             AND postedAt IN $transferCandidateDates
             AND entrySource IN ["manual", "generated"]
             AND status != "ignored" AND transactionKind != "unresolved"
             AND sourceRow = NONE AND statementMatch = NONE
             AND transfer = NONE AND isTransfer != true) {
           LET $candidateClaimId = type::record(
             "statementTransactionResolutionClaim",
             fn::stringID([$candidate.id, "active"])
           );
           LET $candidateClaim = SELECT * FROM ONLY $candidateClaimId;
           IF !$candidateClaim OR $candidateClaim.state != "active" {
             THROW "STATEMENT_TRANSFER_REVIEW_REQUIRED";
           };
         };
         LET $resultRefs = [type::string($transactionId), type::string($matchId)];
         ${CREATE_OPERATION}
         FOR $componentKey IN $componentKeys {
           LET $componentId = type::record("statementRowComponent", $componentKey);
           LET $claimId = type::record("statementComponentResolutionClaim", fn::stringID([$componentId, "active"]));
           LET $claim = SELECT * FROM ONLY $claimId;
           IF $claim AND $claim.state = "active" { THROW "STATEMENT_COMPONENT_ALREADY_DISPOSED"; };
           UPSERT ONLY $claimId CONTENT {
             space: type::record("financialSpace", $transaction.spaceKey),
             account: type::record("account", $transaction.accountKey),
             statementImport: $statementImportId,
             statementRowComponent: $componentId,
             statementTransactionMatch: $matchId,
             transaction: $transactionId, key: "active", state: "active",
             claimedAt: $transaction.recordedAt, operation: $operationId
           };
         };
         LET $transactionRecord = CREATE ONLY $transactionId CONTENT {
           space: type::record("financialSpace", $transaction.spaceKey),
           account: type::record("account", $transaction.accountKey),
           key: $transaction.key,
           sourceRow: type::record("statementRow", $transaction.sourceRowKey),
           sourceChecksum: $transaction.sourceChecksum,
           postedAt: $transaction.postedAt, effectiveAt: $transaction.effectiveAt,
           description: $transaction.description, normalizedDescription: "",
           amount: 0, amountMinor: <int> $transaction.amountMinor,
           balance: 0, currency: $transaction.currency,
           direction: $transaction.direction,
           transactionKind: $transaction.transactionKind,
           flowDirection: $transaction.flowDirection,
           entrySource: "imported", recordedAt: $transaction.recordedAt,
           status: "imported", confidence: 1,
           merchantName: "", isTransfer: false,
           operation: $operationId, statementMatch: $matchId,
           manualOverride: false, notes: ""
         };
         LET $matchRecord = CREATE ONLY $matchId CONTENT {
           space: type::record("financialSpace", $match.spaceKey),
           account: type::record("account", $match.accountKey),
           statementImport: $statementImportId,
           primaryComponent: type::record("statementRowComponent", $match.componentKeys[0]),
           componentIds: $match.componentIds, transaction: $transactionId,
           key: $match.key, state: "confirmed", method: "created_from_component",
           reasonCodes: $match.reasonCodes, confidence: $match.confidence,
           signedComponentTotalMinor: <int> $match.signedComponentTotalMinor,
           currency: $match.currency, revision: 1,
           proposedOperation: $operationId, confirmedOperation: $operationId,
           proposedBy: IF $match.hasProposedBy THEN $match.proposedBy ELSE NONE END,
           reviewedBy: IF $operation.hasActorId THEN $operation.actorId ELSE NONE END,
           proposedAt: $match.proposedAt, confirmedAt: $transaction.recordedAt,
           sourceState: "committed", notes: ""
         };
         LET $transactionClaimId = type::record("statementTransactionResolutionClaim", fn::stringID([$transactionId, "active"]));
         CREATE ONLY $transactionClaimId CONTENT {
           space: type::record("financialSpace", $transaction.spaceKey),
           account: type::record("account", $transaction.accountKey),
           statementImport: $statementImportId,
           statementTransactionMatch: $matchId,
           transaction: $transactionId, key: "active",
           periodStart: $activeImport.periodStart, periodEnd: $activeImport.periodEnd,
           state: "active", claimedAt: $transaction.recordedAt, operation: $operationId
         };
         LET $sourceRowId = type::record("statementRow", $transaction.sourceRowKey);
         LET $accountId = type::record("account", $transaction.accountKey);
         RELATE $sourceRowId->StatementRowTransactions->$transactionId;
         RELATE $accountId->AccountTransactions->$transactionId;
         ${UPSERT_RECONCILIATION}
         RETURN { transaction: $transactionRecord, match: $matchRecord, reconciliation: $reconciliationRecord, operation: $operationRecord };
         COMMIT TRANSACTION;`,
        {
          importKey: recordKey(draft.statementImportId),
          matchKey: recordKey(matchId),
          transactionKey: recordKey(transactionId),
          componentIds: draft.componentIds,
          componentKeys: draft.componentIds.map(recordKey),
          componentChecksums: draft.componentChecksums,
          transferCandidateDates: draft.transferCandidateDates,
          match: matchVars(draft.match),
          transaction: {
            ...draft.transaction,
            spaceKey: recordKey(draft.transaction.spaceId),
            accountKey: recordKey(draft.transaction.accountId),
            sourceRowKey: recordKey(draft.transaction.sourceRowId),
          },
          operation: operationVars(draft.operation),
          reconciliation: reconciliationWithKeys(draft.reconciliation),
          ...reconciliationExpectationVars(draft),
        },
      );
      const result = transactionResult<{
        transaction: Raw;
        match: Raw;
        reconciliation: Raw;
        operation: Raw;
      }>(response, "transaction");
      return {
        transaction: normalizeTransaction({
          ...result.transaction,
          spaceKey: recordKey(draft.transaction.spaceId),
          accountKey: recordKey(draft.transaction.accountId),
          statementImportId: draft.statementImportId,
        }),
        match: normalizeStatementTransactionMatch(result.match),
        reconciliation: normalizeStatementReconciliation(result.reconciliation),
        operation: normalizeStatementResolutionOperation(result.operation),
      };
    } catch (error) {
      const replay = await this.getResolutionOperation(
        draft.operation.command as StatementResolutionCommand,
        draft.operation.idempotencyKey,
      );
      if (replay && replay.requestHash === draft.operation.requestHash) {
        const replayMatchId = replay.resultRefs.find((ref) =>
          ref.startsWith("statementTransactionMatch:"),
        );
        const replayTransactionId = replay.resultRefs.find((ref) =>
          ref.startsWith("transaction:"),
        );
        const [match, transaction] = await Promise.all([
          replayMatchId
            ? this.getStatementTransactionMatch(replayMatchId)
            : null,
          replayTransactionId
            ? this.getResolutionTransaction(replayTransactionId)
            : null,
        ]);
        if (match && transaction) {
          return {
            match,
            transaction,
            reconciliation: await this.getStatementReconciliation(
              match.statementImportId,
            ),
            operation: replay,
          };
        }
      }
      await this.throwActiveClaimConflict({
        componentIds: draft.componentIds,
        componentChecksums: draft.componentChecksums,
        transactionId,
        accountId: draft.transaction.accountId,
        currency: draft.transaction.currency,
        signedComponentTotalMinor: draft.match.signedComponentTotalMinor,
        transactionAmountMinor: draft.transaction.amountMinor,
        flowDirection: draft.transaction.flowDirection,
        acceptedTransactionDates: [draft.transaction.postedAt],
        sourceRowId: draft.transaction.sourceRowId,
        canonicalFinancialDate: draft.transaction.effectiveAt,
      });
      rethrowResolutionError(error);
    }
  }

  async rejectStatementTransactionMatch(
    draft: StatementRejectionDraft,
  ): Promise<StatementMatchRepositoryResult> {
    return this.mutateMatchState(draft, "rejected");
  }

  async supersedeStatementTransactionMatch(
    draft: StatementMatchSupersessionDraft,
  ): Promise<StatementMatchRepositoryResult> {
    const replacementId = await this.getStatementTransactionMatchIdentity(
      draft.replacement.statementImportId,
      draft.replacement.key,
    );
    try {
      const old = await this.getStatementTransactionMatch(draft.oldMatchId);
      const response = await this.client.query(
        `BEGIN TRANSACTION;
         LET $oldMatchId = type::record("statementTransactionMatch", $oldMatchKey);
         LET $replacementMatchId = type::record("statementTransactionMatch", $replacementMatchKey);
         LET $old = SELECT * FROM ONLY $oldMatchId;
         IF !$old OR $old.state = "superseded" OR $old.revision != <int> $expectedRevision {
           THROW "STATEMENT_MATCH_CONFLICT";
         };
         LET $statementImportId = $old.statementImport;
         LET $activeImport = SELECT * FROM ONLY $statementImportId;
         IF !$activeImport OR $activeImport.sourceState != "committed" { THROW "STATEMENT_IMPORT_SUPERSEDED"; };
         LET $replacementTransaction = SELECT * FROM ONLY type::record("transaction", $replacement.transactionKey);
         IF !$replacementTransaction OR $replacementTransaction.status = "ignored"
           OR $replacementTransaction.transactionKind = "unresolved"
           OR !($replacementTransaction.entrySource IN ["manual", "generated"])
           OR $replacementTransaction.sourceRow != NONE
           OR $replacementTransaction.transfer != NONE
           OR $replacementTransaction.isTransfer = true
           OR $replacementTransaction.account != type::record("account", $validation.accountKey)
           OR $replacementTransaction.currency != $validation.currency
           OR $replacementTransaction.amountMinor != <int> $validation.transactionAmountMinor
           OR $replacementTransaction.flowDirection != $validation.flowDirection
           OR !($replacementTransaction.postedAt IN $validation.acceptedTransactionDates) {
           THROW "STATEMENT_TRANSACTION_INELIGIBLE";
         };
         IF $replacementTransaction.statementMatch != NONE
           AND $replacementTransaction.statementMatch != $oldMatchId {
           THROW "STATEMENT_TRANSACTION_ALREADY_MATCHED";
         };
         LET $replacementComponents = SELECT * FROM statementRowComponent
           WHERE record::id(id) IN $replacement.componentKeys;
         IF $replacementComponents.any(|$component|
           $component.statementRow != type::record("statementRow", $validation.sourceRowKey)
           OR (IF $component.transactionDate != NONE THEN $component.transactionDate
             ELSE (IF $component.postingDate != NONE THEN $component.postingDate
               ELSE $component.valueDate END) END) != $validation.canonicalFinancialDate) {
           THROW "STATEMENT_COMPONENT_GROUP_INVALID";
         };
         LET $replacementTotal = math::sum($replacementComponents.balanceEffectMinor);
         IF array::len($replacementComponents) != array::len($replacement.componentIds)
           OR $replacementComponents.any(|$component| $component.sourceState != "committed"
             OR $component.componentRole != "movement"
             OR $component.account != $old.account
             OR $component.statementRow != type::record("statementRow", $validation.sourceRowKey)
             OR $component.currency != $old.currency
             OR (IF $component.transactionDate != NONE THEN $component.transactionDate
               ELSE (IF $component.postingDate != NONE THEN $component.postingDate
                 ELSE $component.valueDate END) END) != $validation.canonicalFinancialDate
             OR !($component.sourceChecksum IN $validation.componentChecksums))
           OR $replacementTotal != <int> $validation.signedComponentTotalMinor {
           THROW "STATEMENT_TRANSACTION_INELIGIBLE";
         };
         LET $resultRefs = [type::string($replacementMatchId), type::string($oldMatchId)];
         ${CREATE_OPERATION}
         IF $old.state = "confirmed" {
           FOR $componentIdString IN $old.componentIds {
             LET $componentId = IF type::is_record($componentIdString)
               THEN $componentIdString
               ELSE type::record("statementRowComponent", string::slice(type::string($componentIdString), string::len("statementRowComponent:")))
             END;
             LET $claimId = type::record("statementComponentResolutionClaim", fn::stringID([$componentId, "active"]));
             UPDATE ONLY $claimId SET state = "released", releasedAt = $supersededAt, operation = $operationId;
           };
           LET $oldTransactionClaimId = type::record("statementTransactionResolutionClaim", fn::stringID([$old.transaction, "active"]));
           UPDATE ONLY $oldTransactionClaimId SET state = "released", releasedAt = $supersededAt, operation = $operationId;
           UPDATE ONLY $old.transaction SET statementMatch = NONE, effectiveAt = NONE;
         };
         FOR $componentKey IN $replacement.componentKeys {
           LET $componentId = type::record("statementRowComponent", $componentKey);
           LET $claimId = type::record("statementComponentResolutionClaim", fn::stringID([$componentId, "active"]));
           LET $claim = SELECT * FROM ONLY $claimId;
           IF $claim AND $claim.state = "active" AND $claim.statementTransactionMatch != $oldMatchId {
             THROW "STATEMENT_COMPONENT_ALREADY_DISPOSED";
           };
           UPSERT ONLY $claimId CONTENT {
             space: $old.space, account: $old.account,
             statementImport: $statementImportId,
             statementRowComponent: $componentId,
             statementTransactionMatch: $replacementMatchId,
             transaction: $replacementTransaction.id,
             key: "active", state: "active", claimedAt: $supersededAt,
             operation: $operationId
           };
         };
         LET $transactionClaimId = type::record("statementTransactionResolutionClaim", fn::stringID([$replacementTransaction.id, "active"]));
         LET $transactionClaim = SELECT * FROM ONLY $transactionClaimId;
         IF $transactionClaim AND $transactionClaim.state = "active"
           AND $transactionClaim.statementTransactionMatch != $oldMatchId {
           THROW "STATEMENT_TRANSACTION_ALREADY_MATCHED";
         };
         UPSERT ONLY $transactionClaimId CONTENT {
           space: $old.space, account: $old.account,
           statementImport: $statementImportId,
           statementTransactionMatch: $replacementMatchId,
           transaction: $replacementTransaction.id, key: "active",
           periodStart: $activeImport.periodStart, periodEnd: $activeImport.periodEnd,
           state: "active", claimedAt: $supersededAt, operation: $operationId
         };
         LET $oldRecord = UPDATE ONLY $oldMatchId SET
           state = "superseded", revision += 1,
           supersededOperation = $operationId, supersededAt = $supersededAt,
           supersessionReason = $reason, supersededBy = $replacementMatchId;
         LET $matchRecord = CREATE ONLY $replacementMatchId CONTENT {
           space: $old.space, account: $old.account,
           statementImport: $statementImportId,
           primaryComponent: type::record("statementRowComponent", $replacement.componentKeys[0]),
           componentIds: $replacement.componentIds,
           transaction: $replacementTransaction.id,
           key: $replacement.key, state: "confirmed", method: $replacement.method,
           reasonCodes: $replacement.reasonCodes, confidence: $replacement.confidence,
           signedComponentTotalMinor: <int> $replacement.signedComponentTotalMinor,
           currency: $replacement.currency, revision: 1,
           proposedOperation: $operationId, confirmedOperation: $operationId,
           proposedBy: IF $replacement.hasProposedBy THEN $replacement.proposedBy ELSE NONE END,
           reviewedBy: IF $operation.hasActorId THEN $operation.actorId ELSE NONE END,
           proposedAt: $replacement.proposedAt, confirmedAt: $supersededAt,
           supersedes: $oldMatchId, sourceState: "committed", notes: ""
         };
         UPDATE ONLY $replacementTransaction.id SET
           statementMatch = $replacementMatchId,
           effectiveAt = $validation.canonicalFinancialDate;
         ${UPSERT_RECONCILIATION}
         RETURN { match: $matchRecord, reconciliation: $reconciliationRecord, operation: $operationRecord };
         COMMIT TRANSACTION;`,
        {
          oldMatchKey: recordKey(draft.oldMatchId),
          replacementMatchKey: recordKey(replacementId),
          expectedRevision: draft.expectedRevision,
          reason: draft.reason,
          supersededAt: draft.supersededAt,
          oldComponentKeys: old?.componentIds.map(recordKey) ?? [],
          replacement: matchVars(draft.replacement),
          validation: validationVars(draft.validation),
          operation: operationVars(draft.operation),
          reconciliation: reconciliationWithKeys(draft.reconciliation),
          ...reconciliationExpectationVars(draft),
        },
      );
      return normalizeMatchResult(response);
    } catch (error) {
      return this.recoverMatchMutation(
        draft.operation,
        error,
        draft.validation,
      );
    }
  }

  async acknowledgeStatementIssue(
    draft: StatementIssueAcknowledgementDraft,
  ): Promise<StatementIssueRepositoryResult> {
    try {
      const response = await this.client.query(
        `BEGIN TRANSACTION;
         LET $issueId = type::record("statementIssue", $issueKey);
         LET $issue = SELECT * FROM ONLY $issueId;
         IF !$issue OR $issue.state != "open" OR $issue.revision != <int> $expectedRevision {
           THROW "STATEMENT_RECONCILIATION_STALE";
         };
         IF $issue.blocking = true { THROW "STATEMENT_BLOCKING_ISSUE_ACTIVE"; };
         LET $statementImportId = $issue.statementImport;
         LET $resultRefs = [type::string($issueId)];
         ${CREATE_OPERATION}
         LET $issueRecord = UPDATE ONLY $issueId SET
           state = "acknowledged", revision += 1,
           dispositionOperation = $operationId, acknowledgedAt = $acknowledgedAt,
           reviewedBy = IF $hasActorId THEN $actorId ELSE NONE END,
           notes = $note;
         ${UPSERT_RECONCILIATION}
         RETURN { issue: $issueRecord, reconciliation: $reconciliationRecord, operation: $operationRecord };
         COMMIT TRANSACTION;`,
        {
          issueKey: recordKey(draft.issueId),
          expectedRevision: draft.expectedRevision,
          note: draft.note,
          acknowledgedAt: draft.acknowledgedAt,
          hasActorId: Boolean(draft.actorId),
          actorId: draft.actorId ?? "",
          operation: operationVars(draft.operation),
          reconciliation: reconciliationWithKeys(draft.reconciliation),
          ...reconciliationExpectationVars(draft),
        },
      );
      const result = transactionResult<{
        issue: Raw;
        reconciliation: Raw;
        operation: Raw;
      }>(response, "issue");
      return {
        issue: normalizeIssue(result.issue),
        reconciliation: normalizeStatementReconciliation(result.reconciliation),
        operation: normalizeStatementResolutionOperation(result.operation),
      };
    } catch (error) {
      const replay = await this.getResolutionOperation(
        draft.operation.command as StatementResolutionCommand,
        draft.operation.idempotencyKey,
      );
      if (replay && replay.requestHash === draft.operation.requestHash) {
        const issueId = replay.resultRefs.find((ref) =>
          ref.startsWith("statementIssue:"),
        );
        const issue = issueId ? await this.getIssue(issueId) : null;
        if (issue) {
          return {
            issue,
            reconciliation: await this.getStatementReconciliation(
              issue.statementImportId,
            ),
            operation: replay,
          };
        }
      }
      rethrowResolutionError(error);
    }
  }

  async supersedeStatementImport(
    draft: StatementImportSupersessionDraft,
  ): Promise<StatementSupersessionRepositoryResult> {
    const replacement = draft.replacement.statementImport;
    const oldImportKey = recordKey(draft.oldImportId);
    try {
      const response = await this.client.query(
        `BEGIN TRANSACTION;
         LET $oldImportId = type::record("statementImport", $oldImportKey);
         LET $oldImport = SELECT *, space.key AS spaceKey, account.key AS accountKey FROM ONLY $oldImportId;
         IF !$oldImport OR $oldImport.sourceState != "committed"
           OR $oldImport.revision != <int> $expectedSourceRevision {
           THROW "STATEMENT_SOURCE_SUPERSESSION_CONFLICT";
         };
         LET $newImportId = type::record("statementImport", fn::stringID([$oldImport.account, $replacement.key]));
         IF record::exists($newImportId)
           OR $oldImport.account != type::record("account", $replacement.accountKey)
           OR $oldImport.space != type::record("financialSpace", $replacement.spaceKey)
           OR $oldImport.periodStart != $replacement.periodStart
           OR $oldImport.periodEnd != $replacement.periodEnd
           OR $oldImport.currency != $replacement.currency
           OR $oldImport.originalFileSha256 = $replacement.originalFileSha256 {
           THROW "STATEMENT_SOURCE_SUPERSESSION_CONFLICT";
         };
         LET $accountContext = SELECT *, space.active AS spaceActive,
           space.timezone AS spaceTimezone FROM ONLY $oldImport.account;
         LET $accountLast4 = IF $accountContext.accountNumberLast4 = NONE
           THEN "" ELSE <string> $accountContext.accountNumberLast4 END;
         LET $accountCurrency = IF $accountContext.currency = NONE OR $accountContext.currency = ""
           THEN "ZAR" ELSE <string> $accountContext.currency END;
         LET $accountNature = IF $accountContext.normalNature = "liability"
           OR (
             $accountContext.normalNature = NONE
             AND $accountContext.accountType IN ["credit_card", "loan", "debt"]
           )
           THEN "liability" ELSE "asset" END;
         LET $accountTimezone = IF $accountContext.spaceTimezone = NONE OR $accountContext.spaceTimezone = ""
           THEN "Africa/Johannesburg" ELSE <string> $accountContext.spaceTimezone END;
         IF !$accountContext OR $accountContext.active != true
           OR $accountContext.spaceActive != true
           OR $accountContext.space != type::record("financialSpace", $expectedAccount.spaceKey)
           OR $accountContext.key != $expectedAccount.accountKey
           OR $accountCurrency != $expectedAccount.currency
           OR $accountNature != $expectedAccount.normalNature
           OR $accountLast4 != $expectedAccount.accountNumberLast4
           OR $accountTimezone != $expectedAccount.spaceTimezone
           OR $oldImport.accountContextFingerprint != $expectedAccount.accountContextFingerprint
           OR $replacement.accountContextFingerprint != $expectedAccount.accountContextFingerprint {
           THROW "STATEMENT_ACCOUNT_CONTEXT_STALE";
         };
         IF $replacement.profileId = "" OR $replacement.profileVersion = ""
           OR $replacement.extractorVersion = ""
           OR $replacement.validationRulesetVersion = ""
           OR !($replacement.balanceConventionAuthority IN ["profile", "operator_unverified"])
           OR !($replacement.balanceConvention IN ["positive_is_asset", "positive_is_liability"])
           OR $replacement.rowCount != array::len($rows)
           OR $replacement.componentCount != array::len($components)
           OR $replacement.issueCount != array::len($issues) {
           THROW "STATEMENT_SOURCE_SUPERSESSION_CONFLICT";
         };
         LET $reconciliationId = type::record("statementReconciliation", fn::stringID([$oldImportId, "current"]));
         LET $oldReconciliation = SELECT * FROM ONLY $reconciliationId;
         IF ($hasExpectedReconciliationRevision
             AND (!$oldReconciliation
               OR $oldReconciliation.revision != <int> $expectedReconciliationRevision
               OR $oldReconciliation.calculationHash != $expectedReconciliationHash))
           OR (!$hasExpectedReconciliationRevision AND $oldReconciliation) {
           THROW "STATEMENT_RECONCILIATION_STALE";
         };
         LET $oldSourceClaimId = type::record("statementSourceClaim", fn::stringID([$oldImport.account, $oldImport.originalFileSha256]));
         LET $newSourceClaimId = type::record("statementSourceClaim", fn::stringID([$oldImport.account, $replacement.originalFileSha256]));
         LET $periodClaimId = type::record("statementPeriodClaim", fn::stringID([$oldImport.account, $oldImport.periodStart, $oldImport.periodEnd]));
         LET $oldSourceClaim = SELECT * FROM ONLY $oldSourceClaimId;
         LET $periodClaim = SELECT * FROM ONLY $periodClaimId;
         LET $newSourceClaim = SELECT * FROM ONLY $newSourceClaimId;
         IF !$oldSourceClaim OR $oldSourceClaim.state != "active"
           OR $oldSourceClaim.statementImport != $oldImportId {
           THROW "STATEMENT_SOURCE_CLAIM_CONFLICT";
         };
         IF !$periodClaim OR $periodClaim.state != "active"
           OR $periodClaim.statementImport != $oldImportId {
           THROW "STATEMENT_PERIOD_CLAIM_CONFLICT";
         };
         IF $newSourceClaim AND $newSourceClaim.state = "active" {
           THROW "STATEMENT_SOURCE_CLAIM_CONFLICT";
         };
         LET $resultRefs = [type::string($oldImportId), type::string($newImportId)];
         ${CREATE_OPERATION}
         LET $automaticReopeningEvent = IF $oldReconciliation.attestationState = "reconciled" {
           LET $eventKey = string::concat("source-replacement-", $operation.key);
           LET $eventId = type::record("statementReconciliationEvent", fn::stringID([$reconciliationId, $eventKey]));
           CREATE ONLY $eventId CONTENT {
             space: $oldImport.space, account: $oldImport.account,
             statementImport: $oldImportId,
             statementReconciliation: $reconciliationId,
             key: $eventKey, eventType: "reopened",
             reconciliationRevision: <int> ($oldReconciliation.revision + 1),
             calculationHash: $oldReconciliation.calculationHash,
             calculationSnapshot: $oldReconciliation,
             reason: $reason,
             actorId: IF $operation.hasActorId THEN $operation.actorId ELSE NONE END,
             channel: $operation.channel, operation: $operationId,
             recordedAt: $operation.recordedAt
           }
         } ELSE { NONE };
         LET $reconciliationRecord = IF $oldReconciliation {
           UPDATE ONLY $reconciliationId SET
             attestationState = IF attestationState = "reconciled" THEN "reopened" ELSE attestationState END,
             revision += 1,
             latestReopeningOperation = IF attestationState = "reconciled" THEN $operationId ELSE latestReopeningOperation END,
             reopenedAt = IF attestationState = "reconciled" THEN $operation.recordedAt ELSE reopenedAt END
         } ELSE { NONE };
         UPDATE statementComponentResolutionClaim SET
           state = "released", releasedAt = $operation.recordedAt, operation = $operationId
           WHERE statementImport = $oldImportId AND state = "active";
         UPDATE statementTransactionResolutionClaim SET
           state = "released", releasedAt = $operation.recordedAt, operation = $operationId
           WHERE statementImport = $oldImportId AND state = "active";
         FOR $match IN (SELECT * FROM statementTransactionMatch WHERE statementImport = $oldImportId AND state = "confirmed" AND sourceState = "committed") {
           UPDATE ONLY $match.transaction SET statementMatch = NONE, effectiveAt = NONE
             WHERE statementMatch = $match.id;
         };
         UPDATE statementTransactionMatch SET sourceState = "superseded"
           WHERE statementImport = $oldImportId AND sourceState = "committed";
         UPDATE statementRowComponent SET sourceState = "superseded"
           WHERE statementImport = $oldImportId AND sourceState = "committed";
         UPDATE statementIssue SET state = "superseded", revision += 1,
           dispositionOperation = $operationId, resolvedAt = $operation.recordedAt
           WHERE statementImport = $oldImportId AND state != "superseded";
         LET $supersededImport = UPDATE ONLY $oldImportId SET
           sourceState = "superseded", revision += 1;
         UPDATE ONLY $oldSourceClaimId SET state = "released", operation = $operationId;
         UPDATE ONLY $periodClaimId SET state = "released", operation = $operationId;
         LET $newSourceClaimRecord = UPSERT ONLY $newSourceClaimId CONTENT {
           space: $oldImport.space, account: $oldImport.account,
           statementImport: $newImportId, key: $replacement.originalFileSha256,
           originalFileSha256: $replacement.originalFileSha256,
           periodStart: $replacement.periodStart, periodEnd: $replacement.periodEnd,
           state: "active", claimedAt: $replacement.committedAt, operation: $operationId
         };
         LET $newPeriodClaimRecord = UPSERT ONLY $periodClaimId CONTENT {
           space: $oldImport.space, account: $oldImport.account,
           statementImport: $newImportId,
           key: string::concat($replacement.periodStart, "|", $replacement.periodEnd),
           periodStart: $replacement.periodStart, periodEnd: $replacement.periodEnd,
           originalFileSha256: $replacement.originalFileSha256,
           state: "active", claimedAt: $replacement.committedAt, operation: $operationId
         };
         LET $replacementImport = CREATE ONLY $newImportId CONTENT {
           space: $oldImport.space, account: $oldImport.account,
           key: $replacement.key, sourceFileName: "private-source",
           sourceFormat: $replacement.sourceKind,
           privateSourceRef: $replacement.privateSourceRef,
           extractionAssistRef: IF $replacement.hasExtractionAssist THEN $replacement.extractionAssistRef ELSE NONE END,
           originalFileSha256: $replacement.originalFileSha256,
           extractionInputSha256: IF $replacement.hasExtractionInputSha256 THEN $replacement.extractionInputSha256 ELSE NONE END,
           canonicalExtractionSha256: $replacement.canonicalExtractionSha256,
           previewHash: $replacement.previewHash,
           sourceMimeType: $replacement.sourceMimeType,
           sourceByteSize: <int> $replacement.sourceByteSize,
           profileId: $replacement.profileId, profileVersion: $replacement.profileVersion,
           extractorVersion: $replacement.extractorVersion,
           validationRulesetVersion: $replacement.validationRulesetVersion,
           periodStart: $replacement.periodStart, periodEnd: $replacement.periodEnd,
           currency: $replacement.currency,
           balanceConvention: $replacement.balanceConvention,
           balanceConventionAuthority: $replacement.balanceConventionAuthority,
           accountContextFingerprint: $replacement.accountContextFingerprint,
           openingBalanceMinor: IF $replacement.hasOpeningBalance THEN <int> $replacement.openingBalanceMinor ELSE NONE END,
           closingBalanceMinor: IF $replacement.hasClosingBalance THEN <int> $replacement.closingBalanceMinor ELSE NONE END,
           closingBalanceEconomicNature: IF $replacement.hasClosingBalanceEconomicNature THEN $replacement.closingBalanceEconomicNature ELSE NONE END,
           coverage: $replacement.coverage, sourceState: "committed",
           commitOperation: $operationId, committedAt: $replacement.committedAt,
           importedAt: $replacement.importedAt, replacementOf: $oldImportId,
           statementDate: $replacement.periodEnd, status: "parsed",
           rowCount: <int> $replacement.rowCount,
           componentCount: <int> $replacement.componentCount,
           issueCount: <int> $replacement.issueCount, revision: 1,
           normalizedCount: 0, clarificationCount: 0,
           sourceChecksum: $replacement.originalFileSha256, notes: ""
         };
         LET $sourceAccountId = $oldImport.account;
         RELATE $sourceAccountId->AccountStatementImports->$newImportId;
         FOR $row IN $rows {
           LET $rowId = type::record("statementRow", fn::stringID([$newImportId, $row.key]));
           CREATE ONLY $rowId CONTENT {
             space: $oldImport.space, account: $oldImport.account,
             statementImport: $newImportId, key: $row.key,
             rowNumber: <int> $row.rowNumber, rowKind: $row.rowKind,
             transactionDate: IF $row.hasTransactionDate THEN $row.transactionDate ELSE NONE END,
             postingDate: IF $row.hasPostingDate THEN $row.postingDate ELSE NONE END,
             valueDate: IF $row.hasValueDate THEN $row.valueDate ELSE NONE END,
             sourceReference: IF $row.hasSourceReference THEN $row.sourceReference ELSE NONE END,
             sourceLocator: IF $row.hasLocator THEN $row.locator ELSE NONE END,
             reportedBalanceMinor: IF $row.hasReportedBalance THEN <int> $row.reportedBalanceMinor ELSE NONE END,
             componentCount: <int> $row.componentCount,
             extractionConfidence: $row.confidence, rowHash: $row.rowHash,
             commitOperation: $operationId,
             postedAt: IF $row.hasPostingDate THEN $row.postingDate ELSE "" END,
             description: $row.rawText, normalizedDescription: "",
             amount: 0, balance: 0, currency: $replacement.currency,
             direction: "unknown", status: "raw", confidence: $row.confidence,
             rawData: {}, sourceChecksum: $row.rowHash, notes: ""
           };
           RELATE $newImportId->StatementImportRows->$rowId;
         };
         FOR $component IN $components {
           LET $rowId = type::record("statementRow", fn::stringID([$newImportId, $component.rowKey]));
           LET $componentId = type::record("statementRowComponent", fn::stringID([$rowId, $component.componentKey]));
           CREATE ONLY $componentId CONTENT {
             space: $oldImport.space, account: $oldImport.account,
             statementImport: $newImportId, statementRow: $rowId,
             key: $component.componentKey, componentKind: $component.componentKind,
             componentRole: $component.componentRole,
             transactionDate: IF $component.hasTransactionDate THEN $component.transactionDate ELSE NONE END,
             postingDate: IF $component.hasPostingDate THEN $component.postingDate ELSE NONE END,
             valueDate: IF $component.hasValueDate THEN $component.valueDate ELSE NONE END,
             description: $component.description,
             sourceReference: IF $component.hasSourceReference THEN $component.sourceReference ELSE NONE END,
             amountMinor: <int> $component.amountMinor, currency: $component.currency,
             sourceDirection: $component.sourceDirection, sourceFlow: $component.sourceFlow,
             balanceEffectMinor: <int> $component.balanceEffectMinor,
             sourceLocator: IF $component.hasLocator THEN $component.locator ELSE NONE END,
             confidence: $component.confidence, sourceChecksum: $component.sourceChecksum,
             sourceState: "committed", commitOperation: $operationId, notes: ""
           };
           RELATE $rowId->StatementRowComponents->$componentId;
         };
         FOR $issue IN $issues {
           LET $issueId = type::record("statementIssue", fn::stringID([$newImportId, $issue.key]));
           LET $rowId = IF $issue.rowKey = "" THEN NONE ELSE type::record("statementRow", fn::stringID([$newImportId, $issue.rowKey])) END;
           LET $componentId = IF $issue.componentKey = "" OR $issue.rowKey = "" THEN NONE
             ELSE type::record("statementRowComponent", fn::stringID([$rowId, $issue.componentKey])) END;
           CREATE ONLY $issueId CONTENT {
             space: $oldImport.space, account: $oldImport.account,
             statementImport: $newImportId, statementRow: $rowId,
             statementRowComponent: $componentId, key: $issue.key,
             code: $issue.code, severity: $issue.severity, blocking: false,
             state: "open", message: $issue.message, revision: 1,
             detectedOperation: $operationId, detectedAt: $issue.detectedAt,
             notes: ""
           };
           RELATE $newImportId->StatementImportIssues->$issueId;
         };
         LET $snapshotRecord = IF $hasSnapshot {
           LET $snapshotId = type::record("accountBalanceSnapshot", $snapshot.key);
           CREATE ONLY $snapshotId CONTENT {
             space: $oldImport.space, account: $oldImport.account,
             key: $snapshot.key, balanceKind: "statement",
             amountMinor: <int> $snapshot.amountMinor, currency: $snapshot.currency,
             economicNature: $snapshot.economicNature, asOf: $snapshot.asOf,
             recordedAt: $snapshot.recordedAt, evidenceLevel: "observed",
             sourceKind: "statement_closing", sourceRef: type::string($newImportId),
             operation: $operationId, notes: ""
           }
         } ELSE { NONE };
         RETURN { supersededImport: $supersededImport, replacementImport: $replacementImport,
           reconciliation: $reconciliationRecord, operation: $operationRecord };
         COMMIT TRANSACTION;`,
        {
          oldImportKey,
          expectedSourceRevision: draft.expectedSourceRevision,
          hasExpectedReconciliationRevision:
            draft.expectedReconciliationRevision !== null,
          expectedReconciliationRevision:
            draft.expectedReconciliationRevision ?? 0,
          expectedReconciliationHash: draft.expectedReconciliationHash ?? "",
          reason: draft.reason,
          replacement: sourceImportVars(replacement),
          expectedAccount: {
            ...draft.replacement.expectedAccountContext,
            spaceKey: recordKey(
              draft.replacement.expectedAccountContext.spaceId,
            ),
            accountKey: draft.replacement.expectedAccountContext.accountKey,
            accountNumberLast4:
              draft.replacement.expectedAccountContext.accountNumberLast4 ?? "",
          },
          rows: sourceRowsVars(draft.replacement.rows),
          components: sourceComponentsVars(draft.replacement.components),
          issues: draft.replacement.issues.map((issue) => ({
            ...issue,
            rowKey: issue.rowKey ?? "",
            componentKey: issue.componentKey ?? "",
          })),
          hasSnapshot: draft.replacement.snapshot !== null,
          snapshot: draft.replacement.snapshot ?? {
            key: "",
            amountMinor: 0,
            currency: "ZAR",
            economicNature: "asset",
            asOf: "",
            recordedAt: draft.operation.recordedAt,
          },
          operation: operationVars(draft.operation),
        },
      );
      const result = transactionResult<{
        supersededImport: Raw;
        replacementImport: Raw;
        reconciliation: Raw | null;
        operation: Raw;
      }>(response, "supersededImport");
      return {
        supersededImport: normalizeSourceImport(result.supersededImport),
        replacementImport: normalizeSourceImport(result.replacementImport),
        reconciliation: result.reconciliation
          ? normalizeStatementReconciliation(result.reconciliation)
          : null,
        operation: normalizeStatementResolutionOperation(result.operation),
      };
    } catch (error) {
      const replay = await this.getResolutionOperation(
        draft.operation.command as StatementResolutionCommand,
        draft.operation.idempotencyKey,
      );
      if (replay) {
        if (replay.requestHash !== draft.operation.requestHash) {
          throw new RavenDomainError(
            "IDEMPOTENCY_CONFLICT",
            "Statement source supersession idempotency conflict",
          );
        }
        const importIds = replay.resultRefs.filter((ref) =>
          ref.startsWith("statementImport:"),
        );
        const [oldImport, newImport] = await Promise.all(
          importIds.slice(0, 2).map((id) => this.getImport(id)),
        );
        if (oldImport && newImport) {
          return {
            supersededImport: oldImport,
            replacementImport: newImport,
            reconciliation: await this.getStatementReconciliation(oldImport.id),
            operation: replay,
          };
        }
      }
      const message = error instanceof Error ? error.message : String(error);
      if (/STATEMENT_SOURCE_SUPERSESSION_CONFLICT/.test(message)) {
        throw new RavenDomainError(
          "STATEMENT_SOURCE_SUPERSESSION_CONFLICT",
          "The active source or replacement claims changed",
        );
      }
      try {
        await this.throwSourceSupersessionConflict(draft);
      } catch (recoveryError) {
        if (recoveryError instanceof RavenDomainError) throw recoveryError;
      }
      rethrowResolutionError(error);
    }
  }

  async recalculateStatementReconciliation(
    draft: StatementReconciliationMutationDraft,
  ): Promise<StatementReconciliationRepositoryResult> {
    return this.persistReconciliationMutation(draft);
  }

  async attestStatementReconciled(
    draft: StatementAttestationDraft,
  ): Promise<StatementReconciliationRepositoryResult> {
    return this.persistAttestation(draft);
  }

  async reopenStatementReconciliation(
    draft: StatementReopeningDraft,
  ): Promise<StatementReconciliationRepositoryResult> {
    return this.persistReopening(draft);
  }

  private async recoverMatchMutation(
    operation: StatementMatchMutationDraft["operation"],
    error: unknown,
    validation?: StatementMatchMutationDraft["validation"],
  ): Promise<StatementMatchRepositoryResult> {
    const replay = await this.getResolutionOperation(
      operation.command as StatementResolutionCommand,
      operation.idempotencyKey,
    );
    if (replay) {
      if (replay.requestHash !== operation.requestHash) {
        throw new RavenDomainError(
          "IDEMPOTENCY_CONFLICT",
          "Idempotency key was already used for a different statement resolution command",
        );
      }
      const matchId = replay.resultRefs.find((ref) =>
        ref.startsWith("statementTransactionMatch:"),
      );
      const match = matchId
        ? await this.getStatementTransactionMatch(matchId)
        : null;
      if (match) {
        return {
          match,
          reconciliation: await this.getStatementReconciliation(
            match.statementImportId,
          ),
          operation: replay,
        };
      }
    }
    if (validation) {
      await this.throwActiveClaimConflict(validation);
    }
    rethrowResolutionError(error);
  }

  private async throwActiveClaimConflict(
    validation: StatementMatchMutationDraft["validation"],
  ): Promise<void> {
    const response = await this.client.query(
      `LET $transactionId = type::record("transaction", $transactionKey);
       RETURN {
         componentClaimCount: array::len(SELECT id FROM statementComponentResolutionClaim
           WHERE record::id(statementRowComponent) IN $componentKeys AND state = "active"),
         transactionClaimCount: array::len(SELECT id FROM statementTransactionResolutionClaim
           WHERE transaction = $transactionId AND state = "active"),
         transactionMatched: (SELECT VALUE statementMatch FROM ONLY $transactionId) != NONE
       };`,
      {
        componentKeys: validation.componentIds.map(recordKey),
        transactionKey: recordKey(validation.transactionId),
      },
    );
    const state = unwrap(response)
      .flatMap((value) => (Array.isArray(value) ? value : [value]))
      .find((value): value is Raw =>
        Boolean(value && typeof value === "object"),
      );
    if (Number(state?.componentClaimCount ?? 0) > 0) {
      throw new RavenDomainError(
        "STATEMENT_COMPONENT_ALREADY_DISPOSED",
        "A movement component already has an active statement resolution",
      );
    }
    if (
      Number(state?.transactionClaimCount ?? 0) > 0 ||
      state?.transactionMatched === true
    ) {
      throw new RavenDomainError(
        "STATEMENT_TRANSACTION_ALREADY_MATCHED",
        "Transaction already has an active statement resolution",
      );
    }
  }

  private async throwSourceSupersessionConflict(
    draft: StatementImportSupersessionDraft,
  ): Promise<void> {
    const response = await this.client.query(
      `LET $oldImportId = type::record("statementImport", $oldImportKey);
       LET $oldImport = SELECT * FROM ONLY $oldImportId;
       LET $accountContext = IF $oldImport {
         SELECT *, space.active AS spaceActive, space.timezone AS spaceTimezone
           FROM ONLY $oldImport.account
       } ELSE { NONE };
       LET $accountCurrency = IF $accountContext.currency = NONE OR $accountContext.currency = ""
         THEN "ZAR" ELSE <string> $accountContext.currency END;
       LET $accountNature = IF $accountContext.normalNature = "liability"
         THEN "liability" ELSE "asset" END;
       LET $accountLast4 = IF $accountContext.accountNumberLast4 = NONE
         THEN "" ELSE <string> $accountContext.accountNumberLast4 END;
       LET $accountTimezone = IF $accountContext.spaceTimezone = NONE OR $accountContext.spaceTimezone = ""
         THEN "Africa/Johannesburg" ELSE <string> $accountContext.spaceTimezone END;
       LET $reconciliationId = type::record("statementReconciliation", fn::stringID([$oldImportId, "current"]));
       LET $current = SELECT * FROM ONLY $reconciliationId;
       LET $oldSourceClaimId = IF $oldImport {
         type::record("statementSourceClaim", fn::stringID([$oldImport.account, $oldImport.originalFileSha256]))
       } ELSE { NONE };
       LET $newSourceClaimId = IF $oldImport {
         type::record("statementSourceClaim", fn::stringID([$oldImport.account, $replacementOriginalHash]))
       } ELSE { NONE };
       LET $periodClaimId = IF $oldImport {
         type::record("statementPeriodClaim", fn::stringID([$oldImport.account, $oldImport.periodStart, $oldImport.periodEnd]))
       } ELSE { NONE };
       LET $oldSourceClaim = IF $oldSourceClaimId { SELECT * FROM ONLY $oldSourceClaimId } ELSE { NONE };
       LET $newSourceClaim = IF $newSourceClaimId { SELECT * FROM ONLY $newSourceClaimId } ELSE { NONE };
       LET $periodClaim = IF $periodClaimId { SELECT * FROM ONLY $periodClaimId } ELSE { NONE };
       RETURN {
         sourceConflict: !$oldImport OR $oldImport.sourceState != "committed"
           OR $oldImport.revision != <int> $expectedSourceRevision,
         accountConflict: !$accountContext OR $accountContext.active != true
           OR $accountContext.spaceActive != true
           OR $accountContext.space != type::record("financialSpace", $expectedSpaceKey)
           OR $accountContext.key != $expectedAccountKey
           OR $accountCurrency != $expectedCurrency
           OR $accountNature != $expectedNature
           OR $accountLast4 != $expectedLast4
           OR $accountTimezone != $expectedTimezone
           OR $oldImport.accountContextFingerprint != $expectedFingerprint,
         reconciliationConflict: ($hasExpectedReconciliation
             AND (!$current OR $current.revision != <int> $expectedReconciliationRevision
               OR $current.calculationHash != $expectedReconciliationHash))
           OR (!$hasExpectedReconciliation AND $current),
         sourceClaimConflict: !$oldSourceClaim OR $oldSourceClaim.state != "active"
           OR $oldSourceClaim.statementImport != $oldImportId,
         periodClaimConflict: !$periodClaim OR $periodClaim.state != "active"
           OR $periodClaim.statementImport != $oldImportId,
         newSourceClaimConflict: $newSourceClaim AND $newSourceClaim.state = "active"
       };`,
      {
        oldImportKey: recordKey(draft.oldImportId),
        expectedSourceRevision: draft.expectedSourceRevision,
        replacementOriginalHash:
          draft.replacement.statementImport.originalFileSha256,
        expectedSpaceKey: recordKey(
          draft.replacement.expectedAccountContext.spaceId,
        ),
        expectedAccountKey: draft.replacement.expectedAccountContext.accountKey,
        expectedCurrency: draft.replacement.expectedAccountContext.currency,
        expectedNature: draft.replacement.expectedAccountContext.normalNature,
        expectedLast4:
          draft.replacement.expectedAccountContext.accountNumberLast4 ?? "",
        expectedTimezone:
          draft.replacement.expectedAccountContext.spaceTimezone,
        expectedFingerprint:
          draft.replacement.expectedAccountContext.accountContextFingerprint,
        hasExpectedReconciliation:
          draft.expectedReconciliationRevision !== null,
        expectedReconciliationRevision:
          draft.expectedReconciliationRevision ?? 0,
        expectedReconciliationHash: draft.expectedReconciliationHash ?? "",
      },
    );
    const state = rows<Raw>(response)[0];
    if (!state) return;
    if (state.sourceConflict) {
      throw new RavenDomainError(
        "STATEMENT_SOURCE_SUPERSESSION_CONFLICT",
        "The active source revision changed during replacement",
      );
    }
    if (state.accountConflict) {
      throw new RavenDomainError(
        "STATEMENT_ACCOUNT_CONTEXT_STALE",
        "The Account context changed during source replacement",
      );
    }
    if (state.reconciliationConflict) {
      throw new RavenDomainError(
        "STATEMENT_RECONCILIATION_STALE",
        "Reconciliation authority changed during source replacement",
      );
    }
    if (state.sourceClaimConflict || state.newSourceClaimConflict) {
      throw new RavenDomainError(
        "STATEMENT_SOURCE_CLAIM_CONFLICT",
        "Statement source claim ownership changed during replacement",
      );
    }
    if (state.periodClaimConflict) {
      throw new RavenDomainError(
        "STATEMENT_PERIOD_CLAIM_CONFLICT",
        "Statement period claim ownership changed during replacement",
      );
    }
  }

  private async mutateMatchState(
    draft: StatementRejectionDraft,
    state: "rejected",
  ): Promise<StatementMatchRepositoryResult> {
    try {
      const response = await this.client.query(
        `BEGIN TRANSACTION;
         LET $matchId = type::record("statementTransactionMatch", $matchKey);
         LET $current = SELECT * FROM ONLY $matchId;
         IF !$current OR $current.state != "proposed" OR $current.revision != <int> $expectedRevision {
           THROW "STATEMENT_MATCH_CONFLICT";
         };
         LET $statementImportId = $current.statementImport;
         LET $resultRefs = [type::string($matchId)];
         ${CREATE_OPERATION}
         LET $matchRecord = UPDATE ONLY $matchId SET
           state = $state, revision += 1,
           rejectedOperation = $operationId, rejectedAt = $recordedAt,
           rejectionReason = $reason,
           reviewedBy = IF $hasActorId THEN $actorId ELSE NONE END;
         ${UPSERT_RECONCILIATION}
         RETURN { match: $matchRecord, reconciliation: $reconciliationRecord, operation: $operationRecord };
         COMMIT TRANSACTION;`,
        {
          matchKey: recordKey(draft.matchId),
          expectedRevision: draft.expectedRevision,
          state,
          reason: draft.reason,
          recordedAt: draft.rejectedAt,
          hasActorId: Boolean(draft.actorId),
          actorId: draft.actorId ?? "",
          operation: operationVars(draft.operation),
          reconciliation: reconciliationWithKeys(draft.reconciliation),
          ...reconciliationExpectationVars(draft),
        },
      );
      return normalizeMatchResult(response);
    } catch (error) {
      return this.recoverMatchMutation(draft.operation, error);
    }
  }

  private async persistReconciliationMutation(
    draft: StatementReconciliationMutationDraft,
  ): Promise<StatementReconciliationRepositoryResult> {
    try {
      const response = await this.client.query(
        `BEGIN TRANSACTION;
         LET $statementImportId = type::record("statementImport", $importKey);
         LET $reconciliationId = type::record("statementReconciliation", fn::stringID([$statementImportId, "current"]));
         LET $current = SELECT * FROM ONLY $reconciliationId;
         IF ($hasExpectedRevision AND (!$current
             OR $current.revision != <int> $expectedRevision
             OR $current.calculationHash != $expectedHash))
           OR (!$hasExpectedRevision AND $current) {
           THROW "STATEMENT_RECONCILIATION_STALE";
         };
         LET $resultRefs = [type::string($reconciliationId)];
         ${CREATE_OPERATION}
         ${UPSERT_RECONCILIATION}
         RETURN { reconciliation: $reconciliationRecord, event: $automaticReopeningEvent, operation: $operationRecord };
         COMMIT TRANSACTION;`,
        {
          importKey: recordKey(draft.statementImportId),
          hasExpectedRevision: draft.expectedRevision !== null,
          expectedRevision: draft.expectedRevision ?? 0,
          expectedHash: draft.expectedHash ?? "",
          operation: operationVars(draft.operation),
          reconciliation: reconciliationWithKeys(draft.reconciliation),
          ...reconciliationExpectationVars({
            expectedReconciliationRevision: draft.expectedRevision,
            expectedReconciliationHash: draft.expectedHash,
          }),
        },
      );
      return normalizeReconciliationResult(response);
    } catch (error) {
      return this.recoverReconciliationMutation(draft.operation, error);
    }
  }

  private async persistAttestation(
    draft: StatementAttestationDraft,
  ): Promise<StatementReconciliationRepositoryResult> {
    try {
      const response = await queryWithResponses(
        this.client,
        `BEGIN TRANSACTION;
         LET $statementImportId = type::record("statementImport", $importKey);
         LET $activeImport = SELECT * FROM ONLY $statementImportId;
         IF !$activeImport OR $activeImport.sourceState != "committed" { THROW "STATEMENT_IMPORT_SUPERSEDED"; };
         LET $accountContext = SELECT *, space.active AS spaceActive,
           space.timezone AS spaceTimezone FROM ONLY $activeImport.account;
         LET $accountLast4 = IF $accountContext.accountNumberLast4 = NONE
           THEN "" ELSE <string> $accountContext.accountNumberLast4 END;
         LET $accountCurrency = IF $accountContext.currency = NONE OR $accountContext.currency = ""
           THEN "ZAR" ELSE <string> $accountContext.currency END;
         LET $accountNature = IF $accountContext.normalNature = "liability"
           OR (
             $accountContext.normalNature = NONE
             AND $accountContext.accountType IN ["credit_card", "loan", "debt"]
           )
           THEN "liability" ELSE "asset" END;
         LET $accountTimezone = IF $accountContext.spaceTimezone = NONE OR $accountContext.spaceTimezone = ""
           THEN "Africa/Johannesburg" ELSE <string> $accountContext.spaceTimezone END;
         IF !$accountContext OR $accountContext.active != true
           OR $accountContext.spaceActive != true
           OR $accountContext.space != type::record("financialSpace", $expectedAccount.spaceKey)
           OR $accountContext.key != $expectedAccount.accountKey
           OR $accountCurrency != $expectedAccount.currency
           OR $accountNature != $expectedAccount.normalNature
           OR $accountLast4 != $expectedAccount.accountNumberLast4
           OR $accountTimezone != $expectedAccount.spaceTimezone
           OR $activeImport.accountContextFingerprint != $expectedAccount.accountContextFingerprint {
           THROW "STATEMENT_ACCOUNT_CONTEXT_STALE";
         };
         LET $sourceClaimId = type::record("statementSourceClaim", fn::stringID([
           $activeImport.account, $activeImport.originalFileSha256
         ]));
         LET $periodClaimId = type::record("statementPeriodClaim", fn::stringID([
           $activeImport.account, $activeImport.periodStart, $activeImport.periodEnd
         ]));
         LET $sourceClaim = SELECT * FROM ONLY $sourceClaimId;
         LET $periodClaim = SELECT * FROM ONLY $periodClaimId;
         IF !$sourceClaim OR $sourceClaim.state != "active"
           OR $sourceClaim.statementImport != $statementImportId {
           THROW "STATEMENT_SOURCE_CLAIM_CONFLICT";
         };
         IF !$periodClaim OR $periodClaim.state != "active"
           OR $periodClaim.statementImport != $statementImportId {
           THROW "STATEMENT_PERIOD_CLAIM_CONFLICT";
         };
         LET $reconciliationId = type::record("statementReconciliation", fn::stringID([$statementImportId, "current"]));
         LET $current = SELECT * FROM ONLY $reconciliationId;
         IF !$current OR $current.revision != <int> $expectedRevision
           OR $current.calculationHash != $calculationHash { THROW "STATEMENT_RECONCILIATION_STALE"; };
         IF $current.attestationState = "reconciled" { THROW "STATEMENT_RECONCILIATION_ALREADY_ATTESTED"; };
         IF !($current.attestationState IN ["ready", "reopened"])
           OR $current.coverageState != "complete"
           OR $current.calculationState != "balanced" OR $current.differenceMinor != 0
           OR $current.unresolvedCount != 0 OR $current.blockingIssueCount != 0 {
           THROW "STATEMENT_RECONCILIATION_INCOMPLETE";
         };
         LET $movementComponents = SELECT * FROM statementRowComponent
           WHERE statementImport = $statementImportId
             AND sourceState = "committed" AND componentRole = "movement";
         LET $activeClaims = SELECT * FROM statementComponentResolutionClaim
           WHERE statementImport = $statementImportId AND state = "active";
         LET $confirmedMatches = SELECT * FROM statementTransactionMatch
           WHERE statementImport = $statementImportId
             AND state = "confirmed" AND sourceState = "committed";
         LET $activeTransactionClaims = SELECT * FROM statementTransactionResolutionClaim
           WHERE statementImport = $statementImportId AND state = "active";
         IF array::len($movementComponents) != $current.movementComponentCount
           OR array::len($activeClaims) != array::len($movementComponents)
           OR array::len($activeTransactionClaims) != array::len($confirmedMatches) {
           THROW "STATEMENT_RECONCILIATION_STALE";
         };
         FOR $component IN $movementComponents {
           LET $claimId = type::record(
             "statementComponentResolutionClaim",
             fn::stringID([$component.id, "active"])
           );
           LET $claim = SELECT * FROM ONLY $claimId;
           IF !$claim OR $claim.state != "active"
             OR $claim.statementRowComponent != $component.id
             OR $claim.statementImport != $statementImportId {
             THROW "STATEMENT_RECONCILIATION_STALE";
           };
         };
         FOR $claim IN $activeClaims {
           LET $match = SELECT * FROM ONLY $claim.statementTransactionMatch;
           LET $transaction = SELECT * FROM ONLY $claim.transaction;
           LET $transactionClaimId = type::record(
             "statementTransactionResolutionClaim",
             fn::stringID([$claim.transaction, "active"])
           );
           LET $transactionClaim = SELECT * FROM ONLY $transactionClaimId;
           IF !$match OR $match.state != "confirmed" OR $match.sourceState != "committed"
             OR $match.statementImport != $statementImportId
             OR $match.transaction != $claim.transaction
             OR !$transaction OR $transaction.statementMatch != $match.id
             OR !$transactionClaim OR $transactionClaim.state != "active"
             OR $transactionClaim.statementImport != $statementImportId
             OR $transactionClaim.statementTransactionMatch != $match.id
             OR $transactionClaim.transaction != $claim.transaction {
             THROW "STATEMENT_RECONCILIATION_STALE";
           };
         };
         FOR $match IN $confirmedMatches {
           IF array::len($match.componentIds) = 0 {
             THROW "STATEMENT_RECONCILIATION_STALE";
           };
           FOR $componentIdString IN $match.componentIds {
             LET $componentId = IF type::is_record($componentIdString)
               THEN $componentIdString
               ELSE type::record(
                 "statementRowComponent",
                 string::slice(type::string($componentIdString), string::len("statementRowComponent:"))
               )
             END;
             LET $claimId = type::record(
               "statementComponentResolutionClaim",
               fn::stringID([$componentId, "active"])
             );
             LET $claim = SELECT * FROM ONLY $claimId;
             IF !$claim OR $claim.state != "active"
               OR $claim.statementTransactionMatch != $match.id
               OR $claim.transaction != $match.transaction {
               THROW "STATEMENT_RECONCILIATION_STALE";
             };
           };
         };
         LET $eventKey = string::concat("attested-", $operation.key);
         LET $eventId = type::record("statementReconciliationEvent", fn::stringID([$reconciliationId, $eventKey]));
         LET $resultRefs = [type::string($reconciliationId), type::string($eventId)];
         ${CREATE_OPERATION}
         LET $eventRecord = CREATE ONLY $eventId CONTENT {
           space: $current.space, account: $current.account,
           statementImport: $statementImportId,
           statementReconciliation: $reconciliationId, key: $eventKey,
           eventType: "attested", reconciliationRevision: <int> ($current.revision + 1),
           calculationHash: $current.calculationHash,
           calculationSnapshot: $current, reason: NONE,
           actorId: IF $operation.hasActorId THEN $operation.actorId ELSE NONE END,
           channel: $operation.channel, operation: $operationId,
           recordedAt: $attestedAt
         };
         LET $reconciliationRecord = UPDATE ONLY $reconciliationId SET
           attestationState = "reconciled", revision += 1,
           latestAttestationOperation = $operationId, attestedAt = $attestedAt;
         RETURN { reconciliation: $reconciliationRecord, event: $eventRecord, operation: $operationRecord };
         COMMIT TRANSACTION;`,
        {
          importKey: recordKey(draft.statementImportId),
          expectedRevision: draft.expectedRevision,
          calculationHash: draft.calculationHash,
          expectedAccount: {
            ...draft.expectedAccountContext,
            spaceKey: recordKey(draft.expectedAccountContext.spaceId),
            accountNumberLast4:
              draft.expectedAccountContext.accountNumberLast4 ?? "",
          },
          attestedAt: draft.attestedAt,
          operation: operationVars(draft.operation),
        },
      );
      return normalizeReconciliationResult(response);
    } catch (error) {
      return this.recoverReconciliationMutation(draft.operation, error);
    }
  }

  private async persistReopening(
    draft: StatementReopeningDraft,
  ): Promise<StatementReconciliationRepositoryResult> {
    try {
      const response = await this.client.query(
        `BEGIN TRANSACTION;
         LET $statementImportId = type::record("statementImport", $importKey);
         LET $reconciliationId = type::record("statementReconciliation", fn::stringID([$statementImportId, "current"]));
         LET $current = SELECT * FROM ONLY $reconciliationId;
         IF !$current OR $current.revision != <int> $expectedRevision
           OR $current.calculationHash != $calculationHash
           OR $current.attestationState != "reconciled" { THROW "STATEMENT_RECONCILIATION_STALE"; };
         LET $eventKey = string::concat("reopened-", $operation.key);
         LET $eventId = type::record("statementReconciliationEvent", fn::stringID([$reconciliationId, $eventKey]));
         LET $resultRefs = [type::string($reconciliationId), type::string($eventId)];
         ${CREATE_OPERATION}
         LET $eventRecord = CREATE ONLY $eventId CONTENT {
           space: $current.space, account: $current.account,
           statementImport: $statementImportId,
           statementReconciliation: $reconciliationId, key: $eventKey,
           eventType: "reopened", reconciliationRevision: <int> ($current.revision + 1),
           calculationHash: $current.calculationHash,
           calculationSnapshot: $current, reason: $reason,
           actorId: IF $operation.hasActorId THEN $operation.actorId ELSE NONE END,
           channel: $operation.channel, operation: $operationId,
           recordedAt: $reopenedAt
         };
         LET $reconciliationRecord = UPDATE ONLY $reconciliationId SET
           attestationState = "reopened", revision += 1,
           latestReopeningOperation = $operationId, reopenedAt = $reopenedAt;
         RETURN { reconciliation: $reconciliationRecord, event: $eventRecord, operation: $operationRecord };
         COMMIT TRANSACTION;`,
        {
          importKey: recordKey(draft.statementImportId),
          expectedRevision: draft.expectedRevision,
          calculationHash: draft.calculationHash,
          reason: draft.reason,
          reopenedAt: draft.reopenedAt,
          operation: operationVars(draft.operation),
        },
      );
      return normalizeReconciliationResult(response);
    } catch (error) {
      return this.recoverReconciliationMutation(draft.operation, error);
    }
  }

  private async getIssue(id: string) {
    const response = await this.client.query(
      `SELECT * FROM type::record("statementIssue", $key) LIMIT 1;`,
      { key: recordKey(id) },
    );
    const value = rows<Raw>(response)[0];
    return value ? normalizeIssue(value) : null;
  }

  private async getImport(id: string): Promise<StatementImportRecord | null> {
    const response = await this.client.query(
      `SELECT *, space.key AS spaceKey, account.key AS accountKey
       FROM type::record("statementImport", $key) LIMIT 1;`,
      { key: recordKey(id) },
    );
    const value = rows<Raw>(response)[0];
    return value ? normalizeSourceImport(value) : null;
  }

  private async recoverReconciliationMutation(
    operation: StatementReconciliationMutationDraft["operation"],
    error: unknown,
  ): Promise<StatementReconciliationRepositoryResult> {
    const replay = await this.getResolutionOperation(
      operation.command as StatementResolutionCommand,
      operation.idempotencyKey,
    );
    if (replay) {
      if (replay.requestHash !== operation.requestHash) {
        throw new RavenDomainError(
          "IDEMPOTENCY_CONFLICT",
          "Idempotency key was already used for a different statement resolution command",
        );
      }
      const reconciliationId = replay.resultRefs.find((ref) =>
        ref.startsWith("statementReconciliation:"),
      );
      if (reconciliationId) {
        const response = await this.client.query(
          `SELECT * FROM type::record("statementReconciliation", $key) LIMIT 1;`,
          { key: recordKey(reconciliationId) },
        );
        const raw = rows<Raw>(response)[0];
        if (raw) {
          const reconciliation = normalizeStatementReconciliation(raw);
          const eventId = replay.resultRefs.find((ref) =>
            ref.startsWith("statementReconciliationEvent:"),
          );
          const events = await this.listStatementReconciliationEvents(
            reconciliation.statementImportId,
          );
          return {
            reconciliation,
            event: events.find((item) => item.id === eventId) ?? null,
            operation: replay,
          };
        }
      }
    }
    rethrowResolutionError(error);
  }
}

function normalizeIssue(raw: Raw) {
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? ""),
    spaceId: recordId(raw.space),
    accountId: recordId(raw.account),
    statementImportId: recordId(raw.statementImport),
    statementRowId: raw.statementRow ? recordId(raw.statementRow) : null,
    statementRowComponentId: raw.statementRowComponent
      ? recordId(raw.statementRowComponent)
      : null,
    code: String(
      raw.code,
    ) as import("@raven/domain/server").StatementIssueRecord["code"],
    severity:
      raw.severity as import("@raven/domain/server").StatementIssueRecord["severity"],
    blocking: raw.blocking === true,
    state:
      raw.state as import("@raven/domain/server").StatementIssueRecord["state"],
    message: String(raw.message ?? ""),
    revision: Number(raw.revision ?? 1),
    detectedOperationId: recordId(raw.detectedOperation),
    dispositionOperationId: raw.dispositionOperation
      ? recordId(raw.dispositionOperation)
      : null,
    detectedAt: String(raw.detectedAt ?? ""),
    acknowledgedAt: nullableString(raw.acknowledgedAt),
    resolvedAt: nullableString(raw.resolvedAt),
    reviewedBy: nullableString(raw.reviewedBy),
    notes: nullableString(raw.notes),
  };
}

function normalizeSourceImport(raw: Raw): StatementImportRecord {
  const coverage =
    raw.coverage && typeof raw.coverage === "object"
      ? (raw.coverage as Raw)
      : null;
  return {
    id: recordId(raw.id),
    spaceId: recordId(raw.space),
    accountId: recordId(raw.account),
    spaceKey: String(raw.spaceKey ?? ""),
    accountKey: String(raw.accountKey ?? ""),
    key: String(raw.key ?? ""),
    privateSourceRef: String(raw.privateSourceRef ?? ""),
    extractionAssistRef: nullableString(raw.extractionAssistRef),
    originalFileSha256: String(raw.originalFileSha256 ?? ""),
    extractionInputSha256: nullableString(raw.extractionInputSha256),
    canonicalExtractionSha256: String(raw.canonicalExtractionSha256 ?? ""),
    previewHash: String(raw.previewHash ?? ""),
    sourceKind: raw.sourceFormat as StatementImportRecord["sourceKind"],
    sourceMimeType: String(raw.sourceMimeType ?? ""),
    sourceByteSize: Number(raw.sourceByteSize ?? 0),
    profile: {
      profileId: String(raw.profileId ?? ""),
      profileVersion: String(raw.profileVersion ?? ""),
      extractorVersion: String(raw.extractorVersion ?? ""),
    },
    validationRulesetVersion: String(raw.validationRulesetVersion ?? ""),
    periodStart: String(raw.periodStart ?? ""),
    periodEnd: String(raw.periodEnd ?? ""),
    currency: String(raw.currency ?? "ZAR"),
    balanceConvention:
      raw.balanceConvention === "positive_is_asset" ||
      raw.balanceConvention === "positive_is_liability"
        ? raw.balanceConvention
        : null,
    balanceConventionAuthority:
      raw.balanceConventionAuthority === "profile" ||
      raw.balanceConventionAuthority === "operator_unverified"
        ? raw.balanceConventionAuthority
        : null,
    accountContextFingerprint: String(raw.accountContextFingerprint ?? ""),
    openingBalanceMinor: Number.isSafeInteger(raw.openingBalanceMinor)
      ? Number(raw.openingBalanceMinor)
      : null,
    closingBalanceMinor: Number.isSafeInteger(raw.closingBalanceMinor)
      ? Number(raw.closingBalanceMinor)
      : null,
    closingBalanceEconomicNature:
      raw.closingBalanceEconomicNature === "asset" ||
      raw.closingBalanceEconomicNature === "liability"
        ? raw.closingBalanceEconomicNature
        : null,
    coverage: coverage
      ? {
          status:
            coverage.status === "complete" ||
            coverage.status === "incomplete" ||
            coverage.status === "indeterminate"
              ? coverage.status
              : "indeterminate",
          sourcePageCount: Number.isSafeInteger(coverage.sourcePageCount)
            ? Number(coverage.sourcePageCount)
            : null,
          processedPages: Array.isArray(coverage.processedPages)
            ? coverage.processedPages.map(Number)
            : [],
          sourceSections: Array.isArray(coverage.sourceSections)
            ? coverage.sourceSections.map(String)
            : [],
          processedSections: Array.isArray(coverage.processedSections)
            ? coverage.processedSections.map(String)
            : [],
          printedRowCount: Number.isSafeInteger(coverage.printedRowCount)
            ? Number(coverage.printedRowCount)
            : null,
          extractedRowCount: Number(coverage.extractedRowCount ?? 0),
        }
      : null,
    sourceState:
      raw.sourceState === "committed" || raw.sourceState === "superseded"
        ? raw.sourceState
        : "legacy",
    importedAt: String(raw.importedAt ?? ""),
    committedAt: String(raw.committedAt ?? ""),
    commitOperationId: raw.commitOperation
      ? recordId(raw.commitOperation)
      : null,
    replacementOfId: raw.replacementOf ? recordId(raw.replacementOf) : null,
    rowCount: Number(raw.rowCount ?? 0),
    componentCount: Number(raw.componentCount ?? 0),
    issueCount: Number(raw.issueCount ?? 0),
    revision: Number(raw.revision ?? 1),
    legacyPeriodEvidence: {
      statementDate: nullableString(raw.statementDate)?.slice(0, 10) ?? null,
      keyDate: String(raw.key ?? "").match(/^\d{4}-\d{2}-\d{2}/)?.[0] ?? null,
      mapping: "not_legacy",
    },
  };
}

function sourceImportVars(
  value: StatementImportSupersessionDraft["replacement"]["statementImport"],
) {
  return {
    ...value,
    spaceKey: recordKey(value.spaceId),
    accountKey: recordKey(value.accountId),
    profileId: value.profile.profileId,
    profileVersion: value.profile.profileVersion,
    extractorVersion: value.profile.extractorVersion,
    hasExtractionAssist: value.extractionAssistRef !== null,
    extractionAssistRef: value.extractionAssistRef ?? "",
    hasExtractionInputSha256: value.extractionInputSha256 !== null,
    extractionInputSha256: value.extractionInputSha256 ?? "",
    hasOpeningBalance: value.openingBalanceMinor !== null,
    openingBalanceMinor: value.openingBalanceMinor ?? 0,
    hasClosingBalance: value.closingBalanceMinor !== null,
    closingBalanceMinor: value.closingBalanceMinor ?? 0,
    hasClosingBalanceEconomicNature:
      value.closingBalanceEconomicNature !== null,
    closingBalanceEconomicNature: value.closingBalanceEconomicNature ?? "asset",
  };
}

function sourceRowsVars(
  values: StatementImportSupersessionDraft["replacement"]["rows"],
) {
  return values.map((row) => ({
    ...row,
    hasTransactionDate: row.transactionDate !== null,
    transactionDate: row.transactionDate ?? "",
    hasPostingDate: row.postingDate !== null,
    postingDate: row.postingDate ?? "",
    hasValueDate: row.valueDate !== null,
    valueDate: row.valueDate ?? "",
    hasSourceReference: row.sourceReference !== null,
    sourceReference: row.sourceReference ?? "",
    hasReportedBalance: row.reportedBalanceMinor !== null,
    reportedBalanceMinor: row.reportedBalanceMinor ?? 0,
    hasLocator: row.locator !== null,
    locator: row.locator ?? {},
  }));
}

function sourceComponentsVars(
  values: StatementImportSupersessionDraft["replacement"]["components"],
) {
  return values.map((component) => ({
    ...component,
    hasTransactionDate: component.transactionDate !== null,
    transactionDate: component.transactionDate ?? "",
    hasPostingDate: component.postingDate !== null,
    postingDate: component.postingDate ?? "",
    hasValueDate: component.valueDate !== null,
    valueDate: component.valueDate ?? "",
    hasSourceReference: component.sourceReference !== null,
    sourceReference: component.sourceReference ?? "",
    hasLocator: component.locator !== null,
    locator: component.locator ?? {},
  }));
}

function normalizeReconciliationResult(
  response: unknown,
): StatementReconciliationRepositoryResult {
  const result = transactionResult<{
    reconciliation: Raw;
    event: Raw | null;
    operation: Raw;
  }>(response, "reconciliation");
  return {
    reconciliation: normalizeStatementReconciliation(result.reconciliation),
    event: result.event ? normalizeEvent(result.event) : null,
    operation: normalizeStatementResolutionOperation(result.operation),
  };
}

function normalizeMatchResult(
  response: unknown,
): StatementMatchRepositoryResult {
  const result = transactionResult<{
    match: Raw;
    reconciliation: Raw;
    operation: Raw;
  }>(response, "match");
  return {
    match: normalizeStatementTransactionMatch(result.match),
    reconciliation: result.reconciliation
      ? normalizeStatementReconciliation(result.reconciliation)
      : null,
    operation: normalizeStatementResolutionOperation(result.operation),
  };
}

function offsetDate(value: string, days: number): string {
  const date = new Date(`${value}T00:00:00.000Z`);
  date.setUTCDate(date.getUTCDate() + days);
  return date.toISOString().slice(0, 10);
}

export function createSurrealStatementResolutionRepository(
  client: SurrealQueryClient,
): StatementResolutionRepository {
  return new SurrealStatementResolutionRepository(client);
}
