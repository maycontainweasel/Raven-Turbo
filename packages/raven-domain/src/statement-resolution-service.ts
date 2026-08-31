import { createHash, randomUUID } from "node:crypto";
import type { TransactionRecord } from "./contracts.js";
import { RavenDomainError } from "./errors.js";
import {
  canonicalStatementJson,
  statementSha256,
} from "./statement-adapters.js";
import type { OperationDraft } from "./repository.js";
import type {
  StatementImportRecord,
  StatementQueryMeta,
  StatementRowComponentRecord,
} from "./statement-contracts.js";
import type {
  StatementCommitDraft,
  StatementReviewedAccountContext,
  StatementTruthRepository,
} from "./statement-repository.js";
import {
  assertStatementComponentBundle,
  calculateStatementReconciliation,
  deriveStatementComponentResolutions,
  generateStatementMatchCandidates,
  retryStatementReconciliationMutation,
  statementCheckedAdd,
  statementMatchAcceptedDates,
} from "./statement-resolution.js";
import type {
  AcknowledgeStatementIssueInput,
  AttestStatementReconciledInput,
  ConfirmStatementTransactionMatchInput,
  GetStatementReconciliationInput,
  GetStatementTransactionMatchInput,
  ListStatementMatchCandidatesInput,
  ListStatementTransactionMatchesInput,
  MaterializeStatementComponentTransactionInput,
  ProposeStatementTransactionMatchInput,
  RecalculateStatementReconciliationInput,
  RejectStatementTransactionMatchInput,
  ReopenStatementReconciliationInput,
  StatementImportSupersessionResult,
  StatementMatchMutationResult,
  StatementMaterializationResult,
  StatementReconciliationMutationResult,
  StatementResolutionApi,
  StatementResolutionCommandMeta,
  StatementResolutionReceipt,
  StatementTransactionMatchRecord,
  SupersedeStatementImportInput,
  SupersedeStatementTransactionMatchInput,
} from "./statement-resolution-contracts.js";
import type {
  StatementImportSupersessionDraft,
  StatementMatchDraft,
  StatementMatchValidation,
  StatementReconciliationDraft,
  StatementResolutionCommand,
  StatementResolutionOperation,
  StatementResolutionRepository,
} from "./statement-resolution-repository.js";

type StatementResolutionServiceOptions = Readonly<{
  sourceRepository: StatementTruthRepository;
  repository: StatementResolutionRepository;
  clock?: () => string;
  prepareSourceSupersession?: (
    input: SupersedeStatementImportInput,
    operation: OperationDraft,
  ) => Promise<StatementCommitDraft>;
}>;

function resolutionMeta(clock: () => string): StatementQueryMeta {
  return {
    requestId: randomUUID(),
    generatedAt: clock(),
    contractVersion: "statement-truth-v0.1",
    warnings: [],
  };
}

function operationKey(
  command: StatementResolutionCommand,
  idempotencyKey: string,
): string {
  return `statement-${createHash("sha256")
    .update(`${command}:${idempotencyKey}`)
    .digest("hex")
    .slice(0, 32)}`;
}

function resolutionRequestHash(
  command: StatementResolutionCommand,
  input: unknown,
): string {
  return statementSha256(canonicalStatementJson({ command, input }));
}

function operationDraft(
  command: StatementResolutionCommand,
  input: StatementResolutionCommandMeta,
  request: unknown,
  recordedAt: string,
): OperationDraft {
  return {
    key: operationKey(command, input.idempotencyKey),
    command,
    idempotencyKey: input.idempotencyKey,
    requestHash: resolutionRequestHash(command, request),
    channel: input.channel,
    actorId: input.actorId,
    recordedAt,
    warningCodes: [],
    auditMeta: {
      contractVersion: "statement-truth-v0.1",
      workline: "ST-02",
    },
  };
}

function receipt(
  operation: StatementResolutionOperation,
  status: "applied" | "replayed",
): StatementResolutionReceipt {
  return {
    operationId: operation.id,
    status,
    resultRefs: operation.resultRefs,
    warningCodes: operation.warningCodes.filter((code) =>
      code.startsWith("STATEMENT_"),
    ) as StatementResolutionReceipt["warningCodes"],
    completedAt: operation.completedAt ?? operation.recordedAt,
  };
}

function assertReplayHash(
  operation: StatementResolutionOperation,
  expectedHash: string,
): void {
  if (operation.requestHash !== expectedHash) {
    throw new RavenDomainError(
      "IDEMPOTENCY_CONFLICT",
      "Idempotency key was already used for a different statement resolution command",
    );
  }
}

function statementRef(
  operation: StatementResolutionOperation,
  prefix: string,
): string | null {
  return operation.resultRefs.find((ref) => ref.startsWith(prefix)) ?? null;
}

function matchKey(
  statementImportId: string,
  componentIds: readonly string[],
  transactionId: string,
  suffix = "",
): string {
  return createHash("sha256")
    .update(
      canonicalStatementJson({
        statementImportId,
        componentIds: [...componentIds].sort(),
        transactionId,
        suffix,
      }),
    )
    .digest("hex")
    .slice(0, 32);
}

function importedTransactionKey(
  statementImportId: string,
  components: readonly StatementRowComponentRecord[],
): string {
  return `statement-${createHash("sha256")
    .update(
      canonicalStatementJson({
        statementImportId,
        components: components.map((component) => ({
          id: component.id,
          sourceChecksum: component.sourceChecksum,
        })),
      }),
    )
    .digest("hex")
    .slice(0, 32)}`;
}

function componentTotal(
  components: readonly StatementRowComponentRecord[],
): number {
  return components.reduce(
    (total, component) =>
      statementCheckedAdd(
        total,
        component.balanceEffectMinor,
        "Statement match component total",
      ),
    0,
  );
}

function flowForTotal(total: number): "inflow" | "outflow" {
  if (total === 0) {
    throw new RavenDomainError(
      "STATEMENT_COMPONENT_TOTAL_MISMATCH",
      "Movement component total cannot be zero",
    );
  }
  return total > 0 ? "inflow" : "outflow";
}

function transactionKindForComponents(
  components: readonly StatementRowComponentRecord[],
  flow: "inflow" | "outflow",
): "income" | "expense" | "adjustment" {
  if (
    components.some((component) => component.componentKind === "adjustment")
  ) {
    return "adjustment";
  }
  return flow === "inflow" ? "income" : "expense";
}

function matchDraft(input: {
  statementImport: StatementImportRecord;
  components: readonly StatementRowComponentRecord[];
  transactionId: string;
  method: StatementMatchDraft["method"];
  reasonCodes: StatementMatchDraft["reasonCodes"];
  confidence: number;
  actorId: string | null;
  proposedAt: string;
  proposedOperationId: string;
  supersedesId?: string | null;
  suffix?: string;
}): StatementMatchDraft {
  const componentIds = input.components.map((component) => component.id).sort();
  return {
    key: matchKey(
      input.statementImport.id,
      componentIds,
      input.transactionId,
      input.suffix,
    ),
    spaceId: input.statementImport.spaceId,
    accountId: input.statementImport.accountId,
    statementImportId: input.statementImport.id,
    componentIds,
    transactionId: input.transactionId,
    method: input.method,
    reasonCodes: input.reasonCodes,
    confidence: input.confidence,
    signedComponentTotalMinor: componentTotal(input.components),
    currency: input.statementImport.currency,
    proposedBy: input.actorId,
    proposedAt: input.proposedAt,
    proposedOperationId: input.proposedOperationId,
    supersedesId: input.supersedesId ?? null,
  };
}

function matchValidation(
  statementImport: StatementImportRecord,
  components: readonly StatementRowComponentRecord[],
  transaction: TransactionRecord,
): StatementMatchValidation {
  const bundle = assertStatementComponentBundle(components);
  const signedComponentTotalMinor = componentTotal(components);
  const amountMinor = transaction.amountMinor;
  const flowDirection = flowForTotal(signedComponentTotalMinor);
  if (
    amountMinor === null ||
    transaction.accountId !== statementImport.accountId ||
    transaction.currency !== statementImport.currency ||
    amountMinor !== Math.abs(signedComponentTotalMinor) ||
    transaction.flowDirection !== flowDirection ||
    !transaction.postedAt
  ) {
    throw new RavenDomainError(
      "STATEMENT_TRANSACTION_INELIGIBLE",
      "Transaction no longer satisfies the exact statement match invariants",
    );
  }
  return {
    componentIds: components.map((component) => component.id).sort(),
    componentChecksums: components
      .map((component) => component.sourceChecksum)
      .sort(),
    transactionId: transaction.id,
    accountId: statementImport.accountId,
    currency: statementImport.currency,
    signedComponentTotalMinor,
    transactionAmountMinor: amountMinor,
    flowDirection,
    acceptedTransactionDates: statementMatchAcceptedDates(components),
    sourceRowId: bundle.sourceRowId,
    canonicalFinancialDate: bundle.canonicalFinancialDate,
  };
}

function reviewedResolutionAccountContext(input: {
  id: string;
  spaceId: string;
  spaceKey: string;
  key: string;
  currency: string;
  normalNature: "asset" | "liability";
  accountNumberLast4?: string | null;
  spaceTimezone: string;
}): StatementReviewedAccountContext {
  const context = {
    spaceId: input.spaceId,
    accountId: input.id,
    spaceKey: input.spaceKey,
    accountKey: input.key,
    currency: input.currency,
    normalNature: input.normalNature,
    accountNumberLast4: input.accountNumberLast4 ?? null,
    spaceTimezone: input.spaceTimezone || "Africa/Johannesburg",
  };
  return {
    ...context,
    accountContextFingerprint: statementSha256(canonicalStatementJson(context)),
  };
}

export class StatementResolutionService implements StatementResolutionApi {
  readonly #sourceRepository: StatementTruthRepository;
  readonly #repository: StatementResolutionRepository;
  readonly #clock: () => string;
  readonly #prepareSourceSupersession?: StatementResolutionServiceOptions["prepareSourceSupersession"];

  constructor(options: StatementResolutionServiceOptions) {
    this.#sourceRepository = options.sourceRepository;
    this.#repository = options.repository;
    this.#clock = options.clock ?? (() => new Date().toISOString());
    this.#prepareSourceSupersession = options.prepareSourceSupersession;
  }

  async #requireReadableImport(id: string): Promise<StatementImportRecord> {
    const statementImport = await this.#sourceRepository.getStatementImport(id);
    if (!statementImport) {
      throw new RavenDomainError("NOT_FOUND", "Statement import was not found");
    }
    if (
      statementImport.sourceState !== "committed" &&
      statementImport.sourceState !== "superseded"
    ) {
      throw new RavenDomainError(
        "STATEMENT_TRANSACTION_INELIGIBLE",
        "Only an active ST-01 committed source can enter matching",
      );
    }
    return statementImport;
  }

  async #requireActiveImport(id: string): Promise<StatementImportRecord> {
    const statementImport = await this.#requireReadableImport(id);
    if (statementImport.sourceState !== "committed") {
      throw new RavenDomainError(
        "STATEMENT_IMPORT_SUPERSEDED",
        "Statement import has been superseded",
      );
    }
    return statementImport;
  }

  async #requireComponents(
    statementImport: StatementImportRecord,
    componentIds: readonly string[],
  ): Promise<StatementRowComponentRecord[]> {
    const uniqueIds = [...new Set(componentIds)].sort();
    if (uniqueIds.length === 0 || uniqueIds.length !== componentIds.length) {
      throw new RavenDomainError(
        "STATEMENT_COMPONENT_TOTAL_MISMATCH",
        "One or more unique movement components are required",
      );
    }
    const all = await this.#sourceRepository.listStatementRowComponents({
      statementImportId: statementImport.id,
    });
    const selected = uniqueIds.map((id) => all.find((item) => item.id === id));
    if (selected.some((item) => !item)) {
      throw new RavenDomainError(
        "NOT_FOUND",
        "One or more statement components were not found in the selected import",
      );
    }
    const components = selected as StatementRowComponentRecord[];
    if (
      components.some(
        (component) =>
          component.componentRole !== "movement" ||
          component.sourceState !== "committed" ||
          component.accountId !== statementImport.accountId ||
          component.currency !== statementImport.currency,
      )
    ) {
      throw new RavenDomainError(
        "STATEMENT_TRANSACTION_INELIGIBLE",
        "Only active same-account, same-currency movement components can be resolved",
      );
    }
    assertStatementComponentBundle(components);
    return components;
  }

  async #requireCurrentAccountContext(
    statementImport: StatementImportRecord,
  ): Promise<StatementReviewedAccountContext> {
    const account = await this.#sourceRepository.getAccount(
      statementImport.spaceKey,
      statementImport.accountKey,
    );
    if (!account) {
      throw new RavenDomainError(
        "STATEMENT_ACCOUNT_CONTEXT_STALE",
        "The statement Account context is no longer active",
      );
    }
    const context = reviewedResolutionAccountContext(account);
    if (
      context.accountId !== statementImport.accountId ||
      context.spaceId !== statementImport.spaceId ||
      context.currency !== statementImport.currency ||
      context.accountContextFingerprint !==
        statementImport.accountContextFingerprint
    ) {
      throw new RavenDomainError(
        "STATEMENT_ACCOUNT_CONTEXT_STALE",
        "The statement Account context changed after source review",
      );
    }
    return context;
  }

  async #assertClientReconciliationExpectation(
    statementImportId: string,
    expected: {
      expectedReconciliationRevision: number | null;
      expectedReconciliationHash: string | null;
    },
  ): Promise<void> {
    const current =
      await this.#repository.getStatementReconciliation(statementImportId);
    if (
      (current?.revision ?? null) !== expected.expectedReconciliationRevision ||
      (current?.calculationHash ?? null) !== expected.expectedReconciliationHash
    ) {
      throw new RavenDomainError(
        "STATEMENT_RECONCILIATION_STALE",
        "Reconciliation authority changed",
      );
    }
  }

  async #allMatches(statementImportId: string) {
    return this.#repository.listStatementTransactionMatches({
      statementImportId,
      includeSuperseded: true,
    });
  }

  async #calculateDraft(
    statementImport: StatementImportRecord,
    operationId: string,
    overrides: {
      matches?: readonly StatementTransactionMatchRecord[];
      issues?: Awaited<
        ReturnType<StatementTruthRepository["listStatementIssues"]>
      >;
    } = {},
  ): Promise<{
    reconciliation: StatementReconciliationDraft;
    expectedReconciliationRevision: number | null;
    expectedReconciliationHash: string | null;
  }> {
    const [
      rows,
      components,
      storedIssues,
      storedMatches,
      previous,
      transactions,
    ] = await Promise.all([
      this.#sourceRepository.listStatementRows(statementImport.id),
      this.#sourceRepository.listStatementRowComponents({
        statementImportId: statementImport.id,
      }),
      this.#sourceRepository.listStatementIssues(statementImport.id),
      this.#allMatches(statementImport.id),
      this.#repository.getStatementReconciliation(statementImport.id),
      this.#repository.listCandidateTransactions({
        spaceId: statementImport.spaceId,
        accountId: statementImport.accountId,
        periodStart: statementImport.periodStart,
        periodEnd: statementImport.periodEnd,
        includeCounterpartAccounts: true,
      }),
    ]);
    const issues = overrides.issues ?? storedIssues;
    const matches = overrides.matches ?? storedMatches;
    const resolutions = deriveStatementComponentResolutions({
      components,
      matches,
    });
    const transferCandidateComponentIds = resolutions
      .filter(
        (resolution) =>
          resolution.component.componentRole === "movement" &&
          !resolution.activeMatch &&
          generateStatementMatchCandidates({
            components: [resolution.component],
            transactions,
          }).some((candidate) => candidate.transferCandidate),
      )
      .map((resolution) => resolution.component.id);
    return {
      reconciliation: calculateStatementReconciliation({
        statementImport,
        rows,
        components,
        issues,
        matches,
        previous,
        operationId,
        calculatedAt: this.#clock(),
        transferCandidateComponentIds,
      }),
      expectedReconciliationRevision: previous?.revision ?? null,
      expectedReconciliationHash: previous?.calculationHash ?? null,
    };
  }

  async listStatementMatchCandidates(input: ListStatementMatchCandidatesInput) {
    const statementImport = await this.#requireActiveImport(
      input.statementImportId,
    );
    const components = await this.#requireComponents(
      statementImport,
      input.componentIds,
    );
    const [transactions, matches] = await Promise.all([
      this.#repository.listCandidateTransactions({
        spaceId: statementImport.spaceId,
        accountId: statementImport.accountId,
        periodStart: statementImport.periodStart,
        periodEnd: statementImport.periodEnd,
        includeCounterpartAccounts: true,
      }),
      this.#allMatches(statementImport.id),
    ]);
    return {
      candidates: generateStatementMatchCandidates({
        components,
        transactions,
        matches,
        explicitTransactionId: input.explicitTransactionId,
      }),
      components: deriveStatementComponentResolutions({
        components,
        matches,
      }),
      meta: resolutionMeta(this.#clock),
    };
  }

  async listStatementTransactionMatches(
    input: ListStatementTransactionMatchesInput,
  ) {
    await this.#requireReadableImport(input.statementImportId);
    return {
      matches: await this.#repository.listStatementTransactionMatches(input),
      meta: resolutionMeta(this.#clock),
    };
  }

  async getStatementTransactionMatch(input: GetStatementTransactionMatchInput) {
    const match = await this.#repository.getStatementTransactionMatch(
      input.statementTransactionMatchId,
    );
    if (!match) {
      throw new RavenDomainError(
        "NOT_FOUND",
        "Statement transaction match was not found",
      );
    }
    return { match, meta: resolutionMeta(this.#clock) };
  }

  async getStatementReconciliation(input: GetStatementReconciliationInput) {
    const statementImport = await this.#requireReadableImport(
      input.statementImportId,
    );
    const [reconciliation, events, components, matches, issues] =
      await Promise.all([
        this.#repository.getStatementReconciliation(statementImport.id),
        this.#repository.listStatementReconciliationEvents(statementImport.id),
        this.#sourceRepository.listStatementRowComponents({
          statementImportId: statementImport.id,
        }),
        this.#allMatches(statementImport.id),
        this.#sourceRepository.listStatementIssues(statementImport.id),
      ]);
    return {
      reconciliation,
      events,
      components: deriveStatementComponentResolutions({ components, matches }),
      issues,
      meta: resolutionMeta(this.#clock),
    };
  }

  async #replayedMatch(
    operation: StatementResolutionOperation,
    expectedHash: string,
  ): Promise<StatementMatchMutationResult> {
    assertReplayHash(operation, expectedHash);
    const matchId = statementRef(operation, "statementTransactionMatch:");
    const match = matchId
      ? await this.#repository.getStatementTransactionMatch(matchId)
      : null;
    if (!match)
      throw new RavenDomainError("INTERNAL", "Match replay is unavailable");
    return {
      match,
      reconciliation: await this.#repository.getStatementReconciliation(
        match.statementImportId,
      ),
      receipt: receipt(operation, "replayed"),
    };
  }

  async proposeStatementTransactionMatch(
    input: ProposeStatementTransactionMatchInput,
  ) {
    const command = "propose_statement_transaction_match" as const;
    const now = this.#clock();
    const operation = operationDraft(command, input, input, now);
    const replay = await this.#repository.getResolutionOperation(
      command,
      input.idempotencyKey,
    );
    if (replay) return this.#replayedMatch(replay, operation.requestHash);
    const statementImport = await this.#requireActiveImport(
      input.statementImportId,
    );
    await this.#assertClientReconciliationExpectation(
      statementImport.id,
      input,
    );
    const components = await this.#requireComponents(
      statementImport,
      input.componentIds,
    );
    const transaction = await this.#repository.getResolutionTransaction(
      input.transactionId,
    );
    if (!transaction)
      throw new RavenDomainError("NOT_FOUND", "Transaction was not found");
    const candidates = generateStatementMatchCandidates({
      components,
      transactions: [transaction],
    });
    const candidate = candidates.find(
      (item) =>
        item.transactionId === transaction.id && !item.transferCandidate,
    );
    if (!candidate) {
      throw new RavenDomainError(
        "STATEMENT_TRANSACTION_INELIGIBLE",
        "Transaction does not satisfy the exact Account, currency, amount, direction, and date policy",
      );
    }
    const draft = matchDraft({
      statementImport,
      components,
      transactionId: transaction.id,
      method: candidate.method,
      reasonCodes: candidate.reasonCodes,
      confidence: candidate.confidence,
      actorId: input.actorId ?? null,
      proposedAt: now,
      proposedOperationId: `financialOperation:${operation.key}`,
    });
    const projected: StatementTransactionMatchRecord = {
      id: await this.#repository.getStatementTransactionMatchIdentity(
        statementImport.id,
        draft.key,
      ),
      ...draft,
      primaryComponentId: draft.componentIds[0]!,
      state: "proposed",
      revision: 1,
      confirmedOperationId: null,
      rejectedOperationId: null,
      supersededOperationId: null,
      reviewedBy: null,
      confirmedAt: null,
      rejectedAt: null,
      supersededAt: null,
      rejectionReason: null,
      supersessionReason: null,
      supersededById: null,
      sourceState: "committed",
    };
    const result = await retryStatementReconciliationMutation(
      async () =>
        this.#calculateDraft(
          statementImport,
          `financialOperation:${operation.key}`,
          {
            matches: [
              ...(await this.#allMatches(statementImport.id)),
              projected,
            ],
          },
        ),
      async (calculated) =>
        this.#repository.proposeStatementTransactionMatch({
          match: draft,
          validation: matchValidation(statementImport, components, transaction),
          operation,
          ...calculated,
        }),
    );
    return {
      match: result.match,
      reconciliation: result.reconciliation,
      receipt: receipt(result.operation, "applied"),
    };
  }

  async confirmStatementTransactionMatch(
    input: ConfirmStatementTransactionMatchInput,
  ) {
    const command = "confirm_statement_transaction_match" as const;
    const now = this.#clock();
    const operation = operationDraft(command, input, input, now);
    const replay = await this.#repository.getResolutionOperation(
      command,
      input.idempotencyKey,
    );
    if (replay) return this.#replayedMatch(replay, operation.requestHash);
    const match = await this.#repository.getStatementTransactionMatch(
      input.statementTransactionMatchId,
    );
    if (!match) throw new RavenDomainError("NOT_FOUND", "Match was not found");
    if (
      match.state !== "proposed" ||
      match.revision !== input.expectedRevision
    ) {
      throw new RavenDomainError(
        "STATEMENT_MATCH_CONFLICT",
        "Statement match state or revision changed",
      );
    }
    const statementImport = await this.#requireActiveImport(
      match.statementImportId,
    );
    await this.#assertClientReconciliationExpectation(
      statementImport.id,
      input,
    );
    const components = await this.#requireComponents(
      statementImport,
      match.componentIds,
    );
    const transaction = await this.#repository.getResolutionTransaction(
      match.transactionId,
    );
    if (!transaction) {
      throw new RavenDomainError("NOT_FOUND", "Transaction was not found");
    }
    const candidates = generateStatementMatchCandidates({
      components,
      transactions: [transaction],
    });
    const candidate = candidates.find(
      (item) =>
        item.transactionId === transaction.id && !item.transferCandidate,
    );
    if (!candidate) {
      throw new RavenDomainError(
        transaction.statementMatchId
          ? "STATEMENT_TRANSACTION_ALREADY_MATCHED"
          : "STATEMENT_TRANSACTION_INELIGIBLE",
        transaction.statementMatchId
          ? "Transaction is already backed by another active statement match"
          : "Transaction no longer satisfies the exact statement match invariants",
      );
    }
    if (
      match.method !== candidate.method ||
      match.confidence !== candidate.confidence ||
      canonicalStatementJson(match.reasonCodes) !==
        canonicalStatementJson(candidate.reasonCodes)
    ) {
      throw new RavenDomainError(
        "STATEMENT_MATCH_CONFLICT",
        "Persisted match evidence no longer equals server-derived evidence",
      );
    }
    const projected: StatementTransactionMatchRecord = {
      ...match,
      state: "confirmed",
      revision: match.revision + 1,
      confirmedOperationId: `financialOperation:${operation.key}`,
      confirmedAt: now,
      reviewedBy: input.actorId ?? null,
    };
    const result = await retryStatementReconciliationMutation(
      async () =>
        this.#calculateDraft(
          statementImport,
          `financialOperation:${operation.key}`,
          {
            matches: (await this.#allMatches(statementImport.id)).map((item) =>
              item.id === match.id ? projected : item,
            ),
          },
        ),
      async (calculated) =>
        this.#repository.confirmStatementTransactionMatch({
          matchId: match.id,
          expectedRevision: input.expectedRevision,
          validation: matchValidation(statementImport, components, transaction),
          actorId: input.actorId ?? null,
          confirmedAt: now,
          operation,
          ...calculated,
        }),
    );
    return {
      match: result.match,
      reconciliation: result.reconciliation,
      receipt: receipt(result.operation, "applied"),
    };
  }

  async materializeStatementComponentTransaction(
    input: MaterializeStatementComponentTransactionInput,
  ): Promise<StatementMaterializationResult> {
    const command = "materialize_statement_component_transaction" as const;
    const now = this.#clock();
    const operation = operationDraft(command, input, input, now);
    const replay = await this.#repository.getResolutionOperation(
      command,
      input.idempotencyKey,
    );
    if (replay) {
      assertReplayHash(replay, operation.requestHash);
      const matchId = statementRef(replay, "statementTransactionMatch:");
      const transactionId = statementRef(replay, "transaction:");
      const match = matchId
        ? await this.#repository.getStatementTransactionMatch(matchId)
        : null;
      if (!match || !transactionId) {
        throw new RavenDomainError(
          "INTERNAL",
          "Materialization replay is unavailable",
        );
      }
      return {
        transactionId,
        match,
        reconciliation: await this.#repository.getStatementReconciliation(
          match.statementImportId,
        ),
        receipt: receipt(replay, "replayed"),
      };
    }
    const statementImport = await this.#requireActiveImport(
      input.statementImportId,
    );
    const components = await this.#requireComponents(
      statementImport,
      input.componentIds,
    );
    const candidateTransactions =
      await this.#repository.listCandidateTransactions({
        spaceId: statementImport.spaceId,
        accountId: statementImport.accountId,
        periodStart: statementImport.periodStart,
        periodEnd: statementImport.periodEnd,
        includeCounterpartAccounts: true,
      });
    if (
      generateStatementMatchCandidates({
        components,
        transactions: candidateTransactions,
      }).some((candidate) => candidate.transferCandidate)
    ) {
      throw new RavenDomainError(
        "STATEMENT_TRANSFER_REVIEW_REQUIRED",
        "A plausible tracked-account transfer must be reviewed and matched explicitly before materialization",
      );
    }
    const total = componentTotal(components);
    const flow = flowForTotal(total);
    const financialDate =
      assertStatementComponentBundle(components).canonicalFinancialDate;
    const transactionKey = importedTransactionKey(
      statementImport.id,
      components,
    );
    const transactionId = await this.#repository.getImportedTransactionIdentity(
      statementImport.accountId,
      transactionKey,
    );
    const draft = matchDraft({
      statementImport,
      components,
      transactionId,
      method: "created_from_component",
      reasonCodes: ["CREATED_FROM_COMPONENT"],
      confidence: 1,
      actorId: input.actorId ?? null,
      proposedAt: now,
      proposedOperationId: `financialOperation:${operation.key}`,
    });
    const projected: StatementTransactionMatchRecord = {
      id: await this.#repository.getStatementTransactionMatchIdentity(
        statementImport.id,
        draft.key,
      ),
      ...draft,
      primaryComponentId: draft.componentIds[0]!,
      state: "confirmed",
      revision: 1,
      confirmedOperationId: `financialOperation:${operation.key}`,
      rejectedOperationId: null,
      supersededOperationId: null,
      reviewedBy: input.actorId ?? null,
      confirmedAt: now,
      rejectedAt: null,
      supersededAt: null,
      rejectionReason: null,
      supersessionReason: null,
      supersededById: null,
      sourceState: "committed",
    };
    const componentKind = transactionKindForComponents(components, flow);
    const result = await retryStatementReconciliationMutation(
      async () =>
        this.#calculateDraft(
          statementImport,
          `financialOperation:${operation.key}`,
          {
            matches: [
              ...(await this.#allMatches(statementImport.id)),
              projected,
            ],
          },
        ),
      async (calculated) =>
        this.#repository.materializeStatementComponentTransaction({
          statementImportId: statementImport.id,
          componentIds: draft.componentIds,
          componentChecksums: components
            .map((component) => component.sourceChecksum)
            .sort(),
          transferCandidateDates: statementMatchAcceptedDates(components),
          transaction: {
            key: transactionKey,
            spaceId: statementImport.spaceId,
            accountId: statementImport.accountId,
            sourceRowId: components[0]!.statementRowId,
            sourceChecksum: statementSha256(
              canonicalStatementJson(
                components.map((component) => component.sourceChecksum),
              ),
            ),
            postedAt: financialDate,
            effectiveAt: financialDate,
            description:
              components.length === 1
                ? components[0]!.description
                : `Statement component group (${components.length})`,
            amountMinor: Math.abs(total),
            currency: statementImport.currency,
            direction: flow === "inflow" ? "credit" : "debit",
            transactionKind: componentKind,
            flowDirection: flow,
            recordedAt: now,
            operationId: `financialOperation:${operation.key}`,
          },
          match: draft,
          operation,
          ...calculated,
        }),
    );
    return {
      transactionId: result.transaction.id,
      match: result.match,
      reconciliation: result.reconciliation,
      receipt: receipt(result.operation, "applied"),
    };
  }

  async rejectStatementTransactionMatch(
    input: RejectStatementTransactionMatchInput,
  ) {
    const command = "reject_statement_transaction_match" as const;
    const now = this.#clock();
    const operation = operationDraft(command, input, input, now);
    const replay = await this.#repository.getResolutionOperation(
      command,
      input.idempotencyKey,
    );
    if (replay) return this.#replayedMatch(replay, operation.requestHash);
    const match = await this.#repository.getStatementTransactionMatch(
      input.statementTransactionMatchId,
    );
    if (!match) throw new RavenDomainError("NOT_FOUND", "Match was not found");
    if (
      match.state !== "proposed" ||
      match.revision !== input.expectedRevision
    ) {
      throw new RavenDomainError(
        "STATEMENT_MATCH_CONFLICT",
        "Match cannot be rejected in its current state",
      );
    }
    const statementImport = await this.#requireActiveImport(
      match.statementImportId,
    );
    await this.#assertClientReconciliationExpectation(
      statementImport.id,
      input,
    );
    const projected = {
      ...match,
      state: "rejected" as const,
      revision: match.revision + 1,
      rejectedOperationId: `financialOperation:${operation.key}`,
      rejectedAt: now,
      rejectionReason: input.reason,
      reviewedBy: input.actorId ?? null,
    };
    const result = await retryStatementReconciliationMutation(
      async () =>
        this.#calculateDraft(
          statementImport,
          `financialOperation:${operation.key}`,
          {
            matches: (await this.#allMatches(statementImport.id)).map((item) =>
              item.id === match.id ? projected : item,
            ),
          },
        ),
      async (calculated) =>
        this.#repository.rejectStatementTransactionMatch({
          matchId: match.id,
          expectedRevision: input.expectedRevision,
          reason: input.reason,
          actorId: input.actorId ?? null,
          rejectedAt: now,
          operation,
          ...calculated,
        }),
    );
    return {
      match: result.match,
      reconciliation: result.reconciliation,
      receipt: receipt(result.operation, "applied"),
    };
  }

  async supersedeStatementTransactionMatch(
    input: SupersedeStatementTransactionMatchInput,
  ) {
    const command = "supersede_statement_transaction_match" as const;
    const now = this.#clock();
    const operation = operationDraft(command, input, input, now);
    const replay = await this.#repository.getResolutionOperation(
      command,
      input.idempotencyKey,
    );
    if (replay) return this.#replayedMatch(replay, operation.requestHash);
    const oldMatch = await this.#repository.getStatementTransactionMatch(
      input.statementTransactionMatchId,
    );
    if (!oldMatch)
      throw new RavenDomainError("NOT_FOUND", "Match was not found");
    if (
      oldMatch.revision !== input.expectedRevision ||
      oldMatch.state === "superseded"
    ) {
      throw new RavenDomainError(
        "STATEMENT_MATCH_CONFLICT",
        "Match revision changed",
      );
    }
    const statementImport = await this.#requireActiveImport(
      oldMatch.statementImportId,
    );
    await this.#assertClientReconciliationExpectation(
      statementImport.id,
      input,
    );
    const components = await this.#requireComponents(
      statementImport,
      input.componentIds,
    );
    const transaction = await this.#repository.getResolutionTransaction(
      input.transactionId,
    );
    if (!transaction)
      throw new RavenDomainError(
        "NOT_FOUND",
        "Replacement transaction was not found",
      );
    const candidate = generateStatementMatchCandidates({
      components,
      transactions: [transaction],
    }).find((item) => !item.transferCandidate);
    if (!candidate) {
      throw new RavenDomainError(
        "STATEMENT_TRANSACTION_INELIGIBLE",
        "Replacement transaction is ineligible",
      );
    }
    const replacement = matchDraft({
      statementImport,
      components,
      transactionId: transaction.id,
      method: candidate.method,
      reasonCodes: candidate.reasonCodes,
      confidence: candidate.confidence,
      actorId: input.actorId ?? null,
      proposedAt: now,
      proposedOperationId: `financialOperation:${operation.key}`,
      supersedesId: oldMatch.id,
      suffix: `${oldMatch.id}:${oldMatch.revision + 1}`,
    });
    const replacementProjected: StatementTransactionMatchRecord = {
      id: await this.#repository.getStatementTransactionMatchIdentity(
        statementImport.id,
        replacement.key,
      ),
      ...replacement,
      primaryComponentId: replacement.componentIds[0]!,
      state: "confirmed",
      revision: 1,
      confirmedOperationId: `financialOperation:${operation.key}`,
      rejectedOperationId: null,
      supersededOperationId: null,
      reviewedBy: input.actorId ?? null,
      confirmedAt: now,
      rejectedAt: null,
      supersededAt: null,
      rejectionReason: null,
      supersessionReason: null,
      supersededById: null,
      sourceState: "committed",
    };
    const oldProjected = {
      ...oldMatch,
      state: "superseded" as const,
      revision: oldMatch.revision + 1,
      supersededOperationId: `financialOperation:${operation.key}`,
      supersededAt: now,
      supersessionReason: input.reason,
      supersededById: replacementProjected.id,
    };
    const result = await retryStatementReconciliationMutation(
      async () =>
        this.#calculateDraft(
          statementImport,
          `financialOperation:${operation.key}`,
          {
            matches: [
              ...(await this.#allMatches(statementImport.id)).filter(
                (item) => item.id !== oldMatch.id,
              ),
              oldProjected,
              replacementProjected,
            ],
          },
        ),
      async (calculated) =>
        this.#repository.supersedeStatementTransactionMatch({
          oldMatchId: oldMatch.id,
          expectedRevision: input.expectedRevision,
          reason: input.reason,
          actorId: input.actorId ?? null,
          supersededAt: now,
          replacement,
          validation: matchValidation(statementImport, components, transaction),
          operation,
          ...calculated,
        }),
    );
    return {
      match: result.match,
      reconciliation: result.reconciliation,
      receipt: receipt(result.operation, "applied"),
    };
  }

  async acknowledgeStatementIssue(input: AcknowledgeStatementIssueInput) {
    const command = "acknowledge_statement_issue" as const;
    const now = this.#clock();
    const operation = operationDraft(command, input, input, now);
    const replay = await this.#repository.getResolutionOperation(
      command,
      input.idempotencyKey,
    );
    if (replay) {
      assertReplayHash(replay, operation.requestHash);
      const issueId = statementRef(replay, "statementIssue:");
      const issue = issueId
        ? await this.#sourceRepository.getStatementIssue(issueId)
        : null;
      if (!issue)
        throw new RavenDomainError("INTERNAL", "Issue replay is unavailable");
      return {
        issue,
        reconciliation: await this.#repository.getStatementReconciliation(
          issue.statementImportId,
        ),
        receipt: receipt(replay, "replayed"),
      };
    }
    const issue = await this.#sourceRepository.getStatementIssue(
      input.statementIssueId,
    );
    if (!issue)
      throw new RavenDomainError("NOT_FOUND", "Statement issue was not found");
    if (issue.blocking) {
      throw new RavenDomainError(
        "STATEMENT_BLOCKING_ISSUE_ACTIVE",
        "A blocking source issue cannot be acknowledged into reconciliation",
      );
    }
    if (issue.state !== "open" || issue.revision !== input.expectedRevision) {
      throw new RavenDomainError(
        "STATEMENT_RECONCILIATION_STALE",
        "Issue revision changed",
      );
    }
    const statementImport = await this.#requireActiveImport(
      issue.statementImportId,
    );
    await this.#assertClientReconciliationExpectation(
      statementImport.id,
      input,
    );
    const result = await retryStatementReconciliationMutation(
      async () => {
        const issues = (
          await this.#sourceRepository.listStatementIssues(statementImport.id)
        ).map((item) =>
          item.id === issue.id
            ? {
                ...item,
                state: "acknowledged" as const,
                revision: item.revision + 1,
                dispositionOperationId: `financialOperation:${operation.key}`,
                acknowledgedAt: now,
                reviewedBy: input.actorId ?? null,
                notes: input.note,
              }
            : item,
        );
        return this.#calculateDraft(
          statementImport,
          `financialOperation:${operation.key}`,
          { issues },
        );
      },
      async (calculated) =>
        this.#repository.acknowledgeStatementIssue({
          issueId: issue.id,
          expectedRevision: input.expectedRevision,
          note: input.note,
          actorId: input.actorId ?? null,
          acknowledgedAt: now,
          operation,
          ...calculated,
        }),
    );
    return {
      issue: result.issue,
      reconciliation: result.reconciliation,
      receipt: receipt(result.operation, "applied"),
    };
  }

  async supersedeStatementImport(
    input: SupersedeStatementImportInput,
  ): Promise<StatementImportSupersessionResult> {
    const command = "supersede_statement_import" as const;
    const now = this.#clock();
    const operation = operationDraft(command, input, input, now);
    const replay = await this.#repository.getResolutionOperation(
      command,
      input.idempotencyKey,
    );
    if (replay) {
      assertReplayHash(replay, operation.requestHash);
      const imports = replay.resultRefs.filter((ref) =>
        ref.startsWith("statementImport:"),
      );
      const oldImport = imports[0]
        ? await this.#sourceRepository.getStatementImport(imports[0])
        : null;
      const replacement = imports[1]
        ? await this.#sourceRepository.getStatementImport(imports[1])
        : null;
      if (!oldImport || !replacement) {
        throw new RavenDomainError(
          "INTERNAL",
          "Source supersession replay is unavailable",
        );
      }
      return {
        supersededImport: oldImport,
        replacementImport: replacement,
        reconciliation: await this.#repository.getStatementReconciliation(
          oldImport.id,
        ),
        receipt: receipt(replay, "replayed"),
      };
    }
    const oldImport = await this.#requireActiveImport(input.statementImportId);
    await this.#assertClientReconciliationExpectation(oldImport.id, input);
    if (oldImport.revision !== input.expectedSourceRevision) {
      throw new RavenDomainError(
        "STATEMENT_SOURCE_SUPERSESSION_CONFLICT",
        "Source revision changed",
      );
    }
    if (!this.#prepareSourceSupersession) {
      throw new RavenDomainError(
        "INTERNAL",
        "Source supersession preparation is unavailable",
      );
    }
    const replacement = await this.#prepareSourceSupersession(input, operation);
    let result: Awaited<
      ReturnType<StatementResolutionRepository["supersedeStatementImport"]>
    > | null = null;
    for (let attempt = 0; attempt < 2; attempt += 1) {
      const current = await this.#repository.getStatementReconciliation(
        oldImport.id,
      );
      const draft: StatementImportSupersessionDraft = {
        oldImportId: oldImport.id,
        expectedSourceRevision: input.expectedSourceRevision,
        expectedReconciliationRevision: current?.revision ?? null,
        expectedReconciliationHash: current?.calculationHash ?? null,
        reason: input.reason,
        replacement,
        operation,
      };
      try {
        result = await this.#repository.supersedeStatementImport(draft);
        break;
      } catch (error) {
        if (
          attempt === 0 &&
          error instanceof RavenDomainError &&
          error.code === "STATEMENT_RECONCILIATION_STALE"
        ) {
          continue;
        }
        throw error;
      }
    }
    if (!result) {
      throw new RavenDomainError(
        "STATEMENT_RECONCILIATION_STALE",
        "Reconciliation authority changed during source replacement",
      );
    }
    return {
      supersededImport: result.supersededImport,
      replacementImport: result.replacementImport,
      reconciliation: result.reconciliation,
      receipt: receipt(result.operation, "applied"),
    };
  }

  async recalculateStatementReconciliation(
    input: RecalculateStatementReconciliationInput,
  ): Promise<StatementReconciliationMutationResult> {
    const command = "recalculate_statement_reconciliation" as const;
    const now = this.#clock();
    const operation = operationDraft(command, input, input, now);
    const replay = await this.#repository.getResolutionOperation(
      command,
      input.idempotencyKey,
    );
    if (replay)
      return this.#replayedReconciliation(replay, operation.requestHash);
    const statementImport = await this.#requireActiveImport(
      input.statementImportId,
    );
    const previous = await this.#repository.getStatementReconciliation(
      statementImport.id,
    );
    if (
      (previous?.revision ?? null) !== input.expectedRevision ||
      (previous?.calculationHash ?? null) !== input.expectedHash
    ) {
      throw new RavenDomainError(
        "STATEMENT_RECONCILIATION_STALE",
        "Reconciliation revision changed",
      );
    }
    const result = await retryStatementReconciliationMutation(
      async () =>
        this.#calculateDraft(
          statementImport,
          `financialOperation:${operation.key}`,
        ),
      async (calculated) =>
        this.#repository.recalculateStatementReconciliation({
          statementImportId: statementImport.id,
          expectedRevision: calculated.expectedReconciliationRevision,
          expectedHash: calculated.expectedReconciliationHash,
          reconciliation: calculated.reconciliation,
          operation,
        }),
    );
    return {
      reconciliation: result.reconciliation,
      event: result.event,
      receipt: receipt(result.operation, "applied"),
    };
  }

  async #replayedReconciliation(
    operation: StatementResolutionOperation,
    expectedHash: string,
  ): Promise<StatementReconciliationMutationResult> {
    assertReplayHash(operation, expectedHash);
    const reconciliationId = statementRef(
      operation,
      "statementReconciliation:",
    );
    if (!reconciliationId)
      throw new RavenDomainError(
        "INTERNAL",
        "Reconciliation replay is unavailable",
      );
    const statementImportId = operation.auditMeta.statementImportId;
    const reconciliation =
      typeof statementImportId === "string"
        ? await this.#repository.getStatementReconciliation(statementImportId)
        : null;
    if (!reconciliation)
      throw new RavenDomainError(
        "INTERNAL",
        "Reconciliation replay is unavailable",
      );
    const events = await this.#repository.listStatementReconciliationEvents(
      statementImportId as string,
    );
    const eventId = statementRef(operation, "statementReconciliationEvent:");
    return {
      reconciliation,
      event: events.find((item) => item.id === eventId) ?? null,
      receipt: receipt(operation, "replayed"),
    };
  }

  async attestStatementReconciled(
    input: AttestStatementReconciledInput,
  ): Promise<StatementReconciliationMutationResult> {
    const command = "attest_statement_reconciled" as const;
    const now = this.#clock();
    const operation = {
      ...operationDraft(command, input, input, now),
      auditMeta: {
        contractVersion: "statement-truth-v0.1",
        workline: "ST-02",
        statementImportId: input.statementImportId,
      },
    };
    const replay = await this.#repository.getResolutionOperation(
      command,
      input.idempotencyKey,
    );
    if (replay)
      return this.#replayedReconciliation(replay, operation.requestHash);
    const statementImport = await this.#requireActiveImport(
      input.statementImportId,
    );
    const expectedAccountContext =
      await this.#requireCurrentAccountContext(statementImport);
    const reconciliation = await this.#repository.getStatementReconciliation(
      statementImport.id,
    );
    if (
      !reconciliation ||
      reconciliation.revision !== input.expectedRevision ||
      reconciliation.calculationHash !== input.calculationHash
    ) {
      throw new RavenDomainError(
        "STATEMENT_RECONCILIATION_STALE",
        "Reconciliation calculation changed",
      );
    }
    if (reconciliation.attestationState === "reconciled") {
      throw new RavenDomainError(
        "STATEMENT_RECONCILIATION_ALREADY_ATTESTED",
        "Statement is already reconciled",
      );
    }
    if (reconciliation.counts.blockingIssueCount > 0) {
      throw new RavenDomainError(
        "STATEMENT_BLOCKING_ISSUE_ACTIVE",
        "A blocking statement issue is active",
      );
    }
    if (reconciliation.calculationState === "difference") {
      throw new RavenDomainError(
        "STATEMENT_RECONCILIATION_DIFFERENCE",
        "Statement difference must be zero before attestation",
        {
          differenceMinor: reconciliation.differenceMinor,
        },
      );
    }
    if (
      (reconciliation.attestationState !== "ready" &&
        reconciliation.attestationState !== "reopened") ||
      reconciliation.coverageState !== "complete" ||
      reconciliation.counts.unresolvedCount !== 0 ||
      reconciliation.calculationState !== "balanced"
    ) {
      throw new RavenDomainError(
        "STATEMENT_RECONCILIATION_INCOMPLETE",
        "Statement is not ready for attestation",
      );
    }
    const result = await this.#repository.attestStatementReconciled({
      statementImportId: statementImport.id,
      expectedRevision: input.expectedRevision,
      calculationHash: input.calculationHash,
      expectedAccountContext,
      actorId: input.actorId ?? null,
      attestedAt: now,
      operation,
    });
    return {
      reconciliation: result.reconciliation,
      event: result.event,
      receipt: receipt(result.operation, "applied"),
    };
  }

  async reopenStatementReconciliation(
    input: ReopenStatementReconciliationInput,
  ): Promise<StatementReconciliationMutationResult> {
    const command = "reopen_statement_reconciliation" as const;
    const now = this.#clock();
    const operation = {
      ...operationDraft(command, input, input, now),
      auditMeta: {
        contractVersion: "statement-truth-v0.1",
        workline: "ST-02",
        statementImportId: input.statementImportId,
      },
    };
    const replay = await this.#repository.getResolutionOperation(
      command,
      input.idempotencyKey,
    );
    if (replay)
      return this.#replayedReconciliation(replay, operation.requestHash);
    const statementImport = await this.#requireActiveImport(
      input.statementImportId,
    );
    const reconciliation = await this.#repository.getStatementReconciliation(
      statementImport.id,
    );
    if (
      !reconciliation ||
      reconciliation.revision !== input.expectedRevision ||
      reconciliation.calculationHash !== input.calculationHash
    ) {
      throw new RavenDomainError(
        "STATEMENT_RECONCILIATION_STALE",
        "Reconciliation revision changed",
      );
    }
    if (reconciliation.attestationState !== "reconciled") {
      throw new RavenDomainError(
        "STATEMENT_RECONCILIATION_INCOMPLETE",
        "Only an attested reconciliation can be reopened explicitly",
      );
    }
    const result = await this.#repository.reopenStatementReconciliation({
      statementImportId: statementImport.id,
      expectedRevision: input.expectedRevision,
      calculationHash: input.calculationHash,
      reason: input.reason,
      actorId: input.actorId ?? null,
      reopenedAt: now,
      operation,
    });
    return {
      reconciliation: result.reconciliation,
      event: result.event,
      receipt: receipt(result.operation, "applied"),
    };
  }
}

export function createStatementResolutionService(
  options: StatementResolutionServiceOptions,
): StatementResolutionApi {
  return new StatementResolutionService(options);
}
