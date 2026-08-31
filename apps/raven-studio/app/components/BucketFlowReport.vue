<script setup lang="ts">
import { storeToRefs } from 'pinia'

const emit = defineEmits<{
  close: []
}>()

const store = useBucketsPrototypeStore()
const { flowReport, scenarioMinor } = storeToRefs(store)
const ruleMovements = computed(() => flowReport.value.filter(entry => entry.kind === 'rule').length)
const expenseMovements = computed(() =>
  flowReport.value.filter(entry => entry.kind === 'expense' || entry.kind === 'budget').length,
)

function formatMinor(value: number) {
  return new Intl.NumberFormat('en-ZA', {
    style: 'currency',
    currency: 'ZAR',
    currencyDisplay: 'narrowSymbol',
    maximumFractionDigits: 0,
  }).format(Math.abs(value) / 100)
}

function formatMovement(value: number) {
  if (value === 0) return '—'
  return `${value > 0 ? '+' : '−'}${formatMinor(value)}`
}
</script>

<template>
  <section class="bucket-flow-report raven-surface" aria-label="Flow report">
    <header class="bucket-flow-report__intro">
      <div>
        <span class="raven-eyebrow">Transaction report</span>
        <h2>How this scenario moves, line by line</h2>
        <p>Each row explains one allocation, deduction, remainder, or rule transfer without replacing the canvas or table.</p>
      </div>
      <div class="bucket-flow-report__summary">
        <span><small>Source</small><strong>{{ formatMinor(scenarioMinor) }}</strong></span>
        <span><small>Expense steps</small><strong>{{ expenseMovements }}</strong></span>
        <span><small>Rule movements</small><strong>{{ ruleMovements }}</strong></span>
        <button class="raven-icon-button" type="button" aria-label="Close flow report" title="Close report" @click="emit('close')">
          <span class="i-lucide-x" aria-hidden="true" />
        </button>
      </div>
    </header>

    <div class="bucket-flow-report__scroll">
      <header class="bucket-flow-report__columns">
        <span>Step</span>
        <span>Movement</span>
        <span>Opening</span>
        <span>Change</span>
        <span>Closing</span>
      </header>
      <ol>
        <li
          v-for="entry in flowReport"
          :key="entry.id"
          :class="`is-${entry.kind}`"
        >
          <span class="bucket-flow-report__step">{{ String(entry.step).padStart(2, '0') }}</span>
          <span class="bucket-flow-report__subject">
            <i aria-hidden="true" />
            <span><strong>{{ entry.subject }}</strong><small>{{ entry.detail }}</small></span>
          </span>
          <span>{{ formatMinor(entry.openingMinor) }}</span>
          <strong class="bucket-flow-report__movement">{{ formatMovement(entry.movementMinor) }}</strong>
          <span>{{ formatMinor(entry.closingMinor) }}</span>
        </li>
      </ol>
    </div>

    <footer>
      <span class="i-lucide-shield-check" aria-hidden="true" />
      <p><strong>Projection only.</strong> These entries explain the active model; they are not observed bank transactions or persisted ledger records.</p>
    </footer>
  </section>
</template>

<style scoped>
.bucket-flow-report {
  min-width: 0;
  overflow: hidden;
}

.bucket-flow-report__intro {
  min-height: 76px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  border-bottom: 1px solid var(--raven-border);
  padding: 14px;
}

.bucket-flow-report__intro > div:first-child {
  display: grid;
  gap: 4px;
}

.bucket-flow-report__intro h2 {
  margin: 0;
  font-size: 15px;
}

.bucket-flow-report__intro p {
  margin: 0;
  color: var(--raven-faint);
  font-size: 9px;
}

.bucket-flow-report__summary {
  display: flex;
  align-items: center;
  gap: 18px;
}

.bucket-flow-report__summary > span {
  display: grid;
  gap: 3px;
}

.bucket-flow-report__summary small {
  color: var(--raven-faint);
  font-size: 8px;
  text-transform: uppercase;
}

.bucket-flow-report__summary strong {
  color: var(--raven-text);
  font-size: 11px;
}

.bucket-flow-report__scroll {
  overflow-x: auto;
}

.bucket-flow-report__columns,
.bucket-flow-report li {
  min-width: 760px;
  display: grid;
  grid-template-columns: 46px minmax(320px, 2fr) minmax(90px, 0.7fr) minmax(90px, 0.7fr) minmax(90px, 0.7fr);
  align-items: center;
  gap: 12px;
}

.bucket-flow-report__columns {
  min-height: 32px;
  border-bottom: 1px solid var(--raven-border-subtle);
  padding: 0 14px;
  color: var(--raven-faint);
  font-size: 8px;
  font-weight: 800;
  letter-spacing: 0.045em;
  text-transform: uppercase;
}

.bucket-flow-report ol {
  margin: 0;
  padding: 0;
  list-style: none;
}

.bucket-flow-report li {
  position: relative;
  min-height: 48px;
  border-bottom: 1px solid var(--raven-border-subtle);
  padding: 0 14px;
  color: var(--raven-muted);
  font-size: 10px;
}

.bucket-flow-report li:last-child {
  border-bottom: 0;
}

.bucket-flow-report li:hover {
  background: color-mix(in srgb, var(--raven-panel-raised) 72%, transparent);
}

.bucket-flow-report__step {
  color: var(--raven-faint);
  font-size: 8px;
  font-weight: 800;
}

.bucket-flow-report__subject {
  min-width: 0;
  display: flex;
  align-items: center;
  gap: 9px;
}

.bucket-flow-report__subject > i {
  width: 7px;
  height: 7px;
  flex: 0 0 auto;
  border-radius: 50%;
  background: var(--raven-accent);
}

.bucket-flow-report__subject > span {
  min-width: 0;
  display: grid;
  gap: 2px;
}

.bucket-flow-report__subject strong {
  overflow: hidden;
  color: var(--raven-text);
  font-size: 10px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.bucket-flow-report__subject small {
  overflow: hidden;
  color: var(--raven-faint);
  font-size: 8px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.bucket-flow-report__movement {
  color: var(--raven-accent);
}

.bucket-flow-report li.is-expense .bucket-flow-report__subject > i,
.bucket-flow-report li.is-expense .bucket-flow-report__movement {
  color: var(--raven-danger);
  background: var(--raven-danger);
}

.bucket-flow-report li.is-budget .bucket-flow-report__subject > i,
.bucket-flow-report li.is-budget .bucket-flow-report__movement {
  color: var(--raven-warning);
  background: var(--raven-warning);
}

.bucket-flow-report li.is-rule {
  background: color-mix(in srgb, #5363d9 7%, transparent);
}

.bucket-flow-report li.is-rule .bucket-flow-report__subject > i,
.bucket-flow-report li.is-rule .bucket-flow-report__movement {
  color: #9ca5ff;
  background: #8792ff;
}

.bucket-flow-report footer {
  min-height: 42px;
  display: flex;
  align-items: center;
  gap: 9px;
  border-top: 1px solid var(--raven-border);
  padding: 8px 14px;
  color: var(--raven-faint);
}

.bucket-flow-report footer > span {
  color: var(--raven-accent);
}

.bucket-flow-report footer p {
  margin: 0;
  font-size: 8px;
}

.bucket-flow-report footer strong {
  color: var(--raven-muted);
}

@media (max-width: 760px) {
  .bucket-flow-report__intro {
    align-items: start;
    flex-direction: column;
  }

  .bucket-flow-report__summary {
    width: 100%;
    flex-wrap: wrap;
  }

  .bucket-flow-report__summary .raven-icon-button {
    margin-left: auto;
  }
}
</style>
