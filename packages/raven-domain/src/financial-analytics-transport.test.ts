import assert from "node:assert/strict";
import test from "node:test";
import type { FinancialAnalyticsApi } from "./financial-analytics-contracts.js";
import { createFinancialAnalyticsTransportHandlers } from "./financial-analytics-transport.js";

test("tRPC, MCP, and Studio-facing analytics handlers remain contract-equivalent", async () => {
  const output = (operation: string, input: unknown) => ({ operation, input });
  const service = {
    getPeriodFinancialSummary: async (input: unknown) =>
      output("period", input),
    getCategorySpendSummary: async (input: unknown) =>
      output("category", input),
    getMerchantSpendSummary: async (input: unknown) =>
      output("merchant", input),
    getFeeSummary: async (input: unknown) => output("fees", input),
    getMonthlyFinancialTrend: async (input: unknown) => output("trend", input),
    listUncategorizedTransactions: async (input: unknown) =>
      output("uncategorized", input),
    getFinancialDataQualitySummary: async (input: unknown) =>
      output("quality", input),
  } as unknown as FinancialAnalyticsApi;
  const { trpc, mcp } = createFinancialAnalyticsTransportHandlers(service);
  const input = { month: "2026-07", currency: "ZAR" } as const;
  const pairs = [
    ["getPeriodFinancialSummary", "get_period_financial_summary"],
    ["getCategorySpendSummary", "get_category_spend_summary"],
    ["getMerchantSpendSummary", "get_merchant_spend_summary"],
    ["getFeeSummary", "get_fee_summary"],
    ["getMonthlyFinancialTrend", "get_monthly_financial_trend"],
    ["listUncategorizedTransactions", "list_uncategorized_transactions"],
    ["getFinancialDataQualitySummary", "get_financial_data_quality_summary"],
  ] as const;
  for (const [trpcName, mcpName] of pairs) {
    assert.deepEqual(
      await mcp[mcpName](input as never),
      await trpc[trpcName](input as never),
    );
  }
});
