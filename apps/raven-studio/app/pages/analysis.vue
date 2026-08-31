<script setup lang="ts">
import {
  formatMoney,
  type GetCategorySpendSummaryOutput,
  type GetFinancialDataQualitySummaryOutput,
  type GetMonthlyFinancialTrendOutput,
  type GetPeriodFinancialSummaryOutput,
  type ListUncategorizedTransactionsOutput,
} from "@raven/domain";

useHead({ title: "Analysis · Raven" });

const api = useFinancialAnalyticsApi();

function currentJohannesburgMonth(date = new Date()): string {
  const parts = new Intl.DateTimeFormat("en-ZA", {
    timeZone: "Africa/Johannesburg",
    year: "numeric",
    month: "2-digit",
  })
    .formatToParts(date)
    .reduce<Record<string, string>>((result, part) => {
      if (part.type !== "literal") result[part.type] = part.value;
      return result;
    }, {});
  return `${parts.year}-${parts.month}`;
}

const month = ref(currentJohannesburgMonth());
const currency = ref("ZAR");
const authorityScope = ref<
  "active_ledger" | "active_ledger_with_legacy_unreconciled"
>("active_ledger");
const loading = ref(false);
const errorMessage = ref("");
const summary = ref<GetPeriodFinancialSummaryOutput | null>(null);
const categories = ref<GetCategorySpendSummaryOutput | null>(null);
const trend = ref<GetMonthlyFinancialTrendOutput | null>(null);
const quality = ref<GetFinancialDataQualitySummaryOutput | null>(null);
const uncategorized = ref<ListUncategorizedTransactionsOutput | null>(null);

const scope = computed(() => ({
  month: month.value,
  currency: currency.value,
  authorityScope: authorityScope.value,
}));

async function load() {
  loading.value = true;
  errorMessage.value = "";
  try {
    const requestScope = { ...scope.value, asOf: new Date().toISOString() };
    const [period, categorySpend, monthlyTrend, dataQuality, openMeaning] =
      await Promise.all([
        api.getPeriodFinancialSummary(requestScope),
        api.getCategorySpendSummary(requestScope),
        api.getMonthlyFinancialTrend(requestScope),
        api.getFinancialDataQualitySummary(requestScope),
        api.listUncategorizedTransactions({ ...requestScope, limit: 10 }),
      ]);
    summary.value = period;
    categories.value = categorySpend;
    trend.value = monthlyTrend;
    quality.value = dataQuality;
    uncategorized.value = openMeaning;
  } catch (error) {
    errorMessage.value =
      error instanceof Error ? error.message : "Analysis could not be loaded.";
  } finally {
    loading.value = false;
  }
}

watch([month, currency, authorityScope], load);
onMounted(load);
</script>

<template>
  <div class="analysis-page">
    <header class="analysis-header">
      <div>
        <p class="raven-eyebrow">Observed financial truth</p>
        <h1>Analysis</h1>
      </div>
      <div class="analysis-controls">
        <label class="raven-field">
          <span>Period</span>
          <input v-model="month" type="month" />
        </label>
        <label class="raven-field analysis-controls__currency">
          <span>Currency</span>
          <select v-model="currency">
            <option value="ZAR">ZAR</option>
          </select>
        </label>
        <label class="raven-field">
          <span>Authority</span>
          <select v-model="authorityScope">
            <option value="active_ledger">Active ledger</option>
            <option value="active_ledger_with_legacy_unreconciled">
              Active + legacy review
            </option>
          </select>
        </label>
        <button
          class="raven-icon-button analysis-refresh"
          type="button"
          title="Refresh analysis"
          aria-label="Refresh analysis"
          :disabled="loading"
          @click="load"
        >
          <span class="i-lucide-refresh-cw" aria-hidden="true" />
        </button>
      </div>
    </header>

    <div v-if="errorMessage" class="analysis-error" role="alert">
      <span>{{ errorMessage }}</span>
      <button class="raven-button" type="button" @click="load">Retry</button>
    </div>

    <template v-if="summary">
      <section class="analysis-totals" aria-label="Period totals">
        <div>
          <span>Income</span>
          <strong>{{ formatMoney(summary.ordinary.income) }}</strong>
          <small>{{ summary.ordinary.incomeCount }} movements</small>
        </div>
        <div>
          <span>Outflow</span>
          <strong>{{ formatMoney(summary.ordinary.outflow) }}</strong>
          <small>{{ summary.ordinary.outflowCount }} movements</small>
        </div>
        <div>
          <span>Net</span>
          <strong>{{ formatMoney(summary.ordinary.net) }}</strong>
          <small>Transfers excluded</small>
        </div>
        <div>
          <span>Unresolved</span>
          <strong>{{
            formatMoney(summary.meta.unresolvedGrossKnownMovementVolume.amount)
          }}</strong>
          <small
            >{{
              summary.meta.unresolvedGrossKnownMovementVolume.count
            }}
            movements</small
          >
        </div>
      </section>

      <section class="analysis-section">
        <header>
          <div>
            <p class="raven-eyebrow">Account flow</p>
            <h2>Accounts</h2>
          </div>
          <span
            >{{ summary.meta.currency }} · {{ summary.meta.period.from }}–{{
              summary.meta.period.through
            }}</span
          >
        </header>
        <div class="analysis-table-wrap">
          <table class="analysis-table">
            <thead>
              <tr>
                <th>Account</th>
                <th>Income</th>
                <th>Outflow</th>
                <th>Net</th>
                <th>Legacy review</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="row in summary.accounts"
                :key="`${row.account.spaceKey}:${row.account.accountKey}`"
              >
                <td>
                  <strong>{{ row.account.accountKey }}</strong>
                  <small>{{ row.account.spaceKey }}</small>
                </td>
                <td>{{ formatMoney(row.ordinary.income) }}</td>
                <td>{{ formatMoney(row.ordinary.outflow) }}</td>
                <td>{{ formatMoney(row.ordinary.net) }}</td>
                <td>{{ formatMoney(row.legacyUnreconciled.outflow) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </template>

    <section v-if="categories" class="analysis-section">
      <header>
        <div>
          <p class="raven-eyebrow">Management meaning</p>
          <h2>Category spend</h2>
        </div>
        <span>{{ categories.categories.length }} categories</span>
      </header>
      <div class="analysis-table-wrap">
        <table class="analysis-table">
          <thead>
            <tr>
              <th>Category</th>
              <th>Spend</th>
              <th>Movements</th>
              <th>Legacy review</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="row in categories.categories"
              :key="`${row.category.spaceKey}:${row.category.key}`"
            >
              <td>
                <strong>{{ row.category.name }}</strong>
                <small>{{ row.category.spaceKey }}</small>
              </td>
              <td>{{ formatMoney(row.ordinary.amount) }}</td>
              <td>{{ row.ordinary.count }}</td>
              <td>{{ formatMoney(row.legacyUnreconciled.amount) }}</td>
            </tr>
            <tr v-if="categories.categories.length === 0">
              <td colspan="4" class="analysis-empty">
                No categorized spend in this period.
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <div class="analysis-lower-grid">
      <section v-if="trend" class="analysis-section">
        <header>
          <div>
            <p class="raven-eyebrow">Observed movement</p>
            <h2>Monthly trend</h2>
          </div>
        </header>
        <div class="analysis-trend">
          <div v-for="row in trend.months" :key="row.month">
            <span>{{ row.month }}</span>
            <strong>{{ formatMoney(row.ordinary.outflow) }}</strong>
            <small>{{ formatMoney(row.ordinary.net) }} net</small>
          </div>
        </div>
      </section>

      <section v-if="quality" class="analysis-section">
        <header>
          <div>
            <p class="raven-eyebrow">Authority and coverage</p>
            <h2>Data quality</h2>
          </div>
        </header>
        <dl class="analysis-quality">
          <div>
            <dt>Active included movements</dt>
            <dd>{{ quality.activeIncludedGrossKnownMovementVolume.count }}</dd>
          </div>
          <div>
            <dt>Uncategorized</dt>
            <dd>
              {{ quality.uncategorizedGrossKnownMovementVolume.count }}
            </dd>
          </div>
          <div>
            <dt>Excluded</dt>
            <dd>{{ quality.excludedGrossKnownMovementVolume.count }}</dd>
          </div>
          <div>
            <dt>Legacy review</dt>
            <dd>
              {{ quality.legacyUnreconciledGrossKnownMovementVolume.count }}
            </dd>
          </div>
        </dl>
      </section>
    </div>

    <section v-if="uncategorized" class="analysis-section">
      <header>
        <div>
          <p class="raven-eyebrow">Open management meaning</p>
          <h2>Uncategorized</h2>
        </div>
        <span>{{ uncategorized.total.ordinary.count }} active</span>
      </header>
      <div class="analysis-table-wrap">
        <table class="analysis-table">
          <thead>
            <tr>
              <th>Date</th>
              <th>Account</th>
              <th>Direction</th>
              <th>Amount</th>
              <th>Evidence</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="row in uncategorized.transactions"
              :key="row.transactionRef"
            >
              <td>{{ row.financialDate }}</td>
              <td>
                <strong>{{ row.account.accountKey }}</strong>
                <small>{{ row.account.spaceKey }}</small>
              </td>
              <td>{{ row.flowDirection }}</td>
              <td>{{ formatMoney(row.amount) }}</td>
              <td>{{ row.evidenceState.replaceAll("_", " ") }}</td>
            </tr>
            <tr v-if="uncategorized.transactions.length === 0">
              <td colspan="5" class="analysis-empty">
                No uncategorized movements in this period.
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
  </div>
</template>

<style scoped>
.analysis-page {
  display: grid;
  gap: 36px;
}

.analysis-header,
.analysis-section > header {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 24px;
}

.analysis-header h1,
.analysis-section h2 {
  margin: 4px 0 0;
  letter-spacing: 0;
}

.analysis-header h1 {
  font-size: 42px;
}

.analysis-section h2 {
  font-size: 20px;
}

.analysis-controls {
  display: grid;
  grid-template-columns: 150px 90px minmax(190px, 1fr) 38px;
  align-items: end;
  gap: 8px;
}

.analysis-refresh {
  align-self: end;
}

.analysis-totals {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  border-block: 1px solid var(--raven-border);
}

.analysis-totals > div {
  min-width: 0;
  display: grid;
  gap: 4px;
  border-right: 1px solid var(--raven-border);
  padding: 22px;
}

.analysis-totals > div:last-child {
  border-right: 0;
}

.analysis-totals span,
.analysis-section > header > span,
.analysis-table th,
.analysis-table small,
.analysis-totals small,
.analysis-trend small,
.analysis-quality dt {
  color: var(--raven-faint);
  font-size: 11px;
}

.analysis-totals strong {
  overflow-wrap: anywhere;
  font-size: 24px;
}

.analysis-section {
  min-width: 0;
  display: grid;
  gap: 16px;
}

.analysis-table-wrap {
  max-width: 100%;
  overflow-x: auto;
  border-top: 1px solid var(--raven-border);
}

.analysis-table {
  width: 100%;
  min-width: 680px;
  border-collapse: collapse;
}

.analysis-table th,
.analysis-table td {
  border-bottom: 1px solid var(--raven-border-subtle);
  padding: 13px 12px;
  text-align: left;
}

.analysis-table th {
  font-weight: 650;
}

.analysis-table td > strong,
.analysis-table td > small {
  display: block;
}

.analysis-empty {
  color: var(--raven-faint);
  text-align: center !important;
}

.analysis-lower-grid {
  display: grid;
  grid-template-columns: minmax(0, 1.4fr) minmax(280px, 0.6fr);
  gap: 36px;
}

.analysis-trend,
.analysis-quality {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
  border-top: 1px solid var(--raven-border);
}

.analysis-trend > div,
.analysis-quality > div {
  min-width: 0;
  display: grid;
  gap: 3px;
  border-bottom: 1px solid var(--raven-border-subtle);
  padding: 14px 12px;
}

.analysis-quality {
  margin: 0;
}

.analysis-quality dd {
  margin: 0;
  font-size: 20px;
  font-weight: 700;
}

.analysis-error {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  border: 1px solid var(--raven-danger);
  border-radius: var(--raven-radius-sm);
  padding: 12px;
  color: var(--raven-danger);
  background: var(--raven-danger-soft);
}

@media (max-width: 920px) {
  .analysis-header {
    align-items: stretch;
    flex-direction: column;
  }

  .analysis-controls {
    grid-template-columns: minmax(120px, 1fr) 90px minmax(170px, 1fr) 38px;
  }

  .analysis-totals {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .analysis-totals > div:nth-child(2) {
    border-right: 0;
  }

  .analysis-lower-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 620px) {
  .analysis-header h1 {
    font-size: 30px;
  }

  .analysis-controls {
    grid-template-columns: 1fr 90px;
  }

  .analysis-controls .raven-field:nth-child(3) {
    grid-column: 1 / -1;
  }

  .analysis-refresh {
    grid-column: 2;
    grid-row: 1;
    justify-self: end;
  }

  .analysis-totals {
    grid-template-columns: 1fr;
  }

  .analysis-totals > div {
    border-right: 0;
    border-bottom: 1px solid var(--raven-border-subtle);
  }
}
</style>
