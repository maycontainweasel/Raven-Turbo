<script setup lang="ts">
import { Dialog } from "@ark-ui/vue/dialog";
import {
  formatMoney,
  type AccountSummary,
  type GetAccountOutput,
  type GetMonthProgressOutput,
  type GetTransactionOutput,
  type ListAccountTransactionsOutput,
  type ListCategoriesOutput,
  type TransactionView,
} from "@raven/domain";

type ClassificationMode = "management" | "tax";

const route = useRoute();
const api = useAccountControlApi();
const { dataVersion, openCommand } = useRavenActions();
const spaceKey = computed(() => String(route.params.spaceKey ?? ""));
const accountKey = computed(() => String(route.params.accountKey ?? ""));
const now = new Date();
const currentMonth = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;
const requestedMonth =
  typeof route.query.month === "string" &&
  /^\d{4}-\d{2}$/.test(route.query.month)
    ? route.query.month
    : null;
const selectedMonth = ref(requestedMonth ?? currentMonth);
const kindFilter = ref("");
const flowFilter = ref("");
const categoryFilter = ref("");
const search = ref("");
const cursor = ref<string | undefined>();
const cursorHistory = ref<Array<string | undefined>>([]);
const selectedTransactionId = ref<string | null>(null);
const balanceAccount = ref<AccountSummary | null>(null);
const classificationMode = ref<ClassificationMode>("management");
const statsOpen = ref(true);
const filtersOpen = ref(true);
const categoriesOpen = ref(true);

useHead({ title: computed(() => `${accountKey.value} · Raven`) });

const {
  data: accountData,
  pending: accountPending,
  error: accountError,
  refresh: refreshAccount,
} = await useAsyncData<GetAccountOutput>(
  computed(() => `account-detail:${spaceKey.value}:${accountKey.value}`),
  () =>
    api.getAccount({ spaceKey: spaceKey.value, accountKey: accountKey.value }),
  { server: false },
);

const account = computed(() => accountData.value?.account ?? null);
const monthOptions = computed(() =>
  [
    ...new Set([
      currentMonth,
      selectedMonth.value,
      ...(accountData.value?.availableMonths ?? []),
    ]),
  ].sort((a, b) => b.localeCompare(a)),
);

watch(
  () => accountData.value?.availableMonths,
  (months) => {
    if (requestedMonth || !months?.length || months.includes(currentMonth))
      return;
    selectedMonth.value = months[0]!;
  },
  { immediate: true },
);

const ledgerKey = computed(() =>
  [
    "account-ledger",
    spaceKey.value,
    accountKey.value,
    selectedMonth.value,
    kindFilter.value,
    flowFilter.value,
    categoryFilter.value,
    search.value,
    cursor.value ?? "first",
  ].join(":"),
);
const {
  data: ledgerData,
  pending: ledgerPending,
  error: ledgerError,
  refresh: refreshLedger,
} = await useAsyncData<ListAccountTransactionsOutput>(
  ledgerKey,
  () =>
    api.listAccountTransactions({
      spaceKey: spaceKey.value,
      accountKey: accountKey.value,
      month: selectedMonth.value,
      authorityScope: "active_ledger_with_legacy_unreconciled",
      kind: (kindFilter.value as any) || undefined,
      flow: (flowFilter.value as any) || undefined,
      categoryKey: categoryFilter.value || undefined,
      search: search.value || undefined,
      cursor: cursor.value,
      limit: 40,
    }),
  { server: false },
);

const progressKey = computed(
  () =>
    `account-progress:${spaceKey.value}:${accountKey.value}:${selectedMonth.value}:${account.value?.currency ?? "pending"}`,
);
const {
  data: progressData,
  pending: progressPending,
  error: progressError,
  refresh: refreshProgress,
} = await useAsyncData<GetMonthProgressOutput | null>(
  progressKey,
  () =>
    account.value
      ? api.getMonthProgress({
          month: selectedMonth.value,
          currency: account.value.currency,
          authorityScope: "active_ledger_with_legacy_unreconciled",
          accountRefs: [
            { spaceKey: spaceKey.value, accountKey: accountKey.value },
          ],
        })
      : Promise.resolve(null),
  { server: false },
);

const { data: categoryData } = await useAsyncData<ListCategoriesOutput>(
  computed(() => `account-categories:${spaceKey.value}`),
  () => api.listCategories({ spaceKey: spaceKey.value }),
  { server: false },
);

const {
  data: transactionData,
  pending: transactionPending,
  error: transactionError,
} = await useAsyncData<GetTransactionOutput | null>(
  computed(() => `transaction-detail:${selectedTransactionId.value ?? "none"}`),
  () =>
    selectedTransactionId.value
      ? api.getTransaction({ transactionId: selectedTransactionId.value })
      : Promise.resolve(null),
  { server: false },
);

const displayTransactions = computed(
  () => ledgerData.value?.transactions ?? [],
);
const displayProgress = computed(() => progressData.value ?? null);
const selectedTransaction = computed(
  () => transactionData.value?.transaction ?? null,
);
const monthQuality = computed(
  () => displayProgress.value?.meta.quality ?? "unavailable",
);
const selectedMonthLabel = computed(() => {
  const [year, month] = selectedMonth.value.split("-").map(Number);
  return new Intl.DateTimeFormat("en-ZA", {
    month: "long",
    year: "numeric",
  }).format(new Date(year!, month! - 1, 1));
});
const visibleCategories = computed(() =>
  classificationMode.value === "tax"
    ? []
    : (categoryData.value?.categories ?? []).filter(
        (category) => category.kind !== "tax",
      ),
);
const categoryModeLabel = computed(() =>
  classificationMode.value === "tax"
    ? "Tax treatment"
    : "Management categories",
);
const totalTransactions = computed(() => {
  const counts = displayProgress.value?.counts;
  return counts ? counts.income + counts.expense + counts.transfer : null;
});
const categorizedCount = computed(() => {
  if (totalTransactions.value === null) return null;
  if (classificationMode.value === "tax") return 0;
  return Math.max(
    0,
    totalTransactions.value -
      (displayProgress.value?.counts.uncategorized ?? 0),
  );
});
const needsReviewCount = computed(() => {
  if (totalTransactions.value === null) return null;
  return classificationMode.value === "tax"
    ? totalTransactions.value
    : (displayProgress.value?.counts.uncategorized ?? 0);
});
const classificationRate = computed(() => {
  if (totalTransactions.value === null) return null;
  if (classificationMode.value === "tax" || totalTransactions.value === 0)
    return 0;
  return Math.round(
    ((categorizedCount.value ?? 0) / totalTransactions.value) * 100,
  );
});
const categorySummary = computed(() => {
  if (classificationMode.value === "tax") return [];
  const summaries = new Map<
    string,
    { name: string; count: number; minorUnits: number }
  >();
  for (const transaction of displayTransactions.value) {
    if (!transaction.amount || transaction.kind === "transfer") continue;
    const name =
      transaction.category?.kind !== "tax"
        ? (transaction.category?.name ?? "Unallocated")
        : "Needs clarification";
    const current = summaries.get(name) ?? { name, count: 0, minorUnits: 0 };
    current.count += 1;
    current.minorUnits += Math.abs(transaction.amount.minorUnits);
    summaries.set(name, current);
  }
  const values = [...summaries.values()]
    .sort((a, b) => b.minorUnits - a.minorUnits)
    .slice(0, 5);
  const maximum = Math.max(...values.map((item) => item.minorUnits), 1);
  return values.map((item) => ({
    ...item,
    width: Math.max(8, (item.minorUnits / maximum) * 100),
  }));
});

watch([selectedMonth, kindFilter, flowFilter, categoryFilter, search], () => {
  cursor.value = undefined;
  cursorHistory.value = [];
});

watch(classificationMode, () => {
  categoryFilter.value = "";
});

watch(dataVersion, async () => {
  await Promise.all([refreshAccount(), refreshLedger(), refreshProgress()]);
});

const refreshAll = async () => {
  await Promise.all([refreshAccount(), refreshLedger(), refreshProgress()]);
};

const accountRef = computed(() => ({
  spaceKey: spaceKey.value,
  accountKey: accountKey.value,
}));
const command = (
  kind: "record-expense" | "record-income" | "record-transfer",
) => openCommand(kind, accountRef.value);

const moveMonth = (offset: number) => {
  const index = monthOptions.value.indexOf(selectedMonth.value);
  const nextIndex = Math.min(
    Math.max(index + offset, 0),
    monthOptions.value.length - 1,
  );
  selectedMonth.value = monthOptions.value[nextIndex] ?? selectedMonth.value;
};
const nextPage = () => {
  if (!ledgerData.value?.nextCursor) return;
  cursorHistory.value.push(cursor.value);
  cursor.value = ledgerData.value.nextCursor;
};
const previousPage = () => {
  cursor.value = cursorHistory.value.pop();
};

const titleCase = (value: string | null | undefined) =>
  value
    ? value
        .replaceAll("_", " ")
        .replace(/\b\w/g, (character) => character.toUpperCase())
    : "Unavailable";
const financialDateLabel = (value: string | null) => {
  if (!value) return "Invalid date";
  const [year, month, day] = value.split("-").map(Number);
  return new Intl.DateTimeFormat("en-ZA", { dateStyle: "medium" }).format(
    new Date(year!, month! - 1, day!),
  );
};
const instantLabel = (value: string | null | undefined) =>
  value
    ? new Intl.DateTimeFormat("en-ZA", {
        dateStyle: "medium",
        timeStyle: "short",
      }).format(new Date(value))
    : "Unavailable";
const balanceLabel = computed(() =>
  account.value?.selectedBalance
    ? formatMoney(account.value.selectedBalance.money)
    : "Unavailable",
);
const progressAmountLabel = (
  amount: GetMonthProgressOutput["income"] | null | undefined,
) =>
  progressPending.value
    ? "Loading…"
    : amount
      ? formatMoney(amount)
      : "Unavailable";
const progressCountLabel = (count: number | null | undefined) =>
  count === null || count === undefined
    ? "Unavailable"
    : `${count} ${count === 1 ? "entry" : "entries"}`;
const amountLabel = (transaction: TransactionView) => {
  if (!transaction.amount) return "Unavailable";
  const label = formatMoney(transaction.amount);
  if (transaction.kind === "transfer")
    return transaction.flowDirection === "inflow"
      ? `→ ${label}`
      : transaction.flowDirection === "outflow"
        ? `← ${label}`
        : `↔ ${label}`;
  return transaction.flowDirection === "inflow"
    ? `+${label}`
    : transaction.flowDirection === "outflow"
      ? `−${label}`
      : label;
};
const amountTone = (transaction: TransactionView) =>
  transaction.kind === "transfer"
    ? "amount--transfer"
    : transaction.flowDirection === "inflow"
      ? "amount--inflow"
      : transaction.flowDirection === "outflow"
        ? "amount--outflow"
        : "amount--unknown";
const flowIcon = (transaction: TransactionView) =>
  transaction.kind === "transfer" || transaction.flowDirection === null
    ? "i-lucide-arrow-left-right"
    : transaction.flowDirection === "inflow"
      ? "i-lucide-arrow-up"
      : "i-lucide-arrow-down";
const reportedBalanceLabel = (transaction: TransactionView) =>
  transaction.reportedBalance
    ? formatMoney(transaction.reportedBalance)
    : "Unavailable";
const categoryForMode = (
  transaction: TransactionView,
  mode = classificationMode.value,
) => {
  if (
    mode === "tax" ||
    !transaction.category ||
    transaction.category.kind === "tax"
  )
    return null;
  return transaction.category;
};
const meaningState = (
  transaction: TransactionView,
  mode = classificationMode.value,
) =>
  mode === "tax"
    ? transaction.taxMeaningState
    : transaction.managementMeaningState;
const classificationLabel = (
  transaction: TransactionView,
  mode = classificationMode.value,
) =>
  mode === "tax"
    ? titleCase(transaction.taxMeaningState)
    : (categoryForMode(transaction, mode)?.name ?? "Unallocated");
const alternateClassificationLabel = (transaction: TransactionView) => {
  const alternate =
    classificationMode.value === "management" ? "tax" : "management";
  return `${alternate === "tax" ? "Tax" : "Management"}: ${classificationLabel(transaction, alternate)}`;
};
const stateTone = (state: string) =>
  ({
    classified: "raven-chip--accent",
    statement_backed: "raven-chip--info",
    provisional: "raven-chip--warning",
    needs_clarification: "raven-chip--warning",
    unresolved: "raven-chip--warning",
  })[state] ?? "";
const reviewWarningCodes = new Set([
  "LEGACY_TRANSFER_AMBIGUOUS",
  "LEGACY_TRANSACTION_INVALID",
  "TRANSACTION_SEMANTICS_UNRESOLVED",
  "PARTIAL_CANONICAL_TRANSACTION",
  "CANONICAL_LEGACY_CONFLICT",
  "TRANSACTION_DATE_INVALID",
]);
const transactionNeedsReview = (transaction: TransactionView) =>
  transaction.kind === "unresolved" ||
  transaction.amount === null ||
  transaction.financialDate === null ||
  (transaction.kind === "transfer" && transaction.flowDirection === null) ||
  transaction.warnings.some((warning) => reviewWarningCodes.has(warning));
const openTransaction = (transaction: TransactionView) => {
  selectedTransactionId.value = transaction.id;
};
const closeTransaction = () => {
  selectedTransactionId.value = null;
};
</script>

<template>
  <div class="account-detail">
    <nav class="account-context" aria-label="Account context">
      <div class="account-context__identity">
        <p class="raven-eyebrow">
          {{ account?.bankName || account?.accountType || "Tracked account" }}
        </p>
        <h1>{{ accountPending ? "Loading…" : account?.name || accountKey }}</h1>
        <span
          >{{
            account?.accountNumberLast4
              ? `•••• ${account.accountNumberLast4} · `
              : ""
          }}{{ account?.spaceKey }} · {{ account?.currency }}</span
        >
      </div>
      <div class="month-switcher" aria-label="Statement month">
        <button
          class="raven-icon-button"
          type="button"
          :disabled="selectedMonth === monthOptions.at(-1)"
          aria-label="Previous month"
          @click="moveMonth(1)"
        >
          <span class="i-lucide-chevron-left" aria-hidden="true" />
        </button>
        <label>
          <span class="sr-only">Month</span>
          <select v-model="selectedMonth">
            <option v-for="month in monthOptions" :key="month" :value="month">
              {{ month === selectedMonth ? selectedMonthLabel : month }}
            </option>
          </select>
        </label>
        <button
          class="raven-icon-button"
          type="button"
          :disabled="selectedMonth === monthOptions[0]"
          aria-label="Next month"
          @click="moveMonth(-1)"
        >
          <span class="i-lucide-chevron-right" aria-hidden="true" />
        </button>
      </div>
      <div class="account-view-toggles" aria-label="Visible account sections">
        <button
          type="button"
          :class="{ active: statsOpen }"
          :aria-pressed="statsOpen"
          aria-label="Toggle account statistics"
          title="Statistics"
          @click="statsOpen = !statsOpen"
        >
          <span
            class="i-lucide-chart-no-axes-column-increasing"
            aria-hidden="true"
          />
        </button>
        <button
          type="button"
          :class="{ active: filtersOpen }"
          :aria-pressed="filtersOpen"
          aria-label="Toggle transaction search and filters"
          title="Search and filters"
          @click="filtersOpen = !filtersOpen"
        >
          <span class="i-lucide-list-filter" aria-hidden="true" />
        </button>
        <button
          type="button"
          :class="{ active: categoriesOpen }"
          :aria-pressed="categoriesOpen"
          aria-label="Toggle category overview"
          title="Categories"
          @click="categoriesOpen = !categoriesOpen"
        >
          <span class="i-lucide-tags" aria-hidden="true" />
        </button>
      </div>
      <div class="classification-switcher" aria-label="Classification context">
        <button
          type="button"
          :class="{ active: classificationMode === 'management' }"
          @click="classificationMode = 'management'"
        >
          Management
        </button>
        <button
          type="button"
          :class="{ active: classificationMode === 'tax' }"
          @click="classificationMode = 'tax'"
        >
          Tax
        </button>
      </div>
      <AccountActionMenu
        :disabled="!account"
        @balance="balanceAccount = account"
        @expense="command('record-expense')"
        @income="command('record-income')"
        @transfer="command('record-transfer')"
        @import-statement="
          navigateTo(`/accounts/${spaceKey}/${accountKey}/statements/import`)
        "
      />
    </nav>

    <div v-if="accountError" class="detail-error" role="alert">
      <span
        >The account could not be loaded. No financial values have been
        substituted.</span
      >
      <button class="raven-button" type="button" @click="refreshAll">
        Retry
      </button>
    </div>

    <div class="detail-content">
      <section
        v-if="statsOpen"
        class="account-metrics"
        aria-label="Account month summary"
      >
        <article>
          <span>Selected balance</span>
          <strong>{{ balanceLabel }}</strong>
          <small
            >{{ titleCase(account?.selectedBalance?.kind) }} ·
            {{ titleCase(account?.freshness.state) }}</small
          >
        </article>
        <article>
          <span>Income</span>
          <strong class="amount--inflow">{{
            progressAmountLabel(displayProgress?.income)
          }}</strong>
          <small>{{
            progressCountLabel(displayProgress?.counts.income)
          }}</small>
        </article>
        <article>
          <span>Outflow</span>
          <strong class="amount--outflow">{{
            progressAmountLabel(displayProgress?.outflow)
          }}</strong>
          <small>{{
            progressCountLabel(displayProgress?.counts.expense)
          }}</small>
        </article>
        <article>
          <span>Net movement</span>
          <strong>{{ progressAmountLabel(displayProgress?.net) }}</strong>
          <small>Transfers excluded · {{ monthQuality }}</small>
        </article>
      </section>

      <div
        v-if="progressError || ledgerError"
        class="detail-error"
        role="alert"
      >
        <span
          >The selected month could not be loaded. No transaction values have
          been substituted.</span
        >
        <button class="raven-button" type="button" @click="refreshAll">
          Retry
        </button>
      </div>
      <section
        v-if="filtersOpen"
        class="ledger-controls raven-surface"
        aria-label="Transaction filters"
      >
        <label class="ledger-search">
          <span class="i-lucide-search" aria-hidden="true" />
          <span class="sr-only">Search transactions</span>
          <input
            v-model="search"
            type="search"
            placeholder="Search description or counterparty…"
          />
        </label>
        <label
          ><span>Kind</span
          ><select v-model="kindFilter">
            <option value="">All activity</option>
            <option value="expense">Expense</option>
            <option value="income">Income</option>
            <option value="transfer">Transfer</option>
            <option value="adjustment">Adjustment</option>
            <option value="unresolved">Unresolved</option>
          </select></label
        >
        <label
          ><span>Flow</span
          ><select v-model="flowFilter">
            <option value="">All flows</option>
            <option value="inflow">Inflow</option>
            <option value="outflow">Outflow</option>
            <option value="unknown">Unknown</option>
          </select></label
        >
        <label>
          <span>{{ classificationMode === "tax" ? "Tax" : "Category" }}</span>
          <select
            v-model="categoryFilter"
            :disabled="classificationMode === 'tax'"
          >
            <option value="">
              {{
                classificationMode === "tax" ? "Tax persistence pending" : "All"
              }}
            </option>
            <option
              v-for="category in visibleCategories"
              :key="category.key"
              :value="category.key"
            >
              {{ category.name }}
            </option>
          </select>
        </label>
      </section>

      <section
        v-if="categoriesOpen"
        class="category-overview raven-surface"
        :aria-label="categoryModeLabel"
      >
        <header>
          <div>
            <p class="raven-eyebrow">{{ classificationMode }} view</p>
            <h2>{{ categoryModeLabel }}</h2>
          </div>
          <p>Current loaded transactions · {{ selectedMonthLabel }}</p>
        </header>
        <div v-if="categorySummary.length" class="category-overview__grid">
          <article v-for="item in categorySummary" :key="item.name">
            <div>
              <strong>{{ item.name }}</strong
              ><span
                >{{ item.count }}
                {{ item.count === 1 ? "entry" : "entries" }}</span
              >
            </div>
            <div class="category-bar" aria-hidden="true">
              <span :style="{ width: `${item.width}%` }" />
            </div>
            <b>{{
              formatMoney({
                currency: account?.currency || "ZAR",
                minorUnits: item.minorUnits,
              })
            }}</b>
          </article>
        </div>
        <div v-else class="category-empty">
          <span class="i-lucide-tags" aria-hidden="true" />
          <p>
            {{
              classificationMode === "tax"
                ? "Tax meaning has not been assessed or persisted for these transactions."
                : "No management classifications are visible in this page of transactions."
            }}
          </p>
        </div>
      </section>

      <section class="ledger-section" aria-labelledby="ledger-title">
        <header>
          <h2 id="ledger-title">Transactions</h2>
          <span>{{ displayTransactions.length }} displayed</span>
        </header>
        <div class="ledger-wrap">
          <table class="ledger-table">
            <thead>
              <tr>
                <th>Date</th>
                <th>Item</th>
                <th>Amount</th>
                <th>
                  {{
                    classificationMode === "tax"
                      ? "Tax treatment"
                      : "Management category"
                  }}
                </th>
                <th>State</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="ledgerPending">
                <td colspan="5">Loading ledger…</td>
              </tr>
              <tr v-else-if="ledgerError">
                <td colspan="5">
                  The ledger is unavailable. No transactions have been
                  substituted.
                </td>
              </tr>
              <tr v-else-if="!displayTransactions.length">
                <td colspan="5">No matching transactions in this month.</td>
              </tr>
              <tr
                v-for="transaction in displayTransactions"
                v-else
                :key="transaction.id"
                :class="{
                  'ledger-row--ignored': transaction.status === 'ignored',
                  'ledger-row--selected':
                    selectedTransactionId === transaction.id,
                }"
                tabindex="0"
                @click="openTransaction(transaction)"
                @keydown.enter="openTransaction(transaction)"
                @keydown.space.prevent="openTransaction(transaction)"
              >
                <td>{{ financialDateLabel(transaction.financialDate) }}</td>
                <td class="ledger-description">
                  <div class="ledger-description__layout">
                    <span
                      class="transaction-flow"
                      :class="amountTone(transaction)"
                      :title="
                        titleCase(transaction.flowDirection ?? transaction.kind)
                      "
                    >
                      <span :class="flowIcon(transaction)" aria-hidden="true" />
                    </span>
                    <span class="ledger-description__body">
                      <strong>{{ transaction.description }}</strong>
                      <small>{{
                        transaction.merchantName || "No counterparty recorded"
                      }}</small>
                    </span>
                  </div>
                </td>
                <td class="transaction-impact">
                  <strong class="amount" :class="amountTone(transaction)">
                    {{ amountLabel(transaction) }}
                  </strong>
                  <small class="transaction-balance">
                    <span>Balance:</span>
                    <strong :class="amountTone(transaction)">
                      {{ reportedBalanceLabel(transaction) }}
                    </strong>
                  </small>
                </td>
                <td>
                  <strong>{{ classificationLabel(transaction) }}</strong
                  ><small>{{
                    alternateClassificationLabel(transaction)
                  }}</small>
                </td>
                <td>
                  <div class="transaction-state">
                    <span
                      class="raven-chip"
                      :class="stateTone(transaction.evidenceState)"
                      >{{ titleCase(transaction.evidenceState) }}</span
                    >
                    <button
                      v-if="transactionNeedsReview(transaction)"
                      class="transaction-review-indicator"
                      type="button"
                      aria-label="Unresolved transaction"
                      title="Unresolved"
                      @click.stop="openTransaction(transaction)"
                    >
                      <span
                        class="i-lucide-triangle-alert"
                        aria-hidden="true"
                      />
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <footer class="ledger-pagination">
          <button
            class="raven-button"
            type="button"
            :disabled="cursorHistory.length === 0"
            @click="previousPage"
          >
            <span class="i-lucide-chevron-left" aria-hidden="true" /> Previous
          </button>
          <button
            class="raven-button"
            type="button"
            :disabled="!ledgerData?.nextCursor"
            @click="nextPage"
          >
            Next <span class="i-lucide-chevron-right" aria-hidden="true" />
          </button>
        </footer>
      </section>

      <section class="classification-health raven-surface">
        <div>
          <p class="raven-eyebrow">{{ selectedMonthLabel }}</p>
          <h2>Monthly classification health</h2>
          <p>
            {{
              classificationMode === "tax"
                ? "Tax assessment remains unavailable until Raven has an accepted vocabulary, evidence, and review contract."
                : "Progress is based on the management category currently attached to each transaction."
            }}
          </p>
        </div>
        <div class="classification-health__score">
          <strong>{{
            classificationRate === null ? "—" : `${classificationRate}%`
          }}</strong>
          <span>{{
            classificationMode === "tax" ? "assessed" : "classified"
          }}</span>
        </div>
        <dl>
          <div>
            <dt>Transactions</dt>
            <dd>{{ totalTransactions ?? "Unavailable" }}</dd>
          </div>
          <div>
            <dt>
              {{ classificationMode === "tax" ? "Assessed" : "Categorized" }}
            </dt>
            <dd>{{ categorizedCount ?? "Unavailable" }}</dd>
          </div>
          <div>
            <dt>
              {{
                classificationMode === "tax" ? "Not assessed" : "Needs review"
              }}
            </dt>
            <dd>{{ needsReviewCount ?? "Unavailable" }}</dd>
          </div>
          <div>
            <dt>Balance evidence</dt>
            <dd>{{ titleCase(account?.freshness.state) }}</dd>
          </div>
        </dl>
      </section>
    </div>

    <AccountBalanceDialog
      :account="balanceAccount"
      @close="balanceAccount = null"
      @complete="refreshAll"
    />

    <Dialog.Root
      :open="Boolean(selectedTransactionId)"
      @open-change="({ open }) => !open && closeTransaction()"
    >
      <Teleport to="body">
        <Dialog.Backdrop
          class="raven-dialog-backdrop transaction-drawer-backdrop"
        />
        <Dialog.Positioner class="transaction-drawer-positioner">
          <Dialog.Content class="transaction-drawer">
            <header class="transaction-drawer__header">
              <Dialog.CloseTrigger as-child>
                <button
                  class="raven-icon-button"
                  type="button"
                  aria-label="Close transaction"
                >
                  <span class="i-lucide-panel-right-close" aria-hidden="true" />
                </button>
              </Dialog.CloseTrigger>
              <span class="raven-meta">Transaction detail</span>
              <button
                class="raven-icon-button"
                type="button"
                aria-label="More transaction actions"
              >
                <span class="i-lucide-ellipsis" aria-hidden="true" />
              </button>
            </header>
            <div v-if="transactionPending" class="drawer-state">
              Loading transaction…
            </div>
            <div v-else-if="transactionError" class="drawer-state">
              The transaction could not be loaded.
            </div>
            <div v-else-if="selectedTransaction" class="drawer-body">
              <section class="drawer-intro">
                <p class="raven-eyebrow">
                  {{ titleCase(selectedTransaction.kind) }}
                </p>
                <Dialog.Title>{{
                  selectedTransaction.description
                }}</Dialog.Title>
                <p>
                  {{ financialDateLabel(selectedTransaction.financialDate) }} ·
                  {{
                    selectedTransaction.merchantName ||
                    "No counterparty recorded"
                  }}
                </p>
                <div class="drawer-intro__amount">
                  <strong :class="amountTone(selectedTransaction)">{{
                    amountLabel(selectedTransaction)
                  }}</strong>
                  <span
                    class="raven-chip"
                    :class="stateTone(selectedTransaction.evidenceState)"
                    >{{ titleCase(selectedTransaction.evidenceState) }}</span
                  >
                </div>
              </section>

              <div
                v-if="transactionNeedsReview(selectedTransaction)"
                class="drawer-review-notice"
                role="status"
              >
                <span class="i-lucide-triangle-alert" aria-hidden="true" />
                <div>
                  <strong>Confirmation required</strong>
                  <p>The transaction's financial role remains unresolved.</p>
                </div>
              </div>

              <section class="drawer-section">
                <h3>Context</h3>
                <div class="drawer-chips">
                  <span class="raven-chip">{{
                    titleCase(selectedTransaction.kind)
                  }}</span>
                  <span class="raven-chip">{{
                    titleCase(selectedTransaction.flowDirection)
                  }}</span>
                  <span class="raven-chip">{{
                    titleCase(selectedTransaction.entrySource)
                  }}</span>
                  <span class="raven-chip"
                    >{{
                      titleCase(selectedTransaction.status)
                    }}
                    processing</span
                  >
                </div>
              </section>

              <section class="drawer-section">
                <div class="drawer-section__heading">
                  <h3>Classification</h3>
                  <div
                    class="classification-switcher classification-switcher--small"
                  >
                    <button
                      type="button"
                      :class="{ active: classificationMode === 'management' }"
                      @click="classificationMode = 'management'"
                    >
                      Management
                    </button>
                    <button
                      type="button"
                      :class="{ active: classificationMode === 'tax' }"
                      @click="classificationMode = 'tax'"
                    >
                      Tax
                    </button>
                  </div>
                </div>
                <div class="classification-card">
                  <span>{{
                    classificationMode === "tax"
                      ? "Tax treatment"
                      : "Management category"
                  }}</span>
                  <strong>{{
                    classificationLabel(selectedTransaction)
                  }}</strong>
                  <small
                    >{{ titleCase(meaningState(selectedTransaction)) }} ·
                    {{
                      alternateClassificationLabel(selectedTransaction)
                    }}</small
                  >
                </div>
              </section>

              <section class="drawer-section">
                <h3>Source evidence</h3>
                <dl class="drawer-evidence">
                  <div>
                    <dt>Evidence state</dt>
                    <dd>{{ titleCase(selectedTransaction.evidenceState) }}</dd>
                  </div>
                  <div>
                    <dt>Management state</dt>
                    <dd>
                      {{
                        titleCase(selectedTransaction.managementMeaningState)
                      }}
                    </dd>
                  </div>
                  <div>
                    <dt>Tax state</dt>
                    <dd>
                      {{ titleCase(selectedTransaction.taxMeaningState) }}
                    </dd>
                  </div>
                  <div>
                    <dt>Source</dt>
                    <dd>
                      {{
                        titleCase(selectedTransaction.provenance.entrySource)
                      }}
                    </dd>
                  </div>
                  <div>
                    <dt>Recorded</dt>
                    <dd>{{ instantLabel(selectedTransaction.recordedAt) }}</dd>
                  </div>
                  <div>
                    <dt>Source row</dt>
                    <dd>
                      {{
                        selectedTransaction.provenance.sourceRowId ||
                        "Unavailable"
                      }}
                    </dd>
                  </div>
                  <div>
                    <dt>Operation</dt>
                    <dd>
                      {{
                        selectedTransaction.operation?.id ||
                        "Imported / unavailable"
                      }}
                    </dd>
                  </div>
                  <div v-if="selectedTransaction.transfer">
                    <dt>Counterpart</dt>
                    <dd>
                      {{ selectedTransaction.transfer.counterpart.spaceKey }} /
                      {{ selectedTransaction.transfer.counterpart.accountKey }}
                    </dd>
                  </div>
                </dl>
              </section>

              <section v-if="selectedTransaction.notes" class="drawer-section">
                <h3>Notes</h3>
                <p>{{ selectedTransaction.notes }}</p>
              </section>
              <p class="drawer-contract-note">
                The source movement is preserved independently from management
                meaning and tax assessment. Tax editing remains unavailable
                until Raven has an accepted vocabulary, evidence, and review
                contract.
              </p>
            </div>
          </Dialog.Content>
        </Dialog.Positioner>
      </Teleport>
    </Dialog.Root>
  </div>
</template>

<style scoped>
.account-detail {
  min-width: 0;
  display: grid;
  grid-template-columns: minmax(0, 1fr);
  gap: 24px;
}
.account-context {
  position: sticky;
  top: 64px;
  z-index: 40;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
  border-bottom: 1px solid var(--raven-border-subtle);
  padding: 10px 0 12px;
  background: color-mix(in srgb, var(--raven-bg) 94%, transparent);
  backdrop-filter: blur(12px);
}
.account-context__identity {
  flex: 1 1 320px;
  min-width: 0;
}
.account-context__identity .raven-eyebrow {
  margin: 0 0 3px;
}
.account-context__identity h1 {
  margin: 0;
  overflow: hidden;
  font-size: 18px;
  line-height: 1.2;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.account-context__identity > span {
  display: block;
  margin-top: 3px;
  overflow: hidden;
  color: var(--raven-faint);
  font-size: 10px;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.month-switcher,
.classification-switcher,
.account-view-toggles {
  display: inline-flex;
  align-items: center;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
  padding: 3px;
  background: var(--raven-panel);
}
.month-switcher .raven-icon-button {
  width: 30px;
  min-height: 28px;
  border: 0;
}
.month-switcher select {
  min-height: 28px;
  border: 0;
  padding: 0 22px 0 8px;
  background: transparent;
  color: var(--raven-text);
  font-size: 11px;
  font-weight: 700;
}
.account-view-toggles button {
  width: 30px;
  min-height: 28px;
  display: grid;
  place-items: center;
  border: 0;
  border-radius: 5px;
  background: transparent;
  color: var(--raven-faint);
  cursor: pointer;
}
.account-view-toggles button:hover {
  color: var(--raven-muted);
}
.account-view-toggles button.active {
  background: var(--raven-panel-subtle);
  color: var(--raven-text);
  box-shadow: inset 0 0 0 1px var(--raven-border);
}
.classification-switcher button {
  min-height: 28px;
  border: 0;
  border-radius: 5px;
  padding: 0 13px;
  background: transparent;
  color: var(--raven-faint);
  font-size: 10px;
  font-weight: 750;
  cursor: pointer;
}
.classification-switcher button.active {
  background: var(--raven-panel-subtle);
  color: var(--raven-text);
  box-shadow: inset 0 0 0 1px var(--raven-border);
}
.classification-switcher--small button {
  min-height: 24px;
  padding-inline: 9px;
  font-size: 9px;
}
.account-metrics {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 10px;
}
.account-metrics article {
  min-width: 0;
  display: grid;
  gap: 6px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
  padding: 14px 15px;
  background: var(--raven-panel);
}
.account-metrics span {
  color: var(--raven-faint);
  font-size: 9px;
  font-weight: 750;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}
.account-metrics strong {
  overflow: hidden;
  font-size: 17px;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.account-metrics small {
  overflow: hidden;
  color: var(--raven-muted);
  font-size: 9px;
  text-overflow: ellipsis;
  text-transform: capitalize;
  white-space: nowrap;
}
.ledger-controls {
  display: grid;
  grid-template-columns: minmax(260px, 1.6fr) repeat(3, minmax(120px, 0.55fr));
  gap: 8px;
  padding: 8px;
}
.ledger-controls label {
  min-width: 0;
  display: grid;
  gap: 3px;
}
.ledger-controls label > span:not(.sr-only) {
  padding-left: 4px;
  color: var(--raven-faint);
  font-size: 8px;
  font-weight: 750;
  letter-spacing: 0.06em;
  text-transform: uppercase;
}
.ledger-controls select,
.ledger-controls input {
  width: 100%;
  min-height: 38px;
  border: 1px solid var(--raven-border);
  border-radius: 6px;
  padding: 0 10px;
  background: var(--raven-bg);
  color: var(--raven-text);
  font-size: 11px;
}
.ledger-search {
  position: relative;
  align-self: end;
}
.ledger-search > span:not(.sr-only) {
  position: absolute;
  left: 12px;
  top: 13px;
  z-index: 1;
  padding: 0 !important;
  color: var(--raven-faint);
  font-size: 13px !important;
}
.ledger-search input {
  padding-left: 35px;
}
.category-overview {
  padding: 18px;
}
.category-overview > header,
.ledger-section > header {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 16px;
}
.category-overview h2,
.ledger-section h2,
.classification-health h2 {
  margin: 4px 0 0;
  font-size: 17px;
}
.category-overview > header > p,
.ledger-section > header > span {
  margin: 0;
  color: var(--raven-faint);
  font-size: 9px;
}
.category-overview__grid {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 8px;
  margin-top: 18px;
}
.category-overview__grid article {
  min-width: 0;
  display: grid;
  gap: 9px;
  border: 1px solid var(--raven-border-subtle);
  border-radius: 7px;
  padding: 11px;
  background: var(--raven-bg);
}
.category-overview__grid article > div:first-child {
  min-width: 0;
  display: flex;
  justify-content: space-between;
  gap: 8px;
}
.category-overview__grid strong {
  overflow: hidden;
  font-size: 10px;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.category-overview__grid span,
.category-overview__grid b {
  color: var(--raven-faint);
  font-size: 8px;
  font-weight: 600;
  white-space: nowrap;
}
.category-overview__grid b {
  color: var(--raven-muted);
  font-size: 10px;
}
.category-bar {
  height: 3px;
  border-radius: 999px;
  background: var(--raven-border-subtle);
}
.category-bar span {
  height: 100%;
  display: block;
  border-radius: inherit;
  background: var(--raven-accent);
}
.category-empty {
  min-height: 86px;
  display: grid;
  place-items: center;
  align-content: center;
  gap: 8px;
  color: var(--raven-faint);
  text-align: center;
}
.category-empty > span {
  font-size: 18px;
}
.category-empty p {
  margin: 0;
  font-size: 10px;
}
.detail-error {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  border: 1px solid color-mix(in srgb, var(--raven-danger) 42%, transparent);
  border-radius: var(--raven-radius-md);
  padding: 10px 12px;
  background: var(--raven-danger-soft);
  color: var(--raven-danger);
}
.ledger-section {
  min-width: 0;
}
.ledger-section > header {
  margin-bottom: 11px;
}
.ledger-wrap {
  overflow-x: auto;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
}
.ledger-table {
  width: 100%;
  min-width: 960px;
  border-collapse: collapse;
  background: var(--raven-panel);
}
.ledger-table th,
.ledger-table td {
  border-bottom: 1px solid var(--raven-border-subtle);
  padding: 12px 13px;
  text-align: left;
}
.ledger-table th {
  color: var(--raven-faint);
  font-size: 8px;
  font-weight: 750;
  letter-spacing: 0.07em;
  text-transform: uppercase;
}
.ledger-table tbody tr[tabindex] {
  cursor: pointer;
}
.ledger-table tbody tr[tabindex]:hover,
.ledger-table tbody tr[tabindex]:focus,
.ledger-table tbody tr.ledger-row--selected {
  background: color-mix(in srgb, var(--raven-accent-soft) 55%, transparent);
  outline: none;
}
.ledger-table tbody tr.ledger-row--ignored {
  opacity: 0.58;
}
.ledger-table td {
  color: var(--raven-muted);
  font-size: 10px;
}
.ledger-table td strong,
.ledger-table td small {
  display: block;
}
.ledger-table td strong {
  color: var(--raven-text);
  font-size: 11px;
}
.ledger-table td.ledger-description strong {
  font-size: 13px;
  line-height: 1.4;
}
.transaction-impact {
  width: 190px;
  white-space: nowrap;
}
.transaction-impact .amount {
  display: block;
  text-align: left;
}
.transaction-impact small {
  white-space: normal;
}
.transaction-balance {
  display: flex !important;
  align-items: baseline;
  gap: 4px;
  font-size: 10px !important;
}
.transaction-balance > span {
  color: var(--raven-faint);
}
.transaction-balance > strong {
  display: inline !important;
  font-size: 10px !important;
  font-weight: 650;
}
.transaction-balance > .amount--inflow {
  color: color-mix(in srgb, var(--raven-accent) 72%, white) !important;
}
.transaction-balance > .amount--outflow {
  color: color-mix(in srgb, var(--raven-danger) 72%, white) !important;
}
.transaction-balance > .amount--transfer {
  color: color-mix(in srgb, var(--raven-info) 72%, white) !important;
}
.transaction-balance > .amount--unknown {
  color: var(--raven-text) !important;
}
.ledger-table td.ledger-description {
  min-width: 300px;
}
.ledger-description__layout {
  display: grid;
  grid-template-columns: 24px minmax(0, 1fr);
  align-items: start;
  gap: 8px;
}
.ledger-table .transaction-impact .amount {
  text-align: left;
}
.transaction-flow {
  width: 24px;
  height: 24px;
  display: grid;
  place-items: center;
  border: 1px solid currentColor;
  border-radius: 50%;
  font-size: 12px;
}
.ledger-description__body {
  min-width: 0;
}
.ledger-table td.ledger-description small {
  font-size: 9px;
}
.ledger-table td small {
  margin-top: 4px;
  color: var(--raven-faint);
  font-size: 8px;
}
.drawer-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
}
.transaction-state {
  display: flex;
  align-items: center;
  gap: 6px;
}
.transaction-review-indicator {
  width: 24px;
  height: 24px;
  display: grid;
  place-items: center;
  border: 0;
  padding: 0;
  background: transparent;
  color: var(--raven-warning);
  font-size: 13px;
  cursor: pointer;
}
.transaction-review-indicator:hover,
.transaction-review-indicator:focus-visible {
  border-radius: 5px;
  background: var(--raven-warning-soft);
  outline: none;
}
.ledger-table .amount {
  text-align: right;
  font-size: 13px;
  font-weight: 750;
  white-space: nowrap;
}
.amount--inflow {
  color: var(--raven-accent) !important;
}
.amount--outflow {
  color: var(--raven-danger) !important;
}
.amount--transfer {
  color: var(--raven-info) !important;
}
.amount--unknown {
  color: var(--raven-warning) !important;
}
.ledger-pagination {
  display: flex;
  justify-content: space-between;
  margin-top: 10px;
}
.classification-health {
  display: grid;
  grid-template-columns: minmax(240px, 1fr) auto minmax(420px, 1.3fr);
  align-items: center;
  gap: 28px;
  padding: 18px;
}
.classification-health > div:first-child > p:last-child {
  max-width: 460px;
  margin: 7px 0 0;
  color: var(--raven-muted);
  font-size: 10px;
  line-height: 1.5;
}
.classification-health__score {
  width: 80px;
  height: 80px;
  display: grid;
  place-items: center;
  align-content: center;
  border: 1px solid
    color-mix(in srgb, var(--raven-accent) 45%, var(--raven-border));
  border-radius: 50%;
  background: var(--raven-accent-soft);
}
.classification-health__score strong {
  color: var(--raven-accent);
  font-size: 21px;
}
.classification-health__score span {
  margin-top: 3px;
  color: var(--raven-muted);
  font-size: 8px;
  text-transform: uppercase;
}
.classification-health dl {
  margin: 0;
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px 22px;
}
.classification-health dl > div {
  display: flex;
  justify-content: space-between;
  gap: 10px;
  border-bottom: 1px solid var(--raven-border-subtle);
  padding-bottom: 7px;
}
.classification-health dt {
  color: var(--raven-faint);
  font-size: 9px;
}
.classification-health dd {
  margin: 0;
  color: var(--raven-text);
  font-size: 10px;
  font-weight: 700;
  text-transform: capitalize;
}
.transaction-drawer-positioner {
  position: fixed;
  inset: 0;
  z-index: 80;
  display: flex;
  justify-content: flex-end;
  pointer-events: none;
}
.transaction-drawer-backdrop {
  background: rgb(0 0 0 / 0.35);
}
.transaction-drawer {
  width: min(100%, 410px);
  height: 100%;
  overflow-y: auto;
  border-left: 1px solid var(--raven-border);
  background: var(--raven-bg);
  box-shadow: -18px 0 44px rgb(0 0 0 / 0.3);
  pointer-events: auto;
}
.transaction-drawer__header {
  position: sticky;
  top: 0;
  z-index: 2;
  display: grid;
  grid-template-columns: 34px minmax(0, 1fr) 34px;
  align-items: center;
  min-height: 58px;
  border-bottom: 1px solid var(--raven-border);
  padding: 0 14px;
  background: var(--raven-bg);
}
.transaction-drawer__header > span {
  text-align: center;
}
.drawer-state,
.drawer-body {
  padding: 22px;
}
.drawer-intro {
  border-bottom: 1px solid var(--raven-border);
  padding-bottom: 20px;
}
.drawer-intro h2 {
  margin: 6px 0 7px;
  font-size: 22px;
  line-height: 1.15;
}
.drawer-intro > p:last-of-type {
  margin: 0;
  color: var(--raven-muted);
  font-size: 10px;
}
.drawer-intro__amount {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-top: 20px;
}
.drawer-intro__amount strong {
  font-size: 20px;
}
.drawer-section {
  border-bottom: 1px solid var(--raven-border);
  padding: 19px 0;
}
.drawer-section h3 {
  margin: 0 0 11px;
  font-size: 10px;
  letter-spacing: 0.04em;
  text-transform: uppercase;
}
.drawer-section > p {
  margin: 0;
  color: var(--raven-muted);
  font-size: 11px;
  line-height: 1.55;
}
.drawer-section__heading {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 11px;
}
.drawer-section__heading h3 {
  margin: 0;
}
.classification-card {
  display: grid;
  gap: 5px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
  padding: 13px;
  background: var(--raven-panel);
}
.classification-card span,
.classification-card small {
  color: var(--raven-faint);
  font-size: 8px;
}
.classification-card strong {
  font-size: 13px;
}
.drawer-evidence {
  margin: 0;
  display: grid;
  gap: 9px;
}
.drawer-evidence > div {
  display: grid;
  grid-template-columns: 95px minmax(0, 1fr);
  gap: 12px;
}
.drawer-evidence dt {
  color: var(--raven-faint);
  font-size: 9px;
}
.drawer-evidence dd {
  margin: 0;
  overflow-wrap: anywhere;
  color: var(--raven-muted);
  font-size: 9px;
}
.drawer-review-notice {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  margin-top: 16px;
  border: 1px solid
    color-mix(in srgb, var(--raven-warning) 35%, var(--raven-border));
  border-radius: 6px;
  padding: 11px;
  background: var(--raven-warning-soft);
  color: var(--raven-warning);
}
.drawer-review-notice > span {
  flex: 0 0 auto;
  margin-top: 1px;
  font-size: 14px;
}
.drawer-review-notice strong {
  display: block;
  font-size: 10px;
}
.drawer-review-notice p {
  margin: 3px 0 0;
  color: var(--raven-muted);
  font-size: 9px;
  line-height: 1.45;
}
.drawer-contract-note {
  margin: 18px 0 0;
  color: var(--raven-faint);
  font-size: 8px;
  line-height: 1.55;
}
@media (max-width: 1040px) {
  .ledger-controls {
    grid-template-columns: repeat(4, minmax(0, 1fr));
  }
  .ledger-search {
    grid-column: 1 / -1;
  }
  .category-overview__grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
  .classification-health {
    grid-template-columns: minmax(0, 1fr) auto;
  }
  .classification-health dl {
    grid-column: 1 / -1;
  }
}
@media (max-width: 760px) {
  .account-context__identity {
    flex-basis: 100%;
  }
  .account-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
  .ledger-controls {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
  .category-overview__grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
@media (max-width: 520px) {
  .month-switcher select {
    max-width: 125px;
  }
  .classification-switcher button {
    padding-inline: 9px;
  }
  .account-metrics,
  .ledger-controls,
  .category-overview__grid {
    grid-template-columns: 1fr;
  }
  .ledger-search {
    grid-column: auto;
  }
  .classification-health {
    grid-template-columns: 1fr;
  }
  .classification-health__score {
    justify-self: start;
  }
  .classification-health dl {
    grid-column: auto;
    grid-template-columns: 1fr;
    width: 100%;
  }
}
</style>
