import assert from "node:assert/strict";
import test from "node:test";

import type { AccountTransferRecord, TransactionRecord } from "./contracts.js";
import { RavenDomainError } from "./errors.js";
import type {
  StatementImportRecord,
  StatementPreviewResult,
  StatementRowRecord,
} from "./statement-contracts.js";
import type {
  StatementLegacyEvidence,
  StatementLegacyPreviewContext,
} from "./statement-legacy-resolution-contracts.js";
import {
  assertLegacyResolutionDecisions,
  planLegacyStatementResolution,
} from "./statement-legacy-resolution-planner.js";

const ACCOUNT_FINGERPRINT = "fictional-account-context-v1";

type ComponentFixture = Readonly<{
  key: string;
  amountMinor: number;
  effectMinor: number;
  date?: string;
  role?: "movement" | "informational_breakdown";
}>;

function context(
  rows: readonly (readonly ComponentFixture[])[],
): StatementLegacyPreviewContext {
  const normalizedRows = rows.map((components, rowIndex) => ({
    rowKey: `row-${rowIndex + 1}`,
    rowNumber: rowIndex + 1,
    transactionDate: components[0]?.date ?? "2026-06-12",
    postingDate: null,
    valueDate: null,
    components: components.map((component) => ({
      componentKey: component.key,
      componentRole: component.role ?? "movement",
      sourceChecksum: `checksum-${component.key}`,
      amountMinor: component.amountMinor,
      balanceEffectMinor: component.effectMinor,
      currency: "ZAR",
      transactionDate: component.date ?? "2026-06-12",
      postingDate: null,
      valueDate: null,
    })),
  }));
  const preview = {
    source: {
      originalFileSha256: "fictional-original-hash",
      extractionInputSha256: "fictional-assist-hash",
    },
    profile: {
      profileId: "fnb-business",
      profileVersion: "1",
      extractorVersion: "1",
    },
    account: {
      spaceId: "FinancialSpace:fictional",
      accountId: "Account:fictional-primary",
      spaceKey: "fictional",
      accountKey: "fictional-primary",
      currency: "ZAR",
      normalNature: "asset",
      accountNumberLast4: "0001",
      spaceTimezone: "Africa/Johannesburg",
      accountContextFingerprint: ACCOUNT_FINGERPRINT,
    },
    extraction: {
      canonicalExtractionSha256: "fictional-canonical-hash",
      currency: "ZAR",
      periodStart: "2026-06-01",
      periodEnd: "2026-06-30",
      rows: normalizedRows,
    },
    previewHash: "fictional-preview-hash",
  } as unknown as StatementPreviewResult;
  return {
    input: {
      sourceRef: "vault:fictional",
      spaceKey: "fictional",
      accountKey: "fictional-primary",
      profileId: "fnb-business",
      profileVersion: "1",
      previewHash: "fictional-preview-hash",
      legacyStatementImportId: "StatementImport:legacy-fictional",
    },
    preview,
  };
}

function legacyImport(): StatementImportRecord {
  return {
    id: "StatementImport:legacy-fictional",
    spaceId: "FinancialSpace:fictional",
    accountId: "Account:fictional-primary",
    spaceKey: "fictional",
    accountKey: "fictional-primary",
    key: "legacy-fictional",
    privateSourceRef: "private:redacted",
    extractionAssistRef: null,
    originalFileSha256: "legacy-original",
    extractionInputSha256: null,
    canonicalExtractionSha256: "legacy-canonical",
    previewHash: "legacy-preview",
    sourceKind: "manual",
    sourceMimeType: "application/json",
    sourceByteSize: 1,
    profile: {
      profileId: "legacy",
      profileVersion: "1",
      extractorVersion: "1",
    },
    validationRulesetVersion: "1",
    periodStart: "2026-06-01",
    periodEnd: "2026-06-30",
    currency: "ZAR",
    balanceConvention: null,
    balanceConventionAuthority: null,
    accountContextFingerprint: ACCOUNT_FINGERPRINT,
    openingBalanceMinor: 100_000,
    closingBalanceMinor: 90_000,
    closingBalanceEconomicNature: "asset",
    coverage: null,
    sourceState: "legacy",
    importedAt: "2026-07-01T00:00:00.000Z",
    committedAt: "2026-07-01T00:00:00.000Z",
    commitOperationId: null,
    replacementOfId: null,
    rowCount: 1,
    componentCount: 0,
    issueCount: 0,
    revision: 1,
    legacyPeriodEvidence: {
      statementDate: "2026-06-30",
      keyDate: "2026-06-30",
      mapping: "exact_fields",
    },
  };
}

function row(rowNumber = 1, rowKind = "transaction"): StatementRowRecord {
  return {
    id: `StatementRow:legacy-${rowNumber}`,
    rowNumber,
    rowKind,
    rowHash: `legacy-row-hash-${rowNumber}`,
  } as unknown as StatementRowRecord;
}

function transaction(
  id: string,
  amountMinor: number,
  date = "2026-06-12",
  overrides: Partial<TransactionRecord> = {},
): TransactionRecord {
  return {
    id,
    key: id.replace(":", "-"),
    spaceId: "FinancialSpace:fictional",
    spaceKey: "fictional",
    accountId: "Account:fictional-primary",
    accountKey: "fictional-primary",
    postedAt: date,
    recordedAt: "2026-07-01T00:00:00.000Z",
    description: "Fictional legacy movement",
    amountMinor: Math.abs(amountMinor),
    currency: "ZAR",
    kind: amountMinor < 0 ? "expense" : "income",
    flowDirection: amountMinor < 0 ? "outflow" : "inflow",
    entrySource: "imported",
    status: "imported",
    sourceRowId: "StatementRow:legacy-1",
    warnings: [],
    ...overrides,
  };
}

function evidence(
  legacyTransactions: readonly TransactionRecord[] = [],
  overrides: Partial<StatementLegacyEvidence> = {},
): StatementLegacyEvidence {
  return {
    databaseFingerprint: "fictional-disposable-db",
    legacyStatementImport: legacyImport(),
    legacyRows: [row()],
    legacyTransactions,
    counterpartTransactions: [],
    accountTransfers: [],
    activeMatches: [],
    reconciliation: null,
    dependentAuthorityHash: "no-dependent-authority",
    ...overrides,
  };
}

test("plans exact adoption deterministically and accepts only the exact decision", () => {
  const input = context([
    [{ key: "payment", amountMinor: 10_000, effectMinor: -10_000 }],
  ]);
  const legacy = evidence([transaction("Transaction:legacy-one", -10_000)]);
  const first = planLegacyStatementResolution(input, legacy);
  const second = planLegacyStatementResolution(input, legacy);
  assert.deepEqual(second, first);
  assert.equal(first.applyEligible, true);
  assert.deepEqual(first.eligibleStrategies, ["A"]);
  assert.equal(first.aggregateCounts.exact_existing_transaction_adoption, 1);
  const planned = first.items[0]!;
  assert.doesNotThrow(() =>
    assertLegacyResolutionDecisions(first, [
      {
        itemKey: planned.key,
        outcome: "adopted_existing",
        itemEvidenceHash: planned.itemEvidenceHash,
        legacyTransactionId: "Transaction:legacy-one",
      },
    ]),
  );
  assert.throws(
    () =>
      assertLegacyResolutionDecisions(first, [
        {
          itemKey: planned.key,
          outcome: "adopted_existing",
          itemEvidenceHash: "stale",
          legacyTransactionId: "Transaction:legacy-one",
        },
      ]),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_LEGACY_CROSSWALK_DRIFT",
  );
});

test("groups only same-row same-date components with an exact signed sum", () => {
  const input = context([
    [
      { key: "principal", amountMinor: 8_000, effectMinor: -8_000 },
      { key: "fee", amountMinor: 2_000, effectMinor: -2_000 },
    ],
  ]);
  const plan = planLegacyStatementResolution(
    input,
    evidence([transaction("Transaction:legacy-group", -10_000)]),
  );
  assert.equal(plan.aggregateCounts.exact_grouped_component_adoption, 1);
  assert.equal(plan.items[0]!.canonicalComponents.length, 2);
  assert.deepEqual(plan.eligibleStrategies, ["A"]);
});

test("assigns materialization, historical-only and informational classes without double counting", () => {
  const input = context([
    [{ key: "new", amountMinor: 4_000, effectMinor: -4_000 }],
    [
      {
        key: "memo",
        amountMinor: 600,
        effectMinor: 0,
        role: "informational_breakdown",
      },
    ],
  ]);
  const historical = transaction("Transaction:legacy-only", -7_000);
  const plan = planLegacyStatementResolution(input, evidence([historical]));
  assert.equal(
    plan.aggregateCounts.canonical_component_requires_materialization,
    1,
  );
  assert.equal(plan.aggregateCounts.legacy_transaction_historical_only, 1);
  assert.equal(plan.aggregateCounts.informational_non_movement, 1);
  assert.deepEqual(plan.eligibleStrategies, ["B"]);
  assert.equal(
    plan.items.flatMap((item) => item.legacyTransactionIds).length,
    1,
  );
});

test("a composite-row informational annotation does not consume its principal transaction", () => {
  const input = context([
    [
      { key: "principal", amountMinor: 10_000, effectMinor: -10_000 },
      {
        key: "printed-charge",
        amountMinor: 300,
        effectMinor: 0,
        role: "informational_breakdown",
      },
    ],
  ]);
  const plan = planLegacyStatementResolution(
    input,
    evidence([transaction("Transaction:principal", -10_000)]),
  );
  assert.equal(plan.applyEligible, true);
  assert.equal(plan.recommendedStrategy, "A");
  assert.equal(plan.aggregateCounts.exact_existing_transaction_adoption, 1);
  assert.equal(plan.aggregateCounts.informational_non_movement, 1);
  assert.equal(plan.aggregateCounts.ambiguous_or_conflicting, 0);
});

test("an unclaimed legacy transaction on a canonical informational row becomes historical only", () => {
  const input = context([
    [
      {
        key: "printed-notice",
        amountMinor: 1_500,
        effectMinor: 0,
        role: "informational_breakdown",
      },
    ],
  ]);
  const legacy = transaction("Transaction:legacy-notice", -1_500);
  const plan = planLegacyStatementResolution(input, evidence([legacy]));
  assert.equal(plan.applyEligible, true);
  assert.equal(plan.aggregateCounts.informational_non_movement, 1);
  assert.equal(plan.aggregateCounts.legacy_transaction_historical_only, 1);
  assert.equal(plan.aggregateCounts.ambiguous_or_conflicting, 0);
});

test("blocks plausible cross-account transfer evidence until an exact transfer exists", () => {
  const input = context([
    [{ key: "transfer", amountMinor: 5_000, effectMinor: -5_000 }],
  ]);
  const primary = transaction("Transaction:primary", -5_000);
  const counterpart = transaction(
    "Transaction:counterpart",
    5_000,
    "2026-06-12",
    {
      accountId: "Account:fictional-secondary",
      accountKey: "fictional-secondary",
      flowDirection: "inflow",
      kind: "income",
    },
  );
  const blocked = planLegacyStatementResolution(
    input,
    evidence([primary], { counterpartTransactions: [counterpart] }),
  );
  assert.equal(blocked.applyEligible, false);
  assert.equal(blocked.aggregateCounts.transfer_review_required, 1);
  assert.throws(
    () => assertLegacyResolutionDecisions(blocked, []),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_LEGACY_TRANSFER_UNRESOLVED",
  );

  const transfer = {
    id: "AccountTransfer:reviewed",
    sourceTransactionId: primary.id,
    targetTransactionId: counterpart.id,
  } as unknown as AccountTransferRecord;
  const released = planLegacyStatementResolution(
    input,
    evidence([primary], {
      counterpartTransactions: [counterpart],
      accountTransfers: [transfer],
    }),
  );
  assert.equal(released.applyEligible, true);
  assert.equal(released.items[0]!.activeLedgerOutcome, "confirmed_transfer");
  assert.equal(released.items[0]!.accountTransferId, transfer.id);
});

test("does not block migration for an unrelated same-date same-amount collision", () => {
  const input = context([
    [{ key: "receipt", amountMinor: 5_000, effectMinor: 5_000 }],
  ]);
  const primary = transaction("Transaction:primary", 5_000, "2026-06-12", {
    description: "Mpire Digital Market",
  });
  const unrelated = transaction(
    "Transaction:unrelated",
    -5_000,
    "2026-06-12",
    {
      accountId: "Account:fictional-secondary",
      accountKey: "fictional-secondary",
      description: "Internet Banking Transfer Selby ZA",
      flowDirection: "outflow",
      kind: "expense",
    },
  );
  const plan = planLegacyStatementResolution(
    input,
    evidence([primary], { counterpartTransactions: [unrelated] }),
  );
  assert.equal(plan.applyEligible, true);
  assert.equal(plan.aggregateCounts.transfer_review_required, 0);
  assert.equal(plan.aggregateCounts.exact_existing_transaction_adoption, 1);
});

test("same amount on another date, amount mismatch, and duplicate candidates never become exact adoption", () => {
  const input = context([
    [{ key: "payment", amountMinor: 10_000, effectMinor: -10_000 }],
  ]);
  const notExact = planLegacyStatementResolution(
    input,
    evidence([
      transaction("Transaction:other-date", -10_000, "2026-06-13"),
      transaction("Transaction:other-amount", -9_999),
    ]),
  );
  assert.equal(notExact.aggregateCounts.exact_existing_transaction_adoption, 0);
  assert.equal(
    notExact.aggregateCounts.canonical_component_requires_materialization,
    1,
  );
  assert.equal(notExact.aggregateCounts.legacy_transaction_historical_only, 2);

  const duplicate = planLegacyStatementResolution(
    input,
    evidence([
      transaction("Transaction:duplicate-a", -10_000),
      transaction("Transaction:duplicate-b", -10_000),
    ]),
  );
  assert.equal(duplicate.applyEligible, false);
  assert.equal(duplicate.aggregateCounts.ambiguous_or_conflicting, 1);
});

test("an exact source-row position disambiguates same-date same-amount legacy candidates", () => {
  const input = context([
    [{ key: "payment", amountMinor: 10_000, effectMinor: -10_000 }],
  ]);
  const aligned = transaction("Transaction:aligned", -10_000);
  const otherRow = transaction("Transaction:other-row", -10_000, "2026-06-12", {
    sourceRowId: "StatementRow:legacy-2",
  });
  const plan = planLegacyStatementResolution(
    input,
    evidence([aligned, otherRow], { legacyRows: [row(1), row(2)] }),
  );
  assert.equal(plan.applyEligible, true);
  assert.equal(plan.aggregateCounts.exact_existing_transaction_adoption, 1);
  assert.equal(plan.aggregateCounts.legacy_transaction_historical_only, 1);
  assert.equal(
    plan.items.find(
      (item) =>
        item.compatibilityClass === "exact_existing_transaction_adoption",
    )?.primaryLegacyTransactionId,
    aligned.id,
  );
});

test("a transaction on another proven source row cannot compete for an identical missing row", () => {
  const input = context([
    [{ key: "payment-one", amountMinor: 10_000, effectMinor: -10_000 }],
    [{ key: "payment-two", amountMinor: 10_000, effectMinor: -10_000 }],
  ]);
  const aligned = transaction("Transaction:aligned", -10_000);
  const plan = planLegacyStatementResolution(
    input,
    evidence([aligned], { legacyRows: [row(1), row(2)] }),
  );
  assert.equal(plan.applyEligible, true);
  assert.equal(plan.recommendedStrategy, "C");
  assert.equal(plan.aggregateCounts.exact_existing_transaction_adoption, 1);
  assert.equal(
    plan.aggregateCounts.canonical_component_requires_materialization,
    1,
  );
  assert.equal(plan.aggregateCounts.ambiguous_or_conflicting, 0);
});

test("Category and Merchant meaning do not affect crosswalk identity", () => {
  const input = context([
    [{ key: "payment", amountMinor: 10_000, effectMinor: -10_000 }],
  ]);
  const base = transaction("Transaction:legacy-one", -10_000);
  const first = planLegacyStatementResolution(input, evidence([base]));
  const changedMeaning = planLegacyStatementResolution(
    input,
    evidence([
      {
        ...base,
        categoryId: "Category:changed",
        categoryName: "Changed meaning",
        merchantName: "Changed merchant",
        notes: "Changed note",
      },
    ]),
  );
  assert.equal(changedMeaning.crosswalkHash, first.crosswalkHash);
  assert.equal(changedMeaning.legacyEvidenceHash, first.legacyEvidenceHash);
});

test("source, legacy evidence and authority revisions invalidate the reviewed plan", () => {
  const input = context([
    [{ key: "payment", amountMinor: 10_000, effectMinor: -10_000 }],
  ]);
  const baseTransaction = transaction("Transaction:legacy-one", -10_000);
  const baseEvidence = evidence([baseTransaction]);
  const base = planLegacyStatementResolution(input, baseEvidence);

  const sourceChanged = planLegacyStatementResolution(
    {
      ...input,
      preview: {
        ...input.preview,
        source: {
          ...input.preview.source,
          extractionInputSha256: "changed-extraction-assistance-hash",
        },
      },
    },
    baseEvidence,
  );
  assert.notEqual(sourceChanged.sourceIdentityHash, base.sourceIdentityHash);
  assert.notEqual(sourceChanged.resultAuthorityHash, base.resultAuthorityHash);

  const rowChanged = planLegacyStatementResolution(
    input,
    evidence([baseTransaction], {
      legacyRows: [{ ...row(), rowHash: "changed-legacy-row-hash" }],
    }),
  );
  assert.notEqual(rowChanged.legacyEvidenceHash, base.legacyEvidenceHash);
  assert.notEqual(rowChanged.resultAuthorityHash, base.resultAuthorityHash);

  const reconciliationChanged = planLegacyStatementResolution(
    input,
    evidence([baseTransaction], {
      reconciliation: {
        id: "StatementReconciliation:fictional",
        revision: 2,
        calculationHash: "changed-calculation-hash",
        attestationState: "open",
      } as never,
      dependentAuthorityHash: "changed-dependent-authority",
    }),
  );
  assert.notEqual(
    reconciliationChanged.expectedRevisionClaimHash,
    base.expectedRevisionClaimHash,
  );
  assert.notEqual(
    reconciliationChanged.resultAuthorityHash,
    base.resultAuthorityHash,
  );

  const activeClaim = planLegacyStatementResolution(
    input,
    evidence([baseTransaction], {
      activeMatches: [
        {
          id: "StatementTransactionMatch:already-claimed",
          transactionId: baseTransaction.id,
          revision: 1,
          state: "confirmed",
          sourceState: "committed",
        } as never,
      ],
    }),
  );
  assert.equal(activeClaim.applyEligible, false);
  assert.equal(activeClaim.aggregateCounts.ambiguous_or_conflicting, 1);
  assert.notEqual(
    activeClaim.expectedRevisionClaimHash,
    base.expectedRevisionClaimHash,
  );
});

test("Account-context drift fails closed", () => {
  const input = context([
    [{ key: "payment", amountMinor: 10_000, effectMinor: -10_000 }],
  ]);
  assert.throws(
    () =>
      planLegacyStatementResolution(
        input,
        evidence([], {
          legacyStatementImport: {
            ...legacyImport(),
            accountContextFingerprint: "changed",
          },
        }),
      ),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_LEGACY_ACCOUNT_CONTEXT_DRIFT",
  );
});
