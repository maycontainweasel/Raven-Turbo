import { z } from "zod";
import {
  createAccountControlTransportHandlers,
  RavenDomainError,
} from "@raven/domain";
import { TRPCError } from "@trpc/server";
import { t } from "@schema/server/trpc/context";
import { getAccountControlService } from "../../services/account-control";

const Instant = z.string().min(1);
const SpaceKeys = z.array(z.string().min(1)).optional();
const CommandMeta = z.object({
  idempotencyKey: z.string().min(8).max(128),
  channel: z.enum(["ui", "mcp", "system"]),
  actorId: z.string().min(1).optional(),
});
const Money = z.object({
  currency: z.string().min(3).max(3),
  minorUnits: z.number().int().safe(),
});
const AccountRef = z.object({
  spaceKey: z.string().min(1),
  accountKey: z.string().min(1),
});
const TransactionKind = z.enum([
  "income",
  "expense",
  "transfer",
  "adjustment",
  "unresolved",
]);
const FlowDirection = z.enum(["inflow", "outflow"]);
const AccountLedgerAuthorityScope = z.enum([
  "active_ledger",
  "active_ledger_with_legacy_unreconciled",
]);
const CategoryKind = z.enum([
  "income",
  "expense",
  "transfer",
  "tax",
  "savings",
  "other",
]);
const DateOnly = z.string().regex(/^\d{4}-\d{2}-\d{2}$/);
const CashflowDirection = z.enum(["outflow", "inflow"]);
const CashflowCertainty = z.enum([
  "committed",
  "confirmed",
  "expected",
  "possible",
]);
const CashflowScheduleStatus = z.enum([
  "active",
  "paused",
  "ended",
  "cancelled",
]);
const CashflowOccurrenceStatus = z.enum([
  "due",
  "settled",
  "skipped",
  "waived",
  "cancelled",
]);
const CashflowTitle = z.string().min(1).max(160);
const CashflowNote = z.string().max(500);
const CashflowSearch = z.string().max(160);
const CashflowRecordId = z.string().min(1).max(256);
const CashflowTimezone = z.string().min(1).max(100);
const Recurrence = z.object({
  cadence: z.enum(["once", "weekly", "monthly", "quarterly", "yearly"]),
  interval: z.number().int().min(1).max(100),
  startDate: DateOnly,
  endDate: DateOnly.optional(),
  onceDueOn: DateOnly.optional(),
  dayOfWeek: z.number().int().min(1).max(7).optional(),
  dayOfMonth: z.number().int().min(1).max(31).optional(),
  monthOfYear: z.number().int().min(1).max(12).optional(),
  timezone: CashflowTimezone,
});
const ScheduleRevision = CommandMeta.extend({
  scheduleId: CashflowRecordId,
  expectedRevision: z.number().int().min(1),
  effectiveOn: DateOnly,
  note: CashflowNote.optional(),
});
const OccurrenceRevision = CommandMeta.extend({
  occurrenceId: CashflowRecordId,
  expectedRevision: z.number().int().min(1),
  reason: CashflowNote.optional(),
  note: CashflowNote.optional(),
});

function domainError(error: unknown): never {
  if (!(error instanceof RavenDomainError)) throw error;
  const code =
    error.code === "NOT_FOUND"
      ? "NOT_FOUND"
      : error.code === "ALREADY_EXISTS" ||
          error.code === "IDEMPOTENCY_CONFLICT" ||
          error.code === "SCHEDULE_REVISION_CONFLICT" ||
          error.code === "OCCURRENCE_REVISION_CONFLICT" ||
          error.code === "OCCURRENCE_CONFLICT"
        ? "CONFLICT"
        : error.code === "INTERNAL"
          ? "INTERNAL_SERVER_ERROR"
          : "BAD_REQUEST";
  throw new TRPCError({ code, message: error.message, cause: error });
}

export const accountControlRouter = t.router({
  listAccounts: t.procedure
    .input(
      z.object({ spaceKeys: SpaceKeys, asOf: Instant.optional() }).optional(),
    )
    .query(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.listAccounts(input ?? {});
      } catch (error) {
        domainError(error);
      }
    }),
  getAccount: t.procedure
    .input(
      z.object({
        spaceKey: z.string().min(1),
        accountKey: z.string().min(1),
        asOf: Instant.optional(),
      }),
    )
    .query(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.getAccount(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getCurrentPosition: t.procedure
    .input(
      z.object({
        spaceKeys: SpaceKeys,
        currency: z.string().length(3),
        asOf: Instant.optional(),
      }),
    )
    .query(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.getCurrentPosition(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getAccountFreshness: t.procedure
    .input(
      z
        .object({
          spaceKeys: SpaceKeys,
          accountKeys: z.array(z.string().min(1)).optional(),
          asOf: Instant.optional(),
        })
        .optional(),
    )
    .query(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.getAccountFreshness(input ?? {});
      } catch (error) {
        domainError(error);
      }
    }),
  listAccountTransactions: t.procedure
    .input(
      z.object({
        spaceKey: z.string().min(1),
        accountKey: z.string().min(1),
        month: z.string().min(7).max(7),
        authorityScope: AccountLedgerAuthorityScope.optional(),
        kind: TransactionKind.optional(),
        flow: z.union([FlowDirection, z.literal("unknown")]).optional(),
        categoryKey: z.string().optional(),
        search: z.string().optional(),
        cursor: z.string().optional(),
        limit: z.number().int().min(1).max(100).optional(),
      }),
    )
    .query(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.listAccountTransactions(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getTransaction: t.procedure
    .input(z.object({ transactionId: z.string().min(1) }))
    .query(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.getTransaction(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getMonthProgress: t.procedure
    .input(
      z.object({
        month: z.string().min(7).max(7),
        currency: z.string().length(3),
        authorityScope: AccountLedgerAuthorityScope.optional(),
        spaceKeys: SpaceKeys,
        accountRefs: z.array(AccountRef).optional(),
        asOf: Instant.optional(),
      }),
    )
    .query(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.getMonthProgress(input);
      } catch (error) {
        domainError(error);
      }
    }),
  listCategories: t.procedure
    .input(
      z.object({
        spaceKey: z.string().min(1),
        kinds: z.array(CategoryKind).optional(),
      }),
    )
    .query(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.listCategories(input);
      } catch (error) {
        domainError(error);
      }
    }),
  createAccount: t.procedure
    .input(
      CommandMeta.extend({
        spaceKey: z.string().min(1),
        accountKey: z.string().min(1),
        name: z.string().min(1),
        bankName: z.string().optional(),
        accountType: z.string().min(1),
        currency: z.string().length(3),
        normalNature: z.enum(["asset", "liability"]),
        liquidityClass: z.enum(["liquid", "non_liquid"]),
        freshnessWindowHours: z.number().int().min(1).max(8760),
      }),
    )
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.createAccount(input);
      } catch (error) {
        domainError(error);
      }
    }),
  confirmAccountBalance: t.procedure
    .input(
      CommandMeta.extend({
        spaceKey: z.string().min(1),
        accountKey: z.string().min(1),
        balanceKind: z.enum([
          "available",
          "ledger",
          "statement",
          "market_value",
          "outstanding",
        ]),
        money: Money,
        economicNature: z.enum(["asset", "liability", "informational"]),
        asOf: Instant,
        note: z.string().optional(),
      }),
    )
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.confirmAccountBalance(input);
      } catch (error) {
        domainError(error);
      }
    }),
  recordExpense: t.procedure
    .input(
      CommandMeta.extend({
        spaceKey: z.string().min(1),
        accountKey: z.string().min(1),
        money: Money,
        postedAt: z.string().min(10).max(10),
        description: z.string().min(1),
        categoryKey: z.string().optional(),
      }),
    )
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.recordExpense(input);
      } catch (error) {
        domainError(error);
      }
    }),
  recordIncome: t.procedure
    .input(
      CommandMeta.extend({
        spaceKey: z.string().min(1),
        accountKey: z.string().min(1),
        money: Money,
        postedAt: z.string().min(10).max(10),
        description: z.string().min(1),
        categoryKey: z.string().optional(),
      }),
    )
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.recordIncome(input);
      } catch (error) {
        domainError(error);
      }
    }),
  recordTransfer: t.procedure
    .input(
      CommandMeta.extend({
        source: AccountRef,
        target: AccountRef,
        money: Money,
        postedAt: z.string().min(10).max(10),
        description: z.string().optional(),
      }),
    )
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.recordTransfer(input);
      } catch (error) {
        domainError(error);
      }
    }),
  listCashflowSchedules: t.procedure
    .input(
      z
        .object({
          spaceKeys: SpaceKeys,
          statuses: z.array(CashflowScheduleStatus).optional(),
          directions: z.array(CashflowDirection).optional(),
          certainties: z.array(CashflowCertainty).optional(),
          asOf: Instant.optional(),
        })
        .optional(),
    )
    .query(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.listCashflowSchedules(input ?? {});
      } catch (error) {
        domainError(error);
      }
    }),
  getCashflowSchedule: t.procedure
    .input(
      z.object({
        scheduleId: CashflowRecordId,
        from: DateOnly.optional(),
        through: DateOnly.optional(),
        asOf: Instant.optional(),
      }),
    )
    .query(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.getCashflowSchedule(input);
      } catch (error) {
        domainError(error);
      }
    }),
  listUpcomingCashflows: t.procedure
    .input(
      z.object({
        from: DateOnly,
        through: DateOnly,
        spaceKeys: SpaceKeys,
        accountRefs: z.array(AccountRef).optional(),
        statuses: z.array(CashflowOccurrenceStatus).optional(),
        directions: z.array(CashflowDirection).optional(),
        certainties: z.array(CashflowCertainty).optional(),
        includeTerminal: z.boolean().optional(),
        search: CashflowSearch.optional(),
        asOf: Instant.optional(),
      }),
    )
    .query(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.listUpcomingCashflows(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getCashflowOccurrence: t.procedure
    .input(
      z.object({ occurrenceId: CashflowRecordId, asOf: Instant.optional() }),
    )
    .query(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.getCashflowOccurrence(input);
      } catch (error) {
        domainError(error);
      }
    }),
  createScheduledCashflow: t.procedure
    .input(
      CommandMeta.merge(Recurrence).extend({
        spaceKey: z.string().min(1),
        accountKey: z.string().optional(),
        categoryKey: z.string().optional(),
        title: CashflowTitle,
        direction: CashflowDirection,
        certainty: CashflowCertainty,
        money: Money,
        materializeThrough: DateOnly,
        notes: CashflowNote.optional(),
      }),
    )
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.createScheduledCashflow(input);
      } catch (error) {
        domainError(error);
      }
    }),
  updateScheduledCashflow: t.procedure
    .input(
      CommandMeta.merge(Recurrence.partial()).extend({
        scheduleId: CashflowRecordId,
        expectedRevision: z.number().int().min(1),
        effectiveFrom: DateOnly,
        accountKey: z.string().nullable().optional(),
        categoryKey: z.string().nullable().optional(),
        title: CashflowTitle.optional(),
        direction: CashflowDirection.optional(),
        certainty: CashflowCertainty.optional(),
        money: Money.optional(),
        notes: CashflowNote.optional(),
      }),
    )
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.updateScheduledCashflow(input);
      } catch (error) {
        domainError(error);
      }
    }),
  pauseScheduledCashflow: t.procedure
    .input(ScheduleRevision)
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.pauseScheduledCashflow(input);
      } catch (error) {
        domainError(error);
      }
    }),
  resumeScheduledCashflow: t.procedure
    .input(
      CommandMeta.extend({
        scheduleId: CashflowRecordId,
        expectedRevision: z.number().int().min(1),
        resumeOn: DateOnly,
        note: CashflowNote.optional(),
      }),
    )
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.resumeScheduledCashflow(input);
      } catch (error) {
        domainError(error);
      }
    }),
  endScheduledCashflow: t.procedure
    .input(ScheduleRevision)
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.endScheduledCashflow(input);
      } catch (error) {
        domainError(error);
      }
    }),
  cancelScheduledCashflow: t.procedure
    .input(ScheduleRevision)
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.cancelScheduledCashflow(input);
      } catch (error) {
        domainError(error);
      }
    }),
  settleCashflowOccurrence: t.procedure
    .input(
      OccurrenceRevision.extend({
        settledAt: Instant,
        transactionId: CashflowRecordId.optional(),
      }),
    )
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.settleCashflowOccurrence(input);
      } catch (error) {
        domainError(error);
      }
    }),
  reconcileCashflowOccurrence: t.procedure
    .input(OccurrenceRevision.extend({ transactionId: CashflowRecordId }))
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.reconcileCashflowOccurrence(input);
      } catch (error) {
        domainError(error);
      }
    }),
  skipCashflowOccurrence: t.procedure
    .input(OccurrenceRevision)
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.skipCashflowOccurrence(input);
      } catch (error) {
        domainError(error);
      }
    }),
  waiveCashflowOccurrence: t.procedure
    .input(OccurrenceRevision)
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.waiveCashflowOccurrence(input);
      } catch (error) {
        domainError(error);
      }
    }),
  cancelCashflowOccurrence: t.procedure
    .input(OccurrenceRevision)
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.cancelCashflowOccurrence(input);
      } catch (error) {
        domainError(error);
      }
    }),
  overrideCashflowOccurrenceAmount: t.procedure
    .input(OccurrenceRevision.extend({ money: Money }))
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.overrideCashflowOccurrenceAmount(input);
      } catch (error) {
        domainError(error);
      }
    }),
  overrideCashflowOccurrenceDueDate: t.procedure
    .input(OccurrenceRevision.extend({ dueOn: DateOnly }))
    .mutation(async ({ input, ctx }) => {
      try {
        return await createAccountControlTransportHandlers(
          getAccountControlService(ctx),
        ).trpc.overrideCashflowOccurrenceDueDate(input);
      } catch (error) {
        domainError(error);
      }
    }),
});

export type AccountControlRouter = typeof accountControlRouter;
