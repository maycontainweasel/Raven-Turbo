import assert from 'node:assert/strict'
import test from 'node:test'
import type { AccountRecord, BalanceSnapshotRecord } from './contracts.js'
import { selectBalanceSnapshot, snapshotFreshness, toAccountSummary } from './balance.js'

const account: AccountRecord = {
  id: 'account:daily',
  spaceId: 'financialSpace:personal',
  spaceKey: 'personal',
  key: 'daily',
  name: 'Daily Account',
  bankName: 'Example Bank',
  accountType: 'current',
  currency: 'ZAR',
  normalNature: 'asset',
  liquidityClass: 'liquid',
  freshnessWindowHours: 72,
  active: true,
}

const snapshot = (overrides: Partial<BalanceSnapshotRecord>): BalanceSnapshotRecord => ({
  id: 'accountBalanceSnapshot:base',
  key: 'base',
  spaceId: account.spaceId,
  accountId: account.id,
  balanceKind: 'ledger',
  amountMinor: 10000,
  currency: 'ZAR',
  economicNature: 'asset',
  asOf: '2026-07-11T08:00:00.000Z',
  recordedAt: '2026-07-11T08:05:00.000Z',
  evidenceLevel: 'confirmed',
  sourceKind: 'manual_confirmation',
  ...overrides,
})

test('fresh credible kind outranks stale higher-priority kind', () => {
  const selected = selectBalanceSnapshot(
    account,
    [
      snapshot({ id: 'available:old', balanceKind: 'available', asOf: '2026-07-01T08:00:00.000Z' }),
      snapshot({ id: 'ledger:fresh', balanceKind: 'ledger', asOf: '2026-07-11T08:00:00.000Z' }),
    ],
    '2026-07-11T10:00:00.000Z',
  )
  assert.equal(selected?.id, 'ledger:fresh')
})

test('kind priority applies among fresh observations', () => {
  const selected = selectBalanceSnapshot(
    account,
    [
      snapshot({ id: 'available:fresh', balanceKind: 'available', asOf: '2026-07-10T08:00:00.000Z' }),
      snapshot({ id: 'ledger:newer', balanceKind: 'ledger', asOf: '2026-07-11T08:00:00.000Z' }),
    ],
    '2026-07-11T10:00:00.000Z',
  )
  assert.equal(selected?.id, 'available:fresh')
})

test('newest stale observation wins before stale kind tie-breaker', () => {
  const selected = selectBalanceSnapshot(
    account,
    [
      snapshot({ id: 'available:older', balanceKind: 'available', asOf: '2026-06-01T08:00:00.000Z' }),
      snapshot({ id: 'ledger:newer', balanceKind: 'ledger', asOf: '2026-07-01T08:00:00.000Z' }),
    ],
    '2026-07-11T10:00:00.000Z',
  )
  assert.equal(selected?.id, 'ledger:newer')
})

test('only future-dated credible evidence remains unselected and surfaces invalid-future freshness', () => {
  const snapshots = [
    snapshot({ id: 'ledger:future-older', asOf: '2026-07-12T08:00:00.000Z' }),
    snapshot({ id: 'ledger:future-newer', asOf: '2026-07-13T08:00:00.000Z' }),
  ]
  const selected = selectBalanceSnapshot(account, snapshots, '2026-07-11T10:00:00.000Z')
  const summary = toAccountSummary(account, snapshots, '2026-07-11T10:00:00.000Z')

  assert.equal(selected, null)
  assert.equal(summary.selectedBalance, null)
  assert.deepEqual(summary.freshness, {
    state: 'invalid_future',
    ageHours: null,
    windowHours: 72,
    asOf: '2026-07-13T08:00:00.000Z',
  })
})

test('future-dated evidence does not hide valid fresh evidence', () => {
  const snapshots = [
    snapshot({ id: 'ledger:future', asOf: '2026-07-12T08:00:00.000Z' }),
    snapshot({ id: 'ledger:fresh', asOf: '2026-07-11T08:00:00.000Z' }),
  ]
  const selected = selectBalanceSnapshot(account, snapshots, '2026-07-11T10:00:00.000Z')
  const summary = toAccountSummary(account, snapshots, '2026-07-11T10:00:00.000Z')

  assert.equal(selected?.id, 'ledger:fresh')
  assert.equal(summary.freshness.state, 'fresh')
})

test('future-dated evidence does not hide valid stale evidence', () => {
  const snapshots = [
    snapshot({ id: 'ledger:future', asOf: '2026-07-12T08:00:00.000Z' }),
    snapshot({ id: 'ledger:stale', asOf: '2026-07-01T08:00:00.000Z' }),
  ]
  const selected = selectBalanceSnapshot(account, snapshots, '2026-07-11T10:00:00.000Z')
  const summary = toAccountSummary(account, snapshots, '2026-07-11T10:00:00.000Z')

  assert.equal(selected?.id, 'ledger:stale')
  assert.equal(summary.freshness.state, 'stale')
})

test('informational future evidence remains excluded without creating invalid-future position state', () => {
  const snapshots = [
    snapshot({
      id: 'available:credit-future',
      balanceKind: 'available',
      economicNature: 'informational',
      asOf: '2026-07-12T08:00:00.000Z',
    }),
  ]
  const selected = selectBalanceSnapshot(
    account,
    snapshots,
    '2026-07-11T10:00:00.000Z',
  )
  const summary = toAccountSummary(account, snapshots, '2026-07-11T10:00:00.000Z')

  assert.equal(selected, null)
  assert.equal(summary.freshness.state, 'unknown')
})

test('freshness is deterministic under a fixed as-of time', () => {
  assert.equal(
    snapshotFreshness(snapshot({ asOf: '2026-07-10T10:00:00.000Z' }), account, '2026-07-11T10:00:00.000Z').state,
    'fresh',
  )
  assert.equal(
    snapshotFreshness(snapshot({ asOf: '2026-07-01T10:00:00.000Z' }), account, '2026-07-11T10:00:00.000Z').state,
    'stale',
  )
  assert.equal(snapshotFreshness(null, account, '2026-07-11T10:00:00.000Z').state, 'unknown')
})
