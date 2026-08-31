<script setup lang="ts">
import type { HeliosCompiledFrameNode } from '@helios/protocol'
import { resolveHeliosManifestClassStyle } from '../../utils/heliosManifestRender'

defineOptions({
  name: 'HeliosRenderedFrame',
})

const props = defineProps<{
  node: HeliosCompiledFrameNode
}>()

const outerStyle = computed(() => ({
  ...resolveHeliosManifestClassStyle(props.node.outerClasses),
  ...(props.node.outerStyle || {}),
}))

const innerStyle = computed(() => ({
  ...resolveHeliosManifestClassStyle(props.node.innerClasses),
  ...(props.node.innerStyle || {}),
}))
</script>

<template>
  <section
    class="helios-rendered-frame"
    :class="node.outerClasses"
    :style="outerStyle"
    :data-helios-node="node.dataHeliosNode"
    :data-helios-node-kind="node.kind"
  >
    <div
      class="helios-rendered-frame__inner"
      :class="node.innerClasses"
      :style="innerStyle"
    >
      <HeliosRenderedNode
        v-for="child in node.children"
        :key="child.id"
        :node="child"
      />
    </div>
  </section>
</template>

<style scoped>
.helios-rendered-frame {
  position: relative;
  box-sizing: border-box;
  min-width: 0;
  min-height: 0;
}

.helios-rendered-frame__inner {
  box-sizing: border-box;
  width: 100%;
  height: 100%;
  min-width: 0;
  min-height: 0;
}
</style>
