<script setup lang="ts">
import { storeToRefs } from 'pinia'
import type { BucketPrototypeNode } from '~/types/buckets'

useHead({ title: 'Buckets · Raven' })

const store = useBucketsPrototypeStore()
const {
  buckets,
  scenarioMinor,
  viewMode,
  selectedId,
  inspectorOpen,
  collapsedIds,
} = storeToRefs(store)

const draggingId = ref<string | null>(null)
const amountInput = ref(scenarioMinor.value / 100)
const editorOpen = ref(false)
const editorZoom = ref(1)
const reportOpen = ref(false)
const editorCanvas = ref<{ focusGraph: () => Promise<void> } | null>(null)
const collapsedSet = computed(() => new Set(collapsedIds.value))

watch(scenarioMinor, value => {
  amountInput.value = value / 100
})

function formatMinor(value: number) {
  return new Intl.NumberFormat('en-ZA', {
    style: 'currency',
    currency: 'ZAR',
    currencyDisplay: 'narrowSymbol',
    maximumFractionDigits: 0,
  }).format(value / 100)
}

function applyStartingAmount() {
  store.setScenarioRands(Number(amountInput.value))
}

function selectNode(nodeOrId: BucketPrototypeNode | string) {
  store.selectNode(typeof nodeOrId === 'string' ? nodeOrId : nodeOrId.id)
}

function plannedNow(node: BucketPrototypeNode) {
  return formatMinor(store.metricFor(node).receivedMinor)
}

function projected(node: BucketPrototypeNode) {
  const metric = store.metricFor(node)
  return formatMinor(node.allocationKind === 'source' ? metric.unallocatedMinor : metric.remainingAfterMinor)
}

function dropBefore(targetId: string) {
  if (!draggingId.value) return
  store.moveBefore(draggingId.value, targetId)
  draggingId.value = null
}

async function openEditor() {
  editorOpen.value = true
  inspectorOpen.value = true
  await nextTick()
  await editorCanvas.value?.focusGraph()
}

function closeEditor() {
  editorOpen.value = false
}

function changeZoom(delta: number) {
  editorZoom.value = Math.min(1.6, Math.max(0.5, Number((editorZoom.value + delta).toFixed(2))))
}

async function fitEditor() {
  editorZoom.value = 0.85
  await nextTick()
  await editorCanvas.value?.focusGraph()
}

function handleEditorKeydown(event: KeyboardEvent) {
  if (event.key === 'Escape' && editorOpen.value) closeEditor()
}

const routedMinor = computed(() => {
  const root = buckets.value[0]
  return root ? scenarioMinor.value - store.metricFor(root).unallocatedMinor : 0
})

watch(editorOpen, (open) => {
  if (import.meta.client) document.documentElement.style.overflow = open ? 'hidden' : ''
})

onMounted(() => window.addEventListener('keydown', handleEditorKeydown))
onBeforeUnmount(() => {
  window.removeEventListener('keydown', handleEditorKeydown)
  if (import.meta.client) document.documentElement.style.overflow = ''
})
</script>

<template>
  <div class="buckets-page">
    <header class="buckets-workspace-header">
      <div class="buckets-workspace-header__intro">
        <h1>Buckets</h1>
        <p>Design how one month of money moves, then inspect the same plan as nodes or a recursive table.</p>
      </div>

      <div class="buckets-workspace-header__controls">
        <label class="buckets-amount">
          <span>Starting amount</span>
          <div>
            <b>R</b>
            <input
              v-model.number="amountInput"
              type="number"
              min="0"
              max="100000000"
              step="1000"
              inputmode="decimal"
              @change="applyStartingAmount"
              @keydown.enter.prevent="applyStartingAmount"
            >
          </div>
        </label>

        <div class="buckets-view-switch" role="group" aria-label="Bucket workspace view">
          <button
            type="button"
            :class="{ active: viewMode === 'nodes' }"
            :aria-pressed="viewMode === 'nodes'"
            @click="viewMode = 'nodes'"
          >
            <span class="i-lucide-git-fork" aria-hidden="true" />
            Nodes
          </button>
          <button
            type="button"
            :class="{ active: viewMode === 'table' }"
            :aria-pressed="viewMode === 'table'"
            @click="viewMode = 'table'"
          >
            <span class="i-lucide-rows-3" aria-hidden="true" />
            Table
          </button>
        </div>

        <button
          class="buckets-report-toggle raven-button"
          :class="{ active: reportOpen }"
          type="button"
          :aria-pressed="reportOpen"
          @click="reportOpen = !reportOpen"
        >
          <span class="i-lucide-scroll-text" aria-hidden="true" />
          Flow report
        </button>

        <button class="raven-icon-button" type="button" title="Reset plan" aria-label="Reset plan" @click="store.resetPrototype">
          <span class="i-lucide-rotate-ccw" aria-hidden="true" />
        </button>
        <button class="raven-button raven-button--primary" type="button" @click="store.addExpenseNode">
          <span class="i-lucide-plus" aria-hidden="true" />
          Node
        </button>
      </div>
    </header>

    <section class="buckets-context-strip" aria-label="Projection context">
      <span><i class="i-lucide-calendar-range" aria-hidden="true" /> One-month projection</span>
      <span><i class="i-lucide-circle-dollar-sign" aria-hidden="true" /> {{ formatMinor(scenarioMinor) }} enters</span>
      <span><i class="i-lucide-route" aria-hidden="true" /> {{ formatMinor(routedMinor) }} explicitly routed</span>
      <strong>Virtual plan · observed balances stay untouched</strong>
    </section>

    <div class="buckets-layout" :class="{ 'buckets-layout--inspector-closed': !inspectorOpen }">
      <main class="buckets-workspace">
        <BucketCircuitCanvas
          v-if="viewMode === 'nodes'"
          show-editor-button
          marker-id="bucket-circuit-arrow-overview"
          @open-editor="openEditor"
        />

        <section v-else class="buckets-table raven-surface">
          <header class="buckets-table__intro">
            <div>
              <span class="raven-eyebrow">Table view</span>
              <strong>The same circuit, expressed as hierarchy and order</strong>
            </div>
            <p>Indentation shows containment. Groups can fold context without owning the routing relationships inside them.</p>
          </header>

          <div class="buckets-table__scroll">
            <header class="buckets-table__columns">
              <span>Flow structure</span>
              <span>Allocation rule</span>
              <span>Receives</span>
              <span>After step</span>
              <span>State</span>
              <span />
            </header>
            <div class="buckets-tree" role="tree" aria-label="Bucket plan hierarchy">
              <BucketTreeRow
                v-for="node in buckets"
                :key="node.id"
                :node="node"
                :selected-id="selectedId"
                :collapsed-ids="collapsedSet"
                :planned-now="plannedNow"
                :projected="projected"
                @select="selectNode"
                @toggle="store.toggleNode"
                @rename="store.renameNode"
                @drag-start="draggingId = $event"
                @drop="dropBefore"
              />
            </div>
          </div>

          <footer class="buckets-table__footer">
            <span class="buckets-quality-dot" />
            <div>
              <strong>{{ formatMinor(routedMinor) }} routed through one shared plan</strong>
              <small>Canvas and table are synchronized surfaces over the same local planning tree.</small>
            </div>
          </footer>
        </section>

        <BucketFlowReport v-if="reportOpen" @close="reportOpen = false" />

        <aside class="buckets-truth-boundary">
          <strong>Plan truth boundary</strong>
          <span>This plan starts blank and does not alter observed transactions, account balances, or accepted cashflow evidence.</span>
        </aside>
      </main>

      <button
        v-if="!inspectorOpen"
        class="buckets-inspector-reopen raven-icon-button"
        type="button"
        aria-label="Open node inspector"
        title="Open node inspector"
        @click="inspectorOpen = true"
      >
        <span class="i-lucide-panel-right-open" aria-hidden="true" />
      </button>

      <BucketNodeInspector v-else />
    </div>

    <Teleport to="body">
      <div
        v-if="editorOpen"
        class="circuit-editor"
        role="dialog"
        aria-modal="true"
        aria-label="Circuit editor"
      >
        <header class="circuit-editor__toolbar">
          <div class="circuit-editor__identity">
            <span class="i-lucide-git-fork" aria-hidden="true" />
            <div>
              <p class="raven-eyebrow">Creative mode</p>
              <h2>Circuit editor</h2>
            </div>
          </div>

          <label class="circuit-editor__amount">
            <span>Starting amount</span>
            <div>
              <b>R</b>
              <input
                v-model.number="amountInput"
                type="number"
                min="0"
                max="100000000"
                step="1000"
                inputmode="decimal"
                @change="applyStartingAmount"
                @keydown.enter.prevent="applyStartingAmount"
              >
            </div>
          </label>

          <div class="circuit-editor__zoom" role="group" aria-label="Canvas zoom">
            <button type="button" aria-label="Zoom out" title="Zoom out" @click="changeZoom(-0.1)">
              <span class="i-lucide-zoom-out" aria-hidden="true" />
            </button>
            <output aria-live="polite">{{ Math.round(editorZoom * 100) }}%</output>
            <button type="button" aria-label="Zoom in" title="Zoom in" @click="changeZoom(0.1)">
              <span class="i-lucide-zoom-in" aria-hidden="true" />
            </button>
            <button type="button" title="Fit canvas" @click="fitEditor">
              Fit
            </button>
          </div>

          <button class="raven-icon-button" type="button" title="Reset plan" aria-label="Reset plan" @click="store.resetPrototype">
            <span class="i-lucide-rotate-ccw" aria-hidden="true" />
          </button>
          <button class="raven-button raven-button--primary" type="button" @click="store.addExpenseNode">
            <span class="i-lucide-plus" aria-hidden="true" />
            Node
          </button>
          <button class="raven-icon-button" type="button" title="Close editor" aria-label="Close circuit editor" @click="closeEditor">
            <span class="i-lucide-x" aria-hidden="true" />
          </button>
        </header>

        <div class="circuit-editor__body" :class="{ 'circuit-editor__body--inspector-closed': !inspectorOpen }">
          <BucketCircuitCanvas
            ref="editorCanvas"
            immersive
            :zoom="editorZoom"
            marker-id="bucket-circuit-arrow-editor"
            @zoom-change="editorZoom = $event"
          />

          <button
            v-if="!inspectorOpen"
            class="circuit-editor__inspector-reopen raven-icon-button"
            type="button"
            aria-label="Open node inspector"
            title="Open node inspector"
            @click="inspectorOpen = true"
          >
            <span class="i-lucide-panel-right-open" aria-hidden="true" />
          </button>
          <BucketNodeInspector v-else class="circuit-editor__inspector" />
        </div>
      </div>
    </Teleport>
  </div>
</template>

<style scoped>
.buckets-page {
  display: grid;
  gap: 14px;
  padding-bottom: 36px;
}

.buckets-workspace-header {
  position: sticky;
  top: 0;
  z-index: 20;
  min-height: 88px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 28px;
  margin: -24px -24px 0;
  border-bottom: 1px solid var(--raven-border);
  padding: 16px 24px;
  background: color-mix(in srgb, var(--raven-bg) 92%, transparent);
  backdrop-filter: blur(16px);
}

.buckets-workspace-header__intro h1 {
  margin: 0;
  font-size: clamp(26px, 2.6vw, 34px);
  line-height: 1;
}

.buckets-workspace-header__intro p {
  max-width: 660px;
  margin: 8px 0 0;
  color: var(--raven-muted);
  font-size: 12px;
}

.buckets-workspace-header__controls {
  display: flex;
  align-items: end;
  gap: 8px;
}

.buckets-amount {
  display: grid;
  gap: 5px;
}

.buckets-amount > span {
  color: var(--raven-faint);
  font-size: 9px;
  font-weight: 750;
  text-transform: uppercase;
}

.buckets-amount > div {
  width: 156px;
  height: 38px;
  display: flex;
  align-items: center;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-sm);
  background: var(--raven-panel);
}

.buckets-amount b {
  padding-left: 11px;
  color: var(--raven-accent);
  font-size: 11px;
}

.buckets-amount input {
  width: 100%;
  min-width: 0;
  height: 100%;
  border: 0;
  padding: 0 10px 0 5px;
  background: transparent;
  color: var(--raven-text);
  font-weight: 700;
  outline: 0;
}

.buckets-view-switch {
  height: 38px;
  display: flex;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-sm);
  padding: 3px;
  background: var(--raven-panel);
}

.buckets-view-switch button {
  min-width: 76px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  border: 0;
  border-radius: 5px;
  padding: 0 10px;
  background: transparent;
  color: var(--raven-faint);
  cursor: pointer;
  font-size: 11px;
  font-weight: 650;
}

.buckets-view-switch button.active {
  background: var(--raven-panel-subtle);
  color: var(--raven-text);
  box-shadow: inset 0 0 0 1px var(--raven-border);
}

.buckets-report-toggle {
  height: 38px;
  color: var(--raven-faint);
}

.buckets-report-toggle.active {
  border-color: color-mix(in srgb, var(--raven-accent) 52%, var(--raven-border));
  color: var(--raven-accent);
  background: color-mix(in srgb, var(--raven-accent-soft) 72%, transparent);
}

.buckets-context-strip {
  min-height: 34px;
  display: flex;
  align-items: center;
  gap: 22px;
  border-bottom: 1px solid var(--raven-border-subtle);
  color: var(--raven-faint);
  font-size: 9px;
  font-weight: 700;
  text-transform: uppercase;
}

.buckets-context-strip span {
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.buckets-context-strip i {
  color: var(--raven-accent);
}

.buckets-context-strip strong {
  margin-left: auto;
  color: var(--raven-muted);
  font-size: inherit;
}

.buckets-layout {
  min-width: 0;
  display: grid;
  grid-template-columns: minmax(0, 1fr) 310px;
  gap: 18px;
  align-items: start;
}

.buckets-layout--inspector-closed {
  grid-template-columns: minmax(0, 1fr) auto;
}

.buckets-workspace {
  min-width: 0;
  display: grid;
  gap: 12px;
}

.buckets-table__intro {
  min-height: 58px;
  display: flex;
  align-items: center;
  gap: 18px;
  border-bottom: 1px solid var(--raven-border);
  padding: 10px 14px;
}

.buckets-table__intro > div {
  display: grid;
  gap: 3px;
}

.buckets-table__intro strong {
  font-size: 12px;
}

.buckets-table__intro p {
  max-width: 470px;
  margin: 0;
  color: var(--raven-faint);
  font-size: 10px;
}

.buckets-table {
  min-width: 0;
  overflow: hidden;
}

.buckets-table__scroll {
  overflow-x: auto;
}

.buckets-table__columns {
  min-width: 760px;
  min-height: 34px;
  display: grid;
  grid-template-columns:
    minmax(280px, 2fr)
    minmax(120px, 1fr)
    minmax(80px, 0.66fr)
    minmax(95px, 0.74fr)
    76px
    16px;
  align-items: center;
  gap: 10px;
  border-bottom: 1px solid var(--raven-border);
  padding: 0 0 0 8px;
  color: var(--raven-faint);
  font-size: 8px;
  font-weight: 800;
  letter-spacing: 0.045em;
  text-transform: uppercase;
}

.buckets-table__columns span:nth-child(5) {
  text-align: right;
}

.buckets-table__footer {
  min-height: 58px;
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 14px;
}

.buckets-table__footer div {
  display: grid;
  gap: 2px;
}

.buckets-table__footer strong {
  font-size: 11px;
}

.buckets-table__footer small {
  color: var(--raven-faint);
  font-size: 9px;
}

.buckets-quality-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: var(--raven-accent);
}

.buckets-truth-boundary {
  display: grid;
  grid-template-columns: auto 1fr;
  gap: 12px;
  border: 1px solid color-mix(in srgb, var(--raven-accent) 30%, var(--raven-border));
  border-radius: var(--raven-radius-sm);
  padding: 10px 12px;
  color: var(--raven-faint);
  font-size: 9px;
}

.buckets-truth-boundary strong {
  color: var(--raven-accent);
  text-transform: uppercase;
}

.circuit-editor {
  position: fixed;
  inset: 0;
  z-index: 100;
  display: grid;
  grid-template-rows: 64px minmax(0, 1fr);
  background: #040504;
  color: var(--raven-text);
}

.circuit-editor__toolbar {
  position: relative;
  z-index: 2;
  display: flex;
  align-items: center;
  gap: 9px;
  border-bottom: 1px solid var(--raven-border);
  padding: 8px 12px;
  background: color-mix(in srgb, var(--raven-bg) 94%, transparent);
  box-shadow: 0 12px 32px rgb(0 0 0 / 0.24);
  backdrop-filter: blur(18px);
}

.circuit-editor__identity {
  min-width: 210px;
  display: flex;
  align-items: center;
  gap: 10px;
  margin-right: auto;
}

.circuit-editor__identity > span {
  width: 36px;
  height: 36px;
  display: grid;
  place-items: center;
  border: 1px solid color-mix(in srgb, var(--raven-accent) 48%, var(--raven-border));
  border-radius: 8px;
  color: var(--raven-accent);
  background: var(--raven-accent-soft);
  font-size: 16px;
}

.circuit-editor__identity div {
  display: grid;
  gap: 2px;
}

.circuit-editor__identity h2 {
  margin: 0;
  font-size: 15px;
}

.circuit-editor__amount {
  display: flex;
  align-items: center;
  gap: 8px;
}

.circuit-editor__amount > span {
  color: var(--raven-faint);
  font-size: 8px;
  font-weight: 750;
  text-transform: uppercase;
}

.circuit-editor__amount > div {
  width: 132px;
  height: 36px;
  display: flex;
  align-items: center;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-sm);
  background: var(--raven-panel);
}

.circuit-editor__amount b {
  padding-left: 10px;
  color: var(--raven-accent);
  font-size: 10px;
}

.circuit-editor__amount input {
  width: 100%;
  min-width: 0;
  height: 100%;
  border: 0;
  padding: 0 8px 0 4px;
  background: transparent;
  color: var(--raven-text);
  font-size: 11px;
  font-weight: 700;
  outline: 0;
}

.circuit-editor__zoom {
  height: 36px;
  display: flex;
  align-items: center;
  overflow: hidden;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-sm);
  background: var(--raven-panel);
}

.circuit-editor__zoom button {
  height: 100%;
  min-width: 34px;
  display: grid;
  place-items: center;
  border: 0;
  border-right: 1px solid var(--raven-border-subtle);
  padding: 0 9px;
  background: transparent;
  color: var(--raven-muted);
  cursor: pointer;
  font-size: 10px;
}

.circuit-editor__zoom button:hover {
  background: var(--raven-panel-subtle);
  color: var(--raven-text);
}

.circuit-editor__zoom output {
  min-width: 48px;
  color: var(--raven-text);
  font-size: 9px;
  font-weight: 750;
  text-align: center;
}

.circuit-editor__body {
  min-width: 0;
  min-height: 0;
  display: grid;
  grid-template-columns: minmax(0, 1fr) 310px;
}

.circuit-editor__body--inspector-closed {
  grid-template-columns: minmax(0, 1fr) auto;
}

.circuit-editor__body > :deep(.circuit-shell) {
  min-height: 0;
  border: 0;
}

.circuit-editor__inspector {
  min-height: 0;
  padding: 18px !important;
  background: var(--raven-bg);
}

.circuit-editor__body > :deep(.buckets-inspector) {
  position: static;
  top: auto;
  width: 310px;
  height: 100%;
  max-height: none;
  padding: 18px;
}

.circuit-editor__inspector-reopen {
  align-self: start;
  margin: 14px 12px 0;
}

.buckets-inspector-reopen {
  position: sticky;
  top: 104px;
}

@media (max-width: 1120px) {
  .buckets-workspace-header {
    position: relative;
    top: auto;
    align-items: start;
    flex-direction: column;
  }

  .buckets-layout {
    grid-template-columns: 1fr;
  }

}

@media (max-width: 720px) {
  .buckets-workspace-header__controls {
    width: 100%;
    flex-wrap: wrap;
  }

  .buckets-amount,
  .buckets-amount > div {
    width: 100%;
  }

  .buckets-context-strip {
    align-items: start;
    flex-direction: column;
    gap: 6px;
    padding: 8px 0;
  }

  .buckets-context-strip strong {
    margin-left: 0;
  }

  .buckets-table__intro {
    align-items: start;
    flex-direction: column;
  }

  .circuit-editor__toolbar {
    overflow-x: auto;
  }

  .circuit-editor__identity {
    min-width: 170px;
  }

  .circuit-editor__amount > span {
    display: none;
  }

  .circuit-editor__body {
    grid-template-columns: minmax(0, 1fr);
  }

  .circuit-editor__body > :deep(.buckets-inspector) {
    display: none;
  }
}
</style>
