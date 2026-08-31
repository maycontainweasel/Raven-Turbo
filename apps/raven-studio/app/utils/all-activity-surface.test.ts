import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

test("All Activity composes complete read-only account ledgers into one calendar-month thread", async () => {
  const [page, layout] = await Promise.all([
    readFile(new URL("../pages/activity.vue", import.meta.url), "utf8"),
    readFile(new URL("../layouts/default.vue", import.meta.url), "utf8"),
  ]);

  assert.match(page, /api\.listAccounts\(/);
  assert.match(page, /api\.getAccount\(/);
  assert.match(page, /api\.listAccountTransactions\(/);
  assert.match(page, /api\.getMonthProgress\(/);
  assert.match(page, /api\.getTransaction\(/);
  assert.match(
    page,
    /authorityScope:\s*"active_ledger_with_legacy_unreconciled"/,
  );
  assert.match(page, /limit:\s*100/);
  assert.match(page, /const seenCursors = new Set<string>\(\)/);
  assert.match(page, /while \(cursor\)/);
  assert.match(
    page,
    /selectedAccountRefs\.value = available\.map\(accountRefKey\)/,
  );
  assert.match(page, /currencyScopes/);
  assert.match(page, /accountRefs:\s*scopedAccounts\.map/);
  assert.match(page, /financialDate/);
  assert.match(page, /right\.financialDate/);
  assert.match(page, /left\.transferId === right\.transferId/);
  assert.match(page, /aria-label="Activity month"/);
  assert.match(page, /type="checkbox"/);
  assert.match(page, />All<\/button>/);
  assert.match(page, />None<\/button>/);
  assert.match(page, /class="transaction-account"/);
  assert.match(
    page,
    /<th>Date<\/th>\s*<th>Account<\/th>\s*<th>Item<\/th>\s*<th>Amount<\/th>/,
  );
  assert.doesNotMatch(page, /<th>Context<\/th>/);
  assert.doesNotMatch(page, /<th>Description<\/th>/);
  assert.doesNotMatch(page, /transaction-description__meta/);
  assert.doesNotMatch(page, /<small>Evidence<\/small>/);
  assert.match(page, /<span>Balance:<\/span>/);
  assert.match(page, /class="transaction-balance"/);
  assert.match(page, /\.activity-table \.amount\s*{[^}]*font-size: 13px/s);
  assert.match(
    page,
    /\.transaction-balance\s*{[^}]*font-size: 10px !important/s,
  );
  assert.match(page, /transaction\.reportedBalance/);
  assert.match(page, /class="transaction-flow"/);
  assert.match(page, /i-lucide-arrow-up/);
  assert.match(page, /i-lucide-arrow-down/);
  assert.match(page, /titleCase\(transaction\.evidenceState\)/);
  assert.match(page, /\?month=\$\{selectedMonth\}/);
  assert.match(page, /\.amount--transfer\s*{[^}]*color: var\(--raven-info\)/s);
  assert.match(page, /aria-label="Unresolved transaction"/);
  assert.match(page, /const clientReady = ref\(false\)/);
  assert.match(page, /<ClientOnly>/);
  assert.match(page, /\.activity-ledger\s*{[^}]*min-width: 0;/s);
  assert.doesNotMatch(page, /\.mutate\s*\(/);
  assert.doesNotMatch(page, /FinancialOperation/);

  assert.match(layout, /route\.path\.startsWith\('\/activity'\)/);
  assert.match(layout, /<NuxtLink to="\/activity">\s*Activity\s*<\/NuxtLink>/);
});
