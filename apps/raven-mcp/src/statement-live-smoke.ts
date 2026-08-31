import assert from "node:assert/strict";
import { spawn, type ChildProcess } from "node:child_process";
import { randomUUID } from "node:crypto";
import { once } from "node:events";
import { mkdir, rm } from "node:fs/promises";
import net from "node:net";
import os from "node:os";
import path from "node:path";
import {
  createDefaultStatementAdapterRegistry,
  createLocalStatementSourceVault,
  createStatementTruthService,
  RavenDomainError,
  type StatementCommitDraft,
  type StatementTruthRepository,
  type StatementTruthApi,
} from "@raven/domain/server";
import {
  createSurrealStatementTruthRepository,
  type SurrealQueryClient,
} from "@raven/surreal";
import { Surreal } from "surrealdb";

const SPACE_KEY = "st01-fictional-space";
const ACCOUNT_KEY = "st01-fictional-account";
const PROFILE_ID = "fnb-business" as const;
const PROFILE_VERSION = "1" as const;
const ACTOR_ID = "st01-live-smoke";
const NOW = "2026-07-30T10:00:00.000Z";
const EPHEMERAL_USERNAME = "st01-smoke";
const EPHEMERAL_PASSWORD = randomUUID();

type Raw = Record<string, unknown>;

function safeRows(response: unknown): Raw[] {
  if (!Array.isArray(response)) return [];
  for (let index = response.length - 1; index >= 0; index -= 1) {
    const result = response[index];
    if (Array.isArray(result)) return result as Raw[];
    if (result && typeof result === "object") return [result as Raw];
  }
  return [];
}

async function reservePort(): Promise<number> {
  const server = net.createServer();
  server.listen(0, "127.0.0.1");
  await once(server, "listening");
  const address = server.address();
  assert(address && typeof address === "object");
  const port = address.port;
  server.close();
  await once(server, "close");
  return port;
}

async function waitForHealth(endpoint: string, process: ChildProcess) {
  for (let attempt = 0; attempt < 80; attempt += 1) {
    if (process.exitCode !== null) {
      throw new Error(
        `Disposable SurrealDB exited before becoming healthy (${process.exitCode})`,
      );
    }
    try {
      const response = await fetch(`${endpoint}/health`);
      if (response.ok) return;
    } catch {
      // The socket is expected to refuse connections during startup.
    }
    await new Promise((resolve) => setTimeout(resolve, 100));
  }
  throw new Error("Disposable SurrealDB did not become healthy");
}

async function connect(endpoint: string): Promise<Surreal> {
  const client = new Surreal();
  await client.connect(endpoint);
  await client.signin({
    username: EPHEMERAL_USERNAME,
    password: EPHEMERAL_PASSWORD,
  });
  await client.use({
    namespace: "raven_st01_smoke",
    database: "raven_st01_smoke",
  });
  return client;
}

async function stop(process: ChildProcess | null): Promise<void> {
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

function extractionInput(options: {
  periodStart: string;
  periodEnd: string;
  marker: string;
}) {
  return {
    contractVersion: "statement-extraction-input-v0.1",
    profileHint: PROFILE_ID,
    sourceKind: "pdf",
    currency: "ZAR",
    periodStart: options.periodStart,
    periodEnd: options.periodEnd,
    balanceConvention: "positive_is_asset",
    openingBalanceMinor: 10_000,
    closingBalanceMinor: 14_000,
    accountHints: {
      maskedAccount: "•••• 4242",
      sourceAccountType: "business current",
    },
    coverage: {
      status: "complete",
      sourcePageCount: 2,
      processedPages: [1, 2],
      sourceSections: ["transactions"],
      processedSections: ["transactions"],
      printedRowCount: 2,
    },
    rows: [
      {
        rowKey: "row-01",
        rowNumber: 1,
        rowKind: "movement",
        transactionDate: options.periodStart,
        postingDate: options.periodStart,
        rawText: `Fictional incoming movement ${options.marker}`,
        sourceReference: `FIC-IN-${options.marker}`,
        reportedBalanceMinor: 15_000,
        confidence: 1,
        components: [
          {
            componentKey: "principal",
            componentKind: "principal",
            componentRole: "movement",
            postingDate: options.periodStart,
            description: "Fictional principal",
            amountMinor: 5_000,
            currency: "ZAR",
            sourceDirection: "credit",
            sourceFlow: "inflow",
            balanceEffectMinor: 5_000,
            confidence: 1,
          },
        ],
      },
      {
        rowKey: "row-02",
        rowNumber: 2,
        rowKind: "composite",
        postingDate: options.periodEnd,
        rawText: `Fictional fee with printed breakdown ${options.marker}`,
        reportedBalanceMinor: 14_000,
        confidence: 1,
        components: [
          {
            componentKey: "fee",
            componentKind: "bank_fee",
            componentRole: "movement",
            postingDate: options.periodEnd,
            description: "Fictional bank fee",
            amountMinor: 1_000,
            currency: "ZAR",
            sourceDirection: "debit",
            sourceFlow: "outflow",
            balanceEffectMinor: -1_000,
            confidence: 1,
          },
          {
            componentKey: "vat-breakdown",
            componentKind: "vat",
            componentRole: "informational_breakdown",
            postingDate: options.periodEnd,
            description: "Printed VAT included in the fee",
            amountMinor: 150,
            currency: "ZAR",
            sourceDirection: "debit",
            sourceFlow: "unknown",
            balanceEffectMinor: 0,
            confidence: 1,
          },
        ],
      },
    ],
  };
}

function pdfBytes(marker: string): Uint8Array {
  return new Uint8Array(
    Buffer.from(`%PDF-1.7\nFictional ST-01 statement ${marker}\n%%EOF\n`),
  );
}

function assistBytes(input: ReturnType<typeof extractionInput>): Uint8Array {
  return new Uint8Array(Buffer.from(JSON.stringify(input)));
}

async function stageAndPreview(
  service: StatementTruthApi,
  options: {
    periodStart: string;
    periodEnd: string;
    marker: string;
    commitAllowed?: boolean;
  },
) {
  const source = await service.stageStatementSource({
    transport: "upload",
    originalBytes: pdfBytes(options.marker),
    mimeType: "application/pdf",
    sourceKind: "pdf",
    extractionAssistBytes: assistBytes(extractionInput(options)),
    extractionAssistMimeType: "application/json",
  });
  const selection = {
    sourceRef: source.sourceRef,
    spaceKey: SPACE_KEY,
    accountKey: ACCOUNT_KEY,
    profileId: PROFILE_ID,
    profileVersion: PROFILE_VERSION,
  };
  const preview = await service.previewStatementImport(selection);
  assert.equal(preview.commitAllowed, options.commitAllowed ?? true);
  return { source, selection, preview };
}

function repositoryDraft(options: {
  spaceId: string;
  accountId: string;
  marker: string;
  originalHash: string;
  periodStart: string;
  periodEnd: string;
  duplicateAt?: "row" | "component" | "issue";
}): StatementCommitDraft {
  const operationKey = `st01-${options.marker}-operation`;
  const importKey = `${options.periodEnd}-${options.marker}`;
  const row = {
    rowKey: "row-01",
    key: "row-01",
    rowNumber: 1,
    rowKind: "movement" as const,
    transactionDate: options.periodStart,
    postingDate: options.periodStart,
    valueDate: null,
    rawText: `Fictional repository row ${options.marker}`,
    sourceReference: `FIC-${options.marker}`,
    reportedBalanceMinor: 10_500,
    locator: { page: 1 },
    confidence: 1,
    rowHash: "e".repeat(64),
    componentCount: 1,
  };
  const component = {
    rowKey: "row-01",
    componentKey: "principal",
    componentKind: "principal" as const,
    componentRole: "movement" as const,
    transactionDate: options.periodStart,
    postingDate: options.periodStart,
    valueDate: null,
    description: `Fictional repository movement ${options.marker}`,
    sourceReference: `FIC-${options.marker}`,
    amountMinor: 500,
    currency: "ZAR" as const,
    sourceDirection: "credit" as const,
    sourceFlow: "inflow" as const,
    balanceEffectMinor: 500,
    locator: { page: 1 },
    confidence: 1,
    sourceChecksum: "f".repeat(64),
  };
  const issue = {
    key: "warning-01",
    code: "STATEMENT_ROW_LOW_CONFIDENCE" as const,
    severity: "warning" as const,
    blocking: false,
    message: `Fictional source warning ${options.marker}`,
    rowKey: "row-01",
    componentKey: null,
    detectedAt: NOW,
  };
  return {
    expectedAccountContext: {
      spaceId: options.spaceId,
      accountId: options.accountId,
      spaceKey: SPACE_KEY,
      accountKey: ACCOUNT_KEY,
      currency: "ZAR",
      normalNature: "asset",
      accountNumberLast4: "4242",
      spaceTimezone: "Africa/Johannesburg",
      accountContextFingerprint: "a".repeat(64),
    },
    statementImport: {
      spaceId: options.spaceId,
      accountId: options.accountId,
      spaceKey: SPACE_KEY,
      accountKey: ACCOUNT_KEY,
      key: importKey,
      privateSourceRef: `stmt-src-${options.marker}`,
      extractionAssistRef: `stmt-src-${options.marker}:assist`,
      originalFileSha256: options.originalHash,
      extractionInputSha256: "b".repeat(64),
      canonicalExtractionSha256: "c".repeat(64),
      previewHash: "d".repeat(64),
      sourceKind: "pdf",
      sourceMimeType: "application/pdf",
      sourceByteSize: 42,
      profile: {
        profileId: PROFILE_ID,
        profileVersion: PROFILE_VERSION,
        extractorVersion: "statement-neutral-v0.3",
      },
      validationRulesetVersion: "statement-validation-v0.3",
      periodStart: options.periodStart,
      periodEnd: options.periodEnd,
      currency: "ZAR",
      balanceConvention: "positive_is_asset",
      balanceConventionAuthority: "profile",
      accountContextFingerprint: "a".repeat(64),
      openingBalanceMinor: 10_000,
      closingBalanceMinor: 10_500,
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
      commitOperationId: `financialOperation:${operationKey}`,
      replacementOfId: null,
      rowCount: options.duplicateAt === "row" ? 2 : 1,
      componentCount: options.duplicateAt === "component" ? 2 : 1,
      issueCount: options.duplicateAt === "issue" ? 2 : 1,
      revision: 1,
    },
    rows: options.duplicateAt === "row" ? [row, row] : [row],
    components:
      options.duplicateAt === "component"
        ? [component, component]
        : [component],
    issues: options.duplicateAt === "issue" ? [issue, issue] : [issue],
    operation: {
      key: operationKey,
      command: "commit_statement_import",
      idempotencyKey: `st01-${options.marker}-idempotency`,
      requestHash: options.marker.padEnd(64, "0").slice(0, 64),
      channel: "system",
      actorId: ACTOR_ID,
      recordedAt: NOW,
      warningCodes: ["STATEMENT_ROW_LOW_CONFIDENCE"],
      auditMeta: { contractVersion: "statement-truth-v0.1" },
    },
    snapshot: null,
  };
}

async function count(client: Surreal, table: string): Promise<number> {
  const response = await client.query(
    `RETURN array::len(SELECT VALUE id FROM type::table($table));`,
    { table },
  );
  const value = response.find((item) => typeof item === "number");
  return Number(value ?? 0);
}

async function assertCounts(
  client: Surreal,
  expected: Record<string, number>,
): Promise<void> {
  for (const [table, value] of Object.entries(expected)) {
    assert.equal(await count(client, table), value, table);
  }
}

async function main() {
  const port = await reservePort();
  const endpoint = `http://127.0.0.1:${port}`;
  const vaultRoot = path.join(
    os.tmpdir(),
    `raven-st01-live-smoke-${process.pid}-${Date.now()}`,
  );
  let database: ChildProcess | null = null;
  const clients: Surreal[] = [];

  try {
    await mkdir(vaultRoot, { recursive: true, mode: 0o700 });
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
        EPHEMERAL_USERNAME,
        "--pass",
        EPHEMERAL_PASSWORD,
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
            LET $raw = IF $value = NONE OR $value = null {
              ""
            } ELSE IF type::is_object($value) AND $value.tb != NONE
              AND $value.tb != null AND $value.id != NONE AND $value.id != null {
              string::concat(<string> $value.tb, ":", <string> $value.id)
            } ELSE IF type::is_object($value) AND $value.id != NONE AND $value.id != null {
              <string> $value.id
            } ELSE {
              <string> $value
            };
            LET $raw = string::trim($raw);
            LET $raw = string::replace($raw, "\`", "");
            LET $raw = string::replace($raw, "⟨", "");
            LET $raw = string::replace($raw, "⟩", "");
            LET $raw = string::replace($raw, "<", "");
            LET $raw = string::replace($raw, ">", "");
            LET $raw = string::replace($raw, "{", "");
            LET $raw = string::replace($raw, "}", "");
            RETURN string::trim($raw);
          });
          RETURN array::join($processed, $separator);
        };
        DEFINE TABLE financialSpace SCHEMALESS;
        DEFINE TABLE account SCHEMALESS;
        DEFINE TABLE financialOperation SCHEMALESS;
        DEFINE TABLE statementImport SCHEMALESS;
        DEFINE TABLE statementSourceClaim SCHEMALESS;
        DEFINE TABLE statementPeriodClaim SCHEMALESS;
        DEFINE TABLE statementRow SCHEMALESS;
        DEFINE TABLE statementRowComponent SCHEMALESS;
        DEFINE TABLE statementIssue SCHEMALESS;
        DEFINE TABLE accountBalanceSnapshot SCHEMALESS;
        DEFINE TABLE transaction SCHEMALESS;
        DEFINE TABLE merchant SCHEMALESS;
        DEFINE TABLE category SCHEMALESS;
        DEFINE TABLE clarificationTask SCHEMALESS;
        DEFINE TABLE statementTransactionMatch SCHEMALESS;
        DEFINE TABLE statementReconciliation SCHEMALESS;
        DEFINE TABLE taxTreatment SCHEMALESS;
        DEFINE TABLE AccountStatementImports TYPE RELATION SCHEMALESS;
        DEFINE TABLE StatementImportRows TYPE RELATION SCHEMALESS;
        DEFINE TABLE StatementRowComponents TYPE RELATION SCHEMALESS;
        DEFINE TABLE StatementImportIssues TYPE RELATION SCHEMALESS;
        LET $spaceId = type::record("financialSpace", $spaceKey);
        LET $accountId = type::record("account", fn::stringID([$spaceId, $accountKey]));
        CREATE ONLY $spaceId CONTENT {
          key: $spaceKey,
          name: "ST-01 Fictional Space",
          spaceType: "business",
          currency: "ZAR",
          timezone: "Africa/Johannesburg",
          active: true
        };
        CREATE ONLY $accountId CONTENT {
          space: $spaceId,
          key: $accountKey,
          name: "ST-01 Fictional Account",
          accountType: "business",
          currency: "ZAR",
          normalNature: "asset",
          liquidityClass: "liquid",
          accountNumberLast4: "4242",
          active: true
        };
      `,
      { spaceKey: SPACE_KEY, accountKey: ACCOUNT_KEY },
    );
    const seededAccounts = safeRows(
      await primary.query(
        `SELECT *, space.key AS spaceKey, space.timezone AS spaceTimezone
         FROM account;`,
      ),
    );
    assert.equal(seededAccounts.length, 1, "fictional account seed");
    assert.equal(seededAccounts[0]?.spaceKey, SPACE_KEY);
    assert.equal(seededAccounts[0]?.spaceTimezone, "Africa/Johannesburg");

    const primaryRepository = createSurrealStatementTruthRepository(primary);
    const service = createStatementTruthService({
      repository: primaryRepository,
      adapters: createDefaultStatementAdapterRegistry(),
      vault: createLocalStatementSourceVault({
        vaultRoot,
        allowedInboxRoots: [],
      }),
      clock: () => NOW,
    });

    const profileMismatchInput = extractionInput({
      periodStart: "2026-04-01",
      periodEnd: "2026-04-30",
      marker: "profile-mismatch",
    });
    profileMismatchInput.balanceConvention = "positive_is_liability";
    const profileMismatchSource = await service.stageStatementSource({
      transport: "upload",
      originalBytes: pdfBytes("profile-mismatch"),
      mimeType: "application/pdf",
      sourceKind: "pdf",
      extractionAssistBytes: assistBytes(profileMismatchInput),
      extractionAssistMimeType: "application/json",
    });
    await assert.rejects(
      service.previewStatementImport({
        sourceRef: profileMismatchSource.sourceRef,
        spaceKey: SPACE_KEY,
        accountKey: ACCOUNT_KEY,
        profileId: PROFILE_ID,
        profileVersion: PROFILE_VERSION,
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_EXTRACTION_INVALID",
    );

    const coverageBypassInput = extractionInput({
      periodStart: "2026-05-01",
      periodEnd: "2026-05-31",
      marker: "coverage-bypass",
    });
    (
      coverageBypassInput.coverage as { sourcePageCount: number | null }
    ).sourcePageCount = null;
    coverageBypassInput.coverage.processedPages = [];
    const coverageBypassSource = await service.stageStatementSource({
      transport: "upload",
      originalBytes: pdfBytes("coverage-bypass"),
      mimeType: "application/pdf",
      sourceKind: "pdf",
      extractionAssistBytes: assistBytes(coverageBypassInput),
      extractionAssistMimeType: "application/json",
    });
    await assert.rejects(
      service.previewStatementImport({
        sourceRef: coverageBypassSource.sourceRef,
        spaceKey: SPACE_KEY,
        accountKey: ACCOUNT_KEY,
        profileId: PROFILE_ID,
        profileVersion: PROFILE_VERSION,
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_EXTRACTION_INVALID",
    );

    const first = await stageAndPreview(service, {
      periodStart: "2026-07-01",
      periodEnd: "2026-07-31",
      marker: "first",
    });
    assert.deepEqual(first.preview.extraction.coverage, {
      status: "complete",
      sourcePageCount: 2,
      processedPages: [1, 2],
      sourceSections: ["transactions"],
      processedSections: ["transactions"],
      printedRowCount: 2,
      extractedRowCount: 2,
    });
    const firstInput = {
      ...first.selection,
      previewHash: first.preview.previewHash,
      idempotencyKey: "st01-live-first",
      channel: "system" as const,
      actorId: ACTOR_ID,
    };
    const committed = await service.commitStatementImport(firstInput);
    assert.equal(committed.receipt.status, "applied");
    assert(committed.snapshotId);
    assert.equal(
      committed.statementImport.importedAt,
      NOW,
      "first commit must preserve its import time",
    );
    await rm(path.join(vaultRoot, first.source.sourceRef), {
      recursive: true,
      force: true,
    });
    const replay = await service.commitStatementImport(firstInput);
    assert.equal(replay.receipt.status, "replayed");
    assert.equal(replay.statementImport.id, committed.statementImport.id);
    assert.equal(
      replay.statementImport.importedAt,
      committed.statementImport.importedAt,
    );
    await assert.rejects(
      service.commitStatementImport({
        ...firstInput,
        actorId: "changed-fictional-actor",
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "IDEMPOTENCY_CONFLICT",
    );

    await primary.query(
      `
      LET $spaceId = type::record("financialSpace", $spaceKey);
      LET $accountId = type::record("account", fn::stringID([$spaceId, $accountKey]));
      LET $legacyId = type::record("statementImport", fn::stringID([$accountId, "2026-12-31-fictional-renderer"]));
      CREATE ONLY $legacyId CONTENT {
        space: $spaceId,
        account: $accountId,
        key: "2026-12-31-fictional-renderer",
        sourceFileName: "private-source",
        sourceFormat: "manual",
        statementDate: "2026-12-31T00:00:00Z",
        importedAt: "2026-12-31T00:00:00Z",
        status: "parsed"
      };
      `,
      { spaceKey: SPACE_KEY, accountKey: ACCOUNT_KEY },
    );
    const legacySource = await stageAndPreview(service, {
      periodStart: "2026-12-01",
      periodEnd: "2026-12-31",
      marker: "renderer-legacy-conflict",
      commitAllowed: false,
    });
    assert.equal(legacySource.preview.commitAllowed, false);
    assert.ok(
      legacySource.preview.issues.some(
        (item) =>
          item.code === "STATEMENT_LEGACY_PERIOD_CONFLICT" && item.blocking,
      ),
    );
    await primary.query(
      `DELETE statementImport WHERE key = "2026-12-31-fictional-renderer";`,
    );

    const account = await primaryRepository.getAccount(SPACE_KEY, ACCOUNT_KEY);
    assert(account);
    const raceA = repositoryDraft({
      spaceId: account.spaceId,
      accountId: account.id,
      marker: "race-a",
      originalHash: "1".repeat(64),
      periodStart: "2026-08-01",
      periodEnd: "2026-08-31",
    });
    const raceB = repositoryDraft({
      spaceId: account.spaceId,
      accountId: account.id,
      marker: "race-b",
      originalHash: "2".repeat(64),
      periodStart: "2026-08-01",
      periodEnd: "2026-08-31",
    });
    const race = await Promise.allSettled([
      createSurrealStatementTruthRepository(
        concurrentA as unknown as SurrealQueryClient,
      ).commitStatementImport(raceA),
      createSurrealStatementTruthRepository(
        concurrentB as unknown as SurrealQueryClient,
      ).commitStatementImport(raceB),
    ]);
    assert.equal(
      race.filter((result) => result.status === "fulfilled").length,
      1,
    );
    const raceFailure = race.find((result) => result.status === "rejected");
    assert(raceFailure && raceFailure.status === "rejected");
    assert(
      raceFailure.reason instanceof RavenDomainError &&
        raceFailure.reason.code === "STATEMENT_IMMUTABLE_CONFLICT",
    );

    const duplicateSourceDraft = repositoryDraft({
      spaceId: account.spaceId,
      accountId: account.id,
      marker: "duplicate-source-claim",
      originalHash: committed.statementImport.originalFileSha256,
      periodStart: "2027-01-01",
      periodEnd: "2027-01-31",
    });
    await assert.rejects(
      primaryRepository.commitStatementImport(duplicateSourceDraft),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_DUPLICATE_SOURCE",
    );

    const contextRace = await stageAndPreview(service, {
      periodStart: "2027-02-01",
      periodEnd: "2027-02-28",
      marker: "account-context-race",
    });
    const importsBeforeContextRace = await count(primary, "statementImport");
    const operationsBeforeContextRace = await count(
      primary,
      "financialOperation",
    );
    const contextRaceRepository: StatementTruthRepository = {
      getAccount: (...args) => primaryRepository.getAccount(...args),
      getCommitOperation: (...args) =>
        primaryRepository.getCommitOperation(...args),
      listStatementImports: (...args) =>
        primaryRepository.listStatementImports(...args),
      getStatementImport: (...args) =>
        primaryRepository.getStatementImport(...args),
      listStatementRows: (...args) =>
        primaryRepository.listStatementRows(...args),
      getStatementRow: (...args) => primaryRepository.getStatementRow(...args),
      listStatementRowComponents: (...args) =>
        primaryRepository.listStatementRowComponents(...args),
      getStatementRowComponent: (...args) =>
        primaryRepository.getStatementRowComponent(...args),
      listStatementIssues: (...args) =>
        primaryRepository.listStatementIssues(...args),
      getStatementIssue: (...args) =>
        primaryRepository.getStatementIssue(...args),
      async commitStatementImport(draft) {
        await primary.query(
          `UPDATE financialSpace SET timezone = "UTC" WHERE key = $spaceKey;`,
          { spaceKey: SPACE_KEY },
        );
        return primaryRepository.commitStatementImport(draft);
      },
    };
    const contextRaceService = createStatementTruthService({
      repository: contextRaceRepository,
      adapters: createDefaultStatementAdapterRegistry(),
      vault: createLocalStatementSourceVault({
        vaultRoot,
        allowedInboxRoots: [],
      }),
      clock: () => NOW,
    });
    await assert.rejects(
      contextRaceService.commitStatementImport({
        ...contextRace.selection,
        previewHash: contextRace.preview.previewHash,
        idempotencyKey: "st01-live-account-context-race",
        channel: "system",
        actorId: ACTOR_ID,
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_PREVIEW_STALE",
    );
    assert.equal(
      await count(primary, "statementImport"),
      importsBeforeContextRace,
    );
    assert.equal(
      await count(primary, "financialOperation"),
      operationsBeforeContextRace,
    );
    await primary.query(
      `UPDATE financialSpace SET timezone = "Africa/Johannesburg" WHERE key = $spaceKey;`,
      { spaceKey: SPACE_KEY },
    );

    for (const duplicateAt of ["row", "component", "issue"] as const) {
      const rollback = repositoryDraft({
        spaceId: account.spaceId,
        accountId: account.id,
        marker: `rollback-${duplicateAt}`,
        originalHash:
          duplicateAt === "row"
            ? "3".repeat(64)
            : duplicateAt === "component"
              ? "4".repeat(64)
              : "5".repeat(64),
        periodStart:
          duplicateAt === "row"
            ? "2026-09-01"
            : duplicateAt === "component"
              ? "2026-10-01"
              : "2026-11-01",
        periodEnd:
          duplicateAt === "row"
            ? "2026-09-30"
            : duplicateAt === "component"
              ? "2026-10-31"
              : "2026-11-30",
        duplicateAt,
      });
      await assert.rejects(primaryRepository.commitStatementImport(rollback));
    }

    await assertCounts(primary, {
      statementImport: 2,
      statementSourceClaim: 2,
      statementPeriodClaim: 2,
      statementRow: 3,
      statementRowComponent: 4,
      statementIssue: 1,
      accountBalanceSnapshot: 1,
      financialOperation: 2,
      AccountStatementImports: 2,
      StatementImportRows: 3,
      StatementRowComponents: 4,
      StatementImportIssues: 1,
      transaction: 0,
      merchant: 0,
      category: 0,
      clarificationTask: 0,
      statementTransactionMatch: 0,
      statementReconciliation: 0,
      taxTreatment: 0,
    });
    const snapshot = safeRows(
      await primary.query(
        `SELECT key, asOf, amountMinor, currency, economicNature
         FROM accountBalanceSnapshot;`,
      ),
    )[0];
    assert(snapshot);
    assert.equal(snapshot.asOf, "2026-07-31T21:59:59.999Z");
    assert.equal(snapshot.amountMinor, 14_000);
    assert.equal(snapshot.currency, "ZAR");
    assert.equal(snapshot.economicNature, "asset");
    assert.match(String(snapshot.key), /^statement-[a-f0-9]{32}$/);

    console.log(
      "ST-01 disposable live smoke passed: profile authority, PDF coverage, renderer legacy conflict, account-context rollback, stable claims, replay, concurrency, edges, snapshot, and later-lane exclusions.",
    );
  } finally {
    await Promise.allSettled(clients.map((client) => client.close()));
    await rm(vaultRoot, { recursive: true, force: true });
    await stop(database);
  }
}

await main();
