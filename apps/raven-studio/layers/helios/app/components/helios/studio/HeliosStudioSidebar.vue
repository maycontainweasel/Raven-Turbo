<script setup lang="ts">
import {
  heliosStudioArenas,
  type HeliosStudioArena,
} from '../../../config/heliosStudioNavigation'

defineProps<{
  activePath: string
  activeArena: HeliosStudioArena
  mobileOpen: boolean
}>()

const emit = defineEmits<{
  close: []
}>()
</script>

<template>
  <aside
    id="helios-studio-navigation"
    class="studio-sidebar"
    :class="{ 'studio-sidebar--open': mobileOpen }"
    aria-label="Design System Studio navigation"
  >
    <div class="studio-sidebar__mobile-head">
      <NuxtLink class="studio-brand" to="/helios" @click="emit('close')">
        <span class="studio-brand__mark i-lucide-sun-medium" aria-hidden="true" />
        <strong>Helios</strong>
      </NuxtLink>
      <button type="button" aria-label="Close navigation" @click="emit('close')">
        <span class="i-lucide-x" aria-hidden="true" />
      </button>
    </div>

    <div class="studio-sidebar__scroll">
      <nav class="studio-sidebar__arenas" aria-label="Studio arenas">
        <NuxtLink
          v-for="arena in heliosStudioArenas"
          :key="arena.id"
          :to="arena.to"
          :aria-current="activeArena.id === arena.id ? 'page' : undefined"
          :class="{ 'studio-sidebar__arena--active': activeArena.id === arena.id }"
          @click="emit('close')"
        >
          {{ arena.label }}
        </NuxtLink>
      </nav>
      <HeliosStudioNavGroup
        v-for="group in activeArena.groups"
        :key="group.label"
        :group="group"
        :active-path="activePath"
        @navigate="emit('close')"
      />
    </div>

    <div class="studio-sidebar__footer">
      <span class="i-lucide-info" aria-hidden="true" />
      <p>App-owned artifact contracts remain provisional.</p>
    </div>
  </aside>
</template>
