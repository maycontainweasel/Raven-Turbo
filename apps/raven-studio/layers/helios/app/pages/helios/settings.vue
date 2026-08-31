<script setup lang="ts">
definePageMeta({ ssr: false, layout: 'helios-studio' })
</script>

<template>
  <div>
    <HeliosStudioPageHeader
      title="Settings"
      description="Architecture and migration status for the removable Studio layer. No destructive actions are available in this sprint."
      status="Safe surface"
      status-tone="success"
    />

    <section id="removal-doctrine" class="studio-section">
      <div class="studio-doctrine">
        <strong>The Studio is removable. Production truth is app-owned.</strong>
        <p>Removal cannot be claimed until a fixture configures and commits output, removes the Studio layer, and proves the host application still installs, builds, and renders correctly.</p>
      </div>
    </section>

    <section id="migration-routes" class="studio-section" aria-labelledby="migration-routes-heading">
      <div class="studio-section__head">
        <div>
          <h2 id="migration-routes-heading">Migration routes</h2>
          <p>Existing capabilities remain reachable while the new Studio gains parity.</p>
        </div>
      </div>
      <dl class="studio-definition-list">
        <div>
          <dt>/helios/legacy</dt>
          <dd>The existing type, color, theme, breakpoint, utility, and generation manager.</dd>
        </div>
        <div>
          <dt>/helios/design</dt>
          <dd>The existing Field/Input and Orbit Dark visual prototype.</dd>
        </div>
        <div>
          <dt>/helios-output</dt>
          <dd>The separate Helios Authoring output-preview surface.</dd>
        </div>
      </dl>
    </section>

    <section id="removal-transactions" class="studio-section">
      <HeliosStudioEmptyState
        icon="i-lucide-shield-check"
        title="Removal and file transactions are not available"
        description="Canonical manifest, registry lock, rollback, conflict handling, and removal-proof contracts remain separate bounded sprints."
      >
        <NuxtLink class="studio-link studio-link--secondary" to="/helios/legacy">Open legacy manager</NuxtLink>
      </HeliosStudioEmptyState>
    </section>
  </div>
</template>
