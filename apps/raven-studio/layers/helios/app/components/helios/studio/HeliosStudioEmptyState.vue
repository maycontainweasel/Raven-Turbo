<script setup lang="ts">
withDefaults(defineProps<{
  icon?: string
  title: string
  description: string
}>(), {
  icon: 'i-lucide-box',
})
</script>

<template>
  <section class="studio-empty-state">
    <span :class="icon" aria-hidden="true" />
    <div>
      <h2>{{ title }}</h2>
      <p>{{ description }}</p>
    </div>
    <div v-if="$slots.default" class="studio-empty-state__actions">
      <slot />
    </div>
  </section>
</template>
