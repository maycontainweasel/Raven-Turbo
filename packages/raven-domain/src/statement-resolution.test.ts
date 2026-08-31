import assert from "node:assert/strict";
import test from "node:test";
import {
  calculateStatementReconciliation,
  deriveStatementComponentResolutions,
  generateStatementMatchCandidates,
  RavenDomainError,
  retryStatementReconciliationMutation,
  statementCheckedAdd,
  type StatementImportRecord,
  type StatementIssueRecord,
  type StatementRowComponentRecord,
  type StatementRowRecord,
  type StatementTransactionMatchRecord,
  type TransactionRecord,
} from "./index.js";

const IMPORT_ID = "statementImport:fictional-period";
const ACCOUNT_ID = "account:fictional-account";
const SPACE_ID = "financialSpace:fictional-space";

test("reconciliation mutation retries one stale aggregate and preserves the refreshed calculation", async () => {
  let calculations = 0;
  let writes = 0;
  const result = await retryStatementReconciliationMutation(
    async () => ({ revision: ++calculations }),
    async (calculated) => {
      writes += 1;
      if (writes === 1) {
        throw new RavenDomainError(
          "STATEMENT_RECONCILIATION_STALE",
          "Fictional independent aggregate update",
        );
      }
      return calculated;
    },
  );
  assert.deepEqual(result, { revision: 2 });
  assert.equal(calculations, 2);
  assert.equal(writes, 2);
});

test("reconciliation mutation does not retry non-stale failures", async () => {
  let writes = 0;
  await assert.rejects(
    retryStatementReconciliationMutation(
      async () => ({ revision: 1 }),
      async () => {
        writes += 1;
        throw new RavenDomainError(
          "STATEMENT_TRANSACTION_ALREADY_MATCHED",
          "Fictional conflicting disposition",
        );
      },
    ),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_TRANSACTION_ALREADY_MATCHED",
  );
  assert.equal(writes, 1);
});

function component(
  overrides: Partial<StatementRowComponentRecord> = {},
): StatementRowComponentRecord {
  return {
    id: "statementRowComponent:fictional-movement",
    spaceId: SPACE_ID,
    accountId: ACCOUNT_ID,
    statementImportId: IMPORT_ID,
    statementRowId: "statementRow:fictional-row",
    commitOperationId: "financialOperation:fictional-commit",
    sourceState: "committed",
    componentKey: "principal",
    componentKind: "principal",
    componentRole: "movement",
    transactionDate: "2026-07-10",
    postingDate: "2026-07-11",
    valueDate: "2026-07-12",
    description: "Fictional workshop deposit",
    sourceReference: "FIC-100",
    amountMinor: 5_000,
    currency: "ZAR",
    sourceDirection: "credit",
    sourceFlow: "inflow",
    balanceEffectMinor: 5_000,
    locator: null,
    confidence: 1,
    sourceChecksum: "c".repeat(64),
    issues: [],
    ...overrides,
  };
}

function transaction(
  overrides: Partial<TransactionRecord> = {},
): TransactionRecord {
  return {
    id: "transaction:fictional-manual",
    key: "fictional-manual",
    spaceId: SPACE_ID,
    spaceKey: "fictional-space",
    accountId: ACCOUNT_ID,
    accountKey: "fictional-account",
    postedAt: "2026-07-10",
    recordedAt: "2026-07-10T12:00:00.000Z",
    description: "Fictional workshop deposit",
    amountMinor: 5_000,
    currency: "ZAR",
    kind: "income",
    flowDirection: "inflow",
    entrySource: "manual",
    status: "normalized",
    categoryId: "category:fictional-consulting",
    categoryKey: "fictional-consulting",
    categoryName: "Fictional consulting",
    categoryKind: "income",
    merchantName: "Fictional Client",
    sourceRowId: null,
    statementMatchId: null,
    statementImportId: null,
    operationId: "financialOperation:fictional-manual",
    transferId: null,
    warnings: [],
    ...overrides,
  };
}

function statementImport(
  overrides: Partial<StatementImportRecord> = {},
): StatementImportRecord {
  return {
    id: IMPORT_ID,
    spaceId: SPACE_ID,
    accountId: ACCOUNT_ID,
    spaceKey: "fictional-space",
    accountKey: "fictional-account",
    key: "2026-07-31-fictional",
    privateSourceRef: "redacted-source-ref",
    extractionAssistRef: null,
    originalFileSha256: "a".repeat(64),
    extractionInputSha256: null,
    canonicalExtractionSha256: "b".repeat(64),
    previewHash: "d".repeat(64),
    sourceKind: "pdf",
    sourceMimeType: "application/pdf",
    sourceByteSize: 42,
    profile: {
      profileId: "fnb-business",
      profileVersion: "1",
      extractorVersion: "statement-neutral-v0.3",
    },
    validationRulesetVersion: "statement-validation-v0.3",
    periodStart: "2026-07-01",
    periodEnd: "2026-07-31",
    currency: "ZAR",
    balanceConvention: "positive_is_asset",
    balanceConventionAuthority: "profile",
    accountContextFingerprint: "e".repeat(64),
    openingBalanceMinor: 10_000,
    closingBalanceMinor: 15_000,
    closingBalanceEconomicNature: "asset",
    coverage: {
      status: "complete",
      sourcePageCount: 1,
      processedPages: [1],
      sourceSections: ["transactions"],
      processedSections: ["transactions"],
      printedRowCount: 1,
      extractedRowCount: 1,
    },
    sourceState: "committed",
    importedAt: "2026-08-04T10:00:00.000Z",
    committedAt: "2026-08-04T10:00:00.000Z",
    commitOperationId: "financialOperation:fictional-commit",
    replacementOfId: null,
    rowCount: 1,
    componentCount: 1,
    issueCount: 0,
    revision: 1,
    legacyPeriodEvidence: {
      statementDate: "2026-07-31",
      keyDate: "2026-07-31",
      mapping: "not_legacy",
    },
    ...overrides,
  };
}

function row(): StatementRowRecord {
  return {
    id: "statementRow:fictional-row",
    spaceId: SPACE_ID,
    accountId: ACCOUNT_ID,
    statementImportId: IMPORT_ID,
    commitOperationId: "financialOperation:fictional-commit",
    rowKey: "row-1",
    rowNumber: 1,
    rowKind: "movement",
    transactionDate: "2026-07-10",
    postingDate: "2026-07-11",
    valueDate: "2026-07-12",
    rawText: "Fictional workshop deposit",
    sourceReference: "FIC-100",
    reportedBalanceMinor: 15_000,
    locator: null,
    confidence: 1,
    rowHash: "f".repeat(64),
    componentCount: 1,
  };
}

function match(
  overrides: Partial<StatementTransactionMatchRecord> = {},
): StatementTransactionMatchRecord {
  return {
    id: "statementTransactionMatch:fictional",
    key: "fictional",
    spaceId: SPACE_ID,
    accountId: ACCOUNT_ID,
    statementImportId: IMPORT_ID,
    primaryComponentId: component().id,
    componentIds: [component().id],
    transactionId: transaction().id,
    state: "confirmed",
    method: "explicit",
    reasonCodes: ["EXPLICIT_OPERATOR_SELECTION"],
    confidence: 1,
    signedComponentTotalMinor: 5_000,
    currency: "ZAR",
    revision: 2,
    proposedOperationId: "financialOperation:fictional-proposal",
    confirmedOperationId: "financialOperation:fictional-confirmation",
    rejectedOperationId: null,
    supersededOperationId: null,
    proposedBy: "fictional-operator",
    reviewedBy: "fictional-operator",
    proposedAt: "2026-08-04T10:01:00.000Z",
    confirmedAt: "2026-08-04T10:02:00.000Z",
    rejectedAt: null,
    supersededAt: null,
    rejectionReason: null,
    supersessionReason: null,
    supersedesId: null,
    supersededById: null,
    sourceState: "committed",
    ...overrides,
  };
}

function issue(
  overrides: Partial<StatementIssueRecord> = {},
): StatementIssueRecord {
  return {
    id: "statementIssue:fictional",
    key: "fictional",
    spaceId: SPACE_ID,
    accountId: ACCOUNT_ID,
    statementImportId: IMPORT_ID,
    statementRowId: row().id,
    statementRowComponentId: component().id,
    code: "STATEMENT_ROW_LOW_CONFIDENCE",
    severity: "warning",
    blocking: false,
    state: "open",
    message: "Fictional warning",
    revision: 1,
    detectedOperationId: "financialOperation:fictional-commit",
    dispositionOperationId: null,
    detectedAt: "2026-08-04T10:00:00.000Z",
    acknowledgedAt: null,
    resolvedAt: null,
    reviewedBy: null,
    notes: null,
    ...overrides,
  };
}

test("exact manual candidate is deterministic, explicit, and side-effect free", () => {
  const manual = transaction();
  const candidates = generateStatementMatchCandidates({
    components: [component()],
    transactions: [manual],
    explicitTransactionId: manual.id,
  });
  assert.equal(candidates.length, 1);
  assert.equal(candidates[0]?.method, "explicit");
  assert.deepEqual(candidates[0]?.reasonCodes, ["EXPLICIT_OPERATOR_SELECTION"]);
  assert.equal(manual.statementMatchId, null);
  assert.equal(manual.categoryId, "category:fictional-consulting");
});

test("an active confirmed source link is returned as an exact replay candidate", () => {
  const linked = transaction({
    statementMatchId: match().id,
    statementImportId: IMPORT_ID,
  });
  const candidates = generateStatementMatchCandidates({
    components: [component()],
    transactions: [linked],
    matches: [match()],
  });
  assert.equal(candidates.length, 1);
  assert.equal(candidates[0]?.evidenceState, "statement_backed");
  assert.deepEqual(candidates[0]?.reasonCodes, [
    "ACTIVE_CONFIRMED_SOURCE_LINK",
  ]);
});

test("amount, Account, currency, direction, date, ignored, and active-match mismatches are ineligible", () => {
  const variants = [
    transaction({ amountMinor: 5_001 }),
    transaction({ accountId: "account:other" }),
    transaction({ currency: "GBP" }),
    transaction({ flowDirection: "outflow", kind: "expense" }),
    transaction({ postedAt: "2026-07-20" }),
    transaction({ status: "ignored" }),
    transaction({ statementMatchId: "statementTransactionMatch:other" }),
    transaction({ entrySource: "imported" }),
    transaction({ sourceRowId: "statementRow:legacy-source" }),
    transaction({ hasActiveStatementClaim: true }),
  ];
  assert.deepEqual(
    generateStatementMatchCandidates({
      components: [component()],
      transactions: variants,
    }),
    [],
  );
});

test("component groups fail closed across source rows or canonical dates", () => {
  assert.throws(
    () =>
      generateStatementMatchCandidates({
        components: [
          component(),
          component({
            id: "statementRowComponent:other-row",
            statementRowId: "statementRow:other-row",
          }),
        ],
        transactions: [transaction({ amountMinor: 10_000 })],
      }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_COMPONENT_GROUP_INVALID",
  );
  assert.throws(
    () =>
      generateStatementMatchCandidates({
        components: [
          component(),
          component({
            id: "statementRowComponent:other-date",
            transactionDate: "2026-07-09",
          }),
        ],
        transactions: [transaction({ amountMinor: 10_000 })],
      }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_COMPONENT_GROUP_INVALID",
  );
});

test("grouped movement components require an exact checked signed total", () => {
  const fee = component({
    id: "statementRowComponent:fee",
    componentKey: "fee",
    amountMinor: 1_000,
    balanceEffectMinor: -1_000,
    sourceFlow: "outflow",
    sourceDirection: "debit",
  });
  const vat = component({
    id: "statementRowComponent:vat",
    componentKey: "vat",
    amountMinor: 150,
    balanceEffectMinor: -150,
    sourceFlow: "outflow",
    sourceDirection: "debit",
  });
  const candidates = generateStatementMatchCandidates({
    components: [fee, vat],
    transactions: [
      transaction({
        amountMinor: 1_150,
        kind: "expense",
        flowDirection: "outflow",
      }),
      transaction({
        id: "transaction:wrong-total",
        amountMinor: 1_149,
        kind: "expense",
        flowDirection: "outflow",
      }),
    ],
  });
  assert.equal(candidates.length, 1);
  assert.equal(candidates[0]?.method, "grouped_exact");
  assert.equal(candidates[0]?.signedComponentTotalMinor, -1_150);
});

test("informational components remain non-movements and cannot produce candidates", () => {
  const informational = component({
    componentRole: "informational_breakdown",
    balanceEffectMinor: 0,
  });
  assert.deepEqual(
    generateStatementMatchCandidates({
      components: [informational],
      transactions: [transaction()],
    }),
    [],
  );
  assert.equal(
    deriveStatementComponentResolutions({
      components: [informational],
      matches: [],
    })[0]?.disposition,
    "informational",
  );
});

test("equal-magnitude opposite Account movement is only a transfer candidate", () => {
  const candidates = generateStatementMatchCandidates({
    components: [component()],
    transactions: [
      transaction({
        id: "transaction:counterpart",
        spaceId: "financialSpace:fictional-personal",
        spaceKey: "fictional-personal",
        accountId: "account:fictional-counterpart",
        accountKey: "fictional-counterpart",
        kind: "expense",
        flowDirection: "outflow",
      }),
    ],
  });
  assert.equal(candidates.length, 1);
  assert.equal(candidates[0]?.method, "transfer_candidate");
  assert.equal(candidates[0]?.transferCandidate, true);
});

test("exact asset equation becomes ready only after every movement is confirmed", () => {
  const unresolved = calculateStatementReconciliation({
    statementImport: statementImport(),
    rows: [row()],
    components: [component()],
    issues: [],
    matches: [],
    previous: null,
    operationId: "financialOperation:recalc-1",
    calculatedAt: "2026-08-04T11:00:00.000Z",
  });
  assert.equal(unresolved.expectedClosingBalanceMinor, 15_000);
  assert.equal(unresolved.differenceMinor, 0);
  assert.equal(unresolved.counts.unresolvedCount, 1);
  assert.equal(unresolved.attestationState, "open");

  const ready = calculateStatementReconciliation({
    statementImport: statementImport(),
    rows: [row()],
    components: [component()],
    issues: [],
    matches: [match()],
    previous: null,
    operationId: "financialOperation:recalc-2",
    calculatedAt: "2026-08-04T11:01:00.000Z",
  });
  assert.equal(ready.calculationState, "balanced");
  assert.equal(ready.coverageState, "complete");
  assert.equal(ready.attestationState, "ready");
  assert.equal(ready.counts.confirmedExistingCount, 1);
});

test("liability equation uses committed signed effects without reinterpretation", () => {
  const debit = component({
    amountMinor: 2_000,
    balanceEffectMinor: -2_000,
    sourceFlow: "outflow",
    sourceDirection: "debit",
  });
  const reconciliation = calculateStatementReconciliation({
    statementImport: statementImport({
      balanceConvention: "positive_is_liability",
      openingBalanceMinor: 8_000,
      closingBalanceMinor: 6_000,
      closingBalanceEconomicNature: "liability",
    }),
    rows: [row()],
    components: [debit],
    issues: [],
    matches: [match({ signedComponentTotalMinor: -2_000 })],
    previous: null,
    operationId: "financialOperation:liability-recalc",
    calculatedAt: "2026-08-04T11:02:00.000Z",
  });
  assert.equal(reconciliation.expectedClosingBalanceMinor, 6_000);
  assert.equal(reconciliation.differenceMinor, 0);
});

test("missing balances and blocking issues prevent readiness", () => {
  const missing = calculateStatementReconciliation({
    statementImport: statementImport({ openingBalanceMinor: null }),
    rows: [row()],
    components: [component()],
    issues: [],
    matches: [match()],
    previous: null,
    operationId: "financialOperation:missing-balance",
    calculatedAt: "2026-08-04T11:03:00.000Z",
  });
  assert.equal(missing.calculationState, "unavailable");
  assert.equal(missing.attestationState, "open");

  const blocked = calculateStatementReconciliation({
    statementImport: statementImport(),
    rows: [row()],
    components: [component()],
    issues: [issue({ blocking: true, severity: "blocking" })],
    matches: [match()],
    previous: null,
    operationId: "financialOperation:blocked",
    calculatedAt: "2026-08-04T11:04:00.000Z",
  });
  assert.equal(blocked.differenceMinor, 0);
  assert.equal(blocked.counts.blockingIssueCount, 1);
  assert.equal(blocked.attestationState, "open");
});

test("changed authority automatically projects an attested period as reopened", () => {
  const ready = calculateStatementReconciliation({
    statementImport: statementImport(),
    rows: [row()],
    components: [component()],
    issues: [],
    matches: [match()],
    previous: null,
    operationId: "financialOperation:ready",
    calculatedAt: "2026-08-04T11:05:00.000Z",
  });
  const attested = {
    id: "statementReconciliation:fictional",
    ...ready,
    attestationState: "reconciled" as const,
    latestAttestationOperationId: "financialOperation:attested",
    attestedAt: "2026-08-04T11:06:00.000Z",
  };
  const changed = calculateStatementReconciliation({
    statementImport: statementImport(),
    rows: [row()],
    components: [component()],
    issues: [issue()],
    matches: [match()],
    previous: attested,
    operationId: "financialOperation:changed",
    calculatedAt: "2026-08-04T11:07:00.000Z",
  });
  assert.equal(changed.attestationState, "reopened");
  assert.equal(
    changed.latestAttestationOperationId,
    "financialOperation:attested",
  );
});

test("safe-integer overflow is rejected with a stable statement code", () => {
  assert.throws(
    () => statementCheckedAdd(Number.MAX_SAFE_INTEGER, 1, "Fictional total"),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_COMPONENT_TOTAL_MISMATCH",
  );
});
