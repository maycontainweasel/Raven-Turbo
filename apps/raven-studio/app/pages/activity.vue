<script setup lang="ts">
import { Dialog } from "@ark-ui/vue/dialog";
import {
  formatMoney,
  type AccountSummary,
  type GetAccountOutput,
  type GetMonthProgressOutput,
  type GetTransactionOutput,
  type ListAccountTransactionsOutput,
  type ListAccountsOutput,
  type TransactionView,
} from "@raven/domain";
import type {
  CurrentClassification,
  EffectiveTransactionLens,
} from "~/composables/useClassificationApi";

type DirectoryAccount = AccountSummary & {
  spaceName: string;
  spaceType: string;
};

const api = useAccountControlApi();
const classificationApi = useClassificationApi();
const currentMonth = new Date().toISOString().slice(0, 7);
const selectedMonth = ref(currentMonth);
const selectedAccountRefs = ref<string[]>([]);
const accountsInitialized = ref(false);
const statsOpen = ref(true);
const filtersOpen = ref(true);
const search = ref("");
const kindFilter = ref("");
const flowFilter = ref("");
const selectedTransactionId = ref<string | null>(null);
const meaningMode = ref<"normal" | "tax">("normal");
const clientReady = ref(false);

onMounted(() => {
  clientReady.value = true;
});

useHead({ title: "All Activity · Raven" });

const { data: accountData, pending: accountsPending } =
  await useAsyncData<ListAccountsOutput>(
    "all-activity-accounts",
    () => api.listAccounts(),
    { server: false },
  );

const accounts = computed<DirectoryAccount[]>(() =>
  (accountData.value?.spaces ?? []).flatMap((space) =>
    space.accounts.map((account) => ({
      ...account,
      spaceName: space.name,
      spaceType: space.spaceType,
    })),
  ),
);
const accountRefKey = (
  account: Pick<AccountSummary, "spaceKey" | "accountKey">,
) => `${account.spaceKey}/${account.accountKey}`;
const accountDirectory = computed(
  () =>
    new Map(accounts.value.map((account) => [accountRefKey(account), account])),
);

watch(
  accounts,
  (available) => {
    if (accountsInitialized.value || !available.length) return;
    selectedAccountRefs.value = available.map(accountRefKey);
    accountsInitialized.value = true;
  },
  { immediate: true },
);

const selectedAccounts = computed(() => {
  const selected = new Set(selectedAccountRefs.value);
  return accounts.value.filter((account) =>
    selected.has(accountRefKey(account)),
  );
});

const accountDetailsKey = computed(
  () =>
    `all-activity-months:${accounts.value.map(accountRefKey).join(",") || "empty"}`,
);
const { data: accountDetails } = await useAsyncData<GetAccountOutput[]>(
  accountDetailsKey,
  () =>
    Promise.all(
      accounts.value.map((account) =>
        api.getAccount({
          spaceKey: account.spaceKey,
          accountKey: account.accountKey,
        }),
      ),
    ),
  { server: false },
);
const monthOptions = computed(() =>
  [
    ...new Set([
      currentMonth,
      selectedMonth.value,
      ...(accountDetails.value ?? []).flatMap(
        (detail) => detail.availableMonths,
      ),
    ]),
  ].sort((left, right) => right.localeCompare(left)),
);

watch(
  () => accountDetails.value,
  (details) => {
    const months = details?.flatMap((detail) => detail.availableMonths) ?? [];
    if (!months.length || months.includes(currentMonth)) return;
    selectedMonth.value = [...new Set(months)].sort((a, b) =>
      b.localeCompare(a),
    )[0]!;
  },
  { immediate: true },
);

const monthLabel = (value: string) => {
  const [year, month] = value.split("-").map(Number);
  return new Intl.DateTimeFormat("en-ZA", {
    month: "long",
    year: "numeric",
  }).format(new Date(year!, month! - 1, 1));
};
const selectedMonthLabel = computed(() => monthLabel(selectedMonth.value));
const moveMonth = (offset: number) => {
  const index = monthOptions.value.indexOf(selectedMonth.value);
  const nextIndex = Math.min(
    Math.max(index + offset, 0),
    monthOptions.value.length - 1,
  );
  selectedMonth.value = monthOptions.value[nextIndex] ?? selectedMonth.value;
};

const currencyScopes = computed(() => {
  const grouped = new Map<string, DirectoryAccount[]>();
  for (const account of selectedAccounts.value) {
    const group = grouped.get(account.currency) ?? [];
    group.push(account);
    grouped.set(account.currency, group);
  }
  return [...grouped.entries()].sort(([left], [right]) =>
    left.localeCompare(right),
  );
});
const progressKey = computed(
  () =>
    `all-activity-progress:${selectedMonth.value}:${selectedAccountRefs.value.slice().sort().join(",")}`,
);
const { data: progressData, pending: progressPending } = await useAsyncData<
  GetMonthProgressOutput[]
>(
  progressKey,
  () =>
    Promise.all(
      currencyScopes.value.map(([currency, scopedAccounts]) =>
        api.getMonthProgress({
          month: selectedMonth.value,
          currency,
          authorityScope: "active_ledger_with_legacy_unreconciled",
          accountRefs: scopedAccounts.map((account) => ({
            spaceKey: account.spaceKey,
            accountKey: account.accountKey,
          })),
        }),
      ),
    ),
  { server: false },
);

const fetchCompleteAccountLedger = async (account: DirectoryAccount) => {
  const transactions: TransactionView[] = [];
  const seenCursors = new Set<string>();
  let cursor: string | undefined;
  do {
    const page: ListAccountTransactionsOutput =
      await api.listAccountTransactions({
        spaceKey: account.spaceKey,
        accountKey: account.accountKey,
        month: selectedMonth.value,
        authorityScope: "active_ledger_with_legacy_unreconciled",
        cursor,
        limit: 100,
      });
    transactions.push(...page.transactions);
    if (!page.nextCursor || seenCursors.has(page.nextCursor)) break;
    seenCursors.add(page.nextCursor);
    cursor = page.nextCursor;
  } while (cursor);
  return transactions;
};

const ledgerKey = computed(
  () =>
    `all-activity-ledger:${selectedMonth.value}:${selectedAccountRefs.value.slice().sort().join(",")}`,
);
const {
  data: ledgerData,
  pending: ledgerPending,
  error: ledgerError,
  refresh: refreshLedger,
} = await useAsyncData<TransactionView[]>(
  ledgerKey,
  async () => {
    const pages = await Promise.all(
      selectedAccounts.value.map(fetchCompleteAccountLedger),
    );
    return pages.flat().sort((left, right) => {
      const date = (right.financialDate ?? "").localeCompare(
        left.financialDate ?? "",
      );
      if (date !== 0) return date;
      if (left.transferId && left.transferId === right.transferId) {
        if (
          left.flowDirection === "outflow" &&
          right.flowDirection === "inflow"
        )
          return -1;
        if (
          left.flowDirection === "inflow" &&
          right.flowDirection === "outflow"
        )
          return 1;
      }
      const recorded = (right.recordedAt ?? "").localeCompare(
        left.recordedAt ?? "",
      );
      return recorded !== 0 ? recorded : right.id.localeCompare(left.id);
    });
  },
  { server: false },
);

const lensKey = computed(() => {
  const ids = (ledgerData.value ?? []).map(transaction => transaction.id);
  return `all-activity-lenses:${selectedMonth.value}:${selectedAccountRefs.value.slice().sort().join(",")}:${ids.length}:${ids.at(0) ?? "empty"}:${ids.at(-1) ?? "empty"}`;
});
const {
  data: lensData,
  pending: lensPending,
  refresh: refreshLenses,
} = await useAsyncData<EffectiveTransactionLens[]>(
  lensKey,
  async () => {
    const ids = (ledgerData.value ?? []).map(transaction => transaction.id);
    if (!ids.length) return [];
    const chunks: string[][] = [];
    for (let index = 0; index < ids.length; index += 500) chunks.push(ids.slice(index, index + 500));
    return (await Promise.all(chunks.map(chunk => classificationApi.getEffectiveLenses(chunk)))).flat();
  },
  { server: false },
);
const lensByTransaction = computed(() => new Map((lensData.value ?? []).map(row => [row.transactionId, row])));
const displayDescription = (transaction: TransactionView) => {
  const lens = lensByTransaction.value.get(transaction.id);
  return meaningMode.value === "tax"
    ? lens?.tax.description || transaction.description
    : lens?.normal.description || transaction.description;
};
const displayCategoryName = (transaction: TransactionView) => {
  const lens = lensByTransaction.value.get(transaction.id);
  return meaningMode.value === "tax"
    ? lens?.tax.categoryName || "Unallocated"
    : lens?.normal.categoryName || transaction.category?.name || "Unallocated";
};
const displayCategorySource = (transaction: TransactionView) => {
  if (meaningMode.value === "normal") return "Management";
  const lens = lensByTransaction.value.get(transaction.id);
  return lens?.tax.hasOverride ? "Tax declaration" : "Inherited from normal";
};

const displayTransactions = computed(() => {
  const query = search.value.trim().toLocaleLowerCase();
  return (ledgerData.value ?? []).filter((transaction) => {
    if (kindFilter.value && transaction.kind !== kindFilter.value) return false;
    if (
      flowFilter.value &&
      (flowFilter.value === "unknown"
        ? transaction.flowDirection !== null
        : transaction.flowDirection !== flowFilter.value)
    )
      return false;
    if (!query) return true;
    const account = accountDirectory.value.get(
      accountRefKey(transaction.account),
    );
    return `${displayDescription(transaction)} ${transaction.description} ${transaction.merchantName ?? ""} ${displayCategoryName(transaction)} ${account?.name ?? ""}`
      .toLocaleLowerCase()
      .includes(query);
  });
});

const toggleAccount = (account: DirectoryAccount) => {
  const key = accountRefKey(account);
  selectedAccountRefs.value = selectedAccountRefs.value.includes(key)
    ? selectedAccountRefs.value.filter((candidate) => candidate !== key)
    : [...selectedAccountRefs.value, key];
};
const selectAllAccounts = () => {
  selectedAccountRefs.value = accounts.value.map(accountRefKey);
};
const clearAccounts = () => {
  selectedAccountRefs.value = [];
};

const financialDateLabel = (value: string | null) => {
  if (!value) return "Invalid date";
  const [year, month, day] = value.split("-").map(Number);
  return new Intl.DateTimeFormat("en-ZA", { dateStyle: "medium" }).format(
    new Date(year!, month! - 1, day!),
  );
};
const titleCase = (value: string | null | undefined) =>
  value
    ? value
        .replaceAll("_", " ")
        .replace(/\b\w/g, (character) => character.toUpperCase())
    : "Unavailable";
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
const evidenceStateTone = (transaction: TransactionView) =>
  transaction.evidenceState === "statement_backed"
    ? "raven-chip--info"
    : "raven-chip--warning";
const accountIcon = (account: DirectoryAccount | undefined) => {
  if (!account) return "i-lucide-landmark";
  if (account.accountType.includes("credit")) return "i-lucide-credit-card";
  if (
    account.accountType.includes("saving") ||
    account.accountType.includes("invest")
  )
    return "i-lucide-piggy-bank";
  if (account.spaceType === "business") return "i-lucide-briefcase-business";
  return "i-lucide-wallet-cards";
};
const accountTone = (account: DirectoryAccount | undefined) => {
  if (!account) return "account-tone--neutral";
  if (account.accountType.includes("credit")) return "account-tone--credit";
  if (
    account.accountType.includes("saving") ||
    account.accountType.includes("invest")
  )
    return "account-tone--savings";
  if (account.spaceType === "business") return "account-tone--business";
  return "account-tone--personal";
};
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
const {
  data: transactionData,
  pending: transactionPending,
  refresh: refreshTransaction,
} =
  await useAsyncData<GetTransactionOutput | null>(
    computed(
      () => `all-activity-transaction:${selectedTransactionId.value ?? "none"}`,
    ),
    () =>
      selectedTransactionId.value
        ? api.getTransaction({ transactionId: selectedTransactionId.value })
        : Promise.resolve(null),
    { server: false },
  );
const selectedTransaction = computed(
  () => transactionData.value?.transaction ?? null,
);
const selectedTransactionAccount = computed(() =>
  selectedTransaction.value
    ? accountDirectory.value.get(
        accountRefKey(selectedTransaction.value.account),
      )
    : undefined,
);

const { data: classificationOptions, refresh: refreshClassificationOptions } =
  await useAsyncData(
    "all-activity-classification-options",
    () => classificationApi.getOptions(),
    { server: false },
  );
const classificationKey = computed(
  () => `all-activity-classification:${selectedTransactionId.value ?? "none"}`,
);
const {
  data: classificationData,
  pending: classificationPending,
  refresh: refreshClassification,
} = await useAsyncData<CurrentClassification | null>(
  classificationKey,
  () => selectedTransactionId.value
    ? classificationApi.getCurrent(selectedTransactionId.value)
    : Promise.resolve(null),
  { server: false },
);
const selectedTaxKey = computed(
  () => `all-activity-tax-declaration:${selectedTransactionId.value ?? "none"}`,
);
const {
  data: selectedTaxData,
  pending: selectedTaxPending,
  refresh: refreshSelectedTax,
} = await useAsyncData<EffectiveTransactionLens | null>(
  selectedTaxKey,
  () => selectedTransactionId.value
    ? classificationApi.getTaxCurrent(selectedTransactionId.value)
    : Promise.resolve(null),
  { server: false },
);

const classificationForm = reactive({
  purposeKey: "",
  merchantKey: "",
  categoryKey: "",
  clientKey: "",
  occurrenceLabel: "",
  tags: "",
  notes: "",
});
const classificationSaving = ref(false);
const classificationError = ref("");
const classificationSaved = ref("");
const classificationSpaceKey = computed(
  () => classificationData.value?.transaction?.spaceKey
    ?? selectedTransaction.value?.account.spaceKey
    ?? "",
);
const purposeOptions = computed(() =>
  (classificationOptions.value?.purposes ?? []).filter(
    (purpose) => purpose.spaceKey === classificationSpaceKey.value,
  ),
);
const merchantOptions = computed(() =>
  (classificationOptions.value?.merchants ?? []).filter(
    (merchant) => merchant.spaceKey === classificationSpaceKey.value,
  ),
);
const categoryOptions = computed(() =>
  (classificationOptions.value?.categories ?? []).filter(
    (category) => category.spaceKey === classificationSpaceKey.value,
  ),
);
const clientOptions = computed(() => classificationOptions.value?.clients ?? []);
const selectedMerchant = computed(() => merchantOptions.value.find(item => item.key === classificationForm.merchantKey));
const taxCategoryOptions = computed(() =>
  (classificationOptions.value?.taxCategories ?? []).filter(
    category => category.spaceKey === classificationSpaceKey.value,
  ),
);
const taxForm = reactive({
  taxCategoryKey: "",
  taxDescription: "",
  evidenceStatus: "not_assessed" as "not_assessed" | "missing" | "partial" | "available" | "not_required",
  notes: "",
});
const taxSaving = ref(false);
const taxError = ref("");
const taxSaved = ref("");

watch(
  [() => selectedTaxData.value, () => selectedTransactionId.value],
  ([current]) => {
    const declaration = current?.tax.declaration;
    Object.assign(taxForm, {
      taxCategoryKey: declaration?.taxCategoryKey ?? "",
      taxDescription: declaration?.taxDescription ?? "",
      evidenceStatus: declaration?.evidenceStatus ?? "not_assessed",
      notes: declaration?.notes ?? "",
    });
    taxError.value = "";
    taxSaved.value = "";
  },
  { immediate: true },
);

watch(
  [() => classificationData.value, () => selectedTransactionId.value],
  ([current]) => {
    classificationError.value = "";
    classificationSaved.value = "";
    const assignment = current?.assignment;
    Object.assign(classificationForm, {
      purposeKey: assignment?.purposeKey ?? "",
      merchantKey: current?.transaction?.merchantKey ?? "",
      categoryKey: current?.transaction?.categoryKey ?? "",
      clientKey: assignment?.clientKey ?? "",
      occurrenceLabel: assignment?.occurrenceLabel ?? "",
      tags: assignment?.tags?.join(", ") ?? "",
      notes: assignment?.notes ?? "",
    });
  },
  { immediate: true },
);

watch(() => classificationForm.purposeKey, (purposeKey, previousPurposeKey) => {
  if (!purposeKey || purposeKey === previousPurposeKey) return;
  const purpose = purposeOptions.value.find(item => item.key === purposeKey);
  if (!purpose) return;
  if (!classificationForm.merchantKey && purpose.merchantKey) classificationForm.merchantKey = purpose.merchantKey;
  if (!classificationForm.categoryKey && purpose.categoryKey) classificationForm.categoryKey = purpose.categoryKey;
});

const saveClassification = async () => {
  if (!selectedTransactionId.value || !classificationForm.purposeKey) return;
  classificationSaving.value = true;
  classificationError.value = "";
  classificationSaved.value = "";
  try {
    await classificationApi.assign({
      transactionId: selectedTransactionId.value,
      purposeKey: classificationForm.purposeKey,
      merchantKey: classificationForm.merchantKey || undefined,
      categoryKey: classificationForm.categoryKey || undefined,
      clientKey: classificationForm.clientKey || undefined,
      occurrenceLabel: classificationForm.occurrenceLabel || undefined,
      tags: [...new Set(classificationForm.tags.split(",").map(tag => tag.trim()).filter(Boolean))],
      notes: classificationForm.notes || undefined,
    });
    await Promise.all([
      refreshClassification(),
      refreshTransaction(),
      refreshLedger(),
      refreshClassificationOptions(),
      refreshLenses(),
    ]);
    classificationSaved.value = "Reviewed meaning saved as a new revision.";
  } catch (error: any) {
    classificationError.value = error?.message || "The reviewed meaning could not be saved.";
  } finally {
    classificationSaving.value = false;
  }
};

const clearClassification = async () => {
  if (!selectedTransactionId.value) return;
  classificationSaving.value = true;
  classificationError.value = "";
  classificationSaved.value = "";
  try {
    await classificationApi.clear(selectedTransactionId.value);
    await Promise.all([
      refreshClassification(),
      refreshTransaction(),
      refreshLedger(),
      refreshClassificationOptions(),
      refreshLenses(),
    ]);
    classificationSaved.value = "Reviewed meaning cleared; the statement description is visible again.";
  } catch (error: any) {
    classificationError.value = error?.message || "The reviewed meaning could not be cleared.";
  } finally {
    classificationSaving.value = false;
  }
};

const saveTaxDeclaration = async () => {
  if (!selectedTransactionId.value) return;
  taxSaving.value = true;
  taxError.value = "";
  taxSaved.value = "";
  try {
    await classificationApi.saveTaxDeclaration({
      transactionId: selectedTransactionId.value,
      taxCategoryKey: taxForm.taxCategoryKey || undefined,
      taxDescription: taxForm.taxDescription || undefined,
      evidenceStatus: taxForm.evidenceStatus,
      notes: taxForm.notes || undefined,
    });
    await Promise.all([
      refreshSelectedTax(),
      refreshLenses(),
      refreshClassificationOptions(),
    ]);
    taxSaved.value = "Tax declaration saved as a new revision.";
  } catch (error: any) {
    taxError.value = error?.message || "The tax declaration could not be saved.";
  } finally {
    taxSaving.value = false;
  }
};

const inheritNormalTaxMeaning = async () => {
  if (!selectedTransactionId.value) return;
  taxSaving.value = true;
  taxError.value = "";
  taxSaved.value = "";
  try {
    await classificationApi.inheritNormalTaxMeaning(selectedTransactionId.value);
    await Promise.all([refreshSelectedTax(), refreshLenses()]);
    taxSaved.value = "Tax mode now inherits the normal classification.";
  } catch (error: any) {
    taxError.value = error?.message || "Normal inheritance could not be restored.";
  } finally {
    taxSaving.value = false;
  }
};
</script>

<template>
  <div class="activity-page">
    <header class="activity-context">
      <div class="activity-context__identity">
        <p class="raven-eyebrow">All accounts</p>
        <h1>Money flow</h1>
        <span>
          {{ selectedAccounts.length }} of {{ accounts.length }} accounts ·
          {{ selectedMonthLabel }}
        </span>
      </div>

      <div class="month-switcher" aria-label="Activity month">
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
              {{ monthLabel(month) }}
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

      <details class="account-picker">
        <summary>
          <span class="i-lucide-landmark" aria-hidden="true" />
          <span>{{ selectedAccounts.length }} accounts</span>
          <span class="i-lucide-chevron-down" aria-hidden="true" />
        </summary>
        <div class="account-picker__panel">
          <header>
            <strong>Included accounts</strong>
            <div>
              <button type="button" @click="selectAllAccounts">All</button>
              <button type="button" @click="clearAccounts">None</button>
            </div>
          </header>
          <label v-for="account in accounts" :key="accountRefKey(account)">
            <input
              type="checkbox"
              :checked="selectedAccountRefs.includes(accountRefKey(account))"
              @change="toggleAccount(account)"
            />
            <span class="account-mark" :class="accountTone(account)">
              <span :class="accountIcon(account)" aria-hidden="true" />
            </span>
            <span>
              <strong>{{ account.name }}</strong>
              <small>{{ account.spaceName }} · {{ account.currency }}</small>
            </span>
          </label>
        </div>
      </details>

      <div class="meaning-mode" aria-label="Transaction meaning mode">
        <button type="button" :class="{ active: meaningMode === 'normal' }" :aria-pressed="meaningMode === 'normal'" @click="meaningMode = 'normal'">Normal</button>
        <button type="button" :class="{ active: meaningMode === 'tax' }" :aria-pressed="meaningMode === 'tax'" @click="meaningMode = 'tax'"><span class="i-lucide-scale" />Tax</button>
      </div>

      <div class="activity-view-toggles" aria-label="Visible activity sections">
        <button
          type="button"
          :class="{ active: statsOpen }"
          :aria-pressed="statsOpen"
          aria-label="Toggle activity statistics"
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
          aria-label="Toggle activity filters"
          title="Search and filters"
          @click="filtersOpen = !filtersOpen"
        >
          <span class="i-lucide-list-filter" aria-hidden="true" />
        </button>
      </div>
    </header>

    <main class="activity-content">
      <section
        v-if="statsOpen"
        class="activity-summary"
        aria-label="Monthly summary"
      >
        <div
          v-if="!clientReady || progressPending || accountsPending"
          class="activity-state"
        >
          Loading account totals…
        </div>
        <div v-else-if="!selectedAccounts.length" class="activity-state">
          Select at least one account to calculate the month.
        </div>
        <div
          v-for="progress in progressData ?? []"
          v-else
          :key="progress.meta.currency"
          class="activity-metrics"
        >
          <article>
            <span>Income · {{ progress.meta.currency }}</span>
            <strong class="amount--inflow">{{
              formatMoney(progress.income)
            }}</strong>
            <small>{{ progress.counts.income }} entries</small>
          </article>
          <article>
            <span>Outflow · {{ progress.meta.currency }}</span>
            <strong class="amount--outflow">{{
              formatMoney(progress.outflow)
            }}</strong>
            <small>{{ progress.counts.expense }} entries</small>
          </article>
          <article>
            <span>Net movement · {{ progress.meta.currency }}</span>
            <strong>{{ formatMoney(progress.net) }}</strong>
            <small>Transfers excluded</small>
          </article>
          <article>
            <span>Internal transfers</span>
            <strong class="amount--transfer">{{
              progress.counts.transfer
            }}</strong>
            <small>Observed transfer legs</small>
          </article>
        </div>
      </section>

      <section
        v-if="filtersOpen"
        class="activity-filters raven-surface"
        aria-label="Activity filters"
      >
        <label class="activity-search">
          <span class="i-lucide-search" aria-hidden="true" />
          <span class="sr-only">Search activity</span>
          <input
            v-model="search"
            type="search"
            placeholder="Search descriptions, counterparties, categories, or accounts…"
          />
        </label>
        <label>
          <span>Kind</span>
          <select v-model="kindFilter">
            <option value="">All activity</option>
            <option value="expense">Expense</option>
            <option value="income">Income</option>
            <option value="transfer">Transfer</option>
            <option value="adjustment">Adjustment</option>
            <option value="unresolved">Unresolved</option>
          </select>
        </label>
        <label>
          <span>Flow</span>
          <select v-model="flowFilter">
            <option value="">All flows</option>
            <option value="inflow">Inflow</option>
            <option value="outflow">Outflow</option>
            <option value="unknown">Unknown</option>
          </select>
        </label>
      </section>

      <section class="activity-ledger" aria-labelledby="activity-ledger-title">
        <header>
          <div><h2 id="activity-ledger-title">Transactions</h2><small>{{ meaningMode === 'tax' ? 'Tax declarations override; everything else inherits normal meaning. Monetary totals do not change.' : 'Normal management meaning and statement-backed money.' }}</small></div>
          <span>{{ displayTransactions.length }} displayed<span v-if="meaningMode === 'tax' && lensPending"> · loading tax lens</span></span>
        </header>
        <div v-if="ledgerError" class="activity-error" role="alert">
          <span>The combined ledger could not be loaded.</span>
          <button class="raven-button" type="button" @click="refreshLedger">
            Retry
          </button>
        </div>
        <div class="activity-table-wrap">
          <table class="activity-table">
            <thead>
              <tr>
                <th>Date</th>
                <th>Account</th>
                <th>Item</th>
                <th>Amount</th>
                <th>Category</th>
                <th>State</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="!clientReady || ledgerPending">
                <td colspan="6">Loading the combined ledger…</td>
              </tr>
              <tr v-else-if="!selectedAccounts.length">
                <td colspan="6">No accounts are selected.</td>
              </tr>
              <tr v-else-if="!displayTransactions.length">
                <td colspan="6">No matching transactions in this month.</td>
              </tr>
              <tr
                v-for="transaction in displayTransactions"
                v-else
                :key="transaction.id"
                tabindex="0"
                @click="openTransaction(transaction)"
                @keydown.enter="openTransaction(transaction)"
                @keydown.space.prevent="openTransaction(transaction)"
              >
                <td>{{ financialDateLabel(transaction.financialDate) }}</td>
                <td>
                  <NuxtLink
                    class="transaction-account"
                    :to="`/accounts/${transaction.account.spaceKey}/${transaction.account.accountKey}?month=${selectedMonth}`"
                    @click.stop
                  >
                    <span
                      class="account-mark"
                      :class="
                        accountTone(
                          accountDirectory.get(
                            accountRefKey(transaction.account),
                          ),
                        )
                      "
                    >
                      <span
                        :class="
                          accountIcon(
                            accountDirectory.get(
                              accountRefKey(transaction.account),
                            ),
                          )
                        "
                        aria-hidden="true"
                      />
                    </span>
                    <span>
                      <strong>{{
                        accountDirectory.get(accountRefKey(transaction.account))
                          ?.name ?? transaction.account.accountKey
                      }}</strong>
                      <small>{{
                        accountDirectory.get(accountRefKey(transaction.account))
                          ?.spaceName ?? transaction.account.spaceKey
                      }}</small>
                    </span>
                  </NuxtLink>
                </td>
                <td class="transaction-description">
                  <div class="transaction-description__layout">
                    <span
                      class="transaction-flow"
                      :class="amountTone(transaction)"
                      :title="
                        titleCase(transaction.flowDirection ?? transaction.kind)
                      "
                    >
                      <span :class="flowIcon(transaction)" aria-hidden="true" />
                    </span>
                    <span class="transaction-description__body">
                      <strong>{{ displayDescription(transaction) }}</strong>
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
                  <strong>{{ displayCategoryName(transaction) }}</strong>
                  <small>{{ displayCategorySource(transaction) }}</small>
                </td>
                <td>
                  <div class="transaction-state">
                    <span
                      class="raven-chip"
                      :class="evidenceStateTone(transaction)"
                    >
                      {{ titleCase(transaction.evidenceState) }}
                    </span>
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
      </section>
    </main>

    <ClientOnly>
      <Dialog.Root
        :open="Boolean(selectedTransactionId)"
        @open-change="({ open }) => !open && closeTransaction()"
      >
        <Teleport to="body">
          <Dialog.Backdrop
            class="raven-dialog-backdrop activity-drawer-backdrop"
          />
          <Dialog.Positioner class="activity-drawer-positioner">
            <Dialog.Content class="activity-drawer">
              <header>
                <Dialog.CloseTrigger as-child>
                  <button
                    class="raven-icon-button"
                    type="button"
                    aria-label="Close transaction"
                  >
                    <span
                      class="i-lucide-panel-right-close"
                      aria-hidden="true"
                    />
                  </button>
                </Dialog.CloseTrigger>
                <span class="raven-meta">Transaction detail</span>
                <span />
              </header>
              <div v-if="transactionPending" class="drawer-state">
                Loading transaction…
              </div>
              <div v-else-if="selectedTransaction" class="drawer-body">
                <section class="drawer-intro">
                  <div class="drawer-account">
                    <span
                      class="account-mark"
                      :class="accountTone(selectedTransactionAccount)"
                    >
                      <span
                        :class="accountIcon(selectedTransactionAccount)"
                        aria-hidden="true"
                      />
                    </span>
                    <span>
                      <strong>{{ selectedTransactionAccount?.name }}</strong>
                      <small>{{ selectedTransactionAccount?.spaceName }}</small>
                    </span>
                  </div>
                  <Dialog.Title>{{
                    selectedTransaction.description
                  }}</Dialog.Title>
                  <p>
                    {{ financialDateLabel(selectedTransaction.financialDate) }}
                    ·
                    {{
                      selectedTransaction.merchantName ||
                      "No counterparty recorded"
                    }}
                  </p>
                  <strong
                    class="drawer-amount"
                    :class="amountTone(selectedTransaction)"
                  >
                    {{ amountLabel(selectedTransaction) }}
                  </strong>
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
                <section v-if="meaningMode === 'normal'" class="drawer-section classification-editor">
                  <div class="classification-editor__heading">
                    <div>
                      <h3>Reviewed meaning</h3>
                      <p>Augments this transaction; statement date, amount, currency, and description stay unchanged.</p>
                    </div>
                    <span v-if="classificationData?.assignment" class="raven-chip raven-chip--info">Revision {{ classificationData.assignment.revision }}</span>
                  </div>
                  <div v-if="classificationPending" class="classification-state">Loading current interpretation…</div>
                  <div v-else-if="!classificationData?.transaction" class="classification-state classification-state--warning">
                    This row is not available as a canonical transaction record yet, so reviewed meaning cannot be attached here.
                  </div>
                  <div v-else-if="!purposeOptions.length" class="classification-state">
                    <p>Create a reusable transaction purpose for {{ selectedTransactionAccount?.spaceName || classificationSpaceKey }} first.</p>
                    <NuxtLink class="raven-button" to="/meaning" @click="closeTransaction">Open Meaning</NuxtLink>
                  </div>
                  <form v-else class="classification-form" @submit.prevent="saveClassification">
                    <label><span>What this was <small>transaction purpose</small></span><select v-model="classificationForm.purposeKey" required><option value="" disabled>Select what this payment represents</option><option v-for="purpose in purposeOptions" :key="purpose.key" :value="purpose.key">{{ purpose.name }}</option></select></label>
                    <div class="classification-form__columns">
                      <label><span>Merchant / counterparty</span><select v-model="classificationForm.merchantKey"><option value="">Not linked</option><option v-for="merchant in merchantOptions" :key="merchant.key" :value="merchant.key">{{ merchant.name }}</option></select></label>
                      <label><span>Budget category</span><select v-model="classificationForm.categoryKey"><option value="">Unallocated</option><option v-for="category in categoryOptions" :key="category.key" :value="category.key">{{ category.parentName ? `${category.parentName} › ` : '' }}{{ category.name }}</option></select></label>
                    </div>
                    <label><span>Client <small>optional income or cost relationship</small></span><select v-model="classificationForm.clientKey"><option value="">No client link</option><option v-for="client in clientOptions" :key="client.key" :value="client.key">{{ client.name }}</option></select></label>
                    <label><span>Occurrence detail <small>one line for this payment</small></span><input v-model.trim="classificationForm.occurrenceLabel" maxlength="240" placeholder="Domain renewal for example.com" /></label>
                    <label><span>Tags <small>comma separated</small></span><input v-model.trim="classificationForm.tags" list="classification-tags" placeholder="family-contribution, legal-report" /><datalist id="classification-tags"><option v-for="tag in classificationOptions?.tags ?? []" :key="tag" :value="tag" /></datalist></label>
                    <label><span>Review notes <small>optional</small></span><textarea v-model.trim="classificationForm.notes" rows="3" maxlength="2000" placeholder="Why this interpretation is correct" /></label>
                    <div v-if="selectedMerchant" class="classification-link"><span>Ledger destination</span><NuxtLink :to="`/merchants/${classificationSpaceKey}/${selectedMerchant.key}`">{{ selectedMerchant.name }} →</NuxtLink></div>
                    <p v-if="classificationError" class="raven-form-error">{{ classificationError }}</p>
                    <p v-if="classificationSaved" class="classification-success">{{ classificationSaved }}</p>
                    <div class="classification-actions">
                      <button v-if="classificationData?.assignment || classificationData?.transaction?.merchantKey || classificationData?.transaction?.categoryKey" class="raven-button" type="button" :disabled="classificationSaving" @click="clearClassification">Return to statement text</button>
                      <button class="raven-button raven-button--primary" type="submit" :disabled="classificationSaving || !classificationForm.purposeKey"><span class="i-lucide-check-check" />{{ classificationSaving ? 'Saving revision…' : 'Save reviewed meaning' }}</button>
                    </div>
                  </form>
                </section>
                <section v-else class="drawer-section classification-editor tax-editor">
                  <div class="classification-editor__heading">
                    <div>
                      <h3>Tax declaration</h3>
                      <p>A sparse tax-facing category and description. Empty fields inherit normal meaning and never alter statement truth.</p>
                    </div>
                    <span v-if="selectedTaxData?.tax.declaration" class="raven-chip raven-chip--info">Revision {{ selectedTaxData.tax.declaration.revision }}</span>
                    <span v-else class="raven-chip">Inherited</span>
                  </div>
                  <div v-if="selectedTaxPending" class="classification-state">Loading tax meaning…</div>
                  <div v-else-if="!classificationData?.transaction" class="classification-state classification-state--warning">This row is not available as a canonical transaction record yet, so a tax declaration cannot be attached.</div>
                  <form v-else class="classification-form" @submit.prevent="saveTaxDeclaration">
                    <aside class="tax-inheritance">
                      <span class="i-lucide-git-merge" />
                      <div><strong>Normal fallback</strong><p>{{ selectedTaxData?.normal.description || selectedTransaction.description }} · {{ selectedTaxData?.normal.categoryName || selectedTransaction.category?.name || 'Unallocated' }}</p></div>
                    </aside>
                    <label><span>Tax category <small>optional override</small></span><select v-model="taxForm.taxCategoryKey"><option value="">Inherit normal category</option><option v-for="category in taxCategoryOptions" :key="category.key" :value="category.key">{{ category.parentName ? `${category.parentName} › ` : '' }}{{ category.name }}</option></select></label>
                    <label><span>Tax description <small>optional override</small></span><input v-model.trim="taxForm.taxDescription" maxlength="240" :placeholder="selectedTaxData?.normal.description || selectedTransaction.description" /></label>
                    <label><span>Evidence readiness <small>tracking only</small></span><select v-model="taxForm.evidenceStatus"><option value="not_assessed">Not assessed</option><option value="missing">Missing</option><option value="partial">Partial</option><option value="available">Available</option><option value="not_required">Not required</option></select></label>
                    <label><span>Tax notes <small>optional rationale</small></span><textarea v-model.trim="taxForm.notes" rows="3" maxlength="2000" placeholder="Why this tax-facing wording or category is appropriate" /></label>
                    <p class="tax-boundary"><span class="i-lucide-info" />This declaration is a working classification. It is not a deductibility, VAT, professional-review, workpaper, or filing decision.</p>
                    <p v-if="taxError" class="raven-form-error">{{ taxError }}</p>
                    <p v-if="taxSaved" class="classification-success">{{ taxSaved }}</p>
                    <div class="classification-actions">
                      <button v-if="selectedTaxData?.tax.hasOverride" class="raven-button" type="button" :disabled="taxSaving" @click="inheritNormalTaxMeaning">Use normal classification</button>
                      <button class="raven-button raven-button--primary" type="submit" :disabled="taxSaving || (!taxForm.taxCategoryKey && !taxForm.taxDescription)"><span class="i-lucide-check-check" />{{ taxSaving ? 'Saving revision…' : 'Save tax declaration' }}</button>
                    </div>
                    <NuxtLink v-if="!taxCategoryOptions.length" class="classification-link" to="/meaning" @click="closeTransaction"><span>No tax categories exist for this Financial Space</span><strong>Create one →</strong></NuxtLink>
                  </form>
                </section>
                <section class="drawer-section">
                  <h3>Meaning</h3>
                  <dl>
                    <div>
                      <dt>Kind</dt>
                      <dd>{{ titleCase(selectedTransaction.kind) }}</dd>
                    </div>
                    <div>
                      <dt>Flow</dt>
                      <dd>
                        {{ titleCase(selectedTransaction.flowDirection) }}
                      </dd>
                    </div>
                    <div>
                      <dt>{{ meaningMode === 'tax' ? 'Tax category' : 'Category' }}</dt>
                      <dd>
                        {{ meaningMode === 'tax' ? (selectedTaxData?.tax.categoryName || selectedTransaction.category?.name || 'Unallocated') : (selectedTransaction.category?.name || 'Unallocated') }}
                      </dd>
                    </div>
                    <div>
                      <dt>Evidence</dt>
                      <dd>
                        {{ titleCase(selectedTransaction.evidenceState) }}
                      </dd>
                    </div>
                  </dl>
                </section>
                <section
                  v-if="selectedTransaction.transfer"
                  class="drawer-section"
                >
                  <h3>Transfer</h3>
                  <p>
                    Counterpart:
                    {{ selectedTransaction.transfer.counterpart.spaceKey }} /
                    {{ selectedTransaction.transfer.counterpart.accountKey }}
                  </p>
                </section>
              </div>
            </Dialog.Content>
          </Dialog.Positioner>
        </Teleport>
      </Dialog.Root>
    </ClientOnly>
  </div>
</template>

<style scoped>
.activity-page {
  min-width: 0;
  display: grid;
  gap: 24px;
}
.activity-context {
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
.activity-context__identity {
  flex: 1 1 300px;
  min-width: 0;
}
.activity-context__identity .raven-eyebrow {
  margin: 0 0 3px;
}
.activity-context__identity h1 {
  margin: 0;
  font-size: 18px;
  line-height: 1.2;
}
.activity-context__identity > span {
  display: block;
  margin-top: 3px;
  color: var(--raven-faint);
  font-size: 10px;
}
.month-switcher,
.activity-view-toggles,
.meaning-mode,
.account-picker > summary {
  display: inline-flex;
  align-items: center;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
  padding: 3px;
  background: var(--raven-panel);
}
.meaning-mode button {
  min-height: 28px;
  display: inline-flex;
  align-items: center;
  gap: 5px;
  border: 0;
  border-radius: 5px;
  padding: 0 10px;
  color: var(--raven-faint);
  background: transparent;
  font-size: 9px;
  font-weight: 750;
  cursor: pointer;
}
.meaning-mode button.active {
  color: var(--raven-text);
  background: var(--raven-panel-subtle);
  box-shadow: inset 0 0 0 1px var(--raven-border);
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
.activity-view-toggles button {
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
.activity-view-toggles button.active {
  background: var(--raven-panel-subtle);
  color: var(--raven-text);
  box-shadow: inset 0 0 0 1px var(--raven-border);
}
.account-picker {
  position: relative;
}
.account-picker > summary {
  min-height: 36px;
  gap: 8px;
  padding-inline: 11px;
  color: var(--raven-muted);
  font-size: 10px;
  font-weight: 700;
  list-style: none;
  cursor: pointer;
}
.account-picker > summary::-webkit-details-marker {
  display: none;
}
.account-picker[open] > summary {
  border-color: var(--raven-accent);
  color: var(--raven-text);
}
.account-picker__panel {
  position: absolute;
  top: calc(100% + 8px);
  right: 0;
  z-index: 70;
  width: min(330px, calc(100vw - 24px));
  display: grid;
  gap: 4px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
  padding: 8px;
  background: var(--raven-panel-raised);
  box-shadow: 0 18px 46px rgb(0 0 0 / 0.42);
}
.account-picker__panel > header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 5px 5px 8px;
}
.account-picker__panel > header strong {
  font-size: 10px;
}
.account-picker__panel > header button {
  border: 0;
  padding: 4px 6px;
  background: transparent;
  color: var(--raven-accent);
  font-size: 9px;
  cursor: pointer;
}
.account-picker__panel label {
  min-width: 0;
  display: grid;
  grid-template-columns: 16px 30px minmax(0, 1fr);
  align-items: center;
  gap: 9px;
  border-radius: 6px;
  padding: 7px;
  cursor: pointer;
}
.account-picker__panel label:hover {
  background: var(--raven-panel-subtle);
}
.account-picker__panel input {
  accent-color: var(--raven-accent);
}
.account-picker__panel label > span:last-child,
.transaction-account > span:last-child,
.drawer-account > span:last-child {
  min-width: 0;
  display: grid;
  gap: 2px;
}
.account-picker__panel label strong,
.account-picker__panel label small,
.transaction-account strong,
.transaction-account small,
.drawer-account strong,
.drawer-account small {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.account-picker__panel label strong {
  font-size: 10px;
}
.account-picker__panel label small {
  color: var(--raven-faint);
  font-size: 8px;
}
.account-mark {
  width: 30px;
  height: 30px;
  display: grid;
  place-items: center;
  border: 1px solid var(--raven-border);
  border-radius: 6px;
  background: var(--raven-panel-subtle);
  color: var(--raven-muted);
}
.account-tone--business {
  color: var(--raven-info);
}
.account-tone--personal {
  color: var(--raven-accent);
}
.account-tone--savings {
  color: var(--raven-warning);
}
.account-tone--credit {
  color: var(--raven-danger);
}
.activity-content {
  min-width: 0;
  display: grid;
  gap: 18px;
}
.activity-summary {
  display: grid;
  gap: 10px;
}
.activity-metrics {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 10px;
}
.activity-metrics article {
  min-width: 0;
  display: grid;
  gap: 6px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
  padding: 14px 15px;
  background: var(--raven-panel);
}
.activity-metrics span {
  color: var(--raven-faint);
  font-size: 9px;
  font-weight: 750;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}
.activity-metrics strong {
  overflow: hidden;
  font-size: 17px;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.activity-metrics small {
  color: var(--raven-muted);
  font-size: 9px;
}
.activity-state {
  border: 1px solid var(--raven-border);
  padding: 16px;
  color: var(--raven-muted);
  font-size: 10px;
}
.activity-filters {
  display: grid;
  grid-template-columns: minmax(280px, 1.8fr) repeat(2, minmax(140px, 0.6fr));
  gap: 8px;
  padding: 8px;
}
.activity-filters label {
  min-width: 0;
  display: grid;
  gap: 3px;
}
.activity-filters label > span:not(.sr-only) {
  padding-left: 4px;
  color: var(--raven-faint);
  font-size: 8px;
  font-weight: 750;
  letter-spacing: 0.06em;
  text-transform: uppercase;
}
.activity-filters input,
.activity-filters select {
  width: 100%;
  min-height: 38px;
  border: 1px solid var(--raven-border);
  border-radius: 6px;
  padding: 0 10px;
  background: var(--raven-bg);
  color: var(--raven-text);
  font-size: 11px;
}
.activity-search {
  position: relative;
  align-self: end;
}
.activity-search > span:not(.sr-only) {
  position: absolute;
  left: 12px;
  top: 13px;
  z-index: 1;
  padding: 0 !important;
  font-size: 13px !important;
}
.activity-search input {
  padding-left: 35px;
}
.activity-ledger {
  min-width: 0;
}
.activity-ledger > header {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 11px;
}
.activity-ledger h2 {
  margin: 0;
  font-size: 17px;
}
.activity-ledger > header small {
  display: block;
  margin-top: 4px;
  color: var(--raven-muted);
  font-size: 9px;
}
.activity-ledger > header > span {
  color: var(--raven-faint);
  font-size: 9px;
}
.activity-table-wrap {
  overflow-x: auto;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
}
.activity-table {
  width: 100%;
  min-width: 1120px;
  border-collapse: collapse;
  background: var(--raven-panel);
}
.activity-table th,
.activity-table td {
  border-bottom: 1px solid var(--raven-border-subtle);
  padding: 12px 13px;
  text-align: left;
}
.activity-table th {
  color: var(--raven-faint);
  font-size: 8px;
  font-weight: 750;
  letter-spacing: 0.07em;
  text-transform: uppercase;
}
.activity-table td {
  color: var(--raven-muted);
  font-size: 10px;
}
.activity-table tbody tr[tabindex] {
  cursor: pointer;
}
.activity-table tbody tr[tabindex]:hover,
.activity-table tbody tr[tabindex]:focus {
  background: color-mix(in srgb, var(--raven-accent-soft) 55%, transparent);
  outline: none;
}
.activity-table td strong,
.activity-table td small {
  display: block;
}
.activity-table td small {
  margin-top: 4px;
  color: var(--raven-faint);
  font-size: 8px;
}
.transaction-account,
.drawer-account {
  min-width: 0;
  display: grid;
  grid-template-columns: 30px minmax(0, 1fr);
  align-items: center;
  gap: 9px;
  color: inherit;
  text-decoration: none;
}
.transaction-account {
  max-width: 220px;
}
.transaction-account strong {
  color: var(--raven-text);
  font-size: 10px;
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
.transaction-description {
  min-width: 280px;
}
.transaction-description__layout {
  display: grid;
  grid-template-columns: 24px minmax(0, 1fr);
  align-items: start;
  gap: 8px;
}
.activity-table .transaction-impact .amount {
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
.transaction-description__body {
  min-width: 0;
}
.transaction-description strong {
  color: var(--raven-text);
  font-size: 13px;
  line-height: 1.4;
}
.transaction-state {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 6px;
}
.transaction-review-indicator {
  width: 24px;
  height: 24px;
  display: grid;
  place-items: center;
  border: 0;
  border-radius: 5px;
  padding: 0;
  background: transparent;
  color: var(--raven-warning);
  cursor: pointer;
}
.transaction-review-indicator:hover,
.transaction-review-indicator:focus-visible {
  background: var(--raven-warning-soft);
  outline: none;
}
.activity-table .amount {
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
.activity-error {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  margin-bottom: 10px;
  border: 1px solid color-mix(in srgb, var(--raven-danger) 42%, transparent);
  border-radius: var(--raven-radius-md);
  padding: 10px 12px;
  background: var(--raven-danger-soft);
  color: var(--raven-danger);
}
.activity-drawer-positioner {
  position: fixed;
  inset: 0;
  z-index: 80;
  display: flex;
  justify-content: flex-end;
  pointer-events: none;
}
.activity-drawer-backdrop {
  background: rgb(0 0 0 / 0.35);
}
.activity-drawer {
  width: min(100%, 560px);
  height: 100%;
  overflow-y: auto;
  border-left: 1px solid var(--raven-border);
  background: var(--raven-bg);
  box-shadow: -18px 0 44px rgb(0 0 0 / 0.3);
  pointer-events: auto;
}
.activity-drawer > header {
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
.activity-drawer > header > span {
  text-align: center;
}
.drawer-state,
.drawer-body {
  padding: 22px;
}
.drawer-account {
  margin-bottom: 18px;
}
.drawer-account strong {
  font-size: 10px;
}
.drawer-account small {
  color: var(--raven-faint);
  font-size: 8px;
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
.drawer-intro > p {
  margin: 0;
  color: var(--raven-muted);
  font-size: 10px;
}
.drawer-amount {
  display: block;
  margin-top: 20px;
  font-size: 20px;
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
.drawer-review-notice p {
  margin: 3px 0 0;
  color: var(--raven-muted);
  font-size: 9px;
}
.drawer-section {
  border-bottom: 1px solid var(--raven-border);
  padding: 19px 0;
}
.drawer-section h3 {
  margin: 0 0 11px;
  font-size: 10px;
  text-transform: uppercase;
}
.drawer-section dl {
  margin: 0;
  display: grid;
  gap: 9px;
}
.drawer-section dl > div {
  display: grid;
  grid-template-columns: 90px minmax(0, 1fr);
  gap: 12px;
}
.drawer-section dt,
.drawer-section dd,
.drawer-section p {
  margin: 0;
  color: var(--raven-muted);
  font-size: 9px;
}
.drawer-section dt {
  color: var(--raven-faint);
}
.classification-editor__heading {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 14px;
  margin-bottom: 13px;
}
.classification-editor__heading h3 {
  margin-bottom: 5px;
}
.classification-editor__heading p,
.classification-state,
.classification-state p {
  margin: 0;
  color: var(--raven-muted);
  font-size: 9px;
  line-height: 1.5;
}
.classification-state {
  border: 1px solid var(--raven-border);
  border-radius: 6px;
  padding: 11px;
}
.classification-state .raven-button {
  margin-top: 10px;
}
.classification-state--warning {
  border-color: color-mix(in srgb, var(--raven-warning) 35%, var(--raven-border));
  color: var(--raven-warning);
}
.classification-form {
  display: grid;
  gap: 11px;
}
.classification-form__columns {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 9px;
}
.classification-form label {
  display: grid;
  gap: 5px;
}
.classification-form label > span,
.classification-link > span {
  color: var(--raven-faint);
  font-size: 8px;
  font-weight: 750;
  letter-spacing: .05em;
  text-transform: uppercase;
}
.classification-form label small {
  font-weight: 400;
  letter-spacing: 0;
  text-transform: none;
}
.classification-form input,
.classification-form select,
.classification-form textarea {
  width: 100%;
  min-height: 36px;
  border: 1px solid var(--raven-border);
  border-radius: 6px;
  padding: 8px 10px;
  color: var(--raven-text);
  background: var(--raven-panel);
  font: inherit;
  font-size: 10px;
}
.classification-form textarea {
  resize: vertical;
}
.classification-link {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  border-radius: 6px;
  padding: 8px 10px;
  background: var(--raven-panel-subtle);
  font-size: 9px;
}
.classification-link a {
  color: var(--raven-accent);
}
.classification-success {
  margin: 0;
  color: var(--raven-success);
  font-size: 9px;
}
.tax-inheritance {
  display: flex;
  align-items: flex-start;
  gap: 9px;
  border: 1px solid var(--raven-border);
  border-radius: 6px;
  padding: 10px;
  background: var(--raven-panel-subtle);
}
.tax-inheritance > span {
  margin-top: 2px;
  color: var(--raven-accent);
}
.tax-inheritance strong {
  font-size: 9px;
}
.tax-inheritance p,
.tax-boundary {
  margin: 3px 0 0;
  color: var(--raven-muted);
  font-size: 9px;
  line-height: 1.45;
}
.tax-boundary {
  display: flex;
  align-items: flex-start;
  gap: 7px;
}
.classification-actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
}
@media (max-width: 900px) {
  .activity-context__identity {
    flex-basis: 100%;
  }
  .activity-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
@media (max-width: 680px) {
  .activity-filters {
    grid-template-columns: 1fr;
  }
  .activity-metrics {
    grid-template-columns: 1fr;
  }
  .account-picker__panel {
    position: fixed;
    top: 132px;
    right: 12px;
  }
  .classification-form__columns {
    grid-template-columns: 1fr;
  }
}
</style>
