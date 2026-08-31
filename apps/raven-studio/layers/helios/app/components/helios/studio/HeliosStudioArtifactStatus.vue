<script setup lang="ts">
withDefaults(defineProps<{
  path: string
  description: string
  status?: string
}>(), {
  status: 'Proposed / not generated',
})
</script>

<template>
  <article class="studio-artifact-row">
    <span class="i-lucide-file-code-2" aria-hidden="true" />
    <div>
      <code>{{ path }}</code>
      <p>{{ description }}</p>
    </div>
    <HeliosStudioStatusBadge :label="status" tone="warning" />
  </article>
</template>
