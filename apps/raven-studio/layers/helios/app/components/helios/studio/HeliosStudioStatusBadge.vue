<script setup lang="ts">
import type { HeliosStudioStatusTone } from '../../../config/heliosStudioNavigation'

withDefaults(defineProps<{
  label: string
  tone?: HeliosStudioStatusTone
}>(), {
  tone: 'neutral',
})
</script>

<template>
  <span class="studio-status-badge" :data-tone="tone">
    <span class="studio-status-badge__dot" aria-hidden="true" />
    {{ label }}
  </span>
</template>
