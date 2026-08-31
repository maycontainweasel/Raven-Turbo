import assert from 'node:assert/strict'
import { execFile } from 'node:child_process'
import { mkdtemp, readFile, rm, writeFile } from 'node:fs/promises'
import os from 'node:os'
import path from 'node:path'
import { promisify } from 'node:util'
import { Surreal } from 'surrealdb'
import YAML from 'yaml'

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

type RawRow = Record<string, unknown>

const execFileAsync = promisify(execFile)
const SPACE_A = 'wl02-import-fictional-personal'
const SPACE_B = 'wl02-import-fictional-business'
const ACCOUNT_KEY = 'wl02-import-fictional-daily'
const IMPORT_KEY = 'wl02-import-fictional-2026-07'

function rows(response: unknown): RawRow[] {
  if (!Array.isArray(response)) return []
  for (let index = response.length - 1; index >= 0; index -= 1) {
    const statement = response[index]
    const result = statement && typeof statement === 'object' && 'result' in statement
      ? (statement as { result?: unknown }).result
      : statement
    if (Array.isArray(result)) return result as RawRow[]
    if (result && typeof result === 'object') return [result as RawRow]
  }
  return []
}

function fixture(source: string, spaceKey: string, spaceName: string, spaceType: string): string {
  return source
    .replace('Environment key: `fictional-space`', `Environment key: \`${spaceKey}\``)
    .replace('Environment name: `Fictional Space`', `Environment name: \`${spaceName}\``)
    .replace('Environment type: `personal`', `Environment type: \`${spaceType}\``)
    .replace('Account key: `fictional-daily`', `Account key: \`${ACCOUNT_KEY}\``)
    .replace('Import key: `fictional-2026-07`', `Import key: \`${IMPORT_KEY}\``)
}

async function render(directory: string, name: string, source: string): Promise<string> {
  const inputPath = path.join(directory, `${name}.md`)
  const outputPath = path.join(directory, `${name}.surql`)
  await writeFile(inputPath, source, 'utf8')
  await execFileAsync(process.execPath, [
    new URL('../../../scripts/render-statement-import.mjs', import.meta.url).pathname,
    '--input', inputPath,
    '--output', outputPath,
  ])
  return readFile(outputPath, 'utf8')
}

async function executeImport(client: Surreal, script: string, variables?: Record<string, unknown>): Promise<void> {
  const responses = await client.query(script, variables).responses()
  const failures = responses.filter((response) => !response.success)
  if (failures.length) {
    throw new Error(failures.map((failure) => failure.success ? '' : failure.error.message).filter(Boolean).join('\n'))
  }
}

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
  const directory = await mkdtemp(path.join(os.tmpdir(), 'raven-import-live-'))
  const cleanup = () => executeImport(client, `
    LET $spaceRecordA = type::record("financialSpace", $spaceA);
    LET $spaceRecordB = type::record("financialSpace", $spaceB);
    LET $accountRecordA = type::record("account", fn::stringID([$spaceRecordA, $accountKey]));
    LET $accountRecordB = type::record("account", fn::stringID([$spaceRecordB, $accountKey]));
    DELETE FinancialSpaceAccounts WHERE in = $spaceRecordA OR in = $spaceRecordB;
    DELETE type::record("FinancialSpaceAccounts", fn::stringID([$spaceRecordA, $accountRecordA]));
    DELETE type::record("FinancialSpaceAccounts", fn::stringID([$spaceRecordB, $accountRecordB]));
    DELETE FinancialSpaceAccounts WHERE string::contains(type::string(in), $spaceA) OR string::contains(type::string(in), $spaceB);
    DELETE AccountStatementImports WHERE string::contains(type::string(in), $spaceA) OR string::contains(type::string(in), $spaceB);
    DELETE StatementImportRows WHERE string::contains(type::string(in), $spaceA) OR string::contains(type::string(in), $spaceB);
    DELETE StatementRowTransactions WHERE string::contains(type::string(in), $spaceA) OR string::contains(type::string(in), $spaceB);
    DELETE AccountTransactions WHERE string::contains(type::string(in), $spaceA) OR string::contains(type::string(in), $spaceB);
    DELETE TransactionMerchant WHERE string::contains(type::string(in), $spaceA) OR string::contains(type::string(in), $spaceB);
    DELETE TransactionCategory WHERE string::contains(type::string(in), $spaceA) OR string::contains(type::string(in), $spaceB);
    DELETE TransactionClarificationTasks WHERE string::contains(type::string(in), $spaceA) OR string::contains(type::string(in), $spaceB);
    DELETE clarificationTask WHERE space.key IN [$spaceA, $spaceB];
    DELETE transaction WHERE space.key IN [$spaceA, $spaceB];
    DELETE statementRow WHERE space.key IN [$spaceA, $spaceB];
    DELETE statementImport WHERE space.key IN [$spaceA, $spaceB];
    DELETE classificationRule WHERE space.key IN [$spaceA, $spaceB];
    DELETE merchant WHERE space.key IN [$spaceA, $spaceB];
    DELETE category WHERE space.key IN [$spaceA, $spaceB];
    DELETE account WHERE space.key IN [$spaceA, $spaceB];
    DELETE financialSpace WHERE key IN [$spaceA, $spaceB];
  `, { spaceA: SPACE_A, spaceB: SPACE_B, accountKey: ACCOUNT_KEY })

  try {
    await cleanup()
    const remainingFixtureEdges = rows(await client.query(`
      SELECT id FROM FinancialSpaceAccounts
      WHERE string::contains(type::string(id), $spaceA)
         OR string::contains(type::string(id), $spaceB);
    `, { spaceA: SPACE_A, spaceB: SPACE_B }))
    assert.equal(remainingFixtureEdges.length, 0, 'fictional fixture edges must be removed before the smoke test')
    const source = await readFile(new URL('../../../scripts/tests/fixtures/fictional-statement-import.md', import.meta.url), 'utf8')
    const personalSource = fixture(source, SPACE_A, 'WL02 Fictional Personal', 'personal')
    const businessSource = fixture(source, SPACE_B, 'WL02 Fictional Business', 'business')
    const personal = await render(directory, 'personal', personalSource)
    const business = await render(directory, 'business', businessSource)

    await executeImport(client, personal)
    const firstImport = rows(await client.query(
      'SELECT id, importedAt, sourceChecksum FROM statementImport WHERE space.key = $spaceKey AND key = $importKey;',
      { spaceKey: SPACE_A, importKey: IMPORT_KEY },
    ))[0]!
    const firstReviewedSource = rows(await client.query(`
      SELECT amountMinor, currency, postedAt, sourceChecksum, sourceRow
      FROM transaction WHERE space.key = $spaceKey AND key = $transactionKey;
    `, { spaceKey: SPACE_A, transactionKey: `import-${IMPORT_KEY}-row-04` }))[0]!
    await executeImport(client, personal)
    const replayImport = rows(await client.query(
      'SELECT id, importedAt, sourceChecksum FROM statementImport WHERE space.key = $spaceKey AND key = $importKey;',
      { spaceKey: SPACE_A, importKey: IMPORT_KEY },
    ))[0]!
    assert.deepEqual(replayImport, firstImport)

    const personalCounts = rows(await client.query(`
      RETURN {
        imports: array::len(SELECT VALUE id FROM statementImport WHERE space.key = $spaceKey),
        rows: array::len(SELECT VALUE id FROM statementRow WHERE space.key = $spaceKey),
        transactions: array::len(SELECT VALUE id FROM transaction WHERE space.key = $spaceKey),
        tasks: array::len(SELECT VALUE id FROM clarificationTask WHERE space.key = $spaceKey)
      };
    `, { spaceKey: SPACE_A }))[0]!
    assert.deepEqual(personalCounts, { imports: 1, rows: 4, transactions: 4, tasks: 2 })

    const immutableChanges = [
      ['amount', personalSource.replace('| 6.78 |  | 1086.62 |', '| 6.79 |  | 1086.62 |')],
      ['date', personalSource.replace('| 4 | 05 Jul |', '| 4 | 06 Jul |')],
      ['raw-row', personalSource.replace('Fictional malformed movement', 'Fictional changed source movement')],
    ] as const
    for (const [name, changedSource] of immutableChanges) {
      const changed = await render(directory, `changed-${name}`, changedSource)
      await assert.rejects(executeImport(client, changed), /RAVEN_IMPORT_IMMUTABLE_CONFLICT/)
    }
    const afterConflictCounts = rows(await client.query(`
      RETURN {
        imports: array::len(SELECT VALUE id FROM statementImport WHERE space.key = $spaceKey),
        rows: array::len(SELECT VALUE id FROM statementRow WHERE space.key = $spaceKey),
        transactions: array::len(SELECT VALUE id FROM transaction WHERE space.key = $spaceKey),
        tasks: array::len(SELECT VALUE id FROM clarificationTask WHERE space.key = $spaceKey)
      };
    `, { spaceKey: SPACE_A }))[0]!
    assert.deepEqual(afterConflictCounts, personalCounts)

    const reviewedSource = personalSource.replace(
      '| 4 | 05 Jul | Fictional malformed movement | mystery |  | Review |  | 6.78 |  | 1086.62 | matched | Direction is deliberately unknown |',
      '| 4 | 05 Jul | Fictional malformed movement | expense | Fictional Shop | General |  | 6.78 |  | 1086.62 | clarified | Reviewed classification |',
    )
    await executeImport(client, await render(directory, 'reviewed', reviewedSource))
    const reviewed = rows(await client.query(`
      SELECT amountMinor, currency, postedAt, sourceChecksum, sourceRow, transactionKind, flowDirection, status
      FROM transaction WHERE space.key = $spaceKey AND key = $transactionKey;
    `, { spaceKey: SPACE_A, transactionKey: `import-${IMPORT_KEY}-row-04` }))[0]!
    assert.equal(reviewed.amountMinor, 678)
    assert.equal(reviewed.currency, firstReviewedSource.currency)
    assert.equal(reviewed.postedAt, firstReviewedSource.postedAt)
    assert.equal(reviewed.sourceChecksum, firstReviewedSource.sourceChecksum)
    assert.deepEqual(reviewed.sourceRow, firstReviewedSource.sourceRow)
    assert.equal(reviewed.transactionKind, 'expense')
    assert.equal(reviewed.flowDirection, 'outflow')
    assert.equal(reviewed.status, 'clarified')
    const reviewedImport = rows(await client.query(
      'SELECT importedAt, sourceChecksum FROM statementImport WHERE space.key = $spaceKey AND key = $importKey;',
      { spaceKey: SPACE_A, importKey: IMPORT_KEY },
    ))[0]!
    assert.deepEqual(reviewedImport, { importedAt: firstImport.importedAt, sourceChecksum: firstImport.sourceChecksum })

    await executeImport(client, business)
    const crossSpace = rows(await client.query(`
      RETURN {
        imports: array::len(SELECT VALUE id FROM statementImport WHERE key = $importKey AND space.key IN [$spaceA, $spaceB]),
        rows: array::len(SELECT VALUE id FROM statementRow WHERE key = "row-01" AND space.key IN [$spaceA, $spaceB]),
        transactions: array::len(SELECT VALUE id FROM transaction WHERE key = $transactionKey AND space.key IN [$spaceA, $spaceB]),
        fees: array::len(SELECT VALUE id FROM category WHERE key = "fees" AND space.key IN [$spaceA, $spaceB]),
        merchants: array::len(SELECT VALUE id FROM merchant WHERE key = "fictional-shop" AND space.key IN [$spaceA, $spaceB])
      };
    `, {
      importKey: IMPORT_KEY,
      transactionKey: `import-${IMPORT_KEY}-row-01`,
      spaceA: SPACE_A,
      spaceB: SPACE_B,
    }))[0]!
    assert.deepEqual(crossSpace, { imports: 2, rows: 2, transactions: 2, fees: 2, merchants: 2 })
    const edgeCounts = rows(await client.query(`
      RETURN {
        financialSpaceAccounts: array::len(SELECT VALUE id FROM FinancialSpaceAccounts WHERE string::contains(type::string(in), $needle)),
        accountStatementImports: array::len(SELECT VALUE id FROM AccountStatementImports WHERE string::contains(type::string(in), $needle)),
        statementImportRows: array::len(SELECT VALUE id FROM StatementImportRows WHERE string::contains(type::string(in), $needle)),
        statementRowTransactions: array::len(SELECT VALUE id FROM StatementRowTransactions WHERE string::contains(type::string(in), $needle)),
        accountTransactions: array::len(SELECT VALUE id FROM AccountTransactions WHERE string::contains(type::string(in), $needle)),
        transactionMerchants: array::len(SELECT VALUE id FROM TransactionMerchant WHERE string::contains(type::string(in), $needle)),
        transactionCategories: array::len(SELECT VALUE id FROM TransactionCategory WHERE string::contains(type::string(in), $needle)),
        transactionClarificationTasks: array::len(SELECT VALUE id FROM TransactionClarificationTasks WHERE string::contains(type::string(in), $needle))
      };
    `, { needle: 'wl02-import-fictional' }))[0]!
    assert.deepEqual(edgeCounts, {
      financialSpaceAccounts: 2,
      accountStatementImports: 2,
      statementImportRows: 8,
      statementRowTransactions: 8,
      accountTransactions: 8,
      transactionMerchants: 5,
      transactionCategories: 8,
      transactionClarificationTasks: 4,
    })

    process.stdout.write('Workline 02 import identity live smoke: PASS\n')
  } finally {
    await cleanup()
    await client.close()
    await rm(directory, { recursive: true, force: true })
  }
}

main().catch((error) => {
  process.stderr.write(`${error instanceof Error ? error.stack ?? error.message : String(error)}\n`)
  process.exitCode = 1
})
