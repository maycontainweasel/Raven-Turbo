<script setup lang="ts">
import {
  formatMoney,
  type CashflowOccurrenceView,
  type CashflowTimingGroup,
  type ListCashflowSchedulesOutput,
  type ListUpcomingCashflowsOutput,
} from "@raven/domain";

useHead({ title: "Upcoming / Raven" });
const api = useAccountControlApi();
const { openCommand, dataVersion } = useRavenActions();
const view = ref<"all" | "outflow" | "inflow" | "schedules">("all");
const certainty = ref<
  "all" | "committed" | "confirmed" | "expected" | "possible"
>("all");
const status = ref<"due" | "all">("due");
const search = ref("");
const hydrated = ref(false);
const selectedOccurrence = ref<CashflowOccurrenceView | null>(null);
const selectedScheduleId = ref<string | null>(null);
const tabs = [
  { id: "all", label: "All" },
  { id: "outflow", label: "To pay" },
  { id: "inflow", label: "Incoming" },
  { id: "schedules", label: "Schedules" },
] as const;

onMounted(() => {
  hydrated.value = true;
});

function localDate(date = new Date()) {
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(date.getDate()).padStart(2, "0")}`;
}

function horizon(value: string) {
  const [year, month, day] = value.split("-").map(Number);
  const next = new Date(Date.UTC(year!, month! + 2, day!));
  return next.toISOString().slice(0, 10);
}

const from = ref(localDate());
const through = ref(horizon(from.value));
const directions = computed(() =>
  view.value === "outflow"
    ? ["outflow" as const]
    : view.value === "inflow"
      ? ["inflow" as const]
      : undefined,
);
const occurrenceKey = computed(() =>
  [
    "upcoming-cashflows",
    from.value,
    through.value,
    view.value,
    certainty.value,
    status.value,
    search.value,
    dataVersion.value,
  ].join(":"),
);
const scheduleKey = computed(() =>
  ["cashflow-schedules", view.value, certainty.value, dataVersion.value].join(
    ":",
  ),
);

const { data, pending, error, refresh } =
  await useAsyncData<ListUpcomingCashflowsOutput>(
    occurrenceKey,
    () =>
      api.listUpcomingCashflows({
        from: from.value,
        through: through.value,
        directions: directions.value,
        certainties: certainty.value === "all" ? undefined : [certainty.value],
        includeTerminal: status.value === "all",
        search: search.value || undefined,
        asOf: new Date().toISOString(),
      }),
    {
      server: false,
      watch: [from, through, view, certainty, status, search, dataVersion],
    },
  );

const {
  data: scheduleData,
  pending: schedulesPending,
  error: schedulesError,
  refresh: refreshSchedules,
} = await useAsyncData<ListCashflowSchedulesOutput>(
  scheduleKey,
  () =>
    api.listCashflowSchedules({
      directions: directions.value,
      certainties: certainty.value === "all" ? undefined : [certainty.value],
      asOf: new Date().toISOString(),
    }),
  { server: false, watch: [view, certainty, dataVersion] },
);

const occurrences = computed(() => data.value?.occurrences ?? []);
const displaySummaries = computed(() => data.value?.summaries ?? []);
const filteredSchedules = computed(() => {
  const query = search.value.trim().toLocaleLowerCase();
  return (scheduleData.value?.schedules ?? []).filter(
    (item) =>
      !query ||
      `${item.title} ${item.category?.name ?? ""}`
        .toLocaleLowerCase()
        .includes(query),
  );
});
const groupLabels: Record<CashflowTimingGroup, string> = {
  overdue: "Overdue",
  today: "Today",
  next_seven_days: "Next seven days",
  later_this_month: "Later this month",
  later: "Later",
  history: "History",
};
const groupOrder: CashflowTimingGroup[] = [
  "overdue",
  "today",
  "next_seven_days",
  "later_this_month",
  "later",
  "history",
];
const groups = computed(() =>
  groupOrder
    .map((key) => ({
      key,
      label: groupLabels[key],
      items: occurrences.value.filter((item) => item.timing.group === key),
    }))
    .filter((group) => group.items.length),
);

const queryMeta = computed(() =>
  view.value === "schedules" ? scheduleData.value?.meta : data.value?.meta,
);

function dateLabel(value: string) {
  return new Intl.DateTimeFormat("en-ZA", {
    weekday: "short",
    day: "numeric",
    month: "short",
    year: "numeric",
    timeZone: "UTC",
  }).format(new Date(`${value}T00:00:00Z`));
}

function reconciliation(item: CashflowOccurrenceView) {
  if (item.reconciled) return "Linked";
  if (item.status === "settled") return "Unreconciled";
  return "Not settled";
}

function selectView(next: (typeof tabs)[number]["id"]) {
  view.value = next;
}

function complete() {
  dataVersion.value += 1;
  selectedOccurrence.value = null;
  selectedScheduleId.value = null;
  void Promise.all([refresh(), refreshSchedules()]);
}
</script>

<template>
  <div class="upcoming-page">
    <header class="upcoming-header">
      <div>
        <p class="raven-eyebrow">Forward cashflow</p>
        <h1>Upcoming</h1>
        <span>See committed payments, expected income and recurring schedules before they become observed transactions.</span>
      </div>
      <button class="raven-button raven-button--primary" type="button" @click="openCommand('create-cashflow')">
        <span class="i-lucide-plus" />Schedule cashflow
      </button>
    </header>

    <section
      v-if="view !== 'schedules'"
      class="upcoming-totals"
      aria-label="Upcoming cashflow summaries"
    >
      <template
        v-for="summary in displaySummaries"
        :key="summary.currency"
      >
        <div>
          <span>Committed out / {{ summary.currency }}</span
          ><strong>{{ formatMoney(summary.committedOutflow) }}</strong>
        </div>
        <div>
          <span>Confirmed in / {{ summary.currency }}</span
          ><strong>{{ formatMoney(summary.confirmedInflow) }}</strong>
        </div>
        <div>
          <span>Expected in / {{ summary.currency }}</span
          ><strong>{{ formatMoney(summary.expectedInflow) }}</strong>
        </div>
        <div>
          <span>Possible in / {{ summary.currency }}</span
          ><strong>{{ formatMoney(summary.possibleInflow) }}</strong>
        </div>
        <div>
          <span>Due / unreconciled</span
          ><strong
            >{{ summary.dueCount }} / {{ summary.unreconciledCount }}</strong
          >
        </div>
      </template>
      <div v-if="!displaySummaries.length">
        <span>Scheduled money</span><strong>None</strong>
      </div>
    </section>

    <section class="upcoming-workspace raven-surface">
      <nav class="cashflow-tabs" aria-label="Cashflow views">
        <button
          v-for="tab in tabs"
          :key="tab.id"
          type="button"
          :class="{ active: view === tab.id }"
          @click="selectView(tab.id)"
        >
          {{ tab.label }}
        </button>
      </nav>
      <div class="upcoming-filters">
        <template v-if="view !== 'schedules'">
        <label><span>From</span><input v-model="from" type="date" /></label>
        <label
          ><span>Through</span><input v-model="through" type="date"
        /></label>
        <label
          ><span>Status</span
          ><select v-model="status">
            <option value="due">Due</option>
            <option value="all">All</option>
          </select></label
        >
        </template>
        <label
          ><span>Certainty</span
          ><select v-model="certainty">
            <option value="all">All</option>
            <option value="committed">Committed</option>
            <option value="confirmed">Confirmed</option>
            <option value="expected">Expected</option>
            <option value="possible">Possible</option>
          </select></label
        >
        <label class="upcoming-search"
          ><span>Search</span
          ><input
            v-model.trim="search"
            maxlength="160"
            type="search"
            placeholder="Title or category"
        /></label>
      </div>
    </section>

    <div
      v-if="
        queryMeta &&
        (queryMeta.quality !== 'complete' || queryMeta.warnings.length)
      "
      class="query-warning"
      role="status"
    >
      <span class="i-lucide-triangle-alert" />
      <span
        >{{ queryMeta.quality }} result<template
          v-if="queryMeta.warnings.length"
        >
          / {{ queryMeta.warnings.join(", ") }}</template
        ></span
      >
    </div>

    <template v-if="view === 'schedules'">
      <div v-if="schedulesError" class="accounts-error">
        <span>Cashflow schedules could not be loaded.</span
        ><button class="raven-button" @click="() => refreshSchedules()">
          Retry
        </button>
      </div>
      <div v-else-if="hydrated && schedulesPending" class="upcoming-loading">
        <div v-for="item in 5" :key="item" />
      </div>
      <div v-else-if="!filteredSchedules.length" class="raven-empty">
        <p>No schedules match this view.</p>
        <button class="raven-button" @click="openCommand('create-cashflow')">
          <span class="i-lucide-plus" />Schedule cashflow
        </button>
      </div>
      <div v-else class="upcoming-table-wrap">
        <table class="upcoming-table schedule-table">
          <thead>
            <tr>
              <th>Schedule</th>
              <th>Flow</th>
              <th>Scope</th>
              <th>Status</th>
              <th>Next due</th>
              <th class="money-cell">Amount</th>
              <th />
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in filteredSchedules" :key="item.id">
              <td>
                <button
                  class="cashflow-link"
                  type="button"
                  @click="selectedScheduleId = item.id"
                >
                  {{ item.title }}</button
                ><small>{{ item.recurrenceLabel }} / {{ item.timezone }}</small>
              </td>
              <td>
                <strong>{{ item.direction }}</strong
                ><small>{{ item.certainty }}</small>
              </td>
              <td>
                {{ item.account?.accountKey || "Unassigned"
                }}<small
                  >{{ item.category?.name || "Uncategorized" }} /
                  {{ item.spaceKey }}</small
                >
              </td>
              <td>
                <span
                  class="cashflow-status"
                  :class="`cashflow-status--${item.effectiveStatus}`"
                  >{{ item.effectiveStatus }}</span
                ><small
                  >configured {{ item.configuredStatus }} / revision
                  {{ item.revision }}</small
                >
              </td>
              <td>
                {{ item.nextDueOn || "None in horizon"
                }}<small v-if="item.pendingTransition"
                  >next {{ item.pendingTransition.status }}
                  {{ item.pendingTransition.effectiveOn }}</small
                ><small v-else>terms {{ item.termsEffectiveFrom }}</small>
              </td>
              <td class="money-cell" :class="`money-cell--${item.direction}`">
                <strong
                  >{{ item.direction === "outflow" ? "-" : "+"
                  }}{{ formatMoney(item.money) }}</strong
                >
              </td>
              <td>
                <button
                  class="raven-icon-button"
                  type="button"
                  title="Manage schedule"
                  aria-label="Manage schedule"
                  @click="selectedScheduleId = item.id"
                >
                  <span class="i-lucide-settings-2" />
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </template>

    <template v-else>
      <div v-if="error" class="accounts-error">
        <span>Upcoming cashflow could not be loaded.</span
        ><button class="raven-button" @click="() => refresh()">Retry</button>
      </div>
      <div v-else-if="hydrated && pending" class="upcoming-loading">
        <div v-for="item in 6" :key="item" />
      </div>
      <div v-else-if="!occurrences.length" class="raven-empty">
        <p>No cashflow occurrences in this horizon.</p>
        <button class="raven-button" @click="openCommand('create-cashflow')">
          <span class="i-lucide-plus" />Schedule cashflow
        </button>
      </div>
      <div v-else class="upcoming-table-wrap">
        <table class="upcoming-table">
          <thead>
            <tr>
              <th>Due</th>
              <th>Cashflow</th>
              <th>Flow</th>
              <th>Scope</th>
              <th>Status</th>
              <th class="money-cell">Amount</th>
              <th />
            </tr>
          </thead>
          <tbody>
            <template v-for="group in groups" :key="group.key">
              <tr class="cashflow-group">
                <td colspan="7">
                  {{ group.label }} <span>{{ group.items.length }}</span>
                </td>
              </tr>
              <tr
                v-for="item in group.items"
                :key="item.id"
                :class="{ 'is-terminal': item.status !== 'due' }"
              >
                <td>
                  <strong>{{ dateLabel(item.dueOn) }}</strong
                  ><small
                    >{{ item.timing.timezone }} / local
                    {{ item.timing.localToday }}</small
                  ><small v-if="item.dueOn !== item.scheduledDueOn"
                    >scheduled {{ item.scheduledDueOn }}</small
                  >
                </td>
                <td>
                  <button
                    class="cashflow-link"
                    type="button"
                    @click="selectedOccurrence = item"
                  >
                    {{ item.title }}</button
                  ><small>{{ item.recurrenceLabel }}</small>
                </td>
                <td>
                  <strong>{{ item.direction }}</strong
                  ><small>{{ item.certainty }}</small>
                </td>
                <td>
                  {{ item.account?.accountKey || "Unassigned"
                  }}<small
                    >{{ item.category?.name || "Uncategorized" }} /
                    {{ item.spaceKey }}</small
                  >
                </td>
                <td>
                  <span
                    class="cashflow-status"
                    :class="`cashflow-status--${item.status}`"
                    >{{ item.status }}</span
                  ><small
                    :class="{
                      'is-warning':
                        item.status === 'settled' && !item.reconciled,
                    }"
                    >{{ reconciliation(item) }}</small
                  >
                </td>
                <td class="money-cell" :class="`money-cell--${item.direction}`">
                  <strong
                    >{{ item.direction === "outflow" ? "-" : "+"
                    }}{{ formatMoney(item.money) }}</strong
                  ><small
                    v-if="
                      item.money.minorUnits !== item.scheduledMoney.minorUnits
                    "
                    >scheduled {{ formatMoney(item.scheduledMoney) }}</small
                  >
                </td>
                <td>
                  <button
                    class="raven-icon-button"
                    type="button"
                    title="Open schedule"
                    aria-label="Open schedule"
                    @click="selectedScheduleId = item.scheduleId"
                  >
                    <span class="i-lucide-repeat-2" />
                  </button>
                </td>
              </tr>
            </template>
          </tbody>
        </table>
      </div>
    </template>

    <CashflowOccurrenceDrawer
      :occurrence="selectedOccurrence"
      @close="selectedOccurrence = null"
      @complete="complete"
    />
    <CashflowScheduleDrawer
      :schedule-id="selectedScheduleId"
      @close="selectedScheduleId = null"
      @complete="complete"
    />
  </div>
</template>

<style scoped>
.upcoming-page {
  display: grid;
  gap: 24px;
}
.upcoming-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 24px;
  padding: 8px 0;
}
.upcoming-header h1 {
  margin: 5px 0 0;
  font-size: clamp(28px, 3vw, 36px);
  letter-spacing: -0.025em;
}
.upcoming-header > div > span {
  display: block;
  max-width: 650px;
  margin-top: 9px;
  color: var(--raven-muted);
  font-size: 11px;
  line-height: 1.5;
}
.upcoming-workspace {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 18px;
  padding: 8px;
}
.cashflow-tabs {
  display: flex;
  gap: 2px;
  width: max-content;
  max-width: 100%;
  overflow-x: auto;
  border: 1px solid var(--raven-border);
  border-radius: 7px;
  padding: 3px;
  background: var(--raven-bg);
}
.cashflow-tabs button {
  min-height: 31px;
  border: 0;
  border-radius: 5px;
  padding: 0 12px;
  color: var(--raven-faint);
  background: transparent;
  font: inherit;
  font-size: 10px;
  font-weight: 700;
  cursor: pointer;
}
.cashflow-tabs button.active {
  background: var(--raven-panel-subtle);
  color: var(--raven-text);
  box-shadow: inset 0 0 0 1px var(--raven-border);
}
.upcoming-totals {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(165px, 1fr));
  gap: 9px;
}
.upcoming-totals div {
  display: grid;
  gap: 7px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
  padding: 14px 15px;
  background: var(--raven-panel);
}
.upcoming-totals span,
.upcoming-filters span {
  color: var(--raven-faint);
  font-size: 8px;
  font-weight: 750;
  letter-spacing: 0.06em;
  text-transform: uppercase;
}
.upcoming-totals strong {
  font-size: 17px;
}
.upcoming-filters {
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-end;
  gap: 7px;
}
.upcoming-filters label {
  min-width: 115px;
  display: grid;
  gap: 4px;
}
.upcoming-filters .upcoming-search {
  min-width: min(220px, 100%);
}
.upcoming-filters input,
.upcoming-filters select {
  min-width: 0;
  height: 34px;
  border: 1px solid var(--raven-border);
  border-radius: 6px;
  padding: 0 9px;
  color: var(--raven-text);
  background: var(--raven-bg);
  font-size: 10px;
}
.query-warning {
  min-height: 42px;
  display: flex;
  align-items: center;
  gap: 9px;
  border: 1px solid color-mix(in srgb, var(--raven-warning) 38%, var(--raven-border));
  border-radius: var(--raven-radius-md);
  padding: 9px 12px;
  color: var(--raven-warning);
  background: var(--raven-warning-soft);
  font-size: 10px;
}
.upcoming-table-wrap {
  overflow-x: auto;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
  background: var(--raven-panel);
}
.upcoming-table {
  width: 100%;
  min-width: 940px;
  border-collapse: collapse;
}
.upcoming-table th {
  padding: 11px 12px;
  color: var(--raven-faint);
  font-size: 8px;
  font-weight: 750;
  letter-spacing: 0.06em;
  text-align: left;
  text-transform: uppercase;
}
.upcoming-table td {
  padding: 12px 11px;
  border-top: 1px solid var(--raven-border-subtle);
  vertical-align: middle;
  color: var(--raven-muted);
  font-size: 10px;
}
.upcoming-table td small {
  display: block;
  margin-top: 4px;
  color: var(--raven-faint);
  font-size: 8px;
}
.upcoming-table tr.is-terminal {
  opacity: 0.68;
}
.upcoming-table .cashflow-group td {
  padding: 9px 11px;
  color: var(--raven-faint);
  background: var(--raven-bg);
  font-size: 8px;
  font-weight: 700;
  text-transform: uppercase;
}
.cashflow-group span {
  margin-left: 5px;
  font-weight: 500;
}
.cashflow-link {
  border: 0;
  padding: 0;
  color: var(--raven-text);
  background: none;
  font: inherit;
  font-weight: 700;
  cursor: pointer;
}
.cashflow-link:hover {
  color: var(--raven-accent);
}
.cashflow-status {
  display: inline-flex;
  border: 1px solid var(--raven-border);
  border-radius: 999px;
  padding: 3px 7px;
  font-size: 8px;
  font-weight: 700;
  text-transform: capitalize;
}
.cashflow-status--due {
  color: var(--raven-accent);
  border-color: color-mix(in srgb, var(--raven-accent) 42%, var(--raven-border));
  background: var(--raven-accent-soft);
}
.is-warning {
  color: var(--raven-warning) !important;
}
.money-cell {
  text-align: right !important;
  white-space: nowrap;
}
.money-cell--inflow {
  color: var(--raven-accent);
}
.money-cell--outflow {
  color: var(--raven-text);
}
.upcoming-loading {
  display: grid;
  gap: 8px;
}
.upcoming-loading div {
  height: 56px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
  background: var(--raven-panel);
  animation: pulse 1.4s infinite;
}
@keyframes pulse {
  50% {
    opacity: 0.45;
  }
}
@media (max-width: 700px) {
  .upcoming-header {
    align-items: stretch;
    flex-direction: column;
  }
  .upcoming-workspace { align-items: stretch; flex-direction: column; }
  .upcoming-filters { justify-content: flex-start; }
  .upcoming-totals {
    grid-template-columns: repeat(2, 1fr);
  }
}
@media (max-width: 460px) {
  .upcoming-totals {
    grid-template-columns: 1fr;
  }
  .upcoming-totals div {
    border-right: 0;
    border-bottom: 1px solid var(--raven-border);
  }
  .upcoming-filters label {
    min-width: 100%;
  }
}
</style>
