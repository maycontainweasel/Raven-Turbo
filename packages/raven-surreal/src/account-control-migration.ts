import { createHash } from 'node:crypto'
import { parseDecimalMoney, RavenDomainError } from '@raven/domain'
import type { AccountNature, LiquidityClass } from '@raven/domain/server'
import type { SurrealQueryClient } from './repository.js'

type RawRow = Record<string, unknown>

export type AccountControlMigrationReport = Readonly<{
  mode: 'audit' | 'apply'
  accountsAudited: number
  classificationReviewRequired: number
  openingBalances: {
    alreadyCanonical: number
    eligible: number
    applied: number
    exceptions: number
  }
  transactionObservations: {
    candidates: number
    alreadyPresent: number
    eligible: number
    applied: number
    exceptions: number
  }
}>

export type AccountControlMigrationOptions = Readonly<{
  apply?: boolean
  recordedAt?: string
}>

function unwrapRows(response: unknown): RawRow[] {
  if (!Array.isArray(response)) return []
  for (let index = response.length - 1; index >= 0; index -= 1) {
    const statement = response[index]
    const result =
      statement && typeof statement === 'object' && 'result' in statement
        ? (statement as { result?: unknown }).result
        : statement
    if (Array.isArray(result)) return result as RawRow[]
  }
  return []
}

function recordId(value: unknown): string {
  if (typeof value === 'string') return value
  if (!value || typeof value !== 'object') return ''
  const record = value as Record<string, unknown>
  const tableValue = record.tb ?? record.table
  const table =
    typeof tableValue === 'string'
      ? tableValue
      : tableValue && typeof tableValue === 'object' && 'name' in tableValue
        ? String((tableValue as { name: unknown }).name)
        : ''
  return table ? `${table}:${String(record.id ?? '')}` : String(record.id ?? '')
}

function recordKey(value: unknown): string {
  return recordId(value).split(':').slice(1).join(':')
}

function decimalSource(value: unknown): string | null {
  if (typeof value === 'string' && value.trim()) return value.trim()
  if (typeof value === 'number' && Number.isFinite(value)) return String(value)
  return null
}

function hasCanonicalMinor(value: unknown): boolean {
  return typeof value === 'number' && Number.isSafeInteger(value)
}

export function suggestedClassification(accountType: string): {
  normalNature: AccountNature
  liquidityClass: LiquidityClass
} {
  return {
    normalNature: ['credit_card', 'loan', 'debt'].includes(accountType) ? 'liability' : 'asset',
    liquidityClass: ['current', 'savings', 'cash'].includes(accountType) ? 'liquid' : 'non_liquid',
  }
}

function isClassificationComplete(row: RawRow): boolean {
  return (
    (row.normalNature === 'asset' || row.normalNature === 'liability') &&
    (row.liquidityClass === 'liquid' || row.liquidityClass === 'non_liquid') &&
    Number.isSafeInteger(row.freshnessWindowHours)
  )
}

function migrationKey(sourceRef: string): string {
  return `transaction-observation-${createHash('sha256').update(sourceRef).digest('hex')}`
}

function requireInstant(value: unknown): string {
  const instant = String(value ?? '')
  if (!Number.isFinite(Date.parse(instant))) {
    throw new RavenDomainError('INVALID_MONEY', 'Transaction observation has no valid as-of time')
  }
  return new Date(instant).toISOString()
}

export async function migrateAccountControlFoundation(
  client: SurrealQueryClient,
  options: AccountControlMigrationOptions = {},
): Promise<AccountControlMigrationReport> {
  const apply = options.apply === true
  const recordedAt = options.recordedAt ?? new Date().toISOString()
  const accounts = unwrapRows(
    await client.query(`
      SELECT id, space, key, accountType, currency, openingBalance, openingBalanceMinor,
        normalNature, liquidityClass, freshnessWindowHours
      FROM account
      ORDER BY key;
    `),
  )
  const existingSourceRefs = new Set(
    unwrapRows(
      await client.query(`
        SELECT sourceRef
        FROM accountBalanceSnapshot
        WHERE sourceKind = "transaction_observation";
      `),
    ).map((row) => String(row.sourceRef ?? '')),
  )
  const transactions = unwrapRows(
    await client.query(`
      SELECT id, account, account.space AS space, account.accountType AS accountType,
        account.normalNature AS normalNature, postedAt, balance, currency, sourceRow
      FROM transaction
      WHERE sourceRow != NONE AND sourceRow != "" AND balance != NONE
      ORDER BY account, postedAt DESC;
    `),
  )

  const opening = { alreadyCanonical: 0, eligible: 0, applied: 0, exceptions: 0 }
  let classificationReviewRequired = 0
  for (const account of accounts) {
    if (!isClassificationComplete(account)) classificationReviewRequired += 1
    if (hasCanonicalMinor(account.openingBalanceMinor)) {
      opening.alreadyCanonical += 1
      continue
    }
    const source = decimalSource(account.openingBalance)
    if (source === null) {
      opening.exceptions += 1
      continue
    }
    try {
      const exact = parseDecimalMoney(source, String(account.currency ?? 'ZAR'))
      opening.eligible += 1
      if (apply) {
        await client.query(
          `UPDATE type::record("account", $accountKey) SET openingBalanceMinor = <int> $minorUnits;`,
          { accountKey: recordKey(account.id) || String(account.key ?? ''), minorUnits: exact.minorUnits },
        )
        opening.applied += 1
      }
    } catch {
      opening.exceptions += 1
    }
  }

  const latestByAccount = new Map<string, RawRow>()
  for (const transaction of transactions) {
    const accountId = recordId(transaction.account)
    if (accountId && !latestByAccount.has(accountId)) latestByAccount.set(accountId, transaction)
  }

  const observations = {
    candidates: latestByAccount.size,
    alreadyPresent: 0,
    eligible: 0,
    applied: 0,
    exceptions: 0,
  }
  for (const [accountId, transaction] of latestByAccount) {
    const sourceRef = recordId(transaction.id)
    if (!sourceRef) {
      observations.exceptions += 1
      continue
    }
    if (existingSourceRefs.has(sourceRef)) {
      observations.alreadyPresent += 1
      continue
    }
    try {
      const source = decimalSource(transaction.balance)
      if (source === null) throw new RavenDomainError('INVALID_MONEY', 'Transaction balance is absent')
      const signed = parseDecimalMoney(source, String(transaction.currency ?? 'ZAR'))
      const classification = suggestedClassification(String(transaction.accountType ?? 'other'))
      const economicNature =
        signed.minorUnits < 0
          ? 'liability'
          : transaction.normalNature === 'asset' || transaction.normalNature === 'liability'
            ? transaction.normalNature
            : classification.normalNature
      const amountMinor = Math.abs(signed.minorUnits)
      if (!Number.isSafeInteger(amountMinor)) {
        throw new RavenDomainError('INVALID_MONEY', 'Transaction balance exceeds the safe range')
      }
      const asOf = requireInstant(transaction.postedAt)
      observations.eligible += 1
      if (apply) {
        await client.query(
          `
            CREATE ONLY type::record("accountBalanceSnapshot", $snapshotKey) CONTENT {
              space: type::record("financialSpace", $spaceKey),
              account: type::record("account", $accountKey),
              key: $snapshotKey,
              balanceKind: "statement",
              amountMinor: <int> $amountMinor,
              currency: $currency,
              economicNature: $economicNature,
              asOf: $asOf,
              recordedAt: $recordedAt,
              evidenceLevel: "observed",
              sourceKind: "transaction_observation",
              sourceRef: $sourceRef,
              notes: "Account Control Workline 01 historical observation backfill"
            };
          `,
          {
            snapshotKey: migrationKey(sourceRef),
            spaceKey: recordKey(transaction.space),
            accountKey: recordKey(accountId),
            amountMinor,
            currency: signed.currency,
            economicNature,
            asOf,
            recordedAt,
            sourceRef,
          },
        )
        observations.applied += 1
      }
    } catch {
      observations.exceptions += 1
    }
  }

  return {
    mode: apply ? 'apply' : 'audit',
    accountsAudited: accounts.length,
    classificationReviewRequired,
    openingBalances: opening,
    transactionObservations: observations,
  }
}
