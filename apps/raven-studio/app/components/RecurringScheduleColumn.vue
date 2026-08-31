<script setup lang="ts">
import type { CashflowScheduleView, MoneyWire } from "@raven/domain";

defineProps<{
  title: string;
  description: string;
  emptyMessage: string;
  tone: "income" | "expense";
  schedules: CashflowScheduleView[];
  dateLabel: (value: string | null) => string;
  formatMoney: (value: MoneyWire) => string;
}>();

defineEmits<{
  create: [];
  select: [scheduleId: string];
}>();
</script>

<template>
  <section class="schedule-column raven-surface" :class="`schedule-column--${tone}`">
    <header>
      <div>
        <p>{{ title }}</p>
        <span>{{ description }}</span>
      </div>
      <span class="schedule-count">{{ schedules.length }}</span>
    </header>

    <div v-if="!schedules.length" class="schedule-empty">
      <span :class="tone === 'income' ? 'i-lucide-arrow-down-left' : 'i-lucide-arrow-up-right'" />
      <p>{{ emptyMessage }}</p>
      <button class="raven-button" type="button" @click="$emit('create')">
        <span class="i-lucide-plus" />Add one
      </button>
    </div>

    <div v-else class="schedule-list">
      <button
        v-for="schedule in schedules"
        :key="schedule.id"
        class="schedule-row"
        type="button"
        @click="$emit('select', schedule.id)"
      >
        <span class="schedule-row__identity">
          <strong>{{ schedule.title }}</strong>
          <small>
            {{ schedule.recurrenceLabel }} ·
            {{ schedule.account?.accountKey || schedule.spaceKey }}
          </small>
          <small>
            {{ schedule.category?.name || "Uncategorized" }} · next
            {{ dateLabel(schedule.nextDueOn) }}
          </small>
        </span>
        <span class="schedule-row__amount">
          <strong>{{ schedule.direction === "outflow" ? "−" : "+" }}{{ formatMoney(schedule.money) }}</strong>
          <small :class="`schedule-status schedule-status--${schedule.effectiveStatus}`">
            {{ schedule.effectiveStatus }}
          </small>
        </span>
      </button>
      <button class="schedule-add" type="button" @click="$emit('create')">
        <span class="i-lucide-plus" />Add {{ tone === "income" ? "income" : "expense" }}
      </button>
    </div>
  </section>
</template>

<style scoped>
.schedule-column {
  min-width: 0;
  overflow: hidden;
}

.schedule-column > header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  border-bottom: 1px solid var(--raven-border);
  padding: 15px 16px;
}

.schedule-column > header p {
  margin: 0;
  color: var(--raven-text);
  font-size: 13px;
  font-weight: 750;
}

.schedule-column > header span:not(.schedule-count),
.schedule-row small {
  color: var(--raven-faint);
  font-size: 8px;
}

.schedule-column > header div > span {
  display: block;
  margin-top: 4px;
}

.schedule-count {
  min-width: 28px;
  min-height: 25px;
  display: grid;
  place-items: center;
  border-radius: 999px;
  background: var(--raven-panel-subtle);
  color: var(--raven-muted);
  font-size: 9px;
  font-weight: 750;
}

.schedule-empty {
  min-height: 240px;
  display: grid;
  place-items: center;
  align-content: center;
  gap: 12px;
  padding: 30px;
  color: var(--raven-faint);
  text-align: center;
}

.schedule-empty > span {
  font-size: 24px;
}

.schedule-empty p {
  margin: 0;
  font-size: 10px;
}

.schedule-list {
  display: grid;
}

.schedule-row,
.schedule-add {
  width: 100%;
  border: 0;
  border-top: 1px solid var(--raven-border-subtle);
  padding: 13px 15px;
  color: inherit;
  background: transparent;
  font: inherit;
  text-align: left;
  cursor: pointer;
}

.schedule-row:first-child {
  border-top: 0;
}

.schedule-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
}

.schedule-row:hover,
.schedule-row:focus-visible,
.schedule-add:hover,
.schedule-add:focus-visible {
  background: var(--raven-panel-subtle);
  outline: none;
}

.schedule-row__identity,
.schedule-row__amount {
  min-width: 0;
  display: grid;
  gap: 4px;
}

.schedule-row__identity strong {
  overflow: hidden;
  color: var(--raven-text);
  font-size: 10px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.schedule-row__amount {
  justify-items: end;
  flex: 0 0 auto;
}

.schedule-row__amount strong {
  font-size: 11px;
}

.schedule-column--income .schedule-row__amount strong {
  color: var(--raven-success);
}

.schedule-column--expense .schedule-row__amount strong {
  color: var(--raven-danger);
}

.schedule-status {
  text-transform: capitalize;
}

.schedule-add {
  color: var(--raven-muted);
  font-size: 9px;
  font-weight: 700;
}
</style>
