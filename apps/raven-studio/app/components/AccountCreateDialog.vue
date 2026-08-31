<script setup lang="ts">
import { Dialog } from '@ark-ui/vue/dialog'
import { createCommandIntent, type ListAccountsOutput } from '@raven/domain'

const props = defineProps<{ spaces: ListAccountsOutput['spaces'] }>()
const emit = defineEmits<{ complete: [] }>()
const { pendingCommand } = useRavenActions()
const api = useAccountControlApi()

const form = reactive({
  spaceKey: '',
  accountKey: '',
  name: '',
  bankName: '',
  accountType: 'current',
  currency: 'ZAR',
  normalNature: 'asset' as 'asset' | 'liability',
  liquidityClass: 'liquid' as 'liquid' | 'non_liquid',
  freshnessWindowHours: 72,
})
const submitting = ref(false)
const errorMessage = ref('')
const open = computed(() => pendingCommand.value === 'create-account')
const commandIntent = createCommandIntent()

const close = () => {
  commandIntent.clear()
  pendingCommand.value = null
  errorMessage.value = ''
}

watch(
  open,
  (isOpen) => {
    if (isOpen) commandIntent.begin()
    else commandIntent.clear()
  },
  { immediate: true },
)

const slugify = (value: string) =>
  value
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')

watch(
  () => form.name,
  (name) => {
    if (!form.accountKey || form.accountKey === slugify(name.slice(0, -1))) form.accountKey = slugify(name)
  },
)

watch(
  () => form.accountType,
  (type) => {
    const liability = ['credit_card', 'loan', 'debt'].includes(type)
    form.normalNature = liability ? 'liability' : 'asset'
    form.liquidityClass = ['current', 'savings', 'cash'].includes(type) ? 'liquid' : 'non_liquid'
  },
)

watch(
  () => props.spaces,
  (spaces) => {
    if (!form.spaceKey && spaces[0]) {
      form.spaceKey = spaces[0].key
      form.currency = spaces[0].currency
    }
  },
  { immediate: true },
)

watch(
  () => form.spaceKey,
  (spaceKey) => {
    const space = props.spaces.find((item) => item.key === spaceKey)
    if (space) form.currency = space.currency
  },
)

const submit = async () => {
  errorMessage.value = ''
  submitting.value = true
  try {
    await api.createAccount({
      ...form,
      idempotencyKey: commandIntent.current(),
      channel: 'ui',
    })
    commandIntent.clear()
    close()
    emit('complete')
    Object.assign(form, {
      accountKey: '',
      name: '',
      bankName: '',
      accountType: 'current',
      normalNature: 'asset',
      liquidityClass: 'liquid',
      freshnessWindowHours: 72,
    })
  } catch (error: any) {
    errorMessage.value = error?.message || 'The account could not be created.'
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <Dialog.Root :open="open" @open-change="({ open: nextOpen }) => !nextOpen && close()">
    <Teleport to="body">
      <Dialog.Backdrop class="raven-dialog-backdrop" />
      <Dialog.Positioner class="raven-dialog-positioner">
        <Dialog.Content class="raven-dialog">
          <header class="raven-dialog__header">
            <Dialog.Title class="raven-dialog__title">Create account</Dialog.Title>
            <Dialog.CloseTrigger as-child>
              <button class="raven-icon-button" type="button" aria-label="Close create account dialog">
                <span class="i-lucide-x" aria-hidden="true" />
              </button>
            </Dialog.CloseTrigger>
          </header>
          <form @submit.prevent="submit">
            <div class="raven-dialog__body">
              <div class="raven-form-grid">
                <label class="raven-field raven-field--wide">
                  <span>Financial Space</span>
                  <select v-model="form.spaceKey" required>
                    <option v-for="space in spaces" :key="space.key" :value="space.key">
                      {{ space.name }}
                    </option>
                  </select>
                </label>
                <label class="raven-field">
                  <span>Account name</span>
                  <input v-model="form.name" required autocomplete="off" placeholder="Daily Account" />
                </label>
                <label class="raven-field">
                  <span>Stable key</span>
                  <input v-model="form.accountKey" required autocomplete="off" placeholder="daily-account" />
                </label>
                <label class="raven-field">
                  <span>Institution</span>
                  <input v-model="form.bankName" autocomplete="organization" placeholder="Example Bank" />
                </label>
                <label class="raven-field">
                  <span>Account type</span>
                  <select v-model="form.accountType">
                    <option value="current">Current</option>
                    <option value="savings">Savings</option>
                    <option value="credit_card">Credit card</option>
                    <option value="loan">Loan</option>
                    <option value="debt">Debt</option>
                    <option value="investment">Investment</option>
                    <option value="cash">Cash</option>
                    <option value="other">Other</option>
                  </select>
                </label>
                <label class="raven-field">
                  <span>Economic nature</span>
                  <select v-model="form.normalNature">
                    <option value="asset">Asset</option>
                    <option value="liability">Liability</option>
                  </select>
                </label>
                <label class="raven-field">
                  <span>Liquidity</span>
                  <select v-model="form.liquidityClass">
                    <option value="liquid">Liquid</option>
                    <option value="non_liquid">Non-liquid</option>
                  </select>
                </label>
                <label class="raven-field">
                  <span>Fresh for (hours)</span>
                  <input v-model.number="form.freshnessWindowHours" type="number" min="1" max="8760" step="1" required />
                </label>
                <label class="raven-field">
                  <span>Currency</span>
                  <input v-model="form.currency" readonly />
                </label>
              </div>
              <p v-if="spaces.length === 0" class="raven-form-error">
                Create a Financial Space before adding an account.
              </p>
              <p v-if="errorMessage" class="raven-form-error">{{ errorMessage }}</p>
            </div>
            <footer class="raven-dialog__footer">
              <button class="raven-button" type="button" @click="close">Cancel</button>
              <button class="raven-button raven-button--primary" type="submit" :disabled="submitting || spaces.length === 0">
                <span v-if="submitting" class="i-lucide-loader-circle" aria-hidden="true" />
                <span v-else class="i-lucide-plus" aria-hidden="true" />
                Create account
              </button>
            </footer>
          </form>
        </Dialog.Content>
      </Dialog.Positioner>
    </Teleport>
  </Dialog.Root>
</template>
