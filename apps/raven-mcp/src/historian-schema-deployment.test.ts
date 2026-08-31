import assert from "node:assert/strict";
import test from "node:test";
import {
  assertAggregateCountInvariance,
  assertSchemaDefinitionStatement,
  classifySchemaPlan,
  STATEMENT_TRUTH_SCHEMA_MODELS,
  targetFingerprint,
  type CanonicalSchemaDefinition,
} from "./historian-schema-deployment-lib.js";

test("HP-01 catalog is exactly the nine accepted Statement Truth models", () => {
  assert.equal(STATEMENT_TRUTH_SCHEMA_MODELS.length, 9);
  assert.deepEqual(
    STATEMENT_TRUTH_SCHEMA_MODELS.map((entry) => entry.model),
    [
      "statementSourceClaim",
      "statementPeriodClaim",
      "statementRowComponent",
      "statementIssue",
      "statementTransactionMatch",
      "statementComponentResolutionClaim",
      "statementTransactionResolutionClaim",
      "statementReconciliation",
      "statementReconciliationEvent",
    ],
  );
});

test("target fingerprint excludes credentials and is deterministic", () => {
  const first = targetFingerprint("http://127.0.0.1:2993", "ns", "db");
  const second = targetFingerprint("http://127.0.0.1:2993", "ns", "db");
  assert.equal(first, second);
  assert.match(first, /^sha256:[a-f0-9]{64}$/);
  assert.doesNotMatch(first, /ns|db|127\.0\.0\.1/);
});

test("schema definitions may contain dormant CRUD inside a function body", () => {
  assert.doesNotThrow(() =>
    assertSchemaDefinitionStatement(
      "DEFINE FUNCTION OVERWRITE fn::example() { CREATE example; UPDATE example; DELETE example; };",
    ),
  );
});

test("top-level destructive and row-changing statements fail closed", () => {
  for (const statement of [
    "REMOVE TABLE example;",
    "DROP TABLE example;",
    "DELETE example;",
    "UPDATE example SET value = 1;",
    "CREATE example CONTENT {};",
    "TRUNCATE TABLE example;",
  ]) {
    assert.throws(
      () => assertSchemaDefinitionStatement(statement),
      /HP01_DESTRUCTIVE_OR_DATA_CHANGING_PLAN/,
    );
  }
});

test("an absent target produces an additive-only classification", () => {
  const definitions: CanonicalSchemaDefinition[] = [
    {
      target: "statementIssue",
      kind: "table",
      statement:
        "DEFINE TABLE IF NOT EXISTS statementIssue TYPE NORMAL SCHEMALESS PERMISSIONS FULL;",
      sourceSha256: "a",
    },
    {
      target: "createStatementIssue",
      kind: "function",
      statement:
        "DEFINE FUNCTION OVERWRITE fn::createStatementIssue() { RETURN NONE; };",
      sourceSha256: "b",
    },
    {
      target: "StatementIssueAdmin",
      kind: "view",
      statement:
        "DEFINE TABLE OVERWRITE StatementIssueAdmin TYPE NORMAL AS SELECT id FROM statementIssue PERMISSIONS FULL;",
      sourceSha256: "c",
    },
  ];
  assert.deepEqual(
    classifySchemaPlan(definitions, {
      tables: new Set(),
      functions: new Set(),
    }),
    {
      additiveTableDefinitions: 1,
      additiveFunctionDefinitions: 1,
      additiveViewDefinitions: 1,
      compatibleDefinitionAlignments: 0,
      destructiveOrDataChanging: 0,
    },
  );
});

test("aggregate verification preserves old counts and requires new tables empty", () => {
  assert.doesNotThrow(() =>
    assertAggregateCountInvariance(
      { transaction: 10, statementImport: 2 },
      { transaction: 10, statementImport: 2, statementIssue: 0 },
      new Set(["statementIssue"]),
    ),
  );
  assert.throws(
    () =>
      assertAggregateCountInvariance(
        { transaction: 10 },
        { transaction: 11, statementIssue: 0 },
        new Set(["statementIssue"]),
      ),
    /HP01_AGGREGATE_COUNT_CHANGED:transaction/,
  );
  assert.throws(
    () =>
      assertAggregateCountInvariance(
        { transaction: 10 },
        { transaction: 10, statementIssue: 1 },
        new Set(["statementIssue"]),
      ),
    /HP01_NEW_SCHEMA_TABLE_NOT_EMPTY:statementIssue/,
  );
});
