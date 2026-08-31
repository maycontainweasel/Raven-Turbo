import assert from "node:assert/strict";
import test from "node:test";
import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import {
  createFinancialAnalyticsTransportHandlers,
  type FinancialAnalyticsApi,
} from "@raven/domain";
import {
  createFinancialAnalyticsMcpHandlers,
  registerFinancialAnalyticsTools,
} from "./financial-analytics-tools.js";

function service(): FinancialAnalyticsApi {
  const output = (operation: string, input: unknown) => ({ operation, input });
  return {
    getPeriodFinancialSummary: async (input) =>
      output("period", input) as never,
    getCategorySpendSummary: async (input) =>
      output("category", input) as never,
    getMerchantSpendSummary: async (input) =>
      output("merchant", input) as never,
    getFeeSummary: async (input) => output("fee", input) as never,
    getMonthlyFinancialTrend: async (input) => output("trend", input) as never,
    listUncategorizedTransactions: async (input) =>
      output("uncategorized", input) as never,
    getFinancialDataQualitySummary: async (input) =>
      output("quality", input) as never,
  };
}

test("semantic MCP exposes the complete seven-query read-only catalog", () => {
  const names: string[] = [];
  const server = {
    registerTool(name: string) {
      names.push(name);
    },
  } as unknown as McpServer;
  registerFinancialAnalyticsTools(server, service());
  assert.deepEqual(names, [
    "get_period_financial_summary",
    "get_category_spend_summary",
    "get_merchant_spend_summary",
    "get_fee_summary",
    "get_monthly_financial_trend",
    "list_uncategorized_transactions",
    "get_financial_data_quality_summary",
  ]);
});

test("MCP and Studio tRPC adapters return identical Domain outputs", async () => {
  const api = service();
  const mcp = createFinancialAnalyticsMcpHandlers(api);
  const trpc = createFinancialAnalyticsTransportHandlers(api).trpc;
  const input = { month: "2026-07", currency: "ZAR" } as const;
  assert.deepEqual(
    await mcp.get_period_financial_summary(input),
    await trpc.getPeriodFinancialSummary(input),
  );
  assert.deepEqual(
    await mcp.get_financial_data_quality_summary(input),
    await trpc.getFinancialDataQualitySummary(input),
  );
});
