<script setup lang="ts">
import { type HeliosGridCellValue, type HeliosInnerBoxValue, type HeliosNodeRecord } from '@helios/protocol'
import { useHeliosRuntimeStore, type HeliosRuntimeRect } from '../../stores/heliosRuntime'

const props = defineProps<{
  documentId: string
  zoneId: string
  cols?: number
  rows?: number
  rowPx?: number
  showGrid?: boolean
  midline?: boolean
}>()

type GridSize = {
  cols: number
  rows: number
  rowPx?: number
}

type ResizeHandle = 'n' | 'e' | 's' | 'w' | 'nw' | 'ne' | 'sw' | 'se'

type LocalPoint = {
  x: number
  y: number
  bounds: DOMRect
}

type OverlayInteraction =
  | {
    mode: 'draw'
    pointerId: number
    contextNode: HeliosNodeRecord | null
    grid: GridSize
    surface: HTMLElement
    start: LocalPoint
    lastRect: HeliosRuntimeRect
  }
  | {
    mode: 'move'
    pointerId: number
    nodeId: string
    grid: GridSize
    surface: HTMLElement
    start: LocalPoint
    startCell: HeliosGridCellValue
    lastCell: HeliosGridCellValue
  }
  | {
    mode: 'resize'
    pointerId: number
    nodeId: string
    resizeHandle: ResizeHandle
    grid: GridSize
    surface: HTMLElement
    start: LocalPoint
    startCell: HeliosGridCellValue
    lastCell: HeliosGridCellValue
  }
  | {
    mode: 'inner-resize'
    pointerId: number
    nodeId: string
    resizeHandle: ResizeHandle
    surface: HTMLElement
    start: LocalPoint
    startInnerBox: HeliosInnerBoxValue
    lastInnerBox: HeliosInnerBoxValue
  }

const runtime = useHeliosRuntimeStore()
const overlayEl = ref<HTMLElement | null>(null)
const framesEl = ref<HTMLElement | null>(null)
const interaction = ref<OverlayInteraction | null>(null)

const rootGrid = computed<GridSize>(() => ({
  cols: Math.max(1, Math.round(Number(props.cols || 24))),
  rows: Math.max(1, Math.round(Number(props.rows || 24))),
  rowPx: Math.max(1, Math.round(Number(props.rowPx || 32))),
}))

const zoneNodes = computed(() => runtime.rootNodesForZone(props.documentId, props.zoneId))

const activeContextNodeId = computed(() => (
  runtime.activeContextNodeIdForZone(props.documentId, props.zoneId)
))

const activeContextNode = computed(() => (
  runtime.activeContextNodeForZone(props.documentId, props.zoneId)
))

const contextLabel = computed(() => {
  const node = activeContextNode.value
  return node
    ? `Zone root / ${node.label || node.record?.display || node.id}`
    : 'Zone root'
})

const gridStyle = computed(() => ({
  '--helios-canvas-row-px': `${rootGrid.value.rowPx}px`,
  gridTemplateColumns: `repeat(${rootGrid.value.cols}, minmax(0, 1fr))`,
  gridTemplateRows: `repeat(${rootGrid.value.rows}, var(--helios-canvas-row-px))`,
}))

const gridLineStyle = computed(() => {
  const images = [
    'linear-gradient(to right, rgba(37, 87, 214, 0.2) 1px, transparent 1px)',
    'linear-gradient(to bottom, rgba(37, 87, 214, 0.2) 1px, transparent 1px)',
  ]
  const sizes = [
    `${100 / rootGrid.value.cols}% ${rootGrid.value.rowPx}px`,
    `${100 / rootGrid.value.cols}% ${rootGrid.value.rowPx}px`,
  ]

  if (props.midline !== false) {
    images.push('linear-gradient(to right, transparent calc(50% - 0.5px), rgba(224, 71, 38, 0.26) calc(50% - 0.5px), rgba(224, 71, 38, 0.26) calc(50% + 0.5px), transparent calc(50% + 0.5px))')
    sizes.push('100% 100%')
  }

  return {
    backgroundImage: images.join(', '),
    backgroundSize: sizes.join(', '),
  }
})

const draftStyle = computed(() => {
  const rect = runtime.draftRect
  if (!rect) return {}

  return {
    left: `${rect.x}px`,
    top: `${rect.y}px`,
    width: `${rect.w}px`,
    height: `${rect.h}px`,
  }
})

const gridForParent = (node: HeliosNodeRecord | null | undefined): GridSize => {
  const container = runtime.getNodeGridContainer(node)
  return {
    cols: Math.max(1, Math.round(Number(container?.cols || rootGrid.value.cols || 24))),
    rows: Math.max(1, Math.round(Number(container?.rows || rootGrid.value.rows || 24))),
  }
}

const getChildrenSurface = (nodeId: string | null | undefined) => {
  if (!nodeId) return framesEl.value
  const surfaces = overlayEl.value?.querySelectorAll<HTMLElement>('[data-helios-children-for]') ?? []
  return Array.from(surfaces).find((surface) => surface.dataset.heliosChildrenFor === nodeId) ?? null
}

const getLocalPoint = (
  event: PointerEvent,
  surface: HTMLElement | null = framesEl.value,
): LocalPoint | null => {
  const bounds = surface?.getBoundingClientRect()
  if (!bounds) return null

  return {
    x: Math.max(0, Math.min(bounds.width, event.clientX - bounds.left)),
    y: Math.max(0, Math.min(bounds.height, event.clientY - bounds.top)),
    bounds,
  }
}

const buildRect = (
  start: { x: number; y: number },
  end: { x: number; y: number },
): HeliosRuntimeRect => {
  const x = Math.min(start.x, end.x)
  const y = Math.min(start.y, end.y)
  return {
    x,
    y,
    w: Math.abs(end.x - start.x),
    h: Math.abs(end.y - start.y),
  }
}

const rectToCell = (
  rect: HeliosRuntimeRect,
  bounds: DOMRect,
  grid: GridSize,
): HeliosGridCellValue => {
  const cellW = Math.max(1, bounds.width / grid.cols)
  const cellH = Math.max(1, grid.rowPx || bounds.height / grid.rows)
  const colStart = Math.max(1, Math.min(grid.cols, Math.floor(rect.x / cellW) + 1))
  const rowStart = Math.max(1, Math.min(grid.rows, Math.floor(rect.y / cellH) + 1))
  const colEnd = Math.max(colStart + 1, Math.min(grid.cols + 1, Math.ceil((rect.x + rect.w) / cellW) + 1))
  const rowEnd = Math.max(rowStart + 1, Math.min(grid.rows + 1, Math.ceil((rect.y + rect.h) / cellH) + 1))

  return {
    cols: grid.cols,
    rows: grid.rows,
    colStart,
    colEnd,
    rowStart,
    rowEnd,
  }
}

const cellToRect = (
  cell: HeliosGridCellValue,
  bounds: DOMRect,
  grid: GridSize,
): HeliosRuntimeRect => {
  const cellW = Math.max(1, bounds.width / grid.cols)
  const cellH = Math.max(1, grid.rowPx || bounds.height / grid.rows)
  return {
    x: (cell.colStart - 1) * cellW,
    y: (cell.rowStart - 1) * cellH,
    w: Math.max(1, cell.colEnd - cell.colStart) * cellW,
    h: Math.max(1, cell.rowEnd - cell.rowStart) * cellH,
  }
}

const snapRect = (
  rect: HeliosRuntimeRect,
  bounds: DOMRect,
  grid: GridSize,
) => cellToRect(rectToCell(rect, bounds, grid), bounds, grid)

const toOverlayRect = (
  rect: HeliosRuntimeRect,
  surfaceBounds: DOMRect,
): HeliosRuntimeRect => {
  const overlayBounds = overlayEl.value?.getBoundingClientRect()
  if (!overlayBounds) return rect
  return {
    ...rect,
    x: rect.x + surfaceBounds.left - overlayBounds.left,
    y: rect.y + surfaceBounds.top - overlayBounds.top,
  }
}

const getEventElement = (event: PointerEvent) => (
  event.target instanceof Element ? event.target : null
)

const getNodeFromEvent = (event: PointerEvent) => {
  const element = getEventElement(event)
  return element?.closest<HTMLElement>('[data-helios-node]') ?? null
}

const getResizeHandleFromEvent = (event: PointerEvent) => {
  const element = getEventElement(event)
  return element?.closest<HTMLElement>('[data-helios-resize]') ?? null
}

const toResizeHandle = (handle: HTMLElement | null): ResizeHandle => {
  const direction = handle?.dataset.heliosResize
  return direction === 'n'
    || direction === 'e'
    || direction === 's'
    || direction === 'w'
    || direction === 'nw'
    || direction === 'ne'
    || direction === 'sw'
    || direction === 'se'
    ? direction
    : 'se'
}

const getNodeCell = (nodeId: string) => runtime.getNodeGridCell(runtime.getNodeById(nodeId))

const clampNumber = (value: number, min: number, max: number) => (
  Math.max(min, Math.min(max, value))
)

const translateCell = (
  cell: HeliosGridCellValue,
  point: LocalPoint,
  start: LocalPoint,
  grid: GridSize,
): HeliosGridCellValue => {
  const cellW = Math.max(1, point.bounds.width / grid.cols)
  const cellH = Math.max(1, grid.rowPx || point.bounds.height / grid.rows)
  const colDelta = Math.round((point.x - start.x) / cellW)
  const rowDelta = Math.round((point.y - start.y) / cellH)
  const width = Math.max(1, cell.colEnd - cell.colStart)
  const height = Math.max(1, cell.rowEnd - cell.rowStart)
  const colStart = Math.max(1, Math.min(grid.cols - width + 1, cell.colStart + colDelta))
  const rowStart = Math.max(1, Math.min(grid.rows - height + 1, cell.rowStart + rowDelta))

  return {
    ...cell,
    cols: grid.cols,
    rows: grid.rows,
    colStart,
    colEnd: colStart + width,
    rowStart,
    rowEnd: rowStart + height,
  }
}

const resizeCell = (
  cell: HeliosGridCellValue,
  point: LocalPoint,
  start: LocalPoint,
  grid: GridSize,
  handle: ResizeHandle,
  symmetric = false,
): HeliosGridCellValue => {
  const cellW = Math.max(1, point.bounds.width / grid.cols)
  const cellH = Math.max(1, grid.rowPx || point.bounds.height / grid.rows)
  const colDelta = Math.round((point.x - start.x) / cellW)
  const rowDelta = Math.round((point.y - start.y) / cellH)
  const width = Math.max(1, cell.colEnd - cell.colStart)
  const height = Math.max(1, cell.rowEnd - cell.rowStart)
  let colStart = cell.colStart
  let colEnd = cell.colEnd
  let rowStart = cell.rowStart
  let rowEnd = cell.rowEnd

  if (symmetric && handle.includes('w')) {
    const maxShrink = Math.floor((width - 1) / 2)
    const maxExpand = Math.min(cell.colStart - 1, grid.cols + 1 - cell.colEnd)
    const delta = clampNumber(colDelta, -maxExpand, maxShrink)
    colStart = cell.colStart + delta
    colEnd = cell.colEnd - delta
  } else if (symmetric && handle.includes('e')) {
    const maxShrink = Math.floor((width - 1) / 2)
    const maxExpand = Math.min(cell.colStart - 1, grid.cols + 1 - cell.colEnd)
    const delta = clampNumber(colDelta, -maxShrink, maxExpand)
    colStart = cell.colStart - delta
    colEnd = cell.colEnd + delta
  } else if (handle.includes('w')) {
    colStart = Math.max(1, Math.min(cell.colEnd - 1, cell.colStart + colDelta))
  } else if (handle.includes('e')) {
    colEnd = Math.max(cell.colStart + 1, Math.min(grid.cols + 1, cell.colEnd + colDelta))
  }

  if (symmetric && handle.includes('n')) {
    const maxShrink = Math.floor((height - 1) / 2)
    const maxExpand = Math.min(cell.rowStart - 1, grid.rows + 1 - cell.rowEnd)
    const delta = clampNumber(rowDelta, -maxExpand, maxShrink)
    rowStart = cell.rowStart + delta
    rowEnd = cell.rowEnd - delta
  } else if (symmetric && handle.includes('s')) {
    const maxShrink = Math.floor((height - 1) / 2)
    const maxExpand = Math.min(cell.rowStart - 1, grid.rows + 1 - cell.rowEnd)
    const delta = clampNumber(rowDelta, -maxShrink, maxExpand)
    rowStart = cell.rowStart - delta
    rowEnd = cell.rowEnd + delta
  } else if (handle.includes('n')) {
    rowStart = Math.max(1, Math.min(cell.rowEnd - 1, cell.rowStart + rowDelta))
  } else if (handle.includes('s')) {
    rowEnd = Math.max(cell.rowStart + 1, Math.min(grid.rows + 1, cell.rowEnd + rowDelta))
  }

  return {
    ...cell,
    cols: grid.cols,
    rows: grid.rows,
    colStart,
    colEnd,
    rowStart,
    rowEnd,
  }
}

const toInsetAmount = (value: number) => Math.max(0, Number(value.toFixed(4)))

const rhythmUnitPx = () => {
  if (typeof window === 'undefined') return 24
  const raw = window.getComputedStyle(document.documentElement).getPropertyValue('--h-gu')
  const parsed = Number.parseFloat(raw)
  return Number.isFinite(parsed) && parsed > 0 ? parsed : 24
}

const innerInsetDelta = (
  deltaPx: number,
  axis: 'x' | 'y',
  bounds: DOMRect,
  snapTo: HeliosInnerBoxValue['snapTo'],
) => {
  if (snapTo === 'rhythm-grid') {
    return Math.round(deltaPx / rhythmUnitPx())
  }
  const base = axis === 'x' ? bounds.width : bounds.height
  return Math.round((deltaPx / Math.max(1, base)) * 100)
}

const resizeInnerBox = (
  innerBox: HeliosInnerBoxValue,
  point: LocalPoint,
  start: LocalPoint,
  handle: ResizeHandle,
  symmetric = false,
): HeliosInnerBoxValue => {
  const snapTo = innerBox.snapTo || 'rhythm-grid'
  const dx = point.x - start.x
  const dy = point.y - start.y
  const next: HeliosInnerBoxValue = {
    ...innerBox,
    mode: innerBox.mode === 'none' ? 'inset' : innerBox.mode,
    snapTo,
  }

  if (handle.includes('w')) {
    const delta = innerInsetDelta(dx, 'x', point.bounds, snapTo)
    next.insetLeft = toInsetAmount(Number(innerBox.insetLeft || 0) + delta)
    if (symmetric) next.insetRight = toInsetAmount(Number(innerBox.insetRight || 0) + delta)
  }
  if (handle.includes('e')) {
    const delta = innerInsetDelta(-dx, 'x', point.bounds, snapTo)
    next.insetRight = toInsetAmount(Number(innerBox.insetRight || 0) + delta)
    if (symmetric) next.insetLeft = toInsetAmount(Number(innerBox.insetLeft || 0) + delta)
  }
  if (handle.includes('n')) {
    const delta = innerInsetDelta(dy, 'y', point.bounds, snapTo)
    next.insetTop = toInsetAmount(Number(innerBox.insetTop || 0) + delta)
    if (symmetric) next.insetBottom = toInsetAmount(Number(innerBox.insetBottom || 0) + delta)
  }
  if (handle.includes('s')) {
    const delta = innerInsetDelta(-dy, 'y', point.bounds, snapTo)
    next.insetBottom = toInsetAmount(Number(innerBox.insetBottom || 0) + delta)
    if (symmetric) next.insetTop = toInsetAmount(Number(innerBox.insetTop || 0) + delta)
  }

  return next
}

const getMoveContext = (node: HeliosNodeRecord, nodeEl: HTMLElement) => {
  const parent = node.parentId ? runtime.getNodeById(node.parentId) : null
  const surface = node.parentId
    ? getChildrenSurface(node.parentId)
    : framesEl.value
  return {
    parent,
    surface: surface ?? nodeEl.parentElement ?? framesEl.value,
    grid: parent ? gridForParent(parent) : rootGrid.value,
  }
}

const getDrawContext = () => {
  const contextNode = activeContextNode.value
  if (runtime.isNodeLocked(contextNode)) {
    runtime.error = 'Unlock parent frame before drawing inside it'
    return null
  }
  const surface = getChildrenSurface(contextNode?.id ?? null)
  if (!surface) return null
  return {
    contextNode,
    surface,
    grid: contextNode ? gridForParent(contextNode) : rootGrid.value,
  }
}

const capturePointer = (event: PointerEvent) => {
  const target = event.currentTarget as HTMLElement
  if (typeof target.setPointerCapture === 'function') {
    target.setPointerCapture(event.pointerId)
  }
}

const releasePointer = (event: PointerEvent) => {
  const target = event.currentTarget as HTMLElement
  if (typeof target.releasePointerCapture === 'function') {
    try {
      target.releasePointerCapture(event.pointerId)
    } catch {
      // Pointer capture may already be released by the browser.
    }
  }
}

const onPointerDown = (event: PointerEvent) => {
  if (!runtime.active) return
  const nodeEl = getNodeFromEvent(event)

  if (runtime.tool === 'draw') {
    const drawContext = getDrawContext()
    if (!drawContext) return
    const nodeId = nodeEl?.dataset.heliosNode
    if (nodeId && nodeId !== drawContext.contextNode?.id) return
    const point = getLocalPoint(event, drawContext.surface)
    if (!point) return
    const initialRect = snapRect({ x: point.x, y: point.y, w: 1, h: 1 }, point.bounds, drawContext.grid)

    event.preventDefault()
    capturePointer(event)
    interaction.value = {
      mode: 'draw',
      pointerId: event.pointerId,
      contextNode: drawContext.contextNode,
      grid: drawContext.grid,
      surface: drawContext.surface,
      start: point,
      lastRect: initialRect,
    }
    runtime.setDraftRect(toOverlayRect(initialRect, point.bounds))
    return
  }

  if (nodeEl?.dataset.heliosNode) {
    const nodeId = nodeEl.dataset.heliosNode
    const node = runtime.getNodeById(nodeId)
    if (!node) return
    runtime.selectNode(nodeId)

    if (runtime.tool !== 'select') return
    if (runtime.isNodeLocked(nodeId)) return
    const resizeHandle = getResizeHandleFromEvent(event)

    const shouldResizeInnerBox = Boolean(
      resizeHandle
      && node.kind === 'frame'
      && (runtime.isInnerFrameControlActive(nodeId) || event.altKey),
    )

    if (shouldResizeInnerBox) {
      const point = getLocalPoint(event, nodeEl)
      const startInnerBox = runtime.ensureNodeInnerBoxLocal(nodeId)
      if (!point || !startInnerBox) return
      event.preventDefault()
      capturePointer(event)
      interaction.value = {
        mode: 'inner-resize',
        pointerId: event.pointerId,
        nodeId,
        resizeHandle: toResizeHandle(resizeHandle),
        surface: nodeEl,
        start: point,
        startInnerBox,
        lastInnerBox: startInnerBox,
      }
      return
    }

    const startCell = getNodeCell(nodeId)
    if (!startCell) return
    const moveContext = getMoveContext(node, nodeEl)
    const surface = moveContext.surface
    if (!surface) return
    const point = getLocalPoint(event, surface)
    if (!point) return

    event.preventDefault()
    capturePointer(event)
    interaction.value = resizeHandle
      ? {
        mode: 'resize',
        pointerId: event.pointerId,
        nodeId,
        resizeHandle: toResizeHandle(resizeHandle),
        grid: moveContext.grid,
        surface,
        start: point,
        startCell,
        lastCell: startCell,
      }
      : {
        mode: 'move',
        pointerId: event.pointerId,
        nodeId,
        grid: moveContext.grid,
        surface,
        start: point,
        startCell,
        lastCell: startCell,
      }
    return
  }

  if (
    runtime.tool === 'select'
    && runtime.settings.deselectOnCanvasClick
    && runtime.selectedNodeId
  ) {
    runtime.clearSelection()
  }
}

const onPointerMove = (event: PointerEvent) => {
  const current = interaction.value
  if (!current || current.pointerId !== event.pointerId || !runtime.active) return
  const point = getLocalPoint(event, current.surface)
  if (!point) return

  if (current.mode === 'draw') {
    const nextRect = snapRect(buildRect(current.start, point), point.bounds, current.grid)
    current.lastRect = nextRect
    runtime.setDraftRect(toOverlayRect(nextRect, point.bounds))
    return
  }

  if (runtime.isNodeLocked(current.nodeId)) return

  if (current.mode === 'inner-resize') {
    const nextInnerBox = resizeInnerBox(current.startInnerBox, point, current.start, current.resizeHandle, event.metaKey)
    current.lastInnerBox = nextInnerBox
    runtime.setNodeInnerBoxLocal(current.nodeId, nextInnerBox)
    return
  }

  const nextCell = current.mode === 'move'
    ? translateCell(current.startCell, point, current.start, current.grid)
    : resizeCell(current.startCell, point, current.start, current.grid, current.resizeHandle, event.metaKey)

  current.lastCell = nextCell
  runtime.setNodeGridCellLocal(current.nodeId, nextCell)
}

const onPointerUp = async (event: PointerEvent) => {
  const current = interaction.value
  if (!current || current.pointerId !== event.pointerId) return
  const point = getLocalPoint(event, current.surface)
  interaction.value = null
  releasePointer(event)

  if (current.mode === 'draw') {
    const rect = current.lastRect
    runtime.setDraftRect(null)
    if (!point || rect.w < 8 || rect.h < 8) return

    await runtime.createFrameNode({
      documentId: props.documentId,
      zoneId: props.zoneId,
      parent: current.contextNode,
      rect,
      cell: rectToCell(rect, point.bounds, current.grid),
    })
    return
  }

  if (runtime.isNodeLocked(current.nodeId)) return

  if (current.mode === 'inner-resize') {
    await runtime.patchNodeInnerBox(current.nodeId, current.lastInnerBox, 'base')
    return
  }

  await runtime.patchNodeGridCell(current.nodeId, current.lastCell)
}

const onPointerCancel = (event: PointerEvent) => {
  interaction.value = null
  runtime.setDraftRect(null)
  releasePointer(event)
}
</script>

<template>
  <div
    ref="overlayEl"
    class="helios-overlay"
    :class="{
      'is-active': runtime.active,
      'is-draw': runtime.tool === 'draw',
      'is-select': runtime.tool === 'select',
    }"
    @pointerdown="onPointerDown"
    @pointermove="onPointerMove"
    @pointerup="onPointerUp"
    @pointercancel="onPointerCancel"
  >
    <div ref="framesEl" class="helios-overlay__frames" :style="gridStyle">
      <template v-for="node in zoneNodes" :key="node.id">
        <HeliosFrameOverlay
          v-if="node.kind === 'frame'"
          :node="node"
          :selected="runtime.selectedNodeId === node.id"
          :context-active="activeContextNodeId === node.id"
          :active-context-node-id="activeContextNodeId"
        />
        <HeliosTextOverlay
          v-else-if="node.kind === 'text'"
          :node="node"
          :selected="runtime.selectedNodeId === node.id"
        />
      </template>
    </div>
    <div v-if="runtime.active && showGrid !== false" class="helios-overlay__grid" :style="gridLineStyle" />
    <div v-if="runtime.active" class="helios-overlay__context">
      {{ contextLabel }}
    </div>
    <div v-if="runtime.active && runtime.draftRect" class="helios-overlay__draft" :style="draftStyle" />
    <div v-if="runtime.active && runtime.error" class="helios-overlay__error">
      {{ runtime.error }}
    </div>
  </div>
</template>

<style scoped>
.helios-overlay {
  position: absolute;
  z-index: 20;
  inset: 0;
  pointer-events: none;
}

.helios-overlay.is-active {
  pointer-events: auto;
}

.helios-overlay.is-draw {
  cursor: crosshair;
}

.helios-overlay.is-select {
  cursor: default;
}

.helios-overlay__frames,
.helios-overlay__grid,
.helios-overlay__draft {
  position: absolute;
  inset: 0;
  box-sizing: border-box;
}

.helios-overlay__frames {
  z-index: 3;
  display: grid;
  min-width: 0;
  min-height: 0;
  pointer-events: none;
}

.helios-overlay.is-active .helios-overlay__frames {
  pointer-events: auto;
}

.helios-overlay__grid {
  z-index: 1;
  background-position: 0 0;
  background-repeat: repeat;
  pointer-events: none;
}

.helios-overlay__context {
  position: absolute;
  z-index: 6;
  left: 10px;
  bottom: 10px;
  max-width: min(420px, calc(100% - 20px));
  overflow: hidden;
  padding: 6px 8px;
  border: 1px solid rgba(37, 87, 214, 0.18);
  border-radius: 6px;
  color: #1e3a8a;
  background: rgba(239, 246, 255, 0.88);
  font-size: 11px;
  font-weight: 800;
  line-height: 1.2;
  pointer-events: none;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.helios-overlay__draft {
  z-index: 5;
  pointer-events: none;
  background: rgba(224, 71, 38, 0.12);
  box-shadow: inset 0 0 0 1px #e04726;
}

.helios-overlay__error {
  position: absolute;
  z-index: 6;
  right: 12px;
  bottom: 12px;
  max-width: min(460px, calc(100% - 24px));
  padding: 8px 10px;
  border: 1px solid rgba(224, 71, 38, 0.38);
  border-radius: 6px;
  color: #7f1d1d;
  background: rgba(255, 245, 242, 0.94);
  font-size: 12px;
  line-height: 1.35;
}
</style>
