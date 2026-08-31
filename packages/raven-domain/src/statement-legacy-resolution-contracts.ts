import type {
  AccountTransferRecord,
  FinancialOperationRecord,
  OperationChannel,
  TransactionRecord,
} from "./contracts.js";
import type { OperationDraft } from "./repository.js";
import type {
  StatementImportRecord,
  StatementPreviewResult,
  StatementRowRecord,
  ValidateStatementPreviewInput,
} from "./statement-contracts.js";
import type {
  StatementReconciliationRecord,
  StatementTransactionMatchRecord,
} from "./statement-resolution-contracts.js";
import type { StatementCommitDraft } from "./statement-repository.js";

export type StatementLegacyCompatibilityClass =
  | "exact_existing_transaction_adoption"
  | "exact_grouped_component_adoption"
  | "canonical_component_requires_materialization"
  | "legacy_transaction_historical_only"
  | "transfer_review_required"
  | "informational_non_movement"
  | "ambiguous_or_conflicting";

export type StatementLegacyStrategy = "A" | "B" | "C" | "D" | "E";
export type StatementLegacyAppliedStrategy = Extract<
  StatementLegacyStrategy,
  "A" | "B" | "C"
>;
export type StatementLegacyActiveLedgerOutcome =
  | "adopted_existing"
  | "adopted_grouped"
  | "materialized"
  | "historical_only"
  | "confirmed_transfer"
  | "informational_only"
  | "authority_released";

export type StatementLegacyAggregateCounts = Readonly<
  Record<StatementLegacyCompatibilityClass, number>
>;

export type StatementLegacyCanonicalComponent = Readonly<{
  rowKey: string;
  rowNumber: number;
  componentKey: string;
  componentRole: "movement" | "informational_breakdown";
  sourceChecksum: string;
  amountMinor: number;
  balanceEffectMinor: number;
  currency: string;
  financialDate: string | null;
}>;

export type StatementLegacyResolutionItemPlan = Readonly<{
  key: string;
  compatibilityClass: StatementLegacyCompatibilityClass;
  activeLedgerOutcome: Exclude<
    StatementLegacyActiveLedgerOutcome,
    "authority_released"
  > | null;
  canonicalComponents: readonly StatementLegacyCanonicalComponent[];
  legacyStatementRowId: string | null;
  legacyTransactionIds: readonly string[];
  primaryLegacyTransactionId: string | null;
  accountTransferId: string | null;
  itemEvidenceHash: string;
  expectedClaimHash: string;
  blocking: boolean;
}>;

export type StatementLegacyEvidence = Readonly<{
  databaseFingerprint: string;
  legacyStatementImport: StatementImportRecord;
  legacyRows: readonly StatementRowRecord[];
  legacyTransactions: readonly TransactionRecord[];
  counterpartTransactions: readonly TransactionRecord[];
  accountTransfers: readonly AccountTransferRecord[];
  activeMatches: readonly StatementTransactionMatchRecord[];
  reconciliation: StatementReconciliationRecord | null;
  dependentAuthorityHash: string;
}>;

export type StatementLegacyResolutionPlan = Readonly<{
  databaseFingerprint: string;
  sourceIdentityHash: string;
  canonicalPreviewHash: string;
  legacyEvidenceHash: string;
  accountContextFingerprint: string;
  crosswalkHash: string;
  expectedRevisionClaimHash: string;
  resultAuthorityHash: string;
  aggregateCounts: StatementLegacyAggregateCounts;
  items: readonly StatementLegacyResolutionItemPlan[];
  eligibleStrategies: readonly StatementLegacyAppliedStrategy[];
  recommendedStrategy: StatementLegacyStrategy;
  applyEligible: boolean;
}>;

export type StatementLegacyResolutionDecision = Readonly<{
  itemKey: string;
  outcome: Exclude<
    StatementLegacyActiveLedgerOutcome,
    "informational_only" | "authority_released"
  >;
  itemEvidenceHash: string;
  legacyTransactionId?: string;
  accountTransferId?: string;
}>;

export type PreviewLegacyStatementResolutionInput =
  ValidateStatementPreviewInput & Readonly<{ legacyStatementImportId: string }>;

export type PreviewLegacyStatementResolutionResult = Readonly<{
  previewIdentityHash: string;
  plan: StatementLegacyResolutionPlan;
  privateProjection: Readonly<{
    items: readonly StatementLegacyResolutionItemPlan[];
  }>;
  aggregateProjection: Readonly<{
    counts: StatementLegacyAggregateCounts;
    recommendedStrategy: StatementLegacyStrategy;
    applyEligible: boolean;
  }>;
}>;

export type ApplyLegacyStatementResolutionInput =
  PreviewLegacyStatementResolutionInput &
    Readonly<{
      previewIdentityHash: string;
      expectedDatabaseFingerprint: string;
      expectedSourceIdentityHash: string;
      expectedLegacyEvidenceHash: string;
      expectedAccountContextFingerprint: string;
      expectedCrosswalkHash: string;
      expectedRevisionClaimHash: string;
      strategy: StatementLegacyAppliedStrategy;
      decisions: readonly StatementLegacyResolutionDecision[];
      idempotencyKey: string;
      channel: OperationChannel;
      actorId?: string;
    }>;

export type ReverseLegacyStatementResolutionInput = Readonly<{
  statementLegacyResolutionId: string;
  expectedDatabaseFingerprint: string;
  expectedTargetRequestHash: string;
  expectedAuthorityHash: string;
  idempotencyKey: string;
  channel: OperationChannel;
  actorId?: string;
}>;

export type StatementLegacyResolutionRecord = Readonly<{
  id: string;
  key: string;
  spaceId: string;
  accountId: string;
  legacyStatementImportId: string;
  canonicalStatementImportId: string;
  resolutionType: "apply" | "reversal";
  strategy: StatementLegacyAppliedStrategy;
  authorityEffect: "activate_canonical" | "restore_previous";
  previousLegacySourceState: "legacy" | "committed";
  previousSourceClaimState: "absent" | "active" | "released";
  previousPeriodClaimState: "absent" | "active" | "released";
  targetResolutionId: string | null;
  predecessorResolutionId: string | null;
  databaseFingerprint: string;
  sourceIdentityHash: string;
  canonicalPreviewHash: string;
  legacyEvidenceHash: string;
  accountContextFingerprint: string;
  crosswalkHash: string;
  expectedRevisionClaimHash: string;
  resultAuthorityHash: string;
  aggregateCounts: StatementLegacyAggregateCounts;
  idempotencyKey: string;
  requestHash: string;
  channel: OperationChannel;
  actorId: string | null;
  operationId: string;
  recordedAt: string;
}>;

export type StatementLegacyResolutionItemRecord = Readonly<{
  id: string;
  key: string;
  statementLegacyResolutionId: string;
  compatibilityClass: StatementLegacyCompatibilityClass;
  activeLedgerOutcome: StatementLegacyActiveLedgerOutcome;
  canonicalComponentIds: readonly string[];
  legacyStatementRowId: string | null;
  legacyTransactionIds: readonly string[];
  primaryLegacyTransactionId: string | null;
  accountTransferId: string | null;
  itemEvidenceHash: string;
  expectedClaimHash: string;
  operationId: string;
  recordedAt: string;
}>;

export type StatementLegacyResolutionReceipt = Readonly<{
  operationId: string;
  status: "applied" | "replayed";
  resultRefs: readonly string[];
  completedAt: string;
}>;

export type StatementLegacyResolutionResult = Readonly<{
  resolution: StatementLegacyResolutionRecord;
  items: readonly StatementLegacyResolutionItemRecord[];
  statementImport: StatementImportRecord;
  reconciliation: StatementReconciliationRecord | null;
  receipt: StatementLegacyResolutionReceipt;
}>;

export type StatementLegacyResolutionCommand =
  | "apply_legacy_statement_resolution"
  | "reverse_legacy_statement_resolution";

export type StatementLegacyResolutionOperation = FinancialOperationRecord &
  Readonly<{ command: StatementLegacyResolutionCommand }>;

export type StatementLegacyApplyDraft = Readonly<{
  source: StatementCommitDraft;
  evidence: StatementLegacyEvidence;
  plan: StatementLegacyResolutionPlan;
  strategy: StatementLegacyAppliedStrategy;
  decisions: readonly StatementLegacyResolutionDecision[];
  operation: OperationDraft;
}>;

export type StatementLegacyReverseDraft = Readonly<{
  target: StatementLegacyResolutionRecord;
  targetItems: readonly StatementLegacyResolutionItemRecord[];
  expectedDatabaseFingerprint: string;
  expectedAuthorityHash: string;
  operation: OperationDraft;
}>;

export interface StatementLegacyResolutionRepository {
  getOperation(
    command: StatementLegacyResolutionCommand,
    idempotencyKey: string,
  ): Promise<StatementLegacyResolutionOperation | null>;
  getResolution(id: string): Promise<StatementLegacyResolutionRecord | null>;
  getStatementImport(id: string): Promise<StatementImportRecord | null>;
  getReconciliation(
    statementImportId: string,
  ): Promise<StatementReconciliationRecord | null>;
  listResolutionItems(
    resolutionId: string,
  ): Promise<StatementLegacyResolutionItemRecord[]>;
  loadEvidence(
    legacyStatementImportId: string,
  ): Promise<StatementLegacyEvidence>;
  apply(
    draft: StatementLegacyApplyDraft,
  ): Promise<StatementLegacyResolutionResult>;
  reverse(
    draft: StatementLegacyReverseDraft,
  ): Promise<StatementLegacyResolutionResult>;
}

export interface StatementLegacySourceService {
  validateStatementPreview(
    input: ValidateStatementPreviewInput,
  ): Promise<StatementPreviewResult>;
  prepareStatementSupersessionDraft(
    input: ValidateStatementPreviewInput,
    operation: OperationDraft,
    replacementOfId: string,
    allowExactLegacyOverlap: boolean,
  ): Promise<StatementCommitDraft>;
}

export interface StatementLegacyResolutionApi {
  previewLegacyStatementResolution(
    input: PreviewLegacyStatementResolutionInput,
  ): Promise<PreviewLegacyStatementResolutionResult>;
  applyLegacyStatementResolution(
    input: ApplyLegacyStatementResolutionInput,
  ): Promise<StatementLegacyResolutionResult>;
  reverseLegacyStatementResolution(
    input: ReverseLegacyStatementResolutionInput,
  ): Promise<StatementLegacyResolutionResult>;
}

export type StatementLegacyPreviewContext = Readonly<{
  input: PreviewLegacyStatementResolutionInput;
  preview: StatementPreviewResult;
}>;
