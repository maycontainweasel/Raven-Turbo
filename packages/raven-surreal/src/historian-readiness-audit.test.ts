import assert from "node:assert/strict";
import test from "node:test";
import { auditHistorianCompatibility } from "./historian-readiness-audit.js";

test("Historian compatibility audit returns counts and classes only", async () => {
  const queries: string[] = [];
  const client = {
    query: async (query: string) => {
      queries.push(query);
      if (query.startsWith("SELECT id, account, periodStart")) {
        return [
          [
            {
              id: "statementImport:canonical",
              account: "account:a",
              periodStart: "2026-06-01",
              periodEnd: "2026-06-30",
              sourceState: "committed",
            },
            {
              id: "statementImport:legacy",
              account: "account:a",
              periodStart: "2026-06-01",
              periodEnd: "2026-06-30",
              sourceState: "legacy",
            },
            {
              id: "statementImport:unmappable",
              account: "account:b",
              periodStart: "",
              periodEnd: "",
              sourceState: "legacy",
            },
          ],
        ];
      }
      if (query.startsWith("SELECT id, entrySource")) {
        return [
          [
            {
              id: "transaction:unresolved-source",
              entrySource: "imported",
              sourceRow: "statementRow:legacy",
              statementMatch: null,
            },
          ],
        ];
      }
      if (query.startsWith("SELECT id, statementImport")) return [[]];
      return [[]];
    },
  };

  const report = await auditHistorianCompatibility(client);
  assert.equal(report.mode, "aggregate_only_audit");
  assert.equal(report.writesPerformed, 0);
  assert.equal(report.recordDetailsIncluded, false);
  assert.equal(report.schemaReadiness.complete, true);
  assert.deepEqual(report.schemaReadiness.missingCanonicalTables, []);
  assert.equal(report.compatibilityClasses.canonicalImports, 1);
  assert.equal(report.compatibilityClasses.activeLegacyImports, 2);
  assert.equal(report.compatibilityClasses.mappableLegacyPeriods, 1);
  assert.equal(report.compatibilityClasses.unmappableLegacyImports, 1);
  assert.equal(report.compatibilityClasses.mixedCanonicalLegacyPeriods, 1);
  assert.equal(
    report.compatibilityClasses.sourceBackedTransactionsWithoutSt02Matches,
    1,
  );

  const serialized = JSON.stringify(report);
  for (const prohibited of [
    "description",
    "amountMinor",
    "sourceFileName",
    "accountName",
    "accountNumber",
    "sourceText",
    "notes",
  ]) {
    assert.equal(serialized.includes(prohibited), false);
  }
  assert.equal(
    queries.every((query) => /^SELECT\b/.test(query)),
    true,
  );
  assert.equal(
    queries.every(
      (query) =>
        !/\b(description|amountMinor|sourceFileName|accountName|accountNumber|sourceText|notes)\b/.test(
          query,
        ),
    ),
    true,
  );
});

test("Historian compatibility audit reports a missing accepted table without widening output", async () => {
  const client = {
    query: async (query: string) => {
      if (/FROM statementReconciliation(?:\s|;)/.test(query)) {
        throw new Error("The table 'statementReconciliation' does not exist");
      }
      return [[]];
    },
  };
  const report = await auditHistorianCompatibility(client);
  assert.equal(report.schemaReadiness.complete, false);
  assert.deepEqual(report.schemaReadiness.missingCanonicalTables, [
    "statementReconciliation",
  ]);
  assert.equal(report.writesPerformed, 0);
});
