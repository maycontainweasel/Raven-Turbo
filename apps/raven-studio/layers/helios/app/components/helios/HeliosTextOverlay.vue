<script setup lang="ts">
import {
  getGridCellValue,
  normalizeTextContentInput,
  type HeliosNodeRecord,
} from '@helios/protocol'
import { useHeliosRuntimeStore } from '../../stores/heliosRuntime'

defineOptions({
  name: 'HeliosTextOverlay',
})

const props = defineProps<{
  node: HeliosNodeRecord
  selected?: boolean
}>()

const runtime = useHeliosRuntimeStore()

const cell = computed(() => (
  getGridCellValue(props.node.qualities, undefined, runtime.activeBreakpoint)
))

const content = computed(() => normalizeTextContentInput(props.node.content))

const textStyle = computed(() => {
  const value = cell.value
  if (!value) return {}

  return {
    gridColumn: `${value.colStart} / ${value.colEnd}`,
    gridRow: `${value.rowStart} / ${value.rowEnd}`,
  }
})

const showLabel = computed(() => (
  runtime.active
  && (runtime.settings.frameLabelVisibility === 'always' || Boolean(props.selected))
))
</script>

<template>
  <div
    class="helios-text-overlay"
    :class="{
      'is-authoring': runtime.active,
      'is-selected': selected,
      'is-locked': runtime.isNodeLocked(node),
    }"
    :style="textStyle"
    :data-helios-node="node.id"
    :data-helios-node-kind="node.kind"
    :data-helios-locked="runtime.isNodeLocked(node) ? 'true' : undefined"
  >
    <component :is="content.tag" class="helios-text-overlay__content">
      {{ content.text }}
    </component>
    <span v-if="showLabel" class="helios-text-overlay__label">
      {{ node.label || 'Text' }}
    </span>
  </div>
</template>

<style scoped>
.helios-text-overlay {
  position: relative;
  box-sizing: border-box;
  min-width: 0;
  min-height: 0;
  padding: 4px 6px;
  color: #0f172a;
  background: transparent;
  cursor: default;
  overflow: hidden;
  pointer-events: auto;
  user-select: none;
}

.helios-text-overlay.is-authoring {
  cursor: grab;
}

.helios-text-overlay.is-authoring:active {
  cursor: grabbing;
}

.helios-text-overlay.is-authoring.is-selected {
  box-shadow:
    inset 0 0 0 1px #08bdf8,
    0 0 0 2px rgba(8, 189, 248, 0.28),
    0 0 18px rgba(8, 189, 248, 0.16);
}

.helios-text-overlay.is-authoring.is-locked {
  cursor: default;
  outline: 1px dashed rgba(37, 87, 214, 0.72);
  outline-offset: -1px;
}

.helios-text-overlay__content {
  margin: 0;
  font: inherit;
  line-height: 1.2;
  pointer-events: none;
  white-space: pre-wrap;
}

.helios-text-overlay__label {
  position: absolute;
  top: 0;
  left: 0;
  z-index: 2;
  max-width: calc(100% - 6px);
  overflow: hidden;
  padding: 2px 5px;
  border-radius: 4px;
  color: #0b1220;
  background: rgba(255, 255, 255, 0.82);
  font-size: 10px;
  font-weight: 700;
  line-height: 1.1;
  pointer-events: none;
  text-overflow: ellipsis;
  white-space: nowrap;
  transform: translateY(-100%);
}
</style>
