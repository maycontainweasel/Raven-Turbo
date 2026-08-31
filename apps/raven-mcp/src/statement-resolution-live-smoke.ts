import assert from "node:assert/strict";
import { spawn, type ChildProcess } from "node:child_process";
import { randomUUID } from "node:crypto";
import { once } from "node:events";
import net from "node:net";
import {
  canonicalStatementJson,
  createStatementResolutionService,
  RavenDomainError,
  statementSha256,
  type StatementCommitDraft,
  type StatementImportRecord,
  type StatementImportSupersessionDraft,
  type StatementResolutionApi,
} from "@raven/domain/server";
import {
  createSurrealAccountControlRepository,
  createSurrealStatementResolutionRepository,
  createSurrealStatementTruthRepository,
} from "@raven/surreal";
import { Surreal } from "surrealdb";

const SPACE_KEY = "st02-fictional-space";
const ACCOUNT_KEY = "st02-fictional-account";
const NOW = "2026-08-04T12:00:00.000Z";
const USERNAME = "st02-smoke";
const PASSWORD = randomUUID();

async function reservePort() {
  const server = net.createServer();
  server.listen(0, "127.0.0.1");
  await once(server, "listening");
  const address = server.address();
  assert(address && typeof address === "object");
  server.close();
  await once(server, "close");
  return address.port;
}

async function waitForHealth(endpoint: string, process: ChildProcess) {
  for (let attempt = 0; attempt < 100; attempt += 1) {
    if (process.exitCode !== null)
      throw new Error("Disposable SurrealDB exited");
    try {
      if ((await fetch(`${endpoint}/health`)).ok) return;
    } catch {
      // Startup socket refusal is expected.
    }
    await new Promise((resolve) => setTimeout(resolve, 100));
  }
  throw new Error("Disposable SurrealDB did not become healthy");
}

async function connect(endpoint: string) {
  const client = new Surreal();
  await client.connect(endpoint);
  await client.signin({ username: USERNAME, password: PASSWORD });
  await client.use({
    namespace: "raven_st02_fictional",
    database: "raven_st02_fictional",
  });
  return client;
}

async function stop(process: ChildProcess | null) {
  if (!process || process.exitCode !== null) return;
  process.kill("SIGTERM");
  await Promise.race([
    once(process, "exit"),
    new Promise((resolve) => setTimeout(resolve, 2_000)),
  ]);
  if (process.exitCode === null) {
    process.kill("SIGKILL");
    await once(process, "exit");
  }
}

async function scalar(
  client: Surreal,
  query: string,
  vars?: Record<string, unknown>,
): Promise<number> {
  const response = await client.query(query, vars);
  const value = response
    .flat(Infinity)
    .find((item) => typeof item === "number");
  return Number(value ?? 0);
}

function required(value: string | undefined, label: string): string {
  assert(value, `${label} was not seeded`);
  return value
    .replace(/^([^:]+):`([\s\S]*)`$/, "$1:$2")
    .replace(/^([^:]+):⟨([\s\S]*)⟩$/, "$1:$2");
}

function reconciliationExpectation(
  reconciliation:
    | { revision: number; calculationHash: string }
    | null
    | undefined,
) {
  return {
    expectedReconciliationRevision: reconciliation?.revision ?? null,
    expectedReconciliationHash: reconciliation?.calculationHash ?? null,
  };
}

async function alignFictionalAccountContext(
  client: Surreal,
  statementImportId: string,
): Promise<string> {
  const account = await createSurrealStatementTruthRepository(
    client,
  ).getAccount(SPACE_KEY, ACCOUNT_KEY);
  assert(account);
  const context = {
    spaceId: account.spaceId,
    accountId: account.id,
    spaceKey: account.spaceKey,
    accountKey: account.key,
    currency: account.currency,
    normalNature: account.normalNature,
    accountNumberLast4: account.accountNumberLast4 ?? null,
    spaceTimezone: account.spaceTimezone || "Africa/Johannesburg",
  };
  const accountContextFingerprint = statementSha256(
    canonicalStatementJson(context),
  );
  await client.query(
    `UPDATE ONLY type::record("statementImport", $importKey)
     SET accountContextFingerprint = $accountContextFingerprint;`,
    {
      importKey: statementImportId.slice("statementImport:".length),
      accountContextFingerprint,
    },
  );
  return accountContextFingerprint;
}

function resolutionService(client: Surreal): StatementResolutionApi {
  return createStatementResolutionService({
    sourceRepository: createSurrealStatementTruthRepository(client),
    repository: createSurrealStatementResolutionRepository(client),
    clock: () => NOW,
  });
}

async function seedMatchRace(input: {
  client: Surreal;
  importKey: string;
  componentKey: string;
  date: string;
  amountMinor: number;
  transactionKeys: readonly string[];
}) {
  await input.client.query(
    `LET $spaceId = type::record("financialSpace", $spaceKey);
     LET $accountId = type::record("account", fn::stringID([$spaceId, $accountKey]));
     LET $importId = type::record("statementImport", fn::stringID([$accountId, $importKey]));
     LET $rowId = type::record("statementRow", fn::stringID([$importId, "row-1"]));
     LET $componentId = type::record("statementRowComponent", fn::stringID([$rowId, $componentKey]));
     CREATE ONLY $importId CONTENT {
       space: $spaceId, account: $accountId, key: $importKey,
       privateSourceRef: "redacted-fictional-race-source",
       originalFileSha256: crypto::sha256(string::concat($importKey, "-original")),
       canonicalExtractionSha256: crypto::sha256(string::concat($importKey, "-extraction")),
       previewHash: crypto::sha256(string::concat($importKey, "-preview")),
       sourceFormat: "pdf", sourceMimeType: "application/pdf", sourceByteSize: 42,
       profileId: "fictional-profile", profileVersion: "1",
       extractorVersion: "statement-neutral-v0.3",
       validationRulesetVersion: "statement-validation-v0.3",
       periodStart: $date, periodEnd: $date, currency: "ZAR",
       balanceConvention: "positive_is_asset", balanceConventionAuthority: "profile",
       accountContextFingerprint: crypto::sha256(string::concat($importKey, "-context")),
       openingBalanceMinor: 0, closingBalanceMinor: <int> $amountMinor,
       closingBalanceEconomicNature: "asset",
       coverage: { status: "complete", sourcePageCount: 1, processedPages: [1],
         sourceSections: ["transactions"], processedSections: ["transactions"],
         printedRowCount: 1, extractedRowCount: 1 },
       sourceState: "committed", importedAt: $now, committedAt: $now,
       rowCount: 1, componentCount: 1, issueCount: 0, revision: 1,
       statementDate: $date
     };
     CREATE ONLY $rowId CONTENT {
       space: $spaceId, account: $accountId, statementImport: $importId,
       key: "row-1", rowNumber: 1, rowKind: "movement",
       transactionDate: $date, postingDate: $date,
       description: "Fictional race movement", componentCount: 1,
       extractionConfidence: 1,
       rowHash: crypto::sha256(string::concat($importKey, "-row"))
     };
     CREATE ONLY $componentId CONTENT {
       space: $spaceId, account: $accountId, statementImport: $importId,
       statementRow: $rowId, key: $componentKey, componentKind: "principal",
       componentRole: "movement", transactionDate: $date, postingDate: $date,
       description: "Fictional race movement", amountMinor: <int> $amountMinor,
       currency: "ZAR", sourceDirection: "credit", sourceFlow: "inflow",
       balanceEffectMinor: <int> $amountMinor, confidence: 1,
       sourceChecksum: crypto::sha256(string::concat($importKey, "-component")),
       sourceState: "committed"
     };
     FOR $transactionKey IN $transactionKeys {
       LET $transactionId = type::record("transaction", fn::stringID([$accountId, $transactionKey]));
       CREATE ONLY $transactionId CONTENT {
         space: $spaceId, account: $accountId, key: $transactionKey,
         postedAt: $date, recordedAt: $now,
         description: "Fictional race movement", amountMinor: <int> $amountMinor,
         currency: "ZAR", direction: "credit", transactionKind: "income",
         flowDirection: "inflow", entrySource: "manual", status: "normalized"
       };
     };`,
    {
      spaceKey: SPACE_KEY,
      accountKey: ACCOUNT_KEY,
      importKey: input.importKey,
      componentKey: input.componentKey,
      date: input.date,
      amountMinor: input.amountMinor,
      transactionKeys: input.transactionKeys,
      now: NOW,
    },
  );
  const [statementImportId, componentId] = await Promise.all([
    input.client.query(
      `RETURN type::string((SELECT VALUE id FROM statementImport WHERE key = $key)[0]);`,
      { key: input.importKey },
    ),
    input.client.query(
      `RETURN type::string((SELECT VALUE id FROM statementRowComponent WHERE key = $key AND statementImport.key = $importKey)[0]);`,
      { key: input.componentKey, importKey: input.importKey },
    ),
  ]);
  const transactionIds = await Promise.all(
    input.transactionKeys.map(async (key) =>
      required(
        String(
          (
            await input.client.query(
              `RETURN type::string((SELECT VALUE id FROM transaction WHERE key = $key)[0]);`,
              { key },
            )
          )
            .flat(Infinity)
            .find(Boolean),
        ),
        `transaction ${key}`,
      ),
    ),
  );
  const resolvedStatementImportId = required(
    String(statementImportId.flat(Infinity).find(Boolean)),
    `statement import ${input.importKey}`,
  );
  await alignFictionalAccountContext(input.client, resolvedStatementImportId);
  await seedSourceClaims(input.client, resolvedStatementImportId);
  return {
    statementImportId: resolvedStatementImportId,
    componentId: required(
      String(componentId.flat(Infinity).find(Boolean)),
      `component ${input.componentKey}`,
    ),
    transactionIds,
  };
}

async function extendMatchRace(input: {
  client: Surreal;
  statementImportId: string;
  componentKey: string;
  transactionKey: string;
  date: string;
  amountMinor: number;
}) {
  await input.client.query(
    `LET $importId = type::record("statementImport", $importKey);
     LET $source = SELECT * FROM ONLY $importId;
     LET $rowId = type::record("statementRow", fn::stringID([$importId, $componentKey]));
     LET $componentId = type::record("statementRowComponent", fn::stringID([$rowId, $componentKey]));
     LET $transactionId = type::record("transaction", fn::stringID([$source.account, $transactionKey]));
     CREATE ONLY $rowId CONTENT {
       space: $source.space, account: $source.account, statementImport: $importId,
       key: $componentKey, rowNumber: 2, rowKind: "movement",
       transactionDate: $date, postingDate: $date,
       description: "Fictional independent movement", componentCount: 1,
       extractionConfidence: 1,
       rowHash: crypto::sha256(string::concat($componentKey, "-row"))
     };
     CREATE ONLY $componentId CONTENT {
       space: $source.space, account: $source.account, statementImport: $importId,
       statementRow: $rowId, key: $componentKey, componentKind: "principal",
       componentRole: "movement", transactionDate: $date, postingDate: $date,
       description: "Fictional independent movement", amountMinor: <int> $amountMinor,
       currency: "ZAR", sourceDirection: "credit", sourceFlow: "inflow",
       balanceEffectMinor: <int> $amountMinor, confidence: 1,
       sourceChecksum: crypto::sha256(string::concat($componentKey, "-component")),
       sourceState: "committed"
     };
     CREATE ONLY $transactionId CONTENT {
       space: $source.space, account: $source.account, key: $transactionKey,
       postedAt: $date, recordedAt: $now,
       description: "Fictional independent movement", amountMinor: <int> $amountMinor,
       currency: "ZAR", direction: "credit", transactionKind: "income",
       flowDirection: "inflow", entrySource: "manual", status: "normalized"
     };
     UPDATE ONLY $importId SET
       closingBalanceMinor += <int> $amountMinor,
       rowCount += 1, componentCount += 1;`,
    {
      importKey: input.statementImportId.slice("statementImport:".length),
      componentKey: input.componentKey,
      transactionKey: input.transactionKey,
      date: input.date,
      amountMinor: input.amountMinor,
      now: NOW,
    },
  );
  const [componentResponse, transactionResponse] = await Promise.all([
    input.client.query(
      `RETURN type::string((SELECT VALUE id FROM statementRowComponent
        WHERE key = $componentKey
          AND statementImport = type::record("statementImport", $importKey))[0]);`,
      {
        componentKey: input.componentKey,
        importKey: input.statementImportId.slice("statementImport:".length),
      },
    ),
    input.client.query(
      `RETURN type::string((SELECT VALUE id FROM transaction WHERE key = $transactionKey)[0]);`,
      { transactionKey: input.transactionKey },
    ),
  ]);
  return {
    componentId: required(
      String(componentResponse.flat(Infinity).find(Boolean)),
      input.componentKey,
    ),
    transactionId: required(
      String(transactionResponse.flat(Infinity).find(Boolean)),
      input.transactionKey,
    ),
  };
}

async function seedReviewIssue(input: {
  client: Surreal;
  statementImportId: string;
  key: string;
}) {
  const response = await input.client.query(
    `LET $importId = type::record("statementImport", $importKey);
     LET $source = SELECT * FROM ONLY $importId;
     LET $issueId = type::record("statementIssue", fn::stringID([$importId, $issueKey]));
     CREATE ONLY $issueId CONTENT {
       space: $source.space, account: $source.account,
       statementImport: $importId, key: $issueKey,
       code: "STATEMENT_ROW_LOW_CONFIDENCE", severity: "warning",
       blocking: false, state: "open", message: "Fictional concurrent review note",
       revision: 1,
       detectedOperation: type::record("financialOperation", fn::stringID([$importId, $issueKey, "detected"])),
       detectedAt: $now
     };
     UPDATE ONLY $importId SET issueCount += 1;
     RETURN type::string($issueId);`,
    {
      importKey: input.statementImportId.slice("statementImport:".length),
      issueKey: input.key,
      now: NOW,
    },
  );
  return required(
    String(response.flat(Infinity).find((value) => typeof value === "string")),
    input.key,
  );
}

function replacementDraft(input: {
  source: StatementImportRecord;
  key: string;
  originalHash: string;
  operationKey: string;
}): StatementCommitDraft {
  if (input.source.balanceConvention === null) {
    throw new Error(
      "Fictional replacement source requires an authoritative balance convention",
    );
  }

  const operationId = `financialOperation:${input.operationKey}`;
  const rowKey = "replacement-row-1";
  return {
    expectedAccountContext: {
      spaceId: input.source.spaceId,
      accountId: input.source.accountId,
      spaceKey: input.source.spaceKey,
      accountKey: input.source.accountKey,
      currency: input.source.currency,
      normalNature: "asset",
      accountNumberLast4: null,
      spaceTimezone: "Africa/Johannesburg",
      accountContextFingerprint: input.source.accountContextFingerprint,
    },
    statementImport: {
      spaceId: input.source.spaceId,
      accountId: input.source.accountId,
      spaceKey: input.source.spaceKey,
      accountKey: input.source.accountKey,
      key: input.key,
      privateSourceRef: "redacted-fictional-replacement-source",
      extractionAssistRef: null,
      originalFileSha256: input.originalHash,
      extractionInputSha256: null,
      canonicalExtractionSha256: "8".repeat(64),
      previewHash: "7".repeat(64),
      sourceKind: "pdf",
      sourceMimeType: "application/pdf",
      sourceByteSize: 64,
      profile: {
        profileId: "fnb-business",
        profileVersion: "1",
        extractorVersion: "statement-neutral-v0.3",
      },
      validationRulesetVersion: "statement-validation-v0.3",
      periodStart: input.source.periodStart,
      periodEnd: input.source.periodEnd,
      currency: "ZAR",
      balanceConvention: input.source.balanceConvention,
      balanceConventionAuthority: "profile",
      accountContextFingerprint: input.source.accountContextFingerprint,
      openingBalanceMinor: 0,
      closingBalanceMinor: input.source.closingBalanceMinor,
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
      importedAt: NOW,
      committedAt: NOW,
      commitOperationId: operationId,
      replacementOfId: input.source.id,
      rowCount: 1,
      componentCount: 1,
      issueCount: 0,
      revision: 1,
    },
    rows: [
      {
        rowKey,
        key: rowKey,
        rowNumber: 1,
        rowKind: "movement",
        transactionDate: input.source.periodEnd,
        postingDate: input.source.periodEnd,
        valueDate: null,
        rawText: "Fictional replacement movement",
        sourceReference: "FIC-REPLACEMENT",
        reportedBalanceMinor: input.source.closingBalanceMinor,
        locator: { page: 1, line: 1 },
        confidence: 1,
        rowHash: "6".repeat(64),
        componentCount: 1,
      },
    ],
    components: [
      {
        rowKey,
        componentKey: "replacement-principal",
        componentKind: "principal",
        componentRole: "movement",
        transactionDate: input.source.periodEnd,
        postingDate: input.source.periodEnd,
        valueDate: null,
        description: "Fictional replacement movement",
        sourceReference: "FIC-REPLACEMENT",
        amountMinor: Math.abs(input.source.closingBalanceMinor ?? 0),
        currency: "ZAR",
        sourceDirection: "credit",
        sourceFlow: "inflow",
        balanceEffectMinor: input.source.closingBalanceMinor ?? 0,
        locator: { page: 1, line: 1 },
        confidence: 1,
        sourceChecksum: "5".repeat(64),
      },
    ],
    issues: [],
    operation: {
      key: input.operationKey,
      command: "supersede_statement_import",
      idempotencyKey: input.operationKey,
      requestHash: "4".repeat(64),
      channel: "system",
      recordedAt: NOW,
      warningCodes: [],
      auditMeta: { contractVersion: "statement-truth-v0.1", workline: "ST-02" },
    },
    snapshot: null,
  };
}

async function seedSourceClaims(client: Surreal, statementImportId: string) {
  await client.query(
    `LET $importId = type::record("statementImport", $importKey);
     LET $source = SELECT * FROM ONLY $importId;
     LET $sourceClaimId = type::record("statementSourceClaim", fn::stringID([$source.account, $source.originalFileSha256]));
     LET $periodClaimId = type::record("statementPeriodClaim", fn::stringID([$source.account, $source.periodStart, $source.periodEnd]));
     UPSERT ONLY $sourceClaimId CONTENT {
       space: $source.space, account: $source.account, statementImport: $importId,
       key: $source.originalFileSha256, originalFileSha256: $source.originalFileSha256,
       periodStart: $source.periodStart, periodEnd: $source.periodEnd,
       state: "active", claimedAt: $source.committedAt
     };
     UPSERT ONLY $periodClaimId CONTENT {
       space: $source.space, account: $source.account, statementImport: $importId,
       key: string::concat($source.periodStart, "|", $source.periodEnd),
       periodStart: $source.periodStart, periodEnd: $source.periodEnd,
       originalFileSha256: $source.originalFileSha256,
       state: "active", claimedAt: $source.committedAt
     };`,
    { importKey: statementImportId.slice("statementImport:".length) },
  );
}

async function main() {
  const port = await reservePort();
  const endpoint = `http://127.0.0.1:${port}`;
  let database: ChildProcess | null = null;
  const clients: Surreal[] = [];
  try {
    database = spawn(
      "surreal",
      [
        "start",
        "--no-banner",
        "--log",
        "error",
        "--bind",
        `127.0.0.1:${port}`,
        "--user",
        USERNAME,
        "--pass",
        PASSWORD,
        "memory",
      ],
      { stdio: ["ignore", "ignore", "pipe"] },
    );
    await waitForHealth(endpoint, database);
    const [primary, concurrentA, concurrentB] = await Promise.all([
      connect(endpoint),
      connect(endpoint),
      connect(endpoint),
    ]);
    clients.push(primary, concurrentA, concurrentB);
    await primary.query(
      `
      DEFINE FUNCTION OVERWRITE fn::stringID($values: array, $separator: option<string>) {
        LET $separator = $separator ?? "|";
        LET $processed = $values.map(|$value| {
          LET $raw = IF $value = NONE OR $value = null { "" }
            ELSE IF type::is_object($value) AND $value.tb != NONE AND $value.id != NONE {
              string::concat(<string> $value.tb, ":", <string> $value.id)
            } ELSE IF type::is_object($value) AND $value.id != NONE { <string> $value.id }
            ELSE { <string> $value };
          LET $raw = string::replace(string::trim($raw), "\`", "");
          LET $raw = string::replace($raw, "⟨", "");
          LET $raw = string::replace($raw, "⟩", "");
          RETURN string::trim($raw);
        });
        RETURN array::join($processed, $separator);
      };
      DEFINE TABLE financialSpace SCHEMALESS;
      DEFINE TABLE account SCHEMALESS;
      DEFINE TABLE financialOperation SCHEMALESS;
      DEFINE TABLE statementImport SCHEMALESS;
      DEFINE TABLE statementRow SCHEMALESS;
      DEFINE TABLE statementRowComponent SCHEMALESS;
      DEFINE TABLE statementIssue SCHEMALESS;
      DEFINE TABLE statementTransactionMatch SCHEMALESS;
      DEFINE TABLE statementComponentResolutionClaim SCHEMALESS;
      DEFINE TABLE statementTransactionResolutionClaim SCHEMALESS;
      DEFINE TABLE statementReconciliation SCHEMALESS;
      DEFINE TABLE statementReconciliationEvent SCHEMALESS;
      DEFINE TABLE statementSourceClaim SCHEMALESS;
      DEFINE TABLE statementPeriodClaim SCHEMALESS;
      DEFINE TABLE accountBalanceSnapshot SCHEMALESS;
      DEFINE TABLE transaction SCHEMALESS;
      DEFINE TABLE category SCHEMALESS;
      DEFINE TABLE accountTransfer SCHEMALESS;
      DEFINE TABLE clarificationTask SCHEMALESS;
      DEFINE TABLE AccountStatementImports TYPE RELATION SCHEMALESS;
      DEFINE TABLE StatementImportRows TYPE RELATION SCHEMALESS;
      DEFINE TABLE StatementRowComponents TYPE RELATION SCHEMALESS;
      DEFINE TABLE StatementImportIssues TYPE RELATION SCHEMALESS;
      DEFINE TABLE StatementRowTransactions TYPE RELATION SCHEMALESS;
      DEFINE TABLE AccountTransactions TYPE RELATION SCHEMALESS;
      LET $spaceId = type::record("financialSpace", $spaceKey);
      LET $accountId = type::record("account", fn::stringID([$spaceId, $accountKey]));
      LET $importId = type::record("statementImport", fn::stringID([$accountId, "2026-07-31-fictional"]));
      LET $rowOne = type::record("statementRow", fn::stringID([$importId, "row-1"]));
      LET $rowTwo = type::record("statementRow", fn::stringID([$importId, "row-2"]));
      LET $incomeComponent = type::record("statementRowComponent", fn::stringID([$rowOne, "principal"]));
      LET $feeComponent = type::record("statementRowComponent", fn::stringID([$rowTwo, "fee"]));
      LET $vatComponent = type::record("statementRowComponent", fn::stringID([$rowTwo, "vat"]));
      LET $manualTransaction = type::record("transaction", fn::stringID([$accountId, "manual-income"]));
      CREATE ONLY $spaceId CONTENT { key: $spaceKey, name: "ST-02 Fictional Space", spaceType: "business", currency: "ZAR", timezone: "Africa/Johannesburg", active: true };
      CREATE ONLY $accountId CONTENT { space: $spaceId, key: $accountKey, name: "ST-02 Fictional Account", accountType: "business", currency: "ZAR", normalNature: "asset", liquidityClass: "liquid", active: true };
      CREATE ONLY $importId CONTENT {
        space: $spaceId, account: $accountId, key: "2026-07-31-fictional",
        privateSourceRef: "redacted-source-ref", originalFileSha256: string::repeat("a", 64),
        canonicalExtractionSha256: string::repeat("b", 64), previewHash: string::repeat("c", 64),
        sourceFormat: "pdf", sourceMimeType: "application/pdf", sourceByteSize: 42,
        profileId: "fnb-business", profileVersion: "1", extractorVersion: "statement-neutral-v0.3",
        validationRulesetVersion: "statement-validation-v0.3", periodStart: "2026-07-01", periodEnd: "2026-07-31",
        currency: "ZAR", balanceConvention: "positive_is_asset", balanceConventionAuthority: "profile",
        accountContextFingerprint: string::repeat("d", 64), openingBalanceMinor: 10000,
        closingBalanceMinor: 14000, closingBalanceEconomicNature: "asset",
        coverage: { status: "complete", sourcePageCount: 1, processedPages: [1], sourceSections: ["transactions"], processedSections: ["transactions"], printedRowCount: 2, extractedRowCount: 2 },
        sourceState: "committed", importedAt: $now, committedAt: $now,
        rowCount: 2, componentCount: 3, issueCount: 0, revision: 1, statementDate: "2026-07-31"
      };
      CREATE ONLY $rowOne CONTENT { space: $spaceId, account: $accountId, statementImport: $importId, key: "row-1", rowNumber: 1, rowKind: "movement", transactionDate: "2026-07-10", postingDate: "2026-07-10", description: "Fictional income", componentCount: 1, extractionConfidence: 1, rowHash: string::repeat("e", 64) };
      CREATE ONLY $rowTwo CONTENT { space: $spaceId, account: $accountId, statementImport: $importId, key: "row-2", rowNumber: 2, rowKind: "composite", postingDate: "2026-07-12", description: "Fictional fee", componentCount: 2, extractionConfidence: 1, rowHash: string::repeat("f", 64) };
      CREATE ONLY $incomeComponent CONTENT { space: $spaceId, account: $accountId, statementImport: $importId, statementRow: $rowOne, key: "principal", componentKind: "principal", componentRole: "movement", transactionDate: "2026-07-10", postingDate: "2026-07-10", description: "Fictional income", sourceReference: "FIC-100", amountMinor: 5000, currency: "ZAR", sourceDirection: "credit", sourceFlow: "inflow", balanceEffectMinor: 5000, confidence: 1, sourceChecksum: string::repeat("1", 64), sourceState: "committed" };
      CREATE ONLY $feeComponent CONTENT { space: $spaceId, account: $accountId, statementImport: $importId, statementRow: $rowTwo, key: "fee", componentKind: "bank_fee", componentRole: "movement", postingDate: "2026-07-12", description: "Fictional bank fee", amountMinor: 1000, currency: "ZAR", sourceDirection: "debit", sourceFlow: "outflow", balanceEffectMinor: -1000, confidence: 1, sourceChecksum: string::repeat("2", 64), sourceState: "committed" };
      CREATE ONLY $vatComponent CONTENT { space: $spaceId, account: $accountId, statementImport: $importId, statementRow: $rowTwo, key: "vat", componentKind: "vat", componentRole: "informational_breakdown", postingDate: "2026-07-12", description: "Fictional VAT included", amountMinor: 150, currency: "ZAR", sourceDirection: "debit", sourceFlow: "unknown", balanceEffectMinor: 0, confidence: 1, sourceChecksum: string::repeat("3", 64), sourceState: "committed" };
      CREATE ONLY $manualTransaction CONTENT { space: $spaceId, account: $accountId, key: "manual-income", postedAt: "2026-07-10", recordedAt: $now, description: "Fictional income", amountMinor: 5000, currency: "ZAR", direction: "credit", transactionKind: "income", flowDirection: "inflow", entrySource: "manual", status: "normalized", category: type::record("category", "fictional-preserved"), operation: type::record("financialOperation", "fictional-manual") };
      RETURN { importId: type::string($importId), incomeComponent: type::string($incomeComponent), feeComponent: type::string($feeComponent), vatComponent: type::string($vatComponent), manualTransaction: type::string($manualTransaction) };
      `,
      { spaceKey: SPACE_KEY, accountKey: ACCOUNT_KEY, now: NOW },
    );
    const seeded = (
      await primary.query(
        `RETURN (SELECT VALUE { importId: type::string(statementImport), incomeComponent: type::string(id) } FROM statementRowComponent WHERE key = "principal")[0];`,
      )
    )
      .flat(Infinity)
      .find((value) => value && typeof value === "object") as Record<
      string,
      string
    >;
    const componentRows = (
      await primary.query(
        `SELECT type::string(id) AS id, key FROM statementRowComponent ORDER BY key;`,
      )
    )
      .flat(Infinity)
      .filter((value) => value && typeof value === "object") as Array<
      Record<string, string>
    >;
    const statementImportId = required(seeded.importId, "statement import");
    await alignFictionalAccountContext(primary, statementImportId);
    await seedSourceClaims(primary, statementImportId);
    const incomeComponentId = required(
      componentRows.find((item) => item.key === "principal")?.id,
      "income component",
    );
    const feeComponentId = required(
      componentRows.find((item) => item.key === "fee")?.id,
      "fee component",
    );
    const vatComponentId = required(
      componentRows.find((item) => item.key === "vat")?.id,
      "VAT component",
    );
    const manualTransactionId = required(
      String(
        (
          await primary.query(
            `RETURN type::string((SELECT VALUE id FROM transaction WHERE key = "manual-income")[0]);`,
          )
        )
          .flat(Infinity)
          .find(Boolean),
      ),
      "manual transaction",
    );
    const sourceRepository = createSurrealStatementTruthRepository(primary);
    const resolutionRepository =
      createSurrealStatementResolutionRepository(primary);
    const service = createStatementResolutionService({
      sourceRepository,
      repository: resolutionRepository,
      clock: () => NOW,
    });
    const candidates = await service.listStatementMatchCandidates({
      statementImportId,
      componentIds: [incomeComponentId],
      explicitTransactionId: manualTransactionId,
    });
    assert.equal(candidates.candidates.length, 1);
    const proposal = await service.proposeStatementTransactionMatch({
      statementImportId,
      componentIds: [incomeComponentId],
      transactionId: manualTransactionId,
      ...reconciliationExpectation(null),
      idempotencyKey: "st02-propose-fictional",
      channel: "system",
    });
    assert.equal(proposal.match.state, "proposed");
    assert.equal(
      await scalar(primary, "RETURN count(SELECT id FROM transaction);"),
      1,
    );
    const confirmed = await service.confirmStatementTransactionMatch({
      statementTransactionMatchId: proposal.match.id,
      expectedRevision: proposal.match.revision,
      ...reconciliationExpectation(proposal.reconciliation),
      idempotencyKey: "st02-confirm-fictional",
      channel: "system",
    });
    assert.equal(confirmed.match.state, "confirmed");
    assert.equal(
      await scalar(primary, "RETURN count(SELECT id FROM transaction);"),
      1,
    );
    const preserved =
      await resolutionRepository.getResolutionTransaction(manualTransactionId);
    assert.equal(preserved?.statementMatchId, confirmed.match.id);
    assert.equal(preserved?.categoryId, "category:fictional-preserved");

    const materialized = await service.materializeStatementComponentTransaction(
      {
        statementImportId,
        componentIds: [feeComponentId],
        ...reconciliationExpectation(confirmed.reconciliation),
        idempotencyKey: "st02-materialize-fictional",
        channel: "system",
      },
    );
    const replay = await service.materializeStatementComponentTransaction({
      statementImportId,
      componentIds: [feeComponentId],
      ...reconciliationExpectation(confirmed.reconciliation),
      idempotencyKey: "st02-materialize-fictional",
      channel: "system",
    });
    assert.equal(replay.transactionId, materialized.transactionId);
    assert.equal(
      await scalar(primary, "RETURN count(SELECT id FROM transaction);"),
      2,
    );
    await assert.rejects(
      service.materializeStatementComponentTransaction({
        statementImportId,
        componentIds: [incomeComponentId],
        ...reconciliationExpectation(confirmed.reconciliation),
        idempotencyKey: "st02-materialize-fictional",
        channel: "system",
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "IDEMPOTENCY_CONFLICT",
    );
    await assert.rejects(
      service.materializeStatementComponentTransaction({
        statementImportId,
        componentIds: [vatComponentId],
        ...reconciliationExpectation(materialized.reconciliation),
        idempotencyKey: "st02-materialize-informational",
        channel: "system",
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_TRANSACTION_INELIGIBLE",
    );
    const reconciliation = await service.recalculateStatementReconciliation({
      statementImportId,
      expectedRevision: materialized.reconciliation?.revision ?? null,
      expectedHash: materialized.reconciliation?.calculationHash ?? null,
      idempotencyKey: "st02-recalculate-fictional",
      channel: "system",
    });
    assert.equal(reconciliation.reconciliation.differenceMinor, 0);
    assert.equal(reconciliation.reconciliation.attestationState, "ready");
    assert.equal(
      reconciliation.reconciliation.counts.informationalComponentCount,
      1,
    );
    const attested = await service.attestStatementReconciled({
      statementImportId,
      expectedRevision: reconciliation.reconciliation.revision,
      calculationHash: reconciliation.reconciliation.calculationHash,
      idempotencyKey: "st02-attest-fictional",
      channel: "system",
    });
    assert.equal(attested.reconciliation.attestationState, "reconciled");
    const issueId = required(
      String(
        (
          await primary.query(
            `LET $importId = type::record("statementImport", $importKey);
           LET $source = SELECT * FROM ONLY $importId;
           LET $issueId = type::record("statementIssue", fn::stringID([$importId, "fictional-review-note"]));
           CREATE ONLY $issueId CONTENT {
             space: $source.space, account: $source.account,
             statementImport: $importId, key: "fictional-review-note",
             code: "STATEMENT_ROW_LOW_CONFIDENCE", severity: "warning",
             blocking: false, state: "open", message: "Fictional review note",
             revision: 1, detectedOperation: type::record("financialOperation", "fictional-detection"),
             detectedAt: $now
           };
           RETURN type::string($issueId);`,
            {
              importKey: statementImportId.slice("statementImport:".length),
              now: NOW,
            },
          )
        )
          .flat(Infinity)
          .find((value) => typeof value === "string"),
      ),
      "non-blocking issue",
    );
    const acknowledged = await service.acknowledgeStatementIssue({
      statementIssueId: issueId,
      expectedRevision: 1,
      note: "Fictional acknowledgement",
      ...reconciliationExpectation(attested.reconciliation),
      idempotencyKey: "st02-acknowledge-fictional",
      channel: "system",
    });
    assert.equal(acknowledged.issue.state, "acknowledged");
    assert.equal(acknowledged.reconciliation?.attestationState, "reopened");
    assert(acknowledged.reconciliation);
    const reattested = await service.attestStatementReconciled({
      statementImportId,
      expectedRevision: acknowledged.reconciliation.revision,
      calculationHash: acknowledged.reconciliation.calculationHash,
      idempotencyKey: "st02-reattest-fictional",
      channel: "system",
    });
    assert.equal(reattested.reconciliation.attestationState, "reconciled");
    const reopened = await service.reopenStatementReconciliation({
      statementImportId,
      expectedRevision: reattested.reconciliation.revision,
      calculationHash: reattested.reconciliation.calculationHash,
      reason: "Fictional later evidence review",
      idempotencyKey: "st02-reopen-fictional",
      channel: "system",
    });
    assert.equal(reopened.reconciliation.attestationState, "reopened");
    assert.equal(
      (
        await resolutionRepository.listStatementReconciliationEvents(
          statementImportId,
        )
      ).length,
      4,
    );

    const serviceA = resolutionService(concurrentA);
    const serviceB = resolutionService(concurrentB);

    const transferReview = await seedMatchRace({
      client: primary,
      importKey: "2026-02-11-transfer-review",
      componentKey: "transfer-review",
      date: "2026-02-11",
      amountMinor: 1_300,
      transactionKeys: [],
    });
    await primary.query(
      `LET $spaceId = type::record("financialSpace", "st02-fictional-counter-space");
       LET $accountId = type::record("account", fn::stringID([$spaceId, "counter-account"]));
       LET $transactionId = type::record("transaction", fn::stringID([$accountId, "counter-transfer"]));
       CREATE ONLY $spaceId CONTENT {
         key: "st02-fictional-counter-space", name: "ST-02 Fictional Counter Space",
         spaceType: "personal", currency: "ZAR", timezone: "Africa/Johannesburg", active: true
       };
       CREATE ONLY $accountId CONTENT {
         space: $spaceId, key: "counter-account", name: "ST-02 Fictional Counter Account",
         accountType: "current", currency: "ZAR", normalNature: "asset",
         liquidityClass: "liquid", active: true
       };
       CREATE ONLY $transactionId CONTENT {
         space: $spaceId, account: $accountId, key: "counter-transfer",
         postedAt: "2026-02-11", recordedAt: $now,
         description: "Fictional tracked-account transfer", amountMinor: 1300,
         currency: "ZAR", direction: "debit", transactionKind: "expense",
         flowDirection: "outflow", entrySource: "manual", status: "normalized"
       };`,
      { now: NOW },
    );
    const transferCandidates = await serviceA.listStatementMatchCandidates({
      statementImportId: transferReview.statementImportId,
      componentIds: [transferReview.componentId],
    });
    assert.equal(transferCandidates.candidates.length, 1);
    assert.equal(transferCandidates.candidates[0]?.transferCandidate, true);
    await assert.rejects(
      serviceA.materializeStatementComponentTransaction({
        statementImportId: transferReview.statementImportId,
        componentIds: [transferReview.componentId],
        ...reconciliationExpectation(null),
        idempotencyKey: "st02-transfer-materialization-block",
        channel: "system",
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_TRANSFER_REVIEW_REQUIRED",
    );

    const independent = await seedMatchRace({
      client: primary,
      importKey: "2026-01-10-independent-success",
      componentKey: "independent-a",
      date: "2026-01-10",
      amountMinor: 1_600,
      transactionKeys: ["independent-transaction-a"],
    });
    const independentB = await extendMatchRace({
      client: primary,
      statementImportId: independent.statementImportId,
      componentKey: "independent-b",
      transactionKey: "independent-transaction-b",
      date: "2026-01-10",
      amountMinor: 1_700,
    });
    const independentProposalA =
      await serviceA.proposeStatementTransactionMatch({
        statementImportId: independent.statementImportId,
        componentIds: [independent.componentId],
        transactionId: independent.transactionIds[0]!,
        ...reconciliationExpectation(null),
        idempotencyKey: "st02-independent-propose-a",
        channel: "system",
      });
    const independentProposalB =
      await serviceB.proposeStatementTransactionMatch({
        statementImportId: independent.statementImportId,
        componentIds: [independentB.componentId],
        transactionId: independentB.transactionId,
        ...reconciliationExpectation(independentProposalA.reconciliation),
        idempotencyKey: "st02-independent-propose-b",
        channel: "system",
      });
    const independentConfirmations = await Promise.all([
      serviceA.confirmStatementTransactionMatch({
        statementTransactionMatchId: independentProposalA.match.id,
        expectedRevision: independentProposalA.match.revision,
        ...reconciliationExpectation(independentProposalB.reconciliation),
        idempotencyKey: "st02-independent-confirm-a",
        channel: "system",
      }),
      serviceB.confirmStatementTransactionMatch({
        statementTransactionMatchId: independentProposalB.match.id,
        expectedRevision: independentProposalB.match.revision,
        ...reconciliationExpectation(independentProposalB.reconciliation),
        idempotencyKey: "st02-independent-confirm-b",
        channel: "system",
      }),
    ]);
    assert(
      independentConfirmations.every(
        (result) => result.match.state === "confirmed",
      ),
    );
    assert.equal(
      await scalar(
        primary,
        `RETURN count(SELECT id FROM statementTransactionMatch
          WHERE statementImport = type::record("statementImport", $importKey)
            AND state = "confirmed" AND sourceState = "committed");`,
        {
          importKey: independent.statementImportId.slice(
            "statementImport:".length,
          ),
        },
      ),
      2,
    );
    const independentState = await serviceA.getStatementReconciliation({
      statementImportId: independent.statementImportId,
    });
    assert.equal(independentState.reconciliation?.counts.unresolvedCount, 0);
    assert.equal(
      independentState.reconciliation?.counts.confirmedExistingCount,
      2,
    );

    const issueMatch = await seedMatchRace({
      client: primary,
      importKey: "2025-12-10-issue-match-success",
      componentKey: "issue-match",
      date: "2025-12-10",
      amountMinor: 1_800,
      transactionKeys: ["issue-match-transaction"],
    });
    const concurrentIssueId = await seedReviewIssue({
      client: primary,
      statementImportId: issueMatch.statementImportId,
      key: "concurrent-review-note",
    });
    const issueMatchProposal = await serviceA.proposeStatementTransactionMatch({
      statementImportId: issueMatch.statementImportId,
      componentIds: [issueMatch.componentId],
      transactionId: issueMatch.transactionIds[0]!,
      ...reconciliationExpectation(null),
      idempotencyKey: "st02-issue-match-propose",
      channel: "system",
    });
    const [issueMatchConfirmation, concurrentAcknowledgement] =
      await Promise.all([
        serviceA.confirmStatementTransactionMatch({
          statementTransactionMatchId: issueMatchProposal.match.id,
          expectedRevision: issueMatchProposal.match.revision,
          ...reconciliationExpectation(issueMatchProposal.reconciliation),
          idempotencyKey: "st02-issue-match-confirm",
          channel: "system",
        }),
        serviceB.acknowledgeStatementIssue({
          statementIssueId: concurrentIssueId,
          expectedRevision: 1,
          note: "Fictional concurrent acknowledgement",
          ...reconciliationExpectation(issueMatchProposal.reconciliation),
          idempotencyKey: "st02-issue-match-acknowledge",
          channel: "system",
        }),
      ]);
    assert.equal(issueMatchConfirmation.match.state, "confirmed");
    assert.equal(concurrentAcknowledgement.issue.state, "acknowledged");
    const issueMatchState = await serviceA.getStatementReconciliation({
      statementImportId: issueMatch.statementImportId,
    });
    assert.equal(issueMatchState.reconciliation?.counts.unresolvedCount, 0);
    assert.equal(issueMatchState.reconciliation?.counts.activeIssueCount, 1);
    assert.equal(issueMatchState.reconciliation?.attestationState, "ready");
    assert.equal(
      (await sourceRepository.getStatementIssue(concurrentIssueId))?.state,
      "acknowledged",
    );

    const componentRace = await seedMatchRace({
      client: primary,
      importKey: "2026-06-10-component-race",
      componentKey: "component-race",
      date: "2026-06-10",
      amountMinor: 700,
      transactionKeys: ["component-race-a", "component-race-b"],
    });
    const componentProposalA = await serviceA.proposeStatementTransactionMatch({
      statementImportId: componentRace.statementImportId,
      componentIds: [componentRace.componentId],
      transactionId: componentRace.transactionIds[0]!,
      ...reconciliationExpectation(null),
      idempotencyKey: "st02-component-race-propose-a",
      channel: "system",
    });
    const componentProposalB = await serviceB.proposeStatementTransactionMatch({
      statementImportId: componentRace.statementImportId,
      componentIds: [componentRace.componentId],
      transactionId: componentRace.transactionIds[1]!,
      ...reconciliationExpectation(componentProposalA.reconciliation),
      idempotencyKey: "st02-component-race-propose-b",
      channel: "system",
    });
    const componentConfirmations = await Promise.allSettled([
      serviceA.confirmStatementTransactionMatch({
        statementTransactionMatchId: componentProposalA.match.id,
        expectedRevision: componentProposalA.match.revision,
        ...reconciliationExpectation(componentProposalB.reconciliation),
        idempotencyKey: "st02-component-race-confirm-a",
        channel: "system",
      }),
      serviceB.confirmStatementTransactionMatch({
        statementTransactionMatchId: componentProposalB.match.id,
        expectedRevision: componentProposalB.match.revision,
        ...reconciliationExpectation(componentProposalB.reconciliation),
        idempotencyKey: "st02-component-race-confirm-b",
        channel: "system",
      }),
    ]);
    assert.equal(
      componentConfirmations.filter((result) => result.status === "fulfilled")
        .length,
      1,
    );
    assert.equal(
      componentConfirmations.filter((result) => result.status === "rejected")
        .length,
      1,
    );
    const componentRaceError = componentConfirmations.find(
      (result): result is PromiseRejectedResult => result.status === "rejected",
    )?.reason;
    assert(
      componentRaceError instanceof RavenDomainError &&
        componentRaceError.code === "STATEMENT_COMPONENT_ALREADY_DISPOSED",
      `Expected component claim conflict, received ${
        componentRaceError instanceof RavenDomainError
          ? `${componentRaceError.code}: ${componentRaceError.message}`
          : String(componentRaceError)
      }`,
    );
    assert.equal(
      await scalar(
        primary,
        `RETURN count(SELECT id FROM statementComponentResolutionClaim
          WHERE statementRowComponent = type::record("statementRowComponent", $key)
            AND state = "active");`,
        {
          key: componentRace.componentId.slice("statementRowComponent:".length),
        },
      ),
      1,
    );

    const transactionRaceA = await seedMatchRace({
      client: primary,
      importKey: "2026-05-10-transaction-race-a",
      componentKey: "transaction-race-a",
      date: "2026-05-10",
      amountMinor: 900,
      transactionKeys: ["transaction-race-shared"],
    });
    const transactionRaceB = await seedMatchRace({
      client: primary,
      importKey: "2026-05-10-transaction-race-b",
      componentKey: "transaction-race-b",
      date: "2026-05-10",
      amountMinor: 900,
      transactionKeys: [],
    });
    const sharedTransactionId = transactionRaceA.transactionIds[0]!;
    const transactionProposalA =
      await serviceA.proposeStatementTransactionMatch({
        statementImportId: transactionRaceA.statementImportId,
        componentIds: [transactionRaceA.componentId],
        transactionId: sharedTransactionId,
        ...reconciliationExpectation(null),
        idempotencyKey: "st02-transaction-race-propose-a",
        channel: "system",
      });
    const transactionProposalB =
      await serviceB.proposeStatementTransactionMatch({
        statementImportId: transactionRaceB.statementImportId,
        componentIds: [transactionRaceB.componentId],
        transactionId: sharedTransactionId,
        ...reconciliationExpectation(null),
        idempotencyKey: "st02-transaction-race-propose-b",
        channel: "system",
      });
    const transactionConfirmations = await Promise.allSettled([
      serviceA.confirmStatementTransactionMatch({
        statementTransactionMatchId: transactionProposalA.match.id,
        expectedRevision: transactionProposalA.match.revision,
        ...reconciliationExpectation(transactionProposalA.reconciliation),
        idempotencyKey: "st02-transaction-race-confirm-a",
        channel: "system",
      }),
      serviceB.confirmStatementTransactionMatch({
        statementTransactionMatchId: transactionProposalB.match.id,
        expectedRevision: transactionProposalB.match.revision,
        ...reconciliationExpectation(transactionProposalB.reconciliation),
        idempotencyKey: "st02-transaction-race-confirm-b",
        channel: "system",
      }),
    ]);
    assert.equal(
      transactionConfirmations.filter((result) => result.status === "fulfilled")
        .length,
      1,
    );
    assert.equal(
      transactionConfirmations.filter((result) => result.status === "rejected")
        .length,
      1,
    );
    const transactionRaceError = transactionConfirmations.find(
      (result): result is PromiseRejectedResult => result.status === "rejected",
    )?.reason;
    assert(
      transactionRaceError instanceof RavenDomainError &&
        transactionRaceError.code === "STATEMENT_TRANSACTION_ALREADY_MATCHED",
      `Expected Transaction claim conflict, received ${
        transactionRaceError instanceof RavenDomainError
          ? `${transactionRaceError.code}: ${transactionRaceError.message}`
          : String(transactionRaceError)
      }`,
    );

    const rejectionCase = await seedMatchRace({
      client: primary,
      importKey: "2026-03-10-rejection",
      componentKey: "rejection-component",
      date: "2026-03-10",
      amountMinor: 1_200,
      transactionKeys: ["rejection-transaction"],
    });
    const rejectionProposal = await serviceA.proposeStatementTransactionMatch({
      statementImportId: rejectionCase.statementImportId,
      componentIds: [rejectionCase.componentId],
      transactionId: rejectionCase.transactionIds[0]!,
      ...reconciliationExpectation(null),
      idempotencyKey: "st02-rejection-proposal",
      channel: "system",
    });
    const rejected = await serviceA.rejectStatementTransactionMatch({
      statementTransactionMatchId: rejectionProposal.match.id,
      expectedRevision: rejectionProposal.match.revision,
      reason: "Fictional candidate rejected after review",
      ...reconciliationExpectation(rejectionProposal.reconciliation),
      idempotencyKey: "st02-rejection-command",
      channel: "system",
    });
    assert.equal(rejected.match.state, "rejected");
    assert.equal(
      (
        await createSurrealStatementResolutionRepository(
          primary,
        ).getResolutionTransaction(rejectionCase.transactionIds[0]!)
      )?.statementMatchId,
      null,
    );
    const blockingIssueId = required(
      String(
        (
          await primary.query(
            `LET $importId = type::record("statementImport", $importKey);
           LET $source = SELECT * FROM ONLY $importId;
           LET $issueId = type::record("statementIssue", fn::stringID([$importId, "fictional-blocking"]));
           CREATE ONLY $issueId CONTENT {
             space: $source.space, account: $source.account,
             statementImport: $importId, key: "fictional-blocking",
             code: "STATEMENT_ACCOUNT_MISMATCH", severity: "blocking",
             blocking: true, state: "open", message: "Fictional blocking issue",
             revision: 1, detectedOperation: type::record("financialOperation", "fictional-blocking-detection"),
             detectedAt: $now
           };
           RETURN type::string($issueId);`,
            {
              importKey: rejectionCase.statementImportId.slice(
                "statementImport:".length,
              ),
              now: NOW,
            },
          )
        )
          .flat(Infinity)
          .find((value) => typeof value === "string"),
      ),
      "blocking issue",
    );
    await assert.rejects(
      serviceA.acknowledgeStatementIssue({
        statementIssueId: blockingIssueId,
        expectedRevision: 1,
        note: "This must not waive a blocking issue",
        ...reconciliationExpectation(rejected.reconciliation),
        idempotencyKey: "st02-blocking-acknowledgement",
        channel: "system",
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_BLOCKING_ISSUE_ACTIVE",
    );

    const componentRaceState = await serviceA.getStatementReconciliation({
      statementImportId: componentRace.statementImportId,
    });
    assert(componentRaceState.reconciliation);
    const componentRaceAttestation = await serviceA.attestStatementReconciled({
      statementImportId: componentRace.statementImportId,
      expectedRevision: componentRaceState.reconciliation.revision,
      calculationHash: componentRaceState.reconciliation.calculationHash,
      idempotencyKey: "st02-source-supersession-attest",
      channel: "system",
    });
    assert.equal(
      componentRaceAttestation.reconciliation.attestationState,
      "reconciled",
    );
    const componentRaceWinner = componentConfirmations.find(
      (
        result,
      ): result is PromiseFulfilledResult<
        Awaited<
          ReturnType<StatementResolutionApi["confirmStatementTransactionMatch"]>
        >
      > => result.status === "fulfilled",
    );
    assert(componentRaceWinner);
    const replacementTransactionId = componentRace.transactionIds.find(
      (id) => id !== componentRaceWinner.value.match.transactionId,
    );
    assert(replacementTransactionId);
    const matchSupersession = await serviceA.supersedeStatementTransactionMatch(
      {
        statementTransactionMatchId: componentRaceWinner.value.match.id,
        expectedRevision: componentRaceWinner.value.match.revision,
        componentIds: [componentRace.componentId],
        transactionId: replacementTransactionId,
        reason: "Fictional corrected Transaction identity",
        ...reconciliationExpectation(componentRaceAttestation.reconciliation),
        idempotencyKey: "st02-match-supersession-fictional",
        channel: "system",
      },
    );
    assert.equal(matchSupersession.match.state, "confirmed");
    assert.equal(
      matchSupersession.reconciliation?.attestationState,
      "reopened",
    );
    const oldMatchAfterSupersession =
      await resolutionRepository.getStatementTransactionMatch(
        componentRaceWinner.value.match.id,
      );
    assert.equal(oldMatchAfterSupersession?.state, "superseded");
    assert.equal(
      (
        await resolutionRepository.getResolutionTransaction(
          componentRaceWinner.value.match.transactionId,
        )
      )?.statementMatchId,
      null,
    );
    assert(matchSupersession.reconciliation);
    await primary.query(
      `CREATE ONLY type::record("statementComponentResolutionClaim", "fictional-extra-attestation-claim") CONTENT {
         statementImport: type::record("statementImport", $importKey),
         statementRowComponent: type::record("statementRowComponent", $componentKey),
         statementTransactionMatch: type::record("statementTransactionMatch", $matchKey),
         transaction: type::record("transaction", $transactionKey),
         state: "active"
       };`,
      {
        importKey: componentRace.statementImportId.slice(
          "statementImport:".length,
        ),
        componentKey: componentRace.componentId.slice(
          "statementRowComponent:".length,
        ),
        matchKey: matchSupersession.match.id.slice(
          "statementTransactionMatch:".length,
        ),
        transactionKey: replacementTransactionId.slice("transaction:".length),
      },
    );
    await assert.rejects(
      serviceA.attestStatementReconciled({
        statementImportId: componentRace.statementImportId,
        expectedRevision: matchSupersession.reconciliation.revision,
        calculationHash: matchSupersession.reconciliation.calculationHash,
        idempotencyKey: "st02-exact-attestation-set-rejected",
        channel: "system",
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_RECONCILIATION_STALE",
    );
    await primary.query(
      `DELETE type::record("statementComponentResolutionClaim", "fictional-extra-attestation-claim");`,
    );
    const componentRaceReattestation = await serviceA.attestStatementReconciled(
      {
        statementImportId: componentRace.statementImportId,
        expectedRevision: matchSupersession.reconciliation.revision,
        calculationHash: matchSupersession.reconciliation.calculationHash,
        idempotencyKey: "st02-source-supersession-reattest",
        channel: "system",
      },
    );
    assert.equal(
      componentRaceReattestation.reconciliation.attestationState,
      "reconciled",
    );
    await seedSourceClaims(primary, componentRace.statementImportId);
    const componentRaceSource = await createSurrealStatementTruthRepository(
      primary,
    ).getStatementImport(componentRace.statementImportId);
    assert(componentRaceSource);
    const sourceReplacement = replacementDraft({
      source: componentRaceSource,
      key: "2026-06-10-component-race-replacement",
      originalHash: "3".repeat(64),
      operationKey: "st02-source-supersession-success",
    });
    const sourceSupersessionDraft: StatementImportSupersessionDraft = {
      oldImportId: componentRaceSource.id,
      expectedSourceRevision: componentRaceSource.revision,
      expectedReconciliationRevision:
        componentRaceReattestation.reconciliation.revision,
      expectedReconciliationHash:
        componentRaceReattestation.reconciliation.calculationHash,
      reason: "Fictional corrected source evidence",
      replacement: sourceReplacement,
      operation: sourceReplacement.operation,
    };
    const superseded = await resolutionRepository.supersedeStatementImport(
      sourceSupersessionDraft,
    );
    assert.equal(superseded.supersededImport.sourceState, "superseded");
    assert.equal(superseded.replacementImport.sourceState, "committed");
    assert.equal(
      superseded.replacementImport.replacementOfId,
      componentRaceSource.id,
    );
    assert.equal(superseded.reconciliation?.attestationState, "reopened");
    assert.equal(
      await scalar(
        primary,
        `RETURN count(SELECT id FROM statementSourceClaim
          WHERE statementImport = type::record("statementImport", $importKey)
            AND state = "active");`,
        {
          importKey: superseded.replacementImport.id.slice(
            "statementImport:".length,
          ),
        },
      ),
      1,
    );
    assert.equal(
      await scalar(
        primary,
        `RETURN count(SELECT id FROM statementPeriodClaim
          WHERE statementImport = type::record("statementImport", $importKey)
            AND state = "active");`,
        {
          importKey: superseded.replacementImport.id.slice(
            "statementImport:".length,
          ),
        },
      ),
      1,
    );
    assert.equal(
      await scalar(
        primary,
        `RETURN count(SELECT id FROM statementTransactionMatch
          WHERE statementImport = type::record("statementImport", $importKey)
            AND sourceState = "committed");`,
        { importKey: componentRaceSource.id.slice("statementImport:".length) },
      ),
      0,
    );

    const projectionCase = await seedMatchRace({
      client: primary,
      importKey: "2025-11-10-active-projection",
      componentKey: "active-projection",
      date: "2025-11-10",
      amountMinor: 2_100,
      transactionKeys: [],
    });
    const projectionMaterialized =
      await serviceA.materializeStatementComponentTransaction({
        statementImportId: projectionCase.statementImportId,
        componentIds: [projectionCase.componentId],
        ...reconciliationExpectation(null),
        idempotencyKey: "st02-active-projection-materialize",
        channel: "system",
      });
    assert(projectionMaterialized.reconciliation);
    const projectionAttested = await serviceA.attestStatementReconciled({
      statementImportId: projectionCase.statementImportId,
      expectedRevision: projectionMaterialized.reconciliation.revision,
      calculationHash: projectionMaterialized.reconciliation.calculationHash,
      idempotencyKey: "st02-active-projection-attest",
      channel: "system",
    });
    await primary.query(
      `LET $importId = type::record("statementImport", $importKey);
       LET $source = SELECT * FROM ONLY $importId;
       CREATE ONLY type::record("accountBalanceSnapshot", "st02-active-projection-old-closing") CONTENT {
         space: $source.space, account: $source.account,
         key: "st02-active-projection-old-closing", balanceKind: "statement",
         amountMinor: 2100, currency: "ZAR", economicNature: "asset",
         asOf: "2025-11-10T21:59:59.999Z", recordedAt: $now,
         evidenceLevel: "observed", sourceKind: "statement_closing",
         sourceRef: type::string($importId),
         operation: type::record("financialOperation", "st02-active-projection-old-snapshot")
       };`,
      {
        importKey: projectionCase.statementImportId.slice(
          "statementImport:".length,
        ),
        now: NOW,
      },
    );
    const projectionSource = await sourceRepository.getStatementImport(
      projectionCase.statementImportId,
    );
    assert(projectionSource);
    const projectionReplacementBase = replacementDraft({
      source: projectionSource,
      key: "2025-11-10-active-projection-replacement",
      originalHash: "1".repeat(64),
      operationKey: "st02-active-projection-supersession",
    });
    const projectionReplacement: StatementCommitDraft = {
      ...projectionReplacementBase,
      snapshot: {
        key: "st02-active-projection-new-closing",
        spaceId: projectionSource.spaceId,
        accountId: projectionSource.accountId,
        balanceKind: "statement",
        amountMinor: 2_100,
        currency: "ZAR",
        economicNature: "asset",
        asOf: "2025-11-10T21:59:59.999Z",
        recordedAt: NOW,
        evidenceLevel: "observed",
        sourceKind: "statement_closing",
        sourceRef: null,
        operationId: projectionReplacementBase.operation.key,
        notes: null,
      },
    };
    const projectionSuperseded =
      await resolutionRepository.supersedeStatementImport({
        oldImportId: projectionSource.id,
        expectedSourceRevision: projectionSource.revision,
        expectedReconciliationRevision:
          projectionAttested.reconciliation.revision,
        expectedReconciliationHash:
          projectionAttested.reconciliation.calculationHash,
        reason: "Fictional active projection replacement",
        replacement: projectionReplacement,
        operation: projectionReplacement.operation,
      });
    const accountRepository = createSurrealAccountControlRepository(primary);
    const activeAfterSupersession = await accountRepository.listTransactions({
      accountIds: [projectionSource.accountId],
    });
    assert.equal(
      activeAfterSupersession.some(
        (transaction) =>
          transaction.id === projectionMaterialized.transactionId,
      ),
      false,
    );
    const currentSnapshots = await accountRepository.listBalanceSnapshots([
      projectionSource.accountId,
    ]);
    assert.equal(
      currentSnapshots.some(
        (snapshot) => snapshot.key === "st02-active-projection-old-closing",
      ),
      false,
    );
    assert.equal(
      currentSnapshots.some(
        (snapshot) => snapshot.key === "st02-active-projection-new-closing",
      ),
      true,
    );
    assert.equal(
      (await sourceRepository.getStatementImport(projectionSource.id))
        ?.sourceState,
      "superseded",
    );
    const historicalComponents =
      await sourceRepository.listStatementRowComponents({
        statementImportId: projectionSource.id,
      });
    assert.equal(historicalComponents.length, 1);
    assert.equal(historicalComponents[0]?.sourceState, "superseded");
    const replacementComponents =
      await sourceRepository.listStatementRowComponents({
        statementImportId: projectionSuperseded.replacementImport.id,
      });
    assert.equal(replacementComponents.length, 1);
    const replacementMaterialized =
      await serviceA.materializeStatementComponentTransaction({
        statementImportId: projectionSuperseded.replacementImport.id,
        componentIds: [replacementComponents[0]!.id],
        ...reconciliationExpectation(null),
        idempotencyKey: "st02-active-projection-rematerialize",
        channel: "system",
      });
    const activeAfterRematerialization =
      await accountRepository.listTransactions({
        accountIds: [projectionSource.accountId],
      });
    assert.equal(
      activeAfterRematerialization.some(
        (transaction) =>
          transaction.id === projectionMaterialized.transactionId,
      ),
      false,
    );
    assert.equal(
      activeAfterRematerialization.filter(
        (transaction) =>
          transaction.id === replacementMaterialized.transactionId,
      ).length,
      1,
    );

    const claimRace = await seedMatchRace({
      client: primary,
      importKey: "2025-10-10-source-claim-race",
      componentKey: "source-claim-race",
      date: "2025-10-10",
      amountMinor: 2_200,
      transactionKeys: [],
    });
    const claimRaceSource = await sourceRepository.getStatementImport(
      claimRace.statementImportId,
    );
    assert(claimRaceSource);
    const claimRaceReplacementA = replacementDraft({
      source: claimRaceSource,
      key: "2025-10-10-source-claim-race-a",
      originalHash: "9".repeat(64),
      operationKey: "st02-source-claim-race-a",
    });
    const claimRaceReplacementB = replacementDraft({
      source: claimRaceSource,
      key: "2025-10-10-source-claim-race-b",
      originalHash: "0".repeat(64),
      operationKey: "st02-source-claim-race-b",
    });
    const claimRaceResults = await Promise.allSettled([
      createSurrealStatementResolutionRepository(
        concurrentA,
      ).supersedeStatementImport({
        oldImportId: claimRaceSource.id,
        expectedSourceRevision: claimRaceSource.revision,
        expectedReconciliationRevision: null,
        expectedReconciliationHash: null,
        reason: "Fictional source claim race A",
        replacement: claimRaceReplacementA,
        operation: claimRaceReplacementA.operation,
      }),
      createSurrealStatementResolutionRepository(
        concurrentB,
      ).supersedeStatementImport({
        oldImportId: claimRaceSource.id,
        expectedSourceRevision: claimRaceSource.revision,
        expectedReconciliationRevision: null,
        expectedReconciliationHash: null,
        reason: "Fictional source claim race B",
        replacement: claimRaceReplacementB,
        operation: claimRaceReplacementB.operation,
      }),
    ]);
    assert.equal(
      claimRaceResults.filter((result) => result.status === "fulfilled").length,
      1,
    );
    assert.equal(
      claimRaceResults.filter((result) => result.status === "rejected").length,
      1,
    );
    const claimRaceError = claimRaceResults.find(
      (result): result is PromiseRejectedResult => result.status === "rejected",
    )?.reason;
    assert(
      claimRaceError instanceof RavenDomainError &&
        [
          "STATEMENT_SOURCE_SUPERSESSION_CONFLICT",
          "STATEMENT_SOURCE_CLAIM_CONFLICT",
          "STATEMENT_PERIOD_CLAIM_CONFLICT",
        ].includes(claimRaceError.code),
      `Expected a stable source-ownership conflict, received ${String(
        claimRaceError,
      )}`,
    );
    assert.equal(
      await scalar(
        primary,
        `RETURN count(SELECT id FROM statementPeriodClaim
          WHERE account = type::record("account", $accountKey)
            AND periodStart = "2025-10-10" AND periodEnd = "2025-10-10"
            AND state = "active");`,
        { accountKey: claimRaceSource.accountId.slice("account:".length) },
      ),
      1,
    );
    assert.equal(
      await scalar(
        primary,
        `RETURN count(SELECT id FROM statementImport
          WHERE replacementOf = type::record("statementImport", $importKey)
            AND sourceState = "committed");`,
        { importKey: claimRaceSource.id.slice("statementImport:".length) },
      ),
      1,
    );

    const contextRace = await seedMatchRace({
      client: primary,
      importKey: "2025-09-10-account-context-race",
      componentKey: "account-context-race",
      date: "2025-09-10",
      amountMinor: 2_300,
      transactionKeys: [],
    });
    const contextRaceSource = await sourceRepository.getStatementImport(
      contextRace.statementImportId,
    );
    assert(contextRaceSource);
    const contextRaceReplacement = replacementDraft({
      source: contextRaceSource,
      key: "2025-09-10-account-context-race-replacement",
      originalHash: "d".repeat(64),
      operationKey: "st02-account-context-race",
    });
    await primary.query(
      `UPDATE account SET currency = "USD" WHERE key = $accountKey;`,
      { accountKey: ACCOUNT_KEY },
    );
    try {
      await assert.rejects(
        resolutionRepository.supersedeStatementImport({
          oldImportId: contextRaceSource.id,
          expectedSourceRevision: contextRaceSource.revision,
          expectedReconciliationRevision: null,
          expectedReconciliationHash: null,
          reason: "Fictional account context race",
          replacement: contextRaceReplacement,
          operation: contextRaceReplacement.operation,
        }),
        (error: unknown) =>
          error instanceof RavenDomainError &&
          error.code === "STATEMENT_ACCOUNT_CONTEXT_STALE",
      );
    } finally {
      await primary.query(
        `UPDATE account SET currency = "ZAR" WHERE key = $accountKey;`,
        { accountKey: ACCOUNT_KEY },
      );
    }
    assert.equal(
      (await sourceRepository.getStatementImport(contextRaceSource.id))
        ?.sourceState,
      "committed",
    );
    assert.equal(
      await scalar(
        primary,
        `RETURN count(SELECT id FROM financialOperation
          WHERE idempotencyKey = "st02-account-context-race");`,
      ),
      0,
    );

    const rollbackCase = await seedMatchRace({
      client: primary,
      importKey: "2026-04-10-source-rollback",
      componentKey: "source-rollback",
      date: "2026-04-10",
      amountMinor: 1_100,
      transactionKeys: [],
    });
    await seedSourceClaims(primary, rollbackCase.statementImportId);
    const rollbackSource = await createSurrealStatementTruthRepository(
      primary,
    ).getStatementImport(rollbackCase.statementImportId);
    assert(rollbackSource);
    const rollbackReplacement = replacementDraft({
      source: rollbackSource,
      key: "2026-04-10-source-rollback-replacement",
      originalHash: "2".repeat(64),
      operationKey: "st02-source-supersession-rollback",
    });
    await primary.query(
      `LET $oldImport = SELECT * FROM ONLY type::record("statementImport", $oldImportKey);
       LET $newImportId = type::record("statementImport", fn::stringID([$oldImport.account, $replacementKey]));
       LET $rowId = type::record("statementRow", fn::stringID([$newImportId, "replacement-row-1"]));
       CREATE ONLY $rowId CONTENT { key: "forced-conflict" };`,
      {
        oldImportKey: rollbackSource.id.slice("statementImport:".length),
        replacementKey: rollbackReplacement.statementImport.key,
      },
    );
    await assert.rejects(
      resolutionRepository.supersedeStatementImport({
        oldImportId: rollbackSource.id,
        expectedSourceRevision: rollbackSource.revision,
        expectedReconciliationRevision: null,
        expectedReconciliationHash: null,
        reason: "Fictional rollback proof",
        replacement: rollbackReplacement,
        operation: rollbackReplacement.operation,
      }),
    );
    const rollbackAfter = await createSurrealStatementTruthRepository(
      primary,
    ).getStatementImport(rollbackSource.id);
    assert.equal(rollbackAfter?.sourceState, "committed");
    assert.equal(rollbackAfter?.revision, rollbackSource.revision);
    assert.equal(
      await scalar(
        primary,
        `RETURN count(SELECT id FROM statementSourceClaim
          WHERE statementImport = type::record("statementImport", $importKey)
            AND state = "active");`,
        { importKey: rollbackSource.id.slice("statementImport:".length) },
      ),
      1,
    );
    assert.equal(
      await scalar(
        primary,
        `RETURN count(SELECT id FROM financialOperation
          WHERE idempotencyKey = "st02-source-supersession-rollback");`,
      ),
      0,
    );
    assert.equal(
      await scalar(primary, "RETURN count(SELECT id FROM accountTransfer);"),
      0,
    );
    assert.equal(
      await scalar(primary, "RETURN count(SELECT id FROM clarificationTask);"),
      0,
    );
    console.log(
      "ST-02 disposable live smoke passed: exact matching, no duplicate manual movement, transfer review blocking, one-shot materialization and replay, informational exclusion, exact reconciliation and attestation-set rejection, independent concurrent confirmations, concurrent issue/match survival, exclusive component and Transaction claims, active-ledger and snapshot supersession, readable history, replacement re-resolution, source-claim and Account-context races, forced rollback, cleanup, and later-lane exclusions.",
    );
  } finally {
    await Promise.allSettled(clients.map((client) => client.close()));
    await stop(database);
  }
}

await main();
