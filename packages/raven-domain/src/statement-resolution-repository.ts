import type {
  FinancialOperationRecord,
  TransactionRecord,
} from "./contracts.js";
import type { OperationDraft } from "./repository.js";
import type {
  StatementImportRecord,
  StatementIssueRecord,
} from "./statement-contracts.js";
import type {
  StatementCommitDraft,
  StatementReviewedAccountContext,
} from "./statement-repository.js";
import type {
  StatementMatchMethod,
  StatementMatchReasonCode,
  StatementReconciliationEventRecord,
  StatementReconciliationRecord,
  StatementTransactionMatchRecord,
} from "./statement-resolution-contracts.js";

export type StatementResolutionCommand = Extract<
  FinancialOperationRecord["command"],
  | "propose_statement_transaction_match"
  | "confirm_statement_transaction_match"
  | "materialize_statement_component_transaction"
  | "reject_statement_transaction_match"
  | "supersede_statement_transaction_match"
  | "acknowledge_statement_issue"
  | "supersede_statement_import"
  | "recalculate_statement_reconciliation"
  | "attest_statement_reconciled"
  | "reopen_statement_reconciliation"
>;

export type StatementResolutionOperation = FinancialOperationRecord &
  Readonly<{ command: StatementResolutionCommand }>;

export type StatementMatchReadFilter = Readonly<{
  statementImportId: string;
  statementRowComponentId?: string;
  transactionId?: string;
  includeSuperseded?: boolean;
}>;

export type StatementCandidateTransactionFilter = Readonly<{
  spaceId: string;
  accountId: string;
  periodStart: string;
  periodEnd: string;
  includeCounterpartAccounts: boolean;
}>;

export type StatementMatchDraft = Readonly<{
  key: string;
  spaceId: string;
  accountId: string;
  statementImportId: string;
  componentIds: readonly string[];
  transactionId: string;
  method: StatementMatchMethod;
  reasonCodes: readonly StatementMatchReasonCode[];
  confidence: number;
  signedComponentTotalMinor: number;
  currency: string;
  proposedBy: string | null;
  proposedAt: string;
  proposedOperationId: string;
  supersedesId: string | null;
}>;

export type StatementMatchValidation = Readonly<{
  componentIds: readonly string[];
  componentChecksums: readonly string[];
  transactionId: string;
  accountId: string;
  currency: string;
  signedComponentTotalMinor: number;
  transactionAmountMinor: number;
  flowDirection: "inflow" | "outflow";
  acceptedTransactionDates: readonly string[];
  sourceRowId: string;
  canonicalFinancialDate: string;
}>;

export type StatementReconciliationPersistenceExpectation = Readonly<{
  expectedReconciliationRevision: number | null;
  expectedReconciliationHash: string | null;
}>;

export type StatementReconciliationDraft = Omit<
  StatementReconciliationRecord,
  "id"
>;

export type StatementImportedTransactionDraft = Readonly<{
  key: string;
  spaceId: string;
  accountId: string;
  sourceRowId: string;
  sourceChecksum: string;
  postedAt: string;
  effectiveAt: string;
  description: string;
  amountMinor: number;
  currency: string;
  direction: "debit" | "credit";
  transactionKind: "income" | "expense" | "adjustment" | "unresolved";
  flowDirection: "inflow" | "outflow";
  recordedAt: string;
  operationId: string;
}>;

export type StatementMatchMutationDraft = Readonly<{
  match: StatementMatchDraft;
  validation: StatementMatchValidation;
  operation: OperationDraft;
  reconciliation: StatementReconciliationDraft | null;
}> &
  StatementReconciliationPersistenceExpectation;

export type StatementConfirmationDraft = Readonly<{
  matchId: string;
  expectedRevision: number;
  validation: StatementMatchValidation;
  actorId: string | null;
  confirmedAt: string;
  operation: OperationDraft;
  reconciliation: StatementReconciliationDraft | null;
}> &
  StatementReconciliationPersistenceExpectation;

export type StatementMaterializationDraft = Readonly<{
  statementImportId: string;
  componentIds: readonly string[];
  componentChecksums: readonly string[];
  transferCandidateDates: readonly string[];
  transaction: StatementImportedTransactionDraft;
  match: StatementMatchDraft;
  operation: OperationDraft;
  reconciliation: StatementReconciliationDraft | null;
}> &
  StatementReconciliationPersistenceExpectation;

export type StatementRejectionDraft = Readonly<{
  matchId: string;
  expectedRevision: number;
  reason: string;
  actorId: string | null;
  rejectedAt: string;
  operation: OperationDraft;
  reconciliation: StatementReconciliationDraft | null;
}> &
  StatementReconciliationPersistenceExpectation;

export type StatementMatchSupersessionDraft = Readonly<{
  oldMatchId: string;
  expectedRevision: number;
  reason: string;
  actorId: string | null;
  supersededAt: string;
  replacement: StatementMatchDraft;
  validation: StatementMatchValidation;
  operation: OperationDraft;
  reconciliation: StatementReconciliationDraft | null;
}> &
  StatementReconciliationPersistenceExpectation;

export type StatementIssueAcknowledgementDraft = Readonly<{
  issueId: string;
  expectedRevision: number;
  note: string;
  actorId: string | null;
  acknowledgedAt: string;
  operation: OperationDraft;
  reconciliation: StatementReconciliationDraft | null;
}> &
  StatementReconciliationPersistenceExpectation;

export type StatementImportSupersessionDraft = Readonly<{
  oldImportId: string;
  expectedSourceRevision: number;
  expectedReconciliationRevision: number | null;
  expectedReconciliationHash: string | null;
  reason: string;
  replacement: StatementCommitDraft;
  operation: OperationDraft;
}>;

export type StatementReconciliationMutationDraft = Readonly<{
  statementImportId: string;
  expectedRevision: number | null;
  expectedHash: string | null;
  reconciliation: StatementReconciliationDraft;
  operation: OperationDraft;
}>;

export type StatementAttestationDraft = Readonly<{
  statementImportId: string;
  expectedRevision: number;
  calculationHash: string;
  expectedAccountContext: StatementReviewedAccountContext;
  actorId: string | null;
  attestedAt: string;
  operation: OperationDraft;
}>;

export type StatementReopeningDraft = Readonly<{
  statementImportId: string;
  expectedRevision: number;
  calculationHash: string;
  reason: string;
  actorId: string | null;
  reopenedAt: string;
  operation: OperationDraft;
}>;

export type StatementMatchRepositoryResult = Readonly<{
  match: StatementTransactionMatchRecord;
  reconciliation: StatementReconciliationRecord | null;
  operation: StatementResolutionOperation;
}>;

export type StatementMaterializationRepositoryResult =
  StatementMatchRepositoryResult & Readonly<{ transaction: TransactionRecord }>;

export type StatementIssueRepositoryResult = Readonly<{
  issue: StatementIssueRecord;
  reconciliation: StatementReconciliationRecord | null;
  operation: StatementResolutionOperation;
}>;

export type StatementSupersessionRepositoryResult = Readonly<{
  supersededImport: StatementImportRecord;
  replacementImport: StatementImportRecord;
  reconciliation: StatementReconciliationRecord | null;
  operation: StatementResolutionOperation;
}>;

export type StatementReconciliationRepositoryResult = Readonly<{
  reconciliation: StatementReconciliationRecord;
  event: StatementReconciliationEventRecord | null;
  operation: StatementResolutionOperation;
}>;

export interface StatementResolutionRepository {
  getStatementTransactionMatchIdentity(
    statementImportId: string,
    key: string,
  ): Promise<string>;
  getImportedTransactionIdentity(
    accountId: string,
    key: string,
  ): Promise<string>;
  getResolutionOperation(
    command: StatementResolutionCommand,
    idempotencyKey: string,
  ): Promise<StatementResolutionOperation | null>;
  listCandidateTransactions(
    filter: StatementCandidateTransactionFilter,
  ): Promise<TransactionRecord[]>;
  getResolutionTransaction(id: string): Promise<TransactionRecord | null>;
  listStatementTransactionMatches(
    filter: StatementMatchReadFilter,
  ): Promise<StatementTransactionMatchRecord[]>;
  getStatementTransactionMatch(
    id: string,
  ): Promise<StatementTransactionMatchRecord | null>;
  getStatementReconciliation(
    statementImportId: string,
  ): Promise<StatementReconciliationRecord | null>;
  listStatementReconciliationEvents(
    statementImportId: string,
  ): Promise<StatementReconciliationEventRecord[]>;
  proposeStatementTransactionMatch(
    draft: StatementMatchMutationDraft,
  ): Promise<StatementMatchRepositoryResult>;
  confirmStatementTransactionMatch(
    draft: StatementConfirmationDraft,
  ): Promise<StatementMatchRepositoryResult>;
  materializeStatementComponentTransaction(
    draft: StatementMaterializationDraft,
  ): Promise<StatementMaterializationRepositoryResult>;
  rejectStatementTransactionMatch(
    draft: StatementRejectionDraft,
  ): Promise<StatementMatchRepositoryResult>;
  supersedeStatementTransactionMatch(
    draft: StatementMatchSupersessionDraft,
  ): Promise<StatementMatchRepositoryResult>;
  acknowledgeStatementIssue(
    draft: StatementIssueAcknowledgementDraft,
  ): Promise<StatementIssueRepositoryResult>;
  supersedeStatementImport(
    draft: StatementImportSupersessionDraft,
  ): Promise<StatementSupersessionRepositoryResult>;
  recalculateStatementReconciliation(
    draft: StatementReconciliationMutationDraft,
  ): Promise<StatementReconciliationRepositoryResult>;
  attestStatementReconciled(
    draft: StatementAttestationDraft,
  ): Promise<StatementReconciliationRepositoryResult>;
  reopenStatementReconciliation(
    draft: StatementReopeningDraft,
  ): Promise<StatementReconciliationRepositoryResult>;
}
