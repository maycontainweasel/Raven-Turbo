<script setup lang="ts">
import type { ClientDirectoryRow, RetainerDashboard } from '~/composables/useClientControlApi'

useHead({ title: 'Clients · Raven' })

const api = useClientControlApi()
const search = ref('')
const statusFilter = ref('all')
const createOpen = ref(false)
const hydrated = ref(false)

onMounted(() => {
  hydrated.value = true
})

const {
  data,
  pending,
  error,
  refresh,
} = await useAsyncData<{ clients: ClientDirectoryRow[]; dashboard: RetainerDashboard }>(
  'client-directory-live',
  async () => {
    const [clients, dashboard] = await Promise.all([
      api.listClients(),
      api.getRetainerDashboard(),
    ])
    return { clients, dashboard }
  },
  { server: false },
)

const clients = computed(() => data.value?.clients ?? [])
const statuses = computed(() => [...new Set(clients.value.map(client => client.status))].sort())
const filteredClients = computed(() => {
  const needle = search.value.trim().toLowerCase()
  return clients.value.filter((client) => {
    if (statusFilter.value !== 'all' && client.status !== statusFilter.value) return false
    if (!needle) return true
    return [
      client.name,
      client.businessName,
      client.contactPerson,
      client.email,
      client.websiteDomain,
      client.notes,
    ].filter(Boolean).join(' ').toLowerCase().includes(needle)
  })
})

function money(value: number, currency = 'ZAR') {
  return new Intl.NumberFormat('en-ZA', {
    style: 'currency',
    currency,
    maximumFractionDigits: 2,
  }).format(value)
}

const completeCreate = async () => { await refresh() }
</script>

<template>
  <div class="clients-page">
    <header class="clients-header">
      <div>
        <p class="raven-eyebrow">Database-backed relationships</p>
        <h1>Clients</h1>
        <p>Only persisted client and retainer records are shown.</p>
      </div>
      <div class="clients-header__actions">
        <button class="raven-button" type="button" :disabled="hydrated && pending" @click="refresh"><span class="i-lucide-refresh-cw" aria-hidden="true" /> Refresh</button>
        <button class="raven-button raven-button--primary" type="button" @click="createOpen = true"><span class="i-lucide-contact-round" />Create client</button>
      </div>
    </header>

    <div v-if="error" class="clients-error" role="alert">
      <span>Client records could not be loaded. Only persisted client records can appear here.</span>
      <button class="raven-button" type="button" @click="refresh">Retry</button>
    </div>

    <section class="client-summary" aria-label="Persisted client summary">
      <article>
        <span>Clients</span>
        <strong>{{ hydrated && pending ? '…' : data?.dashboard.summary.clientCount ?? clients.length }}</strong>
        <small>Persisted records</small>
      </article>
      <article>
        <span>Active retainers</span>
        <strong>{{ hydrated && pending ? '…' : data?.dashboard.summary.activeRetainerCount ?? 0 }}</strong>
        <small>{{ data?.dashboard.summary.retainerCount ?? 0 }} total agreements</small>
      </article>
      <article>
        <span>Monthly retained</span>
        <strong>{{ hydrated && pending ? '…' : money(data?.dashboard.summary.monthlyRevenue ?? 0) }}</strong>
        <small>From active agreement records</small>
      </article>
      <article>
        <span>Needs review</span>
        <strong>{{ hydrated && pending ? '…' : data?.dashboard.summary.reviewNeededCount ?? 0 }}</strong>
        <small>{{ data?.dashboard.summary.overdueCount ?? 0 }} overdue</small>
      </article>
    </section>

    <section class="client-controls raven-surface">
      <label>
        <span class="i-lucide-search" aria-hidden="true" />
        <span class="sr-only">Search clients</span>
        <input v-model="search" type="search" placeholder="Search persisted client records…" />
      </label>
      <label>
        <span>Status</span>
        <select v-model="statusFilter">
          <option value="all">All statuses</option>
          <option v-for="status in statuses" :key="status" :value="status">{{ status }}</option>
        </select>
      </label>
    </section>

    <div v-if="hydrated && pending" class="clients-loading">Loading clients…</div>
    <div v-else-if="!clients.length && !error" class="raven-empty">
      <p>No persisted clients exist yet.</p>
    </div>
    <div v-else-if="!filteredClients.length" class="raven-empty">
      <p>No persisted clients match this view.</p>
    </div>
    <div v-else class="client-table-wrap">
      <table class="client-table">
        <thead>
          <tr>
            <th>Client</th>
            <th>Status</th>
            <th>Contact</th>
            <th>Retainers</th>
            <th>Monthly retained</th>
            <th><span class="sr-only">Open client</span></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="client in filteredClients" :key="client.id">
            <td>
              <NuxtLink :to="`/clients/${client.key}`">
                <strong>{{ client.name }}</strong>
                <small>{{ client.businessName || client.websiteDomain || client.key }}</small>
              </NuxtLink>
            </td>
            <td>{{ client.status }}</td>
            <td>
              <strong>{{ client.contactPerson || 'Not recorded' }}</strong>
              <small>{{ client.email || client.phoneWhatsapp || 'No contact details' }}</small>
            </td>
            <td>{{ client.activeRetainerCount }} active / {{ client.retainerCount }} total</td>
            <td><strong>{{ money(client.monthlyRevenue) }}</strong></td>
            <td><NuxtLink :to="`/clients/${client.key}`" :aria-label="`Open ${client.name}`">→</NuxtLink></td>
          </tr>
        </tbody>
      </table>
    </div>
    <ClientCreateDialog v-model:open="createOpen" @complete="completeCreate" />
  </div>
</template>

<style scoped>
.clients-page { display: grid; gap: 26px; }
.clients-header { display: flex; align-items: flex-start; justify-content: space-between; gap: 24px; }
.clients-header h1 { margin: 6px 0 0; font-size: clamp(28px, 3vw, 36px); }
.clients-header p:last-child { margin: 8px 0 0; color: var(--raven-muted); }
.clients-header__actions { display: flex; gap: 8px; }
.clients-error { display: flex; align-items: center; justify-content: space-between; gap: 16px; border: 1px solid color-mix(in srgb, var(--raven-danger) 42%, transparent); border-radius: var(--raven-radius-md); padding: 12px 14px; background: var(--raven-danger-soft); color: var(--raven-danger); }
.client-summary { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; }
.client-summary article { display: grid; gap: 7px; border: 1px solid var(--raven-border); border-radius: var(--raven-radius-md); padding: 16px 18px; background: var(--raven-panel); }
.client-summary span, .client-summary small { color: var(--raven-muted); font-size: 11px; }
.client-summary strong { font-size: 20px; }
.client-controls { display: flex; align-items: end; justify-content: space-between; gap: 14px; padding: 12px; }
.client-controls label { display: grid; gap: 6px; color: var(--raven-muted); font-size: 11px; }
.client-controls label:first-child { min-width: min(100%, 440px); grid-template-columns: auto 1fr; align-items: center; }
.client-controls input, .client-controls select { min-height: 36px; border: 1px solid var(--raven-border); border-radius: var(--raven-radius-sm); padding: 0 11px; color: var(--raven-text); background: var(--raven-bg); }
.clients-loading { color: var(--raven-muted); }
.client-table-wrap { overflow-x: auto; border: 1px solid var(--raven-border); border-radius: var(--raven-radius-md); background: var(--raven-panel); }
.client-table { width: 100%; min-width: 880px; border-collapse: collapse; }
.client-table th, .client-table td { border-bottom: 1px solid var(--raven-border); padding: 13px 15px; text-align: left; }
.client-table th { color: var(--raven-muted); font-size: 10px; text-transform: uppercase; }
.client-table td { font-size: 12px; }
.client-table td > a, .client-table td > span { display: grid; gap: 3px; color: var(--raven-text); text-decoration: none; }
.client-table small { color: var(--raven-muted); }
@media (max-width: 800px) { .client-summary { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
@media (max-width: 560px) { .clients-header, .client-controls { align-items: stretch; flex-direction: column; } .clients-header__actions { flex-wrap: wrap; } .client-summary { grid-template-columns: 1fr; } }
</style>
