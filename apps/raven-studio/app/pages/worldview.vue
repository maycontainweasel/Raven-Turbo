<script setup lang="ts">
import {
  formatMoney,
  type AccountRef,
  type AccountSummary,
  type FinancialMonthlyTrendRow,
  type FinancialMovementTotals,
  type ListAccountsOutput,
  type MoneyWire,
} from "@raven/domain";

useHead({ title: "Financial Worldview · Raven" });

const accountApi = useAccountControlApi();
const analyticsApi = useFinancialAnalyticsApi();

function johannesburgDateParts(date = new Date()): Record<string, string> {
  return new Intl.DateTimeFormat("en-ZA", {
    timeZone: "Africa/Johannesburg",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  })
    .formatToParts(date)
    .reduce<Record<string, string>>((result, part) => {
      if (part.type !== "literal") result[part.type] = part.value;
      return result;
    }, {});
}

const todayParts = johannesburgDateParts();
const currentMonth = `${todayParts.year}-${todayParts.month}`;
const currentFinancialDate = `${currentMonth}-${todayParts.day}`;
const fromMonth = ref("2018-01");
const throughMonth = ref(currentMonth);
const authorityScope = ref<
  "active_ledger" | "active_ledger_with_legacy_unreconciled"
>("active_ledger_with_legacy_unreconciled");
const loading = ref(false);
const loadedSliceCount = ref(0);
const totalSliceCount = ref(0);
const errorMessage = ref("");
const accountWarning = ref("");
const accountsData = ref<ListAccountsOutput | null>(null);
const trendData = ref<{
  months: FinancialMonthlyTrendRow[];
  accounts: AccountRef[];
} | null>(null);

function finalDateForMonth(month: string): string {
  if (month === currentMonth) return currentFinancialDate;
  const [year, value] = month.split("-").map(Number);
  const end = new Date(Date.UTC(year ?? 0, value ?? 1, 0));
  return end.toISOString().slice(0, 10);
}

function yearSlices(firstMonth: string, lastMonth: string) {
  const firstYear = Number(firstMonth.slice(0, 4));
  const lastYear = Number(lastMonth.slice(0, 4));
  return Array.from({ length: lastYear - firstYear + 1 }, (_, index) => {
    const year = firstYear + index;
    return {
      fromMonth: year === firstYear ? firstMonth : `${year}-01`,
      throughMonth: year === lastYear ? lastMonth : `${year}-12`,
    };
  }).reverse();
}

async function load() {
  errorMessage.value = "";
  accountWarning.value = "";
  if (fromMonth.value > throughMonth.value) {
    errorMessage.value = "The first month must not follow the last month.";
    return;
  }
  loading.value = true;
  loadedSliceCount.value = 0;
  try {
    const slices = yearSlices(fromMonth.value, throughMonth.value);
    totalSliceCount.value = slices.length;
    const asOf = new Date().toISOString();
    const accountsPromise = accountApi.listAccounts().then(
      (value) => ({ ok: true as const, value }),
      (error) => ({ ok: false as const, error }),
    );
    const trendResults: Array<
      Awaited<ReturnType<typeof analyticsApi.getMonthlyFinancialTrend>>
    > = [];
    for (let index = 0; index < slices.length; index += 2) {
      const batch = await Promise.all(
        slices.slice(index, index + 2).map((slice) =>
          analyticsApi.getMonthlyFinancialTrend({
            from: `${slice.fromMonth}-01`,
            through: finalDateForMonth(slice.throughMonth),
            currency: "ZAR",
            authorityScope: authorityScope.value,
            asOf,
          }),
        ),
      );
      trendResults.push(...batch);
      loadedSliceCount.value += batch.length;
    }
    const accountRefs = new Map<string, AccountRef>();
    for (const result of trendResults) {
      for (const account of result.meta.accounts) {
        accountRefs.set(`${account.spaceKey}:${account.accountKey}`, account);
      }
    }
    trendData.value = {
      months: trendResults
        .flatMap((result) => result.months)
        .sort((left, right) => left.month.localeCompare(right.month)),
      accounts: [...accountRefs.values()],
    };
    const accountsResult = await accountsPromise;
    if (accountsResult.ok) {
      accountsData.value = accountsResult.value;
    } else {
      accountWarning.value =
        "Account labels could not be loaded; Raven is using ledger identifiers.";
    }
  } catch (error) {
    errorMessage.value =
      error instanceof Error
        ? error.message
        : "The financial worldview could not be loaded.";
  } finally {
    loading.value = false;
  }
}

onMounted(load);

const spaces = computed(() => accountsData.value?.spaces ?? []);
const accountDirectory = computed(() => {
  const directory = new Map<string, AccountSummary>();
  for (const space of spaces.value) {
    for (const account of space.accounts) {
      directory.set(`${space.key}:${account.accountKey}`, account);
    }
  }
  return directory;
});

const businessSpaceKeys = computed(
  () =>
    new Set(
      spaces.value
        .filter((space) => space.spaceType.toLowerCase().includes("business"))
        .map((space) => space.key),
    ),
);

function isBusinessAccount(account: AccountRef): boolean {
  if (businessSpaceKeys.value.size > 0) {
    return businessSpaceKeys.value.has(account.spaceKey);
  }
  return account.spaceKey.toLowerCase().includes("business");
}

const knownAccounts = computed(
  () => trendData.value?.accounts ?? ([] as AccountRef[]),
);
const businessAccounts = computed(() =>
  knownAccounts.value.filter(isBusinessAccount),
);
const personalAccounts = computed(() =>
  knownAccounts.value.filter((account) => !isBusinessAccount(account)),
);
const monthRows = computed(() => [...(trendData.value?.months ?? [])].reverse());

function zeroMoney(currency = "ZAR"): MoneyWire {
  return { currency, minorUnits: 0 };
}

function zeroMovement(currency = "ZAR"): FinancialMovementTotals {
  return {
    income: zeroMoney(currency),
    outflow: zeroMoney(currency),
    net: zeroMoney(currency),
    incomeCount: 0,
    outflowCount: 0,
  };
}

function combineMovement(
  rows: readonly FinancialMovementTotals[],
): FinancialMovementTotals {
  return rows.reduce<FinancialMovementTotals>(
    (total, row) => ({
      income: {
        currency: row.income.currency,
        minorUnits: total.income.minorUnits + row.income.minorUnits,
      },
      outflow: {
        currency: row.outflow.currency,
        minorUnits: total.outflow.minorUnits + row.outflow.minorUnits,
      },
      net: {
        currency: row.net.currency,
        minorUnits: total.net.minorUnits + row.net.minorUnits,
      },
      incomeCount: total.incomeCount + row.incomeCount,
      outflowCount: total.outflowCount + row.outflowCount,
    }),
    zeroMovement(),
  );
}

function accountIdentity(account: AccountRef): string {
  return `${account.spaceKey}:${account.accountKey}`;
}

function accountRowsFor(
  month: FinancialMonthlyTrendRow,
  accounts: readonly AccountRef[],
) {
  const identities = new Set(accounts.map(accountIdentity));
  return month.accounts.filter((row) =>
    identities.has(accountIdentity(row.account)),
  );
}

function movementFor(
  month: FinancialMonthlyTrendRow,
  accounts: readonly AccountRef[],
  key: "ordinary" | "legacyUnreconciled",
): FinancialMovementTotals {
  return combineMovement(accountRowsFor(month, accounts).map((row) => row[key]));
}

type WorldviewRow = Readonly<{
  id: string;
  label: string;
  detail: string;
  tone: "world" | "business" | "personal" | "account";
  ordinary: FinancialMovementTotals;
  legacy: FinancialMovementTotals;
}>;

function accountLabel(account: AccountRef): { label: string; detail: string } {
  const summary = accountDirectory.value.get(accountIdentity(account));
  if (!summary) {
    return { label: account.accountKey, detail: account.spaceKey };
  }
  return {
    label: summary.name,
    detail: [summary.bankName, summary.accountType].filter(Boolean).join(" · "),
  };
}

function rowsForMonth(month: FinancialMonthlyTrendRow): WorldviewRow[] {
  const businessOrdinary = movementFor(
    month,
    businessAccounts.value,
    "ordinary",
  );
  const businessLegacy = movementFor(
    month,
    businessAccounts.value,
    "legacyUnreconciled",
  );
  const personalOrdinary = movementFor(
    month,
    personalAccounts.value,
    "ordinary",
  );
  const personalLegacy = movementFor(
    month,
    personalAccounts.value,
    "legacyUnreconciled",
  );
  const rows: WorldviewRow[] = [
    {
      id: `${month.month}:world`,
      label: "Combined held accounts",
      detail: "Business and personal · internal transfers excluded",
      tone: "world",
      ordinary: month.ordinary,
      legacy: month.legacyUnreconciled,
    },
    {
      id: `${month.month}:business`,
      label: "Business",
      detail: `${businessAccounts.value.length} account${businessAccounts.value.length === 1 ? "" : "s"}`,
      tone: "business",
      ordinary: businessOrdinary,
      legacy: businessLegacy,
    },
  ];
  for (const account of accountRowsFor(month, businessAccounts.value)) {
    const copy = accountLabel(account.account);
    rows.push({
      id: `${month.month}:${accountIdentity(account.account)}`,
      ...copy,
      tone: "account",
      ordinary: account.ordinary,
      legacy: account.legacyUnreconciled,
    });
  }
  rows.push({
    id: `${month.month}:personal`,
    label: "Personal hemisphere",
    detail: `${personalAccounts.value.length} non-business account${personalAccounts.value.length === 1 ? "" : "s"} consolidated`,
    tone: "personal",
    ordinary: personalOrdinary,
    legacy: personalLegacy,
  });
  for (const account of accountRowsFor(month, personalAccounts.value)) {
    const copy = accountLabel(account.account);
    rows.push({
      id: `${month.month}:${accountIdentity(account.account)}`,
      ...copy,
      tone: "account",
      ordinary: account.ordinary,
      legacy: account.legacyUnreconciled,
    });
  }
  return rows;
}

function monthLabel(month: string): string {
  return new Intl.DateTimeFormat("en-ZA", {
    timeZone: "Africa/Johannesburg",
    year: "numeric",
    month: "long",
  }).format(new Date(`${month}-01T12:00:00+02:00`));
}

function movementCount(row: FinancialMovementTotals): number {
  return row.incomeCount + row.outflowCount;
}

function legacyLabel(row: FinancialMovementTotals): string {
  const count = movementCount(row);
  if (count === 0) return "—";
  return `${formatMoney({
    currency: row.income.currency,
    minorUnits: row.income.minorUnits + row.outflow.minorUnits,
  })} · ${count}`;
}

const activeMonthCount = computed(
  () =>
    monthRows.value.filter((month) => movementCount(month.ordinary) > 0)
      .length,
);
</script>

<template>
  <div class="worldview-page">
    <header class="worldview-header">
      <div class="worldview-heading">
        <p class="raven-eyebrow">Temporary preparation view</p>
        <h1>Financial Worldview</h1>
        <p>
          One monthly thread across the business and personal hemispheres,
          grounded in Raven's observed transaction ledger.
        </p>
      </div>
      <div class="worldview-controls raven-surface">
        <label class="raven-field">
          <span>From</span>
          <input v-model="fromMonth" type="month" min="2010-01" :max="throughMonth" />
        </label>
        <label class="raven-field">
          <span>Through</span>
          <input v-model="throughMonth" type="month" :min="fromMonth" :max="currentMonth" />
        </label>
        <label class="raven-field worldview-controls__authority">
          <span>Evidence</span>
          <select v-model="authorityScope">
            <option value="active_ledger">Active ledger only</option>
            <option value="active_ledger_with_legacy_unreconciled">
              Active + legacy shown separately
            </option>
          </select>
        </label>
        <button class="raven-button raven-button--primary" type="button" :disabled="loading" @click="load">
          <span class="i-lucide-refresh-cw" aria-hidden="true" />
          {{
            loading
              ? `Loading ${loadedSliceCount}/${totalSliceCount}…`
              : "Load"
          }}
        </button>
      </div>
    </header>

    <section class="worldview-notice" aria-label="Interpretation boundary">
      <span class="i-lucide-shield-check" aria-hidden="true" />
      <p>
        <strong>This is a movement report, not a balance sheet.</strong>
        Income minus outflow is labelled movement net. Confirmed transfers between
        your own accounts are excluded. Unknown attribution is never treated as zero.
      </p>
    </section>

    <div v-if="errorMessage" class="worldview-error" role="alert">
      <span>{{ errorMessage }}</span>
      <button class="raven-button" type="button" @click="load">Retry</button>
    </div>
    <div v-if="accountWarning" class="worldview-warning" role="status">
      {{ accountWarning }}
    </div>

    <section v-if="trendData" class="worldview-summary" aria-label="Worldview coverage">
      <div>
        <span>Calendar range</span>
        <strong>{{ monthRows.length }} months</strong>
        <small>{{ fromMonth }} through {{ throughMonth }}</small>
      </div>
      <div>
        <span>Months with active movement</span>
        <strong>{{ activeMonthCount }}</strong>
        <small>Zero months remain visible</small>
      </div>
      <div>
        <span>Business accounts</span>
        <strong>{{ businessAccounts.length }}</strong>
        <small>Detected from Financial Space type</small>
      </div>
      <div>
        <span>Personal hemisphere</span>
        <strong>{{ personalAccounts.length }}</strong>
        <small>All non-business accounts consolidated</small>
      </div>
    </section>

    <div v-if="loading && !trendData" class="worldview-loading" aria-label="Loading monthly ledgers">
      <div v-for="index in 5" :key="index" />
    </div>

    <main v-else-if="trendData" class="month-thread">
      <section
        v-for="month in monthRows"
        :id="`month-${month.month}`"
        :key="month.month"
        class="month-ledger"
        :class="{ 'month-ledger--quiet': movementCount(month.ordinary) === 0 }"
      >
        <header>
          <div>
            <p class="raven-eyebrow">{{ month.month }}</p>
            <h2>{{ monthLabel(month.month) }}</h2>
          </div>
          <span>
            {{ movementCount(month.ordinary) }} active movement{{ movementCount(month.ordinary) === 1 ? "" : "s" }}
          </span>
        </header>
        <div class="month-ledger__table-wrap">
          <table class="month-ledger__table">
            <thead>
              <tr>
                <th>Sphere / account</th>
                <th>Income</th>
                <th>Outflow</th>
                <th>Movement net</th>
                <th>Trading</th>
                <th>Paid to wife</th>
                <th>Family support</th>
                <th>Legacy review volume</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="row in rowsForMonth(month)" :key="row.id" :class="`ledger-row--${row.tone}`">
                <td>
                  <strong>{{ row.label }}</strong>
                  <small>{{ row.detail }}</small>
                </td>
                <td>
                  <strong>{{ formatMoney(row.ordinary.income) }}</strong>
                  <small>{{ row.ordinary.incomeCount }} inflow{{ row.ordinary.incomeCount === 1 ? "" : "s" }}</small>
                </td>
                <td>
                  <strong>{{ formatMoney(row.ordinary.outflow) }}</strong>
                  <small>{{ row.ordinary.outflowCount }} outflow{{ row.ordinary.outflowCount === 1 ? "" : "s" }}</small>
                </td>
                <td class="movement-net" :class="{ 'movement-net--negative': row.ordinary.net.minorUnits < 0 }">
                  <strong>{{ formatMoney(row.ordinary.net) }}</strong>
                </td>
                <td class="attribution-unknown">Unknown</td>
                <td class="attribution-unknown">Unknown</td>
                <td class="attribution-unknown">Unknown</td>
                <td class="legacy-volume">{{ legacyLabel(row.legacy) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </main>

    <section v-else-if="!loading" class="raven-empty">
      <p>No monthly ledger has been loaded.</p>
      <button class="raven-button" type="button" @click="load">Load worldview</button>
    </section>

    <footer class="worldview-footer">
      Preparation aid only. Reconcile material figures to source statements and
      review the resulting interpretation with your legal advisers before relying on it.
    </footer>
  </div>
</template>

<style scoped>
.worldview-page {
  display: grid;
  gap: 30px;
}

.worldview-header {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(540px, auto);
  align-items: end;
  gap: 32px;
}

.worldview-heading h1 {
  margin: 4px 0 8px;
  font-size: clamp(34px, 4vw, 52px);
  letter-spacing: -0.035em;
}

.worldview-heading > p:last-child {
  max-width: 720px;
  margin: 0;
  color: var(--raven-muted);
  line-height: 1.6;
}

.worldview-controls {
  display: grid;
  grid-template-columns: 140px 140px minmax(220px, 1fr) auto;
  align-items: end;
  gap: 9px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-sm);
  padding: 12px;
}

.worldview-controls .raven-button {
  min-height: 38px;
}

.worldview-notice {
  display: grid;
  grid-template-columns: 20px minmax(0, 1fr);
  gap: 12px;
  border-block: 1px solid var(--raven-border);
  padding: 16px 2px;
  color: var(--raven-muted);
}

.worldview-notice > span {
  margin-top: 2px;
  color: var(--raven-text);
}

.worldview-notice p {
  margin: 0;
  line-height: 1.55;
}

.worldview-notice strong {
  color: var(--raven-text);
}

.worldview-error,
.worldview-warning {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  border: 1px solid var(--raven-danger);
  border-radius: var(--raven-radius-sm);
  padding: 12px;
  color: var(--raven-danger);
  background: var(--raven-danger-soft);
}

.worldview-warning {
  border-color: var(--raven-border);
  color: var(--raven-muted);
  background: var(--raven-panel);
}

.worldview-summary {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  border-block: 1px solid var(--raven-border);
}

.worldview-summary > div {
  min-width: 0;
  display: grid;
  gap: 4px;
  border-right: 1px solid var(--raven-border);
  padding: 18px;
}

.worldview-summary > div:last-child {
  border-right: 0;
}

.worldview-summary span,
.worldview-summary small,
.month-ledger > header > span,
.month-ledger__table th,
.month-ledger__table small {
  color: var(--raven-faint);
  font-size: 11px;
}

.worldview-summary strong {
  font-size: 23px;
}

.month-thread {
  display: grid;
  gap: 36px;
}

.month-ledger {
  min-width: 0;
  scroll-margin-top: 88px;
}

.month-ledger > header {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 18px;
  border-bottom: 1px solid var(--raven-border);
  padding: 0 2px 12px;
}

.month-ledger h2 {
  margin: 3px 0 0;
  font-size: 22px;
}

.month-ledger--quiet > header,
.month-ledger--quiet .month-ledger__table {
  opacity: 0.68;
}

.month-ledger__table-wrap {
  max-width: 100%;
  overflow-x: auto;
}

.month-ledger__table {
  width: 100%;
  min-width: 1220px;
  border-collapse: collapse;
}

.month-ledger__table th,
.month-ledger__table td {
  border-bottom: 1px solid var(--raven-border-subtle);
  padding: 11px 12px;
  text-align: left;
  vertical-align: top;
}

.month-ledger__table th:first-child,
.month-ledger__table td:first-child {
  width: 25%;
}

.month-ledger__table th {
  font-weight: 650;
  white-space: nowrap;
}

.month-ledger__table td > strong,
.month-ledger__table td > small {
  display: block;
}

.month-ledger__table td > small {
  margin-top: 2px;
}

.ledger-row--world td {
  border-bottom-color: var(--raven-border);
  background: var(--raven-panel-strong);
}

.ledger-row--business td,
.ledger-row--personal td {
  background: var(--raven-panel);
}

.ledger-row--world td:first-child strong,
.ledger-row--business td:first-child strong,
.ledger-row--personal td:first-child strong {
  font-size: 13px;
}

.ledger-row--account td:first-child {
  padding-left: 30px;
}

.ledger-row--account td:first-child strong {
  font-weight: 600;
}

.movement-net--negative strong {
  color: var(--raven-danger);
}

.attribution-unknown {
  color: var(--raven-faint);
  font-size: 12px;
  font-style: italic;
}

.legacy-volume {
  color: var(--raven-muted);
  font-size: 12px;
  white-space: nowrap;
}

.worldview-loading {
  display: grid;
  gap: 28px;
}

.worldview-loading > div {
  height: 230px;
  border: 1px solid var(--raven-border-subtle);
  border-radius: var(--raven-radius-sm);
  background: linear-gradient(90deg, var(--raven-panel), var(--raven-panel-strong), var(--raven-panel));
  background-size: 200% 100%;
  animation: worldview-shimmer 1.5s linear infinite;
}

.worldview-footer {
  border-top: 1px solid var(--raven-border);
  padding-top: 18px;
  color: var(--raven-faint);
  font-size: 11px;
  line-height: 1.5;
}

@keyframes worldview-shimmer {
  to {
    background-position: -200% 0;
  }
}

@media (max-width: 1120px) {
  .worldview-header {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 760px) {
  .worldview-controls {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .worldview-controls__authority {
    grid-column: 1 / -1;
  }

  .worldview-summary {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .worldview-summary > div:nth-child(2) {
    border-right: 0;
  }
}

@media (max-width: 520px) {
  .worldview-controls,
  .worldview-summary {
    grid-template-columns: 1fr;
  }

  .worldview-controls__authority {
    grid-column: auto;
  }

  .worldview-summary > div {
    border-right: 0;
    border-bottom: 1px solid var(--raven-border-subtle);
  }
}
</style>
