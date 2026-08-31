<script setup lang="ts">
definePageMeta({ ssr: false, layout: 'helios-studio' })
</script>

<template>
  <div>
    <HeliosStudioPageHeader
      title="Themes"
      description="Semantic presets package Atomic language without replacing its typography, rhythm, or utility foundations."
      status="1 preset"
      status-tone="success"
    />

    <section id="orbit-dark" class="studio-section">
      <article class="studio-preset-preview" data-theme="orbit-dark">
        <div class="studio-preset-preview__copy">
          <div>
            <p class="studio-eyebrow">Active presentation preset</p>
            <h2>Orbit Dark</h2>
            <p>A focused dark application baseline for dashboards, agents, task surfaces, builders, and operational workspaces.</p>
          </div>
          <div class="studio-page-header__actions">
            <HeliosStudioStatusBadge label="v0 proposed semantics" tone="info" />
            <NuxtLink class="studio-link" to="/helios/design">
              Open visual prototype
              <span class="i-lucide-arrow-right" aria-hidden="true" />
            </NuxtLink>
          </div>
        </div>
        <div class="studio-preset-preview__sample">
          <div class="studio-swatch-strip" aria-label="Orbit Dark surface and accent samples">
            <span style="background: var(--ds-bg-root)" />
            <span style="background: var(--ds-bg-surface)" />
            <span style="background: var(--ds-bg-muted)" />
            <span style="background: var(--ds-accent)" />
            <span style="background: var(--ds-success)" />
          </div>
          <label for="theme-preview-field" class="studio-eyebrow">Field preview</label>
          <input id="theme-preview-field" class="ds-field" value="Semantic control" readonly>
          <div class="studio-page-header__actions">
            <button class="ds-button ds-button-primary" type="button">Primary</button>
            <button class="ds-button ds-button-secondary" type="button">Secondary</button>
          </div>
        </div>
      </article>
    </section>
  </div>
</template>
