<script setup lang="ts">
import {
  formatMoney,
  type AccountSummary,
  type GetCurrentPositionOutput,
  type ListAccountsOutput,
} from '@raven/domain'

useHead({ title: 'Accounts · Raven' })

const api = useAccountControlApi()
const selectedAccount = ref<AccountSummary | null>(null)
const { pendingCommand, dataVersion } = useRavenActions()
const hydrated = ref(false)

onMounted(() => {
  hydrated.value = true
})

const {
  data: accountsData,
  pending: accountsPending,
  status: accountsStatus,
  error: accountsError,
  refresh: refreshAccounts,
} = await useAsyncData<ListAccountsOutput>('account-control-accounts', () => api.listAccounts(), {
  server: false,
})

const {
  data: positionData,
  pending: positionPending,
  status: positionStatus,
  error: positionError,
  refresh: refreshPosition,
} = await useAsyncData<GetCurrentPositionOutput>(
  'account-control-position-zar',
  () => api.getCurrentPosition({ currency: 'ZAR' }),
  { server: false },
)

const refresh = async () => {
  await Promise.all([refreshAccounts(), refreshPosition()])
}

const completeAccountCreation = async () => {
  dataVersion.value += 1
  await refresh()
}

const displaySpaces = computed(() => accountsData.value?.spaces || [])
const accountCount = computed(() =>
  displaySpaces.value.reduce((total: number, space: any) => total + space.accounts.length, 0),
)
const accountsLoading = computed(() => hydrated.value && (accountsPending.value || accountsStatus.value === 'idle'))
const positionLoading = computed(() => hydrated.value && (positionPending.value || positionStatus.value === 'idle'))

const moneyLabel = (value: { currency: string; minorUnits: number } | null | undefined) =>
  value ? formatMoney(value) : 'Unavailable'

const balanceLabel = (account: AccountSummary) => {
  if (!account.selectedBalance) return account.freshness.state === 'invalid_future' ? 'Unavailable' : 'Unknown'
  const label = formatMoney(account.selectedBalance.money)
  return account.selectedBalance.economicNature === 'liability' ? `${label} owed` : label
}

const freshnessLabel = (account: AccountSummary) => {
  if (account.freshness.state === 'unknown') return 'Unknown'
  if (account.freshness.state === 'invalid_future') return 'Invalid future'
  const age = account.freshness.ageHours === 0 ? 'now' : `${account.freshness.ageHours}h old`
  return `${account.freshness.state === 'fresh' ? 'Fresh' : 'Stale'} · ${age}`
}

const asOfLabel = (account: AccountSummary) => {
  const asOf = account.selectedBalance?.asOf ?? account.freshness.asOf
  if (!asOf) return '—'
  return new Intl.DateTimeFormat('en-ZA', {
    dateStyle: 'medium',
    timeStyle: 'short',
  }).format(new Date(asOf))
}
</script>

<template>
  <div class="accounts-page">
    <header class="accounts-header">
      <div>
        <p class="raven-eyebrow">Present control</p>
        <h1>Accounts</h1>
        <p>Balances are evidence with an explicit as-of time. Unknown values are never treated as zero.</p>
      </div>
      <button class="raven-button raven-button--primary" type="button" @click="pendingCommand = 'create-account'">
        <span class="i-lucide-plus" aria-hidden="true" />
        Account
      </button>
    </header>

    <section class="position-summary" aria-label="Known financial position">
      <div>
        <span>Liquid cash</span>
        <strong>{{ positionLoading ? 'Loading…' : moneyLabel(positionData?.liquidCash) }}</strong>
      </div>
      <div>
        <span>Known assets</span>
        <strong>{{ positionLoading ? 'Loading…' : moneyLabel(positionData?.knownAssets) }}</strong>
      </div>
      <div>
        <span>Liabilities</span>
        <strong>{{ positionLoading ? 'Loading…' : moneyLabel(positionData?.knownLiabilities) }}</strong>
      </div>
      <div>
        <span>Known net position</span>
        <strong>{{ positionLoading ? 'Loading…' : moneyLabel(positionData?.knownNetPosition) }}</strong>
      </div>
    </section>

    <div v-if="positionData && positionData.meta.quality !== 'complete'" class="accounts-notice" role="status">
      <span class="i-lucide-triangle-alert" aria-hidden="true" />
      <span>
        Position is {{ positionData?.meta.quality }}.
        <template v-if="positionData?.missingAccountIds.length">
          {{ positionData.missingAccountIds.length }} account balance{{ positionData.missingAccountIds.length === 1 ? ' is' : 's are' }} unknown.
        </template>
        <template v-if="positionData?.invalidFutureAccountIds.length">
          {{ positionData.invalidFutureAccountIds.length }} account balance observation{{ positionData.invalidFutureAccountIds.length === 1 ? ' is' : 's are' }} future-dated and excluded.
        </template>
        <template v-if="positionData?.staleAccountIds.length">
          {{ positionData.staleAccountIds.length }} account balance{{ positionData.staleAccountIds.length === 1 ? ' is' : 's are' }} stale.
        </template>
      </span>
    </div>

    <div v-if="accountsError" class="accounts-error" role="alert">
      <span class="i-lucide-triangle-alert" aria-hidden="true" />
      <span>Accounts could not be loaded. Only persisted records can appear here.</span>
      <button class="raven-button" type="button" @click="refresh">Retry live data</button>
    </div>

    <div v-if="accountsLoading" class="accounts-loading" aria-label="Loading accounts">
      <div v-for="index in 5" :key="index" />
    </div>

    <div v-else-if="accountCount === 0" class="raven-empty">
      <p>No tracked accounts yet.</p>
      <button class="raven-button" type="button" @click="pendingCommand = 'create-account'">
        <span class="i-lucide-plus" aria-hidden="true" />
        Create account
      </button>
    </div>

    <section v-for="space in displaySpaces" v-else :key="space.key" class="account-group">
      <header class="account-group__header">
        <div>
          <h2>{{ space.name }}</h2>
          <span>{{ space.spaceType }} · {{ space.currency }}</span>
        </div>
        <span>{{ space.accounts.length }} account{{ space.accounts.length === 1 ? '' : 's' }}</span>
      </header>
      <div class="account-table-wrap">
        <table class="account-table">
          <thead>
            <tr>
              <th>Account</th>
              <th>Nature</th>
              <th>Balance</th>
              <th>As of</th>
              <th>Freshness</th>
              <th><span class="sr-only">Actions</span></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="account in space.accounts" :key="account.id">
              <td>
                <NuxtLink class="account-link" :to="`/accounts/${account.spaceKey}/${account.accountKey}`">
                  {{ account.name }}
                </NuxtLink>
                <span>{{ account.bankName || account.accountType }}<template v-if="account.accountNumberLast4"> · •••• {{ account.accountNumberLast4 }}</template></span>
              </td>
              <td>
                <span>{{ account.normalNature }}</span>
                <small>{{ account.liquidityClass.replace('_', '-') }}</small>
              </td>
              <td>
                <strong>{{ balanceLabel(account) }}</strong>
                <span v-if="account.selectedBalance">{{ account.selectedBalance.kind.replace('_', ' ') }}</span>
              </td>
              <td>{{ asOfLabel(account) }}</td>
              <td>
                <button
                  class="freshness-button"
                  :class="`freshness-button--${account.freshness.state}`"
                  type="button"
                  @click="selectedAccount = account"
                >
                  <span class="freshness-dot" aria-hidden="true" />
                  {{ freshnessLabel(account) }}
                </button>
              </td>
              <td>
                <button
                  class="raven-icon-button"
                  type="button"
                  aria-label="Confirm account balance"
                  title="Confirm balance"
                  @click="selectedAccount = account"
                >
                  <span class="i-lucide-scale" aria-hidden="true" />
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <AccountCreateDialog :spaces="accountsData?.spaces || []" @complete="completeAccountCreation" />
    <AccountBalanceDialog :account="selectedAccount" @close="selectedAccount = null" @complete="refresh" />
  </div>
</template>

<style scoped>
.accounts-page {
  display: grid;
  gap: 28px;
}

.accounts-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 24px;
}

.accounts-header h1 {
  margin: 8px 0 0;
  font-size: 32px;
  font-weight: 650;
  line-height: 1.1;
}

.accounts-header p:last-child {
  max-width: 660px;
  margin: 10px 0 0;
  color: var(--raven-muted);
  line-height: 1.55;
}

.position-summary {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 12px;
}

.position-summary > div {
  min-width: 0;
  display: grid;
  gap: 5px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
  padding: 16px 18px;
  background: var(--raven-panel);
}

.position-summary span,
.account-group__header span,
.account-table td > span,
.account-table td small {
  color: var(--raven-muted);
  font-size: 12px;
}

.position-summary strong {
  overflow: hidden;
  font-size: 18px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.accounts-notice,
.accounts-error {
  display: flex;
  align-items: center;
  gap: 10px;
  border: 1px solid color-mix(in srgb, var(--raven-warning) 42%, transparent);
  border-radius: var(--raven-radius-md);
  padding: 12px 14px;
  background: var(--raven-warning-soft);
  color: var(--raven-warning);
}

.accounts-error {
  justify-content: space-between;
  border-color: color-mix(in srgb, var(--raven-danger) 42%, transparent);
  background: var(--raven-danger-soft);
  color: var(--raven-danger);
}

.account-group {
  min-width: 0;
}

.account-group__header {
  min-height: 52px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 0 4px;
}

.account-group__header h2 {
  margin: 0 0 2px;
  font-size: 17px;
  font-weight: 650;
}

.account-table-wrap {
  overflow-x: auto;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-md);
}

.account-table {
  width: 100%;
  min-width: 900px;
  border-collapse: collapse;
  background: var(--raven-panel);
}

.account-table th,
.account-table td {
  border-bottom: 1px solid var(--raven-border);
  padding: 14px 16px;
  text-align: left;
  vertical-align: middle;
}

.account-table th {
  color: var(--raven-faint);
  background: color-mix(in srgb, var(--raven-panel) 82%, var(--raven-panel-subtle));
  font-size: 10px;
  font-weight: 750;
  letter-spacing: 0.035em;
  text-transform: uppercase;
}

.account-table tbody tr:last-child td {
  border-bottom: 0;
}

.account-table tbody tr {
  transition: background-color 140ms ease;
}

.account-table tbody tr:hover {
  background: #07110d;
}

.account-table td:first-child,
.account-table td:nth-child(3) {
  min-width: 190px;
}

.account-table td > strong,
.account-link,
.account-table td > span,
.account-table td > small {
  display: block;
}

.account-link {
  color: var(--raven-text);
  font-weight: 650;
  text-decoration: none;
}

.account-link:hover {
  text-decoration: underline;
  text-underline-offset: 3px;
}

.account-table td > span,
.account-table td > small {
  margin-top: 3px;
}

.account-table td:last-child {
  width: 58px;
  text-align: right;
}

.freshness-button {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  border: 0;
  border-radius: 4px;
  padding: 5px 7px;
  background: transparent;
  color: var(--raven-muted);
  cursor: pointer;
}

.freshness-button:hover {
  background: var(--raven-panel-subtle);
}

.freshness-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: currentColor;
}

.freshness-button--fresh {
  color: var(--raven-accent);
}

.freshness-button--stale {
  color: var(--raven-warning);
}

.freshness-button--unknown,
.freshness-button--invalid_future {
  color: var(--raven-danger);
}

.accounts-loading {
  display: grid;
  gap: 1px;
  background: var(--raven-border);
}

.accounts-loading > div {
  height: 58px;
  background: var(--raven-panel-subtle);
  animation: raven-pulse 1.5s ease-in-out infinite;
}

@keyframes raven-pulse {
  50% {
    opacity: 0.55;
  }
}

@media (max-width: 860px) {
  .position-summary {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

}

@media (max-width: 540px) {
  .accounts-header {
    align-items: stretch;
    flex-direction: column;
  }

  .accounts-header > .raven-button {
    align-self: flex-start;
  }

  .position-summary {
    grid-template-columns: 1fr;
  }

}
</style>
