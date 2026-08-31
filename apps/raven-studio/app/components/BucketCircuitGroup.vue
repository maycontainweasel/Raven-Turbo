<script setup lang="ts">
import type { BucketAllocationMetric, BucketCanvasPosition } from '~/stores/bucketsPrototype'
import type { BucketPrototypeNode } from '~/types/buckets'

export type BucketCircuitGroupBounds = {
  x: number
  y: number
  width: number
  height: number
}

const props = withDefaults(defineProps<{
  node: BucketPrototypeNode
  bounds: BucketCircuitGroupBounds
  position: BucketCanvasPosition
  metric: BucketAllocationMetric
  selected: boolean
  collapsed: boolean
  formatMinor: (value: number) => string
  scale?: number
}>(), {
  scale: 1,
})

const emit = defineEmits<{
  select: [id: string]
  toggle: [id: string]
  move: [payload: { id: string; x: number; y: number }]
  resize: [payload: { id: string; width: number; height: number }]
}>()

const dragging = ref(false)
let activePointer: number | null = null
let startPointerX = 0
let startPointerY = 0
let startGroupX = 0
let startGroupY = 0
let resizePointer: number | null = null
let startResizeX = 0
let startResizeY = 0
let startWidth = 0
let startHeight = 0

function beginDrag(event: PointerEvent) {
  if (event.button !== 0) return
  event.preventDefault()
  activePointer = event.pointerId
  dragging.value = true
  startPointerX = event.clientX
  startPointerY = event.clientY
  startGroupX = props.position.x
  startGroupY = props.position.y
  ;(event.currentTarget as HTMLElement).setPointerCapture(event.pointerId)
  window.addEventListener('pointermove', drag)
  window.addEventListener('pointerup', endDrag)
  window.addEventListener('pointercancel', endDrag)
  emit('select', props.node.id)
}

function drag(event: PointerEvent) {
  if (activePointer !== event.pointerId) return
  emit('move', {
    id: props.node.id,
    x: startGroupX + (event.clientX - startPointerX) / props.scale,
    y: startGroupY + (event.clientY - startPointerY) / props.scale,
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

function beginResize(event: PointerEvent) {
  if (event.button !== 0 || props.collapsed) return
  event.preventDefault()
  event.stopPropagation()
  resizePointer = event.pointerId
  startResizeX = event.clientX
  startResizeY = event.clientY
  startWidth = props.bounds.width
  startHeight = props.bounds.height
  ;(event.currentTarget as HTMLElement).setPointerCapture(event.pointerId)
  window.addEventListener('pointermove', resize)
  window.addEventListener('pointerup', endResize)
  window.addEventListener('pointercancel', endResize)
  emit('select', props.node.id)
}

function resize(event: PointerEvent) {
  if (resizePointer !== event.pointerId) return
  emit('resize', {
    id: props.node.id,
    width: startWidth + (event.clientX - startResizeX) / props.scale,
    height: startHeight + (event.clientY - startResizeY) / props.scale,
  })
}

function endResize(event: PointerEvent) {
  if (resizePointer !== event.pointerId) return
  resizePointer = null
  window.removeEventListener('pointermove', resize)
  window.removeEventListener('pointerup', endResize)
  window.removeEventListener('pointercancel', endResize)
}

onBeforeUnmount(() => {
  stopPointerTracking()
  window.removeEventListener('pointermove', resize)
  window.removeEventListener('pointerup', endResize)
  window.removeEventListener('pointercancel', endResize)
})
</script>

<template>
  <fieldset
    class="circuit-group"
    :class="{ 'is-selected': selected, 'is-dragging': dragging, 'is-collapsed': collapsed }"
    :style="{
      transform: `translate3d(${bounds.x}px, ${bounds.y}px, 0)`,
      width: `${bounds.width}px`,
      height: `${bounds.height}px`,
    }"
    @click.self="emit('select', node.id)"
  >
    <legend>
      <span class="circuit-group__toolbar">
        <button
          class="circuit-group__handle"
          type="button"
          title="Drag to move this group and every node inside it"
          @pointerdown.stop="beginDrag"
          @click.stop="emit('select', node.id)"
        >
          <span class="i-lucide-grip-vertical circuit-group__grip" aria-hidden="true" />
          <strong>{{ node.name }}</strong>
          <small>Group</small>
          <b>{{ formatMinor(metric.grossReceivedMinor) }}</b>
        </button>
        <button
          class="circuit-group__toggle"
          type="button"
          :aria-label="`${collapsed ? 'Expand' : 'Collapse'} ${node.name}`"
          :title="`${collapsed ? 'Expand' : 'Collapse'} group`"
          @click.stop="emit('toggle', node.id)"
        >
          <span :class="collapsed ? 'i-lucide-maximize-2' : 'i-lucide-minimize-2'" aria-hidden="true" />
        </button>
      </span>
    </legend>
    <button
      v-if="!collapsed"
      class="circuit-group__resize"
      type="button"
      aria-label="Resize group frame"
      title="Drag to resize this group frame"
      @pointerdown="beginResize"
    >
      <span class="i-lucide-grip" aria-hidden="true" />
    </button>
  </fieldset>
</template>

<style scoped>
.circuit-group {
  position: absolute;
  z-index: 0;
  box-sizing: border-box;
  margin: 0;
  border: 1px dashed color-mix(in srgb, var(--raven-muted) 34%, var(--raven-border));
  border-radius: 14px;
  padding: 0;
  background:
    linear-gradient(180deg, color-mix(in srgb, var(--raven-panel) 28%, transparent), transparent 18%),
    color-mix(in srgb, var(--raven-panel) 8%, transparent);
  transition:
    border-color 120ms ease,
    background-color 120ms ease;
}

.circuit-group:hover,
.circuit-group.is-selected {
  border-color: color-mix(in srgb, var(--raven-accent) 55%, var(--raven-border));
  background-color: color-mix(in srgb, var(--raven-accent-soft) 8%, transparent);
}

.circuit-group legend {
  margin-left: 16px;
  padding: 0 6px;
}

.circuit-group__toolbar {
  display: inline-flex;
  align-items: stretch;
}

.circuit-group__handle {
  min-height: 30px;
  display: inline-flex;
  align-items: center;
  gap: 7px;
  border: 1px solid color-mix(in srgb, var(--raven-muted) 32%, var(--raven-border));
  border-radius: 999px;
  padding: 0 10px;
  background: color-mix(in srgb, var(--raven-panel-raised) 94%, transparent);
  color: var(--raven-muted);
  cursor: grab;
  touch-action: none;
  user-select: none;
  box-shadow: 0 8px 20px rgb(0 0 0 / 0.22);
}

.circuit-group__handle:active,
.circuit-group.is-dragging .circuit-group__handle {
  cursor: grabbing;
}

.circuit-group.is-dragging {
  z-index: 5;
  transition: none;
}

.circuit-group.is-selected .circuit-group__handle {
  border-color: color-mix(in srgb, var(--raven-accent) 58%, var(--raven-border));
}

.circuit-group__grip {
  color: var(--raven-faint);
}

.circuit-group__handle strong {
  color: var(--raven-text);
  font-size: 11px;
}

.circuit-group__handle small {
  color: var(--raven-faint);
  font-size: 8px;
  font-weight: 750;
  letter-spacing: 0.035em;
  text-transform: uppercase;
}

.circuit-group__handle b {
  border-left: 1px solid var(--raven-border);
  padding-left: 8px;
  color: var(--raven-muted);
  font-size: 10px;
}

.circuit-group__toggle {
  width: 30px;
  min-height: 30px;
  display: grid;
  place-items: center;
  margin-left: 4px;
  border: 1px solid var(--raven-border);
  border-radius: 999px;
  background: var(--raven-panel-raised);
  color: var(--raven-faint);
  cursor: pointer;
}

.circuit-group__toggle:hover {
  color: var(--raven-text);
}

.circuit-group__resize {
  position: absolute;
  right: 4px;
  bottom: 4px;
  width: 22px;
  height: 22px;
  display: grid;
  place-items: center;
  border: 0;
  background: transparent;
  color: var(--raven-faint);
  cursor: nwse-resize;
  touch-action: none;
}

.circuit-group.is-collapsed {
  z-index: 1;
  border-style: solid;
  background: color-mix(in srgb, var(--raven-panel-raised) 94%, transparent);
}
</style>
