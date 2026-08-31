<script setup lang="ts">
definePageMeta({ ssr: false, layout: 'helios-studio' })

const artifacts = [
  { id: 'manifest', path: 'app/atomic/design-system.json', description: 'Canonical project design-system configuration.' },
  { id: 'registry-lock', path: 'app/atomic/registry.lock.json', description: 'Committed component provenance, capabilities, checksums, and modification state.' },
  { id: 'tokens', path: 'app/atomic/generated/tokens.css', description: 'App-owned semantic token output.' },
  { id: 'recipes', path: 'app/atomic/generated/recipes.css', description: 'App-owned component recipe output.' },
  { id: 'uno-payload', path: 'app/atomic/generated/uno.generated.ts', description: 'Host-consumed Atomic and Uno payload.' },
  { id: 'agent-cookbook', path: 'app/atomic/generated/agent-cookbook.json', description: 'Project-specific instructions generated from committed design truth.' },
  { id: 'types', path: 'app/atomic/generated/design-system.types.ts', description: 'Typed design-system contract for application code and agents.' },
]
</script>

<template>
  <div>
    <HeliosStudioPageHeader
      title="Build"
      description="The future inspection and transaction surface for app-owned design-system output. Shell v2 writes no artifacts."
      status="No writes"
      status-tone="warning"
    />

    <section class="studio-section" aria-labelledby="artifact-targets-heading">
      <div class="studio-section__head">
        <div>
          <h2 id="artifact-targets-heading">Proposed artifact targets</h2>
          <p>Target direction accepted by DEC-0003; exact schemas and transaction mechanics remain provisional.</p>
        </div>
      </div>
      <div class="studio-artifact-list">
        <HeliosStudioArtifactStatus
          v-for="artifact in artifacts"
          :id="artifact.id"
          :key="artifact.path"
          :path="artifact.path"
          :description="artifact.description"
        />
      </div>
    </section>

    <section id="component-diff" class="studio-section">
      <HeliosStudioEmptyState
        icon="i-lucide-file-diff"
        title="Component diff transaction"
        description="Future commits must expose file changes, dependencies, Atomic requirements, conflicts, tests, and registry-lock changes before writing."
      />
    </section>
  </div>
</template>
