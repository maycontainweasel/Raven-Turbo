import { RavenDomainError } from "./errors.js";
import {
  canonicalStatementJson,
  statementSha256,
} from "./statement-adapters.js";
import type {
  StatementLegacyAggregateCounts,
  StatementLegacyCanonicalComponent,
  StatementLegacyCompatibilityClass,
  StatementLegacyEvidence,
  StatementLegacyResolutionDecision,
  StatementLegacyResolutionItemPlan,
  StatementLegacyResolutionPlan,
  StatementLegacyStrategy,
  StatementLegacyPreviewContext,
} from "./statement-legacy-resolution-contracts.js";

const classes: readonly StatementLegacyCompatibilityClass[] = [
  "exact_existing_transaction_adoption",
  "exact_grouped_component_adoption",
  "canonical_component_requires_materialization",
  "legacy_transaction_historical_only",
  "transfer_review_required",
  "informational_non_movement",
  "ambiguous_or_conflicting",
];

function emptyCounts(): Record<StatementLegacyCompatibilityClass, number> {
  return Object.fromEntries(classes.map((value) => [value, 0])) as Record<
    StatementLegacyCompatibilityClass,
    number
  >;
}

function componentDate(component: {
  transactionDate: string | null;
  postingDate: string | null;
  valueDate: string | null;
}): string | null {
  return (
    component.transactionDate ?? component.postingDate ?? component.valueDate
  );
}

function sourceFlow(effect: number): "inflow" | "outflow" | null {
  if (effect > 0) return "inflow";
  if (effect < 0) return "outflow";
  return null;
}

function itemKey(
  prefix: string,
  components: readonly StatementLegacyCanonicalComponent[],
  transactionIds: readonly string[],
): string {
  return statementSha256(
    canonicalStatementJson({
      prefix,
      components: components.map((entry) => [entry.rowKey, entry.componentKey]),
      transactionIds: [...transactionIds].sort(),
    }),
  ).slice(0, 24);
}

function item(
  value: Omit<
    StatementLegacyResolutionItemPlan,
    "key" | "itemEvidenceHash" | "expectedClaimHash"
  >,
): StatementLegacyResolutionItemPlan {
  const identity = {
    compatibilityClass: value.compatibilityClass,
    activeLedgerOutcome: value.activeLedgerOutcome,
    canonicalComponents: value.canonicalComponents.map((component) => ({
      rowKey: component.rowKey,
      rowNumber: component.rowNumber,
      componentKey: component.componentKey,
      componentRole: component.componentRole,
      sourceChecksum: component.sourceChecksum,
      amountMinor: component.amountMinor,
      balanceEffectMinor: component.balanceEffectMinor,
      currency: component.currency,
      financialDate: component.financialDate,
    })),
    legacyStatementRowId: value.legacyStatementRowId,
    legacyTransactionIds: [...value.legacyTransactionIds].sort(),
    primaryLegacyTransactionId: value.primaryLegacyTransactionId,
    accountTransferId: value.accountTransferId,
  };
  return {
    ...value,
    key: itemKey(
      value.compatibilityClass,
      value.canonicalComponents,
      value.legacyTransactionIds,
    ),
    itemEvidenceHash: statementSha256(canonicalStatementJson(identity)),
    expectedClaimHash: statementSha256(
      canonicalStatementJson({
        transactions: [...value.legacyTransactionIds].sort(),
        outcome: value.activeLedgerOutcome,
      }),
    ),
  };
}

function canonicalComponents(
  context: StatementLegacyPreviewContext,
): StatementLegacyCanonicalComponent[] {
  return context.preview.extraction.rows.flatMap((row) =>
    row.components.map((component) => ({
      rowKey: row.rowKey,
      rowNumber: row.rowNumber,
      componentKey: component.componentKey,
      componentRole: component.componentRole,
      sourceChecksum: component.sourceChecksum,
      amountMinor: component.amountMinor,
      balanceEffectMinor: component.balanceEffectMinor,
      currency: component.currency,
      financialDate: componentDate(component),
    })),
  );
}

function exactCandidates(
  componentGroup: readonly StatementLegacyCanonicalComponent[],
  evidence: StatementLegacyEvidence,
  consumed: ReadonlySet<string>,
) {
  const date = componentGroup[0]?.financialDate ?? null;
  const currency = componentGroup[0]?.currency ?? "";
  const effect = componentGroup.reduce(
    (total, component) => total + component.balanceEffectMinor,
    0,
  );
  const flow = sourceFlow(effect);
  if (!date || !flow || !Number.isSafeInteger(effect)) return [];
  const exact = evidence.legacyTransactions.filter(
    (transaction) =>
      !consumed.has(transaction.id) &&
      transaction.accountId === evidence.legacyStatementImport.accountId &&
      transaction.currency === currency &&
      transaction.amountMinor === Math.abs(effect) &&
      transaction.flowDirection === flow &&
      transaction.postedAt === date &&
      Boolean(transaction.sourceRowId),
  );
  const canonicalRowNumbers = new Set(
    componentGroup.map((component) => component.rowNumber),
  );
  const legacyRowNumberById = new Map(
    evidence.legacyRows.map((row) => [row.id, row.rowNumber]),
  );
  const rowAligned = exact.filter((transaction) => {
    const rowNumber = transaction.sourceRowId
      ? legacyRowNumberById.get(transaction.sourceRowId)
      : undefined;
    return rowNumber !== undefined && canonicalRowNumbers.has(rowNumber);
  });
  const hasSamePositionLegacyEvidence = evidence.legacyRows.some((row) =>
    canonicalRowNumbers.has(row.rowNumber),
  );
  return hasSamePositionLegacyEvidence ? rowAligned : exact;
}

function exactCounterparts(
  transactionId: string,
  evidence: StatementLegacyEvidence,
) {
  const transaction = evidence.legacyTransactions.find(
    (candidate) => candidate.id === transactionId,
  );
  if (
    !transaction ||
    !transaction.postedAt ||
    transaction.amountMinor === null ||
    !transaction.flowDirection
  ) {
    return [];
  }
  return evidence.counterpartTransactions.filter(
    (candidate) =>
      candidate.accountId !== transaction.accountId &&
      candidate.currency === transaction.currency &&
      candidate.amountMinor === transaction.amountMinor &&
      candidate.postedAt === transaction.postedAt &&
      candidate.flowDirection !== null &&
      candidate.flowDirection !== transaction.flowDirection &&
      counterpartDescriptionsCorroborate(
        transaction.description,
        candidate.description,
      ),
  );
}

const TRANSFER_EVIDENCE_STOP_WORDS = new Set([
  "ACCOUNT",
  "BANKING",
  "CREDIT",
  "DEBIT",
  "EXPRESS",
  "FROM",
  "INTERNET",
  "PAYMENT",
  "SUPPLIER",
  "TRANSFER",
  "WITHDRAWAL",
]);

function distinctiveDescriptionTokens(value: string): Set<string> {
  return new Set(
    value
      .normalize("NFKD")
      .toUpperCase()
      .replace(/[^A-Z0-9]+/g, " ")
      .split(" ")
      .filter(
        (token) =>
          token.length >= 4 &&
          !/^\d+$/.test(token) &&
          !TRANSFER_EVIDENCE_STOP_WORDS.has(token),
      ),
  );
}

function counterpartDescriptionsCorroborate(
  primaryDescription: string,
  candidateDescription: string,
): boolean {
  const primary = distinctiveDescriptionTokens(primaryDescription);
  const candidate = distinctiveDescriptionTokens(candidateDescription);
  const shared = [...primary].filter((token) => candidate.has(token));
  return shared.length >= 2 || shared.some((token) => token.length >= 8);
}

function reviewedTransfer(
  transactionId: string,
  counterpartIds: readonly string[],
  evidence: StatementLegacyEvidence,
) {
  return evidence.accountTransfers.find((transfer) => {
    const ids = new Set([
      transfer.sourceTransactionId,
      transfer.targetTransactionId,
    ]);
    return (
      ids.has(transactionId) &&
      counterpartIds.some((counterpartId) => ids.has(counterpartId))
    );
  });
}

function hasActiveCanonicalClaim(
  transactionId: string,
  evidence: StatementLegacyEvidence,
): boolean {
  const transaction = evidence.legacyTransactions.find(
    (candidate) => candidate.id === transactionId,
  );
  return (
    transaction?.hasActiveStatementClaim === true ||
    evidence.activeMatches.some(
      (match) =>
        match.transactionId === transactionId &&
        match.state === "confirmed" &&
        match.sourceState === "committed",
    )
  );
}

function sourceIdentityHash(context: StatementLegacyPreviewContext): string {
  return statementSha256(
    canonicalStatementJson({
      originalFileSha256: context.preview.source.originalFileSha256,
      extractionInputSha256: context.preview.source.extractionInputSha256,
      canonicalExtractionSha256:
        context.preview.extraction.canonicalExtractionSha256,
      profile: context.preview.profile,
    }),
  );
}

function legacyEvidenceHash(evidence: StatementLegacyEvidence): string {
  return statementSha256(
    canonicalStatementJson({
      import: {
        id: evidence.legacyStatementImport.id,
        revision: evidence.legacyStatementImport.revision,
        sourceState: evidence.legacyStatementImport.sourceState,
        accountId: evidence.legacyStatementImport.accountId,
        periodStart: evidence.legacyStatementImport.periodStart,
        periodEnd: evidence.legacyStatementImport.periodEnd,
        currency: evidence.legacyStatementImport.currency,
      },
      rows: evidence.legacyRows.map((row) => ({
        id: row.id,
        rowNumber: row.rowNumber,
        rowKind: row.rowKind,
        rowHash: row.rowHash,
      })),
      transactions: evidence.legacyTransactions.map((transaction) => ({
        id: transaction.id,
        sourceRowId: transaction.sourceRowId,
        accountId: transaction.accountId,
        postedAt: transaction.postedAt,
        amountMinor: transaction.amountMinor,
        currency: transaction.currency,
        flowDirection: transaction.flowDirection,
        entrySource: transaction.entrySource,
        status: transaction.status,
        statementMatchId: transaction.statementMatchId,
        hasActiveStatementClaim: transaction.hasActiveStatementClaim,
        transferId: transaction.transferId,
      })),
      transfers: evidence.accountTransfers.map((transfer) => ({
        id: transfer.id,
        sourceTransactionId: transfer.sourceTransactionId,
        targetTransactionId: transfer.targetTransactionId,
        amountMinor: transfer.amountMinor,
        currency: transfer.currency,
        postedAt: transfer.postedAt,
      })),
    }),
  );
}

function revisionClaimHash(evidence: StatementLegacyEvidence): string {
  return statementSha256(
    canonicalStatementJson({
      importRevision: evidence.legacyStatementImport.revision,
      activeMatches: evidence.activeMatches.map((match) => ({
        id: match.id,
        revision: match.revision,
        state: match.state,
        sourceState: match.sourceState,
      })),
      reconciliation: evidence.reconciliation
        ? {
            id: evidence.reconciliation.id,
            revision: evidence.reconciliation.revision,
            hash: evidence.reconciliation.calculationHash,
            attestationState: evidence.reconciliation.attestationState,
          }
        : null,
      dependentAuthorityHash: evidence.dependentAuthorityHash,
    }),
  );
}

export function planLegacyStatementResolution(
  context: StatementLegacyPreviewContext,
  evidence: StatementLegacyEvidence,
): StatementLegacyResolutionPlan {
  if (
    context.preview.account.accountId !==
      evidence.legacyStatementImport.accountId ||
    context.preview.extraction.currency !== "ZAR" ||
    evidence.legacyStatementImport.currency !== "ZAR"
  ) {
    throw new RavenDomainError(
      "STATEMENT_LEGACY_ACCOUNT_CONTEXT_DRIFT",
      "Canonical and legacy evidence do not share one reviewed ZAR Account",
    );
  }
  if (
    context.preview.account.accountContextFingerprint !==
    evidence.legacyStatementImport.accountContextFingerprint
  ) {
    throw new RavenDomainError(
      "STATEMENT_LEGACY_ACCOUNT_CONTEXT_DRIFT",
      "Legacy Account context changed from the canonical preview",
    );
  }
  if (
    context.preview.extraction.periodStart !==
      evidence.legacyStatementImport.periodStart ||
    context.preview.extraction.periodEnd !==
      evidence.legacyStatementImport.periodEnd
  ) {
    throw new RavenDomainError(
      "STATEMENT_LEGACY_EVIDENCE_DRIFT",
      "Legacy evidence does not cover the canonical preview period",
    );
  }

  const components = canonicalComponents(context);
  const information = components.filter(
    (component) => component.componentRole === "informational_breakdown",
  );
  const movements = components.filter(
    (component) => component.componentRole === "movement",
  );
  const consumed = new Set<string>();
  const items: StatementLegacyResolutionItemPlan[] = [];
  const legacyRowsByNumber = new Map(
    evidence.legacyRows.map((row) => [row.rowNumber, row]),
  );

  for (const component of information) {
    const legacyRow = legacyRowsByNumber.get(component.rowNumber);
    items.push(
      item({
        compatibilityClass: "informational_non_movement",
        activeLedgerOutcome: "informational_only",
        canonicalComponents: [component],
        legacyStatementRowId: legacyRow?.id ?? null,
        legacyTransactionIds: [],
        primaryLegacyTransactionId: null,
        accountTransferId: null,
        blocking: false,
      }),
    );
  }

  const candidatesByComponent = new Map(
    movements.map((component) => [
      component,
      exactCandidates([component], evidence, consumed),
    ]),
  );
  const candidateFrequency = new Map<string, number>();
  for (const candidates of candidatesByComponent.values()) {
    for (const candidate of candidates) {
      candidateFrequency.set(
        candidate.id,
        (candidateFrequency.get(candidate.id) ?? 0) + 1,
      );
    }
  }
  const remaining: StatementLegacyCanonicalComponent[] = [];
  for (const component of movements) {
    const candidates = candidatesByComponent.get(component) ?? [];
    if (
      candidates.length !== 1 ||
      (candidateFrequency.get(candidates[0]!.id) ?? 0) !== 1
    ) {
      remaining.push(component);
      continue;
    }
    const transaction = candidates[0]!;
    if (hasActiveCanonicalClaim(transaction.id, evidence)) {
      consumed.add(transaction.id);
      items.push(
        item({
          compatibilityClass: "ambiguous_or_conflicting",
          activeLedgerOutcome: null,
          canonicalComponents: [component],
          legacyStatementRowId: transaction.sourceRowId ?? null,
          legacyTransactionIds: [transaction.id],
          primaryLegacyTransactionId: transaction.id,
          accountTransferId: null,
          blocking: true,
        }),
      );
      continue;
    }
    const counterparts = exactCounterparts(transaction.id, evidence);
    const transfer = reviewedTransfer(
      transaction.id,
      counterparts.map((candidate) => candidate.id),
      evidence,
    );
    consumed.add(transaction.id);
    const transferBlocked = counterparts.length > 0 && !transfer;
    items.push(
      item({
        compatibilityClass: transferBlocked
          ? "transfer_review_required"
          : "exact_existing_transaction_adoption",
        activeLedgerOutcome: transferBlocked
          ? null
          : transfer
            ? "confirmed_transfer"
            : "adopted_existing",
        canonicalComponents: [component],
        legacyStatementRowId: transaction.sourceRowId ?? null,
        legacyTransactionIds: [
          transaction.id,
          ...counterparts.map((candidate) => candidate.id),
        ],
        primaryLegacyTransactionId: transaction.id,
        accountTransferId: transfer?.id ?? null,
        blocking: transferBlocked,
      }),
    );
  }

  const groupedByRowDate = new Map<
    string,
    StatementLegacyCanonicalComponent[]
  >();
  for (const component of remaining) {
    const key = component.rowKey + "|" + (component.financialDate ?? "");
    groupedByRowDate.set(key, [
      ...(groupedByRowDate.get(key) ?? []),
      component,
    ]);
  }
  for (const group of groupedByRowDate.values()) {
    const groupedCandidates =
      group.length > 1 ? exactCandidates(group, evidence, consumed) : [];
    if (groupedCandidates.length === 1) {
      const transaction = groupedCandidates[0]!;
      if (hasActiveCanonicalClaim(transaction.id, evidence)) {
        consumed.add(transaction.id);
        items.push(
          item({
            compatibilityClass: "ambiguous_or_conflicting",
            activeLedgerOutcome: null,
            canonicalComponents: group,
            legacyStatementRowId: transaction.sourceRowId ?? null,
            legacyTransactionIds: [transaction.id],
            primaryLegacyTransactionId: transaction.id,
            accountTransferId: null,
            blocking: true,
          }),
        );
        continue;
      }
      const counterparts = exactCounterparts(transaction.id, evidence);
      const transfer = reviewedTransfer(
        transaction.id,
        counterparts.map((candidate) => candidate.id),
        evidence,
      );
      consumed.add(transaction.id);
      const transferBlocked = counterparts.length > 0 && !transfer;
      items.push(
        item({
          compatibilityClass: transferBlocked
            ? "transfer_review_required"
            : "exact_grouped_component_adoption",
          activeLedgerOutcome: transferBlocked
            ? null
            : transfer
              ? "confirmed_transfer"
              : "adopted_grouped",
          canonicalComponents: group,
          legacyStatementRowId: transaction.sourceRowId ?? null,
          legacyTransactionIds: [
            transaction.id,
            ...counterparts.map((candidate) => candidate.id),
          ],
          primaryLegacyTransactionId: transaction.id,
          accountTransferId: transfer?.id ?? null,
          blocking: transferBlocked,
        }),
      );
      continue;
    }
    const individualCandidates = [
      ...new Map(
        group
          .flatMap((component) =>
            exactCandidates([component], evidence, consumed),
          )
          .map((candidate) => [candidate.id, candidate]),
      ).values(),
    ];
    if (individualCandidates.length > 0) {
      individualCandidates.forEach((candidate) => consumed.add(candidate.id));
      items.push(
        item({
          compatibilityClass: "ambiguous_or_conflicting",
          activeLedgerOutcome: null,
          canonicalComponents: group,
          legacyStatementRowId: individualCandidates[0]?.sourceRowId ?? null,
          legacyTransactionIds: individualCandidates.map(
            (candidate) => candidate.id,
          ),
          primaryLegacyTransactionId: individualCandidates[0]?.id ?? null,
          accountTransferId: null,
          blocking: true,
        }),
      );
    } else {
      for (const component of group) {
        items.push(
          item({
            compatibilityClass: "canonical_component_requires_materialization",
            activeLedgerOutcome: "materialized",
            canonicalComponents: [component],
            legacyStatementRowId: null,
            legacyTransactionIds: [],
            primaryLegacyTransactionId: null,
            accountTransferId: null,
            blocking: false,
          }),
        );
      }
    }
  }

  for (const transaction of evidence.legacyTransactions) {
    if (consumed.has(transaction.id)) continue;
    const row = evidence.legacyRows.find(
      (candidate) => candidate.id === transaction.sourceRowId,
    );
    items.push(
      item({
        compatibilityClass:
          row?.rowKind === "informational" ||
          hasActiveCanonicalClaim(transaction.id, evidence)
            ? "ambiguous_or_conflicting"
            : "legacy_transaction_historical_only",
        activeLedgerOutcome:
          row?.rowKind === "informational" ||
          hasActiveCanonicalClaim(transaction.id, evidence)
            ? null
            : "historical_only",
        canonicalComponents: [],
        legacyStatementRowId: transaction.sourceRowId ?? null,
        legacyTransactionIds: [transaction.id],
        primaryLegacyTransactionId: transaction.id,
        accountTransferId: null,
        blocking:
          row?.rowKind === "informational" ||
          hasActiveCanonicalClaim(transaction.id, evidence),
      }),
    );
  }

  items.sort((left, right) => left.key.localeCompare(right.key));
  const aggregateCounts = emptyCounts();
  for (const planned of items) aggregateCounts[planned.compatibilityClass] += 1;
  const hasBlocking = items.some((planned) => planned.blocking);
  const hasAdoption =
    aggregateCounts.exact_existing_transaction_adoption > 0 ||
    aggregateCounts.exact_grouped_component_adoption > 0;
  const hasMaterialization =
    aggregateCounts.canonical_component_requires_materialization > 0;
  const eligibleStrategies = hasBlocking
    ? []
    : hasAdoption && hasMaterialization
      ? (["C"] as const)
      : hasMaterialization
        ? (["B"] as const)
        : (["A"] as const);
  const recommendedStrategy: StatementLegacyStrategy = hasBlocking
    ? "D"
    : eligibleStrategies[0]!;
  const legacyHash = legacyEvidenceHash(evidence);
  const expectedHash = revisionClaimHash(evidence);
  const crosswalkHash = statementSha256(
    canonicalStatementJson(
      items.map((planned) => ({
        key: planned.key,
        class: planned.compatibilityClass,
        outcome: planned.activeLedgerOutcome,
        evidence: planned.itemEvidenceHash,
      })),
    ),
  );
  return {
    databaseFingerprint: evidence.databaseFingerprint,
    sourceIdentityHash: sourceIdentityHash(context),
    canonicalPreviewHash: context.preview.previewHash,
    legacyEvidenceHash: legacyHash,
    accountContextFingerprint:
      context.preview.account.accountContextFingerprint,
    crosswalkHash,
    expectedRevisionClaimHash: expectedHash,
    resultAuthorityHash: statementSha256(
      canonicalStatementJson({
        databaseFingerprint: evidence.databaseFingerprint,
        sourceIdentityHash: sourceIdentityHash(context),
        canonicalPreviewHash: context.preview.previewHash,
        legacyEvidenceHash: legacyHash,
        crosswalkHash,
        expectedRevisionClaimHash: expectedHash,
      }),
    ),
    aggregateCounts,
    items,
    eligibleStrategies,
    recommendedStrategy,
    applyEligible: !hasBlocking && eligibleStrategies.length === 1,
  };
}

export function assertLegacyResolutionDecisions(
  plan: StatementLegacyResolutionPlan,
  decisions: readonly StatementLegacyResolutionDecision[],
): void {
  if (!plan.applyEligible) {
    if (plan.aggregateCounts.transfer_review_required > 0) {
      throw new RavenDomainError(
        "STATEMENT_LEGACY_TRANSFER_UNRESOLVED",
        "Transfer-review evidence remains unresolved",
      );
    }
    throw new RavenDomainError(
      "STATEMENT_LEGACY_CONFLICT_UNRESOLVED",
      "Ambiguous or conflicting legacy evidence remains unresolved",
    );
  }
  const byKey = new Map(
    decisions.map((decision) => [decision.itemKey, decision]),
  );
  if (byKey.size !== decisions.length) {
    throw new RavenDomainError(
      "STATEMENT_LEGACY_CROSSWALK_DRIFT",
      "Compatibility decisions contain duplicate item keys",
    );
  }
  const expectedDecisionKeys = new Set(
    plan.items
      .filter(
        (planned) =>
          planned.compatibilityClass !== "informational_non_movement",
      )
      .map((planned) => planned.key),
  );
  if (
    decisions.length !== expectedDecisionKeys.size ||
    decisions.some((decision) => !expectedDecisionKeys.has(decision.itemKey))
  ) {
    throw new RavenDomainError(
      "STATEMENT_LEGACY_CROSSWALK_DRIFT",
      "Compatibility decisions must match the exact server-derived item set",
    );
  }
  for (const planned of plan.items) {
    if (planned.compatibilityClass === "informational_non_movement") continue;
    const decision = byKey.get(planned.key);
    if (
      !decision ||
      decision.itemEvidenceHash !== planned.itemEvidenceHash ||
      decision.outcome !== planned.activeLedgerOutcome ||
      (planned.primaryLegacyTransactionId &&
        decision.legacyTransactionId !== planned.primaryLegacyTransactionId) ||
      (planned.accountTransferId &&
        decision.accountTransferId !== planned.accountTransferId)
    ) {
      throw new RavenDomainError(
        "STATEMENT_LEGACY_CROSSWALK_DRIFT",
        "Compatibility decisions do not match the server-derived exact plan",
      );
    }
  }
}
