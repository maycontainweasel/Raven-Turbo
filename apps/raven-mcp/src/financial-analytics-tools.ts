import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import {
  createFinancialAnalyticsTransportHandlers,
  RavenDomainError,
  type FinancialAnalyticsApi,
} from "@raven/domain";
import { z } from "zod";

const dateOnly = z.string().regex(/^\d{4}-\d{2}-\d{2}$/);
const accountRef = z.object({
  spaceKey: z.string().min(1),
  accountKey: z.string().min(1),
});
const authorityScope = z
  .enum(["active_ledger", "active_ledger_with_legacy_unreconciled"])
  .default("active_ledger");
const scope = {
  month: z
    .string()
    .regex(/^\d{4}-\d{2}$/)
    .optional(),
  from: dateOnly.optional(),
  through: dateOnly.optional(),
  currency: z.string().length(3),
  asOf: z.string().datetime({ offset: true }).optional(),
  spaceKeys: z.array(z.string().min(1)).optional(),
  accountRefs: z.array(accountRef).optional(),
  authorityScope,
};
const feeRule = z.discriminatedUnion("type", [
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

export function createFinancialAnalyticsMcpHandlers(
  service: FinancialAnalyticsApi,
) {
  return createFinancialAnalyticsTransportHandlers(service).mcp;
}

export function registerFinancialAnalyticsTools(
  server: McpServer,
  service: FinancialAnalyticsApi,
): void {
  const handlers = createFinancialAnalyticsMcpHandlers(service);

  server.registerTool(
    "get_period_financial_summary",
    {
      description:
        "Return exact per-currency income, outflow, and net for a date range or month. Transfers, unresolved evidence, ignored records, invalid records, and superseded authority are never silently counted.",
      inputSchema: scope,
    },
    async (input) => {
      try {
        return result(await handlers.get_period_financial_summary(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "get_category_spend_summary",
    {
      description:
        "Summarize exact observed expense outflow by management Category. Category results make no tax claim.",
      inputSchema: {
        ...scope,
        categoryKeys: z.array(z.string().min(1)).optional(),
        includeDescendants: z.boolean().optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.get_category_spend_summary(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "get_merchant_spend_summary",
    {
      description:
        "Summarize exact observed expense outflow by reviewed merchant name with active and legacy authority kept separate.",
      inputSchema: {
        ...scope,
        merchantNames: z.array(z.string().min(1)).optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.get_merchant_spend_summary(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "get_fee_summary",
    {
      description:
        "Summarize fees only from caller-supplied reviewed Category, exact merchant, or explicit description evidence rules. Rule precedence and every subtotal are disclosed.",
      inputSchema: { ...scope, rules: z.array(feeRule).min(1) },
    },
    async (input) => {
      try {
        return result(await handlers.get_fee_summary(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "get_monthly_financial_trend",
    {
      description:
        "Return deterministic calendar-month income, outflow, and net rows over an exact date range without FX conversion.",
      inputSchema: scope,
    },
    async (input) => {
      try {
        return result(await handlers.get_monthly_financial_trend(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "list_uncategorized_transactions",
    {
      description:
        "List paginated references for valid observed income and expense movements that still lack management Category meaning.",
      inputSchema: {
        ...scope,
        cursor: z.string().min(1).optional(),
        limit: z.number().int().min(1).max(100).optional(),
      },
    },
    async (input) => {
      try {
        return result(await handlers.list_uncategorized_transactions(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );

  server.registerTool(
    "get_financial_data_quality_summary",
    {
      description:
        "Return authority, categorization, unresolved, invalid, ignored, transfer, adjustment, future, and historical evidence counts plus explicitly named gross known movement volumes for an exact financial period.",
      inputSchema: scope,
    },
    async (input) => {
      try {
        return result(await handlers.get_financial_data_quality_summary(input));
      } catch (error) {
        return errorResult(error);
      }
    },
  );
}
