import { defineStore } from 'pinia'
import {
  BACKGROUND_QUALITY_KEY,
  HELIOS_CANVAS_MAX_ROWS,
  createDefaultTextContent,
  createDefaultFrameGrid,
  GRID_CELL_QUALITY_KEY,
  GRID_CONTAINER_QUALITY_KEY,
  getInnerBoxValue,
  getGridContainerValue,
  getGridCellValue,
  resolveBackgroundInputValue,
  resolveInnerBoxBackgroundInputValue,
  upsertBackgroundQuality,
  upsertGridContainerQuality,
  upsertGridCellQuality,
  upsertInnerBoxBackgroundQuality,
  upsertInnerBoxQuality,
  normalizeTextContentInput,
  type HeliosBreakpointKey,
  type HeliosGridContainerValue,
  type HeliosGridCellValue,
  type HeliosInnerBoxValue,
  type HeliosNodePatch,
  type HeliosNodeRecord,
  type HeliosQualityMap,
  type HeliosTextContent,
} from '@helios/protocol'
import {
  HELIOS_RUNTIME_BREAKPOINTS,
  HELIOS_RUNTIME_VIEWPORTS,
  getHeliosRuntimeViewport,
  type HeliosRuntimeBreakpoint,
} from '../utils/heliosRuntimeViewports'

export type HeliosRuntimeTool = 'select' | 'draw'
export type HeliosRuntimeMode = 'frame' | 'widget'
export type HeliosFrameControlMode = 'outer' | 'inner'
export type HeliosFrameLabelVisibility = 'always' | 'selected'
export type HeliosArenaLabelPlacement = 'top-center' | 'bottom-center'

export type HeliosRuntimeRect = {
  x: number
  y: number
  w: number
  h: number
}

export type HeliosRuntimeSettings = {
  deselectOnCanvasClick: boolean
  frameLabelVisibility: HeliosFrameLabelVisibility
  arenaLabelPlacement: HeliosArenaLabelPlacement
}

export type HeliosCanvasHeightMode = 'rows' | 'viewport-blocks' | 'content'
export type HeliosCanvasGrowthUnit = '25dvh' | '50dvh' | '100dvh'

export type HeliosRuntimeCanvasConfig = {
  cols: number
  rows: number
  heightMode: HeliosCanvasHeightMode
  viewportBlocks: number
  rowPx: number
  showGrid: boolean
  snap: boolean
  midline: boolean
}

type HeliosFrameClipboard = {
  sourceId: string
  label: string | null | undefined
  qualities: HeliosQualityMap
  meta: Record<string, any>
}

const DEFAULT_CANVAS_CONFIG: HeliosRuntimeCanvasConfig = {
  cols: 24,
  rows: 72,
  heightMode: 'rows',
  viewportBlocks: 2,
  rowPx: 32,
  showGrid: true,
  snap: true,
  midline: true,
}

const CANVAS_GROWTH_FACTORS: Record<HeliosCanvasGrowthUnit, number> = {
  '25dvh': 0.25,
  '50dvh': 0.5,
  '100dvh': 1,
}

const SETTINGS_STORAGE_KEY = 'helios.runtime.settings'

const DEFAULT_RUNTIME_SETTINGS: HeliosRuntimeSettings = {
  deselectOnCanvasClick: true,
  frameLabelVisibility: 'always',
  arenaLabelPlacement: 'bottom-center',
}

export const DEFAULT_INNER_FRAME_BOX: HeliosInnerBoxValue = {
  mode: 'inset',
  snapTo: 'rhythm-grid',
  insetTop: 0,
  insetRight: 0,
  insetBottom: 0,
  insetLeft: 0,
  maxWidth: null,
  centerX: false,
  centerY: false,
}

// Editor-only fallback fill for transparent structural frames in Edit mode.
// Do not persist this as appearance.bg unless the user explicitly sets it.
export const DEFAULT_FRAME_BACKGROUND_COLOR = '#FFFFFF'

const errorMessage = (err: any, fallback: string) => (
  err?.data?.statusMessage || err?.statusMessage || err?.message || fallback
)

const cloneQualities = (qualities?: HeliosQualityMap | null): HeliosQualityMap => (
  qualities ? JSON.parse(JSON.stringify(qualities)) as HeliosQualityMap : {}
)

const cloneMeta = (meta?: Record<string, any> | null): Record<string, any> => (
  meta ? JSON.parse(JSON.stringify(meta)) as Record<string, any> : {}
)

const frameSpan = (
  cell: HeliosGridCellValue | null | undefined,
  fallbackCols = 6,
  fallbackRows = 6,
) => ({
  cols: Math.max(1, Number(cell?.colEnd ?? fallbackCols + 1) - Number(cell?.colStart ?? 1)),
  rows: Math.max(1, Number(cell?.rowEnd ?? fallbackRows + 1) - Number(cell?.rowStart ?? 1)),
})

const defaultTextCellForSurface = (cols: number, rows: number): HeliosGridCellValue => {
  const colStart = Math.min(Math.max(1, Math.ceil(cols / 12)), Math.max(1, cols))
  const rowStart = Math.min(2, Math.max(1, rows))
  const spanCols = Math.max(2, Math.min(8, cols - colStart + 1))
  const spanRows = Math.max(1, Math.min(2, rows - rowStart + 1))
  return {
    cols,
    rows,
    colStart,
    colEnd: Math.min(cols + 1, colStart + spanCols),
    rowStart,
    rowEnd: Math.min(rows + 1, rowStart + spanRows),
  }
}

const clampFrameCell = (
  cell: Partial<HeliosGridCellValue>,
  cols: number,
  rows: number,
): HeliosGridCellValue => {
  const span = frameSpan(cell as HeliosGridCellValue)
  const maxColStart = Math.max(1, cols - span.cols + 1)
  const maxRowStart = Math.max(1, rows - span.rows + 1)
  const colStart = Math.max(1, Math.min(Math.round(Number(cell.colStart ?? 1)), maxColStart))
  const rowStart = Math.max(1, Math.min(Math.round(Number(cell.rowStart ?? 1)), maxRowStart))
  return {
    cols,
    rows,
    colStart,
    colEnd: Math.min(cols + 1, colStart + span.cols),
    rowStart,
    rowEnd: Math.min(rows + 1, rowStart + span.rows),
  }
}

const scopeKey = (documentId: string, zoneId: string) => `${documentId}::${zoneId}`

const scopeKeyForNode = (node: Pick<HeliosNodeRecord, 'documentId' | 'zoneId'>) => (
  scopeKey(node.documentId, node.zoneId)
)

const isLockedNode = (node: HeliosNodeRecord | null | undefined) => (
  node?.meta?.editor?.locked === true
)

const withEditorMeta = (
  meta: Record<string, any> | null | undefined,
  patch: Record<string, any>,
) => {
  const next = cloneMeta(meta)
  next.editor = {
    ...(next.editor && typeof next.editor === 'object' ? next.editor : {}),
    ...patch,
  }
  return next
}

const upsertGridCellWithBase = (
  qualities: HeliosQualityMap | null | undefined,
  cell: HeliosGridCellValue,
  breakpoint: HeliosBreakpointKey,
) => {
  let next = upsertGridCellQuality(cloneQualities(qualities), cell, breakpoint)
  if (breakpoint !== 'base' && !getGridCellValue(next, undefined, 'base')) {
    next = upsertGridCellQuality(next, cell, 'base')
  }
  return next
}

const normalizeCanvasConfig = (
  input?: Partial<HeliosRuntimeCanvasConfig> | null,
): HeliosRuntimeCanvasConfig => {
  const rows = Math.max(24, Math.min(HELIOS_CANVAS_MAX_ROWS, Math.round(Number(input?.rows ?? DEFAULT_CANVAS_CONFIG.rows))))
  const cols = Math.max(1, Math.min(96, Math.round(Number(input?.cols ?? DEFAULT_CANVAS_CONFIG.cols))))
  const viewportBlocks = Math.max(1, Math.min(12, Math.round(Number(input?.viewportBlocks ?? DEFAULT_CANVAS_CONFIG.viewportBlocks))))
  const rowPx = Math.max(8, Math.min(96, Math.round(Number(input?.rowPx ?? DEFAULT_CANVAS_CONFIG.rowPx))))
  const heightMode: HeliosCanvasHeightMode = input?.heightMode === 'viewport-blocks' || input?.heightMode === 'content'
    ? input.heightMode
    : 'rows'

  return {
    cols,
    rows,
    heightMode,
    viewportBlocks,
    rowPx,
    showGrid: input?.showGrid !== false,
    snap: input?.snap !== false,
    midline: input?.midline !== false,
  }
}

const viewportHeight = () => {
  if (typeof window === 'undefined') return 720
  return Math.max(1, window.innerHeight || 720)
}

const readRuntimeSettings = (): HeliosRuntimeSettings => {
  if (typeof window === 'undefined') return DEFAULT_RUNTIME_SETTINGS
  try {
    const parsed = JSON.parse(window.localStorage.getItem(SETTINGS_STORAGE_KEY) || '{}')
    const frameLabelVisibility: HeliosFrameLabelVisibility = parsed?.frameLabelVisibility === 'selected'
      ? 'selected'
      : 'always'
    const arenaLabelPlacement: HeliosArenaLabelPlacement = parsed?.arenaLabelPlacement === 'top-center'
      ? 'top-center'
      : 'bottom-center'
    return {
      deselectOnCanvasClick: parsed?.deselectOnCanvasClick !== false,
      frameLabelVisibility,
      arenaLabelPlacement,
    }
  } catch {
    return DEFAULT_RUNTIME_SETTINGS
  }
}

const writeRuntimeSettings = (settings: HeliosRuntimeSettings) => {
  if (typeof window === 'undefined') return
  window.localStorage.setItem(SETTINGS_STORAGE_KEY, JSON.stringify(settings))
}

export const useHeliosRuntimeStore = defineStore('helios-runtime', () => {
  const active = ref(false)
  const tool = ref<HeliosRuntimeTool>('draw')
  const runtimeMode = ref<HeliosRuntimeMode>('frame')
  const frameControlMode = ref<HeliosFrameControlMode>('outer')
  const settings = ref<HeliosRuntimeSettings>(readRuntimeSettings())
  const selectedNodeId = ref<string | null>(null)
  const activeContextByScope = ref<Record<string, string | null>>({})
  const activeZoneId = ref<string | null>(null)
  const documentId = ref<string | null>(null)
  const activeBreakpoint = ref<HeliosRuntimeBreakpoint>('base')
  const draftRect = ref<HeliosRuntimeRect | null>(null)
  const nodesByScope = ref<Record<string, HeliosNodeRecord[]>>({})
  const canvasByScope = ref<Record<string, HeliosRuntimeCanvasConfig>>({})
  const frameClipboard = ref<HeliosFrameClipboard | null>(null)
  const pending = ref(false)
  const error = ref<string | null>(null)
  const status = ref('')
  const navigatorOpen = ref(false)
  const frameOptionsOpen = ref(false)

  const nodes = computed(() => (
    Object.values(nodesByScope.value).flat()
  ))

  const activeScopeKey = computed(() => (
    documentId.value && activeZoneId.value
      ? scopeKey(documentId.value, activeZoneId.value)
      : null
  ))

  const activeViewport = computed(() => getHeliosRuntimeViewport(activeBreakpoint.value))

  const selectedNode = computed(() => (
    nodes.value.find((node) => node.id === selectedNodeId.value) ?? null
  ))

  const activeContextNodeId = computed(() => (
    activeScopeKey.value
      ? activeContextByScope.value[activeScopeKey.value] ?? null
      : null
  ))

  const activeContextNode = computed(() => (
    nodes.value.find((node) => node.id === activeContextNodeId.value) ?? null
  ))

  const setActive = (enabled: boolean) => {
    active.value = enabled
    if (!enabled) {
      draftRect.value = null
      frameOptionsOpen.value = false
      navigatorOpen.value = false
    }
    status.value = enabled ? 'Helios edit mode' : 'Helios live view'
  }

  const toggleActive = () => {
    setActive(!active.value)
  }

  const setTool = (nextTool: HeliosRuntimeTool) => {
    tool.value = nextTool
    if (nextTool === 'draw') {
      selectedNodeId.value = null
      frameControlMode.value = 'outer'
    }
  }

  const setRuntimeMode = (nextMode: HeliosRuntimeMode) => {
    runtimeMode.value = nextMode === 'widget' ? 'widget' : 'frame'
    if (runtimeMode.value === 'widget') {
      tool.value = 'select'
      status.value = 'Widget mode: press T to create text'
    }
  }

  const setActiveBreakpoint = (breakpoint: HeliosRuntimeBreakpoint) => {
    activeBreakpoint.value = HELIOS_RUNTIME_BREAKPOINTS.includes(breakpoint)
      ? breakpoint
      : 'base'
  }

  const cycleBreakpoint = () => {
    const current = HELIOS_RUNTIME_BREAKPOINTS.indexOf(activeBreakpoint.value)
    const next = (current + 1) % HELIOS_RUNTIME_BREAKPOINTS.length
    activeBreakpoint.value = HELIOS_RUNTIME_BREAKPOINTS[next] ?? 'base'
  }

  const cycleBreakpointPrevious = () => {
    const current = HELIOS_RUNTIME_BREAKPOINTS.indexOf(activeBreakpoint.value)
    const previous = (current - 1 + HELIOS_RUNTIME_BREAKPOINTS.length) % HELIOS_RUNTIME_BREAKPOINTS.length
    activeBreakpoint.value = HELIOS_RUNTIME_BREAKPOINTS[previous] ?? 'base'
  }

  const setActiveZone = (nextDocumentId: string, nextZoneId: string) => {
    documentId.value = nextDocumentId
    activeZoneId.value = nextZoneId
  }

  const canvasForZone = (nextDocumentId: string, nextZoneId: string) => (
    canvasByScope.value[scopeKey(nextDocumentId, nextZoneId)] ?? DEFAULT_CANVAS_CONFIG
  )

  const setCanvasForZone = (
    nextDocumentId: string,
    nextZoneId: string,
    patch: Partial<HeliosRuntimeCanvasConfig>,
  ) => {
    const key = scopeKey(nextDocumentId, nextZoneId)
    canvasByScope.value = {
      ...canvasByScope.value,
      [key]: normalizeCanvasConfig({
        ...canvasForZone(nextDocumentId, nextZoneId),
        ...patch,
      }),
    }
  }

  const adjustCanvasRows = (
    nextDocumentId: string,
    nextZoneId: string,
    deltaRows: number,
  ) => {
    const current = canvasForZone(nextDocumentId, nextZoneId)
    setCanvasForZone(nextDocumentId, nextZoneId, {
      heightMode: 'rows',
      rows: current.rows + deltaRows,
    })
  }

  const setDeselectOnCanvasClick = (enabled: boolean) => {
    settings.value = {
      ...settings.value,
      deselectOnCanvasClick: enabled,
    }
    writeRuntimeSettings(settings.value)
  }

  const setFrameLabelVisibility = (visibility: HeliosFrameLabelVisibility) => {
    settings.value = {
      ...settings.value,
      frameLabelVisibility: visibility === 'selected' ? 'selected' : 'always',
    }
    writeRuntimeSettings(settings.value)
  }

  const setArenaLabelPlacement = (placement: HeliosArenaLabelPlacement) => {
    settings.value = {
      ...settings.value,
      arenaLabelPlacement: placement === 'top-center' ? 'top-center' : 'bottom-center',
    }
    writeRuntimeSettings(settings.value)
  }

  const adjustCanvasByViewportUnit = (
    nextDocumentId: string,
    nextZoneId: string,
    unit: HeliosCanvasGrowthUnit,
    direction: 1 | -1 = 1,
  ) => {
    const current = canvasForZone(nextDocumentId, nextZoneId)
    const factor = CANVAS_GROWTH_FACTORS[unit] ?? CANVAS_GROWTH_FACTORS['50dvh']
    const deltaRows = Math.max(1, Math.ceil((viewportHeight() * factor) / current.rowPx))
    adjustCanvasRows(nextDocumentId, nextZoneId, deltaRows * direction)
  }

  const normalizeCanvasHeightForZone = (
    nextDocumentId: string,
    nextZoneId: string,
    bufferRows = 0,
  ) => {
    const current = canvasForZone(nextDocumentId, nextZoneId)
    const rootFrames = rootNodesForZone(nextDocumentId, nextZoneId)
    const furthestRowEnd = rootFrames.reduce((furthest, node) => {
      const cell = getNodeGridCell(node, activeBreakpoint.value) || getNodeGridCell(node, 'base')
      const occupiedRows = Math.max(0, Number(cell?.rowEnd || 0) - 1)
      return Math.max(furthest, occupiedRows)
    }, 0)
    const minimumRows = Math.max(24, Math.ceil(viewportHeight() / current.rowPx))
    const rows = furthestRowEnd
      ? Math.max(1, Math.ceil(furthestRowEnd + bufferRows))
      : Math.max(minimumRows, DEFAULT_CANVAS_CONFIG.rows)

    setCanvasForZone(nextDocumentId, nextZoneId, {
      heightMode: furthestRowEnd ? 'content' : 'rows',
      rows,
    })
    status.value = furthestRowEnd
      ? `Canvas height normalized to row ${rows}`
      : 'Canvas height reset to the default workspace'
  }

  const canvasPixelHeight = (nextDocumentId: string, nextZoneId: string) => {
    const canvas = canvasForZone(nextDocumentId, nextZoneId)
    if (canvas.heightMode === 'viewport-blocks') {
      return `calc(100vh * ${canvas.viewportBlocks})`
    }
    return `${canvas.rows * canvas.rowPx}px`
  }

  const setDraftRect = (rect: HeliosRuntimeRect | null) => {
    draftRect.value = rect
  }

  const selectNode = (id: string | null) => {
    if (selectedNodeId.value !== id) frameControlMode.value = 'outer'
    selectedNodeId.value = id
    if (id) tool.value = 'select'
  }

  const activeContextNodeIdForZone = (nextDocumentId: string, nextZoneId: string) => (
    activeContextByScope.value[scopeKey(nextDocumentId, nextZoneId)] ?? null
  )

  const activeContextNodeForZone = (nextDocumentId: string, nextZoneId: string) => (
    getNodeById(activeContextNodeIdForZone(nextDocumentId, nextZoneId))
  )

  const setActiveContextForZone = (
    nextDocumentId: string,
    nextZoneId: string,
    id: string | null,
  ) => {
    const key = scopeKey(nextDocumentId, nextZoneId)
    activeContextByScope.value = {
      ...activeContextByScope.value,
      [key]: id && getNodeById(id) ? id : null,
    }
  }

  const setActiveContextNode = (id: string | null) => {
    if (!documentId.value || !activeZoneId.value) return
    setActiveContextForZone(documentId.value, activeZoneId.value, id)
  }

  const enterNodeContext = (id: string | null = selectedNodeId.value) => {
    const node = getNodeById(id)
    if (!node) return
    if (node.kind !== 'frame') {
      error.value = 'Only frames can become draw contexts'
      return
    }
    setActiveZone(node.documentId, node.zoneId)
    setActiveContextForZone(node.documentId, node.zoneId, node.id)
    selectedNodeId.value = node.id
    tool.value = 'draw'
    status.value = `Drawing inside ${node.label || node.record?.display || node.id}`
  }

  const exitNodeContext = (nextDocumentId = documentId.value, nextZoneId = activeZoneId.value) => {
    if (nextDocumentId && nextZoneId) {
      setActiveContextForZone(nextDocumentId, nextZoneId, null)
    }
    status.value = 'Drawing at zone root'
  }

  const clearSelection = () => {
    frameControlMode.value = 'outer'
    selectedNodeId.value = null
    frameOptionsOpen.value = false
  }

  const getEffectiveNodeInnerBox = (
    nodeOrId: HeliosNodeRecord | string | null | undefined,
    breakpoint: HeliosBreakpointKey = 'base',
  ): HeliosInnerBoxValue => {
    const node = typeof nodeOrId === 'string' ? getNodeById(nodeOrId) : nodeOrId
    const value = getNodeInnerBox(node, breakpoint)
    return value && value.mode !== 'none'
      ? value
      : { ...DEFAULT_INNER_FRAME_BOX }
  }

  const setNodeInnerBoxLocal = (
    id: string,
    input: HeliosInnerBoxValue,
    breakpoint: HeliosBreakpointKey = 'base',
  ) => {
    const node = getNodeById(id)
    if (!node) return
    updateNodeLocal({
      ...node,
      qualities: upsertInnerBoxQuality(cloneQualities(node.qualities), input, breakpoint),
    })
  }

  const ensureNodeInnerBoxLocal = (
    id: string,
    breakpoint: HeliosBreakpointKey = 'base',
  ) => {
    const current = getNodeById(id)
    if (!current) return null
    const value = getNodeInnerBox(current, breakpoint)
    if (value && value.mode !== 'none') return value
    const next = { ...DEFAULT_INNER_FRAME_BOX }
    setNodeInnerBoxLocal(id, next, breakpoint)
    return next
  }

  const setFrameControlMode = async (
    mode: HeliosFrameControlMode,
    id: string | null = selectedNodeId.value,
  ) => {
    const node = getNodeById(id)
    if (!node) {
      frameControlMode.value = 'outer'
      return null
    }
    if (node.kind !== 'frame') {
      frameControlMode.value = 'outer'
      error.value = 'Inner control mode is available for frames only'
      return null
    }

    selectedNodeId.value = node.id
    setActiveZone(node.documentId, node.zoneId)

    if (mode === 'inner') {
      frameControlMode.value = 'inner'
      setActiveContextForZone(node.documentId, node.zoneId, node.id)
      const value = getNodeInnerBox(node, 'base')
      if (!value || value.mode === 'none') {
        await patchNodeInnerBox(node.id, { ...DEFAULT_INNER_FRAME_BOX }, 'base')
      }
      status.value = `Inner frame control for ${node.label || node.record?.display || node.id}`
      return node
    }

    frameControlMode.value = 'outer'
    if (activeContextNodeIdForZone(node.documentId, node.zoneId) === node.id) {
      setActiveContextForZone(node.documentId, node.zoneId, node.parentId ?? null)
    }
    status.value = `Outer frame control for ${node.label || node.record?.display || node.id}`
    return node
  }

  const toggleFrameControlMode = async () => {
    await setFrameControlMode(frameControlMode.value === 'inner' ? 'outer' : 'inner')
  }

  const isInnerFrameControlActive = (
    nodeOrId: HeliosNodeRecord | string | null | undefined,
  ) => {
    const node = typeof nodeOrId === 'string' ? getNodeById(nodeOrId) : nodeOrId
    return Boolean(active.value && node && selectedNodeId.value === node.id && frameControlMode.value === 'inner')
  }

  const toggleNavigator = () => {
    navigatorOpen.value = !navigatorOpen.value
  }

  const toggleFrameOptions = () => {
    if (!selectedNode.value) return
    frameOptionsOpen.value = !frameOptionsOpen.value
  }

  const nodesForZone = (nextDocumentId: string, nextZoneId: string) => (
    [...(nodesByScope.value[scopeKey(nextDocumentId, nextZoneId)] ?? [])]
      .sort((a, b) => (a.order - b.order) || a.id.localeCompare(b.id))
  )

  const rootNodesForZone = (nextDocumentId: string, nextZoneId: string) => (
    nodesForZone(nextDocumentId, nextZoneId)
      .filter((node) => !node.parentId)
  )

  const childNodesFor = (parentId: string | null | undefined) => (
    parentId
      ? nodes.value
          .filter((node) => node.parentId === parentId)
          .sort((a, b) => (a.order - b.order) || a.id.localeCompare(b.id))
      : []
  )

  const siblingNodesFor = (
    nextDocumentId: string,
    nextZoneId: string,
    parentId: string | null | undefined,
  ) => (
    nodesForZone(nextDocumentId, nextZoneId)
      .filter((node) => (node.parentId || null) === (parentId || null))
  )

  const nextGeneratedFrameLabel = (
    nextDocumentId: string,
    nextZoneId: string,
    parentId: string | null | undefined,
  ) => {
    const prefix = parentId ? 'Child frame' : 'Frame'
    const pattern = new RegExp(`^${prefix}\\s+(\\d+)$`, 'i')
    const highest = siblingNodesFor(nextDocumentId, nextZoneId, parentId)
      .reduce((max, node) => {
        const match = String(node.label || '').trim().match(pattern)
        const number = match ? Number(match[1]) : 0
        return Number.isFinite(number) ? Math.max(max, number) : max
      }, 0)
    return `${prefix} ${highest + 1}`
  }

  const nextGeneratedTextLabel = (
    nextDocumentId: string,
    nextZoneId: string,
    parentId: string | null | undefined,
  ) => {
    const pattern = /^Text\s+(\d+)$/i
    const highest = siblingNodesFor(nextDocumentId, nextZoneId, parentId)
      .filter((node) => node.kind === 'text')
      .reduce((max, node) => {
        const match = String(node.label || '').trim().match(pattern)
        const number = match ? Number(match[1]) : 0
        return Number.isFinite(number) ? Math.max(max, number) : max
      }, 0)
    return `Text ${highest + 1}`
  }

  const descendantIdsFor = (parentId: string) => {
    const descendants: string[] = []
    const stack = childNodesFor(parentId).map((node) => node.id)
    while (stack.length > 0) {
      const nextId = stack.shift()
      if (!nextId) continue
      descendants.push(nextId)
      stack.push(...childNodesFor(nextId).map((node) => node.id))
    }
    return descendants
  }

  const getNodeById = (id: string | null | undefined) => (
    id ? nodes.value.find((node) => node.id === id) ?? null : null
  )

  const getNodeGridCell = (
    node: HeliosNodeRecord | null | undefined,
    breakpoint: HeliosBreakpointKey = activeBreakpoint.value,
  ) => getGridCellValue(node?.qualities, undefined, breakpoint)

  const getNodeGridContainer = (
    node: HeliosNodeRecord | null | undefined,
    breakpoint: HeliosBreakpointKey = 'base',
  ) => getGridContainerValue(node?.qualities, undefined, breakpoint)

  const gridSurfaceForParent = (
    nextDocumentId: string,
    nextZoneId: string,
    parent: HeliosNodeRecord | null | undefined,
  ) => {
    if (parent) {
      const container = getNodeGridContainer(parent, 'base')
      return {
        cols: Math.max(1, Math.round(Number(container?.cols || 24))),
        rows: Math.max(1, Math.round(Number(container?.rows || 24))),
      }
    }
    const canvas = canvasForZone(nextDocumentId, nextZoneId)
    return {
      cols: canvas.cols,
      rows: canvas.rows,
    }
  }

  const getNodeBackgroundInput = (
    node: HeliosNodeRecord | null | undefined,
    breakpoint: HeliosBreakpointKey = 'base',
  ) => resolveBackgroundInputValue(node?.qualities, undefined, breakpoint)

  const getNodeInnerBoxBackgroundInput = (
    node: HeliosNodeRecord | null | undefined,
    breakpoint: HeliosBreakpointKey = 'base',
  ) => resolveInnerBoxBackgroundInputValue(node?.qualities, undefined, breakpoint)

  const getNodeInnerBox = (
    node: HeliosNodeRecord | null | undefined,
    breakpoint: HeliosBreakpointKey = 'base',
  ) => getInnerBoxValue(node?.qualities, undefined, breakpoint)

  const isNodeLocked = (nodeOrId: HeliosNodeRecord | string | null | undefined) => {
    const node = typeof nodeOrId === 'string' ? getNodeById(nodeOrId) : nodeOrId
    return isLockedNode(node)
  }

  const loadNodes = async (
    inputOrDocumentId: { documentId: string; zoneId: string } | string,
    maybeZoneId?: string,
  ) => {
    const input = typeof inputOrDocumentId === 'string'
      ? { documentId: inputOrDocumentId, zoneId: maybeZoneId || '' }
      : inputOrDocumentId

    pending.value = true
    error.value = null
    setActiveZone(input.documentId, input.zoneId)

    try {
      const response = await $fetch<{
        ok: boolean
        nodes: HeliosNodeRecord[]
        storage?: {
          available: boolean
          message?: string
        }
      }>('/api/helios/nodes', {
        query: input,
      })
      const key = scopeKey(input.documentId, input.zoneId)
      const nextNodes = response.nodes || []
      nodesByScope.value = {
        ...nodesByScope.value,
        [key]: nextNodes,
      }
      const scopedContextId = activeContextByScope.value[key]
      if (scopedContextId && !nextNodes.some((node) => node.id === scopedContextId)) {
        activeContextByScope.value = {
          ...activeContextByScope.value,
          [key]: null,
        }
      }
      if (response.ok === false) {
        error.value = response.storage?.message || 'Helios storage is unavailable'
        status.value = 'Helios storage offline'
      } else {
        status.value = `${nextNodes.length} Helios nodes loaded`
      }
    } catch (err: any) {
      error.value = errorMessage(err, 'Unable to load Helios nodes')
    } finally {
      pending.value = false
    }
  }

  const updateNodeLocal = (nextNode: HeliosNodeRecord) => {
    const oldNode = getNodeById(nextNode.id)
    const oldKey = oldNode ? scopeKeyForNode(oldNode) : null
    const nextKey = scopeKeyForNode(nextNode)
    const nextByScope = { ...nodesByScope.value }

    if (oldKey && oldKey !== nextKey) {
      nextByScope[oldKey] = (nextByScope[oldKey] ?? []).filter((node) => node.id !== nextNode.id)
    }

    const currentScopeNodes = nextByScope[nextKey] ?? []
    const exists = currentScopeNodes.some((node) => node.id === nextNode.id)
    nextByScope[nextKey] = exists
      ? currentScopeNodes.map((node) => node.id === nextNode.id ? nextNode : node)
      : [...currentScopeNodes, nextNode]

    nodesByScope.value = nextByScope
  }

  const updateNode = async (id: string, patch: HeliosNodePatch) => {
    pending.value = true
    error.value = null
    const current = getNodeById(id)
    const record = current?.record ?? id

    try {
      const response = await $fetch<{ ok: boolean; node: HeliosNodeRecord }>('/api/helios/nodes', {
        method: 'PATCH',
        body: {
          record,
          patch,
        },
      })
      if (response.node) updateNodeLocal(response.node)
      status.value = 'Helios node updated'
      return response.node
    } catch (err: any) {
      error.value = errorMessage(err, 'Unable to update Helios node')
      throw err
    } finally {
      pending.value = false
    }
  }

  const setNodeGridCellLocal = (
    id: string,
    cell: HeliosGridCellValue,
    breakpoint: HeliosBreakpointKey = activeBreakpoint.value,
  ) => {
    const node = getNodeById(id)
    if (!node) return
    updateNodeLocal({
      ...node,
      qualities: upsertGridCellWithBase(node.qualities, cell, breakpoint),
    })
  }

  const patchNodeGridCell = async (
    id: string,
    cell: HeliosGridCellValue,
    breakpoint: HeliosBreakpointKey = activeBreakpoint.value,
  ) => {
    const current = getNodeById(id)
    if (!current) return null
    if (isLockedNode(current)) {
      error.value = 'Unlock node before editing placement'
      return null
    }
    const qualities = upsertGridCellWithBase(current.qualities, cell, breakpoint)
    setNodeGridCellLocal(id, cell, breakpoint)
    return updateNode(id, { qualities })
  }

  const patchNodeGridContainer = async (
    id: string,
    container: HeliosGridContainerValue,
  ) => {
    const current = getNodeById(id)
    if (!current) return null
    if (isLockedNode(current)) {
      error.value = 'Unlock frame before editing its grid'
      return null
    }
    const qualities = upsertGridContainerQuality(
      cloneQualities(current.qualities),
      container,
      'base',
    )
    updateNodeLocal({ ...current, qualities })
    return updateNode(id, { qualities })
  }

  const patchNodeBackground = async (
    id: string,
    input: unknown,
    breakpoint: HeliosBreakpointKey = 'base',
  ) => {
    const current = getNodeById(id)
    if (!current) return null
    if (isLockedNode(current)) {
      error.value = 'Unlock frame before editing background'
      return null
    }
    const qualities = upsertBackgroundQuality(
      cloneQualities(current.qualities),
      input,
      breakpoint,
    )
    updateNodeLocal({ ...current, qualities })
    return updateNode(id, { qualities })
  }

  const patchNodeInnerBoxBackground = async (
    id: string,
    input: unknown,
    breakpoint: HeliosBreakpointKey = 'base',
  ) => {
    const current = getNodeById(id)
    if (!current) return null
    if (isLockedNode(current)) {
      error.value = 'Unlock frame before editing inner background'
      return null
    }
    const qualities = upsertInnerBoxBackgroundQuality(
      cloneQualities(current.qualities),
      input,
      breakpoint,
    )
    updateNodeLocal({ ...current, qualities })
    return updateNode(id, { qualities })
  }

  const patchNodeInnerBox = async (
    id: string,
    input: HeliosInnerBoxValue,
    breakpoint: HeliosBreakpointKey = 'base',
  ) => {
    const current = getNodeById(id)
    if (!current) return null
    if (isLockedNode(current)) {
      error.value = 'Unlock frame before editing inner box'
      return null
    }
    const qualities = upsertInnerBoxQuality(
      cloneQualities(current.qualities),
      input,
      breakpoint,
    )
    updateNodeLocal({ ...current, qualities })
    return updateNode(id, { qualities })
  }

  const updateSelectedNodeLabel = async (label: string) => {
    const current = selectedNode.value
    if (!current) return null
    const nextLabel = label.trim() || null
    updateNodeLocal({ ...current, label: nextLabel })
    return updateNode(current.id, { label: nextLabel })
  }

  const toggleNodeLock = async (
    id: string | null = selectedNodeId.value,
    force?: boolean,
  ) => {
    const current = getNodeById(id)
    if (!current) return null
    const locked = typeof force === 'boolean' ? force : !isLockedNode(current)
    const meta = withEditorMeta(current.meta, { locked })
    updateNodeLocal({ ...current, meta })
    return updateNode(current.id, { meta })
  }

  const createFrameNode = async (input: {
    documentId: string
    zoneId: string
    cell: HeliosGridCellValue
    rect: HeliosRuntimeRect
    parent?: HeliosNodeRecord | null
  }) => {
    pending.value = true
    error.value = null
    setActiveZone(input.documentId, input.zoneId)
    const parent = input.parent ?? activeContextNodeForZone(input.documentId, input.zoneId)
    if (isLockedNode(parent)) {
      pending.value = false
      error.value = 'Unlock parent frame before drawing inside it'
      return null
    }

    const breakpoint = activeBreakpoint.value
    const gridCellByBreakpoint: Partial<Record<HeliosBreakpointKey, HeliosGridCellValue>> = {
      base: input.cell,
    }
    if (breakpoint !== 'base') {
      gridCellByBreakpoint[breakpoint] = input.cell
    }

    const qualities: HeliosQualityMap = {
      [GRID_CELL_QUALITY_KEY]: gridCellByBreakpoint,
      [GRID_CONTAINER_QUALITY_KEY]: {
        base: createDefaultFrameGrid(),
      },
    }

    try {
      const siblingCount = nodesForZone(input.documentId, input.zoneId)
        .filter((node) => (node.parentId || null) === (parent?.id || null))
        .length
      const response = await $fetch<{ ok: boolean; node: HeliosNodeRecord }>('/api/helios/nodes', {
        method: 'POST',
        body: {
          documentId: input.documentId,
          zoneId: input.zoneId,
          kind: 'frame',
          parent: parent?.record ?? null,
          order: siblingCount,
          label: nextGeneratedFrameLabel(input.documentId, input.zoneId, parent?.id ?? null),
          qualities,
          meta: {
            editor: {
              canvasRect: input.rect,
              locked: false,
            },
          },
        },
      })

      if (response.node) {
        updateNodeLocal(response.node)
        selectedNodeId.value = response.node.id
        tool.value = 'select'
        status.value = 'Frame node created'
      }
      return response.node
    } catch (err: any) {
      error.value = errorMessage(err, 'Unable to create Helios node')
      throw err
    } finally {
      pending.value = false
    }
  }

  const createTextNode = async (input?: {
    documentId?: string
    zoneId?: string
    parent?: HeliosNodeRecord | null
    cell?: HeliosGridCellValue
    content?: Partial<HeliosTextContent> | string
  }) => {
    const nextDocumentId = input?.documentId ?? selectedNode.value?.documentId ?? documentId.value
    const nextZoneId = input?.zoneId ?? selectedNode.value?.zoneId ?? activeZoneId.value
    if (!nextDocumentId || !nextZoneId) {
      error.value = 'Select a zone before creating text'
      return null
    }

    const selectedFrame = selectedNode.value?.kind === 'frame' ? selectedNode.value : null
    const parent = input?.parent ?? activeContextNodeForZone(nextDocumentId, nextZoneId) ?? selectedFrame
    if (isLockedNode(parent)) {
      error.value = 'Unlock parent frame before creating text inside it'
      return null
    }

    pending.value = true
    error.value = null
    setActiveZone(nextDocumentId, nextZoneId)

    const surface = gridSurfaceForParent(nextDocumentId, nextZoneId, parent)
    const cell = input?.cell ?? defaultTextCellForSurface(surface.cols, surface.rows)
    const qualities: HeliosQualityMap = {
      [GRID_CELL_QUALITY_KEY]: {
        base: cell,
      },
    }
    const content = normalizeTextContentInput(input?.content ?? createDefaultTextContent())

    try {
      const siblingCount = nodesForZone(nextDocumentId, nextZoneId)
        .filter((node) => (node.parentId || null) === (parent?.id || null))
        .length
      const response = await $fetch<{ ok: boolean; node: HeliosNodeRecord }>('/api/helios/nodes', {
        method: 'POST',
        body: {
          documentId: nextDocumentId,
          zoneId: nextZoneId,
          kind: 'text',
          parent: parent?.record ?? null,
          order: siblingCount,
          label: nextGeneratedTextLabel(nextDocumentId, nextZoneId, parent?.id ?? null),
          content,
          qualities,
          meta: {
            editor: {
              locked: false,
            },
          },
        },
      })

      if (response.node) {
        updateNodeLocal(response.node)
        selectedNodeId.value = response.node.id
        frameControlMode.value = 'outer'
        tool.value = 'select'
        runtimeMode.value = 'widget'
        status.value = parent
          ? 'Text node created inside active frame'
          : 'Text node created at zone root'
      }
      return response.node
    } catch (err: any) {
      error.value = errorMessage(err, 'Unable to create text node')
      throw err
    } finally {
      pending.value = false
    }
  }

  const patchTextContent = async (
    id: string,
    content: Partial<HeliosTextContent> | string,
  ) => {
    const current = getNodeById(id)
    if (!current) return null
    if (current.kind !== 'text') {
      error.value = 'Select a text node before editing text content'
      return null
    }
    if (isLockedNode(current)) {
      error.value = 'Unlock text before editing content'
      return null
    }
    const nextContent = normalizeTextContentInput({
      ...(current.content ?? createDefaultTextContent()),
      ...(typeof content === 'string' ? { text: content } : content),
    })
    updateNodeLocal({ ...current, content: nextContent })
    return updateNode(id, { content: nextContent })
  }

  const copySelectedFrame = () => {
    const node = selectedNode.value
    if (!node) {
      error.value = 'Select a frame before copying'
      return false
    }
    if (node.kind !== 'frame') {
      error.value = 'Only frames can be copied right now'
      return false
    }
    frameClipboard.value = {
      sourceId: node.id,
      label: node.label,
      qualities: cloneQualities(node.qualities),
      meta: cloneMeta(node.meta),
    }
    error.value = null
    status.value = `Copied ${node.label || 'frame'}`
    return true
  }

  const createPastedFrame = async (input: {
    parent: HeliosNodeRecord | null
    anchor: HeliosNodeRecord | null
    documentId: string
    zoneId: string
    mode: 'sibling' | 'child'
  }) => {
    const clipboard = frameClipboard.value
    if (!clipboard) {
      error.value = 'Copy a frame before pasting'
      return null
    }
    if (isLockedNode(input.parent)) {
      error.value = 'Unlock parent frame before pasting inside it'
      return null
    }

    pending.value = true
    error.value = null
    setActiveZone(input.documentId, input.zoneId)

    const source = getNodeById(clipboard.sourceId)
    const sourceCell = source
      ? getNodeGridCell(source, activeBreakpoint.value) || getNodeGridCell(source, 'base')
      : getGridCellValue(clipboard.qualities, undefined, activeBreakpoint.value)
        || getGridCellValue(clipboard.qualities, undefined, 'base')
    const anchorCell = input.anchor
      ? getNodeGridCell(input.anchor, activeBreakpoint.value) || getNodeGridCell(input.anchor, 'base')
      : null
    const surface = gridSurfaceForParent(input.documentId, input.zoneId, input.parent)
    const span = frameSpan(sourceCell)
    const nextCell = input.mode === 'child'
      ? clampFrameCell({
          colStart: 2,
          rowStart: 2,
          colEnd: 2 + span.cols,
          rowEnd: 2 + span.rows,
        }, surface.cols, surface.rows)
      : clampFrameCell({
          colStart: Number(anchorCell?.colStart ?? sourceCell?.colStart ?? 1) + 1,
          rowStart: Number(anchorCell?.rowStart ?? sourceCell?.rowStart ?? 1) + 1,
          colEnd: Number(anchorCell?.colStart ?? sourceCell?.colStart ?? 1) + 1 + span.cols,
          rowEnd: Number(anchorCell?.rowStart ?? sourceCell?.rowStart ?? 1) + 1 + span.rows,
        }, surface.cols, surface.rows)

    const qualities = upsertGridCellWithBase(
      cloneQualities(clipboard.qualities),
      nextCell,
      activeBreakpoint.value,
    )
    const siblingCount = nodesForZone(input.documentId, input.zoneId)
      .filter((node) => (node.parentId || null) === (input.parent?.id || null))
      .length
    const meta = cloneMeta(clipboard.meta)
    meta.editor = {
      ...(meta.editor && typeof meta.editor === 'object' ? meta.editor : {}),
      locked: false,
      duplicatedFrom: clipboard.sourceId,
    }

    try {
      const response = await $fetch<{ ok: boolean; node: HeliosNodeRecord }>('/api/helios/nodes', {
        method: 'POST',
        body: {
          documentId: input.documentId,
          zoneId: input.zoneId,
          kind: 'frame',
          parent: input.parent?.record ?? null,
          order: siblingCount,
          label: nextGeneratedFrameLabel(input.documentId, input.zoneId, input.parent?.id ?? null),
          qualities,
          meta,
        },
      })

      if (response.node) {
        updateNodeLocal(response.node)
        selectedNodeId.value = response.node.id
        tool.value = 'select'
        status.value = input.mode === 'child'
          ? 'Frame pasted inside selected frame'
          : 'Frame pasted alongside selected frame'
      }
      return response.node
    } catch (err: any) {
      error.value = errorMessage(err, 'Unable to paste Helios frame')
      throw err
    } finally {
      pending.value = false
    }
  }

  const pasteCopiedFrame = async () => {
    const clipboard = frameClipboard.value
    if (!clipboard) {
      error.value = 'Copy a frame before pasting'
      return null
    }
    const anchor = selectedNode.value ?? getNodeById(clipboard.sourceId)
    const nextDocumentId = anchor?.documentId ?? documentId.value
    const nextZoneId = anchor?.zoneId ?? activeZoneId.value
    if (!nextDocumentId || !nextZoneId) {
      error.value = 'Select a zone before pasting'
      return null
    }
    const parent = anchor?.parentId ? getNodeById(anchor.parentId) : null
    return createPastedFrame({
      parent,
      anchor,
      documentId: nextDocumentId,
      zoneId: nextZoneId,
      mode: 'sibling',
    })
  }

  const pasteCopiedFrameInsideSelected = async () => {
    const parent = selectedNode.value
    if (!parent) {
      error.value = 'Select a parent frame before pasting inside'
      return null
    }
    if (parent.kind !== 'frame') {
      error.value = 'Paste inside currently supports frames only'
      return null
    }
    return createPastedFrame({
      parent,
      anchor: null,
      documentId: parent.documentId,
      zoneId: parent.zoneId,
      mode: 'child',
    })
  }

  const deleteNode = async (id: string) => {
    const current = getNodeById(id)
    const idsToDelete = [id, ...descendantIdsFor(id)]
    const lockedNode = idsToDelete.map((nodeId) => getNodeById(nodeId)).find(isLockedNode)
    if (lockedNode) {
      error.value = 'Unlock node before deleting'
      return
    }

    pending.value = true
    error.value = null

    try {
      for (const nodeId of [...idsToDelete].reverse()) {
        const node = getNodeById(nodeId)
        await $fetch<{ ok: boolean }>('/api/helios/nodes', {
          method: 'DELETE',
          body: {
            record: node?.record ?? nodeId,
          },
        })
      }
      if (current) {
        const key = scopeKeyForNode(current)
        nodesByScope.value = {
          ...nodesByScope.value,
          [key]: (nodesByScope.value[key] ?? []).filter((node) => !idsToDelete.includes(node.id)),
        }
      } else {
        const nextByScope: Record<string, HeliosNodeRecord[]> = {}
        for (const [key, scopeNodes] of Object.entries(nodesByScope.value)) {
          nextByScope[key] = scopeNodes.filter((node) => !idsToDelete.includes(node.id))
        }
        nodesByScope.value = nextByScope
      }
      if (selectedNodeId.value && idsToDelete.includes(selectedNodeId.value)) clearSelection()
      const nextContexts = { ...activeContextByScope.value }
      for (const [key, contextId] of Object.entries(nextContexts)) {
        if (contextId && idsToDelete.includes(contextId)) {
          nextContexts[key] = null
        }
      }
      activeContextByScope.value = nextContexts
      status.value = idsToDelete.length > 1 ? 'Helios node tree deleted' : 'Helios node deleted'
    } catch (err: any) {
      error.value = errorMessage(err, 'Unable to delete Helios node')
      throw err
    } finally {
      pending.value = false
    }
  }

  const deleteSelectedNode = async () => {
    if (!selectedNodeId.value) return
    await deleteNode(selectedNodeId.value)
  }

  const migrate = async () => {
    pending.value = true
    error.value = null

    try {
      const response = await $fetch<{ ok: boolean; notes: string[] }>('/api/helios/setup/migrate', {
        method: 'POST',
      })
      status.value = response.notes?.[0] || 'Helios storage migrated'
      return response
    } catch (err: any) {
      error.value = errorMessage(err, 'Unable to migrate Helios storage')
      throw err
    } finally {
      pending.value = false
    }
  }

  return {
    active,
    tool,
    runtimeMode,
    frameControlMode,
    settings,
    selectedNodeId,
    selectedNode,
    activeContextByScope,
    activeContextNodeId,
    activeContextNode,
    activeZoneId,
    documentId,
    activeBreakpoint,
    activeViewport,
    breakpoints: HELIOS_RUNTIME_BREAKPOINTS,
    viewports: HELIOS_RUNTIME_VIEWPORTS,
    draftRect,
    nodesByScope,
    canvasByScope,
    nodes,
    pending,
    error,
    status,
    navigatorOpen,
    frameOptionsOpen,
    setActive,
    toggleActive,
    setTool,
    setRuntimeMode,
    setFrameControlMode,
    toggleFrameControlMode,
    setActiveBreakpoint,
    cycleBreakpoint,
    cycleBreakpointPrevious,
    setDeselectOnCanvasClick,
    setFrameLabelVisibility,
    setArenaLabelPlacement,
    setActiveZone,
    canvasForZone,
    setCanvasForZone,
    adjustCanvasRows,
    adjustCanvasByViewportUnit,
    normalizeCanvasHeightForZone,
    canvasPixelHeight,
    setDraftRect,
    selectNode,
    setActiveContextNode,
    activeContextNodeIdForZone,
    activeContextNodeForZone,
    enterNodeContext,
    exitNodeContext,
    clearSelection,
    getEffectiveNodeInnerBox,
    setNodeInnerBoxLocal,
    ensureNodeInnerBoxLocal,
    isInnerFrameControlActive,
    toggleNavigator,
    toggleFrameOptions,
    nodesForZone,
    rootNodesForZone,
    childNodesFor,
    getNodeById,
    getNodeGridCell,
    getNodeGridContainer,
    getNodeBackgroundInput,
    getNodeInnerBoxBackgroundInput,
    getNodeInnerBox,
    isNodeLocked,
    loadNodes,
    updateNode,
    setNodeGridCellLocal,
    patchNodeGridCell,
    patchNodeGridContainer,
    patchNodeBackground,
    patchNodeInnerBoxBackground,
    patchNodeInnerBox,
    updateSelectedNodeLabel,
    toggleNodeLock,
    createFrameNode,
    createTextNode,
    patchTextContent,
    copySelectedFrame,
    pasteCopiedFrame,
    pasteCopiedFrameInsideSelected,
    deleteNode,
    deleteSelectedNode,
    migrate,
  }
})
