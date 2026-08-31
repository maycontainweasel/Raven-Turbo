import {
  createFinancialAnalyticsTransportHandlers,
  RavenDomainError,
} from "@raven/domain";
import { TRPCError } from "@trpc/server";
import { z } from "zod";
import { t } from "@schema/server/trpc/context";
import { getFinancialAnalyticsService } from "../../services/financial-analytics";

const DateOnly = z.string().regex(/^\d{4}-\d{2}-\d{2}$/);
const AccountRef = z.object({
  spaceKey: z.string().min(1),
  accountKey: z.string().min(1),
});
const AuthorityScope = z.enum([
  "active_ledger",
  "active_ledger_with_legacy_unreconciled",
]);
const ScopeShape = {
  month: z
    .string()
    .regex(/^\d{4}-\d{2}$/)
    .optional(),
  from: DateOnly.optional(),
  through: DateOnly.optional(),
  currency: z.string().length(3),
  asOf: z.string().datetime({ offset: true }).optional(),
  spaceKeys: z.array(z.string().min(1)).optional(),
  accountRefs: z.array(AccountRef).optional(),
  authorityScope: AuthorityScope.optional(),
};

function scopedInput<T extends z.ZodRawShape>(extra: T) {
  return z.object({ ...ScopeShape, ...extra });
}

const FeeRule = z.discriminatedUnion("type", [
  z.object({
    id: z.string().min(1),
    label: z.string().min(1),
    type: z.literal("category"),
    categoryKeys: z.array(z.string().min(1)).min(1),
    includeDescendants: z.boolean().optional(),
  }),
  z.object({
    id: z.string().min(1),
    label: z.string().min(1),
    type: z.literal("merchant_exact"),
    merchantNames: z.array(z.string().min(1)).min(1),
  }),
  z.object({
    id: z.string().min(1),
    label: z.string().min(1),
    type: z.literal("description_contains"),
    phrases: z.array(z.string().min(1)).min(1),
  }),
]);

function domainError(error: unknown): never {
  if (!(error instanceof RavenDomainError)) throw error;
  const code =
    error.code === "NOT_FOUND"
      ? "NOT_FOUND"
      : error.code === "INTERNAL"
        ? "INTERNAL_SERVER_ERROR"
        : "BAD_REQUEST";
  throw new TRPCError({ code, message: error.message, cause: error });
}

function handlers(ctx: Parameters<typeof getFinancialAnalyticsService>[0]) {
  return createFinancialAnalyticsTransportHandlers(
    getFinancialAnalyticsService(ctx),
  ).trpc;
}

export const financialAnalyticsRouter = t.router({
  getPeriodFinancialSummary: t.procedure
    .input(scopedInput({}))
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).getPeriodFinancialSummary(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getCategorySpendSummary: t.procedure
    .input(
      scopedInput({
        categoryKeys: z.array(z.string().min(1)).optional(),
        includeDescendants: z.boolean().optional(),
      }),
    )
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).getCategorySpendSummary(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getMerchantSpendSummary: t.procedure
    .input(
      scopedInput({
        merchantNames: z.array(z.string().min(1)).optional(),
      }),
    )
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).getMerchantSpendSummary(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getFeeSummary: t.procedure
    .input(scopedInput({ rules: z.array(FeeRule).min(1) }))
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).getFeeSummary(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getMonthlyFinancialTrend: t.procedure
    .input(scopedInput({}))
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).getMonthlyFinancialTrend(input);
      } catch (error) {
        domainError(error);
      }
    }),
  listUncategorizedTransactions: t.procedure
    .input(
      scopedInput({
        cursor: z.string().min(1).optional(),
        limit: z.number().int().min(1).max(100).optional(),
      }),
    )
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).listUncategorizedTransactions(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getFinancialDataQualitySummary: t.procedure
    .input(scopedInput({}))
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).getFinancialDataQualitySummary(input);
      } catch (error) {
        domainError(error);
      }
    }),
});

export type FinancialAnalyticsRouter = typeof financialAnalyticsRouter;
