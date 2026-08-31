<script setup lang="ts">
import {
  DialogCloseTrigger,
  DialogContent,
  DialogDescription,
  DialogPositioner,
  DialogRoot,
  DialogTitle,
} from '@ark-ui/vue/dialog'
import { Switch } from '@ark-ui/vue/switch'
import { useHeliosRuntimeStore } from '../../stores/heliosRuntime'

const props = withDefaults(defineProps<{
  documentId?: string
  zoneId?: string
}>(), {
  documentId: 'page:home',
  zoneId: 'home-main',
})

const runtime = useHeliosRuntimeStore()
const documentId = computed(() => props.documentId)
const zoneId = computed(() => props.zoneId)
const SETTINGS_EVENT = 'helios:open-runtime-settings'
const SETTINGS_WINDOW_STORAGE_KEY = 'helios.runtime.settingsWindowPosition'

const settingsSections = [
  { id: 'runtime', label: 'General', icon: 'i-lucide-sliders-horizontal' },
  { id: 'canvas', label: 'Canvas', icon: 'i-lucide-grid-3x3' },
  { id: 'shortcuts', label: 'Shortcuts', icon: 'i-lucide-keyboard' },
] as const

type SettingsSectionId = typeof settingsSections[number]['id']

const canvas = computed(() => runtime.canvasForZone(documentId.value, zoneId.value))
const growthUnit = ref<'25dvh' | '50dvh' | '100dvh'>('50dvh')
const settingsDialogOpen = ref(false)
const settingsSection = ref<SettingsSectionId>('runtime')
const canvasColsInput = ref(canvas.value.cols)
const canvasRowPxInput = ref(canvas.value.rowPx)
const settingsWindowPosition = ref<{ x: number; y: number } | null>(null)
const settingsWindowDrag = ref<{
  pointerId: number
  startX: number
  startY: number
  originX: number
  originY: number
} | null>(null)

const shortcutGroups = [
  {
    title: 'Runtime Tools',
    items: [
      { keys: 'Space', action: 'Toggle between Edit mode and Live view' },
      { keys: 'F', action: 'Enter Edit mode and select the Frame draw tool' },
      { keys: 'V', action: 'Enter Edit mode and select tool' },
      { keys: 'W', action: 'Toggle between Frame mode and Widget mode while in Edit mode' },
      { keys: 'Y', action: 'Open Settings while in Edit mode' },
      { keys: 'Esc', action: 'Cancel draft and clear selection while in Edit mode' },
    ],
  },
  {
    title: 'Selected Frame',
    items: [
      { keys: 'S', action: 'Open Frame Options for the selected frame while in Edit mode' },
      { keys: 'D', action: 'Toggle selected frame between Outer control and InnerBox control' },
      { keys: 'Option + drag handle', action: 'Temporarily adjust the selected frame InnerBox without toggling persistent InnerBox control mode' },
      { keys: 'Cmd + C', action: 'Copy selected frame qualities/meta into the Helios frame clipboard' },
      { keys: 'Cmd + V', action: 'Paste copied frame alongside the selected frame with a one-cell offset' },
      { keys: 'Ctrl + Cmd + V', action: 'Paste copied frame inside the selected frame' },
      { keys: 'L', action: 'Toggle selected frame lock' },
      { keys: 'Delete / Backspace', action: 'Delete selected Helios node after confirmation' },
    ],
  },
  {
    title: 'Text Node v0',
    items: [
      { keys: 'T', action: 'Enter Widget mode and create a basic text node in the active frame/InnerBox context' },
    ],
  },
  {
    title: 'Responsive Arena',
    items: [
      { keys: 'R', action: 'Next responsive arena, including Live view' },
      { keys: 'Shift + R', action: 'Previous responsive arena, including Live view' },
    ],
  },
  {
    title: 'Settings Dialog',
    items: [
      { keys: 'Arrow Up', action: 'Move to the previous settings section when Settings is open' },
      { keys: 'Arrow Down', action: 'Move to the next settings section when Settings is open' },
    ],
  },
]

const viewportStyle = computed(() => {
  const width = runtime.activeViewport?.width ?? null
  return {
    width: width ? `${width}px` : '100%',
    maxWidth: '100%',
  }
})

const canvasStyle = computed(() => {
  const height = runtime.canvasPixelHeight(documentId.value, zoneId.value)
  if (canvas.value.heightMode === 'content') {
    return {
      height,
      minHeight: '0',
    }
  }
  return {
    minHeight: `max(100dvh, ${height})`,
  }
})

const canvasRowsLabel = computed(() => `${Math.round(canvas.value.rows * (canvas.value.rowPx || 32))}px`)
const canvasTapestrySummary = computed(() => (
  `${canvas.value.cols} fractional columns, ${canvas.value.rowPx}px fixed rows, ${canvas.value.rows} rows`
))
const outputPreviewHref = computed(() => {
  const params = new URLSearchParams({
    documentId: documentId.value,
    zoneId: zoneId.value,
    cols: String(canvas.value.cols),
    rows: String(canvas.value.rows),
    rowPx: String(canvas.value.rowPx),
    canvasHeight: String(canvas.value.rows * canvas.value.rowPx),
  })
  return `/helios-output?${params.toString()}`
})

const activeSettingsSection = computed(() => (
  settingsSections.find((section) => section.id === settingsSection.value) ?? settingsSections[0]
))

const settingsWindowStyle = computed(() => {
  const position = settingsWindowPosition.value
  return position
    ? {
        left: `${position.x}px`,
        top: `${position.y}px`,
      }
    : {}
})

const viewportLabel = computed(() => {
  const viewport = runtime.activeViewport
  return viewport?.width
    ? `${viewport.label} / ${viewport.width}px`
    : 'Base / full width'
})

const shrinkCanvas = () => runtime.adjustCanvasByViewportUnit(documentId.value, zoneId.value, growthUnit.value, -1)
const growCanvas = () => runtime.adjustCanvasByViewportUnit(documentId.value, zoneId.value, growthUnit.value, 1)
const normalizeCanvas = () => runtime.normalizeCanvasHeightForZone(documentId.value, zoneId.value)
const openOutputPreview = () => {
  if (typeof window === 'undefined') return
  window.open(outputPreviewHref.value, '_blank', 'noopener,noreferrer')
}
const setDeselectOnCanvasClick = (details: { checked: boolean }) => {
  runtime.setDeselectOnCanvasClick(Boolean(details.checked))
}

const setFrameLabelVisibility = (event: Event) => {
  const value = (event.target as HTMLSelectElement).value
  runtime.setFrameLabelVisibility(value === 'selected' ? 'selected' : 'always')
}

const setArenaLabelPlacement = (event: Event) => {
  const value = (event.target as HTMLSelectElement).value
  runtime.setArenaLabelPlacement(value === 'top-center' ? 'top-center' : 'bottom-center')
}

const estimatedSettingsWindowSize = () => {
  if (typeof window === 'undefined') return { width: 720, height: 460 }
  const width = window.innerWidth <= 840
    ? Math.min(640, Math.max(320, window.innerWidth - 24))
    : Math.min(960, window.innerWidth * 0.6, window.innerWidth - 32)
  return {
    width,
    height: Math.min(520, Math.max(320, window.innerHeight - 24)),
  }
}

const clampSettingsWindowPosition = (position: { x: number; y: number }) => {
  if (typeof window === 'undefined') return position
  const size = estimatedSettingsWindowSize()
  return {
    x: Math.max(12, Math.min(position.x, Math.max(12, window.innerWidth - size.width - 12))),
    y: Math.max(12, Math.min(position.y, Math.max(12, window.innerHeight - 72))),
  }
}

const defaultSettingsWindowPosition = () => {
  if (typeof window === 'undefined') return { x: 160, y: 64 }
  const size = estimatedSettingsWindowSize()
  return {
    x: Math.max(12, Math.round((window.innerWidth - size.width) / 2)),
    y: Math.max(12, Math.round(window.innerHeight * 0.08)),
  }
}

const readSettingsWindowPosition = () => {
  if (typeof window === 'undefined') return null
  try {
    const parsed = JSON.parse(window.localStorage.getItem(SETTINGS_WINDOW_STORAGE_KEY) || 'null')
    if (typeof parsed?.x !== 'number' || typeof parsed?.y !== 'number') return null
    return clampSettingsWindowPosition({ x: parsed.x, y: parsed.y })
  } catch {
    return null
  }
}

const writeSettingsWindowPosition = () => {
  if (typeof window === 'undefined' || !settingsWindowPosition.value) return
  window.localStorage.setItem(SETTINGS_WINDOW_STORAGE_KEY, JSON.stringify(settingsWindowPosition.value))
}

const ensureSettingsWindowPosition = () => {
  settingsWindowPosition.value = settingsWindowPosition.value
    ? clampSettingsWindowPosition(settingsWindowPosition.value)
    : readSettingsWindowPosition() ?? defaultSettingsWindowPosition()
}

const openSettingsDialog = (section: SettingsSectionId = 'runtime') => {
  settingsSection.value = section
  ensureSettingsWindowPosition()
  settingsDialogOpen.value = true
}

const syncCanvasInputs = () => {
  canvasColsInput.value = canvas.value.cols
  canvasRowPxInput.value = canvas.value.rowPx
}

watch(
  () => [canvas.value.cols, canvas.value.rowPx],
  syncCanvasInputs,
  { immediate: true },
)

watch(
  () => runtime.active,
  (isActive) => {
    if (!isActive) settingsDialogOpen.value = false
  },
)

const positiveInteger = (value: unknown, fallback: number, min: number, max: number) => {
  const next = Math.round(Number(value))
  if (!Number.isFinite(next)) return fallback
  return Math.max(min, Math.min(max, next))
}

const applyCanvasTapestrySettings = () => {
  runtime.setCanvasForZone(documentId.value, zoneId.value, {
    cols: positiveInteger(canvasColsInput.value, canvas.value.cols, 1, 96),
    rowPx: positiveInteger(canvasRowPxInput.value, canvas.value.rowPx, 8, 96),
  })
  syncCanvasInputs()
}

const setCanvasMidline = (details: { checked: boolean }) => {
  runtime.setCanvasForZone(documentId.value, zoneId.value, {
    midline: Boolean(details.checked),
  })
}

const setCanvasShowGrid = (details: { checked: boolean }) => {
  runtime.setCanvasForZone(documentId.value, zoneId.value, {
    showGrid: Boolean(details.checked),
  })
}

const setCanvasSnap = (details: { checked: boolean }) => {
  runtime.setCanvasForZone(documentId.value, zoneId.value, {
    snap: Boolean(details.checked),
  })
}

const selectSettingsSection = (section: SettingsSectionId) => {
  settingsSection.value = section
}

const cycleSettingsSection = (direction: 1 | -1) => {
  const current = settingsSections.findIndex((section) => section.id === settingsSection.value)
  const next = (current + direction + settingsSections.length) % settingsSections.length
  settingsSection.value = settingsSections[next]?.id ?? 'runtime'
}

const isFormTarget = (target: EventTarget | null) => {
  if (!(target instanceof HTMLElement)) return false
  return Boolean(
    target.closest('button, input, textarea, select, [contenteditable="true"]')
    || target.isContentEditable,
  )
}

const onSettingsWindowPointerDown = (event: PointerEvent) => {
  if (event.button !== 0 || isFormTarget(event.target)) return
  ensureSettingsWindowPosition()
  const position = settingsWindowPosition.value ?? defaultSettingsWindowPosition()
  settingsWindowDrag.value = {
    pointerId: event.pointerId,
    startX: event.clientX,
    startY: event.clientY,
    originX: position.x,
    originY: position.y,
  }
  ;(event.currentTarget as HTMLElement).setPointerCapture(event.pointerId)
  event.preventDefault()
}

const onSettingsWindowPointerMove = (event: PointerEvent) => {
  const drag = settingsWindowDrag.value
  if (!drag || drag.pointerId !== event.pointerId) return
  settingsWindowPosition.value = clampSettingsWindowPosition({
    x: drag.originX + event.clientX - drag.startX,
    y: drag.originY + event.clientY - drag.startY,
  })
}

const onSettingsWindowPointerUp = (event: PointerEvent) => {
  const drag = settingsWindowDrag.value
  if (!drag || drag.pointerId !== event.pointerId) return
  settingsWindowDrag.value = null
  ;(event.currentTarget as HTMLElement).releasePointerCapture(event.pointerId)
  writeSettingsWindowPosition()
}

const onSettingsDialogKeydown = (event: KeyboardEvent) => {
  event.stopPropagation()
  if (isFormTarget(event.target)) return
  if (event.key === 'ArrowDown') {
    event.preventDefault()
    cycleSettingsSection(1)
  } else if (event.key === 'ArrowUp') {
    event.preventDefault()
    cycleSettingsSection(-1)
  }
}

const onOpenSettingsEvent = (event: Event) => {
  const detail = (event as CustomEvent<{ section?: SettingsSectionId }>).detail
  openSettingsDialog(detail?.section || 'runtime')
}

onMounted(() => {
  window.addEventListener(SETTINGS_EVENT, onOpenSettingsEvent)
  window.addEventListener('resize', ensureSettingsWindowPosition)
})

onBeforeUnmount(() => {
  window.removeEventListener(SETTINGS_EVENT, onOpenSettingsEvent)
  window.removeEventListener('resize', ensureSettingsWindowPosition)
})
</script>

<template>
  <main class="helios-runtime-canvas">
    <ClientOnly>
      <HeliosRuntimeToggle v-if="runtime.active" />

      <div class="helios-runtime-canvas__stage">
        <div
          class="helios-runtime-canvas__viewport"
          :class="{ 'is-constrained': Boolean(runtime.activeViewport?.width) }"
          :style="viewportStyle"
        >
          <div
            v-if="runtime.active"
            class="helios-runtime-canvas__arena-label"
            :class="`is-${runtime.settings.arenaLabelPlacement}`"
          >
            {{ viewportLabel }}
          </div>
          <div v-if="runtime.active" class="helios-runtime-canvas__canvas-controls">
            <button type="button" :title="`Remove ${growthUnit} working space`" @click="shrinkCanvas">
              -{{ growthUnit }}
            </button>
            <select v-model="growthUnit" aria-label="Canvas growth unit" title="Canvas growth unit">
              <option value="25dvh">25dvh</option>
              <option value="50dvh">50dvh</option>
              <option value="100dvh">100dvh</option>
            </select>
            <span>{{ canvasRowsLabel }}</span>
            <button type="button" :title="`Add ${growthUnit} working space`" @click="growCanvas">
              +{{ growthUnit }}
            </button>
            <button type="button" title="Normalize canvas height to content" @click="normalizeCanvas">
              Fit
            </button>
            <button type="button" title="Open chrome-free output preview" @click="openOutputPreview">
              Output
            </button>
            <button
              type="button"
              class="helios-runtime-canvas__icon-button"
              title="Runtime settings"
              aria-label="Runtime settings"
              @click="openSettingsDialog('runtime')"
            >
              <span class="i-lucide-settings-2" aria-hidden="true" />
            </button>
          </div>
          <HeliosZone
            :id="zoneId"
            :document-id="documentId"
            :cols="canvas.cols"
            :rows="canvas.rows"
            :row-px="canvas.rowPx"
            :show-grid="runtime.active && canvas.showGrid"
            :midline="runtime.active && canvas.midline"
            :style="canvasStyle"
          />
        </div>
      </div>

      <HeliosFrameNavigator v-if="runtime.active" :document-id="documentId" :zone-id="zoneId" />
      <HeliosFrameOptionsPanel v-if="runtime.active" />

      <Teleport to="body">
        <DialogRoot
          :open="settingsDialogOpen"
          :modal="false"
          lazy-mount
          unmount-on-exit
          @update:open="(open) => { settingsDialogOpen = open }"
        >
          <DialogPositioner class="helios-settings-dialog__positioner">
            <DialogContent
              class="helios-settings-dialog__panel"
              data-helios-settings-dialog
              :style="settingsWindowStyle"
              @keydown="onSettingsDialogKeydown"
            >
              <header
                class="helios-settings-dialog__header"
                :class="{ 'is-dragging': Boolean(settingsWindowDrag) }"
                @pointerdown="onSettingsWindowPointerDown"
                @pointermove="onSettingsWindowPointerMove"
                @pointerup="onSettingsWindowPointerUp"
                @pointercancel="onSettingsWindowPointerUp"
              >
                <div class="helios-settings-dialog__title">
                  <DialogTitle as-child>
                    <h2>Settings</h2>
                  </DialogTitle>
                  <span aria-hidden="true" />
                  <strong>{{ activeSettingsSection.label }}</strong>
                  <DialogDescription class="helios-settings-dialog__description sr-only">
                    Configure Helios runtime, canvas, and shortcut reference settings.
                  </DialogDescription>
                </div>
                <DialogCloseTrigger class="helios-settings-dialog__close" aria-label="Close settings">
                  <span class="i-lucide-x" aria-hidden="true" />
                </DialogCloseTrigger>
              </header>

              <div class="helios-settings-dialog__layout">
                <nav class="helios-settings-dialog__nav" aria-label="Runtime settings sections">
                  <button
                    v-for="section in settingsSections"
                    :key="section.id"
                    type="button"
                    :class="{ 'is-active': settingsSection === section.id }"
                    @click="selectSettingsSection(section.id)"
                  >
                    <span :class="section.icon" aria-hidden="true" />
                    {{ section.label }}
                  </button>
                </nav>

                <section v-if="settingsSection === 'runtime'" class="helios-settings-dialog__section">
                  <div class="helios-settings-dialog__field-grid">
                    <label class="helios-settings-dialog__field">
                      <span>Frame labels</span>
                      <select
                        :value="runtime.settings.frameLabelVisibility"
                        @change="setFrameLabelVisibility"
                      >
                        <option value="always">Always visible</option>
                        <option value="selected">Selected frame only</option>
                      </select>
                    </label>

                    <label class="helios-settings-dialog__field">
                      <span>Arena label</span>
                      <select
                        :value="runtime.settings.arenaLabelPlacement"
                        @change="setArenaLabelPlacement"
                      >
                        <option value="bottom-center">Bottom center</option>
                        <option value="top-center">Top center</option>
                      </select>
                    </label>
                  </div>

                  <Switch.Root
                    :checked="runtime.settings.deselectOnCanvasClick"
                    class="helios-runtime-canvas__switch-row"
                    @checked-change="setDeselectOnCanvasClick"
                  >
                    <span class="helios-runtime-canvas__switch-copy">
                      <Switch.Label class="helios-runtime-canvas__switch-label">
                        Deselect on background click
                      </Switch.Label>
                      <span class="helios-runtime-canvas__switch-description">
                        Clicking empty canvas space clears the selected frame.
                      </span>
                    </span>
                    <Switch.Control class="helios-runtime-canvas__switch-control">
                      <Switch.Thumb class="helios-runtime-canvas__switch-thumb" />
                    </Switch.Control>
                    <Switch.HiddenInput />
                  </Switch.Root>
                </section>

                <section v-else-if="settingsSection === 'canvas'" class="helios-settings-dialog__section">
                  <p class="helios-settings-dialog__note">
                    The canvas grid is a runtime drawing guide: fractional columns across the visible canvas and fixed-height rows for working space. It is not a frame's deployable Frame Grid.
                  </p>

                  <div class="helios-settings-dialog__field-grid">
                    <label class="helios-settings-dialog__field">
                      <span>Columns</span>
                      <input
                        v-model.number="canvasColsInput"
                        type="number"
                        min="1"
                        max="96"
                        inputmode="numeric"
                        @blur="applyCanvasTapestrySettings"
                        @change="applyCanvasTapestrySettings"
                      >
                    </label>

                    <label class="helios-settings-dialog__field">
                      <span>Row height</span>
                      <input
                        v-model.number="canvasRowPxInput"
                        type="number"
                        min="8"
                        max="96"
                        inputmode="numeric"
                        @blur="applyCanvasTapestrySettings"
                        @change="applyCanvasTapestrySettings"
                      >
                    </label>
                  </div>

                  <div class="helios-settings-dialog__readout">
                    <span>{{ canvasTapestrySummary }}</span>
                    <small>{{ canvasRowsLabel }} workspace height</small>
                  </div>

                  <Switch.Root
                    :checked="canvas.midline"
                    class="helios-runtime-canvas__switch-row"
                    @checked-change="setCanvasMidline"
                  >
                    <span class="helios-runtime-canvas__switch-copy">
                      <Switch.Label class="helios-runtime-canvas__switch-label">
                        Show vertical center line
                      </Switch.Label>
                      <span class="helios-runtime-canvas__switch-description">
                        Displays the editor-only midline on the Canvas Tapestry.
                      </span>
                    </span>
                    <Switch.Control class="helios-runtime-canvas__switch-control">
                      <Switch.Thumb class="helios-runtime-canvas__switch-thumb" />
                    </Switch.Control>
                    <Switch.HiddenInput />
                  </Switch.Root>

                  <Switch.Root
                    :checked="canvas.showGrid"
                    class="helios-runtime-canvas__switch-row"
                    @checked-change="setCanvasShowGrid"
                  >
                    <span class="helios-runtime-canvas__switch-copy">
                      <Switch.Label class="helios-runtime-canvas__switch-label">
                        Show Canvas Tapestry grid
                      </Switch.Label>
                      <span class="helios-runtime-canvas__switch-description">
                        Displays the editor-only drawing guide. It does not create a frame quality.
                      </span>
                    </span>
                    <Switch.Control class="helios-runtime-canvas__switch-control">
                      <Switch.Thumb class="helios-runtime-canvas__switch-thumb" />
                    </Switch.Control>
                    <Switch.HiddenInput />
                  </Switch.Root>

                  <Switch.Root
                    :checked="canvas.snap"
                    class="helios-runtime-canvas__switch-row"
                    @checked-change="setCanvasSnap"
                  >
                    <span class="helios-runtime-canvas__switch-copy">
                      <Switch.Label class="helios-runtime-canvas__switch-label">
                        Snap to Canvas Tapestry (planned)
                      </Switch.Label>
                      <span class="helios-runtime-canvas__switch-description">
                        Stores the root-canvas snap preference. Freeform placement is not enabled yet, so frame placement still snaps and writes grid-cell qualities.
                      </span>
                    </span>
                    <Switch.Control class="helios-runtime-canvas__switch-control">
                      <Switch.Thumb class="helios-runtime-canvas__switch-thumb" />
                    </Switch.Control>
                    <Switch.HiddenInput />
                  </Switch.Root>
                </section>

                <section v-else class="helios-settings-dialog__section">
                  <div class="helios-settings-dialog__shortcut-groups">
                    <article
                      v-for="group in shortcutGroups"
                      :key="group.title"
                      class="helios-settings-dialog__shortcut-group"
                    >
                      <h3>{{ group.title }}</h3>
                      <dl>
                        <div v-for="item in group.items" :key="item.keys">
                          <dt>{{ item.keys }}</dt>
                          <dd>{{ item.action }}</dd>
                        </div>
                      </dl>
                    </article>
                  </div>
                </section>
              </div>
            </DialogContent>
          </DialogPositioner>
        </DialogRoot>
      </Teleport>
    </ClientOnly>
  </main>
</template>

<style scoped>
.helios-runtime-canvas {
  min-height: 100vh;
  width: 100%;
  max-width: 100%;
  overflow-x: clip;
  background: #e5e7eb;
  color: #0f172a;
  font-family: ui-sans-serif, system-ui, sans-serif;
}

:global([data-scope='color-picker'][data-part='positioner']),
:global([data-scope='select'][data-part='positioner']),
:global([data-scope='combobox'][data-part='positioner']),
:global([data-scope='popover'][data-part='positioner']),
:global([data-scope='menu'][data-part='positioner']),
:global([data-scope='date-picker'][data-part='positioner']),
:global([data-scope='color-picker'][data-part='content']),
:global([data-scope='select'][data-part='content']),
:global([data-scope='combobox'][data-part='content']),
:global([data-scope='popover'][data-part='content']),
:global([data-scope='menu'][data-part='content']),
:global([data-scope='date-picker'][data-part='content']) {
  z-index: var(--helios-runtime-ark-popup-z-index, 1400);
}

.helios-runtime-canvas__stage {
  display: flex;
  justify-content: center;
  min-height: 100vh;
  width: 100%;
  max-width: 100%;
  min-width: 0;
  overflow-x: clip;
  overflow-y: auto;
}

.helios-runtime-canvas__viewport {
  position: relative;
  flex: 0 0 auto;
  box-sizing: border-box;
  min-height: 100vh;
  min-width: 0;
  max-width: 100%;
  background: #f8fafc;
  transition: width 160ms ease;
}

.helios-runtime-canvas__viewport.is-constrained {
  box-shadow: 0 0 0 1px rgba(15, 23, 42, 0.12), 0 24px 70px rgba(15, 23, 42, 0.16);
}

.helios-runtime-canvas__arena-label {
  position: fixed;
  z-index: 60;
  left: 50%;
  transform: translateX(-50%);
  padding: 5px 8px;
  border: 1px solid rgba(15, 23, 42, 0.12);
  border-radius: 6px;
  color: #334155;
  background: rgba(255, 255, 255, 0.9);
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0;
  pointer-events: none;
  text-transform: uppercase;
}

.helios-runtime-canvas__arena-label.is-top-center {
  top: 14px;
}

.helios-runtime-canvas__arena-label.is-bottom-center {
  bottom: 14px;
}

.helios-runtime-canvas__canvas-controls {
  position: fixed;
  z-index: 60;
  right: 16px;
  top: 14px;
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 4px;
  border: 1px solid rgba(15, 23, 42, 0.12);
  border-radius: 6px;
  color: #334155;
  background: rgba(255, 255, 255, 0.9);
  font-size: 11px;
  font-weight: 800;
}

.helios-runtime-canvas__canvas-controls button {
  height: 24px;
  min-width: 38px;
  border: 0;
  border-radius: 4px;
  color: #2557d6;
  background: rgba(37, 87, 214, 0.1);
  font-size: 11px;
  font-weight: 900;
  cursor: pointer;
}

.helios-runtime-canvas__icon-button {
  min-width: 24px;
}

.helios-runtime-canvas__icon-button span {
  width: 15px;
  height: 15px;
}

.helios-runtime-canvas__switch-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
  cursor: pointer;
}

.helios-runtime-canvas__switch-copy {
  display: grid;
  gap: 3px;
  min-width: 0;
}

.helios-runtime-canvas__switch-label {
  color: #172033;
  font-size: 12px;
  font-weight: 800;
  line-height: 1.2;
}

.helios-runtime-canvas__switch-description {
  color: #64748b;
  font-size: 11px;
  font-weight: 600;
  line-height: 1.25;
}

.helios-runtime-canvas__switch-control {
  position: relative;
  flex: 0 0 auto;
  width: 38px;
  height: 22px;
  padding: 2px;
  border-radius: 999px;
  background: rgba(100, 116, 139, 0.32);
  transition: background 130ms ease;
}

.helios-runtime-canvas__switch-control[data-state='checked'] {
  background: #2557d6;
}

.helios-runtime-canvas__switch-thumb {
  display: block;
  width: 18px;
  height: 18px;
  border-radius: 999px;
  background: #ffffff;
  box-shadow: 0 3px 8px rgba(15, 23, 42, 0.22);
  transition: transform 130ms ease;
}

.helios-runtime-canvas__switch-thumb[data-state='checked'] {
  transform: translateX(16px);
}

.helios-runtime-canvas__canvas-controls select {
  height: 24px;
  max-width: 76px;
  border: 0;
  border-radius: 4px;
  color: #334155;
  background: rgba(15, 23, 42, 0.06);
  font-size: 11px;
  font-weight: 900;
  cursor: pointer;
}

.helios-runtime-canvas__canvas-controls button:hover {
  color: #ffffff;
  background: #2557d6;
}

.helios-settings-dialog__positioner {
  position: fixed;
  z-index: 121;
  inset: 0;
  overflow: visible;
  pointer-events: none;
}

.helios-settings-dialog__panel {
  position: fixed;
  display: grid;
  width: min(960px, 60vw);
  max-width: calc(100vw - 32px);
  max-height: calc(100vh - 48px);
  overflow: hidden;
  border: 1px solid rgba(15, 23, 42, 0.16);
  border-radius: 8px;
  color: #0f172a;
  background: rgba(255, 255, 255, 0.98);
  box-shadow: 0 28px 80px rgba(15, 23, 42, 0.24);
  pointer-events: auto;
}

.helios-settings-dialog__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  padding: 12px 14px;
  border-bottom: 1px solid rgba(15, 23, 42, 0.08);
  cursor: grab;
  user-select: none;
  touch-action: none;
}

.helios-settings-dialog__header.is-dragging {
  cursor: grabbing;
}

.helios-settings-dialog__title {
  display: flex;
  align-items: center;
  min-width: 0;
  gap: 10px;
}

.helios-settings-dialog__header h2 {
  margin: 0;
  color: #0f172a;
  font-size: 15px;
  font-weight: 900;
  letter-spacing: 0;
}

.helios-settings-dialog__title > span {
  width: 2px;
  height: 20px;
  border-radius: 999px;
  background: #d63424;
}

.helios-settings-dialog__title strong {
  overflow: hidden;
  color: #334155;
  font-size: 12px;
  font-weight: 900;
  letter-spacing: 0;
  text-overflow: ellipsis;
  text-transform: uppercase;
  white-space: nowrap;
}

.helios-settings-dialog__description {
  margin: 4px 0 0;
  color: #64748b;
  font-size: 12px;
  font-weight: 650;
  line-height: 1.35;
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
}

.helios-settings-dialog__close {
  display: grid;
  flex: 0 0 auto;
  width: 28px;
  height: 28px;
  place-items: center;
  border: 0;
  border-radius: 6px;
  color: #334155;
  background: rgba(15, 23, 42, 0.06);
  cursor: pointer;
}

.helios-settings-dialog__close:hover {
  color: #ffffff;
  background: #2557d6;
}

.helios-settings-dialog__close span {
  width: 15px;
  height: 15px;
}

.helios-settings-dialog__layout {
  display: grid;
  grid-template-columns: 184px minmax(0, 1fr);
  min-height: 320px;
  max-height: calc(100vh - 86px);
  overflow: hidden;
}

.helios-settings-dialog__nav {
  display: grid;
  align-content: start;
  gap: 6px;
  padding: 14px;
  border-right: 1px solid rgba(15, 23, 42, 0.08);
  background: rgba(248, 250, 252, 0.9);
}

.helios-settings-dialog__nav button {
  display: flex;
  align-items: center;
  gap: 9px;
  width: 100%;
  height: 36px;
  border: 0;
  border-radius: 6px;
  padding: 0 10px;
  color: #334155;
  background: transparent;
  font-size: 12px;
  font-weight: 850;
  text-align: left;
  cursor: pointer;
}

.helios-settings-dialog__nav button:hover,
.helios-settings-dialog__nav button.is-active {
  color: #ffffff;
  background: #2557d6;
}

.helios-settings-dialog__nav span {
  width: 16px;
  height: 16px;
  flex: 0 0 auto;
}

.helios-settings-dialog__section {
  display: grid;
  align-content: start;
  gap: 14px;
  overflow: auto;
  padding: 18px;
}

.helios-settings-dialog__section-heading {
  display: grid;
  gap: 4px;
  padding-bottom: 10px;
  border-bottom: 1px solid rgba(15, 23, 42, 0.08);
}

.helios-settings-dialog__section-heading span {
  color: #0f172a;
  font-size: 13px;
  font-weight: 900;
  letter-spacing: 0;
  text-transform: uppercase;
}

.helios-settings-dialog__section-heading small {
  color: #64748b;
  font-size: 12px;
  font-weight: 650;
}

.helios-settings-dialog__note {
  margin: 0;
  max-width: 640px;
  color: #475569;
  font-size: 12px;
  font-weight: 650;
  line-height: 1.45;
}

.helios-settings-dialog__field-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
}

.helios-settings-dialog__field {
  display: grid;
  gap: 6px;
}

.helios-settings-dialog__field span {
  color: #334155;
  font-size: 11px;
  font-weight: 850;
  letter-spacing: 0;
  text-transform: uppercase;
}

.helios-settings-dialog__field input,
.helios-settings-dialog__field select {
  width: 100%;
  box-sizing: border-box;
  height: 34px;
  border: 1px solid rgba(15, 23, 42, 0.14);
  border-radius: 6px;
  padding: 0 10px;
  color: #0f172a;
  background: #ffffff;
  font-size: 12px;
  font-weight: 750;
  outline: none;
}

.helios-settings-dialog__field select {
  cursor: pointer;
}

.helios-settings-dialog__field input:focus,
.helios-settings-dialog__field select:focus {
  border-color: rgba(37, 87, 214, 0.7);
  box-shadow: 0 0 0 3px rgba(37, 87, 214, 0.12);
}

.helios-settings-dialog__readout {
  display: grid;
  gap: 2px;
  padding: 10px 12px;
  border: 1px solid rgba(37, 87, 214, 0.14);
  border-radius: 6px;
  color: #1e3a8a;
  background: rgba(37, 87, 214, 0.06);
}

.helios-settings-dialog__readout span {
  font-size: 12px;
  font-weight: 850;
}

.helios-settings-dialog__readout small {
  color: #64748b;
  font-size: 11px;
  font-weight: 650;
}

.helios-settings-dialog__shortcut-groups {
  display: grid;
  gap: 12px;
}

.helios-settings-dialog__shortcut-group {
  display: grid;
  gap: 10px;
  padding: 12px;
  border: 1px solid rgba(15, 23, 42, 0.1);
  border-radius: 8px;
  background: rgba(248, 250, 252, 0.82);
}

.helios-settings-dialog__shortcut-group h3 {
  margin: 0;
  color: #334155;
  font-size: 12px;
  font-weight: 900;
  letter-spacing: 0;
  text-transform: uppercase;
}

.helios-settings-dialog__shortcut-group dl {
  display: grid;
  gap: 7px;
  margin: 0;
}

.helios-settings-dialog__shortcut-group dl > div {
  display: grid;
  grid-template-columns: minmax(92px, max-content) minmax(0, 1fr);
  align-items: center;
  gap: 12px;
}

.helios-settings-dialog__shortcut-group dt {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 24px;
  border: 1px solid rgba(37, 87, 214, 0.18);
  border-radius: 5px;
  padding: 0 8px;
  color: #1e3a8a;
  background: rgba(37, 87, 214, 0.08);
  font-size: 11px;
  font-weight: 900;
  white-space: nowrap;
}

.helios-settings-dialog__shortcut-group dd {
  margin: 0;
  color: #475569;
  font-size: 12px;
  font-weight: 650;
  line-height: 1.35;
}

@media (max-width: 840px) {
  .helios-settings-dialog__panel {
    width: min(100%, 640px);
    max-height: calc(100vh - 24px);
  }

  .helios-settings-dialog__layout {
    grid-template-columns: 1fr;
    max-height: calc(100vh - 70px);
  }

  .helios-settings-dialog__nav {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    overflow-x: auto;
    border-right: 0;
    border-bottom: 1px solid rgba(15, 23, 42, 0.08);
  }

  .helios-settings-dialog__nav button {
    justify-content: center;
  }
}

@media (max-width: 560px) {
  .helios-settings-dialog__panel {
    max-width: calc(100vw - 24px);
  }

  .helios-settings-dialog__header {
    padding: 10px;
  }

  .helios-settings-dialog__layout {
    max-height: calc(100vh - 64px);
  }

  .helios-settings-dialog__section {
    padding: 14px;
  }

  .helios-settings-dialog__field-grid {
    grid-template-columns: 1fr;
  }

  .helios-settings-dialog__shortcut-group dl > div {
    grid-template-columns: 1fr;
    gap: 5px;
  }
}

.helios-runtime-canvas :deep(.helios-zone) {
  width: 100%;
  border: 0;
  border-radius: 0;
}

.helios-runtime-canvas :deep(.helios-zone__content) {
  min-height: inherit;
  padding: 0;
}
</style>
