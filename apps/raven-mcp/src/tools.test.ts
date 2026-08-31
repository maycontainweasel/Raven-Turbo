import assert from "node:assert/strict";
import test from "node:test";
import {
  createAccountControlTransportHandlers,
  type AccountControlApi,
} from "@raven/domain";
import { createMcpHandlers } from "./tools.js";

test("Studio tRPC and MCP names return contract-equivalent outputs for all thirty operations", async () => {
  const output = (operation: string, input: unknown) => ({ operation, input });
  const service = {
    listAccounts: async (input: unknown) => output("listAccounts", input),
    getAccount: async (input: unknown) => output("getAccount", input),
    getCurrentPosition: async (input: unknown) =>
      output("getCurrentPosition", input),
    getAccountFreshness: async (input: unknown) =>
      output("getAccountFreshness", input),
    listAccountTransactions: async (input: unknown) =>
      output("listAccountTransactions", input),
    getTransaction: async (input: unknown) => output("getTransaction", input),
    getMonthProgress: async (input: unknown) =>
      output("getMonthProgress", input),
    listCategories: async (input: unknown) => output("listCategories", input),
    createAccount: async (input: unknown) => output("createAccount", input),
    confirmAccountBalance: async (input: unknown) =>
      output("confirmAccountBalance", input),
    recordExpense: async (input: unknown) => output("recordExpense", input),
    recordIncome: async (input: unknown) => output("recordIncome", input),
    recordTransfer: async (input: unknown) => output("recordTransfer", input),
    listCashflowSchedules: async (input: unknown) =>
      output("listCashflowSchedules", input),
    getCashflowSchedule: async (input: unknown) =>
      output("getCashflowSchedule", input),
    listUpcomingCashflows: async (input: unknown) =>
      output("listUpcomingCashflows", input),
    getCashflowOccurrence: async (input: unknown) =>
      output("getCashflowOccurrence", input),
    createScheduledCashflow: async (input: unknown) =>
      output("createScheduledCashflow", input),
    updateScheduledCashflow: async (input: unknown) =>
      output("updateScheduledCashflow", input),
    pauseScheduledCashflow: async (input: unknown) =>
      output("pauseScheduledCashflow", input),
    resumeScheduledCashflow: async (input: unknown) =>
      output("resumeScheduledCashflow", input),
    endScheduledCashflow: async (input: unknown) =>
      output("endScheduledCashflow", input),
    cancelScheduledCashflow: async (input: unknown) =>
      output("cancelScheduledCashflow", input),
    settleCashflowOccurrence: async (input: unknown) =>
      output("settleCashflowOccurrence", input),
    reconcileCashflowOccurrence: async (input: unknown) =>
      output("reconcileCashflowOccurrence", input),
    skipCashflowOccurrence: async (input: unknown) =>
      output("skipCashflowOccurrence", input),
    waiveCashflowOccurrence: async (input: unknown) =>
      output("waiveCashflowOccurrence", input),
    cancelCashflowOccurrence: async (input: unknown) =>
      output("cancelCashflowOccurrence", input),
    overrideCashflowOccurrenceAmount: async (input: unknown) =>
      output("overrideCashflowOccurrenceAmount", input),
    overrideCashflowOccurrenceDueDate: async (input: unknown) =>
      output("overrideCashflowOccurrenceDueDate", input),
  } as unknown as AccountControlApi;
  const trpc = createAccountControlTransportHandlers(service).trpc;
  const mcp = createMcpHandlers(service);
  const asOf = "2026-07-11T10:00:00.000Z";
  const listInput = { spaceKeys: ["fictional-personal"], asOf };
  const accountInput = {
    spaceKey: "fictional-personal",
    accountKey: "fictional-daily",
    asOf,
  };
  const positionInput = {
    spaceKeys: ["fictional-personal"],
    currency: "ZAR",
    asOf,
  };
  const freshnessInput = {
    spaceKeys: ["fictional-personal"],
    accountKeys: ["fictional-daily"],
    asOf,
  };
  const createInput = {
    idempotencyKey: "fictional-create-001",
    channel: "mcp" as const,
    spaceKey: "fictional-personal",
    accountKey: "fictional-daily",
    name: "Fictional Daily",
    accountType: "current",
    currency: "ZAR",
    normalNature: "asset" as const,
    liquidityClass: "liquid" as const,
    freshnessWindowHours: 72,
  };
  const balanceInput = {
    idempotencyKey: "fictional-balance-001",
    channel: "mcp" as const,
    spaceKey: "fictional-personal",
    accountKey: "fictional-daily",
    balanceKind: "available" as const,
    money: { currency: "ZAR", minorUnits: 12_345 },
    economicNature: "asset" as const,
    asOf,
  };
  const ledgerInput = {
    ...accountInput,
    month: "2026-07",
    authorityScope: "active_ledger_with_legacy_unreconciled" as const,
    limit: 25,
  };
  const transactionInput = { transactionId: "transaction:fictional-entry" };
  const progressInput = {
    month: "2026-07",
    currency: "ZAR",
    authorityScope: "active_ledger_with_legacy_unreconciled" as const,
    accountRefs: [accountInput],
  };
  const categoriesInput = {
    spaceKey: "fictional-personal",
    kinds: ["expense" as const],
  };
  const movementInput = {
    idempotencyKey: "fictional-expense-001",
    channel: "mcp" as const,
    spaceKey: "fictional-personal",
    accountKey: "fictional-daily",
    money: { currency: "ZAR", minorUnits: 1_250 },
    postedAt: "2026-07-10",
    description: "Fictional movement",
  };
  const transferInput = {
    idempotencyKey: "fictional-transfer-001",
    channel: "mcp" as const,
    source: { spaceKey: "fictional-personal", accountKey: "fictional-daily" },
    target: { spaceKey: "fictional-personal", accountKey: "fictional-savings" },
    money: { currency: "ZAR", minorUnits: 5_000 },
    postedAt: "2026-07-10",
  };

  assert.deepEqual(
    await mcp.list_accounts(listInput),
    await trpc.listAccounts(listInput),
  );
  assert.deepEqual(
    await mcp.get_account(accountInput),
    await trpc.getAccount(accountInput),
  );
  assert.deepEqual(
    await mcp.get_current_position(positionInput),
    await trpc.getCurrentPosition(positionInput),
  );
  assert.deepEqual(
    await mcp.get_account_freshness(freshnessInput),
    await trpc.getAccountFreshness(freshnessInput),
  );
  assert.deepEqual(
    await mcp.create_account(createInput),
    await trpc.createAccount(createInput),
  );
  assert.deepEqual(
    await mcp.confirm_account_balance(balanceInput),
    await trpc.confirmAccountBalance(balanceInput),
  );
  assert.deepEqual(
    await mcp.list_account_transactions(ledgerInput),
    await trpc.listAccountTransactions(ledgerInput),
  );
  assert.deepEqual(
    await mcp.get_transaction(transactionInput),
    await trpc.getTransaction(transactionInput),
  );
  assert.deepEqual(
    await mcp.get_month_progress(progressInput),
    await trpc.getMonthProgress(progressInput),
  );
  assert.deepEqual(
    await mcp.list_categories(categoriesInput),
    await trpc.listCategories(categoriesInput),
  );
  assert.deepEqual(
    await mcp.record_expense(movementInput),
    await trpc.recordExpense(movementInput),
  );
  assert.deepEqual(
    await mcp.record_income({
      ...movementInput,
      idempotencyKey: "fictional-income-001",
    }),
    await trpc.recordIncome({
      ...movementInput,
      idempotencyKey: "fictional-income-001",
    }),
  );
  assert.deepEqual(
    await mcp.record_transfer(transferInput),
    await trpc.recordTransfer(transferInput),
  );

  const cashflowInput = { fixture: "fictional-cashflow" } as any;
  const cashflowPairs = [
    ["list_cashflow_schedules", "listCashflowSchedules"],
    ["get_cashflow_schedule", "getCashflowSchedule"],
    ["list_upcoming_cashflows", "listUpcomingCashflows"],
    ["get_cashflow_occurrence", "getCashflowOccurrence"],
    ["create_scheduled_cashflow", "createScheduledCashflow"],
    ["update_scheduled_cashflow", "updateScheduledCashflow"],
    ["pause_scheduled_cashflow", "pauseScheduledCashflow"],
    ["resume_scheduled_cashflow", "resumeScheduledCashflow"],
    ["end_scheduled_cashflow", "endScheduledCashflow"],
    ["cancel_scheduled_cashflow", "cancelScheduledCashflow"],
    ["settle_cashflow_occurrence", "settleCashflowOccurrence"],
    ["reconcile_cashflow_occurrence", "reconcileCashflowOccurrence"],
    ["skip_cashflow_occurrence", "skipCashflowOccurrence"],
    ["waive_cashflow_occurrence", "waiveCashflowOccurrence"],
    ["cancel_cashflow_occurrence", "cancelCashflowOccurrence"],
    ["override_cashflow_occurrence_amount", "overrideCashflowOccurrenceAmount"],
    [
      "override_cashflow_occurrence_due_date",
      "overrideCashflowOccurrenceDueDate",
    ],
  ] as const;
  for (const [mcpName, trpcName] of cashflowPairs) {
    assert.deepEqual(
      await mcp[mcpName](cashflowInput),
      await trpc[trpcName](cashflowInput),
    );
  }
});

test("schedule lifecycle truth fields remain identical through Studio tRPC and MCP adapters", async () => {
  const output = {
    schedules: [
      {
        id: "cashflowSchedule:fictional",
        status: "ended",
        configuredStatus: "ended",
        effectiveStatus: "paused",
        pendingTransition: { status: "ended", effectiveOn: "2026-05-31" },
      },
    ],
    meta: {
      asOf: "2026-04-30T10:00:00.000Z",
      quality: "complete",
      warnings: [],
    },
  };
  const service = {
    listCashflowSchedules: async () => output,
  } as unknown as AccountControlApi;
  const trpc = createAccountControlTransportHandlers(service).trpc;
  const mcp = createMcpHandlers(service);
  const input = { asOf: output.meta.asOf };
  const trpcResult = await trpc.listCashflowSchedules(input);
  const mcpResult = await mcp.list_cashflow_schedules(input);
  assert.deepEqual(mcpResult, trpcResult);
  assert.deepEqual(
    (mcpResult as unknown as typeof output).schedules[0],
    output.schedules[0],
  );
});
