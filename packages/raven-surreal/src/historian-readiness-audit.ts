import type { SurrealQueryClient } from "./repository.js";
import { auditImportIdentityCompatibility } from "./import-identity-migration.js";

type RawRow = Record<string, unknown>;

const requiredStatementTables = [
  "financialOperation",
  "statementImport",
  "statementSourceClaim",
  "statementPeriodClaim",
  "statementRow",
  "statementRowComponent",
  "statementIssue",
  "statementTransactionMatch",
  "statementComponentResolutionClaim",
  "statementTransactionResolutionClaim",
  "statementReconciliation",
  "statementReconciliationEvent",
  "transaction",
] as const;

export type HistorianCompatibilityClasses = Readonly<{
  canonicalImports: number;
  activeCanonicalImports: number;
  supersededCanonicalImports: number;
  activeLegacyImports: number;
  legacyIdentities: number;
  mappableLegacyPeriods: number;
  unmappableLegacyImports: number;
  periodsAlreadyOccupied: number;
  canonicalOnlyPeriods: number;
  legacyOnlyPeriods: number;
  mixedCanonicalLegacyPeriods: number;
  canonicalImportsWithoutReconciliation: number;
  sourceBackedTransactionsWithoutSt02Matches: number;
}>;

export type HistorianCompatibilityAuditReport = Readonly<{
  mode: "aggregate_only_audit";
  writesPerformed: 0;
  recordDetailsIncluded: false;
  schemaReadiness: Readonly<{
    complete: boolean;
    missingCanonicalTables: readonly string[];
  }>;
  compatibilityClasses: HistorianCompatibilityClasses;
}>;

function rows(response: unknown): RawRow[] {
  if (!Array.isArray(response)) return [];
  for (let index = response.length - 1; index >= 0; index -= 1) {
    const statement = response[index];
    const result =
      statement && typeof statement === "object" && "result" in statement
        ? (statement as { result?: unknown }).result
        : statement;
    if (Array.isArray(result)) return result as RawRow[];
  }
  return [];
}

function identityPart(value: unknown): string {
  if (typeof value === "string") return value;
  if (!value || typeof value !== "object") return "";
  const record = value as Record<string, unknown>;
  if (record.tb && record.id)
    return `${String(record.tb)}:${String(record.id)}`;
  return record.id ? String(record.id) : "";
}

function present(value: unknown): boolean {
  return (
    value !== undefined && value !== null && value !== "" && value !== "NONE"
  );
}

function dateOnly(value: unknown): string | null {
  const normalized = String(value ?? "");
  return /^\d{4}-\d{2}-\d{2}$/.test(normalized) ? normalized : null;
}

function periodKey(row: RawRow): string | null {
  const account = identityPart(row.account);
  const periodStart = dateOnly(row.periodStart);
  const periodEnd = dateOnly(row.periodEnd);
  return account && periodStart && periodEnd
    ? `${account}|${periodStart}|${periodEnd}`
    : null;
}

function isCanonicalImport(row: RawRow): boolean {
  return row.sourceState === "committed" || row.sourceState === "superseded";
}

async function readTable(
  client: SurrealQueryClient,
  table: string,
  query: string,
): Promise<{ available: boolean; records: RawRow[] }> {
  try {
    return { available: true, records: rows(await client.query(query)) };
  } catch (error) {
    if (
      error instanceof Error &&
      error.message.includes(`table '${table}' does not exist`)
    ) {
      return { available: false, records: [] };
    }
    throw error;
  }
}

async function tableAvailable(
  client: SurrealQueryClient,
  table: string,
): Promise<boolean> {
  try {
    await client.query(`SELECT count() AS count FROM ${table} GROUP ALL;`);
    return true;
  } catch (error) {
    if (
      error instanceof Error &&
      error.message.includes(`table '${table}' does not exist`)
    ) {
      return false;
    }
    throw error;
  }
}

export async function auditHistorianCompatibility(
  client: SurrealQueryClient,
): Promise<HistorianCompatibilityAuditReport> {
  const [
    importRead,
    transactionRead,
    reconciliationRead,
    identityReport,
    tableAvailability,
  ] = await Promise.all([
    readTable(
      client,
      "statementImport",
      "SELECT id, account, periodStart, periodEnd, sourceState FROM statementImport ORDER BY id;",
    ),
    readTable(
      client,
      "transaction",
      'SELECT id, entrySource, sourceRow, statementMatch FROM transaction WHERE entrySource = "imported" OR sourceRow != NONE ORDER BY id;',
    ),
    readTable(
      client,
      "statementReconciliation",
      "SELECT id, statementImport FROM statementReconciliation ORDER BY id;",
    ),
    auditImportIdentityCompatibility(client),
    Promise.all(
      requiredStatementTables.map(
        async (table) => [table, await tableAvailable(client, table)] as const,
      ),
    ),
  ]);

  const imports = importRead.records;
  const transactions = transactionRead.records;
  const reconciledImports = new Set(
    reconciliationRead.records
      .map((row) => identityPart(row.statementImport))
      .filter(Boolean),
  );
  const periodStates = new Map<
    string,
    { canonical: boolean; legacy: boolean }
  >();
  const mappableLegacyPeriodKeys = new Set<string>();
  let canonicalImports = 0;
  let activeCanonicalImports = 0;
  let supersededCanonicalImports = 0;
  let activeLegacyImports = 0;
  let unmappableLegacyImports = 0;
  let canonicalImportsWithoutReconciliation = 0;

  for (const statementImport of imports) {
    const canonical = isCanonicalImport(statementImport);
    const key = periodKey(statementImport);
    if (canonical) {
      canonicalImports += 1;
      if (statementImport.sourceState === "committed")
        activeCanonicalImports += 1;
      if (statementImport.sourceState === "superseded")
        supersededCanonicalImports += 1;
      if (!reconciledImports.has(identityPart(statementImport.id))) {
        canonicalImportsWithoutReconciliation += 1;
      }
    } else {
      activeLegacyImports += 1;
      if (key) mappableLegacyPeriodKeys.add(key);
      else unmappableLegacyImports += 1;
    }
    if (key) {
      const state = periodStates.get(key) ?? {
        canonical: false,
        legacy: false,
      };
      state.canonical ||= canonical;
      state.legacy ||= !canonical;
      periodStates.set(key, state);
    }
  }

  const periodValues = [...periodStates.values()];
  const sourceBackedTransactionsWithoutSt02Matches = transactions.filter(
    (transaction) =>
      (transaction.entrySource === "imported" ||
        present(transaction.sourceRow)) &&
      !present(transaction.statementMatch),
  ).length;

  return {
    mode: "aggregate_only_audit",
    writesPerformed: 0,
    recordDetailsIncluded: false,
    schemaReadiness: {
      complete: tableAvailability.every(([, available]) => available),
      missingCanonicalTables: tableAvailability
        .filter(([, available]) => !available)
        .map(([table]) => String(table)),
    },
    compatibilityClasses: {
      canonicalImports,
      activeCanonicalImports,
      supersededCanonicalImports,
      activeLegacyImports,
      legacyIdentities: identityReport.legacyIdentities,
      mappableLegacyPeriods: mappableLegacyPeriodKeys.size,
      unmappableLegacyImports,
      periodsAlreadyOccupied: periodStates.size,
      canonicalOnlyPeriods: periodValues.filter(
        (state) => state.canonical && !state.legacy,
      ).length,
      legacyOnlyPeriods: periodValues.filter(
        (state) => state.legacy && !state.canonical,
      ).length,
      mixedCanonicalLegacyPeriods: periodValues.filter(
        (state) => state.legacy && state.canonical,
      ).length,
      canonicalImportsWithoutReconciliation,
      sourceBackedTransactionsWithoutSt02Matches,
    },
  };
}
