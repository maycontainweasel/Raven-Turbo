<script setup lang="ts">
import { storeToRefs } from 'pinia'

const store = useBucketsPrototypeStore()
const { selectedBucket, selectedParent, inspectorOpen, collapsedIds } = storeToRefs(store)
const selectedMetric = computed(() => store.metricFor(selectedBucket.value))
const directChildren = computed(() =>
  (selectedBucket.value.children ?? []).filter(child => child.allocationKind !== 'remainder'),
)
const parentSiblings = computed(() =>
  (selectedParent.value?.children ?? []).filter(child => child.allocationKind !== 'remainder'),
)
const routedParent = computed(() =>
  selectedBucket.value.presentation === 'group' ? null : selectedParent.value,
)
const routedChildren = computed(() =>
  selectedBucket.value.presentation === 'group' ? [] : directChildren.value,
)
const parentSearch = ref('')
const parentPickerOpen = ref(false)
const parentOptions = computed(() => store.parentOptionsFor(selectedBucket.value.id))
const filteredParentOptions = computed(() => {
  const query = parentSearch.value.trim().toLocaleLowerCase()
  return query
    ? parentOptions.value.filter(option =>
        `${option.name} ${option.kind}`.toLocaleLowerCase().includes(query),
      )
    : parentOptions.value
})
const groupFrame = computed(() => store.groupFrameFor(selectedBucket.value.id))
const groupCollapsed = computed(() => collapsedIds.value.includes(selectedBucket.value.id))
const expenseLifecycles = [
  { value: 'one-off', label: 'One-off', icon: 'i-lucide-circle-dot' },
  { value: 'recurring', label: 'Recurring', icon: 'i-lucide-repeat-2' },
  { value: 'payoff', label: 'Payoff', icon: 'i-lucide-goal' },
] as const

function formatMinor(value: number) {
  return new Intl.NumberFormat('en-ZA', {
    style: 'currency',
    currency: 'ZAR',
    currencyDisplay: 'narrowSymbol',
    maximumFractionDigits: 0,
  }).format(value / 100)
}

function allocationValue() {
  const node = selectedBucket.value
  return node.allocationKind === 'fixed' ? (node.allocationValue ?? 0) / 100 : node.allocationValue ?? 0
}

function updateAllocation(event: Event) {
  const value = Number((event.target as HTMLInputElement).value)
  const node = selectedBucket.value
  store.setAllocationValue(node.id, node.allocationKind === 'fixed' ? value * 100 : value)
}

function updateDistribution(parentId: string, childId: string, event: Event) {
  store.setChildDistribution(
    parentId,
    childId,
    Number((event.target as HTMLInputElement).value),
  )
}

function chooseParent(parentId: string) {
  store.setParent(selectedBucket.value.id, parentId)
  parentPickerOpen.value = false
  parentSearch.value = ''
}

function updateGroupPadding(axis: 'horizontal' | 'vertical', event: Event) {
  store.setGroupPadding(
    selectedBucket.value.id,
    axis,
    Number((event.target as HTMLInputElement).value),
  )
}

function updateRecurrenceDay(event: Event) {
  store.setRecurrenceDay(selectedBucket.value.id, Number((event.target as HTMLInputElement).value))
}

function updateExpenseTarget(event: Event) {
  store.setExpenseTarget(
    selectedBucket.value.id,
    Number((event.target as HTMLInputElement).value) * 100,
  )
}

watch(() => selectedBucket.value.id, () => {
  parentPickerOpen.value = false
  parentSearch.value = ''
})
</script>

<template>
  <aside class="buckets-inspector" aria-label="Selected node inspector">
    <header class="buckets-inspector__top">
      <div>
        <p class="raven-eyebrow">Selected node</p>
        <span>{{ selectedBucket.kind }}</span>
      </div>
      <button
        class="raven-icon-button"
        type="button"
        aria-label="Collapse node inspector"
        title="Collapse inspector"
        @click="inspectorOpen = false"
      >
        <span class="i-lucide-panel-right-close" aria-hidden="true" />
      </button>
    </header>

    <h2>{{ selectedBucket.name }}</h2>
    <div class="buckets-inspector__chips">
      <span class="raven-chip raven-chip--accent">{{ selectedBucket.state }}</span>
      <span class="raven-chip">{{ selectedBucket.allocationKind }}</span>
      <span v-if="selectedBucket.expenseMode" class="raven-chip">{{ selectedBucket.expenseMode }} expense</span>
    </div>
    <p class="buckets-inspector__description">{{ selectedBucket.description }}</p>

    <section class="buckets-inspector__allocation raven-surface">
      <span>{{ selectedBucket.expenseMode === 'budget' ? 'Reserved this month' : 'Receives this month' }}</span>
      <strong>{{ formatMinor(selectedMetric.receivedMinor) }}</strong>
      <small>{{ selectedBucket.method }}</small>
    </section>

    <section
      v-if="selectedBucket.id !== 'plan'"
      class="buckets-inspector__relationship"
    >
      <h3>Parent relationship</h3>
      <div class="buckets-parent-picker">
        <button
          type="button"
          role="combobox"
          :aria-expanded="parentPickerOpen"
          aria-controls="bucket-parent-options"
          @click="parentPickerOpen = !parentPickerOpen"
        >
          <span>
            <small>Flows from</small>
            <strong>{{ selectedParent?.name ?? 'No parent' }}</strong>
          </span>
          <span :class="parentPickerOpen ? 'i-lucide-chevron-up' : 'i-lucide-chevrons-up-down'" aria-hidden="true" />
        </button>
        <div v-if="parentPickerOpen" class="buckets-parent-picker__popover">
          <label>
            <span class="i-lucide-search" aria-hidden="true" />
            <input
              v-model="parentSearch"
              type="search"
              placeholder="Search every available node…"
              aria-label="Search available parent nodes"
              @keydown.esc="parentPickerOpen = false"
            >
          </label>
          <div id="bucket-parent-options" role="listbox">
            <button
              v-for="option in filteredParentOptions"
              :key="option.id"
              type="button"
              role="option"
              :aria-selected="selectedParent?.id === option.id"
              @click="chooseParent(option.id)"
            >
              <span :style="{ paddingLeft: `${Math.min(option.depth, 3) * 8}px` }">
                <strong>{{ option.name }}</strong>
                <small>{{ option.kind }}</small>
              </span>
              <span v-if="selectedParent?.id === option.id" class="i-lucide-check" aria-hidden="true" />
            </button>
            <p v-if="filteredParentOptions.length === 0">No matching nodes.</p>
          </div>
        </div>
      </div>
      <p>Reassigning the parent rewires this node without changing the visual group that explains its context.</p>
    </section>

    <section v-if="selectedBucket.presentation === 'group'" class="buckets-inspector__group-frame">
      <header>
        <h3>Group presentation</h3>
        <button type="button" @click="store.toggleNode(selectedBucket.id)">
          <span :class="groupCollapsed ? 'i-lucide-maximize-2' : 'i-lucide-minimize-2'" aria-hidden="true" />
          {{ groupCollapsed ? 'Expand' : 'Collapse' }}
        </button>
      </header>
      <label>
        <span><strong>Side spacing</strong><output>{{ groupFrame.paddingX }}px</output></span>
        <input
          :value="groupFrame.paddingX"
          type="range"
          min="12"
          max="160"
          step="2"
          @input="updateGroupPadding('horizontal', $event)"
        >
      </label>
      <label>
        <span><strong>Vertical spacing</strong><output>{{ groupFrame.paddingTop }}px</output></span>
        <input
          :value="groupFrame.paddingTop"
          type="range"
          min="12"
          max="160"
          step="2"
          @input="updateGroupPadding('vertical', $event)"
        >
      </label>
      <p>The frame names and folds a micro-flow. It does not decide how its children route money.</p>
    </section>

    <section
      v-if="routedChildren.length > 1"
      class="buckets-inspector__flow-mode"
    >
      <h3>Child routing</h3>
      <div role="group" :aria-label="`${selectedBucket.name} child routing`">
        <button
          type="button"
          :aria-pressed="(selectedBucket.connectionMode ?? 'series') === 'series'"
          :class="{ active: (selectedBucket.connectionMode ?? 'series') === 'series' }"
          @click="store.setConnectionMode(selectedBucket.id, 'series')"
        >
          <span class="i-lucide-list-ordered" aria-hidden="true" />
          In sequence
        </button>
        <button
          type="button"
          :aria-pressed="selectedBucket.connectionMode === 'branch'"
          :class="{ active: selectedBucket.connectionMode === 'branch' }"
          @click="store.setConnectionMode(selectedBucket.id, 'branch')"
        >
          <span class="i-lucide-git-fork" aria-hidden="true" />
          Share input
        </button>
      </div>
    </section>

    <section
      v-if="routedChildren.length > 1 && selectedBucket.connectionMode === 'branch'"
      class="buckets-inspector__distribution"
    >
      <header><h3>Child distribution</h3><output>100%</output></header>
      <label v-for="child in routedChildren" :key="child.id">
        <span><strong>{{ child.name }}</strong><small>{{ formatMinor(store.metricFor(child).grossReceivedMinor) }}</small></span>
        <div>
          <input
            :value="child.distributionPercentage ?? 0"
            type="range"
            min="0"
            max="100"
            step="1"
            @input="updateDistribution(selectedBucket.id, child.id, $event)"
          >
          <output>{{ child.distributionPercentage ?? 0 }}%</output>
        </div>
      </label>
    </section>

    <section
      v-if="routedParent && parentSiblings.length > 1"
      class="buckets-inspector__flow-mode"
    >
      <h3>Siblings under {{ routedParent.name }}</h3>
      <div role="group" aria-label="Sibling routing mode">
        <button
          type="button"
          :class="{ active: (routedParent.connectionMode ?? 'series') === 'series' }"
          @click="store.setConnectionMode(routedParent.id, 'series')"
        >
          <span class="i-lucide-list-ordered" aria-hidden="true" />
          In sequence
        </button>
        <button
          type="button"
          :class="{ active: routedParent.connectionMode === 'branch' }"
          @click="store.setConnectionMode(routedParent.id, 'branch')"
        >
          <span class="i-lucide-git-fork" aria-hidden="true" />
          Share input
        </button>
      </div>
      <p>Routing belongs to this parent-child relationship, not to the surrounding visual group.</p>
    </section>

    <section
      v-if="routedParent?.connectionMode === 'branch' && parentSiblings.length > 1"
      class="buckets-inspector__distribution"
    >
      <header><h3>Sibling distribution</h3><output>100%</output></header>
      <label v-for="sibling in parentSiblings" :key="sibling.id">
        <span><strong>{{ sibling.name }}</strong><small>{{ formatMinor(store.metricFor(sibling).grossReceivedMinor) }}</small></span>
        <div>
          <input
            :value="sibling.distributionPercentage ?? 0"
            type="range"
            min="0"
            max="100"
            step="1"
            @input="routedParent && updateDistribution(routedParent.id, sibling.id, $event)"
          >
          <output>{{ sibling.distributionPercentage ?? 0 }}%</output>
        </div>
      </label>
    </section>

    <section v-if="selectedBucket.kind === 'expense'" class="buckets-inspector__expense-mode">
      <h3>Amount behavior</h3>
      <div role="group" aria-label="Selected expense type">
        <button
          type="button"
          :aria-pressed="(selectedBucket.expenseMode ?? 'fixed') === 'fixed'"
          :class="{ active: (selectedBucket.expenseMode ?? 'fixed') === 'fixed' }"
          @click="store.setExpenseMode(selectedBucket.id, 'fixed')"
        >
          <span class="i-lucide-receipt-text" aria-hidden="true" />
          Fixed
        </button>
        <button
          type="button"
          :aria-pressed="selectedBucket.expenseMode === 'budget'"
          :class="{ active: selectedBucket.expenseMode === 'budget' }"
          @click="store.setExpenseMode(selectedBucket.id, 'budget')"
        >
          <span class="i-lucide-wallet-cards" aria-hidden="true" />
          Budget
        </button>
      </div>
    </section>

    <section v-if="selectedBucket.kind === 'expense'" class="buckets-inspector__expense-lifecycle">
      <h3>Expense lifecycle</h3>
      <div role="group" aria-label="Selected expense lifecycle">
        <button
          v-for="lifecycle in expenseLifecycles"
          :key="lifecycle.value"
          type="button"
          :class="{ active: (selectedBucket.expenseLifecycle ?? 'one-off') === lifecycle.value }"
          @click="store.setExpenseLifecycle(selectedBucket.id, lifecycle.value)"
        >
          <span :class="lifecycle.icon" aria-hidden="true" />
          {{ lifecycle.label }}
        </button>
      </div>
      <label v-if="selectedBucket.expenseLifecycle === 'recurring'" class="buckets-inspector__small-input">
        <span>Repeats monthly on day</span>
        <input
          :value="selectedBucket.recurrenceDay ?? 1"
          type="number"
          min="1"
          max="31"
          @change="updateRecurrenceDay"
        >
      </label>
      <label v-if="selectedBucket.expenseLifecycle === 'payoff'" class="buckets-inspector__small-input">
        <span>Total to complete</span>
        <div><b>R</b><input :value="(selectedBucket.targetMinor ?? 0) / 100" type="number" min="0" step="500" @change="updateExpenseTarget"></div>
      </label>
    </section>

    <section v-if="selectedBucket.presentation !== 'group'" class="buckets-inspector__view">
      <h3>Card view</h3>
      <div role="group" aria-label="Selected node card view">
        <button
          type="button"
          :aria-pressed="selectedBucket.displayMode === 'compact'"
          :class="{ active: selectedBucket.displayMode === 'compact' }"
          @click="store.setDisplayMode(selectedBucket.id, 'compact')"
        >
          <span class="i-lucide-panel-top" aria-hidden="true" />
          Compact
        </button>
        <button
          type="button"
          :aria-pressed="(selectedBucket.displayMode ?? 'inline') === 'inline'"
          :class="{ active: (selectedBucket.displayMode ?? 'inline') === 'inline' }"
          @click="store.setDisplayMode(selectedBucket.id, 'inline')"
        >
          <span class="i-lucide-gallery-horizontal" aria-hidden="true" />
          Inline
        </button>
      </div>
    </section>

    <section
      v-if="selectedBucket.allocationKind === 'fixed' || selectedBucket.allocationKind === 'percentage'"
      class="buckets-inspector__editor"
    >
      <label>
        <span>
          {{
            selectedBucket.allocationKind === 'fixed'
              ? selectedBucket.expenseMode === 'budget'
                ? 'Monthly budget'
                : 'Fixed amount'
              : 'Percentage of parent'
          }}
        </span>
        <div>
          <b>{{ selectedBucket.allocationKind === 'fixed' ? 'R' : '%' }}</b>
          <input
            :value="allocationValue()"
            type="number"
            min="0"
            :max="selectedBucket.allocationKind === 'percentage' ? 100 : undefined"
            :step="selectedBucket.allocationKind === 'fixed' ? 500 : 1"
            @change="updateAllocation"
          >
        </div>
      </label>
    </section>

    <section class="buckets-inspector__flow">
      <h3>Flow position</h3>
      <dl>
        <div><dt>Gross input</dt><dd>{{ formatMinor(selectedMetric.grossReceivedMinor) }}</dd></div>
        <div v-if="selectedMetric.redirectedInMinor"><dt>Redirected in</dt><dd>+{{ formatMinor(selectedMetric.redirectedInMinor) }}</dd></div>
        <div v-if="selectedMetric.redirectedOutMinor"><dt>Redirected by rule</dt><dd>−{{ formatMinor(selectedMetric.redirectedOutMinor) }}</dd></div>
        <div><dt>Retained by node</dt><dd>{{ formatMinor(selectedMetric.receivedMinor) }}</dd></div>
        <div><dt>Continues after step</dt><dd>{{ formatMinor(selectedMetric.remainingAfterMinor) }}</dd></div>
        <div>
          <dt>{{ selectedBucket.children?.length ? 'Unallocated inside' : 'Retained here' }}</dt>
          <dd>{{ formatMinor(selectedMetric.unallocatedMinor) }}</dd>
        </div>
      </dl>
    </section>

    <section class="buckets-inspector__rules">
      <h3>Rules · execution order</h3>
      <article v-for="(rule, index) in selectedBucket.rules" :key="rule.id">
        <span>{{ String(index + 1).padStart(2, '0') }}</span>
        <div><strong>{{ rule.title }}</strong><small>{{ rule.detail }}</small></div>
      </article>
      <p v-if="selectedBucket.rules.length === 0">No explicit rule has been attached to this planning node yet.</p>
    </section>

    <aside class="buckets-inspector__explanation">
      <strong>Why this moved</strong>
      <span>{{ selectedBucket.method }} routes {{ formatMinor(selectedMetric.receivedMinor) }} here in the current one-month scenario.</span>
    </aside>
  </aside>
</template>

<style scoped>
.buckets-inspector {
  position: sticky;
  top: 104px;
  max-height: calc(100vh - 120px);
  overflow-y: auto;
  border-left: 1px solid var(--raven-border);
  padding: 0 0 24px 18px;
  scrollbar-color: transparent transparent;
  scrollbar-width: thin;
}

.buckets-inspector::-webkit-scrollbar {
  width: 6px;
}

.buckets-inspector::-webkit-scrollbar-track {
  background: transparent;
}

.buckets-inspector::-webkit-scrollbar-thumb {
  border: 2px solid transparent;
  border-radius: 999px;
  background: transparent;
  background-clip: padding-box;
}

.buckets-inspector:hover {
  scrollbar-color: color-mix(in srgb, var(--raven-text) 20%, transparent) transparent;
}

.buckets-inspector:hover::-webkit-scrollbar-thumb {
  background-color: color-mix(in srgb, var(--raven-text) 24%, transparent);
}

.buckets-inspector:hover::-webkit-scrollbar-thumb:hover {
  background-color: color-mix(in srgb, var(--raven-text) 36%, transparent);
}

.buckets-inspector__top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.buckets-inspector__top > div {
  display: grid;
  gap: 3px;
}

.buckets-inspector__top > div > span {
  color: var(--raven-faint);
  font-size: 9px;
  font-weight: 750;
  text-transform: uppercase;
}

.buckets-inspector h2 {
  margin: 20px 0 10px;
  font-size: 23px;
  line-height: 1.05;
}

.buckets-inspector__chips {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.buckets-inspector__description {
  margin: 22px 0;
  color: var(--raven-muted);
  font-size: 11px;
  line-height: 1.55;
}

.buckets-inspector__allocation {
  display: grid;
  gap: 4px;
  padding: 14px;
}

.buckets-inspector__allocation span,
.buckets-inspector__allocation small {
  color: var(--raven-faint);
  font-size: 9px;
}

.buckets-inspector__allocation strong {
  color: var(--raven-accent);
  font-size: 24px;
}

.buckets-inspector__editor {
  margin-top: 10px;
}

.buckets-inspector__view,
.buckets-inspector__expense-mode,
.buckets-inspector__expense-lifecycle,
.buckets-inspector__flow-mode,
.buckets-inspector__relationship,
.buckets-inspector__group-frame {
  margin-top: 18px;
}

.buckets-inspector__view > div,
.buckets-inspector__expense-mode > div,
.buckets-inspector__flow-mode > div {
  height: 34px;
  display: grid;
  grid-template-columns: 1fr 1fr;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-sm);
  padding: 3px;
  background: var(--raven-panel);
}

.buckets-inspector__view button,
.buckets-inspector__expense-mode button,
.buckets-inspector__flow-mode button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
  border: 0;
  border-radius: 5px;
  background: transparent;
  color: var(--raven-faint);
  cursor: pointer;
  font-size: 9px;
  font-weight: 750;
}

.buckets-inspector__view button.active,
.buckets-inspector__expense-mode button.active,
.buckets-inspector__flow-mode button.active {
  color: var(--raven-text);
  background: var(--raven-panel-subtle);
  box-shadow: inset 0 0 0 1px var(--raven-border);
}

.buckets-inspector__flow-mode > p,
.buckets-inspector__distribution > p,
.buckets-inspector__relationship > p,
.buckets-inspector__group-frame > p {
  margin: 8px 0 0;
  color: var(--raven-faint);
  font-size: 8px;
  line-height: 1.45;
}

.buckets-parent-picker {
  position: relative;
  z-index: 8;
}

.buckets-parent-picker > button {
  width: 100%;
  min-height: 42px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-sm);
  padding: 7px 9px;
  background: var(--raven-panel);
  color: var(--raven-text);
  cursor: pointer;
  text-align: left;
}

.buckets-parent-picker > button > span:first-child {
  min-width: 0;
  display: grid;
  gap: 2px;
}

.buckets-parent-picker > button small {
  color: var(--raven-faint);
  font-size: 8px;
  text-transform: uppercase;
}

.buckets-parent-picker > button strong {
  overflow: hidden;
  font-size: 10px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.buckets-parent-picker__popover {
  position: absolute;
  top: calc(100% + 5px);
  right: 0;
  left: 0;
  overflow: hidden;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-sm);
  background: color-mix(in srgb, var(--raven-panel-raised) 98%, black);
  box-shadow: 0 16px 36px rgb(0 0 0 / 0.42);
}

.buckets-parent-picker__popover > label {
  height: 34px;
  display: flex;
  align-items: center;
  gap: 7px;
  border-bottom: 1px solid var(--raven-border);
  padding: 0 9px;
  color: var(--raven-faint);
}

.buckets-parent-picker__popover input {
  width: 100%;
  min-width: 0;
  border: 0;
  background: transparent;
  color: var(--raven-text);
  font-size: 9px;
  outline: 0;
}

.buckets-parent-picker__popover [role='listbox'] {
  max-height: 184px;
  overflow-y: auto;
  padding: 4px;
}

.buckets-parent-picker__popover [role='option'] {
  width: 100%;
  min-height: 34px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border: 0;
  border-radius: 5px;
  padding: 5px 7px;
  background: transparent;
  color: var(--raven-muted);
  cursor: pointer;
  text-align: left;
}

.buckets-parent-picker__popover [role='option']:hover,
.buckets-parent-picker__popover [role='option'][aria-selected='true'] {
  background: var(--raven-panel-subtle);
  color: var(--raven-text);
}

.buckets-parent-picker__popover [role='option'] > span:first-child {
  display: grid;
  gap: 2px;
}

.buckets-parent-picker__popover [role='option'] strong {
  font-size: 9px;
}

.buckets-parent-picker__popover [role='option'] small {
  color: var(--raven-faint);
  font-size: 7px;
  text-transform: uppercase;
}

.buckets-parent-picker__popover [role='listbox'] > p {
  margin: 8px;
  color: var(--raven-faint);
  font-size: 8px;
}

.buckets-inspector__group-frame {
  display: grid;
  gap: 11px;
}

.buckets-inspector__group-frame > header,
.buckets-inspector__group-frame label > span {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.buckets-inspector__group-frame > header h3 {
  margin: 0;
}

.buckets-inspector__group-frame > header button {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  border: 1px solid var(--raven-border);
  border-radius: 999px;
  padding: 4px 7px;
  background: var(--raven-panel);
  color: var(--raven-muted);
  cursor: pointer;
  font-size: 8px;
}

.buckets-inspector__group-frame label {
  display: grid;
  gap: 5px;
}

.buckets-inspector__group-frame label strong,
.buckets-inspector__group-frame label output {
  font-size: 8px;
}

.buckets-inspector__group-frame label output {
  color: var(--raven-faint);
}

.buckets-inspector__group-frame input[type='range'] {
  width: 100%;
  accent-color: var(--raven-accent);
}

.buckets-inspector__distribution {
  display: grid;
  gap: 11px;
  margin-top: 20px;
  border-top: 1px solid var(--raven-border);
  padding-top: 18px;
}

.buckets-inspector__distribution > header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.buckets-inspector__distribution > header h3 {
  margin: 0;
}

.buckets-inspector__distribution > header output {
  color: var(--raven-accent);
  font-size: 9px;
  font-weight: 800;
}

.buckets-inspector__distribution label {
  display: grid;
  gap: 5px;
}

.buckets-inspector__distribution label > span,
.buckets-inspector__distribution label > div {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}

.buckets-inspector__distribution label strong {
  font-size: 9px;
}

.buckets-inspector__distribution label small {
  color: var(--raven-faint);
  font-size: 8px;
}

.buckets-inspector__distribution input[type='range'] {
  width: 100%;
  accent-color: var(--raven-accent);
}

.buckets-inspector__distribution label output {
  min-width: 30px;
  color: var(--raven-text);
  font-size: 9px;
  font-weight: 750;
  text-align: right;
}

.buckets-inspector__expense-lifecycle > div {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 3px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-sm);
  padding: 3px;
  background: var(--raven-panel);
}

.buckets-inspector__expense-lifecycle > div > button {
  min-height: 30px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  border: 0;
  border-radius: 5px;
  background: transparent;
  color: var(--raven-faint);
  cursor: pointer;
  font-size: 8px;
  font-weight: 750;
}

.buckets-inspector__expense-lifecycle > div > button.active {
  background: var(--raven-panel-subtle);
  color: var(--raven-text);
  box-shadow: inset 0 0 0 1px var(--raven-border);
}

.buckets-inspector__small-input {
  display: grid;
  gap: 6px;
  margin-top: 8px;
  color: var(--raven-faint);
  font-size: 8px;
  font-weight: 750;
  text-transform: uppercase;
}

.buckets-inspector__small-input > input,
.buckets-inspector__small-input > div {
  height: 34px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-sm);
  background: var(--raven-panel);
}

.buckets-inspector__small-input > input {
  padding: 0 9px;
  color: var(--raven-text);
}

.buckets-inspector__small-input > div {
  display: flex;
  align-items: center;
}

.buckets-inspector__small-input > div b {
  padding-left: 9px;
  color: var(--raven-accent);
}

.buckets-inspector__small-input > div input {
  width: 100%;
  height: 100%;
  border: 0;
  padding: 0 9px 0 5px;
  background: transparent;
  color: var(--raven-text);
  outline: 0;
}

.buckets-inspector__editor label {
  display: grid;
  gap: 6px;
}

.buckets-inspector__editor label > span {
  color: var(--raven-faint);
  font-size: 9px;
  font-weight: 750;
  text-transform: uppercase;
}

.buckets-inspector__editor label > div {
  height: 36px;
  display: flex;
  align-items: center;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-sm);
  background: var(--raven-panel);
}

.buckets-inspector__editor b {
  padding-left: 10px;
  color: var(--raven-accent);
  font-size: 10px;
}

.buckets-inspector__editor input {
  width: 100%;
  min-width: 0;
  height: 100%;
  border: 0;
  padding: 0 9px 0 5px;
  background: transparent;
  color: var(--raven-text);
  outline: 0;
}

.buckets-inspector__flow,
.buckets-inspector__rules {
  margin-top: 26px;
  border-top: 1px solid var(--raven-border);
  padding-top: 18px;
}

.buckets-inspector h3 {
  margin: 0 0 12px;
  color: var(--raven-faint);
  font-size: 9px;
  letter-spacing: 0.045em;
  text-transform: uppercase;
}

.buckets-inspector__flow dl {
  display: grid;
  gap: 9px;
  margin: 0;
}

.buckets-inspector__flow dl > div {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  font-size: 10px;
}

.buckets-inspector__flow dt {
  color: var(--raven-faint);
}

.buckets-inspector__flow dd {
  margin: 0;
  color: var(--raven-text);
  font-weight: 700;
}

.buckets-inspector__rules {
  display: grid;
  gap: 8px;
}

.buckets-inspector__rules article {
  display: grid;
  grid-template-columns: 22px 1fr;
  gap: 7px;
  border: 1px solid var(--raven-border-subtle);
  border-radius: 6px;
  padding: 9px;
  background: var(--raven-panel);
}

.buckets-inspector__rules article > span {
  color: var(--raven-accent);
  font-size: 8px;
  font-weight: 800;
}

.buckets-inspector__rules article div {
  display: grid;
  gap: 2px;
}

.buckets-inspector__rules article strong {
  font-size: 10px;
}

.buckets-inspector__rules article small,
.buckets-inspector__rules > p {
  margin: 0;
  color: var(--raven-faint);
  font-size: 8px;
}

.buckets-inspector__explanation {
  display: grid;
  gap: 5px;
  margin-top: 26px;
  border-left: 2px solid var(--raven-accent);
  padding: 2px 0 2px 11px;
}

.buckets-inspector__explanation strong {
  color: var(--raven-accent);
  font-size: 9px;
  text-transform: uppercase;
}

.buckets-inspector__explanation span {
  color: var(--raven-muted);
  font-size: 9px;
  line-height: 1.5;
}

@media (max-width: 1120px) {
  .buckets-inspector {
    position: static;
    max-height: none;
    border-top: 1px solid var(--raven-border);
    border-left: 0;
    padding: 18px 0;
  }
}
</style>
