import assert from 'node:assert/strict'
import test from 'node:test'
import { migrateAccountControlFoundation, suggestedClassification } from './account-control-migration.js'
import type { SurrealQueryClient } from './repository.js'

class MigrationClient implements SurrealQueryClient {
  readonly writes: Array<{ query: string; vars?: Record<string, unknown> }> = []

  async query(query: string, vars?: Record<string, unknown>): Promise<unknown> {
    if (query.includes('FROM account\n')) {
      return [
        [
          {
            id: 'account:fictional-daily',
            space: 'financialSpace:fictional-personal',
            key: 'fictional-daily',
            accountType: 'current',
            currency: 'ZAR',
            openingBalance: '123.45',
            normalNature: 'asset',
            liquidityClass: 'liquid',
            freshnessWindowHours: 72,
          },
          {
            id: 'account:fictional-precision-exception',
            space: 'financialSpace:fictional-personal',
            key: 'fictional-precision-exception',
            accountType: 'savings',
            currency: 'ZAR',
            openingBalance: '1.001',
          },
        ],
      ]
    }
    if (query.includes('FROM accountBalanceSnapshot')) return [[]]
    if (query.includes('FROM transaction')) {
      return [
        [
          {
            id: 'transaction:fictional-latest',
            account: 'account:fictional-daily',
            space: 'financialSpace:fictional-personal',
            accountType: 'current',
            normalNature: 'asset',
            postedAt: '2026-07-10T08:00:00.000Z',
            balance: '-20.50',
            currency: 'ZAR',
            sourceRow: 'statementRow:fictional-row',
          },
        ],
      ]
    }
    this.writes.push({ query, vars })
    return [[]]
  }
}

test('migration audit is aggregate-only and rejects unsupported opening precision', async () => {
  const client = new MigrationClient()
  const report = await migrateAccountControlFoundation(client, {
    recordedAt: '2026-07-11T10:00:00.000Z',
  })

  assert.equal(report.mode, 'audit')
  assert.equal(report.accountsAudited, 2)
  assert.equal(report.classificationReviewRequired, 1)
  assert.deepEqual(report.openingBalances, {
    alreadyCanonical: 0,
    eligible: 1,
    applied: 0,
    exceptions: 1,
  })
  assert.deepEqual(report.transactionObservations, {
    candidates: 1,
    alreadyPresent: 0,
    eligible: 1,
    applied: 0,
    exceptions: 0,
  })
  assert.equal(client.writes.length, 0)
})

test('apply writes exact minor units and preserves transaction observation provenance', async () => {
  const client = new MigrationClient()
  const report = await migrateAccountControlFoundation(client, {
    apply: true,
    recordedAt: '2026-07-11T10:00:00.000Z',
  })

  assert.equal(report.openingBalances.applied, 1)
  assert.equal(report.transactionObservations.applied, 1)
  assert.equal(client.writes.length, 2)
  assert.equal(client.writes[0]?.vars?.minorUnits, 12_345)
  assert.equal(client.writes[1]?.vars?.amountMinor, 2_050)
  assert.equal(client.writes[1]?.vars?.economicNature, 'liability')
  assert.equal(client.writes[1]?.vars?.asOf, '2026-07-10T08:00:00.000Z')
  assert.match(client.writes[1]?.query ?? '', /evidenceLevel: "observed"/)
  assert.match(client.writes[1]?.query ?? '', /sourceKind: "transaction_observation"/)
})

test('classification suggestions are deterministic but remain review input', () => {
  assert.deepEqual(suggestedClassification('credit_card'), {
    normalNature: 'liability',
    liquidityClass: 'non_liquid',
  })
  assert.deepEqual(suggestedClassification('savings'), {
    normalNature: 'asset',
    liquidityClass: 'liquid',
  })
})
