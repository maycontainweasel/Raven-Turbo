<script setup lang="ts">
import { Dialog } from '@ark-ui/vue/dialog'
import type { CategoryOption, FinancialSpaceOption } from '~/composables/useClassificationApi'

const props = defineProps<{ open: boolean; spaces: FinancialSpaceOption[]; categories: CategoryOption[] }>()
const emit = defineEmits<{ 'update:open': [value: boolean]; complete: [] }>()
const api = useClassificationApi()
const form = reactive({ space: '', key: '', name: '', categoryKind: 'expense', parentKey: '', notes: '' })
const keyIsManual = ref(false)
const submitting = ref(false)
const errorMessage = ref('')
const slugify = (value: string) => value.trim().toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')
const parentOptions = computed(() => props.categories.filter(category => category.spaceKey === form.space))
watch(() => form.name, name => { if (!keyIsManual.value) form.key = slugify(name) })
watch(() => props.spaces, spaces => { if (!form.space && spaces[0]) form.space = spaces[0].key }, { immediate: true })
watch(() => form.space, () => { if (!parentOptions.value.some(item => item.key === form.parentKey)) form.parentKey = '' })
const close = () => emit('update:open', false)
const submit = async () => {
  submitting.value = true; errorMessage.value = ''
  try {
    const parent = parentOptions.value.find(item => item.key === form.parentKey)
    await api.createCategory({
      space: form.space, key: form.key, name: form.name, categoryKind: form.categoryKind,
      parentCategory: parent?.id, active: true, notes: form.notes,
    })
    emit('complete'); close(); Object.assign(form, { key: '', name: '', parentKey: '', notes: '' }); keyIsManual.value = false
  } catch (error: any) { errorMessage.value = error?.message || 'The category could not be created.' }
  finally { submitting.value = false }
}
</script>

<template>
  <Dialog.Root :open="props.open" @open-change="({ open: next }) => !next && close()"><Teleport to="body"><Dialog.Backdrop class="raven-dialog-backdrop" /><Dialog.Positioner class="raven-dialog-positioner"><Dialog.Content class="raven-dialog">
    <header class="raven-dialog__header"><Dialog.Title class="raven-dialog__title">Create category</Dialog.Title><Dialog.CloseTrigger as-child><button class="raven-icon-button" type="button" aria-label="Close category dialog"><span class="i-lucide-x" /></button></Dialog.CloseTrigger></header>
    <form @submit.prevent="submit"><div class="raven-dialog__body raven-form-grid">
      <label class="raven-field raven-field--wide"><span>Financial Space</span><select v-model="form.space" required><option v-for="space in spaces" :key="space.key" :value="space.key">{{ space.name }}</option></select></label>
      <label class="raven-field"><span>Name</span><input v-model.trim="form.name" required /></label><label class="raven-field"><span>Stable key</span><input v-model.trim="form.key" required @input="keyIsManual = true" /></label>
      <label class="raven-field"><span>Broad kind</span><select v-model="form.categoryKind"><option value="income">Income</option><option value="expense">Expense</option><option value="transfer">Transfer</option><option value="savings">Savings</option><option value="other">Other</option></select></label>
      <label class="raven-field"><span>Parent category <small>optional</small></span><select v-model="form.parentKey"><option value="">Top level</option><option v-for="category in parentOptions" :key="category.id" :value="category.key">{{ category.parentName ? `${category.parentName} › ` : '' }}{{ category.name }}</option></select></label>
      <label class="raven-field raven-field--wide"><span>Notes <small>optional</small></span><textarea v-model.trim="form.notes" rows="3" /></label><p v-if="errorMessage" class="raven-form-error raven-field--wide">{{ errorMessage }}</p>
    </div><footer class="raven-dialog__footer"><button class="raven-button" type="button" @click="close">Cancel</button><button class="raven-button raven-button--primary" type="submit" :disabled="submitting || !spaces.length"><span class="i-lucide-tags" />{{ submitting ? 'Creating…' : 'Create category' }}</button></footer></form>
  </Dialog.Content></Dialog.Positioner></Teleport></Dialog.Root>
</template>
