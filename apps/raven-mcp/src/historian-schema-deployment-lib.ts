import { createHash } from "node:crypto";

export type StatementTruthSchemaModel = Readonly<{
  name: string;
  model: string;
  migrationDirectory: string;
}>;

export const STATEMENT_TRUTH_SCHEMA_MODELS = [
  {
    name: "StatementSourceClaim",
    model: "statementSourceClaim",
    migrationDirectory: "statementsourceclaim",
  },
  {
    name: "StatementPeriodClaim",
    model: "statementPeriodClaim",
    migrationDirectory: "statementperiodclaim",
  },
  {
    name: "StatementRowComponent",
    model: "statementRowComponent",
    migrationDirectory: "statementrowcomponent",
  },
  {
    name: "StatementIssue",
    model: "statementIssue",
    migrationDirectory: "statementissue",
  },
  {
    name: "StatementTransactionMatch",
    model: "statementTransactionMatch",
    migrationDirectory: "statementtransactionmatch",
  },
  {
    name: "StatementComponentResolutionClaim",
    model: "statementComponentResolutionClaim",
    migrationDirectory: "statementcomponentresolutionclaim",
  },
  {
    name: "StatementTransactionResolutionClaim",
    model: "statementTransactionResolutionClaim",
    migrationDirectory: "statementtransactionresolutionclaim",
  },
  {
    name: "StatementReconciliation",
    model: "statementReconciliation",
    migrationDirectory: "statementreconciliation",
  },
  {
    name: "StatementReconciliationEvent",
    model: "statementReconciliationEvent",
    migrationDirectory: "statementreconciliationevent",
  },
] as const satisfies readonly StatementTruthSchemaModel[];

export type CanonicalSchemaDefinition = Readonly<{
  target: string;
  kind: "table" | "function" | "view";
  statement: string;
  sourceSha256: string;
}>;

export type SchemaPlanClassification = Readonly<{
  additiveTableDefinitions: number;
  additiveFunctionDefinitions: number;
  additiveViewDefinitions: number;
  compatibleDefinitionAlignments: number;
  destructiveOrDataChanging: number;
}>;

const forbiddenTopLevel =
  /^(?:DROP|REMOVE|DELETE|TRUNCATE|UPDATE|CREATE|UPSERT|INSERT|RELATE)\b/i;

export function sha256(value: string | Buffer): string {
  return createHash("sha256").update(value).digest("hex");
}

export function targetFingerprint(
  url: string,
  namespace: string,
  database: string,
): string {
  return `sha256:${sha256([url, namespace, database].join("\n"))}`;
}

export function assertSchemaDefinitionStatement(statement: string): void {
  const normalized = statement.trim();
  if (!normalized) throw new Error("Schema plan contains an empty statement");
  if (forbiddenTopLevel.test(normalized)) {
    throw new Error("HP01_DESTRUCTIVE_OR_DATA_CHANGING_PLAN");
  }
  if (
    !/^DEFINE\s+(?:TABLE|FUNCTION|FIELD|INDEX|EVENT|ANALYZER)\b/i.test(
      normalized,
    )
  ) {
    throw new Error("HP01_NON_SCHEMA_STATEMENT");
  }
}

export function classifySchemaPlan(
  definitions: readonly CanonicalSchemaDefinition[],
  existingTargets: Readonly<{
    tables: ReadonlySet<string>;
    functions: ReadonlySet<string>;
  }>,
): SchemaPlanClassification {
  const result = {
    additiveTableDefinitions: 0,
    additiveFunctionDefinitions: 0,
    additiveViewDefinitions: 0,
    compatibleDefinitionAlignments: 0,
    destructiveOrDataChanging: 0,
  };

  for (const definition of definitions) {
    assertSchemaDefinitionStatement(definition.statement);
    const exists =
      definition.kind === "function"
        ? existingTargets.functions.has(definition.target)
        : existingTargets.tables.has(definition.target);
    if (exists) {
      result.compatibleDefinitionAlignments += 1;
      continue;
    }
    if (definition.kind === "table") result.additiveTableDefinitions += 1;
    if (definition.kind === "function") result.additiveFunctionDefinitions += 1;
    if (definition.kind === "view") result.additiveViewDefinitions += 1;
  }

  return result;
}

export function assertAggregateCountInvariance(
  before: Readonly<Record<string, number>>,
  after: Readonly<Record<string, number>>,
  newlyIntroducedTables: ReadonlySet<string>,
): void {
  for (const [table, count] of Object.entries(before)) {
    if (after[table] !== count) {
      throw new Error(`HP01_AGGREGATE_COUNT_CHANGED:${table}`);
    }
  }
  for (const table of newlyIntroducedTables) {
    if (after[table] !== 0) {
      throw new Error(`HP01_NEW_SCHEMA_TABLE_NOT_EMPTY:${table}`);
    }
  }
}
