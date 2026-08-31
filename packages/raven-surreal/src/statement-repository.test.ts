import assert from "node:assert/strict";
import test from "node:test";
import {
  RavenDomainError,
  type StatementCommitDraft,
} from "@raven/domain/server";
import { createSurrealStatementTruthRepository } from "./statement-repository.js";

test("statement account binding infers liability for legacy credit-card metadata", async () => {
  const repository = createSurrealStatementTruthRepository({
    async query() {
      return [
        [
          {
            id: "account:personal|card",
            space: "financialSpace:personal",
            spaceKey: "personal",
            key: "card",
            accountType: "credit_card",
            currency: "ZAR",
            accountNumberLast4: "8996",
            spaceTimezone: "Africa/Johannesburg",
          },
        ],
      ];
    },
  });

  const account = await repository.getAccount("personal", "card");
  assert.equal(account?.normalNature, "liability");
});

function draft(): StatementCommitDraft {
  return {
    expectedAccountContext: {
      spaceId: "financialSpace:fictional-space",
      accountId: "account:fictional-space|fictional-account",
      spaceKey: "fictional-space",
      accountKey: "fictional-account",
      currency: "ZAR",
      normalNature: "asset",
      accountNumberLast4: "4242",
      spaceTimezone: "Africa/Johannesburg",
      accountContextFingerprint: "a".repeat(64),
    },
    statementImport: {
      spaceId: "financialSpace:fictional-space",
      accountId: "account:fictional-space|fictional-account",
      spaceKey: "fictional-space",
      accountKey: "fictional-account",
      key: "2026-07-31-abc123",
      privateSourceRef: "stmt-src-00000000-0000-4000-8000-000000000000",
      extractionAssistRef:
        "stmt-src-00000000-0000-4000-8000-000000000000:assist",
      originalFileSha256: "a".repeat(64),
      extractionInputSha256: "b".repeat(64),
      canonicalExtractionSha256: "c".repeat(64),
      previewHash: "d".repeat(64),
      sourceKind: "pdf",
      sourceMimeType: "application/pdf",
      sourceByteSize: 42,
      profile: {
        profileId: "fnb-business",
        profileVersion: "1",
        extractorVersion: "statement-neutral-v0.3",
      },
      validationRulesetVersion: "statement-validation-v0.3",
      periodStart: "2026-07-01",
      periodEnd: "2026-07-31",
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
      importedAt: "2026-07-29T12:00:00.000Z",
      committedAt: "2026-07-29T12:00:00.000Z",
      commitOperationId: "financialOperation:statement-operation",
      replacementOfId: null,
      rowCount: 1,
      componentCount: 1,
      issueCount: 0,
      revision: 1,
    },
    rows: [
      {
        rowKey: "row-01",
        key: "row-01",
        rowNumber: 1,
        rowKind: "movement",
        transactionDate: "2026-07-01",
        postingDate: "2026-07-02",
        valueDate: "2026-07-03",
        rawText: "Fictional source row",
        sourceReference: "FIC-01",
        reportedBalanceMinor: 10_500,
        locator: { page: 1, line: 2 },
        confidence: 1,
        rowHash: "e".repeat(64),
        componentCount: 1,
      },
    ],
    components: [
      {
        rowKey: "row-01",
        componentKey: "principal",
        componentKind: "principal",
        componentRole: "movement",
        transactionDate: "2026-07-01",
        postingDate: "2026-07-02",
        valueDate: "2026-07-03",
        description: "Fictional movement",
        sourceReference: "FIC-01",
        amountMinor: 500,
        currency: "ZAR",
        sourceDirection: "credit",
        sourceFlow: "inflow",
        balanceEffectMinor: 500,
        locator: { page: 1, line: 2 },
        confidence: 1,
        sourceChecksum: "f".repeat(64),
      },
    ],
    issues: [],
    operation: {
      key: "statement-operation",
      command: "commit_statement_import",
      idempotencyKey: "fictional-operation-001",
      requestHash: "1".repeat(64),
      channel: "system",
      recordedAt: "2026-07-29T12:00:00.000Z",
      warningCodes: [],
      auditMeta: { contractVersion: "statement-truth-v0.1" },
    },
    snapshot: {
      key: "2026-07-31-abc123-closing",
      spaceId: "financialSpace:fictional-space",
      accountId: "account:fictional-space|fictional-account",
      balanceKind: "statement",
      amountMinor: 10_500,
      currency: "ZAR",
      economicNature: "asset",
      asOf: "2026-07-31T23:59:59.999Z",
      recordedAt: "2026-07-29T12:00:00.000Z",
      evidenceLevel: "observed",
      sourceKind: "statement_closing",
      sourceRef: "statement-import:2026-07-31-abc123",
      operationId: "financialOperation:statement-operation",
      notes: null,
    },
  };
}

test("statement source commit is one transaction and contains no later-lane records", async () => {
  let capturedQuery = "";
  let capturedVars: Record<string, unknown> = {};
  const repository = createSurrealStatementTruthRepository({
    async query(query, vars) {
      capturedQuery = query;
      capturedVars = vars ?? {};
      return [
        {
          status: "OK",
          result: [
            {
              statementImport: {
                id: "statementImport:fictional-space|fictional-account|2026-07-31-abc123",
                space: "financialSpace:fictional-space",
                account: "account:fictional-space|fictional-account",
                key: "2026-07-31-abc123",
                sourceFormat: "pdf",
                privateSourceRef:
                  "stmt-src-00000000-0000-4000-8000-000000000000",
                extractionAssistRef:
                  "stmt-src-00000000-0000-4000-8000-000000000000:assist",
                originalFileSha256: "a".repeat(64),
                extractionInputSha256: "b".repeat(64),
                canonicalExtractionSha256: "c".repeat(64),
                previewHash: "d".repeat(64),
                sourceMimeType: "application/pdf",
                sourceByteSize: 42,
                profileId: "fnb-business",
                profileVersion: "1",
                extractorVersion: "statement-neutral-v0.1",
                validationRulesetVersion: "statement-validation-v0.1",
                periodStart: "2026-07-01",
                periodEnd: "2026-07-31",
                currency: "ZAR",
                balanceConvention: "positive_is_asset",
                openingBalanceMinor: 10_000,
                closingBalanceMinor: 10_500,
                closingBalanceEconomicNature: "asset",
                sourceState: "committed",
                importedAt: "2026-07-29T12:00:00.000Z",
                committedAt: "2026-07-29T12:00:00.000Z",
                commitOperation: "financialOperation:statement-operation",
                rowCount: 1,
                componentCount: 1,
                issueCount: 0,
              },
              operation: {
                id: "financialOperation:statement-operation",
                key: "statement-operation",
                command: "commit_statement_import",
                idempotencyKey: "fictional-operation-001",
                requestHash: "1".repeat(64),
                channel: "system",
                status: "applied",
                resultRefs: [
                  "statementImport:fictional-space|fictional-account|2026-07-31-abc123",
                  "accountBalanceSnapshot:2026-07-31-abc123-closing",
                ],
                warningCodes: [],
                auditMeta: {},
                recordedAt: "2026-07-29T12:00:00.000Z",
                completedAt: "2026-07-29T12:00:00.000Z",
              },
              snapshotId: "accountBalanceSnapshot:2026-07-31-abc123-closing",
            },
          ],
        },
      ];
    },
  });

  const result = await repository.commitStatementImport(draft());
  assert.match(capturedQuery, /BEGIN TRANSACTION;/);
  assert.match(capturedQuery, /COMMIT TRANSACTION;/);
  assert.match(capturedQuery, /CREATE ONLY \$importId/);
  assert.match(capturedQuery, /statementSourceClaim/);
  assert.match(capturedQuery, /statementPeriodClaim/);
  assert.match(capturedQuery, /STATEMENT_DUPLICATE_SOURCE/);
  assert.match(capturedQuery, /STATEMENT_IMMUTABLE_CONFLICT/);
  assert.match(capturedQuery, /STATEMENT_PREVIEW_STALE/);
  assert.match(capturedQuery, /STATEMENT_LEGACY_PERIOD_CONFLICT/);
  assert.match(capturedQuery, /STATEMENT_LEGACY_COMPATIBILITY_REQUIRED/);
  assert.match(
    capturedQuery,
    /accountType IN \["credit_card", "loan", "debt"\]/,
  );
  assert.match(capturedQuery, /CREATE ONLY \$rowId/);
  assert.match(capturedQuery, /CREATE ONLY \$componentId/);
  assert.match(capturedQuery, /CREATE ONLY \$issueId/);
  assert.match(capturedQuery, /CREATE ONLY \$snapshotId/);
  assert.match(capturedQuery, /StatementRowComponents/);
  assert.match(capturedQuery, /StatementImportIssues/);
  assert.match(capturedQuery, /AccountStatementImports/);
  assert.match(capturedQuery, /IF \$hasSnapshot/);
  assert.doesNotMatch(
    capturedQuery,
    /CREATE(?:\s+ONLY)?\s+type::record\("transaction"/i,
  );
  assert.doesNotMatch(
    capturedQuery,
    /CREATE(?:\s+ONLY)?\s+type::record\("(merchant|category|clarificationTask|statementTransactionMatch|statementReconciliation)"/i,
  );
  assert.equal((capturedVars.import as any).sourceFileName, undefined);
  assert.equal((capturedVars.import as any).coverage.status, "complete");
  assert.equal(capturedVars.hasSnapshot, true);
  assert.equal(result.statementImport.importedAt, "2026-07-29T12:00:00.000Z");
  assert.equal(
    result.snapshotId,
    "accountBalanceSnapshot:2026-07-31-abc123-closing",
  );

  const optionalFields = draft();
  await repository.commitStatementImport({
    ...optionalFields,
    statementImport: {
      ...optionalFields.statementImport,
      extractionAssistRef: null,
      extractionInputSha256: null,
      openingBalanceMinor: null,
      closingBalanceMinor: null,
      closingBalanceEconomicNature: null,
    },
    rows: optionalFields.rows.map((row) => ({
      ...row,
      transactionDate: null,
      postingDate: null,
      valueDate: null,
      sourceReference: null,
      reportedBalanceMinor: null,
      locator: null,
    })),
    components: optionalFields.components.map((component) => ({
      ...component,
      transactionDate: null,
      postingDate: null,
      valueDate: null,
      sourceReference: null,
      locator: null,
    })),
    snapshot: null,
  });
  assert.equal(capturedVars.hasSnapshot, false);
  assert.equal((capturedVars.import as any).hasExtractionAssist, false);
  assert.equal((capturedVars.import as any).hasOpeningBalance, false);
  assert.equal((capturedVars.import as any).hasClosingBalance, false);
  assert.equal((capturedVars.rows as any[])[0].hasPostingDate, false);
  assert.equal((capturedVars.rows as any[])[0].hasReportedBalance, false);
  assert.equal((capturedVars.components as any[])[0].hasLocator, false);
});

test("statement replay reads Surreal 3 angle-quoted record references", async () => {
  const importKey =
    "account:financialSpace:fictional-space|fictional-account|2026-07-31-abc123";
  const repository = createSurrealStatementTruthRepository({
    async query(query) {
      if (query.includes("FROM financialOperation")) {
        return [
          [
            {
              id: "financialOperation:statement-operation",
              key: "statement-operation",
              command: "commit_statement_import",
              idempotencyKey: "fictional-operation-001",
              requestHash: "1".repeat(64),
              channel: "system",
              status: "applied",
              resultRefs: [`statementImport:⟨${importKey}⟩`],
              warningCodes: [],
              auditMeta: {},
              recordedAt: "2026-07-29T12:00:00.000Z",
              completedAt: "2026-07-29T12:00:00.000Z",
            },
          ],
        ];
      }
      if (query.includes('type::record("statementImport"')) {
        return [
          [
            {
              id: `statementImport:⟨${importKey}⟩`,
              space: "financialSpace:fictional-space",
              account:
                "account:⟨financialSpace:fictional-space|fictional-account⟩",
              key: "2026-07-31-abc123",
              sourceFormat: "pdf",
              sourceState: "committed",
              profileId: "fnb-business",
              profileVersion: "1",
              extractorVersion: "statement-neutral-v0.3",
              validationRulesetVersion: "statement-validation-v0.3",
              currency: "ZAR",
              periodStart: "2026-07-01",
              periodEnd: "2026-07-31",
            },
          ],
        ];
      }
      return [];
    },
  });

  const operation = await repository.getCommitOperation(
    "fictional-operation-001",
  );
  assert.equal(operation?.resultRefs[0], `statementImport:${importKey}`);
  const statementImport = await repository.getStatementImport(
    operation!.resultRefs[0]!,
  );
  assert.equal(statementImport?.id, `statementImport:${importKey}`);
});

test("failed statement transaction is surfaced and never converted into a partial success", async () => {
  const repository = createSurrealStatementTruthRepository({
    async query() {
      throw new Error("simulated row write failure");
    },
  });
  await assert.rejects(
    repository.commitStatementImport(draft()),
    /simulated row write failure/,
  );
});

test("claim conflicts preserve distinct duplicate-source and immutable-period errors", async () => {
  const sourceConflict = createSurrealStatementTruthRepository({
    async query() {
      throw new Error("Database error: statementSourceClaim already exists");
    },
  });
  await assert.rejects(
    sourceConflict.commitStatementImport(draft()),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_DUPLICATE_SOURCE",
  );

  const periodConflict = createSurrealStatementTruthRepository({
    async query() {
      throw new Error("Database error: statementPeriodClaim already exists");
    },
  });
  await assert.rejects(
    periodConflict.commitStatementImport(draft()),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_IMMUTABLE_CONFLICT",
  );

  for (const code of [
    "STATEMENT_LEGACY_PERIOD_CONFLICT",
    "STATEMENT_LEGACY_COMPATIBILITY_REQUIRED",
    "STATEMENT_PREVIEW_STALE",
  ] as const) {
    const repository = createSurrealStatementTruthRepository({
      async query() {
        throw new Error(code);
      },
    });
    await assert.rejects(
      repository.commitStatementImport(draft()),
      (error: unknown) =>
        error instanceof RavenDomainError && error.code === code,
    );
  }
});

test("retryable transaction conflicts are retried into a stable claim result", async () => {
  let attempts = 0;
  const repository = createSurrealStatementTruthRepository({
    async query() {
      attempts += 1;
      if (attempts === 1) {
        throw new Error(
          "Transaction conflict: Write conflict, retry the transaction",
        );
      }
      throw new Error("STATEMENT_IMMUTABLE_CONFLICT");
    },
  });

  await assert.rejects(
    repository.commitStatementImport(draft()),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_IMMUTABLE_CONFLICT",
  );
  assert.equal(attempts, 2);
});

test("a generic failed transaction resolves against deterministic claim state", async () => {
  let queries = 0;
  const repository = createSurrealStatementTruthRepository({
    async query(query) {
      queries += 1;
      if (query.includes("BEGIN TRANSACTION")) {
        throw new Error(
          "The query was not executed due to a failed transaction",
        );
      }
      return [
        null,
        null,
        {
          sourceClaimExists: false,
          periodClaimExists: true,
        },
      ];
    },
  });

  await assert.rejects(
    repository.commitStatementImport(draft()),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_IMMUTABLE_CONFLICT",
  );
  assert.equal(queries, 2);
});

test("legacy imports preserve their actual persisted profile and source semantics", async () => {
  const repository = createSurrealStatementTruthRepository({
    async query() {
      return [
        {
          status: "OK",
          result: [
            {
              id: "statementImport:legacy",
              space: "financialSpace:fictional-space",
              account: "account:fictional-account",
              spaceKey: "fictional-space",
              accountKey: "fictional-account",
              key: "2025-07-18-fictional-account",
              statementDate: "2025-07-18T00:00:00Z",
              sourceFormat: "manual",
              sourceState: "legacy",
              profileId: "historical-csv",
              profileVersion: "0.7",
              extractorVersion: "legacy-parser-v3",
              validationRulesetVersion: "historical-rules-v2",
              currency: "USD",
              importedAt: "2024-01-01T00:00:00.000Z",
            },
          ],
        },
      ];
    },
  });
  const [legacy] = await repository.listStatementImports({
    spaceKey: "fictional-space",
    accountKey: "fictional-account",
  });
  assert.equal(legacy?.sourceState, "legacy");
  assert.equal(legacy?.sourceKind, "manual");
  assert.deepEqual(legacy?.profile, {
    profileId: "historical-csv",
    profileVersion: "0.7",
    extractorVersion: "legacy-parser-v3",
  });
  assert.equal(legacy?.validationRulesetVersion, "historical-rules-v2");
  assert.equal(legacy?.currency, "USD");
  assert.equal(legacy?.balanceConvention, null);
  assert.equal(legacy?.commitOperationId, null);
  assert.deepEqual(legacy?.legacyPeriodEvidence, {
    statementDate: "2025-07-18",
    keyDate: "2025-07-18",
    mapping: "known_renderer_end_date",
  });
});

test("unmappable active legacy imports expose compatibility-required evidence only", async () => {
  const repository = createSurrealStatementTruthRepository({
    async query() {
      return [
        {
          status: "OK",
          result: [
            {
              id: "statementImport:legacy-unmappable",
              space: "financialSpace:fictional-space",
              account: "account:fictional-account",
              spaceKey: "fictional-space",
              accountKey: "fictional-account",
              key: "legacy-without-date",
              sourceFormat: "manual",
              sourceState: "legacy",
            },
          ],
        },
      ];
    },
  });
  const [legacy] = await repository.listStatementImports({
    spaceKey: "fictional-space",
    accountKey: "fictional-account",
  });
  assert.deepEqual(legacy?.legacyPeriodEvidence, {
    statementDate: null,
    keyDate: null,
    mapping: "unmappable",
  });
});
