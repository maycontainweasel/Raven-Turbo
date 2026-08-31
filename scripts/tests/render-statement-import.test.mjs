import assert from 'node:assert/strict';
import { execFile } from 'node:child_process';
import { mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';
import { promisify } from 'node:util';

const execFileAsync = promisify(execFile);
const root = path.resolve(import.meta.dirname, '../..');

function rowBlock(output, rowNumber) {
  const next = rowNumber + 1;
  const match = output.match(new RegExp(`-- Row ${rowNumber}\\n([\\s\\S]*?)(?=\\n-- Row ${next}\\n|\\n-- Final import snapshot)`));
  assert.ok(match, `Expected rendered row ${rowNumber}`);
  return match[1];
}

function checksums(output) {
  return [...new Set([...output.matchAll(/sourceChecksum: "([a-f0-9]{64})"/g)].map((match) => match[1]))];
}

async function renderFixture(temporaryDirectory, name, content) {
  const inputPath = path.join(temporaryDirectory, `${name}.md`);
  const outputPath = path.join(temporaryDirectory, `${name}.surql`);
  await writeFile(inputPath, content, 'utf8');
  await execFileAsync(process.execPath, [
    path.join(root, 'scripts/render-statement-import.mjs'),
    '--input', inputPath,
    '--output', outputPath,
  ], { cwd: root });
  return readFile(outputPath, 'utf8');
}

test('fictional statement rendering preserves exact and unresolved transaction truth', async () => {
  const temporaryDirectory = await mkdtemp(path.join(os.tmpdir(), 'raven-statement-render-'));
  const outputPath = path.join(temporaryDirectory, 'fictional.surql');
  try {
    await execFileAsync(process.execPath, [
      path.join(root, 'scripts/render-statement-import.mjs'),
      '--input', path.join(root, 'scripts/tests/fixtures/fictional-statement-import.md'),
      '--output', outputPath,
    ], { cwd: root });
    const output = await readFile(outputPath, 'utf8');

    assert.match(output, /BEGIN TRANSACTION;/);
    assert.match(output, /COMMIT TRANSACTION;/);
    assert.match(output, /fn::ensureStatementImport/);
    assert.match(output, /fn::ensureStatementRow/);
    assert.match(output, /fn::ensureImportedTransaction/);
    assert.doesNotMatch(output, /fn::createStatement(?:Import|Row)/);
    assert.doesNotMatch(output, /fn::createTransaction/);

    const credit = rowBlock(output, 1);
    assert.match(credit, /amountMinor: 12345/);
    assert.match(credit, /direction: "credit"/);
    assert.match(credit, /transactionKind: "income"/);
    assert.match(credit, /flowDirection: "inflow"/);

    const debit = rowBlock(output, 2);
    assert.match(debit, /amountMinor: 2005/);
    assert.match(debit, /direction: "debit"/);
    assert.match(debit, /transactionKind: "expense"/);
    assert.match(debit, /flowDirection: "outflow"/);

    const transfer = rowBlock(output, 3);
    assert.match(transfer, /direction: "transfer"/);
    assert.match(transfer, /transactionKind: "transfer"/);
    assert.doesNotMatch(transfer, /flowDirection:/);

    const unresolved = rowBlock(output, 4);
    assert.match(unresolved, /direction: "unknown"/);
    assert.match(unresolved, /transactionKind: "unresolved"/);
    assert.doesNotMatch(unresolved, /flowDirection:/);

    for (const block of [credit, debit, transfer, unresolved]) {
      assert.match(block, /entrySource: "imported"/);
      assert.match(block, /recordedAt: type::string\(\$import\.importedAt\)/);
    }
  } finally {
    await rm(temporaryDirectory, { recursive: true, force: true });
  }
});

test('fictional imports use scoped identities and immutable checksums without coupling reviewed meaning', async () => {
  const temporaryDirectory = await mkdtemp(path.join(os.tmpdir(), 'raven-statement-identity-'));
  try {
    const source = await readFile(path.join(root, 'scripts/tests/fixtures/fictional-statement-import.md'), 'utf8');
    const personal = await renderFixture(temporaryDirectory, 'personal', source);
    const businessSource = source
      .replace('Environment key: `fictional-space`', 'Environment key: `fictional-business`')
      .replace('Environment name: `Fictional Space`', 'Environment name: `Fictional Business`')
      .replace('Environment type: `personal`', 'Environment type: `business`')
      .replace('Account key: `fictional-daily`', 'Account key: `fictional-business-daily`')
      .replace('Account name: `Fictional Daily Account`', 'Account name: `Fictional Business Daily`');
    const business = await renderFixture(temporaryDirectory, 'business', businessSource);

    assert.match(personal, /key: "fictional-2026-07"/);
    assert.match(business, /key: "fictional-2026-07"/);
    assert.match(personal, /key: "import-fictional-2026-07-row-01"/);
    assert.match(business, /key: "import-fictional-2026-07-row-01"/);
    assert.notEqual(checksums(personal)[0], checksums(business)[0]);

    const classificationOnly = source.replace(
      '| 4 | 05 Jul | Fictional malformed movement | mystery |  | Review |  | 6.78 |  | 1086.62 | matched | Direction is deliberately unknown |',
      '| 4 | 05 Jul | Fictional malformed movement | expense | Fictional Shop | General |  | 6.78 |  | 1086.62 | clarified | Reviewed classification |',
    );
    const reviewed = await renderFixture(temporaryDirectory, 'reviewed', classificationOnly);
    assert.deepEqual(checksums(reviewed), checksums(personal));
    assert.match(reviewed, /fn::reviewImportedTransaction/);

    const changedAmount = source.replace('| 6.78 |  | 1086.62 |', '| 6.79 |  | 1086.62 |');
    const changed = await renderFixture(temporaryDirectory, 'changed', changedAmount);
    assert.notDeepEqual(checksums(changed), checksums(personal));

    const generatedIdentityFiles = await Promise.all([
      readFile(path.join(root, 'apps/schema/config/migrations/category/F_createCategory.surql'), 'utf8'),
      readFile(path.join(root, 'apps/schema/config/migrations/merchant/F_createMerchant.surql'), 'utf8'),
      readFile(path.join(root, 'apps/schema/config/migrations/classificationrule/F_createClassificationRule.surql'), 'utf8'),
      readFile(path.join(root, 'apps/schema/config/migrations/clarificationtask/F_createClarificationTask.surql'), 'utf8'),
    ]);
    assert.match(generatedIdentityFiles[0], /fn::stringID\(\[\$payload\.space, \$payload\.key\]\)/);
    assert.match(generatedIdentityFiles[1], /fn::stringID\(\[\$payload\.space, \$payload\.key\]\)/);
    assert.match(generatedIdentityFiles[2], /fn::stringID\(\[\$payload\.space, \$payload\.key\]\)/);
    assert.match(generatedIdentityFiles[3], /fn::stringID\(\[\$payload\.transaction, \$payload\.key\]\)/);

    const [statementImportEnsure, statementRowEnsure, transactionEnsure] = await Promise.all([
      readFile(path.join(root, 'apps/schema/config/overrides/functions/statementimport/F_ensureStatementImport.surql'), 'utf8'),
      readFile(path.join(root, 'apps/schema/config/overrides/functions/statementrow/F_ensureStatementRow.surql'), 'utf8'),
      readFile(path.join(root, 'apps/schema/config/overrides/functions/transaction/F_ensureImportedTransaction.surql'), 'utf8'),
    ]);
    assert.match(statementImportEnsure, /\$existing\.account != \$payload\.account/);
    assert.match(statementRowEnsure, /\$existing\.currency != \$payload\.currency/);
    assert.match(transactionEnsure, /\$existing\.currency != \$payload\.currency/);
    assert.match(transactionEnsure, /\$existing\.sourceRow != \$payload\.sourceRow/);
  } finally {
    await rm(temporaryDirectory, { recursive: true, force: true });
  }
});
