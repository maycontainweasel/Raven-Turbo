<script setup lang="ts">
import type { BucketAllocationMetric, BucketCanvasPosition } from '~/stores/bucketsPrototype'
import type {
  BucketPrototypeCreateDirection,
  BucketPrototypeCreateKind,
  BucketPrototypeNode,
} from '~/types/buckets'

const props = withDefaults(defineProps<{
  node: BucketPrototypeNode
  position: BucketCanvasPosition
  metric: BucketAllocationMetric
  selected: boolean
  formatMinor: (value: number) => string
  scale?: number
}>(), {
  scale: 1,
})

const emit = defineEmits<{
  select: [id: string]
  move: [payload: { id: string; x: number; y: number }]
  rename: [id: string, name: string]
  create: [payload: {
    sourceId: string
    direction: BucketPrototypeCreateDirection
    kind: BucketPrototypeCreateKind
  }]
}>()

const editing = ref(false)
const draftName = ref(props.node.name)
const input = ref<HTMLInputElement | null>(null)
const dragging = ref(false)
const createDirection = ref<BucketPrototypeCreateDirection | null>(null)
let activePointer: number | null = null
let startPointerX = 0
let startPointerY = 0
let startNodeX = 0
let startNodeY = 0

const role = computed(() => {
  if (props.node.allocationKind === 'source') return 'source'
  if (props.node.expenseMode === 'budget') return 'budget'
  if (props.node.kind === 'expense') return 'expense'
  if (props.node.kind === 'accumulator' || props.node.kind === 'remainder') return 'accumulator'
  return 'flow'
})

const displayMode = computed(() => props.node.displayMode ?? 'inline')
const displayAmount = computed(() => {
  const amount = props.formatMinor(props.metric.receivedMinor)
  return props.node.kind === 'expense' ? `−${amount}` : amount
})
const hasConditionalRule = computed(() => Boolean(props.node.conditionalRedirect))
const addDirections: Array<{
  direction: BucketPrototypeCreateDirection
  label: string
  icon: string
}> = [
  { direction: 'top', label: 'Add above', icon: 'i-lucide-plus' },
  { direction: 'right', label: 'Add right', icon: 'i-lucide-plus' },
  { direction: 'bottom', label: 'Add below', icon: 'i-lucide-plus' },
  { direction: 'left', label: 'Add left', icon: 'i-lucide-plus' },
]

watch(() => props.node.name, (value) => {
  if (!editing.value) draftName.value = value
})

watch(() => props.selected, (selected) => {
  if (!selected) createDirection.value = null
})

function beginDrag(event: PointerEvent) {
  if (editing.value || event.button !== 0) return
  event.preventDefault()
  activePointer = event.pointerId
  dragging.value = true
  startPointerX = event.clientX
  startPointerY = event.clientY
  startNodeX = props.position.x
  startNodeY = props.position.y
  ;(event.currentTarget as HTMLElement).setPointerCapture(event.pointerId)
  window.addEventListener('pointermove', drag)
  window.addEventListener('pointerup', endDrag)
  window.addEventListener('pointercancel', endDrag)
  emit('select', props.node.id)
}

function drag(event: PointerEvent) {
  if (activePointer !== event.pointerId) return
  const deltaX = (event.clientX - startPointerX) / props.scale
  const deltaY = (event.clientY - startPointerY) / props.scale
  emit('move', {
    id: props.node.id,
    x: startNodeX + deltaX,
    y: startNodeY + deltaY,
  })
}

function endDrag(event: PointerEvent) {
  if (activePointer !== event.pointerId) return
  activePointer = null
  dragging.value = false
  stopPointerTracking()
}

function stopPointerTracking() {
  window.removeEventListener('pointermove', drag)
  window.removeEventListener('pointerup', endDrag)
  window.removeEventListener('pointercancel', endDrag)
}

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

function chooseCreateDirection(direction: BucketPrototypeCreateDirection) {
  createDirection.value = createDirection.value === direction ? null : direction
  emit('select', props.node.id)
}

function createNode(kind: BucketPrototypeCreateKind) {
  if (!createDirection.value) return
  emit('create', {
    sourceId: props.node.id,
    direction: createDirection.value,
    kind,
  })
  createDirection.value = null
}

onBeforeUnmount(stopPointerTracking)
</script>

<template>
  <article
    class="circuit-node"
    :class="[
      `circuit-node--${node.tone}`,
      `circuit-node--role-${role}`,
      `circuit-node--display-${displayMode}`,
      {
        'is-selected': selected,
        'is-source': node.allocationKind === 'source',
        'is-dragging': dragging,
      },
    ]"
    :style="{ transform: `translate3d(${position.x}px, ${position.y}px, 0)` }"
    :aria-label="`${node.name}, receives ${formatMinor(metric.receivedMinor)}`"
    @click="emit('select', node.id)"
  >
    <header
      class="circuit-node__handle"
      title="Drag to move · double-click the title to rename"
      @pointerdown="beginDrag"
    >
      <span class="i-lucide-grip-vertical circuit-node__grip" aria-hidden="true" />
      <input
        v-if="editing"
        ref="input"
        v-model="draftName"
        maxlength="80"
        aria-label="Node name"
        @click.stop
        @keydown.enter.prevent="commitName"
        @keydown.esc.prevent="editing = false"
        @blur="commitName"
      >
      <button
        v-else
        class="circuit-node__name"
        type="button"
        @click.stop="emit('select', node.id)"
        @dblclick.stop="beginEditing"
      >
        {{ node.name }}
      </button>
      <span
        v-if="node.expenseMode === 'budget'"
        class="circuit-node__semantic circuit-node__semantic--budget"
        title="This expense is a monthly budget"
      >
        <i class="i-lucide-wallet-cards" aria-hidden="true" />
        Budget
      </span>
      <span
        v-if="hasConditionalRule"
        class="circuit-node__rule"
        title="This node has a conditional routing rule"
        aria-label="Conditional rule"
      >
        <i class="i-lucide-git-branch" aria-hidden="true" />
        Rule
      </span>
      <strong v-if="displayMode === 'inline'" class="circuit-node__inline-value">{{ displayAmount }}</strong>
    </header>

    <div v-if="displayMode === 'compact'" class="circuit-node__value">
      <strong>{{ displayAmount }}</strong>
    </div>

    <i class="circuit-node__port circuit-node__port--input" aria-hidden="true" />
    <i class="circuit-node__port circuit-node__port--output" aria-hidden="true" />

    <button
      v-for="item in addDirections"
      :key="item.direction"
      class="circuit-node__add"
      :class="[
        `circuit-node__add--${item.direction}`,
        { 'is-active': createDirection === item.direction },
      ]"
      type="button"
      :aria-label="`${item.label} from ${node.name}`"
      :title="item.label"
      @pointerdown.stop
      @click.stop="chooseCreateDirection(item.direction)"
    >
      <i :class="item.icon" aria-hidden="true" />
    </button>

    <div
      v-if="createDirection"
      class="circuit-node__create-menu"
      :class="`circuit-node__create-menu--${createDirection}`"
      role="menu"
      :aria-label="`Add from ${node.name}`"
      @pointerdown.stop
      @click.stop
    >
      <button class="is-expense" type="button" role="menuitem" @click="createNode('expense')">
        <i class="i-lucide-receipt-text" aria-hidden="true" />
        <span><strong>Expense</strong><small>Fixed monthly cost</small></span>
      </button>
      <button class="is-expense-budget" type="button" role="menuitem" @click="createNode('budget')">
        <i class="i-lucide-wallet-cards" aria-hidden="true" />
        <span><strong>Expense budget</strong><small>Monthly spending boundary</small></span>
      </button>
      <button class="is-bucket" type="button" role="menuitem" @click="createNode('bucket')">
        <i class="i-lucide-badge-plus" aria-hidden="true" />
        <span><strong>Bucket</strong><small>Retain an allocation</small></span>
      </button>
    </div>
  </article>
</template>

<style scoped>
.circuit-node {
  --node-role-color: var(--raven-muted);
  --node-role-soft: color-mix(in srgb, var(--node-role-color) 8%, transparent);
  position: absolute;
  z-index: 2;
  width: 240px;
  height: 76px;
  overflow: visible;
  border: 1px solid color-mix(in srgb, var(--node-role-color) 38%, var(--raven-border));
  border-radius: 8px;
  background:
    linear-gradient(145deg, var(--node-role-soft), transparent 52%),
    linear-gradient(180deg, color-mix(in srgb, var(--raven-panel-raised) 94%, transparent), var(--raven-panel));
  box-shadow: 0 12px 28px rgb(0 0 0 / 0.22);
  color: var(--raven-text);
  transition:
    border-color 120ms ease,
    box-shadow 120ms ease;
  will-change: transform;
}

.circuit-node:hover {
  border-color: color-mix(in srgb, var(--node-role-color) 66%, var(--raven-border));
}

.circuit-node.is-selected {
  border-color: var(--node-role-color);
  box-shadow:
    0 0 0 1px color-mix(in srgb, var(--node-role-color) 24%, transparent),
    0 16px 36px rgb(0 0 0 / 0.34);
}

.circuit-node.is-source {
  width: 260px;
}

.circuit-node--display-inline {
  height: 48px;
}

.circuit-node--role-source {
  --node-role-color: #7181ff;
  --node-role-soft: color-mix(in srgb, #4657d8 18%, transparent);
  background:
    linear-gradient(145deg, color-mix(in srgb, #3647bd 24%, transparent), transparent 58%),
    linear-gradient(180deg, color-mix(in srgb, #111735 88%, var(--raven-panel-raised)), color-mix(in srgb, #080d22 82%, var(--raven-panel)));
}

.circuit-node--role-accumulator {
  --node-role-color: var(--raven-accent);
}

.circuit-node--role-expense {
  --node-role-color: var(--raven-danger);
}

.circuit-node--role-budget {
  --node-role-color: var(--raven-warning);
}

.circuit-node--role-flow {
  --node-role-color: var(--raven-muted);
}

.circuit-node.is-dragging {
  z-index: 4;
  cursor: grabbing;
  transition: none;
}

.circuit-node__handle {
  min-height: 35px;
  display: flex;
  align-items: center;
  gap: 7px;
  padding: 0 11px 0 7px;
  color: color-mix(in srgb, var(--node-role-color) 76%, var(--raven-text));
  cursor: grab;
  touch-action: none;
  user-select: none;
}

.circuit-node--display-inline .circuit-node__handle {
  min-height: 46px;
}

.circuit-node__handle:active {
  cursor: grabbing;
}

.circuit-node__grip {
  font-size: 13px;
}

.circuit-node__name {
  min-width: 0;
  width: auto;
  max-width: 100%;
  flex: 1 1 auto;
  overflow: hidden;
  border: 0;
  padding: 0;
  background: transparent;
  color: var(--raven-text);
  cursor: text;
  font-size: 14.5px;
  font-weight: 750;
  text-align: left;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.circuit-node__handle input {
  min-width: 0;
  width: auto;
  flex: 1 1 auto;
  height: 25px;
  border: 1px solid var(--raven-accent);
  border-radius: 4px;
  padding: 0 6px;
  background: var(--raven-panel-subtle);
  color: var(--raven-text);
  font-size: 13px;
  font-weight: 750;
}

.circuit-node__value {
  padding: 0 14px 11px 27px;
}

.circuit-node__value > strong,
.circuit-node__inline-value {
  color: color-mix(in srgb, var(--node-role-color) 58%, var(--raven-text));
  font-size: 20px;
  font-weight: 680;
  letter-spacing: -0.035em;
  white-space: nowrap;
}

.circuit-node__inline-value {
  flex: 0 0 auto;
  margin-left: auto;
  font-size: 16px;
}

.circuit-node__rule {
  flex: 0 0 auto;
  display: inline-flex;
  align-items: center;
  gap: 3px;
  border: 1px solid color-mix(in srgb, #8792ff 45%, var(--raven-border));
  border-radius: 999px;
  padding: 3px 6px;
  color: #9ca5ff;
  background: color-mix(in srgb, #5363d9 10%, transparent);
  font-size: 8px;
  font-weight: 800;
}

.circuit-node__semantic {
  flex: 0 0 auto;
  display: inline-flex;
  align-items: center;
  gap: 3px;
  border-radius: 999px;
  padding: 3px 6px;
  font-size: 8px;
  font-weight: 800;
}

.circuit-node__semantic--budget {
  border: 1px solid color-mix(in srgb, var(--raven-warning) 42%, var(--raven-border));
  color: color-mix(in srgb, var(--raven-warning) 72%, var(--raven-text));
  background: color-mix(in srgb, var(--raven-warning) 8%, transparent);
}

.circuit-node__add {
  position: absolute;
  z-index: 7;
  width: 20px;
  height: 20px;
  display: grid;
  place-items: center;
  border: 1px solid color-mix(in srgb, var(--node-role-color) 58%, var(--raven-border));
  border-radius: 50%;
  padding: 0;
  background: var(--raven-panel-raised);
  color: color-mix(in srgb, var(--node-role-color) 72%, var(--raven-text));
  cursor: pointer;
  opacity: 0;
  transform: scale(0.78);
  transition:
    opacity 100ms ease,
    transform 100ms ease,
    background-color 100ms ease;
}

.circuit-node:hover .circuit-node__add,
.circuit-node:focus-within .circuit-node__add,
.circuit-node.is-selected .circuit-node__add {
  opacity: 1;
  transform: scale(1);
}

.circuit-node__add:hover,
.circuit-node__add.is-active {
  background: color-mix(in srgb, var(--node-role-color) 18%, var(--raven-panel-raised));
}

.circuit-node__add--top {
  top: -11px;
  left: 50%;
  transform: translateX(-50%) scale(0.78);
}

.circuit-node:hover .circuit-node__add--top,
.circuit-node:focus-within .circuit-node__add--top,
.circuit-node.is-selected .circuit-node__add--top {
  transform: translateX(-50%) scale(1);
}

.circuit-node__add--right {
  top: 50%;
  right: -11px;
  transform: translateY(-50%) scale(0.78);
}

.circuit-node:hover .circuit-node__add--right,
.circuit-node:focus-within .circuit-node__add--right,
.circuit-node.is-selected .circuit-node__add--right {
  transform: translateY(-50%) scale(1);
}

.circuit-node__add--bottom {
  bottom: -11px;
  left: 50%;
  transform: translateX(-50%) scale(0.78);
}

.circuit-node:hover .circuit-node__add--bottom,
.circuit-node:focus-within .circuit-node__add--bottom,
.circuit-node.is-selected .circuit-node__add--bottom {
  transform: translateX(-50%) scale(1);
}

.circuit-node__add--left {
  top: 50%;
  left: -11px;
  transform: translateY(-50%) scale(0.78);
}

.circuit-node:hover .circuit-node__add--left,
.circuit-node:focus-within .circuit-node__add--left,
.circuit-node.is-selected .circuit-node__add--left {
  transform: translateY(-50%) scale(1);
}

.circuit-node__create-menu {
  position: absolute;
  z-index: 10;
  width: 184px;
  display: grid;
  gap: 2px;
  border: 1px solid var(--raven-border);
  border-radius: 8px;
  padding: 4px;
  background: color-mix(in srgb, var(--raven-panel-raised) 97%, transparent);
  box-shadow: 0 18px 46px rgb(0 0 0 / 0.48);
}

.circuit-node__create-menu--right {
  top: 50%;
  left: calc(100% + 18px);
  transform: translateY(-50%);
}

.circuit-node__create-menu--left {
  top: 50%;
  right: calc(100% + 18px);
  transform: translateY(-50%);
}

.circuit-node__create-menu--top {
  right: 50%;
  bottom: calc(100% + 18px);
  transform: translateX(50%);
}

.circuit-node__create-menu--bottom {
  top: calc(100% + 18px);
  left: 50%;
  transform: translateX(-50%);
}

.circuit-node__create-menu button {
  display: grid;
  grid-template-columns: 24px 1fr;
  align-items: center;
  gap: 7px;
  border: 0;
  border-radius: 5px;
  padding: 7px;
  background: transparent;
  color: var(--raven-muted);
  cursor: pointer;
  text-align: left;
}

.circuit-node__create-menu button:hover {
  color: var(--raven-text);
  background: var(--raven-panel-subtle);
}

.circuit-node__create-menu button.is-expense,
.circuit-node__create-menu button.is-expense-budget {
  color: color-mix(in srgb, var(--raven-danger) 76%, var(--raven-text));
}

.circuit-node__create-menu button.is-bucket {
  color: color-mix(in srgb, var(--raven-accent) 82%, var(--raven-text));
}

.circuit-node__create-menu button.is-expense:hover,
.circuit-node__create-menu button.is-expense-budget:hover {
  background: color-mix(in srgb, var(--raven-danger) 9%, var(--raven-panel-subtle));
}

.circuit-node__create-menu button.is-bucket:hover {
  background: color-mix(in srgb, var(--raven-accent) 9%, var(--raven-panel-subtle));
}

.circuit-node__create-menu button > i {
  font-size: 13px;
}

.circuit-node__create-menu button > span {
  display: grid;
  gap: 1px;
}

.circuit-node__create-menu strong {
  color: inherit;
  font-size: 9px;
}

.circuit-node__create-menu small {
  color: var(--raven-faint);
  font-size: 7px;
}

.circuit-node__port {
  position: absolute;
  left: 50%;
  width: 8px;
  height: 8px;
  border: 2px solid var(--raven-bg);
  border-radius: 50%;
  background: var(--node-role-color);
  transform: translateX(-50%);
}

.circuit-node__port--input {
  top: -5px;
}

.circuit-node__port--output {
  bottom: -5px;
}

.circuit-node.is-source .circuit-node__port--input {
  display: none;
}

</style>
