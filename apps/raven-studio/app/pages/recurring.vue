<script setup lang="ts">
import {
  formatMoney,
  type CashflowScheduleView,
  type ListCashflowSchedulesOutput,
} from "@raven/domain";

useHead({ title: "Recurring · Raven" });

const api = useAccountControlApi();
const { openCommand, dataVersion } = useRavenActions();
const search = ref("");
const status = ref<"current" | "all">("current");
const hydrated = ref(false);
const selectedScheduleId = ref<string | null>(null);

onMounted(() => {
  hydrated.value = true;
});

const queryKey = computed(
  () => `recurring-schedules:${status.value}:${dataVersion.value}`,
);
const {
  data,
  pending,
  error,
  refresh,
} = await useAsyncData<ListCashflowSchedulesOutput>(
  queryKey,
  () => api.listCashflowSchedules({ asOf: new Date().toISOString() }),
  { server: false, watch: [status, dataVersion] },
);

const recurringSchedules = computed(() => {
  const query = search.value.trim().toLocaleLowerCase();
  return (data.value?.schedules ?? []).filter((schedule) => {
    if (schedule.cadence === "once") return false;
    if (
      status.value === "current" &&
      !["active", "paused"].includes(schedule.effectiveStatus)
    ) {
      return false;
    }
    return (
      !query ||
      `${schedule.title} ${schedule.category?.name ?? ""} ${schedule.account?.accountKey ?? ""} ${schedule.spaceKey}`
        .toLocaleLowerCase()
        .includes(query)
    );
  });
});

const incoming = computed(() =>
  recurringSchedules.value.filter((schedule) => schedule.direction === "inflow"),
);
const outgoing = computed(() =>
  recurringSchedules.value.filter((schedule) => schedule.direction === "outflow"),
);

function dateLabel(value: string | null) {
  if (!value) return "No next occurrence";
  return new Intl.DateTimeFormat("en-ZA", {
    day: "numeric",
    month: "short",
    year: "numeric",
    timeZone: "UTC",
  }).format(new Date(`${value}T00:00:00Z`));
}

function complete() {
  dataVersion.value += 1;
  selectedScheduleId.value = null;
  void refresh();
}

function createIncome() {
  openCommand("create-expected-income");
}

function createExpense() {
  openCommand("create-upcoming-payment");
}
</script>

<template>
  <div class="recurring-page">
    <header class="recurring-header">
      <div>
        <p class="raven-eyebrow">Expected money</p>
        <h1>Recurring</h1>
        <span>
          Define repeating income and expenses once, project their future
          occurrences, and link actual occurrences to observed transactions.
        </span>
      </div>
      <div class="recurring-header__actions">
        <button class="raven-button" type="button" @click="createIncome">
          <span class="i-lucide-plus" />Recurring income
        </button>
        <button
          class="raven-button raven-button--primary"
          type="button"
          @click="createExpense"
        >
          <span class="i-lucide-plus" />Recurring expense
        </button>
      </div>
    </header>

    <section class="recurring-toolbar raven-surface">
      <label>
        <span>Search</span>
        <input
          v-model.trim="search"
          type="search"
          maxlength="160"
          placeholder="Name, category, account or space"
        />
      </label>
      <label>
        <span>Status</span>
        <select v-model="status">
          <option value="current">Current</option>
          <option value="all">All history</option>
        </select>
      </label>
    </section>

    <div v-if="error" class="accounts-error">
      <span>Recurring cashflow could not be loaded.</span>
      <button class="raven-button" type="button" @click="() => refresh()">
        Retry
      </button>
    </div>
    <div v-else-if="hydrated && pending" class="recurring-loading">
      <div v-for="item in 6" :key="item" />
    </div>

    <main v-else class="recurring-columns">
      <RecurringScheduleColumn
        title="Recurring income"
        description="Money expected to arrive repeatedly."
        empty-message="No recurring income has been defined."
        tone="income"
        :schedules="incoming"
        :date-label="dateLabel"
        :format-money="formatMoney"
        @create="createIncome"
        @select="selectedScheduleId = $event"
      />
      <RecurringScheduleColumn
        title="Recurring expenses"
        description="Money expected to leave repeatedly."
        empty-message="No recurring expenses have been defined."
        tone="expense"
        :schedules="outgoing"
        :date-label="dateLabel"
        :format-money="formatMoney"
        @create="createExpense"
        @select="selectedScheduleId = $event"
      />
    </main>

    <CashflowScheduleDrawer
      :schedule-id="selectedScheduleId"
      @close="selectedScheduleId = null"
      @complete="complete"
    />
  </div>
</template>

<style scoped>
.recurring-page {
  display: grid;
  gap: 22px;
}

.recurring-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  padding: 8px 0;
}

.recurring-header h1 {
  margin: 5px 0 0;
  font-size: clamp(28px, 3vw, 36px);
  letter-spacing: -0.025em;
}

.recurring-header > div:first-child > span {
  display: block;
  max-width: 680px;
  margin-top: 9px;
  color: var(--raven-muted);
  font-size: 11px;
  line-height: 1.55;
}

.recurring-header__actions {
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-end;
  gap: 8px;
}

.recurring-toolbar {
  display: flex;
  align-items: end;
  justify-content: flex-end;
  gap: 8px;
  padding: 9px;
}

.recurring-toolbar label {
  display: grid;
  gap: 5px;
  min-width: 150px;
}

.recurring-toolbar label:first-child {
  width: min(360px, 100%);
}

.recurring-toolbar span {
  color: var(--raven-faint);
  font-size: 8px;
  font-weight: 750;
  letter-spacing: 0.06em;
  text-transform: uppercase;
}

.recurring-toolbar input,
.recurring-toolbar select {
  min-width: 0;
  height: 35px;
  border: 1px solid var(--raven-border);
  border-radius: 6px;
  padding: 0 10px;
  color: var(--raven-text);
  background: var(--raven-bg);
  font: inherit;
  font-size: 10px;
}

.recurring-columns {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
  gap: 14px;
  align-items: start;
}

.recurring-loading {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
}

.recurring-loading div {
  height: 110px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
  background: var(--raven-panel);
  animation: raven-pulse 1.4s ease-in-out infinite;
}

@media (max-width: 880px) {
  .recurring-header,
  .recurring-toolbar {
    align-items: stretch;
    flex-direction: column;
  }

  .recurring-header__actions {
    justify-content: flex-start;
  }

  .recurring-toolbar label,
  .recurring-toolbar label:first-child {
    width: 100%;
  }

  .recurring-columns,
  .recurring-loading {
    grid-template-columns: 1fr;
  }
}
</style>
