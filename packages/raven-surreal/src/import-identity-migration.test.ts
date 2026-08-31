import assert from 'node:assert/strict'
import test from 'node:test'
import { auditImportIdentityCompatibility } from './import-identity-migration.js'
import type { SurrealQueryClient } from './repository.js'

test('import identity compatibility audit is aggregate-only and has no apply mode', async () => {
  const queries: string[] = []
  const fixtures: Record<string, Array<Record<string, unknown>>> = {
    statementImport: [
      { id: 'statementImport:account:space-a|daily|july', account: 'account:space-a|daily', key: 'july' },
      { id: 'statementImport:legacy-july', account: 'account:space-b|daily', key: 'july' },
    ],
    statementRow: [
      { id: 'statementRow:statementImport:account:space-a|daily|july|row-01', statementImport: 'statementImport:account:space-a|daily|july', key: 'row-01' },
      { id: 'statementRow:missing-key', statementImport: 'statementImport:account:space-a|daily|july', key: '' },
    ],
    transaction: [
      { id: 'transaction:account:space-a|daily|import-july-row-01', account: 'account:space-a|daily', key: 'import-july-row-01' },
    ],
    category: [
      { id: 'category:financialSpace:space-a|fees', space: 'financialSpace:space-a', key: 'fees' },
      { id: 'category:legacy-fees', space: 'financialSpace:space-b', key: 'fees' },
    ],
    merchant: [],
    classificationRule: [],
    clarificationTask: [],
  }
  const client: SurrealQueryClient = {
    async query(query) {
      queries.push(query)
      const model = Object.keys(fixtures).find((name) => query.includes(`FROM ${name}`))!
      return [[...fixtures[model]!]]
    },
  }

  const report = await auditImportIdentityCompatibility(client)

  assert.equal(report.mode, 'audit')
  assert.equal(report.rowsAudited, 7)
  assert.equal(report.canonicalIdentities, 4)
  assert.equal(report.legacyIdentities, 2)
  assert.equal(report.missingIdentityInputs, 1)
  assert.equal(report.expectedIdentityCollisions, 0)
  const transactionQuery = queries.find((query) => query.includes('FROM transaction'))
  assert.match(transactionQuery ?? '', /WHERE entrySource = "imported"/)
  assert.deepEqual(Object.keys(report).sort(), [
    'canonicalIdentities', 'expectedIdentityCollisions', 'legacyIdentities',
    'missingIdentityInputs', 'mode', 'models', 'rowsAudited',
  ])
})
