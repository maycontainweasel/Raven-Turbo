<script setup lang="ts">
import {
  formatMoney,
  type AccountSummary,
  type GetCurrentPositionOutput,
  type GetPeriodFinancialSummaryOutput,
  type ListAccountsOutput,
  type ListUpcomingCashflowsOutput,
  type MoneyWire,
} from '@raven/domain'

useHead({ title: 'Today · Raven' })

const accountApi = useAccountControlApi()
const analyticsApi = useFinancialAnalyticsApi()

function johannesburgParts(date = new Date()) {
  return new Intl.DateTimeFormat('en-ZA', {
    timeZone: 'Africa/Johannesburg',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).formatToParts(date).reduce<Record<string, string>>((parts, part) => {
    if (part.type !== 'literal') parts[part.type] = part.value
    return parts
  }, {})
}

function localDate(date = new Date()) {
  const parts = johannesburgParts(date)
  return `${parts.year}-${parts.month}-${parts.day}`
}

const now = new Date()
const today = localDate(now)
const currentMonth = today.slice(0, 7)
const horizonDate = new Date(now)
horizonDate.setDate(horizonDate.getDate() + 45)
const horizon = localDate(horizonDate)
const lastUpdated = ref(now)
const hydrated = ref(false)

onMounted(() => {
  hydrated.value = true
})

const dateLabel = computed(() => new Intl.DateTimeFormat('en-ZA', {
  timeZone: 'Africa/Johannesburg',
  weekday: 'long',
  day: 'numeric',
  month: 'long',
  year: 'numeric',
}).format(lastUpdated.value))

const monthLabel = computed(() => new Intl.DateTimeFormat('en-ZA', {
  timeZone: 'Africa/Johannesburg',
  month: 'long',
  year: 'numeric',
}).format(lastUpdated.value))

const asOf = now.toISOString()

const {
  data: accountsData,
  pending: accountsPending,
  error: accountsError,
  refresh: refreshAccounts,
} = await useAsyncData<ListAccountsOutput>('today-accounts', () => accountApi.listAccounts(), { server: false })

const {
  data: position,
  pending: positionPending,
  error: positionError,
  refresh: refreshPosition,
} = await useAsyncData<GetCurrentPositionOutput>(
  'today-position',
  () => accountApi.getCurrentPosition({ currency: 'ZAR', asOf }),
  { server: false },
)

const {
  data: monthSummary,
  pending: summaryPending,
  error: summaryError,
  refresh: refreshSummary,
} = await useAsyncData<GetPeriodFinancialSummaryOutput>(
  `today-summary-${currentMonth}`,
  () => analyticsApi.getPeriodFinancialSummary({
    month: currentMonth,
    currency: 'ZAR',
    authorityScope: 'active_ledger',
    asOf,
  }),
  { server: false },
)

const {
  data: upcoming,
  pending: upcomingPending,
  error: upcomingError,
  refresh: refreshUpcoming,
} = await useAsyncData<ListUpcomingCashflowsOutput>(
  `today-upcoming-${today}-${horizon}`,
  () => accountApi.listUpcomingCashflows({
    from: today,
    through: horizon,
    includeTerminal: false,
    asOf,
  }),
  { server: false },
)

const loading = computed(() => (
  accountsPending.value || positionPending.value || summaryPending.value || upcomingPending.value
))

const loadErrors = computed(() => [
  accountsError.value && 'accounts',
  positionError.value && 'current position',
  summaryError.value && 'monthly analysis',
  upcomingError.value && 'upcoming cashflow',
].filter(Boolean) as string[])

const accountCount = computed(() => (
  accountsData.value?.spaces.reduce((total, space) => total + space.accounts.length, 0) ?? 0
))

const positionMetrics = computed(() => [
  { label: 'Liquid cash', value: position.value?.liquidCash, detail: 'Known liquid account balances' },
  { label: 'Known assets', value: position.value?.knownAssets, detail: 'Observed asset balances' },
  { label: 'Liabilities', value: position.value?.knownLiabilities, detail: 'Observed liability balances' },
  { label: 'Known net position', value: position.value?.knownNetPosition, detail: 'Assets less liabilities' },
])

const monthMetrics = computed(() => [
  { label: 'Income', value: monthSummary.value?.ordinary.income, count: monthSummary.value?.ordinary.incomeCount },
  { label: 'Outflow', value: monthSummary.value?.ordinary.outflow, count: monthSummary.value?.ordinary.outflowCount },
  { label: 'Net movement', value: monthSummary.value?.ordinary.net, count: null },
])

const upcomingItems = computed(() => upcoming.value?.occurrences.slice(0, 8) ?? [])

function moneyLabel(value: MoneyWire | null | undefined) {
  return value ? formatMoney(value) : 'Unavailable'
}

function accountBalanceLabel(account: AccountSummary) {
  if (!account.selectedBalance) return 'Unknown'
  const amount = formatMoney(account.selectedBalance.money)
  return account.selectedBalance.economicNature === 'liability' ? `${amount} owed` : amount
}

function accountAsOfLabel(account: AccountSummary) {
  const value = account.selectedBalance?.asOf ?? account.freshness.asOf
  if (!value) return 'No balance evidence'
  return `As of ${new Intl.DateTimeFormat('en-ZA', {
    dateStyle: 'medium',
    timeStyle: 'short',
  }).format(new Date(value))}`
}

function occurrenceDate(value: string) {
  return new Intl.DateTimeFormat('en-ZA', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
    timeZone: 'UTC',
  }).format(new Date(`${value}T00:00:00Z`))
}

async function refresh() {
  await Promise.all([refreshAccounts(), refreshPosition(), refreshSummary(), refreshUpcoming()])
  lastUpdated.value = new Date()
}
</script>

<template>
  <div class="today-page">
    <header class="today-header">
      <div>
        <p class="raven-eyebrow">Observed financial truth</p>
        <h1>{{ dateLabel }}</h1>
        <p>Only database-backed balances, ledger movements, and scheduled cashflows appear here.</p>
      </div>
      <button class="raven-button" type="button" :disabled="hydrated && loading" @click="refresh">
        <span class="i-lucide-refresh-cw" aria-hidden="true" />
        Refresh
      </button>
    </header>

    <div v-if="loadErrors.length" class="today-warning" role="alert">
      <span class="i-lucide-triangle-alert" aria-hidden="true" />
      <span>Raven could not load {{ loadErrors.join(', ') }}. Unavailable values remain hidden rather than being replaced with samples.</span>
    </div>

    <section class="today-section">
      <header class="today-section__header">
        <div>
          <p class="raven-eyebrow">Current position</p>
          <h2>Known balances</h2>
        </div>
        <span>{{ accountCount }} tracked account{{ accountCount === 1 ? '' : 's' }}</span>
      </header>

      <div class="today-metrics" aria-label="Known financial position">
        <article v-for="metric in positionMetrics" :key="metric.label" class="raven-surface">
          <span>{{ metric.label }}</span>
          <strong>{{ hydrated && positionPending ? 'Loading…' : moneyLabel(metric.value) }}</strong>
          <small>{{ metric.detail }}</small>
        </article>
      </div>

      <p v-if="position && position.meta.quality !== 'complete'" class="today-quality">
        Position quality is {{ position.meta.quality }}:
        {{ position.missingAccountIds.length }} unknown,
        {{ position.staleAccountIds.length }} stale, and
        {{ position.invalidFutureAccountIds.length }} future-dated balance{{ position.invalidFutureAccountIds.length === 1 ? '' : 's' }} excluded.
      </p>
    </section>

    <section class="today-grid">
      <article class="today-panel raven-surface">
        <header>
          <div>
            <p class="raven-eyebrow">Accounts</p>
            <h2>Balance evidence</h2>
          </div>
          <NuxtLink to="/accounts">Open accounts →</NuxtLink>
        </header>

        <div v-if="hydrated && accountsPending" class="today-loading">Loading accounts…</div>
        <div v-else-if="!accountCount" class="raven-empty">
          <p>No tracked accounts were returned by Raven.</p>
        </div>
        <div v-else class="today-list">
          <template v-for="space in accountsData?.spaces" :key="space.key">
            <NuxtLink
              v-for="account in space.accounts"
              :key="account.id"
              :to="`/accounts/${account.spaceKey}/${account.accountKey}`"
              class="today-row"
            >
              <span>
                <strong>{{ account.name }}</strong>
                <small>{{ space.name }} · {{ accountAsOfLabel(account) }}</small>
              </span>
              <b>{{ accountBalanceLabel(account) }}</b>
            </NuxtLink>
          </template>
        </div>
      </article>

      <article class="today-panel raven-surface">
        <header>
          <div>
            <p class="raven-eyebrow">{{ monthLabel }}</p>
            <h2>Observed movement</h2>
          </div>
          <NuxtLink to="/analysis">Open analysis →</NuxtLink>
        </header>

        <div v-if="hydrated && summaryPending" class="today-loading">Loading monthly analysis…</div>
        <div v-else-if="!monthSummary" class="raven-empty">
          <p>Monthly ledger analysis is unavailable.</p>
        </div>
        <div v-else class="today-month-metrics">
          <div v-for="metric in monthMetrics" :key="metric.label">
            <span>{{ metric.label }}</span>
            <strong>{{ moneyLabel(metric.value) }}</strong>
            <small v-if="metric.count !== null">{{ metric.count }} movement{{ metric.count === 1 ? '' : 's' }}</small>
            <small v-else>Internal transfers excluded</small>
          </div>
        </div>
      </article>
    </section>

    <section class="today-panel raven-surface">
      <header>
        <div>
          <p class="raven-eyebrow">Forward cashflow</p>
          <h2>Upcoming scheduled movements</h2>
        </div>
        <NuxtLink to="/upcoming">Open upcoming →</NuxtLink>
      </header>

      <div v-if="hydrated && upcomingPending" class="today-loading">Loading scheduled cashflow…</div>
      <div v-else-if="!upcomingItems.length" class="raven-empty">
        <p>No scheduled cashflows fall within the next 45 days.</p>
      </div>
      <div v-else class="today-list">
        <div v-for="item in upcomingItems" :key="item.id" class="today-row">
          <span>
            <strong>{{ item.title }}</strong>
            <small>{{ occurrenceDate(item.dueOn) }} · {{ item.certainty }} · {{ item.status }}</small>
          </span>
          <b :class="`today-money--${item.direction}`">
            {{ item.direction === 'outflow' ? '−' : item.direction === 'inflow' ? '+' : '' }}{{ formatMoney(item.money) }}
          </b>
        </div>
      </div>
    </section>

    <footer class="today-footer">
      Last refreshed {{ new Intl.DateTimeFormat('en-ZA', { dateStyle: 'medium', timeStyle: 'short' }).format(lastUpdated) }}.
      Unknown and unavailable values are never represented as zero.
    </footer>
  </div>
</template>

<style scoped>
.today-page { display: grid; gap: 28px; }
.today-header, .today-section__header, .today-panel > header { display: flex; align-items: flex-start; justify-content: space-between; gap: 24px; }
.today-header h1 { margin: 7px 0 0; font-size: clamp(28px, 3vw, 38px); }
.today-header p:last-child, .today-footer, .today-quality, .today-loading { color: var(--raven-muted); }
.today-header p:last-child { margin: 8px 0 0; }
.today-warning, .today-quality { border: 1px solid color-mix(in srgb, var(--raven-warning) 45%, transparent); border-radius: var(--raven-radius-md); padding: 12px 14px; background: var(--raven-warning-soft); color: var(--raven-warning); }
.today-warning { display: flex; align-items: center; gap: 10px; }
.today-section { display: grid; gap: 14px; }
.today-section__header h2, .today-panel h2 { margin: 4px 0 0; font-size: 19px; }
.today-section__header > span, .today-panel header a { color: var(--raven-muted); font-size: 12px; }
.today-metrics { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; }
.today-metrics article { display: grid; gap: 7px; padding: 16px 18px; }
.today-metrics span, .today-metrics small, .today-month-metrics span, .today-month-metrics small, .today-row small { color: var(--raven-muted); font-size: 11px; }
.today-metrics strong { font-size: 19px; }
.today-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px; }
.today-panel { min-width: 0; padding: 18px; }
.today-panel > header { margin-bottom: 17px; }
.today-list { display: grid; }
.today-row { display: flex; align-items: center; justify-content: space-between; gap: 20px; min-width: 0; border-top: 1px solid var(--raven-border); padding: 12px 0; color: var(--raven-text); text-decoration: none; }
.today-row:first-child { border-top: 0; }
.today-row > span { min-width: 0; display: grid; gap: 3px; }
.today-row strong, .today-row small { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.today-row b { flex: 0 0 auto; }
.today-month-metrics { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 10px; }
.today-month-metrics > div { display: grid; gap: 6px; border-left: 1px solid var(--raven-border); padding-left: 13px; }
.today-month-metrics > div:first-child { border-left: 0; padding-left: 0; }
.today-money--inflow { color: var(--raven-accent); }
.today-money--outflow { color: var(--raven-warning); }
.today-footer { font-size: 11px; text-align: right; }
@media (max-width: 960px) { .today-metrics, .today-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
@media (max-width: 640px) {
  .today-header, .today-section__header, .today-panel > header { align-items: stretch; flex-direction: column; }
  .today-metrics, .today-grid, .today-month-metrics { grid-template-columns: 1fr; }
  .today-month-metrics > div { border-top: 1px solid var(--raven-border); border-left: 0; padding: 10px 0 0; }
}
</style>
