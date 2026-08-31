export type HeliosBreakpointKey = 'base' | string
export type HeliosNodeKind = 'frame' | 'text' | 'image' | 'widget'
export const HELIOS_TEXT_TAGS = ['p', 'span', 'div', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'] as const
export type HeliosTextTag = typeof HELIOS_TEXT_TAGS[number]
export const HELIOS_IMAGE_OBJECT_FITS = ['cover', 'contain', 'fill', 'none', 'scale-down'] as const
export type HeliosImageObjectFit = typeof HELIOS_IMAGE_OBJECT_FITS[number]

export const HELIOS_CANVAS_MAX_COLS = 96
export const HELIOS_CANVAS_MAX_ROWS = 720

export type HeliosRecordIdPart =
  | string
  | number
  | unknown[]
  | Record<string, unknown>

export type HeliosRecordRef = {
  table: string
  id: HeliosRecordIdPart
  key: string
  display: string
}

export type HeliosBackgroundValue =
  | { kind: 'semantic-token'; token: string }
  | { kind: 'palette'; palette: string; step: string }
  | { kind: 'color'; value: string }

export type HeliosGridContainerMode = 'division' | 'rhythm'
export type HeliosGridContainerUnit = 'fr' | 'gu'

export type HeliosGridContainerValue = {
  mode?: HeliosGridContainerMode
  cols: number
  rows: number
  unit?: HeliosGridContainerUnit
}

export type HeliosGridCellValue = {
  cols: number
  rows: number
  colStart: number
  colEnd: number
  rowStart: number
  rowEnd: number
}

export type HeliosInnerBoxMode = 'none' | 'inset' | 'container'
export type HeliosInnerBoxSnapTarget = 'division-grid' | 'rhythm-grid'

export type HeliosInnerBoxValue = {
  mode: HeliosInnerBoxMode
  snapTo: HeliosInnerBoxSnapTarget
  insetTop?: number
  insetRight?: number
  insetBottom?: number
  insetLeft?: number
  maxWidth?: string | number | null
  centerX?: boolean
  centerY?: boolean
}

export type HeliosTextContent = {
  text: string
  tag: HeliosTextTag
}

export type HeliosImageContent = {
  src: string
  alt?: string
  objectFit?: HeliosImageObjectFit
  objectPosition?: string
}

export type HeliosNodeContent = HeliosTextContent | HeliosImageContent

export type HeliosQualityValue =
  | HeliosBackgroundValue
  | HeliosGridContainerValue
  | HeliosGridCellValue
  | HeliosInnerBoxValue

export type HeliosQualityMap = Record<
  string,
  Partial<Record<HeliosBreakpointKey, HeliosQualityValue>>
>

export type HeliosPreviewStyle = Record<string, string>

export type HeliosQualityDefinition<TValue> = {
  key: string
  normalize(input: unknown): TValue | null
  format(value: TValue | null | undefined): string
  preview(value: TValue | null | undefined): HeliosPreviewStyle
  compile(value: TValue, breakpoint: HeliosBreakpointKey): string[]
}

export type HeliosCompiledBaseNode = {
  id: string
  subId: string
  label?: string | null
  dataHeliosNode: string
}

export type HeliosCompiledTextNode = HeliosCompiledBaseNode & {
  kind: 'text'
  tag: HeliosTextTag
  text: string
  classes: string[]
  style?: Record<string, string>
}

export type HeliosCompiledImageNode = HeliosCompiledBaseNode & {
  kind: 'image'
  src: string
  alt?: string
  objectFit: HeliosImageObjectFit
  objectPosition: string
  classes: string[]
  style?: Record<string, string>
}

export type HeliosCompiledFrameNode = HeliosCompiledBaseNode & {
  kind: 'frame'
  outerClasses: string[]
  outerStyle?: Record<string, string>
  innerClasses: string[]
  innerStyle?: Record<string, string>
  children: HeliosCompiledNode[]
}

export type HeliosCompiledNode =
  | HeliosCompiledFrameNode
  | HeliosCompiledTextNode
  | HeliosCompiledImageNode

export type HeliosPageManifest = {
  version: 1
  pageId: string
  meta?: Record<string, unknown>
  canvas: {
    classes: string[]
    style?: Record<string, string>
  }
  nodes: HeliosCompiledNode[]
}

export type HeliosPageManifestInput = {
  pageId: string
  nodes: HeliosNodeRecord[]
  cols?: number
  rows?: number
  canvasHeight?: number
}

export type HeliosNodeRecord = {
  /** Compatibility alias for record.key. Treat as an opaque client key. */
  id: string
  record: HeliosRecordRef
  parent: HeliosRecordRef | null
  documentId: string
  zoneId: string
  kind: HeliosNodeKind
  /** Compatibility alias for parent?.key. Treat as an opaque client key. */
  parentId: string | null
  order: number
  label?: string | null
  content?: HeliosNodeContent | null
  qualities?: HeliosQualityMap
  meta?: Record<string, any>
}

export type HeliosNodeCreateInput = {
  documentId: string
  zoneId: string
  kind: HeliosNodeKind
  parent?: HeliosRecordRef | null
  parentId?: string | null
  order: number
  label?: string | null
  content?: HeliosNodeContent | null
  qualities?: HeliosQualityMap
  meta?: Record<string, any>
}

export type HeliosNodePatch = Partial<HeliosNodeCreateInput>

export const BACKGROUND_QUALITY_KEY = 'appearance.bg'
export const INNER_BOX_BACKGROUND_QUALITY_KEY = 'appearance.innerBox.bg'
export const GRID_CONTAINER_QUALITY_KEY = 'layout.grid.container'
export const GRID_CELL_QUALITY_KEY = 'layout.grid.cell'
export const INNER_BOX_QUALITY_KEY = 'layout.innerBox'
export const HELIOS_GRID_UNIT_CSS_VAR = 'var(--h-gu)'
export const HELIOS_GRID_UNIT_PREVIEW_CSS_VAR = 'var(--h-gu, 1.4rem)'

export const DEFAULT_FRAME_GRID: Readonly<HeliosGridContainerValue> = {
  mode: 'division',
  cols: 24,
  rows: 24,
  unit: 'fr',
}

export const createDefaultFrameGrid = (): HeliosGridContainerValue => ({
  ...DEFAULT_FRAME_GRID,
})

const PALETTE_BG_RE = /^bg-([a-z][a-z0-9-]*)-(\d{2,3})$/i
const PALETTE_TOKEN_RE = /^palette:([a-z][a-z0-9-]*):(\d{2,3})$/i
const SEMANTIC_BG_RE = /^bg-([a-z][a-z0-9-]*)$/i
const SEMANTIC_TOKEN_RE = /^(?:semantic:|bg\.)([a-z][a-z0-9-]*)$/i
const ARBITRARY_BG_RE = /^bg-\[(.+)\]$/i
const HEX_COLOR_RE = /^#([0-9a-f]{3,8})$/i
const GRADIENT_RE = /^(linear-gradient|radial-gradient|conic-gradient)\(/i
const GRID_SIZE_RE = /^(\d{1,3})x(\d{1,3})$/i
const RECORD_KEY_PREFIX = 'hrec_'
const RECORD_TABLE_RE = /^[a-zA-Z_][a-zA-Z0-9_]*$/
const SIMPLE_RECORD_ID_RE = /^[a-zA-Z0-9_]+$/
const INNER_BOX_MODES = new Set<HeliosInnerBoxMode>(['none', 'inset', 'container'])
const INNER_BOX_SNAP_TARGETS = new Set<HeliosInnerBoxSnapTarget>(['division-grid', 'rhythm-grid'])
const GRID_CONTAINER_MODES = new Set<HeliosGridContainerMode>(['division', 'rhythm'])
const TEXT_TAGS = new Set<HeliosTextTag>(HELIOS_TEXT_TAGS)
const IMAGE_OBJECT_FITS = new Set<HeliosImageObjectFit>(HELIOS_IMAGE_OBJECT_FITS)

const cloneQualities = (qualities?: HeliosQualityMap | null) => {
  if (!qualities || typeof qualities !== 'object') return {}
  return JSON.parse(JSON.stringify(qualities)) as HeliosQualityMap
}

const toCssVar = (name: string) => `var(${name})`

export const withBreakpoint = (token: string, breakpoint: HeliosBreakpointKey) => {
  const normalized = String(breakpoint || 'base').trim()
  if (!normalized || normalized === 'base') return token
  return `${normalized}:${token}`
}

export const sortBreakpoints = (breakpoints: Iterable<HeliosBreakpointKey>) => {
  return Array.from(new Set(Array.from(breakpoints)))
    .sort((a, b) => {
      if (a === 'base') return -1
      if (b === 'base') return 1
      return String(a).localeCompare(String(b))
    })
}

const normalizeArbitraryValue = (value: string) => value.replaceAll('_', ' ')

const escapeUnoArbitraryValue = (value: string) => value.replace(/\s+/g, '_')

const asRecord = (value: unknown): Record<string, any> => (
  value && typeof value === 'object' && !Array.isArray(value)
    ? value as Record<string, any>
    : {}
)

export const normalizeTextTag = (input: unknown): HeliosTextTag => {
  const value = String(input || 'p').trim().toLowerCase() as HeliosTextTag
  return TEXT_TAGS.has(value) ? value : 'p'
}

export const normalizeTextContentInput = (input: unknown): HeliosTextContent => {
  if (typeof input === 'string') {
    return {
      text: input,
      tag: 'p',
    }
  }

  const source = asRecord(input)
  return {
    text: String(source.text ?? source.value ?? ''),
    tag: normalizeTextTag(source.tag),
  }
}

export const createDefaultTextContent = (): HeliosTextContent => ({
  text: 'Text',
  tag: 'p',
})

export const normalizeImageObjectFit = (input: unknown): HeliosImageObjectFit => {
  const value = String(input || 'cover').trim().toLowerCase() as HeliosImageObjectFit
  return IMAGE_OBJECT_FITS.has(value) ? value : 'cover'
}

export const normalizeImageContentInput = (input: unknown): HeliosImageContent => {
  const source = asRecord(input)
  return {
    src: String(source.src ?? source.url ?? ''),
    alt: source.alt === undefined || source.alt === null ? '' : String(source.alt),
    objectFit: normalizeImageObjectFit(source.objectFit ?? source.fit),
    objectPosition: String(source.objectPosition ?? source.position ?? '50% 50%'),
  }
}

export const createDefaultImageContent = (): HeliosImageContent => ({
  src: '',
  alt: '',
  objectFit: 'cover',
  objectPosition: '50% 50%',
})

const isRecordIdPartObject = (value: unknown): value is Record<string, unknown> => (
  value !== null && typeof value === 'object' && !Array.isArray(value)
)

const cloneJsonValue = <T>(value: T): T => (
  value && typeof value === 'object'
    ? JSON.parse(JSON.stringify(value)) as T
    : value
)

const stableJsonValue = (value: unknown): unknown => {
  if (Array.isArray(value)) return value.map((entry) => stableJsonValue(entry))
  if (value && typeof value === 'object') {
    const source = value as Record<string, unknown>
    return Object.keys(source)
      .sort()
      .reduce<Record<string, unknown>>((next, key) => {
        next[key] = stableJsonValue(source[key])
        return next
      }, {})
  }
  return value
}

const stableStringify = (value: unknown) => JSON.stringify(stableJsonValue(value))

const encodeBase64Url = (value: string) => {
  const globalValue = globalThis as any
  const base64 = globalValue.Buffer
    ? globalValue.Buffer.from(value, 'utf8').toString('base64')
    : btoa(Array.from(new TextEncoder().encode(value), (byte) => String.fromCharCode(byte)).join(''))
  return base64.replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/g, '')
}

const decodeBase64Url = (value: string) => {
  const normalized = value.replace(/-/g, '+').replace(/_/g, '/')
  const padded = normalized.padEnd(Math.ceil(normalized.length / 4) * 4, '=')
  const globalValue = globalThis as any
  if (globalValue.Buffer) return globalValue.Buffer.from(padded, 'base64').toString('utf8')
  const binary = atob(padded)
  const bytes = Uint8Array.from(binary, (char) => char.charCodeAt(0))
  return new TextDecoder().decode(bytes)
}

const readTableName = (value: unknown, fallbackTable?: string) => {
  if (typeof value === 'string') return value
  if (value && typeof value === 'object') {
    const record = value as Record<string, any>
    if (typeof record.name === 'string') return record.name
    if (typeof record.tb === 'string') return record.tb
    if (typeof record.table === 'string') return record.table
  }
  return fallbackTable || ''
}

const normalizeEncodedRecordIdPart = (value: unknown): HeliosRecordIdPart | null => {
  if (typeof value === 'string' || typeof value === 'number') return value
  if (Array.isArray(value)) return cloneJsonValue(value)
  if (isRecordIdPartObject(value)) return cloneJsonValue(value)
  return null
}

const normalizeRecordIdPartFromSdk = (value: unknown): HeliosRecordIdPart | null => {
  if (typeof value === 'string' || typeof value === 'number') return value
  if (Array.isArray(value)) return cloneJsonValue(value)
  if (isRecordIdPartObject(value)) {
    const source = value as Record<string, any>
    if (typeof source.String === 'string') return source.String
    if (typeof source.Number === 'number' || typeof source.Number === 'string') return Number(source.Number)
    return cloneJsonValue(value)
  }
  return null
}

const readRecordIdPart = (value: unknown): HeliosRecordIdPart | null => {
  if (value && typeof value === 'object' && !Array.isArray(value)) {
    const source = value as Record<string, any>
    if ('id' in source && ('tb' in source || 'table' in source)) {
      return normalizeRecordIdPartFromSdk(source.id)
    }
  }
  return normalizeEncodedRecordIdPart(value)
}

const displayRecordIdPart = (id: HeliosRecordIdPart): string => {
  if (typeof id === 'number') return String(id)
  if (typeof id === 'string') {
    return SIMPLE_RECORD_ID_RE.test(id)
      ? id
      : `\`${id.replace(/`/g, '\\`')}\``
  }
  return JSON.stringify(id)
}

export const createHeliosRecordKey = (
  input: Pick<HeliosRecordRef, 'table' | 'id'>,
) => {
  return `${RECORD_KEY_PREFIX}${encodeBase64Url(stableStringify({
    v: 1,
    table: input.table,
    id: input.id,
  }))}`
}

export const decodeHeliosRecordKey = (
  key: string,
): Pick<HeliosRecordRef, 'table' | 'id'> | null => {
  const value = String(key || '').trim()
  if (!value.startsWith(RECORD_KEY_PREFIX)) return null
  try {
    const decoded = JSON.parse(decodeBase64Url(value.slice(RECORD_KEY_PREFIX.length)))
    const table = readTableName(decoded?.table)
    const id = normalizeEncodedRecordIdPart(decoded?.id)
    if (!table || id === null) return null
    return { table, id }
  } catch {
    return null
  }
}

export const createHeliosRecordRef = (
  table: string,
  id: HeliosRecordIdPart,
): HeliosRecordRef => {
  const normalizedTable = readTableName(table)
  if (!normalizedTable || !RECORD_TABLE_RE.test(normalizedTable)) {
    throw new Error(`Invalid Helios record table: ${String(table || '')}`)
  }
  const normalizedId = stableJsonValue(cloneJsonValue(id)) as HeliosRecordIdPart
  const key = createHeliosRecordKey({ table: normalizedTable, id: normalizedId })
  return {
    table: normalizedTable,
    id: normalizedId,
    key,
    display: `${normalizedTable}:${displayRecordIdPart(normalizedId)}`,
  }
}

export const normalizeHeliosRecordRef = (
  input: unknown,
  fallbackTable?: string,
): HeliosRecordRef | null => {
  if (!input) return null

  if (typeof input === 'string') {
    const decoded = decodeHeliosRecordKey(input)
    if (decoded) return createHeliosRecordRef(decoded.table, decoded.id)

    const trimmed = input.trim()
    if (!trimmed) return null
    if (fallbackTable && trimmed.startsWith(`${fallbackTable}:`)) {
      return createHeliosRecordRef(fallbackTable, trimmed.slice(fallbackTable.length + 1))
    }
    if (!fallbackTable) {
      const [candidateTable, ...rest] = trimmed.split(':')
      if (candidateTable && rest.length > 0 && RECORD_TABLE_RE.test(candidateTable)) {
        return createHeliosRecordRef(candidateTable, rest.join(':'))
      }
    }
    if (fallbackTable) return createHeliosRecordRef(fallbackTable, trimmed)
    return null
  }

  if (input && typeof input === 'object') {
    const source = input as Record<string, any>
    if (typeof source.key === 'string') {
      const decoded = decodeHeliosRecordKey(source.key)
      if (decoded) return createHeliosRecordRef(decoded.table, decoded.id)
    }
    const table = readTableName(source.tb ?? source.table, fallbackTable)
    const id = readRecordIdPart(source)
    if (table && id !== null) return createHeliosRecordRef(table, id)
  }

  return null
}

const toGridCount = (value: unknown, fallback = 24) => {
  const parsed = Number(value)
  if (!Number.isFinite(parsed)) return Math.max(1, Math.min(96, Math.round(fallback)))
  return Math.max(1, Math.min(96, Math.round(parsed)))
}

const toGridLine = (value: unknown, fallback: number, min: number, max: number) => {
  const parsed = Number(value)
  const next = Number.isFinite(parsed) ? Math.round(parsed) : fallback
  return Math.max(min, Math.min(max, next))
}

const normalizeGridContainerMode = (value: unknown): HeliosGridContainerMode => {
  const mode = String(value || 'division').trim() as HeliosGridContainerMode
  return GRID_CONTAINER_MODES.has(mode) ? mode : 'division'
}

const toOptionalInnerBoxNumber = (value: unknown) => {
  if (value === undefined || value === null || value === '') return undefined
  const parsed = Number(value)
  if (!Number.isFinite(parsed)) return undefined
  return Math.max(0, Number(parsed.toFixed(4)))
}

const normalizeInnerBoxMode = (value: unknown): HeliosInnerBoxMode => {
  const mode = String(value || 'none').trim() as HeliosInnerBoxMode
  return INNER_BOX_MODES.has(mode) ? mode : 'none'
}

const normalizeInnerBoxSnapTarget = (value: unknown): HeliosInnerBoxSnapTarget => {
  const snapTo = String(value || 'division-grid').trim() as HeliosInnerBoxSnapTarget
  return INNER_BOX_SNAP_TARGETS.has(snapTo) ? snapTo : 'division-grid'
}

export const normalizeBackgroundInput = (input: unknown): HeliosBackgroundValue | null => {
  const trimmed = String(input ?? '').trim()
  if (!trimmed) return null

  const arbitraryMatch = trimmed.match(ARBITRARY_BG_RE)
  if (arbitraryMatch?.[1]) {
    return { kind: 'color', value: normalizeArbitraryValue(arbitraryMatch[1].trim()) }
  }

  const paletteBgMatch = trimmed.match(PALETTE_BG_RE)
  if (paletteBgMatch?.[1] && paletteBgMatch?.[2]) {
    return {
      kind: 'palette',
      palette: paletteBgMatch[1].toLowerCase(),
      step: paletteBgMatch[2],
    }
  }

  const paletteTokenMatch = trimmed.match(PALETTE_TOKEN_RE)
  if (paletteTokenMatch?.[1] && paletteTokenMatch?.[2]) {
    return {
      kind: 'palette',
      palette: paletteTokenMatch[1].toLowerCase(),
      step: paletteTokenMatch[2],
    }
  }

  const semanticTokenMatch = trimmed.match(SEMANTIC_TOKEN_RE)
  if (semanticTokenMatch?.[1]) {
    return {
      kind: 'semantic-token',
      token: semanticTokenMatch[1],
    }
  }

  const semanticBgMatch = trimmed.match(SEMANTIC_BG_RE)
  if (semanticBgMatch?.[1]) {
    return {
      kind: 'semantic-token',
      token: semanticBgMatch[1],
    }
  }

  return {
    kind: 'color',
    value: trimmed,
  }
}

export const formatBackgroundValue = (value: HeliosBackgroundValue | null | undefined) => {
  if (!value) return ''
  if (value.kind === 'semantic-token') {
    return `bg-${value.token}`
  }
  if (value.kind === 'palette') {
    return `bg-${value.palette}-${value.step}`
  }
  return value.value
}

export const getQualityValue = (
  qualities: HeliosQualityMap | null | undefined,
  key: string,
  breakpoint: HeliosBreakpointKey = 'base',
) => {
  const entry = qualities?.[key]
  if (!entry) return null
  return (entry[breakpoint] ?? entry.base ?? null) as HeliosQualityValue | null
}

export const getBackgroundValue = (
  qualities: HeliosQualityMap | null | undefined,
  legacyValue?: unknown,
  breakpoint: HeliosBreakpointKey = 'base',
) => {
  const direct = getQualityValue(qualities, BACKGROUND_QUALITY_KEY, breakpoint)
  if (direct) return direct as HeliosBackgroundValue
  return normalizeBackgroundInput(legacyValue)
}

export const resolveBackgroundInputValue = (
  qualities: HeliosQualityMap | null | undefined,
  legacyValue?: unknown,
  breakpoint: HeliosBreakpointKey = 'base',
) => {
  return formatBackgroundValue(getBackgroundValue(qualities, legacyValue, breakpoint))
}

export const upsertBackgroundQuality = (
  qualities: HeliosQualityMap | null | undefined,
  input: unknown,
  breakpoint: HeliosBreakpointKey = 'base',
) => {
  const next = cloneQualities(qualities)
  const value = normalizeBackgroundInput(input)
  const current = { ...(next[BACKGROUND_QUALITY_KEY] ?? {}) }

  if (!value) {
    delete current[breakpoint]
    if (Object.keys(current).length === 0) {
      delete next[BACKGROUND_QUALITY_KEY]
    } else {
      next[BACKGROUND_QUALITY_KEY] = current
    }
    return Object.keys(next).length ? next : undefined
  }

  current[breakpoint] = value
  next[BACKGROUND_QUALITY_KEY] = current
  return next
}

export const getInnerBoxBackgroundValue = (
  qualities: HeliosQualityMap | null | undefined,
  legacyValue?: unknown,
  breakpoint: HeliosBreakpointKey = 'base',
) => {
  const direct = getQualityValue(qualities, INNER_BOX_BACKGROUND_QUALITY_KEY, breakpoint)
  if (direct) return direct as HeliosBackgroundValue
  return normalizeBackgroundInput(legacyValue)
}

export const resolveInnerBoxBackgroundInputValue = (
  qualities: HeliosQualityMap | null | undefined,
  legacyValue?: unknown,
  breakpoint: HeliosBreakpointKey = 'base',
) => {
  return formatBackgroundValue(getInnerBoxBackgroundValue(qualities, legacyValue, breakpoint))
}

export const upsertInnerBoxBackgroundQuality = (
  qualities: HeliosQualityMap | null | undefined,
  input: unknown,
  breakpoint: HeliosBreakpointKey = 'base',
) => {
  const next = cloneQualities(qualities)
  const value = normalizeBackgroundInput(input)
  const current = { ...(next[INNER_BOX_BACKGROUND_QUALITY_KEY] ?? {}) }

  if (!value) {
    delete current[breakpoint]
    if (Object.keys(current).length === 0) {
      delete next[INNER_BOX_BACKGROUND_QUALITY_KEY]
    } else {
      next[INNER_BOX_BACKGROUND_QUALITY_KEY] = current
    }
    return Object.keys(next).length ? next : undefined
  }

  current[breakpoint] = value
  next[INNER_BOX_BACKGROUND_QUALITY_KEY] = current
  return next
}

const toPreviewBackgroundStyle = (value: HeliosBackgroundValue | null | undefined) => {
  if (!value) return {}
  if (value.kind === 'semantic-token') {
    return {
      background: toCssVar(`--hc-bg-${value.token}`),
    }
  }
  if (value.kind === 'palette') {
    return {
      background: toCssVar(`--hc-${value.palette}-${value.step}`),
    }
  }

  return GRADIENT_RE.test(value.value)
    ? { background: value.value }
    : { background: value.value }
}

export const resolveBackgroundPreviewStyle = (
  qualities: HeliosQualityMap | null | undefined,
  legacyValue?: unknown,
  breakpoint: HeliosBreakpointKey = 'base',
) => {
  return toPreviewBackgroundStyle(getBackgroundValue(qualities, legacyValue, breakpoint))
}

export const resolveInnerBoxBackgroundPreviewStyle = (
  qualities: HeliosQualityMap | null | undefined,
  legacyValue?: unknown,
  breakpoint: HeliosBreakpointKey = 'base',
) => {
  return toPreviewBackgroundStyle(getInnerBoxBackgroundValue(qualities, legacyValue, breakpoint))
}

const compileBackgroundClass = (
  value: HeliosBackgroundValue,
  breakpoint: HeliosBreakpointKey,
) => {
  if (value.kind === 'semantic-token') {
    return withBreakpoint(`bg-${value.token}`, breakpoint)
  }
  if (value.kind === 'palette') {
    return withBreakpoint(`bg-${value.palette}-${value.step}`, breakpoint)
  }

  const raw = value.value.trim()
  if (!raw) return ''
  if (HEX_COLOR_RE.test(raw)) {
    return withBreakpoint(`bg-[${raw}]`, breakpoint)
  }
  return withBreakpoint(`bg-[${escapeUnoArbitraryValue(raw)}]`, breakpoint)
}

export const backgroundQualityDefinition: HeliosQualityDefinition<HeliosBackgroundValue> = {
  key: BACKGROUND_QUALITY_KEY,
  normalize: normalizeBackgroundInput,
  format: formatBackgroundValue,
  preview: toPreviewBackgroundStyle,
  compile: (value, breakpoint) => [compileBackgroundClass(value, breakpoint)].filter(Boolean),
}

export const innerBoxBackgroundQualityDefinition: HeliosQualityDefinition<HeliosBackgroundValue> = {
  key: INNER_BOX_BACKGROUND_QUALITY_KEY,
  normalize: normalizeBackgroundInput,
  format: formatBackgroundValue,
  preview: toPreviewBackgroundStyle,
  compile: (value, breakpoint) => [compileBackgroundClass(value, breakpoint)].filter(Boolean),
}

export const normalizeGridContainerInput = (input: unknown): HeliosGridContainerValue | null => {
  if (typeof input === 'string') {
    const sizeMatch = input.trim().match(GRID_SIZE_RE)
    if (!sizeMatch?.[1] || !sizeMatch?.[2]) return null
    return {
      mode: 'division',
      cols: toGridCount(sizeMatch[1], 24),
      rows: toGridCount(sizeMatch[2], 24),
      unit: 'fr',
    }
  }

  const source = asRecord(input)
  const nestedGrid = asRecord(source.grid)
  const innerLayout = asRecord(source.innerLayout)
  const innerGrid = asRecord(innerLayout.grid)
  const colsInput = source.cols ?? source.columns ?? source.x ?? innerGrid.cols ?? nestedGrid.cols
  const rowsInput = source.rows ?? source.y ?? innerGrid.rows ?? nestedGrid.rows
  const hasExplicitValue = [colsInput, rowsInput].some((value) => value !== undefined && value !== null && value !== '')
  if (!hasExplicitValue) return null
  const mode = normalizeGridContainerMode(source.mode ?? nestedGrid.mode ?? innerGrid.mode)

  return {
    mode,
    cols: toGridCount(colsInput, 24),
    rows: toGridCount(rowsInput, 24),
    unit: mode === 'rhythm' ? 'gu' : 'fr',
  }
}

export const normalizeGridCellInput = (input: unknown): HeliosGridCellValue | null => {
  const source = asRecord(input)
  const nestedGrid = asRecord(source.grid)
  const nestedCell = asRecord(source.cell)
  const cellSource = Object.keys(nestedCell).length > 0 ? nestedCell : source
  const topLeft = asRecord(cellSource.topLeft)
  const topRight = asRecord(cellSource.topRight)
  const bottomLeft = asRecord(cellSource.bottomLeft)
  const hasCellSignal = [
    cellSource.colStart,
    cellSource.colEnd,
    cellSource.rowStart,
    cellSource.rowEnd,
    topLeft.col,
    topLeft.row,
    topRight.col,
    bottomLeft.row,
  ].some((value) => value !== undefined && value !== null && value !== '')

  if (!hasCellSignal) return null

  const cols = toGridCount(cellSource.cols ?? source.cols ?? nestedGrid.cols, 24)
  const rows = toGridCount(cellSource.rows ?? source.rows ?? nestedGrid.rows, 24)
  const colStart = toGridLine(cellSource.colStart ?? topLeft.col, 1, 1, cols)
  const rowStart = toGridLine(cellSource.rowStart ?? topLeft.row, 1, 1, rows)
  const colEnd = Math.max(
    colStart + 1,
    toGridLine(cellSource.colEnd ?? topRight.col, colStart + 1, 2, cols + 1),
  )
  const rowEnd = Math.max(
    rowStart + 1,
    toGridLine(cellSource.rowEnd ?? bottomLeft.row, rowStart + 1, 2, rows + 1),
  )

  return {
    cols,
    rows,
    colStart,
    colEnd: Math.min(cols + 1, colEnd),
    rowStart,
    rowEnd: Math.min(rows + 1, rowEnd),
  }
}

export const formatGridContainerValue = (
  value: HeliosGridContainerValue | null | undefined,
) => {
  if (!value) return ''
  const prefix = value.mode && value.mode !== 'division' ? `${value.mode}:` : ''
  return `${prefix}${value.cols}x${value.rows}`
}

export const formatGridCellValue = (
  value: HeliosGridCellValue | null | undefined,
) => {
  if (!value) return ''
  return `${value.colStart}/${value.colEnd}/${value.rowStart}/${value.rowEnd}`
}

export const getGridContainerValue = (
  qualities: HeliosQualityMap | null | undefined,
  legacyValue?: unknown,
  breakpoint: HeliosBreakpointKey = 'base',
) => {
  const direct = getQualityValue(qualities, GRID_CONTAINER_QUALITY_KEY, breakpoint)
  if (direct) return normalizeGridContainerInput(direct)
  return normalizeGridContainerInput(legacyValue)
}

export const getGridCellValue = (
  qualities: HeliosQualityMap | null | undefined,
  legacyValue?: unknown,
  breakpoint: HeliosBreakpointKey = 'base',
) => {
  const direct = getQualityValue(qualities, GRID_CELL_QUALITY_KEY, breakpoint)
  if (direct) return normalizeGridCellInput(direct)
  return normalizeGridCellInput(legacyValue)
}

export const normalizeInnerBoxInput = (input: unknown): HeliosInnerBoxValue | null => {
  if (typeof input === 'string') {
    const trimmed = input.trim()
    if (!trimmed) return null
    return {
      mode: normalizeInnerBoxMode(trimmed),
      snapTo: 'division-grid',
    }
  }

  const source = asRecord(input)
  const hasSignal = [
    source.mode,
    source.snapTo,
    source.insetTop,
    source.insetRight,
    source.insetBottom,
    source.insetLeft,
    source.maxWidth,
    source.centerX,
    source.centerY,
  ].some((value) => value !== undefined && value !== null && value !== '')
  if (!hasSignal) return null

  const value: HeliosInnerBoxValue = {
    mode: normalizeInnerBoxMode(source.mode),
    snapTo: normalizeInnerBoxSnapTarget(source.snapTo),
  }

  const insetTop = toOptionalInnerBoxNumber(source.insetTop ?? source.top)
  const insetRight = toOptionalInnerBoxNumber(source.insetRight ?? source.right)
  const insetBottom = toOptionalInnerBoxNumber(source.insetBottom ?? source.bottom)
  const insetLeft = toOptionalInnerBoxNumber(source.insetLeft ?? source.left)
  if (insetTop !== undefined) value.insetTop = insetTop
  if (insetRight !== undefined) value.insetRight = insetRight
  if (insetBottom !== undefined) value.insetBottom = insetBottom
  if (insetLeft !== undefined) value.insetLeft = insetLeft

  if (source.maxWidth === null) {
    value.maxWidth = null
  } else if (source.maxWidth !== undefined && source.maxWidth !== '') {
    const numericMaxWidth = Number(source.maxWidth)
    value.maxWidth = Number.isFinite(numericMaxWidth)
      ? Math.max(0, Number(numericMaxWidth.toFixed(4)))
      : String(source.maxWidth).trim()
  }

  if (typeof source.centerX === 'boolean') value.centerX = source.centerX
  if (typeof source.centerY === 'boolean') value.centerY = source.centerY

  return value
}

export const formatInnerBoxValue = (
  value: HeliosInnerBoxValue | null | undefined,
) => {
  if (!value) return ''
  return `${value.mode}:${value.snapTo}`
}

export const getInnerBoxValue = (
  qualities: HeliosQualityMap | null | undefined,
  legacyValue?: unknown,
  breakpoint: HeliosBreakpointKey = 'base',
) => {
  const direct = getQualityValue(qualities, INNER_BOX_QUALITY_KEY, breakpoint)
  if (direct) return normalizeInnerBoxInput(direct)
  return normalizeInnerBoxInput(legacyValue)
}

export const upsertGridContainerQuality = (
  qualities: HeliosQualityMap | null | undefined,
  input: unknown,
  breakpoint: HeliosBreakpointKey = 'base',
) => {
  const next = cloneQualities(qualities)
  const value = normalizeGridContainerInput(input)
  const current = { ...(next[GRID_CONTAINER_QUALITY_KEY] ?? {}) }

  if (!value) {
    delete current[breakpoint]
    if (Object.keys(current).length === 0) {
      delete next[GRID_CONTAINER_QUALITY_KEY]
    } else {
      next[GRID_CONTAINER_QUALITY_KEY] = current
    }
    return Object.keys(next).length ? next : undefined
  }

  current[breakpoint] = value
  next[GRID_CONTAINER_QUALITY_KEY] = current
  return next
}

export const upsertGridCellQuality = (
  qualities: HeliosQualityMap | null | undefined,
  input: unknown,
  breakpoint: HeliosBreakpointKey = 'base',
) => {
  const next = cloneQualities(qualities)
  const value = normalizeGridCellInput(input)
  const current = { ...(next[GRID_CELL_QUALITY_KEY] ?? {}) }

  if (!value) {
    delete current[breakpoint]
    if (Object.keys(current).length === 0) {
      delete next[GRID_CELL_QUALITY_KEY]
    } else {
      next[GRID_CELL_QUALITY_KEY] = current
    }
    return Object.keys(next).length ? next : undefined
  }

  current[breakpoint] = value
  next[GRID_CELL_QUALITY_KEY] = current
  return next
}

export const upsertInnerBoxQuality = (
  qualities: HeliosQualityMap | null | undefined,
  input: unknown,
  breakpoint: HeliosBreakpointKey = 'base',
) => {
  const next = cloneQualities(qualities)
  const value = normalizeInnerBoxInput(input)
  const current = { ...(next[INNER_BOX_QUALITY_KEY] ?? {}) }

  if (!value) {
    delete current[breakpoint]
    if (Object.keys(current).length === 0) {
      delete next[INNER_BOX_QUALITY_KEY]
    } else {
      next[INNER_BOX_QUALITY_KEY] = current
    }
    return Object.keys(next).length ? next : undefined
  }

  current[breakpoint] = value
  next[INNER_BOX_QUALITY_KEY] = current
  return next
}

const compileGridContainerValue = (
  value: HeliosGridContainerValue,
  breakpoint: HeliosBreakpointKey,
) => {
  const mode = value.mode || 'division'
  if (mode === 'rhythm') {
    return [
      withBreakpoint('grid', breakpoint),
      withBreakpoint(`grid-cols-[repeat(${value.cols},var(--h-gu))]`, breakpoint),
      withBreakpoint(`grid-rows-[repeat(${value.rows},var(--h-gu))]`, breakpoint),
    ]
  }

  return [
    withBreakpoint('grid', breakpoint),
    withBreakpoint(`grid-cols-${value.cols}`, breakpoint),
    withBreakpoint(`grid-rows-${value.rows}`, breakpoint),
  ]
}

const compileGridCellValue = (
  value: HeliosGridCellValue,
  breakpoint: HeliosBreakpointKey,
) => {
  return [
    withBreakpoint(`col-start-${value.colStart}`, breakpoint),
    withBreakpoint(`col-end-${value.colEnd}`, breakpoint),
    withBreakpoint(`row-start-${value.rowStart}`, breakpoint),
    withBreakpoint(`row-end-${value.rowEnd}`, breakpoint),
  ]
}

export const gridContainerQualityDefinition: HeliosQualityDefinition<HeliosGridContainerValue> = {
  key: GRID_CONTAINER_QUALITY_KEY,
  normalize: normalizeGridContainerInput,
  format: formatGridContainerValue,
  preview: (value) => resolveGridContainerPreviewStyle(value),
  compile: compileGridContainerValue,
}

export const gridCellQualityDefinition: HeliosQualityDefinition<HeliosGridCellValue> = {
  key: GRID_CELL_QUALITY_KEY,
  normalize: normalizeGridCellInput,
  format: formatGridCellValue,
  preview: (value) => resolveGridCellPreviewRect(value),
  compile: compileGridCellValue,
}

export const resolveGridContainerPreviewStyle = (
  value: HeliosGridContainerValue | null | undefined,
) => {
  if (!value) return {}
  const mode = value.mode || 'division'
  return {
    gridTemplateColumns: mode === 'rhythm'
      ? `repeat(${value.cols}, ${HELIOS_GRID_UNIT_PREVIEW_CSS_VAR})`
      : `repeat(${value.cols}, minmax(0, 1fr))`,
    gridTemplateRows: mode === 'rhythm'
      ? `repeat(${value.rows}, ${HELIOS_GRID_UNIT_PREVIEW_CSS_VAR})`
      : `repeat(${value.rows}, minmax(0, 1fr))`,
  }
}

const innerBoxInsetCssValue = (
  value: number | undefined,
  snapTo: HeliosInnerBoxSnapTarget,
  options: { previewFallback?: boolean } = {},
) => {
  if (value === undefined || value <= 0) return null
  const gridUnit = options.previewFallback
    ? HELIOS_GRID_UNIT_PREVIEW_CSS_VAR
    : HELIOS_GRID_UNIT_CSS_VAR
  return snapTo === 'rhythm-grid'
    ? `calc(${gridUnit} * ${value})`
    : `${value}%`
}

const innerBoxMaxWidthCssValue = (value: string | number | null | undefined) => {
  if (value === undefined || value === null || value === '') return null
  return typeof value === 'number' ? `${value}px` : String(value)
}

const innerBoxSpacingClasses = (
  value: HeliosInnerBoxValue,
  breakpoint: HeliosBreakpointKey,
) => {
  const entries: Array<[string, number | undefined]> = [
    ['pt', value.insetTop],
    ['pr', value.insetRight],
    ['pb', value.insetBottom],
    ['pl', value.insetLeft],
  ]
  return entries
    .map(([prefix, amount]) => {
      const cssValue = innerBoxInsetCssValue(amount, value.snapTo)
      return cssValue ? withBreakpoint(`${prefix}-[${escapeUnoArbitraryValue(cssValue)}]`, breakpoint) : ''
    })
    .filter(Boolean)
}

export const resolveInnerBoxPreviewStyle = (
  value: HeliosInnerBoxValue | null | undefined,
) => {
  if (!value || value.mode === 'none') return {}
  const style: HeliosPreviewStyle = {}
  const insetTop = innerBoxInsetCssValue(value.insetTop, value.snapTo, { previewFallback: true })
  const insetRight = innerBoxInsetCssValue(value.insetRight, value.snapTo, { previewFallback: true })
  const insetBottom = innerBoxInsetCssValue(value.insetBottom, value.snapTo, { previewFallback: true })
  const insetLeft = innerBoxInsetCssValue(value.insetLeft, value.snapTo, { previewFallback: true })
  if (insetTop) style.paddingTop = insetTop
  if (insetRight) style.paddingRight = insetRight
  if (insetBottom) style.paddingBottom = insetBottom
  if (insetLeft) style.paddingLeft = insetLeft
  if (value.centerX || value.mode === 'container') {
    style.marginLeft = 'auto'
    style.marginRight = 'auto'
  }
  if (value.centerY) {
    style.marginTop = 'auto'
    style.marginBottom = 'auto'
  }
  const maxWidth = innerBoxMaxWidthCssValue(value.maxWidth)
  if (maxWidth) style.maxWidth = maxWidth
  return style
}

export const resolveInnerBoxStyle = (
  qualities: HeliosQualityMap | null | undefined,
  legacyValue?: unknown,
  breakpoint: HeliosBreakpointKey = 'base',
) => resolveInnerBoxPreviewStyle(getInnerBoxValue(qualities, legacyValue, breakpoint))

const compileInnerBoxValue = (
  value: HeliosInnerBoxValue,
  breakpoint: HeliosBreakpointKey,
) => {
  if (value.mode === 'none') return []

  const classes: string[] = []
  const spacing = innerBoxSpacingClasses(value, breakpoint)
  if (value.mode === 'container' || value.centerX) {
    classes.push(withBreakpoint('mx-auto', breakpoint))
  }
  if (value.centerY) {
    classes.push(withBreakpoint('my-auto', breakpoint))
  }
  const maxWidth = innerBoxMaxWidthCssValue(value.maxWidth)
  if (maxWidth) classes.push(withBreakpoint(`max-w-[${escapeUnoArbitraryValue(maxWidth)}]`, breakpoint))
  return [...classes, ...spacing]
}

export const innerBoxQualityDefinition: HeliosQualityDefinition<HeliosInnerBoxValue> = {
  key: INNER_BOX_QUALITY_KEY,
  normalize: normalizeInnerBoxInput,
  format: formatInnerBoxValue,
  preview: (value) => resolveInnerBoxPreviewStyle(value),
  compile: compileInnerBoxValue,
}

export const compileGridContainerClasses = (
  qualities: HeliosQualityMap | null | undefined,
  legacyValue?: unknown,
) => {
  const entry = qualities?.[GRID_CONTAINER_QUALITY_KEY]
  if (!entry || Object.keys(entry).length === 0) {
    const fallback = getGridContainerValue(undefined, legacyValue, 'base')
    return fallback ? compileGridContainerValue(fallback, 'base') : []
  }

  const classes: string[] = []
  for (const breakpoint of sortBreakpoints(Object.keys(entry))) {
    const value = getGridContainerValue(qualities, legacyValue, breakpoint)
    if (!value) continue
    classes.push(...compileGridContainerValue(value, breakpoint))
  }
  return classes
}

export const compileGridCellClasses = (
  qualities: HeliosQualityMap | null | undefined,
  legacyValue?: unknown,
) => {
  const entry = qualities?.[GRID_CELL_QUALITY_KEY]
  if (!entry || Object.keys(entry).length === 0) {
    const fallback = getGridCellValue(undefined, legacyValue, 'base')
    return fallback ? compileGridCellValue(fallback, 'base') : []
  }

  const classes: string[] = []
  for (const breakpoint of sortBreakpoints(Object.keys(entry))) {
    const value = getGridCellValue(qualities, legacyValue, breakpoint)
    if (!value) continue
    classes.push(...compileGridCellValue(value, breakpoint))
  }
  return classes
}

export const compileInnerBoxClasses = (
  qualities: HeliosQualityMap | null | undefined,
  legacyValue?: unknown,
) => {
  const entry = qualities?.[INNER_BOX_QUALITY_KEY]
  if (!entry || Object.keys(entry).length === 0) {
    const fallback = getInnerBoxValue(undefined, legacyValue, 'base')
    return fallback ? compileInnerBoxValue(fallback, 'base') : []
  }

  const classes: string[] = []
  for (const breakpoint of sortBreakpoints(Object.keys(entry))) {
    const value = getInnerBoxValue(qualities, legacyValue, breakpoint)
    if (!value) continue
    classes.push(...compileInnerBoxValue(value, breakpoint))
  }
  return classes
}

export const resolveGridCellPreviewRect = (
  value: HeliosGridCellValue | null | undefined,
) => {
  if (!value) return {}
  const width = Math.max(1, value.colEnd - value.colStart)
  const height = Math.max(1, value.rowEnd - value.rowStart)
  return {
    left: `${((value.colStart - 1) / value.cols) * 100}%`,
    top: `${((value.rowStart - 1) / value.rows) * 100}%`,
    width: `${(width / value.cols) * 100}%`,
    height: `${(height / value.rows) * 100}%`,
  }
}

export const resolveGridPreviewRect = resolveGridCellPreviewRect

export const compileBackgroundClasses = (
  qualities: HeliosQualityMap | null | undefined,
  legacyValue?: unknown,
) => {
  const entry = qualities?.[BACKGROUND_QUALITY_KEY]
  if (!entry || Object.keys(entry).length === 0) {
    const fallback = getBackgroundValue(undefined, legacyValue, 'base')
    return fallback ? [compileBackgroundClass(fallback, 'base')].filter(Boolean) : []
  }

  const classes: string[] = []
  for (const breakpoint of sortBreakpoints(Object.keys(entry))) {
    const value = getBackgroundValue(qualities, legacyValue, breakpoint)
    if (!value) continue
    const token = compileBackgroundClass(value, breakpoint)
    if (token) classes.push(token)
  }
  return classes
}

export const compileInnerBoxBackgroundClasses = (
  qualities: HeliosQualityMap | null | undefined,
  legacyValue?: unknown,
) => {
  const entry = qualities?.[INNER_BOX_BACKGROUND_QUALITY_KEY]
  if (!entry || Object.keys(entry).length === 0) {
    const fallback = getInnerBoxBackgroundValue(undefined, legacyValue, 'base')
    return fallback ? [compileBackgroundClass(fallback, 'base')].filter(Boolean) : []
  }

  const classes: string[] = []
  for (const breakpoint of sortBreakpoints(Object.keys(entry))) {
    const value = getInnerBoxBackgroundValue(qualities, legacyValue, breakpoint)
    if (!value) continue
    const token = compileBackgroundClass(value, breakpoint)
    if (token) classes.push(token)
  }
  return classes
}

export const compileHeliosManifestNodes = (
  nodes: HeliosNodeRecord[],
  parentId: string | null = null,
  fallbackGrid: { cols: number; rows: number } = { cols: 24, rows: 24 },
): HeliosCompiledNode[] => {
  return nodes
    .filter((node) => (node.parentId || null) === parentId)
    .sort((a, b) => ((a.order || 0) - (b.order || 0)) || a.id.localeCompare(b.id))
    .filter((node) => node.kind === 'frame' || node.kind === 'text' || node.kind === 'image')
    .map((node) => {
      if (node.kind === 'text') {
        const content = normalizeTextContentInput(node.content)
        return {
          id: node.id,
          subId: node.record?.display || node.record?.key || node.id,
          kind: 'text',
          label: node.label || undefined,
          dataHeliosNode: node.id,
          tag: content.tag,
          text: content.text,
          classes: [
            'h-text',
            ...compileGridCellClasses(node.qualities),
          ],
        }
      }

      if (node.kind === 'image') {
        const content = normalizeImageContentInput(node.content)
        return {
          id: node.id,
          subId: node.record?.display || node.record?.key || node.id,
          kind: 'image',
          label: node.label || undefined,
          dataHeliosNode: node.id,
          src: content.src,
          alt: content.alt || '',
          objectFit: content.objectFit || 'cover',
          objectPosition: content.objectPosition || '50% 50%',
          classes: [
            'h-image',
            ...compileGridCellClasses(node.qualities),
          ],
        }
      }

      return {
        id: node.id,
        subId: node.record?.display || node.record?.key || node.id,
        kind: 'frame',
        label: node.label || undefined,
        dataHeliosNode: node.id,
        outerClasses: [
          'h-frame',
          'h-frame-layer',
          ...compileGridCellClasses(node.qualities),
          ...compileBackgroundClasses(node.qualities),
        ],
        innerClasses: [
          'h-frame-inner',
          ...compileGridContainerClasses(node.qualities, fallbackGrid),
          ...compileInnerBoxClasses(node.qualities),
          ...compileInnerBoxBackgroundClasses(node.qualities),
        ],
        // InnerBox is class-first when values map cleanly to generated utilities.
        // Inline style remains an explicit fallback for arbitrary wrapper values until
        // the compiler can emit generated fallback CSS rules instead.
        innerStyle: resolveInnerBoxStyle(node.qualities),
        children: compileHeliosManifestNodes(nodes, node.id, fallbackGrid),
      }
    })
}

export const createHeliosPageManifest = ({
  pageId,
  nodes,
  cols = 24,
  rows = 24,
  canvasHeight = 720,
}: HeliosPageManifestInput): HeliosPageManifest => {
  const canvasCols = Math.max(1, Math.min(HELIOS_CANVAS_MAX_COLS, Math.round(Number(cols) || 24)))
  const canvasRows = Math.max(1, Math.min(HELIOS_CANVAS_MAX_ROWS, Math.round(Number(rows) || 24)))
  const height = Math.max(1, Math.round(Number(canvasHeight) || 720))

  return {
    version: 1,
    pageId,
    canvas: {
      classes: [
        'page',
        'canvas',
        'min-h-100vh',
        `h-[${height}px]`,
        'grid',
        `grid-cols-${canvasCols}`,
        `grid-rows-${canvasRows}`,
      ],
    },
    nodes: compileHeliosManifestNodes(nodes, null, { cols: canvasCols, rows: canvasRows }),
  }
}
