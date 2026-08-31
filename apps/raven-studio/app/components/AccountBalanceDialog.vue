<script setup lang="ts">
import { Dialog } from '@ark-ui/vue/dialog'
import {
  createCommandIntent,
  parseDecimalMoney,
  type AccountSummary,
  type BalanceKind,
} from '@raven/domain'

const props = defineProps<{ account: AccountSummary | null }>()
const emit = defineEmits<{ close: []; complete: [] }>()
const api = useAccountControlApi()
const amount = ref('')
const balanceKind = ref<BalanceKind>('ledger')
const economicNature = ref<'asset' | 'liability' | 'informational'>('asset')
const asOf = ref('')
const note = ref('')
const submitting = ref(false)
const errorMessage = ref('')
const commandIntent = createCommandIntent()

const close = () => {
  commandIntent.clear()
  emit('close')
}

const localDateTime = (date = new Date()) => {
  const local = new Date(date.getTime() - date.getTimezoneOffset() * 60_000)
  return local.toISOString().slice(0, 16)
}

watch(
  () => props.account,
  (account) => {
    commandIntent.clear()
    if (!account) return
    commandIntent.begin()
    balanceKind.value = account.normalNature === 'liability'
      ? 'outstanding'
      : account.accountType === 'investment'
        ? 'market_value'
        : 'available'
    economicNature.value = account.normalNature
    amount.value = ''
    asOf.value = localDateTime()
    note.value = ''
    errorMessage.value = ''
  },
  { immediate: true },
)

watch(balanceKind, (kind) => {
  if (!props.account) return
  if (kind === 'outstanding') economicNature.value = 'liability'
  else if (kind === 'market_value') economicNature.value = 'asset'
  else if (kind === 'available' && props.account.normalNature === 'liability') economicNature.value = 'informational'
  else economicNature.value = props.account.normalNature
})

const submit = async () => {
  if (!props.account) return
  errorMessage.value = ''
  submitting.value = true
  try {
    await api.confirmAccountBalance({
      idempotencyKey: commandIntent.current(),
      channel: 'ui',
      spaceKey: props.account.spaceKey,
      accountKey: props.account.accountKey,
      balanceKind: balanceKind.value,
      money: parseDecimalMoney(amount.value, props.account.currency),
      economicNature: economicNature.value,
      asOf: new Date(asOf.value).toISOString(),
      note: note.value || undefined,
    })
    commandIntent.clear()
    emit('complete')
    close()
  } catch (error: any) {
    errorMessage.value = error?.message || 'The balance could not be confirmed.'
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <Dialog.Root :open="Boolean(account)" @open-change="({ open }) => !open && close()">
    <Teleport to="body">
      <Dialog.Backdrop class="raven-dialog-backdrop" />
      <Dialog.Positioner class="raven-dialog-positioner">
        <Dialog.Content v-if="account" class="raven-dialog">
          <header class="raven-dialog__header">
            <Dialog.Title class="raven-dialog__title">Confirm {{ account.name }} balance</Dialog.Title>
            <Dialog.CloseTrigger as-child>
              <button class="raven-icon-button" type="button" aria-label="Close balance dialog">
                <span class="i-lucide-x" aria-hidden="true" />
              </button>
            </Dialog.CloseTrigger>
          </header>
          <form @submit.prevent="submit">
            <div class="raven-dialog__body">
              <div class="raven-form-grid">
                <label class="raven-field">
                  <span>Balance kind</span>
                  <select v-model="balanceKind">
                    <option value="available">Available</option>
                    <option value="ledger">Ledger</option>
                    <option value="statement">Statement</option>
                    <option value="market_value">Market value</option>
                    <option value="outstanding">Outstanding</option>
                  </select>
                </label>
                <label class="raven-field">
                  <span>Economic meaning</span>
                  <select v-model="economicNature">
                    <option value="asset">Asset</option>
                    <option value="liability">Liability</option>
                    <option value="informational">Informational</option>
                  </select>
                </label>
                <label class="raven-field">
                  <span>Amount ({{ account.currency }})</span>
                  <input v-model="amount" inputmode="decimal" required autocomplete="off" placeholder="0.00" />
                </label>
                <label class="raven-field">
                  <span>True as of</span>
                  <input v-model="asOf" type="datetime-local" required />
                </label>
                <label class="raven-field raven-field--wide">
                  <span>Note (optional)</span>
                  <textarea v-model="note" rows="2" />
                </label>
              </div>
              <p v-if="errorMessage" class="raven-form-error">{{ errorMessage }}</p>
            </div>
            <footer class="raven-dialog__footer">
              <button class="raven-button" type="button" @click="close">Cancel</button>
              <button class="raven-button raven-button--primary" type="submit" :disabled="submitting">
                <span class="i-lucide-check" aria-hidden="true" />
                Confirm balance
              </button>
            </footer>
          </form>
        </Dialog.Content>
      </Dialog.Positioner>
    </Teleport>
  </Dialog.Root>
</template>
