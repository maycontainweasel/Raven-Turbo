<script setup lang="ts">
import type { HeliosCompiledNode } from '@helios/protocol'

defineOptions({
  name: 'HeliosRenderedNode',
})

defineProps<{
  node: HeliosCompiledNode
}>()
</script>

<template>
  <HeliosRenderedFrame
    v-if="node.kind === 'frame'"
    :node="node"
  />
  <HeliosRenderedText
    v-else-if="node.kind === 'text'"
    :node="node"
  />
</template>
