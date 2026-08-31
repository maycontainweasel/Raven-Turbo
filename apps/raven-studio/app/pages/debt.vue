<script setup lang="ts">
import {
  formatMoney,
  type AccountSummary,
  type FacilitySnapshotView,
  type GetAccountOutput,
  type ListAccountTransactionsOutput,
  type MoneyWire,
  type TransactionView,
} from "@raven/domain";
import {
  bankCostLabels,
  classifyBankCost,
  classifyStatementBackedCosts,
  monthSequence,
  simulateCreditFirstPayoff,
  type BankCostCategory,
  type ClassifiedBankCost,
  type DebtFacilityKind,
} from "~/utils/debt-strategy";

type DirectoryAccount = AccountSummary & {
  spaceName: string;
  spaceType: string;
};

type DebtAccountState = Readonly<{
  account: DirectoryAccount;
  detail: GetAccountOutput;
  facility: FacilitySnapshotView | null;
  transactions: TransactionView[];
  costs: ClassifiedBankCost[];
}>;

useHead({ title: "Debt · Raven" });

const api = useAccountControlApi();
const loading = ref(false);
const auditLoading = ref(false);
const loadedSlices = ref(0);
const totalSlices = ref(0);
const errorMessage = ref("");
const debtStates = ref<DebtAccountState[]>([]);
const monthlyTargetRands = ref<number | null>(null);
const plannerReady = ref(false);
const plannerStorageKey = "raven.debt-strategy.monthly-target-rands";

const todayParts = new Intl.DateTimeFormat("en-ZA", {
  timeZone: "Africa/Johannesburg",
  year: "numeric",
  month: "2-digit",
  day: "2-digit",
})
  .formatToParts(new Date())
  .reduce<Record<string, string>>((result, part) => {
    if (part.type !== "literal") result[part.type] = part.value;
    return result;
  }, {});
const throughMonth = `${todayParts.year}-${todayParts.month}`;
const throughDate = `${throughMonth}-${todayParts.day}`;
const auditStart = new Date(
  Date.UTC(Number(todayParts.year) - 1, Number(todayParts.month) - 1, 1),
);
const fromMonth = `${auditStart.getUTCFullYear()}-${String(
  auditStart.getUTCMonth() + 1,
).padStart(2, "0")}`;
const auditMonths = monthSequence(fromMonth, throughMonth);

function money(minorUnits: number, currency = "ZAR"): MoneyWire {
  return { currency, minorUnits: Math.round(minorUnits) };
}

function accountIdentity(
  account: Pick<AccountSummary, "spaceKey" | "accountKey">,
): string {
  return `${account.spaceKey}:${account.accountKey}`;
}

function isPersonalAccount(account: DirectoryAccount): boolean {
  const value = `${account.spaceType} ${account.spaceKey}`.toLocaleLowerCase();
  return value.includes("personal");
}

function newestFacility(detail: GetAccountOutput): FacilitySnapshotView | null {
  return (
    [...detail.facilityHistory].sort((left, right) =>
      right.asOf.localeCompare(left.asOf),
    )[0] ?? null
  );
}

function facilityRate(state: DebtAccountState | null): number | null {
  if (!state?.facility) return null;
  const key =
    state.account.facilityKind === "credit_card"
      ? "purchaseDebitRateBps"
      : "debitInterestRateBps";
  const value = state.facility.interestRates[key];
  return typeof value === "number" && Number.isFinite(value)
    ? value / 10_000
    : null;
}

function balanceMinor(state: DebtAccountState | null): number {
  return Math.abs(state?.account.selectedBalance?.money.minorUnits ?? 0);
}

function facilityLimitMinor(state: DebtAccountState | null): number {
  return Math.abs(state?.facility?.facilityLimit?.minorUnits ?? 0);
}

function overLimitMinor(state: DebtAccountState | null): number {
  return Math.max(0, balanceMinor(state) - facilityLimitMinor(state));
}

function dateLabel(value: string | null | undefined): string {
  if (!value) return "Unknown";
  return new Intl.DateTimeFormat("en-ZA", {
    day: "numeric",
    month: "short",
    year: "numeric",
    timeZone: "UTC",
  }).format(new Date(`${value.slice(0, 10)}T00:00:00Z`));
}

function monthLabel(value: string): string {
  const [year, month] = value.split("-").map(Number);
  return new Intl.DateTimeFormat("en-ZA", {
    month: "short",
    year: "numeric",
    timeZone: "UTC",
  }).format(new Date(Date.UTC(year!, month! - 1, 1)));
}

async function fetchCompleteMonth(
  account: DirectoryAccount,
  month: string,
): Promise<TransactionView[]> {
  const transactions: TransactionView[] = [];
  const seenCursors = new Set<string>();
  let cursor: string | undefined;
  do {
    const page: ListAccountTransactionsOutput =
      await api.listAccountTransactions({
        spaceKey: account.spaceKey,
        accountKey: account.accountKey,
        month,
        authorityScope: "active_ledger_with_legacy_unreconciled",
        cursor,
        limit: 100,
      });
    transactions.push(...page.transactions);
    if (!page.nextCursor || seenCursors.has(page.nextCursor)) break;
    seenCursors.add(page.nextCursor);
    cursor = page.nextCursor;
  } while (cursor);
  return transactions;
}

async function load() {
  loading.value = true;
  errorMessage.value = "";
  loadedSlices.value = 0;
  try {
    const accountsResponse = await api.listAccounts();
    const accounts: DirectoryAccount[] = accountsResponse.spaces.flatMap(
      (space) =>
        space.accounts.map((account) => ({
          ...account,
          spaceName: space.name,
          spaceType: space.spaceType,
        })),
    );
    const selected = accounts.filter(
      (account) =>
        isPersonalAccount(account) &&
        ["credit_card", "overdraft"].includes(account.facilityKind),
    );
    if (!selected.length) {
      throw new Error(
        "No personal credit-card or overdraft account is available.",
      );
    }

    const details = await Promise.all(
      selected.map((account) =>
        api.getAccount({
          spaceKey: account.spaceKey,
          accountKey: account.accountKey,
        }),
      ),
    );
    debtStates.value = selected.map((account, index) => ({
      account,
      detail: details[index]!,
      facility: newestFacility(details[index]!),
      transactions: [],
      costs: [],
    }));
    loading.value = false;
    auditLoading.value = true;
    const slices = selected.flatMap((account) =>
      auditMonths.map((month) => ({ account, month })),
    );
    totalSlices.value = slices.length;
    const transactionDirectory = new Map<string, TransactionView[]>();
    for (let index = 0; index < slices.length; index += 13) {
      const batch = slices.slice(index, index + 13);
      const pages = await Promise.all(
        batch.map((slice) => fetchCompleteMonth(slice.account, slice.month)),
      );
      batch.forEach((slice, offset) => {
        const key = accountIdentity(slice.account);
        const rows = transactionDirectory.get(key) ?? [];
        rows.push(...(pages[offset] ?? []));
        transactionDirectory.set(key, rows);
      });
      loadedSlices.value += batch.length;
    }

    debtStates.value = selected.map((account, index) => {
      const detail = details[index]!;
      const facility = newestFacility(detail);
      const transactions =
        transactionDirectory.get(accountIdentity(account)) ?? [];
      const costs = classifyStatementBackedCosts(
        account.facilityKind as DebtFacilityKind,
        transactions,
        facility?.sourceKind === "statement"
          ? facility.asOf.slice(0, 10)
          : null,
      );
      return { account, detail, facility, transactions, costs };
    });
  } catch (error) {
    errorMessage.value =
      error instanceof Error
        ? error.message
        : "The debt position could not be loaded.";
  } finally {
    loading.value = false;
    auditLoading.value = false;
  }
}

onMounted(() => {
  const stored = Number(window.localStorage.getItem(plannerStorageKey));
  monthlyTargetRands.value =
    Number.isFinite(stored) && stored > 0 ? stored : null;
  plannerReady.value = true;
  void load();
});

watch(monthlyTargetRands, (value) => {
  if (!plannerReady.value) return;
  if (typeof value === "number" && Number.isFinite(value) && value > 0) {
    window.localStorage.setItem(plannerStorageKey, String(value));
  } else {
    window.localStorage.removeItem(plannerStorageKey);
  }
});

const creditState = computed(
  () =>
    debtStates.value.find(
      (state) => state.account.facilityKind === "credit_card",
    ) ?? null,
);
const overdraftState = computed(
  () =>
    debtStates.value.find(
      (state) => state.account.facilityKind === "overdraft",
    ) ?? null,
);
const totalDebtMinor = computed(
  () => balanceMinor(creditState.value) + balanceMinor(overdraftState.value),
);
const totalOverLimitMinor = computed(
  () =>
    overLimitMinor(creditState.value) + overLimitMinor(overdraftState.value),
);
const minimumPaymentMinor = computed(
  () => creditState.value?.facility?.minimumPayment?.minorUnits ?? 0,
);
const scheduledApoFundingMinor = computed(
  () => minimumPaymentMinor.value + overLimitMinor(overdraftState.value),
);
const paymentDueOn = computed(
  () => creditState.value?.facility?.paymentDueOn ?? null,
);
const daysUntilDue = computed(() => {
  if (!paymentDueOn.value) return null;
  const due = Date.parse(`${paymentDueOn.value}T00:00:00Z`);
  const today = Date.parse(`${throughDate}T00:00:00Z`);
  return Math.ceil((due - today) / 86_400_000);
});

const combinedCosts = computed(() =>
  debtStates.value.flatMap((state) => state.costs),
);

function costTotal(
  costs: readonly ClassifiedBankCost[],
  categories?: readonly BankCostCategory[],
): number {
  const categorySet = categories ? new Set(categories) : null;
  return costs.reduce((total, cost) => {
    if (categorySet && !categorySet.has(cost.category)) return total;
    return total + cost.signedMinorUnits;
  }, 0);
}

const interestCostMinor = computed(() =>
  costTotal(combinedCosts.value, ["interest"]),
);
const nonInterestCostMinor = computed(
  () => costTotal(combinedCosts.value) - interestCostMinor.value,
);
const categoryRows = computed(() => {
  const order = Object.keys(bankCostLabels) as BankCostCategory[];
  return order
    .map((category) => {
      const credit = costTotal(creditState.value?.costs ?? [], [category]);
      const overdraft = costTotal(overdraftState.value?.costs ?? [], [
        category,
      ]);
      return {
        category,
        label: bankCostLabels[category],
        credit,
        overdraft,
        total: credit + overdraft,
      };
    })
    .filter((row) => row.total !== 0);
});

const monthlyRows = computed(() =>
  [...auditMonths].reverse().map((month) => {
    const rows = combinedCosts.value.filter(
      (cost) => cost.transaction.financialDate?.slice(0, 7) === month,
    );
    const interest = costTotal(rows, ["interest"]);
    const fees = costTotal(rows) - interest;
    return { month, interest, fees, total: interest + fees };
  }),
);

function averageNonInterestCostMinor(state: DebtAccountState | null): number {
  if (!state) return 0;
  const relevant = state.costs.filter((cost) => cost.category !== "interest");
  const months = new Set(
    relevant
      .map((cost) => cost.transaction.financialDate?.slice(0, 7))
      .filter((month): month is string => Boolean(month)),
  );
  return months.size ? Math.round(costTotal(relevant) / months.size) : 0;
}

const estimatedMonthlyCarryMinor = computed(() => {
  const creditRate = facilityRate(creditState.value) ?? 0;
  const overdraftRate = facilityRate(overdraftState.value) ?? 0;
  return (
    Math.round((balanceMinor(creditState.value) * creditRate) / 12) +
    Math.round((balanceMinor(overdraftState.value) * overdraftRate) / 12) +
    averageNonInterestCostMinor(creditState.value) +
    averageNonInterestCostMinor(overdraftState.value)
  );
});

const projection = computed(() => {
  if (!monthlyTargetRands.value || monthlyTargetRands.value <= 0) return null;
  const creditRate = facilityRate(creditState.value);
  const overdraftRate = facilityRate(overdraftState.value);
  if (creditRate == null || overdraftRate == null) return null;
  return simulateCreditFirstPayoff({
    creditBalanceMinor: balanceMinor(creditState.value),
    overdraftBalanceMinor: balanceMinor(overdraftState.value),
    creditAnnualRate: creditRate,
    overdraftAnnualRate: overdraftRate,
    creditMonthlyFeeReserveMinor: averageNonInterestCostMinor(
      creditState.value,
    ),
    overdraftMonthlyFeeReserveMinor: averageNonInterestCostMinor(
      overdraftState.value,
    ),
    monthlyPaymentMinor: Math.round(monthlyTargetRands.value * 100),
  });
});

const weightedAnnualRate = computed(() => {
  if (!totalDebtMinor.value) return null;
  const creditRate = facilityRate(creditState.value);
  const overdraftRate = facilityRate(overdraftState.value);
  if (creditRate == null || overdraftRate == null) return null;
  return (
    (balanceMinor(creditState.value) * creditRate +
      balanceMinor(overdraftState.value) * overdraftRate) /
    totalDebtMinor.value
  );
});

function percentage(value: number | null): string {
  return value == null
    ? "Unknown"
    : new Intl.NumberFormat("en-ZA", {
        style: "percent",
        minimumFractionDigits: 1,
        maximumFractionDigits: 2,
      }).format(value);
}

function sourceThrough(state: DebtAccountState | null): string | null {
  if (!state) return null;
  const dates = state.costs
    .map((cost) => cost.transaction.financialDate)
    .filter((value): value is string => Boolean(value));
  return dates.sort((left, right) => right.localeCompare(left))[0] ?? null;
}

const facilityStates = computed(() =>
  [creditState.value, overdraftState.value].filter(
    (state): state is DebtAccountState => Boolean(state),
  ),
);

const creditDirectionWarningCount = computed(
  () =>
    creditState.value?.costs.filter(
      (cost) =>
        cost.transaction.evidenceState === "statement_backed" &&
        cost.transaction.flowDirection !== "outflow",
    ).length ?? 0,
);
const ignoredCreditObservationCount = computed(() => {
  const state = creditState.value;
  const cutoff = state?.facility?.asOf.slice(0, 10);
  if (!state || !cutoff) return 0;
  return state.transactions.filter(
    (transaction) =>
      transaction.ledgerAuthority === "active" &&
      transaction.evidenceState === "provisional" &&
      Boolean(transaction.financialDate) &&
      transaction.financialDate! <= cutoff &&
      Boolean(classifyBankCost("credit_card", transaction.description)),
  ).length;
});

function isApoPayment(transaction: TransactionView): boolean {
  const value = transaction.description
    .toLocaleUpperCase()
    .replace(/[^A-Z0-9]/g, "");
  return value.includes("APOPAYMENT") && !value.includes("FEE");
}

const apoSummary = computed(() => {
  const transactions = overdraftState.value?.transactions ?? [];
  const statementRows = transactions.filter(
    (transaction) =>
      transaction.ledgerAuthority === "active" &&
      transaction.evidenceState === "statement_backed" &&
      Boolean(transaction.amount) &&
      Boolean(transaction.financialDate),
  );
  const attemptRows = statementRows.filter(isApoPayment);
  const reversalRows = statementRows.filter((transaction) =>
    transaction.description.trim().toLocaleUpperCase().startsWith("REV_"),
  );
  const matchedReversalIds = new Set<string>();
  let reversals = 0;
  for (const attempt of attemptRows) {
    const amount = Math.abs(attempt.amount!.minorUnits);
    const attemptTime = Date.parse(`${attempt.financialDate}T00:00:00Z`);
    const match = reversalRows.find((reversal) => {
      if (matchedReversalIds.has(reversal.id)) return false;
      if (Math.abs(reversal.amount!.minorUnits) !== amount) return false;
      const reversalTime = Date.parse(`${reversal.financialDate}T00:00:00Z`);
      const elapsedDays = (reversalTime - attemptTime) / 86_400_000;
      return elapsedDays >= 0 && elapsedDays <= 7;
    });
    if (!match) continue;
    matchedReversalIds.add(match.id);
    reversals += amount;
  }
  const attempts = attemptRows.reduce(
    (total, transaction) => total + Math.abs(transaction.amount!.minorUnits),
    0,
  );
  return {
    attempts,
    reversals,
    unreversed: Math.max(0, attempts - reversals),
    attemptCount: attemptRows.length,
    reversalCount: matchedReversalIds.size,
  };
});
</script>

<template>
  <div class="debt-page">
    <header class="debt-header">
      <div>
        <p class="raven-eyebrow">Debt control</p>
        <h1>Debt strategy</h1>
        <p>
          A statement-backed view of what the two facilities cost, what is due
          next, and how quickly a fixed monthly payment can remove them.
        </p>
      </div>
      <button
        class="raven-button"
        type="button"
        :disabled="loading || auditLoading"
        @click="load"
      >
        <span class="i-lucide-refresh-cw" />
        Refresh evidence
      </button>
    </header>

    <div v-if="errorMessage" class="debt-error raven-surface">
      <div>
        <strong>Debt evidence could not be loaded.</strong>
        <span>{{ errorMessage }}</span>
      </div>
      <button class="raven-button" type="button" @click="load">Retry</button>
    </div>

    <div v-else-if="loading" class="debt-loading raven-surface">
      <span class="i-lucide-loader-circle" />
      <div>
        <strong>Reading the statement-backed ledger</strong>
        <span>
          {{ loadedSlices }} of {{ totalSlices || auditMonths.length * 2 }}
          account-months loaded
        </span>
      </div>
    </div>

    <template v-else-if="debtStates.length">
      <section class="debt-now raven-surface">
        <div class="debt-now__heading">
          <div>
            <span class="debt-kicker debt-kicker--danger"
              >Immediate position</span
            >
            <h2>{{ formatMoney(money(totalDebtMinor)) }} outstanding</h2>
          </div>
          <span
            >Balances confirmed
            {{ dateLabel(creditState?.account.selectedBalance?.asOf) }}</span
          >
        </div>
        <div class="debt-now__grid">
          <article>
            <span>Card minimum due</span>
            <strong>{{ formatMoney(money(minimumPaymentMinor)) }}</strong>
            <small>
              {{ dateLabel(paymentDueOn) }}
              <template v-if="daysUntilDue != null">
                · {{ daysUntilDue >= 0 ? `${daysUntilDue} days` : "overdue" }}
              </template>
            </small>
          </article>
          <article>
            <span>Minimum funding into current</span>
            <strong>{{ formatMoney(money(scheduledApoFundingMinor)) }}</strong>
            <small>For the scheduled APO, assuming no other debits</small>
          </article>
          <article>
            <span>Over agreed limits</span>
            <strong>{{ formatMoney(money(totalOverLimitMinor)) }}</strong>
            <small>Card and current account combined</small>
          </article>
          <article>
            <span>Estimated monthly carrying cost</span>
            <strong>{{
              auditLoading
                ? "Calculating…"
                : formatMoney(money(estimatedMonthlyCarryMinor))
            }}</strong>
            <small>Current interest plus audited average fees</small>
          </article>
        </div>
        <div class="debt-now__instruction">
          <span class="i-lucide-triangle-alert" />
          <p>
            If the scheduled APO is the repayment route, fund at least
            {{ formatMoney(money(scheduledApoFundingMinor)) }} into the current
            account before it runs and allow for any other pending debits. If
            you pay the card directly instead, first confirm how the APO will be
            handled so the payment is not duplicated. Then stop new card
            spending and failed payment attempts.
          </p>
        </div>
      </section>

      <section class="facility-grid" aria-label="Debt facilities">
        <article
          v-for="state in facilityStates"
          :key="accountIdentity(state.account)"
          class="facility-card raven-surface"
        >
          <div class="facility-card__heading">
            <div>
              <span>{{ state.account.bankName }}</span>
              <h2>{{ state.account.name }}</h2>
            </div>
            <span class="debt-pill">
              {{
                state.account.facilityKind === "credit_card"
                  ? "Credit card"
                  : "Overdraft"
              }}
            </span>
          </div>
          <strong class="facility-card__balance">
            {{
              formatMoney(money(balanceMinor(state), state.account.currency))
            }}
          </strong>
          <div class="facility-card__facts">
            <div>
              <span>Agreed limit</span>
              <strong>{{
                formatMoney(
                  money(facilityLimitMinor(state), state.account.currency),
                )
              }}</strong>
            </div>
            <div>
              <span>Over limit</span>
              <strong :class="{ 'is-danger': overLimitMinor(state) > 0 }">
                {{
                  formatMoney(
                    money(overLimitMinor(state), state.account.currency),
                  )
                }}
              </strong>
            </div>
            <div>
              <span>Annual debit rate</span>
              <strong>{{ percentage(facilityRate(state)) }}</strong>
            </div>
            <div>
              <span>Terms observed</span>
              <strong>{{ dateLabel(state.facility?.asOf) }}</strong>
            </div>
          </div>
          <p v-if="state.account.facilityKind === 'credit_card'">
            Minimum
            {{
              formatMoney(
                money(state.facility?.minimumPayment?.minorUnits ?? 0),
              )
            }}
            due {{ dateLabel(state.facility?.paymentDueOn) }}.
          </p>
          <p v-else>
            This balance is already
            {{ formatMoney(money(overLimitMinor(state))) }}
            beyond the recorded overdraft limit.
          </p>
        </article>
      </section>

      <section class="payoff-panel raven-surface">
        <div class="section-heading">
          <div>
            <span class="debt-kicker">Credit-first avalanche</span>
            <h2>Payoff planner</h2>
          </div>
          <label class="target-input">
            <span>Monthly debt allocation</span>
            <span>
              <b>R</b>
              <input
                v-model.number="monthlyTargetRands"
                type="number"
                min="1"
                step="500"
                inputmode="decimal"
                placeholder="Enter an amount"
              />
            </span>
          </label>
        </div>

        <div v-if="projection && !auditLoading" class="projection-grid">
          <article>
            <span>Projected debt-free time</span>
            <strong>
              {{
                projection.completed
                  ? `${projection.months} months`
                  : "Target too low"
              }}
            </strong>
          </article>
          <article>
            <span>Projected interest</span>
            <strong>{{
              formatMoney(money(projection.totalInterestMinor))
            }}</strong>
          </article>
          <article>
            <span>Fee reserve</span>
            <strong>{{
              formatMoney(money(projection.totalFeeReserveMinor))
            }}</strong>
          </article>
          <article>
            <span>Total projected payments</span>
            <strong>{{ formatMoney(money(projection.totalPaidMinor)) }}</strong>
          </article>
        </div>
        <div v-else class="projection-empty">
          <template v-if="auditLoading">
            The balances and rates are ready. Raven is finishing the fee audit
            before calculating the payoff path.
          </template>
          <template v-else>
            Enter the amount you can protect for debt every month to model the
            credit-first payoff path. The amount is stored only in this browser.
          </template>
        </div>

        <div class="strategy-route">
          <ol>
            <li>
              <strong>Stabilise now</strong>
              <span
                >Fund the minimum, cure
                {{ formatMoney(money(totalOverLimitMinor)) }} over-limit, and
                stop new debt.</span
              >
            </li>
            <li>
              <strong>Hold the overdraft flat</strong>
              <span
                >Cover its monthly interest and fees while directing the rest to
                the 21% card.</span
              >
            </li>
            <li>
              <strong>Collapse the card</strong>
              <span
                >Apply every protected monthly payment and extra windfall to
                card principal.</span
              >
            </li>
            <li>
              <strong>Close the overdraft</strong>
              <span
                >Roll the full payment into the current account once the card
                reaches zero.</span
              >
            </li>
          </ol>
        </div>

        <p class="model-note">
          Model assumptions: no new borrowing or card purchases; current
          recorded annual rates; interest calculated monthly; and each account's
          observed average non-interest bank cost reserved monthly. It is a
          planning estimate, not a bank settlement quote.
        </p>
      </section>

      <section class="audit-panel raven-surface">
        <div class="section-heading">
          <div>
            <span class="debt-kicker"
              >{{ monthLabel(fromMonth) }} –
              {{ monthLabel(throughMonth) }}</span
            >
            <h2>What the debt has cost</h2>
          </div>
          <div v-if="!auditLoading" class="audit-total">
            <span>Bank cost identified</span>
            <strong>{{ formatMoney(money(costTotal(combinedCosts))) }}</strong>
          </div>
        </div>
        <div v-if="auditLoading" class="debt-loading audit-loading">
          <span class="i-lucide-loader-circle" />
          <div>
            <strong>Reading the statement-backed fee history</strong>
            <span
              >{{ loadedSlices }} of {{ totalSlices }} account-months
              loaded</span
            >
          </div>
        </div>
        <template v-else>
          <div class="audit-summary">
            <article>
              <span>Interest</span>
              <strong>{{ formatMoney(money(interestCostMinor)) }}</strong>
            </article>
            <article>
              <span>Fees and fee VAT</span>
              <strong>{{ formatMoney(money(nonInterestCostMinor)) }}</strong>
            </article>
            <article>
              <span>Credit evidence through</span>
              <strong>{{ dateLabel(sourceThrough(creditState)) }}</strong>
            </article>
            <article>
              <span>Current evidence through</span>
              <strong>{{ dateLabel(sourceThrough(overdraftState)) }}</strong>
            </article>
          </div>

          <div class="audit-tables">
            <div class="audit-table-wrap">
              <h3>Cost type</h3>
              <table>
                <thead>
                  <tr>
                    <th>Cost</th>
                    <th>Credit card</th>
                    <th>Current</th>
                    <th>Total</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="row in categoryRows" :key="row.category">
                    <td>{{ row.label }}</td>
                    <td>{{ formatMoney(money(row.credit)) }}</td>
                    <td>{{ formatMoney(money(row.overdraft)) }}</td>
                    <td>{{ formatMoney(money(row.total)) }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div class="audit-table-wrap audit-table-wrap--months">
              <h3>Monthly cost</h3>
              <table>
                <thead>
                  <tr>
                    <th>Month</th>
                    <th>Interest</th>
                    <th>Fees</th>
                    <th>Total</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="row in monthlyRows" :key="row.month">
                    <td>{{ monthLabel(row.month) }}</td>
                    <td>{{ formatMoney(money(row.interest)) }}</td>
                    <td>{{ formatMoney(money(row.fees)) }}</td>
                    <td>{{ formatMoney(money(row.total)) }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </template>
      </section>

      <section v-if="!auditLoading" class="repayment-panel raven-surface">
        <div class="section-heading">
          <div>
            <span class="debt-kicker">Repayment evidence</span>
            <h2>APO does not always mean paid</h2>
          </div>
        </div>
        <div class="repayment-grid">
          <article>
            <span>APO attempts</span>
            <strong>{{ formatMoney(money(apoSummary.attempts)) }}</strong>
            <small>{{ apoSummary.attemptCount }} statement entries</small>
          </article>
          <article>
            <span>Identified reversals</span>
            <strong>{{ formatMoney(money(apoSummary.reversals)) }}</strong>
            <small>{{ apoSummary.reversalCount }} reversed entries</small>
          </article>
          <article>
            <span>Unreversed APO attempts</span>
            <strong>{{ formatMoney(money(apoSummary.unreversed)) }}</strong>
            <small>Not a complete repayment total</small>
          </article>
        </div>
        <p>
          An APO entry is treated as an attempted scheduled payment. Only an
          unreversed attempt can be considered a likely successful APO, and
          manual card payments still require transfer reconciliation before
          Raven can state a complete repayment total.
        </p>
      </section>

      <section class="consolidation-panel raven-surface">
        <div>
          <span class="debt-kicker">Decision gate</span>
          <h2>Do not consolidate from the headline rate alone</h2>
          <p>
            The current balance-weighted debit rate is
            <strong>{{ percentage(weightedAnnualRate) }}</strong> before monthly
            fees. A consolidation quote only improves the position if its
            written all-in cost—interest, initiation fee, monthly service fee
            and credit insurance—is materially lower, while keeping the same
            accelerated payment amount and avoiding a longer debt habit.
          </p>
        </div>
        <ul>
          <li>Ask for the annual interest rate and whether it is fixed.</li>
          <li>
            Ask for initiation, monthly service and insurance costs in rand.
          </li>
          <li>Ask for total repayment at the planned accelerated payment.</li>
          <li>
            Confirm that extra payments and early settlement carry no penalty.
          </li>
        </ul>
      </section>

      <section
        v-if="
          !auditLoading &&
          (creditDirectionWarningCount || ignoredCreditObservationCount)
        "
        class="evidence-warning raven-surface"
      >
        <span class="i-lucide-shield-alert" />
        <div>
          <strong>Ledger reconciliation remains visible, not hidden.</strong>
          <p>
            {{ creditDirectionWarningCount }} statement-backed credit charge
            rows currently carry a non-outflow direction, and
            {{ ignoredCreditObservationCount }} pre-cutoff provisional
            credit-cost observations were excluded to prevent double counting.
            This page identifies bank costs from exact source descriptions and
            evidence state; it does not rewrite the statement backbone.
          </p>
        </div>
      </section>
    </template>
  </div>
</template>

<style scoped>
.debt-page {
  display: grid;
  gap: 20px;
  padding-bottom: 40px;
}

.debt-header,
.section-heading,
.debt-now__heading,
.facility-card__heading {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 20px;
}

.debt-header {
  align-items: center;
  padding: 8px 0;
}

.debt-header h1,
.section-heading h2,
.debt-now h2,
.facility-card h2,
.consolidation-panel h2 {
  margin: 5px 0 0;
  color: var(--raven-text);
  letter-spacing: -0.025em;
}

.debt-header h1 {
  font-size: clamp(30px, 3vw, 40px);
}

.debt-header p {
  max-width: 720px;
  margin: 9px 0 0;
  color: var(--raven-muted);
  font-size: 12px;
  line-height: 1.6;
}

.debt-loading,
.debt-error,
.evidence-warning {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 18px;
}

.debt-loading > span,
.evidence-warning > span {
  width: 28px;
  height: 28px;
  color: var(--raven-muted);
}

.debt-loading > span {
  animation: spin 1s linear infinite;
}

.debt-loading div,
.debt-error div {
  display: grid;
  gap: 3px;
}

.debt-loading span,
.debt-error span,
.evidence-warning p {
  color: var(--raven-muted);
  font-size: 11px;
}

.debt-error {
  justify-content: space-between;
  border-color: color-mix(in srgb, #ef4444 35%, var(--raven-border));
}

.debt-kicker {
  color: var(--raven-faint);
  font-size: 10px;
  font-weight: 750;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.debt-kicker--danger {
  color: #dc6f6f;
}

.debt-now {
  padding: 22px;
  border-color: color-mix(in srgb, #ef4444 24%, var(--raven-border));
  background:
    linear-gradient(
      115deg,
      color-mix(in srgb, #ef4444 5%, transparent),
      transparent 42%
    ),
    var(--raven-panel);
}

.debt-now__heading > span {
  color: var(--raven-faint);
  font-size: 10px;
}

.debt-now__grid,
.projection-grid,
.audit-summary,
.repayment-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 10px;
  margin-top: 20px;
}

.debt-now__grid {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.debt-now__grid article,
.projection-grid article,
.audit-summary article,
.repayment-grid article {
  display: grid;
  gap: 7px;
  min-width: 0;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-sm);
  padding: 14px;
  background: color-mix(in srgb, var(--raven-panel-strong) 60%, transparent);
}

.debt-now__grid span,
.projection-grid span,
.audit-summary span,
.repayment-grid span,
.facility-card__facts span,
.target-input > span:first-child,
.audit-total span {
  color: var(--raven-faint);
  font-size: 10px;
}

.debt-now__grid strong,
.projection-grid strong,
.audit-summary strong,
.repayment-grid strong {
  font-size: clamp(17px, 2vw, 23px);
  letter-spacing: -0.025em;
}

.debt-now__grid small,
.repayment-grid small {
  color: var(--raven-muted);
  font-size: 10px;
}

.debt-now__instruction {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  margin-top: 12px;
  border-radius: var(--raven-radius-sm);
  padding: 12px 14px;
  color: color-mix(in srgb, #f59e0b 78%, var(--raven-text));
  background: color-mix(in srgb, #f59e0b 8%, transparent);
}

.debt-now__instruction span {
  width: 16px;
  height: 16px;
  flex: 0 0 auto;
}

.debt-now__instruction p {
  margin: 0;
  color: var(--raven-muted);
  font-size: 11px;
  line-height: 1.55;
}

.facility-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
}

.facility-card {
  padding: 20px;
}

.facility-card__heading > div > span {
  color: var(--raven-faint);
  font-size: 10px;
}

.facility-card h2 {
  font-size: 17px;
}

.debt-pill {
  border: 1px solid var(--raven-border);
  border-radius: 999px;
  padding: 5px 8px;
  color: var(--raven-muted);
  font-size: 9px;
  font-weight: 700;
  text-transform: uppercase;
}

.facility-card__balance {
  display: block;
  margin-top: 22px;
  font-size: clamp(28px, 4vw, 42px);
  letter-spacing: -0.045em;
}

.facility-card__facts {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
  margin-top: 18px;
}

.facility-card__facts > div {
  display: grid;
  gap: 5px;
}

.facility-card__facts strong {
  font-size: 13px;
}

.is-danger {
  color: #dc6f6f;
}

.facility-card > p,
.model-note,
.repayment-panel > p,
.consolidation-panel p,
.evidence-warning p {
  margin: 16px 0 0;
  color: var(--raven-muted);
  font-size: 10px;
  line-height: 1.6;
}

.payoff-panel,
.audit-panel,
.repayment-panel,
.consolidation-panel {
  padding: 22px;
}

.section-heading {
  align-items: flex-end;
}

.section-heading h2,
.consolidation-panel h2 {
  font-size: 22px;
}

.target-input {
  display: grid;
  gap: 5px;
  min-width: 230px;
}

.target-input > span:last-child {
  display: flex;
  align-items: center;
  gap: 8px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-sm);
  padding: 0 10px;
  background: var(--raven-bg);
}

.target-input b {
  color: var(--raven-faint);
  font-size: 12px;
}

.target-input input {
  width: 100%;
  border: 0;
  padding: 10px 0;
  color: var(--raven-text);
  background: transparent;
  outline: none;
  font: inherit;
}

.projection-grid,
.audit-summary {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.projection-empty {
  margin-top: 18px;
  border: 1px dashed var(--raven-border);
  border-radius: var(--raven-radius-sm);
  padding: 18px;
  color: var(--raven-muted);
  font-size: 11px;
  text-align: center;
}

.strategy-route {
  margin-top: 20px;
  border-top: 1px solid var(--raven-border);
  padding-top: 18px;
}

.strategy-route ol {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 12px;
  margin: 0;
  padding: 0;
  list-style: none;
  counter-reset: debt-route;
}

.strategy-route li {
  display: grid;
  grid-template-columns: 22px minmax(0, 1fr);
  gap: 4px 8px;
  counter-increment: debt-route;
}

.strategy-route li::before {
  content: counter(debt-route);
  width: 22px;
  height: 22px;
  display: grid;
  place-items: center;
  grid-row: span 2;
  border: 1px solid var(--raven-border);
  border-radius: 50%;
  color: var(--raven-muted);
  font-size: 9px;
}

.strategy-route strong {
  font-size: 11px;
}

.strategy-route span {
  color: var(--raven-muted);
  font-size: 9px;
  line-height: 1.5;
}

.audit-total {
  display: grid;
  gap: 3px;
  text-align: right;
}

.audit-total strong {
  font-size: 22px;
}

.audit-tables {
  display: grid;
  grid-template-columns: minmax(0, 1.25fr) minmax(360px, 0.75fr);
  gap: 18px;
  margin-top: 20px;
}

.audit-table-wrap {
  min-width: 0;
  overflow-x: auto;
}

.audit-table-wrap--months {
  max-height: 520px;
  overflow: auto;
}

.audit-table-wrap h3 {
  margin: 0 0 9px;
  font-size: 11px;
}

table {
  width: 100%;
  border-collapse: collapse;
  font-size: 10px;
}

th,
td {
  border-bottom: 1px solid var(--raven-border);
  padding: 9px 8px;
  text-align: right;
  white-space: nowrap;
}

th:first-child,
td:first-child {
  text-align: left;
}

th {
  position: sticky;
  top: 0;
  color: var(--raven-faint);
  background: var(--raven-panel);
  font-size: 9px;
  font-weight: 700;
}

.repayment-panel > p {
  max-width: 900px;
}

.consolidation-panel {
  display: grid;
  grid-template-columns: minmax(0, 1.3fr) minmax(320px, 0.7fr);
  gap: 30px;
}

.consolidation-panel p strong {
  color: var(--raven-text);
}

.consolidation-panel ul {
  display: grid;
  gap: 9px;
  margin: 0;
  padding-left: 18px;
  color: var(--raven-muted);
  font-size: 10px;
  line-height: 1.5;
}

.evidence-warning {
  align-items: flex-start;
}

.evidence-warning p {
  margin-top: 5px;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

@media (max-width: 980px) {
  .debt-now__grid,
  .projection-grid,
  .audit-summary,
  .repayment-grid,
  .strategy-route ol {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .audit-tables,
  .consolidation-panel {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 700px) {
  .debt-header,
  .section-heading,
  .debt-now__heading,
  .facility-card__heading {
    align-items: stretch;
    flex-direction: column;
  }

  .facility-grid,
  .debt-now__grid,
  .projection-grid,
  .audit-summary,
  .repayment-grid,
  .strategy-route ol {
    grid-template-columns: 1fr;
  }

  .target-input {
    width: 100%;
    min-width: 0;
  }
}
</style>
