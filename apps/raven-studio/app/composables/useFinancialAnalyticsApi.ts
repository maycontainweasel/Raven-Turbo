import type {
  GetCategorySpendSummaryInput,
  GetFeeSummaryInput,
  GetFinancialDataQualitySummaryInput,
  GetMerchantSpendSummaryInput,
  GetMonthlyFinancialTrendInput,
  GetPeriodFinancialSummaryInput,
  ListUncategorizedTransactionsInput,
} from "@raven/domain";

export function useFinancialAnalyticsApi() {
  const { $api } = useNuxtApp() as any;

  return {
    getPeriodFinancialSummary: (input: GetPeriodFinancialSummaryInput) =>
      $api.financialAnalytics.getPeriodFinancialSummary.query(input),
    getCategorySpendSummary: (input: GetCategorySpendSummaryInput) =>
      $api.financialAnalytics.getCategorySpendSummary.query(input),
    getMerchantSpendSummary: (input: GetMerchantSpendSummaryInput) =>
      $api.financialAnalytics.getMerchantSpendSummary.query(input),
    getFeeSummary: (input: GetFeeSummaryInput) =>
      $api.financialAnalytics.getFeeSummary.query(input),
    getMonthlyFinancialTrend: (input: GetMonthlyFinancialTrendInput) =>
      $api.financialAnalytics.getMonthlyFinancialTrend.query(input),
    listUncategorizedTransactions: (
      input: ListUncategorizedTransactionsInput,
    ) => $api.financialAnalytics.listUncategorizedTransactions.query(input),
    getFinancialDataQualitySummary: (
      input: GetFinancialDataQualitySummaryInput,
    ) => $api.financialAnalytics.getFinancialDataQualitySummary.query(input),
  };
}
