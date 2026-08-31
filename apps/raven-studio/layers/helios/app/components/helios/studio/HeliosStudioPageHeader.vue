<script setup lang="ts">
import type { HeliosStudioStatusTone } from '../../../config/heliosStudioNavigation'

withDefaults(defineProps<{
  eyebrow?: string
  title: string
  description: string
  status?: string
  statusTone?: HeliosStudioStatusTone
}>(), {
  eyebrow: 'Design System Studio',
  status: '',
  statusTone: 'neutral',
})
</script>

<template>
  <header class="studio-page-header">
    <div>
      <p class="studio-eyebrow">{{ eyebrow }}</p>
      <div class="studio-page-header__title">
        <h1>{{ title }}</h1>
        <HeliosStudioStatusBadge v-if="status" :label="status" :tone="statusTone" />
      </div>
      <p>{{ description }}</p>
    </div>
    <div v-if="$slots.actions" class="studio-page-header__actions">
      <slot name="actions" />
    </div>
  </header>
</template>
