<script setup lang="ts">
import { Menu } from "@ark-ui/vue/menu";

defineProps<{ disabled?: boolean }>();
const emit = defineEmits<{
  balance: [];
  expense: [];
  income: [];
  transfer: [];
  importStatement: [];
}>();

const actions = [
  {
    id: "balance",
    label: "Update balance",
    description: "Record balance evidence",
    icon: "i-lucide-scale",
  },
  {
    id: "expense",
    label: "Record expense",
    description: "Add an observed outflow",
    icon: "i-lucide-arrow-up-right",
  },
  {
    id: "income",
    label: "Record income",
    description: "Add an observed inflow",
    icon: "i-lucide-arrow-down-left",
  },
  {
    id: "transfer",
    label: "Record transfer",
    description: "Move money between accounts",
    icon: "i-lucide-arrow-left-right",
  },
  {
    id: "import-statement",
    label: "Import statement",
    description: "Preview immutable bank source",
    icon: "i-lucide-file-input",
  },
] as const;

const run = (id: (typeof actions)[number]["id"]) => {
  if (id === "balance") emit("balance");
  if (id === "expense") emit("expense");
  if (id === "income") emit("income");
  if (id === "transfer") emit("transfer");
  if (id === "import-statement") emit("importStatement");
};
</script>

<template>
  <Menu.Root>
    <Menu.Trigger as-child>
      <button
        class="account-actions-trigger"
        type="button"
        :disabled="disabled"
      >
        <span
          class="account-actions-trigger__icon i-lucide-plus"
          aria-hidden="true"
        />
        <strong>Account actions</strong>
        <span class="i-lucide-chevron-down" aria-hidden="true" />
      </button>
    </Menu.Trigger>
    <Teleport to="body">
      <Menu.Positioner class="account-actions-positioner">
        <Menu.Content class="account-actions-menu">
          <Menu.Item
            v-for="action in actions"
            :key="action.id"
            :value="action.id"
            class="account-actions-menu__item"
            @click="run(action.id)"
          >
            <span :class="action.icon" aria-hidden="true" />
            <span>
              <strong>{{ action.label }}</strong>
              <small>{{ action.description }}</small>
            </span>
          </Menu.Item>
        </Menu.Content>
      </Menu.Positioner>
    </Teleport>
  </Menu.Root>
</template>

<style scoped>
.account-actions-trigger {
  min-width: 146px;
  min-height: 36px;
  display: grid;
  grid-template-columns: 18px minmax(0, 1fr) 14px;
  align-items: center;
  gap: 8px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
  padding: 6px 10px;
  color: var(--raven-text);
  background: var(--raven-panel);
  text-align: left;
  cursor: pointer;
}

.account-actions-trigger:hover {
  border-color: color-mix(
    in srgb,
    var(--raven-accent) 55%,
    var(--raven-border)
  );
  background: var(--raven-panel-subtle);
}

.account-actions-trigger:disabled {
  cursor: not-allowed;
  opacity: 0.55;
}

.account-actions-trigger__icon {
  color: var(--raven-accent);
  font-size: 15px;
}

.account-actions-trigger strong,
.account-actions-trigger small,
.account-actions-menu__item strong,
.account-actions-menu__item small {
  display: block;
}

.account-actions-trigger strong {
  font-size: 11px;
}

.account-actions-positioner {
  z-index: 76;
}

.account-actions-menu {
  min-width: 280px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
  padding: 6px;
  background: var(--raven-panel);
  box-shadow: var(--raven-shadow);
}

.account-actions-menu__item {
  min-height: 54px;
  display: grid;
  grid-template-columns: 22px minmax(0, 1fr);
  align-items: center;
  gap: 10px;
  border-radius: 6px;
  padding: 8px 10px;
  outline: none;
  cursor: pointer;
}

.account-actions-menu__item[data-highlighted] {
  background: var(--raven-panel-subtle);
}

.account-actions-menu__item strong {
  font-size: 13px;
}

.account-actions-menu__item small {
  margin-top: 3px;
  color: var(--raven-muted);
  font-size: 10px;
}
</style>
