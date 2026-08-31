import { createHash, randomUUID } from "node:crypto";
import { RavenDomainError } from "./errors.js";
import {
  canonicalStatementJson,
  statementSha256,
} from "./statement-adapters.js";
import type { BalanceSnapshotDraft, OperationDraft } from "./repository.js";
import {
  statementComponentDraft,
  statementRowDraft,
  type StatementCommitDraft,
  type StatementImportDraft,
  type StatementIssueDraft,
  type StatementReviewedAccountContext,
  type StatementTruthRepository,
} from "./statement-repository.js";
import {
  STATEMENT_TRUTH_CONTRACT_VERSION,
  STATEMENT_VALIDATION_RULESET_VERSION,
  type CommitStatementImportInput,
  type DetectStatementProfileInput,
  type GetStatementImportInput,
  type GetStatementImportIssueInput,
  type GetStatementRowComponentInput,
  type GetStatementRowInput,
  type ListStatementImportIssuesInput,
  type ListStatementImportsInput,
  type ListStatementRowComponentsInput,
  type ListStatementRowsInput,
  type PreviewStatementImportInput,
  type StageStatementSourceInput,
  type StatementAdapterRegistry,
  type StatementAccountBinding,
  type StatementCommitResult,
  type StatementCommitOperation,
  type StatementIssue,
  type StatementPreviewResult,
  type StatementQueryMeta,
  type StatementSourceVault,
  type StatementTruthApi,
  type StatementWarningCode,
  type ValidateStatementPreviewInput,
} from "./statement-contracts.js";
import type { StatementResolutionApi } from "./statement-resolution-contracts.js";
import type { StatementLegacyResolutionApi } from "./statement-legacy-resolution-contracts.js";

type StatementTruthServiceOptions = Readonly<{
  repository: StatementTruthRepository;
  vault: StatementSourceVault;
  adapters: StatementAdapterRegistry;
  clock?: () => string;
  resolution?: StatementResolutionApi;
  legacyResolution?: StatementLegacyResolutionApi;
}>;

function operationKey(idempotencyKey: string): string {
  return `statement-${createHash("sha256").update(idempotencyKey).digest("hex").slice(0, 32)}`;
}

function checkedAdd(left: number, right: number, label: string): number {
  const result = left + right;
  if (!Number.isSafeInteger(result)) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      `${label} exceeds the safe integer range`,
    );
  }
  return result;
}

function reviewedAccountContext(
  account: StatementAccountBinding,
): StatementReviewedAccountContext {
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
  return {
    ...context,
    accountContextFingerprint: statementSha256(canonicalStatementJson(context)),
  };
}

function blockingPreviewError(
  issues: readonly StatementIssue[],
): RavenDomainError {
  const codes = issues.filter((item) => item.blocking).map((item) => item.code);
  const stableCode = [
    "STATEMENT_PREVIEW_STALE",
    "STATEMENT_DUPLICATE_SOURCE",
    "STATEMENT_LEGACY_PERIOD_CONFLICT",
    "STATEMENT_LEGACY_COMPATIBILITY_REQUIRED",
    "STATEMENT_IMMUTABLE_CONFLICT",
    "STATEMENT_ACCOUNT_MISMATCH",
    "STATEMENT_CURRENCY_MISMATCH",
  ].find((code) => codes.includes(code as StatementIssue["code"]));
  return new RavenDomainError(
    (stableCode ?? "STATEMENT_EXTRACTION_INVALID") as
      | "STATEMENT_PREVIEW_STALE"
      | "STATEMENT_DUPLICATE_SOURCE"
      | "STATEMENT_LEGACY_PERIOD_CONFLICT"
      | "STATEMENT_LEGACY_COMPATIBILITY_REQUIRED"
      | "STATEMENT_IMMUTABLE_CONFLICT"
      | "STATEMENT_ACCOUNT_MISMATCH"
      | "STATEMENT_CURRENCY_MISMATCH"
      | "STATEMENT_EXTRACTION_INVALID",
    "Statement preview contains blocking issues",
    { issueCodes: codes },
  );
}

function statementCommitRequestHash(input: CommitStatementImportInput): string {
  return statementSha256(
    canonicalStatementJson({
      sourceRef: input.sourceRef,
      spaceKey: input.spaceKey,
      accountKey: input.accountKey,
      profileId: input.profileId,
      profileVersion: input.profileVersion,
      previewHash: input.previewHash,
      channel: input.channel,
      actorId: input.actorId ?? null,
    }),
  );
}

function snapshotKey(
  spaceId: string,
  accountId: string,
  importKey: string,
): string {
  return `statement-${createHash("sha256")
    .update(canonicalStatementJson({ spaceId, accountId, importKey }))
    .digest("hex")
    .slice(0, 32)}`;
}

function zonedEndOfDay(dateOnly: string, timeZone: string): string {
  const year = Number(dateOnly.slice(0, 4));
  const month = Number(dateOnly.slice(5, 7));
  const day = Number(dateOnly.slice(8, 10));
  const targetNextMidnight = Date.UTC(year, month - 1, day + 1);
  const formatter = new Intl.DateTimeFormat("en-CA", {
    timeZone,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
    hourCycle: "h23",
  });
  let instant = targetNextMidnight;
  for (let attempt = 0; attempt < 4; attempt += 1) {
    const parts = Object.fromEntries(
      formatter
        .formatToParts(new Date(instant))
        .filter((part) => part.type !== "literal")
        .map((part) => [part.type, Number(part.value)]),
    ) as Record<string, number>;
    const representedAsUtc = Date.UTC(
      parts.year!,
      parts.month! - 1,
      parts.day!,
      parts.hour!,
      parts.minute!,
      parts.second!,
    );
    const adjustment = targetNextMidnight - representedAsUtc;
    if (adjustment === 0) break;
    instant += adjustment;
  }
  return new Date(instant - 1).toISOString();
}

function statementMeta(
  clock: () => string,
  warnings: readonly StatementWarningCode[] = [],
): StatementQueryMeta {
  return {
    requestId: randomUUID(),
    generatedAt: clock(),
    contractVersion: STATEMENT_TRUTH_CONTRACT_VERSION,
    warnings,
  };
}

function issueKey(issue: StatementIssue, index: number): string {
  return createHash("sha256")
    .update(
      canonicalStatementJson({
        code: issue.code,
        severity: issue.severity,
        rowKey: issue.rowKey ?? null,
        componentKey: issue.componentKey ?? null,
        index,
      }),
    )
    .digest("hex")
    .slice(0, 24);
}

function warningCodes(
  issues: readonly StatementIssue[],
): StatementWarningCode[] {
  const supported = new Set<StatementWarningCode>([
    "STATEMENT_ROW_LOW_CONFIDENCE",
    "STATEMENT_ROW_UNRESOLVED",
    "STATEMENT_COMPONENT_UNRESOLVED",
    "STATEMENT_BALANCE_MISSING",
    "STATEMENT_BALANCE_DIFFERENCE",
    "STATEMENT_BALANCE_CONVENTION_UNVERIFIED",
    "STATEMENT_EXISTING_IMPORT_FOUND",
    "STATEMENT_PARTIAL_PERIOD",
  ]);
  return [
    ...new Set(
      issues
        .filter(
          (item) =>
            item.severity !== "blocking" &&
            supported.has(item.code as StatementWarningCode),
        )
        .map((item) => item.code as StatementWarningCode),
    ),
  ];
}

function persistedIssues(
  issues: readonly StatementIssue[],
  now: string,
): StatementIssueDraft[] {
  return issues
    .filter((item) => !item.blocking)
    .map((item, index) => ({
      ...item,
      key: issueKey(item, index),
      rowKey: item.rowKey ?? null,
      componentKey: item.componentKey ?? null,
      detectedAt: now,
    }));
}

async function resolveCommitReplay(
  repository: StatementTruthRepository,
  replay: StatementCommitOperation,
  requestHash: string,
): Promise<StatementCommitResult> {
  if (replay.requestHash !== requestHash) {
    throw new RavenDomainError(
      "IDEMPOTENCY_CONFLICT",
      "Idempotency key was already used for a different statement commit",
    );
  }
  const importId = replay.resultRefs.find((ref) =>
    ref.startsWith("statementImport:"),
  );
  const statementImport = importId
    ? await repository.getStatementImport(importId)
    : null;
  if (!statementImport) {
    throw new RavenDomainError(
      "INTERNAL",
      "Statement replay result is unavailable",
    );
  }
  return {
    statementImport,
    snapshotId:
      replay.resultRefs.find((ref) =>
        ref.startsWith("accountBalanceSnapshot:"),
      ) ?? null,
    receipt: {
      operationId: replay.id,
      status: "replayed",
      resultRefs: replay.resultRefs,
      warningCodes: replay.warningCodes.filter((code) =>
        code.startsWith("STATEMENT_"),
      ) as StatementWarningCode[],
      completedAt: replay.completedAt ?? replay.recordedAt,
    },
  };
}

export class StatementTruthService implements StatementTruthApi {
  readonly #repository: StatementTruthRepository;
  readonly #vault: StatementSourceVault;
  readonly #adapters: StatementAdapterRegistry;
  readonly #clock: () => string;
  readonly #resolution: StatementResolutionApi | null;
  readonly #legacyResolution: StatementLegacyResolutionApi | null;

  readonly listStatementMatchCandidates: StatementResolutionApi["listStatementMatchCandidates"];
  readonly listStatementTransactionMatches: StatementResolutionApi["listStatementTransactionMatches"];
  readonly getStatementTransactionMatch: StatementResolutionApi["getStatementTransactionMatch"];
  readonly getStatementReconciliation: StatementResolutionApi["getStatementReconciliation"];
  readonly proposeStatementTransactionMatch: StatementResolutionApi["proposeStatementTransactionMatch"];
  readonly confirmStatementTransactionMatch: StatementResolutionApi["confirmStatementTransactionMatch"];
  readonly materializeStatementComponentTransaction: StatementResolutionApi["materializeStatementComponentTransaction"];
  readonly rejectStatementTransactionMatch: StatementResolutionApi["rejectStatementTransactionMatch"];
  readonly supersedeStatementTransactionMatch: StatementResolutionApi["supersedeStatementTransactionMatch"];
  readonly acknowledgeStatementIssue: StatementResolutionApi["acknowledgeStatementIssue"];
  readonly supersedeStatementImport: StatementResolutionApi["supersedeStatementImport"];
  readonly recalculateStatementReconciliation: StatementResolutionApi["recalculateStatementReconciliation"];
  readonly attestStatementReconciled: StatementResolutionApi["attestStatementReconciled"];
  readonly reopenStatementReconciliation: StatementResolutionApi["reopenStatementReconciliation"];
  readonly previewLegacyStatementResolution: StatementLegacyResolutionApi["previewLegacyStatementResolution"];
  readonly applyLegacyStatementResolution: StatementLegacyResolutionApi["applyLegacyStatementResolution"];
  readonly reverseLegacyStatementResolution: StatementLegacyResolutionApi["reverseLegacyStatementResolution"];

  constructor(options: StatementTruthServiceOptions) {
    this.#repository = options.repository;
    this.#vault = options.vault;
    this.#adapters = options.adapters;
    this.#clock = options.clock ?? (() => new Date().toISOString());
    this.#resolution = options.resolution ?? null;
    this.#legacyResolution = options.legacyResolution ?? null;
    const resolution = () => {
      if (!this.#resolution) {
        throw new RavenDomainError(
          "INTERNAL",
          "Statement resolution repository is unavailable",
        );
      }
      return this.#resolution;
    };
    this.listStatementMatchCandidates = (input) =>
      resolution().listStatementMatchCandidates(input);
    this.listStatementTransactionMatches = (input) =>
      resolution().listStatementTransactionMatches(input);
    this.getStatementTransactionMatch = (input) =>
      resolution().getStatementTransactionMatch(input);
    this.getStatementReconciliation = (input) =>
      resolution().getStatementReconciliation(input);
    this.proposeStatementTransactionMatch = (input) =>
      resolution().proposeStatementTransactionMatch(input);
    this.confirmStatementTransactionMatch = (input) =>
      resolution().confirmStatementTransactionMatch(input);
    this.materializeStatementComponentTransaction = (input) =>
      resolution().materializeStatementComponentTransaction(input);
    this.rejectStatementTransactionMatch = (input) =>
      resolution().rejectStatementTransactionMatch(input);
    this.supersedeStatementTransactionMatch = (input) =>
      resolution().supersedeStatementTransactionMatch(input);
    this.acknowledgeStatementIssue = (input) =>
      resolution().acknowledgeStatementIssue(input);
    this.supersedeStatementImport = (input) =>
      resolution().supersedeStatementImport(input);
    this.recalculateStatementReconciliation = (input) =>
      resolution().recalculateStatementReconciliation(input);
    this.attestStatementReconciled = (input) =>
      resolution().attestStatementReconciled(input);
    this.reopenStatementReconciliation = (input) =>
      resolution().reopenStatementReconciliation(input);
    const legacyResolution = () => {
      if (!this.#legacyResolution) {
        throw new RavenDomainError(
          "INTERNAL",
          "Statement legacy-resolution repository is unavailable",
        );
      }
      return this.#legacyResolution;
    };
    this.previewLegacyStatementResolution = (input) =>
      legacyResolution().previewLegacyStatementResolution(input);
    this.applyLegacyStatementResolution = (input) =>
      legacyResolution().applyLegacyStatementResolution(input);
    this.reverseLegacyStatementResolution = (input) =>
      legacyResolution().reverseLegacyStatementResolution(input);
  }

  stageStatementSource(input: StageStatementSourceInput) {
    return input.transport === "upload"
      ? this.#vault.stageUpload(input)
      : this.#vault.stageLocalPath(input);
  }

  async listStatementProfiles() {
    return {
      profiles: this.#adapters.list(),
      meta: statementMeta(this.#clock),
    };
  }

  async detectStatementProfile(input: DetectStatementProfileInput) {
    const bundle = await this.#vault.readBundle(input.sourceRef);
    const candidates = await this.#adapters.detect(bundle);
    return {
      source: bundle.descriptor,
      candidates,
      meta: statementMeta(this.#clock),
    };
  }

  async previewStatementImport(
    input: PreviewStatementImportInput,
  ): Promise<StatementPreviewResult> {
    const bundle = await this.#vault.readBundle(input.sourceRef);
    const adapter = this.#adapters.get(input.profileId, input.profileVersion);
    if (!adapter) {
      throw new RavenDomainError(
        "STATEMENT_PROFILE_UNSUPPORTED",
        "Statement profile or version is unsupported",
      );
    }
    const account = await this.#repository.getAccount(
      input.spaceKey,
      input.accountKey,
    );
    if (!account)
      throw new RavenDomainError("NOT_FOUND", "Account was not found");
    const extraction = await adapter.extract(bundle);
    const accountContext = reviewedAccountContext(account);
    const issues: StatementIssue[] = [
      ...extraction.issues,
      ...extraction.rows.flatMap((row) => [
        ...row.issues,
        ...row.components.flatMap((component) => component.issues),
      ]),
    ];

    if (account.currency !== extraction.currency) {
      issues.push({
        code: "STATEMENT_CURRENCY_MISMATCH",
        severity: "blocking",
        blocking: true,
        message: "Statement currency does not match the selected account",
      });
    }
    const profileConvention = adapter.profile.balanceConventionAuthority;
    const profileNature =
      profileConvention === "positive_is_asset"
        ? "asset"
        : profileConvention === "positive_is_liability"
          ? "liability"
          : null;
    if (profileNature !== null && account.normalNature !== profileNature) {
      issues.push({
        code: "STATEMENT_ACCOUNT_MISMATCH",
        severity: "blocking",
        blocking: true,
        message:
          "The selected account economic nature does not match the selected statement profile",
      });
    }
    const maskedHint = extraction.accountHints.maskedAccount
      ?.replace(/\D/g, "")
      .slice(-4);
    if (
      maskedHint &&
      account.accountNumberLast4 &&
      maskedHint !== account.accountNumberLast4
    ) {
      issues.push({
        code: "STATEMENT_ACCOUNT_MISMATCH",
        severity: "blocking",
        blocking: true,
        message: "Statement account hint does not match the selected account",
      });
    }

    const allForAccount = await this.#repository.listStatementImports({
      spaceKey: input.spaceKey,
      accountKey: input.accountKey,
    });
    const existingForAccount = allForAccount.filter(
      (item) => item.sourceState !== "superseded",
    );
    const existingForPeriod = existingForAccount.filter(
      (item) =>
        (item.periodStart === extraction.periodStart &&
          item.periodEnd === extraction.periodEnd) ||
        (item.sourceState === "legacy" &&
          item.legacyPeriodEvidence.mapping === "known_renderer_end_date" &&
          item.legacyPeriodEvidence.statementDate === extraction.periodEnd &&
          item.legacyPeriodEvidence.keyDate === extraction.periodEnd),
    );
    const duplicate = existingForAccount.find(
      (item) =>
        item.sourceState === "committed" &&
        item.originalFileSha256 === bundle.descriptor.originalFileSha256,
    );
    const legacyPeriod = existingForPeriod.find(
      (item) => item.sourceState === "legacy",
    );
    const unmappableLegacy = existingForAccount.find(
      (item) =>
        item.sourceState === "legacy" &&
        item.legacyPeriodEvidence.mapping === "unmappable",
    );
    if (legacyPeriod) {
      issues.push({
        code: "STATEMENT_LEGACY_PERIOD_CONFLICT",
        severity: "blocking",
        blocking: true,
        message:
          "A legacy unverified import occupies this exact account period and requires a later aggregate-only compatibility audit",
      });
    } else if (unmappableLegacy) {
      issues.push({
        code: "STATEMENT_LEGACY_COMPATIBILITY_REQUIRED",
        severity: "blocking",
        blocking: true,
        message:
          "An active legacy import cannot be mapped safely to a statement period and requires compatibility review",
      });
    } else if (duplicate) {
      issues.push({
        code: "STATEMENT_DUPLICATE_SOURCE",
        severity: "blocking",
        blocking: true,
        message:
          "This exact source is already committed for the selected account",
      });
    } else if (existingForPeriod.length > 0) {
      issues.push({
        code: "STATEMENT_IMMUTABLE_CONFLICT",
        severity: "blocking",
        blocking: true,
        message:
          "The selected account and period already contain a different committed source",
      });
    }

    const movementComponents = extraction.rows.flatMap((row) =>
      row.components.filter(
        (component) => component.componentRole === "movement",
      ),
    );
    const effectMinor = movementComponents.reduce(
      (total, component) =>
        checkedAdd(
          total,
          component.balanceEffectMinor,
          "Statement movement total",
        ),
      0,
    );
    const expectedClosingBalanceMinor =
      extraction.openingBalanceMinor === null
        ? null
        : checkedAdd(
            extraction.openingBalanceMinor,
            effectMinor,
            "Expected closing balance",
          );
    const differenceMinor =
      expectedClosingBalanceMinor === null ||
      extraction.closingBalanceMinor === null
        ? null
        : checkedAdd(
            expectedClosingBalanceMinor,
            -extraction.closingBalanceMinor,
            "Statement closing balance difference",
          );
    if (differenceMinor !== null && differenceMinor !== 0) {
      issues.push({
        code: "STATEMENT_BALANCE_DIFFERENCE",
        severity: "blocking",
        blocking: true,
        message:
          "Statement movements do not reproduce the reported closing balance",
      });
    }
    const expectedConvention = profileConvention;
    const expectedAccountNature =
      expectedConvention === "positive_is_asset"
        ? "asset"
        : expectedConvention === "positive_is_liability"
          ? "liability"
          : null;
    const closingSnapshotEligible =
      extraction.closingBalanceMinor !== null &&
      extraction.closingBalanceEconomicNature !== null &&
      expectedConvention !== null &&
      expectedConvention === extraction.balanceConvention &&
      expectedAccountNature === account.normalNature;
    if (
      expectedConvention === null ||
      (extraction.closingBalanceMinor !== null &&
        extraction.closingBalanceEconomicNature !== null &&
        !closingSnapshotEligible)
    ) {
      issues.push({
        code: "STATEMENT_BALANCE_CONVENTION_UNVERIFIED",
        severity: "warning",
        blocking: false,
        message:
          "The closing balance is preserved, but its profile/account balance convention is not authoritative enough to create a snapshot",
      });
    }

    const previewIdentity = {
      originalFileSha256: bundle.descriptor.originalFileSha256,
      extractionInputSha256: bundle.descriptor.extractionInputSha256,
      canonicalExtractionSha256: extraction.canonicalExtractionSha256,
      account: { spaceKey: account.spaceKey, accountKey: account.key },
      accountContextFingerprint: accountContext.accountContextFingerprint,
      profile: extraction.profile,
      validationRulesetVersion: STATEMENT_VALIDATION_RULESET_VERSION,
    };
    const previewHash = statementSha256(
      canonicalStatementJson(previewIdentity),
    );
    const warnings = warningCodes(issues);
    return {
      source: bundle.descriptor,
      profile: extraction.profile,
      account: {
        spaceId: account.spaceId,
        accountId: account.id,
        spaceKey: account.spaceKey,
        accountKey: account.key,
        currency: account.currency,
        normalNature: account.normalNature,
        accountNumberLast4: account.accountNumberLast4 ?? null,
        spaceTimezone: accountContext.spaceTimezone,
        accountContextFingerprint: accountContext.accountContextFingerprint,
      },
      extraction,
      rowCount: extraction.rows.length,
      componentCount: extraction.rows.reduce(
        (total, row) => total + row.components.length,
        0,
      ),
      informationalRowCount: extraction.rows.filter(
        (row) =>
          row.rowKind === "informational" ||
          row.components.every(
            (component) =>
              component.componentRole === "informational_breakdown",
          ),
      ).length,
      inflowMinor: movementComponents
        .filter((component) => component.sourceFlow === "inflow")
        .reduce(
          (total, component) =>
            checkedAdd(total, component.amountMinor, "Statement inflow total"),
          0,
        ),
      outflowMinor: movementComponents
        .filter((component) => component.sourceFlow === "outflow")
        .reduce(
          (total, component) =>
            checkedAdd(total, component.amountMinor, "Statement outflow total"),
          0,
        ),
      expectedClosingBalanceMinor,
      reportedClosingBalanceMinor: extraction.closingBalanceMinor,
      differenceMinor,
      duplicateImports: [
        ...new Map(
          [...existingForPeriod, ...(duplicate ? [duplicate] : [])].map(
            (item) => [item.id, item],
          ),
        ).values(),
      ].map((item) => item.id),
      issues,
      previewHash,
      closingSnapshotEligible,
      commitAllowed: !issues.some((item) => item.blocking),
      meta: statementMeta(this.#clock, warnings),
    };
  }

  async validateStatementPreview(
    input: ValidateStatementPreviewInput,
  ): Promise<StatementPreviewResult> {
    const preview = await this.previewStatementImport(input);
    if (preview.previewHash !== input.previewHash) {
      throw new RavenDomainError(
        "STATEMENT_PREVIEW_STALE",
        "Statement preview is stale and must be reviewed again",
      );
    }
    return preview;
  }

  async commitStatementImport(
    input: CommitStatementImportInput,
  ): Promise<StatementCommitResult> {
    const requestHash = statementCommitRequestHash(input);
    const replay = await this.#repository.getCommitOperation(
      input.idempotencyKey,
    );
    if (replay) {
      return resolveCommitReplay(this.#repository, replay, requestHash);
    }
    const preview = await this.validateStatementPreview(input);
    if (!preview.commitAllowed) {
      throw blockingPreviewError(preview.issues);
    }

    const now = this.#clock();
    const account = preview.account;
    const extraction = preview.extraction;
    const importKey = `${extraction.periodEnd}-${preview.source.originalFileSha256.slice(0, 12)}`;
    const warnings = warningCodes(preview.issues);
    const operation: OperationDraft = {
      key: operationKey(input.idempotencyKey),
      command: "commit_statement_import",
      idempotencyKey: input.idempotencyKey,
      requestHash,
      channel: input.channel,
      actorId: input.actorId,
      recordedAt: now,
      warningCodes: warnings,
      auditMeta: {
        contractVersion: STATEMENT_TRUTH_CONTRACT_VERSION,
        profileId: input.profileId,
        profileVersion: input.profileVersion,
        validationRulesetVersion: STATEMENT_VALIDATION_RULESET_VERSION,
        accountContextFingerprint: account.accountContextFingerprint,
      },
    };
    const statementImport: StatementImportDraft = {
      spaceId: account.spaceId,
      accountId: account.accountId,
      spaceKey: account.spaceKey,
      accountKey: account.accountKey,
      key: importKey,
      privateSourceRef: preview.source.sourceRef,
      extractionAssistRef: preview.source.extractionAssistRef,
      originalFileSha256: preview.source.originalFileSha256,
      extractionInputSha256: preview.source.extractionInputSha256,
      canonicalExtractionSha256: extraction.canonicalExtractionSha256,
      previewHash: preview.previewHash,
      sourceKind: preview.source.sourceKind,
      sourceMimeType: preview.source.mimeType,
      sourceByteSize: preview.source.byteSize,
      profile: extraction.profile,
      validationRulesetVersion: STATEMENT_VALIDATION_RULESET_VERSION,
      periodStart: extraction.periodStart,
      periodEnd: extraction.periodEnd,
      currency: extraction.currency,
      balanceConvention: extraction.balanceConvention,
      balanceConventionAuthority: extraction.balanceConventionAuthority,
      accountContextFingerprint: account.accountContextFingerprint,
      openingBalanceMinor: extraction.openingBalanceMinor,
      closingBalanceMinor: extraction.closingBalanceMinor,
      closingBalanceEconomicNature: extraction.closingBalanceEconomicNature,
      coverage: extraction.coverage,
      sourceState: "committed",
      importedAt: now,
      committedAt: now,
      commitOperationId: `financialOperation:${operation.key}`,
      replacementOfId: null,
      rowCount: preview.rowCount,
      componentCount: preview.componentCount,
      issueCount: preview.issues.filter((item) => !item.blocking).length,
      revision: 1,
    };
    const snapshot: BalanceSnapshotDraft | null =
      preview.closingSnapshotEligible &&
      extraction.closingBalanceMinor !== null &&
      extraction.closingBalanceEconomicNature !== null
        ? {
            key: snapshotKey(account.spaceId, account.accountId, importKey),
            spaceId: account.spaceId,
            accountId: account.accountId,
            balanceKind: "statement",
            amountMinor: Math.abs(extraction.closingBalanceMinor),
            currency: extraction.currency,
            economicNature: extraction.closingBalanceEconomicNature,
            asOf: zonedEndOfDay(
              extraction.periodEnd,
              account.spaceTimezone || "Africa/Johannesburg",
            ),
            recordedAt: now,
            evidenceLevel: "observed",
            sourceKind: "statement_closing",
            sourceRef: `statement-import:${importKey}`,
            operationId: `financialOperation:${operation.key}`,
            notes: null,
          }
        : null;
    const draft: StatementCommitDraft = {
      expectedAccountContext: {
        spaceId: account.spaceId,
        accountId: account.accountId,
        spaceKey: account.spaceKey,
        accountKey: account.accountKey,
        currency: account.currency,
        normalNature: account.normalNature,
        accountNumberLast4: account.accountNumberLast4,
        spaceTimezone: account.spaceTimezone,
        accountContextFingerprint: account.accountContextFingerprint,
      },
      statementImport,
      rows: extraction.rows.map(statementRowDraft),
      components: extraction.rows.flatMap((row) =>
        row.components.map((component) =>
          statementComponentDraft(row.rowKey, component),
        ),
      ),
      issues: persistedIssues(preview.issues, now),
      operation,
      snapshot,
    };
    let result;
    try {
      result = await this.#repository.commitStatementImport(draft);
    } catch (error) {
      const concurrentReplay = await this.#repository.getCommitOperation(
        input.idempotencyKey,
      );
      if (!concurrentReplay) throw error;
      return resolveCommitReplay(
        this.#repository,
        concurrentReplay,
        requestHash,
      );
    }
    return {
      statementImport: result.statementImport,
      snapshotId: result.snapshotId,
      receipt: {
        operationId: result.operation.id,
        status: "applied",
        resultRefs: result.operation.resultRefs,
        warningCodes: warnings,
        completedAt:
          result.operation.completedAt ?? result.operation.recordedAt,
      },
    };
  }

  async prepareStatementSupersessionDraft(
    input: ValidateStatementPreviewInput,
    operation: OperationDraft,
    replacementOfId: string,
    allowExactLegacyOverlap = false,
  ): Promise<StatementCommitDraft> {
    const preview = await this.validateStatementPreview(input);
    if (!preview.commitAllowed) {
      const legacyOverlapCodes = new Set([
        "STATEMENT_LEGACY_PERIOD_CONFLICT",
        "STATEMENT_LEGACY_COMPATIBILITY_REQUIRED",
        "STATEMENT_IMMUTABLE_CONFLICT",
      ]);
      const blockingIssues = preview.issues.filter((issue) => issue.blocking);
      const exactLegacyOverlap =
        allowExactLegacyOverlap &&
        blockingIssues.length > 0 &&
        blockingIssues.every((issue) => legacyOverlapCodes.has(issue.code)) &&
        preview.duplicateImports.length === 1 &&
        preview.duplicateImports[0] === replacementOfId;
      if (!exactLegacyOverlap) throw blockingPreviewError(preview.issues);
    }
    const now = operation.recordedAt;
    const account = preview.account;
    const extraction = preview.extraction;
    const importKey = `${extraction.periodEnd}-${preview.source.originalFileSha256.slice(0, 12)}`;
    const statementImport: StatementImportDraft = {
      spaceId: account.spaceId,
      accountId: account.accountId,
      spaceKey: account.spaceKey,
      accountKey: account.accountKey,
      key: importKey,
      privateSourceRef: preview.source.sourceRef,
      extractionAssistRef: preview.source.extractionAssistRef,
      originalFileSha256: preview.source.originalFileSha256,
      extractionInputSha256: preview.source.extractionInputSha256,
      canonicalExtractionSha256: extraction.canonicalExtractionSha256,
      previewHash: preview.previewHash,
      sourceKind: preview.source.sourceKind,
      sourceMimeType: preview.source.mimeType,
      sourceByteSize: preview.source.byteSize,
      profile: extraction.profile,
      validationRulesetVersion: STATEMENT_VALIDATION_RULESET_VERSION,
      periodStart: extraction.periodStart,
      periodEnd: extraction.periodEnd,
      currency: extraction.currency,
      balanceConvention: extraction.balanceConvention,
      balanceConventionAuthority: extraction.balanceConventionAuthority,
      accountContextFingerprint: account.accountContextFingerprint,
      openingBalanceMinor: extraction.openingBalanceMinor,
      closingBalanceMinor: extraction.closingBalanceMinor,
      closingBalanceEconomicNature: extraction.closingBalanceEconomicNature,
      coverage: extraction.coverage,
      sourceState: "committed",
      importedAt: now,
      committedAt: now,
      commitOperationId: `financialOperation:${operation.key}`,
      replacementOfId,
      rowCount: preview.rowCount,
      componentCount: preview.componentCount,
      issueCount: preview.issues.filter((item) => !item.blocking).length,
      revision: 1,
    };
    const snapshot: BalanceSnapshotDraft | null =
      preview.closingSnapshotEligible &&
      extraction.closingBalanceMinor !== null &&
      extraction.closingBalanceEconomicNature !== null
        ? {
            key: snapshotKey(account.spaceId, account.accountId, importKey),
            spaceId: account.spaceId,
            accountId: account.accountId,
            balanceKind: "statement",
            amountMinor: Math.abs(extraction.closingBalanceMinor),
            currency: extraction.currency,
            economicNature: extraction.closingBalanceEconomicNature,
            asOf: zonedEndOfDay(
              extraction.periodEnd,
              account.spaceTimezone || "Africa/Johannesburg",
            ),
            recordedAt: now,
            evidenceLevel: "observed",
            sourceKind: "statement_closing",
            sourceRef: `statement-import:${importKey}`,
            operationId: `financialOperation:${operation.key}`,
            notes: null,
          }
        : null;
    return {
      expectedAccountContext: {
        spaceId: account.spaceId,
        accountId: account.accountId,
        spaceKey: account.spaceKey,
        accountKey: account.accountKey,
        currency: account.currency,
        normalNature: account.normalNature,
        accountNumberLast4: account.accountNumberLast4,
        spaceTimezone: account.spaceTimezone,
        accountContextFingerprint: account.accountContextFingerprint,
      },
      statementImport,
      rows: extraction.rows.map(statementRowDraft),
      components: extraction.rows.flatMap((row) =>
        row.components.map((component) =>
          statementComponentDraft(row.rowKey, component),
        ),
      ),
      issues: persistedIssues(preview.issues, now),
      operation,
      snapshot,
    };
  }

  async listStatementImports(input: ListStatementImportsInput) {
    return {
      imports: await this.#repository.listStatementImports(input),
      meta: statementMeta(this.#clock),
    };
  }

  async getStatementImport(input: GetStatementImportInput) {
    const statementImport = await this.#repository.getStatementImport(
      input.statementImportId,
    );
    if (!statementImport)
      throw new RavenDomainError("NOT_FOUND", "Statement import was not found");
    const [rows, components, issues] = await Promise.all([
      this.#repository.listStatementRows(statementImport.id),
      this.#repository.listStatementRowComponents({
        statementImportId: statementImport.id,
      }),
      this.#repository.listStatementIssues(statementImport.id),
    ]);
    return {
      statementImport,
      rows,
      components,
      issues,
      meta: statementMeta(this.#clock),
    };
  }

  async listStatementRows(input: ListStatementRowsInput) {
    return {
      rows: await this.#repository.listStatementRows(input.statementImportId),
      meta: statementMeta(this.#clock),
    };
  }

  async getStatementRow(input: GetStatementRowInput) {
    const row = await this.#repository.getStatementRow(input.statementRowId);
    if (!row)
      throw new RavenDomainError("NOT_FOUND", "Statement row was not found");
    const [components, allIssues] = await Promise.all([
      this.#repository.listStatementRowComponents({ statementRowId: row.id }),
      this.#repository.listStatementIssues(row.statementImportId),
    ]);
    return {
      row,
      components,
      issues: allIssues.filter((item) => item.statementRowId === row.id),
      meta: statementMeta(this.#clock),
    };
  }

  async listStatementRowComponents(input: ListStatementRowComponentsInput) {
    if (!input.statementImportId && !input.statementRowId) {
      throw new RavenDomainError(
        "STATEMENT_EXTRACTION_INVALID",
        "A statement import or row is required",
      );
    }
    return {
      components: await this.#repository.listStatementRowComponents(input),
      meta: statementMeta(this.#clock),
    };
  }

  async getStatementRowComponent(input: GetStatementRowComponentInput) {
    const component = await this.#repository.getStatementRowComponent(
      input.statementRowComponentId,
    );
    if (!component) {
      throw new RavenDomainError(
        "NOT_FOUND",
        "Statement row component was not found",
      );
    }
    return { component, meta: statementMeta(this.#clock) };
  }

  async listStatementImportIssues(input: ListStatementImportIssuesInput) {
    return {
      issues: await this.#repository.listStatementIssues(
        input.statementImportId,
      ),
      meta: statementMeta(this.#clock),
    };
  }

  async getStatementImportIssue(input: GetStatementImportIssueInput) {
    const issue = await this.#repository.getStatementIssue(
      input.statementIssueId,
    );
    if (!issue)
      throw new RavenDomainError("NOT_FOUND", "Statement issue was not found");
    return { issue, meta: statementMeta(this.#clock) };
  }
}

export function createStatementTruthService(
  options: StatementTruthServiceOptions,
): StatementTruthApi {
  return new StatementTruthService(options);
}
