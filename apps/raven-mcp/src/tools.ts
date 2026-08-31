import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import {
  createAccountControlTransportHandlers,
  RavenDomainError,
  type AccountControlApi,
  type FinancialAnalyticsApi,
  type StatementTruthApi,
} from "@raven/domain";
import { registerStatementTruthTools } from "./statement-tools.js";
import { registerFinancialAnalyticsTools } from "./financial-analytics-tools.js";

const optionalSpaceKeys = z.array(z.string().min(1)).optional();
const commandMeta = {
  idempotencyKey: z.string().min(8).max(128),
  channel: z.literal("mcp").default("mcp"),
  actorId: z.string().min(1).optional(),
};
const money = z.object({
  currency: z.string().length(3),
  minorUnits: z.number().int().safe(),
});
const accountRef = z.object({
  spaceKey: z.string().min(1),
  accountKey: z.string().min(1),
});
const transactionKind = z.enum([
  "income",
  "expense",
  "transfer",
  "adjustment",
  "unresolved",
]);
const flowDirection = z.enum(["inflow", "outflow"]);
const accountLedgerAuthorityScope = z.enum([
  "active_ledger",
  "active_ledger_with_legacy_unreconciled",
]);
const categoryKind = z.enum([
  "income",
  "expense",
  "transfer",
  "tax",
  "savings",
  "other",
]);
const dateOnly = z.string().regex(/^\d{4}-\d{2}-\d{2}$/);
const cashflowDirection = z.enum(["outflow", "inflow"]);
const cashflowCertainty = z.enum([
  "committed",
  "confirmed",
  "expected",
  "possible",
]);
const cashflowScheduleStatus = z.enum([
  "active",
  "paused",
  "ended",
  "cancelled",
]);
const cashflowOccurrenceStatus = z.enum([
  "due",
  "settled",
  "skipped",
  "waived",
  "cancelled",
]);
const cashflowTitle = z.string().min(1).max(160);
const cashflowNote = z.string().max(500);
const cashflowSearch = z.string().max(160);
const cashflowRecordId = z.string().min(1).max(256);
const cashflowTimezone = z.string().min(1).max(100);
const recurrence = {
  cadence: z.enum(["once", "weekly", "monthly", "quarterly", "yearly"]),
  interval: z.number().int().min(1).max(100),
  startDate: dateOnly,
  endDate: dateOnly.optional(),
  onceDueOn: dateOnly.optional(),
  dayOfWeek: z.number().int().min(1).max(7).optional(),
  dayOfMonth: z.number().int().min(1).max(31).optional(),
  monthOfYear: z.number().int().min(1).max(12).optional(),
  timezone: cashflowTimezone,
};
const scheduleRevision = {
  ...commandMeta,
  scheduleId: cashflowRecordId,
  expectedRevision: z.number().int().min(1),
  effectiveOn: dateOnly,
  note: cashflowNote.optional(),
};
const occurrenceRevision = {
  ...commandMeta,
  occurrenceId: cashflowRecordId,
  expectedRevision: z.number().int().min(1),
  reason: cashflowNote.optional(),
  note: cashflowNote.optional(),
};

function result(value: unknown) {
  return {
    content: [{ type: "text" as const, text: JSON.stringify(value, null, 2) }],
    structuredContent: value as Record<string, unknown>,
  };
}

function errorResult(error: unknown) {
  const payload =
    error instanceof RavenDomainError
      ? { code: error.code, message: error.message, details: error.details }
      : {
          code: "INTERNAL",
          message:
            error instanceof Error ? error.message : "Unknown Raven error",
        };
  return {
    isError: true,
    content: [
      { type: "text" as const, text: JSON.stringify(payload, null, 2) },
    ],
    structuredContent: payload,
  };
}

export function createMcpHandlers(service: AccountControlApi) {
  return createAccountControlTransportHandlers(service).mcp;
}

export function createRavenMcpServer(
  service: AccountControlApi,
  statementService?: StatementTruthApi,
  financialAnalyticsService?: FinancialAnalyticsApi,
): McpServer {
  const server = new McpServer({ name: "raven", version: "0.1.0" });
  const handlers = createMcpHandlers(service);

  if (financialAnalyticsService) {
    registerFinancialAnalyticsTools(server, financialAnalyticsService);
  }

  server.registerTool(
    "list_accounts",
    {
      description:
        "List tracked accounts grouped by financial space, including balance freshness.",
      inputSchema: {
        spaceKeys: optionalSpaceKeys,
        asOf: z.string().optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.list_accounts(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "get_account",
    {
      description:
        "Get one tracked account and its selected as-of balance evidence.",
      inputSchema: {
        spaceKey: z.string().min(1),
        accountKey: z.string().min(1),
        asOf: z.string().optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.get_account(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "get_current_position",
    {
      description:
        "Calculate liquid cash, known assets, liabilities, and known net position with stale, unknown, and invalid-future metadata.",
      inputSchema: {
        spaceKeys: optionalSpaceKeys,
        currency: z.string().length(3),
        asOf: z.string().optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.get_current_position(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "get_account_freshness",
    {
      description:
        "Check which account balances are fresh, stale, unknown, or invalid-future.",
      inputSchema: {
        spaceKeys: optionalSpaceKeys,
        accountKeys: z.array(z.string().min(1)).optional(),
        asOf: z.string().optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.get_account_freshness(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "list_account_transactions",
    {
      description:
        "List an exact account month ledger with separate source-evidence, management-meaning, and tax-readiness states; legacy rows may carry explicit fallback or unresolved-transfer warnings.",
      inputSchema: {
        spaceKey: z.string().min(1),
        accountKey: z.string().min(1),
        month: z.string().length(7),
        authorityScope: accountLedgerAuthorityScope.optional(),
        kind: transactionKind.optional(),
        flow: z.union([flowDirection, z.literal("unknown")]).optional(),
        categoryKey: z.string().optional(),
        search: z.string().optional(),
        cursor: z.string().optional(),
        limit: z.number().int().min(1).max(100).optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.list_account_transactions(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "get_transaction",
    {
      description:
        "Inspect one semantic transaction, its separate evidence/management/tax states, provenance, operation receipt, management category, and linked transfer counterpart.",
      inputSchema: { transactionId: z.string().min(1) },
    },
    async (input) => {
      try {
        return result(await handlers.get_transaction(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "get_month_progress",
    {
      description:
        "Calculate exact observed income, outflow, and net for a month; transfers and ambiguous legacy transfers are excluded.",
      inputSchema: {
        month: z.string().length(7),
        currency: z.string().length(3),
        authorityScope: accountLedgerAuthorityScope.optional(),
        spaceKeys: optionalSpaceKeys,
        accountRefs: z.array(accountRef).optional(),
        asOf: z.string().optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.get_month_progress(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "list_categories",
    {
      description:
        "List active legacy semantic categories for one Financial Space. Non-tax kinds may support management meaning; Category is not an accepted tax-treatment model.",
      inputSchema: {
        spaceKey: z.string().min(1),
        kinds: z.array(categoryKind).optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.list_categories(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "create_account",
    {
      description:
        "Create a tracked financial account with explicit nature, liquidity, and freshness policy.",
      inputSchema: {
        ...commandMeta,
        spaceKey: z.string().min(1),
        accountKey: z.string().min(1),
        name: z.string().min(1),
        bankName: z.string().optional(),
        accountType: z.string().min(1),
        facilityKind: z
          .enum([
            "none",
            "credit_card",
            "overdraft",
            "revolving_credit",
            "loan",
            "other",
          ])
          .optional(),
        currency: z.string().length(3),
        normalNature: z.enum(["asset", "liability"]),
        liquidityClass: z.enum(["liquid", "non_liquid"]),
        freshnessWindowHours: z.number().int().min(1).max(8760),
      },
    },
    async (input) => {
      try {
        return result(await handlers.create_account(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "confirm_account_balance",
    {
      description:
        "Append an immutable as-of account balance confirmation without overwriting prior evidence.",
      inputSchema: {
        ...commandMeta,
        spaceKey: z.string().min(1),
        accountKey: z.string().min(1),
        balanceKind: z.enum([
          "available",
          "ledger",
          "statement",
          "market_value",
          "outstanding",
        ]),
        money,
        economicNature: z.enum(["asset", "liability", "informational"]),
        asOf: z.string().min(1),
        note: z.string().optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.confirm_account_balance(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "record_account_facility_snapshot",
    {
      description:
        "Append dated credit, overdraft, loan, or revolving-facility evidence without overwriting earlier limits or terms. Actual charged fees remain statement transactions; feeTerms are contractual or printed terms only.",
      inputSchema: {
        ...commandMeta,
        spaceKey: z.string().min(1),
        accountKey: z.string().min(1),
        facilityKind: z.enum([
          "credit_card",
          "overdraft",
          "revolving_credit",
          "loan",
          "other",
        ]),
        asOf: z.string().min(1),
        effectiveFrom: dateOnly.optional(),
        evidenceLevel: z.enum(["confirmed", "observed"]),
        sourceKind: z.enum([
          "statement",
          "contract",
          "manual_confirmation",
          "provider_sync",
        ]),
        sourceRef: z.string().optional(),
        statementImportId: z.string().optional(),
        facilityLimit: money.optional(),
        availableCredit: money.optional(),
        minimumPayment: money.optional(),
        paymentDueOn: dateOnly.optional(),
        interestRates: z.record(z.string(), z.unknown()).optional(),
        feeTerms: z.record(z.string(), z.unknown()).optional(),
        terms: z.record(z.string(), z.unknown()).optional(),
        note: z.string().optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.record_account_facility_snapshot(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "record_expense",
    {
      description:
        "Record a provisional observed expense with exact positive money. categoryKey is management-only; later statement evidence must be matched without double counting. This does not mutate account balance evidence.",
      inputSchema: {
        ...commandMeta,
        spaceKey: z.string().min(1),
        accountKey: z.string().min(1),
        money,
        postedAt: z.string().length(10),
        description: z.string().min(1),
        categoryKey: z.string().optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.record_expense(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "record_income",
    {
      description:
        "Record a provisional observed income with exact positive money. categoryKey is management-only; later statement evidence must be matched without double counting. This does not mutate account balance evidence.",
      inputSchema: {
        ...commandMeta,
        spaceKey: z.string().min(1),
        accountKey: z.string().min(1),
        money,
        postedAt: z.string().length(10),
        description: z.string().min(1),
        categoryKey: z.string().optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.record_income(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "record_transfer",
    {
      description:
        "Move exact observed money between two tracked same-currency accounts as linked legs excluded from income and spending.",
      inputSchema: {
        ...commandMeta,
        source: accountRef,
        target: accountRef,
        money,
        postedAt: z.string().length(10),
        description: z.string().optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.record_transfer(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "list_cashflow_schedules",
    {
      description:
        "List source-authority upcoming cashflow schedules with explicit lifecycle and recurrence.",
      inputSchema: {
        spaceKeys: optionalSpaceKeys,
        statuses: z.array(cashflowScheduleStatus).optional(),
        directions: z.array(cashflowDirection).optional(),
        certainties: z.array(cashflowCertainty).optional(),
        asOf: z.string().optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.list_cashflow_schedules(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "get_cashflow_schedule",
    {
      description:
        "Inspect one scheduled cashflow, its materialized occurrences, revision, and operation provenance.",
      inputSchema: {
        scheduleId: cashflowRecordId,
        from: dateOnly.optional(),
        through: dateOnly.optional(),
        asOf: z.string().optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.get_cashflow_schedule(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "list_upcoming_cashflows",
    {
      description:
        "List deterministic upcoming inflow and outflow occurrences for a bounded date horizon.",
      inputSchema: {
        from: dateOnly,
        through: dateOnly,
        spaceKeys: optionalSpaceKeys,
        accountRefs: z.array(accountRef).optional(),
        statuses: z.array(cashflowOccurrenceStatus).optional(),
        directions: z.array(cashflowDirection).optional(),
        certainties: z.array(cashflowCertainty).optional(),
        includeTerminal: z.boolean().optional(),
        search: cashflowSearch.optional(),
        asOf: z.string().optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.list_upcoming_cashflows(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "get_cashflow_occurrence",
    {
      description:
        "Inspect one immutable-identity cashflow occurrence and its current overrides or settlement evidence.",
      inputSchema: {
        occurrenceId: cashflowRecordId,
        asOf: z.string().optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.get_cashflow_occurrence(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "create_scheduled_cashflow",
    {
      description:
        "Create a recurring or one-off source-authority cashflow schedule and materialize its bounded horizon.",
      inputSchema: {
        ...commandMeta,
        ...recurrence,
        spaceKey: z.string().min(1),
        accountKey: z.string().optional(),
        categoryKey: z.string().optional(),
        title: cashflowTitle,
        direction: cashflowDirection,
        certainty: cashflowCertainty,
        money,
        materializeThrough: dateOnly,
        notes: cashflowNote.optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.create_scheduled_cashflow(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "update_scheduled_cashflow",
    {
      description:
        "Revise future schedule terms from an effective date with optimistic concurrency.",
      inputSchema: {
        ...commandMeta,
        scheduleId: cashflowRecordId,
        expectedRevision: z.number().int().min(1),
        effectiveFrom: dateOnly,
        cadence: recurrence.cadence.optional(),
        interval: recurrence.interval.optional(),
        startDate: dateOnly.optional(),
        endDate: dateOnly.optional(),
        onceDueOn: dateOnly.optional(),
        dayOfWeek: recurrence.dayOfWeek,
        dayOfMonth: recurrence.dayOfMonth,
        monthOfYear: recurrence.monthOfYear,
        timezone: recurrence.timezone.optional(),
        accountKey: z.string().nullable().optional(),
        categoryKey: z.string().nullable().optional(),
        title: cashflowTitle.optional(),
        direction: cashflowDirection.optional(),
        certainty: cashflowCertainty.optional(),
        money: money.optional(),
        notes: cashflowNote.optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.update_scheduled_cashflow(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "pause_scheduled_cashflow",
    {
      description: "Pause a cashflow schedule at an effective date.",
      inputSchema: scheduleRevision,
    },
    async (input) => {
      try {
        return result(await handlers.pause_scheduled_cashflow(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );
  server.registerTool(
    "resume_scheduled_cashflow",
    {
      description:
        "Resume a paused schedule and deterministically rematerialize future occurrences.",
      inputSchema: {
        ...commandMeta,
        scheduleId: cashflowRecordId,
        expectedRevision: z.number().int().min(1),
        resumeOn: dateOnly,
        note: cashflowNote.optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.resume_scheduled_cashflow(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );
  server.registerTool(
    "end_scheduled_cashflow",
    {
      description:
        "End a schedule and cancel due occurrences after the effective date.",
      inputSchema: scheduleRevision,
    },
    async (input) => {
      try {
        return result(await handlers.end_scheduled_cashflow(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );
  server.registerTool(
    "cancel_scheduled_cashflow",
    {
      description: "Cancel a schedule and its remaining due occurrences.",
      inputSchema: scheduleRevision,
    },
    async (input) => {
      try {
        return result(await handlers.cancel_scheduled_cashflow(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "settle_cashflow_occurrence",
    {
      description:
        "Mark one due occurrence settled, optionally reconciling it to exact observed transaction evidence.",
      inputSchema: {
        ...occurrenceRevision,
        settledAt: z.string().min(1),
        transactionId: cashflowRecordId.optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.settle_cashflow_occurrence(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );
  server.registerTool(
    "reconcile_cashflow_occurrence",
    {
      description:
        "Attach exact observed transaction evidence to an already settled, unreconciled occurrence.",
      inputSchema: { ...occurrenceRevision, transactionId: cashflowRecordId },
    },
    async (input) => {
      try {
        return result(await handlers.reconcile_cashflow_occurrence(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );
  server.registerTool(
    "skip_cashflow_occurrence",
    {
      description: "Skip one due occurrence without changing its schedule.",
      inputSchema: occurrenceRevision,
    },
    async (input) => {
      try {
        return result(await handlers.skip_cashflow_occurrence(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );
  server.registerTool(
    "waive_cashflow_occurrence",
    {
      description: "Waive one due occurrence without changing its schedule.",
      inputSchema: occurrenceRevision,
    },
    async (input) => {
      try {
        return result(await handlers.waive_cashflow_occurrence(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );
  server.registerTool(
    "cancel_cashflow_occurrence",
    {
      description: "Cancel one due occurrence without changing its schedule.",
      inputSchema: occurrenceRevision,
    },
    async (input) => {
      try {
        return result(await handlers.cancel_cashflow_occurrence(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );
  server.registerTool(
    "override_cashflow_occurrence_amount",
    {
      description:
        "Override one due occurrence amount while preserving the scheduled amount and immutable identity.",
      inputSchema: { ...occurrenceRevision, money },
    },
    async (input) => {
      try {
        return result(
          await handlers.override_cashflow_occurrence_amount(input),
        );
      } catch (error) {
        return errorResult(error);
      }
    },
  );
  server.registerTool(
    "override_cashflow_occurrence_due_date",
    {
      description:
        "Override one due date while preserving its original scheduled date and immutable identity.",
      inputSchema: { ...occurrenceRevision, dueOn: dateOnly },
    },
    async (input) => {
      try {
        return result(
          await handlers.override_cashflow_occurrence_due_date(input),
        );
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  if (statementService) registerStatementTruthTools(server, statementService);
  return server;
}
