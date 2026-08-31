import assert from 'node:assert/strict'
import { readFile } from 'node:fs/promises'
import { Surreal } from 'surrealdb'
import YAML from 'yaml'
import { createAccountControlService } from '@raven/domain/server'
import { createSurrealAccountControlRepository } from '@raven/surreal'

type DatabaseConfig = {
  url: string
  namespace: string
  database: string
  username: string
  password: string
}

type LocalAppConfig = {
  environment: { defaultDatabase: string }
  databases: Record<string, DatabaseConfig>
}

const SPACE_KEY = 'wl01-fictional-space'
const SECOND_SPACE_KEY = 'wl01-fictional-business-space'
const ACCOUNT_KEY = 'wl01-fictional-account'
const TARGET_ACCOUNT_KEY = 'wl02-fictional-target-account'
const CREATE_KEY = 'wl01-fictional-create-001'
const SECOND_CREATE_KEY = 'wl01-fictional-create-002'
const TARGET_CREATE_KEY = 'wl02-fictional-create-target-001'
const BALANCE_KEY = 'wl01-fictional-balance-001'
const EXPENSE_KEY = 'wl02-fictional-expense-001'
const INCOME_KEY = 'wl02-fictional-income-001'
const TRANSFER_KEY = 'wl02-fictional-transfer-001'
const NOW = '2026-07-11T10:00:00.000Z'

async function main() {
  const config = YAML.parse(
    await readFile(new URL('../../schema/config/app.config.yaml', import.meta.url), 'utf8'),
  ) as LocalAppConfig
  const database = config.databases.local ?? config.databases[config.environment.defaultDatabase]
  if (!database) throw new Error('Local Raven database configuration is unavailable')

  const client = new Surreal()
  await client.connect(database.url)
  await client.signin({ username: database.username, password: database.password })
  await client.use({ namespace: database.namespace, database: database.database })

  const cleanup = () =>
    client.query(
      `
        DELETE accountBalanceSnapshot
          WHERE account.key = $accountKey OR notes = "Disposable fictional balance note";
        DELETE transaction
          WHERE account.key IN [$accountKey, $targetAccountKey]
            AND space.key IN [$spaceKey, $secondSpaceKey];
        DELETE accountTransfer
          WHERE sourceAccount.key IN [$accountKey, $targetAccountKey]
             OR targetAccount.key IN [$accountKey, $targetAccountKey];
        DELETE financialOperation WHERE idempotencyKey IN [
          $createKey, $secondCreateKey, $targetCreateKey, $balanceKey,
          $expenseKey, $incomeKey, $transferKey
        ];
        DELETE account
          WHERE key IN [$accountKey, $targetAccountKey]
            AND space.key IN [$spaceKey, $secondSpaceKey];
        DELETE financialSpace WHERE key IN [$spaceKey, $secondSpaceKey];
      `,
      {
        spaceKey: SPACE_KEY,
        secondSpaceKey: SECOND_SPACE_KEY,
        accountKey: ACCOUNT_KEY,
        targetAccountKey: TARGET_ACCOUNT_KEY,
        createKey: CREATE_KEY,
        secondCreateKey: SECOND_CREATE_KEY,
        targetCreateKey: TARGET_CREATE_KEY,
        balanceKey: BALANCE_KEY,
        expenseKey: EXPENSE_KEY,
        incomeKey: INCOME_KEY,
        transferKey: TRANSFER_KEY,
      },
    )

  try {
    await cleanup()
    await client.query(
      `
        CREATE ONLY type::record("financialSpace", $spaceKey) CONTENT {
          key: $spaceKey,
          name: "Workline 01 Fictional Space",
          spaceType: "personal",
          currency: "ZAR",
          description: "Disposable Account Control smoke fixture",
          active: true,
          archivedAt: ""
        };
        CREATE ONLY type::record("financialSpace", $secondSpaceKey) CONTENT {
          key: $secondSpaceKey,
          name: "Workline 01 Fictional Business Space",
          spaceType: "business",
          currency: "ZAR",
          description: "Disposable Account Control collision fixture",
          active: true,
          archivedAt: ""
        };
      `,
      { spaceKey: SPACE_KEY, secondSpaceKey: SECOND_SPACE_KEY },
    )

    const service = createAccountControlService(
      createSurrealAccountControlRepository(client),
      () => new Date(NOW),
    )
    const createInput = {
      idempotencyKey: CREATE_KEY,
      channel: 'system' as const,
      spaceKey: SPACE_KEY,
      accountKey: ACCOUNT_KEY,
      name: 'Workline 01 Fictional Account',
      bankName: 'Example Bank',
      accountType: 'current',
      currency: 'ZAR',
      normalNature: 'asset' as const,
      liquidityClass: 'liquid' as const,
      freshnessWindowHours: 72,
    }
    const created = await service.createAccount(createInput)
    const createReplay = await service.createAccount(createInput)
    assert.equal(created.receipt.status, 'applied')
    assert.equal(createReplay.receipt.status, 'replayed')

    const secondCreated = await service.createAccount({
      ...createInput,
      idempotencyKey: SECOND_CREATE_KEY,
      spaceKey: SECOND_SPACE_KEY,
    })
    assert.notEqual(created.entity.id, secondCreated.entity.id)
    assert.equal(created.entity.accountKey, secondCreated.entity.accountKey)

    const balanceInput = {
      idempotencyKey: BALANCE_KEY,
      channel: 'system' as const,
      spaceKey: SPACE_KEY,
      accountKey: ACCOUNT_KEY,
      balanceKind: 'available' as const,
      money: { currency: 'ZAR', minorUnits: 12_345 },
      economicNature: 'asset' as const,
      asOf: NOW,
      note: 'Disposable fictional balance note',
    }
    const confirmed = await service.confirmAccountBalance(balanceInput)
    const balanceReplay = await service.confirmAccountBalance(balanceInput)
    assert.equal(confirmed.receipt.status, 'applied')
    assert.equal(balanceReplay.receipt.status, 'replayed')
    assert.equal(confirmed.entity.snapshotId, balanceReplay.entity.snapshotId)
    assert.equal(confirmed.entity.note, 'Disposable fictional balance note')
    assert.equal(balanceReplay.entity.note, 'Disposable fictional balance note')

    const listed = await service.listAccounts({ spaceKeys: [SPACE_KEY], asOf: NOW })
    assert.equal(listed.spaces.length, 1)
    assert.equal(listed.spaces[0]?.accounts.length, 1)
    assert.equal(listed.spaces[0]?.accounts[0]?.selectedBalance?.money.minorUnits, 12_345)

    const position = await service.getCurrentPosition({ spaceKeys: [SPACE_KEY], currency: 'ZAR', asOf: NOW })
    assert.equal(position.liquidCash?.minorUnits, 12_345)
    assert.equal(position.knownNetPosition.minorUnits, 12_345)
    assert.equal(position.meta.quality, 'complete')

    const targetCreated = await service.createAccount({
      ...createInput,
      idempotencyKey: TARGET_CREATE_KEY,
      accountKey: TARGET_ACCOUNT_KEY,
      name: 'Workline 02 Fictional Target Account',
    })
    assert.equal(targetCreated.receipt.status, 'applied')

    const expenseInput = {
      idempotencyKey: EXPENSE_KEY,
      channel: 'system' as const,
      spaceKey: SPACE_KEY,
      accountKey: ACCOUNT_KEY,
      money: { currency: 'ZAR', minorUnits: 2_345 },
      postedAt: '2026-07-10',
      description: 'Disposable fictional expense',
    }
    const incomeInput = {
      idempotencyKey: INCOME_KEY,
      channel: 'system' as const,
      spaceKey: SPACE_KEY,
      accountKey: ACCOUNT_KEY,
      money: { currency: 'ZAR', minorUnits: 8_000 },
      postedAt: '2026-07-09',
      description: 'Disposable fictional income',
    }
    const transferInput = {
      idempotencyKey: TRANSFER_KEY,
      channel: 'system' as const,
      source: { spaceKey: SPACE_KEY, accountKey: ACCOUNT_KEY },
      target: { spaceKey: SPACE_KEY, accountKey: TARGET_ACCOUNT_KEY },
      money: { currency: 'ZAR', minorUnits: 1_500 },
      postedAt: '2026-07-08',
      description: 'Disposable fictional transfer',
    }

    const expense = await service.recordExpense(expenseInput)
    const expenseReplay = await service.recordExpense(expenseInput)
    const income = await service.recordIncome(incomeInput)
    const incomeReplay = await service.recordIncome(incomeInput)
    const transfer = await service.recordTransfer(transferInput)
    const transferReplay = await service.recordTransfer(transferInput)
    assert.equal(expense.receipt.status, 'applied')
    assert.equal(expenseReplay.receipt.status, 'replayed')
    assert.equal(expense.entity.id, expenseReplay.entity.id)
    assert.equal(income.receipt.status, 'applied')
    assert.equal(incomeReplay.receipt.status, 'replayed')
    assert.equal(income.entity.id, incomeReplay.entity.id)
    assert.equal(transfer.receipt.status, 'applied')
    assert.equal(transferReplay.receipt.status, 'replayed')
    assert.equal(transfer.transfer.id, transferReplay.transfer.id)
    assert.equal(transfer.sourceTransaction.flowDirection, 'outflow')
    assert.equal(transfer.targetTransaction.flowDirection, 'inflow')

    const progress = await service.getMonthProgress({
      month: '2026-07',
      currency: 'ZAR',
      accountRefs: [
        { spaceKey: SPACE_KEY, accountKey: ACCOUNT_KEY },
        { spaceKey: SPACE_KEY, accountKey: TARGET_ACCOUNT_KEY },
      ],
      asOf: NOW,
    })
    assert.equal(progress.income.minorUnits, 8_000)
    assert.equal(progress.outflow.minorUnits, 2_345)
    assert.equal(progress.net.minorUnits, 5_655)
    assert.equal(progress.counts.transfer, 2)

    const sourceLedger = await service.listAccountTransactions({
      spaceKey: SPACE_KEY,
      accountKey: ACCOUNT_KEY,
      month: '2026-07',
    })
    assert.equal(sourceLedger.transactions.length, 3)
    assert.deepEqual(sourceLedger.transactions.map((entry) => entry.financialDate), [
      '2026-07-10',
      '2026-07-09',
      '2026-07-08',
    ])
    const detail = await service.getTransaction({ transactionId: transfer.sourceTransaction.id })
    assert.equal(detail.transaction.transfer?.counterpart.accountKey, TARGET_ACCOUNT_KEY)

    const accountAfterMovements = await service.getAccount({
      spaceKey: SPACE_KEY,
      accountKey: ACCOUNT_KEY,
      asOf: NOW,
    })
    assert.equal(accountAfterMovements.account.selectedBalance?.money.minorUnits, 12_345)
    assert.equal(accountAfterMovements.account.selectedBalance?.recordedAt, confirmed.entity.recordedAt)
    assert.deepEqual(accountAfterMovements.availableMonths, ['2026-07'])

    process.stdout.write('Account Control Worklines 01-02 live smoke: PASS\n')
  } finally {
    await cleanup()
    await client.close()
  }
}

main().catch((error) => {
  process.stderr.write(`${error instanceof Error ? error.stack ?? error.message : String(error)}\n`)
  process.exitCode = 1
})
