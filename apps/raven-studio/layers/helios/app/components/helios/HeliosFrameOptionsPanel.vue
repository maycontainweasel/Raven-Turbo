<script setup lang="ts">
import { ColorPicker, parseColor, type Color, type ColorPickerValueChangeDetails } from '@ark-ui/vue/color-picker'
import {
  HELIOS_TEXT_TAGS,
  normalizeTextContentInput,
  type HeliosGridContainerMode,
  type HeliosInnerBoxMode,
  type HeliosInnerBoxSnapTarget,
  type HeliosTextTag,
} from '@helios/protocol'
import { useHeliosRuntimeStore } from '../../stores/heliosRuntime'

const runtime = useHeliosRuntimeStore()
const panelEl = ref<HTMLElement | null>(null)
const labelInputEl = ref<HTMLInputElement | null>(null)
const position = ref({ x: 16, y: 128 })
const dragState = ref<{
  pointerId: number
  startX: number
  startY: number
  originX: number
  originY: number
} | null>(null)

const STORAGE_KEY = 'helios.runtime.optionsPosition'
const DEFAULT_BACKGROUND_COLOR = '#2858ff24'
const DEFAULT_INNER_BACKGROUND_COLOR = '#ffffff00'
const colorPickerPositioning = {
  placement: 'bottom-start',
  gutter: 8,
} as const

const label = ref('')
const colStart = ref(1)
const colEnd = ref(2)
const rowStart = ref(1)
const rowEnd = ref(2)
const containerMode = ref<HeliosGridContainerMode>('division')
const containerCols = ref(24)
const containerRows = ref(24)
const backgroundInput = ref('')
const backgroundColor = ref<Color>(parseColor(DEFAULT_BACKGROUND_COLOR))
const innerBackgroundInput = ref('')
const innerBackgroundColor = ref<Color>(parseColor(DEFAULT_INNER_BACKGROUND_COLOR))
const locked = ref(false)
const innerBoxMode = ref<HeliosInnerBoxMode>('none')
const innerBoxSnapTo = ref<HeliosInnerBoxSnapTarget>('division-grid')
const innerBoxInsetTop = ref(0)
const innerBoxInsetRight = ref(0)
const innerBoxInsetBottom = ref(0)
const innerBoxInsetLeft = ref(0)
const innerBoxMaxWidth = ref('')
const innerBoxCenterX = ref(false)
const innerBoxCenterY = ref(false)
const labelEditing = ref(false)
const textContent = ref('')
const textTag = ref<HeliosTextTag>('p')

const selectedNode = computed(() => runtime.selectedNode)
const frameTitle = computed(() => (
  selectedNode.value?.label || selectedNode.value?.record?.display || selectedNode.value?.id || 'Node'
))
const cell = computed(() => runtime.getNodeGridCell(selectedNode.value))
const container = computed(() => runtime.getNodeGridContainer(selectedNode.value))
const innerBox = computed(() => runtime.getNodeInnerBox(selectedNode.value))
const isInnerControlMode = computed(() => runtime.frameControlMode === 'inner')
const isFrameNode = computed(() => selectedNode.value?.kind === 'frame')
const isTextNode = computed(() => selectedNode.value?.kind === 'text')

const panelStyle = computed(() => ({
  left: `${position.value.x}px`,
  top: `${position.value.y}px`,
}))

const clampPosition = (next: { x: number; y: number }) => {
  if (typeof window === 'undefined') return next
  const bounds = panelEl.value?.getBoundingClientRect()
  const width = bounds?.width || 340
  const height = bounds?.height || 560
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
  if ((event.target as HTMLElement | null)?.closest('button, input, select, textarea, [data-no-drag]')) return
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

const toPositiveInteger = (value: unknown, fallback: number) => {
  const parsed = Number(value)
  if (!Number.isFinite(parsed)) return fallback
  return Math.max(1, Math.round(parsed))
}

const toNonNegativeNumber = (value: unknown, fallback = 0) => {
  const parsed = Number(value)
  if (!Number.isFinite(parsed)) return fallback
  return Math.max(0, Number(parsed.toFixed(4)))
}

const parseBackgroundColor = (value: string) => {
  try {
    const trimmed = value.trim()
    return parseColor(trimmed || DEFAULT_BACKGROUND_COLOR)
  } catch {
    return null
  }
}

const syncBackgroundColor = (value: string) => {
  const parsed = parseBackgroundColor(value)
  if (parsed) backgroundColor.value = parsed
}

const parseInnerBackgroundColor = (value: string) => {
  try {
    const trimmed = value.trim()
    return parseColor(trimmed || DEFAULT_INNER_BACKGROUND_COLOR)
  } catch {
    return null
  }
}

const syncInnerBackgroundColor = (value: string) => {
  const parsed = parseInnerBackgroundColor(value)
  if (parsed) innerBackgroundColor.value = parsed
}

const colorToBackgroundInput = (color: Color) => color.toString('hexa')

const syncFields = () => {
  const node = selectedNode.value
  const nextCell = cell.value
  const nextContainer = container.value
  const nextBackground = runtime.getNodeBackgroundInput(node)
  const nextInnerBackground = runtime.getNodeInnerBoxBackgroundInput(node)

  if (!labelEditing.value) label.value = node?.label || ''
  colStart.value = nextCell?.colStart ?? 1
  colEnd.value = nextCell?.colEnd ?? 2
  rowStart.value = nextCell?.rowStart ?? 1
  rowEnd.value = nextCell?.rowEnd ?? 2
  containerMode.value = nextContainer?.mode ?? 'division'
  containerCols.value = nextContainer?.cols ?? nextCell?.cols ?? 24
  containerRows.value = nextContainer?.rows ?? nextCell?.rows ?? 24
  backgroundInput.value = nextBackground
  syncBackgroundColor(nextBackground)
  innerBackgroundInput.value = nextInnerBackground
  syncInnerBackgroundColor(nextInnerBackground)
  locked.value = runtime.isNodeLocked(node)
  innerBoxMode.value = innerBox.value?.mode ?? 'none'
  innerBoxSnapTo.value = innerBox.value?.snapTo ?? 'division-grid'
  innerBoxInsetTop.value = innerBox.value?.insetTop ?? 0
  innerBoxInsetRight.value = innerBox.value?.insetRight ?? 0
  innerBoxInsetBottom.value = innerBox.value?.insetBottom ?? 0
  innerBoxInsetLeft.value = innerBox.value?.insetLeft ?? 0
  innerBoxMaxWidth.value = innerBox.value?.maxWidth === undefined || innerBox.value?.maxWidth === null
    ? ''
    : String(innerBox.value.maxWidth)
  innerBoxCenterX.value = innerBox.value?.centerX ?? false
  innerBoxCenterY.value = innerBox.value?.centerY ?? false
  const nextText = normalizeTextContentInput(node?.content)
  textContent.value = nextText.text
  textTag.value = nextText.tag
}

watch(
  () => [
    selectedNode.value?.id,
    selectedNode.value?.label,
    runtime.activeBreakpoint,
    JSON.stringify(selectedNode.value?.qualities ?? {}),
    JSON.stringify(selectedNode.value?.content ?? {}),
    selectedNode.value?.meta?.editor?.locked === true ? 'locked' : 'unlocked',
  ],
  syncFields,
  { immediate: true },
)

const applyLabel = async () => {
  if (!selectedNode.value) return
  await runtime.updateSelectedNodeLabel(label.value)
}

const startLabelEdit = async () => {
  if (!selectedNode.value) return
  label.value = selectedNode.value.label || ''
  labelEditing.value = true
  await nextTick()
  labelInputEl.value?.focus()
  labelInputEl.value?.select()
}

const commitLabelEdit = async () => {
  if (!labelEditing.value) return
  labelEditing.value = false
  await applyLabel()
}

const cancelLabelEdit = () => {
  labelEditing.value = false
  label.value = selectedNode.value?.label || ''
}

const applyCell = async () => {
  const node = selectedNode.value
  const current = cell.value
  if (!node || !current) return

  const cols = toPositiveInteger(current.cols, 24)
  const rows = toPositiveInteger(current.rows, 24)
  const nextColStart = Math.min(toPositiveInteger(colStart.value, current.colStart), cols)
  const nextRowStart = Math.min(toPositiveInteger(rowStart.value, current.rowStart), rows)

  await runtime.patchNodeGridCell(node.id, {
    cols,
    rows,
    colStart: nextColStart,
    colEnd: Math.max(nextColStart + 1, Math.min(cols + 1, toPositiveInteger(colEnd.value, current.colEnd))),
    rowStart: nextRowStart,
    rowEnd: Math.max(nextRowStart + 1, Math.min(rows + 1, toPositiveInteger(rowEnd.value, current.rowEnd))),
  })
}

const applyContainer = async () => {
  const node = selectedNode.value
  if (!node) return
  await runtime.patchNodeGridContainer(node.id, {
    mode: containerMode.value,
    cols: toPositiveInteger(containerCols.value, container.value?.cols ?? cell.value?.cols ?? 24),
    rows: toPositiveInteger(containerRows.value, container.value?.rows ?? cell.value?.rows ?? 24),
  })
}

const applyBackgroundValue = async (value: string) => {
  const node = selectedNode.value
  if (!node) return
  backgroundInput.value = value
  syncBackgroundColor(value)
  await runtime.patchNodeBackground(node.id, value)
}

const applyBackground = async () => {
  await applyBackgroundValue(backgroundInput.value)
}

const updateBackgroundColor = (color: Color) => {
  backgroundColor.value = color
  backgroundInput.value = colorToBackgroundInput(color)
}

const onBackgroundColorChange = (details: ColorPickerValueChangeDetails) => {
  updateBackgroundColor(details.value)
}

const onBackgroundColorChangeEnd = async (details: ColorPickerValueChangeDetails) => {
  await applyBackgroundValue(colorToBackgroundInput(details.value))
}

const applyInnerBackgroundValue = async (value: string) => {
  const node = selectedNode.value
  if (!node) return
  innerBackgroundInput.value = value
  syncInnerBackgroundColor(value)
  await runtime.patchNodeInnerBoxBackground(node.id, value)
}

const applyInnerBackground = async () => {
  await applyInnerBackgroundValue(innerBackgroundInput.value)
}

const updateInnerBackgroundColor = (color: Color) => {
  innerBackgroundColor.value = color
  innerBackgroundInput.value = colorToBackgroundInput(color)
}

const onInnerBackgroundColorChange = (details: ColorPickerValueChangeDetails) => {
  updateInnerBackgroundColor(details.value)
}

const onInnerBackgroundColorChangeEnd = async (details: ColorPickerValueChangeDetails) => {
  await applyInnerBackgroundValue(colorToBackgroundInput(details.value))
}

const applyLock = async () => {
  const node = selectedNode.value
  if (!node) return
  await runtime.toggleNodeLock(node.id, locked.value)
}

const setControlMode = async (mode: 'outer' | 'inner') => {
  await runtime.setFrameControlMode(mode)
}

const applyInnerBox = async () => {
  const node = selectedNode.value
  if (!node) return
  await runtime.patchNodeInnerBox(node.id, {
    mode: innerBoxMode.value,
    snapTo: innerBoxSnapTo.value,
    insetTop: toNonNegativeNumber(innerBoxInsetTop.value),
    insetRight: toNonNegativeNumber(innerBoxInsetRight.value),
    insetBottom: toNonNegativeNumber(innerBoxInsetBottom.value),
    insetLeft: toNonNegativeNumber(innerBoxInsetLeft.value),
    maxWidth: innerBoxMaxWidth.value.trim() || null,
    centerX: innerBoxCenterX.value,
    centerY: innerBoxCenterY.value,
  })
}

const applyTextContent = async () => {
  const node = selectedNode.value
  if (!node || node.kind !== 'text') return
  await runtime.patchTextContent(node.id, {
    text: textContent.value,
    tag: textTag.value,
  })
}

const applyTextTag = async () => {
  await applyTextContent()
}

onMounted(() => {
  if (typeof window === 'undefined') return
  const fallback = {
    x: Math.max(16, window.innerWidth - 356),
    y: Math.max(16, window.innerHeight - 600),
  }
  const saved = window.localStorage.getItem(STORAGE_KEY)
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
    v-if="runtime.frameOptionsOpen && selectedNode"
    ref="panelEl"
    class="helios-frame-options"
    :style="panelStyle"
  >
    <header
      @pointerdown="onPanelPointerDown"
      @pointermove="onPanelPointerMove"
      @pointerup="onPanelPointerUp"
      @pointercancel="onPanelPointerUp"
    >
      <input
        v-if="labelEditing"
        ref="labelInputEl"
        v-model="label"
        class="helios-frame-options__title-input"
        type="text"
        data-no-drag
        aria-label="Node label"
        @blur="commitLabelEdit"
        @keydown.enter.prevent="commitLabelEdit"
        @keydown.esc.prevent="cancelLabelEdit"
      >
      <strong
        v-else
        class="helios-frame-options__title"
        data-no-drag
        title="Double-click to rename"
        @dblclick.stop="startLabelEdit"
      >
        {{ frameTitle }}
      </strong>
      <div v-if="isFrameNode" class="helios-frame-options__mode" aria-label="Frame control mode">
        <button
          type="button"
          :class="{ 'is-active': !isInnerControlMode }"
          @click="setControlMode('outer')"
        >
          Frame
        </button>
        <button
          type="button"
          :class="{ 'is-active': isInnerControlMode }"
          @click="setControlMode('inner')"
        >
          Inner
        </button>
      </div>
      <button type="button" title="Close" @click="runtime.toggleFrameOptions()">
        <span class="i-lucide-x" aria-hidden="true" />
      </button>
    </header>

    <div class="helios-frame-options__body">
      <template v-if="isFrameNode && !isInnerControlMode">
        <section class="helios-frame-options__section">
          <div class="helios-frame-options__section-header">
            <span>Cell</span>
            <small>{{ runtime.activeBreakpoint }}</small>
          </div>
          <div class="helios-frame-options__grid helios-frame-options__grid--cell">
            <label>
              <span>Col start</span>
              <input v-model.number="colStart" type="number" min="1" @change="applyCell">
            </label>
            <label>
              <span>Col end</span>
              <input v-model.number="colEnd" type="number" min="2" @change="applyCell">
            </label>
            <label>
              <span>Row start</span>
              <input v-model.number="rowStart" type="number" min="1" @change="applyCell">
            </label>
            <label>
              <span>Row end</span>
              <input v-model.number="rowEnd" type="number" min="2" @change="applyCell">
            </label>
          </div>
        </section>

        <section class="helios-frame-options__section">
          <div class="helios-frame-options__section-header">
            <span>Frame Grid</span>
            <small>base</small>
          </div>
          <div class="helios-frame-options__grid helios-frame-options__grid--frame-grid">
            <label>
              <span>Mode</span>
              <select v-model="containerMode" @change="applyContainer">
                <option value="division">Division</option>
                <option value="rhythm">Rhythm</option>
              </select>
            </label>
            <label>
              <span>Cols</span>
              <input v-model.number="containerCols" type="number" min="1" @change="applyContainer">
            </label>
            <label>
              <span>Rows</span>
              <input v-model.number="containerRows" type="number" min="1" @change="applyContainer">
            </label>
          </div>
          <p v-if="containerMode === 'rhythm'" class="helios-frame-options__hint">
            Rhythm grid preview only; placement snapping still uses division math.
          </p>
          <p class="helios-frame-options__hint">
            Frame Grid belongs to this frame. Canvas Tapestry is editor-only and does not compile.
          </p>
        </section>

        <section class="helios-frame-options__section">
          <div class="helios-frame-options__section-header">
            <span>Background</span>
            <small>appearance.bg</small>
          </div>
          <div class="helios-frame-options__grid helios-frame-options__grid--background">
            <ColorPicker.Root
              class="helios-frame-options__color-picker"
              :model-value="backgroundColor"
              default-format="rgba"
              :positioning="colorPickerPositioning"
              @update:model-value="updateBackgroundColor"
              @value-change="onBackgroundColorChange"
              @value-change-end="onBackgroundColorChangeEnd"
            >
              <ColorPicker.Label class="helios-frame-options__color-label">
                Color
              </ColorPicker.Label>
              <ColorPicker.Control class="helios-frame-options__color-control">
                <ColorPicker.Trigger class="helios-frame-options__color-trigger">
                  <ColorPicker.ValueSwatch class="helios-frame-options__color-swatch" />
                  <ColorPicker.ValueText class="helios-frame-options__color-value" format="hexa" />
                  <span class="i-lucide-chevron-down" aria-hidden="true" />
                </ColorPicker.Trigger>
              </ColorPicker.Control>
              <Teleport to="body">
                <ColorPicker.Positioner class="helios-frame-options__color-positioner">
                  <ColorPicker.Content class="helios-frame-options__color-content">
                    <ColorPicker.Area class="helios-frame-options__color-area">
                      <ColorPicker.AreaBackground class="helios-frame-options__color-area-background" />
                      <ColorPicker.AreaThumb class="helios-frame-options__color-area-thumb" />
                    </ColorPicker.Area>
                    <ColorPicker.ChannelSlider channel="hue" class="helios-frame-options__color-slider">
                      <ColorPicker.ChannelSliderTrack class="helios-frame-options__color-slider-track helios-frame-options__color-slider-track--hue" />
                      <ColorPicker.ChannelSliderThumb class="helios-frame-options__color-slider-thumb" />
                    </ColorPicker.ChannelSlider>
                    <ColorPicker.ChannelSlider channel="alpha" class="helios-frame-options__color-slider">
                      <ColorPicker.TransparencyGrid class="helios-frame-options__color-transparency" />
                      <ColorPicker.ChannelSliderTrack class="helios-frame-options__color-slider-track" />
                      <ColorPicker.ChannelSliderThumb class="helios-frame-options__color-slider-thumb" />
                    </ColorPicker.ChannelSlider>
                  </ColorPicker.Content>
                </ColorPicker.Positioner>
              </Teleport>
              <ColorPicker.HiddenInput />
            </ColorPicker.Root>
            <label class="helios-frame-options__field">
              <span>Raw / token</span>
              <input
                v-model="backgroundInput"
                type="text"
                placeholder="bg-red-500, #ffe0e0, linear-gradient(...)"
                @change="applyBackground"
                @keyup.enter="applyBackground"
              >
            </label>
          </div>
          <p class="helios-frame-options__hint">
            Picker saves HEX/alpha colors. Raw input still accepts tokens, palettes, and gradients.
          </p>
        </section>

        <label class="helios-frame-options__lock">
          <input v-model="locked" type="checkbox" @change="applyLock">
          <span>Locked</span>
        </label>
      </template>

      <section v-else-if="isFrameNode" class="helios-frame-options__section">
        <div class="helios-frame-options__section-header">
          <span>InnerBox</span>
          <small>base</small>
        </div>
        <p class="helios-frame-options__hint">
          Inner mode controls the built-in wrapper and makes this frame the active draw context.
        </p>
        <div class="helios-frame-options__grid">
          <label>
            <span>Mode</span>
            <select v-model="innerBoxMode" @change="applyInnerBox">
              <option value="none">None</option>
              <option value="inset">Inset</option>
              <option value="container">Container</option>
            </select>
          </label>
          <label>
            <span>Snap</span>
            <select v-model="innerBoxSnapTo" @change="applyInnerBox">
              <option value="division-grid">Division</option>
              <option value="rhythm-grid">Rhythm</option>
            </select>
          </label>
        </div>
        <p v-if="innerBoxSnapTo === 'rhythm-grid'" class="helios-frame-options__hint">
          Rhythm insets use grid-unit preview values.
        </p>
        <div class="helios-frame-options__section-header helios-frame-options__section-header--sub">
          <span>Inner Background</span>
          <small>appearance.innerBox.bg</small>
        </div>
        <div class="helios-frame-options__grid helios-frame-options__grid--background">
          <ColorPicker.Root
            class="helios-frame-options__color-picker"
            :model-value="innerBackgroundColor"
            default-format="rgba"
            :positioning="colorPickerPositioning"
            @update:model-value="updateInnerBackgroundColor"
            @value-change="onInnerBackgroundColorChange"
            @value-change-end="onInnerBackgroundColorChangeEnd"
          >
            <ColorPicker.Label class="helios-frame-options__color-label">
              Color
            </ColorPicker.Label>
            <ColorPicker.Control class="helios-frame-options__color-control">
              <ColorPicker.Trigger class="helios-frame-options__color-trigger">
                <ColorPicker.ValueSwatch class="helios-frame-options__color-swatch" />
                <ColorPicker.ValueText class="helios-frame-options__color-value" format="hexa" />
                <span class="i-lucide-chevron-down" aria-hidden="true" />
              </ColorPicker.Trigger>
            </ColorPicker.Control>
            <Teleport to="body">
              <ColorPicker.Positioner class="helios-frame-options__color-positioner">
                <ColorPicker.Content class="helios-frame-options__color-content">
                  <ColorPicker.Area class="helios-frame-options__color-area">
                    <ColorPicker.AreaBackground class="helios-frame-options__color-area-background" />
                    <ColorPicker.AreaThumb class="helios-frame-options__color-area-thumb" />
                  </ColorPicker.Area>
                  <ColorPicker.ChannelSlider channel="hue" class="helios-frame-options__color-slider">
                    <ColorPicker.ChannelSliderTrack class="helios-frame-options__color-slider-track helios-frame-options__color-slider-track--hue" />
                    <ColorPicker.ChannelSliderThumb class="helios-frame-options__color-slider-thumb" />
                  </ColorPicker.ChannelSlider>
                  <ColorPicker.ChannelSlider channel="alpha" class="helios-frame-options__color-slider">
                    <ColorPicker.TransparencyGrid class="helios-frame-options__color-transparency" />
                    <ColorPicker.ChannelSliderTrack class="helios-frame-options__color-slider-track" />
                    <ColorPicker.ChannelSliderThumb class="helios-frame-options__color-slider-thumb" />
                  </ColorPicker.ChannelSlider>
                </ColorPicker.Content>
              </ColorPicker.Positioner>
            </Teleport>
            <ColorPicker.HiddenInput />
          </ColorPicker.Root>
          <label class="helios-frame-options__field">
            <span>Raw / token</span>
            <input
              v-model="innerBackgroundInput"
              type="text"
              placeholder="bg-surface, #ffffffcc, linear-gradient(...)"
              @change="applyInnerBackground"
              @keyup.enter="applyInnerBackground"
            >
          </label>
        </div>
        <p class="helios-frame-options__hint">
          Inner background applies to the built-in wrapper, not to a child frame.
        </p>
        <div class="helios-frame-options__grid helios-frame-options__grid--insets">
          <label>
            <span>Top</span>
            <input v-model.number="innerBoxInsetTop" type="number" min="0" @change="applyInnerBox">
          </label>
          <label>
            <span>Right</span>
            <input v-model.number="innerBoxInsetRight" type="number" min="0" @change="applyInnerBox">
          </label>
          <label>
            <span>Bottom</span>
            <input v-model.number="innerBoxInsetBottom" type="number" min="0" @change="applyInnerBox">
          </label>
          <label>
            <span>Left</span>
            <input v-model.number="innerBoxInsetLeft" type="number" min="0" @change="applyInnerBox">
          </label>
        </div>
        <label class="helios-frame-options__field">
          <span>Max width</span>
          <input
            v-model="innerBoxMaxWidth"
            type="text"
            placeholder="64rem"
            @change="applyInnerBox"
            @keyup.enter="applyInnerBox"
          >
        </label>
        <div class="helios-frame-options__checks">
          <label>
            <input v-model="innerBoxCenterX" type="checkbox" @change="applyInnerBox">
            <span>Center X</span>
          </label>
          <label>
            <input v-model="innerBoxCenterY" type="checkbox" @change="applyInnerBox">
            <span>Center Y</span>
          </label>
        </div>
      </section>

      <template v-else-if="isTextNode">
        <section class="helios-frame-options__section">
          <div class="helios-frame-options__section-header">
            <span>Text</span>
            <small>v0</small>
          </div>
          <p class="helios-frame-options__hint">
            Text Node v0 edits only content and tag. Typography qualities come next.
          </p>
          <div class="helios-frame-options__grid helios-frame-options__grid--text">
            <label>
              <span>Tag</span>
              <select v-model="textTag" @change="applyTextTag">
                <option
                  v-for="tag in HELIOS_TEXT_TAGS"
                  :key="tag"
                  :value="tag"
                >
                  {{ tag }}
                </option>
              </select>
            </label>
            <label>
              <span>Label</span>
              <input
                v-model="label"
                type="text"
                placeholder="Text label"
                @change="applyLabel"
                @keyup.enter="applyLabel"
              >
            </label>
          </div>
          <label class="helios-frame-options__field">
            <span>Content</span>
            <textarea
              v-model="textContent"
              rows="5"
              placeholder="Text"
              @change="applyTextContent"
              @keyup.meta.enter="applyTextContent"
              @keyup.ctrl.enter="applyTextContent"
            />
          </label>
        </section>

        <section class="helios-frame-options__section">
          <div class="helios-frame-options__section-header">
            <span>Cell</span>
            <small>{{ runtime.activeBreakpoint }}</small>
          </div>
          <div class="helios-frame-options__grid helios-frame-options__grid--cell">
            <label>
              <span>Col start</span>
              <input v-model.number="colStart" type="number" min="1" @change="applyCell">
            </label>
            <label>
              <span>Col end</span>
              <input v-model.number="colEnd" type="number" min="2" @change="applyCell">
            </label>
            <label>
              <span>Row start</span>
              <input v-model.number="rowStart" type="number" min="1" @change="applyCell">
            </label>
            <label>
              <span>Row end</span>
              <input v-model.number="rowEnd" type="number" min="2" @change="applyCell">
            </label>
          </div>
        </section>

        <label class="helios-frame-options__lock">
          <input v-model="locked" type="checkbox" @change="applyLock">
          <span>Locked</span>
        </label>
      </template>
    </div>
  </aside>
</template>

<style scoped>
.helios-frame-options {
  position: fixed;
  z-index: 76;
  width: min(340px, calc(100vw - 32px));
  max-height: min(560px, calc(100vh - 32px));
  overflow: hidden;
  border: 1px solid rgba(11, 18, 32, 0.14);
  border-radius: 8px;
  color: #0f172a;
  background: rgba(255, 255, 255, 0.94);
  box-shadow: 0 18px 44px rgba(11, 18, 32, 0.16);
  backdrop-filter: blur(16px);
}

.helios-frame-options header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 10px 10px 8px 12px;
  border-bottom: 1px solid rgba(11, 18, 32, 0.08);
  cursor: grab;
  touch-action: none;
  user-select: none;
}

.helios-frame-options header:active {
  cursor: grabbing;
}

.helios-frame-options strong {
  min-width: 0;
  flex: 1 1 auto;
  overflow: hidden;
  font-size: 13px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.helios-frame-options__title {
  cursor: text;
}

.helios-frame-options__title-input {
  min-width: 0;
  flex: 1 1 auto;
  height: 28px;
  border: 1px solid rgba(37, 87, 214, 0.35);
  border-radius: 6px;
  padding: 0 7px;
  color: #0f172a;
  background: #ffffff;
  font-size: 13px;
  font-weight: 800;
  outline: 0;
}

.helios-frame-options__title-input:focus {
  border-color: rgba(37, 87, 214, 0.8);
  box-shadow: 0 0 0 2px rgba(37, 87, 214, 0.16);
}

.helios-frame-options button {
  display: grid;
  flex: 0 0 auto;
  width: 28px;
  height: 28px;
  place-items: center;
  border: 0;
  border-radius: 6px;
  color: #334155;
  background: transparent;
  cursor: pointer;
}

.helios-frame-options button:hover {
  color: #ffffff;
  background: #2557d6;
}

.helios-frame-options button span[aria-hidden='true'] {
  pointer-events: none;
}

.helios-frame-options__mode {
  display: grid;
  flex: 0 0 auto;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 2px;
  padding: 2px;
  border: 1px solid rgba(11, 18, 32, 0.1);
  border-radius: 7px;
  background: rgba(241, 245, 249, 0.9);
}

.helios-frame-options__mode button {
  width: auto;
  min-width: 48px;
  height: 24px;
  border-radius: 5px;
  color: #64748b;
  font-size: 11px;
  font-weight: 800;
}

.helios-frame-options__mode button.is-active {
  color: #ffffff;
  background: #2557d6;
}

.helios-frame-options__mode button.is-active:last-child {
  color: #052e1b;
  background: #19d27c;
}

.helios-frame-options__body {
  display: grid;
  gap: 14px;
  overflow: auto;
  max-height: calc(min(560px, 100vh - 32px) - 48px);
  padding: 12px;
}

.helios-frame-options__section {
  display: grid;
  gap: 8px;
}

.helios-frame-options__context button {
  width: 100%;
  height: 32px;
  border: 1px solid rgba(37, 87, 214, 0.18);
  border-radius: 6px;
  color: #2557d6;
  background: rgba(37, 87, 214, 0.08);
  font-size: 12px;
  font-weight: 800;
  cursor: pointer;
}

.helios-frame-options__context button:hover {
  color: #ffffff;
  background: #2557d6;
}

.helios-frame-options__section-header {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  color: #334155;
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0;
  text-transform: uppercase;
}

.helios-frame-options__section-header small {
  color: #64748b;
  font-size: 11px;
}

.helios-frame-options__section-header--sub {
  padding-top: 4px;
  color: #475569;
}

.helios-frame-options__hint {
  margin: 0;
  padding: 7px 8px;
  border-radius: 6px;
  color: #475569;
  background: rgba(37, 87, 214, 0.08);
  font-size: 11px;
  font-weight: 700;
  line-height: 1.25;
}

.helios-frame-options__color-picker {
  display: grid;
  gap: 6px;
  min-width: 0;
}

.helios-frame-options__color-label {
  color: #64748b;
  font-size: 11px;
  font-weight: 700;
}

.helios-frame-options__color-control {
  min-width: 0;
}

.helios-frame-options button.helios-frame-options__color-trigger {
  display: flex;
  align-items: center;
  gap: 8px;
  width: 100%;
  height: 34px;
  border: 1px solid rgba(11, 18, 32, 0.16);
  border-radius: 6px;
  padding: 0 9px;
  color: #0f172a;
  background: #ffffff;
  cursor: pointer;
}

.helios-frame-options button.helios-frame-options__color-trigger:hover,
.helios-frame-options button.helios-frame-options__color-trigger:focus-visible {
  color: #0f172a;
  border-color: rgba(37, 87, 214, 0.62);
  background: #ffffff;
  outline: 0;
}

.helios-frame-options__color-swatch {
  width: 22px;
  height: 22px;
  flex: 0 0 auto;
  border-radius: 5px;
  box-shadow:
    inset 0 0 0 1px rgba(255, 255, 255, 0.62),
    0 0 0 1px rgba(11, 18, 32, 0.18);
}

.helios-frame-options__color-value {
  min-width: 0;
  flex: 1 1 auto;
  overflow: hidden;
  font-size: 12px;
  font-weight: 800;
  text-align: left;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.helios-frame-options__color-positioner {
  z-index: var(--helios-runtime-ark-popup-z-index, 1400);
}

.helios-frame-options__color-content {
  display: grid;
  gap: 10px;
  width: min(280px, calc(100vw - 24px));
  border: 1px solid rgba(11, 18, 32, 0.16);
  border-radius: 8px;
  padding: 10px;
  background: rgba(255, 255, 255, 0.98);
  box-shadow: 0 18px 44px rgba(11, 18, 32, 0.18);
  backdrop-filter: blur(16px);
}

.helios-frame-options__color-area {
  position: relative;
  width: 100%;
  height: 148px;
  overflow: hidden;
  border-radius: 6px;
}

.helios-frame-options__color-area-background {
  width: 100%;
  height: 100%;
}

.helios-frame-options__color-area-thumb {
  position: absolute;
  width: 14px;
  height: 14px;
  border: 2px solid #ffffff;
  border-radius: 999px;
  box-shadow: 0 0 0 1px rgba(2, 6, 23, 0.34);
  transform: translate(-50%, -50%);
}

.helios-frame-options__color-slider {
  position: relative;
  width: 100%;
  height: 14px;
  overflow: hidden;
  border-radius: 999px;
}

.helios-frame-options__color-transparency,
.helios-frame-options__color-slider-track {
  position: absolute;
  inset: 0;
}

.helios-frame-options__color-transparency {
  --size: 7px;
}

.helios-frame-options__color-slider-track {
  width: 100%;
  height: 100%;
}

.helios-frame-options__color-slider-track--hue {
  background: linear-gradient(to right, #ff0000, #ffe500, #17c964, #0ea5e9, #6366f1, #c026d3, #ff0000);
}

.helios-frame-options__color-slider-thumb {
  position: absolute;
  top: 50%;
  width: 14px;
  height: 14px;
  border: 2px solid #061b31;
  border-radius: 999px;
  background: #ffffff;
  box-shadow: 0 1px 4px rgba(11, 18, 32, 0.2);
  transform: translate(-50%, -50%);
}

.helios-frame-options__field,
.helios-frame-options__grid label {
  display: grid;
  gap: 5px;
  min-width: 0;
  color: #64748b;
  font-size: 11px;
  font-weight: 700;
}

.helios-frame-options__grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 8px;
}

.helios-frame-options__grid--cell {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.helios-frame-options__grid--frame-grid {
  grid-template-columns: minmax(0, 2fr) minmax(0, 1fr) minmax(0, 1fr);
}

.helios-frame-options__grid--background {
  grid-template-columns: repeat(2, minmax(0, 1fr));
}

.helios-frame-options__grid--insets {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.helios-frame-options__grid--text {
  grid-template-columns: minmax(0, 1fr) minmax(0, 2fr);
}

.helios-frame-options input[type='text'],
.helios-frame-options input[type='number'],
.helios-frame-options select,
.helios-frame-options textarea {
  width: 100%;
  min-width: 0;
  border: 1px solid rgba(11, 18, 32, 0.16);
  border-radius: 6px;
  color: #0f172a;
  background: #ffffff;
  font-size: 12px;
  font-weight: 700;
}

.helios-frame-options input[type='text'],
.helios-frame-options input[type='number'],
.helios-frame-options select {
  height: 32px;
  padding: 0 8px;
}

.helios-frame-options textarea {
  min-height: 92px;
  resize: vertical;
  padding: 8px;
  line-height: 1.35;
}

.helios-frame-options select {
  cursor: pointer;
}

.helios-frame-options__checks,
.helios-frame-options__lock {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #334155;
  font-size: 12px;
  font-weight: 800;
}

.helios-frame-options__checks {
  justify-content: space-between;
}

.helios-frame-options__checks label {
  display: flex;
  align-items: center;
  gap: 7px;
}

.helios-frame-options__checks input,
.helios-frame-options__lock input {
  width: 16px;
  height: 16px;
}
</style>
