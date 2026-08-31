import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

const operations = [
  "getPeriodFinancialSummary",
  "getCategorySpendSummary",
  "getMerchantSpendSummary",
  "getFeeSummary",
  "getMonthlyFinancialTrend",
  "listUncategorizedTransactions",
  "getFinancialDataQualitySummary",
] as const;

test("Studio exposes every analytics operation as a query and no financial write", async () => {
  const [composable, router, page] = await Promise.all([
    readFile(
      new URL("../composables/useFinancialAnalyticsApi.ts", import.meta.url),
      "utf8",
    ),
    readFile(
      new URL(
        "../../server/trpc/routers/financial-analytics.ts",
        import.meta.url,
      ),
      "utf8",
    ),
    readFile(new URL("../pages/analysis.vue", import.meta.url), "utf8"),
  ]);
  for (const operation of operations) {
    assert.match(composable, new RegExp(`${operation}[\\s\\S]*?\\.query\\(`));
    assert.match(router, new RegExp(`${operation}: t\\.procedure`));
  }
  assert.doesNotMatch(composable, /\.mutate\s*\(/);
  assert.doesNotMatch(router, /\.mutation\s*\(/);
  assert.doesNotMatch(
    `${composable}\n${router}\n${page}`,
    /FinancialOperation/,
  );
  assert.match(page, /getPeriodFinancialSummary/);
  assert.match(page, /getFinancialDataQualitySummary/);
  assert.match(page, /listUncategorizedTransactions/);
  assert.match(page, /Africa\/Johannesburg/);
  assert.doesNotMatch(page, /new Date\(\)\.toISOString\(\)\.slice\(0, 7\)/);
});
