<script setup lang="ts">
import { Dialog } from "@ark-ui/vue/dialog";
import {
  formatMoney,
  parseDecimalMoney,
  type GetCashflowScheduleOutput,
} from "@raven/domain";
import {
  createCashflowScheduleIntentManager,
  financialDateInTimezone,
  latestFinancialDate,
  scheduleLifecycleMinimum,
  type CashflowScheduleAction,
} from "../utils/cashflow-schedule-intents";

const props = defineProps<{ scheduleId: string | null }>();
const emit = defineEmits<{ close: []; complete: [] }>();
const api = useAccountControlApi();
const intents = createCashflowScheduleIntentManager();
const data = ref<GetCashflowScheduleOutput | null>(null);
const loading = ref(false);
const pendingAction = ref("");
const errorMessage = ref("");
const termsEffectiveFrom = ref("");
const lifecycleEffectiveOn = ref("");
const lifecycleNote = ref("");
const title = ref("");
const amount = ref("");
const certainty = ref<"committed" | "confirmed" | "expected" | "possible">(
  "committed",
);
const cadence = ref<"once" | "weekly" | "monthly" | "quarterly" | "yearly">(
  "monthly",
);
const interval = ref(1);
const startDate = ref("");
const endDate = ref("");
const onceDueOn = ref("");
const dayOfWeek = ref(1);
const dayOfMonth = ref(1);
const monthOfYear = ref(1);
const timezone = ref("");
const notes = ref("");

const syncingForm = ref(false);
const termsMinimum = computed(() =>
  data.value
    ? latestFinancialDate(
        data.value.schedule.startDate,
        data.value.schedule.termsEffectiveFrom,
      )
    : "",
);
const lifecycleMinimum = computed(() =>
  data.value ? scheduleLifecycleMinimum(data.value.schedule) : "",
);
const resumeDateValid = computed(
  () =>
    !data.value?.schedule.pausedOn ||
    lifecycleEffectiveOn.value > data.value.schedule.pausedOn,
);
const lifecycleConsequence = computed(() => {
  if (!data.value || !lifecycleEffectiveOn.value) return "";
  const schedule = data.value.schedule;
  if (schedule.status === "paused") {
    return `The schedule remains paused from ${schedule.pausedOn}. Resume creates no backfill before ${lifecycleEffectiveOn.value}; end preserves that date; cancel is inclusive from that date.`;
  }
  return `Pause preserves accepted dates through ${lifecycleEffectiveOn.value}. End preserves that date. Cancel is inclusive from that date.`;
});

async function resetForm(
  response: GetCashflowScheduleOutput,
  queryAsOf: string,
) {
  syncingForm.value = true;
  const schedule = response.schedule;
  termsEffectiveFrom.value = latestFinancialDate(
    schedule.termsEffectiveFrom,
    schedule.startDate,
  );
  lifecycleEffectiveOn.value = latestFinancialDate(
    financialDateInTimezone(queryAsOf, schedule.timezone),
    scheduleLifecycleMinimum(schedule),
  );
  lifecycleNote.value = "";
  title.value = schedule.title;
  amount.value = String(schedule.money.minorUnits / 100);
  certainty.value = schedule.certainty;
  cadence.value = schedule.cadence;
  interval.value = schedule.interval;
  startDate.value = schedule.startDate;
  endDate.value = schedule.endDate ?? "";
  onceDueOn.value = schedule.onceDueOn ?? schedule.startDate;
  dayOfWeek.value = schedule.dayOfWeek ?? 1;
  dayOfMonth.value = schedule.dayOfMonth ?? 1;
  monthOfYear.value = schedule.monthOfYear ?? 1;
  timezone.value = schedule.timezone;
  notes.value = schedule.notes ?? "";
  await nextTick();
  syncingForm.value = false;
}

async function loadSchedule(id: string, showLoading = true) {
  intents.clearAll();
  errorMessage.value = "";
  if (showLoading) loading.value = true;
  try {
    const queryAsOf = new Date().toISOString();
    const response = await api.getCashflowSchedule({
      scheduleId: id,
      asOf: queryAsOf,
    });
    data.value = response;
    await resetForm(response, queryAsOf);
  } catch (error: any) {
    errorMessage.value = error?.message || "The schedule could not be loaded.";
  } finally {
    if (showLoading) loading.value = false;
  }
}

watch(
  () => props.scheduleId,
  async (id) => {
    data.value = null;
    if (!id) return;
    await loadSchedule(id);
  },
  { immediate: true },
);

watch(
  [
    title,
    amount,
    certainty,
    cadence,
    interval,
    startDate,
    endDate,
    onceDueOn,
    dayOfWeek,
    dayOfMonth,
    monthOfYear,
    timezone,
    notes,
  ],
  () => {
    if (!syncingForm.value) intents.invalidateTerms();
  },
);
watch(termsEffectiveFrom, () => {
  if (!syncingForm.value) intents.invalidateTerms();
});
watch([lifecycleEffectiveOn, lifecycleNote], () => {
  if (!syncingForm.value) intents.invalidateLifecycle();
});

function close() {
  intents.clearAll();
  emit("close");
}

async function run(
  action: CashflowScheduleAction,
  command: (idempotencyKey: string) => Promise<unknown>,
) {
  pendingAction.value = action;
  errorMessage.value = "";
  try {
    await command(intents.current(action));
    intents.succeeded(action);
    if (props.scheduleId) await loadSchedule(props.scheduleId, false);
    emit("complete");
  } catch (error: any) {
    errorMessage.value = error?.message || "The schedule could not be updated.";
  } finally {
    pendingAction.value = "";
  }
}

function lifecycleInput(idempotencyKey: string) {
  return {
    scheduleId: data.value!.schedule.id,
    expectedRevision: data.value!.schedule.revision,
    effectiveOn: lifecycleEffectiveOn.value,
    note: lifecycleNote.value || undefined,
    idempotencyKey,
    channel: "ui" as const,
  };
}

function update(idempotencyKey: string) {
  const schedule = data.value!.schedule;
  return api.updateScheduledCashflow({
    scheduleId: schedule.id,
    expectedRevision: schedule.revision,
    effectiveFrom: termsEffectiveFrom.value,
    title: title.value,
    money: parseDecimalMoney(amount.value, schedule.money.currency),
    certainty: certainty.value,
    cadence: cadence.value,
    interval: interval.value,
    startDate: startDate.value,
    endDate: endDate.value || undefined,
    onceDueOn: cadence.value === "once" ? onceDueOn.value : undefined,
    dayOfWeek: cadence.value === "weekly" ? dayOfWeek.value : undefined,
    dayOfMonth: ["monthly", "quarterly", "yearly"].includes(cadence.value)
      ? dayOfMonth.value
      : undefined,
    monthOfYear: cadence.value === "yearly" ? monthOfYear.value : undefined,
    timezone: timezone.value,
    notes: notes.value || undefined,
    idempotencyKey,
    channel: "ui",
  });
}

function operationLabel(command: string) {
  return command.replaceAll("_", " ");
}
</script>

<template>
  <div class="cashflow-component-host">
    <Dialog.Root
      :open="Boolean(scheduleId)"
      @open-change="({ open }) => !open && close()"
    >
      <Teleport to="body">
        <Dialog.Backdrop class="raven-dialog-backdrop" />
        <Dialog.Positioner class="cashflow-drawer-positioner">
          <Dialog.Content class="cashflow-drawer">
            <header>
              <div>
                <span>Schedule</span
                ><Dialog.Title>{{
                  data?.schedule.title || "Loading"
                }}</Dialog.Title>
              </div>
              <Dialog.CloseTrigger as-child
                ><button class="raven-icon-button" aria-label="Close">
                  <span class="i-lucide-x" /></button
              ></Dialog.CloseTrigger>
            </header>
            <div v-if="loading" class="drawer-body">Loading...</div>
            <div v-else-if="data" class="drawer-body">
              <dl>
                <div>
                  <dt>Effective status</dt>
                  <dd>{{ data.schedule.effectiveStatus }}</dd>
                </div>
                <div>
                  <dt>Configured status</dt>
                  <dd>{{ data.schedule.configuredStatus }}</dd>
                </div>
                <div v-if="data.schedule.pendingTransition">
                  <dt>Next transition</dt>
                  <dd>
                    {{ data.schedule.pendingTransition.status }} on
                    {{ data.schedule.pendingTransition.effectiveOn }}
                  </dd>
                </div>
                <div>
                  <dt>Direction / certainty</dt>
                  <dd>
                    {{ data.schedule.direction }} /
                    {{ data.schedule.certainty }}
                  </dd>
                </div>
                <div>
                  <dt>Amount</dt>
                  <dd>{{ formatMoney(data.schedule.money) }}</dd>
                </div>
                <div>
                  <dt>Rule</dt>
                  <dd>{{ data.schedule.recurrenceLabel }}</dd>
                </div>
                <div>
                  <dt>Timezone</dt>
                  <dd>{{ data.schedule.timezone }}</dd>
                </div>
                <div>
                  <dt>Scope</dt>
                  <dd>
                    {{ data.schedule.spaceKey }} /
                    {{ data.schedule.account?.accountKey || "unassigned" }}
                  </dd>
                </div>
                <div>
                  <dt>Category</dt>
                  <dd>{{ data.schedule.category?.name || "Uncategorized" }}</dd>
                </div>
                <div>
                  <dt>Terms effective</dt>
                  <dd>{{ data.schedule.termsEffectiveFrom }}</dd>
                </div>
                <div>
                  <dt>Materialized through</dt>
                  <dd>{{ data.schedule.materializedThrough || "None" }}</dd>
                </div>
                <div>
                  <dt>Revision</dt>
                  <dd>{{ data.schedule.revision }}</dd>
                </div>
              </dl>

              <div class="drawer-section">
                <h3>Occurrence history</h3>
                <div class="history-counts">
                  <span
                    v-for="(count, state) in data.occurrenceCounts"
                    :key="state"
                    ><strong>{{ count }}</strong> {{ state }}</span
                  >
                </div>
              </div>

              <div
                v-if="['active', 'paused'].includes(data.schedule.status)"
                class="drawer-section"
              >
                <h3>Future terms</h3>
                <p class="drawer-consequence">
                  Old terms remain authoritative before this date. Due rows from
                  this date are reconciled without deleting history.
                </p>
                <label class="raven-field"
                  ><span>Effective from</span
                  ><input
                    v-model="termsEffectiveFrom"
                    type="date"
                    :min="termsMinimum"
                    required
                /></label>
                <label class="raven-field"
                  ><span>Title</span><input v-model="title" maxlength="160"
                /></label>
                <div class="drawer-pair">
                  <label class="raven-field"
                    ><span>Amount</span
                    ><input v-model="amount" inputmode="decimal"
                  /></label>
                  <label class="raven-field"
                    ><span>Certainty</span
                    ><select v-model="certainty">
                      <option
                        v-if="data.schedule.direction === 'outflow'"
                        value="committed"
                      >
                        Committed
                      </option>
                      <template v-else
                        ><option value="confirmed">Confirmed</option>
                        <option value="expected">Expected</option>
                        <option value="possible">Possible</option></template
                      >
                    </select></label
                  >
                </div>
                <div class="drawer-pair">
                  <label class="raven-field"
                    ><span>Cadence</span
                    ><select v-model="cadence">
                      <option value="once">Once</option>
                      <option value="weekly">Weekly</option>
                      <option value="monthly">Monthly</option>
                      <option value="quarterly">Quarterly</option>
                      <option value="yearly">Yearly</option>
                    </select></label
                  >
                  <label class="raven-field"
                    ><span>Interval</span
                    ><input
                      v-model.number="interval"
                      type="number"
                      min="1"
                      max="100"
                  /></label>
                </div>
                <div class="drawer-pair">
                  <label class="raven-field"
                    ><span>Start</span
                    ><input v-model="startDate" type="date" /></label
                  ><label class="raven-field"
                    ><span>End</span><input v-model="endDate" type="date"
                  /></label>
                </div>
                <label v-if="cadence === 'once'" class="raven-field"
                  ><span>Due on</span><input v-model="onceDueOn" type="date"
                /></label>
                <label v-if="cadence === 'weekly'" class="raven-field"
                  ><span>Weekday</span
                  ><input
                    v-model.number="dayOfWeek"
                    type="number"
                    min="1"
                    max="7"
                /></label>
                <label
                  v-if="['monthly', 'quarterly', 'yearly'].includes(cadence)"
                  class="raven-field"
                  ><span>Day of month</span
                  ><input
                    v-model.number="dayOfMonth"
                    type="number"
                    min="1"
                    max="31"
                /></label>
                <label v-if="cadence === 'yearly'" class="raven-field"
                  ><span>Month</span
                  ><input
                    v-model.number="monthOfYear"
                    type="number"
                    min="1"
                    max="12"
                /></label>
                <label class="raven-field"
                  ><span>Timezone</span><input v-model="timezone" required
                /></label>
                <label class="raven-field"
                  ><span>Notes</span
                  ><textarea v-model="notes" maxlength="500" rows="2" />
                </label>
                <button
                  class="raven-button"
                  :disabled="Boolean(pendingAction)"
                  @click="run('update-schedule', update)"
                >
                  Apply future terms
                </button>
              </div>

              <div
                v-if="['active', 'paused'].includes(data.schedule.status)"
                class="drawer-section"
              >
                <h3>Lifecycle</h3>
                <label class="raven-field"
                  ><span>Effective date</span
                  ><input
                    v-model="lifecycleEffectiveOn"
                    type="date"
                    :min="lifecycleMinimum"
                    required
                /></label>
                <label class="raven-field"
                  ><span>Audit note</span
                  ><input
                    v-model="lifecycleNote"
                    maxlength="500"
                    placeholder="Optional context"
                /></label>
                <div class="drawer-actions">
                  <button
                    v-if="data.schedule.status === 'active'"
                    class="raven-button"
                    :disabled="Boolean(pendingAction)"
                    @click="
                      run('pause-schedule', (key) =>
                        api.pauseScheduledCashflow(lifecycleInput(key)),
                      )
                    "
                  >
                    <span class="i-lucide-pause" />Pause
                  </button>
                  <button
                    v-else
                    class="raven-button"
                    :disabled="Boolean(pendingAction) || !resumeDateValid"
                    @click="
                      run('resume-schedule', (key) =>
                        api.resumeScheduledCashflow({
                          scheduleId: data!.schedule.id,
                          expectedRevision: data!.schedule.revision,
                          resumeOn: lifecycleEffectiveOn,
                          note: lifecycleNote || undefined,
                          idempotencyKey: key,
                          channel: 'ui',
                        }),
                      )
                    "
                  >
                    <span class="i-lucide-play" />Resume
                  </button>
                  <button
                    class="raven-button"
                    :disabled="Boolean(pendingAction)"
                    @click="
                      run('end-schedule', (key) =>
                        api.endScheduledCashflow(lifecycleInput(key)),
                      )
                    "
                  >
                    End after date
                  </button>
                  <button
                    class="raven-button raven-button--danger"
                    :disabled="Boolean(pendingAction)"
                    @click="
                      run('cancel-schedule', (key) =>
                        api.cancelScheduledCashflow(lifecycleInput(key)),
                      )
                    "
                  >
                    Cancel from date
                  </button>
                </div>
                <p class="drawer-consequence">{{ lifecycleConsequence }}</p>
                <p
                  v-if="data.schedule.status === 'paused' && !resumeDateValid"
                  class="drawer-warning"
                >
                  <span class="i-lucide-triangle-alert" />Resume must be after
                  {{ data.schedule.pausedOn }}.
                </p>
              </div>

              <div class="drawer-section">
                <h3>Operation history</h3>
                <div v-if="!data.operations.length" class="history-empty">
                  No operation history.
                </div>
                <ol v-else class="operation-history">
                  <li v-for="operation in data.operations" :key="operation.id">
                    <div>
                      <strong>{{ operationLabel(operation.command) }}</strong
                      ><time>{{ operation.recordedAt }}</time>
                    </div>
                    <small
                      >via {{ operation.channel }} / {{ operation.status }} /
                      {{ operation.id.slice(-12) }}</small
                    >
                    <code v-if="Object.keys(operation.auditMeta).length">{{
                      JSON.stringify(operation.auditMeta)
                    }}</code>
                  </li>
                </ol>
              </div>
              <p
                v-if="
                  data.meta.quality !== 'complete' || data.meta.warnings.length
                "
                class="drawer-warning"
              >
                <span class="i-lucide-triangle-alert" />{{ data.meta.quality
                }}<template v-if="data.meta.warnings.length"
                  >: {{ data.meta.warnings.join(", ") }}</template
                >
              </p>
              <p v-if="errorMessage" class="raven-form-error">
                {{ errorMessage }}
              </p>
            </div>
            <div v-else class="drawer-body">
              <p class="raven-form-error">{{ errorMessage }}</p>
            </div>
          </Dialog.Content>
        </Dialog.Positioner>
      </Teleport>
    </Dialog.Root>
  </div>
</template>

<style scoped>
.cashflow-component-host {
  display: contents;
}
.cashflow-drawer-positioner {
  position: fixed;
  inset: 0;
  z-index: 100;
  display: flex;
  justify-content: flex-end;
}
.cashflow-drawer {
  width: min(520px, 100vw);
  height: 100%;
  overflow-y: auto;
  border-left: 1px solid var(--raven-border);
  background: var(--raven-bg);
  box-shadow: -16px 0 40px #0008;
}
.cashflow-drawer > header {
  position: sticky;
  top: 0;
  z-index: 1;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px 20px;
  border-bottom: 1px solid var(--raven-border);
  background: var(--raven-bg);
}
.cashflow-drawer header span {
  color: var(--raven-muted);
  font-size: 11px;
}
.cashflow-drawer h2 {
  margin: 3px 0 0;
  font-size: 20px;
}
.drawer-body {
  display: grid;
  gap: 22px;
  padding: 20px;
}
dl {
  margin: 0;
  border-block: 1px solid var(--raven-border);
}
dl div {
  display: flex;
  justify-content: space-between;
  gap: 18px;
  padding: 10px 0;
  border-bottom: 1px solid var(--raven-border);
}
dl div:last-child {
  border: 0;
}
dt {
  color: var(--raven-muted);
}
dd {
  margin: 0;
  text-align: right;
  overflow-wrap: anywhere;
  text-transform: capitalize;
}
.drawer-section {
  display: grid;
  gap: 10px;
}
.drawer-section h3 {
  margin: 0;
  font-size: 13px;
}
.drawer-pair {
  display: grid;
  grid-template-columns: 1fr 1fr;
  align-items: end;
  gap: 8px;
}
.drawer-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.drawer-consequence,
.history-empty {
  margin: 0;
  color: var(--raven-muted);
  font-size: 12px;
  line-height: 1.5;
}
.history-counts {
  display: flex;
  flex-wrap: wrap;
  gap: 8px 14px;
  color: var(--raven-muted);
  font-size: 12px;
  text-transform: capitalize;
}
.history-counts strong {
  color: var(--raven-text);
}
.operation-history {
  display: grid;
  gap: 0;
  margin: 0;
  padding: 0;
  list-style: none;
  border-block: 1px solid var(--raven-border);
}
.operation-history li {
  display: grid;
  gap: 4px;
  padding: 10px 0;
  border-bottom: 1px solid var(--raven-border);
}
.operation-history li:last-child {
  border: 0;
}
.operation-history div {
  display: flex;
  justify-content: space-between;
  gap: 12px;
}
.operation-history strong {
  font-size: 12px;
  text-transform: capitalize;
}
.operation-history time,
.operation-history small {
  color: var(--raven-muted);
  font-size: 11px;
}
.operation-history code {
  overflow-wrap: anywhere;
  color: var(--raven-muted);
  font-size: 10px;
  white-space: normal;
}
.drawer-warning {
  display: flex;
  gap: 8px;
  color: #eab85c;
}
textarea {
  resize: vertical;
}
@media (max-width: 520px) {
  .drawer-pair {
    grid-template-columns: 1fr;
  }
}
</style>
