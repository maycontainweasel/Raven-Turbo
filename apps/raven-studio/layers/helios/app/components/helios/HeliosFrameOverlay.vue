<script setup lang="ts">
import {
  getBackgroundValue,
  resolveInnerBoxBackgroundPreviewStyle,
  getGridCellValue,
  getGridContainerValue,
  getInnerBoxValue,
  resolveInnerBoxPreviewStyle,
  type HeliosInnerBoxValue,
  type HeliosNodeRecord,
} from '@helios/protocol'
import {
  DEFAULT_FRAME_BACKGROUND_COLOR,
  DEFAULT_INNER_FRAME_BOX,
  useHeliosRuntimeStore,
} from '../../stores/heliosRuntime'

defineOptions({
  name: 'HeliosFrameOverlay',
})

const props = defineProps<{
  node: HeliosNodeRecord
  selected?: boolean
  contextActive?: boolean
  activeContextNodeId?: string | null
}>()

const runtime = useHeliosRuntimeStore()
const resizeHandles = ['n', 'e', 's', 'w', 'nw', 'ne', 'sw', 'se'] as const
const innerBoxInsetSides = ['top', 'right', 'bottom', 'left'] as const
type InnerBoxInsetSide = typeof innerBoxInsetSides[number]

const cell = computed(() => (
  getGridCellValue(props.node.qualities, undefined, runtime.activeBreakpoint)
))

const background = computed(() => (
  getBackgroundValue(props.node.qualities, undefined, runtime.activeBreakpoint)
))

const isPreviousDefaultBackground = (value: string) => {
  const normalized = value.trim().toLowerCase()
  return normalized === '#c9f7ff'
    || /^rgba\(\s*40\s*,\s*88\s*,\s*255\s*,\s*0\.14\s*\)$/i.test(normalized)
}

const backgroundStyle = computed(() => {
  const value = background.value
  if (!value) return runtime.active ? DEFAULT_FRAME_BACKGROUND_COLOR : 'transparent'
  if (value.kind === 'semantic-token') return `var(--hc-bg-${value.token})`
  if (value.kind === 'palette') return `var(--hc-${value.palette}-${value.step})`
  if (isPreviousDefaultBackground(value.value)) return DEFAULT_FRAME_BACKGROUND_COLOR
  return value.value
})

const locked = computed(() => runtime.isNodeLocked(props.node))

const childNodes = computed(() => runtime.childNodesFor(props.node.id))

const innerBox = computed(() => (
  getInnerBoxValue(props.node.qualities, undefined, runtime.activeBreakpoint)
))

const innerControlActive = computed(() => runtime.isInnerFrameControlActive(props.node))

const effectiveInnerBox = computed<HeliosInnerBoxValue | null>(() => {
  const value = innerBox.value
  if (innerControlActive.value && (!value || value.mode === 'none')) {
    return { ...DEFAULT_INNER_FRAME_BOX }
  }
  return value
})

const innerBoxPreviewStyle = computed(() => (
  resolveInnerBoxPreviewStyle(effectiveInnerBox.value)
))

const showInnerBoxPreview = computed(() => (
  effectiveInnerBox.value
  && effectiveInnerBox.value.mode !== 'none'
))

const showFrameLabel = computed(() => (
  runtime.active
  && (runtime.settings.frameLabelVisibility === 'always' || Boolean(props.selected))
))

const innerBoxShellStyle = computed(() => {
  const style: Record<string, string> = {}
  for (const key of ['paddingTop', 'paddingRight', 'paddingBottom', 'paddingLeft']) {
    const value = innerBoxPreviewStyle.value[key]
    if (value) style[key] = value
  }
  if (effectiveInnerBox.value?.centerY) {
    style.justifyContent = 'center'
  }
  return style
})

const innerBoxInsetCss = computed<Record<InnerBoxInsetSide, string>>(() => ({
  top: innerBoxShellStyle.value.paddingTop || '0px',
  right: innerBoxShellStyle.value.paddingRight || '0px',
  bottom: innerBoxShellStyle.value.paddingBottom || '0px',
  left: innerBoxShellStyle.value.paddingLeft || '0px',
}))

const innerBoxInsets = computed<Record<InnerBoxInsetSide, number>>(() => {
  const value = effectiveInnerBox.value
  return {
    top: Math.max(0, Number(value?.insetTop || 0)),
    right: Math.max(0, Number(value?.insetRight || 0)),
    bottom: Math.max(0, Number(value?.insetBottom || 0)),
    left: Math.max(0, Number(value?.insetLeft || 0)),
  }
})

const showInnerBoxSpaceOverlay = computed(() => (
  runtime.active
  && innerControlActive.value
  && Boolean(showInnerBoxPreview.value)
))

const innerBoxSpaceGridStyle = computed<Record<string, string>>(() => {
  const snapTo = effectiveInnerBox.value?.snapTo || 'rhythm-grid'
  return {
    '--helios-innerbox-space-grid-x': snapTo === 'rhythm-grid'
      ? 'var(--h-gu, 1.4rem)'
      : `${100 / childGrid.value.cols}%`,
    '--helios-innerbox-space-grid-y': snapTo === 'rhythm-grid'
      ? 'var(--h-gu, 1.4rem)'
      : `${100 / childGrid.value.rows}%`,
  }
})

const innerBoxShellVisualStyle = computed(() => ({
  ...innerBoxShellStyle.value,
  ...(showInnerBoxSpaceOverlay.value ? innerBoxSpaceGridStyle.value : {}),
}))

const innerBoxMeasureStyle = (side: InnerBoxInsetSide) => {
  const value = innerBoxInsetCss.value[side]
  if (side === 'left') return { left: '0', top: '50%', width: value }
  if (side === 'right') return { right: '0', top: '50%', width: value }
  if (side === 'top') return { top: '0', left: '50%', height: value }
  return { bottom: '0', left: '50%', height: value }
}

const innerBoxSpaceStyle = (side: InnerBoxInsetSide) => {
  const inset = innerBoxInsetCss.value
  if (side === 'left') {
    return {
      top: inset.top,
      bottom: inset.bottom,
      left: '0',
      width: inset.left,
    }
  }
  if (side === 'right') {
    return {
      top: inset.top,
      right: '0',
      bottom: inset.bottom,
      width: inset.right,
    }
  }
  if (side === 'top') {
    return {
      top: '0',
      right: '0',
      left: '0',
      height: inset.top,
    }
  }
  return {
    right: '0',
    bottom: '0',
    left: '0',
    height: inset.bottom,
  }
}

const formatInnerBoxInset = (side: InnerBoxInsetSide) => {
  const value = innerBoxInsets.value[side]
  return Number.isInteger(value)
    ? String(value)
    : value.toFixed(2).replace(/\.?0+$/, '')
}

const innerBoxBoundaryStyle = computed(() => {
  const style: Record<string, string> = {
    ...resolveInnerBoxBackgroundPreviewStyle(props.node.qualities, undefined, runtime.activeBreakpoint),
  }
  const maxWidth = innerBoxPreviewStyle.value.maxWidth
  if (maxWidth) {
    style.maxWidth = maxWidth
    style.width = '100%'
  }
  if (innerBoxPreviewStyle.value.marginLeft) style.marginLeft = innerBoxPreviewStyle.value.marginLeft
  if (innerBoxPreviewStyle.value.marginRight) style.marginRight = innerBoxPreviewStyle.value.marginRight
  if (effectiveInnerBox.value?.centerY) {
    style.flex = '0 1 70%'
  }
  return style
})

const childGrid = computed(() => {
  const value = getGridContainerValue(props.node.qualities, undefined, 'base')
  return {
    mode: value?.mode || 'division',
    cols: Math.max(1, Math.round(Number(value?.cols || 24))),
    rows: Math.max(1, Math.round(Number(value?.rows || 24))),
  }
})

const childGridStyle = computed(() => ({
  gridTemplateColumns: childGrid.value.mode === 'rhythm'
    ? `repeat(${childGrid.value.cols}, var(--h-gu, 24px))`
    : `repeat(${childGrid.value.cols}, minmax(0, 1fr))`,
  gridTemplateRows: childGrid.value.mode === 'rhythm'
    ? `repeat(${childGrid.value.rows}, var(--h-gu, 24px))`
    : `repeat(${childGrid.value.rows}, minmax(0, 1fr))`,
}))

const childGridLineStyle = computed(() => ({
  backgroundImage: [
    'linear-gradient(to right, rgba(37, 87, 214, 0.22) 1px, transparent 1px)',
    'linear-gradient(to bottom, rgba(37, 87, 214, 0.22) 1px, transparent 1px)',
  ].join(', '),
  backgroundSize: childGrid.value.mode === 'rhythm'
    ? 'var(--h-gu, 24px) var(--h-gu, 24px)'
    : `${100 / childGrid.value.cols}% ${100 / childGrid.value.rows}%`,
}))

const showChildPlacementGrid = computed(() => (
  runtime.active && runtime.tool === 'draw' && props.contextActive
))

const fullChildrenSurfaceStyle = computed(() => (
  showChildPlacementGrid.value ? childGridLineStyle.value : {}
))

const innerBoxChildrenSurfaceStyle = computed(() => ({
  ...innerBoxBoundaryStyle.value,
  ...childGridStyle.value,
  ...(showChildPlacementGrid.value ? childGridLineStyle.value : {}),
}))

const frameStyle = computed(() => {
  const value = cell.value
  if (!value) return {}

  return {
    gridColumn: `${value.colStart} / ${value.colEnd}`,
    gridRow: `${value.rowStart} / ${value.rowEnd}`,
    background: backgroundStyle.value,
  }
})
</script>

<template>
  <div
    class="helios-frame-overlay"
    :class="{
      'is-authoring': runtime.active,
      'is-selected': selected,
      'is-inner-control': innerControlActive,
      'is-locked': locked,
      'is-context': contextActive,
    }"
    :style="frameStyle"
    :data-helios-node="node.id"
    :data-helios-node-kind="node.kind"
    :data-helios-locked="locked ? 'true' : undefined"
  >
    <div
      v-if="showInnerBoxPreview"
      class="helios-frame-overlay__innerbox"
      :class="{
        'is-rhythm': effectiveInnerBox?.snapTo === 'rhythm-grid',
        'is-center-x': effectiveInnerBox?.centerX,
        'is-center-y': effectiveInnerBox?.centerY,
      }"
      :style="innerBoxShellVisualStyle"
      :data-helios-innerbox-for="node.id"
    >
      <div
        class="helios-frame-overlay__innerbox-boundary helios-frame-overlay__innerbox-children"
        :class="{ 'is-context-grid': showChildPlacementGrid }"
        :style="innerBoxChildrenSurfaceStyle"
        :data-helios-children-for="node.id"
      >
        <template v-for="child in childNodes" :key="child.id">
          <HeliosFrameOverlay
            v-if="child.kind === 'frame'"
            :node="child"
            :selected="runtime.selectedNodeId === child.id"
            :context-active="activeContextNodeId === child.id"
            :active-context-node-id="activeContextNodeId"
          />
          <HeliosTextOverlay
            v-else-if="child.kind === 'text'"
            :node="child"
            :selected="runtime.selectedNodeId === child.id"
          />
        </template>
        <template v-if="runtime.active && selected && !locked && innerControlActive">
          <button
            v-for="handle in resizeHandles"
            :key="handle"
            type="button"
            class="helios-frame-overlay__resize helios-frame-overlay__resize--inner"
            :class="[`is-${handle}`, handle.length === 1 ? 'is-edge' : 'is-corner']"
            :data-helios-resize="handle"
            :title="`Adjust inner frame from ${handle.toUpperCase()} ${handle.length === 1 ? 'edge' : 'corner'}`"
            :aria-label="`Adjust inner frame from ${handle.toUpperCase()} ${handle.length === 1 ? 'edge' : 'corner'}`"
          />
        </template>
      </div>
      <template v-if="showInnerBoxSpaceOverlay">
        <span
          v-for="side in innerBoxInsetSides"
          v-show="innerBoxInsets[side] > 0"
          :key="`space-${side}`"
          class="helios-frame-overlay__space"
          :class="`is-${side}`"
          :style="innerBoxSpaceStyle(side)"
          aria-hidden="true"
        />
        <span
          v-for="side in innerBoxInsetSides"
          v-show="innerBoxInsets[side] > 0"
          :key="side"
          class="helios-frame-overlay__measure"
          :class="`is-${side}`"
          :style="innerBoxMeasureStyle(side)"
          aria-hidden="true"
        >
          <span class="helios-frame-overlay__measure-line" />
          <span class="helios-frame-overlay__measure-value">
            {{ formatInnerBoxInset(side) }}
          </span>
        </span>
      </template>
    </div>
    <div
      v-else
      class="helios-frame-overlay__children"
      :class="{ 'is-context-grid': showChildPlacementGrid }"
      :style="[childGridStyle, fullChildrenSurfaceStyle]"
      :data-helios-children-for="node.id"
    >
      <template v-for="child in childNodes" :key="child.id">
        <HeliosFrameOverlay
          v-if="child.kind === 'frame'"
          :node="child"
          :selected="runtime.selectedNodeId === child.id"
          :context-active="activeContextNodeId === child.id"
          :active-context-node-id="activeContextNodeId"
        />
        <HeliosTextOverlay
          v-else-if="child.kind === 'text'"
          :node="child"
          :selected="runtime.selectedNodeId === child.id"
        />
      </template>
    </div>
    <span v-if="showFrameLabel" class="helios-frame-overlay__label">
      {{ node.label || node.record?.display || node.id }}
    </span>
    <template v-if="runtime.active && selected && !locked && !innerControlActive">
      <button
        v-for="handle in resizeHandles"
        :key="handle"
        type="button"
        class="helios-frame-overlay__resize"
        :class="[`is-${handle}`, handle.length === 1 ? 'is-edge' : 'is-corner']"
        :data-helios-resize="handle"
        :title="`Resize frame from ${handle.toUpperCase()} ${handle.length === 1 ? 'edge' : 'corner'}`"
        :aria-label="`Resize frame from ${handle.toUpperCase()} ${handle.length === 1 ? 'edge' : 'corner'}`"
      />
    </template>
  </div>
</template>

<style scoped>
.helios-frame-overlay {
  --helios-frame-accent: #08bdf8;
  --helios-frame-accent-soft: rgba(8, 189, 248, 0.28);
  --helios-frame-accent-glow: rgba(8, 189, 248, 0.18);
  --helios-box-accent: #19d27c;
  --helios-box-accent-soft: rgba(25, 210, 124, 0.34);
  --helios-box-accent-glow: rgba(25, 210, 124, 0.16);
  position: relative;
  box-sizing: border-box;
  min-width: 0;
  min-height: 0;
  border: 0;
  background: #fff;
  box-shadow: none;
  cursor: default;
  overflow: hidden;
  pointer-events: auto;
  user-select: none;
}

.helios-frame-overlay.is-authoring {
  box-shadow:
    inset 0 0 0 1px rgba(8, 189, 248, 0.42),
    inset 0 0 0 2px rgba(255, 255, 255, 0.45);
  cursor: grab;
}

.helios-frame-overlay.is-authoring:active {
  cursor: grabbing;
}

.helios-frame-overlay.is-authoring.is-locked {
  cursor: default;
  outline: 1px dashed rgba(37, 87, 214, 0.72);
  outline-offset: -1px;
}

.helios-frame-overlay.is-authoring.is-locked:active {
  cursor: default;
}

.helios-frame-overlay.is-authoring.is-selected {
  box-shadow:
    inset 0 0 0 1px var(--helios-frame-accent),
    inset 0 0 0 2px rgba(255, 255, 255, 0.7),
    0 0 0 2px var(--helios-frame-accent-soft),
    0 0 22px var(--helios-frame-accent-glow);
}

.helios-frame-overlay.is-authoring.is-selected.is-inner-control {
  box-shadow:
    inset 0 0 0 1px var(--helios-box-accent),
    inset 0 0 0 2px rgba(255, 255, 255, 0.72),
    0 0 0 2px var(--helios-box-accent-soft),
    0 0 24px var(--helios-box-accent-glow);
}

.helios-frame-overlay.is-authoring.is-context {
  box-shadow:
    inset 0 0 0 1px var(--helios-frame-accent),
    inset 0 0 0 2px rgba(255, 255, 255, 0.7),
    0 0 0 2px var(--helios-frame-accent-soft);
}

.helios-frame-overlay__children {
  position: absolute;
  inset: 0;
  display: grid;
  min-width: 0;
  min-height: 0;
  pointer-events: auto;
}

.helios-frame-overlay__children.is-context-grid,
.helios-frame-overlay__innerbox-children.is-context-grid {
  box-shadow: inset 0 0 0 2px rgba(37, 87, 214, 0.2);
}

.helios-frame-overlay__label {
  position: absolute;
  top: 6px;
  left: 6px;
  z-index: 4;
  max-width: calc(100% - 12px);
  overflow: hidden;
  padding: 3px 5px;
  border-radius: 4px;
  color: #0b1220;
  background: rgba(255, 255, 255, 0.82);
  font-size: 11px;
  line-height: 1.1;
  pointer-events: none;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.helios-frame-overlay__resize {
  position: absolute;
  z-index: 5;
  box-sizing: border-box;
  width: 20px;
  height: 20px;
  border: 0;
  padding: 0;
  background: rgba(255, 255, 255, 0.82);
  opacity: 0.32;
  transition:
    background 120ms ease,
    opacity 120ms ease,
    transform 120ms ease;
  transform: scale(0.82);
}

.helios-frame-overlay__resize.is-edge {
  background: transparent;
  opacity: 0;
}

.helios-frame-overlay__resize::before {
  position: absolute;
  width: 9px;
  height: 9px;
  border-color: var(--helios-frame-accent);
  border-style: solid;
  content: '';
}

.helios-frame-overlay__resize.is-edge::before {
  border: 0;
  border-radius: 999px;
  background: var(--helios-frame-accent);
  box-shadow:
    0 0 0 1px rgba(255, 255, 255, 0.84),
    0 0 12px var(--helios-frame-accent-glow);
}

.helios-frame-overlay.is-inner-control .helios-frame-overlay__resize::before {
  border-color: var(--helios-box-accent);
}

.helios-frame-overlay.is-inner-control .helios-frame-overlay__resize.is-edge::before {
  background: var(--helios-box-accent);
  box-shadow:
    0 0 0 1px rgba(255, 255, 255, 0.84),
    0 0 12px var(--helios-box-accent-glow);
}

.helios-frame-overlay.is-inner-control .helios-frame-overlay__resize:hover,
.helios-frame-overlay.is-inner-control .helios-frame-overlay__resize:focus-visible {
  background: rgba(236, 253, 245, 0.96);
}

.helios-frame-overlay:hover > .helios-frame-overlay__resize.is-corner,
.helios-frame-overlay__innerbox-boundary:hover > .helios-frame-overlay__resize.is-corner,
.helios-frame-overlay__resize:focus-visible {
  background: rgba(255, 255, 255, 0.94);
  opacity: 1;
  transform: scale(1);
}

.helios-frame-overlay__resize.is-edge:hover,
.helios-frame-overlay__resize.is-edge:focus-visible,
.helios-frame-overlay__resize.is-edge:active {
  background: transparent;
  opacity: 1;
}

.helios-frame-overlay__resize--inner {
  z-index: 8;
}

.helios-frame-overlay__resize.is-n,
.helios-frame-overlay__resize.is-s {
  left: 50%;
  width: 96px;
  height: 24px;
  margin-left: -48px;
  cursor: ns-resize;
}

.helios-frame-overlay__resize.is-n {
  top: -12px;
}

.helios-frame-overlay__resize.is-s {
  bottom: -12px;
}

.helios-frame-overlay__resize.is-e,
.helios-frame-overlay__resize.is-w {
  top: 50%;
  width: 24px;
  height: 96px;
  margin-top: -48px;
  cursor: ew-resize;
}

.helios-frame-overlay__resize.is-e {
  right: -12px;
}

.helios-frame-overlay__resize.is-w {
  left: -12px;
}

.helios-frame-overlay__resize.is-n,
.helios-frame-overlay__resize.is-s {
  transform: scaleX(0.92) scaleY(0.82);
}

.helios-frame-overlay__resize.is-e,
.helios-frame-overlay__resize.is-w {
  transform: scaleX(0.82) scaleY(0.92);
}

.helios-frame-overlay__resize.is-n:hover,
.helios-frame-overlay__resize.is-s:hover,
.helios-frame-overlay__resize.is-n:focus-visible,
.helios-frame-overlay__resize.is-s:focus-visible {
  transform: scaleX(1.04) scaleY(1);
}

.helios-frame-overlay__resize.is-e:hover,
.helios-frame-overlay__resize.is-w:hover,
.helios-frame-overlay__resize.is-e:focus-visible,
.helios-frame-overlay__resize.is-w:focus-visible {
  transform: scaleX(1) scaleY(1.04);
}

.helios-frame-overlay__resize.is-n:active,
.helios-frame-overlay__resize.is-s:active {
  transform: scaleX(1.1) scaleY(1.04);
}

.helios-frame-overlay__resize.is-e:active,
.helios-frame-overlay__resize.is-w:active {
  transform: scaleX(1.04) scaleY(1.1);
}

.helios-frame-overlay__resize.is-n::before,
.helios-frame-overlay__resize.is-s::before {
  left: 12px;
  width: 72px;
  height: 5px;
}

.helios-frame-overlay__resize.is-n::before {
  top: 13px;
}

.helios-frame-overlay__resize.is-s::before {
  top: 6px;
}

.helios-frame-overlay__resize.is-e::before,
.helios-frame-overlay__resize.is-w::before {
  top: 12px;
  width: 5px;
  height: 72px;
}

.helios-frame-overlay__resize.is-e::before {
  left: 3px;
}

.helios-frame-overlay__resize.is-w::before {
  right: 3px;
  left: auto;
}

.helios-frame-overlay__resize.is-nw {
  top: 0;
  left: 0;
  border-radius: 0 0 5px;
  cursor: nwse-resize;
}

.helios-frame-overlay__resize.is-ne {
  top: 0;
  right: 0;
  border-radius: 0 0 0 5px;
  cursor: nesw-resize;
}

.helios-frame-overlay__resize.is-sw {
  bottom: 0;
  left: 0;
  border-radius: 0 5px 0 0;
  cursor: nesw-resize;
}

.helios-frame-overlay__resize.is-se {
  right: 0;
  bottom: 0;
  border-radius: 5px 0 0;
  cursor: nwse-resize;
}

.helios-frame-overlay__resize.is-nw::before {
  top: 4px;
  left: 4px;
  border-width: 2px 0 0 2px;
}

.helios-frame-overlay__resize.is-ne::before {
  top: 4px;
  right: 4px;
  border-width: 2px 2px 0 0;
}

.helios-frame-overlay__resize.is-sw::before {
  bottom: 4px;
  left: 4px;
  border-width: 0 0 2px 2px;
}

.helios-frame-overlay__resize.is-se::before {
  right: 4px;
  bottom: 4px;
  border-width: 0 2px 2px 0;
}

.helios-frame-overlay__innerbox {
  position: absolute;
  z-index: 3;
  inset: 0;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
  pointer-events: auto;
}

.helios-frame-overlay.is-authoring.is-inner-control > .helios-frame-overlay__innerbox {
  background-color: rgba(25, 210, 124, 0.06);
}

.helios-frame-overlay__innerbox-boundary {
  position: relative;
  z-index: 2;
  box-sizing: border-box;
  flex: 1 1 auto;
  min-width: 12px;
  min-height: 12px;
  border: 0;
  background: transparent;
}

.helios-frame-overlay__innerbox-children {
  display: grid;
  min-width: 0;
  min-height: 0;
  pointer-events: auto;
}

.helios-frame-overlay.is-authoring > .helios-frame-overlay__innerbox .helios-frame-overlay__innerbox-boundary {
  border: 1px dashed rgba(8, 189, 248, 0.74);
  background: #fff;
  box-shadow:
    inset 0 0 0 1px rgba(255, 255, 255, 0.42),
    0 0 0 1px rgba(8, 189, 248, 0.1);
}

.helios-frame-overlay.is-authoring > .helios-frame-overlay__innerbox.is-rhythm .helios-frame-overlay__innerbox-boundary {
  border-color: rgba(8, 189, 248, 0.74);
  background: #fff;
}

.helios-frame-overlay.is-authoring.is-inner-control > .helios-frame-overlay__innerbox .helios-frame-overlay__innerbox-boundary {
  border-color: var(--helios-box-accent);
  background: #fff;
  box-shadow:
    inset 0 0 0 1px rgba(255, 255, 255, 0.52),
    0 0 0 1px rgba(25, 210, 124, 0.18),
    0 0 18px rgba(25, 210, 124, 0.12);
}

.helios-frame-overlay__space {
  position: absolute;
  z-index: 1;
  overflow: hidden;
  background-color: rgba(25, 210, 124, 0.065);
  pointer-events: none;
}

.helios-frame-overlay__space.is-left {
  background-image:
    repeating-linear-gradient(
      to right,
      transparent 0,
      transparent calc(var(--helios-innerbox-space-grid-x, 24px) - 1px),
      rgba(25, 210, 124, 0.3) calc(var(--helios-innerbox-space-grid-x, 24px) - 1px),
      rgba(25, 210, 124, 0.3) var(--helios-innerbox-space-grid-x, 24px)
    ),
    repeating-linear-gradient(
      to bottom,
      transparent 0,
      transparent calc(var(--helios-innerbox-space-grid-y, 24px) - 1px),
      rgba(25, 210, 124, 0.18) calc(var(--helios-innerbox-space-grid-y, 24px) - 1px),
      rgba(25, 210, 124, 0.18) var(--helios-innerbox-space-grid-y, 24px)
    );
}

.helios-frame-overlay__space.is-right {
  background-image:
    repeating-linear-gradient(
      to left,
      transparent 0,
      transparent calc(var(--helios-innerbox-space-grid-x, 24px) - 1px),
      rgba(25, 210, 124, 0.3) calc(var(--helios-innerbox-space-grid-x, 24px) - 1px),
      rgba(25, 210, 124, 0.3) var(--helios-innerbox-space-grid-x, 24px)
    ),
    repeating-linear-gradient(
      to bottom,
      transparent 0,
      transparent calc(var(--helios-innerbox-space-grid-y, 24px) - 1px),
      rgba(25, 210, 124, 0.18) calc(var(--helios-innerbox-space-grid-y, 24px) - 1px),
      rgba(25, 210, 124, 0.18) var(--helios-innerbox-space-grid-y, 24px)
    );
}

.helios-frame-overlay__space.is-top {
  background-image:
    repeating-linear-gradient(
      to bottom,
      transparent 0,
      transparent calc(var(--helios-innerbox-space-grid-y, 24px) - 1px),
      rgba(25, 210, 124, 0.3) calc(var(--helios-innerbox-space-grid-y, 24px) - 1px),
      rgba(25, 210, 124, 0.3) var(--helios-innerbox-space-grid-y, 24px)
    ),
    repeating-linear-gradient(
      to right,
      transparent 0,
      transparent calc(var(--helios-innerbox-space-grid-x, 24px) - 1px),
      rgba(25, 210, 124, 0.18) calc(var(--helios-innerbox-space-grid-x, 24px) - 1px),
      rgba(25, 210, 124, 0.18) var(--helios-innerbox-space-grid-x, 24px)
    );
}

.helios-frame-overlay__space.is-bottom {
  background-image:
    repeating-linear-gradient(
      to top,
      transparent 0,
      transparent calc(var(--helios-innerbox-space-grid-y, 24px) - 1px),
      rgba(25, 210, 124, 0.3) calc(var(--helios-innerbox-space-grid-y, 24px) - 1px),
      rgba(25, 210, 124, 0.3) var(--helios-innerbox-space-grid-y, 24px)
    ),
    repeating-linear-gradient(
      to right,
      transparent 0,
      transparent calc(var(--helios-innerbox-space-grid-x, 24px) - 1px),
      rgba(25, 210, 124, 0.18) calc(var(--helios-innerbox-space-grid-x, 24px) - 1px),
      rgba(25, 210, 124, 0.18) var(--helios-innerbox-space-grid-x, 24px)
    );
}

.helios-frame-overlay__measure {
  position: absolute;
  z-index: 7;
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 16px;
  min-height: 16px;
  color: #11945c;
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0;
  line-height: 1;
  pointer-events: none;
}

.helios-frame-overlay__measure.is-left,
.helios-frame-overlay__measure.is-right {
  height: 20px;
  transform: translateY(-50%);
}

.helios-frame-overlay__measure.is-top,
.helios-frame-overlay__measure.is-bottom {
  width: 20px;
  transform: translateX(-50%);
}

.helios-frame-overlay__measure-line {
  position: absolute;
  border-radius: 999px;
  background: rgba(25, 210, 124, 0.82);
  content: '';
}

.helios-frame-overlay__measure.is-left .helios-frame-overlay__measure-line,
.helios-frame-overlay__measure.is-right .helios-frame-overlay__measure-line {
  top: 50%;
  right: 0;
  left: 0;
  height: 2px;
  transform: translateY(-50%);
}

.helios-frame-overlay__measure.is-top .helios-frame-overlay__measure-line,
.helios-frame-overlay__measure.is-bottom .helios-frame-overlay__measure-line {
  top: 0;
  bottom: 0;
  left: 50%;
  width: 2px;
  transform: translateX(-50%);
}

.helios-frame-overlay__measure-value {
  position: relative;
  z-index: 1;
  min-width: 20px;
  padding: 2px 6px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.96);
  box-shadow:
    0 0 0 1px rgba(25, 210, 124, 0.32),
    0 6px 16px rgba(17, 148, 92, 0.14);
  text-align: center;
}

.helios-frame-overlay.is-authoring > .helios-frame-overlay__innerbox.is-center-x .helios-frame-overlay__innerbox-boundary::before,
.helios-frame-overlay.is-authoring > .helios-frame-overlay__innerbox.is-center-y .helios-frame-overlay__innerbox-boundary::after {
  position: absolute;
  content: '';
  background: rgba(8, 189, 248, 0.46);
}

.helios-frame-overlay.is-authoring > .helios-frame-overlay__innerbox.is-center-x .helios-frame-overlay__innerbox-boundary::before {
  top: 0;
  bottom: 0;
  left: 50%;
  width: 1px;
}

.helios-frame-overlay.is-authoring > .helios-frame-overlay__innerbox.is-center-y .helios-frame-overlay__innerbox-boundary::after {
  top: 50%;
  right: 0;
  left: 0;
  height: 1px;
}
</style>
