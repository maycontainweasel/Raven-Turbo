<script setup lang="ts">
import { Dialog } from '@ark-ui/vue/dialog'

const props = defineProps<{ open: boolean }>()
const emit = defineEmits<{ 'update:open': [value: boolean]; complete: [] }>()
const api = useClientControlApi()

const form = reactive({
  key: '',
  name: '',
  businessName: '',
  contactPerson: '',
  email: '',
  phoneWhatsapp: '',
  websiteDomain: '',
  status: 'active' as 'active' | 'paused' | 'inactive' | 'closed',
  relatedProjects: '',
  orbitClientId: '',
  notes: '',
})
const keyIsManual = ref(false)
const submitting = ref(false)
const errorMessage = ref('')

const slugify = (value: string) => value.trim().toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')

watch(() => form.name, (name) => {
  if (!keyIsManual.value) form.key = slugify(name)
})

const reset = () => {
  Object.assign(form, {
    key: '', name: '', businessName: '', contactPerson: '', email: '', phoneWhatsapp: '',
    websiteDomain: '', status: 'active', relatedProjects: '', orbitClientId: '', notes: '',
  })
  keyIsManual.value = false
  errorMessage.value = ''
}

const close = () => emit('update:open', false)

const submit = async () => {
  submitting.value = true
  errorMessage.value = ''
  try {
    await api.createClient({ ...form })
    emit('complete')
    close()
    reset()
  } catch (error: any) {
    errorMessage.value = error?.message || 'The client could not be created.'
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <Dialog.Root :open="props.open" @open-change="({ open: next }) => !next && close()">
    <Teleport to="body">
      <Dialog.Backdrop class="raven-dialog-backdrop" />
      <Dialog.Positioner class="raven-dialog-positioner">
        <Dialog.Content class="raven-dialog client-dialog">
          <header class="raven-dialog__header">
            <Dialog.Title class="raven-dialog__title">Create client</Dialog.Title>
            <Dialog.CloseTrigger as-child><button class="raven-icon-button" type="button" aria-label="Close create client dialog"><span class="i-lucide-x" /></button></Dialog.CloseTrigger>
          </header>
          <form @submit.prevent="submit">
            <div class="raven-dialog__body raven-form-grid">
              <label class="raven-field"><span>Client name</span><input v-model.trim="form.name" required autocomplete="organization" /></label>
              <label class="raven-field"><span>Stable key</span><input v-model.trim="form.key" required autocomplete="off" @input="keyIsManual = true" /></label>
              <label class="raven-field"><span>Business name <small>optional</small></span><input v-model.trim="form.businessName" /></label>
              <label class="raven-field"><span>Status</span><select v-model="form.status"><option value="active">Active</option><option value="paused">Paused</option><option value="inactive">Inactive</option><option value="closed">Closed</option></select></label>
              <label class="raven-field"><span>Contact person <small>optional</small></span><input v-model.trim="form.contactPerson" autocomplete="name" /></label>
              <label class="raven-field"><span>Email <small>optional</small></span><input v-model.trim="form.email" type="email" autocomplete="email" /></label>
              <label class="raven-field"><span>Phone / WhatsApp <small>optional</small></span><input v-model.trim="form.phoneWhatsapp" autocomplete="tel" /></label>
              <label class="raven-field"><span>Website <small>optional</small></span><input v-model.trim="form.websiteDomain" placeholder="example.com" /></label>
              <label class="raven-field raven-field--wide"><span>Related projects <small>optional</small></span><input v-model.trim="form.relatedProjects" /></label>
              <label class="raven-field raven-field--wide"><span>Notes <small>optional</small></span><textarea v-model.trim="form.notes" rows="3" maxlength="2000" /></label>
              <p v-if="errorMessage" class="raven-form-error raven-field--wide">{{ errorMessage }}</p>
            </div>
            <footer class="raven-dialog__footer"><button class="raven-button" type="button" @click="close">Cancel</button><button class="raven-button raven-button--primary" type="submit" :disabled="submitting"><span class="i-lucide-contact-round" />{{ submitting ? 'Creating…' : 'Create client' }}</button></footer>
          </form>
        </Dialog.Content>
      </Dialog.Positioner>
    </Teleport>
  </Dialog.Root>
</template>

<style scoped>
.client-dialog { width: min(680px, calc(100vw - 24px)); }
.raven-field small { color: var(--raven-muted); font-size: 9px; font-weight: 400; }
</style>
