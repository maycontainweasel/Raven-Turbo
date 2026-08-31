<script setup lang="ts">
import type { HeliosCompiledTextNode } from '@helios/protocol'
import { resolveHeliosManifestClassStyle } from '../../utils/heliosManifestRender'

defineOptions({
  name: 'HeliosRenderedText',
})

const props = defineProps<{
  node: HeliosCompiledTextNode
}>()

const textStyle = computed(() => ({
  ...resolveHeliosManifestClassStyle(props.node.classes),
  ...(props.node.style || {}),
}))
</script>

<template>
  <component
    :is="node.tag"
    class="helios-rendered-text"
    :class="node.classes"
    :style="textStyle"
    :data-helios-node="node.dataHeliosNode"
    :data-helios-node-kind="node.kind"
  >
    {{ node.text }}
  </component>
</template>

<style scoped>
.helios-rendered-text {
  box-sizing: border-box;
  min-width: 0;
  min-height: 0;
  margin: 0;
  color: inherit;
  line-height: 1.2;
  white-space: pre-wrap;
}
</style>
