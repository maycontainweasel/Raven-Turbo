<script setup lang="ts">
import { storeToRefs } from 'pinia'
import type { BucketPrototypeEdge } from '~/stores/bucketsPrototype'
import type { BucketPrototypeNode } from '~/types/buckets'

type CircuitGroupBounds = {
  x: number
  y: number
  width: number
  height: number
}

const props = withDefaults(defineProps<{
  zoom?: number
  immersive?: boolean
  showEditorButton?: boolean
  markerId?: string
}>(), {
  zoom: 1,
  immersive: false,
  showEditorButton: false,
  markerId: 'bucket-circuit-arrow',
})

const emit = defineEmits<{
  openEditor: []
  zoomChange: [zoom: number]
}>()

const store = useBucketsPrototypeStore()
const { selectedId, positions, flatNodes, edges, collapsedIds } = storeToRefs(store)
const viewport = ref<HTMLElement | null>(null)
const spacePressed = ref(false)
const panning = ref(false)
const scrolling = ref(false)
const groupNodes = computed(() => flatNodes.value.filter(({ node }) => node.presentation === 'group'))
const hiddenNodeIds = computed(() => {
  const result = new Set<string>()
  const collect = (node: BucketPrototypeNode) => {
    for (const child of node.children ?? []) {
      result.add(child.id)
      collect(child)
    }
  }
  for (const { node } of groupNodes.value) {
    if (collapsedIds.value.includes(node.id)) collect(node)
  }
  return result
})
const regularNodes = computed(() =>
  flatNodes.value.filter(({ node }) => node.presentation !== 'group' && !hiddenNodeIds.value.has(node.id)),
)
const visibleEdges = computed(() =>
  edges.value.filter(edge => !hiddenNodeIds.value.has(edge.sourceId) && !hiddenNodeIds.value.has(edge.targetId)),
)
const graphWidth = computed(() => {
  const furthestNode = Math.max(...Object.values(positions.value).map(position => position.x), 760)
  return Math.max(1120, furthestNode + 380)
})
const graphHeight = computed(() => {
  const lowestNode = Math.max(...Object.values(positions.value).map(position => position.y), 720)
  return Math.max(920, lowestNode + 140)
})
const canvasWidth = computed(() => props.immersive ? Math.max(4000, graphWidth.value + 1800) : graphWidth.value)
const canvasHeight = computed(() => props.immersive ? Math.max(3000, graphHeight.value + 1200) : graphHeight.value)
const graphOffset = computed(() => props.immersive ? { x: 1200, y: 480 } : { x: 0, y: 0 })
const scaledCanvasStyle = computed(() => ({
  width: `${Math.round(canvasWidth.value * props.zoom)}px`,
  height: `${Math.round(canvasHeight.value * props.zoom)}px`,
}))
const canvasStyle = computed(() => ({
  width: `${canvasWidth.value}px`,
  height: `${canvasHeight.value}px`,
  transform: `scale(${props.zoom})`,
}))
const graphStyle = computed(() => ({
  width: `${graphWidth.value}px`,
  height: `${graphHeight.value}px`,
  transform: `translate3d(${graphOffset.value.x}px, ${graphOffset.value.y}px, 0)`,
}))

let panPointerId: number | null = null
let panStartX = 0
let panStartY = 0
let panStartScrollLeft = 0
let panStartScrollTop = 0
let pendingZoomAnchor: {
  worldX: number
  worldY: number
  pointerX: number
  pointerY: number
} | null = null
let scrollIdleTimer: ReturnType<typeof setTimeout> | null = null

function formatMinor(value: number) {
  return new Intl.NumberFormat('en-ZA', {
    style: 'currency',
    currency: 'ZAR',
    currencyDisplay: 'narrowSymbol',
    maximumFractionDigits: 0,
  }).format(value / 100)
}

function nodeWidth(nodeId: string) {
  return store.findNode(nodeId)?.allocationKind === 'source' ? 260 : 240
}

function nodeHeight(nodeId: string) {
  return store.findNode(nodeId)?.displayMode === 'compact' ? 76 : 48
}

function groupBoundsFor(node: BucketPrototypeNode): CircuitGroupBounds {
  const position = positions.value[node.id] ?? { x: 580, y: 180 }
  if (collapsedIds.value.includes(node.id)) {
    return { x: position.x, y: position.y, width: 280, height: 52 }
  }
  const frame = store.groupFrameFor(node.id)
  const descendants: BucketPrototypeNode[] = []
  const collectDescendants = (children: BucketPrototypeNode[]) => {
    for (const child of children) {
      descendants.push(child)
      if (child.children?.length) collectDescendants(child.children)
    }
  }
  collectDescendants(node.children ?? [])
  const members = descendants
    .map(child => ({ node: child, position: positions.value[child.id] }))
    .filter((entry): entry is { node: BucketPrototypeNode; position: { x: number; y: number } } => Boolean(entry.position))

  if (!members.length) {
    return {
      x: position.x,
      y: position.y,
      width: frame.minWidth,
      height: frame.minHeight,
    }
  }

  const minX = Math.min(...members.map(({ position }) => position.x)) - frame.paddingX
  const maxX = Math.max(...members.map(({ node: child, position }) => position.x + nodeWidth(child.id))) + frame.paddingX
  const minY = Math.min(...members.map(({ position }) => position.y)) - frame.paddingTop
  const maxY = Math.max(...members.map(({ node: child, position }) => position.y + nodeHeight(child.id))) + frame.paddingBottom
  return {
    x: minX,
    y: minY,
    width: Math.max(frame.minWidth, maxX - minX),
    height: Math.max(frame.minHeight, maxY - minY),
  }
}

function inputAnchor(nodeId: string) {
  const node = store.findNode(nodeId)
  const position = positions.value[nodeId]
  if (!node || !position) return null
  if (node.presentation === 'group') {
    const bounds = groupBoundsFor(node)
    return { x: bounds.x + bounds.width / 2, y: bounds.y }
  }
  return { x: position.x + nodeWidth(nodeId) / 2, y: position.y }
}

function outputAnchor(nodeId: string) {
  const node = store.findNode(nodeId)
  const position = positions.value[nodeId]
  if (!node || !position) return null
  if (node.presentation === 'group') {
    const bounds = groupBoundsFor(node)
    return { x: bounds.x + bounds.width / 2, y: bounds.y + 30 }
  }
  return { x: position.x + nodeWidth(nodeId) / 2, y: position.y + nodeHeight(nodeId) }
}

function edgePath(edge: BucketPrototypeEdge) {
  const source = positions.value[edge.sourceId]
  const target = positions.value[edge.targetId]
  if (!source || !target) return ''

  if (edge.kind === 'rule') {
    const sourceX = source.x
    const sourceY = source.y + nodeHeight(edge.sourceId) / 2
    const targetX = target.x + nodeWidth(edge.targetId)
    const targetY = target.y + nodeHeight(edge.targetId) / 2
    const routeX = Math.round((sourceX + targetX) / 2)
    return `M ${sourceX} ${sourceY} H ${routeX} V ${targetY} H ${targetX}`
  }

  const sourcePoint = outputAnchor(edge.sourceId)
  const targetPoint = inputAnchor(edge.targetId)
  if (!sourcePoint || !targetPoint) return ''
  const sourceX = sourcePoint.x
  const sourceY = sourcePoint.y
  const targetX = targetPoint.x
  const targetY = targetPoint.y
  const middleY = Math.round((sourceY + targetY) / 2)
  return `M ${sourceX} ${sourceY} V ${middleY} H ${targetX} V ${targetY}`
}

function edgeLabel(edge: BucketPrototypeEdge) {
  const source = positions.value[edge.sourceId]
  const target = positions.value[edge.targetId]
  if (!source || !target) return { x: 0, y: 0 }

  if (edge.kind === 'rule') {
    const sourceX = source.x
    const sourceY = source.y + nodeHeight(edge.sourceId) / 2
    const targetX = target.x + nodeWidth(edge.targetId)
    const targetY = target.y + nodeHeight(edge.targetId) / 2
    return {
      x: Math.round((sourceX + targetX) / 2),
      y: Math.round((sourceY + targetY) / 2),
    }
  }

  const sourcePoint = outputAnchor(edge.sourceId)
  const targetPoint = inputAnchor(edge.targetId)
  if (!sourcePoint || !targetPoint) return { x: 0, y: 0 }
  const sourceX = sourcePoint.x
  const targetX = targetPoint.x
  const sourceY = sourcePoint.y
  const targetY = targetPoint.y
  return {
    x: Math.round((sourceX + targetX) / 2),
    y: Math.round((sourceY + targetY) / 2) - 9,
  }
}

function isTypingTarget(target: EventTarget | null) {
  const element = target instanceof HTMLElement ? target : null
  return Boolean(element?.isContentEditable || element?.matches('input, textarea, select'))
}

function handleKeydown(event: KeyboardEvent) {
  if (!props.immersive || event.code !== 'Space' || isTypingTarget(event.target)) return
  event.preventDefault()
  spacePressed.value = true
}

function handleKeyup(event: KeyboardEvent) {
  if (event.code !== 'Space') return
  spacePressed.value = false
  if (panning.value) endPan()
}

function beginPan(event: PointerEvent) {
  const element = viewport.value
  if (!props.immersive || !spacePressed.value || event.button !== 0 || !element) return
  event.preventDefault()
  event.stopPropagation()
  panPointerId = event.pointerId
  panning.value = true
  panStartX = event.clientX
  panStartY = event.clientY
  panStartScrollLeft = element.scrollLeft
  panStartScrollTop = element.scrollTop
  element.setPointerCapture(event.pointerId)
  window.addEventListener('pointermove', pan)
  window.addEventListener('pointerup', endPan)
  window.addEventListener('pointercancel', endPan)
}

function pan(event: PointerEvent) {
  const element = viewport.value
  if (panPointerId !== event.pointerId || !element) return
  element.scrollLeft = panStartScrollLeft - (event.clientX - panStartX)
  element.scrollTop = panStartScrollTop - (event.clientY - panStartY)
}

function endPan(event?: PointerEvent) {
  if (event && panPointerId !== event.pointerId) return
  panPointerId = null
  panning.value = false
  window.removeEventListener('pointermove', pan)
  window.removeEventListener('pointerup', endPan)
  window.removeEventListener('pointercancel', endPan)
}

function handleScroll() {
  scrolling.value = true
  if (scrollIdleTimer) clearTimeout(scrollIdleTimer)
  scrollIdleTimer = setTimeout(() => {
    scrolling.value = false
    scrollIdleTimer = null
  }, 720)
}

function handleWheel(event: WheelEvent) {
  const element = viewport.value
  if (!props.immersive || !(event.metaKey || event.ctrlKey) || !element) return
  event.preventDefault()
  const rect = element.getBoundingClientRect()
  const pointerX = event.clientX - rect.left
  const pointerY = event.clientY - rect.top
  pendingZoomAnchor = {
    worldX: (element.scrollLeft + pointerX) / props.zoom,
    worldY: (element.scrollTop + pointerY) / props.zoom,
    pointerX,
    pointerY,
  }
  const nextZoom = Math.min(1.6, Math.max(0.5, Number((props.zoom + (event.deltaY < 0 ? 0.1 : -0.1)).toFixed(2))))
  if (nextZoom !== props.zoom) emit('zoomChange', nextZoom)
}

async function focusGraph() {
  if (!props.immersive) return
  await nextTick()
  const element = viewport.value
  if (!element) return
  element.scrollTo({
    left: Math.max(0, graphOffset.value.x * props.zoom - element.clientWidth * 0.18),
    top: Math.max(0, graphOffset.value.y * props.zoom - 56),
    behavior: 'auto',
  })
}

watch(() => props.zoom, async (zoom) => {
  if (!pendingZoomAnchor) return
  await nextTick()
  const element = viewport.value
  if (!element) return
  element.scrollLeft = pendingZoomAnchor.worldX * zoom - pendingZoomAnchor.pointerX
  element.scrollTop = pendingZoomAnchor.worldY * zoom - pendingZoomAnchor.pointerY
  pendingZoomAnchor = null
})

onMounted(() => {
  window.addEventListener('keydown', handleKeydown)
  window.addEventListener('keyup', handleKeyup)
  if (props.immersive) void focusGraph()
})

onBeforeUnmount(() => {
  window.removeEventListener('keydown', handleKeydown)
  window.removeEventListener('keyup', handleKeyup)
  if (scrollIdleTimer) clearTimeout(scrollIdleTimer)
  endPan()
})

defineExpose({ focusGraph })
</script>

<template>
  <section class="circuit-shell raven-surface" :class="{ 'circuit-shell--immersive': immersive }">
    <header class="circuit-shell__header">
      <div>
        <span class="raven-eyebrow">{{ immersive ? 'Editing canvas' : 'Circuit view' }}</span>
        <strong>Monthly allocation flow</strong>
      </div>
      <p>Drag any node. Positions snap to a 20px grid; the allocation order remains deterministic.</p>
      <div class="circuit-legend">
        <span><i /> Accumulator</span>
        <span><i class="is-expense" /> Expense</span>
        <span><i class="is-budget" /> Budget</span>
        <span><i class="is-series" /> Flow group</span>
      </div>
      <button
        v-if="showEditorButton"
        class="circuit-open-editor raven-button"
        type="button"
        @click="emit('openEditor')"
      >
        <span class="i-lucide-maximize-2" aria-hidden="true" />
        Open editor
      </button>
    </header>

    <div
      ref="viewport"
      class="circuit-viewport"
      :class="{
        'is-space-ready': immersive && spacePressed,
        'is-panning': panning,
        'is-scrolling': scrolling,
      }"
      :aria-label="immersive ? 'Circuit canvas. Hold Space and drag to pan. Hold Command and use the mouse wheel to zoom.' : 'Circuit canvas'"
      @wheel="handleWheel"
      @scroll.passive="handleScroll"
      @pointerdown.capture="beginPan"
    >
      <div class="circuit-stage" :style="scaledCanvasStyle">
        <div class="circuit-canvas" :style="canvasStyle">
          <div class="circuit-graph" :style="graphStyle">
            <BucketCircuitGroup
              v-for="{ node } in groupNodes"
              :key="node.id"
              :node="node"
              :bounds="groupBoundsFor(node)"
              :position="positions[node.id] ?? { x: 20, y: 20 }"
              :metric="store.metricFor(node)"
              :selected="selectedId === node.id"
              :collapsed="collapsedIds.includes(node.id)"
              :format-minor="formatMinor"
              :scale="zoom"
              @select="store.selectNode"
              @toggle="store.toggleNode"
              @move="store.moveGroup($event.id, $event.x, $event.y)"
              @resize="store.resizeGroup($event.id, $event.width, $event.height)"
            />

            <svg
              class="circuit-connectors"
              :width="graphWidth"
              :height="graphHeight"
              aria-label="Connections between bucket nodes"
            >
              <defs>
                <marker :id="markerId" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto" markerUnits="strokeWidth">
                  <path d="M 0 0 L 8 4 L 0 8 z" fill="currentColor" />
                </marker>
              </defs>
              <g v-for="edge in visibleEdges" :key="edge.id" :class="['circuit-edge', `is-${edge.kind}`]">
                <path :d="edgePath(edge)" :marker-end="`url(#${markerId})`" />
                <g class="circuit-edge__label" :transform="`translate(${edgeLabel(edge).x}, ${edgeLabel(edge).y})`">
                  <rect x="-50" y="-13" width="100" height="26" rx="13" />
                  <text text-anchor="middle" dominant-baseline="middle">{{ formatMinor(edge.amountMinor) }}</text>
                </g>
              </g>
            </svg>

            <BucketCircuitNode
              v-for="{ node } in regularNodes"
              :key="node.id"
              :node="node"
              :position="positions[node.id] ?? { x: 20, y: 20 }"
              :metric="store.metricFor(node)"
              :selected="selectedId === node.id"
              :format-minor="formatMinor"
              :scale="zoom"
              @select="store.selectNode"
              @move="store.moveNode($event.id, $event.x, $event.y)"
              @rename="store.renameNode"
              @create="store.addNodeFrom($event.sourceId, $event.direction, $event.kind)"
            />
          </div>
        </div>
      </div>
    </div>

    <footer class="circuit-shell__footer">
      <span v-if="immersive"><kbd>Space</kbd> + drag to pan</span>
      <span v-if="immersive"><kbd>⌘</kbd> + wheel to zoom</span>
      <span v-else><i class="i-lucide-move" aria-hidden="true" /> Drag to arrange</span>
      <span><i class="i-lucide-mouse-pointer-2" aria-hidden="true" /> Select to inspect</span>
      <span><i class="i-lucide-text-cursor-input" aria-hidden="true" /> Double-click a title to rename</span>
      <strong>{{ regularNodes.length + groupNodes.length }} visible nodes · {{ visibleEdges.length }} connections</strong>
    </footer>
  </section>
</template>

<style scoped>
.circuit-shell {
  min-width: 0;
  overflow: hidden;
}

.circuit-shell--immersive {
  height: 100%;
  display: grid;
  grid-template-rows: auto minmax(0, 1fr) auto;
  border-radius: 0;
}

.circuit-shell__header {
  min-height: 58px;
  display: flex;
  align-items: center;
  gap: 18px;
  border-bottom: 1px solid var(--raven-border);
  padding: 10px 14px;
}

.circuit-shell__header > div:first-child {
  display: grid;
  gap: 3px;
}

.circuit-shell__header strong {
  font-size: 12px;
}

.circuit-shell__header p {
  max-width: 440px;
  margin: 0;
  color: var(--raven-faint);
  font-size: 10px;
}

.circuit-legend {
  display: flex;
  gap: 12px;
  margin-left: auto;
  color: var(--raven-faint);
  font-size: 9px;
}

.circuit-legend span {
  display: flex;
  align-items: center;
  gap: 5px;
}

.circuit-legend i {
  width: 16px;
  height: 2px;
  display: block;
  background: var(--raven-accent);
}

.circuit-legend i.is-expense {
  background: var(--raven-danger);
}

.circuit-legend i.is-budget {
  background: var(--raven-warning);
}

.circuit-legend i.is-series {
  background: var(--raven-muted);
}

.circuit-open-editor {
  flex: 0 0 auto;
}

.circuit-viewport {
  max-height: min(70vh, 880px);
  overflow: auto;
  overscroll-behavior: contain;
  scrollbar-color: transparent transparent;
  scrollbar-width: thin;
}

.circuit-viewport::-webkit-scrollbar {
  width: 7px;
  height: 7px;
}

.circuit-viewport::-webkit-scrollbar-track {
  background: transparent;
}

.circuit-viewport::-webkit-scrollbar-thumb {
  border: 2px solid transparent;
  border-radius: 999px;
  background: transparent;
  background-clip: padding-box;
  transition: background-color 160ms ease;
}

.circuit-viewport::-webkit-scrollbar-corner {
  background: transparent;
}

.circuit-viewport.is-scrolling,
.circuit-viewport:focus-within {
  scrollbar-color: color-mix(in srgb, var(--raven-text) 22%, transparent) transparent;
}

.circuit-viewport.is-scrolling::-webkit-scrollbar-thumb,
.circuit-viewport:focus-within::-webkit-scrollbar-thumb {
  background-color: color-mix(in srgb, var(--raven-text) 26%, transparent);
}

.circuit-viewport.is-scrolling::-webkit-scrollbar-thumb:hover,
.circuit-viewport:focus-within::-webkit-scrollbar-thumb:hover {
  background-color: color-mix(in srgb, var(--raven-text) 38%, transparent);
}

.circuit-viewport.is-space-ready {
  cursor: grab;
  user-select: none;
}

.circuit-viewport.is-panning {
  cursor: grabbing;
}

.circuit-shell--immersive .circuit-viewport {
  max-height: none;
}

.circuit-stage {
  position: relative;
}

.circuit-canvas {
  position: absolute;
  inset: 0 auto auto 0;
  transform-origin: top left;
  background-color: #050605;
  background-image:
    linear-gradient(var(--raven-border-subtle) 1px, transparent 1px),
    linear-gradient(90deg, var(--raven-border-subtle) 1px, transparent 1px),
    linear-gradient(color-mix(in srgb, var(--raven-border-subtle) 58%, transparent) 1px, transparent 1px),
    linear-gradient(90deg, color-mix(in srgb, var(--raven-border-subtle) 58%, transparent) 1px, transparent 1px);
  background-position: -1px -1px;
  background-size: 100px 100px, 100px 100px, 20px 20px, 20px 20px;
}

.circuit-graph {
  position: absolute;
  inset: 0 auto auto 0;
}

.circuit-connectors {
  position: absolute;
  inset: 0;
  z-index: 1;
  overflow: visible;
  color: var(--raven-accent);
  pointer-events: none;
}

.circuit-edge path {
  fill: none;
  stroke: currentColor;
  stroke-width: 1.5;
  vector-effect: non-scaling-stroke;
}

.circuit-edge.is-series {
  color: color-mix(in srgb, var(--raven-accent) 64%, var(--raven-muted));
}

.circuit-edge.is-rule {
  color: #8792ff;
}

.circuit-edge.is-rule path {
  stroke-dasharray: 5 5;
}

.circuit-edge.is-rule rect {
  stroke: color-mix(in srgb, #8792ff 62%, var(--raven-border));
}

.circuit-edge rect {
  fill: #0d0f0e;
  stroke: color-mix(in srgb, var(--raven-text) 28%, var(--raven-border));
  stroke-width: 1.2;
  filter: drop-shadow(0 5px 8px rgb(0 0 0 / 0.44));
}

.circuit-edge text {
  fill: var(--raven-text);
  font-size: 10.5px;
  font-weight: 780;
  letter-spacing: 0.01em;
}

.circuit-shell__footer {
  min-height: 38px;
  display: flex;
  align-items: center;
  gap: 18px;
  border-top: 1px solid var(--raven-border);
  padding: 0 14px;
  color: var(--raven-faint);
  background: var(--raven-panel);
  font-size: 9px;
}

.circuit-shell__footer span {
  display: inline-flex;
  align-items: center;
  gap: 5px;
}

.circuit-shell__footer kbd {
  min-width: 20px;
  height: 20px;
  display: inline-grid;
  place-items: center;
  border: 1px solid var(--raven-border);
  border-bottom-color: color-mix(in srgb, var(--raven-text) 34%, var(--raven-border));
  border-radius: 4px;
  padding: 0 5px;
  color: var(--raven-muted);
  background: var(--raven-panel-subtle);
  font: inherit;
  font-weight: 800;
}

.circuit-shell__footer strong {
  margin-left: auto;
  color: var(--raven-muted);
  font-size: inherit;
}

@media (max-width: 860px) {
  .circuit-shell__header {
    align-items: start;
    flex-direction: column;
  }

  .circuit-legend {
    margin-left: 0;
  }

  .circuit-shell__footer {
    align-items: start;
    flex-direction: column;
    gap: 5px;
    padding: 10px 14px;
  }

  .circuit-shell__footer strong {
    margin-left: 0;
  }
}
</style>
