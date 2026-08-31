import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

test("Financial Worldview renders one read-only monthly thread with explicit evidence boundaries", async () => {
  const [page, layout, contracts, service] = await Promise.all([
    readFile(new URL("../pages/worldview.vue", import.meta.url), "utf8"),
    readFile(new URL("../layouts/default.vue", import.meta.url), "utf8"),
    readFile(
      new URL(
        "../../../../packages/raven-domain/src/financial-analytics-contracts.ts",
        import.meta.url,
      ),
      "utf8",
    ),
    readFile(
      new URL(
        "../../../../packages/raven-domain/src/financial-analytics-service.ts",
        import.meta.url,
      ),
      "utf8",
    ),
  ]);

  assert.match(page, /getMonthlyFinancialTrend/);
  assert.match(page, /function yearSlices/);
  assert.match(page, /index \+= 2/);
  assert.match(page, /fromMonth = ref\("2018-01"\)/);
  assert.match(page, /active_ledger_with_legacy_unreconciled/);
  assert.match(page, /internal transfers excluded/i);
  assert.match(page, /movement report, not a balance sheet/i);
  assert.match(page, /Unknown attribution is never treated as zero/i);
  assert.match(page, />Trading</);
  assert.match(page, />Paid to wife</);
  assert.match(page, />Family support</);
  assert.match(page, /class="attribution-unknown">Unknown/g);
  assert.doesNotMatch(page, /\.mutate\s*\(/);
  assert.match(layout, /to="\/worldview"/);
  assert.match(contracts, /FinancialMonthlyTrendRow[\s\S]*accounts: Array/);
  assert.match(service, /accounts: dataset\.accounts\.map/);
});
