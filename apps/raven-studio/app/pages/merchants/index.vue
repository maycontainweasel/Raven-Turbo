<script setup lang="ts">
import type { ClassificationOptions, MerchantDirectoryRow } from '~/composables/useClassificationApi'

useHead({ title: 'Merchants · Raven' })

const api = useClassificationApi()
const search = ref('')
const spaceFilter = ref('all')
const createOpen = ref(false)
const hydrated = ref(false)

onMounted(() => { hydrated.value = true })

const { data, pending, error, refresh } = await useAsyncData<{
  merchants: MerchantDirectoryRow[]
  options: ClassificationOptions
}>('merchant-directory-live', async () => {
  const [merchants, options] = await Promise.all([api.listMerchants(), api.getOptions()])
  return { merchants, options }
}, { server: false })

const merchants = computed(() => (data.value?.merchants ?? []).filter(merchant => merchant.active))
const spaces = computed(() => data.value?.options.spaces ?? [])
const filteredMerchants = computed(() => {
  const needle = search.value.trim().toLowerCase()
  return merchants.value.filter((merchant) => {
    if (spaceFilter.value !== 'all' && merchant.spaceKey !== spaceFilter.value) return false
    if (!needle) return true
    return [merchant.name, merchant.normalizedName, merchant.notes, merchant.spaceName]
      .filter(Boolean).join(' ').toLowerCase().includes(needle)
  })
})

const totalTransactions = computed(() => merchants.value.reduce((sum, merchant) => sum + merchant.transactionCount, 0))
const classifiedMerchants = computed(() => merchants.value.filter(merchant => merchant.transactionCount > 0).length)

const money = (value: number, currency: string) => new Intl.NumberFormat('en-ZA', {
  style: 'currency', currency, maximumFractionDigits: 2,
}).format(value)

const completeCreate = async () => { await refresh() }
</script>

<template>
  <div class="merchant-page">
    <header class="merchant-header">
      <div>
        <p class="raven-eyebrow">Transaction counterparties</p>
        <h1>Merchants &amp; counterparties</h1>
        <p>Who money was paid to or received from, without changing the statement description.</p>
      </div>
      <div class="merchant-header__actions">
        <button class="raven-button" type="button" :disabled="hydrated && pending" @click="refresh"><span class="i-lucide-refresh-cw" />Refresh</button>
        <button class="raven-button raven-button--primary" type="button" @click="createOpen = true"><span class="i-lucide-store" />Create merchant</button>
      </div>
    </header>

    <div v-if="error" class="merchant-error" role="alert">
      <span>Merchant records and their transaction totals could not be loaded.</span>
      <button class="raven-button" type="button" @click="refresh">Retry</button>
    </div>

    <section class="merchant-summary" aria-label="Merchant summary">
      <article><span>Counterparties</span><strong>{{ hydrated && pending ? '…' : merchants.length }}</strong><small>Persisted records</small></article>
      <article><span>With ledger activity</span><strong>{{ hydrated && pending ? '…' : classifiedMerchants }}</strong><small>Linked to at least one transaction</small></article>
      <article><span>Linked transactions</span><strong>{{ hydrated && pending ? '…' : totalTransactions }}</strong><small>Across all Financial Spaces</small></article>
    </section>

    <section class="merchant-controls raven-surface">
      <label class="merchant-search"><span class="i-lucide-search" /><span class="sr-only">Search merchants</span><input v-model="search" type="search" placeholder="Search merchants, counterparties, or notes…" /></label>
      <label><span>Financial Space</span><select v-model="spaceFilter"><option value="all">All spaces</option><option v-for="space in spaces" :key="space.key" :value="space.key">{{ space.name }}</option></select></label>
    </section>

    <div v-if="hydrated && pending" class="merchant-loading">Loading merchant ledgers…</div>
    <div v-else-if="!merchants.length && !error" class="raven-empty"><p>No merchant records exist yet. Create one, then link it while reviewing a transaction in Activity.</p></div>
    <div v-else-if="!filteredMerchants.length" class="raven-empty"><p>No merchants match this view.</p></div>
    <div v-else class="merchant-grid">
      <NuxtLink v-for="merchant in filteredMerchants" :key="`${merchant.spaceKey}:${merchant.key}`" class="merchant-card raven-surface" :to="`/merchants/${merchant.spaceKey}/${merchant.key}`">
        <header><span><strong>{{ merchant.name }}</strong><small>{{ merchant.normalizedName || merchant.key }}</small></span><span class="raven-chip">{{ merchant.spaceName }}</span></header>
        <div v-if="merchant.totals.length" class="merchant-card__totals">
          <div v-for="total in merchant.totals" :key="total.currency"><span>Paid</span><strong>{{ money(total.outflow, total.currency) }}</strong><small>{{ total.transactionCount }} transactions · avg {{ money(total.averageMonthlyOutflow, total.currency) }}/active month</small></div>
          <div v-for="total in merchant.totals" :key="`${total.currency}-in`"><span>Received</span><strong>{{ money(total.inflow, total.currency) }}</strong><small>{{ total.activeMonthCount }} active months</small></div>
        </div>
        <div v-else class="merchant-card__empty">No transactions linked yet.</div>
        <footer><span>{{ merchant.notes || 'No counterparty notes' }}</span><span aria-hidden="true">→</span></footer>
      </NuxtLink>
    </div>

    <MerchantCreateDialog v-model:open="createOpen" :spaces="spaces" @complete="completeCreate" />
  </div>
</template>

<style scoped>
.merchant-page { display: grid; gap: 26px; }
.merchant-header { display: flex; align-items: flex-start; justify-content: space-between; gap: 24px; }
.merchant-header h1 { margin: 6px 0 0; font-size: clamp(28px, 3vw, 38px); }
.merchant-header p:last-child { max-width: 720px; margin: 8px 0 0; color: var(--raven-muted); }
.merchant-header__actions { display: flex; gap: 8px; }
.merchant-error { display: flex; align-items: center; justify-content: space-between; gap: 16px; border: 1px solid color-mix(in srgb, var(--raven-danger) 42%, transparent); border-radius: var(--raven-radius-md); padding: 12px 14px; color: var(--raven-danger); background: var(--raven-danger-soft); }
.merchant-summary { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; }
.merchant-summary article { display: grid; gap: 7px; border: 1px solid var(--raven-border); border-radius: var(--raven-radius-md); padding: 16px 18px; background: var(--raven-panel); }
.merchant-summary span, .merchant-summary small { color: var(--raven-muted); font-size: 11px; }
.merchant-summary strong { font-size: 21px; }
.merchant-controls { display: flex; align-items: end; justify-content: space-between; gap: 14px; padding: 12px; }
.merchant-controls label { display: grid; gap: 6px; color: var(--raven-muted); font-size: 11px; }
.merchant-search { min-width: min(100%, 520px); grid-template-columns: auto 1fr !important; align-items: center; }
.merchant-controls input, .merchant-controls select { min-height: 36px; border: 1px solid var(--raven-border); border-radius: var(--raven-radius-sm); padding: 0 11px; color: var(--raven-text); background: var(--raven-bg); }
.merchant-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px; }
.merchant-card { display: grid; gap: 18px; padding: 18px; color: var(--raven-text); text-decoration: none; }
.merchant-card:hover { border-color: color-mix(in srgb, var(--raven-muted) 55%, var(--raven-border)); }
.merchant-card header, .merchant-card footer { display: flex; justify-content: space-between; gap: 16px; }
.merchant-card header > span:first-child { display: grid; gap: 4px; }
.merchant-card header strong { font-size: 16px; }
.merchant-card small, .merchant-card footer, .merchant-card__empty { color: var(--raven-muted); font-size: 11px; }
.merchant-card__totals { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 10px; }
.merchant-card__totals > div { display: grid; gap: 5px; border-left: 2px solid var(--raven-border); padding-left: 10px; }
.merchant-card__totals span { color: var(--raven-muted); font-size: 10px; text-transform: uppercase; }
.merchant-card__totals strong { font-size: 15px; }
.merchant-loading { color: var(--raven-muted); }
@media (max-width: 820px) { .merchant-grid { grid-template-columns: 1fr; } }
@media (max-width: 650px) { .merchant-header, .merchant-controls { flex-direction: column; align-items: stretch; } .merchant-header__actions { flex-wrap: wrap; } .merchant-summary { grid-template-columns: 1fr; } }
</style>
