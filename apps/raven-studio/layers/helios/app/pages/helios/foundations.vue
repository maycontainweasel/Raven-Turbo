<script setup lang="ts">
definePageMeta({ ssr: false, layout: 'helios-studio' })

const foundations = [
  { id: 'colors', label: 'Colors', description: 'Palette generation and semantic theme mapping.', icon: 'i-lucide-palette' },
  { id: 'typography', label: 'Typography', description: 'Modular type scale and breakpoint-specific sizing.', icon: 'i-lucide-type' },
  { id: 'rhythm-space', label: 'Rhythm & Space', description: 'Grid-unit rhythm, ratio spacing, and utility families.', icon: 'i-lucide-ruler' },
  { id: 'breakpoints', label: 'Breakpoints', description: 'Responsive ranges and generated media arenas.', icon: 'i-lucide-monitor-smartphone' },
  { id: 'radius', label: 'Radius', description: 'Proposed semantic corner scale for component families.', icon: 'i-lucide-scan-corner' },
  { id: 'shadows', label: 'Shadows', description: 'Proposed elevation language for application surfaces.', icon: 'i-lucide-layers-3' },
  { id: 'motion', label: 'Motion', description: 'Proposed duration and easing conventions.', icon: 'i-lucide-gauge' },
]
</script>

<template>
  <div>
    <HeliosStudioPageHeader
      title="Foundations"
      description="The Atomic language beneath themes and components. Existing editors stay available while Studio-native foundation surfaces are designed."
      status="Migration"
      status-tone="warning"
    >
      <template #actions>
        <NuxtLink class="studio-link" to="/helios/legacy">
          <span class="i-lucide-external-link" aria-hidden="true" />
          Open working controls
        </NuxtLink>
      </template>
    </HeliosStudioPageHeader>

    <section class="studio-section">
      <div class="studio-foundation-list">
        <article v-for="foundation in foundations" :id="foundation.id" :key="foundation.id" class="studio-foundation-row">
          <span :class="foundation.icon" aria-hidden="true" />
          <div>
            <h2>{{ foundation.label }}</h2>
            <p>{{ foundation.description }}</p>
          </div>
          <HeliosStudioStatusBadge
            :label="['colors', 'typography', 'rhythm-space', 'breakpoints'].includes(foundation.id) ? 'Legacy active' : 'Planned'"
            :tone="['colors', 'typography', 'rhythm-space', 'breakpoints'].includes(foundation.id) ? 'success' : 'warning'"
          />
        </article>
      </div>
    </section>
  </div>
</template>
