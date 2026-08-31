<script setup lang="ts">
definePageMeta({ ssr: false, layout: 'helios-studio' })

const agentSurfaces = [
  { id: 'cookbook', title: 'Cookbook', description: 'Generated project-specific guidance derived from committed artifacts.', icon: 'i-lucide-book-open-check', status: 'Prototype docs' },
  { id: 'capabilities', title: 'Capabilities', description: 'Explicit operations available to agents for each installed component family.', icon: 'i-lucide-list-checks', status: 'Planned' },
  { id: 'mcp-status', title: 'MCP Status', description: 'Read and write authorization, validation, and audit status for future agent tooling.', icon: 'i-lucide-plug-zap', status: 'Planned' },
]
</script>

<template>
  <div>
    <HeliosStudioPageHeader
      title="Agents"
      description="Agent behavior must follow committed project truth and explicit capabilities rather than inventing component or styling conventions."
      status="Read model first"
      status-tone="info"
    />

    <section class="studio-section" aria-label="Agent surfaces">
      <div class="studio-agent-grid">
        <article v-for="surface in agentSurfaces" :id="surface.id" :key="surface.id" class="studio-card">
          <span class="studio-card__icon" aria-hidden="true">
            <span :class="surface.icon" />
          </span>
          <h2>{{ surface.title }}</h2>
          <p>{{ surface.description }}</p>
          <div class="studio-card__meta">
            <HeliosStudioStatusBadge :label="surface.status" :tone="surface.id === 'cookbook' ? 'info' : 'warning'" />
          </div>
        </article>
      </div>
    </section>

    <section id="agent-doctrine" class="studio-section">
      <div class="studio-doctrine">
        <strong>Agents operate through the language.</strong>
        <p>Future MCP writes require explicit authorization, validation, visible diffs, conflict policy, and app-owned canonical artifacts. Shell v2 adds no write capability.</p>
      </div>
    </section>
  </div>
</template>
