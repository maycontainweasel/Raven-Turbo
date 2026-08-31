<script setup lang="ts">
import { useHeliosRuntimeStore } from '../../stores/heliosRuntime'

const runtime = useHeliosRuntimeStore()
const dockEl = ref<HTMLElement | null>(null)
const position = ref({ x: 16, y: 16 })
const dragState = ref<{
  pointerId: number
  startX: number
  startY: number
  originX: number
  originY: number
} | null>(null)

const STORAGE_KEY = 'helios.runtime.dockPosition'

const dockStyle = computed(() => ({
  left: `${position.value.x}px`,
  top: `${position.value.y}px`,
}))

const clampPosition = (next: { x: number; y: number }) => {
  if (typeof window === 'undefined') return next
  const bounds = dockEl.value?.getBoundingClientRect()
  const width = bounds?.width || 244
  const height = bounds?.height || 46
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

const onDockPointerDown = (event: PointerEvent) => {
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

const onDockPointerMove = (event: PointerEvent) => {
  const state = dragState.value
  if (!state || state.pointerId !== event.pointerId) return
  position.value = clampPosition({
    x: state.originX + event.clientX - state.startX,
    y: state.originY + event.clientY - state.startY,
  })
}

const onDockPointerUp = (event: PointerEvent) => {
  const state = dragState.value
  if (!state || state.pointerId !== event.pointerId) return
  dragState.value = null
  savePosition()
}

onMounted(() => {
  const saved = window.localStorage.getItem(STORAGE_KEY)
  if (!saved) return
  try {
    const parsed = JSON.parse(saved)
    position.value = clampPosition({
      x: Number(parsed.x) || 16,
      y: Number(parsed.y) || 16,
    })
  } catch {
    position.value = { x: 16, y: 16 }
  }
})
</script>

<template>
  <div
    ref="dockEl"
    class="helios-runtime-toggle"
    :style="dockStyle"
    aria-label="Helios runtime controls"
  >
    <button
      type="button"
      class="helios-runtime-toggle__handle"
      title="Move controls"
      aria-label="Move controls"
      @pointerdown="onDockPointerDown"
      @pointermove="onDockPointerMove"
      @pointerup="onDockPointerUp"
      @pointercancel="onDockPointerUp"
    >
      <span />
      <span />
      <span />
    </button>
    <button
      type="button"
      class="helios-runtime-toggle__button"
      :class="{ 'is-active': runtime?.tool === 'draw' }"
      :aria-pressed="runtime?.tool === 'draw'"
      title="Draw frame"
      @click="runtime?.setTool?.('draw')"
    >
      <span class="i-lucide-square-dashed-mouse-pointer" aria-hidden="true" />
    </button>
    <button
      type="button"
      class="helios-runtime-toggle__button"
      :class="{ 'is-active': runtime?.tool === 'select' }"
      :aria-pressed="runtime?.tool === 'select'"
      title="Select frame"
      @click="runtime?.setTool?.('select')"
    >
      <span class="i-lucide-mouse-pointer-2" aria-hidden="true" />
    </button>
    <button
      type="button"
      class="helios-runtime-toggle__button"
      :class="{ 'is-active': runtime?.navigatorOpen }"
      :aria-pressed="runtime?.navigatorOpen"
      title="Frame navigator"
      @click="runtime?.toggleNavigator?.()"
    >
      <span class="i-lucide-list-tree" aria-hidden="true" />
    </button>
    <button
      type="button"
      class="helios-runtime-toggle__breakpoint"
      title="Switch responsive arena. Press R for next, Shift+R for previous."
      @click="runtime?.cycleBreakpoint?.()"
    >
      {{ runtime?.activeBreakpoint || 'base' }}
    </button>
    <div class="helios-runtime-toggle__mode" role="group" aria-label="Runtime authoring mode">
      <button
        type="button"
        :class="{ 'is-active': runtime?.runtimeMode === 'frame' }"
        title="Frame authoring mode"
        @click="runtime?.setRuntimeMode?.('frame')"
      >
        Frame
      </button>
      <button
        type="button"
        :class="{ 'is-active': runtime?.runtimeMode === 'widget' }"
        title="Widget authoring mode. Press T to create a text node."
        @click="runtime?.setRuntimeMode?.('widget')"
      >
        Widget
      </button>
    </div>
  </div>
</template>

<style scoped>
.helios-runtime-toggle {
  position: fixed;
  z-index: 80;
  display: flex;
  gap: 6px;
  padding: 6px;
  border: 1px solid rgba(11, 18, 32, 0.16);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.92);
  box-shadow: 0 12px 30px rgba(11, 18, 32, 0.14);
  backdrop-filter: blur(16px);
}

.helios-runtime-toggle__handle,
.helios-runtime-toggle__button,
.helios-runtime-toggle__breakpoint {
  display: grid;
  height: 34px;
  place-items: center;
  border: 0;
  border-radius: 6px;
  color: #1f2937;
  background: transparent;
}

.helios-runtime-toggle__handle {
  width: 18px;
  gap: 3px;
  cursor: grab;
}

.helios-runtime-toggle__handle:active {
  cursor: grabbing;
}

.helios-runtime-toggle__handle span {
  width: 3px;
  height: 3px;
  border-radius: 999px;
  background: currentColor;
}

.helios-runtime-toggle__button {
  width: 34px;
  cursor: pointer;
}

.helios-runtime-toggle__mode {
  display: flex;
  align-items: center;
  gap: 2px;
  padding: 2px;
  border: 1px solid rgba(11, 18, 32, 0.1);
  border-radius: 6px;
  background: rgba(241, 245, 249, 0.82);
}

.helios-runtime-toggle__mode button {
  display: grid;
  height: 28px;
  min-width: 54px;
  place-items: center;
  border: 0;
  border-radius: 5px;
  padding: 0 8px;
  color: #334155;
  background: transparent;
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0;
  text-transform: uppercase;
  cursor: pointer;
}

.helios-runtime-toggle__mode button.is-active {
  color: #ffffff;
  background: #2557d6;
}

.helios-runtime-toggle__mode button:disabled {
  color: #94a3b8;
  cursor: not-allowed;
}

.helios-runtime-toggle__breakpoint {
  min-width: 62px;
  padding: 0 8px;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0;
  text-transform: uppercase;
  cursor: pointer;
}

.helios-runtime-toggle__button:hover,
.helios-runtime-toggle__button.is-active,
.helios-runtime-toggle__breakpoint:hover {
  color: #ffffff;
  background: #2557d6;
}

.helios-runtime-toggle__button span {
  width: 18px;
  height: 18px;
}
</style>
