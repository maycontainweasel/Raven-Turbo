import assert from "node:assert/strict";
import { spawn, type ChildProcess } from "node:child_process";
import { randomUUID } from "node:crypto";
import { once } from "node:events";
import net from "node:net";

import type {
  StatementLegacyApplyDraft,
  StatementLegacyReverseDraft,
} from "@raven/domain/server";
import { createSurrealStatementLegacyResolutionRepository } from "@raven/surreal";
import { Surreal } from "surrealdb";

const USERNAME = "hp04-smoke";
const PASSWORD = randomUUID();
const NOW = "2026-08-11T10:00:00.000Z";
const H = "a".repeat(64);

async function reservePort(): Promise<number> {
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
  for (let attempt = 0; attempt < 80; attempt += 1) {
    if (process.exitCode !== null) {
      throw new Error(
        `Disposable SurrealDB exited early (${process.exitCode})`,
      );
    }
    try {
      if ((await fetch(`${endpoint}/health`)).ok) return;
    } catch {
      // Startup races are expected for this disposable process.
    }
    await new Promise((resolve) => setTimeout(resolve, 100));
  }
  throw new Error("Disposable SurrealDB did not become healthy");
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

async function scalar(client: Surreal, query: string): Promise<number> {
  const response = await client.query(query);
  const value = response
    .flat(Infinity)
    .find((entry) => typeof entry === "number");
  return Number(value ?? 0);
}

function operation(
  command:
    | "apply_legacy_statement_resolution"
    | "reverse_legacy_statement_resolution",
  suffix = "live",
) {
  return {
    key: `${command}-hp04-${suffix}`,
    command,
    idempotencyKey: `${command}-hp04-${suffix}-intent`,
    requestHash:
      command === "apply_legacy_statement_resolution"
        ? "b".repeat(64)
        : "c".repeat(64),
    channel: "system" as const,
    actorId: "hp04-fictional-operator",
    recordedAt: NOW,
    warningCodes: [],
    auditMeta: { contractVersion: "statement-truth-v0.1", workline: "HP-04" },
  };
}

function applyDraft(): StatementLegacyApplyDraft {
  const applyOperation = operation("apply_legacy_statement_resolution");
  return {
    source: {
      expectedAccountContext: {
        spaceId: "financialSpace:hp04-fictional",
        accountId: "account:financialSpace:hp04-fictional|hp04-primary",
        spaceKey: "hp04-fictional",
        accountKey: "hp04-primary",
        currency: "ZAR",
        normalNature: "asset",
        accountNumberLast4: "0001",
        spaceTimezone: "Africa/Johannesburg",
        accountContextFingerprint: H,
      },
      statementImport: {
        spaceId: "financialSpace:hp04-fictional",
        accountId: "account:financialSpace:hp04-fictional|hp04-primary",
        spaceKey: "hp04-fictional",
        accountKey: "hp04-primary",
        key: "2026-06-30-hp04-canonical",
        privateSourceRef: "vault:fictional-hp04-source",
        extractionAssistRef: null,
        originalFileSha256: "d".repeat(64),
        extractionInputSha256: "e".repeat(64),
        canonicalExtractionSha256: "f".repeat(64),
        previewHash: "1".repeat(64),
        sourceKind: "pdf",
        sourceMimeType: "application/pdf",
        sourceByteSize: 64,
        profile: {
          profileId: "fnb-business",
          profileVersion: "1",
          extractorVersion: "statement-neutral-v0.3",
        },
        validationRulesetVersion: "statement-validation-v0.3",
        periodStart: "2026-06-01",
        periodEnd: "2026-06-30",
        currency: "ZAR",
        balanceConvention: "positive_is_asset",
        balanceConventionAuthority: "profile",
        accountContextFingerprint: H,
        openingBalanceMinor: 10_000,
        closingBalanceMinor: 5_000,
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
        commitOperationId: `financialOperation:${applyOperation.key}`,
        replacementOfId:
          "statementImport:account:financialSpace:hp04-fictional|hp04-primary|2026-06-30-hp04-legacy",
        rowCount: 1,
        componentCount: 1,
        issueCount: 0,
        revision: 1,
      },
      rows: [
        {
          rowKey: "row-1",
          key: "row-1",
          rowNumber: 1,
          rowKind: "movement",
          transactionDate: "2026-06-12",
          postingDate: "2026-06-12",
          valueDate: null,
          rawText: "Fictional exact payment",
          sourceReference: "FIC-HP04-1",
          reportedBalanceMinor: 5_000,
          locator: { page: 1, line: 1 },
          confidence: 1,
          rowHash: "2".repeat(64),
          componentCount: 1,
        },
      ],
      components: [
        {
          rowKey: "row-1",
          componentKey: "principal",
          componentKind: "principal",
          componentRole: "movement",
          transactionDate: "2026-06-12",
          postingDate: "2026-06-12",
          valueDate: null,
          description: "Fictional exact payment",
          sourceReference: "FIC-HP04-1",
          amountMinor: 5_000,
          currency: "ZAR",
          sourceDirection: "debit",
          sourceFlow: "outflow",
          balanceEffectMinor: -5_000,
          locator: { page: 1, line: 1 },
          confidence: 1,
          sourceChecksum: "3".repeat(64),
        },
      ],
      issues: [],
      operation: applyOperation,
      snapshot: null,
    },
    evidence: {
      databaseFingerprint: H,
      legacyStatementImport: {
        id: "statementImport:account:financialSpace:hp04-fictional|hp04-primary|2026-06-30-hp04-legacy",
        revision: 1,
        sourceState: "legacy",
      },
      legacyRows: [],
      legacyTransactions: [],
      counterpartTransactions: [],
      accountTransfers: [],
      activeMatches: [],
      reconciliation: null,
      dependentAuthorityHash: "4".repeat(64),
    },
    plan: {
      databaseFingerprint: H,
      sourceIdentityHash: "5".repeat(64),
      canonicalPreviewHash: "1".repeat(64),
      legacyEvidenceHash: "6".repeat(64),
      accountContextFingerprint: H,
      crosswalkHash: "7".repeat(64),
      expectedRevisionClaimHash: "8".repeat(64),
      resultAuthorityHash: "9".repeat(64),
      aggregateCounts: {
        exact_existing_transaction_adoption: 1,
        exact_grouped_component_adoption: 0,
        canonical_component_requires_materialization: 0,
        legacy_transaction_historical_only: 0,
        transfer_review_required: 0,
        informational_non_movement: 0,
        ambiguous_or_conflicting: 0,
      },
      items: [
        {
          key: "exact-adoption",
          compatibilityClass: "exact_existing_transaction_adoption",
          activeLedgerOutcome: "adopted_existing",
          canonicalComponents: [
            {
              rowKey: "row-1",
              rowNumber: 1,
              componentKey: "principal",
              componentRole: "movement",
              sourceChecksum: "3".repeat(64),
              amountMinor: 5_000,
              balanceEffectMinor: -5_000,
              currency: "ZAR",
              financialDate: "2026-06-12",
            },
          ],
          legacyStatementRowId:
            "statementRow:statementImport:account:financialSpace:hp04-fictional|hp04-primary|2026-06-30-hp04-legacy|legacy-row-1",
          legacyTransactionIds: [
            "transaction:account:financialSpace:hp04-fictional|hp04-primary|legacy-payment",
          ],
          primaryLegacyTransactionId:
            "transaction:account:financialSpace:hp04-fictional|hp04-primary|legacy-payment",
          accountTransferId: null,
          itemEvidenceHash: "0".repeat(64),
          expectedClaimHash: "a".repeat(64),
          blocking: false,
        },
      ],
      eligibleStrategies: ["A"],
      recommendedStrategy: "A",
      applyEligible: true,
    },
    strategy: "A",
    decisions: [
      {
        itemKey: "exact-adoption",
        outcome: "adopted_existing",
        itemEvidenceHash: "0".repeat(64),
        legacyTransactionId:
          "transaction:account:financialSpace:hp04-fictional|hp04-primary|legacy-payment",
      },
    ],
    operation: applyOperation,
  } as unknown as StatementLegacyApplyDraft;
}

function materializationDraft(): StatementLegacyApplyDraft {
  const base = applyDraft();
  const applyOperation = {
    ...operation("apply_legacy_statement_resolution"),
    key: "apply_legacy_statement_resolution-hp04-materialize",
    idempotencyKey: "apply_legacy_statement_resolution-hp04-materialize-intent",
    requestHash: "6".repeat(64),
  };
  const legacyImportId =
    "statementImport:account:financialSpace:hp04-fictional|hp04-primary|2026-06-30-hp04-materialize-legacy";
  return {
    ...base,
    source: {
      ...base.source,
      statementImport: {
        ...base.source.statementImport,
        key: "2026-06-30-hp04-materialize-canonical",
        privateSourceRef: "vault:fictional-hp04-materialize-source",
        originalFileSha256: "4".repeat(64),
        canonicalExtractionSha256: "5".repeat(64),
        replacementOfId: legacyImportId,
        commitOperationId: `financialOperation:${applyOperation.key}`,
      },
      operation: applyOperation,
    },
    evidence: {
      ...base.evidence,
      legacyStatementImport: {
        id: legacyImportId,
        revision: 1,
        sourceState: "legacy",
      },
      dependentAuthorityHash: "7".repeat(64),
    },
    plan: {
      ...base.plan,
      sourceIdentityHash: "8".repeat(64),
      legacyEvidenceHash: "a".repeat(64),
      crosswalkHash: "b".repeat(64),
      expectedRevisionClaimHash: "c".repeat(64),
      resultAuthorityHash: "d".repeat(64),
      aggregateCounts: {
        exact_existing_transaction_adoption: 0,
        exact_grouped_component_adoption: 0,
        canonical_component_requires_materialization: 1,
        legacy_transaction_historical_only: 0,
        transfer_review_required: 0,
        informational_non_movement: 0,
        ambiguous_or_conflicting: 0,
      },
      items: [
        {
          ...base.plan.items[0]!,
          key: "explicit-materialization",
          compatibilityClass: "canonical_component_requires_materialization",
          activeLedgerOutcome: "materialized",
          legacyStatementRowId:
            "statementRow:statementImport:account:financialSpace:hp04-fictional|hp04-primary|2026-06-30-hp04-materialize-legacy|legacy-row-1",
          legacyTransactionIds: [],
          primaryLegacyTransactionId: null,
          itemEvidenceHash: "e".repeat(64),
          expectedClaimHash: "f".repeat(64),
        },
      ],
      eligibleStrategies: ["B"],
      recommendedStrategy: "B",
    },
    strategy: "B",
    decisions: [
      {
        itemKey: "explicit-materialization",
        outcome: "materialized",
        itemEvidenceHash: "e".repeat(64),
      },
    ],
    operation: applyOperation,
  } as unknown as StatementLegacyApplyDraft;
}

async function main() {
  const port = await reservePort();
  const endpoint = `http://127.0.0.1:${port}`;
  let database: ChildProcess | null = null;
  let client: Surreal | null = null;
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
    client = new Surreal();
    await client.connect(endpoint);
    await client.signin({ username: USERNAME, password: PASSWORD });
    await client.use({
      namespace: "raven_hp04_smoke",
      database: "raven_hp04_smoke",
    });
    await client.query(
      `DEFINE FUNCTION OVERWRITE fn::stringID($values: array, $separator: option<string>) {
         LET $separator = $separator ?? "|";
         LET $processed = $values.map(|$value| {
           LET $raw = IF $value = NONE OR $value = null { "" }
             ELSE IF type::is_object($value) AND $value.tb != NONE AND $value.id != NONE {
               string::concat(<string> $value.tb, ":", <string> $value.id)
             } ELSE IF type::is_object($value) AND $value.id != NONE { <string> $value.id }
             ELSE { <string> $value };
           RETURN string::trim(string::replace(string::replace(string::replace($raw, "\`", ""), "⟨", ""), "⟩", ""));
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
       DEFINE TABLE statementLegacyResolution SCHEMALESS;
       DEFINE TABLE statementLegacyResolutionItem SCHEMALESS;
       DEFINE TABLE transaction SCHEMALESS;
       DEFINE TABLE accountTransfer SCHEMALESS;
       DEFINE TABLE accountBalanceSnapshot SCHEMALESS;
       DEFINE TABLE AccountStatementImports TYPE RELATION SCHEMALESS;
       DEFINE TABLE StatementImportRows TYPE RELATION SCHEMALESS;
       DEFINE TABLE StatementRowComponents TYPE RELATION SCHEMALESS;
       DEFINE TABLE StatementImportIssues TYPE RELATION SCHEMALESS;
       LET $spaceId = type::record("financialSpace", "hp04-fictional");
       LET $accountId = type::record("account", fn::stringID([$spaceId, "hp04-primary"]));
       LET $legacyImportId = type::record("statementImport", fn::stringID([$accountId, "2026-06-30-hp04-legacy"]));
       LET $legacyRowId = type::record("statementRow", fn::stringID([$legacyImportId, "legacy-row-1"]));
       LET $legacyTransactionId = type::record("transaction", fn::stringID([$accountId, "legacy-payment"]));
       LET $materializeImportId = type::record("statementImport", fn::stringID([$accountId, "2026-06-30-hp04-materialize-legacy"]));
       LET $materializeRowId = type::record("statementRow", fn::stringID([$materializeImportId, "legacy-row-1"]));
       CREATE ONLY $spaceId CONTENT { key: "hp04-fictional", name: "HP-04 Fictional", active: true, currency: "ZAR", timezone: "Africa/Johannesburg" };
       CREATE ONLY $accountId CONTENT { space: $spaceId, key: "hp04-primary", name: "HP-04 Primary", active: true, currency: "ZAR", normalNature: "asset", accountNumberLast4: "0001" };
       CREATE ONLY $legacyImportId CONTENT {
         space: $spaceId, account: $accountId, key: "2026-06-30-hp04-legacy",
         privateSourceRef: "legacy:fictional", originalFileSha256: string::repeat("e", 64),
         canonicalExtractionSha256: string::repeat("f", 64), previewHash: string::repeat("1", 64),
         sourceFormat: "manual", sourceMimeType: "application/json", sourceByteSize: 1,
         profileId: "legacy", profileVersion: "1", extractorVersion: "1",
         validationRulesetVersion: "1", periodStart: "2026-06-01", periodEnd: "2026-06-30",
         currency: "ZAR", accountContextFingerprint: string::repeat("a", 64),
         openingBalanceMinor: 10000, closingBalanceMinor: 5000,
         sourceState: "legacy", importedAt: $now, committedAt: $now,
         rowCount: 1, componentCount: 0, issueCount: 0, revision: 1, statementDate: "2026-06-30"
       };
       CREATE ONLY $legacyRowId CONTENT {
         space: $spaceId, account: $accountId, statementImport: $legacyImportId,
         key: "legacy-row-1", rowNumber: 1, rowKind: "movement",
         transactionDate: "2026-06-12", postingDate: "2026-06-12",
         description: "Fictional exact payment", rowHash: string::repeat("2", 64), componentCount: 0
       };
       CREATE ONLY $legacyTransactionId CONTENT {
         space: $spaceId, account: $accountId, key: "legacy-payment",
         sourceRow: $legacyRowId, postedAt: "2026-06-12", recordedAt: $now,
         description: "Fictional exact payment", amount: 50, amountMinor: 5000,
         currency: "ZAR", direction: "debit", transactionKind: "expense",
         flowDirection: "outflow", entrySource: "imported", status: "normalized"
       };
       CREATE ONLY $materializeImportId CONTENT {
         space: $spaceId, account: $accountId, key: "2026-06-30-hp04-materialize-legacy",
         privateSourceRef: "legacy:fictional-materialize", originalFileSha256: string::repeat("6", 64),
         canonicalExtractionSha256: string::repeat("7", 64), previewHash: string::repeat("1", 64),
         sourceFormat: "manual", sourceMimeType: "application/json", sourceByteSize: 1,
         profileId: "legacy", profileVersion: "1", extractorVersion: "1",
         validationRulesetVersion: "1", periodStart: "2026-06-01", periodEnd: "2026-06-30",
         currency: "ZAR", accountContextFingerprint: string::repeat("a", 64),
         openingBalanceMinor: 10000, closingBalanceMinor: 5000,
         sourceState: "legacy", importedAt: $now, committedAt: $now,
         rowCount: 1, componentCount: 0, issueCount: 0, revision: 1, statementDate: "2026-06-30"
       };
       CREATE ONLY $materializeRowId CONTENT {
         space: $spaceId, account: $accountId, statementImport: $materializeImportId,
         key: "legacy-row-1", rowNumber: 1, rowKind: "movement",
         transactionDate: "2026-06-12", postingDate: "2026-06-12",
         description: "Fictional materialized payment", rowHash: string::repeat("8", 64), componentCount: 0
       };
       RETURN { legacyImport: type::string($legacyImportId), legacyTransaction: type::string($legacyTransactionId) };`,
      { now: NOW },
    );

    const repository = createSurrealStatementLegacyResolutionRepository(
      client,
      H,
    );
    const applied = await repository.apply(applyDraft());
    assert.equal(applied.resolution.resolutionType, "apply");
    assert.equal(applied.statementImport.sourceState, "committed");
    assert.equal(applied.reconciliation?.differenceMinor, 0);
    assert.equal(
      await scalar(
        client,
        'RETURN count(SELECT id FROM statementTransactionResolutionClaim WHERE state = "active");',
      ),
      1,
    );
    assert.equal(
      await scalar(
        client,
        'RETURN count(SELECT id FROM transaction WHERE status != "ignored");',
      ),
      1,
    );
    const conflictingOperation = {
      ...operation("apply_legacy_statement_resolution"),
      key: "apply_legacy_statement_resolution-hp04-conflict",
      idempotencyKey: "apply_legacy_statement_resolution-hp04-conflict-intent",
      requestHash: "2".repeat(64),
    };
    const conflictingDraft = {
      ...applyDraft(),
      operation: conflictingOperation,
    } as unknown as StatementLegacyApplyDraft;
    await assert.rejects(repository.apply(conflictingDraft));
    assert.equal(
      await scalar(
        client,
        "RETURN count(SELECT id FROM statementLegacyResolution);",
      ),
      1,
    );
    assert.equal(
      await scalar(client, "RETURN count(SELECT id FROM financialOperation);"),
      1,
    );
    const reversed = await repository.reverse({
      target: applied.resolution,
      targetItems: applied.items,
      expectedDatabaseFingerprint: H,
      expectedAuthorityHash: applied.resolution.resultAuthorityHash,
      operation: operation("reverse_legacy_statement_resolution"),
    } as StatementLegacyReverseDraft);
    assert.equal(reversed.resolution.resolutionType, "reversal");
    assert.equal(reversed.statementImport.sourceState, "legacy");
    assert.equal(
      await scalar(
        client,
        'RETURN count(SELECT id FROM statementTransactionResolutionClaim WHERE state = "active");',
      ),
      0,
    );
    assert.equal(
      await scalar(
        client,
        'RETURN count(SELECT id FROM transaction WHERE status != "ignored");',
      ),
      1,
    );
    assert.equal(
      await scalar(
        client,
        "RETURN count(SELECT id FROM statementLegacyResolution);",
      ),
      2,
    );
    const materialized = await repository.apply(materializationDraft());
    assert.equal(materialized.resolution.strategy, "B");
    assert.equal(materialized.items[0]?.activeLedgerOutcome, "materialized");
    assert.equal(
      await scalar(
        client,
        'RETURN count(SELECT id FROM statementTransactionResolutionClaim WHERE state = "active");',
      ),
      1,
    );
    assert.equal(
      await scalar(
        client,
        'RETURN count(SELECT id FROM transaction WHERE status != "ignored");',
      ),
      2,
    );
    const materializedReversal = await repository.reverse({
      target: materialized.resolution,
      targetItems: materialized.items,
      expectedDatabaseFingerprint: H,
      expectedAuthorityHash: materialized.resolution.resultAuthorityHash,
      operation: operation(
        "reverse_legacy_statement_resolution",
        "materialize",
      ),
    } as StatementLegacyReverseDraft);
    assert.equal(materializedReversal.resolution.resolutionType, "reversal");
    assert.equal(
      await scalar(
        client,
        'RETURN count(SELECT id FROM statementTransactionResolutionClaim WHERE state = "active");',
      ),
      0,
    );
    assert.equal(
      await scalar(
        client,
        'RETURN count(SELECT id FROM transaction WHERE status != "ignored");',
      ),
      1,
    );
    assert.equal(
      await scalar(
        client,
        "RETURN count(SELECT id FROM statementLegacyResolution);",
      ),
      4,
    );
    console.log(
      "HP-04 disposable live smoke passed: fictional exact adoption and explicit materialization, one-active-movement authority, atomic apply, append-only guarded reversal, claim release, and history preservation.",
    );
  } finally {
    await client?.close();
    await stop(database);
  }
}

await main();
