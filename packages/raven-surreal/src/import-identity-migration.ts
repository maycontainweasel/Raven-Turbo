import type { SurrealQueryClient } from './repository.js'

type RawRow = Record<string, unknown>
type ModelName =
  | 'statementImport'
  | 'statementRow'
  | 'transaction'
  | 'category'
  | 'merchant'
  | 'classificationRule'
  | 'clarificationTask'

export type ImportIdentityModelReport = Readonly<{
  rowsAudited: number
  canonicalIdentities: number
  legacyIdentities: number
  missingIdentityInputs: number
  expectedIdentityCollisions: number
}>

export type ImportIdentityCompatibilityReport = Readonly<{
  mode: 'audit'
  rowsAudited: number
  canonicalIdentities: number
  legacyIdentities: number
  missingIdentityInputs: number
  expectedIdentityCollisions: number
  models: Readonly<Record<ModelName, ImportIdentityModelReport>>
}>

const scopes: Readonly<Record<ModelName, readonly string[]>> = {
  statementImport: ['account', 'key'],
  statementRow: ['statementImport', 'key'],
  transaction: ['account', 'key'],
  category: ['space', 'key'],
  merchant: ['space', 'key'],
  classificationRule: ['space', 'key'],
  clarificationTask: ['transaction', 'key'],
}

function rows(response: unknown): RawRow[] {
  if (!Array.isArray(response)) return []
  for (let index = response.length - 1; index >= 0; index -= 1) {
    const statement = response[index]
    const result = statement && typeof statement === 'object' && 'result' in statement
      ? (statement as { result?: unknown }).result
      : statement
    if (Array.isArray(result)) return result as RawRow[]
  }
  return []
}

function identityPart(value: unknown): string {
  if (typeof value === 'string') return value.replaceAll('`', '').replaceAll('⟨', '').replaceAll('⟩', '')
  if (!value || typeof value !== 'object') return ''
  const record = value as Record<string, unknown>
  if (record.tb && record.id) return `${String(record.tb)}:${String(record.id)}`
  return record.id ? String(record.id) : ''
}

function recordKey(value: unknown): string {
  const normalized = identityPart(value)
  return normalized.includes(':') ? normalized.split(':').slice(1).join(':') : normalized
}

function modelReport(model: ModelName, records: RawRow[]): ImportIdentityModelReport {
  let canonicalIdentities = 0
  let missingIdentityInputs = 0
  const expectedCounts = new Map<string, number>()
  for (const record of records) {
    const parts = scopes[model].map((field) => identityPart(record[field]))
    if (parts.some((part) => !part)) {
      missingIdentityInputs += 1
      continue
    }
    const expected = parts.join('|')
    expectedCounts.set(expected, (expectedCounts.get(expected) ?? 0) + 1)
    if (recordKey(record.id) === expected) canonicalIdentities += 1
  }
  const expectedIdentityCollisions = [...expectedCounts.values()]
    .reduce((total, count) => total + Math.max(0, count - 1), 0)
  return {
    rowsAudited: records.length,
    canonicalIdentities,
    legacyIdentities: records.length - canonicalIdentities - missingIdentityInputs,
    missingIdentityInputs,
    expectedIdentityCollisions,
  }
}

export async function auditImportIdentityCompatibility(
  client: SurrealQueryClient,
): Promise<ImportIdentityCompatibilityReport> {
  const entries = await Promise.all(
    (Object.keys(scopes) as ModelName[]).map(async (model) => {
      const fields = [...new Set(['id', ...scopes[model]])].join(', ')
      const where = model === 'transaction' ? ' WHERE entrySource = "imported"' : ''
      const response = await client.query(`SELECT ${fields} FROM ${model}${where} ORDER BY id;`)
      return [model, modelReport(model, rows(response))] as const
    }),
  )
  const models = Object.fromEntries(entries) as Record<ModelName, ImportIdentityModelReport>
  return {
    mode: 'audit',
    rowsAudited: entries.reduce((total, [, report]) => total + report.rowsAudited, 0),
    canonicalIdentities: entries.reduce((total, [, report]) => total + report.canonicalIdentities, 0),
    legacyIdentities: entries.reduce((total, [, report]) => total + report.legacyIdentities, 0),
    missingIdentityInputs: entries.reduce((total, [, report]) => total + report.missingIdentityInputs, 0),
    expectedIdentityCollisions: entries.reduce((total, [, report]) => total + report.expectedIdentityCollisions, 0),
    models,
  }
}
