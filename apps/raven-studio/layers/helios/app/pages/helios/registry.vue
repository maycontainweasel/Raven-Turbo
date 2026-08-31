<script setup lang="ts">
definePageMeta({ ssr: false, layout: 'helios-studio' })

const states = [
  { id: 'installed', label: 'Installed', description: 'Components committed into the host application.', icon: 'i-lucide-package-check' },
  { id: 'available', label: 'Available', description: 'Registry families compatible with the active project language.', icon: 'i-lucide-package-search' },
  { id: 'modified', label: 'Modified', description: 'App-owned source that differs from its registry baseline.', icon: 'i-lucide-file-diff' },
  { id: 'updates', label: 'Updates', description: 'Explicit upstream changes awaiting review and conflict policy.', icon: 'i-lucide-refresh-cw' },
]
</script>

<template>
  <div>
    <HeliosStudioPageHeader
      title="Registry"
      description="Future source ownership and update visibility. No registry schema, lock file, installation, or mutation is implemented in Shell v2."
      status="Planned"
      status-tone="warning"
    />

    <section class="studio-section" aria-label="Registry states">
      <div class="studio-registry-list">
        <article v-for="state in states" :id="state.id" :key="state.id" class="studio-registry-row">
          <span :class="state.icon" aria-hidden="true" />
          <div>
            <h2>{{ state.label }}</h2>
            <p>{{ state.description }}</p>
          </div>
          <HeliosStudioStatusBadge label="Contract pending" tone="warning" />
        </article>
      </div>
    </section>

    <section id="registry-operations" class="studio-section">
      <HeliosStudioEmptyState
        icon="i-lucide-library"
        title="Registry operations are intentionally unavailable"
        description="The canonical manifest and registry-lock contracts must be accepted before source installation or update flows begin."
      />
    </section>
  </div>
</template>
