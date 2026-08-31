<script setup lang="ts">
useHead({
  htmlAttrs: {
    'data-theme': 'raven-studio',
  },
  bodyAttrs: {
    class: 'raven-studio-app',
  },
})
</script>

<template>
  <NuxtRouteAnnouncer />
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>
