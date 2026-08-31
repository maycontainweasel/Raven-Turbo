<script setup lang="ts">
import type { HeliosStudioNavGroup } from '../../../config/heliosStudioNavigation'

const props = defineProps<{
  group: HeliosStudioNavGroup
  activePath: string
}>()

const emit = defineEmits<{
  navigate: []
}>()

const isActive = (to: string) => {
  const [targetPath, targetHash] = to.split('#')
  const [currentPath, currentHash] = props.activePath.split('#')

  if (targetHash) return currentPath === targetPath && currentHash === targetHash
  if (targetPath === '/helios') return currentPath === '/helios'
  return currentPath === targetPath || currentPath.startsWith(`${targetPath}/`)
}
</script>

<template>
  <section class="studio-nav-group">
    <h2>{{ group.label }}</h2>
    <nav :aria-label="`${group.label} navigation`">
      <div v-for="item in group.items" :key="item.to" class="studio-nav-item">
        <NuxtLink
          class="studio-nav-link"
          :class="{ 'studio-nav-link--active': isActive(item.to) }"
          :to="item.to"
          :aria-current="isActive(item.to) ? 'page' : undefined"
          @click="emit('navigate')"
        >
          <span class="studio-nav-link__label">{{ item.label }}</span>
          <HeliosStudioStatusBadge
            v-if="item.status"
            :label="item.status"
            :tone="item.statusTone"
          />
        </NuxtLink>
      </div>
    </nav>
  </section>
</template>
