<script setup lang="ts">
import { Dialog } from '@ark-ui/vue/dialog'
import { createCommandIntent, parseDecimalMoney, type AccountSummary, type CategoryView } from '@raven/domain'

type SpaceOption = Readonly<{ key: string; name: string; currency: string }>

const props = defineProps<{ accounts: AccountSummary[]; spaces: SpaceOption[] }>()
const emit = defineEmits<{ complete: [] }>()
const api = useAccountControlApi()
const { pendingCommand } = useRavenActions()
const intent = createCommandIntent()
const title = ref('')
const direction = ref<'outflow' | 'inflow'>('outflow')
const certainty = ref<'committed' | 'confirmed' | 'expected' | 'possible'>('committed')
const spaceKey = ref('')
const accountKey = ref('')
const currency = ref('ZAR')
const categoryKey = ref('')
const amount = ref('')
const cadence = ref<'once' | 'weekly' | 'monthly' | 'quarterly' | 'yearly'>('monthly')
const interval = ref(1)
const startDate = ref('')
const endDate = ref('')
const dueDay = ref(1)
const weekday = ref(1)
const monthOfYear = ref(1)
const timezone = ref('Africa/Johannesburg')
const notes = ref('')
const categories = ref<CategoryView[]>([])
const submitting = ref(false)
const errorMessage = ref('')

const open = computed(() => ['create-cashflow', 'create-upcoming-payment', 'create-expected-income'].includes(pendingCommand.value ?? ''))
const selectedSpace = computed(() => props.spaces.find((space) => space.key === spaceKey.value) ?? null)
const availableAccounts = computed(() => props.accounts.filter((account) => account.spaceKey === spaceKey.value && account.currency === currency.value))

function localDate(date = new Date()) {
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
}

function horizon(date: string) {
  const [year, month, day] = date.split('-').map(Number)
  const next = new Date(Date.UTC(year! + 1, month! - 1, day!))
  return next.toISOString().slice(0, 10)
}

async function loadCategories() {
  categories.value = []
  if (!spaceKey.value) return
  const kinds = direction.value === 'inflow' ? ['income', 'other'] as const : ['expense', 'tax', 'savings', 'other'] as const
  categories.value = (await api.listCategories({ spaceKey: spaceKey.value, kinds: [...kinds] })).categories
}

watch(open, (value) => {
  if (!value) return
  intent.clear()
  intent.begin()
  const space = props.spaces[0]
  spaceKey.value = space?.key ?? ''
  currency.value = space?.currency ?? 'ZAR'
  accountKey.value = ''
  title.value = ''
  direction.value = pendingCommand.value === 'create-expected-income' ? 'inflow' : 'outflow'
  certainty.value = direction.value === 'outflow' ? 'committed' : 'expected'
  amount.value = ''
  cadence.value = 'monthly'
  interval.value = 1
  startDate.value = localDate()
  endDate.value = ''
  dueDay.value = new Date().getDate()
  weekday.value = ((new Date().getDay() + 6) % 7) + 1
  monthOfYear.value = new Date().getMonth() + 1
  timezone.value = 'Africa/Johannesburg'
  notes.value = ''
  categoryKey.value = ''
  errorMessage.value = ''
  void loadCategories()
})
watch(spaceKey, () => {
  const space = selectedSpace.value
  currency.value = space?.currency ?? currency.value
  accountKey.value = ''
  categoryKey.value = ''
  intent.clear()
  void loadCategories()
})
watch(currency, () => {
  const normalized = currency.value.toUpperCase()
  if (currency.value !== normalized) {
    currency.value = normalized
    return
  }
  if (!availableAccounts.value.some((account) => account.accountKey === accountKey.value)) accountKey.value = ''
  intent.clear()
})
watch(direction, (value) => {
  certainty.value = value === 'outflow' ? 'committed' : 'expected'
  categoryKey.value = ''
  intent.clear()
  void loadCategories()
})
watch([title, certainty, accountKey, categoryKey, amount, cadence, interval, startDate, endDate, dueDay, weekday, monthOfYear, timezone, notes], () => intent.clear())

function close() {
  intent.clear()
  pendingCommand.value = null
}

async function submit() {
  if (!selectedSpace.value || !currency.value || !timezone.value.trim()) return
  submitting.value = true
  errorMessage.value = ''
  try {
    await api.createScheduledCashflow({
      idempotencyKey: intent.current(),
      channel: 'ui',
      spaceKey: selectedSpace.value.key,
      accountKey: accountKey.value || undefined,
      categoryKey: categoryKey.value || undefined,
      title: title.value,
      direction: direction.value,
      certainty: certainty.value,
      money: parseDecimalMoney(amount.value, currency.value),
      cadence: cadence.value,
      interval: interval.value,
      startDate: startDate.value,
      endDate: endDate.value || undefined,
      onceDueOn: cadence.value === 'once' ? startDate.value : undefined,
      dayOfWeek: cadence.value === 'weekly' ? weekday.value : undefined,
      dayOfMonth: ['monthly', 'quarterly', 'yearly'].includes(cadence.value) ? dueDay.value : undefined,
      monthOfYear: cadence.value === 'yearly' ? monthOfYear.value : undefined,
      timezone: timezone.value.trim(),
      materializeThrough: horizon(startDate.value),
      notes: notes.value || undefined,
    })
    intent.clear()
    emit('complete')
    close()
  } catch (error: any) {
    errorMessage.value = error?.message || 'The scheduled cashflow could not be created.'
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <div class="cashflow-component-host">
    <Dialog.Root :open="open" @open-change="({ open: next }) => !next && close()">
    <Teleport to="body">
      <Dialog.Backdrop class="raven-dialog-backdrop" />
      <Dialog.Positioner class="raven-dialog-positioner">
        <Dialog.Content class="raven-dialog cashflow-dialog">
          <header class="raven-dialog__header">
            <Dialog.Title class="raven-dialog__title">{{ pendingCommand === 'create-upcoming-payment' ? 'Upcoming payment' : pendingCommand === 'create-expected-income' ? 'Expected income' : 'Schedule cashflow' }}</Dialog.Title>
            <Dialog.CloseTrigger as-child><button class="raven-icon-button" type="button" aria-label="Close"><span class="i-lucide-x" /></button></Dialog.CloseTrigger>
          </header>
          <form @submit.prevent="submit">
            <div class="raven-dialog__body raven-form-grid">
              <label class="raven-field"><span>Financial Space</span><select v-model="spaceKey" required><option disabled value="">Select a space</option><option v-for="space in spaces" :key="space.key" :value="space.key">{{ space.name }}</option></select></label>
              <label class="raven-field"><span>Currency</span><input v-model.trim="currency" minlength="3" maxlength="3" required /></label>
              <label class="raven-field raven-field--wide"><span>Title</span><input v-model="title" maxlength="160" required autocomplete="off" /></label>
              <label class="raven-field"><span>Direction</span><select v-model="direction"><option value="outflow">Outgoing</option><option value="inflow">Incoming</option></select></label>
              <label class="raven-field"><span>Certainty</span><select v-model="certainty"><option v-if="direction === 'outflow'" value="committed">Committed</option><template v-else><option value="confirmed">Confirmed</option><option value="expected">Expected</option><option value="possible">Possible</option></template></select></label>
              <label class="raven-field raven-field--wide"><span>Account <small>optional</small></span><select v-model="accountKey"><option value="">Unassigned</option><option v-for="account in availableAccounts" :key="account.id" :value="account.accountKey">{{ account.name }} / {{ account.currency }}</option></select></label>
              <label class="raven-field"><span>Amount</span><input v-model="amount" required inputmode="decimal" placeholder="0.00" /></label>
              <label class="raven-field"><span>Category <small>optional</small></span><select v-model="categoryKey"><option value="">Uncategorized</option><option v-for="category in categories" :key="category.key" :value="category.key">{{ category.name }}</option></select></label>
              <label class="raven-field"><span>Cadence</span><select v-model="cadence"><option value="once">Once</option><option value="weekly">Weekly</option><option value="monthly">Monthly</option><option value="quarterly">Quarterly</option><option value="yearly">Yearly</option></select></label>
              <label class="raven-field"><span>Every</span><input v-model.number="interval" type="number" min="1" max="100" required /></label>
              <label class="raven-field"><span>{{ cadence === 'once' ? 'Due date' : 'Starts' }}</span><input v-model="startDate" type="date" required /></label>
              <label class="raven-field"><span>Ends <small>optional</small></span><input v-model="endDate" type="date" /></label>
              <label v-if="cadence === 'weekly'" class="raven-field"><span>Weekday</span><select v-model.number="weekday"><option :value="1">Monday</option><option :value="2">Tuesday</option><option :value="3">Wednesday</option><option :value="4">Thursday</option><option :value="5">Friday</option><option :value="6">Saturday</option><option :value="7">Sunday</option></select></label>
              <label v-if="['monthly', 'quarterly', 'yearly'].includes(cadence)" class="raven-field"><span>Day of month</span><input v-model.number="dueDay" type="number" min="1" max="31" required /></label>
              <label v-if="cadence === 'yearly'" class="raven-field"><span>Month</span><input v-model.number="monthOfYear" type="number" min="1" max="12" required /></label>
              <label class="raven-field raven-field--wide"><span>Timezone</span><input v-model="timezone" required placeholder="Africa/Johannesburg" /></label>
              <label class="raven-field raven-field--wide"><span>Notes <small>optional</small></span><textarea v-model="notes" maxlength="500" rows="2" /></label>
              <p v-if="errorMessage" class="raven-form-error raven-field--wide">{{ errorMessage }}</p>
            </div>
            <footer class="raven-dialog__footer"><button class="raven-button" type="button" @click="close">Cancel</button><button class="raven-button raven-button--primary" type="submit" :disabled="submitting || !selectedSpace"><span class="i-lucide-calendar-plus" />Schedule</button></footer>
          </form>
        </Dialog.Content>
      </Dialog.Positioner>
    </Teleport>
    </Dialog.Root>
  </div>
</template>

<style scoped>
.cashflow-component-host { display: contents; }
.cashflow-dialog { width: min(640px, calc(100vw - 24px)); }
.raven-field small { color: var(--raven-muted); font-size: 10px; font-weight: 400; }
textarea { resize: vertical; }
</style>
