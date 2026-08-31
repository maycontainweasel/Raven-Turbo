import type { FinancialAnalyticsApi } from "./financial-analytics-contracts.js";

export function createFinancialAnalyticsTransportHandlers(
  service: FinancialAnalyticsApi,
) {
  const trpc = {
    getPeriodFinancialSummary: (
      input: Parameters<FinancialAnalyticsApi["getPeriodFinancialSummary"]>[0],
    ) => service.getPeriodFinancialSummary(input),
    getCategorySpendSummary: (
      input: Parameters<FinancialAnalyticsApi["getCategorySpendSummary"]>[0],
    ) => service.getCategorySpendSummary(input),
    getMerchantSpendSummary: (
      input: Parameters<FinancialAnalyticsApi["getMerchantSpendSummary"]>[0],
    ) => service.getMerchantSpendSummary(input),
    getFeeSummary: (
      input: Parameters<FinancialAnalyticsApi["getFeeSummary"]>[0],
    ) => service.getFeeSummary(input),
    getMonthlyFinancialTrend: (
      input: Parameters<FinancialAnalyticsApi["getMonthlyFinancialTrend"]>[0],
    ) => service.getMonthlyFinancialTrend(input),
    listUncategorizedTransactions: (
      input: Parameters<
        FinancialAnalyticsApi["listUncategorizedTransactions"]
      >[0],
    ) => service.listUncategorizedTransactions(input),
    getFinancialDataQualitySummary: (
      input: Parameters<
        FinancialAnalyticsApi["getFinancialDataQualitySummary"]
      >[0],
    ) => service.getFinancialDataQualitySummary(input),
  };

  return {
    trpc,
    mcp: {
      get_period_financial_summary: trpc.getPeriodFinancialSummary,
      get_category_spend_summary: trpc.getCategorySpendSummary,
      get_merchant_spend_summary: trpc.getMerchantSpendSummary,
      get_fee_summary: trpc.getFeeSummary,
      get_monthly_financial_trend: trpc.getMonthlyFinancialTrend,
      list_uncategorized_transactions: trpc.listUncategorizedTransactions,
      get_financial_data_quality_summary: trpc.getFinancialDataQualitySummary,
    },
  };
}
