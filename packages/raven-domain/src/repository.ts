import type {
  AccountRecord,
  AccountTransferRecord,
  BalanceSnapshotRecord,
  CashflowOccurrenceRecord,
  CashflowOccurrenceStatus,
  CashflowScheduleRecord,
  CashflowScheduleStatus,
  CategoryRecord,
  ClarificationSummary,
  CreateAccountInput,
  FinancialOperationRecord,
  FinancialSpaceRecord,
  FacilitySnapshotRecord,
  RecordTransactionInput,
  RecordTransferInput,
  TransactionRecord,
  TransactionKind,
  FlowDirection,
} from "./contracts.js";
import type { RavenWarningCode } from "./errors.js";

export type OperationDraft = Readonly<{
  key: string;
  command: FinancialOperationRecord["command"];
  idempotencyKey: string;
  requestHash: string;
  channel: FinancialOperationRecord["channel"];
  actorId?: string;
  recordedAt: string;
  warningCodes?: RavenWarningCode[];
  auditMeta?: Record<string, unknown>;
  resultRefs?: string[];
}>;

export type BalanceSnapshotDraft = Omit<BalanceSnapshotRecord, "id">;
export type FacilitySnapshotDraft = Omit<FacilitySnapshotRecord, "id">;

export type TransactionDraft = Readonly<{
  key: string;
  spaceId: string;
  spaceKey: string;
  accountId: string;
  accountKey: string;
  postedAt: string;
  recordedAt: string;
  description: string;
  amountMinor: number;
  currency: string;
  kind: Exclude<TransactionKind, "transfer" | "unresolved">;
  flowDirection: FlowDirection;
  categoryId?: string | null;
  operationId: string;
}>;

export type TransferDraft = Readonly<{
  key: string;
  sourceTransactionKey: string;
  targetTransactionKey: string;
  sourceAccount: AccountRecord;
  targetAccount: AccountRecord;
  postedAt: string;
  recordedAt: string;
  description?: string | null;
  amountMinor: number;
  currency: string;
  operationId: string;
}>;

export type TransactionReadFilter = Readonly<{
  accountIds?: string[];
  month?: string;
  includeLegacyUnreconciled?: boolean;
}>;

export type CashflowScheduleDraft = Omit<CashflowScheduleRecord, "id">;
export type CashflowOccurrenceDraft = Omit<CashflowOccurrenceRecord, "id">;
export type CashflowScheduleReadFilter = Readonly<{
  spaceKeys?: string[];
  statuses?: CashflowScheduleStatus[];
}>;
export type CashflowOccurrenceReadFilter = Readonly<{
  scheduleIds?: string[];
  spaceKeys?: string[];
  statuses?: CashflowOccurrenceStatus[];
  from?: string;
  through?: string;
}>;
export type CashflowOccurrencePatch = Partial<
  Omit<
    CashflowOccurrenceRecord,
    | "id"
    | "scheduleId"
    | "spaceId"
    | "spaceKey"
    | "scheduledDueOn"
    | "recordedAt"
  >
>;
export type CashflowSchedulePatch = Partial<
  Omit<
    CashflowScheduleRecord,
    "id" | "key" | "spaceId" | "spaceKey" | "recordedAt" | "createdOperationId"
  >
>;
export type CashflowScheduleMutation = Readonly<{
  scheduleId: string;
  expectedRevision: number;
  expectedStatus: CashflowScheduleStatus;
  patch: CashflowSchedulePatch;
  createOccurrences: CashflowOccurrenceDraft[];
  occurrencePatches: Array<{
    occurrenceId: string;
    expectedRevision: number;
    expectedStatus: CashflowOccurrenceStatus;
    patch: CashflowOccurrencePatch;
  }>;
}>;
export type CashflowOccurrenceMutation = Readonly<{
  occurrenceId: string;
  expectedRevision: number;
  expectedStatus: CashflowOccurrenceStatus;
  patch: CashflowOccurrencePatch;
  settlementTransactionId?: string;
}>;

export interface AccountControlRepository {
  listSpaces(spaceKeys?: string[]): Promise<FinancialSpaceRecord[]>;
  listAccounts(spaceKeys?: string[]): Promise<AccountRecord[]>;
  getAccount(
    spaceKey: string,
    accountKey: string,
  ): Promise<AccountRecord | null>;
  listBalanceSnapshots(accountIds: string[]): Promise<BalanceSnapshotRecord[]>;
  getBalanceSnapshot(id: string): Promise<BalanceSnapshotRecord | null>;
  listFacilitySnapshots?(accountIds: string[]): Promise<FacilitySnapshotRecord[]>;
  getFacilitySnapshot?(id: string): Promise<FacilitySnapshotRecord | null>;
  listTransactions(
    filter?: TransactionReadFilter,
  ): Promise<TransactionRecord[]>;
  getTransaction(id: string): Promise<TransactionRecord | null>;
  listCategories(spaceKey: string): Promise<CategoryRecord[]>;
  getCategory(
    spaceKey: string,
    categoryKey: string,
  ): Promise<CategoryRecord | null>;
  getOperationById(id: string): Promise<FinancialOperationRecord | null>;
  getTransfer(id: string): Promise<AccountTransferRecord | null>;
  listClarifications(transactionId: string): Promise<ClarificationSummary[]>;
  getOperation(
    command: FinancialOperationRecord["command"],
    idempotencyKey: string,
  ): Promise<FinancialOperationRecord | null>;
  listOperationsForEntity?(
    entityId: string,
  ): Promise<FinancialOperationRecord[]>;
  listCashflowSchedules?(
    filter?: CashflowScheduleReadFilter,
  ): Promise<CashflowScheduleRecord[]>;
  getCashflowSchedule?(id: string): Promise<CashflowScheduleRecord | null>;
  listCashflowOccurrences?(
    filter?: CashflowOccurrenceReadFilter,
  ): Promise<CashflowOccurrenceRecord[]>;
  getCashflowOccurrence?(id: string): Promise<CashflowOccurrenceRecord | null>;
  createAccountWithOperation(
    input: CreateAccountInput,
    operation: OperationDraft,
  ): Promise<{ account: AccountRecord; operation: FinancialOperationRecord }>;
  confirmBalanceWithOperation(
    snapshot: BalanceSnapshotDraft,
    operation: OperationDraft,
  ): Promise<{
    snapshot: BalanceSnapshotRecord;
    operation: FinancialOperationRecord;
  }>;
  recordFacilitySnapshotWithOperation?(
    snapshot: FacilitySnapshotDraft,
    operation: OperationDraft,
  ): Promise<{
    snapshot: FacilitySnapshotRecord;
    operation: FinancialOperationRecord;
  }>;
  recordTransactionWithOperation(
    transaction: TransactionDraft,
    operation: OperationDraft,
  ): Promise<{
    transaction: TransactionRecord;
    operation: FinancialOperationRecord;
  }>;
  recordTransferWithOperation(
    transfer: TransferDraft,
    operation: OperationDraft,
  ): Promise<{
    transfer: AccountTransferRecord;
    sourceTransaction: TransactionRecord;
    targetTransaction: TransactionRecord;
    operation: FinancialOperationRecord;
  }>;
  createCashflowScheduleWithOperation?(
    schedule: CashflowScheduleDraft,
    occurrences: CashflowOccurrenceDraft[],
    operation: OperationDraft,
  ): Promise<{
    schedule: CashflowScheduleRecord;
    occurrences: CashflowOccurrenceRecord[];
    operation: FinancialOperationRecord;
  }>;
  mutateCashflowScheduleWithOperation?(
    mutation: CashflowScheduleMutation,
    operation: OperationDraft,
  ): Promise<{
    schedule: CashflowScheduleRecord;
    occurrences: CashflowOccurrenceRecord[];
    operation: FinancialOperationRecord;
  }>;
  materializeCashflowOccurrences?(
    scheduleId: string,
    expectedRevision: number,
    through: string,
    occurrences: CashflowOccurrenceDraft[],
  ): Promise<{
    schedule: CashflowScheduleRecord;
    occurrences: CashflowOccurrenceRecord[];
  }>;
  mutateCashflowOccurrenceWithOperation?(
    mutation: CashflowOccurrenceMutation,
    operation: OperationDraft,
  ): Promise<{
    occurrence: CashflowOccurrenceRecord;
    operation: FinancialOperationRecord;
  }>;
}
