import assert from 'node:assert/strict'
import test from 'node:test'
import { migrateTransactionExactMoney } from './transaction-migration.js'
import type { SurrealQueryClient } from './repository.js'

type FictionalRow = Record<string, unknown>

const MIGRATION_TIME = '2026-07-11T10:00:00.000Z'

function row(key: string, overrides: FictionalRow = {}): FictionalRow {
  return {
    id: `transaction:${key}`,
    amount: '12.50',
    currency: 'ZAR',
    direction: 'debit',
    postedAt: '2026-07-09',
    sourceImportedAt: '2026-07-10T09:00:00.000Z',
    ...overrides,
  }
}

class MigrationClient implements SurrealQueryClient {
  readonly writes: Array<{ query: string; vars?: Record<string, unknown> }> = []

  constructor(private readonly rows: FictionalRow[]) {}

  async query(query: string, vars?: Record<string, unknown>): Promise<unknown> {
    if (query.includes('FROM transaction')) return [[...this.rows]]
    this.writes.push({ query, vars })
    return [[]]
  }
}

test('audit is aggregate-only, defaults to zero writes, and recognizes a generated-default credit', async () => {
  const client = new MigrationClient([
    row('generated-credit', {
      amount: '100.00',
      direction: 'credit',
      amountMinor: 0,
      transactionKind: 'expense',
      flowDirection: 'outflow',
      entrySource: 'imported',
      recordedAt: '',
    }),
  ])

  const report = await migrateTransactionExactMoney(client, { recordedAt: MIGRATION_TIME })

  assert.deepEqual(report, {
    mode: 'audit',
    rowsAudited: 1,
    alreadyCanonical: 0,
    eligibleIncomeRows: 1,
    eligibleExpenseRows: 0,
    ambiguousLegacyTransfers: 0,
    precisionRangeDateExceptions: 0,
    canonicalLegacyConflicts: 0,
    recordedAtFallbacks: 0,
    rowsApplied: 0,
  })
  assert.equal(client.writes.length, 0)
  assert.deepEqual(Object.keys(report).sort(), [
    'alreadyCanonical',
    'ambiguousLegacyTransfers',
    'canonicalLegacyConflicts',
    'eligibleExpenseRows',
    'eligibleIncomeRows',
    'mode',
    'precisionRangeDateExceptions',
    'recordedAtFallbacks',
    'rowsApplied',
    'rowsAudited',
  ])
})

test('apply replaces only the recognized generated sentinel tuple for a legacy credit', async () => {
  const client = new MigrationClient([
    row('generated-credit', {
      amount: '100.00',
      direction: 'credit',
      amountMinor: 0,
      transactionKind: 'expense',
      flowDirection: 'outflow',
      entrySource: 'imported',
      recordedAt: '',
    }),
  ])

  const report = await migrateTransactionExactMoney(client, { apply: true, recordedAt: MIGRATION_TIME })

  assert.equal(report.rowsApplied, 1)
  assert.equal(report.canonicalLegacyConflicts, 0)
  assert.equal(client.writes.length, 1)
  assert.deepEqual(client.writes[0]?.vars, {
    transactionKey: 'generated-credit',
    amountMinor: 10_000,
    transactionKind: 'income',
    flowDirection: 'inflow',
    entrySource: 'imported',
    recordedAt: '2026-07-10T09:00:00.000Z',
  })
  assert.doesNotMatch(client.writes[0]?.query ?? '', /postedAt\s*=/)
})

test('partial exact amount conflict is reported and receives no write', async () => {
  const client = new MigrationClient([
    row('amount-conflict', {
      amountMinor: 2_000,
      transactionKind: 'expense',
      flowDirection: 'outflow',
      entrySource: 'imported',
      recordedAt: '',
    }),
  ])

  const report = await migrateTransactionExactMoney(client, { apply: true, recordedAt: MIGRATION_TIME })

  assert.equal(report.canonicalLegacyConflicts, 1)
  assert.equal(report.rowsApplied, 0)
  assert.equal(client.writes.length, 0)
})

test('partial kind and flow conflicts are reported and every conflict path receives no write', async () => {
  const client = new MigrationClient([
    row('kind-conflict', {
      amount: '100.00',
      amountMinor: 10_000,
      direction: 'credit',
      transactionKind: 'expense',
      flowDirection: 'inflow',
      entrySource: 'imported',
      recordedAt: '',
    }),
    row('flow-conflict', {
      amount: '100.00',
      amountMinor: 10_000,
      direction: 'credit',
      transactionKind: 'income',
      flowDirection: 'outflow',
      entrySource: 'imported',
      recordedAt: '',
    }),
    row('source-conflict', {
      amountMinor: 1_250,
      transactionKind: 'expense',
      flowDirection: 'outflow',
      entrySource: 'manual',
      recordedAt: '',
    }),
    row('recorded-at-conflict', {
      amountMinor: 1_250,
      transactionKind: 'expense',
      flowDirection: 'outflow',
      entrySource: 'imported',
      recordedAt: '2026-07-10T08:00:00.000Z',
    }),
  ])

  const report = await migrateTransactionExactMoney(client, { apply: true, recordedAt: MIGRATION_TIME })

  assert.equal(report.canonicalLegacyConflicts, 4)
  assert.equal(report.rowsApplied, 0)
  assert.equal(client.writes.length, 0)
})

test('partial compatible row fills only missing fields and preserves authoritative values', async () => {
  const client = new MigrationClient([
    row('compatible', {
      amountMinor: 1_250,
      transactionKind: 'expense',
      flowDirection: 'outflow',
      recordedAt: '2026-07-10T09:00:00.000Z',
    }),
  ])

  const report = await migrateTransactionExactMoney(client, { apply: true, recordedAt: MIGRATION_TIME })

  assert.equal(report.eligibleExpenseRows, 1)
  assert.equal(report.rowsApplied, 1)
  assert.deepEqual(client.writes[0]?.vars, {
    transactionKey: 'compatible',
    entrySource: 'imported',
  })
  assert.match(client.writes[0]?.query ?? '', /SET entrySource = \$entrySource/)
  assert.doesNotMatch(
    client.writes[0]?.query ?? '',
    /amountMinor\s*=|transactionKind\s*=|flowDirection\s*=|postedAt\s*=|recordedAt\s*=/,
  )
})

test('an isolated empty recorded time is not treated as a generated sentinel', async () => {
  const client = new MigrationClient([
    row('isolated-empty-recorded-at', {
      amountMinor: 1_250,
      transactionKind: 'expense',
      flowDirection: 'outflow',
      entrySource: 'imported',
      recordedAt: '',
    }),
  ])

  const report = await migrateTransactionExactMoney(client, { apply: true, recordedAt: MIGRATION_TIME })

  assert.equal(report.precisionRangeDateExceptions, 1)
  assert.equal(report.rowsApplied, 0)
  assert.equal(client.writes.length, 0)
})

test('ambiguous transfer remains unapplied', async () => {
  const client = new MigrationClient([
    row('ambiguous-transfer', {
      amount: '50.00',
      direction: 'transfer',
      isTransfer: true,
    }),
  ])

  const report = await migrateTransactionExactMoney(client, { apply: true, recordedAt: MIGRATION_TIME })

  assert.equal(report.ambiguousLegacyTransfers, 1)
  assert.equal(report.rowsApplied, 0)
  assert.equal(client.writes.length, 0)
})

test('complete canonical manual row is already canonical without imported-source conflict noise', async () => {
  const client = new MigrationClient([
    row('manual-expense', {
      amountMinor: 1_250,
      transactionKind: 'expense',
      flowDirection: 'outflow',
      entrySource: 'manual',
      recordedAt: '2026-07-10T09:00:00.000Z',
    }),
  ])

  const report = await migrateTransactionExactMoney(client, { apply: true, recordedAt: MIGRATION_TIME })

  assert.equal(report.alreadyCanonical, 1)
  assert.equal(report.canonicalLegacyConflicts, 0)
  assert.equal(report.rowsApplied, 0)
  assert.equal(client.writes.length, 0)
})
