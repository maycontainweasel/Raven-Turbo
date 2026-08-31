import { execFileSync } from "node:child_process";
import { createHash } from "node:crypto";
import { lstat, readFile, readdir } from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { Surreal } from "surrealdb";
import { parse as parseYaml } from "yaml";
import {
  assertAggregateCountInvariance,
  assertSchemaDefinitionStatement,
  classifySchemaPlan,
  sha256,
  STATEMENT_TRUTH_SCHEMA_MODELS,
  targetFingerprint,
  type CanonicalSchemaDefinition,
} from "./historian-schema-deployment-lib.js";
import { loadRavenLocalConnectionConfig } from "./local-config.js";

type Mode = "plan" | "apply" | "verify";

type DatabaseStructureEntry = Readonly<{
  name?: string;
  kind?: unknown;
  schemafull?: boolean;
  permissions?: unknown;
  view?: unknown;
}>;

type DatabaseStructure = Readonly<{
  tables?: readonly DatabaseStructureEntry[] | Record<string, unknown>;
  functions?: readonly DatabaseStructureEntry[] | Record<string, unknown>;
}>;

type DatabaseSnapshot = Readonly<{
  structure: DatabaseStructure;
  tableNames: readonly string[];
  functionNames: readonly string[];
  counts: Readonly<Record<string, number>>;
  schemaShapeSha256: string;
  countVectorSha256: string;
}>;

type CanonicalBundle = Readonly<{
  definitions: readonly CanonicalSchemaDefinition[];
  graphSha256: string;
  contractSha256: string;
  modelCount: number;
  fieldCount: number;
  physicalFieldDefinitionCount: 0;
  indexDefinitionCount: 0;
  relationDefinitionCount: 0;
}>;

type BackupMetadata = Readonly<{
  opaqueRef?: string;
  targetFingerprint?: string;
  sha256?: string;
  archiveIntegrity?: boolean;
  extractionVerified?: boolean;
  restorable?: boolean;
}>;

function argument(name: string): string | undefined {
  const index = process.argv.indexOf(name);
  return index >= 0 ? process.argv[index + 1] : undefined;
}

function mode(): Mode {
  const value = argument("--mode") ?? "plan";
  if (value === "plan" || value === "apply" || value === "verify") {
    return value;
  }
  throw new Error("HP01_INVALID_MODE");
}

function structureNames(
  value:
    | readonly DatabaseStructureEntry[]
    | Record<string, unknown>
    | undefined,
): string[] {
  if (Array.isArray(value)) {
    return value
      .map((entry) => String(entry.name ?? ""))
      .filter(Boolean)
      .sort();
  }
  return Object.keys(value ?? {}).sort();
}

function queryRows(response: unknown): Array<Record<string, unknown>> {
  if (!Array.isArray(response)) return [];
  for (let index = response.length - 1; index >= 0; index -= 1) {
    const statement = response[index];
    const result =
      statement && typeof statement === "object" && "result" in statement
        ? (statement as { result?: unknown }).result
        : statement;
    if (Array.isArray(result)) {
      return result as Array<Record<string, unknown>>;
    }
  }
  return [];
}

async function captureSnapshot(client: Surreal): Promise<DatabaseSnapshot> {
  const info = (await client.query("INFO FOR DB STRUCTURE;")) as unknown[];
  const structure = (info[0] ?? {}) as DatabaseStructure;
  const tableNames = structureNames(structure.tables);
  const functionNames = structureNames(structure.functions);
  const counts: Record<string, number> = {};
  for (const table of tableNames) {
    if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(table)) {
      throw new Error("HP01_UNSAFE_SCHEMA_IDENTIFIER");
    }
    const rows = queryRows(
      await client.query(`SELECT count() AS count FROM ${table} GROUP ALL;`),
    );
    counts[table] = Number(rows[0]?.count ?? 0);
  }
  return {
    structure,
    tableNames,
    functionNames,
    counts,
    schemaShapeSha256: sha256(JSON.stringify(structure)),
    countVectorSha256: sha256(JSON.stringify(counts)),
  };
}

function schemaTableEntry(
  structure: DatabaseStructure,
  target: string,
): DatabaseStructureEntry | undefined {
  if (!Array.isArray(structure.tables)) return undefined;
  return structure.tables.find((entry) => entry.name === target);
}

function schemaFunctionEntry(
  structure: DatabaseStructure,
  target: string,
): DatabaseStructureEntry | undefined {
  if (!Array.isArray(structure.functions)) return undefined;
  return structure.functions.find((entry) => entry.name === target);
}

function permissionsAreFull(value: unknown): boolean {
  if (value === true) return true;
  if (!value || typeof value !== "object") return false;
  const permissions = value as Record<string, unknown>;
  return ["create", "delete", "select", "update"].every(
    (permission) => permissions[permission] === true,
  );
}

function normalizeSchemaText(value: string): string {
  return value
    .replace(/\s+/g, " ")
    .replace(/\s*,\s*/g, ", ")
    .trim();
}

function expectedFunctionArgs(statement: string): string[][] {
  const match = statement.match(
    /^DEFINE FUNCTION OVERWRITE fn::[^()]+\(([^)]*)\)/,
  );
  if (!match) throw new Error("HP01_INVALID_FUNCTION_HEADER");
  const source = match[1]?.trim() ?? "";
  if (!source) return [];
  return source.split(",").map((entry) => {
    const argumentMatch = entry
      .trim()
      .match(/^\$([A-Za-z_][A-Za-z0-9_]*):\s*(.+)$/);
    if (!argumentMatch) throw new Error("HP01_INVALID_FUNCTION_ARGUMENT");
    return [argumentMatch[1]!, normalizeSchemaText(argumentMatch[2]!)];
  });
}

function assertRemoteDefinitionShape(
  structure: DatabaseStructure,
  definitions: readonly CanonicalSchemaDefinition[],
): void {
  for (const definition of definitions) {
    if (definition.kind === "function") {
      const entry = schemaFunctionEntry(structure, definition.target) as
        | (DatabaseStructureEntry & { args?: unknown })
        | undefined;
      if (
        !entry ||
        !permissionsAreFull(entry.permissions) ||
        JSON.stringify(entry.args ?? []) !==
          JSON.stringify(expectedFunctionArgs(definition.statement))
      ) {
        throw new Error(
          `HP01_REMOTE_FUNCTION_DEFINITION_MISMATCH:${definition.target}`,
        );
      }
      continue;
    }

    const entry = schemaTableEntry(structure, definition.target);
    const kind =
      entry?.kind && typeof entry.kind === "object" && "kind" in entry.kind
        ? String((entry.kind as { kind?: unknown }).kind)
        : String(entry?.kind ?? "");
    if (
      !entry ||
      kind !== "NORMAL" ||
      entry.schemafull !== false ||
      !permissionsAreFull(entry.permissions)
    ) {
      throw new Error(
        `HP01_REMOTE_TABLE_DEFINITION_MISMATCH:${definition.target}`,
      );
    }
    if (definition.kind === "table" && entry.view != null) {
      throw new Error(
        `HP01_REMOTE_TABLE_DEFINITION_MISMATCH:${definition.target}`,
      );
    }
    if (definition.kind === "view") {
      const expectedView = definition.statement.match(
        /\bAS\s+([\s\S]*?)\s+PERMISSIONS\s+FULL;$/i,
      )?.[1];
      if (
        !expectedView ||
        normalizeSchemaText(String(entry.view ?? "")).replace(/^AS\s+/i, "") !==
          normalizeSchemaText(expectedView)
      ) {
        throw new Error(
          `HP01_REMOTE_VIEW_DEFINITION_MISMATCH:${definition.target}`,
        );
      }
    }
  }
}

function assertExistingBaseTableCompatible(
  structure: DatabaseStructure,
  target: string,
): void {
  const entry = schemaTableEntry(structure, target);
  if (!entry) return;
  if (entry.view != null || entry.schemafull === true) {
    throw new Error(`HP01_INCOMPATIBLE_EXISTING_TABLE:${target}`);
  }
}

function splitViewDefinitions(
  content: string,
  model: string,
  adminView: string,
): readonly [string, string] {
  const separator = content.indexOf(";");
  if (separator < 0) throw new Error(`HP01_INVALID_VIEW_ARTIFACT:${adminView}`);
  const tableDefinition = content.slice(0, separator + 1).trim();
  const viewDefinition = content.slice(separator + 1).trim();
  const expectedTable = `DEFINE TABLE IF NOT EXISTS ${model} TYPE NORMAL SCHEMALESS PERMISSIONS FULL;`;
  if (tableDefinition !== expectedTable) {
    throw new Error(`HP01_UNEXPECTED_TABLE_DEFINITION:${model}`);
  }
  if (
    !viewDefinition.startsWith(
      `DEFINE TABLE OVERWRITE ${adminView} TYPE NORMAL AS`,
    ) ||
    !viewDefinition.endsWith(";")
  ) {
    throw new Error(`HP01_UNEXPECTED_VIEW_DEFINITION:${adminView}`);
  }
  return [tableDefinition, viewDefinition];
}

async function loadCanonicalBundle(
  repositoryRoot: string,
): Promise<CanonicalBundle> {
  const schemaRoot = path.join(repositoryRoot, "apps", "schema");
  const graph = await readFile(
    path.join(schemaRoot, "config", "graph.mpdg"),
    "utf8",
  );
  const definitions: CanonicalSchemaDefinition[] = [];
  const contractHashes: string[] = [];
  let fieldCount = 0;

  for (const model of STATEMENT_TRUTH_SCHEMA_MODELS) {
    const specPath = path.join(
      schemaRoot,
      "config",
      "specs",
      `${model.name}(${model.model})`,
      `${model.model}.primary.yaml`,
    );
    const specSource = await readFile(specPath, "utf8");
    const spec = parseYaml(specSource) as {
      name?: string;
      table?: { model?: string; schemaMode?: string; permissions?: string };
      id?: { structure?: string };
      fields?: unknown[];
    };
    if (
      spec.name !== model.name ||
      spec.table?.model !== model.model ||
      spec.table.schemaMode !== "schemaless" ||
      spec.table.permissions !== "full" ||
      typeof spec.id?.structure !== "string" ||
      !Array.isArray(spec.fields)
    ) {
      throw new Error(`HP01_CANONICAL_SPEC_MISMATCH:${model.model}`);
    }
    fieldCount += spec.fields.length;
    contractHashes.push(sha256(specSource));

    const migrationRoot = path.join(
      schemaRoot,
      "config",
      "migrations",
      model.migrationDirectory,
    );
    const viewSource = await readFile(
      path.join(migrationRoot, `V_${model.name}Admin.surql`),
      "utf8",
    );
    const [tableDefinition, viewDefinition] = splitViewDefinitions(
      viewSource,
      model.model,
      `${model.name}Admin`,
    );
    definitions.push({
      target: model.model,
      kind: "table",
      statement: tableDefinition,
      sourceSha256: sha256(viewSource),
    });

    for (const operation of ["create", "update", "delete"] as const) {
      const functionName = `${operation}${model.name}`;
      const source = await readFile(
        path.join(migrationRoot, `F_${functionName}.surql`),
        "utf8",
      );
      if (
        !source
          .trim()
          .startsWith(`DEFINE FUNCTION OVERWRITE fn::${functionName}(`) ||
        !source.trim().endsWith("};") ||
        /\b(?:DROP|TRUNCATE)\b/i.test(source)
      ) {
        throw new Error(`HP01_UNEXPECTED_FUNCTION_DEFINITION:${functionName}`);
      }
      definitions.push({
        target: functionName,
        kind: "function",
        statement: source.trim(),
        sourceSha256: sha256(source),
      });
    }

    definitions.push({
      target: `${model.name}Admin`,
      kind: "view",
      statement: viewDefinition,
      sourceSha256: sha256(viewSource),
    });
  }

  definitions.forEach((definition) =>
    assertSchemaDefinitionStatement(definition.statement),
  );
  return {
    definitions,
    graphSha256: sha256(graph),
    contractSha256: sha256(contractHashes.sort().join("\n")),
    modelCount: STATEMENT_TRUTH_SCHEMA_MODELS.length,
    fieldCount,
    physicalFieldDefinitionCount: 0,
    indexDefinitionCount: 0,
    relationDefinitionCount: 0,
  };
}

async function connect(): Promise<{
  client: Surreal;
  repositoryRoot: string;
  fingerprint: string;
}> {
  const config = await loadRavenLocalConnectionConfig();
  const fingerprint = targetFingerprint(
    config.url,
    config.namespace,
    config.database,
  );
  const client = new Surreal();
  await client.connect(config.url);
  await client.signin({
    username: config.username,
    password: config.password,
  });
  await client.use({
    namespace: config.namespace,
    database: config.database,
  });
  return { client, repositoryRoot: config.repositoryRoot, fingerprint };
}

async function fileSha256(filePath: string): Promise<string> {
  return createHash("sha256")
    .update(await readFile(filePath))
    .digest("hex");
}

async function verifyRecoveryPoint(
  expectedReference: string,
  fingerprint: string,
): Promise<{ opaqueRef: string; sha256: string; verified: true }> {
  const root = path.join(
    os.homedir(),
    "Library",
    "Application Support",
    "command-center",
    "surreal-backups",
    "raven-turbo",
  );
  const rootStat = await lstat(root);
  if (
    !rootStat.isDirectory() ||
    rootStat.isSymbolicLink() ||
    (rootStat.mode & 0o777) !== 0o700
  ) {
    throw new Error("HP01_BACKUP_REQUIRED");
  }
  for (const directory of await readdir(root)) {
    const backupDirectory = path.join(root, directory);
    let metadata: BackupMetadata;
    try {
      metadata = JSON.parse(
        await readFile(
          path.join(backupDirectory, "backup-metadata.json"),
          "utf8",
        ),
      ) as BackupMetadata;
    } catch {
      continue;
    }
    if (metadata.opaqueRef !== expectedReference) continue;
    const directoryStat = await lstat(backupDirectory);
    const artifact = path.join(backupDirectory, "rocksdb-cold-snapshot.tar.gz");
    const artifactStat = await lstat(artifact);
    if (
      !directoryStat.isDirectory() ||
      directoryStat.isSymbolicLink() ||
      (directoryStat.mode & 0o777) !== 0o700 ||
      !artifactStat.isFile() ||
      artifactStat.isSymbolicLink() ||
      (artifactStat.mode & 0o777) !== 0o600 ||
      metadata.targetFingerprint !== fingerprint ||
      metadata.restorable !== true ||
      metadata.archiveIntegrity !== true ||
      metadata.extractionVerified !== true ||
      metadata.sha256 !== (await fileSha256(artifact))
    ) {
      throw new Error("HP01_BACKUP_REQUIRED");
    }
    execFileSync("tar", ["-tzf", artifact], { stdio: "ignore" });
    return {
      opaqueRef: expectedReference,
      sha256: metadata.sha256,
      verified: true,
    };
  }
  throw new Error("HP01_BACKUP_REQUIRED");
}

function safeSnapshot(snapshot: DatabaseSnapshot): object {
  return {
    tableCount: snapshot.tableNames.length,
    schemaShapeSha256: snapshot.schemaShapeSha256,
    countVectorSha256: snapshot.countVectorSha256,
    aggregateCounts: snapshot.counts,
  };
}

async function main(): Promise<void> {
  const selectedMode = mode();
  const { client, repositoryRoot, fingerprint } = await connect();
  try {
    const bundle = await loadCanonicalBundle(repositoryRoot);
    const before = await captureSnapshot(client);
    for (const model of STATEMENT_TRUTH_SCHEMA_MODELS) {
      assertExistingBaseTableCompatible(before.structure, model.model);
    }
    const existingTargets = {
      tables: new Set(before.tableNames),
      functions: new Set(before.functionNames),
    };
    const classification = classifySchemaPlan(
      bundle.definitions,
      existingTargets,
    );
    const missingBaseTables = STATEMENT_TRUTH_SCHEMA_MODELS.map(
      (entry) => entry.model,
    ).filter((table) => !existingTargets.tables.has(table));
    const plan = {
      mode: selectedMode,
      targetFingerprint: fingerprint,
      canonicalGraphSha256: bundle.graphSha256,
      canonicalContractSha256: bundle.contractSha256,
      canonicalModelCount: bundle.modelCount,
      canonicalFieldCount: bundle.fieldCount,
      physicalFieldDefinitionCount: bundle.physicalFieldDefinitionCount,
      indexDefinitionCount: bundle.indexDefinitionCount,
      relationDefinitionCount: bundle.relationDefinitionCount,
      definitionCount: bundle.definitions.length,
      classification,
      missingBaseTables,
      topLevelStatementsOnly: "DEFINE",
      functionBodiesExecuted: false,
      privateRowsRead: false,
      baseline: safeSnapshot(before),
    };

    if (selectedMode === "plan" || selectedMode === "verify") {
      if (selectedMode === "verify") {
        assertRemoteDefinitionShape(before.structure, bundle.definitions);
      }
      process.stdout.write(
        `${JSON.stringify(
          {
            ...plan,
            canonicalDefinitionShapeVerified: selectedMode === "verify",
          },
          null,
          2,
        )}\n`,
      );
      return;
    }

    if (
      classification.destructiveOrDataChanging !== 0 ||
      classification.compatibleDefinitionAlignments !== 0 ||
      missingBaseTables.length !== STATEMENT_TRUTH_SCHEMA_MODELS.length
    ) {
      throw new Error("HP01_PLAN_NOT_PURELY_ADDITIVE");
    }
    const confirmedFingerprint = argument("--target-fingerprint");
    const backupReference = argument("--backup-ref");
    if (confirmedFingerprint !== fingerprint || !backupReference) {
      throw new Error("HP01_TARGET_CONFIRMATION_REQUIRED");
    }
    const recoveryPoint = await verifyRecoveryPoint(
      backupReference,
      fingerprint,
    );

    const transaction = [
      "BEGIN TRANSACTION;",
      ...bundle.definitions.map((definition) => definition.statement),
      "COMMIT TRANSACTION;",
    ].join("\n\n");
    await client.query(transaction);

    const after = await captureSnapshot(client);
    assertRemoteDefinitionShape(after.structure, bundle.definitions);
    const expectedBaseTables = new Set(
      STATEMENT_TRUTH_SCHEMA_MODELS.map((entry) => entry.model),
    );
    const expectedAdminViews = new Set(
      STATEMENT_TRUTH_SCHEMA_MODELS.map((entry) => `${entry.name}Admin`),
    );
    const expectedNewTables = new Set([
      ...expectedBaseTables,
      ...expectedAdminViews,
    ]);
    const expectedFunctions = new Set(
      STATEMENT_TRUTH_SCHEMA_MODELS.flatMap((entry) =>
        ["create", "update", "delete"].map(
          (operation) => `${operation}${entry.name}`,
        ),
      ),
    );
    assertAggregateCountInvariance(
      before.counts,
      after.counts,
      expectedNewTables,
    );
    for (const table of expectedNewTables) {
      if (!after.tableNames.includes(table)) {
        throw new Error(`HP01_SCHEMA_TARGET_MISSING:${table}`);
      }
    }
    for (const functionName of expectedFunctions) {
      if (!after.functionNames.includes(functionName)) {
        throw new Error(`HP01_SCHEMA_TARGET_MISSING:${functionName}`);
      }
    }
    const newlyPresentTables = after.tableNames.filter(
      (table) => !before.tableNames.includes(table),
    );
    const newlyPresentFunctions = after.functionNames.filter(
      (functionName) => !before.functionNames.includes(functionName),
    );
    if (
      newlyPresentTables.length !== expectedNewTables.size ||
      newlyPresentFunctions.length !== expectedFunctions.size ||
      newlyPresentTables.some((table) => !expectedNewTables.has(table)) ||
      newlyPresentFunctions.some(
        (functionName) => !expectedFunctions.has(functionName),
      )
    ) {
      throw new Error("HP01_UNEXPECTED_SCHEMA_DELTA");
    }

    process.stdout.write(
      `${JSON.stringify(
        {
          status: "schema_applied_and_verified",
          targetFingerprint: fingerprint,
          recoveryPoint,
          plan: {
            ...plan,
            baseline: safeSnapshot(before),
          },
          schemaApplied: true,
          transactionCount: 1,
          destructiveOrDataChangingFound: false,
          canonicalDefinitionShapeVerified: true,
          newlyPresentTables,
          newlyPresentFunctions,
          newBaseTablesEmpty: [...expectedBaseTables].every(
            (table) => after.counts[table] === 0,
          ),
          newAdminViewsEmpty: [...expectedAdminViews].every(
            (table) => after.counts[table] === 0,
          ),
          preExistingAggregateCountsUnchanged: true,
          before: safeSnapshot(before),
          after: safeSnapshot(after),
          financialRecordWritesPerformed: 0,
          privateRowsRead: false,
          migrationOrReplayPerformed: false,
        },
        null,
        2,
      )}\n`,
    );
  } finally {
    await client.close();
  }
}

main().catch((error) => {
  const repositoryRoot = process.env.RAVEN_REPOSITORY_ROOT ?? "";
  let message = error instanceof Error ? error.message : String(error);
  if (repositoryRoot)
    message = message.replaceAll(repositoryRoot, "[repository]");
  message = message.replaceAll(os.homedir(), "[home]");
  process.stderr.write(`HP-01 schema deployment failed: ${message}\n`);
  process.exitCode = 1;
});
