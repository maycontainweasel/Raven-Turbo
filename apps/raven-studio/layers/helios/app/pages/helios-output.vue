<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import type { HeliosPageManifest } from '@helios/protocol'
import { useHeliosRuntimeStore } from '../stores/heliosRuntime'

definePageMeta({
  ssr: false,
  layout: false,
})

const route = useRoute()
const runtime = useHeliosRuntimeStore()
const manifest = ref<HeliosPageManifest | null>(null)
const pending = ref(true)
const errorMessage = ref('')

const documentId = computed(() => String(route.query.documentId || 'page:home'))
const zoneId = computed(() => String(route.query.zoneId || 'home-main'))
const canvas = computed(() => runtime.canvasForZone(documentId.value, zoneId.value))
const outputLabel = computed(() => `${documentId.value} / ${zoneId.value}`)
const hasManifestNodes = computed(() => Boolean(manifest.value?.nodes.length))

const queryNumber = (value: unknown, fallback: number) => {
  const parsed = Number(Array.isArray(value) ? value[0] : value)
  return Number.isFinite(parsed) && parsed > 0 ? parsed : fallback
}

const manifestBody = computed(() => {
  const rows = queryNumber(route.query.rows, canvas.value.rows)
  const rowPx = queryNumber(route.query.rowPx, canvas.value.rowPx)
  return {
    documentId: documentId.value,
    zoneId: zoneId.value,
    cols: queryNumber(route.query.cols, canvas.value.cols),
    rows,
    canvasHeight: queryNumber(route.query.canvasHeight, rows * rowPx),
  }
})

const buildManifest = async () => {
  pending.value = true
  errorMessage.value = ''
  try {
    manifest.value = await $fetch<HeliosPageManifest>('/api/helios/manifest/build', {
      method: 'POST',
      body: manifestBody.value,
    })
  } catch (error: any) {
    manifest.value = null
    errorMessage.value = error?.data?.message || error?.message || 'Could not build Helios output preview.'
  } finally {
    pending.value = false
  }
}

onMounted(buildManifest)

watch(() => route.fullPath, () => {
  buildManifest()
})
</script>

<template>
  <main
    class="helios-output-preview"
    :data-helios-document="documentId"
    :data-helios-zone="zoneId"
  >
    <div class="helios-output-preview__meta" aria-label="Output preview scope">
      {{ outputLabel }}
    </div>
    <HeliosManifestPage
      v-if="manifest"
      :manifest="manifest"
    />
    <div
      v-if="manifest && !hasManifestNodes"
      class="helios-output-preview__status is-empty"
    >
      <strong>Empty output preview</strong>
      <p>{{ outputLabel }}</p>
    </div>
    <div v-if="!manifest" class="helios-output-preview__status">
      <strong>{{ pending ? 'Building output preview' : 'Output preview unavailable' }}</strong>
      <p>{{ outputLabel }}</p>
      <p v-if="errorMessage">
        {{ errorMessage }}
      </p>
      <button v-if="errorMessage" type="button" @click="buildManifest">
        Retry
      </button>
    </div>
  </main>
</template>

<style scoped>
.helios-output-preview {
  position: relative;
  min-height: 100vh;
  width: 100%;
  margin: 0;
  color: #0f172a;
  background: #ffffff;
}

.helios-output-preview__meta {
  position: fixed;
  top: 8px;
  left: 8px;
  z-index: 10;
  max-width: min(420px, calc(100vw - 16px));
  padding: 4px 7px;
  border: 1px solid rgba(148, 163, 184, 0.28);
  border-radius: 6px;
  color: rgba(51, 65, 85, 0.72);
  background: rgba(255, 255, 255, 0.72);
  font-size: 10px;
  font-weight: 800;
  line-height: 1;
  pointer-events: none;
}

.helios-output-preview__status {
  display: grid;
  place-items: center;
  min-height: 100vh;
  padding: 24px;
  color: #334155;
  text-align: center;
}

.helios-output-preview__status.is-empty {
  position: absolute;
  inset: 0;
  pointer-events: none;
}

.helios-output-preview__status strong {
  color: #0f172a;
  font-size: 14px;
  font-weight: 900;
}

.helios-output-preview__status p {
  max-width: 520px;
  margin: 8px 0 0;
  color: #64748b;
  font-size: 13px;
  font-weight: 650;
}

.helios-output-preview__status button {
  height: 30px;
  margin-top: 14px;
  padding: 0 12px;
  border: 0;
  border-radius: 6px;
  color: #ffffff;
  background: #2557d6;
  font-size: 12px;
  font-weight: 900;
  cursor: pointer;
}
</style>
