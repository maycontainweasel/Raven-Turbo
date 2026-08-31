<script setup lang="ts">
definePageMeta({ ssr: false, layout: 'helios-studio' })

const components = [
  { id: 'field', title: 'Field', description: 'Shared label, control, helper, error, icon, and indicator anatomy.', status: 'Contract', tone: 'success' as const, icon: 'i-lucide-text-cursor-input' },
  { id: 'input', title: 'Input', description: 'The first visual control playground and proposed ds-* expression.', status: 'Prototype', tone: 'info' as const, icon: 'i-lucide-rectangle-ellipsis' },
  { id: 'button', title: 'Button', description: 'Action hierarchy, icon variants, state behavior, and capability selection.', status: 'Planned', tone: 'warning' as const, icon: 'i-lucide-mouse-pointer-click' },
  { id: 'select', title: 'Select', description: 'Ark UI composition, portal policy, field integration, and option states.', status: 'Not installed', tone: 'neutral' as const, icon: 'i-lucide-list-filter' },
]
</script>

<template>
  <div>
    <HeliosStudioPageHeader
      title="Components"
      description="A catalogue contract for source-owned Vue components built from Ark UI behavior and Atomic presentation language."
      status="Catalogue shell"
      status-tone="info"
    >
      <template #actions>
        <NuxtLink class="studio-link" to="/helios/design">
          <span class="i-lucide-flask-conical" aria-hidden="true" />
          Open playground
        </NuxtLink>
      </template>
    </HeliosStudioPageHeader>

    <section class="studio-section">
      <div class="studio-component-grid">
        <article v-for="component in components" :id="component.id" :key="component.id" class="studio-component-card">
          <span class="studio-component-card__icon" aria-hidden="true">
            <span :class="component.icon" />
          </span>
          <h2>{{ component.title }}</h2>
          <p>{{ component.description }}</p>
          <div class="studio-component-card__meta">
            <HeliosStudioStatusBadge :label="component.status" :tone="component.tone" />
            <span class="ds-text-muted">Source commit unavailable</span>
          </div>
        </article>
      </div>
    </section>
  </div>
</template>
