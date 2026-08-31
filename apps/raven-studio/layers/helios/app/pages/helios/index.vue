<script setup lang="ts">
definePageMeta({
  ssr: false,
  layout: 'helios-studio',
})

const summaries = [
  {
    title: 'Foundations',
    description: 'Typography, colors, themes, spacing, and breakpoint generation remain operational in the legacy manager.',
    icon: 'i-lucide-swatch-book',
    status: 'Legacy active',
    tone: 'success' as const,
    to: '/helios/foundations',
  },
  {
    title: 'Components',
    description: 'Field and Input have contracts and a playground. Button and Select establish the next catalogue boundary.',
    icon: 'i-lucide-boxes',
    status: 'Prototype',
    tone: 'info' as const,
    to: '/helios/components',
  },
  {
    title: 'Build',
    description: 'App-owned manifests, generated Atomic payloads, registry locks, and component diffs remain deliberately unimplemented.',
    icon: 'i-lucide-package-check',
    status: 'App-owned later',
    tone: 'warning' as const,
    to: '/helios/build',
  },
]
</script>

<template>
  <div>
    <HeliosStudioPageHeader
      title="Design System Studio"
      description="A removable control plane for shaping Atomic foundations, inspecting component contracts, and preparing explicit app-owned output."
      status="Shell v2"
      status-tone="info"
    >
      <template #actions>
        <NuxtLink class="studio-link studio-link--secondary" to="/helios/legacy">
          <span class="i-lucide-history" aria-hidden="true" />
          Legacy manager
        </NuxtLink>
        <NuxtLink class="studio-link" to="/helios/design">
          <span class="i-lucide-panels-top-left" aria-hidden="true" />
          Open prototype
        </NuxtLink>
      </template>
    </HeliosStudioPageHeader>

    <section id="studio-doctrine" class="studio-section">
      <div class="studio-doctrine">
        <strong>The Studio is removable. The artifacts it commits belong to the application.</strong>
        <p>Shell v2 establishes product structure only. Canonical manifests, registry locks, file transactions, and removal proof remain bounded follow-up contracts.</p>
      </div>
    </section>

    <section id="system-status" class="studio-section" aria-labelledby="overview-status-heading">
      <div class="studio-section__head">
        <div>
          <h2 id="overview-status-heading">System status</h2>
          <p>Current surfaces and the boundary each one owns during migration.</p>
        </div>
        <HeliosStudioStatusBadge label="DEC-0003 accepted" tone="success" />
      </div>
      <div class="studio-summary-grid">
        <article v-for="summary in summaries" :key="summary.title" class="studio-card">
          <span class="studio-card__icon" aria-hidden="true">
            <span :class="summary.icon" />
          </span>
          <h2>{{ summary.title }}</h2>
          <p>{{ summary.description }}</p>
          <div class="studio-card__meta">
            <HeliosStudioStatusBadge :label="summary.status" :tone="summary.tone" />
            <NuxtLink class="studio-text-link" :to="summary.to">
              Inspect
              <span class="i-lucide-arrow-right" aria-hidden="true" />
            </NuxtLink>
          </div>
        </article>
      </div>
    </section>

    <section id="accepted-ownership" class="studio-section" aria-labelledby="ownership-heading">
      <div class="studio-section__head">
        <div>
          <h2 id="ownership-heading">Accepted ownership</h2>
          <p>The durable system and removable tools now have explicit responsibilities.</p>
        </div>
      </div>
      <dl class="studio-definition-list">
        <div>
          <dt>Atomic Runtime</dt>
          <dd>Durable tokens, utilities, Uno integration, themes, and generated output.</dd>
        </div>
        <div>
          <dt>Design System Studio</dt>
          <dd>Removable management, registry, preview, diff, and commit tooling.</dd>
        </div>
        <div>
          <dt>Helios Authoring</dt>
          <dd>Separate removable page and component authoring, with its own output-preview contract.</dd>
        </div>
      </dl>
    </section>
  </div>
</template>
