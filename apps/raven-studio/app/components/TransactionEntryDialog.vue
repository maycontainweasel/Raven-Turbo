<script setup lang="ts">
import { Dialog } from "@ark-ui/vue/dialog";
import {
  createCommandIntent,
  parseDecimalMoney,
  type AccountSummary,
  type CategoryView,
} from "@raven/domain";

const props = defineProps<{ accounts: AccountSummary[] }>();
const emit = defineEmits<{ complete: [] }>();
const api = useAccountControlApi();
const { pendingCommand, commandAccount } = useRavenActions();
const commandIntent = createCommandIntent();
const accountValue = ref("");
const amount = ref("");
const postedAt = ref("");
const description = ref("");
const categoryKey = ref("");
const categories = ref<CategoryView[]>([]);
const categoriesLoading = ref(false);
const submitting = ref(false);
const errorMessage = ref("");

const mode = computed(() =>
  pendingCommand.value === "record-expense" ||
  pendingCommand.value === "record-income"
    ? pendingCommand.value
    : null,
);
const selectedAccount = computed(
  () =>
    props.accounts.find(
      (account) =>
        accountValue.value === `${account.spaceKey}\u0000${account.accountKey}`,
    ) ?? null,
);
const title = computed(() =>
  mode.value === "record-income" ? "Record income" : "Record expense",
);

const localDate = () => {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, "0");
  const day = String(now.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};

const loadCategories = async () => {
  if (!selectedAccount.value || !mode.value) {
    categories.value = [];
    return;
  }
  categoriesLoading.value = true;
  try {
    const kinds =
      mode.value === "record-income"
        ? (["income", "other"] as const)
        : (["expense", "savings", "other"] as const);
    categories.value = (
      await api.listCategories({
        spaceKey: selectedAccount.value.spaceKey,
        kinds: [...kinds],
      })
    ).categories;
  } finally {
    categoriesLoading.value = false;
  }
};

watch(
  mode,
  (nextMode) => {
    commandIntent.clear();
    if (!nextMode) return;
    commandIntent.begin();
    const preselected = commandAccount.value
      ? props.accounts.find(
          (account) =>
            account.spaceKey === commandAccount.value?.spaceKey &&
            account.accountKey === commandAccount.value?.accountKey,
        )
      : null;
    const account = preselected ?? props.accounts[0];
    accountValue.value = account
      ? `${account.spaceKey}\u0000${account.accountKey}`
      : "";
    amount.value = "";
    postedAt.value = localDate();
    description.value = "";
    categoryKey.value = "";
    errorMessage.value = "";
    void loadCategories();
  },
  { immediate: true },
);

watch(accountValue, () => {
  categoryKey.value = "";
  void loadCategories();
});

const close = () => {
  commandIntent.clear();
  pendingCommand.value = null;
  commandAccount.value = null;
  errorMessage.value = "";
};

const submit = async () => {
  if (!selectedAccount.value || !mode.value) return;
  submitting.value = true;
  errorMessage.value = "";
  try {
    const input = {
      idempotencyKey: commandIntent.current(),
      channel: "ui" as const,
      spaceKey: selectedAccount.value.spaceKey,
      accountKey: selectedAccount.value.accountKey,
      money: parseDecimalMoney(amount.value, selectedAccount.value.currency),
      postedAt: postedAt.value,
      description: description.value,
      categoryKey: categoryKey.value || undefined,
    };
    if (mode.value === "record-income") await api.recordIncome(input);
    else await api.recordExpense(input);
    commandIntent.clear();
    emit("complete");
    close();
  } catch (error: any) {
    errorMessage.value =
      error?.message || "The transaction could not be recorded.";
  } finally {
    submitting.value = false;
  }
};
</script>

<template>
  <Dialog.Root
    :open="Boolean(mode)"
    @open-change="({ open }) => !open && close()"
  >
    <Teleport to="body">
      <Dialog.Backdrop class="raven-dialog-backdrop" />
      <Dialog.Positioner class="raven-dialog-positioner">
        <Dialog.Content class="raven-dialog">
          <header class="raven-dialog__header">
            <Dialog.Title class="raven-dialog__title">{{ title }}</Dialog.Title>
            <Dialog.CloseTrigger as-child>
              <button
                class="raven-icon-button"
                type="button"
                :aria-label="`Close ${title.toLowerCase()} dialog`"
              >
                <span class="i-lucide-x" aria-hidden="true" />
              </button>
            </Dialog.CloseTrigger>
          </header>
          <form @submit.prevent="submit">
            <div class="raven-dialog__body">
              <div class="raven-form-grid">
                <label class="raven-field raven-field--wide">
                  <span>Account</span>
                  <select v-model="accountValue" required>
                    <option
                      v-for="account in accounts"
                      :key="account.id"
                      :value="`${account.spaceKey}\u0000${account.accountKey}`"
                    >
                      {{ account.name }} · {{ account.currency }}
                    </option>
                  </select>
                </label>
                <label class="raven-field">
                  <span>Amount ({{ selectedAccount?.currency || "—" }})</span>
                  <input
                    v-model="amount"
                    inputmode="decimal"
                    required
                    autocomplete="off"
                    placeholder="0.00"
                  />
                </label>
                <label class="raven-field">
                  <span>Financial date</span>
                  <input v-model="postedAt" type="date" required />
                </label>
                <label class="raven-field raven-field--wide">
                  <span>Description</span>
                  <input
                    v-model="description"
                    required
                    autocomplete="off"
                    placeholder="What was this movement?"
                  />
                </label>
                <label class="raven-field raven-field--wide">
                  <span>Management category (optional)</span>
                  <select v-model="categoryKey" :disabled="categoriesLoading">
                    <option value="">Uncategorized</option>
                    <option
                      v-for="category in categories"
                      :key="category.key"
                      :value="category.key"
                    >
                      {{ category.name }}
                    </option>
                  </select>
                </label>
              </div>
              <p v-if="errorMessage" class="raven-form-error">
                {{ errorMessage }}
              </p>
            </div>
            <footer class="raven-dialog__footer">
              <button class="raven-button" type="button" @click="close">
                Cancel
              </button>
              <button
                class="raven-button raven-button--primary"
                type="submit"
                :disabled="submitting || !selectedAccount"
              >
                <span class="i-lucide-check" aria-hidden="true" />
                {{ title }}
              </button>
            </footer>
          </form>
        </Dialog.Content>
      </Dialog.Positioner>
    </Teleport>
  </Dialog.Root>
</template>
