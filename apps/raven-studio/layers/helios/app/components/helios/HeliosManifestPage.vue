<script setup lang="ts">
import type { HeliosPageManifest } from '@helios/protocol'
import { resolveHeliosManifestClassStyle } from '../../utils/heliosManifestRender'

defineOptions({
  name: 'HeliosManifestPage',
})

const props = defineProps<{
  manifest: HeliosPageManifest
}>()

const canvasStyle = computed(() => ({
  ...resolveHeliosManifestClassStyle(props.manifest.canvas.classes),
  ...(props.manifest.canvas.style || {}),
}))
</script>

<template>
  <main
    class="helios-manifest-page"
    :class="manifest.canvas.classes"
    :style="canvasStyle"
    :data-helios-page="manifest.pageId"
  >
    <HeliosRenderedNode
      v-for="node in manifest.nodes"
      :key="node.id"
      :node="node"
    />
  </main>
</template>

<style scoped>
.helios-manifest-page {
  box-sizing: border-box;
  width: 100%;
  min-width: 0;
  color: #0f172a;
  background: #ffffff;
}
</style>
