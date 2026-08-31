<script setup lang="ts">
import {
  heliosStudioArenas,
  type HeliosStudioArena,
} from '../../../config/heliosStudioNavigation'

defineProps<{
  activeArena: HeliosStudioArena
  navigationOpen: boolean
}>()

const emit = defineEmits<{
  toggleNavigation: []
}>()
</script>

<template>
  <header class="studio-header">
    <div class="studio-header__inner">
      <button
        class="studio-header__menu"
        type="button"
        aria-label="Toggle navigation"
        aria-controls="helios-studio-navigation"
        :aria-expanded="navigationOpen"
        @click="emit('toggleNavigation')"
      >
        <span class="i-lucide-panel-left" aria-hidden="true" />
      </button>
      <NuxtLink class="studio-brand" to="/helios">
        <span class="studio-brand__mark i-lucide-sun-medium" aria-hidden="true" />
        <strong>Helios</strong>
      </NuxtLink>

      <nav class="studio-arena-nav" aria-label="Studio arenas">
        <NuxtLink
          v-for="arena in heliosStudioArenas"
          :key="arena.id"
          :to="arena.to"
          :aria-current="activeArena.id === arena.id ? 'page' : undefined"
          :class="{ 'studio-arena-nav__link--active': activeArena.id === arena.id }"
        >
          {{ arena.label }}
        </NuxtLink>
      </nav>

      <div class="studio-header__actions">
        <button class="studio-search-trigger" type="button" disabled>
          <span class="i-lucide-search" aria-hidden="true" />
          <span>Search...</span>
          <kbd>⌘ K</kbd>
        </button>
        <NuxtLink class="studio-icon-link" to="/helios-output" aria-label="Open output preview" title="Output preview">
          <span class="i-lucide-monitor-play" aria-hidden="true" />
        </NuxtLink>
        <button class="studio-icon-link" type="button" aria-label="Theme controls planned" title="Theme controls planned" disabled>
          <span class="i-lucide-circle-half" aria-hidden="true" />
        </button>
        <button class="studio-commit-button" type="button" disabled title="Commit transactions are planned">
          <span class="i-lucide-git-commit-horizontal" aria-hidden="true" />
          Commit
        </button>
      </div>
    </div>
  </header>
</template>
