import type { MoneyWire } from "./money.js";
import type { RavenWarningCode } from "./errors.js";
import type { CashflowCadence } from "./recurrence.js";

export type Instant = string;
export type AccountNature = "asset" | "liability";
export type LiquidityClass = "liquid" | "non_liquid";
export type FacilityKind =
  | "none"
  | "credit_card"
  | "overdraft"
  | "revolving_credit"
  | "loan"
  | "other";
export type ActiveFacilityKind = Exclude<FacilityKind, "none">;
export type FacilitySourceKind =
  | "statement"
  | "contract"
  | "manual_confirmation"
  | "provider_sync";
export type BalanceKind =
  | "available"
  | "ledger"
  | "statement"
  | "market_value"
  | "outstanding";
export type EconomicNature = "asset" | "liability" | "informational";
export type EvidenceLevel = "confirmed" | "observed";
export type BalanceSourceKind =
  | "manual_confirmation"
  | "statement_closing"
  | "transaction_observation"
  | "provider_sync"
  | "market_quote";
export type OperationChannel = "ui" | "mcp" | "system";
export type TransactionKind =
  | "income"
  | "expense"
  | "transfer"
  | "adjustment"
  | "unresolved";
export type FlowDirection = "inflow" | "outflow";
export type EntrySource = "imported" | "manual" | "generated";
export type TransactionStatus =
  | "imported"
  | "normalized"
  | "matched"
  | "classified"
  | "clarified"
  | "ignored";
export type TransactionEvidenceState =
  | "provisional"
  | "statement_backed"
  | "unresolved";
export type TransactionLedgerAuthority =
  | "active"
  | "legacy_unreconciled"
  | "canonical_historical_superseded";
export type ManagementMeaningState =
  | "unclassified"
  | "classified"
  | "needs_clarification";
export type TaxMeaningState = "not_assessed";
export type CategoryKind =
  | "income"
  | "expense"
  | "transfer"
  | "tax"
  | "savings"
  | "other";
export type AccountRef = Readonly<{ spaceKey: string; accountKey: string }>;
export type CashflowDirection = "outflow" | "inflow";
export type CashflowCertainty =
  | "committed"
  | "confirmed"
  | "expected"
  | "possible";
export type CashflowScheduleStatus =
  | "active"
  | "paused"
  | "ended"
  | "cancelled";
export type CashflowOccurrenceStatus =
  | "due"
  | "settled"
  | "skipped"
  | "waived"
  | "cancelled";
export type CashflowTimingGroup =
  | "overdue"
  | "today"
  | "next_seven_days"
  | "later_this_month"
  | "later"
  | "history";

export type FinancialSpaceRecord = Readonly<{
  id: string;
  key: string;
  name: string;
  spaceType: string;
  currency: string;
}>;

export type AccountRecord = Readonly<{
  id: string;
  spaceId: string;
  spaceKey: string;
  key: string;
  name: string;
  bankName: string;
  accountType: string;
  facilityKind?: FacilityKind;
  currency: string;
  accountNumberLast4?: string | null;
  normalNature: AccountNature;
  liquidityClass: LiquidityClass;
  freshnessWindowHours: number;
  active: boolean;
}>; 

export type FacilitySnapshotRecord = Readonly<{
  id: string;
  key: string;
  spaceId: string;
  accountId: string;
  facilityKind: ActiveFacilityKind;
  currency: string;
  asOf: Instant;
  effectiveFrom?: string | null;
  recordedAt: Instant;
  evidenceLevel: EvidenceLevel;
  sourceKind: FacilitySourceKind;
  sourceRef?: string | null;
  statementImportId?: string | null;
  facilityLimitMinor?: number | null;
  availableCreditMinor?: number | null;
  minimumPaymentMinor?: number | null;
  paymentDueOn?: string | null;
  interestRates: Record<string, unknown>;
  feeTerms: Record<string, unknown>;
  terms: Record<string, unknown>;
  operationId?: string | null;
  notes?: string | null;
}>;

export type BalanceSnapshotRecord = Readonly<{
  id: string;
  key: string;
  spaceId: string;
  accountId: string;
  balanceKind: BalanceKind;
  amountMinor: number;
  currency: string;
  economicNature: EconomicNature;
  asOf: Instant;
  recordedAt: Instant;
  evidenceLevel: EvidenceLevel;
  sourceKind: BalanceSourceKind;
  sourceRef?: string | null;
  operationId?: string | null;
  notes?: string | null;
}>;

export type FinancialOperationRecord = Readonly<{
  id: string;
  key: string;
  command:
    | "create_account"
    | "confirm_account_balance"
    | "record_account_facility_snapshot"
    | "record_expense"
    | "record_income"
    | "record_transfer"
    | "create_scheduled_cashflow"
    | "update_scheduled_cashflow"
    | "pause_scheduled_cashflow"
    | "resume_scheduled_cashflow"
    | "end_scheduled_cashflow"
    | "cancel_scheduled_cashflow"
    | "settle_cashflow_occurrence"
    | "reconcile_cashflow_occurrence"
    | "skip_cashflow_occurrence"
    | "waive_cashflow_occurrence"
    | "cancel_cashflow_occurrence"
    | "override_cashflow_occurrence_amount"
    | "override_cashflow_occurrence_due_date"
    | "commit_statement_import"
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
    | "apply_legacy_statement_resolution"
    | "reverse_legacy_statement_resolution";
  idempotencyKey: string;
  requestHash: string;
  channel: OperationChannel;
  actorId?: string | null;
  status: "applied" | "replayed" | "failed";
  resultRefs: string[];
  warningCodes: RavenWarningCode[];
  auditMeta: Record<string, unknown>;
  recordedAt: Instant;
  completedAt?: Instant | null;
  failureCode?: string | null;
}>;

export type CategoryRecord = Readonly<{
  id: string;
  spaceId: string;
  spaceKey: string;
  key: string;
  name: string;
  kind: CategoryKind;
  parentId?: string | null;
  parentKey?: string | null;
  parentName?: string | null;
  active: boolean;
}>;

export type TransactionRecord = Readonly<{
  id: string;
  key: string;
  spaceId: string;
  spaceKey: string;
  accountId: string;
  accountKey: string;
  postedAt: string | null;
  effectiveAt?: string | null;
  recordedAt: string | null;
  description: string;
  amountMinor: number | null;
  reportedBalanceMinor?: number | null;
  currency: string;
  kind: TransactionKind;
  flowDirection: FlowDirection | null;
  entrySource: EntrySource;
  status: TransactionStatus;
  categoryId?: string | null;
  categoryKey?: string | null;
  categoryName?: string | null;
  categoryKind?: CategoryKind | null;
  merchantName?: string | null;
  notes?: string | null;
  sourceRowId?: string | null;
  statementMatchId?: string | null;
  statementImportId?: string | null;
  statementMatchState?: string | null;
  statementMatchSourceState?: string | null;
  statementImportSourceState?: string | null;
  hasActiveStatementClaim?: boolean;
  hasCanonicalStatementMatchHistory?: boolean;
  ledgerAuthority?: TransactionLedgerAuthority;
  operationId?: string | null;
  transferId?: string | null;
  warnings: RavenWarningCode[];
}>;

export type AccountTransferRecord = Readonly<{
  id: string;
  key: string;
  source: AccountRef & { accountId: string };
  target: AccountRef & { accountId: string };
  amountMinor: number;
  currency: string;
  postedAt: string;
  description?: string | null;
  sourceTransactionId: string;
  targetTransactionId: string;
  operationId: string;
  recordedAt: string;
}>;

export type CashflowScheduleRecord = Readonly<{
  id: string;
  key: string;
  spaceId: string;
  spaceKey: string;
  accountId?: string | null;
  accountKey?: string | null;
  categoryId?: string | null;
  categoryKey?: string | null;
  categoryName?: string | null;
  title: string;
  direction: CashflowDirection;
  certainty: CashflowCertainty;
  amountMinor: number;
  currency: string;
  timezone: string;
  cadence: CashflowCadence;
  interval: number;
  startDate: string;
  endDate?: string | null;
  onceDueOn?: string | null;
  dayOfWeek?: number | null;
  dayOfMonth?: number | null;
  monthOfYear?: number | null;
  status: CashflowScheduleStatus;
  revision: number;
  materializedThrough?: string | null;
  termsEffectiveFrom: string;
  pausedOn?: string | null;
  resumedOn?: string | null;
  endedOn?: string | null;
  cancelledOn?: string | null;
  createdOperationId: string;
  lastOperationId: string;
  recordedAt: string;
  updatedAt: string;
  notes?: string | null;
}>;

export type CashflowOccurrenceRecord = Readonly<{
  id: string;
  scheduleId: string;
  spaceId: string;
  spaceKey: string;
  accountId?: string | null;
  accountKey?: string | null;
  categoryId?: string | null;
  categoryKey?: string | null;
  categoryName?: string | null;
  scheduledDueOn: string;
  dueOn: string;
  scheduleRevision: number;
  revision: number;
  title: string;
  direction: CashflowDirection;
  certainty: CashflowCertainty;
  cadence: CashflowCadence;
  scheduledAmountMinor: number;
  amountMinor: number;
  currency: string;
  status: CashflowOccurrenceStatus;
  settledAt?: string | null;
  transactionId?: string | null;
  overrideReason?: string | null;
  statusReason?: string | null;
  notes?: string | null;
  lastOperationId: string;
  recordedAt: string;
  updatedAt: string;
}>;

export type ClarificationSummary = Readonly<{
  id: string;
  status: string;
  taskType?: string | null;
}>;

export type FreshnessView = Readonly<{
  state: "fresh" | "stale" | "unknown" | "invalid_future";
  ageHours: number | null;
  windowHours: number;
  asOf: Instant | null;
}>;

export type BalanceView = Readonly<{
  snapshotId: string;
  kind: BalanceKind;
  money: MoneyWire;
  economicNature: EconomicNature;
  asOf: Instant;
  recordedAt: Instant;
  evidenceLevel: EvidenceLevel;
  sourceKind: BalanceSourceKind;
  note?: string | null;
}>;

export type AccountSummary = Readonly<{
  id: string;
  spaceKey: string;
  accountKey: string;
  name: string;
  bankName: string;
  accountType: string;
  facilityKind: FacilityKind;
  currency: string;
  accountNumberLast4?: string | null;
  normalNature: AccountNature;
  liquidityClass: LiquidityClass;
  freshnessWindowHours: number;
  selectedBalance: BalanceView | null;
  freshness: FreshnessView;
}>;

export type QueryMeta = Readonly<{
  asOf: Instant;
  currency?: string;
  quality: "complete" | "partial" | "provisional" | "unavailable";
  warnings: RavenWarningCode[];
}>;

export type CommandMeta = Readonly<{
  idempotencyKey: string;
  channel: OperationChannel;
  actorId?: string;
}>;

export type CommandReceipt = Readonly<{
  operationId: string;
  idempotencyKey: string;
  status: "applied" | "replayed";
  entityRefs: string[];
  recordedAt: Instant;
  warnings: RavenWarningCode[];
}>;

export type ListAccountsInput = Readonly<{
  spaceKeys?: string[];
  asOf?: Instant;
}>;
export type ListAccountsOutput = Readonly<{
  spaces: Array<{
    key: string;
    name: string;
    spaceType: string;
    currency: string;
    accounts: AccountSummary[];
  }>;
  meta: QueryMeta;
}>;

export type GetAccountInput = Readonly<{
  spaceKey: string;
  accountKey: string;
  asOf?: Instant;
}>;
export type GetAccountOutput = Readonly<{
  account: AccountSummary;
  facilityHistory: FacilitySnapshotView[];
  availableMonths: string[];
  meta: QueryMeta;
}>;

export type FacilitySnapshotView = Readonly<{
  snapshotId: string;
  facilityKind: ActiveFacilityKind;
  asOf: Instant;
  effectiveFrom?: string | null;
  recordedAt: Instant;
  evidenceLevel: EvidenceLevel;
  sourceKind: FacilitySourceKind;
  sourceRef?: string | null;
  statementImportId?: string | null;
  facilityLimit: MoneyWire | null;
  availableCredit: MoneyWire | null;
  minimumPayment: MoneyWire | null;
  paymentDueOn?: string | null;
  interestRates: Record<string, unknown>;
  feeTerms: Record<string, unknown>;
  terms: Record<string, unknown>;
  note?: string | null;
}>;

export type TransactionView = Readonly<{
  id: string;
  account: AccountRef;
  financialDate: string | null;
  observationDate: string | null;
  financialDateProvenance: "observation" | "statement_source";
  recordedAt: string | null;
  description: string;
  amount: MoneyWire | null;
  reportedBalance: MoneyWire | null;
  kind: TransactionKind;
  flowDirection: FlowDirection | null;
  entrySource: EntrySource;
  status: TransactionStatus;
  evidenceState: TransactionEvidenceState;
  ledgerAuthority: TransactionLedgerAuthority;
  managementMeaningState: ManagementMeaningState;
  taxMeaningState: TaxMeaningState;
  category: Readonly<{ key: string; name: string; kind: CategoryKind }> | null;
  merchantName: string | null;
  transferId: string | null;
  warnings: RavenWarningCode[];
}>;

export type TransactionDetailView = TransactionView &
  Readonly<{
    notes: string | null;
    provenance: Readonly<{
      sourceRowId: string | null;
      statementMatchId: string | null;
      statementImportId: string | null;
      entrySource: EntrySource;
      observationDate: string | null;
      statementFinancialDate: string | null;
    }>;
    operation: Readonly<{
      id: string;
      command: FinancialOperationRecord["command"];
      recordedAt: string;
    }> | null;
    transfer: Readonly<{
      id: string;
      counterpart: AccountRef;
      counterpartTransactionId: string;
    }> | null;
    clarifications: ClarificationSummary[];
  }>;

export type CategoryView = Readonly<{
  key: string;
  name: string;
  kind: CategoryKind;
  parent: Readonly<{ key: string; name: string }> | null;
}>;

export type ListAccountTransactionsInput = Readonly<{
  spaceKey: string;
  accountKey: string;
  month: string;
  authorityScope?: "active_ledger" | "active_ledger_with_legacy_unreconciled";
  kind?: TransactionKind;
  flow?: FlowDirection | "unknown";
  categoryKey?: string;
  search?: string;
  cursor?: string;
  limit?: number;
}>;
export type ListAccountTransactionsOutput = Readonly<{
  account: AccountRef;
  month: string;
  transactions: TransactionView[];
  nextCursor: string | null;
  meta: QueryMeta;
}>;

export type GetTransactionInput = Readonly<{ transactionId: string }>;
export type GetTransactionOutput = Readonly<{
  transaction: TransactionDetailView;
  meta: QueryMeta;
}>;

export type GetMonthProgressInput = Readonly<{
  month: string;
  currency: string;
  authorityScope?: "active_ledger" | "active_ledger_with_legacy_unreconciled";
  spaceKeys?: string[];
  accountRefs?: AccountRef[];
  asOf?: Instant;
}>;
export type GetMonthProgressOutput = Readonly<{
  month: string;
  income: MoneyWire;
  outflow: MoneyWire;
  net: MoneyWire;
  counts: Readonly<{
    income: number;
    expense: number;
    transfer: number;
    uncategorized: number;
  }>;
  meta: QueryMeta;
}>;

export type ListCategoriesInput = Readonly<{
  spaceKey: string;
  kinds?: CategoryKind[];
}>;
export type ListCategoriesOutput = Readonly<{
  categories: CategoryView[];
  meta: QueryMeta;
}>;

export type GetCurrentPositionInput = Readonly<{
  spaceKeys?: string[];
  currency: string;
  asOf?: Instant;
}>;
export type GetCurrentPositionOutput = Readonly<{
  liquidCash: MoneyWire | null;
  knownAssets: MoneyWire;
  knownLiabilities: MoneyWire;
  knownNetPosition: MoneyWire;
  missingAccountIds: string[];
  invalidFutureAccountIds: string[];
  staleAccountIds: string[];
  meta: QueryMeta;
}>;

export type GetAccountFreshnessInput = Readonly<{
  spaceKeys?: string[];
  accountKeys?: string[];
  asOf?: Instant;
}>;
export type GetAccountFreshnessOutput = Readonly<{
  accounts: Array<{
    accountId: string;
    spaceKey: string;
    accountKey: string;
    freshness: FreshnessView;
  }>;
  meta: QueryMeta;
}>;

export type CreateAccountInput = CommandMeta &
  Readonly<{
    spaceKey: string;
    accountKey: string;
    name: string;
    bankName?: string;
    accountType: string;
    facilityKind?: FacilityKind;
    currency: string;
    normalNature: AccountNature;
    liquidityClass: LiquidityClass;
    freshnessWindowHours: number;
  }>;

export type ConfirmAccountBalanceInput = CommandMeta &
  Readonly<{
    spaceKey: string;
    accountKey: string;
    balanceKind: BalanceKind;
    money: MoneyWire;
    economicNature: EconomicNature;
    asOf: Instant;
    note?: string;
  }>;

export type CreateAccountOutput = Readonly<{
  entity: AccountSummary;
  receipt: CommandReceipt;
}>;
export type ConfirmAccountBalanceOutput = Readonly<{
  entity: BalanceView;
  receipt: CommandReceipt;
}>;

export type RecordAccountFacilitySnapshotInput = CommandMeta &
  Readonly<{
    spaceKey: string;
    accountKey: string;
    facilityKind: ActiveFacilityKind;
    asOf: Instant;
    effectiveFrom?: string;
    evidenceLevel: EvidenceLevel;
    sourceKind: FacilitySourceKind;
    sourceRef?: string;
    statementImportId?: string;
    facilityLimit?: MoneyWire;
    availableCredit?: MoneyWire;
    minimumPayment?: MoneyWire;
    paymentDueOn?: string;
    interestRates?: Record<string, unknown>;
    feeTerms?: Record<string, unknown>;
    terms?: Record<string, unknown>;
    note?: string;
  }>;
export type RecordAccountFacilitySnapshotOutput = Readonly<{
  entity: FacilitySnapshotView;
  receipt: CommandReceipt;
}>;

export type RecordTransactionInput = CommandMeta &
  Readonly<{
    spaceKey: string;
    accountKey: string;
    money: MoneyWire;
    postedAt: string;
    description: string;
    categoryKey?: string;
  }>;
export type RecordExpenseInput = RecordTransactionInput;
export type RecordIncomeInput = RecordTransactionInput;
export type RecordTransactionOutput = Readonly<{
  entity: TransactionView;
  receipt: CommandReceipt;
}>;

export type RecordTransferInput = CommandMeta &
  Readonly<{
    source: AccountRef;
    target: AccountRef;
    money: MoneyWire;
    postedAt: string;
    description?: string;
  }>;
export type RecordTransferOutput = Readonly<{
  transfer: Readonly<{
    id: string;
    source: AccountRef;
    target: AccountRef;
    amount: MoneyWire;
    postedAt: string;
    description: string | null;
  }>;
  sourceTransaction: TransactionView;
  targetTransaction: TransactionView;
  receipt: CommandReceipt;
}>;

export type CashflowScheduleView = Readonly<{
  id: string;
  key: string;
  spaceKey: string;
  account: AccountRef | null;
  category: Readonly<{ key: string; name: string }> | null;
  title: string;
  direction: CashflowDirection;
  certainty: CashflowCertainty;
  money: MoneyWire;
  timezone: string;
  cadence: CashflowCadence;
  recurrenceLabel: string;
  interval: number;
  startDate: string;
  endDate: string | null;
  onceDueOn: string | null;
  dayOfWeek: number | null;
  dayOfMonth: number | null;
  monthOfYear: number | null;
  status: CashflowScheduleStatus;
  configuredStatus: CashflowScheduleStatus;
  effectiveStatus: CashflowScheduleStatus;
  pendingTransition: Readonly<{
    status: CashflowScheduleStatus;
    effectiveOn: string;
  }> | null;
  revision: number;
  materializedThrough: string | null;
  termsEffectiveFrom: string;
  pausedOn: string | null;
  resumedOn: string | null;
  endedOn: string | null;
  cancelledOn: string | null;
  nextDueOn: string | null;
  createdOperationId: string;
  lastOperationId: string;
  recordedAt: string;
  updatedAt: string;
  notes: string | null;
}>;

export type CashflowOccurrenceView = Readonly<{
  id: string;
  scheduleId: string;
  spaceKey: string;
  account: AccountRef | null;
  category: Readonly<{ key: string; name: string }> | null;
  scheduledDueOn: string;
  dueOn: string;
  scheduleRevision: number;
  revision: number;
  title: string;
  direction: CashflowDirection;
  certainty: CashflowCertainty;
  cadence: CashflowCadence;
  recurrenceLabel: string;
  scheduledMoney: MoneyWire;
  money: MoneyWire;
  status: CashflowOccurrenceStatus;
  overdue: boolean;
  timing: Readonly<{
    group: CashflowTimingGroup;
    timezone: string;
    localToday: string;
  }>;
  settledAt: string | null;
  transactionId: string | null;
  reconciled: boolean;
  overrideReason: string | null;
  statusReason: string | null;
  notes: string | null;
  lastOperationId: string;
  recordedAt: string;
  updatedAt: string;
  warnings: RavenWarningCode[];
}>;

export type ListCashflowSchedulesInput = Readonly<{
  spaceKeys?: string[];
  statuses?: CashflowScheduleStatus[];
  directions?: CashflowDirection[];
  certainties?: CashflowCertainty[];
  asOf?: string;
}>;
export type ListCashflowSchedulesOutput = Readonly<{
  schedules: CashflowScheduleView[];
  meta: QueryMeta;
}>;
export type GetCashflowScheduleInput = Readonly<{
  scheduleId: string;
  from?: string;
  through?: string;
  asOf?: string;
}>;
export type GetCashflowScheduleOutput = Readonly<{
  schedule: CashflowScheduleView;
  occurrences: CashflowOccurrenceView[];
  operation: FinancialOperationRecord | null;
  operations: FinancialOperationRecord[];
  occurrenceCounts: Readonly<Record<CashflowOccurrenceStatus, number>>;
  meta: QueryMeta;
}>;
export type ListUpcomingCashflowsInput = Readonly<{
  from: string;
  through: string;
  spaceKeys?: string[];
  directions?: CashflowDirection[];
  certainties?: CashflowCertainty[];
  statuses?: CashflowOccurrenceStatus[];
  accountRefs?: AccountRef[];
  search?: string;
  includeTerminal?: boolean;
  asOf?: string;
}>;
export type CashflowCurrencySummary = Readonly<{
  currency: string;
  committedOutflow: MoneyWire;
  confirmedInflow: MoneyWire;
  expectedInflow: MoneyWire;
  possibleInflow: MoneyWire;
  dueCount: number;
  unreconciledCount: number;
}>;
export type ListUpcomingCashflowsOutput = Readonly<{
  occurrences: CashflowOccurrenceView[];
  summaries: CashflowCurrencySummary[];
  meta: QueryMeta;
}>;
export type GetCashflowOccurrenceInput = Readonly<{
  occurrenceId: string;
  asOf?: string;
}>;
export type GetCashflowOccurrenceOutput = Readonly<{
  occurrence: CashflowOccurrenceView;
  schedule: CashflowScheduleView;
  operation: FinancialOperationRecord | null;
  operations: FinancialOperationRecord[];
  settlementCandidates: TransactionView[];
  meta: QueryMeta;
}>;

export type ScheduleRecurrenceInput = Readonly<{
  cadence: CashflowCadence;
  interval: number;
  startDate: string;
  endDate?: string;
  onceDueOn?: string;
  dayOfWeek?: number;
  dayOfMonth?: number;
  monthOfYear?: number;
  timezone: string;
}>;

export type CreateScheduledCashflowInput = CommandMeta &
  ScheduleRecurrenceInput &
  Readonly<{
    spaceKey: string;
    accountKey?: string;
    categoryKey?: string;
    title: string;
    direction: CashflowDirection;
    certainty: CashflowCertainty;
    money: MoneyWire;
    materializeThrough: string;
    notes?: string;
  }>;
export type CreateScheduledCashflowOutput = Readonly<{
  schedule: CashflowScheduleView;
  occurrences: CashflowOccurrenceView[];
  receipt: CommandReceipt;
}>;

export type UpdateScheduledCashflowInput = CommandMeta &
  Partial<ScheduleRecurrenceInput> &
  Readonly<{
    scheduleId: string;
    expectedRevision: number;
    effectiveFrom: string;
    accountKey?: string | null;
    categoryKey?: string | null;
    title?: string;
    direction?: CashflowDirection;
    certainty?: CashflowCertainty;
    money?: MoneyWire;
    notes?: string;
  }>;
export type ScheduleRevisionCommandInput = CommandMeta &
  Readonly<{
    scheduleId: string;
    expectedRevision: number;
    effectiveOn: string;
    note?: string;
  }>;
export type ResumeScheduledCashflowInput = Omit<
  ScheduleRevisionCommandInput,
  "effectiveOn"
> &
  Readonly<{ resumeOn: string; note?: string }>;
export type UpdateScheduledCashflowOutput = Readonly<{
  schedule: CashflowScheduleView;
  occurrences: CashflowOccurrenceView[];
  receipt: CommandReceipt;
}>;

export type OccurrenceRevisionCommandInput = CommandMeta &
  Readonly<{
    occurrenceId: string;
    expectedRevision: number;
    reason?: string;
    note?: string;
  }>;
export type SettleCashflowOccurrenceInput = OccurrenceRevisionCommandInput &
  Readonly<{ settledAt: string; transactionId?: string }>;
export type ReconcileCashflowOccurrenceInput = OccurrenceRevisionCommandInput &
  Readonly<{ transactionId: string }>;
export type OverrideCashflowOccurrenceAmountInput =
  OccurrenceRevisionCommandInput & Readonly<{ money: MoneyWire }>;
export type OverrideCashflowOccurrenceDueDateInput =
  OccurrenceRevisionCommandInput & Readonly<{ dueOn: string }>;
export type UpdateCashflowOccurrenceOutput = Readonly<{
  occurrence: CashflowOccurrenceView;
  receipt: CommandReceipt;
}>;

export interface AccountControlApi {
  listAccounts(input: ListAccountsInput): Promise<ListAccountsOutput>;
  getAccount(input: GetAccountInput): Promise<GetAccountOutput>;
  getCurrentPosition(
    input: GetCurrentPositionInput,
  ): Promise<GetCurrentPositionOutput>;
  getAccountFreshness(
    input: GetAccountFreshnessInput,
  ): Promise<GetAccountFreshnessOutput>;
  listAccountTransactions(
    input: ListAccountTransactionsInput,
  ): Promise<ListAccountTransactionsOutput>;
  getTransaction(input: GetTransactionInput): Promise<GetTransactionOutput>;
  getMonthProgress(
    input: GetMonthProgressInput,
  ): Promise<GetMonthProgressOutput>;
  listCategories(input: ListCategoriesInput): Promise<ListCategoriesOutput>;
  createAccount(input: CreateAccountInput): Promise<CreateAccountOutput>;
  confirmAccountBalance(
    input: ConfirmAccountBalanceInput,
  ): Promise<ConfirmAccountBalanceOutput>;
  recordAccountFacilitySnapshot(
    input: RecordAccountFacilitySnapshotInput,
  ): Promise<RecordAccountFacilitySnapshotOutput>;
  recordExpense(input: RecordExpenseInput): Promise<RecordTransactionOutput>;
  recordIncome(input: RecordIncomeInput): Promise<RecordTransactionOutput>;
  recordTransfer(input: RecordTransferInput): Promise<RecordTransferOutput>;
  listCashflowSchedules(
    input: ListCashflowSchedulesInput,
  ): Promise<ListCashflowSchedulesOutput>;
  getCashflowSchedule(
    input: GetCashflowScheduleInput,
  ): Promise<GetCashflowScheduleOutput>;
  listUpcomingCashflows(
    input: ListUpcomingCashflowsInput,
  ): Promise<ListUpcomingCashflowsOutput>;
  getCashflowOccurrence(
    input: GetCashflowOccurrenceInput,
  ): Promise<GetCashflowOccurrenceOutput>;
  createScheduledCashflow(
    input: CreateScheduledCashflowInput,
  ): Promise<CreateScheduledCashflowOutput>;
  updateScheduledCashflow(
    input: UpdateScheduledCashflowInput,
  ): Promise<UpdateScheduledCashflowOutput>;
  pauseScheduledCashflow(
    input: ScheduleRevisionCommandInput,
  ): Promise<UpdateScheduledCashflowOutput>;
  resumeScheduledCashflow(
    input: ResumeScheduledCashflowInput,
  ): Promise<UpdateScheduledCashflowOutput>;
  endScheduledCashflow(
    input: ScheduleRevisionCommandInput,
  ): Promise<UpdateScheduledCashflowOutput>;
  cancelScheduledCashflow(
    input: ScheduleRevisionCommandInput,
  ): Promise<UpdateScheduledCashflowOutput>;
  settleCashflowOccurrence(
    input: SettleCashflowOccurrenceInput,
  ): Promise<UpdateCashflowOccurrenceOutput>;
  reconcileCashflowOccurrence(
    input: ReconcileCashflowOccurrenceInput,
  ): Promise<UpdateCashflowOccurrenceOutput>;
  skipCashflowOccurrence(
    input: OccurrenceRevisionCommandInput,
  ): Promise<UpdateCashflowOccurrenceOutput>;
  waiveCashflowOccurrence(
    input: OccurrenceRevisionCommandInput,
  ): Promise<UpdateCashflowOccurrenceOutput>;
  cancelCashflowOccurrence(
    input: OccurrenceRevisionCommandInput,
  ): Promise<UpdateCashflowOccurrenceOutput>;
  overrideCashflowOccurrenceAmount(
    input: OverrideCashflowOccurrenceAmountInput,
  ): Promise<UpdateCashflowOccurrenceOutput>;
  overrideCashflowOccurrenceDueDate(
    input: OverrideCashflowOccurrenceDueDateInput,
  ): Promise<UpdateCashflowOccurrenceOutput>;
}
