<script setup lang="ts">
import { Dialog } from '@ark-ui/vue/dialog'
import type { CategoryOption, FinancialSpaceOption, MerchantOption } from '~/composables/useClassificationApi'

const props = defineProps<{ open: boolean; spaces: FinancialSpaceOption[]; merchants: MerchantOption[]; categories: CategoryOption[] }>()
const emit = defineEmits<{ 'update:open': [value: boolean]; complete: [] }>()
const api = useClassificationApi()
const form = reactive({ space: '', key: '', name: '', description: '', purposeKind: 'other', occurrencePattern: 'unknown', merchantKey: '', categoryKey: '', aliases: '', notes: '' })
const keyIsManual = ref(false)
const submitting = ref(false)
const errorMessage = ref('')
const slugify = (value: string) => value.trim().toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')
const merchantOptions = computed(() => props.merchants.filter(item => item.spaceKey === form.space))
const categoryOptions = computed(() => props.categories.filter(item => item.spaceKey === form.space))
watch(() => form.name, name => { if (!keyIsManual.value) form.key = slugify(name) })
watch(() => props.spaces, spaces => { if (!form.space && spaces[0]) form.space = spaces[0].key }, { immediate: true })
watch(() => form.space, () => { form.merchantKey = ''; form.categoryKey = '' })
const close = () => emit('update:open', false)
const submit = async () => {
  submitting.value = true; errorMessage.value = ''
  try {
    const merchant = merchantOptions.value.find(item => item.key === form.merchantKey)
    const category = categoryOptions.value.find(item => item.key === form.categoryKey)
    await api.createPurpose({
      space: form.space, key: form.key, name: form.name, description: form.description,
      purposeKind: form.purposeKind, occurrencePattern: form.occurrencePattern,
      defaultMerchant: merchant?.id, defaultCategory: category?.id,
      aliases: form.aliases.split(',').map(item => item.trim()).filter(Boolean), active: true, notes: form.notes,
    })
    emit('complete'); close(); Object.assign(form, { key: '', name: '', description: '', merchantKey: '', categoryKey: '', aliases: '', notes: '' }); keyIsManual.value = false
  } catch (error: any) { errorMessage.value = error?.message || 'The purpose could not be created.' }
  finally { submitting.value = false }
}
</script>

<template>
  <Dialog.Root :open="props.open" @open-change="({ open: next }) => !next && close()"><Teleport to="body"><Dialog.Backdrop class="raven-dialog-backdrop" /><Dialog.Positioner class="raven-dialog-positioner"><Dialog.Content class="raven-dialog purpose-dialog">
    <header class="raven-dialog__header"><Dialog.Title class="raven-dialog__title">Create transaction purpose</Dialog.Title><Dialog.CloseTrigger as-child><button class="raven-icon-button" type="button" aria-label="Close purpose dialog"><span class="i-lucide-x" /></button></Dialog.CloseTrigger></header>
    <form @submit.prevent="submit"><div class="raven-dialog__body raven-form-grid">
      <label class="raven-field raven-field--wide"><span>Financial Space</span><select v-model="form.space" required><option v-for="space in spaces" :key="space.key" :value="space.key">{{ space.name }}</option></select></label>
      <label class="raven-field"><span>Name</span><input v-model.trim="form.name" required placeholder="Elite Host hosting fees" /></label><label class="raven-field"><span>Stable key</span><input v-model.trim="form.key" required @input="keyIsManual = true" /></label>
      <label class="raven-field"><span>Purpose kind</span><select v-model="form.purposeKind"><option value="subscription">Subscription</option><option value="service">Service</option><option value="bank_fee">Bank fee</option><option value="family_support">Family support</option><option value="housing">Housing</option><option value="education">Education</option><option value="trading_funding">Trading funding</option><option value="transfer_purpose">Transfer purpose</option><option value="income_source">Income source</option><option value="purchase">Purchase</option><option value="other">Other</option></select></label>
      <label class="raven-field"><span>Pattern</span><select v-model="form.occurrencePattern"><option value="recurring">Recurring</option><option value="one_off">One-off</option><option value="irregular">Irregular</option><option value="unknown">Unknown</option></select></label>
      <label class="raven-field"><span>Default merchant <small>optional</small></span><select v-model="form.merchantKey"><option value="">None</option><option v-for="merchant in merchantOptions" :key="merchant.id" :value="merchant.key">{{ merchant.name }}</option></select></label>
      <label class="raven-field"><span>Default category <small>optional</small></span><select v-model="form.categoryKey"><option value="">None</option><option v-for="category in categoryOptions" :key="category.id" :value="category.key">{{ category.parentName ? `${category.parentName} › ` : '' }}{{ category.name }}</option></select></label>
      <label class="raven-field raven-field--wide"><span>Description</span><input v-model.trim="form.description" placeholder="What this recognizable payment represents" /></label>
      <label class="raven-field raven-field--wide"><span>Aliases <small>comma separated</small></span><input v-model.trim="form.aliases" placeholder="elitehost, paypal elite host" /></label>
      <label class="raven-field raven-field--wide"><span>Notes <small>optional</small></span><textarea v-model.trim="form.notes" rows="3" /></label><p v-if="errorMessage" class="raven-form-error raven-field--wide">{{ errorMessage }}</p>
    </div><footer class="raven-dialog__footer"><button class="raven-button" type="button" @click="close">Cancel</button><button class="raven-button raven-button--primary" type="submit" :disabled="submitting || !spaces.length"><span class="i-lucide-bookmark-plus" />{{ submitting ? 'Creating…' : 'Create purpose' }}</button></footer></form>
  </Dialog.Content></Dialog.Positioner></Teleport></Dialog.Root>
</template>

<style scoped>.purpose-dialog { width: min(720px, calc(100vw - 24px)); }.raven-field small { color: var(--raven-muted); font-size: 9px; font-weight: 400; }</style>
