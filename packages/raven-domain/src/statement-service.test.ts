import assert from "node:assert/strict";
import { chmod, mkdir, rm, symlink, writeFile } from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import test from "node:test";
import {
  createDefaultStatementAdapterRegistry,
  createLocalStatementSourceVault,
  createStatementTruthService,
  RavenDomainError,
  type StatementCommitDraft,
  type StatementCommitOperation,
  type StatementImportReadFilter,
  type StatementImportRecord,
  type StatementIssueRecord,
  type StatementRowComponentRecord,
  type StatementRowRecord,
  type StatementTruthRepository,
  type BalanceSnapshotDraft,
} from "./index.js";

const ORIGINAL = new Uint8Array(
  Buffer.from("%PDF-1.4\nFictional statement evidence\n"),
);

function extractionInput(overrides: Record<string, unknown> = {}) {
  return {
    contractVersion: "statement-extraction-input-v0.1",
    profileHint: "fnb-business",
    sourceKind: "pdf",
    currency: "ZAR",
    periodStart: "2026-07-01",
    periodEnd: "2026-07-31",
    balanceConvention: "positive_is_asset",
    openingBalanceMinor: 10_000,
    closingBalanceMinor: 14_000,
    accountHints: {
      maskedAccount: "•••• 4242",
      sourceAccountType: "business current",
    },
    coverage: {
      status: "complete",
      sourcePageCount: 1,
      processedPages: [1],
      sourceSections: ["transactions"],
      processedSections: ["transactions"],
      printedRowCount: 2,
    },
    rows: [
      {
        rowKey: "row-01",
        rowNumber: 1,
        rowKind: "movement",
        transactionDate: "2026-07-03",
        postingDate: "2026-07-04",
        valueDate: "2026-07-05",
        rawText: "Fictional incoming movement",
        sourceReference: "FIC-001",
        reportedBalanceMinor: 15_000,
        confidence: 1,
        components: [
          {
            componentKey: "principal",
            componentKind: "principal",
            componentRole: "movement",
            transactionDate: "2026-07-03",
            postingDate: "2026-07-04",
            valueDate: "2026-07-05",
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
        postingDate: "2026-07-08",
        rawText: "Fictional fee with printed VAT breakdown",
        reportedBalanceMinor: 14_000,
        confidence: 1,
        components: [
          {
            componentKey: "fee",
            componentKind: "bank_fee",
            componentRole: "movement",
            postingDate: "2026-07-08",
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
            postingDate: "2026-07-08",
            description: "Printed VAT included in fee",
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
    ...overrides,
  };
}

function assistBytes(overrides: Record<string, unknown> = {}) {
  return new Uint8Array(
    Buffer.from(JSON.stringify(extractionInput(overrides))),
  );
}

class MemoryStatementRepository implements StatementTruthRepository {
  readonly accounts = [
    {
      id: "account:fictional-space|fictional-business",
      spaceId: "financialSpace:fictional-space",
      spaceKey: "fictional-space",
      key: "fictional-business",
      currency: "ZAR",
      normalNature: "asset" as const,
      accountNumberLast4: "4242",
      spaceTimezone: "Africa/Johannesburg",
    },
  ];
  readonly imports: StatementImportRecord[] = [];
  readonly rows: StatementRowRecord[] = [];
  readonly components: StatementRowComponentRecord[] = [];
  readonly issues: StatementIssueRecord[] = [];
  readonly operations: StatementCommitOperation[] = [];
  commitCount = 0;
  snapshotIds: string[] = [];
  snapshotDrafts: BalanceSnapshotDraft[] = [];

  async getAccount(spaceKey: string, accountKey: string) {
    return (
      this.accounts.find(
        (account) =>
          account.spaceKey === spaceKey && account.key === accountKey,
      ) ?? null
    );
  }

  async getCommitOperation(idempotencyKey: string) {
    return (
      this.operations.find(
        (operation) => operation.idempotencyKey === idempotencyKey,
      ) ?? null
    );
  }

  async listStatementImports(filter: StatementImportReadFilter) {
    return this.imports.filter(
      (item) =>
        item.spaceKey === filter.spaceKey &&
        item.accountKey === filter.accountKey &&
        (!filter.periodStart || item.periodStart === filter.periodStart) &&
        (!filter.periodEnd || item.periodEnd === filter.periodEnd),
    );
  }

  async getStatementImport(id: string) {
    return this.imports.find((item) => item.id === id) ?? null;
  }

  async listStatementRows(statementImportId: string) {
    return this.rows.filter(
      (item) => item.statementImportId === statementImportId,
    );
  }

  async getStatementRow(id: string) {
    return this.rows.find((item) => item.id === id) ?? null;
  }

  async listStatementRowComponents(filter: {
    statementImportId?: string;
    statementRowId?: string;
  }) {
    return this.components.filter(
      (item) =>
        (!filter.statementImportId ||
          item.statementImportId === filter.statementImportId) &&
        (!filter.statementRowId ||
          item.statementRowId === filter.statementRowId),
    );
  }

  async getStatementRowComponent(id: string) {
    return this.components.find((item) => item.id === id) ?? null;
  }

  async listStatementIssues(statementImportId: string) {
    return this.issues.filter(
      (item) => item.statementImportId === statementImportId,
    );
  }

  async getStatementIssue(id: string) {
    return this.issues.find((item) => item.id === id) ?? null;
  }

  async commitStatementImport(draft: StatementCommitDraft) {
    this.commitCount += 1;
    const importId = `statementImport:${draft.statementImport.accountId}|${draft.statementImport.key}`;
    const operationId = `financialOperation:${draft.operation.key}`;
    const statementImport: StatementImportRecord = {
      ...draft.statementImport,
      id: importId,
      legacyPeriodEvidence: {
        statementDate: draft.statementImport.periodEnd,
        keyDate: draft.statementImport.periodEnd,
        mapping: "not_legacy",
      },
    };
    const operation: StatementCommitOperation = {
      id: operationId,
      key: draft.operation.key,
      command: "commit_statement_import",
      idempotencyKey: draft.operation.idempotencyKey,
      requestHash: draft.operation.requestHash,
      channel: draft.operation.channel,
      actorId: draft.operation.actorId ?? null,
      status: "applied",
      resultRefs: [
        importId,
        ...(draft.snapshot
          ? [`accountBalanceSnapshot:${draft.snapshot.key}`]
          : []),
      ],
      warningCodes: draft.operation.warningCodes ?? [],
      auditMeta: draft.operation.auditMeta ?? {},
      recordedAt: draft.operation.recordedAt,
      completedAt: draft.operation.recordedAt,
      failureCode: null,
    };
    this.imports.push(statementImport);
    this.operations.push(operation);
    for (const row of draft.rows) {
      this.rows.push({
        ...row,
        id: `statementRow:${importId}|${row.key}`,
        spaceId: statementImport.spaceId,
        accountId: statementImport.accountId,
        statementImportId: importId,
        commitOperationId: operationId,
      });
    }
    for (const component of draft.components) {
      const row = this.rows.find(
        (item) =>
          item.statementImportId === importId &&
          item.rowKey === component.rowKey,
      )!;
      this.components.push({
        ...component,
        id: `statementRowComponent:${row.id}|${component.componentKey}`,
        spaceId: statementImport.spaceId,
        accountId: statementImport.accountId,
        statementImportId: importId,
        statementRowId: row.id,
        commitOperationId: operationId,
        sourceState: "committed",
        issues: [],
      });
    }
    for (const item of draft.issues) {
      const { rowKey, componentKey, ...issue } = item;
      const row = this.rows.find(
        (candidate) =>
          candidate.statementImportId === importId &&
          candidate.rowKey === rowKey,
      );
      this.issues.push({
        ...issue,
        ...(rowKey ? { rowKey } : {}),
        ...(componentKey ? { componentKey } : {}),
        id: `statementIssue:${importId}|${item.key}`,
        spaceId: statementImport.spaceId,
        accountId: statementImport.accountId,
        statementImportId: importId,
        statementRowId: row?.id ?? null,
        statementRowComponentId: null,
        state: "open",
        revision: 1,
        detectedOperationId: operationId,
        dispositionOperationId: null,
        acknowledgedAt: null,
        resolvedAt: null,
        reviewedBy: null,
        notes: null,
      });
    }
    if (draft.snapshot) {
      this.snapshotIds.push(`accountBalanceSnapshot:${draft.snapshot.key}`);
      this.snapshotDrafts.push(draft.snapshot);
    }
    return {
      statementImport,
      operation,
      snapshotId: draft.snapshot
        ? `accountBalanceSnapshot:${draft.snapshot.key}`
        : null,
    };
  }
}

async function fixture(options: { maxSourceBytes?: number } = {}) {
  const actualRoot = path.join(
    os.tmpdir(),
    `raven-statement-${crypto.randomUUID()}`,
  );
  await mkdir(actualRoot, { recursive: true });
  const inbox = path.join(actualRoot, "inbox");
  const vaultRoot = path.join(actualRoot, "vault");
  await mkdir(inbox, { recursive: true, mode: 0o700 });
  const repository = new MemoryStatementRepository();
  const vault = createLocalStatementSourceVault({
    vaultRoot,
    allowedInboxRoots: [inbox],
    maxSourceBytes: options.maxSourceBytes,
  });
  const service = createStatementTruthService({
    repository,
    vault,
    adapters: createDefaultStatementAdapterRegistry(),
    clock: () => "2026-07-29T12:00:00.000Z",
  });
  return {
    root: actualRoot,
    inbox,
    vaultRoot,
    repository,
    vault,
    service,
    cleanup: async () => {
      await rm(actualRoot, { recursive: true, force: true });
    },
  };
}

async function stageValid(
  service: ReturnType<typeof createStatementTruthService>,
  overrides: Record<string, unknown> = {},
) {
  return service.stageStatementSource({
    transport: "upload",
    originalBytes: ORIGINAL,
    mimeType: "application/pdf",
    sourceKind: "pdf",
    extractionAssistBytes: assistBytes(overrides),
    extractionAssistMimeType: "application/json",
  });
}

function selection(sourceRef: string) {
  return {
    sourceRef,
    spaceKey: "fictional-space",
    accountKey: "fictional-business",
    profileId: "fnb-business" as const,
    profileVersion: "1" as const,
  };
}

test("separate evidence, assist and canonical hashes drive preview identity", async () => {
  const context = await fixture();
  try {
    const first = await stageValid(context.service);
    const changedEvidence = await context.service.stageStatementSource({
      transport: "upload",
      originalBytes: new Uint8Array(
        Buffer.from("%PDF-1.4\nDifferent fictional evidence\n"),
      ),
      mimeType: "application/pdf",
      sourceKind: "pdf",
      extractionAssistBytes: assistBytes(),
      extractionAssistMimeType: "application/json",
    });
    const changedAssist = await stageValid(context.service, {
      periodEnd: "2026-08-01",
    });
    const [firstPreview, evidencePreview, assistPreview] = await Promise.all([
      context.service.previewStatementImport(selection(first.sourceRef)),
      context.service.previewStatementImport(
        selection(changedEvidence.sourceRef),
      ),
      context.service.previewStatementImport(
        selection(changedAssist.sourceRef),
      ),
    ]);
    assert.notEqual(
      first.originalFileSha256,
      changedEvidence.originalFileSha256,
    );
    assert.equal(
      first.extractionInputSha256,
      changedEvidence.extractionInputSha256,
    );
    assert.notEqual(
      first.extractionInputSha256,
      changedAssist.extractionInputSha256,
    );
    assert.notEqual(firstPreview.previewHash, evidencePreview.previewHash);
    assert.notEqual(firstPreview.previewHash, assistPreview.previewHash);
    assert.notEqual(
      firstPreview.extraction.canonicalExtractionSha256,
      assistPreview.extraction.canonicalExtractionSha256,
    );
  } finally {
    await context.cleanup();
  }
});

test("component roles prevent informational VAT double counting and preserve printed dates", async () => {
  const context = await fixture();
  try {
    const staged = await stageValid(context.service);
    const preview = await context.service.previewStatementImport(
      selection(staged.sourceRef),
    );
    assert.equal(preview.commitAllowed, true);
    assert.equal(preview.inflowMinor, 5_000);
    assert.equal(preview.outflowMinor, 1_000);
    assert.equal(preview.expectedClosingBalanceMinor, 14_000);
    assert.equal(preview.differenceMinor, 0);
    const first = preview.extraction.rows[0]!;
    assert.equal(first.transactionDate, "2026-07-03");
    assert.equal(first.postingDate, "2026-07-04");
    assert.equal(first.valueDate, "2026-07-05");
    const vat = preview.extraction.rows[1]!.components[1]!;
    assert.equal(vat.componentRole, "informational_breakdown");
    assert.equal(vat.balanceEffectMinor, 0);
  } finally {
    await context.cleanup();
  }
});

test("invalid component role/effect combinations fail closed", async () => {
  const context = await fixture();
  try {
    const input = extractionInput();
    (input.rows[0]!.components[0] as any).balanceEffectMinor = 0;
    const staged = await context.service.stageStatementSource({
      transport: "upload",
      originalBytes: ORIGINAL,
      mimeType: "application/pdf",
      sourceKind: "pdf",
      extractionAssistBytes: new Uint8Array(Buffer.from(JSON.stringify(input))),
      extractionAssistMimeType: "application/json",
    });
    await assert.rejects(
      context.service.previewStatementImport(selection(staged.sourceRef)),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_EXTRACTION_INVALID",
    );
  } finally {
    await context.cleanup();
  }
});

test("strict extraction rejects unknown fields, invalid calendar dates, duplicate identities, and missing arrays", async () => {
  const cases = [
    { unknownMeaningField: true },
    { periodEnd: "2026-02-30" },
    { rows: undefined },
    {
      rows: [
        extractionInput().rows[0],
        { ...extractionInput().rows[1], rowKey: "row-01" },
      ],
    },
  ];
  for (const invalid of cases) {
    const context = await fixture();
    try {
      const staged = await stageValid(context.service, invalid);
      await assert.rejects(
        context.service.previewStatementImport(selection(staged.sourceRef)),
        (error: unknown) =>
          error instanceof RavenDomainError &&
          (error.code === "STATEMENT_EXTRACTION_INVALID" ||
            error.code === "STATEMENT_PERIOD_INVALID"),
      );
    } finally {
      await context.cleanup();
    }
  }
});

test("coverage, movement dates, flow coherence, running balances, and safe integer totals fail closed", async () => {
  const invalidInputs = [
    {
      coverage: {
        status: "incomplete",
        sourcePageCount: 2,
        processedPages: [1],
        sourceSections: ["transactions"],
        processedSections: ["transactions"],
        printedRowCount: 2,
      },
      expectedPreviewBlocker: "STATEMENT_PARTIAL_PERIOD",
    },
    {
      mutate(input: ReturnType<typeof extractionInput>) {
        const row = input.rows[0]! as unknown as {
          transactionDate?: string;
          postingDate?: string;
          valueDate?: string;
          components: Array<{
            transactionDate?: string;
            postingDate?: string;
            valueDate?: string;
          }>;
        };
        delete row.transactionDate;
        delete row.postingDate;
        delete row.valueDate;
        delete row.components[0]!.transactionDate;
        delete row.components[0]!.postingDate;
        delete row.components[0]!.valueDate;
      },
    },
    {
      mutate(input: ReturnType<typeof extractionInput>) {
        input.rows[0]!.components[0]!.sourceFlow = "outflow";
      },
    },
    {
      mutate(input: ReturnType<typeof extractionInput>) {
        input.rows[0]!.reportedBalanceMinor = 14_999;
      },
      expectedPreviewBlocker: "STATEMENT_BALANCE_DIFFERENCE",
    },
    {
      openingBalanceMinor: Number.MAX_SAFE_INTEGER,
      closingBalanceMinor: Number.MAX_SAFE_INTEGER,
    },
  ];
  for (const invalid of invalidInputs) {
    const context = await fixture();
    try {
      const { mutate, expectedPreviewBlocker, ...overrides } = invalid as {
        mutate?: (input: ReturnType<typeof extractionInput>) => void;
        expectedPreviewBlocker?: string;
        [key: string]: unknown;
      };
      const input = extractionInput(overrides);
      mutate?.(input);
      const staged = await context.service.stageStatementSource({
        transport: "upload",
        originalBytes: ORIGINAL,
        mimeType: "application/pdf",
        sourceKind: "pdf",
        extractionAssistBytes: new Uint8Array(
          Buffer.from(JSON.stringify(input)),
        ),
        extractionAssistMimeType: "application/json",
      });
      if (expectedPreviewBlocker) {
        const preview = await context.service.previewStatementImport(
          selection(staged.sourceRef),
        );
        assert.equal(preview.commitAllowed, false);
        assert.ok(
          preview.issues.some(
            (item) => item.blocking && item.code === expectedPreviewBlocker,
          ),
        );
      } else {
        await assert.rejects(
          context.service.previewStatementImport(selection(staged.sourceRef)),
          (error: unknown) =>
            error instanceof RavenDomainError &&
            error.code === "STATEMENT_EXTRACTION_INVALID",
        );
      }
    } finally {
      await context.cleanup();
    }
  }
});

test("zero-row statements require explicit complete coverage and exact zero activity", async () => {
  const context = await fixture();
  try {
    const staged = await stageValid(context.service, {
      rows: [],
      openingBalanceMinor: 10_000,
      closingBalanceMinor: 10_000,
      coverage: {
        status: "complete",
        sourcePageCount: 1,
        processedPages: [1],
        sourceSections: ["transactions"],
        processedSections: ["transactions"],
        printedRowCount: 0,
      },
    });
    const preview = await context.service.previewStatementImport(
      selection(staged.sourceRef),
    );
    assert.equal(preview.rowCount, 0);
    assert.equal(preview.commitAllowed, true);
  } finally {
    await context.cleanup();
  }
});

test("blocking preview issues produce no financial commit", async () => {
  const context = await fixture();
  try {
    const staged = await stageValid(context.service, {
      closingBalanceMinor: 99_999,
    });
    const preview = await context.service.previewStatementImport(
      selection(staged.sourceRef),
    );
    assert.equal(preview.commitAllowed, false);
    assert.equal(context.repository.commitCount, 0);
    await assert.rejects(
      context.service.commitStatementImport({
        ...selection(staged.sourceRef),
        previewHash: preview.previewHash,
        idempotencyKey: "fictional-blocked-001",
        channel: "ui",
      }),
    );
    assert.equal(context.repository.commitCount, 0);
    assert.equal(context.repository.operations.length, 0);
  } finally {
    await context.cleanup();
  }
});

test("stale preview and changed profile selection fail before commit", async () => {
  const context = await fixture();
  try {
    const staged = await stageValid(context.service);
    const selected = selection(staged.sourceRef);
    const preview = await context.service.previewStatementImport(selected);
    await assert.rejects(
      context.service.validateStatementPreview({
        ...selected,
        previewHash: "0".repeat(64),
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_PREVIEW_STALE",
    );
    await assert.rejects(
      context.service.commitStatementImport({
        ...selected,
        profileId: "normalized-json-v1",
        previewHash: preview.previewHash,
        idempotencyKey: "fictional-stale-profile-001",
        channel: "system",
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_PREVIEW_STALE",
    );
    await assert.rejects(
      context.service.previewStatementImport({
        ...selected,
        profileVersion: "2",
      } as any),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_PROFILE_UNSUPPORTED",
    );
    assert.equal(context.repository.commitCount, 0);
  } finally {
    await context.cleanup();
  }
});

test("preview, detection and validation are write-free; commit replay is exact", async () => {
  const context = await fixture();
  try {
    const staged = await stageValid(context.service);
    const detection = await context.service.detectStatementProfile({
      sourceRef: staged.sourceRef,
    });
    assert.deepEqual(
      detection.candidates.map((candidate) => candidate.profile.profileId),
      ["fnb-business", "normalized-json-v1"],
    );
    const preview = await context.service.previewStatementImport(
      selection(staged.sourceRef),
    );
    await context.service.validateStatementPreview({
      ...selection(staged.sourceRef),
      previewHash: preview.previewHash,
    });
    assert.equal(context.repository.commitCount, 0);
    const input = {
      ...selection(staged.sourceRef),
      previewHash: preview.previewHash,
      idempotencyKey: "fictional-commit-001",
      channel: "ui" as const,
    };
    const first = await context.service.commitStatementImport(input);
    await rm(context.vaultRoot, { recursive: true, force: true });
    const replay = await context.service.commitStatementImport(input);
    assert.equal(context.repository.commitCount, 1);
    assert.equal(
      first.statementImport.importedAt,
      replay.statementImport.importedAt,
    );
    assert.equal(first.statementImport.id, replay.statementImport.id);
    assert.equal(first.snapshotId, replay.snapshotId);
    assert.equal(replay.receipt.status, "replayed");
    assert.equal(context.repository.components.length, 3);
    assert.equal(context.repository.snapshotIds.length, 1);
    await assert.rejects(
      context.service.commitStatementImport({
        ...input,
        actorId: "different-operator",
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "IDEMPOTENCY_CONFLICT",
    );
    assert.equal(context.repository.commitCount, 1);
  } finally {
    await context.cleanup();
  }
});

test("composite movement rows and informational source rows preserve role boundaries", async () => {
  const context = await fixture();
  try {
    const input = extractionInput();
    input.rows[0]!.components.push({
      componentKey: "bank-fee",
      componentKind: "bank_fee",
      componentRole: "movement",
      transactionDate: "2026-07-03",
      postingDate: "2026-07-04",
      valueDate: "2026-07-05",
      description: "Fictional fee printed with principal",
      amountMinor: 100,
      currency: "ZAR",
      sourceDirection: "debit",
      sourceFlow: "outflow",
      balanceEffectMinor: -100,
      confidence: 1,
    });
    input.rows[0]!.reportedBalanceMinor = 14_900;
    input.rows[1]!.reportedBalanceMinor = 13_900;
    input.rows.push({
      rowKey: "row-03",
      rowNumber: 3,
      rowKind: "informational",
      postingDate: "2026-07-09",
      rawText: "Fictional informational source note",
      reportedBalanceMinor: 13_900,
      confidence: 0.85,
      components: [],
    });
    input.coverage.printedRowCount = 3;
    input.closingBalanceMinor = 13_900;
    const staged = await context.service.stageStatementSource({
      transport: "upload",
      originalBytes: ORIGINAL,
      mimeType: "application/pdf",
      sourceKind: "pdf",
      extractionAssistBytes: new Uint8Array(Buffer.from(JSON.stringify(input))),
      extractionAssistMimeType: "application/json",
    });
    const preview = await context.service.previewStatementImport(
      selection(staged.sourceRef),
    );
    assert.equal(preview.commitAllowed, true);
    assert.equal(preview.inflowMinor, 5_000);
    assert.equal(preview.outflowMinor, 1_100);
    assert.equal(preview.informationalRowCount, 1);
    assert.equal(preview.extraction.rows[0]!.components.length, 2);
    assert.equal(preview.extraction.rows[2]!.components.length, 0);
    assert.ok(
      preview.issues.some(
        (issue) =>
          issue.code === "STATEMENT_ROW_LOW_CONFIDENCE" &&
          issue.severity === "warning" &&
          !issue.blocking,
      ),
    );
    assert.equal(context.repository.commitCount, 0);
  } finally {
    await context.cleanup();
  }
});

test("duplicate bytes are blocked across periods and changed bytes cannot replace a committed period", async () => {
  const context = await fixture();
  try {
    const first = await stageValid(context.service);
    const firstPreview = await context.service.previewStatementImport(
      selection(first.sourceRef),
    );
    await context.service.commitStatementImport({
      ...selection(first.sourceRef),
      previewHash: firstPreview.previewHash,
      idempotencyKey: "fictional-source-identity-001",
      channel: "system",
    });

    const exactDuplicate = await stageValid(context.service);
    const duplicatePreview = await context.service.previewStatementImport(
      selection(exactDuplicate.sourceRef),
    );
    assert.equal(duplicatePreview.commitAllowed, false);
    assert.ok(
      duplicatePreview.issues.some(
        (issue) =>
          issue.code === "STATEMENT_DUPLICATE_SOURCE" && issue.blocking,
      ),
    );
    await assert.rejects(
      context.service.commitStatementImport({
        ...selection(exactDuplicate.sourceRef),
        previewHash: duplicatePreview.previewHash,
        idempotencyKey: "fictional-source-identity-duplicate",
        channel: "system",
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_DUPLICATE_SOURCE",
    );

    const differentPeriod = await stageValid(context.service, {
      periodStart: "2026-08-01",
      periodEnd: "2026-08-31",
    });
    const differentPeriodPreview = await context.service.previewStatementImport(
      selection(differentPeriod.sourceRef),
    );
    assert.ok(
      differentPeriodPreview.issues.some(
        (issue) =>
          issue.code === "STATEMENT_DUPLICATE_SOURCE" && issue.blocking,
      ),
    );

    const changedSource = await context.service.stageStatementSource({
      transport: "upload",
      originalBytes: new Uint8Array(
        Buffer.from("%PDF-1.4\nChanged fictional statement evidence\n"),
      ),
      mimeType: "application/pdf",
      sourceKind: "pdf",
      extractionAssistBytes: assistBytes(),
      extractionAssistMimeType: "application/json",
    });
    const changedPreview = await context.service.previewStatementImport(
      selection(changedSource.sourceRef),
    );
    assert.ok(
      changedPreview.issues.some(
        (issue) =>
          issue.code === "STATEMENT_IMMUTABLE_CONFLICT" && issue.blocking,
      ),
    );
    assert.equal(context.repository.commitCount, 1);
  } finally {
    await context.cleanup();
  }
});

test("legacy periods remain visibly unverified and block a new ST-01 preview", async () => {
  const context = await fixture();
  try {
    const first = await stageValid(context.service);
    const firstPreview = await context.service.previewStatementImport(
      selection(first.sourceRef),
    );
    await context.service.commitStatementImport({
      ...selection(first.sourceRef),
      previewHash: firstPreview.previewHash,
      idempotencyKey: "fictional-legacy-seed-001",
      channel: "system",
    });
    (context.repository.imports[0] as { sourceState: string }).sourceState =
      "legacy";
    const changed = await context.service.stageStatementSource({
      transport: "upload",
      originalBytes: new Uint8Array(
        Buffer.from("%PDF-1.4\nChanged fictional legacy-period evidence\n"),
      ),
      mimeType: "application/pdf",
      sourceKind: "pdf",
      extractionAssistBytes: assistBytes(),
      extractionAssistMimeType: "application/json",
    });
    const preview = await context.service.previewStatementImport(
      selection(changed.sourceRef),
    );
    assert.equal(preview.commitAllowed, false);
    assert.ok(
      preview.issues.some(
        (item) =>
          item.code === "STATEMENT_LEGACY_PERIOD_CONFLICT" && item.blocking,
      ),
    );
  } finally {
    await context.cleanup();
  }
});

test("account, currency and confidence blockers remain preview-only", async () => {
  const accountMismatch = await fixture();
  try {
    const staged = await stageValid(accountMismatch.service, {
      accountHints: {
        maskedAccount: "•••• 9999",
        sourceAccountType: "business current",
      },
    });
    const preview = await accountMismatch.service.previewStatementImport(
      selection(staged.sourceRef),
    );
    assert.ok(
      preview.issues.some(
        (issue) =>
          issue.code === "STATEMENT_ACCOUNT_MISMATCH" && issue.blocking,
      ),
    );
    assert.equal(accountMismatch.repository.commitCount, 0);
  } finally {
    await accountMismatch.cleanup();
  }

  const currencyMismatch = await fixture();
  try {
    (currencyMismatch.repository.accounts[0] as { currency: string }).currency =
      "USD";
    const staged = await stageValid(currencyMismatch.service);
    const preview = await currencyMismatch.service.previewStatementImport(
      selection(staged.sourceRef),
    );
    assert.ok(
      preview.issues.some(
        (issue) =>
          issue.code === "STATEMENT_CURRENCY_MISMATCH" && issue.blocking,
      ),
    );
    assert.equal(currencyMismatch.repository.commitCount, 0);
  } finally {
    await currencyMismatch.cleanup();
  }

  const lowConfidence = await fixture();
  try {
    const input = extractionInput();
    input.rows[0]!.confidence = 0.7;
    input.rows[0]!.components[0]!.confidence = 0.7;
    const staged = await lowConfidence.service.stageStatementSource({
      transport: "upload",
      originalBytes: ORIGINAL,
      mimeType: "application/pdf",
      sourceKind: "pdf",
      extractionAssistBytes: new Uint8Array(Buffer.from(JSON.stringify(input))),
      extractionAssistMimeType: "application/json",
    });
    const preview = await lowConfidence.service.previewStatementImport(
      selection(staged.sourceRef),
    );
    assert.ok(
      preview.issues.some(
        (issue) =>
          issue.code === "STATEMENT_ROW_LOW_CONFIDENCE" && issue.blocking,
      ),
    );
    assert.ok(
      preview.issues.some(
        (issue) =>
          issue.code === "STATEMENT_COMPONENT_UNRESOLVED" && issue.blocking,
      ),
    );
    assert.equal(lowConfidence.repository.commitCount, 0);
  } finally {
    await lowConfidence.cleanup();
  }
});

test("malformed assistance, missing assistance and unsupported source currency fail closed", async () => {
  const context = await fixture();
  try {
    await assert.rejects(
      context.service.stageStatementSource({
        transport: "upload",
        originalBytes: ORIGINAL,
        mimeType: "application/pdf",
        sourceKind: "pdf",
        extractionAssistBytes: new Uint8Array(Buffer.from("{not-json")),
        extractionAssistMimeType: "application/json",
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_EXTRACTION_INVALID",
    );

    const missing = await context.service.stageStatementSource({
      transport: "upload",
      originalBytes: ORIGINAL,
      mimeType: "application/pdf",
      sourceKind: "pdf",
    });
    await assert.rejects(
      context.service.previewStatementImport(selection(missing.sourceRef)),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_PROFILE_UNSUPPORTED",
    );

    const unsupportedCurrency = await stageValid(context.service, {
      currency: "USD",
    });
    await assert.rejects(
      context.service.previewStatementImport(
        selection(unsupportedCurrency.sourceRef),
      ),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "UNSUPPORTED_CURRENCY",
    );
    assert.equal(context.repository.commitCount, 0);
  } finally {
    await context.cleanup();
  }
});

test("closing balance convention maps exact economic nature or omits snapshot", async () => {
  const liability = await fixture();
  try {
    (
      liability.repository.accounts[0] as {
        normalNature: "asset" | "liability";
      }
    ).normalNature = "liability";
    const input = extractionInput({
      profileHint: "nedbank-credit",
      balanceConvention: "positive_is_liability",
      openingBalanceMinor: 5_000,
      closingBalanceMinor: 9_000,
    });
    input.rows[0]!.reportedBalanceMinor = 10_000;
    input.rows[0]!.components[0]!.sourceDirection = "debit";
    input.rows[0]!.components[0]!.sourceFlow = "outflow";
    input.rows[1]!.reportedBalanceMinor = 9_000;
    input.rows[1]!.components[0]!.sourceDirection = "credit";
    input.rows[1]!.components[0]!.sourceFlow = "inflow";
    const staged = await liability.service.stageStatementSource({
      transport: "upload",
      originalBytes: ORIGINAL,
      mimeType: "application/pdf",
      sourceKind: "pdf",
      extractionAssistBytes: new Uint8Array(Buffer.from(JSON.stringify(input))),
      extractionAssistMimeType: "application/json",
    });
    const liabilitySelection = {
      ...selection(staged.sourceRef),
      profileId: "nedbank-credit" as const,
    };
    const preview =
      await liability.service.previewStatementImport(liabilitySelection);
    assert.equal(preview.extraction.closingBalanceEconomicNature, "liability");
    assert.equal(preview.closingSnapshotEligible, true);
    const committed = await liability.service.commitStatementImport({
      ...liabilitySelection,
      previewHash: preview.previewHash,
      idempotencyKey: "fictional-liability-001",
      channel: "ui",
    });
    assert.ok(committed.snapshotId);
    assert.equal(
      liability.repository.snapshotDrafts[0]?.asOf,
      "2026-07-31T21:59:59.999Z",
    );
    assert.match(
      liability.repository.snapshotDrafts[0]?.key ?? "",
      /^statement-[a-f0-9]{32}$/,
    );
  } finally {
    await liability.cleanup();
  }

  const missing = await fixture();
  try {
    const staged = await stageValid(missing.service, {
      openingBalanceMinor: undefined,
      closingBalanceMinor: undefined,
    });
    const preview = await missing.service.previewStatementImport(
      selection(staged.sourceRef),
    );
    assert.equal(preview.commitAllowed, true);
    const committed = await missing.service.commitStatementImport({
      ...selection(staged.sourceRef),
      previewHash: preview.previewHash,
      idempotencyKey: "fictional-no-snapshot-001",
      channel: "ui",
    });
    assert.equal(committed.snapshotId, null);
  } finally {
    await missing.cleanup();
  }

  const unverified = await fixture();
  try {
    const staged = await stageValid(unverified.service);
    const genericSelection = {
      ...selection(staged.sourceRef),
      profileId: "normalized-json-v1" as const,
    };
    const preview =
      await unverified.service.previewStatementImport(genericSelection);
    assert.equal(preview.closingSnapshotEligible, false);
    assert.equal(
      preview.extraction.balanceConventionAuthority,
      "operator_unverified",
    );
    assert.ok(
      preview.issues.some(
        (item) =>
          item.code === "STATEMENT_BALANCE_CONVENTION_UNVERIFIED" &&
          !item.blocking,
      ),
    );
    const committed = await unverified.service.commitStatementImport({
      ...genericSelection,
      previewHash: preview.previewHash,
      idempotencyKey: "fictional-unverified-snapshot-001",
      channel: "ui",
    });
    assert.equal(committed.snapshotId, null);
  } finally {
    await unverified.cleanup();
  }
});

test("profile authority rejects convention mismatch and account nature mismatch", async () => {
  const convention = await fixture();
  try {
    const staged = await stageValid(convention.service, {
      balanceConvention: "positive_is_liability",
    });
    await assert.rejects(
      convention.service.previewStatementImport(selection(staged.sourceRef)),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_EXTRACTION_INVALID",
    );
  } finally {
    await convention.cleanup();
  }

  const nature = await fixture();
  try {
    (
      nature.repository.accounts[0] as {
        normalNature: "asset" | "liability";
      }
    ).normalNature = "liability";
    const staged = await stageValid(nature.service);
    const preview = await nature.service.previewStatementImport(
      selection(staged.sourceRef),
    );
    assert.equal(preview.commitAllowed, false);
    assert.ok(
      preview.issues.some(
        (item) => item.blocking && item.code === "STATEMENT_ACCOUNT_MISMATCH",
      ),
    );
  } finally {
    await nature.cleanup();
  }
});

test("source-kind coverage, source-order rows, and locators fail closed", async () => {
  const invalidInputs = [
    {
      coverage: {
        status: "complete",
        sourcePageCount: null,
        processedPages: [],
        sourceSections: ["transactions"],
        processedSections: ["transactions"],
        printedRowCount: 2,
      },
    },
    {
      coverage: {
        status: "complete",
        sourcePageCount: 2,
        processedPages: [2, 1],
        sourceSections: ["transactions"],
        processedSections: ["transactions"],
        printedRowCount: 2,
      },
    },
    {
      mutate(input: ReturnType<typeof extractionInput>) {
        (input.rows[0] as any).locator = { page: 2 };
      },
    },
    {
      mutate(input: ReturnType<typeof extractionInput>) {
        (input.rows[0] as any).locator = {
          page: 1,
          region: { x: -1, y: 0, width: 1, height: 1 },
        };
      },
    },
    {
      mutate(input: ReturnType<typeof extractionInput>) {
        input.rows = [input.rows[1]!, input.rows[0]!];
      },
    },
    {
      mutate(input: ReturnType<typeof extractionInput>) {
        input.rows[1]!.rowNumber = 3;
      },
    },
  ];
  for (const invalid of invalidInputs) {
    const context = await fixture();
    try {
      const input = extractionInput(invalid as Record<string, unknown>);
      (
        invalid as {
          mutate?: (value: ReturnType<typeof extractionInput>) => void;
        }
      ).mutate?.(input);
      delete (input as any).mutate;
      const staged = await context.service.stageStatementSource({
        transport: "upload",
        originalBytes: ORIGINAL,
        mimeType: "application/pdf",
        sourceKind: "pdf",
        extractionAssistBytes: new Uint8Array(
          Buffer.from(JSON.stringify(input)),
        ),
        extractionAssistMimeType: "application/json",
      });
      await assert.rejects(
        context.service.previewStatementImport(selection(staged.sourceRef)),
        (error: unknown) =>
          error instanceof RavenDomainError &&
          error.code === "STATEMENT_EXTRACTION_INVALID",
      );
    } finally {
      await context.cleanup();
    }
  }

  const csv = await fixture();
  try {
    const input = extractionInput({
      sourceKind: "csv",
      coverage: {
        status: "complete",
        sourcePageCount: null,
        processedPages: [],
        sourceSections: ["transactions"],
        processedSections: ["transactions"],
        printedRowCount: 2,
      },
    });
    const staged = await csv.service.stageStatementSource({
      transport: "upload",
      originalBytes: new Uint8Array(
        Buffer.from("date,amount\n2026-07-03,50.00\n"),
      ),
      mimeType: "text/csv",
      sourceKind: "csv",
      extractionAssistBytes: new Uint8Array(Buffer.from(JSON.stringify(input))),
      extractionAssistMimeType: "application/json",
    });
    const preview = await csv.service.previewStatementImport(
      selection(staged.sourceRef),
    );
    assert.equal(preview.commitAllowed, true);
  } finally {
    await csv.cleanup();
  }
});

test("renderer-era legacy evidence maps by closing date and unmappable legacy fails closed", async () => {
  const exact = await fixture();
  try {
    const staged = await stageValid(exact.service);
    const seeded = await exact.service.previewStatementImport(
      selection(staged.sourceRef),
    );
    await exact.service.commitStatementImport({
      ...selection(staged.sourceRef),
      previewHash: seeded.previewHash,
      idempotencyKey: "fictional-renderer-legacy-seed",
      channel: "system",
    });
    Object.assign(exact.repository.imports[0]!, {
      sourceState: "legacy",
      periodStart: "",
      periodEnd: "",
      key: "2026-07-31-fictional-business",
      legacyPeriodEvidence: {
        statementDate: "2026-07-31",
        keyDate: "2026-07-31",
        mapping: "known_renderer_end_date",
      },
    });
    const changed = await exact.service.stageStatementSource({
      transport: "upload",
      originalBytes: new Uint8Array(
        Buffer.from("%PDF-1.4\nChanged legacy evidence\n"),
      ),
      mimeType: "application/pdf",
      sourceKind: "pdf",
      extractionAssistBytes: assistBytes(),
      extractionAssistMimeType: "application/json",
    });
    const preview = await exact.service.previewStatementImport(
      selection(changed.sourceRef),
    );
    assert.ok(
      preview.issues.some(
        (item) =>
          item.code === "STATEMENT_LEGACY_PERIOD_CONFLICT" && item.blocking,
      ),
    );
  } finally {
    await exact.cleanup();
  }

  const unknown = await fixture();
  try {
    const staged = await stageValid(unknown.service);
    const seeded = await unknown.service.previewStatementImport(
      selection(staged.sourceRef),
    );
    await unknown.service.commitStatementImport({
      ...selection(staged.sourceRef),
      previewHash: seeded.previewHash,
      idempotencyKey: "fictional-unmappable-legacy-seed",
      channel: "system",
    });
    Object.assign(unknown.repository.imports[0]!, {
      sourceState: "legacy",
      periodStart: "",
      periodEnd: "",
      key: "legacy-without-date",
      legacyPeriodEvidence: {
        statementDate: null,
        keyDate: null,
        mapping: "unmappable",
      },
    });
    const preview = await unknown.service.previewStatementImport(
      selection(staged.sourceRef),
    );
    assert.ok(
      preview.issues.some(
        (item) =>
          item.code === "STATEMENT_LEGACY_COMPATIBILITY_REQUIRED" &&
          item.blocking,
      ),
    );
  } finally {
    await unknown.cleanup();
  }
});

test("account context fingerprint invalidates a reviewed preview before commit", async () => {
  const context = await fixture();
  try {
    const staged = await stageValid(context.service);
    const selected = selection(staged.sourceRef);
    const preview = await context.service.previewStatementImport(selected);
    assert.match(preview.account.accountContextFingerprint, /^[a-f0-9]{64}$/);
    (
      context.repository.accounts[0] as { spaceTimezone: string }
    ).spaceTimezone = "UTC";
    await assert.rejects(
      context.service.commitStatementImport({
        ...selected,
        previewHash: preview.previewHash,
        idempotencyKey: "fictional-account-context-race",
        channel: "system",
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_PREVIEW_STALE",
    );
    assert.equal(context.repository.commitCount, 0);
  } finally {
    await context.cleanup();
  }
});

test("normalized assistance cannot supply accepted account, merchant, category or checksum authority", async () => {
  const context = await fixture();
  try {
    for (const forbidden of [
      { accountKey: "untrusted" },
      { checksum: "untrusted" },
      { rows: [{ merchant: "untrusted" }] },
      { rows: [{ category: "untrusted" }] },
    ]) {
      const input = { ...extractionInput(), ...forbidden };
      const staged = await context.service.stageStatementSource({
        transport: "upload",
        originalBytes: ORIGINAL,
        mimeType: "application/pdf",
        sourceKind: "pdf",
        extractionAssistBytes: new Uint8Array(
          Buffer.from(JSON.stringify(input)),
        ),
        extractionAssistMimeType: "application/json",
      });
      await assert.rejects(
        context.service.previewStatementImport(selection(staged.sourceRef)),
        (error: unknown) =>
          error instanceof RavenDomainError &&
          error.code === "STATEMENT_EXTRACTION_INVALID",
      );
    }
  } finally {
    await context.cleanup();
  }
});

test("vault path intake rejects traversal, symlinks, out-of-root, MIME mismatch and oversize without disclosure", async () => {
  const context = await fixture({ maxSourceBytes: 128 });
  try {
    const original = path.join(context.inbox, "fictional.pdf");
    const assist = path.join(context.inbox, "fictional.json");
    await writeFile(original, ORIGINAL);
    await writeFile(assist, assistBytes());
    await chmod(original, 0o600);
    await chmod(assist, 0o600);
    const outside = path.join(context.root, "outside.pdf");
    await writeFile(outside, ORIGINAL);
    const linked = path.join(context.inbox, "linked.pdf");
    await symlink(outside, linked);

    const attempts = [
      {
        originalPath: path.join(context.inbox, "..", "outside.pdf"),
        mimeType: "application/pdf",
        sourceKind: "pdf" as const,
      },
      {
        originalPath: linked,
        mimeType: "application/pdf",
        sourceKind: "pdf" as const,
      },
      {
        originalPath: outside,
        mimeType: "application/pdf",
        sourceKind: "pdf" as const,
      },
      {
        originalPath: original,
        mimeType: "text/csv",
        sourceKind: "pdf" as const,
      },
    ];
    for (const attempt of attempts) {
      await assert.rejects(
        context.service.stageStatementSource({
          transport: "local_path",
          ...attempt,
        }),
        (error: unknown) => {
          assert.ok(error instanceof RavenDomainError);
          assert.doesNotMatch(
            error.message,
            new RegExp(context.root.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")),
          );
          return true;
        },
      );
    }
    const oversized = path.join(context.inbox, "large.pdf");
    await writeFile(
      oversized,
      new Uint8Array(Buffer.from(`%PDF-${"x".repeat(256)}`)),
    );
    await assert.rejects(
      context.service.stageStatementSource({
        transport: "local_path",
        originalPath: oversized,
        mimeType: "application/pdf",
        sourceKind: "pdf",
      }),
    );
  } finally {
    await context.cleanup();
  }
});

test("changing staged evidence or assist bytes invalidates subsequent reads", async () => {
  const context = await fixture();
  try {
    const staged = await stageValid(context.service);
    const sourceDirectory = path.join(context.vaultRoot, staged.sourceRef);
    await writeFile(
      path.join(sourceDirectory, "original.bin"),
      new Uint8Array(Buffer.from("%PDF-changed")),
    );
    await assert.rejects(
      context.service.previewStatementImport(selection(staged.sourceRef)),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_SOURCE_CHANGED",
    );

    const second = await stageValid(context.service);
    await writeFile(
      path.join(context.vaultRoot, second.sourceRef, "extraction-assist.json"),
      assistBytes({ periodEnd: "2026-08-01" }),
    );
    await assert.rejects(
      context.service.previewStatementImport(selection(second.sourceRef)),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "STATEMENT_SOURCE_CHANGED",
    );
  } finally {
    await context.cleanup();
  }
});
