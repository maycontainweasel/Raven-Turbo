<script setup lang="ts">
import { Dialog } from '@ark-ui/vue/dialog'
import type { FinancialSpaceOption } from '~/composables/useClassificationApi'

const props = defineProps<{ open: boolean; spaces: FinancialSpaceOption[] }>()
const emit = defineEmits<{ 'update:open': [value: boolean]; complete: [] }>()
const api = useClassificationApi()
const form = reactive({ space: '', key: '', name: '', normalizedName: '', notes: '' })
const keyIsManual = ref(false)
const normalizedNameIsManual = ref(false)
const submitting = ref(false)
const errorMessage = ref('')
const slugify = (value: string) => value.trim().toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')

watch(() => form.name, (name) => {
  if (!keyIsManual.value) form.key = slugify(name)
  if (!normalizedNameIsManual.value) form.normalizedName = name.trim()
})
watch(() => props.spaces, spaces => { if (!form.space && spaces[0]) form.space = spaces[0].key }, { immediate: true })

const close = () => emit('update:open', false)
const submit = async () => {
  submitting.value = true
  errorMessage.value = ''
  try {
    await api.createMerchant({ ...form, active: true })
    emit('complete')
    close()
    Object.assign(form, { key: '', name: '', normalizedName: '', notes: '' })
    keyIsManual.value = false
    normalizedNameIsManual.value = false
  } catch (error: any) {
    errorMessage.value = error?.message || 'The merchant could not be created.'
  } finally { submitting.value = false }
}
</script>

<template>
  <Dialog.Root :open="props.open" @open-change="({ open: next }) => !next && close()">
    <Teleport to="body"><Dialog.Backdrop class="raven-dialog-backdrop" /><Dialog.Positioner class="raven-dialog-positioner"><Dialog.Content class="raven-dialog">
      <header class="raven-dialog__header"><Dialog.Title class="raven-dialog__title">Create merchant or counterparty</Dialog.Title><Dialog.CloseTrigger as-child><button class="raven-icon-button" type="button" aria-label="Close merchant dialog"><span class="i-lucide-x" /></button></Dialog.CloseTrigger></header>
      <form @submit.prevent="submit"><div class="raven-dialog__body raven-form-grid">
        <label class="raven-field raven-field--wide"><span>Financial Space</span><select v-model="form.space" required><option v-for="space in spaces" :key="space.key" :value="space.key">{{ space.name }} · {{ space.currency }}</option></select></label>
        <label class="raven-field"><span>Name</span><input v-model.trim="form.name" required /></label>
        <label class="raven-field"><span>Stable key</span><input v-model.trim="form.key" required @input="keyIsManual = true" /></label>
        <label class="raven-field raven-field--wide"><span>Normalized statement name <small>optional</small></span><input v-model.trim="form.normalizedName" @input="normalizedNameIsManual = true" /></label>
        <label class="raven-field raven-field--wide"><span>Notes <small>optional</small></span><textarea v-model.trim="form.notes" rows="3" maxlength="2000" /></label>
        <p v-if="errorMessage" class="raven-form-error raven-field--wide">{{ errorMessage }}</p>
      </div><footer class="raven-dialog__footer"><button class="raven-button" type="button" @click="close">Cancel</button><button class="raven-button raven-button--primary" type="submit" :disabled="submitting || !spaces.length"><span class="i-lucide-store" />{{ submitting ? 'Creating…' : 'Create merchant' }}</button></footer></form>
    </Dialog.Content></Dialog.Positioner></Teleport>
  </Dialog.Root>
</template>
