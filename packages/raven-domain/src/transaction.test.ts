import assert from "node:assert/strict";
import test from "node:test";

import type { TransactionRecord } from "./contracts.js";
import {
  toTransactionView,
  transactionEvidenceState,
  transactionManagementMeaningState,
  transactionTaxMeaningState,
} from "./transaction.js";

function transaction(
  overrides: Partial<TransactionRecord> = {},
): TransactionRecord {
  return {
    id: "transaction:fictional-ledger-entry",
    key: "fictional-ledger-entry",
    spaceId: "financialSpace:fictional-business",
    spaceKey: "fictional-business",
    accountId: "account:fictional-current",
    accountKey: "fictional-current",
    postedAt: "2026-07-01",
    recordedAt: "2026-07-01T08:00:00.000Z",
    description: "Fictional ledger entry",
    amountMinor: 1_000,
    currency: "ZAR",
    kind: "expense",
    flowDirection: "outflow",
    entrySource: "imported",
    status: "imported",
    warnings: [],
    ...overrides,
  };
}

test("transaction evidence state distinguishes statement evidence from provisional observations", () => {
  assert.equal(
    transactionEvidenceState(
      transaction({ sourceRowId: "statementRow:fictional-row" }),
    ),
    "unresolved",
  );
  assert.equal(
    transactionEvidenceState(transaction({ entrySource: "manual" })),
    "provisional",
  );
  assert.equal(
    transactionEvidenceState(
      transaction({
        entrySource: "manual",
        statementMatchId: "statementTransactionMatch:fictional-confirmed",
        statementImportId: "statementImport:fictional-period",
        statementMatchState: "confirmed",
        statementMatchSourceState: "committed",
        statementImportSourceState: "committed",
      }),
    ),
    "statement_backed",
  );
  assert.equal(
    transactionEvidenceState(
      transaction({ entrySource: "generated", operationId: "operation:1" }),
    ),
    "provisional",
  );
  assert.equal(transactionEvidenceState(transaction()), "unresolved");
});

test("management meaning does not reinterpret legacy tax categories as tax assessment", () => {
  const legacyTax = transaction({
    categoryId: "category:legacy-tax",
    categoryKey: "legacy-tax",
    categoryName: "Legacy tax label",
    categoryKind: "tax",
  });
  const management = transaction({
    categoryId: "category:software",
    categoryKey: "software",
    categoryName: "Software",
    categoryKind: "expense",
  });

  assert.equal(
    transactionManagementMeaningState(legacyTax),
    "needs_clarification",
  );
  assert.equal(transactionManagementMeaningState(management), "classified");
  assert.equal(
    transactionManagementMeaningState(transaction()),
    "unclassified",
  );
  assert.equal(transactionTaxMeaningState(), "not_assessed");
});

test("transaction views expose separate evidence, management, and tax states", () => {
  const view = toTransactionView(
    transaction({
      sourceRowId: "statementRow:fictional-row",
      statementMatchId: "statementTransactionMatch:fictional-confirmed",
      statementImportId: "statementImport:fictional-period",
      statementMatchState: "confirmed",
      statementMatchSourceState: "committed",
      statementImportSourceState: "committed",
      effectiveAt: "2026-06-30",
      categoryId: "category:software",
      categoryKey: "software",
      categoryName: "Software",
      categoryKind: "expense",
      reportedBalanceMinor: -42_500,
      status: "matched",
    }),
  );

  assert.equal(view.status, "matched");
  assert.equal(view.evidenceState, "statement_backed");
  assert.equal(view.financialDate, "2026-06-30");
  assert.equal(view.observationDate, "2026-07-01");
  assert.equal(view.financialDateProvenance, "statement_source");
  assert.equal(view.managementMeaningState, "classified");
  assert.equal(view.taxMeaningState, "not_assessed");
  assert.deepEqual(view.reportedBalance, {
    currency: "ZAR",
    minorUnits: -42_500,
  });
});

test("transaction views do not invent a running balance when statement evidence omits it", () => {
  const view = toTransactionView(transaction({ reportedBalanceMinor: null }));

  assert.equal(view.reportedBalance, null);
});

test("superseded source-created transactions remain historical-only", () => {
  const view = toTransactionView(
    transaction({
      sourceRowId: "statementRow:fictional-row",
      statementMatchId: null,
      effectiveAt: null,
      hasCanonicalStatementMatchHistory: true,
    }),
  );

  assert.equal(view.evidenceState, "unresolved");
  assert.equal(view.ledgerAuthority, "canonical_historical_superseded");
  assert.equal(view.financialDate, "2026-07-01");
});

test("adopted legacy transactions remain canonical history after their active pointer is cleared", () => {
  const view = toTransactionView(
    transaction({
      sourceRowId: "statementRow:fictional-adopted-legacy-row",
      statementMatchId: null,
      effectiveAt: null,
      hasCanonicalStatementMatchHistory: true,
    }),
  );

  assert.equal(view.ledgerAuthority, "canonical_historical_superseded");
  assert.equal(view.financialDate, "2026-07-01");
});

test("unmatched renderer-era source evidence remains legacy-unreconciled", () => {
  const view = toTransactionView(
    transaction({
      sourceRowId: "statementRow:fictional-legacy-row",
      statementMatchId: null,
      hasCanonicalStatementMatchHistory: false,
    }),
  );

  assert.equal(view.evidenceState, "unresolved");
  assert.equal(view.ledgerAuthority, "legacy_unreconciled");
});

test("proposed or rejected match pointers do not invent canonical history", () => {
  for (const state of ["proposed", "rejected"]) {
    const view = toTransactionView(
      transaction({
        sourceRowId: `statementRow:fictional-${state}`,
        statementMatchId: `statementTransactionMatch:fictional-${state}`,
        statementMatchState: state,
        statementMatchSourceState: "committed",
        hasCanonicalStatementMatchHistory: false,
      }),
    );

    assert.equal(view.ledgerAuthority, "legacy_unreconciled");
  }
});

test("manual transactions return to active provisional observation authority after supersession", () => {
  const view = toTransactionView(
    transaction({
      entrySource: "manual",
      sourceRowId: null,
      statementMatchId: null,
      effectiveAt: null,
      hasCanonicalStatementMatchHistory: true,
    }),
  );

  assert.equal(view.evidenceState, "provisional");
  assert.equal(view.ledgerAuthority, "active");
  assert.equal(view.financialDate, "2026-07-01");
  assert.equal(view.financialDateProvenance, "observation");
});
