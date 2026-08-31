import type { AccountControlApi } from './contracts.js'

export function createAccountControlTransportHandlers(service: AccountControlApi) {
  const trpc = {
    listAccounts: (input: Parameters<AccountControlApi['listAccounts']>[0]) => service.listAccounts(input),
    getAccount: (input: Parameters<AccountControlApi['getAccount']>[0]) => service.getAccount(input),
    getCurrentPosition: (input: Parameters<AccountControlApi['getCurrentPosition']>[0]) =>
      service.getCurrentPosition(input),
    getAccountFreshness: (input: Parameters<AccountControlApi['getAccountFreshness']>[0]) =>
      service.getAccountFreshness(input),
    listAccountTransactions: (input: Parameters<AccountControlApi['listAccountTransactions']>[0]) =>
      service.listAccountTransactions(input),
    getTransaction: (input: Parameters<AccountControlApi['getTransaction']>[0]) =>
      service.getTransaction(input),
    getMonthProgress: (input: Parameters<AccountControlApi['getMonthProgress']>[0]) =>
      service.getMonthProgress(input),
    listCategories: (input: Parameters<AccountControlApi['listCategories']>[0]) =>
      service.listCategories(input),
    createAccount: (input: Parameters<AccountControlApi['createAccount']>[0]) => service.createAccount(input),
    confirmAccountBalance: (input: Parameters<AccountControlApi['confirmAccountBalance']>[0]) =>
      service.confirmAccountBalance(input),
    recordAccountFacilitySnapshot: (input: Parameters<AccountControlApi['recordAccountFacilitySnapshot']>[0]) =>
      service.recordAccountFacilitySnapshot(input),
    recordExpense: (input: Parameters<AccountControlApi['recordExpense']>[0]) => service.recordExpense(input),
    recordIncome: (input: Parameters<AccountControlApi['recordIncome']>[0]) => service.recordIncome(input),
    recordTransfer: (input: Parameters<AccountControlApi['recordTransfer']>[0]) => service.recordTransfer(input),
    listCashflowSchedules: (input: Parameters<AccountControlApi['listCashflowSchedules']>[0]) => service.listCashflowSchedules(input),
    getCashflowSchedule: (input: Parameters<AccountControlApi['getCashflowSchedule']>[0]) => service.getCashflowSchedule(input),
    listUpcomingCashflows: (input: Parameters<AccountControlApi['listUpcomingCashflows']>[0]) => service.listUpcomingCashflows(input),
    getCashflowOccurrence: (input: Parameters<AccountControlApi['getCashflowOccurrence']>[0]) => service.getCashflowOccurrence(input),
    createScheduledCashflow: (input: Parameters<AccountControlApi['createScheduledCashflow']>[0]) => service.createScheduledCashflow(input),
    updateScheduledCashflow: (input: Parameters<AccountControlApi['updateScheduledCashflow']>[0]) => service.updateScheduledCashflow(input),
    pauseScheduledCashflow: (input: Parameters<AccountControlApi['pauseScheduledCashflow']>[0]) => service.pauseScheduledCashflow(input),
    resumeScheduledCashflow: (input: Parameters<AccountControlApi['resumeScheduledCashflow']>[0]) => service.resumeScheduledCashflow(input),
    endScheduledCashflow: (input: Parameters<AccountControlApi['endScheduledCashflow']>[0]) => service.endScheduledCashflow(input),
    cancelScheduledCashflow: (input: Parameters<AccountControlApi['cancelScheduledCashflow']>[0]) => service.cancelScheduledCashflow(input),
    settleCashflowOccurrence: (input: Parameters<AccountControlApi['settleCashflowOccurrence']>[0]) => service.settleCashflowOccurrence(input),
    reconcileCashflowOccurrence: (input: Parameters<AccountControlApi['reconcileCashflowOccurrence']>[0]) => service.reconcileCashflowOccurrence(input),
    skipCashflowOccurrence: (input: Parameters<AccountControlApi['skipCashflowOccurrence']>[0]) => service.skipCashflowOccurrence(input),
    waiveCashflowOccurrence: (input: Parameters<AccountControlApi['waiveCashflowOccurrence']>[0]) => service.waiveCashflowOccurrence(input),
    cancelCashflowOccurrence: (input: Parameters<AccountControlApi['cancelCashflowOccurrence']>[0]) => service.cancelCashflowOccurrence(input),
    overrideCashflowOccurrenceAmount: (input: Parameters<AccountControlApi['overrideCashflowOccurrenceAmount']>[0]) => service.overrideCashflowOccurrenceAmount(input),
    overrideCashflowOccurrenceDueDate: (input: Parameters<AccountControlApi['overrideCashflowOccurrenceDueDate']>[0]) => service.overrideCashflowOccurrenceDueDate(input),
  }

  return {
    trpc,
    mcp: {
      list_accounts: trpc.listAccounts,
      get_account: trpc.getAccount,
      get_current_position: trpc.getCurrentPosition,
      get_account_freshness: trpc.getAccountFreshness,
      list_account_transactions: trpc.listAccountTransactions,
      get_transaction: trpc.getTransaction,
      get_month_progress: trpc.getMonthProgress,
      list_categories: trpc.listCategories,
      create_account: trpc.createAccount,
      confirm_account_balance: trpc.confirmAccountBalance,
      record_account_facility_snapshot: trpc.recordAccountFacilitySnapshot,
      record_expense: trpc.recordExpense,
      record_income: trpc.recordIncome,
      record_transfer: trpc.recordTransfer,
      list_cashflow_schedules: trpc.listCashflowSchedules,
      get_cashflow_schedule: trpc.getCashflowSchedule,
      list_upcoming_cashflows: trpc.listUpcomingCashflows,
      get_cashflow_occurrence: trpc.getCashflowOccurrence,
      create_scheduled_cashflow: trpc.createScheduledCashflow,
      update_scheduled_cashflow: trpc.updateScheduledCashflow,
      pause_scheduled_cashflow: trpc.pauseScheduledCashflow,
      resume_scheduled_cashflow: trpc.resumeScheduledCashflow,
      end_scheduled_cashflow: trpc.endScheduledCashflow,
      cancel_scheduled_cashflow: trpc.cancelScheduledCashflow,
      settle_cashflow_occurrence: trpc.settleCashflowOccurrence,
      reconcile_cashflow_occurrence: trpc.reconcileCashflowOccurrence,
      skip_cashflow_occurrence: trpc.skipCashflowOccurrence,
      waive_cashflow_occurrence: trpc.waiveCashflowOccurrence,
      cancel_cashflow_occurrence: trpc.cancelCashflowOccurrence,
      override_cashflow_occurrence_amount: trpc.overrideCashflowOccurrenceAmount,
      override_cashflow_occurrence_due_date: trpc.overrideCashflowOccurrenceDueDate,
    },
  }
}
