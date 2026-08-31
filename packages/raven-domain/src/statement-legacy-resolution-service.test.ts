import assert from "node:assert/strict";
import test from "node:test";

import type { TransactionRecord } from "./contracts.js";
import { RavenDomainError } from "./errors.js";
import type {
  StatementImportRecord,
  StatementPreviewResult,
} from "./statement-contracts.js";
import type {
  ApplyLegacyStatementResolutionInput,
  PreviewLegacyStatementResolutionResult,
  StatementLegacyApplyDraft,
  StatementLegacyResolutionOperation,
  StatementLegacyResolutionRecord,
  StatementLegacyResolutionRepository,
  StatementLegacyResolutionResult,
  StatementLegacyReverseDraft,
  StatementLegacySourceService,
} from "./statement-legacy-resolution-contracts.js";
import { createStatementLegacyResolutionService } from "./statement-legacy-resolution-service.js";

const HASH = (value: string) => value.repeat(64).slice(0, 64);

function statementImport(): StatementImportRecord {
  return {
    id: "StatementImport:legacy-fictional",
    accountId: "Account:fictional",
    spaceId: "FinancialSpace:fictional",
    periodStart: "2026-06-01",
    periodEnd: "2026-06-30",
    currency: "ZAR",
    sourceState: "legacy",
    accountContextFingerprint: HASH("a"),
    revision: 1,
  } as unknown as StatementImportRecord;
}

function preview(): StatementPreviewResult {
  return {
    source: {
      originalFileSha256: HASH("b"),
      extractionInputSha256: HASH("c"),
    },
    profile: {
      profileId: "fnb-business",
      profileVersion: "1",
      extractorVersion: "1",
    },
    account: {
      accountId: "Account:fictional",
      spaceId: "FinancialSpace:fictional",
      accountContextFingerprint: HASH("a"),
    },
    extraction: {
      canonicalExtractionSha256: HASH("d"),
      currency: "ZAR",
      periodStart: "2026-06-01",
      periodEnd: "2026-06-30",
      rows: [
        {
          rowKey: "row-1",
          rowNumber: 1,
          transactionDate: "2026-06-12",
          postingDate: null,
          valueDate: null,
          components: [
            {
              componentKey: "payment",
              componentRole: "movement",
              sourceChecksum: HASH("e"),
              amountMinor: 5_000,
              balanceEffectMinor: -5_000,
              currency: "ZAR",
              transactionDate: "2026-06-12",
              postingDate: null,
              valueDate: null,
            },
          ],
        },
      ],
    },
    previewHash: HASH("f"),
  } as unknown as StatementPreviewResult;
}

function transaction(): TransactionRecord {
  return {
    id: "Transaction:legacy-fictional",
    key: "legacy-fictional",
    spaceId: "FinancialSpace:fictional",
    spaceKey: "fictional",
    accountId: "Account:fictional",
    accountKey: "fictional",
    postedAt: "2026-06-12",
    recordedAt: "2026-07-01T00:00:00.000Z",
    description: "Fictional movement",
    amountMinor: 5_000,
    currency: "ZAR",
    kind: "expense",
    flowDirection: "outflow",
    entrySource: "imported",
    status: "imported",
    sourceRowId: "StatementRow:legacy-1",
    warnings: [],
  };
}

class MemoryRepository implements StatementLegacyResolutionRepository {
  operations = new Map<string, StatementLegacyResolutionOperation>();
  resolutions = new Map<string, StatementLegacyResolutionRecord>();
  applyCalls = 0;
  reverseCalls = 0;
  evidenceRevision = 1;
  throwAfterApplyPersist = false;
  reverseFailure: RavenDomainError | null = null;

  async getOperation(command: string, idempotencyKey: string) {
    return this.operations.get(`${command}:${idempotencyKey}`) ?? null;
  }
  async getResolution(id: string) {
    return this.resolutions.get(id) ?? null;
  }
  async getStatementImport() {
    return statementImport();
  }
  async getReconciliation() {
    return null;
  }
  async listResolutionItems() {
    return [];
  }
  async loadEvidence() {
    return {
      databaseFingerprint: HASH("9"),
      legacyStatementImport: {
        ...statementImport(),
        revision: this.evidenceRevision,
      },
      legacyRows: [
        {
          id: "StatementRow:legacy-1",
          rowNumber: 1,
          rowKind: "movement",
          rowHash: HASH("8"),
        },
      ] as any,
      legacyTransactions: [transaction()],
      counterpartTransactions: [],
      accountTransfers: [],
      activeMatches: [],
      reconciliation: null,
      dependentAuthorityHash: HASH("7"),
    };
  }
  async apply(draft: StatementLegacyApplyDraft) {
    this.applyCalls += 1;
    await Promise.resolve();
    const operationKey = `${draft.operation.command}:${draft.operation.idempotencyKey}`;
    if (this.operations.has(operationKey)) {
      throw new Error("fictional concurrent operation conflict");
    }
    const result = resultFor(draft.operation, draft.plan.resultAuthorityHash);
    this.persistOperation(draft.operation, result);
    if (this.throwAfterApplyPersist) {
      throw new Error("fictional lost response after atomic commit");
    }
    return result;
  }
  async reverse(draft: StatementLegacyReverseDraft) {
    this.reverseCalls += 1;
    if (this.reverseFailure) throw this.reverseFailure;
    const result = resultFor(draft.operation, HASH("6"), "reversal");
    this.persistOperation(draft.operation, result);
    return result;
  }

  persistOperation(
    operation: StatementLegacyApplyDraft["operation"],
    result: StatementLegacyResolutionResult,
  ) {
    const record: StatementLegacyResolutionOperation = {
      id: result.receipt.operationId,
      key: operation.key,
      command:
        operation.command as StatementLegacyResolutionOperation["command"],
      idempotencyKey: operation.idempotencyKey,
      requestHash: operation.requestHash,
      channel: operation.channel,
      actorId: operation.actorId ?? null,
      status: "applied",
      resultRefs: [result.resolution.id],
      warningCodes: [],
      auditMeta: operation.auditMeta ?? {},
      recordedAt: operation.recordedAt,
      completedAt: operation.recordedAt,
    };
    this.operations.set(`${record.command}:${record.idempotencyKey}`, record);
    this.resolutions.set(result.resolution.id, result.resolution);
  }
}

function resultFor(
  operation: StatementLegacyApplyDraft["operation"],
  authorityHash: string,
  resolutionType: "apply" | "reversal" = "apply",
): StatementLegacyResolutionResult {
  return {
    resolution: {
      id: `statementLegacyResolution:${resolutionType}`,
      key: resolutionType,
      spaceId: "FinancialSpace:fictional",
      accountId: "Account:fictional",
      legacyStatementImportId: "StatementImport:legacy-fictional",
      canonicalStatementImportId: "StatementImport:canonical-fictional",
      resolutionType,
      strategy: "A",
      authorityEffect:
        resolutionType === "apply" ? "activate_canonical" : "restore_previous",
      previousLegacySourceState: "legacy",
      previousSourceClaimState: "absent",
      previousPeriodClaimState: "absent",
      targetResolutionId:
        resolutionType === "reversal"
          ? "statementLegacyResolution:apply"
          : null,
      predecessorResolutionId:
        resolutionType === "reversal"
          ? "statementLegacyResolution:apply"
          : null,
      resultAuthorityHash: authorityHash,
      requestHash: operation.requestHash,
      databaseFingerprint: HASH("9"),
    } as StatementLegacyResolutionRecord,
    items: [],
    statementImport: statementImport(),
    reconciliation: null,
    receipt: {
      operationId: `financialOperation:${operation.key}`,
      status: "applied",
      resultRefs: [`statementLegacyResolution:${resolutionType}`],
      completedAt: operation.recordedAt,
    },
  };
}

function sourceService() {
  let validationCalls = 0;
  let draftCalls = 0;
  const source = {
    async validateStatementPreview() {
      validationCalls += 1;
      return preview();
    },
    async prepareStatementSupersessionDraft(
      _input,
      operation,
      replacementOfId,
      allowExactLegacyOverlap,
    ) {
      draftCalls += 1;
      assert.equal(replacementOfId, "StatementImport:legacy-fictional");
      assert.equal(allowExactLegacyOverlap, true);
      return {
        statementImport: {
          replacementOfId,
        },
        components: [],
        rows: [],
        issues: [],
        operation,
      } as unknown as StatementLegacyApplyDraft["source"];
    },
  } satisfies StatementLegacySourceService;
  return {
    source,
    validationCalls: () => validationCalls,
    draftCalls: () => draftCalls,
  };
}

const previewInput = {
  sourceRef: "vault:fictional",
  spaceKey: "fictional",
  accountKey: "fictional",
  profileId: "fnb-business" as const,
  profileVersion: "1" as const,
  previewHash: HASH("f"),
  legacyStatementImportId: "StatementImport:legacy-fictional",
};

function reviewedApplyInput(
  reviewed: PreviewLegacyStatementResolutionResult,
  idempotencyKey: string,
): ApplyLegacyStatementResolutionInput {
  const planned = reviewed.plan.items[0]!;
  return {
    ...previewInput,
    previewIdentityHash: reviewed.previewIdentityHash,
    expectedDatabaseFingerprint: reviewed.plan.databaseFingerprint,
    expectedSourceIdentityHash: reviewed.plan.sourceIdentityHash,
    expectedLegacyEvidenceHash: reviewed.plan.legacyEvidenceHash,
    expectedAccountContextFingerprint: reviewed.plan.accountContextFingerprint,
    expectedCrosswalkHash: reviewed.plan.crosswalkHash,
    expectedRevisionClaimHash: reviewed.plan.expectedRevisionClaimHash,
    strategy: "A",
    decisions: [
      {
        itemKey: planned.key,
        outcome: "adopted_existing",
        itemEvidenceHash: planned.itemEvidenceHash,
        legacyTransactionId: "Transaction:legacy-fictional",
      },
    ],
    idempotencyKey,
    channel: "mcp",
  };
}

test("legacy preview is deterministic and performs no repository mutation", async () => {
  const repository = new MemoryRepository();
  const source = sourceService();
  const service = createStatementLegacyResolutionService({
    source: source.source,
    repository,
    clock: () => "2026-08-11T00:00:00.000Z",
  });
  const first = await service.previewLegacyStatementResolution(previewInput);
  const second = await service.previewLegacyStatementResolution(previewInput);
  assert.deepEqual(second.plan, first.plan);
  assert.equal(first.plan.applyEligible, true);
  assert.equal(repository.applyCalls, 0);
  assert.equal(repository.reverseCalls, 0);
  assert.equal(source.draftCalls(), 0);
});

test("apply rederives exact evidence and exact replay bypasses private source access", async () => {
  const repository = new MemoryRepository();
  const source = sourceService();
  const service = createStatementLegacyResolutionService({
    source: source.source,
    repository,
    clock: () => "2026-08-11T00:00:00.000Z",
  });
  const reviewed = await service.previewLegacyStatementResolution(previewInput);
  const input = reviewedApplyInput(reviewed, "fictional-hp04-apply");
  const applied = await service.applyLegacyStatementResolution(input);
  assert.equal(applied.receipt.status, "applied");
  assert.equal(repository.applyCalls, 1);
  assert.equal(source.draftCalls(), 1);

  const callsBeforeReplay = source.validationCalls();
  const replayed = await service.applyLegacyStatementResolution(input);
  assert.equal(replayed.receipt.status, "replayed");
  assert.equal(source.validationCalls(), callsBeforeReplay);
  assert.equal(repository.applyCalls, 1);
  await assert.rejects(
    service.applyLegacyStatementResolution({
      ...input,
      expectedCrosswalkHash: HASH("0"),
    }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_LEGACY_REPLAY_CONFLICT",
  );
  assert.equal(source.validationCalls(), callsBeforeReplay);
});

test("concurrent identical apply attempts produce one apply and one exact replay", async () => {
  const repository = new MemoryRepository();
  const source = sourceService();
  const service = createStatementLegacyResolutionService({
    source: source.source,
    repository,
    clock: () => "2026-08-11T00:00:00.000Z",
  });
  const reviewed = await service.previewLegacyStatementResolution(previewInput);
  const input = reviewedApplyInput(reviewed, "fictional-hp04-concurrent");
  const results = await Promise.all([
    service.applyLegacyStatementResolution(input),
    service.applyLegacyStatementResolution(input),
  ]);
  assert.deepEqual(results.map((result) => result.receipt.status).sort(), [
    "applied",
    "replayed",
  ]);
  assert.equal(repository.applyCalls, 2);
  assert.equal(repository.operations.size, 1);
  assert.equal(repository.resolutions.size, 1);
});

test("a lost apply response resolves through the persisted immutable operation", async () => {
  const repository = new MemoryRepository();
  repository.throwAfterApplyPersist = true;
  const source = sourceService();
  const service = createStatementLegacyResolutionService({
    source: source.source,
    repository,
    clock: () => "2026-08-11T00:00:00.000Z",
  });
  const reviewed = await service.previewLegacyStatementResolution(previewInput);
  const input = reviewedApplyInput(reviewed, "fictional-hp04-lost-response");
  const recovered = await service.applyLegacyStatementResolution(input);
  assert.equal(recovered.receipt.status, "replayed");
  assert.equal(repository.applyCalls, 1);
  assert.equal(repository.operations.size, 1);
  assert.equal(repository.resolutions.size, 1);
});

test("reversal replays exactly and rejects changed reuse of its intent", async () => {
  const repository = new MemoryRepository();
  const source = sourceService();
  const service = createStatementLegacyResolutionService({
    source: source.source,
    repository,
    clock: () => "2026-08-11T00:00:00.000Z",
  });
  const reviewed = await service.previewLegacyStatementResolution(previewInput);
  const applied = await service.applyLegacyStatementResolution(
    reviewedApplyInput(reviewed, "fictional-hp04-reversal-target"),
  );
  const reverseInput = {
    statementLegacyResolutionId: applied.resolution.id,
    expectedDatabaseFingerprint: applied.resolution.databaseFingerprint,
    expectedTargetRequestHash: applied.resolution.requestHash,
    expectedAuthorityHash: applied.resolution.resultAuthorityHash,
    idempotencyKey: "fictional-hp04-reversal",
    channel: "mcp" as const,
  };
  const reversed = await service.reverseLegacyStatementResolution(reverseInput);
  assert.equal(reversed.receipt.status, "applied");
  const replayed = await service.reverseLegacyStatementResolution(reverseInput);
  assert.equal(replayed.receipt.status, "replayed");
  assert.equal(repository.reverseCalls, 1);
  await assert.rejects(
    service.reverseLegacyStatementResolution({
      ...reverseInput,
      expectedAuthorityHash: HASH("0"),
    }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_LEGACY_REPLAY_CONFLICT",
  );
});

test("stale reversal and later dependent authority remain ineligible", async () => {
  const repository = new MemoryRepository();
  const source = sourceService();
  const service = createStatementLegacyResolutionService({
    source: source.source,
    repository,
    clock: () => "2026-08-11T00:00:00.000Z",
  });
  const reviewed = await service.previewLegacyStatementResolution(previewInput);
  const applied = await service.applyLegacyStatementResolution(
    reviewedApplyInput(reviewed, "fictional-hp04-stale-target"),
  );
  const reverseInput = {
    statementLegacyResolutionId: applied.resolution.id,
    expectedDatabaseFingerprint: applied.resolution.databaseFingerprint,
    expectedTargetRequestHash: applied.resolution.requestHash,
    expectedAuthorityHash: applied.resolution.resultAuthorityHash,
    idempotencyKey: "fictional-hp04-stale-reversal",
    channel: "mcp" as const,
  };
  await assert.rejects(
    service.reverseLegacyStatementResolution({
      ...reverseInput,
      expectedAuthorityHash: HASH("0"),
    }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_LEGACY_ROLLBACK_INELIGIBLE",
  );
  assert.equal(repository.reverseCalls, 0);

  repository.reverseFailure = new RavenDomainError(
    "STATEMENT_LEGACY_ROLLBACK_INELIGIBLE",
    "Fictional later authority depends on the target",
  );
  await assert.rejects(
    service.reverseLegacyStatementResolution(reverseInput),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_LEGACY_ROLLBACK_INELIGIBLE",
  );
  assert.equal(repository.reverseCalls, 1);
  assert.equal(
    repository.operations.has(
      "reverse_legacy_statement_resolution:fictional-hp04-stale-reversal",
    ),
    false,
  );
});

test("evidence drift fails before the atomic repository apply", async () => {
  const repository = new MemoryRepository();
  const source = sourceService();
  const service = createStatementLegacyResolutionService({
    source: source.source,
    repository,
  });
  const reviewed = await service.previewLegacyStatementResolution(previewInput);
  repository.evidenceRevision = 2;
  const planned = reviewed.plan.items[0]!;
  await assert.rejects(
    service.applyLegacyStatementResolution({
      ...previewInput,
      previewIdentityHash: reviewed.previewIdentityHash,
      expectedDatabaseFingerprint: reviewed.plan.databaseFingerprint,
      expectedSourceIdentityHash: reviewed.plan.sourceIdentityHash,
      expectedLegacyEvidenceHash: reviewed.plan.legacyEvidenceHash,
      expectedAccountContextFingerprint:
        reviewed.plan.accountContextFingerprint,
      expectedCrosswalkHash: reviewed.plan.crosswalkHash,
      expectedRevisionClaimHash: reviewed.plan.expectedRevisionClaimHash,
      strategy: "A",
      decisions: [
        {
          itemKey: planned.key,
          outcome: "adopted_existing",
          itemEvidenceHash: planned.itemEvidenceHash,
          legacyTransactionId: "Transaction:legacy-fictional",
        },
      ],
      idempotencyKey: "fictional-hp04-drift",
      channel: "mcp",
    }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_LEGACY_EVIDENCE_DRIFT",
  );
  assert.equal(repository.applyCalls, 0);
});
