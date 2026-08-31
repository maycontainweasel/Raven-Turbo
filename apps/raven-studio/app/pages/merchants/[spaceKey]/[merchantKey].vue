<script setup lang="ts">
import type { MerchantDetail } from '~/composables/useClassificationApi'

const route = useRoute()
const api = useClassificationApi()
const spaceKey = computed(() => String(route.params.spaceKey ?? ''))
const merchantKey = computed(() => String(route.params.merchantKey ?? ''))
const hydrated = ref(false)
onMounted(() => { hydrated.value = true })

const { data, pending, error, refresh } = await useAsyncData<MerchantDetail>(
  `merchant-detail-${spaceKey.value}-${merchantKey.value}`,
  () => api.getMerchant(spaceKey.value, merchantKey.value),
  { server: false },
)

const merchant = computed(() => data.value?.merchant ?? null)
useHead({ title: computed(() => `${merchant.value?.name ?? 'Merchant'} · Raven`) })

const money = (value: number, currency: string) => new Intl.NumberFormat('en-ZA', {
  style: 'currency', currency, maximumFractionDigits: 2,
}).format(value)
const dateLabel = (value: string) => new Intl.DateTimeFormat('en-ZA', {
  dateStyle: 'medium', timeZone: 'UTC',
}).format(new Date(`${value.slice(0, 10)}T00:00:00Z`))
</script>

<template>
  <div v-if="hydrated && pending" class="merchant-state raven-surface">Loading merchant ledger…</div>
  <div v-else-if="error" class="merchant-state merchant-state--error raven-surface"><h1>Merchant unavailable</h1><p>The merchant ledger could not be loaded.</p><button class="raven-button" type="button" @click="refresh">Retry</button></div>
  <div v-else-if="merchant" class="merchant-detail">
    <nav class="merchant-breadcrumb"><NuxtLink to="/merchants">Merchants</NuxtLink><span>/</span><strong>{{ merchant.name }}</strong></nav>
    <header class="merchant-detail__header"><div><p class="raven-eyebrow">{{ merchant.spaceName }} counterparty</p><h1>{{ merchant.name }}</h1><p>{{ merchant.notes || merchant.normalizedName || merchant.key }}</p></div><span class="raven-chip raven-chip--accent">{{ merchant.active ? 'active' : 'inactive' }}</span></header>

    <section v-if="data?.totals.length" class="merchant-metrics">
      <template v-for="total in data.totals" :key="total.currency">
        <article><span>Total paid</span><strong>{{ money(total.outflow, total.currency) }}</strong><small>{{ total.transactionCount }} linked transactions</small></article>
        <article><span>Total received</span><strong>{{ money(total.inflow, total.currency) }}</strong><small>Net {{ money(total.net, total.currency) }}</small></article>
        <article><span>Average paid</span><strong>{{ money(total.averageMonthlyOutflow, total.currency) }}</strong><small>Per active month</small></article>
        <article><span>Active months</span><strong>{{ total.activeMonthCount }}</strong><small>Months containing linked activity</small></article>
      </template>
    </section>

    <section class="merchant-ledger raven-surface">
      <header><div><h2>Transaction ledger</h2><p>Statement truth plus Raven’s reviewed purpose, category, and occurrence context.</p></div><span>{{ data?.transactions.length ?? 0 }} shown</span></header>
      <div v-if="!data?.transactions.length" class="raven-empty"><p>No transactions are linked to this merchant yet. Review one in Activity to begin its ledger.</p></div>
      <div v-else class="merchant-ledger__table"><table><thead><tr><th>Date</th><th>Statement description</th><th>Reviewed meaning</th><th>Account</th><th>Amount</th></tr></thead><tbody>
        <tr v-for="transaction in data.transactions" :key="transaction.id">
          <td>{{ dateLabel(transaction.postedAt) }}</td>
          <td><strong>{{ transaction.description }}</strong><small>{{ transaction.key }}</small></td>
          <td><strong>{{ transaction.purpose?.purposeName || 'Purpose not reviewed' }}</strong><small>{{ transaction.purpose?.occurrenceLabel || transaction.categoryName || 'No occurrence detail' }}</small><span v-if="transaction.purpose?.tags?.length" class="tag-row"><span v-for="tag in transaction.purpose.tags" :key="tag" class="raven-chip">{{ tag }}</span></span></td>
          <td><strong>{{ transaction.accountName || transaction.accountKey || 'Unknown account' }}</strong><small>{{ transaction.status }}</small></td>
          <td :class="transaction.flowDirection === 'inflow' || (!transaction.flowDirection && transaction.direction === 'credit') ? 'amount-in' : 'amount-out'">{{ money(Math.abs(transaction.amount), transaction.currency) }}</td>
        </tr>
      </tbody></table></div>
    </section>
  </div>
  <div v-else class="merchant-state raven-surface"><h1>Merchant not found</h1><p>No merchant uses this key in the selected Financial Space.</p><NuxtLink class="raven-button" to="/merchants">Return to merchants</NuxtLink></div>
</template>

<style scoped>
.merchant-detail { display: grid; gap: 26px; }
.merchant-breadcrumb { display: flex; gap: 8px; color: var(--raven-muted); font-size: 11px; }.merchant-breadcrumb a { color: inherit; }
.merchant-detail__header { display: flex; align-items: flex-start; justify-content: space-between; gap: 20px; }.merchant-detail__header h1 { margin: 6px 0 0; font-size: clamp(30px, 4vw, 42px); }.merchant-detail__header p:last-child { margin: 8px 0 0; color: var(--raven-muted); }
.merchant-metrics { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; }.merchant-metrics article { display: grid; gap: 7px; border: 1px solid var(--raven-border); border-radius: var(--raven-radius-md); padding: 16px 18px; background: var(--raven-panel); }.merchant-metrics span, .merchant-metrics small { color: var(--raven-muted); font-size: 11px; }.merchant-metrics strong { font-size: 18px; }
.merchant-ledger { overflow: hidden; }.merchant-ledger > header { display: flex; justify-content: space-between; gap: 20px; padding: 18px; }.merchant-ledger h2 { margin: 0; font-size: 18px; }.merchant-ledger header p, .merchant-ledger header > span { margin: 5px 0 0; color: var(--raven-muted); font-size: 11px; }
.merchant-ledger__table { overflow-x: auto; }.merchant-ledger table { width: 100%; min-width: 980px; border-collapse: collapse; }.merchant-ledger th, .merchant-ledger td { border-top: 1px solid var(--raven-border); padding: 12px 14px; text-align: left; vertical-align: top; }.merchant-ledger th { color: var(--raven-muted); font-size: 10px; text-transform: uppercase; }.merchant-ledger td { font-size: 12px; }.merchant-ledger td > strong, .merchant-ledger td > small { display: block; }.merchant-ledger td small { margin-top: 3px; color: var(--raven-muted); }.merchant-ledger td:last-child { text-align: right; font-weight: 700; }
.tag-row { display: flex; flex-wrap: wrap; gap: 4px; margin-top: 6px; }.tag-row .raven-chip { font-size: 9px; }.amount-in { color: var(--raven-success); }.amount-out { color: var(--raven-text); }
.merchant-state { max-width: 620px; margin: 40px auto; padding: 24px; }.merchant-state--error { border-color: color-mix(in srgb, var(--raven-danger) 42%, transparent); }
@media (max-width: 900px) { .merchant-metrics { grid-template-columns: repeat(2, minmax(0, 1fr)); } } @media (max-width: 560px) { .merchant-detail__header { flex-direction: column; }.merchant-metrics { grid-template-columns: 1fr; } }
</style>
