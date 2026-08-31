<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import {
  findHeliosStudioArena,
  getHeliosStudioPageOutline,
} from '../../../config/heliosStudioNavigation'

const route = useRoute()
const navigationOpen = ref(false)
const activeArena = computed(() => findHeliosStudioArena(route.path))
const pageOutline = computed(() => getHeliosStudioPageOutline(route.path))

watch(() => route.fullPath, () => {
  navigationOpen.value = false
})

const onKeydown = (event: KeyboardEvent) => {
  if (event.key === 'Escape') navigationOpen.value = false
}

onMounted(() => window.addEventListener('keydown', onKeydown))
onBeforeUnmount(() => window.removeEventListener('keydown', onKeydown))
</script>

<template>
  <div class="helios-studio ds-app" data-theme="orbit-dark">
    <a class="studio-skip-link" href="#helios-studio-main">Skip to content</a>
    <HeliosStudioHeader
      :active-arena="activeArena"
      :navigation-open="navigationOpen"
      @toggle-navigation="navigationOpen = !navigationOpen"
    />

    <div class="studio-shell-body">
      <HeliosStudioSidebar
        :active-path="route.fullPath"
        :active-arena="activeArena"
        :mobile-open="navigationOpen"
        @close="navigationOpen = false"
      />
      <button
        v-if="navigationOpen"
        class="studio-sidebar-backdrop"
        type="button"
        aria-label="Close navigation"
        @click="navigationOpen = false"
      />
      <main id="helios-studio-main" class="studio-main" tabindex="-1">
        <slot />
      </main>
      <HeliosStudioOutline :items="pageOutline" />
    </div>
  </div>
</template>
