<script setup lang="ts">
import type { ClientStatus } from '~/composables/useRavenClientsApi'

type ClientForm = {
  key: string
  name: string
  businessName: string
  contactPerson: string
  email: string
  phoneWhatsapp: string
  websiteDomain: string
  status: ClientStatus
  relatedProjects: string
  orbitClientId: string
  notes: string
}

const route = useRoute()
const api = useRavenClientsApi()
const selectedKey = ref('')
const showClientModal = ref(false)
const editingClient = ref<Awaited<ReturnType<typeof api.list>>[number] | null>(null)
const saving = ref(false)
const saveError = ref('')
const statusFilter = ref<'all' | ClientStatus>('active')

const blankForm = (): ClientForm => ({
  key: '',
  name: '',
  businessName: '',
  contactPerson: '',
  email: '',
  phoneWhatsapp: '',
  websiteDomain: '',
  status: 'active',
  relatedProjects: '',
  orbitClientId: '',
  notes: '',
})

const form = reactive<ClientForm>(blankForm())

const { data, pending, error, refresh } = await useAsyncData('raven-clients-dashboard', () => api.list(), {
  server: false,
  default: () => [],
})

const requestedClientKey = computed(() => {
  const value = route.query.client
  return Array.isArray(value) ? value[0] || '' : value || ''
})

const filteredClients = computed(() => {
  const clients = data.value || []
  if (statusFilter.value === 'all') return clients
  return clients.filter((client) => client.status === statusFilter.value)
})

const selectedClient = computed(() => {
  return (data.value || []).find((client) => client.key === selectedKey.value) || filteredClients.value[0] || null
})

const stats = computed(() => {
  const clients = data.value || []
  return {
    total: clients.length,
    active: clients.filter((client) => client.status === 'active').length,
    retainers: clients.reduce((total, client) => total + client.activeRetainerCount, 0),
    monthlyRevenue: clients.reduce((total, client) => total + client.monthlyRevenue, 0),
  }
})

watch(
  [filteredClients, requestedClientKey],
  ([clients, requested]) => {
    const allClients = data.value || []
    if (requested && allClients.some((client) => client.key === requested)) {
      statusFilter.value = 'all'
      selectedKey.value = requested
      return
    }

    if (!clients.some((client) => client.key === selectedKey.value)) {
      selectedKey.value = clients[0]?.key || ''
    }
  },
  { immediate: true },
)

watch(
  () => form.name,
  (name) => {
    if (!showClientModal.value || editingClient.value || form.key) return
    form.key = slugify(name)
  },
)

const currency = new Intl.NumberFormat('en-ZA', {
  style: 'currency',
  currency: 'ZAR',
})

function slugify(value: string) {
  return value
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
}

function resetForm() {
  Object.assign(form, blankForm())
}

function fillForm(client: Awaited<ReturnType<typeof api.list>>[number]) {
  Object.assign(form, {
    key: client.key,
    name: client.name,
    businessName: client.businessName || '',
    contactPerson: client.contactPerson || '',
    email: client.email || '',
    phoneWhatsapp: client.phoneWhatsapp || '',
    websiteDomain: client.websiteDomain || '',
    status: client.status,
    relatedProjects: client.relatedProjects || '',
    orbitClientId: client.orbitClientId || '',
    notes: client.notes || '',
  })
}

function openNewClient() {
  editingClient.value = null
  saveError.value = ''
  resetForm()
  showClientModal.value = true
}

function openEditClient(client: Awaited<ReturnType<typeof api.list>>[number]) {
  editingClient.value = client
  saveError.value = ''
  fillForm(client)
  showClientModal.value = true
}

function closeClientModal() {
  if (saving.value) return
  showClientModal.value = false
  editingClient.value = null
  saveError.value = ''
  resetForm()
}

async function saveClient() {
  saveError.value = ''
  const key = slugify(form.key || form.name)

  if (!key || !form.name.trim()) {
    saveError.value = 'Client name is required.'
    return
  }

  if (!editingClient.value && (data.value || []).some((client) => client.key === key)) {
    saveError.value = 'A client with this name already exists.'
    return
  }

  saving.value = true
  try {
    const payload = {
      key,
      name: form.name.trim(),
      businessName: form.businessName.trim() || undefined,
      contactPerson: form.contactPerson.trim() || undefined,
      email: form.email.trim() || undefined,
      phoneWhatsapp: form.phoneWhatsapp.trim() || undefined,
      websiteDomain: form.websiteDomain.trim() || undefined,
      status: form.status,
      relatedProjects: form.relatedProjects.trim() || undefined,
      orbitClientId: form.orbitClientId.trim() || undefined,
      notes: form.notes.trim() || undefined,
    }

    if (editingClient.value) {
      await api.update({ id: editingClient.value.id, ...payload })
    } else {
      await api.create(payload)
    }

    await refresh()
    selectedKey.value = key
    closeClientModal()
  } catch (err) {
    saveError.value = err instanceof Error ? err.message : 'Could not save client.'
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <main class="min-h-screen bg-[#030712] px-6 py-8 text-slate-100 lg:px-10">
    <div class="mx-auto flex w-full max-w-7xl flex-col gap-8">
      <header class="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
        <div>
          <NuxtLink to="/" class="text-sm font-semibold uppercase tracking-[0.2em] text-slate-500 hover:text-slate-300">
            <- Raven
          </NuxtLink>
          <h1 class="mt-4 text-4xl font-semibold tracking-tight text-white">Clients</h1>
          <p class="mt-3 max-w-3xl text-lg text-slate-300">
            Manage the global Raven client records that retainers, hosting agreements, and future billing workflows will use.
          </p>
        </div>
        <div class="flex flex-wrap gap-3">
          <NuxtLink
            to="/retainers"
            class="rounded-full border border-cyan-400/25 bg-cyan-400/10 px-5 py-3 text-sm font-semibold text-cyan-100 hover:border-cyan-300/50 hover:bg-cyan-400/15"
          >
            Retainers
          </NuxtLink>
          <button
            class="rounded-full border border-cyan-300/30 bg-cyan-300/10 px-5 py-3 text-sm font-semibold text-cyan-50 hover:border-cyan-200/60 hover:bg-cyan-300/20"
            type="button"
            @click="openNewClient"
          >
            New client
          </button>
        </div>
      </header>

      <section class="grid gap-4 md:grid-cols-4">
        <div class="raven-card p-5">
          <p class="text-xs font-semibold uppercase tracking-[0.28em] text-slate-500">Clients</p>
          <p class="mt-4 text-3xl font-semibold text-white">{{ stats.total }}</p>
        </div>
        <div class="raven-card p-5">
          <p class="text-xs font-semibold uppercase tracking-[0.28em] text-slate-500">Active clients</p>
          <p class="mt-4 text-3xl font-semibold text-white">{{ stats.active }}</p>
        </div>
        <div class="raven-card p-5">
          <p class="text-xs font-semibold uppercase tracking-[0.28em] text-slate-500">Active retainers</p>
          <p class="mt-4 text-3xl font-semibold text-white">{{ stats.retainers }}</p>
        </div>
        <div class="raven-card p-5">
          <p class="text-xs font-semibold uppercase tracking-[0.28em] text-slate-500">Monthly revenue</p>
          <p class="mt-4 text-3xl font-semibold text-emerald-100">{{ currency.format(stats.monthlyRevenue) }}</p>
        </div>
      </section>

      <section class="space-y-4">
        <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
          <h2 class="text-lg font-semibold text-white">{{ filteredClients.length }} clients in view</h2>
          <select
            v-model="statusFilter"
            class="rounded-full border border-white/10 bg-[#040817] px-5 py-3 text-sm text-white outline-none ring-cyan-300/20 focus:ring-4"
          >
            <option value="active">Active</option>
            <option value="paused">Paused</option>
            <option value="inactive">Inactive</option>
            <option value="closed">Closed</option>
            <option value="all">All clients</option>
          </select>
        </div>

        <div v-if="pending" class="raven-card p-6 text-slate-400">Loading clients...</div>
        <div v-else-if="error" class="raven-card border-red-500/30 p-6 text-red-200">
          Could not load clients: {{ error.message }}
        </div>
        <div v-else-if="!filteredClients.length" class="raven-card p-6 text-slate-400">
          No clients match this view.
        </div>
        <div v-else class="overflow-hidden rounded-2xl border border-white/10 bg-white/[0.03]">
          <div
            v-for="client in filteredClients"
            :key="client.id"
            class="grid cursor-pointer gap-4 border-b border-white/10 px-5 py-5 transition last:border-b-0 md:grid-cols-[1.4fr_0.6fr_0.7fr_0.8fr_auto]"
            :class="client.key === selectedClient?.key ? 'bg-cyan-400/10' : 'hover:bg-white/[0.04]'"
            role="button"
            tabindex="0"
            @click="selectedKey = client.key"
            @keyup.enter="selectedKey = client.key"
          >
            <div>
              <p class="font-semibold text-white">{{ client.name }}</p>
              <p class="mt-1 text-sm text-slate-400">{{ client.businessName || client.contactPerson || client.websiteDomain || 'No profile detail' }}</p>
            </div>
            <div class="text-sm text-slate-300">
              <p>{{ client.totalRetainerCount }} retainers</p>
              <p class="mt-1 text-slate-500">{{ client.activeRetainerCount }} active</p>
            </div>
            <div class="text-sm text-slate-300">
              <p>{{ currency.format(client.monthlyRevenue) }}/month</p>
              <p class="mt-1 text-slate-500">{{ client.email || client.phoneWhatsapp || 'No contact captured' }}</p>
            </div>
            <div>
              <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-sm capitalize text-slate-300">
                {{ client.status }}
              </span>
            </div>
            <div class="flex items-center justify-end gap-2">
              <NuxtLink
                :to="{ path: '/retainers', query: { client: client.key } }"
                class="rounded-full border border-cyan-300/20 px-4 py-2 text-sm font-semibold text-cyan-100 hover:bg-cyan-300/10"
                @click.stop
              >
                Retainers
              </NuxtLink>
              <button
                class="rounded-full border border-white/10 px-4 py-2 text-sm font-semibold text-slate-100 hover:bg-white/10"
                type="button"
                @click.stop="openEditClient(client)"
              >
                Edit
              </button>
            </div>
          </div>
        </div>
      </section>
    </div>

    <Teleport to="body">
      <div
        v-if="showClientModal"
        class="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto bg-black/70 px-4 py-8 backdrop-blur-sm"
        @click.self="closeClientModal"
      >
        <form
          class="client-modal w-full max-w-3xl rounded-2xl border border-white/10 bg-[#050917] p-6 shadow-2xl shadow-cyan-950/30"
          @submit.prevent="saveClient"
        >
          <div class="flex items-start justify-between gap-4">
            <div>
              <p class="text-xs font-semibold uppercase tracking-[0.28em] text-slate-500">
                {{ editingClient ? 'Edit client' : 'New client' }}
              </p>
              <h2 class="mt-3 text-2xl font-semibold text-white">
                {{ editingClient ? form.name || 'Client' : 'Add client' }}
              </h2>
            </div>
            <button
              class="rounded-full border border-white/10 px-3 py-2 text-sm font-semibold text-slate-300 hover:bg-white/10"
              type="button"
              @click="closeClientModal"
            >
              Close
            </button>
          </div>

          <div class="mt-6 grid gap-4 md:grid-cols-2">
            <label class="client-field md:col-span-2">
              <span class="text-sm font-semibold text-slate-300">Name</span>
              <input v-model="form.name" required class="client-input" placeholder="Client name" />
            </label>
            <label class="client-field">
              <span class="text-sm font-semibold text-slate-300">Business name</span>
              <input v-model="form.businessName" class="client-input" placeholder="Registered or trading name" />
            </label>
            <label class="client-field">
              <span class="text-sm font-semibold text-slate-300">Status</span>
              <select v-model="form.status" class="client-input">
                <option value="active">Active</option>
                <option value="paused">Paused</option>
                <option value="inactive">Inactive</option>
                <option value="closed">Closed</option>
              </select>
            </label>
            <label class="client-field">
              <span class="text-sm font-semibold text-slate-300">Contact person</span>
              <input v-model="form.contactPerson" class="client-input" />
            </label>
            <label class="client-field">
              <span class="text-sm font-semibold text-slate-300">Email</span>
              <input v-model="form.email" class="client-input" type="email" />
            </label>
            <label class="client-field">
              <span class="text-sm font-semibold text-slate-300">Phone / WhatsApp</span>
              <input v-model="form.phoneWhatsapp" class="client-input" />
            </label>
            <label class="client-field">
              <span class="text-sm font-semibold text-slate-300">Website / domain</span>
              <input v-model="form.websiteDomain" class="client-input" placeholder="example.com" />
            </label>
            <label class="client-field md:col-span-2">
              <span class="text-sm font-semibold text-slate-300">Notes</span>
              <textarea v-model="form.notes" class="client-input" />
            </label>
          </div>

          <p v-if="saveError" class="mt-5 rounded-xl border border-red-500/30 bg-red-500/10 p-3 text-sm text-red-100">
            {{ saveError }}
          </p>

          <div class="mt-6 flex flex-col-reverse gap-3 sm:flex-row sm:justify-end">
            <button
              class="rounded-full border border-white/10 px-5 py-3 text-sm font-semibold text-slate-200 hover:bg-white/10"
              type="button"
              @click="closeClientModal"
            >
              Cancel
            </button>
            <button
              class="rounded-full border border-cyan-300/30 bg-cyan-300/15 px-5 py-3 text-sm font-semibold text-cyan-50 hover:bg-cyan-300/25 disabled:cursor-not-allowed disabled:opacity-60"
              :disabled="saving"
              type="submit"
            >
              {{ saving ? 'Saving...' : editingClient ? 'Save client' : 'Add client' }}
            </button>
          </div>
        </form>
      </div>
    </Teleport>
  </main>
</template>

<style scoped>
.client-modal {
  max-height: calc(100vh - 4rem);
  color-scheme: dark;
}

.client-field {
  display: flex;
  min-width: 0;
  flex-direction: column;
  gap: 0.5rem;
}

.client-input {
  min-height: 3.15rem;
  width: 100%;
  min-width: 0;
  border-radius: 1rem;
  border: 1px solid rgb(148 163 184 / 0.18);
  background: rgb(2 6 23 / 0.78);
  color: rgb(248 250 252);
  font-size: 0.95rem;
  line-height: 1.35;
  outline: none;
  padding: 0.78rem 1rem;
  box-shadow: inset 0 1px 0 rgb(255 255 255 / 0.04);
  transition:
    background-color 160ms ease,
    border-color 160ms ease,
    box-shadow 160ms ease;
}

.client-input::placeholder {
  color: rgb(148 163 184 / 0.72);
}

.client-input:hover {
  border-color: rgb(148 163 184 / 0.34);
}

.client-input:focus {
  border-color: rgb(103 232 249 / 0.68);
  background: rgb(3 7 18 / 0.95);
  box-shadow:
    0 0 0 4px rgb(34 211 238 / 0.12),
    inset 0 1px 0 rgb(255 255 255 / 0.05);
}

select.client-input {
  appearance: none;
  background-image:
    linear-gradient(45deg, transparent 50%, rgb(148 163 184) 50%),
    linear-gradient(135deg, rgb(148 163 184) 50%, transparent 50%);
  background-position:
    calc(100% - 1.3rem) 50%,
    calc(100% - 0.95rem) 50%;
  background-repeat: no-repeat;
  background-size:
    0.36rem 0.36rem,
    0.36rem 0.36rem;
  padding-right: 2.75rem;
}

textarea.client-input {
  min-height: 8rem;
  resize: vertical;
}

@media (max-width: 640px) {
  .client-modal {
    max-height: calc(100vh - 2rem);
    padding: 1.25rem;
  }
}
</style>
