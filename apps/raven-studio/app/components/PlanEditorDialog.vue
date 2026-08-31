<script setup lang="ts">
import { Dialog } from "@ark-ui/vue/dialog";

type PlanLane = "personal" | "business";
type PlanEditorMode = "item" | "section";
type PlanTaxTreatment = "none" | "personal" | "business_deductible";

type PlanEditorValue = {
  id: string;
  label: string;
  note: string;
  monthlyRands: number;
  sectionId: string;
  parentItemId: string;
  taxTreatment: PlanTaxTreatment;
};

type PlanEditorSectionDraft = {
  id: string;
  title: string;
};

const props = defineProps<{
  open: boolean;
  mode: PlanEditorMode;
  lane: PlanLane;
  value: PlanEditorValue;
  sections: Array<{ id: string; title: string }>;
  items: Array<{
    id: string;
    label: string;
    sectionId: string;
    parentItemId?: string;
  }>;
}>();

const emit = defineEmits<{
  close: [];
  remove: [];
  save: [value: PlanEditorValue, createdSections: PlanEditorSectionDraft[]];
}>();

const form = reactive<PlanEditorValue>({ ...props.value });
const createdSections = ref<PlanEditorSectionDraft[]>([]);

const sectionOptions = computed(() => [
  {
    value: "",
    label: "No category",
    description: "Leave this item uncategorized",
  },
  ...props.sections.map((section) => ({
    value: section.id,
    label: section.title,
  })),
  ...createdSections.value.map((section) => ({
    value: section.id,
    label: section.title,
    description: "New category",
  })),
]);

const itemHasChildren = computed(
  () =>
    Boolean(form.id) &&
    props.items.some((item) => item.parentItemId === form.id),
);

const parentItemOptions = computed(() => [
  {
    value: "",
    label: "No parent item",
    description: "Keep this as a top-level budget item",
  },
  ...props.items
    .filter(
      (item) =>
        item.id !== form.id &&
        !item.parentItemId &&
        item.sectionId === form.sectionId,
    )
    .map((item) => ({
      value: item.id,
      label: item.label,
      description: "Budget item in this category",
    })),
]);

const taxTreatmentOptions = [
  {
    value: "none",
    label: "No direct tax effect",
    description: "Keep this category outside the working tax classification.",
  },
  {
    value: "personal",
    label: "Personal tax consideration",
    description: "Flag the category for later personal-tax review.",
  },
  {
    value: "business_deductible",
    label: "Business-deductible expense",
    description: "Treat this as a working business deduction assumption.",
  },
];

const title = computed(() => {
  const action = props.value.id ? "Edit" : "Add";
  const subject =
    props.mode === "section"
      ? "category"
      : form.parentItemId
        ? "sub-item"
        : "item";
  return `${action} ${props.lane} ${subject}`;
});

watch(
  () => [props.open, props.value] as const,
  ([open, value]) => {
    if (!open) return;
    Object.assign(form, value);
    createdSections.value = [];
  },
  { deep: true, immediate: true },
);

watch(
  () => form.sectionId,
  (sectionId) => {
    if (!form.parentItemId) return;
    const parentStillValid = props.items.some(
      (item) =>
        item.id === form.parentItemId &&
        !item.parentItemId &&
        item.sectionId === sectionId,
    );
    if (!parentStillValid) form.parentItemId = "";
  },
);

function submit() {
  const label = form.label.trim();
  if (!label) return;

  emit(
    "save",
    {
      ...form,
      label,
      note: form.note.trim(),
      monthlyRands:
        props.mode === "item" ? Math.max(0, Number(form.monthlyRands) || 0) : 0,
      sectionId: props.mode === "item" ? form.sectionId : "",
      parentItemId: props.mode === "item" ? form.parentItemId : "",
      taxTreatment: props.mode === "section" ? form.taxTreatment : "none",
    },
    createdSections.value.map((section) => ({ ...section })),
  );
}

function createSection(label: string) {
  const normalized = label.trim();
  if (!normalized) return;
  const id = `${props.lane}-section-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
  createdSections.value.push({ id, title: normalized });
  form.sectionId = id;
}
</script>

<template>
  <Dialog.Root
    :open="open"
    @open-change="({ open: nextOpen }) => !nextOpen && $emit('close')"
  >
    <Teleport to="body">
      <Dialog.Backdrop class="raven-dialog-backdrop" />
      <Dialog.Positioner class="raven-dialog-positioner">
        <Dialog.Content class="raven-dialog plan-editor-dialog">
          <header class="raven-dialog__header">
            <div>
              <Dialog.Title class="raven-dialog__title">{{
                title
              }}</Dialog.Title>
              <p class="plan-editor-dialog__context">
                {{
                  mode === "section"
                    ? "Organize the plan and record what this category represents."
                    : form.parentItemId
                      ? "Detail one component of a budget item without counting it twice."
                      : "Set the working monthly assumption and place it in a category."
                }}
              </p>
            </div>
            <Dialog.CloseTrigger as-child>
              <button
                class="raven-icon-button"
                type="button"
                aria-label="Close plan editor"
              >
                <span class="i-lucide-x" aria-hidden="true" />
              </button>
            </Dialog.CloseTrigger>
          </header>

          <form @submit.prevent="submit">
            <div class="raven-dialog__body raven-form-grid">
              <label class="raven-field raven-field--wide">
                <span>{{
                  mode === "section" ? "Category name" : "Item name"
                }}</span>
                <input
                  v-model="form.label"
                  required
                  autocomplete="off"
                  :placeholder="
                    mode === 'section' ? 'e.g. Maintenance' : 'e.g. School fees'
                  "
                />
              </label>

              <template v-if="mode === 'item'">
                <label class="raven-field">
                  <span>Monthly amount (ZAR)</span>
                  <input
                    v-model.number="form.monthlyRands"
                    type="number"
                    min="0"
                    step="0.01"
                    inputmode="decimal"
                    required
                  />
                </label>
                <label class="raven-field">
                  <span>Category</span>
                  <RavenQueryInput
                    v-model="form.sectionId"
                    :options="sectionOptions"
                    label="Category"
                    placeholder="Search or create a category…"
                    creatable
                    create-label="Create category"
                    @create="createSection"
                  />
                </label>
                <label
                  v-if="!itemHasChildren"
                  class="raven-field raven-field--wide"
                >
                  <span>Parent budget item</span>
                  <RavenQueryInput
                    v-model="form.parentItemId"
                    :options="parentItemOptions"
                    label="Parent budget item"
                    placeholder="Keep top-level or choose a budget item…"
                  />
                </label>
                <div
                  v-else
                  class="raven-field raven-field--wide plan-editor-dialog__locked"
                >
                  <span>Budget item</span>
                  <p>
                    This item already contains sub-items and therefore remains
                    top-level.
                  </p>
                </div>
              </template>

              <label v-else class="raven-field raven-field--wide">
                <span>Tax treatment</span>
                <RavenQueryInput
                  v-model="form.taxTreatment"
                  :options="taxTreatmentOptions"
                  label="Tax treatment"
                  placeholder="Search tax treatments…"
                />
              </label>

              <label class="raven-field raven-field--wide">
                <span>{{
                  mode === "section" ? "Category note" : "Description"
                }}</span>
                <textarea
                  v-model="form.note"
                  rows="4"
                  :placeholder="
                    mode === 'section'
                      ? 'What belongs in this category?'
                      : 'What does this monthly item cover?'
                  "
                />
              </label>
            </div>

            <footer class="raven-dialog__footer">
              <button
                v-if="value.id"
                class="raven-button plan-editor-dialog__remove"
                type="button"
                @click="$emit('remove')"
              >
                <span class="i-lucide-trash-2" aria-hidden="true" />
                Remove
              </button>
              <span class="plan-editor-dialog__spacer" />
              <button
                class="raven-button"
                type="button"
                @click="$emit('close')"
              >
                Cancel
              </button>
              <button
                class="raven-button raven-button--primary"
                type="submit"
                :disabled="!form.label.trim()"
              >
                <span class="i-lucide-check" aria-hidden="true" />
                Save
              </button>
            </footer>
          </form>
        </Dialog.Content>
      </Dialog.Positioner>
    </Teleport>
  </Dialog.Root>
</template>

<style scoped>
.plan-editor-dialog {
  width: min(620px, calc(100vw - 28px));
}

.plan-editor-dialog__context {
  margin: 4px 0 0;
  color: var(--raven-muted);
  font-size: 11px;
  font-weight: 400;
}

.plan-editor-dialog__spacer {
  flex: 1 1 auto;
}

.plan-editor-dialog__remove {
  color: var(--raven-danger);
}

.plan-editor-dialog__locked p {
  margin: 0;
  border: 1px solid var(--raven-border);
  border-radius: 8px;
  padding: 10px 12px;
  color: var(--raven-muted);
  background: var(--raven-panel);
  font-size: 11px;
}
</style>
