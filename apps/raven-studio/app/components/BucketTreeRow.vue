<script setup lang="ts">
import type { BucketPrototypeNode } from '~/types/buckets'

defineOptions({ name: 'BucketTreeRow' })

const props = defineProps<{
  node: BucketPrototypeNode
  depth?: number
  selectedId: string
  collapsedIds: Set<string>
  plannedNow: (node: BucketPrototypeNode) => string
  projected: (node: BucketPrototypeNode) => string
}>()

const emit = defineEmits<{
  select: [node: BucketPrototypeNode]
  toggle: [id: string]
  rename: [id: string, name: string]
  dragStart: [id: string]
  drop: [id: string]
}>()

const editing = ref(false)
const draftName = ref(props.node.name)
const input = ref<HTMLInputElement | null>(null)
const rowDepth = computed(() => props.depth ?? 0)
const hasChildren = computed(() => Boolean(props.node.children?.length))
const collapsed = computed(() => props.collapsedIds.has(props.node.id))
const kindLabel = computed(() => {
  if (props.node.presentation === 'group') return 'Group'
  if (props.node.expenseLifecycle === 'payoff') return 'Payoff expense'
  if (props.node.expenseLifecycle === 'recurring' && props.node.expenseMode === 'budget') return 'Recurring budget'
  if (props.node.expenseLifecycle === 'recurring') return 'Recurring expense'
  if (props.node.expenseMode === 'budget') return 'Expense budget'
  if (props.node.expenseMode === 'fixed') return 'Fixed expense'
  return props.node.kind
})

watch(() => props.node.name, value => {
  if (!editing.value) draftName.value = value
})

async function beginEditing() {
  editing.value = true
  draftName.value = props.node.name
  await nextTick()
  input.value?.focus()
  input.value?.select()
}

function commitName() {
  const name = draftName.value.trim()
  if (name && name !== props.node.name) emit('rename', props.node.id, name)
  else draftName.value = props.node.name
  editing.value = false
}
</script>

<template>
  <div class="bucket-tree-row-wrap">
    <div
      class="bucket-tree-row"
      :class="{ 'is-selected': selectedId === node.id }"
      :style="{ '--bucket-depth': rowDepth }"
      role="treeitem"
      :aria-level="rowDepth + 1"
      :aria-expanded="hasChildren ? !collapsed : undefined"
      :aria-selected="selectedId === node.id"
      @click="emit('select', node)"
      @dragover.prevent
      @drop.prevent.stop="emit('drop', node.id)"
    >
      <div class="bucket-tree-row__identity">
        <button
          class="bucket-tree-row__drag"
          type="button"
          draggable="true"
          :aria-label="`Move ${node.name}`"
          title="Drag to reorder"
          @click.stop
          @dragstart.stop="emit('dragStart', node.id)"
        >
          <span class="i-lucide-grip-vertical" aria-hidden="true" />
        </button>
        <button
          class="bucket-tree-row__toggle"
          type="button"
          :disabled="!hasChildren"
          :aria-label="hasChildren ? `${collapsed ? 'Expand' : 'Collapse'} ${node.name}` : undefined"
          @click.stop="hasChildren && emit('toggle', node.id)"
        >
          <span
            :class="hasChildren ? (collapsed ? 'i-lucide-chevron-right' : 'i-lucide-chevron-down') : 'i-lucide-dot'"
            aria-hidden="true"
          />
        </button>
        <input
          v-if="editing"
          ref="input"
          v-model="draftName"
          class="bucket-tree-row__name-input"
          maxlength="80"
          @click.stop
          @keydown.enter.prevent="commitName"
          @keydown.esc.prevent="editing = false"
          @blur="commitName"
        >
        <button
          v-else
          class="bucket-tree-row__name"
          type="button"
          title="Double-click to rename"
          @click.stop="emit('select', node)"
          @dblclick.stop="beginEditing"
        >
          {{ node.name }}
        </button>
        <span class="bucket-tree-row__kind">{{ kindLabel }}</span>
      </div>
      <span class="bucket-tree-row__method">{{ node.method }}</span>
      <strong class="bucket-tree-row__money">{{ plannedNow(node) }}</strong>
      <strong class="bucket-tree-row__money bucket-tree-row__money--projected">{{ projected(node) }}</strong>
      <span class="bucket-tree-row__state" :class="`is-${node.tone}`">{{ node.state }}</span>
      <span class="i-lucide-chevron-right bucket-tree-row__open" aria-hidden="true" />
    </div>

    <div v-if="hasChildren && !collapsed" class="bucket-tree-row__children" role="group">
      <BucketTreeRow
        v-for="child in node.children"
        :key="child.id"
        :node="child"
        :depth="rowDepth + 1"
        :selected-id="selectedId"
        :collapsed-ids="collapsedIds"
        :planned-now="plannedNow"
        :projected="projected"
        @select="emit('select', $event)"
        @toggle="emit('toggle', $event)"
        @rename="(id, name) => emit('rename', id, name)"
        @drag-start="emit('dragStart', $event)"
        @drop="emit('drop', $event)"
      />
    </div>
  </div>
</template>

<style scoped>
.bucket-tree-row-wrap {
  min-width: 760px;
}

.bucket-tree-row {
  --bucket-indent: calc(var(--bucket-depth) * 28px);
  position: relative;
  min-height: 47px;
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
  border-bottom: 1px solid var(--raven-border-subtle);
  color: var(--raven-muted);
  cursor: default;
  transition: background-color 120ms ease;
}

.bucket-tree-row:hover {
  background: color-mix(in srgb, var(--raven-panel-raised) 72%, transparent);
}

.bucket-tree-row.is-selected {
  background: color-mix(in srgb, var(--raven-accent-soft) 54%, transparent);
}

.bucket-tree-row.is-selected::before {
  position: absolute;
  inset: 0 auto 0 0;
  width: 3px;
  border-radius: 2px;
  background: var(--raven-accent);
  content: '';
}

.bucket-tree-row__identity {
  min-width: 0;
  display: flex;
  align-items: center;
  gap: 6px;
  padding-left: calc(8px + var(--bucket-indent));
}

.bucket-tree-row__identity::before {
  position: absolute;
  left: calc(25px + var(--bucket-indent));
  top: -1px;
  bottom: -1px;
  width: 1px;
  background: var(--raven-border-subtle);
  content: '';
  opacity: calc(min(var(--bucket-depth), 1));
}

.bucket-tree-row__drag,
.bucket-tree-row__toggle,
.bucket-tree-row__name {
  border: 0;
  padding: 0;
  background: transparent;
  color: inherit;
}

.bucket-tree-row__drag,
.bucket-tree-row__toggle {
  position: relative;
  z-index: 1;
  flex: 0 0 auto;
  display: grid;
  place-items: center;
}

.bucket-tree-row__drag {
  width: 18px;
  height: 28px;
  color: var(--raven-faint);
  cursor: grab;
}

.bucket-tree-row__drag:active {
  cursor: grabbing;
}

.bucket-tree-row__toggle {
  width: 20px;
  height: 28px;
  color: var(--raven-faint);
  cursor: pointer;
}

.bucket-tree-row__toggle:disabled {
  cursor: default;
  opacity: 0.38;
}

.bucket-tree-row__name {
  min-width: 0;
  overflow: hidden;
  color: var(--raven-text);
  font-weight: 700;
  text-align: left;
  text-overflow: ellipsis;
  white-space: nowrap;
  cursor: pointer;
}

.bucket-tree-row__name:hover {
  color: var(--raven-accent);
}

.bucket-tree-row__name-input {
  min-width: 90px;
  height: 30px;
  flex: 1 1 180px;
  border: 1px solid var(--raven-accent);
  border-radius: 5px;
  padding: 0 7px;
  background: var(--raven-panel-raised);
  color: var(--raven-text);
  font-weight: 700;
}

.bucket-tree-row__kind {
  flex: 0 1 auto;
  overflow: hidden;
  color: var(--raven-faint);
  font-size: 9px;
  font-weight: 700;
  text-overflow: ellipsis;
  text-transform: uppercase;
  white-space: nowrap;
}

.bucket-tree-row__method {
  overflow: hidden;
  color: var(--raven-faint);
  font-size: 10px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.bucket-tree-row__money {
  overflow: hidden;
  color: var(--raven-muted);
  font-size: 11px;
  font-weight: 650;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.bucket-tree-row__money--projected,
.bucket-tree-row.is-selected .bucket-tree-row__money--projected {
  color: var(--raven-accent);
}

.bucket-tree-row__state {
  overflow: hidden;
  font-size: 9px;
  font-weight: 750;
  letter-spacing: 0.035em;
  text-align: right;
  text-overflow: ellipsis;
  text-transform: uppercase;
  white-space: nowrap;
}

.bucket-tree-row__state.is-accent {
  color: var(--raven-accent);
}

.bucket-tree-row__state.is-warning {
  color: var(--raven-warning);
}

.bucket-tree-row__state.is-muted {
  color: var(--raven-faint);
}

.bucket-tree-row__state.is-default {
  color: var(--raven-text);
}

.bucket-tree-row__open {
  color: var(--raven-faint);
}
</style>
