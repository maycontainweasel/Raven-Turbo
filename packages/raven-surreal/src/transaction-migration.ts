import { normalizeLegacyFinancialDate, parseDecimalMoney } from '@raven/domain'
import type { SurrealQueryClient } from './repository.js'

type RawRow = Record<string, unknown>
type CanonicalPatch = Partial<{
  amountMinor: number
  transactionKind: string
  flowDirection: string
  entrySource: string
  postedAt: string
  recordedAt: string
}>

type LegacyProposal = Readonly<{
  amountMinor: number
  transactionKind: 'income' | 'expense'
  flowDirection: 'inflow' | 'outflow'
  entrySource: 'imported'
  postedAt: string
  recordedAt: string
  recordedAtFromSource: boolean
}>

export type TransactionMigrationReport = Readonly<{
  mode: 'audit' | 'apply'
  rowsAudited: number
  alreadyCanonical: number
  eligibleIncomeRows: number
  eligibleExpenseRows: number
  ambiguousLegacyTransfers: number
  precisionRangeDateExceptions: number
  canonicalLegacyConflicts: number
  recordedAtFallbacks: number
  rowsApplied: number
}>

export type TransactionMigrationOptions = Readonly<{
  apply?: boolean
  recordedAt?: string
}>

const transactionKinds = new Set(['income', 'expense', 'transfer', 'adjustment', 'unresolved'])
const flowDirections = new Set(['inflow', 'outflow'])
const entrySources = new Set(['imported', 'manual', 'generated'])

function unwrapRows(response: unknown): RawRow[] {
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

function recordKey(value: unknown): string {
  if (typeof value === 'string') return value.split(':').slice(1).join(':')
  if (!value || typeof value !== 'object') return ''
  return String((value as Record<string, unknown>).id ?? '')
}

function validInstant(value: unknown): string | null {
  const parsed = Date.parse(String(value ?? ''))
  return Number.isFinite(parsed) ? new Date(parsed).toISOString() : null
}

function isMissing(value: unknown): boolean {
  return value === undefined || value === null || value === 'NONE'
}

function isBlankOrMissing(value: unknown): boolean {
  return value === '' || isMissing(value)
}

function hasExactAmount(value: unknown): value is number {
  return typeof value === 'number' && Number.isSafeInteger(value) && value > 0
}

function kindFlowCoherent(kind: unknown, flow: unknown): boolean {
  if (!transactionKinds.has(String(kind)) || !flowDirections.has(String(flow))) return false
  if (kind === 'income') return flow === 'inflow'
  if (kind === 'expense') return flow === 'outflow'
  return kind === 'transfer' || kind === 'adjustment'
}

function canonicalComplete(row: RawRow): boolean {
  return (
    hasExactAmount(row.amountMinor)
    && kindFlowCoherent(row.transactionKind, row.flowDirection)
    && entrySources.has(String(row.entrySource))
    && normalizeLegacyFinancialDate(row.postedAt) !== null
    && validInstant(row.recordedAt) !== null
  )
}

function isOldGeneratedDefaultTuple(row: RawRow): boolean {
  return (
    row.amountMinor === 0
    && row.transactionKind === 'expense'
    && row.flowDirection === 'outflow'
    && row.entrySource === 'imported'
    && row.recordedAt === ''
  )
}

function isEmptyGeneratedDefaultTuple(row: RawRow): boolean {
  return (
    row.amountMinor === 0
    && isBlankOrMissing(row.transactionKind)
    && isBlankOrMissing(row.flowDirection)
    && isBlankOrMissing(row.entrySource)
    && isBlankOrMissing(row.recordedAt)
  )
}

function legacyProposal(
  row: RawRow,
  migrationRecordedAt: string,
): LegacyProposal | null {
  if (row.direction !== 'credit' && row.direction !== 'debit') return null
  const parsed = parseDecimalMoney(String(row.amount ?? ''), String(row.currency ?? 'ZAR'))
  const amountMinor = Math.abs(parsed.minorUnits)
  const postedAt = normalizeLegacyFinancialDate(row.postedAt)
  if (!Number.isSafeInteger(amountMinor) || amountMinor <= 0 || !postedAt) return null
  const sourceRecordedAt = validInstant(row.sourceImportedAt)
  return {
    amountMinor,
    transactionKind: row.direction === 'credit' ? 'income' : 'expense',
    flowDirection: row.direction === 'credit' ? 'inflow' : 'outflow',
    entrySource: 'imported',
    postedAt,
    recordedAt: sourceRecordedAt ?? migrationRecordedAt,
    recordedAtFromSource: sourceRecordedAt !== null,
  }
}

function auditCanonicalFields(
  row: RawRow,
  proposal: LegacyProposal,
): { conflict: boolean; invalid: boolean; patch: CanonicalPatch } {
  const patch: CanonicalPatch = {}
  let conflict = false
  let invalid = false
  const generatedDefaults = isOldGeneratedDefaultTuple(row) || isEmptyGeneratedDefaultTuple(row)

  if (generatedDefaults || isMissing(row.amountMinor)) patch.amountMinor = proposal.amountMinor
  else if (hasExactAmount(row.amountMinor)) conflict ||= row.amountMinor !== proposal.amountMinor
  else invalid = true

  if (generatedDefaults || isBlankOrMissing(row.transactionKind)) {
    patch.transactionKind = proposal.transactionKind
  } else if (transactionKinds.has(String(row.transactionKind))) {
    conflict ||= row.transactionKind !== proposal.transactionKind
  } else {
    invalid = true
  }

  if (generatedDefaults || isBlankOrMissing(row.flowDirection)) {
    patch.flowDirection = proposal.flowDirection
  } else if (flowDirections.has(String(row.flowDirection))) {
    conflict ||= row.flowDirection !== proposal.flowDirection
  } else {
    invalid = true
  }

  if (generatedDefaults || isBlankOrMissing(row.entrySource)) {
    patch.entrySource = proposal.entrySource
  } else if (entrySources.has(String(row.entrySource))) {
    conflict ||= row.entrySource !== proposal.entrySource
  } else {
    invalid = true
  }

  const canonicalPostedAt = normalizeLegacyFinancialDate(row.postedAt)
  if (isMissing(row.postedAt)) patch.postedAt = proposal.postedAt
  else if (canonicalPostedAt) conflict ||= canonicalPostedAt !== proposal.postedAt
  else invalid = true

  const canonicalRecordedAt = validInstant(row.recordedAt)
  if (generatedDefaults || isMissing(row.recordedAt)) {
    patch.recordedAt = proposal.recordedAt
  } else if (canonicalRecordedAt) {
    if (proposal.recordedAtFromSource) conflict ||= canonicalRecordedAt !== proposal.recordedAt
  } else {
    invalid = true
  }

  return { conflict, invalid, patch }
}

function assignment(field: keyof CanonicalPatch): string {
  return field === 'amountMinor'
    ? 'amountMinor = <int> $amountMinor'
    : `${field} = $${field}`
}

export async function migrateTransactionExactMoney(
  client: SurrealQueryClient,
  options: TransactionMigrationOptions = {},
): Promise<TransactionMigrationReport> {
  const apply = options.apply === true
  const migrationRecordedAt = validInstant(options.recordedAt ?? new Date().toISOString())!
  const records = unwrapRows(
    await client.query(`
      SELECT id, amount, amountMinor, currency, direction, isTransfer, postedAt,
        transactionKind, flowDirection, entrySource, recordedAt,
        sourceRow.statementImport.importedAt AS sourceImportedAt
      FROM transaction
      ORDER BY id;
    `),
  )
  const report = {
    mode: apply ? 'apply' as const : 'audit' as const,
    rowsAudited: records.length,
    alreadyCanonical: 0,
    eligibleIncomeRows: 0,
    eligibleExpenseRows: 0,
    ambiguousLegacyTransfers: 0,
    precisionRangeDateExceptions: 0,
    canonicalLegacyConflicts: 0,
    recordedAtFallbacks: 0,
    rowsApplied: 0,
  }

  for (const row of records) {
    let proposal: LegacyProposal | null = null
    try {
      proposal = legacyProposal(row, migrationRecordedAt)
    } catch {
      // A complete canonical tuple remains authoritative even if its legacy fields are malformed.
    }

    if (canonicalComplete(row)) {
      report.alreadyCanonical += 1
      if (row.entrySource === 'imported' && proposal && auditCanonicalFields(row, proposal).conflict) {
        report.canonicalLegacyConflicts += 1
      }
      continue
    }

    const transferLike = row.isTransfer === true
      || row.direction === 'transfer'
      || row.transactionKind === 'transfer'
    if (transferLike) {
      if (!flowDirections.has(String(row.flowDirection))) report.ambiguousLegacyTransfers += 1
      else report.precisionRangeDateExceptions += 1
      continue
    }

    if (!proposal) {
      report.precisionRangeDateExceptions += 1
      continue
    }

    const audit = auditCanonicalFields(row, proposal)
    if (audit.conflict) {
      report.canonicalLegacyConflicts += 1
      continue
    }
    if (audit.invalid || Object.keys(audit.patch).length === 0) {
      report.precisionRangeDateExceptions += 1
      continue
    }

    if (proposal.transactionKind === 'income') report.eligibleIncomeRows += 1
    else report.eligibleExpenseRows += 1
    if ('recordedAt' in audit.patch && !proposal.recordedAtFromSource) {
      report.recordedAtFallbacks += 1
    }

    if (apply) {
      const fields = Object.keys(audit.patch) as Array<keyof CanonicalPatch>
      await client.query(
        `UPDATE type::record("transaction", $transactionKey) SET ${fields.map(assignment).join(', ')};`,
        { transactionKey: recordKey(row.id), ...audit.patch },
      )
      report.rowsApplied += 1
    }
  }

  return report
}
