import { createHash } from "node:crypto";

import { RavenDomainError } from "./errors.js";
import type { OperationDraft } from "./repository.js";
import {
  canonicalStatementJson,
  statementSha256,
} from "./statement-adapters.js";
import type {
  ApplyLegacyStatementResolutionInput,
  PreviewLegacyStatementResolutionInput,
  PreviewLegacyStatementResolutionResult,
  ReverseLegacyStatementResolutionInput,
  StatementLegacyResolutionApi,
  StatementLegacyResolutionCommand,
  StatementLegacyResolutionOperation,
  StatementLegacyResolutionRepository,
  StatementLegacyResolutionResult,
  StatementLegacySourceService,
} from "./statement-legacy-resolution-contracts.js";
import {
  assertLegacyResolutionDecisions,
  planLegacyStatementResolution,
} from "./statement-legacy-resolution-planner.js";

type Options = Readonly<{
  source: StatementLegacySourceService;
  repository: StatementLegacyResolutionRepository;
  clock?: () => string;
}>;

function operationKey(
  command: StatementLegacyResolutionCommand,
  idempotencyKey: string,
): string {
  return `statement-${createHash("sha256")
    .update(`${command}:${idempotencyKey}`)
    .digest("hex")
    .slice(0, 32)}`;
}

function requestHash(
  command: StatementLegacyResolutionCommand,
  input: unknown,
): string {
  return statementSha256(canonicalStatementJson({ command, input }));
}

function operationDraft(
  command: StatementLegacyResolutionCommand,
  input: {
    idempotencyKey: string;
    channel: "ui" | "mcp" | "system";
    actorId?: string;
  },
  request: unknown,
  recordedAt: string,
): OperationDraft {
  return {
    key: operationKey(command, input.idempotencyKey),
    command,
    idempotencyKey: input.idempotencyKey,
    requestHash: requestHash(command, request),
    channel: input.channel,
    actorId: input.actorId,
    recordedAt,
    warningCodes: [],
    auditMeta: {
      contractVersion: "statement-truth-v0.1",
      workline: "HP-04",
    },
  };
}

function assertReplay(
  operation: StatementLegacyResolutionOperation,
  expectedHash: string,
): void {
  if (operation.requestHash !== expectedHash) {
    throw new RavenDomainError(
      "STATEMENT_LEGACY_REPLAY_CONFLICT",
      "Idempotency key was already used for a different legacy-resolution command",
    );
  }
}

function previewIdentityHash(
  input: PreviewLegacyStatementResolutionInput,
  result: PreviewLegacyStatementResolutionResult["plan"],
): string {
  return statementSha256(
    canonicalStatementJson({
      legacyStatementImportId: input.legacyStatementImportId,
      sourceIdentityHash: result.sourceIdentityHash,
      canonicalPreviewHash: result.canonicalPreviewHash,
      legacyEvidenceHash: result.legacyEvidenceHash,
      accountContextFingerprint: result.accountContextFingerprint,
      crosswalkHash: result.crosswalkHash,
      expectedRevisionClaimHash: result.expectedRevisionClaimHash,
      databaseFingerprint: result.databaseFingerprint,
    }),
  );
}

function sortedDecisions(
  input: ApplyLegacyStatementResolutionInput,
): ApplyLegacyStatementResolutionInput {
  return {
    ...input,
    decisions: [...input.decisions].sort((left, right) =>
      left.itemKey.localeCompare(right.itemKey),
    ),
  };
}

export class StatementLegacyResolutionService implements StatementLegacyResolutionApi {
  readonly #source: StatementLegacySourceService;
  readonly #repository: StatementLegacyResolutionRepository;
  readonly #clock: () => string;

  constructor(options: Options) {
    this.#source = options.source;
    this.#repository = options.repository;
    this.#clock = options.clock ?? (() => new Date().toISOString());
  }

  async previewLegacyStatementResolution(
    input: PreviewLegacyStatementResolutionInput,
  ): Promise<PreviewLegacyStatementResolutionResult> {
    const [preview, evidence] = await Promise.all([
      this.#source.validateStatementPreview(input),
      this.#repository.loadEvidence(input.legacyStatementImportId),
    ]);
    const plan = planLegacyStatementResolution({ input, preview }, evidence);
    return {
      previewIdentityHash: previewIdentityHash(input, plan),
      plan,
      privateProjection: { items: plan.items },
      aggregateProjection: {
        counts: plan.aggregateCounts,
        recommendedStrategy: plan.recommendedStrategy,
        applyEligible: plan.applyEligible,
      },
    };
  }

  async applyLegacyStatementResolution(
    originalInput: ApplyLegacyStatementResolutionInput,
  ): Promise<StatementLegacyResolutionResult> {
    const input = sortedDecisions(originalInput);
    const command = "apply_legacy_statement_resolution" as const;
    const expectedRequestHash = requestHash(command, input);
    const replay = await this.#repository.getOperation(
      command,
      input.idempotencyKey,
    );
    if (replay) {
      assertReplay(replay, expectedRequestHash);
      return this.#replayResult(replay);
    }

    const previewResult = await this.previewLegacyStatementResolution(input);
    const plan = previewResult.plan;
    if (
      input.previewIdentityHash !== previewResult.previewIdentityHash ||
      input.expectedDatabaseFingerprint !== plan.databaseFingerprint ||
      input.expectedSourceIdentityHash !== plan.sourceIdentityHash ||
      input.expectedLegacyEvidenceHash !== plan.legacyEvidenceHash ||
      input.expectedAccountContextFingerprint !==
        plan.accountContextFingerprint ||
      input.expectedCrosswalkHash !== plan.crosswalkHash ||
      input.expectedRevisionClaimHash !== plan.expectedRevisionClaimHash
    ) {
      throw new RavenDomainError(
        "STATEMENT_LEGACY_EVIDENCE_DRIFT",
        "Legacy-resolution evidence changed after the reviewed preview",
      );
    }
    if (!plan.eligibleStrategies.includes(input.strategy)) {
      throw new RavenDomainError(
        "STATEMENT_LEGACY_STRATEGY_UNSUPPORTED",
        "The requested strategy is not eligible for the exact server-derived crosswalk",
      );
    }
    assertLegacyResolutionDecisions(plan, input.decisions);

    const operation = operationDraft(command, input, input, this.#clock());
    const source = await this.#source.prepareStatementSupersessionDraft(
      input,
      operation,
      input.legacyStatementImportId,
      true,
    );
    const evidence = await this.#repository.loadEvidence(
      input.legacyStatementImportId,
    );
    const finalPlan = planLegacyStatementResolution(
      { input, preview: await this.#source.validateStatementPreview(input) },
      evidence,
    );
    if (
      finalPlan.crosswalkHash !== plan.crosswalkHash ||
      finalPlan.expectedRevisionClaimHash !== plan.expectedRevisionClaimHash ||
      finalPlan.resultAuthorityHash !== plan.resultAuthorityHash
    ) {
      throw new RavenDomainError(
        "STATEMENT_LEGACY_EVIDENCE_DRIFT",
        "Legacy-resolution evidence changed while preparing the atomic apply",
      );
    }
    assertLegacyResolutionDecisions(finalPlan, input.decisions);
    try {
      return await this.#repository.apply({
        source,
        evidence,
        plan: finalPlan,
        strategy: input.strategy,
        decisions: input.decisions,
        operation,
      });
    } catch (error) {
      const concurrent = await this.#repository.getOperation(
        command,
        input.idempotencyKey,
      );
      if (!concurrent) throw error;
      assertReplay(concurrent, expectedRequestHash);
      return this.#replayResult(concurrent);
    }
  }

  async reverseLegacyStatementResolution(
    input: ReverseLegacyStatementResolutionInput,
  ): Promise<StatementLegacyResolutionResult> {
    const command = "reverse_legacy_statement_resolution" as const;
    const expectedRequestHash = requestHash(command, input);
    const replay = await this.#repository.getOperation(
      command,
      input.idempotencyKey,
    );
    if (replay) {
      assertReplay(replay, expectedRequestHash);
      return this.#replayResult(replay);
    }
    const target = await this.#repository.getResolution(
      input.statementLegacyResolutionId,
    );
    if (!target || target.resolutionType !== "apply") {
      throw new RavenDomainError(
        "STATEMENT_LEGACY_ROLLBACK_INELIGIBLE",
        "The target apply resolution is unavailable for reversal",
      );
    }
    if (
      target.databaseFingerprint !== input.expectedDatabaseFingerprint ||
      target.requestHash !== input.expectedTargetRequestHash ||
      target.resultAuthorityHash !== input.expectedAuthorityHash
    ) {
      throw new RavenDomainError(
        "STATEMENT_LEGACY_ROLLBACK_INELIGIBLE",
        "The target apply authority changed after reversal review",
      );
    }
    const targetItems = await this.#repository.listResolutionItems(target.id);
    const operation = operationDraft(command, input, input, this.#clock());
    try {
      return await this.#repository.reverse({
        target,
        targetItems,
        expectedDatabaseFingerprint: input.expectedDatabaseFingerprint,
        expectedAuthorityHash: input.expectedAuthorityHash,
        operation,
      });
    } catch (error) {
      const concurrent = await this.#repository.getOperation(
        command,
        input.idempotencyKey,
      );
      if (!concurrent) throw error;
      assertReplay(concurrent, expectedRequestHash);
      return this.#replayResult(concurrent);
    }
  }

  async #replayResult(
    operation: StatementLegacyResolutionOperation,
  ): Promise<StatementLegacyResolutionResult> {
    const resolutionId = operation.resultRefs.find((value) =>
      value.startsWith("statementLegacyResolution:"),
    );
    if (!resolutionId) {
      throw new RavenDomainError(
        "INTERNAL",
        "Legacy-resolution replay is missing its immutable result reference",
      );
    }
    const resolution = await this.#repository.getResolution(resolutionId);
    if (!resolution) {
      throw new RavenDomainError(
        "INTERNAL",
        "Legacy-resolution replay result is unavailable",
      );
    }
    const authorityImportId =
      resolution.authorityEffect === "activate_canonical"
        ? resolution.canonicalStatementImportId
        : resolution.legacyStatementImportId;
    const [items, statementImport, reconciliation] = await Promise.all([
      this.#repository.listResolutionItems(resolution.id),
      this.#repository.getStatementImport(authorityImportId),
      this.#repository.getReconciliation(authorityImportId),
    ]);
    if (!statementImport) {
      throw new RavenDomainError(
        "INTERNAL",
        "Legacy-resolution replay statement authority is unavailable",
      );
    }
    return {
      resolution,
      items,
      statementImport,
      reconciliation,
      receipt: {
        operationId: operation.id,
        status: "replayed",
        resultRefs: operation.resultRefs,
        completedAt: operation.completedAt ?? operation.recordedAt,
      },
    };
  }
}

export function createStatementLegacyResolutionService(
  options: Options,
): StatementLegacyResolutionApi {
  return new StatementLegacyResolutionService(options);
}
