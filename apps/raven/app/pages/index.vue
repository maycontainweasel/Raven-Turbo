<script setup lang="ts">
import { TabContent, TabList, TabTrigger, TabsRoot } from '@ark-ui/vue/tabs'

useHead({
  title: 'Raven',
  meta: [
    {
      name: 'description',
      content:
        'Raven is a financial operating system for past truth, present control, and future projection.',
    },
  ],
})

type Phase = {
  id: 'past' | 'present' | 'future'
  label: string
  title: string
  summary: string
  bullets: string[]
  signal: string
}

const stats = [
  { label: 'System', value: 'Financial operating system', note: 'Not just a budget app' },
  { label: 'Model', value: 'Environment -> account -> statement', note: 'Traceable by design' },
  { label: 'Database', value: 'Local Raven SurrealDB', note: 'MCP-ready from schema' },
  { label: 'Focus', value: 'History first', note: 'Truth before projection' },
]

const phases: Phase[] = [
  {
    id: 'past',
    label: 'Past',
    title: 'Truth before interpretation',
    summary:
      'Import statements, normalize rows, and turn every unknown line into a clear financial fact.',
    bullets: [
      'Load bank statements by real-world account',
      'Normalize each raw row into a transaction',
      'Resolve merchant, category, and account ambiguity',
      'Build month snapshots that never drift from the source',
    ],
    signal: 'History / truth layer',
  },
  {
    id: 'present',
    label: 'Present',
    title: 'Command center for the month',
    summary:
      'See what is already spent, what is left, and what still needs attention before the month closes.',
    bullets: [
      'Track current cash, debt pressure, and budget headroom',
      'Surface unresolved items as clarification tasks',
      'Review active accounts inside each environment',
      'Keep the month legible at a glance',
    ],
    signal: 'Today / control layer',
  },
  {
    id: 'future',
    label: 'Future',
    title: 'Rules-driven projection',
    summary:
      'Shape the flow of money into buckets, goals, savings, debt reduction, and opportunity.',
    bullets: [
      'Model bucket rules and spillover logic',
      'Project debt payoff and savings growth',
      'Set goals for business, personal, and family needs',
      'Turn small gains into durable structure',
    ],
    signal: 'Tomorrow / design layer',
  },
]

const environmentCards = [
  {
    name: 'MPIRE',
    title: 'Business environment',
    description:
      'Business accounts, revenue, expenses, tax, and debt live here as a single operating context.',
  },
  {
    name: 'Personal',
    title: 'Personal environment',
    description:
      'Current, credit card, savings, and day-to-day money stay separate from the business context.',
  },
]

const modelSpine = [
  {
    name: 'financialSpace',
    description: 'A named environment of focus, such as MPIRE or Personal.',
  },
  {
    name: 'account',
    description: 'A real-world bank account inside a financial space.',
  },
  {
    name: 'statementImport',
    description: 'A batch import for one statement file or one capture session.',
  },
  {
    name: 'statementRow',
    description: 'An immutable raw row from the source statement.',
  },
  {
    name: 'transaction',
    description: 'A normalized financial record used for analysis and rules.',
  },
  {
    name: 'clarificationTask',
    description: 'An unresolved item that needs a human decision or AI suggestion.',
  },
  {
    name: 'monthlySnapshot',
    description: 'A month-end truth layer for reporting and projections.',
  },
]

const buildOrder = [
  'Import statements into the past layer.',
  'Map accounts to their real-world environments.',
  'Classify transactions and create clarification tasks.',
  'Lock in monthly snapshots before adding projection depth.',
]
</script>

<template>
  <section class="space-y-10">
    <header class="space-y-8">
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div class="space-y-2">
          <div class="inline-flex items-center gap-2 rounded-full border border-cyan-400/20 bg-cyan-400/10 px-3 py-1 text-[11px] font-medium uppercase tracking-[0.32em] text-cyan-100/80">
            <span class="h-1.5 w-1.5 rounded-full bg-cyan-300 shadow-[0_0_18px_rgba(34,211,238,0.8)]" />
            Raven
          </div>
          <p class="text-xs uppercase tracking-[0.34em] text-slate-400">
            Financial operating system
          </p>
        </div>

        <div class="flex flex-wrap items-center gap-2 text-[11px] uppercase tracking-[0.28em] text-slate-300/80">
          <span class="raven-status-pill raven-status-pill--cyan">Local DB ready</span>
          <span class="raven-status-pill">MCP wired</span>
          <span class="raven-status-pill raven-status-pill--emerald">Source authority</span>
        </div>
      </div>

      <div class="grid gap-6 lg:grid-cols-[1.2fr_0.8fr] lg:items-end">
        <div class="space-y-6">
          <h1 class="max-w-4xl text-5xl font-semibold tracking-[-0.06em] text-white sm:text-6xl lg:text-7xl">
            Past truth, present command, future design.
          </h1>
          <p class="max-w-3xl text-base leading-7 text-slate-300 sm:text-lg">
            Raven is the calm center for bank accounts, statements, tax, debt, budgets, and projections.
            It starts with history, turns that history into truth, and then uses rules to shape the future.
          </p>
          <div class="flex flex-wrap gap-3">
            <a href="#past" class="raven-link">Start with history</a>
            <a href="#present" class="raven-link raven-link--ghost">Open command center</a>
            <a href="#future" class="raven-link raven-link--ghost">Shape projections</a>
          </div>
        </div>

        <div class="raven-card space-y-3 p-5 sm:p-6">
          <div class="flex items-center justify-between gap-4">
            <div>
              <p class="text-[11px] uppercase tracking-[0.3em] text-slate-400">Current focus</p>
              <h2 class="mt-2 text-xl font-semibold text-white">Import one month, then make it legible.</h2>
            </div>
            <div class="rounded-full border border-emerald-400/20 bg-emerald-400/10 px-3 py-1 text-xs font-medium text-emerald-100">
              Ready
            </div>
          </div>

          <ul class="space-y-2 text-sm text-slate-300">
            <li v-for="item in buildOrder" :key="item" class="flex gap-3 rounded-2xl border border-white/5 bg-white/5 px-3 py-2">
              <span class="mt-1 h-2 w-2 shrink-0 rounded-full bg-cyan-300 shadow-[0_0_16px_rgba(34,211,238,0.8)]" />
              <span>{{ item }}</span>
            </li>
          </ul>
        </div>
      </div>
    </header>

    <section class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
      <article v-for="stat in stats" :key="stat.label" class="raven-card p-5">
        <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">{{ stat.label }}</p>
        <h2 class="mt-3 text-xl font-semibold text-white">{{ stat.value }}</h2>
        <p class="mt-2 text-sm leading-6 text-slate-300">{{ stat.note }}</p>
      </article>
    </section>

    <section class="space-y-5">
      <div class="flex items-end justify-between gap-4">
        <div>
          <p class="text-xs uppercase tracking-[0.34em] text-slate-400">Phase map</p>
          <h2 class="mt-2 text-2xl font-semibold tracking-[-0.04em] text-white sm:text-3xl">
            Past, present, and future stay separate.
          </h2>
        </div>
      </div>

      <TabsRoot defaultValue="past" class="space-y-5">
        <TabList class="raven-tabs__list">
          <TabTrigger v-for="phase in phases" :key="phase.id" :value="phase.id" class="raven-tabs__trigger">
            <span class="text-xs uppercase tracking-[0.28em] text-current/80">{{ phase.label }}</span>
          </TabTrigger>
        </TabList>

        <div class="grid gap-5 lg:grid-cols-[1.15fr_0.85fr]">
          <div class="space-y-5">
            <TabContent v-for="phase in phases" :key="phase.id" :value="phase.id">
              <article :id="phase.id" class="raven-card p-6 sm:p-7">
                <div class="flex flex-wrap items-center justify-between gap-3">
                  <p class="text-[11px] uppercase tracking-[0.3em] text-cyan-100/70">
                    {{ phase.signal }}
                  </p>
                  <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-[11px] uppercase tracking-[0.22em] text-slate-300">
                    {{ phase.label }}
                  </span>
                </div>

                <h3 class="mt-4 text-3xl font-semibold tracking-[-0.05em] text-white sm:text-4xl">
                  {{ phase.title }}
                </h3>

                <p class="mt-4 max-w-2xl text-base leading-7 text-slate-300">
                  {{ phase.summary }}
                </p>

                <ul class="mt-6 grid gap-3 sm:grid-cols-2">
                  <li
                    v-for="bullet in phase.bullets"
                    :key="bullet"
                    class="rounded-2xl border border-white/8 bg-slate-950/45 px-4 py-3 text-sm leading-6 text-slate-200"
                  >
                    {{ bullet }}
                  </li>
                </ul>
              </article>
            </TabContent>
          </div>

          <aside class="space-y-5">
            <article class="raven-card p-6">
              <p class="text-[11px] uppercase tracking-[0.3em] text-slate-400">Operational rule</p>
              <h3 class="mt-3 text-xl font-semibold text-white">Never mix observed money with planned money.</h3>
              <p class="mt-3 text-sm leading-6 text-slate-300">
                Raven keeps raw truth, classified truth, and projected truth in separate layers so the app
                stays honest as it grows.
              </p>
            </article>

            <article class="raven-card p-6">
              <p class="text-[11px] uppercase tracking-[0.3em] text-slate-400">Environments</p>
              <div class="mt-4 space-y-3">
                <div v-for="environment in environmentCards" :key="environment.name" class="rounded-2xl border border-white/8 bg-white/5 p-4">
                  <div class="flex items-center justify-between gap-3">
                    <h3 class="text-lg font-semibold text-white">{{ environment.name }}</h3>
                    <span class="rounded-full border border-cyan-400/20 bg-cyan-400/10 px-2.5 py-1 text-[10px] uppercase tracking-[0.24em] text-cyan-100">
                      Focus
                    </span>
                  </div>
                  <p class="mt-1 text-xs uppercase tracking-[0.26em] text-slate-400">{{ environment.title }}</p>
                  <p class="mt-3 text-sm leading-6 text-slate-300">{{ environment.description }}</p>
                </div>
              </div>
            </article>

            <article class="raven-card p-6">
              <p class="text-[11px] uppercase tracking-[0.3em] text-slate-400">MCP / Database</p>
              <h3 class="mt-3 text-xl font-semibold text-white">Local SurrealDB is already the anchor.</h3>
              <p class="mt-3 text-sm leading-6 text-slate-300">
                The schema workspace includes the Raven MCP compose file wired to the local database, so
                the agent can query the same truth layer that powers the app.
              </p>
              <dl class="mt-4 grid gap-3 text-sm">
                <div class="rounded-2xl border border-white/8 bg-slate-950/45 p-4">
                  <dt class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Namespace</dt>
                  <dd class="mt-1 text-slate-100">raven</dd>
                </div>
                <div class="rounded-2xl border border-white/8 bg-slate-950/45 p-4">
                  <dt class="text-[11px] uppercase tracking-[0.24em] text-slate-400">Database</dt>
                  <dd class="mt-1 text-slate-100">raven1</dd>
                </div>
              </dl>
            </article>
          </aside>
        </div>
      </TabsRoot>
    </section>

    <section class="grid gap-5 xl:grid-cols-[1fr_1fr]">
      <article class="raven-card p-6">
        <p class="text-[11px] uppercase tracking-[0.3em] text-slate-400">Model spine</p>
        <h2 class="mt-3 text-2xl font-semibold tracking-[-0.04em] text-white">The first schema chain</h2>
        <div class="mt-5 space-y-3">
          <div v-for="item in modelSpine" :key="item.name" class="rounded-2xl border border-white/8 bg-white/5 p-4">
            <h3 class="text-sm font-semibold text-cyan-100">{{ item.name }}</h3>
            <p class="mt-2 text-sm leading-6 text-slate-300">{{ item.description }}</p>
          </div>
        </div>
      </article>

      <article class="raven-card p-6">
        <p class="text-[11px] uppercase tracking-[0.3em] text-slate-400">What this becomes</p>
        <h2 class="mt-3 text-2xl font-semibold tracking-[-0.04em] text-white">
          A calm control room for money, not a noisy dashboard.
        </h2>
        <p class="mt-4 max-w-2xl text-sm leading-7 text-slate-300">
          The first version should stay simple: accounts, statements, transactions, clarifications, and
          snapshots. Everything else builds on top of that spine.
        </p>

        <div class="mt-6 grid gap-3 sm:grid-cols-2">
          <div class="rounded-2xl border border-cyan-400/15 bg-cyan-400/8 p-4">
            <p class="text-[11px] uppercase tracking-[0.24em] text-cyan-100/80">Immediate</p>
            <p class="mt-2 text-sm leading-6 text-slate-100">Import a statement and map it to an account.</p>
          </div>
          <div class="rounded-2xl border border-emerald-400/15 bg-emerald-400/8 p-4">
            <p class="text-[11px] uppercase tracking-[0.24em] text-emerald-100/80">Next</p>
            <p class="mt-2 text-sm leading-6 text-slate-100">Turn ambiguity into a clarification queue.</p>
          </div>
        </div>
      </article>
    </section>
  </section>
</template>

<style scoped>
.raven-card {
  border-radius: 1.5rem;
  border: 1px solid rgba(148, 163, 184, 0.16);
  background:
    linear-gradient(180deg, rgba(10, 16, 30, 0.92), rgba(5, 10, 18, 0.82));
  box-shadow:
    0 24px 80px rgba(0, 0, 0, 0.34),
    inset 0 1px 0 rgba(255, 255, 255, 0.04);
  backdrop-filter: blur(22px);
}

.raven-status-pill {
  border-radius: 9999px;
  border: 1px solid rgba(148, 163, 184, 0.16);
  background: rgba(255, 255, 255, 0.04);
  padding: 0.6rem 0.9rem;
  color: rgba(226, 232, 240, 0.82);
}

.raven-status-pill--cyan {
  border-color: rgba(34, 211, 238, 0.22);
  background: rgba(34, 211, 238, 0.1);
  color: rgba(207, 250, 254, 0.95);
}

.raven-status-pill--emerald {
  border-color: rgba(16, 185, 129, 0.22);
  background: rgba(16, 185, 129, 0.1);
  color: rgba(209, 250, 229, 0.96);
}

.raven-link {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 9999px;
  border: 1px solid rgba(34, 211, 238, 0.26);
  background: linear-gradient(180deg, rgba(34, 211, 238, 0.18), rgba(59, 130, 246, 0.12));
  padding: 0.9rem 1.2rem;
  font-size: 0.875rem;
  font-weight: 600;
  color: rgba(236, 254, 255, 0.96);
  transition: transform 160ms ease, border-color 160ms ease, background 160ms ease, box-shadow 160ms ease;
}

.raven-link:hover {
  transform: translateY(-1px);
  border-color: rgba(103, 232, 249, 0.42);
  box-shadow: 0 0 0 1px rgba(34, 211, 238, 0.12) inset;
}

.raven-link--ghost {
  border-color: rgba(148, 163, 184, 0.2);
  background: rgba(255, 255, 255, 0.04);
  color: rgba(226, 232, 240, 0.9);
}

.raven-tabs__list {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  border-radius: 9999px;
  border: 1px solid rgba(148, 163, 184, 0.16);
  background: rgba(7, 11, 20, 0.76);
  padding: 0.5rem;
  backdrop-filter: blur(20px);
}

.raven-tabs__trigger {
  border: 1px solid transparent;
  border-radius: 9999px;
  padding: 0.85rem 1rem;
  color: rgba(203, 213, 225, 0.76);
  transition: border-color 160ms ease, color 160ms ease, background 160ms ease, box-shadow 160ms ease;
}

.raven-tabs__trigger:hover {
  color: rgba(248, 250, 252, 0.94);
}

.raven-tabs__trigger[aria-selected='true'] {
  border-color: rgba(34, 211, 238, 0.26);
  background: linear-gradient(180deg, rgba(34, 211, 238, 0.18), rgba(59, 130, 246, 0.09));
  color: rgba(248, 250, 252, 0.98);
  box-shadow: 0 0 0 1px rgba(34, 211, 238, 0.08) inset;
}
</style>
