<script setup lang="ts">
export type RavenQueryInputOption = {
  value: string;
  label: string;
  description?: string;
};

const props = withDefaults(
  defineProps<{
    modelValue: string;
    options: RavenQueryInputOption[];
    label?: string;
    placeholder?: string;
    creatable?: boolean;
    createLabel?: string;
    emptyMessage?: string;
  }>(),
  {
    placeholder: "Search options…",
    creatable: false,
    createLabel: "Create",
    emptyMessage: "No matching options.",
  },
);

const emit = defineEmits<{
  "update:modelValue": [value: string];
  create: [label: string];
}>();

const listboxId = useId();
const query = ref("");
const open = ref(false);
const activeIndex = ref(0);

const selectedOption = computed(
  () =>
    props.options.find((option) => option.value === props.modelValue) ?? null,
);

const normalizedQuery = computed(() => query.value.trim().toLocaleLowerCase());
const queryMatchesSelection = computed(
  () =>
    Boolean(selectedOption.value) &&
    normalizedQuery.value ===
      selectedOption.value?.label.trim().toLocaleLowerCase(),
);
const filteredOptions = computed(() => {
  if (!normalizedQuery.value || queryMatchesSelection.value)
    return props.options;
  return props.options.filter((option) =>
    `${option.label} ${option.description ?? ""}`
      .toLocaleLowerCase()
      .includes(normalizedQuery.value),
  );
});
const exactQueryOption = computed(() =>
  props.options.find(
    (option) =>
      option.label.trim().toLocaleLowerCase() === normalizedQuery.value,
  ),
);
const canCreate = computed(
  () =>
    props.creatable &&
    Boolean(query.value.trim()) &&
    !exactQueryOption.value &&
    !queryMatchesSelection.value,
);

watch(
  () => [props.modelValue, props.options] as const,
  () => {
    query.value = selectedOption.value?.label ?? "";
  },
  { deep: true, immediate: true },
);

watch(filteredOptions, () => {
  activeIndex.value = 0;
});

function selectOption(option: RavenQueryInputOption) {
  emit("update:modelValue", option.value);
  query.value = option.label;
  open.value = false;
}

function createOption() {
  const label = query.value.trim();
  if (!label || !canCreate.value) return;
  emit("create", label);
  open.value = false;
}

function restoreSelection() {
  query.value = selectedOption.value?.label ?? "";
  open.value = false;
}

function handleFocus(event: FocusEvent) {
  open.value = true;
  window.setTimeout(
    () => (event.target as HTMLInputElement | null)?.select(),
    0,
  );
}

function handleInput() {
  open.value = true;
}

function handleKeydown(event: KeyboardEvent) {
  if (event.key === "Escape") {
    event.preventDefault();
    restoreSelection();
    return;
  }

  if (event.key === "ArrowDown" || event.key === "ArrowUp") {
    event.preventDefault();
    open.value = true;
    const direction = event.key === "ArrowDown" ? 1 : -1;
    const count = filteredOptions.value.length;
    if (count) {
      activeIndex.value = (activeIndex.value + direction + count) % count;
    }
    return;
  }

  if (event.key !== "Enter") return;
  event.preventDefault();

  if (exactQueryOption.value) {
    selectOption(exactQueryOption.value);
    return;
  }
  if (canCreate.value) {
    createOption();
    return;
  }
  const option = filteredOptions.value[activeIndex.value];
  if (option) selectOption(option);
}

function handleBlur() {
  window.setTimeout(() => {
    if (open.value) restoreSelection();
  }, 120);
}
</script>

<template>
  <div class="rqi" data-rqi>
    <div class="rqi__control">
      <span class="i-lucide-search" aria-hidden="true" />
      <input
        v-model="query"
        role="combobox"
        :aria-label="label"
        :aria-expanded="open"
        :aria-controls="listboxId"
        aria-autocomplete="list"
        :aria-activedescendant="
          open && filteredOptions[activeIndex]
            ? `${listboxId}-${activeIndex}`
            : undefined
        "
        autocomplete="off"
        :placeholder="placeholder"
        @focus="handleFocus"
        @input="handleInput"
        @keydown="handleKeydown"
        @blur="handleBlur"
      />
      <button
        type="button"
        :aria-label="open ? 'Close options' : 'Open options'"
        @mousedown.prevent
        @click="open = !open"
      >
        <span
          :class="open ? 'i-lucide-chevron-up' : 'i-lucide-chevrons-up-down'"
          aria-hidden="true"
        />
      </button>
    </div>

    <div v-if="open" :id="listboxId" class="rqi__popover" role="listbox">
      <button
        v-for="(option, index) in filteredOptions"
        :id="`${listboxId}-${index}`"
        :key="option.value || '__empty'"
        type="button"
        role="option"
        :aria-selected="option.value === modelValue"
        :class="{ 'rqi__option--active': activeIndex === index }"
        @mouseenter="activeIndex = index"
        @mousedown.prevent="selectOption(option)"
      >
        <span>
          <strong>{{ option.label }}</strong>
          <small v-if="option.description">{{ option.description }}</small>
        </span>
        <span
          v-if="option.value === modelValue"
          class="i-lucide-check"
          aria-hidden="true"
        />
      </button>

      <button
        v-if="canCreate"
        class="rqi__create"
        type="button"
        @mousedown.prevent="createOption"
      >
        <span class="i-lucide-folder-plus" aria-hidden="true" />
        <span>
          <strong>{{ createLabel }} “{{ query.trim() }}”</strong>
          <small>Press Enter to create and select it</small>
        </span>
      </button>

      <p v-if="!filteredOptions.length && !canCreate">{{ emptyMessage }}</p>
    </div>

    <small v-if="creatable" class="rqi__hint">
      Search existing options, or type a new name and press Enter.
    </small>
  </div>
</template>

<style scoped>
.rqi {
  position: relative;
  display: grid;
  gap: 5px;
}

.rqi__control {
  min-height: 40px;
  display: grid;
  grid-template-columns: 18px minmax(0, 1fr) 32px;
  align-items: center;
  gap: 7px;
  border: 1px solid var(--raven-border);
  border-radius: 8px;
  padding-left: 10px;
  background: var(--raven-panel);
}

.rqi__control:focus-within {
  border-color: var(--raven-accent);
  box-shadow: 0 0 0 2px var(--raven-accent-soft);
}

.rqi__control > span {
  color: var(--raven-faint);
  font-size: 13px;
}

.rqi__control input {
  width: 100%;
  min-width: 0;
  height: 38px;
  border: 0;
  outline: 0;
  padding: 0;
  background: transparent;
  color: var(--raven-text);
  font: inherit;
}

.rqi__control button {
  width: 32px;
  height: 38px;
  display: grid;
  place-items: center;
  border: 0;
  background: transparent;
  color: var(--raven-muted);
  cursor: pointer;
}

.rqi__popover {
  position: absolute;
  z-index: 40;
  top: 45px;
  right: 0;
  left: 0;
  max-height: 240px;
  display: grid;
  overflow-y: auto;
  border: 1px solid var(--raven-border);
  border-radius: 10px;
  background: var(--raven-panel-raised);
  box-shadow: 0 18px 48px rgb(0 0 0 / 0.34);
}

.rqi__popover > button {
  min-height: 42px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  border: 0;
  border-bottom: 1px solid var(--raven-border);
  padding: 8px 10px;
  background: transparent;
  color: var(--raven-text);
  font: inherit;
  text-align: left;
  cursor: pointer;
}

.rqi__popover > button:last-of-type {
  border-bottom: 0;
}

.rqi__popover > button:hover,
.rqi__option--active {
  background: var(--raven-panel);
}

.rqi__popover button > span:first-child {
  min-width: 0;
  display: grid;
  gap: 2px;
}

.rqi__popover strong {
  overflow: hidden;
  font-size: 11px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.rqi__popover small {
  overflow: hidden;
  color: var(--raven-faint);
  font-size: 9px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.rqi__popover > p {
  margin: 0;
  padding: 12px;
  color: var(--raven-faint);
  font-size: 10px;
}

.rqi__create {
  justify-content: flex-start !important;
  color: var(--raven-accent) !important;
}

.rqi__create > span:first-child {
  flex: 0 0 auto;
}

.rqi__hint {
  color: var(--raven-faint);
  font-size: 9px;
}
</style>
