<script setup lang="ts">
import { useHeliosRuntimeStore } from '../../stores/heliosRuntime'

const props = defineProps<{
  documentId: string
  zoneId: string
}>()

const runtime = useHeliosRuntimeStore()
const panelEl = ref<HTMLElement | null>(null)
const position = ref({ x: 16, y: 72 })
const dragState = ref<{
  pointerId: number
  startX: number
  startY: number
  originX: number
  originY: number
} | null>(null)

const STORAGE_KEY = 'helios.runtime.navigatorPosition'

const frames = computed(() => (
  runtime?.nodesForZone?.(props.documentId, props.zoneId) ?? []
))

const activeContextNodeId = computed(() => (
  runtime?.activeContextNodeIdForZone?.(props.documentId, props.zoneId) ?? null
))

const panelStyle = computed(() => ({
  left: `${position.value.x}px`,
  top: `${position.value.y}px`,
}))

const clampPosition = (next: { x: number; y: number }) => {
  if (typeof window === 'undefined') return next
  const bounds = panelEl.value?.getBoundingClientRect()
  const width = bounds?.width || 300
  const height = bounds?.height || 460
  const margin = 8
  return {
    x: Math.max(margin, Math.min(window.innerWidth - width - margin, next.x)),
    y: Math.max(margin, Math.min(window.innerHeight - height - margin, next.y)),
  }
}

const savePosition = () => {
  if (typeof window === 'undefined') return
  window.localStorage.setItem(STORAGE_KEY, JSON.stringify(position.value))
}

const onPanelPointerDown = (event: PointerEvent) => {
  if ((event.target as HTMLElement | null)?.closest('button')) return
  event.preventDefault()
  dragState.value = {
    pointerId: event.pointerId,
    startX: event.clientX,
    startY: event.clientY,
    originX: position.value.x,
    originY: position.value.y,
  }
  ;(event.currentTarget as HTMLElement).setPointerCapture(event.pointerId)
}

const onPanelPointerMove = (event: PointerEvent) => {
  const state = dragState.value
  if (!state || state.pointerId !== event.pointerId) return
  position.value = clampPosition({
    x: state.originX + event.clientX - state.startX,
    y: state.originY + event.clientY - state.startY,
  })
}

const onPanelPointerUp = (event: PointerEvent) => {
  const state = dragState.value
  if (!state || state.pointerId !== event.pointerId) return
  dragState.value = null
  savePosition()
}

const frameRows = computed(() => {
  const rows: Array<{ node: any; level: number }> = []
  const visit = (node: any, level: number) => {
    rows.push({ node, level })
    for (const child of runtime?.childNodesFor?.(node.id) ?? []) {
      visit(child, level + 1)
    }
  }

  for (const node of runtime?.rootNodesForZone?.(props.documentId, props.zoneId) ?? []) {
    visit(node, 0)
  }
  return rows
})

const selectFrame = (id: string) => {
  runtime?.selectNode?.(id)
}

const toggleLock = async (id: string) => {
  await runtime?.toggleNodeLock?.(id)
}

const toggleContext = (id: string) => {
  if (activeContextNodeId.value === id) {
    runtime?.exitNodeContext?.(props.documentId, props.zoneId)
    return
  }
  runtime?.enterNodeContext?.(id)
}

onMounted(() => {
  if (typeof window === 'undefined') return
  const saved = window.localStorage.getItem(STORAGE_KEY)
  const fallback = {
    x: Math.max(16, window.innerWidth - 316),
    y: 72,
  }
  if (!saved) {
    position.value = clampPosition(fallback)
    return
  }
  try {
    const parsed = JSON.parse(saved)
    position.value = clampPosition({
      x: Number(parsed.x) || fallback.x,
      y: Number(parsed.y) || fallback.y,
    })
  } catch {
    position.value = clampPosition(fallback)
  }
})
</script>

<template>
  <aside
    v-if="runtime?.navigatorOpen"
    ref="panelEl"
    class="helios-frame-navigator"
    :style="panelStyle"
  >
    <header
      class="helios-frame-navigator__header"
      @pointerdown="onPanelPointerDown"
      @pointermove="onPanelPointerMove"
      @pointerup="onPanelPointerUp"
      @pointercancel="onPanelPointerUp"
    >
      <strong>Nodes</strong>
      <button type="button" title="Close" @click="runtime?.toggleNavigator?.()">
        <span class="i-lucide-x" aria-hidden="true" />
      </button>
    </header>
    <div class="helios-frame-navigator__meta">
      {{ runtime?.activeBreakpoint || 'base' }} / {{ frames.length }}
      <button
        v-if="activeContextNodeId"
        type="button"
        @click="runtime?.exitNodeContext?.(props.documentId, props.zoneId)"
      >
        Exit context
      </button>
    </div>
    <ol class="helios-frame-navigator__list">
      <li
        v-for="row in frameRows"
        :key="row.node.id"
        :style="{ '--frame-level': row.level }"
      >
        <button
          type="button"
          class="helios-frame-navigator__row"
          :class="{
            'is-selected': runtime?.selectedNodeId === row.node.id,
            'is-context': activeContextNodeId === row.node.id,
          }"
          @click="selectFrame(row.node.id)"
        >
          <span>{{ row.node.label || row.node.record?.display || row.node.id }}</span>
          <small>{{ row.node.kind }}</small>
        </button>
        <div class="helios-frame-navigator__actions">
          <button
            v-if="row.node.kind === 'frame'"
            type="button"
            :class="{ 'is-active': activeContextNodeId === row.node.id }"
            :title="activeContextNodeId === row.node.id ? 'Exit frame context' : 'Enter frame context'"
            @click="toggleContext(row.node.id)"
          >
            <span
              :class="activeContextNodeId === row.node.id ? 'i-lucide-log-out' : 'i-lucide-corner-down-right'"
              aria-hidden="true"
            />
          </button>
          <button
            type="button"
            :class="{ 'is-active': runtime?.isNodeLocked?.(row.node.id) }"
            :title="runtime?.isNodeLocked?.(row.node.id) ? 'Unlock node' : 'Lock node'"
            @click="toggleLock(row.node.id)"
          >
            <span
              :class="runtime?.isNodeLocked?.(row.node.id) ? 'i-lucide-lock' : 'i-lucide-unlock'"
              aria-hidden="true"
            />
          </button>
          <button
            type="button"
            title="Delete node"
            :disabled="runtime?.isNodeLocked?.(row.node.id)"
            @click="runtime?.deleteNode?.(row.node.id)"
          >
            <span class="i-lucide-trash-2" aria-hidden="true" />
          </button>
        </div>
      </li>
    </ol>
  </aside>
</template>

<style scoped>
.helios-frame-navigator {
  position: fixed;
  z-index: 75;
  display: grid;
  width: min(300px, calc(100vw - 32px));
  max-height: min(460px, calc(100vh - 96px));
  overflow: hidden;
  border: 1px solid rgba(11, 18, 32, 0.14);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.94);
  box-shadow: 0 18px 44px rgba(11, 18, 32, 0.16);
  backdrop-filter: blur(16px);
}

.helios-frame-navigator__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 10px 8px 12px;
  border-bottom: 1px solid rgba(11, 18, 32, 0.08);
  cursor: grab;
  touch-action: none;
  user-select: none;
}

.helios-frame-navigator__header:active {
  cursor: grabbing;
}

.helios-frame-navigator__header strong {
  font-size: 13px;
}

.helios-frame-navigator__header button,
.helios-frame-navigator__actions button {
  display: grid;
  width: 28px;
  height: 28px;
  place-items: center;
  border: 0;
  border-radius: 6px;
  color: #334155;
  background: transparent;
  cursor: pointer;
}

.helios-frame-navigator__header button:hover,
.helios-frame-navigator__actions button:hover,
.helios-frame-navigator__actions button.is-active {
  color: #ffffff;
  background: #2557d6;
}

.helios-frame-navigator__actions button:disabled {
  opacity: 0.42;
  cursor: default;
}

.helios-frame-navigator__actions button:disabled:hover {
  color: #334155;
  background: transparent;
}

.helios-frame-navigator__meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  padding: 8px 12px;
  color: #64748b;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0;
  text-transform: uppercase;
}

.helios-frame-navigator__meta button {
  border: 0;
  border-radius: 5px;
  padding: 5px 7px;
  color: #2557d6;
  background: rgba(37, 87, 214, 0.1);
  font-size: 10px;
  font-weight: 800;
  cursor: pointer;
  text-transform: uppercase;
}

.helios-frame-navigator__list {
  display: grid;
  gap: 2px;
  overflow: auto;
  margin: 0;
  padding: 0 8px 8px;
  list-style: none;
}

.helios-frame-navigator__list li {
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 4px;
  align-items: center;
}

.helios-frame-navigator__row {
  display: grid;
  min-width: 0;
  padding: 8px 8px 8px calc(8px + (var(--frame-level, 0) * 14px));
  border: 0;
  border-radius: 6px;
  color: #0f172a;
  background: transparent;
  text-align: left;
  cursor: pointer;
}

.helios-frame-navigator__row:hover,
.helios-frame-navigator__row.is-selected,
.helios-frame-navigator__row.is-context {
  background: rgba(37, 87, 214, 0.1);
}

.helios-frame-navigator__row.is-context {
  box-shadow: inset 3px 0 0 #2557d6;
}

.helios-frame-navigator__row span,
.helios-frame-navigator__row small {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.helios-frame-navigator__row span {
  font-size: 12px;
  font-weight: 700;
}

.helios-frame-navigator__row small {
  color: #64748b;
  font-size: 11px;
}

.helios-frame-navigator__actions {
  display: flex;
  gap: 2px;
}
</style>
