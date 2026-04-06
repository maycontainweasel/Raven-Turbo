<script setup lang="ts">
type SpaceRow = {
  id: string
  key: string
  name: string
  spaceType: string
  currency: string
  description?: string | null
}

type AccountRow = {
  id: string
  key: string
  name: string
  bankName: string
  accountType: string
  currency: string
  accountNumberLast4?: string | null
  openingBalance?: number | null
  active: boolean
  notes?: string | null
  transactionCount?: number
  latestTransactionAt?: string | null
  openClarificationCount?: number
}

type TransactionCountRow = {
  account: string
  transactionCount: number
  latestTransactionAt?: string | null
}

type ClarificationCountRow = {
  account: string
  openClarificationCount: number
}

type StatementImportRow = {
  id: string
  key: string
  statementDate: string
  sourceFileName: string
  rowCount: number
  normalizedCount: number
  clarificationCount: number
  status: string
}

type MonthDirectionRow = {
  month: string
  direction: 'credit' | 'debit' | 'transfer'
  total: number
  amountTotal: number
}

type CategoryTotalRow = {
  category: string
  categoryKey?: string | null
  categoryName?: string | null
  total: number
  amountTotal: number
}

type TransactionRow = {
  id: string
  postedAt: string
  description: string
  normalizedDescription?: string | null
  amount: number
  balance?: number | null
  direction: 'credit' | 'debit' | 'transfer'
  status: string
  merchantName?: string | null
  category?: string | null
  categoryKey?: string | null
  categoryName?: string | null
  notes?: string | null
  rowNumber?: number | null
  bankChargeZar?: number | null
  rawRowText?: string | null
}

type TransactionDetail = {
  id: string
  postedAt: string
  description: string
  normalizedDescription?: string | null
  amount: number
  balance?: number | null
  direction: 'credit' | 'debit' | 'transfer'
  status: string
  merchantName?: string | null
  notes?: string | null
  category?: {
    id: string
    key?: string | null
    name?: string | null
  } | null
  merchant?: {
    id: string
    key?: string | null
    name?: string | null
    normalizedName?: string | null
  } | null
  sourceRow?: {
    id: string
    rowNumber?: number | null
    rawData?: {
      rawRowText?: string | null
      bankChargeZar?: number | null
      category?: string | null
      clarificationStatus?: string | null
      feeType?: string | null
      normalizedMerchant?: string | null
      sourceFileName?: string | null
      statementPeriodStart?: string | null
      statementPeriodEnd?: string | null
      transactionType?: string | null
    } | null
  } | null
}

type ClarificationTaskRow = {
  id: string
  key: string
  status: string
  question: string
  reason?: string | null
  confidence?: number | null
  resolutionNotes?: string | null
}

type MonthSummary = {
  month: string
  income: number
  outgoing: number
  transfers: number
  transactionCount: number
  creditCount: number
  debitCount: number
  transferCount: number
  net: number
}

type TransferMatchCandidate = {
  id: string
  postedAt: string
  amount: number
  description: string
  merchantName?: string | null
  categoryKey?: string | null
  categoryName?: string | null
  accountKey?: string | null
  accountName?: string | null
  accountType?: string | null
  accountLast4?: string | null
  spaceKey?: string | null
  spaceName?: string | null
}

type TransferMatchRow = {
  source: {
    id: string
    postedAt: string
    amount: number
    description: string
    merchantName?: string | null
    categoryKey?: string | null
    categoryName?: string | null
    notes?: string | null
    rawRowText?: string | null
    accountKey?: string | null
    accountName?: string | null
    spaceKey?: string | null
    spaceName?: string | null
  }
  bestMatch?: {
    confidence: 'high' | 'medium' | 'low'
    score: number
    dayDelta: number
    inferredKind: string
    reason: string
    candidate: TransferMatchCandidate
  } | null
  candidates: Array<{
    confidence: 'high' | 'medium' | 'low'
    score: number
    dayDelta: number
    inferredKind: string
    reason: string
    candidate: TransferMatchCandidate
  }>
}

type TransferMatchesResult = {
  summary: {
    transferCount: number
    matchedCount: number
    unmatchedCount: number
    matchedAmount: number
    unmatchedAmount: number
  }
  matches: TransferMatchRow[]
}

const route = useRoute()
const router = useRouter()
const explorerApi = useRavenExplorerApi()

const routeString = (value: unknown) => {
  if (Array.isArray(value)) return typeof value[0] === 'string' ? value[0] : ''
  return typeof value === 'string' ? value : ''
}

const formatMoney = (value: number | null | undefined, currency = 'ZAR') =>
  new Intl.NumberFormat('en-ZA', {
    style: 'currency',
    currency,
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(value ?? 0)

const formatCount = (value: number | null | undefined) =>
  new Intl.NumberFormat('en-ZA').format(value ?? 0)

const formatCompactDate = (value: string | null | undefined) => {
  if (!value) return 'Unknown'
  return new Intl.DateTimeFormat('en-ZA', {
    day: '2-digit',
    month: 'short',
    year: 'numeric',
  }).format(new Date(value))
}

const formatMonthLabel = (value: string | null | undefined) => {
  if (!value) return 'Unknown month'
  return new Intl.DateTimeFormat('en-ZA', {
    month: 'long',
    year: 'numeric',
  }).format(new Date(`${value}-01T00:00:00Z`))
}

const formatAccountType = (value: string | null | undefined) =>
  String(value || 'other')
    .split(/[_-]+/)
    .filter(Boolean)
    .map(part => part.charAt(0).toUpperCase() + part.slice(1))
    .join(' ')

const directionTone = (value: 'credit' | 'debit' | 'transfer') => {
  if (value === 'credit') return 'text-emerald-200'
  if (value === 'transfer') return 'text-amber-200'
  return 'text-rose-200'
}

const directionLabel = (value: 'credit' | 'debit' | 'transfer') => {
  if (value === 'credit') return 'Inflow'
  if (value === 'transfer') return 'Transfer'
  return 'Outflow'
}

const monthChipTone = (summary: MonthSummary) => {
  if (summary.net > 0) return 'border-emerald-300/30 bg-emerald-400/10 text-emerald-100'
  if (summary.net < 0) return 'border-rose-300/30 bg-rose-400/10 text-rose-100'
  return 'border-white/10 bg-white/5 text-slate-200'
}

const categoryShare = (amount: number, maxAmount: number) => {
  if (!maxAmount) return 0
  return Math.max(8, Math.round((amount / maxAmount) * 100))
}

const transferConfidenceTone = (value: 'high' | 'medium' | 'low' | null | undefined) => {
  if (value === 'high') return 'border-emerald-300/30 bg-emerald-400/10 text-emerald-100'
  if (value === 'medium') return 'border-amber-300/30 bg-amber-400/10 text-amber-100'
  return 'border-white/10 bg-white/5 text-slate-300'
}

const transferKindLabel = (value: string | null | undefined) =>
  String(value || 'internal_transfer')
    .split(/[_-]+/)
    .filter(Boolean)
    .map(part => part.charAt(0).toUpperCase() + part.slice(1))
    .join(' ')

const spaceKey = computed(() => routeString(route.params.spaceKey))
const requestedAccountKey = computed(() => routeString(route.query.account))
const requestedMonth = computed(() => routeString(route.query.month))
const selectedTransactionId = computed(() => routeString(route.query.tx))

useHead(() => ({
  title: `Raven · ${spaceKey.value || 'Environment'}`,
}))

const { data: environmentData, pending: environmentPending, error: environmentError, refresh: refreshEnvironment } = await useAsyncData(
  () => `raven-environment:${spaceKey.value}`,
  async () => {
    if (!spaceKey.value) return null

    return await explorerApi.getEnvironmentExplorer(spaceKey.value)
  },
  {
    server: false,
    watch: [spaceKey],
  },
)

const selectedAccountKey = computed(() => {
  const accounts = environmentData.value?.accounts || []
  const requested = requestedAccountKey.value
  if (requested && accounts.some(account => account.key === requested)) return requested
  return accounts[0]?.key || ''
})

const selectedAccount = computed(() =>
  (environmentData.value?.accounts || []).find(account => account.key === selectedAccountKey.value) || null,
)

const { data: accountData, pending: accountPending, error: accountError, refresh: refreshAccount } = await useAsyncData(
  () => `raven-environment-account:${spaceKey.value}:${selectedAccountKey.value || 'none'}`,
  async () => {
    if (!spaceKey.value || !selectedAccountKey.value) return null

    return await explorerApi.getAccountExplorer(spaceKey.value, selectedAccountKey.value)
  },
  {
    server: false,
    watch: [spaceKey, selectedAccountKey],
  },
)

const selectedMonth = computed(() => {
  const months = accountData.value?.months || []
  const requested = requestedMonth.value
  if (requested && months.some(month => month.month === requested)) return requested
  return months[0]?.month || ''
})

const currentMonthSummary = computed(() =>
  (accountData.value?.months || []).find(month => month.month === selectedMonth.value) || null,
)

const { data: monthData, pending: monthPending, error: monthError, refresh: refreshMonth } = await useAsyncData(
  () => `raven-environment-month:${spaceKey.value}:${selectedAccountKey.value || 'none'}:${selectedMonth.value || 'none'}`,
  async () => {
    if (!spaceKey.value || !selectedAccountKey.value || !selectedMonth.value) return null

    return await explorerApi.getAccountMonth(spaceKey.value, selectedAccountKey.value, selectedMonth.value)
  },
  {
    server: false,
    watch: [spaceKey, selectedAccountKey, selectedMonth],
  },
)

const { data: transferMatchesData, pending: transferMatchesPending, error: transferMatchesError, refresh: refreshTransferMatches } = await useAsyncData<TransferMatchesResult | null>(
  () => `raven-environment-transfer-matches:${spaceKey.value}:${selectedAccountKey.value || 'none'}:${selectedMonth.value || 'none'}`,
  async () => {
    if (!spaceKey.value || !selectedAccountKey.value || !selectedMonth.value) return null

    return await explorerApi.getAccountTransferMatches(spaceKey.value, selectedAccountKey.value, selectedMonth.value)
  },
  {
    server: false,
    watch: [spaceKey, selectedAccountKey, selectedMonth],
  },
)

const { data: transactionPanelData, pending: transactionPending, error: transactionError } = await useAsyncData(
  () => `raven-transaction-detail:${selectedTransactionId.value || 'none'}`,
  async () => {
    if (!selectedTransactionId.value) return null

    return await explorerApi.getTransactionDetail(selectedTransactionId.value)
  },
  {
    server: false,
    watch: [selectedTransactionId],
  },
)

const categoryMax = computed(() =>
  Math.max(...(monthData.value?.categories || []).map(category => Math.abs(category.amountTotal)), 0),
)

const feeTotal = computed(() =>
  (monthData.value?.categories || [])
    .filter(category => String(category.categoryKey || '').startsWith('fees'))
    .reduce((total, category) => total + category.amountTotal, 0),
)

const matchedTransferRows = computed(() =>
  (transferMatchesData.value?.matches || []).filter(row => row.bestMatch),
)

const unmatchedTransferRows = computed(() =>
  (transferMatchesData.value?.matches || []).filter(row => !row.bestMatch),
)

const linkedTransferAccountCount = computed(() =>
  new Set(
    matchedTransferRows.value
      .map(row => row.bestMatch?.candidate.accountKey)
      .filter((value): value is string => Boolean(value)),
  ).size,
)

const toggleQuery = async (patch: Record<string, string | undefined>) => {
  await router.replace({
    query: {
      ...route.query,
      ...patch,
    },
  })
}

const openAccount = async (accountKey: string) => {
  await toggleQuery({
    account: accountKey,
    month: undefined,
    tx: undefined,
  })
}

const openMonth = async (month: string) => {
  await toggleQuery({
    account: selectedAccountKey.value || undefined,
    month,
    tx: undefined,
  })
}

const openTransaction = async (transactionId: string) => {
  await toggleQuery({
    account: selectedAccountKey.value || undefined,
    month: selectedMonth.value || undefined,
    tx: transactionId,
  })
}

const closeTransaction = async () => {
  await toggleQuery({ tx: undefined })
}

const refreshAll = async () => {
  await Promise.all([
    refreshEnvironment(),
    refreshAccount(),
    refreshMonth(),
    refreshTransferMatches(),
  ])
}
</script>

<template>
  <section class="space-y-8 py-6">
    <header class="space-y-6">
      <NuxtLink to="/" class="inline-flex items-center gap-2 text-sm text-slate-300 transition hover:text-white">
        <span aria-hidden="true">←</span>
        Environments
      </NuxtLink>

      <div class="grid gap-6 xl:grid-cols-[1.15fr_0.85fr]">
        <div class="space-y-4">
          <div class="flex flex-wrap items-center gap-2">
            <span class="rounded-full border border-cyan-400/20 bg-cyan-400/10 px-3 py-1 text-[11px] uppercase tracking-[0.3em] text-cyan-100/80">
              Environment explorer
            </span>
            <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-[11px] uppercase tracking-[0.24em] text-slate-300">
              Calendar months
            </span>
          </div>

          <div v-if="environmentData?.space" class="space-y-3">
            <p class="text-xs uppercase tracking-[0.34em] text-slate-400">
              {{ formatAccountType(environmentData.space.spaceType) }} environment
            </p>
            <h1 class="text-4xl font-semibold tracking-[-0.06em] text-white sm:text-5xl">
              {{ environmentData.space.name }}
            </h1>
            <p class="max-w-3xl text-base leading-7 text-slate-300">
              {{ environmentData.space.description || 'Review account history, move through months, and clarify anything that still feels vague.' }}
            </p>
          </div>
        </div>

        <article class="raven-card space-y-4 p-5 sm:p-6">
          <div class="flex items-center justify-between gap-3">
            <div>
              <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Current lens</p>
              <h2 class="mt-2 text-xl font-semibold text-white">
                {{ selectedAccount?.name || 'No account selected' }}
              </h2>
            </div>
            <button class="raven-link raven-link--ghost" type="button" @click="refreshAll()">
              Refresh
            </button>
          </div>

          <dl class="grid gap-3 sm:grid-cols-3">
            <div class="rounded-3xl border border-white/8 bg-slate-950/45 p-4">
              <dt class="text-[11px] uppercase tracking-[0.26em] text-slate-400">Month</dt>
              <dd class="mt-3 text-lg font-semibold text-white">{{ formatMonthLabel(selectedMonth) }}</dd>
            </div>

            <div class="rounded-3xl border border-white/8 bg-slate-950/45 p-4">
              <dt class="text-[11px] uppercase tracking-[0.26em] text-slate-400">Fees</dt>
              <dd class="mt-3 text-lg font-semibold text-white">{{ formatMoney(feeTotal, selectedAccount?.currency || 'ZAR') }}</dd>
            </div>

            <div class="rounded-3xl border border-white/8 bg-slate-950/45 p-4">
              <dt class="text-[11px] uppercase tracking-[0.26em] text-slate-400">Clarifications</dt>
              <dd class="mt-3 text-lg font-semibold text-white">{{ formatCount(monthData?.openClarificationCount ?? accountData?.openClarificationCount ?? 0) }}</dd>
            </div>
          </dl>
        </article>
      </div>
    </header>

    <section v-if="environmentError" class="raven-card space-y-3 p-6">
      <p class="text-sm font-medium text-rose-200">The environment could not load.</p>
      <p class="text-sm leading-6 text-slate-300">{{ environmentError.message }}</p>
      <button class="raven-link" type="button" @click="refreshEnvironment()">
        Retry
      </button>
    </section>

    <section v-else-if="environmentPending" class="grid gap-4 xl:grid-cols-3">
      <article v-for="index in 3" :key="index" class="raven-card animate-pulse space-y-4 p-6">
        <div class="h-3 w-24 rounded-full bg-white/8" />
        <div class="h-8 w-full rounded-full bg-white/10" />
        <div class="h-28 rounded-3xl bg-white/5" />
      </article>
    </section>

    <template v-else-if="environmentData?.space">
      <section class="space-y-4">
        <div class="flex items-center justify-between gap-4">
          <div>
            <p class="text-xs uppercase tracking-[0.34em] text-slate-400">Accounts</p>
            <h2 class="mt-2 text-2xl font-semibold tracking-[-0.04em] text-white">Choose the operating account.</h2>
          </div>
        </div>

        <div class="grid gap-4 lg:grid-cols-2">
          <button
            v-for="account in environmentData.accounts"
            :key="account.id"
            type="button"
            class="text-left transition"
            :class="account.key === selectedAccountKey ? 'translate-y-[-2px]' : ''"
            @click="openAccount(account.key)"
          >
            <article
              class="raven-card h-full p-5"
              :class="account.key === selectedAccountKey ? 'border-cyan-300/30 bg-cyan-400/[0.07]' : ''"
            >
              <div class="flex flex-wrap items-start justify-between gap-4">
                <div>
                  <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">{{ account.bankName }}</p>
                  <h3 class="mt-2 text-xl font-semibold text-white">{{ account.name }}</h3>
                  <p class="mt-2 text-sm leading-6 text-slate-300">
                    {{ formatAccountType(account.accountType) }}
                    <span v-if="account.accountNumberLast4"> · •••• {{ account.accountNumberLast4 }}</span>
                  </p>
                </div>

                <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs uppercase tracking-[0.22em] text-slate-300">
                  {{ account.currency }}
                </span>
              </div>

              <dl class="mt-5 grid gap-3 sm:grid-cols-3">
                <div class="rounded-2xl border border-white/8 bg-slate-950/35 px-4 py-3">
                  <dt class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Transactions</dt>
                  <dd class="mt-2 text-lg font-semibold text-white">{{ formatCount(account.transactionCount) }}</dd>
                </div>

                <div class="rounded-2xl border border-white/8 bg-slate-950/35 px-4 py-3">
                  <dt class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Open clarifications</dt>
                  <dd class="mt-2 text-lg font-semibold text-white">{{ formatCount(account.openClarificationCount) }}</dd>
                </div>

                <div class="rounded-2xl border border-white/8 bg-slate-950/35 px-4 py-3">
                  <dt class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Latest activity</dt>
                  <dd class="mt-2 text-sm font-medium text-white">{{ formatCompactDate(account.latestTransactionAt) }}</dd>
                </div>
              </dl>
            </article>
          </button>
        </div>
      </section>

      <section v-if="accountError" class="raven-card space-y-3 p-6">
        <p class="text-sm font-medium text-rose-200">The account view could not load.</p>
        <p class="text-sm leading-6 text-slate-300">{{ accountError.message }}</p>
        <button class="raven-link" type="button" @click="refreshAccount()">
          Retry
        </button>
      </section>

      <template v-else-if="accountData?.account">
        <section class="grid gap-4 xl:grid-cols-4">
          <article class="raven-card p-5">
            <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Inflow</p>
            <p class="mt-3 text-2xl font-semibold text-emerald-100">
              {{ formatMoney(currentMonthSummary?.income, accountData.account.currency) }}
            </p>
            <p class="mt-2 text-sm text-slate-300">{{ formatCount(currentMonthSummary?.creditCount) }} credit items</p>
          </article>

          <article class="raven-card p-5">
            <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Outflow</p>
            <p class="mt-3 text-2xl font-semibold text-rose-100">
              {{ formatMoney(currentMonthSummary?.outgoing, accountData.account.currency) }}
            </p>
            <p class="mt-2 text-sm text-slate-300">{{ formatCount(currentMonthSummary?.debitCount) }} debit items</p>
          </article>

          <article class="raven-card p-5">
            <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Transfers</p>
            <p class="mt-3 text-2xl font-semibold text-amber-100">
              {{ formatMoney(currentMonthSummary?.transfers, accountData.account.currency) }}
            </p>
            <p class="mt-2 text-sm text-slate-300">{{ formatCount(currentMonthSummary?.transferCount) }} transfer items</p>
          </article>

          <article class="raven-card p-5">
            <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Net flow</p>
            <p
              class="mt-3 text-2xl font-semibold"
              :class="(currentMonthSummary?.net ?? 0) >= 0 ? 'text-cyan-100' : 'text-rose-100'"
            >
              {{ formatMoney(currentMonthSummary?.net, accountData.account.currency) }}
            </p>
            <p class="mt-2 text-sm text-slate-300">{{ formatCount(currentMonthSummary?.transactionCount) }} transactions in this month</p>
          </article>
        </section>

        <section class="space-y-4">
          <div class="flex flex-wrap items-center justify-between gap-4">
            <div>
              <p class="text-xs uppercase tracking-[0.34em] text-slate-400">Calendar months</p>
              <h2 class="mt-2 text-2xl font-semibold tracking-[-0.04em] text-white">Move through the account history.</h2>
            </div>
          </div>

          <div class="flex gap-3 overflow-x-auto pb-2">
            <button
              v-for="month in accountData.months"
              :key="month.month"
              type="button"
              class="min-w-[16rem] rounded-3xl border px-4 py-4 text-left transition"
              :class="month.month === selectedMonth ? monthChipTone(month) : 'border-white/8 bg-slate-950/35 text-slate-200 hover:border-cyan-300/20 hover:bg-white/[0.06]'"
              @click="openMonth(month.month)"
            >
              <p class="text-[11px] uppercase tracking-[0.24em] text-current/70">
                {{ formatMonthLabel(month.month) }}
              </p>
              <div class="mt-4 grid gap-2 text-sm">
                <div class="flex items-center justify-between">
                  <span>Inflow</span>
                  <span>{{ formatMoney(month.income, accountData.account.currency) }}</span>
                </div>
                <div class="flex items-center justify-between">
                  <span>Outflow</span>
                  <span>{{ formatMoney(month.outgoing, accountData.account.currency) }}</span>
                </div>
                <div class="flex items-center justify-between">
                  <span>Transfers</span>
                  <span>{{ formatMoney(month.transfers, accountData.account.currency) }}</span>
                </div>
              </div>
            </button>
          </div>
        </section>

        <section class="space-y-4">
          <div class="flex flex-wrap items-center justify-between gap-4">
            <div>
              <p class="text-xs uppercase tracking-[0.34em] text-slate-400">Cross-account flows</p>
              <h2 class="mt-2 text-2xl font-semibold tracking-[-0.04em] text-white">Matched transfers for {{ formatMonthLabel(selectedMonth) }}</h2>
              <p class="mt-2 max-w-3xl text-sm leading-6 text-slate-300">
                Review how money moved between tracked accounts. The matches below stay explicit so business-to-personal movement, savings flows, and credit servicing remain visible.
              </p>
            </div>
          </div>

          <div class="grid gap-4 xl:grid-cols-4">
            <article class="raven-card p-5">
              <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Transfer rows</p>
              <p class="mt-3 text-2xl font-semibold text-white">
                {{ formatCount(transferMatchesData?.summary.transferCount ?? 0) }}
              </p>
            </article>

            <article class="raven-card p-5">
              <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Matched</p>
              <p class="mt-3 text-2xl font-semibold text-emerald-100">
                {{ formatCount(transferMatchesData?.summary.matchedCount ?? 0) }}
              </p>
              <p class="mt-2 text-sm text-slate-300">
                {{ formatMoney(transferMatchesData?.summary.matchedAmount, selectedAccount?.currency || 'ZAR') }}
              </p>
            </article>

            <article class="raven-card p-5">
              <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Needs linking</p>
              <p class="mt-3 text-2xl font-semibold text-amber-100">
                {{ formatCount(transferMatchesData?.summary.unmatchedCount ?? 0) }}
              </p>
              <p class="mt-2 text-sm text-slate-300">
                {{ formatMoney(transferMatchesData?.summary.unmatchedAmount, selectedAccount?.currency || 'ZAR') }}
              </p>
            </article>

            <article class="raven-card p-5">
              <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Linked accounts</p>
              <p class="mt-3 text-2xl font-semibold text-cyan-100">
                {{ formatCount(linkedTransferAccountCount) }}
              </p>
              <p class="mt-2 text-sm text-slate-300">Visible counterpart accounts this month</p>
            </article>
          </div>

          <div v-if="transferMatchesError" class="raven-card space-y-3 p-6">
            <p class="text-sm font-medium text-rose-200">The transfer matcher could not load.</p>
            <p class="text-sm leading-6 text-slate-300">{{ transferMatchesError.message }}</p>
            <button class="raven-link" type="button" @click="refreshTransferMatches()">
              Retry
            </button>
          </div>

          <div v-else-if="transferMatchesPending" class="grid gap-4 lg:grid-cols-2">
            <article v-for="index in 2" :key="index" class="raven-card animate-pulse space-y-4 p-6">
              <div class="h-3 w-28 rounded-full bg-white/8" />
              <div class="h-8 w-full rounded-full bg-white/10" />
              <div class="h-24 rounded-3xl bg-white/5" />
            </article>
          </div>

          <div v-else-if="!transferMatchesData?.matches.length" class="raven-card p-6 text-sm leading-6 text-slate-300">
            No transfer-like rows were found for this account in the selected month yet.
          </div>

          <div v-else class="grid gap-6 xl:grid-cols-[1.05fr_0.95fr]">
            <article class="raven-card p-5 sm:p-6">
              <div class="flex items-center justify-between gap-4">
                <div>
                  <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Matched flows</p>
                  <h2 class="mt-2 text-xl font-semibold text-white">Top counterpart matches</h2>
                </div>
                <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs uppercase tracking-[0.22em] text-slate-300">
                  {{ formatCount(matchedTransferRows.length) }} matched
                </span>
              </div>

              <div v-if="!matchedTransferRows.length" class="mt-5 rounded-3xl border border-white/8 bg-slate-950/35 p-5 text-sm leading-6 text-slate-300">
                No counterpart matches were found yet. The transfers still remain visible in the unmatched list.
              </div>

              <ul v-else class="mt-5 space-y-3">
                <li v-for="row in matchedTransferRows" :key="row.source.id" class="rounded-3xl border border-white/8 bg-slate-950/35 p-4">
                  <div class="flex flex-wrap items-start justify-between gap-3">
                    <div>
                      <p class="text-sm font-medium text-white">{{ row.source.description }}</p>
                      <p class="mt-1 text-xs uppercase tracking-[0.18em] text-slate-400">
                        {{ formatCompactDate(row.source.postedAt) }} · {{ row.source.accountName }}
                      </p>
                    </div>

                    <div class="text-right">
                      <p class="text-sm font-semibold text-amber-100">
                        {{ formatMoney(row.source.amount, selectedAccount?.currency || 'ZAR') }}
                      </p>
                      <span
                        class="mt-2 inline-flex rounded-full border px-3 py-1 text-xs uppercase tracking-[0.2em]"
                        :class="transferConfidenceTone(row.bestMatch?.confidence)"
                      >
                        {{ row.bestMatch?.confidence || 'Unmatched' }}
                      </span>
                    </div>
                  </div>

                  <div v-if="row.bestMatch" class="mt-4 rounded-2xl border border-cyan-300/12 bg-cyan-400/[0.05] p-4">
                    <div class="flex flex-wrap items-start justify-between gap-3">
                      <div>
                        <p class="text-[11px] uppercase tracking-[0.22em] text-cyan-100/70">
                          {{ transferKindLabel(row.bestMatch.inferredKind) }}
                        </p>
                        <p class="mt-2 text-sm font-medium text-white">
                          {{ row.bestMatch.candidate.accountName || 'Tracked account' }}
                          <span class="text-slate-400">· {{ row.bestMatch.candidate.spaceName || 'Unknown environment' }}</span>
                        </p>
                        <p class="mt-1 text-sm text-slate-300">
                          {{ row.bestMatch.candidate.description }}
                        </p>
                      </div>

                      <div class="text-right text-sm text-slate-300">
                        <div>{{ formatCompactDate(row.bestMatch.candidate.postedAt) }}</div>
                        <div class="mt-1">{{ formatMoney(row.bestMatch.candidate.amount, selectedAccount?.currency || 'ZAR') }}</div>
                      </div>
                    </div>

                    <p class="mt-3 text-sm leading-6 text-slate-300">
                      {{ row.bestMatch.reason }}
                    </p>
                  </div>
                </li>
              </ul>
            </article>

            <article class="raven-card p-5 sm:p-6">
              <div class="flex items-center justify-between gap-4">
                <div>
                  <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Needs manual linking</p>
                  <h2 class="mt-2 text-xl font-semibold text-white">Unmatched transfer rows</h2>
                </div>
                <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs uppercase tracking-[0.22em] text-slate-300">
                  {{ formatCount(unmatchedTransferRows.length) }} unmatched
                </span>
              </div>

              <div v-if="!unmatchedTransferRows.length" class="mt-5 rounded-3xl border border-white/8 bg-slate-950/35 p-5 text-sm leading-6 text-slate-300">
                Every transfer-like row in this month has a counterpart candidate.
              </div>

              <ul v-else class="mt-5 space-y-3">
                <li v-for="row in unmatchedTransferRows" :key="row.source.id" class="rounded-3xl border border-white/8 bg-slate-950/35 p-4">
                  <div class="flex flex-wrap items-start justify-between gap-3">
                    <div>
                      <p class="text-sm font-medium text-white">{{ row.source.description }}</p>
                      <p class="mt-1 text-xs uppercase tracking-[0.18em] text-slate-400">
                        {{ formatCompactDate(row.source.postedAt) }} · {{ row.source.categoryName || 'Transfer' }}
                      </p>
                    </div>

                    <p class="text-sm font-semibold text-amber-100">
                      {{ formatMoney(row.source.amount, selectedAccount?.currency || 'ZAR') }}
                    </p>
                  </div>

                  <p v-if="row.source.notes" class="mt-3 text-sm leading-6 text-slate-300">
                    {{ row.source.notes }}
                  </p>

                  <button
                    type="button"
                    class="mt-4 inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/5 px-4 py-2 text-sm font-medium text-slate-200 transition hover:border-cyan-300/20 hover:text-white"
                    @click="openTransaction(row.source.id)"
                  >
                    Open transaction
                    <span aria-hidden="true">→</span>
                  </button>
                </li>
              </ul>
            </article>
          </div>
        </section>

        <section class="grid gap-6 xl:grid-cols-[0.82fr_1.18fr]">
          <article class="raven-card p-5 sm:p-6">
            <div class="flex items-center justify-between gap-4">
              <div>
                <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Category rollup</p>
                <h2 class="mt-2 text-xl font-semibold text-white">{{ formatMonthLabel(selectedMonth) }}</h2>
              </div>
              <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs uppercase tracking-[0.22em] text-slate-300">
                {{ formatCount(monthData?.categories.length) }} categories
              </span>
            </div>

            <div v-if="monthError" class="mt-4 space-y-2">
              <p class="text-sm font-medium text-rose-200">The month rollup could not load.</p>
              <p class="text-sm leading-6 text-slate-300">{{ monthError.message }}</p>
              <button class="raven-link" type="button" @click="refreshMonth()">
                Retry
              </button>
            </div>

            <div v-else-if="monthPending" class="mt-4 space-y-3">
              <div v-for="index in 5" :key="index" class="h-14 animate-pulse rounded-2xl bg-white/5" />
            </div>

            <div v-else-if="!monthData?.categories.length" class="mt-4 rounded-3xl border border-white/8 bg-slate-950/35 p-5 text-sm leading-6 text-slate-300">
              No categorized transactions exist for this month yet.
            </div>

            <ul v-else class="mt-5 space-y-3">
              <li
                v-for="category in monthData.categories"
                :key="category.category || category.categoryName || 'unknown-category'"
                class="rounded-3xl border border-white/8 bg-slate-950/35 p-4"
              >
                <div class="flex items-center justify-between gap-4">
                  <div>
                    <p class="text-sm font-medium text-white">{{ category.categoryName || 'Uncategorized' }}</p>
                    <p class="mt-1 text-xs uppercase tracking-[0.22em] text-slate-400">
                      {{ formatCount(category.total) }} entries
                    </p>
                  </div>
                  <p class="text-sm font-semibold text-slate-100">
                    {{ formatMoney(category.amountTotal, selectedAccount?.currency || 'ZAR') }}
                  </p>
                </div>

                <div class="mt-4 h-2 rounded-full bg-white/6">
                  <div
                    class="h-full rounded-full bg-gradient-to-r from-cyan-300 via-sky-300 to-emerald-300"
                    :style="{ width: `${categoryShare(category.amountTotal, categoryMax)}%` }"
                  />
                </div>
              </li>
            </ul>
          </article>

          <article class="raven-card p-5 sm:p-6">
            <div class="flex flex-wrap items-center justify-between gap-4">
              <div>
                <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Transactions</p>
                <h2 class="mt-2 text-xl font-semibold text-white">Statement-ordered month view</h2>
                <p class="mt-2 text-sm leading-6 text-slate-300">
                  Review every row in order, then open any transaction to inspect the raw statement text and its clarification state.
                </p>
              </div>

              <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs uppercase tracking-[0.22em] text-slate-300">
                {{ formatCount(monthData?.transactions.length) }} rows
              </span>
            </div>

            <div class="mt-5 overflow-hidden rounded-3xl border border-white/8 bg-slate-950/35">
              <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-white/6 text-sm">
                  <thead class="bg-white/[0.03] text-left text-[11px] uppercase tracking-[0.24em] text-slate-400">
                    <tr>
                      <th class="px-4 py-3 font-medium">Date</th>
                      <th class="px-4 py-3 font-medium">Description</th>
                      <th class="px-4 py-3 font-medium">Category</th>
                      <th class="px-4 py-3 font-medium">Direction</th>
                      <th class="px-4 py-3 font-medium text-right">Amount</th>
                      <th class="px-4 py-3 font-medium text-right">Balance</th>
                    </tr>
                  </thead>

                  <tbody class="divide-y divide-white/6">
                    <tr v-if="monthPending">
                      <td colspan="6" class="px-4 py-10 text-center text-sm text-slate-300">
                        Loading the month ledger…
                      </td>
                    </tr>

                    <tr v-else-if="!monthData?.transactions.length">
                      <td colspan="6" class="px-4 py-10 text-center text-sm text-slate-300">
                        No transactions exist for this month yet.
                      </td>
                    </tr>

                    <tr
                      v-for="transaction in monthData?.transactions || []"
                      :key="transaction.id"
                      class="cursor-pointer transition hover:bg-white/[0.04]"
                      @click="openTransaction(transaction.id)"
                    >
                      <td class="px-4 py-3 align-top text-slate-200">
                        <div>{{ formatCompactDate(transaction.postedAt) }}</div>
                        <div class="mt-1 text-xs uppercase tracking-[0.18em] text-slate-500">
                          Row {{ transaction.rowNumber || '—' }}
                        </div>
                      </td>

                      <td class="px-4 py-3 align-top">
                        <div class="font-medium text-white">{{ transaction.description }}</div>
                        <div class="mt-1 text-sm text-slate-400">
                          {{ transaction.merchantName || transaction.normalizedDescription || 'Unmapped transaction' }}
                        </div>
                        <div v-if="transaction.notes" class="mt-2 text-xs leading-5 text-slate-500">
                          {{ transaction.notes }}
                        </div>
                      </td>

                      <td class="px-4 py-3 align-top text-slate-300">
                        {{ transaction.categoryName || 'Uncategorized' }}
                      </td>

                      <td class="px-4 py-3 align-top">
                        <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs font-medium uppercase tracking-[0.2em]" :class="directionTone(transaction.direction)">
                          {{ directionLabel(transaction.direction) }}
                        </span>
                      </td>

                      <td class="px-4 py-3 align-top text-right font-medium" :class="directionTone(transaction.direction)">
                        {{ formatMoney(transaction.amount, selectedAccount?.currency || 'ZAR') }}
                      </td>

                      <td class="px-4 py-3 align-top text-right text-slate-300">
                        {{ formatMoney(transaction.balance, selectedAccount?.currency || 'ZAR') }}
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </article>
        </section>

        <section class="raven-card p-5 sm:p-6">
          <div class="flex items-center justify-between gap-4">
            <div>
              <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Statement batches</p>
              <h2 class="mt-2 text-xl font-semibold text-white">Imported statement history</h2>
            </div>
            <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs uppercase tracking-[0.22em] text-slate-300">
              {{ formatCount(accountData.statementImports.length) }} imports
            </span>
          </div>

          <div class="mt-5 grid gap-3 lg:grid-cols-2">
            <article
              v-for="statementImport in accountData.statementImports"
              :key="statementImport.id"
              class="rounded-3xl border border-white/8 bg-slate-950/35 p-4"
            >
              <div class="flex flex-wrap items-center justify-between gap-3">
                <div>
                  <p class="text-sm font-medium text-white">{{ formatCompactDate(statementImport.statementDate) }}</p>
                  <p class="mt-1 text-xs uppercase tracking-[0.18em] text-slate-400">{{ statementImport.key }}</p>
                </div>
                <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs uppercase tracking-[0.2em] text-slate-300">
                  {{ statementImport.status }}
                </span>
              </div>

              <dl class="mt-4 grid gap-3 sm:grid-cols-3">
                <div>
                  <dt class="text-[11px] uppercase tracking-[0.2em] text-slate-500">Rows</dt>
                  <dd class="mt-1 text-sm font-medium text-white">{{ formatCount(statementImport.rowCount) }}</dd>
                </div>
                <div>
                  <dt class="text-[11px] uppercase tracking-[0.2em] text-slate-500">Normalized</dt>
                  <dd class="mt-1 text-sm font-medium text-white">{{ formatCount(statementImport.normalizedCount) }}</dd>
                </div>
                <div>
                  <dt class="text-[11px] uppercase tracking-[0.2em] text-slate-500">Clarifications</dt>
                  <dd class="mt-1 text-sm font-medium text-white">{{ formatCount(statementImport.clarificationCount) }}</dd>
                </div>
              </dl>

              <p class="mt-4 text-xs leading-5 text-slate-500">
                {{ statementImport.sourceFileName }}
              </p>
            </article>
          </div>
        </section>
      </template>
    </template>

    <Teleport to="body">
      <Transition
        enter-active-class="duration-200 ease-out"
        enter-from-class="opacity-0"
        enter-to-class="opacity-100"
        leave-active-class="duration-150 ease-in"
        leave-from-class="opacity-100"
        leave-to-class="opacity-0"
      >
        <div
          v-if="selectedTransactionId"
          class="fixed inset-0 z-40 bg-slate-950/70 backdrop-blur-sm"
          @click="closeTransaction()"
        />
      </Transition>

      <Transition
        enter-active-class="duration-300 ease-out"
        enter-from-class="translate-x-full"
        enter-to-class="translate-x-0"
        leave-active-class="duration-200 ease-in"
        leave-from-class="translate-x-0"
        leave-to-class="translate-x-full"
      >
        <aside
          v-if="selectedTransactionId"
          class="fixed inset-y-0 right-0 z-50 w-full max-w-2xl border-l border-white/10 bg-[#07101c]/95 shadow-[0_0_60px_rgba(2,6,23,0.65)] backdrop-blur"
        >
          <div class="flex h-full flex-col">
            <header class="flex items-start justify-between gap-4 border-b border-white/8 px-5 py-5 sm:px-6">
              <div>
                <p class="text-[11px] uppercase tracking-[0.3em] text-slate-400">Transaction detail</p>
                <h2 class="mt-2 text-2xl font-semibold text-white">
                  {{ transactionPanelData?.transaction?.merchant?.name || transactionPanelData?.transaction?.merchantName || 'Transaction' }}
                </h2>
              </div>

              <button
                type="button"
                class="rounded-full border border-white/10 bg-white/5 px-3 py-2 text-sm text-slate-300 transition hover:text-white"
                @click="closeTransaction()"
              >
                Close
              </button>
            </header>

            <div class="flex-1 overflow-y-auto px-5 py-5 sm:px-6">
              <div v-if="transactionPending" class="space-y-3">
                <div v-for="index in 5" :key="index" class="h-16 animate-pulse rounded-3xl bg-white/5" />
              </div>

              <div v-else-if="transactionError" class="space-y-3">
                <p class="text-sm font-medium text-rose-200">The transaction detail could not load.</p>
                <p class="text-sm leading-6 text-slate-300">{{ transactionError.message }}</p>
              </div>

              <div v-else-if="transactionPanelData?.transaction" class="space-y-6">
                <section class="grid gap-3 sm:grid-cols-2">
                  <div class="rounded-3xl border border-white/8 bg-white/[0.04] p-4">
                    <p class="text-[11px] uppercase tracking-[0.22em] text-slate-400">Amount</p>
                    <p class="mt-3 text-2xl font-semibold" :class="directionTone(transactionPanelData.transaction.direction)">
                      {{ formatMoney(transactionPanelData.transaction.amount, selectedAccount?.currency || 'ZAR') }}
                    </p>
                  </div>

                  <div class="rounded-3xl border border-white/8 bg-white/[0.04] p-4">
                    <p class="text-[11px] uppercase tracking-[0.22em] text-slate-400">Balance</p>
                    <p class="mt-3 text-2xl font-semibold text-white">
                      {{ formatMoney(transactionPanelData.transaction.balance, selectedAccount?.currency || 'ZAR') }}
                    </p>
                  </div>
                </section>

                <section class="grid gap-3 sm:grid-cols-2">
                  <div class="rounded-3xl border border-white/8 bg-white/[0.04] p-4">
                    <p class="text-[11px] uppercase tracking-[0.22em] text-slate-400">Posted</p>
                    <p class="mt-2 text-sm font-medium text-white">{{ formatCompactDate(transactionPanelData.transaction.postedAt) }}</p>
                  </div>

                  <div class="rounded-3xl border border-white/8 bg-white/[0.04] p-4">
                    <p class="text-[11px] uppercase tracking-[0.22em] text-slate-400">Status</p>
                    <p class="mt-2 text-sm font-medium text-white">{{ transactionPanelData.transaction.status }}</p>
                  </div>

                  <div class="rounded-3xl border border-white/8 bg-white/[0.04] p-4">
                    <p class="text-[11px] uppercase tracking-[0.22em] text-slate-400">Category</p>
                    <p class="mt-2 text-sm font-medium text-white">
                      {{ transactionPanelData.transaction.category?.name || 'Uncategorized' }}
                    </p>
                  </div>

                  <div class="rounded-3xl border border-white/8 bg-white/[0.04] p-4">
                    <p class="text-[11px] uppercase tracking-[0.22em] text-slate-400">Bank charge</p>
                    <p class="mt-2 text-sm font-medium text-white">
                      {{ formatMoney(transactionPanelData.transaction.sourceRow?.rawData?.bankChargeZar, selectedAccount?.currency || 'ZAR') }}
                    </p>
                  </div>
                </section>

                <section class="rounded-3xl border border-white/8 bg-white/[0.04] p-4">
                  <p class="text-[11px] uppercase tracking-[0.22em] text-slate-400">Normalized view</p>
                  <p class="mt-3 text-lg font-medium text-white">
                    {{ transactionPanelData.transaction.normalizedDescription || transactionPanelData.transaction.description }}
                  </p>
                  <p class="mt-3 text-sm leading-6 text-slate-300">
                    {{ transactionPanelData.transaction.notes || 'No review notes exist yet.' }}
                  </p>
                </section>

                <section class="rounded-3xl border border-white/8 bg-slate-950/40 p-4">
                  <p class="text-[11px] uppercase tracking-[0.22em] text-slate-400">Raw statement row</p>
                  <pre class="mt-3 overflow-x-auto whitespace-pre-wrap text-sm leading-6 text-slate-200">{{ transactionPanelData.transaction.sourceRow?.rawData?.rawRowText || transactionPanelData.transaction.description }}</pre>
                </section>

                <section class="rounded-3xl border border-white/8 bg-white/[0.04] p-4">
                  <p class="text-[11px] uppercase tracking-[0.22em] text-slate-400">Import context</p>
                  <dl class="mt-4 grid gap-3 sm:grid-cols-2">
                    <div>
                      <dt class="text-[11px] uppercase tracking-[0.2em] text-slate-500">Source file</dt>
                      <dd class="mt-1 text-sm text-white">{{ transactionPanelData.transaction.sourceRow?.rawData?.sourceFileName || 'Unknown' }}</dd>
                    </div>
                    <div>
                      <dt class="text-[11px] uppercase tracking-[0.2em] text-slate-500">Statement period</dt>
                      <dd class="mt-1 text-sm text-white">
                        {{ transactionPanelData.transaction.sourceRow?.rawData?.statementPeriodStart || '—' }}
                        to
                        {{ transactionPanelData.transaction.sourceRow?.rawData?.statementPeriodEnd || '—' }}
                      </dd>
                    </div>
                    <div>
                      <dt class="text-[11px] uppercase tracking-[0.2em] text-slate-500">Imported type</dt>
                      <dd class="mt-1 text-sm text-white">{{ transactionPanelData.transaction.sourceRow?.rawData?.transactionType || '—' }}</dd>
                    </div>
                    <div>
                      <dt class="text-[11px] uppercase tracking-[0.2em] text-slate-500">Row number</dt>
                      <dd class="mt-1 text-sm text-white">{{ transactionPanelData.transaction.sourceRow?.rowNumber || '—' }}</dd>
                    </div>
                  </dl>
                </section>

                <section class="space-y-3">
                  <div class="flex items-center justify-between gap-4">
                    <h3 class="text-lg font-semibold text-white">Clarification queue</h3>
                    <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs uppercase tracking-[0.22em] text-slate-300">
                      {{ formatCount(transactionPanelData.clarificationTasks.length) }} tasks
                    </span>
                  </div>

                  <div
                    v-if="!transactionPanelData.clarificationTasks.length"
                    class="rounded-3xl border border-white/8 bg-slate-950/35 p-4 text-sm leading-6 text-slate-300"
                  >
                    This transaction has no clarification task attached right now.
                  </div>

                  <article
                    v-for="task in transactionPanelData.clarificationTasks"
                    :key="task.id"
                    class="rounded-3xl border border-white/8 bg-slate-950/40 p-4"
                  >
                    <div class="flex items-center justify-between gap-3">
                      <p class="text-sm font-medium text-white">{{ task.question }}</p>
                      <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs uppercase tracking-[0.2em] text-slate-300">
                        {{ task.status }}
                      </span>
                    </div>
                    <p class="mt-3 text-sm leading-6 text-slate-300">{{ task.reason || 'No additional reason recorded.' }}</p>
                  </article>
                </section>
              </div>
            </div>
          </div>
        </aside>
      </Transition>
    </Teleport>
  </section>
</template>
