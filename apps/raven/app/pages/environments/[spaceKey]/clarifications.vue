<script setup lang="ts">
type SpaceRow = {
  id: string
  key: string
  name: string
  spaceType: string
  currency: string
}

type AccountRow = {
  id: string
  key: string
  name: string
  bankName: string
  accountType: string
  currency: string
  accountNumberLast4?: string | null
}

type ClarificationQueueTask = {
  id: string
  key: string
  status: string
  question: string
  reason?: string | null
  confidence?: number | null
  resolutionNotes?: string | null
  transactionId: string
  postedAt: string
  amount: number
  direction: 'credit' | 'debit' | 'transfer'
  description: string
  normalizedDescription?: string | null
  transactionNotes?: string | null
  accountId?: string | null
  accountKey?: string | null
  accountName?: string | null
  accountBankName?: string | null
  accountType?: string | null
  categoryId?: string | null
  categoryKey?: string | null
  categoryName?: string | null
  merchantId?: string | null
  merchantKey?: string | null
  merchantName?: string | null
  sourceRowId?: string | null
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
}

type QueueData = {
  space: SpaceRow | null
  summary: {
    total: number
    open: number
    resolved: number
    accountCount: number
    merchantCount: number
  }
  accounts: AccountRow[]
  tasks: ClarificationQueueTask[]
}

type TransactionDetail = {
  transaction: {
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
  } | null
  clarificationTasks: Array<{
    id: string
    key: string
    status: string
    question: string
    reason?: string | null
    confidence?: number | null
    resolutionNotes?: string | null
  }>
}

const route = useRoute()
const router = useRouter()
const explorerApi = useRavenExplorerApi()

const routeString = (value: unknown) => {
  if (Array.isArray(value)) return typeof value[0] === 'string' ? value[0] : ''
  return typeof value === 'string' ? value : ''
}

const routeStatus = (value: unknown) => {
  const status = routeString(value)
  if (status === 'resolved' || status === 'all') return status
  return 'open'
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

const formatDate = (value: string | null | undefined) => {
  if (!value) return 'Unknown'
  return new Intl.DateTimeFormat('en-ZA', {
    day: '2-digit',
    month: 'short',
    year: 'numeric',
  }).format(new Date(value))
}

const formatAccountType = (value: string | null | undefined) =>
  String(value || 'other')
    .split(/[_-]+/)
    .filter(Boolean)
    .map(part => part.charAt(0).toUpperCase() + part.slice(1))
    .join(' ')

const directionLabel = (value: 'credit' | 'debit' | 'transfer') => {
  if (value === 'credit') return 'Inflow'
  if (value === 'transfer') return 'Transfer'
  return 'Outflow'
}

const directionTone = (value: 'credit' | 'debit' | 'transfer') => {
  if (value === 'credit') return 'border-emerald-300/30 bg-emerald-400/10 text-emerald-100'
  if (value === 'transfer') return 'border-amber-300/30 bg-amber-400/10 text-amber-100'
  return 'border-rose-300/30 bg-rose-400/10 text-rose-100'
}

const statusTone = (value: string | null | undefined) => {
  if (value === 'resolved') return 'border-emerald-300/30 bg-emerald-400/10 text-emerald-100'
  return 'border-amber-300/30 bg-amber-400/10 text-amber-100'
}

const spaceKey = computed(() => routeString(route.params.spaceKey))
const selectedAccountKey = computed(() => routeString(route.query.account))
const selectedStatus = computed<'open' | 'resolved' | 'all'>(() => routeStatus(route.query.status))
const selectedTransactionId = computed(() => routeString(route.query.tx))

useHead(() => ({
  title: `Raven · ${spaceKey.value || 'Environment'} clarifications`,
}))

const { data: queueData, pending: queuePending, error: queueError, refresh: refreshQueue } = await useAsyncData<QueueData | null>(
  () => `raven-clarifications:${spaceKey.value}:${selectedAccountKey.value || 'all'}:${selectedStatus.value}`,
  async () => {
    if (!spaceKey.value) return null
    return await explorerApi.getClarificationQueue(
      spaceKey.value,
      selectedAccountKey.value || undefined,
      selectedStatus.value,
    )
  },
  {
    server: false,
    watch: [spaceKey, selectedAccountKey, selectedStatus],
  },
)

const { data: transactionPanelData, pending: transactionPending, error: transactionError } = await useAsyncData<TransactionDetail | null>(
  () => `raven-clarification-transaction:${selectedTransactionId.value || 'none'}`,
  async () => {
    if (!selectedTransactionId.value) return null
    return await explorerApi.getTransactionDetail(selectedTransactionId.value)
  },
  {
    server: false,
    watch: [selectedTransactionId],
  },
)

const activeAccount = computed(() =>
  (queueData.value?.accounts || []).find(account => account.key === selectedAccountKey.value) || null,
)

const filteredTasks = computed(() => queueData.value?.tasks || [])

const groupedTaskCounts = computed(() => {
  const groups = new Map<string, { key: string; label: string; count: number }>()

  for (const task of filteredTasks.value) {
    const key = task.accountKey || 'unknown'
    const label = task.accountName || 'Unknown account'
    const current = groups.get(key)
    if (current) current.count += 1
    else groups.set(key, { key, label, count: 1 })
  }

  return Array.from(groups.values()).sort((left, right) => right.count - left.count)
})

const toggleQuery = async (patch: Record<string, string | undefined>) => {
  await router.replace({
    query: {
      ...route.query,
      ...patch,
    },
  })
}

const setAccount = async (accountKey?: string) => {
  await toggleQuery({
    account: accountKey || undefined,
    tx: undefined,
  })
}

const setStatus = async (status: 'open' | 'resolved' | 'all') => {
  await toggleQuery({
    status: status === 'open' ? undefined : status,
    tx: undefined,
  })
}

const openTransaction = async (transactionId: string) => {
  await toggleQuery({ tx: transactionId })
}

const closeTransaction = async () => {
  await toggleQuery({ tx: undefined })
}
</script>

<template>
  <section class="space-y-8 py-6">
    <header class="space-y-6">
      <div class="flex flex-wrap items-center justify-between gap-3">
        <div class="space-y-3">
          <NuxtLink
            :to="`/environments/${spaceKey}`"
            class="inline-flex items-center gap-2 text-sm text-slate-300 transition hover:text-white"
          >
            <span aria-hidden="true">←</span>
            Back to environment
          </NuxtLink>

          <div class="flex flex-wrap items-center gap-2">
            <span class="rounded-full border border-amber-300/20 bg-amber-400/10 px-3 py-1 text-[11px] uppercase tracking-[0.3em] text-amber-100/80">
              Clarification queue
            </span>
            <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-[11px] uppercase tracking-[0.24em] text-slate-300">
              Review surface
            </span>
          </div>

          <div>
            <p class="text-xs uppercase tracking-[0.34em] text-slate-400">
              {{ queueData?.space ? formatAccountType(queueData.space.spaceType) : 'Environment' }}
            </p>
            <h1 class="mt-2 text-4xl font-semibold tracking-[-0.06em] text-white sm:text-5xl">
              {{ queueData?.space?.name || 'Clarifications' }}
            </h1>
            <p class="mt-3 max-w-3xl text-base leading-7 text-slate-300">
              Review rows whose meaning is not trusted yet. Keep the raw statement truth intact, then refine merchant, category, notes, and future rules from this queue.
            </p>
          </div>
        </div>

        <button class="raven-link raven-link--ghost" type="button" @click="refreshQueue()">
          Refresh
        </button>
      </div>

      <div class="grid gap-4 lg:grid-cols-4">
        <article class="raven-card p-5">
          <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Open tasks</p>
          <p class="mt-3 text-2xl font-semibold text-white">{{ formatCount(queueData?.summary.open) }}</p>
          <p class="mt-2 text-sm text-slate-300">Items still needing meaning.</p>
        </article>

        <article class="raven-card p-5">
          <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Accounts in queue</p>
          <p class="mt-3 text-2xl font-semibold text-white">{{ formatCount(queueData?.summary.accountCount) }}</p>
          <p class="mt-2 text-sm text-slate-300">Accounts represented in the current filter.</p>
        </article>

        <article class="raven-card p-5">
          <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Known merchants</p>
          <p class="mt-3 text-2xl font-semibold text-white">{{ formatCount(queueData?.summary.merchantCount) }}</p>
          <p class="mt-2 text-sm text-slate-300">Distinct merchant profiles attached so far.</p>
        </article>

        <article class="raven-card p-5">
          <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Current filter</p>
          <p class="mt-3 text-xl font-semibold text-white">
            {{ activeAccount?.name || 'All accounts' }}
          </p>
          <p class="mt-2 text-sm text-slate-300">
            {{ selectedStatus === 'all' ? 'Open and resolved tasks' : selectedStatus === 'resolved' ? 'Resolved only' : 'Open only' }}
          </p>
        </article>
      </div>
    </header>

    <section class="grid gap-6 xl:grid-cols-[0.8fr_1.2fr_0.9fr]">
      <aside class="space-y-4">
        <article class="raven-card space-y-4 p-5">
          <div>
            <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Status</p>
            <h2 class="mt-2 text-lg font-semibold text-white">Queue scope</h2>
          </div>

          <div class="flex flex-wrap gap-2">
            <button
              type="button"
              class="rounded-full border px-3 py-2 text-xs uppercase tracking-[0.22em] transition"
              :class="selectedStatus === 'open' ? 'border-cyan-300/30 bg-cyan-400/10 text-cyan-100' : 'border-white/10 bg-white/5 text-slate-300 hover:text-white'"
              @click="setStatus('open')"
            >
              Open
            </button>
            <button
              type="button"
              class="rounded-full border px-3 py-2 text-xs uppercase tracking-[0.22em] transition"
              :class="selectedStatus === 'resolved' ? 'border-cyan-300/30 bg-cyan-400/10 text-cyan-100' : 'border-white/10 bg-white/5 text-slate-300 hover:text-white'"
              @click="setStatus('resolved')"
            >
              Resolved
            </button>
            <button
              type="button"
              class="rounded-full border px-3 py-2 text-xs uppercase tracking-[0.22em] transition"
              :class="selectedStatus === 'all' ? 'border-cyan-300/30 bg-cyan-400/10 text-cyan-100' : 'border-white/10 bg-white/5 text-slate-300 hover:text-white'"
              @click="setStatus('all')"
            >
              All
            </button>
          </div>
        </article>

        <article class="raven-card space-y-4 p-5">
          <div>
            <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Accounts</p>
            <h2 class="mt-2 text-lg font-semibold text-white">Filter by account</h2>
          </div>

          <div class="space-y-2">
            <button
              type="button"
              class="flex w-full items-center justify-between rounded-2xl border px-4 py-3 text-left transition"
              :class="!selectedAccountKey ? 'border-cyan-300/30 bg-cyan-400/10 text-cyan-100' : 'border-white/10 bg-white/5 text-slate-200 hover:text-white'"
              @click="setAccount()"
            >
              <span class="text-sm font-medium">All accounts</span>
              <span class="text-xs uppercase tracking-[0.22em]">{{ formatCount(queueData?.summary.total) }}</span>
            </button>

            <button
              v-for="group in groupedTaskCounts"
              :key="group.key"
              type="button"
              class="flex w-full items-center justify-between rounded-2xl border px-4 py-3 text-left transition"
              :class="selectedAccountKey === group.key ? 'border-cyan-300/30 bg-cyan-400/10 text-cyan-100' : 'border-white/10 bg-white/5 text-slate-200 hover:text-white'"
              @click="setAccount(group.key)"
            >
              <span class="text-sm font-medium">{{ group.label }}</span>
              <span class="text-xs uppercase tracking-[0.22em]">{{ formatCount(group.count) }}</span>
            </button>
          </div>
        </article>
      </aside>

      <section class="space-y-4">
        <section v-if="queueError" class="raven-card space-y-3 p-6">
          <p class="text-sm font-medium text-rose-200">The clarification queue could not load.</p>
          <p class="text-sm leading-6 text-slate-300">{{ queueError.message }}</p>
          <button class="raven-link" type="button" @click="refreshQueue()">
            Retry
          </button>
        </section>

        <section v-else-if="queuePending" class="space-y-4">
          <article v-for="index in 4" :key="index" class="raven-card animate-pulse space-y-4 p-5">
            <div class="h-3 w-24 rounded-full bg-white/8" />
            <div class="h-6 w-2/3 rounded-full bg-white/10" />
            <div class="h-20 rounded-3xl bg-white/5" />
          </article>
        </section>

        <section v-else-if="!filteredTasks.length" class="raven-card space-y-3 p-6">
          <p class="text-sm font-medium text-white">No clarification tasks match this filter.</p>
          <p class="text-sm leading-6 text-slate-300">
            This scope is currently clear. Switch the status or account filter if you want to inspect older resolved work.
          </p>
        </section>

        <section v-else class="space-y-4">
          <article
            v-for="task in filteredTasks"
            :key="task.id"
            class="raven-card cursor-pointer p-5 transition hover:translate-y-[-1px] hover:border-cyan-300/20"
            @click="openTransaction(task.transactionId)"
          >
            <div class="flex flex-wrap items-start justify-between gap-3">
              <div class="space-y-3">
                <div class="flex flex-wrap items-center gap-2">
                  <span class="rounded-full border px-3 py-1 text-[11px] uppercase tracking-[0.24em]" :class="statusTone(task.status)">
                    {{ task.status }}
                  </span>
                  <span class="rounded-full border px-3 py-1 text-[11px] uppercase tracking-[0.24em]" :class="directionTone(task.direction)">
                    {{ directionLabel(task.direction) }}
                  </span>
                  <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-[11px] uppercase tracking-[0.24em] text-slate-300">
                    {{ formatDate(task.postedAt) }}
                  </span>
                </div>

                <div>
                  <h3 class="text-lg font-semibold text-white">{{ task.question }}</h3>
                  <p class="mt-2 text-sm leading-6 text-slate-300">
                    {{ task.reason || 'This row needs review before it can be treated as trusted history.' }}
                  </p>
                </div>
              </div>

              <div class="text-right">
                <p class="text-xs uppercase tracking-[0.24em] text-slate-400">{{ task.accountName || 'Unknown account' }}</p>
                <p class="mt-2 text-lg font-semibold text-white">{{ formatMoney(task.amount, queueData?.space?.currency || 'ZAR') }}</p>
                <p class="mt-2 text-xs uppercase tracking-[0.22em] text-slate-400">
                  {{ task.accountBankName || 'Bank unknown' }}
                </p>
              </div>
            </div>

            <dl class="mt-5 grid gap-3 lg:grid-cols-3">
              <div class="rounded-2xl border border-white/8 bg-slate-950/35 px-4 py-3">
                <dt class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Merchant</dt>
                <dd class="mt-2 text-sm font-medium text-white">{{ task.merchantName || task.rawData?.normalizedMerchant || 'Unassigned' }}</dd>
              </div>

              <div class="rounded-2xl border border-white/8 bg-slate-950/35 px-4 py-3">
                <dt class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Category</dt>
                <dd class="mt-2 text-sm font-medium text-white">{{ task.categoryName || task.rawData?.category || 'Unassigned' }}</dd>
              </div>

              <div class="rounded-2xl border border-white/8 bg-slate-950/35 px-4 py-3">
                <dt class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Raw row</dt>
                <dd class="mt-2 line-clamp-2 text-sm font-medium text-white">{{ task.rawData?.rawRowText || task.description }}</dd>
              </div>
            </dl>

            <div class="mt-5 flex flex-wrap items-center gap-2 text-xs uppercase tracking-[0.22em] text-slate-400">
              <span v-if="task.rawData?.feeType" class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-slate-300">
                {{ task.rawData.feeType }}
              </span>
              <span v-if="task.rawData?.sourceFileName" class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-slate-300">
                {{ task.rawData.sourceFileName }}
              </span>
              <span v-if="task.rowNumber" class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-slate-300">
                Row {{ task.rowNumber }}
              </span>
            </div>
          </article>
        </section>
      </section>

      <aside class="space-y-4">
        <article class="raven-card space-y-4 p-5">
          <div class="flex items-center justify-between gap-3">
            <div>
              <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Transaction detail</p>
              <h2 class="mt-2 text-lg font-semibold text-white">
                {{ transactionPanelData?.transaction?.description || 'Select a task' }}
              </h2>
            </div>
            <button
              v-if="selectedTransactionId"
              class="raven-link raven-link--ghost"
              type="button"
              @click="closeTransaction()"
            >
              Close
            </button>
          </div>

          <section v-if="transactionError" class="rounded-3xl border border-rose-300/20 bg-rose-400/10 p-4">
            <p class="text-sm font-medium text-rose-100">The transaction detail could not load.</p>
            <p class="mt-2 text-sm leading-6 text-rose-50/80">{{ transactionError.message }}</p>
          </section>

          <section v-else-if="transactionPending" class="space-y-3">
            <div class="h-4 w-24 animate-pulse rounded-full bg-white/10" />
            <div class="h-20 animate-pulse rounded-3xl bg-white/5" />
            <div class="h-24 animate-pulse rounded-3xl bg-white/5" />
          </section>

          <section v-else-if="transactionPanelData?.transaction" class="space-y-4">
            <dl class="grid gap-3">
              <div class="rounded-3xl border border-white/8 bg-slate-950/35 px-4 py-4">
                <dt class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Amount</dt>
                <dd class="mt-2 text-lg font-semibold text-white">
                  {{ formatMoney(transactionPanelData.transaction.amount, queueData?.space?.currency || 'ZAR') }}
                </dd>
              </div>

              <div class="rounded-3xl border border-white/8 bg-slate-950/35 px-4 py-4">
                <dt class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Merchant</dt>
                <dd class="mt-2 text-sm font-medium text-white">
                  {{ transactionPanelData.transaction.merchant?.name || transactionPanelData.transaction.merchantName || 'Unassigned' }}
                </dd>
              </div>

              <div class="rounded-3xl border border-white/8 bg-slate-950/35 px-4 py-4">
                <dt class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Category</dt>
                <dd class="mt-2 text-sm font-medium text-white">
                  {{ transactionPanelData.transaction.category?.name || transactionPanelData.transaction.sourceRow?.rawData?.category || 'Unassigned' }}
                </dd>
              </div>

              <div class="rounded-3xl border border-white/8 bg-slate-950/35 px-4 py-4">
                <dt class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Raw statement text</dt>
                <dd class="mt-2 text-sm leading-6 text-slate-200">
                  {{ transactionPanelData.transaction.sourceRow?.rawData?.rawRowText || 'Not available' }}
                </dd>
              </div>

              <div class="rounded-3xl border border-white/8 bg-slate-950/35 px-4 py-4">
                <dt class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Queue tasks</dt>
                <dd class="mt-3 space-y-3">
                  <article
                    v-for="task in transactionPanelData.clarificationTasks"
                    :key="task.id"
                    class="rounded-2xl border border-white/8 bg-white/[0.03] px-4 py-3"
                  >
                    <div class="flex items-center justify-between gap-3">
                      <p class="text-sm font-medium text-white">{{ task.question }}</p>
                      <span class="rounded-full border px-3 py-1 text-[11px] uppercase tracking-[0.22em]" :class="statusTone(task.status)">
                        {{ task.status }}
                      </span>
                    </div>
                    <p class="mt-2 text-sm leading-6 text-slate-300">
                      {{ task.reason || 'No reason recorded.' }}
                    </p>
                  </article>

                  <p v-if="!transactionPanelData.clarificationTasks.length" class="text-sm leading-6 text-slate-300">
                    No clarification tasks are attached to this transaction.
                  </p>
                </dd>
              </div>
            </dl>
          </section>

          <section v-else class="rounded-3xl border border-white/8 bg-slate-950/35 px-4 py-4">
            <p class="text-sm leading-6 text-slate-300">
              Choose a task from the queue to inspect its source row and current classification context.
            </p>
          </section>
        </article>
      </aside>
    </section>
  </section>
</template>
