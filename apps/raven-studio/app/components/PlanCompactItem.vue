<script setup lang="ts">
type PlanItemView = {
  id: string;
  label: string;
  monthlyRands: number;
  note: string;
};

defineProps<{
  item: PlanItemView;
  derived?: boolean;
  nested?: boolean;
  allowSubItems?: boolean;
}>();

defineEmits<{
  edit: [];
  addSubItem: [];
}>();

const compactRands = new Intl.NumberFormat("en-ZA", {
  minimumFractionDigits: 0,
  maximumFractionDigits: 2,
});

function formatCompactRands(value: number): string {
  const safe = Number.isFinite(value) ? Math.max(0, value) : 0;
  return `R ${compactRands.format(safe)}`;
}
</script>

<template>
  <div
    class="compact-plan-item"
    :class="{
      'compact-plan-item--derived': derived,
      'compact-plan-item--nested': nested,
      'compact-plan-item--has-add': allowSubItems,
    }"
  >
    <span
      v-if="!derived"
      class="compact-plan-item__grip i-lucide-grip-vertical"
      aria-hidden="true"
    />
    <span
      v-else
      class="compact-plan-item__grip i-lucide-calculator"
      aria-hidden="true"
    />

    <button
      class="compact-plan-item__summary"
      type="button"
      :disabled="derived"
      :title="derived ? item.note : `Edit ${item.label || 'item'}`"
      @click="$emit('edit')"
    >
      <strong>{{ item.label || "Untitled item" }}</strong>
      <span class="compact-plan-item__pipe" aria-hidden="true">|</span>
      <span
        class="compact-plan-item__description"
        :title="item.note || 'No description yet'"
      >
        {{ item.note || "No description yet" }}
      </span>
    </button>

    <strong class="compact-plan-item__value">
      {{ formatCompactRands(item.monthlyRands) }}
    </strong>

    <button
      v-if="allowSubItems && !derived"
      class="compact-plan-item__add raven-icon-button"
      type="button"
      :aria-label="`Add sub-item to ${item.label || 'item'}`"
      :title="`Add sub-item to ${item.label || 'item'}`"
      @click="$emit('addSubItem')"
    >
      <span class="i-lucide-list-plus" aria-hidden="true" />
    </button>

    <button
      v-if="!derived"
      class="compact-plan-item__edit raven-icon-button"
      type="button"
      :aria-label="`Edit ${item.label || 'item'}`"
      @click="$emit('edit')"
    >
      <span class="i-lucide-pencil" aria-hidden="true" />
    </button>
    <span
      v-else
      class="compact-plan-item__lock i-lucide-lock-keyhole"
      aria-label="Calculated by Raven"
      title="Calculated by Raven"
    />
  </div>
</template>

<style scoped>
.compact-plan-item {
  min-height: 46px;
  display: grid;
  grid-template-columns: 16px minmax(0, 1fr) auto 28px;
  align-items: center;
  gap: 8px;
  border-bottom: 1px solid var(--raven-border);
  padding: 0 12px;
  background: var(--raven-panel);
}

.compact-plan-item[draggable="true"] {
  cursor: grab;
}

.compact-plan-item[draggable="true"]:active {
  cursor: grabbing;
}

.compact-plan-item--derived {
  background: color-mix(
    in srgb,
    var(--raven-accent-soft) 35%,
    var(--raven-panel)
  );
}

.compact-plan-item--nested {
  padding-left: 34px;
  background: color-mix(
    in srgb,
    var(--raven-panel-raised) 45%,
    var(--raven-panel)
  );
}

.compact-plan-item--nested .compact-plan-item__grip {
  opacity: 0.65;
}

.compact-plan-item--has-add {
  grid-template-columns: 16px minmax(0, 1fr) auto 28px 28px;
}

.compact-plan-item__grip {
  color: var(--raven-faint);
  font-size: 13px;
}

.compact-plan-item__summary {
  min-width: 0;
  display: flex;
  align-items: baseline;
  gap: 8px;
  border: 0;
  padding: 0;
  overflow: hidden;
  background: transparent;
  color: inherit;
  font: inherit;
  text-align: left;
  cursor: pointer;
}

.compact-plan-item__summary:disabled {
  cursor: default;
}

.compact-plan-item__summary strong {
  flex: 0 0 auto;
  max-width: 44%;
  overflow: hidden;
  font-size: 12px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.compact-plan-item__pipe {
  flex: 0 0 auto;
  color: var(--raven-border-strong);
}

.compact-plan-item__description {
  min-width: 0;
  overflow: hidden;
  color: var(--raven-muted);
  font-size: 11px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.compact-plan-item__value {
  font-size: 12px;
  font-variant-numeric: tabular-nums;
  white-space: nowrap;
}

.compact-plan-item__add,
.compact-plan-item__edit {
  width: 28px;
  height: 28px;
  min-height: 28px;
}

.compact-plan-item__add {
  color: var(--raven-accent);
}

.compact-plan-item__lock {
  justify-self: center;
  color: var(--raven-faint);
  font-size: 12px;
}

@media (max-width: 560px) {
  .compact-plan-item {
    grid-template-columns: 14px minmax(0, 1fr) auto 26px;
    padding-inline: 8px;
  }

  .compact-plan-item--nested {
    padding-left: 24px;
  }

  .compact-plan-item--has-add {
    grid-template-columns: 14px minmax(0, 1fr) auto 26px 26px;
  }

  .compact-plan-item__description,
  .compact-plan-item__pipe {
    display: none;
  }

  .compact-plan-item__summary strong {
    max-width: 100%;
  }
}
</style>
