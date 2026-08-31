<script setup lang="ts">
type RetainerRow = {
  id: string
  key: string
  clientKey?: string | null
  clientName?: string | null
  clientBusinessName?: string | null
  title: string
  type: string
  status: string
  billingCadence: string
  amountCharged: number
  currency: string
  nextBillingDate?: string | null
  lastBilledDate?: string | null
  invoiceCount: number
  amountCollectedToDate: number
  hostingProviderName?: string | null
  providerAccountName?: string | null
  coveredAssets?: string | null
  costToMe: number
  costCadence?: string | null
  monthlyRevenue: number
  monthlyCost: number
  monthlyProfit: number
  marginPercent?: number | null
  overdue: boolean
  upcoming: boolean
  reviewNeeded: boolean
  recommendedAction?: string | null
  risksIssues?: string | null
  nextAction?: string | null
  includedServices?: string | null
  excludedServices?: string | null
  supportLevel?: string | null
}

type RetainerDashboard = {
  retainers: RetainerRow[]
  summary: {
    clientCount: number
    providerCount: number
    activeRetainerCount: number
    hostingRetainerCount: number
    overdueCount: number
    upcomingBillingCount: number
    reviewNeededCount: number
    monthlyRevenue: number
    monthlyCost: number
    monthlyProfit: number
  }
}

const api = useRavenRetainersApi()
const route = useRoute()
const activeView = ref('active')
const selectedRetainerKey = ref('')

useHead({
  title: 'Retainers - Raven',
})

const { data, pending, error, refresh } = await useAsyncData<RetainerDashboard>(
  'raven-retainers-dashboard',
  async () => await api.getDashboard(),
  {
    server: false,
    default: () => ({
      retainers: [],
      summary: {
        clientCount: 0,
        providerCount: 0,
        activeRetainerCount: 0,
        hostingRetainerCount: 0,
        overdueCount: 0,
        upcomingBillingCount: 0,
        reviewNeededCount: 0,
        monthlyRevenue: 0,
        monthlyCost: 0,
        monthlyProfit: 0,
      },
    }),
  },
)

const views = [
  { key: 'active', label: 'Active' },
  { key: 'hosting', label: 'Hosting' },
  { key: 'upcoming', label: 'Upcoming billing' },
  { key: 'overdue', label: 'Overdue' },
  { key: 'profitability', label: 'Profitability' },
  { key: 'review', label: 'Review needed' },
]

const clientFilterKey = computed(() => {
  const value = route.query.client
  return Array.isArray(value) ? value[0] || '' : value || ''
})

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
  if (!value) return 'Not set'
  return new Intl.DateTimeFormat('en-ZA', {
    day: '2-digit',
    month: 'short',
    year: 'numeric',
  }).format(new Date(`${String(value).slice(0, 10)}T00:00:00Z`))
}

const labelize = (value: string | null | undefined) =>
  String(value || 'none')
    .split(/[_-]+/)
    .filter(Boolean)
    .map(part => part.charAt(0).toUpperCase() + part.slice(1))
    .join(' ')

const filteredRetainers = computed(() => {
  let rows = [...(data.value?.retainers || [])]
  if (clientFilterKey.value) {
    rows = rows.filter(row => row.clientKey === clientFilterKey.value)
  }

  if (activeView.value === 'hosting') {
    return rows.filter(row => ['hosting', 'email_hosting', 'mixed'].includes(row.type))
  }
  if (activeView.value === 'upcoming') {
    return rows.filter(row => row.upcoming)
  }
  if (activeView.value === 'overdue') {
    return rows.filter(row => row.overdue)
  }
  if (activeView.value === 'profitability') {
    return rows.sort((a, b) => a.monthlyProfit - b.monthlyProfit)
  }
  if (activeView.value === 'review') {
    return rows.filter(row => row.reviewNeeded)
  }
  return rows.filter(row => row.status === 'active' || row.status === 'overdue')
})

const selectedRetainer = computed(() => {
  const rows = data.value?.retainers || []
  return rows.find(row => row.key === selectedRetainerKey.value) || filteredRetainers.value[0] || null
})

watch(filteredRetainers, (rows) => {
  if (!rows.some(row => row.key === selectedRetainerKey.value)) {
    selectedRetainerKey.value = rows[0]?.key || ''
  }
}, { immediate: true })

const profitTone = (value: number) => {
  if (value < 0) return 'text-rose-200'
  if (value === 0) return 'text-amber-200'
  return 'text-emerald-200'
}
</script>

<template>
  <section class="space-y-7 py-6">
    <header class="flex flex-wrap items-end justify-between gap-5">
      <div class="space-y-3">
        <NuxtLink to="/" class="raven-link text-sm">
          ← Raven home
        </NuxtLink>
        <div>
          <p class="text-xs uppercase tracking-[0.34em] text-slate-400">Retainer Management</p>
          <h1 class="mt-2 text-4xl font-semibold tracking-[-0.05em] text-white sm:text-5xl">
            Hosting and support retainers.
          </h1>
          <p class="mt-3 max-w-3xl text-sm leading-6 text-slate-300 sm:text-base">
            Track active clients, billing expectations, provider costs, and review actions from Raven's schema-backed retainer register.
          </p>
        </div>
      </div>

      <div class="flex flex-wrap gap-3">
        <NuxtLink
          to="/clients"
          class="rounded-full border border-cyan-300/25 bg-cyan-400/10 px-4 py-2 text-sm font-medium text-cyan-50 transition hover:border-cyan-200/40 hover:bg-cyan-300/18"
        >
          Clients
        </NuxtLink>
        <button
          class="rounded-full border border-cyan-300/30 bg-cyan-400/12 px-4 py-2 text-sm font-medium text-cyan-50 transition hover:border-cyan-200/40 hover:bg-cyan-300/18"
          type="button"
          @click="refresh()"
        >
          Refresh
        </button>
      </div>
    </header>

    <section v-if="error" class="raven-card p-6">
      <p class="text-sm font-medium text-rose-200">The retainer dashboard could not load.</p>
      <p class="mt-2 text-sm leading-6 text-slate-300">{{ error.message }}</p>
    </section>

    <template v-else>
      <section class="grid gap-3 md:grid-cols-3 xl:grid-cols-6">
        <article class="raven-card p-4">
          <p class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Active</p>
          <p class="mt-3 text-2xl font-semibold text-white">{{ formatCount(data?.summary.activeRetainerCount) }}</p>
        </article>
        <article class="raven-card p-4">
          <p class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Hosting</p>
          <p class="mt-3 text-2xl font-semibold text-white">{{ formatCount(data?.summary.hostingRetainerCount) }}</p>
        </article>
        <article class="raven-card p-4">
          <p class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Revenue / month</p>
          <p class="mt-3 text-2xl font-semibold text-white">{{ formatMoney(data?.summary.monthlyRevenue) }}</p>
        </article>
        <article class="raven-card p-4">
          <p class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Cost / month</p>
          <p class="mt-3 text-2xl font-semibold text-white">{{ formatMoney(data?.summary.monthlyCost) }}</p>
        </article>
        <article class="raven-card p-4">
          <p class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Profit / month</p>
          <p class="mt-3 text-2xl font-semibold" :class="profitTone(data?.summary.monthlyProfit || 0)">
            {{ formatMoney(data?.summary.monthlyProfit) }}
          </p>
        </article>
        <article class="raven-card p-4">
          <p class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Review</p>
          <p class="mt-3 text-2xl font-semibold text-amber-100">{{ formatCount(data?.summary.reviewNeededCount) }}</p>
        </article>
      </section>

      <nav class="flex gap-2 overflow-x-auto pb-1">
        <button
          v-for="view in views"
          :key="view.key"
          class="shrink-0 rounded-full border px-4 py-2 text-sm font-medium transition"
          :class="activeView === view.key ? 'border-cyan-300/40 bg-cyan-400/15 text-cyan-50' : 'border-white/10 bg-white/5 text-slate-300 hover:border-white/20 hover:bg-white/8'"
          type="button"
          @click="activeView = view.key"
        >
          {{ view.label }}
        </button>
      </nav>

      <div v-if="clientFilterKey" class="flex flex-wrap items-center justify-between gap-3 rounded-2xl border border-cyan-300/15 bg-cyan-400/8 px-4 py-3">
        <p class="text-sm text-cyan-50">Showing retainers for one selected client.</p>
        <NuxtLink to="/retainers" class="text-sm font-semibold text-cyan-100 hover:text-white">
          Clear filter
        </NuxtLink>
      </div>

      <section class="grid gap-5 xl:grid-cols-[1fr_24rem]">
        <div class="raven-card overflow-hidden">
          <div class="border-b border-white/8 px-5 py-4">
            <p class="text-sm font-medium text-white">{{ formatCount(filteredRetainers.length) }} retainers in view</p>
          </div>

          <div v-if="pending" class="space-y-3 p-5">
            <div v-for="index in 6" :key="index" class="h-12 animate-pulse rounded-2xl bg-white/6" />
          </div>

          <div v-else-if="!filteredRetainers.length" class="p-6">
            <p class="text-lg font-medium text-white">No retainers exist in this view yet.</p>
            <p class="mt-2 text-sm leading-6 text-slate-300">
              The schema is ready. Add client, provider, and retainer records through the generated APIs or the next create/edit UI pass.
            </p>
          </div>

          <div v-else class="overflow-x-auto">
            <table class="min-w-full text-left text-sm">
              <thead class="border-b border-white/8 text-[11px] uppercase tracking-[0.22em] text-slate-400">
                <tr>
                  <th class="px-4 py-3 font-medium">Client</th>
                  <th class="px-4 py-3 font-medium">Retainer</th>
                  <th class="px-4 py-3 font-medium">Provider</th>
                  <th class="px-4 py-3 text-right font-medium">Charged</th>
                  <th class="px-4 py-3 text-right font-medium">Cost</th>
                  <th class="px-4 py-3 text-right font-medium">Profit</th>
                  <th class="px-4 py-3 font-medium">Next billing</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-white/7">
                <tr
                  v-for="retainer in filteredRetainers"
                  :key="retainer.id"
                  class="cursor-pointer transition hover:bg-white/[0.04]"
                  :class="selectedRetainer?.key === retainer.key ? 'bg-cyan-400/[0.07]' : ''"
                  @click="selectedRetainerKey = retainer.key"
                >
                  <td class="px-4 py-3 align-top">
                    <NuxtLink
                      v-if="retainer.clientKey"
                      :to="{ path: '/clients', query: { client: retainer.clientKey } }"
                      class="font-medium text-white hover:text-cyan-100"
                      @click.stop
                    >
                      {{ retainer.clientName || retainer.clientBusinessName || 'Unlinked client' }}
                    </NuxtLink>
                    <div v-else class="font-medium text-white">{{ retainer.clientName || retainer.clientBusinessName || 'Unlinked client' }}</div>
                    <div class="mt-1 text-xs text-slate-400">{{ labelize(retainer.status) }}</div>
                  </td>
                  <td class="px-4 py-3 align-top">
                    <div class="font-medium text-white">{{ retainer.title }}</div>
                    <div class="mt-1 text-xs text-slate-400">{{ labelize(retainer.type) }} · {{ labelize(retainer.billingCadence) }}</div>
                  </td>
                  <td class="px-4 py-3 align-top text-slate-300">
                    {{ retainer.hostingProviderName || retainer.providerAccountName || 'Not set' }}
                  </td>
                  <td class="px-4 py-3 align-top text-right text-white">{{ formatMoney(retainer.monthlyRevenue, retainer.currency) }}</td>
                  <td class="px-4 py-3 align-top text-right text-white">{{ formatMoney(retainer.monthlyCost, retainer.currency) }}</td>
                  <td class="px-4 py-3 align-top text-right font-medium" :class="profitTone(retainer.monthlyProfit)">
                    {{ formatMoney(retainer.monthlyProfit, retainer.currency) }}
                  </td>
                  <td class="px-4 py-3 align-top">
                    <span :class="retainer.overdue ? 'text-rose-200' : retainer.upcoming ? 'text-amber-200' : 'text-slate-300'">
                      {{ formatDate(retainer.nextBillingDate) }}
                    </span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <aside class="raven-card p-5">
          <template v-if="selectedRetainer">
            <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Selected retainer</p>
            <h2 class="mt-2 text-xl font-semibold text-white">{{ selectedRetainer.title }}</h2>
            <NuxtLink
              v-if="selectedRetainer.clientKey"
              :to="{ path: '/clients', query: { client: selectedRetainer.clientKey } }"
              class="mt-2 inline-flex text-sm font-medium text-cyan-100 hover:text-white"
            >
              {{ selectedRetainer.clientName || selectedRetainer.clientBusinessName || 'Unlinked client' }}
            </NuxtLink>
            <p v-else class="mt-2 text-sm text-slate-300">{{ selectedRetainer.clientName || 'Unlinked client' }}</p>

            <dl class="mt-5 grid gap-3 text-sm">
              <div class="rounded-2xl border border-white/8 bg-slate-950/35 p-3">
                <dt class="text-slate-400">Monthly profit</dt>
                <dd class="mt-1 font-medium" :class="profitTone(selectedRetainer.monthlyProfit)">
                  {{ formatMoney(selectedRetainer.monthlyProfit, selectedRetainer.currency) }}
                  <span v-if="selectedRetainer.marginPercent !== null" class="text-slate-400">· {{ selectedRetainer.marginPercent }}%</span>
                </dd>
              </div>
              <div class="rounded-2xl border border-white/8 bg-slate-950/35 p-3">
                <dt class="text-slate-400">Billing</dt>
                <dd class="mt-1 text-white">{{ labelize(selectedRetainer.billingCadence) }} · next {{ formatDate(selectedRetainer.nextBillingDate) }}</dd>
              </div>
              <div class="rounded-2xl border border-white/8 bg-slate-950/35 p-3">
                <dt class="text-slate-400">Invoices sent</dt>
                <dd class="mt-1 text-white">{{ formatCount(selectedRetainer.invoiceCount) }}</dd>
              </div>
            </dl>

            <div class="mt-5 space-y-4 text-sm leading-6">
              <section>
                <h3 class="font-medium text-white">Included</h3>
                <p class="mt-1 text-slate-300">{{ selectedRetainer.includedServices || 'Not captured yet.' }}</p>
              </section>
              <section>
                <h3 class="font-medium text-white">Excluded</h3>
                <p class="mt-1 text-slate-300">{{ selectedRetainer.excludedServices || 'Not captured yet.' }}</p>
              </section>
              <section>
                <h3 class="font-medium text-white">Covered assets</h3>
                <p class="mt-1 text-slate-300">{{ selectedRetainer.coveredAssets || 'Not captured yet.' }}</p>
              </section>
              <section>
                <h3 class="font-medium text-white">Next action</h3>
                <p class="mt-1 text-slate-300">{{ selectedRetainer.nextAction || labelize(selectedRetainer.recommendedAction) }}</p>
              </section>
            </div>
          </template>

          <p v-else class="text-sm leading-6 text-slate-300">
            Select a retainer to inspect terms, covered assets, billing status, and review actions.
          </p>
        </aside>
      </section>
    </template>
  </section>
</template>
