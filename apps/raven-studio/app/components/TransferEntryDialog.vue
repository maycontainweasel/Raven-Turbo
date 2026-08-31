<script setup lang="ts">
import { Dialog } from '@ark-ui/vue/dialog'
import { createCommandIntent, parseDecimalMoney, type AccountSummary } from '@raven/domain'

const props = defineProps<{ accounts: AccountSummary[] }>()
const emit = defineEmits<{ complete: [] }>()
const api = useAccountControlApi()
const { pendingCommand, commandAccount } = useRavenActions()
const commandIntent = createCommandIntent()
const sourceValue = ref('')
const targetValue = ref('')
const amount = ref('')
const postedAt = ref('')
const description = ref('')
const submitting = ref(false)
const errorMessage = ref('')
const open = computed(() => pendingCommand.value === 'record-transfer')
const valueFor = (account: AccountSummary) => `${account.spaceKey}\u0000${account.accountKey}`
const sourceAccount = computed(() => props.accounts.find((account) => valueFor(account) === sourceValue.value) ?? null)
const targetAccount = computed(() => props.accounts.find((account) => valueFor(account) === targetValue.value) ?? null)
const targetAccounts = computed(() => props.accounts.filter(
  (account) => sourceAccount.value && account.id !== sourceAccount.value.id && account.currency === sourceAccount.value.currency,
))

const localDate = () => {
  const now = new Date()
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
}

watch(open, (isOpen) => {
  commandIntent.clear()
  if (!isOpen) return
  commandIntent.begin()
  const preselected = commandAccount.value
    ? props.accounts.find((account) => account.spaceKey === commandAccount.value?.spaceKey && account.accountKey === commandAccount.value?.accountKey)
    : null
  const source = preselected ?? props.accounts[0]
  sourceValue.value = source ? valueFor(source) : ''
  targetValue.value = ''
  amount.value = ''
  postedAt.value = localDate()
  description.value = ''
  errorMessage.value = ''
}, { immediate: true })

watch(targetAccounts, (accounts) => {
  if (!accounts.some((account) => valueFor(account) === targetValue.value)) {
    targetValue.value = accounts[0] ? valueFor(accounts[0]) : ''
  }
}, { immediate: true })

const close = () => {
  commandIntent.clear()
  pendingCommand.value = null
  commandAccount.value = null
  errorMessage.value = ''
}

const submit = async () => {
  if (!sourceAccount.value || !targetAccount.value) return
  submitting.value = true
  errorMessage.value = ''
  try {
    await api.recordTransfer({
      idempotencyKey: commandIntent.current(),
      channel: 'ui',
      source: { spaceKey: sourceAccount.value.spaceKey, accountKey: sourceAccount.value.accountKey },
      target: { spaceKey: targetAccount.value.spaceKey, accountKey: targetAccount.value.accountKey },
      money: parseDecimalMoney(amount.value, sourceAccount.value.currency),
      postedAt: postedAt.value,
      description: description.value || undefined,
    })
    commandIntent.clear()
    emit('complete')
    close()
  } catch (error: any) {
    errorMessage.value = error?.message || 'The transfer could not be recorded.'
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
            <Dialog.Title class="raven-dialog__title">Record transfer</Dialog.Title>
            <Dialog.CloseTrigger as-child>
              <button class="raven-icon-button" type="button" aria-label="Close transfer dialog">
                <span class="i-lucide-x" aria-hidden="true" />
              </button>
            </Dialog.CloseTrigger>
          </header>
          <form @submit.prevent="submit">
            <div class="raven-dialog__body">
              <div class="raven-form-grid">
                <label class="raven-field raven-field--wide">
                  <span>From</span>
                  <select v-model="sourceValue" required>
                    <option v-for="account in accounts" :key="account.id" :value="valueFor(account)">
                      {{ account.name }} · {{ account.currency }}
                    </option>
                  </select>
                </label>
                <label class="raven-field raven-field--wide">
                  <span>To</span>
                  <select v-model="targetValue" required>
                    <option v-for="account in targetAccounts" :key="account.id" :value="valueFor(account)">
                      {{ account.name }}
                    </option>
                  </select>
                </label>
                <label class="raven-field">
                  <span>Amount ({{ sourceAccount?.currency || '—' }})</span>
                  <input v-model="amount" inputmode="decimal" required autocomplete="off" placeholder="0.00" />
                </label>
                <label class="raven-field">
                  <span>Financial date</span>
                  <input v-model="postedAt" type="date" required />
                </label>
                <label class="raven-field raven-field--wide">
                  <span>Description (optional)</span>
                  <input v-model="description" autocomplete="off" placeholder="Transfer purpose" />
                </label>
              </div>
              <p v-if="sourceAccount && targetAccounts.length === 0" class="raven-form-note">No other tracked account uses {{ sourceAccount.currency }}.</p>
              <p v-if="errorMessage" class="raven-form-error">{{ errorMessage }}</p>
            </div>
            <footer class="raven-dialog__footer">
              <button class="raven-button" type="button" @click="close">Cancel</button>
              <button class="raven-button raven-button--primary" type="submit" :disabled="submitting || !targetAccount">
                <span class="i-lucide-arrow-left-right" aria-hidden="true" />
                Record transfer
              </button>
            </footer>
          </form>
        </Dialog.Content>
      </Dialog.Positioner>
    </Teleport>
  </Dialog.Root>
</template>
