import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

test("Account ledger requests raw statement evidence without weakening ordinary analytics", async () => {
  const [page, router, actionMenu] = await Promise.all([
    readFile(
      new URL("../pages/accounts/[spaceKey]/[accountKey].vue", import.meta.url),
      "utf8",
    ),
    readFile(
      new URL("../../server/trpc/routers/account-control.ts", import.meta.url),
      "utf8",
    ),
    readFile(
      new URL("../components/AccountActionMenu.vue", import.meta.url),
      "utf8",
    ),
  ]);

  assert.match(
    page,
    /authorityScope:\s*"active_ledger_with_legacy_unreconciled"/,
  );
  assert.match(page, /route\.query\.month/);
  assert.match(page, /availableMonths/);
  assert.match(page, /class="account-context__identity"/);
  assert.match(page, /class="ledger-description"/);
  assert.match(page, /<th>Date<\/th>\s*<th>Item<\/th>\s*<th>Amount<\/th>/);
  assert.doesNotMatch(page, /<th>Context<\/th>/);
  assert.doesNotMatch(page, /<th>Description<\/th>/);
  assert.doesNotMatch(page, /ledger-description__meta/);
  assert.match(page, /<span>Balance:<\/span>/);
  assert.match(page, /class="transaction-balance"/);
  assert.match(page, /\.ledger-table \.amount\s*{[^}]*font-size: 13px/s);
  assert.match(
    page,
    /\.transaction-balance\s*{[^}]*font-size: 10px !important/s,
  );
  assert.match(page, /transaction\.reportedBalance/);
  assert.match(page, /class="transaction-flow"/);
  assert.match(page, /i-lucide-arrow-up/);
  assert.match(page, /i-lucide-arrow-down/);
  assert.match(page, /stateTone\(transaction\.evidenceState\)/);
  assert.doesNotMatch(page, /stateTone\(meaningState\(transaction\)\)/);
  assert.match(page, /const statsOpen = ref\(true\)/);
  assert.match(page, /const filtersOpen = ref\(true\)/);
  assert.match(page, /const categoriesOpen = ref\(true\)/);
  assert.match(page, /aria-label="Toggle account statistics"/);
  assert.match(page, /aria-label="Toggle transaction search and filters"/);
  assert.match(page, /aria-label="Toggle category overview"/);
  assert.match(page, /v-if="statsOpen"/);
  assert.match(page, /v-if="filtersOpen"/);
  assert.match(page, /v-if="categoriesOpen"/);
  assert.match(page, /const transactionNeedsReview =/);
  assert.match(page, /aria-label="Unresolved transaction"/);
  assert.match(page, /title="Unresolved"/);
  assert.match(page, /Confirmation required/);
  assert.match(page, /The transaction's financial role remains unresolved\./);
  assert.doesNotMatch(page, /Some imported transactions need review/);
  assert.doesNotMatch(page, /Observed activity/);
  assert.doesNotMatch(page, /monthWarnings\.join\(/);
  assert.doesNotMatch(page, /selectedTransaction\.warnings\.join\(/);
  assert.doesNotMatch(page, /class="categories-toggle"/);
  assert.match(
    page,
    /\.account-context\s*{[^}]*position: sticky;[^}]*top: 64px;/s,
  );
  assert.match(page, /\.amount--transfer\s*{[^}]*color: var\(--raven-info\)/s);
  assert.match(
    page,
    /\.ledger-table td\.ledger-description strong\s*{[^}]*font-size: 13px/s,
  );
  assert.doesNotMatch(page, /account-context__breadcrumb/);
  assert.doesNotMatch(page, /account-identity__mark/);
  assert.doesNotMatch(page, /statement-source-state/);
  const contextStart = page.indexOf('<nav class="account-context"');
  const contextEnd = page.indexOf("</nav>", contextStart);
  const actionMenuPosition = page.indexOf("<AccountActionMenu", contextStart);
  assert.ok(
    actionMenuPosition > contextStart && actionMenuPosition < contextEnd,
  );
  assert.match(actionMenu, /id: "import-statement"/);
  assert.match(actionMenu, /<strong>Account actions<\/strong>/);
  assert.match(router, /active_ledger_with_legacy_unreconciled/);
  assert.doesNotMatch(page, /\.mutate\s*\(/);
});
