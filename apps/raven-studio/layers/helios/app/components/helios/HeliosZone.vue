<script setup lang="ts">
import { useHeliosRuntimeStore } from '../../stores/heliosRuntime'

const props = withDefaults(defineProps<{
  id: string
  documentId: string
  cols?: number
  rows?: number
  rowPx?: number
  showGrid?: boolean
  midline?: boolean
}>(), {
  cols: 24,
  rows: 24,
  rowPx: 32,
  showGrid: true,
  midline: true,
})

const runtime = useHeliosRuntimeStore()

const load = () => runtime.loadNodes({
  documentId: props.documentId,
  zoneId: props.id,
})

onMounted(load)

watch(
  () => [props.documentId, props.id],
  () => load(),
)
</script>

<template>
  <section
    class="helios-zone"
    :data-helios-zone="id"
    :data-helios-document="documentId"
  >
    <div class="helios-zone__content">
      <slot />
    </div>
    <HeliosOverlay
      :document-id="documentId"
      :zone-id="id"
      :cols="cols"
      :rows="rows"
      :row-px="rowPx"
      :show-grid="showGrid"
      :midline="midline"
    />
  </section>
</template>

<style scoped>
.helios-zone {
  position: relative;
  box-sizing: border-box;
  min-height: 62vh;
  border: 1px solid rgba(11, 18, 32, 0.14);
  border-radius: 8px;
  background: #f8fafc;
  overflow: hidden;
}

.helios-zone__content {
  min-height: inherit;
  padding: clamp(24px, 4vw, 56px);
}
</style>
