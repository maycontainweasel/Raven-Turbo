<script setup lang="ts">
import type { ClientDirectoryRow, ClientLedgerDetail, RetainerDashboard } from '~/composables/useClientControlApi'

const route = useRoute()
const api = useClientControlApi()
const clientKey = computed(() => String(route.params.clientKey ?? ''))
const hydrated = ref(false)

onMounted(() => {
  hydrated.value = true
})

const {
  data,
  pending,
  error,
  refresh,
} = await useAsyncData<{ clients: ClientDirectoryRow[]; dashboard: RetainerDashboard; ledger: ClientLedgerDetail }>(
  `client-live-${clientKey.value}`,
  async () => {
    const [clients, dashboard, ledger] = await Promise.all([
      api.listClients(),
      api.getRetainerDashboard(),
      api.getClientDetail(clientKey.value),
    ])
    return { clients, dashboard, ledger }
  },
  { server: false },
)

const client = computed(() => data.value?.clients.find(item => item.key === clientKey.value) ?? null)
const retainers = computed(() => data.value?.dashboard.retainers.filter(item => item.clientKey === clientKey.value) ?? [])
const activeRetainers = computed(() => retainers.value.filter(item => item.status === 'active' || item.status === 'overdue'))
const monthlyRevenue = computed(() => activeRetainers.value.reduce((sum, item) => sum + item.monthlyRevenue, 0))
const monthlyCost = computed(() => activeRetainers.value.reduce((sum, item) => sum + item.monthlyCost, 0))
const monthlyProfit = computed(() => activeRetainers.value.reduce((sum, item) => sum + item.monthlyProfit, 0))
const ledger = computed(() => data.value?.ledger ?? { client: null, totals: [], transactions: [] })

useHead({ title: computed(() => `${client.value?.name ?? 'Client'} · Raven`) })

function money(value: number, currency = 'ZAR') {
  return new Intl.NumberFormat('en-ZA', {
    style: 'currency',
    currency,
    maximumFractionDigits: 2,
  }).format(value)
}

function dateLabel(value: string | null | undefined) {
  if (!value) return 'Not recorded'
  const date = new Date(`${value.slice(0, 10)}T00:00:00Z`)
  if (Number.isNaN(date.getTime())) return value
  return new Intl.DateTimeFormat('en-ZA', { dateStyle: 'medium', timeZone: 'UTC' }).format(date)
}

function transactionIsInflow(transaction: ClientLedgerDetail['transactions'][number]) {
  return transaction.flowDirection === 'inflow' || (!transaction.flowDirection && transaction.direction === 'credit')
}
</script>

<template>
  <div v-if="hydrated && pending" class="client-state raven-surface">Loading persisted client record…</div>

  <div v-else-if="error" class="client-state client-state--error raven-surface">
    <h1>Client unavailable</h1>
    <p>The database-backed client record could not be loaded.</p>
    <button class="raven-button" type="button" @click="refresh">Retry</button>
  </div>

  <div v-else-if="client" class="client-page">
    <nav class="client-breadcrumb" aria-label="Client context">
      <NuxtLink to="/clients">Clients</NuxtLink><span>/</span><strong>{{ client.name }}</strong>
    </nav>

    <header class="client-header">
      <div>
        <p class="raven-eyebrow">Persisted client record</p>
        <h1>{{ client.name }}</h1>
        <p>{{ client.businessName || client.websiteDomain || client.key }}</p>
      </div>
      <span class="raven-chip raven-chip--accent">{{ client.status }}</span>
    </header>

    <section class="client-metrics" aria-label="Persisted retainer summary">
      <article><span>Active retainers</span><strong>{{ activeRetainers.length }}</strong><small>{{ retainers.length }} total agreements</small></article>
      <article><span>Monthly revenue</span><strong>{{ money(monthlyRevenue) }}</strong><small>Active agreement records</small></article>
      <article><span>Monthly cost</span><strong>{{ money(monthlyCost) }}</strong><small>Recorded provider cost</small></article>
      <article><span>Monthly margin</span><strong>{{ money(monthlyProfit) }}</strong><small>Revenue less recorded cost</small></article>
    </section>

    <section class="client-grid">
      <article class="client-panel raven-surface">
        <header><h2>Client record</h2><p>Fields stored in Raven’s client table.</p></header>
        <dl>
          <div><dt>Contact</dt><dd>{{ client.contactPerson || 'Not recorded' }}</dd></div>
          <div><dt>Email</dt><dd>{{ client.email || 'Not recorded' }}</dd></div>
          <div><dt>Phone / WhatsApp</dt><dd>{{ client.phoneWhatsapp || 'Not recorded' }}</dd></div>
          <div><dt>Website</dt><dd>{{ client.websiteDomain || 'Not recorded' }}</dd></div>
          <div><dt>Related projects</dt><dd>{{ client.relatedProjects || 'Not recorded' }}</dd></div>
          <div><dt>Notes</dt><dd>{{ client.notes || 'No persisted notes' }}</dd></div>
        </dl>
      </article>

      <article class="client-panel raven-surface">
        <header><h2>Retainers</h2><p>Persisted recurring agreements for this client.</p></header>
        <div v-if="!retainers.length" class="raven-empty"><p>No retainer records are linked to this client.</p></div>
        <div v-else class="retainer-list">
          <div v-for="retainer in retainers" :key="retainer.id" class="retainer-row">
            <span>
              <strong>{{ retainer.title }}</strong>
              <small>{{ retainer.type }} · {{ retainer.billingCadence }} · next {{ dateLabel(retainer.nextBillingDate) }}</small>
            </span>
            <span>
              <strong>{{ money(retainer.amountCharged, retainer.currency) }}</strong>
              <small>{{ retainer.status }}<template v-if="retainer.reviewNeeded"> · review needed</template></small>
            </span>
          </div>
        </div>
      </article>
    </section>

    <section class="client-ledger raven-surface">
      <header>
        <div><h2>Client transaction ledger</h2><p>Income or expenditure explicitly linked to this client during transaction review.</p></div>
        <span>{{ ledger.transactions.length }} transactions</span>
      </header>
      <div v-if="ledger.totals.length" class="ledger-totals">
        <template v-for="total in ledger.totals" :key="total.currency">
          <article><span>Received</span><strong>{{ money(total.inflow, total.currency) }}</strong><small>Average {{ money(total.averageMonthlyInflow, total.currency) }} per active month</small></article>
          <article><span>Paid out</span><strong>{{ money(total.outflow, total.currency) }}</strong><small>Net {{ money(total.net, total.currency) }}</small></article>
        </template>
      </div>
      <div v-if="!ledger.transactions.length" class="raven-empty"><p>No transactions have been linked to this client. Open a transaction in Activity and add the client under Reviewed meaning.</p></div>
      <div v-else class="client-ledger__table"><table><thead><tr><th>Date</th><th>Statement description</th><th>Reviewed meaning</th><th>Merchant</th><th>Account</th><th>Amount</th></tr></thead><tbody>
        <tr v-for="transaction in ledger.transactions" :key="transaction.assignmentId">
          <td>{{ dateLabel(transaction.postedAt) }}</td>
          <td><strong>{{ transaction.description }}</strong><small>{{ transaction.transactionKey }}</small></td>
          <td><strong>{{ transaction.purposeName }}</strong><small>{{ transaction.occurrenceLabel || transaction.categoryName || 'No occurrence detail' }}</small><span v-if="transaction.tags?.length" class="ledger-tags"><span v-for="tag in transaction.tags" :key="tag" class="raven-chip">{{ tag }}</span></span></td>
          <td>{{ transaction.merchantName || 'Not linked' }}</td>
          <td>{{ transaction.accountName || transaction.accountKey || 'Unknown' }}</td>
          <td :class="transactionIsInflow(transaction) ? 'ledger-amount--in' : ''">{{ money(Math.abs(transaction.amount), transaction.currency) }}</td>
        </tr>
      </tbody></table></div>
    </section>
  </div>

  <div v-else class="client-state raven-surface">
    <h1>Client not found</h1>
    <p>No persisted client uses the key “{{ clientKey }}”.</p>
    <NuxtLink class="raven-button" to="/clients">Return to clients</NuxtLink>
  </div>
</template>

<style scoped>
.client-page { display: grid; gap: 26px; }
.client-breadcrumb { display: flex; align-items: center; gap: 8px; color: var(--raven-muted); font-size: 11px; }
.client-breadcrumb a { color: inherit; }
.client-header { display: flex; align-items: flex-start; justify-content: space-between; gap: 24px; }
.client-header h1 { margin: 6px 0 0; font-size: clamp(30px, 4vw, 42px); }
.client-header p:last-child { margin: 8px 0 0; color: var(--raven-muted); }
.client-metrics { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; }
.client-metrics article { display: grid; gap: 7px; border: 1px solid var(--raven-border); border-radius: var(--raven-radius-md); padding: 16px 18px; background: var(--raven-panel); }
.client-metrics span, .client-metrics small { color: var(--raven-muted); font-size: 11px; }
.client-metrics strong { font-size: 19px; }
.client-grid { display: grid; grid-template-columns: minmax(280px, .75fr) minmax(0, 1.25fr); gap: 14px; }
.client-panel { padding: 18px; }
.client-panel header h2 { margin: 0; font-size: 18px; }
.client-panel header p { margin: 5px 0 16px; color: var(--raven-muted); font-size: 12px; }
.client-panel dl { display: grid; gap: 12px; margin: 0; }
.client-panel dl div { display: grid; gap: 4px; border-top: 1px solid var(--raven-border); padding-top: 10px; }
.client-panel dt, .retainer-row small { color: var(--raven-muted); font-size: 11px; }
.client-panel dd { margin: 0; white-space: pre-wrap; }
.retainer-list { display: grid; }
.retainer-row { display: flex; justify-content: space-between; gap: 18px; border-top: 1px solid var(--raven-border); padding: 12px 0; }
.retainer-row > span { display: grid; gap: 4px; }
.retainer-row > span:last-child { flex: 0 0 auto; text-align: right; }
.client-state { max-width: 620px; margin: 40px auto; padding: 24px; }
.client-state--error { border-color: color-mix(in srgb, var(--raven-danger) 42%, transparent); }
.client-ledger { overflow: hidden; }
.client-ledger > header { display: flex; justify-content: space-between; gap: 20px; padding: 18px; }
.client-ledger h2 { margin: 0; font-size: 18px; }
.client-ledger header p, .client-ledger header > span { margin: 5px 0 0; color: var(--raven-muted); font-size: 11px; }
.ledger-totals { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 10px; border-top: 1px solid var(--raven-border); padding: 14px 18px; }
.ledger-totals article { display: grid; gap: 4px; border-left: 2px solid var(--raven-border); padding-left: 10px; }
.ledger-totals span, .ledger-totals small { color: var(--raven-muted); font-size: 10px; }
.client-ledger__table { overflow-x: auto; }
.client-ledger table { width: 100%; min-width: 1020px; border-collapse: collapse; }
.client-ledger th, .client-ledger td { border-top: 1px solid var(--raven-border); padding: 12px 14px; text-align: left; vertical-align: top; }
.client-ledger th { color: var(--raven-muted); font-size: 10px; text-transform: uppercase; }
.client-ledger td { font-size: 12px; }
.client-ledger td > strong, .client-ledger td > small { display: block; }
.client-ledger td small { margin-top: 3px; color: var(--raven-muted); }
.client-ledger td:last-child { text-align: right; font-weight: 700; }
.ledger-tags { display: flex; flex-wrap: wrap; gap: 4px; margin-top: 6px; }.ledger-tags .raven-chip { font-size: 9px; }
.ledger-amount--in { color: var(--raven-success); }
@media (max-width: 880px) { .client-metrics { grid-template-columns: repeat(2, minmax(0, 1fr)); } .client-grid { grid-template-columns: 1fr; } }
@media (max-width: 560px) { .client-header { flex-direction: column; } .client-metrics { grid-template-columns: 1fr; } }
</style>
