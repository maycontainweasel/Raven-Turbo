import type {
  FlowDirection,
  OperationChannel,
  TransactionEvidenceState,
  TransactionKind,
} from "./contracts.js";
import type {
  PreviewStatementImportInput,
  StatementImportRecord,
  StatementIssueRecord,
  StatementQueryMeta,
  StatementRowComponentRecord,
  StatementWarningCode,
} from "./statement-contracts.js";

export const STATEMENT_MATCH_DATE_WINDOW_DAYS = 3 as const;

export type StatementMatchState =
  | "proposed"
  | "confirmed"
  | "rejected"
  | "superseded";
export type StatementMatchMethod =
  | "explicit"
  | "exact_reference"
  | "exact_description"
  | "exact_date"
  | "bounded_date"
  | "grouped_exact"
  | "created_from_component"
  | "transfer_candidate"
  | "other";
export type StatementMatchReasonCode =
  | "ACTIVE_CONFIRMED_SOURCE_LINK"
  | "EXPLICIT_OPERATOR_SELECTION"
  | "EXACT_SOURCE_REFERENCE"
  | "EXACT_NORMALIZED_DESCRIPTION"
  | "EXACT_FINANCIAL_DATE"
  | "BOUNDED_FINANCIAL_DATE"
  | "EXACT_COMPONENT_GROUP_TOTAL"
  | "OPPOSITE_ACCOUNT_EFFECT"
  | "CREATED_FROM_COMPONENT";
export type StatementComponentDisposition =
  | "informational"
  | "pending"
  | "proposed"
  | "matched_existing"
  | "materialized_imported"
  | "rejected_proposal_present"
  | "conflict"
  | "superseded_source";
export type StatementCalculationState =
  | "unavailable"
  | "difference"
  | "balanced";
export type StatementCoverageState = "incomplete" | "complete";
export type StatementAttestationState =
  | "open"
  | "ready"
  | "reconciled"
  | "reopened";
export type StatementReconciliationEventType = "attested" | "reopened";

export type StatementTransactionCandidate = Readonly<{
  transactionId: string;
  account: Readonly<{
    spaceKey: string;
    accountKey: string;
  }>;
  financialDate: string;
  description: string;
  amountMinor: number;
  currency: string;
  kind: TransactionKind;
  flowDirection: FlowDirection | null;
  evidenceState: TransactionEvidenceState;
  method: StatementMatchMethod;
  reasonCodes: readonly StatementMatchReasonCode[];
  confidence: number;
  dateDistanceDays: number;
  transferCandidate: boolean;
  componentIds: readonly string[];
  signedComponentTotalMinor: number;
}>;

export type StatementTransactionMatchRecord = Readonly<{
  id: string;
  key: string;
  spaceId: string;
  accountId: string;
  statementImportId: string;
  primaryComponentId: string;
  componentIds: readonly string[];
  transactionId: string;
  state: StatementMatchState;
  method: StatementMatchMethod;
  reasonCodes: readonly StatementMatchReasonCode[];
  confidence: number;
  signedComponentTotalMinor: number;
  currency: string;
  revision: number;
  proposedOperationId: string;
  confirmedOperationId: string | null;
  rejectedOperationId: string | null;
  supersededOperationId: string | null;
  proposedBy: string | null;
  reviewedBy: string | null;
  proposedAt: string;
  confirmedAt: string | null;
  rejectedAt: string | null;
  supersededAt: string | null;
  rejectionReason: string | null;
  supersessionReason: string | null;
  supersedesId: string | null;
  supersededById: string | null;
  sourceState: "committed" | "superseded";
}>;

export type StatementComponentResolution = Readonly<{
  component: StatementRowComponentRecord;
  disposition: StatementComponentDisposition;
  activeMatch: StatementTransactionMatchRecord | null;
  proposals: readonly StatementTransactionMatchRecord[];
}>;

export type StatementReconciliationCounts = Readonly<{
  printedRowCount: number;
  extractedRowCount: number;
  movementComponentCount: number;
  informationalComponentCount: number;
  pendingCount: number;
  proposedCount: number;
  confirmedExistingCount: number;
  newlyMaterializedCount: number;
  unresolvedCount: number;
  transferCandidateCount: number;
  activeIssueCount: number;
  blockingIssueCount: number;
}>;

export type StatementReconciliationRecord = Readonly<{
  id: string;
  key: string;
  spaceId: string;
  accountId: string;
  statementImportId: string;
  periodStart: string;
  periodEnd: string;
  currency: string;
  openingBalanceMinor: number | null;
  signedMovementEffectMinor: number;
  expectedClosingBalanceMinor: number | null;
  reportedClosingBalanceMinor: number | null;
  differenceMinor: number | null;
  counts: StatementReconciliationCounts;
  calculationState: StatementCalculationState;
  coverageState: StatementCoverageState;
  attestationState: StatementAttestationState;
  calculationHash: string;
  revision: number;
  calculatedAt: string;
  calculationOperationId: string;
  latestAttestationOperationId: string | null;
  latestReopeningOperationId: string | null;
  attestedAt: string | null;
  reopenedAt: string | null;
  provenance: Readonly<Record<string, unknown>>;
}>;

export type StatementReconciliationEventRecord = Readonly<{
  id: string;
  key: string;
  spaceId: string;
  accountId: string;
  statementImportId: string;
  statementReconciliationId: string;
  eventType: StatementReconciliationEventType;
  reconciliationRevision: number;
  calculationHash: string;
  calculationSnapshot: Readonly<Record<string, unknown>>;
  reason: string | null;
  actorId: string | null;
  channel: OperationChannel;
  operationId: string;
  recordedAt: string;
}>;

export type StatementResolutionReceipt = Readonly<{
  operationId: string;
  status: "applied" | "replayed";
  resultRefs: readonly string[];
  warningCodes: readonly StatementWarningCode[];
  completedAt: string;
}>;

export type StatementResolutionCommandMeta = Readonly<{
  idempotencyKey: string;
  channel: OperationChannel;
  actorId?: string;
}>;
export type StatementReconciliationExpectation = Readonly<{
  expectedReconciliationRevision: number | null;
  expectedReconciliationHash: string | null;
}>;

export type ListStatementMatchCandidatesInput = Readonly<{
  statementImportId: string;
  componentIds: readonly string[];
  explicitTransactionId?: string;
}>;
export type ListStatementTransactionMatchesInput = Readonly<{
  statementImportId: string;
  statementRowComponentId?: string;
  transactionId?: string;
  includeSuperseded?: boolean;
}>;
export type GetStatementTransactionMatchInput = Readonly<{
  statementTransactionMatchId: string;
}>;
export type GetStatementReconciliationInput = Readonly<{
  statementImportId: string;
}>;

export type ProposeStatementTransactionMatchInput =
  StatementResolutionCommandMeta &
    StatementReconciliationExpectation &
    Readonly<{
      statementImportId: string;
      componentIds: readonly string[];
      transactionId: string;
    }>;
export type ConfirmStatementTransactionMatchInput =
  StatementResolutionCommandMeta &
    StatementReconciliationExpectation &
    Readonly<{
      statementTransactionMatchId: string;
      expectedRevision: number;
    }>;
export type MaterializeStatementComponentTransactionInput =
  StatementResolutionCommandMeta &
    StatementReconciliationExpectation &
    Readonly<{
      statementImportId: string;
      componentIds: readonly string[];
    }>;
export type RejectStatementTransactionMatchInput =
  StatementResolutionCommandMeta &
    StatementReconciliationExpectation &
    Readonly<{
      statementTransactionMatchId: string;
      expectedRevision: number;
      reason: string;
    }>;
export type SupersedeStatementTransactionMatchInput =
  StatementResolutionCommandMeta &
    StatementReconciliationExpectation &
    Readonly<{
      statementTransactionMatchId: string;
      expectedRevision: number;
      componentIds: readonly string[];
      transactionId: string;
      reason: string;
    }>;
export type AcknowledgeStatementIssueInput = StatementResolutionCommandMeta &
  StatementReconciliationExpectation &
  Readonly<{
    statementIssueId: string;
    expectedRevision: number;
    note: string;
  }>;
export type SupersedeStatementImportInput = StatementResolutionCommandMeta &
  Readonly<{
    statementImportId: string;
    expectedSourceRevision: number;
    expectedReconciliationRevision: number | null;
    expectedReconciliationHash: string | null;
    replacement: PreviewStatementImportInput &
      Readonly<{ previewHash: string }>;
    reason: string;
  }>;
export type RecalculateStatementReconciliationInput =
  StatementResolutionCommandMeta &
    Readonly<{
      statementImportId: string;
      expectedRevision: number | null;
      expectedHash: string | null;
    }>;
export type AttestStatementReconciledInput = StatementResolutionCommandMeta &
  Readonly<{
    statementImportId: string;
    expectedRevision: number;
    calculationHash: string;
  }>;
export type ReopenStatementReconciliationInput =
  StatementResolutionCommandMeta &
    Readonly<{
      statementImportId: string;
      expectedRevision: number;
      reason: string;
      calculationHash: string;
    }>;

export type StatementMatchMutationResult = Readonly<{
  match: StatementTransactionMatchRecord;
  reconciliation: StatementReconciliationRecord | null;
  receipt: StatementResolutionReceipt;
}>;
export type StatementMaterializationResult = Readonly<{
  transactionId: string;
  match: StatementTransactionMatchRecord;
  reconciliation: StatementReconciliationRecord | null;
  receipt: StatementResolutionReceipt;
}>;
export type StatementIssueAcknowledgementResult = Readonly<{
  issue: StatementIssueRecord;
  reconciliation: StatementReconciliationRecord | null;
  receipt: StatementResolutionReceipt;
}>;
export type StatementImportSupersessionResult = Readonly<{
  supersededImport: StatementImportRecord;
  replacementImport: StatementImportRecord;
  reconciliation: StatementReconciliationRecord | null;
  receipt: StatementResolutionReceipt;
}>;
export type StatementReconciliationMutationResult = Readonly<{
  reconciliation: StatementReconciliationRecord;
  event: StatementReconciliationEventRecord | null;
  receipt: StatementResolutionReceipt;
}>;

export interface StatementResolutionApi {
  listStatementMatchCandidates(
    input: ListStatementMatchCandidatesInput,
  ): Promise<{
    candidates: readonly StatementTransactionCandidate[];
    components: readonly StatementComponentResolution[];
    meta: StatementQueryMeta;
  }>;
  listStatementTransactionMatches(
    input: ListStatementTransactionMatchesInput,
  ): Promise<{
    matches: readonly StatementTransactionMatchRecord[];
    meta: StatementQueryMeta;
  }>;
  getStatementTransactionMatch(
    input: GetStatementTransactionMatchInput,
  ): Promise<{
    match: StatementTransactionMatchRecord;
    meta: StatementQueryMeta;
  }>;
  getStatementReconciliation(input: GetStatementReconciliationInput): Promise<{
    reconciliation: StatementReconciliationRecord | null;
    events: readonly StatementReconciliationEventRecord[];
    components: readonly StatementComponentResolution[];
    issues: readonly StatementIssueRecord[];
    meta: StatementQueryMeta;
  }>;
  proposeStatementTransactionMatch(
    input: ProposeStatementTransactionMatchInput,
  ): Promise<StatementMatchMutationResult>;
  confirmStatementTransactionMatch(
    input: ConfirmStatementTransactionMatchInput,
  ): Promise<StatementMatchMutationResult>;
  materializeStatementComponentTransaction(
    input: MaterializeStatementComponentTransactionInput,
  ): Promise<StatementMaterializationResult>;
  rejectStatementTransactionMatch(
    input: RejectStatementTransactionMatchInput,
  ): Promise<StatementMatchMutationResult>;
  supersedeStatementTransactionMatch(
    input: SupersedeStatementTransactionMatchInput,
  ): Promise<StatementMatchMutationResult>;
  acknowledgeStatementIssue(
    input: AcknowledgeStatementIssueInput,
  ): Promise<StatementIssueAcknowledgementResult>;
  supersedeStatementImport(
    input: SupersedeStatementImportInput,
  ): Promise<StatementImportSupersessionResult>;
  recalculateStatementReconciliation(
    input: RecalculateStatementReconciliationInput,
  ): Promise<StatementReconciliationMutationResult>;
  attestStatementReconciled(
    input: AttestStatementReconciledInput,
  ): Promise<StatementReconciliationMutationResult>;
  reopenStatementReconciliation(
    input: ReopenStatementReconciliationInput,
  ): Promise<StatementReconciliationMutationResult>;
}
