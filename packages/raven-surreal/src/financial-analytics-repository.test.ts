import assert from "node:assert/strict";
import test from "node:test";
import { SurrealAccountControlRepository } from "./repository.js";

test("financial analytics repository executes one set-based bounded read and preserves authority", async () => {
  const calls: Array<{ query: string; vars?: Record<string, unknown> }> = [];
  const client = {
    async query(query: string, vars?: Record<string, unknown>) {
      calls.push({ query, vars });
      return [
        {
          status: "OK",
          result: [
            {
              id: "transaction:fictional-active",
              key: "fictional-active",
              spaceId: "financialSpace:fictional-space",
              spaceKey: "fictional-space",
              accountId: "account:fictional-account",
              accountKey: "fictional-account",
              postedAt: "2026-07-10",
              effectiveAt: "2026-07-09",
              recordedAt: "2026-07-10T12:00:00.000Z",
              description: "Fictional observed movement",
              amountMinor: 1_250,
              currency: "ZAR",
              direction: "debit",
              transactionKind: "expense",
              flowDirection: "outflow",
              entrySource: "imported",
              status: "matched",
              sourceRowId: "statementRow:fictional-row",
              statementMatchId: "statementTransactionMatch:fictional-match",
              statementMatchState: "confirmed",
              statementMatchSourceState: "committed",
              statementImportSourceState: "committed",
              statementImportId: "statementImport:fictional-import",
            },
            {
              id: "transaction:fictional-legacy",
              key: "fictional-legacy",
              spaceId: "financialSpace:fictional-space",
              spaceKey: "fictional-space",
              accountId: "account:fictional-account",
              accountKey: "fictional-account",
              postedAt: "2026-07-08",
              recordedAt: "2026-07-08T12:00:00.000Z",
              description: "Fictional legacy movement",
              amountMinor: 2_500,
              currency: "ZAR",
              direction: "debit",
              transactionKind: "expense",
              flowDirection: "outflow",
              entrySource: "imported",
              status: "imported",
              sourceRowId: "statementRow:fictional-legacy-row",
            },
            {
              id: "transaction:fictional-source-created-superseded",
              key: "fictional-source-created-superseded",
              spaceId: "financialSpace:fictional-space",
              spaceKey: "fictional-space",
              accountId: "account:fictional-account",
              accountKey: "fictional-account",
              postedAt: "2026-07-07",
              effectiveAt: null,
              recordedAt: "2026-07-07T12:00:00.000Z",
              description: "Fictional source-created superseded movement",
              amountMinor: 3_500,
              currency: "ZAR",
              direction: "debit",
              transactionKind: "expense",
              flowDirection: "outflow",
              entrySource: "imported",
              status: "matched",
              sourceRowId: "statementRow:fictional-superseded-row",
              statementMatchId: null,
              hasCanonicalStatementMatchHistory: true,
            },
            {
              id: "transaction:fictional-adopted-legacy-superseded",
              key: "fictional-adopted-legacy-superseded",
              spaceId: "financialSpace:fictional-space",
              spaceKey: "fictional-space",
              accountId: "account:fictional-account",
              accountKey: "fictional-account",
              postedAt: "2026-07-06",
              effectiveAt: null,
              recordedAt: "2026-07-06T12:00:00.000Z",
              description: "Fictional adopted legacy superseded movement",
              amountMinor: 4_500,
              currency: "ZAR",
              direction: "debit",
              transactionKind: "expense",
              flowDirection: "outflow",
              entrySource: "imported",
              status: "matched",
              sourceRowId: "statementRow:fictional-adopted-legacy-row",
              statementMatchId: null,
              hasCanonicalStatementMatchHistory: true,
            },
            {
              id: "transaction:fictional-manual-superseded",
              key: "fictional-manual-superseded",
              spaceId: "financialSpace:fictional-space",
              spaceKey: "fictional-space",
              accountId: "account:fictional-account",
              accountKey: "fictional-account",
              postedAt: "2026-07-05",
              effectiveAt: null,
              recordedAt: "2026-07-05T12:00:00.000Z",
              description: "Fictional manual movement returned to provisional",
              amountMinor: 5_500,
              currency: "ZAR",
              direction: "debit",
              transactionKind: "expense",
              flowDirection: "outflow",
              entrySource: "manual",
              status: "matched",
              statementMatchId: null,
              hasCanonicalStatementMatchHistory: true,
            },
          ],
        },
      ];
    },
  };
  const repository = new SurrealAccountControlRepository(client);
  const rows = await repository.listFinancialAnalyticsTransactions({
    accountIds: ["account:fictional-account"],
    currency: "ZAR",
    authorityScope: "active_ledger_with_legacy_unreconciled",
    from: "2026-07-01",
    through: "2026-07-31",
  });

  assert.equal(calls.length, 1);
  assert.match(calls[0]!.query, /^\s*LET \$canonicalHistoryTransactions/);
  assert.doesNotMatch(
    calls[0]!.query,
    /\b(?:CREATE|UPDATE|UPSERT|DELETE|INSERT|RELATE|BEGIN|COMMIT|CANCEL)\b/i,
  );
  assert.doesNotMatch(calls[0]!.query, /financialOperation/i);
  assert.match(calls[0]!.query, /record::id\(account\) IN \$accountRecordKeys/);
  assert.match(calls[0]!.query, /postedAt >= \$from/);
  assert.match(calls[0]!.query, /effectiveAt >= \$from/);
  assert.match(calls[0]!.query, /recordedAt/);
  assert.match(calls[0]!.query, /FROM statementTransactionMatch/);
  assert.match(calls[0]!.query, /SELECT VALUE transaction/);
  assert.match(
    calls[0]!.query,
    /id IN \$canonicalHistoryTransactions AS hasCanonicalStatementMatchHistory/,
  );
  assert.match(calls[0]!.query, /state IN \["confirmed", "superseded"\]/);
  assert.match(calls[0]!.query, /sourceState IN \["committed", "superseded"\]/);
  assert.doesNotMatch(calls[0]!.query, /\$parent\.id/);
  assert.deepEqual(calls[0]!.vars, {
    accountRecordKeys: ["fictional-account"],
    currency: "ZAR",
    from: "2026-07-01",
    through: "2026-07-31",
  });
  assert.deepEqual(
    rows.map((row) => [row.id, row.ledgerAuthority]),
    [
      ["transaction:fictional-active", "active"],
      ["transaction:fictional-legacy", "legacy_unreconciled"],
      [
        "transaction:fictional-source-created-superseded",
        "canonical_historical_superseded",
      ],
      [
        "transaction:fictional-adopted-legacy-superseded",
        "canonical_historical_superseded",
      ],
      ["transaction:fictional-manual-superseded", "active"],
    ],
  );
  assert.equal(rows.at(-1)?.effectiveAt, null);
  assert.equal(rows.at(-1)?.postedAt, "2026-07-05");
});

test("empty Account scope performs no database query", async () => {
  let called = false;
  const repository = new SurrealAccountControlRepository({
    async query() {
      called = true;
      return [];
    },
  });
  const rows = await repository.listFinancialAnalyticsTransactions({
    accountIds: [],
    currency: "ZAR",
    authorityScope: "active_ledger",
    from: "2026-07-01",
    through: "2026-07-31",
  });
  assert.deepEqual(rows, []);
  assert.equal(called, false);
});

test("empty Financial Space scope performs no Account query", async () => {
  let called = false;
  const repository = new SurrealAccountControlRepository({
    async query() {
      called = true;
      return [];
    },
  });

  assert.deepEqual(await repository.listAccounts([]), []);
  assert.equal(called, false);
});
