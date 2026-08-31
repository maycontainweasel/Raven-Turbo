<script setup lang="ts">
import type { CategoryOption, ClassificationOptions, PurposeDirectoryRow, TaxCategoryOption } from '~/composables/useClassificationApi'

useHead({ title: 'Transaction meaning · Raven' })

const api = useClassificationApi()
const search = ref('')
const spaceFilter = ref('all')
const purposeOpen = ref(false)
const categoryOpen = ref(false)
const taxCategoryOpen = ref(false)
const hydrated = ref(false)
onMounted(() => { hydrated.value = true })

const { data, pending, error, refresh } = await useAsyncData<{
  options: ClassificationOptions
  purposes: PurposeDirectoryRow[]
  categories: CategoryOption[]
}>('transaction-meaning-directory', async () => {
  const [options, purposes, categories] = await Promise.all([
    api.getOptions(), api.listPurposes(), api.listCategories(),
  ])
  return { options, purposes, categories }
}, { server: false })

const spaces = computed(() => data.value?.options.spaces ?? [])
const merchants = computed(() => data.value?.options.merchants ?? [])
const purposes = computed(() => (data.value?.purposes ?? []).filter(purpose => purpose.active))
const categories = computed(() => (data.value?.categories ?? []).filter(category => category.active !== false))
const taxCategories = computed<TaxCategoryOption[]>(() => data.value?.options.taxCategories ?? [])
const tags = computed(() => data.value?.options.tags ?? [])

const matches = (values: Array<string | null | undefined>) => {
  const needle = search.value.trim().toLowerCase()
  return !needle || values.filter(Boolean).join(' ').toLowerCase().includes(needle)
}
const filteredPurposes = computed(() => purposes.value.filter(purpose =>
  (spaceFilter.value === 'all' || purpose.spaceKey === spaceFilter.value)
  && matches([purpose.name, purpose.description, purpose.purposeKind, purpose.merchantName, purpose.categoryName, ...(purpose.aliases ?? [])]),
))
const filteredCategories = computed(() => categories.value.filter(category =>
  (spaceFilter.value === 'all' || category.spaceKey === spaceFilter.value)
  && matches([category.name, category.parentName, category.categoryKind, category.notes]),
))
const filteredTaxCategories = computed(() => taxCategories.value.filter(category =>
  (spaceFilter.value === 'all' || category.spaceKey === spaceFilter.value)
  && matches([category.name, category.parentName, category.notes]),
))

const completeCreate = async () => { await refresh() }
</script>

<template>
  <div class="meaning-page">
    <header class="meaning-header">
      <div><p class="raven-eyebrow">Reviewed transaction layer</p><h1>Meaning</h1><p>Reusable purposes, hierarchical budget and tax categories, and occurrence tags that sit above immutable statement truth.</p></div>
      <div class="meaning-header__actions"><button class="raven-button" type="button" :disabled="hydrated && pending" @click="refresh"><span class="i-lucide-refresh-cw" />Refresh</button><button class="raven-button" type="button" @click="taxCategoryOpen = true"><span class="i-lucide-scale" />Create tax category</button><button class="raven-button" type="button" @click="categoryOpen = true"><span class="i-lucide-tags" />Create category</button><button class="raven-button raven-button--primary" type="button" @click="purposeOpen = true"><span class="i-lucide-bookmark-plus" />Create purpose</button></div>
    </header>

    <aside class="meaning-contract raven-surface"><span class="i-lucide-shield-check" /><div><strong>Statement truth remains intact</strong><p>Assigning meaning never replaces the original date, amount, currency, or description. Each review creates a new assignment revision and supersedes the prior current interpretation.</p></div></aside>

    <div v-if="error" class="meaning-error" role="alert"><span>Raven’s meaning records could not be loaded.</span><button class="raven-button" type="button" @click="refresh">Retry</button></div>

    <section class="meaning-controls raven-surface"><label class="meaning-search"><span class="i-lucide-search" /><span class="sr-only">Search meaning records</span><input v-model="search" type="search" placeholder="Search purposes, categories, aliases, or tags…" /></label><label><span>Financial Space</span><select v-model="spaceFilter"><option value="all">All spaces</option><option v-for="space in spaces" :key="space.key" :value="space.key">{{ space.name }}</option></select></label></section>

    <div v-if="hydrated && pending" class="meaning-loading">Loading reviewed meaning…</div>
    <template v-else>
      <section class="meaning-section">
        <header><div><p class="raven-eyebrow">What a payment represents</p><h2>Transaction purposes</h2></div><span>{{ filteredPurposes.length }} records</span></header>
        <div v-if="!filteredPurposes.length" class="raven-empty"><p>No transaction purposes match this view. A purpose can represent something recurring such as “Elite Host hosting fees” or a one-off purchase.</p></div>
        <div v-else class="purpose-grid">
          <article v-for="purpose in filteredPurposes" :key="`${purpose.spaceKey}:${purpose.key}`" class="purpose-card raven-surface">
            <header><div><strong>{{ purpose.name }}</strong><small>{{ purpose.spaceName }} · {{ purpose.purposeKind.replaceAll('_', ' ') }} · {{ purpose.occurrencePattern.replaceAll('_', ' ') }}</small></div><span class="raven-chip">{{ purpose.assignmentCount }} linked</span></header>
            <p>{{ purpose.description || 'No purpose description recorded.' }}</p>
            <dl><div><dt>Default merchant</dt><dd>{{ purpose.merchantName || 'None' }}</dd></div><div><dt>Default category</dt><dd>{{ purpose.categoryName || 'None' }}</dd></div><div><dt>Aliases</dt><dd>{{ purpose.aliases?.join(', ') || 'None' }}</dd></div></dl>
          </article>
        </div>
      </section>

      <section class="meaning-section">
        <header><div><p class="raven-eyebrow">Budget taxonomy</p><h2>Categories</h2></div><span>{{ filteredCategories.length }} records</span></header>
        <div v-if="!filteredCategories.length" class="raven-empty"><p>No categories match this view. Create a broad category first, then use it as the parent of a more specific category.</p></div>
        <div v-else class="category-list raven-surface">
          <div v-for="category in filteredCategories" :key="`${category.spaceKey}:${category.key}`" class="category-row"><span class="category-row__path"><span>{{ category.parentName || 'Top level' }}</span><span v-if="category.parentName">›</span><strong>{{ category.name }}</strong></span><span class="raven-chip">{{ category.categoryKind }}</span><small>{{ spaces.find(space => space.key === category.spaceKey)?.name || category.spaceKey }}</small><p>{{ category.notes || 'No category notes' }}</p></div>
        </div>
      </section>

      <section class="meaning-section">
        <header><div><p class="raven-eyebrow">Separate tax vocabulary</p><h2>Tax categories</h2></div><span>{{ filteredTaxCategories.length }} records</span></header>
        <div v-if="!filteredTaxCategories.length" class="raven-empty"><p>No tax categories match this view. Tax mode inherits the ordinary category until an explicit tax category is declared.</p></div>
        <div v-else class="category-list raven-surface">
          <div v-for="category in filteredTaxCategories" :key="`${category.spaceKey}:${category.key}`" class="category-row"><span class="category-row__path"><span>{{ category.parentName || 'Top level' }}</span><span v-if="category.parentName">›</span><strong>{{ category.name }}</strong></span><span class="raven-chip raven-chip--info">Tax lens</span><small>{{ spaces.find(space => space.key === category.spaceKey)?.name || category.spaceKey }}</small><p>{{ category.notes || 'No vocabulary notes' }}</p></div>
        </div>
        <p class="meaning-boundary">A tax category is a reporting label only. It does not assert deductibility, VAT treatment, professional review, or a filed position.</p>
      </section>

      <section class="meaning-section">
        <header><div><p class="raven-eyebrow">Flexible occurrence context</p><h2>Observed tags</h2></div><span>{{ tags.length }} values</span></header>
        <div class="tag-panel raven-surface"><p>Tags are intentionally lightweight labels on a reviewed transaction occurrence—for example a domain name, family contribution, or legal-report grouping. They are not statement text and do not replace the category hierarchy.</p><div v-if="tags.length" class="tag-cloud"><span v-for="tag in tags" :key="tag" class="raven-chip">{{ tag }}</span></div><small v-else>No tags have been recorded on current confirmed assignments yet.</small></div>
      </section>
    </template>

    <CategoryCreateDialog v-model:open="categoryOpen" :spaces="spaces" :categories="categories" @complete="completeCreate" />
    <TaxCategoryCreateDialog v-model:open="taxCategoryOpen" :spaces="spaces" :categories="taxCategories" @complete="completeCreate" />
    <PurposeCreateDialog v-model:open="purposeOpen" :spaces="spaces" :merchants="merchants" :categories="categories" @complete="completeCreate" />
  </div>
</template>

<style scoped>
.meaning-page { display: grid; gap: 28px; }.meaning-header { display: flex; align-items: flex-start; justify-content: space-between; gap: 24px; }.meaning-header h1 { margin: 6px 0 0; font-size: clamp(30px, 4vw, 42px); }.meaning-header p:last-child { max-width: 760px; margin: 8px 0 0; color: var(--raven-muted); }.meaning-header__actions { display: flex; flex-wrap: wrap; justify-content: flex-end; gap: 8px; }
.meaning-contract { display: flex; gap: 12px; padding: 15px 17px; }.meaning-contract > span { margin-top: 2px; color: var(--raven-success); font-size: 20px; }.meaning-contract strong { font-size: 13px; }.meaning-contract p { margin: 5px 0 0; color: var(--raven-muted); font-size: 12px; }
.meaning-error { display: flex; align-items: center; justify-content: space-between; gap: 16px; border: 1px solid color-mix(in srgb, var(--raven-danger) 42%, transparent); border-radius: var(--raven-radius-md); padding: 12px 14px; color: var(--raven-danger); background: var(--raven-danger-soft); }
.meaning-controls { display: flex; align-items: end; justify-content: space-between; gap: 14px; padding: 12px; }.meaning-controls label { display: grid; gap: 6px; color: var(--raven-muted); font-size: 11px; }.meaning-search { min-width: min(100%, 540px); grid-template-columns: auto 1fr !important; align-items: center; }.meaning-controls input, .meaning-controls select { min-height: 36px; border: 1px solid var(--raven-border); border-radius: var(--raven-radius-sm); padding: 0 11px; color: var(--raven-text); background: var(--raven-bg); }
.meaning-section { display: grid; gap: 14px; }.meaning-section > header { display: flex; align-items: end; justify-content: space-between; gap: 16px; }.meaning-section h2 { margin: 4px 0 0; font-size: 21px; }.meaning-section > header > span { color: var(--raven-muted); font-size: 11px; }
.purpose-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }.purpose-card { display: grid; gap: 14px; padding: 17px; }.purpose-card header { display: flex; justify-content: space-between; gap: 14px; }.purpose-card header > div { display: grid; gap: 4px; }.purpose-card small, .purpose-card p, .purpose-card dt { color: var(--raven-muted); font-size: 11px; }.purpose-card p { margin: 0; }.purpose-card dl { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 10px; margin: 0; }.purpose-card dl div { display: grid; gap: 4px; }.purpose-card dd { margin: 0; font-size: 11px; }
.category-list { overflow: hidden; }.category-row { display: grid; grid-template-columns: minmax(260px, 1.2fr) auto minmax(120px, .45fr) minmax(220px, 1fr); align-items: center; gap: 14px; border-top: 1px solid var(--raven-border); padding: 12px 15px; }.category-row:first-child { border-top: 0; }.category-row__path { display: flex; gap: 7px; }.category-row__path > span { color: var(--raven-muted); }.category-row small, .category-row p { margin: 0; color: var(--raven-muted); font-size: 11px; }
.meaning-boundary { margin: 0; color: var(--raven-muted); font-size: 11px; }
.tag-panel { display: grid; gap: 13px; padding: 17px; }.tag-panel p { max-width: 900px; margin: 0; color: var(--raven-muted); font-size: 12px; }.tag-panel small { color: var(--raven-muted); }.tag-cloud { display: flex; flex-wrap: wrap; gap: 6px; }.meaning-loading { color: var(--raven-muted); }
@media (max-width: 860px) { .purpose-grid { grid-template-columns: 1fr; }.category-row { grid-template-columns: 1fr auto; }.category-row p { grid-column: 1 / -1; } }
@media (max-width: 650px) { .meaning-header, .meaning-controls { flex-direction: column; align-items: stretch; }.meaning-header__actions { justify-content: flex-start; }.purpose-card dl { grid-template-columns: 1fr; } }
</style>
