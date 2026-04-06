<script setup lang="ts">
type SpaceRow = {
  id: string
  key: string
  name: string
  spaceType: string
  currency: string
  description?: string | null
}

type CountRow = {
  space: string
  total: number
}

useHead({
  title: 'Raven',
  meta: [
    {
      name: 'description',
      content: 'Raven environment explorer for financial truth, monthly review, and transaction clarification.',
    },
  ],
})

const formatCount = (value: number) => new Intl.NumberFormat('en-ZA').format(value || 0)

const formatSpaceType = (value: string) =>
  value
    .split(/[_-]+/)
    .filter(Boolean)
    .map(part => part.charAt(0).toUpperCase() + part.slice(1))
    .join(' ')

const { data, pending, error, refresh } = await useAsyncData('raven-home-environments', async () => {
  const response = await queryRavenDb(
    `
      SELECT id, key, name, spaceType, currency, description
      FROM financialSpace
      WHERE active = true
      ORDER BY name;

      SELECT space, count() AS total
      FROM account
      WHERE active = true
      GROUP BY space;

      SELECT space, count() AS total
      FROM transaction
      GROUP BY space;

      SELECT space, count() AS total
      FROM clarificationTask
      WHERE status = 'open'
      GROUP BY space;
    `,
  )

  const spaces = statementResult<SpaceRow[]>(response, 0)
  const accountCounts = statementResult<CountRow[]>(response, 1)
  const transactionCounts = statementResult<CountRow[]>(response, 2)
  const clarificationCounts = statementResult<CountRow[]>(response, 3)

  const accountCountMap = new Map(accountCounts.map(row => [row.space, row.total]))
  const transactionCountMap = new Map(transactionCounts.map(row => [row.space, row.total]))
  const clarificationCountMap = new Map(clarificationCounts.map(row => [row.space, row.total]))

  return spaces.map(space => ({
    ...space,
    accountCount: accountCountMap.get(space.id) ?? 0,
    transactionCount: transactionCountMap.get(space.id) ?? 0,
    openClarificationCount: clarificationCountMap.get(space.id) ?? 0,
  }))
}, {
  server: false,
})

const primarySpace = computed(() => data.value?.[0] ?? null)
</script>

<template>
  <section class="space-y-8 py-6">
    <header class="grid gap-6 lg:grid-cols-[1.15fr_0.85fr] lg:items-end">
      <div class="space-y-5">
        <div class="inline-flex items-center gap-2 rounded-full border border-cyan-400/20 bg-cyan-400/10 px-3 py-1 text-[11px] font-medium uppercase tracking-[0.32em] text-cyan-100/80">
          <span class="h-1.5 w-1.5 rounded-full bg-cyan-300 shadow-[0_0_18px_rgba(34,211,238,0.8)]" />
          Raven
        </div>

        <div class="space-y-3">
          <p class="text-xs uppercase tracking-[0.34em] text-slate-400">
            Environment Explorer
          </p>
          <h1 class="max-w-4xl text-5xl font-semibold tracking-[-0.06em] text-white sm:text-6xl">
            Financial truth, organized by environment.
          </h1>
          <p class="max-w-3xl text-base leading-7 text-slate-300 sm:text-lg">
            Start with the real operating contexts you manage. Each environment becomes a place to review
            accounts, drill into months, and clarify transactions without losing the original statement trail.
          </p>
        </div>
      </div>

      <article class="raven-card space-y-4 p-5 sm:p-6">
        <div class="flex items-center justify-between gap-4">
          <div>
            <p class="text-[11px] uppercase tracking-[0.3em] text-slate-400">Primary environment</p>
            <h2 class="mt-2 text-xl font-semibold text-white">
              {{ primarySpace?.name || 'No environments yet' }}
            </h2>
          </div>
          <span class="rounded-full border border-emerald-400/20 bg-emerald-400/10 px-3 py-1 text-xs font-medium text-emerald-100">
            Live data
          </span>
        </div>

        <p class="text-sm leading-6 text-slate-300">
          The next useful slice is month review by account: inflow, outflow, fees, categories, and every
          imported transaction in statement order.
        </p>

        <NuxtLink
          v-if="primarySpace"
          :to="`/environments/${primarySpace.key}`"
          class="inline-flex items-center gap-2 rounded-full border border-cyan-300/30 bg-cyan-400/12 px-4 py-2 text-sm font-medium text-cyan-50 transition hover:border-cyan-200/40 hover:bg-cyan-300/18"
        >
          Open {{ primarySpace.name }}
          <span aria-hidden="true">→</span>
        </NuxtLink>
      </article>
    </header>

    <section v-if="error" class="raven-card space-y-3 p-6">
      <p class="text-sm font-medium text-rose-200">The environment overview could not load.</p>
      <p class="text-sm leading-6 text-slate-300">
        {{ error.message }}
      </p>
      <button class="raven-link" type="button" @click="refresh()">
        Retry
      </button>
    </section>

    <section v-else-if="pending" class="grid gap-4 lg:grid-cols-2">
      <article v-for="index in 2" :key="index" class="raven-card animate-pulse space-y-4 p-6">
        <div class="h-3 w-24 rounded-full bg-white/8" />
        <div class="h-8 w-56 rounded-full bg-white/10" />
        <div class="h-20 rounded-3xl bg-white/5" />
      </article>
    </section>

    <section v-else-if="!data?.length" class="raven-card p-6">
      <p class="text-lg font-medium text-white">No environments are available yet.</p>
      <p class="mt-2 max-w-2xl text-sm leading-6 text-slate-300">
        Once environments and accounts exist, Raven can start summarizing months and exposing imported
        statement history through the explorer.
      </p>
    </section>

    <section v-else class="grid gap-4 lg:grid-cols-2">
      <NuxtLink
        v-for="space in data"
        :key="space.id"
        :to="`/environments/${space.key}`"
        class="group raven-card block overflow-hidden p-6 transition duration-200 hover:border-cyan-300/30 hover:bg-white/[0.065]"
      >
        <div class="flex flex-wrap items-start justify-between gap-4">
          <div class="space-y-2">
            <p class="text-[11px] uppercase tracking-[0.3em] text-slate-400">
              {{ formatSpaceType(space.spaceType) }} environment
            </p>
            <h2 class="text-2xl font-semibold tracking-[-0.04em] text-white">
              {{ space.name }}
            </h2>
            <p class="max-w-xl text-sm leading-6 text-slate-300">
              {{ space.description || 'Financial context for accounts, transactions, and monthly review.' }}
            </p>
          </div>

          <div class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs uppercase tracking-[0.24em] text-slate-300">
            {{ space.currency }}
          </div>
        </div>

        <div class="mt-6 grid gap-3 sm:grid-cols-3">
          <div class="rounded-3xl border border-white/8 bg-slate-950/40 p-4">
            <p class="text-[11px] uppercase tracking-[0.26em] text-slate-400">Accounts</p>
            <p class="mt-3 text-2xl font-semibold text-white">{{ formatCount(space.accountCount) }}</p>
          </div>

          <div class="rounded-3xl border border-white/8 bg-slate-950/40 p-4">
            <p class="text-[11px] uppercase tracking-[0.26em] text-slate-400">Transactions</p>
            <p class="mt-3 text-2xl font-semibold text-white">{{ formatCount(space.transactionCount) }}</p>
          </div>

          <div class="rounded-3xl border border-white/8 bg-slate-950/40 p-4">
            <p class="text-[11px] uppercase tracking-[0.26em] text-slate-400">Open clarifications</p>
            <p class="mt-3 text-2xl font-semibold text-white">{{ formatCount(space.openClarificationCount) }}</p>
          </div>
        </div>

        <div class="mt-6 flex items-center justify-between text-sm text-slate-300">
          <span>Open environment explorer</span>
          <span class="transition-transform duration-200 group-hover:translate-x-1">→</span>
        </div>
      </NuxtLink>
    </section>
  </section>
</template>
