<script setup lang="ts">
import { Dialog } from '@ark-ui/vue/dialog'
import {
  createCommandIntentRegistry,
  formatMoney,
  parseDecimalMoney,
  type CashflowOccurrenceView,
  type GetCashflowOccurrenceOutput,
} from '@raven/domain'

const props = defineProps<{ occurrence: CashflowOccurrenceView | null }>()
const emit = defineEmits<{ close: []; complete: [] }>()
const api = useAccountControlApi()
const intents = createCommandIntentRegistry((action) => `ui-${action}-${crypto.randomUUID()}`)
const detail = ref<GetCashflowOccurrenceOutput | null>(null)
const loading = ref(false)
const transactionId = ref('')
const manualTransactionId = ref('')
const showManualId = ref(false)
const reason = ref('')
const note = ref('')
const amount = ref('')
const dueOn = ref('')
const pendingAction = ref('')
const errorMessage = ref('')

const item = computed(() => detail.value?.occurrence ?? props.occurrence)

watch(() => props.occurrence?.id, async (id) => {
  intents.clearAll()
  detail.value = null
  transactionId.value = ''
  manualTransactionId.value = ''
  showManualId.value = false
  reason.value = ''
  note.value = ''
  errorMessage.value = ''
  if (!id) return
  loading.value = true
  try {
    const response = await api.getCashflowOccurrence({ occurrenceId: id })
    detail.value = response
    amount.value = String(response.occurrence.money.minorUnits / 100)
    dueOn.value = response.occurrence.dueOn
  } catch (error: any) {
    errorMessage.value = error?.message || 'The occurrence could not be loaded.'
  } finally {
    loading.value = false
  }
}, { immediate: true })

watch([transactionId, manualTransactionId, showManualId], () => {
  intents.clear('settle')
  intents.clear('reconcile')
})
watch([amount, reason, note], () => {
  intents.clear('amount')
  for (const action of ['settle', 'reconcile', 'skip', 'waive', 'cancel']) intents.clear(action)
})
watch([dueOn, reason, note], () => intents.clear('date'))

function close() {
  intents.clearAll()
  emit('close')
}

function selectedTransactionId() {
  return showManualId.value ? manualTransactionId.value.trim() : transactionId.value
}

async function run(action: string, command: (idempotencyKey: string) => Promise<unknown>) {
  pendingAction.value = action
  errorMessage.value = ''
  try {
    await command(intents.current(action))
    intents.clear(action)
    emit('complete')
  } catch (error: any) {
    errorMessage.value = error?.message || 'The occurrence could not be updated.'
  } finally {
    pendingAction.value = ''
  }
}

function common(idempotencyKey: string) {
  return {
    occurrenceId: item.value!.id,
    expectedRevision: item.value!.revision,
    idempotencyKey,
    channel: 'ui' as const,
    reason: reason.value || undefined,
    note: note.value || undefined,
  }
}

function operationLabel(command: string) {
  return command.replaceAll('_', ' ')
}

function candidateLabel(candidate: GetCashflowOccurrenceOutput['settlementCandidates'][number]) {
  const amountLabel = candidate.amount ? formatMoney(candidate.amount) : 'Unknown amount'
  return `${candidate.financialDate} / ${candidate.description} / ${amountLabel} / ${candidate.account.accountKey} / ${candidate.flowDirection}`
}

function overrideAmount(idempotencyKey: string) {
  if (!item.value) return Promise.resolve()
  return api.overrideCashflowOccurrenceAmount({
    ...common(idempotencyKey),
    money: parseDecimalMoney(amount.value, item.value.money.currency),
  })
}
</script>

<template>
  <div class="cashflow-component-host">
    <Dialog.Root :open="Boolean(occurrence)" @open-change="({ open }) => !open && close()">
    <Teleport to="body">
      <Dialog.Backdrop class="raven-dialog-backdrop" />
      <Dialog.Positioner class="cashflow-drawer-positioner">
        <Dialog.Content class="cashflow-drawer">
          <header>
            <div><span>Occurrence</span><Dialog.Title>{{ item?.title || 'Loading' }}</Dialog.Title></div>
            <Dialog.CloseTrigger as-child><button class="raven-icon-button" aria-label="Close"><span class="i-lucide-x" /></button></Dialog.CloseTrigger>
          </header>
          <div v-if="loading" class="drawer-body">Loading...</div>
          <div v-else-if="detail && item" class="drawer-body">
            <dl>
              <div><dt>Status</dt><dd>{{ item.status }} / {{ item.reconciled ? 'Linked' : item.status === 'settled' ? 'Unreconciled' : 'Not settled' }}</dd></div>
              <div><dt>Timing</dt><dd>{{ item.timing.group.replaceAll('_', ' ') }} / {{ item.timing.localToday }}</dd></div>
              <div><dt>Due</dt><dd>{{ item.dueOn }}<template v-if="item.dueOn !== item.scheduledDueOn"> (scheduled {{ item.scheduledDueOn }})</template></dd></div>
              <div><dt>Amount</dt><dd>{{ formatMoney(item.money) }}<template v-if="item.money.minorUnits !== item.scheduledMoney.minorUnits"> (scheduled {{ formatMoney(item.scheduledMoney) }})</template></dd></div>
              <div><dt>Direction / certainty</dt><dd>{{ item.direction }} / {{ item.certainty }}</dd></div>
              <div><dt>Rule</dt><dd>{{ item.recurrenceLabel }}</dd></div>
              <div><dt>Scope</dt><dd>{{ item.spaceKey }} / {{ item.account?.accountKey || 'unassigned' }}</dd></div>
              <div><dt>Category</dt><dd>{{ item.category?.name || 'Uncategorized' }}</dd></div>
              <div><dt>Revisions</dt><dd>schedule {{ item.scheduleRevision }} / occurrence {{ item.revision }}</dd></div>
              <div><dt>Settlement evidence</dt><dd>{{ item.transactionId || 'None' }}</dd></div>
              <div><dt>Override</dt><dd>{{ item.overrideReason || 'None' }}</dd></div>
              <div><dt>Status reason</dt><dd>{{ item.statusReason || 'None' }}</dd></div>
            </dl>

            <div v-if="item.status === 'due' || (item.status === 'settled' && !item.reconciled)" class="drawer-section">
              <h3>{{ item.status === 'due' ? 'Settle' : 'Reconcile' }}</h3>
              <label v-if="detail.settlementCandidates.length && !showManualId" class="raven-field">
                <span>Matching observed transaction</span>
                <select v-model="transactionId">
                  <option value="">{{ item.status === 'due' ? 'Settle without evidence' : 'Select matching evidence' }}</option>
                  <option v-for="candidate in detail.settlementCandidates" :key="candidate.id" :value="candidate.id">
                    {{ candidateLabel(candidate) }}
                  </option>
                </select>
              </label>
              <p v-else-if="!showManualId" class="drawer-consequence">No canonical same-space, same-account, exact-money candidates were found.</p>
              <button class="manual-toggle" type="button" @click="showManualId = !showManualId"><span class="i-lucide-terminal" />{{ showManualId ? 'Use candidate picker' : 'Expert: enter transaction ID' }}</button>
              <label v-if="showManualId" class="raven-field"><span>Observed transaction ID</span><input v-model="manualTransactionId" maxlength="180" placeholder="transaction:..." /></label>
              <button v-if="item.status === 'due'" class="raven-button raven-button--primary" :disabled="Boolean(pendingAction)" @click="run('settle', (key) => api.settleCashflowOccurrence({ ...common(key), settledAt: new Date().toISOString(), transactionId: selectedTransactionId() || undefined }))"><span class="i-lucide-check" />Mark settled</button>
              <button v-else class="raven-button" :disabled="!selectedTransactionId() || Boolean(pendingAction)" @click="run('reconcile', (key) => api.reconcileCashflowOccurrence({ ...common(key), transactionId: selectedTransactionId() }))">Link evidence</button>
            </div>

            <div v-if="item.status === 'due'" class="drawer-section">
              <h3>Override</h3>
              <div class="drawer-pair"><label class="raven-field"><span>Amount</span><input v-model="amount" inputmode="decimal" /></label><button class="raven-button" :disabled="Boolean(pendingAction)" @click="run('amount', overrideAmount)">Apply</button></div>
              <div class="drawer-pair"><label class="raven-field"><span>Due date</span><input v-model="dueOn" type="date" /></label><button class="raven-button" :disabled="Boolean(pendingAction)" @click="run('date', (key) => api.overrideCashflowOccurrenceDueDate({ ...common(key), dueOn }))">Apply</button></div>
              <label class="raven-field"><span>Reason</span><input v-model="reason" maxlength="500" placeholder="Optional context" /></label>
              <label class="raven-field"><span>Audit note</span><input v-model="note" maxlength="500" placeholder="Optional note" /></label>
            </div>

            <div v-if="item.status === 'due'" class="drawer-section">
              <h3>Resolve without settlement</h3>
              <div class="drawer-actions">
                <button class="raven-button" :disabled="Boolean(pendingAction)" @click="run('skip', (key) => api.skipCashflowOccurrence(common(key)))">Skip</button>
                <button class="raven-button" :disabled="Boolean(pendingAction)" @click="run('waive', (key) => api.waiveCashflowOccurrence(common(key)))">Waive</button>
                <button class="raven-button raven-button--danger" :disabled="Boolean(pendingAction)" @click="run('cancel', (key) => api.cancelCashflowOccurrence(common(key)))">Cancel</button>
              </div>
            </div>

            <div class="drawer-section">
              <h3>Operation history</h3>
              <div v-if="!detail.operations.length" class="drawer-consequence">No operation history.</div>
              <ol v-else class="operation-history">
                <li v-for="operation in detail.operations" :key="operation.id">
                  <div><strong>{{ operationLabel(operation.command) }}</strong><time>{{ operation.recordedAt }}</time></div>
                  <small>via {{ operation.channel }} / {{ operation.status }} / {{ operation.id.slice(-12) }}</small>
                  <code v-if="Object.keys(operation.auditMeta).length">{{ JSON.stringify(operation.auditMeta) }}</code>
                </li>
              </ol>
            </div>

            <p v-if="detail.meta.quality !== 'complete' || detail.meta.warnings.length" class="drawer-warning"><span class="i-lucide-triangle-alert" />{{ detail.meta.quality }}<template v-if="detail.meta.warnings.length">: {{ detail.meta.warnings.join(', ') }}</template></p>
            <p v-if="errorMessage" class="raven-form-error">{{ errorMessage }}</p>
          </div>
          <div v-else class="drawer-body"><p class="raven-form-error">{{ errorMessage }}</p></div>
        </Dialog.Content>
      </Dialog.Positioner>
    </Teleport>
    </Dialog.Root>
  </div>
</template>

<style scoped>
.cashflow-component-host { display: contents; }
.cashflow-drawer-positioner { position: fixed; inset: 0; z-index: 100; display: flex; justify-content: flex-end; }
.cashflow-drawer { width: min(540px, 100vw); height: 100%; overflow-y: auto; border-left: 1px solid var(--raven-border); background: var(--raven-bg); box-shadow: -16px 0 40px #0008; }
.cashflow-drawer > header { position: sticky; top: 0; z-index: 1; display: flex; justify-content: space-between; align-items: center; padding: 18px 20px; border-bottom: 1px solid var(--raven-border); background: var(--raven-bg); }
.cashflow-drawer header span { color: var(--raven-muted); font-size: 11px; }
.cashflow-drawer h2 { margin: 3px 0 0; font-size: 20px; }
.drawer-body { display: grid; gap: 22px; padding: 20px; }
dl { margin: 0; border-block: 1px solid var(--raven-border); }
dl div { display: flex; justify-content: space-between; gap: 18px; padding: 10px 0; border-bottom: 1px solid var(--raven-border); }
dl div:last-child { border: 0; }
dt { color: var(--raven-muted); }
dd { margin: 0; max-width: 65%; text-align: right; overflow-wrap: anywhere; text-transform: capitalize; }
.drawer-section { display: grid; gap: 10px; }
.drawer-section h3 { margin: 0; font-size: 13px; }
.drawer-pair { display: grid; grid-template-columns: 1fr auto; align-items: end; gap: 8px; }
.drawer-actions { display: flex; flex-wrap: wrap; gap: 8px; }
.drawer-warning { display: flex; gap: 8px; color: #eab85c; }
.drawer-consequence { margin: 0; color: var(--raven-muted); font-size: 12px; line-height: 1.5; }
.manual-toggle { width: max-content; display: inline-flex; align-items: center; gap: 7px; border: 0; padding: 0; color: var(--raven-muted); background: none; font: inherit; font-size: 11px; cursor: pointer; }
.manual-toggle:hover { color: var(--raven-text); }
.operation-history { display: grid; gap: 0; margin: 0; padding: 0; list-style: none; border-block: 1px solid var(--raven-border); }
.operation-history li { display: grid; gap: 4px; padding: 10px 0; border-bottom: 1px solid var(--raven-border); }
.operation-history li:last-child { border: 0; }
.operation-history div { display: flex; justify-content: space-between; gap: 12px; }
.operation-history strong { font-size: 12px; text-transform: capitalize; }
.operation-history time, .operation-history small { color: var(--raven-muted); font-size: 11px; }
.operation-history code { overflow-wrap: anywhere; color: var(--raven-muted); font-size: 10px; white-space: normal; }
@media (max-width: 520px) { .drawer-pair { grid-template-columns: 1fr; } }
</style>
