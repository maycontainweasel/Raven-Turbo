import type {
  AccountRecord,
  AccountSummary,
  BalanceKind,
  BalanceSnapshotRecord,
  BalanceView,
  FreshnessView,
} from './contracts.js'
import { money } from './money.js'

const HOUR_MS = 60 * 60 * 1000
const FUTURE_TOLERANCE_MS = 5 * 60 * 1000

function newestInvalidFutureSnapshot(
  account: AccountRecord,
  snapshots: readonly BalanceSnapshotRecord[],
  asOf: string,
): BalanceSnapshotRecord | null {
  const queryTime = Date.parse(asOf)
  if (!Number.isFinite(queryTime)) return null

  return (
    snapshots
      .filter((snapshot) => {
        if (snapshot.accountId !== account.id || snapshot.currency !== account.currency) return false
        if (snapshot.economicNature === 'informational') return false
        const snapshotTime = Date.parse(snapshot.asOf)
        return Number.isFinite(snapshotTime) && snapshotTime - queryTime > FUTURE_TOLERANCE_MS
      })
      .sort((left, right) => Date.parse(right.asOf) - Date.parse(left.asOf))[0] ?? null
  )
}

export function preferredBalanceKinds(account: AccountRecord): BalanceKind[] {
  if (account.normalNature === 'liability') return ['outstanding', 'statement']
  if (account.accountType === 'investment') return ['market_value', 'statement']
  if (account.liquidityClass === 'liquid') return ['available', 'ledger', 'statement']
  return ['ledger', 'statement', 'market_value']
}

export function snapshotFreshness(
  snapshot: BalanceSnapshotRecord | null,
  account: AccountRecord,
  asOf: string,
): FreshnessView {
  if (!snapshot) {
    return { state: 'unknown', ageHours: null, windowHours: account.freshnessWindowHours, asOf: null }
  }

  const queryTime = Date.parse(asOf)
  const snapshotTime = Date.parse(snapshot.asOf)
  if (!Number.isFinite(queryTime) || !Number.isFinite(snapshotTime)) {
    return {
      state: 'invalid_future',
      ageHours: null,
      windowHours: account.freshnessWindowHours,
      asOf: snapshot.asOf,
    }
  }
  if (snapshotTime - queryTime > FUTURE_TOLERANCE_MS) {
    return {
      state: 'invalid_future',
      ageHours: null,
      windowHours: account.freshnessWindowHours,
      asOf: snapshot.asOf,
    }
  }

  const ageHours = Math.max(0, Math.floor((queryTime - snapshotTime) / HOUR_MS))
  return {
    state: ageHours <= account.freshnessWindowHours ? 'fresh' : 'stale',
    ageHours,
    windowHours: account.freshnessWindowHours,
    asOf: snapshot.asOf,
  }
}

export function selectBalanceSnapshot(
  account: AccountRecord,
  snapshots: readonly BalanceSnapshotRecord[],
  asOf: string,
): BalanceSnapshotRecord | null {
  const preferred = preferredBalanceKinds(account)
  const eligible = snapshots.filter((snapshot) => {
    if (snapshot.accountId !== account.id || snapshot.currency !== account.currency) return false
    if (snapshot.economicNature === 'informational') return false
    return snapshotFreshness(snapshot, account, asOf).state !== 'invalid_future'
  })

  for (const kind of preferred) {
    const fresh = eligible
      .filter(
        (snapshot) =>
          snapshot.balanceKind === kind && snapshotFreshness(snapshot, account, asOf).state === 'fresh',
      )
      .sort((left, right) => Date.parse(right.asOf) - Date.parse(left.asOf))
    if (fresh[0]) return fresh[0]
  }

  const kindRank = new Map(preferred.map((kind, index) => [kind, index]))
  return (
    eligible
      .filter((snapshot) => snapshotFreshness(snapshot, account, asOf).state === 'stale')
      .sort((left, right) => {
        const dateDifference = Date.parse(right.asOf) - Date.parse(left.asOf)
        if (dateDifference !== 0) return dateDifference
        return (kindRank.get(left.balanceKind) ?? 999) - (kindRank.get(right.balanceKind) ?? 999)
      })[0] ?? null
  )
}

export function toBalanceView(snapshot: BalanceSnapshotRecord): BalanceView {
  return {
    snapshotId: snapshot.id,
    kind: snapshot.balanceKind,
    money: money({ currency: snapshot.currency, minorUnits: snapshot.amountMinor }, { nonNegative: true }),
    economicNature: snapshot.economicNature,
    asOf: snapshot.asOf,
    recordedAt: snapshot.recordedAt,
    evidenceLevel: snapshot.evidenceLevel,
    sourceKind: snapshot.sourceKind,
    note: snapshot.notes ?? null,
  }
}

export function toAccountSummary(
  account: AccountRecord,
  snapshots: readonly BalanceSnapshotRecord[],
  asOf: string,
): AccountSummary {
  const selected = selectBalanceSnapshot(account, snapshots, asOf)
  const freshnessEvidence = selected ?? newestInvalidFutureSnapshot(account, snapshots, asOf)
  return {
    id: account.id,
    spaceKey: account.spaceKey,
    accountKey: account.key,
    name: account.name,
    bankName: account.bankName,
    accountType: account.accountType,
    facilityKind:
      account.facilityKind ??
      (account.accountType === "credit_card"
        ? "credit_card"
        : account.accountType === "loan"
          ? "loan"
          : "none"),
    currency: account.currency,
    accountNumberLast4: account.accountNumberLast4,
    normalNature: account.normalNature,
    liquidityClass: account.liquidityClass,
    freshnessWindowHours: account.freshnessWindowHours,
    selectedBalance: selected ? toBalanceView(selected) : null,
    freshness: snapshotFreshness(freshnessEvidence, account, asOf),
  }
}
