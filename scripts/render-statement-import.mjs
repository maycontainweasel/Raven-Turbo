#!/usr/bin/env node
import fs from 'node:fs/promises';
import path from 'node:path';

function parseArgs(argv) {
  const args = {
    input: null,
    output: null,
  };

  for (let i = 0; i < argv.length; i += 1) {
    const value = argv[i];
    if (value === '--input' && argv[i + 1]) {
      args.input = argv[i + 1];
      i += 1;
      continue;
    }
    if (value === '--output' && argv[i + 1]) {
      args.output = argv[i + 1];
      i += 1;
      continue;
    }
    if (!value.startsWith('--') && !args.input) {
      args.input = value;
      continue;
    }
    if (!value.startsWith('--') && !args.output) {
      args.output = value;
      continue;
    }
  }

  return args;
}

function slugify(value) {
  return String(value)
    .normalize('NFKD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

function titleize(value) {
  return String(value)
    .split(/[\s/_-]+/)
    .filter(Boolean)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1).toLowerCase())
    .join(' ');
}

function parseMarkdownTable(content) {
  const lines = content.split(/\r?\n/);
  const start = lines.findIndex((line) => line.trim() === '## Import Sheet');
  const end = lines.findIndex((line, index) => index > start && line.trim() === '## Notes');

  if (start === -1 || end === -1) {
    throw new Error('Could not find import table in markdown');
  }

  const tableLines = lines.slice(start + 2, end).filter((line) => line.trim().startsWith('|'));
  if (tableLines.length < 3) {
    throw new Error('Import table did not contain any rows');
  }

  const headers = tableLines[0]
    .split('|')
    .map((cell) => cell.trim())
    .filter(Boolean);

  const rows = [];
  for (const line of tableLines.slice(2)) {
    const normalized = line
      .split('|')
      .map((cell) => cell.trim());

    const values = normalized.slice(1, -1);
    if (values.length !== headers.length) {
      continue;
    }

    const row = {};
    headers.forEach((header, index) => {
      row[header] = values[index] ?? '';
    });
    rows.push(row);
  }

  return rows;
}

function parseMetadata(content) {
  const getMatch = (pattern) => {
    const match = content.match(pattern);
    return match ? match.slice(1) : [];
  };

  const [sourceFileName = ''] = getMatch(/Source:\s*\n-\s*`([^`]+)`/);
  const [accountLabel = ''] = getMatch(/Account:\s*\n-\s*([^\n]+)/);
  const [statementStart = '', statementEnd = ''] = getMatch(/Statement period:\s*\n-\s*`([^`]+)`\s*to\s*`([^`]+)`/);
  const [openingBalance = ''] = getMatch(/Opening balance:\s*`([^`]+)`/);
  const [closingBalance = ''] = getMatch(/Closing balance:\s*`([^`]+)`/);
  const [spaceKey = 'mpire-business'] = getMatch(/Environment key:\s*`([^`]+)`/);
  const [spaceName = 'MPIRE Business'] = getMatch(/Environment name:\s*`([^`]+)`/);
  const [spaceType = 'business'] = getMatch(/Environment type:\s*`([^`]+)`/);
  const [spaceCurrency = 'ZAR'] = getMatch(/Environment currency:\s*`([^`]+)`/);
  const [spaceDescription = 'Business environment for MPIRE'] = getMatch(/Environment description:\s*`([^`]+)`/);
  const [accountKey = 'fnb-gold-business-27821'] = getMatch(/Account key:\s*`([^`]+)`/);
  const [accountName = 'FNB Gold Business Account'] = getMatch(/Account name:\s*`([^`]+)`/);
  const [accountBank = 'FNB'] = getMatch(/Account bank:\s*`([^`]+)`/);
  const [accountType = 'current'] = getMatch(/Account type:\s*`([^`]+)`/);
  const [accountCurrency = 'ZAR'] = getMatch(/Account currency:\s*`([^`]+)`/);
  const [accountLast4 = '27821'] = getMatch(/Account last4:\s*`([^`]+)`/);
  const [importKey = ''] = getMatch(/Import key:\s*`([^`]+)`/);

  return {
    sourceFileName,
    accountLabel,
    statementStart,
    statementEnd,
    openingBalance,
    closingBalance,
    spaceKey,
    spaceName,
    spaceType,
    spaceCurrency,
    spaceDescription,
    accountKey,
    accountName,
    accountBank,
    accountType,
    accountCurrency,
    accountLast4,
    importKey,
  };
}

function parseNumber(value) {
  if (value === null || value === undefined || value === '') {
    return null;
  }
  const normalized = String(value).replace(/,/g, '').trim();
  if (!normalized) {
    return null;
  }
  const parsed = Number.parseFloat(normalized);
  return Number.isFinite(parsed) ? parsed : null;
}

function parseDateLabel(dateLabel, statementStart, statementEnd) {
  const match = String(dateLabel).trim().match(/^(\d{1,2})\s+([A-Za-z]{3})$/);
  if (!match) {
    throw new Error(`Could not parse statement date label: ${dateLabel}`);
  }

  const [, day, monthAbbrev] = match;
  const months = {
    jan: '01',
    feb: '02',
    mar: '03',
    apr: '04',
    may: '05',
    jun: '06',
    jul: '07',
    aug: '08',
    sep: '09',
    oct: '10',
    nov: '11',
    dec: '12',
  };

  const month = months[monthAbbrev.toLowerCase()];
  if (!month) {
    throw new Error(`Could not parse statement month label: ${monthAbbrev}`);
  }

  const endYear = Number.parseInt(String(statementEnd).slice(0, 4), 10) || 2026;
  const endMonth = Number.parseInt(String(statementEnd).slice(5, 7), 10) || 12;
  const startYear = Number.parseInt(String(statementStart).slice(0, 4), 10) || endYear;
  const startMonth = Number.parseInt(String(statementStart).slice(5, 7), 10) || 1;
  const monthNumber = Number.parseInt(month, 10);

  let resolvedYear = endYear;
  if (startYear !== endYear) {
    resolvedYear = monthNumber > endMonth ? startYear : endYear;
  }
  else if (monthNumber < startMonth || monthNumber > endMonth) {
    resolvedYear = endYear;
  }

  return `${resolvedYear}-${month}-${String(day).padStart(2, '0')}T00:00:00Z`;
}

function extractBalance(rawRowText) {
  const parts = rawRowText.split(';').map((part) => part.trim()).filter(Boolean);
  if (!parts.length) {
    return null;
  }

  const last = parts[parts.length - 1];
  const candidate = /^[0-9,]+\.[0-9]{2}$/.test(last) && parts.length > 1 ? parts[parts.length - 2] : last;
  const match = candidate.match(/([0-9,]+\.[0-9]{2})(?:\s*(Cr|Dr))?$/i);
  if (!match) {
    return null;
  }

  return parseNumber(match[1]);
}

function extractLeadingLabel(rawRowText) {
  return String(rawRowText).split(';')[0].trim();
}

function renderValue(value) {
  if (value && typeof value === 'object' && Object.prototype.hasOwnProperty.call(value, '__expr')) {
    return value.__expr;
  }
  if (value === null || value === undefined) {
    return 'null';
  }
  if (typeof value === 'number') {
    return Number.isFinite(value) ? String(value) : 'null';
  }
  if (typeof value === 'boolean') {
    return value ? 'true' : 'false';
  }
  return JSON.stringify(String(value));
}

function expr(value) {
  return { __expr: value };
}

function renderObject(fields, indent = 2) {
  const padding = ' '.repeat(indent);
  const inner = Object.entries(fields)
    .map(([key, value]) => `${padding}${key}: ${renderValue(value)}`)
    .join(',\n');
  return `{\n${inner}\n}`;
}

function toKeyFromLabel(label) {
  return slugify(label);
}

function variableName(prefix, key) {
  return `${prefix}_${String(key)
    .replace(/[^a-zA-Z0-9]+/g, '_')
    .replace(/^_+|_+$/g, '')
    .toLowerCase()}`;
}

function parseFeeTypeLabel(feeType) {
  return titleize(feeType);
}

function rowDirection(transactionType) {
  if (transactionType === 'transfer') {
    return 'transfer';
  }
  if (transactionType === 'income' || transactionType === 'reversal') {
    return 'credit';
  }
  return 'debit';
}

function clarificationQuestion(row) {
  const merchant = row.normalized_merchant;
  if (row.row_no === 1) {
    return 'What exactly is the Magtape Unpaid / Not Provided For reversal?';
  }
  if (merchant.includes('PayPal')) {
    return `What is the underlying purchase or service behind this ${merchant} charge?`;
  }
  if (merchant === 'Wise') {
    return 'What was the purpose of this Wise spend or transfer?';
  }
  if (merchant === 'Mpire Digital Market') {
    return 'Which internal account or transfer does this Mpire Digital Market payment belong to?';
  }
  return `What is the exact purpose of this ${merchant} transaction?`;
}

function clarificationReason(row) {
  if (row.normalized_merchant.includes('PayPal')) {
    return 'Underlying PayPal purchase still needs confirmation.';
  }
  if (row.normalized_merchant === 'Wise') {
    return 'Wise spend or transfer rail needs confirmation.';
  }
  if (row.normalized_merchant === 'Mpire Digital Market') {
    return 'Likely internal transfer, but the destination still needs confirmation.';
  }
  if (row.row_no === 1) {
    return 'Returned item / reversal needs confirmation.';
  }
  return 'Needs manual confirmation from the statement import.';
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const inputPath = path.resolve(process.cwd(), args.input || 'docs/statements/business/2026-03-18.import.md');
  const outputPath = path.resolve(process.cwd(), args.output || inputPath.replace(/\.md$/i, '.surql'));

  const content = await fs.readFile(inputPath, 'utf8');
  const meta = parseMetadata(content);
  const statementPeriodStart = meta.statementStart || '2026-02-18';
  const statementPeriodEnd = meta.statementEnd || '2026-03-18';
  const statementStamp = statementPeriodEnd.slice(0, 10);
  const rows = parseMarkdownTable(content).map((row) => {
    const amount = parseNumber(row.amount_zar);
    const bankCharge = parseNumber(row.bank_charge_zar);
    return {
      ...row,
      row_no: Number.parseInt(row.row_no, 10),
      amount_zar: amount,
      bank_charge_zar: bankCharge,
      balance_zar: row.balance_zar ? parseNumber(row.balance_zar) : extractBalance(row.raw_row_text),
      posted_at: parseDateLabel(row.date, statementPeriodStart, statementPeriodEnd),
      description_label: extractLeadingLabel(row.raw_row_text),
    };
  });

  const openingBalance = parseNumber(meta.openingBalance);
  const closingBalance = parseNumber(meta.closingBalance);

  const merchants = new Map();
  const categories = new Map();
  const feeTypes = new Map();

  for (const row of rows) {
    if (row.normalized_merchant) {
      const key = toKeyFromLabel(row.normalized_merchant);
      merchants.set(row.normalized_merchant, {
        key,
        varName: variableName('merchant', key),
      });
    }

    if (row.category) {
      const key = toKeyFromLabel(row.category);
      categories.set(row.category, {
        key,
        varName: variableName('cat', key),
      });
    }

    if (row.fee_type) {
      const key = toKeyFromLabel(row.fee_type);
      feeTypes.set(row.fee_type, {
        key: `fees-${key}`,
        varName: variableName('cat', `fees-${key}`),
      });
    }
  }

  categories.set('Fees', {
    key: 'fees',
    varName: variableName('cat', 'fees'),
  });
  categories.set('Income', {
    key: 'income',
    varName: variableName('cat', 'income'),
  });
  categories.set('Transfer', {
    key: 'transfer',
    varName: variableName('cat', 'transfer'),
  });
  categories.set('Reversal / refund', {
    key: 'reversal-refund',
    varName: variableName('cat', 'reversal-refund'),
  });

  const lines = [];
  lines.push(`-- Generated from ${path.relative(process.cwd(), inputPath)}`);
  lines.push(`-- Source: ${meta.sourceFileName}`);
  lines.push('');
  lines.push('USE NS raven DB raven1;');
  lines.push('');
  lines.push('-- Base environment and account');
  lines.push(
    `LET $space = fn::createFinancialSpace(${renderObject({
      key: meta.spaceKey,
      name: meta.spaceName,
      spaceType: meta.spaceType,
      currency: meta.spaceCurrency,
      active: true,
      description: meta.spaceDescription,
    })});`,
  );
  lines.push(
    `LET $account = fn::createAccount(${renderObject({
      space: expr('$space'),
      key: meta.accountKey,
      name: meta.accountName,
      bankName: meta.accountBank,
      accountType: meta.accountType,
      currency: meta.accountCurrency,
      accountNumberLast4: meta.accountLast4,
      openingBalance: openingBalance ?? 0,
      active: true,
      notes: `Imported from ${path.basename(meta.sourceFileName || 'statement.pdf')}`,
    })});`,
  );
  lines.push(`fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });`);
  lines.push('');
  lines.push('-- Statement import batch');
  lines.push(
    `LET $import = fn::createStatementImport(${renderObject({
      space: expr('$space'),
      account: expr('$account'),
      key: meta.importKey || `${statementStamp}-${meta.accountKey}`,
      sourceFileName: meta.sourceFileName || path.basename(inputPath).replace(/\.import\.md$/i, '.pdf'),
      sourceFormat: 'pdf',
      importedAt: expr('time::now()'),
      statementDate: `${statementPeriodEnd}T00:00:00Z`,
      status: 'matched',
      rowCount: 0,
      normalizedCount: 0,
      clarificationCount: 0,
      sourceChecksum: '',
      notes: `Imported from ${path.basename(inputPath)}`,
    })});`,
  );
  lines.push(`fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });`);
  lines.push('');

  lines.push('-- Category records');
  for (const [label, info] of categories.entries()) {
    const payload = {
      space: expr('$space'),
      key: info.key,
      name: label,
      categoryKind: label === 'Income' ? 'income' : label === 'Transfer' ? 'transfer' : label === 'Reversal / refund' ? 'other' : 'expense',
      active: true,
      notes: `Imported from ${path.basename(inputPath)}`,
    };
    lines.push(`LET $${info.varName} = fn::createCategory(${renderObject(payload)});`);
  }
  for (const [label, info] of feeTypes.entries()) {
    const payload = {
      space: expr('$space'),
      key: info.key,
      name: titleize(label),
      categoryKind: 'expense',
      parentCategory: expr(`$${categories.get('Fees').varName}`),
      active: true,
      notes: `Imported from ${path.basename(inputPath)}`,
    };
    lines.push(`LET $${info.varName} = fn::createCategory(${renderObject(payload)});`);
  }

  lines.push('');
  lines.push('-- Merchant records');
  for (const [label, info] of merchants.entries()) {
    lines.push(
      `LET $${info.varName} = fn::createMerchant(${renderObject({
        space: expr('$space'),
        key: info.key,
        name: label,
        normalizedName: label,
        active: true,
        notes: `Imported from ${path.basename(inputPath)}`,
      })});`,
    );
  }

  lines.push('');
  lines.push('-- Rows, transactions, and clarification tasks');
  let clarificationCount = 0;
  for (const row of rows) {
    const rowKey = `row-${String(row.row_no).padStart(2, '0')}`;
    const rowVar = variableName('row', rowKey);
    const txVar = variableName('tx', `stmt-${statementStamp}-${rowKey}`);
    const txKey = `stmt-${statementStamp}-${rowKey}`;
    const isClarified = row.clarification_status === 'clarified';
    const rowStatus = isClarified ? 'clarified' : 'matched';
    const txStatus = isClarified ? 'clarified' : 'matched';
    const merchantInfo = row.normalized_merchant ? merchants.get(row.normalized_merchant) : null;
    const merchantExpr = merchantInfo ? expr(`$${merchantInfo.varName}`) : null;
    const categoryInfo = row.transaction_type === 'fee' && row.fee_type ? feeTypes.get(row.fee_type) : categories.get(row.category);
    const categoryExpr = expr(`$${categoryInfo.varName}`);
    const amount = row.amount_zar ?? 0;
    const bankCharge = row.bank_charge_zar ?? null;
    const balance = row.balance_zar ?? 0;
    const description = row.description_label || row.raw_row_text;
    const normalizedDescription = row.transaction_type === 'fee' && row.fee_type ? titleize(row.fee_type) : row.normalized_merchant || row.category;
    const rawData = {
      sourceFileName: meta.sourceFileName,
      statementPeriodStart,
      statementPeriodEnd,
      rowNo: row.row_no,
      rawRowText: row.raw_row_text,
      transactionType: row.transaction_type,
      normalizedMerchant: row.normalized_merchant,
      category: row.category,
      feeType: row.fee_type,
      clarificationStatus: row.clarification_status,
      amountZar: amount,
      bankChargeZar: bankCharge,
      balanceZar: balance,
    };

    lines.push(``);
    lines.push(`-- Row ${row.row_no}`);
    lines.push(
      `LET $${rowVar} = fn::createStatementRow(${renderObject({
        space: expr('$space'),
        account: expr('$account'),
        statementImport: expr('$import'),
        rowNumber: row.row_no,
        postedAt: row.posted_at,
        description,
        normalizedDescription,
        amount,
        balance,
        currency: meta.accountCurrency || 'ZAR',
        direction: rowDirection(row.transaction_type),
        status: rowStatus,
        confidence: isClarified ? 0.95 : 0.55,
        rawData: expr(renderObject(rawData, 4)),
        notes: row.notes || '',
      })});`,
    );
    lines.push(
      `LET $${txVar} = fn::createTransaction(${renderObject({
        space: expr('$space'),
        account: expr('$account'),
        key: txKey,
        sourceRow: expr(`$${rowVar}`),
        postedAt: row.posted_at,
        description,
        normalizedDescription,
        amount,
        balance,
        currency: meta.accountCurrency || 'ZAR',
        direction: rowDirection(row.transaction_type),
        status: txStatus,
        confidence: isClarified ? 0.95 : 0.55,
        merchantName: row.normalized_merchant || '',
        merchant: merchantExpr || '',
        category: categoryExpr,
        isTransfer: row.transaction_type === 'transfer',
        manualOverride: false,
        notes: row.notes || '',
      })});`,
    );
    lines.push(`fn::updateStatementRow($${rowVar}.id, { transaction: $${txVar}.id, status: ${JSON.stringify(rowStatus)} });`);
    lines.push(`fn::createEdge($import.id, "StatementImportRows", $${rowVar}.id, { boundId: true, overwrite: false, skipExists: true });`);
    lines.push(`fn::createEdge($${rowVar}.id, "StatementRowTransactions", $${txVar}.id, { boundId: true, overwrite: false, skipExists: true });`);
    lines.push(`fn::createEdge($account.id, "AccountTransactions", $${txVar}.id, { boundId: true, overwrite: false, skipExists: true });`);
    if (merchantExpr) {
      lines.push(`fn::createEdge($${txVar}.id, "TransactionMerchant", $${merchantInfo.varName}.id, { boundId: true, overwrite: false, skipExists: true });`);
    }
    lines.push(`fn::createEdge($${txVar}.id, "TransactionCategory", ${categoryExpr.__expr}.id, { boundId: true, overwrite: false, skipExists: true });`);

    if (!isClarified) {
      clarificationCount += 1;
      const taskKey = `stmt-${statementStamp}-row-${String(row.row_no).padStart(2, '0')}`;
      const taskVar = variableName('task', `stmt-${statementStamp}-${rowKey}`);
      lines.push(
        `LET $${taskVar} = fn::createClarificationTask(${renderObject({
          space: expr('$space'),
          key: taskKey,
          transaction: expr(`$${txVar}`),
          status: 'open',
          question: clarificationQuestion(row),
          reason: clarificationReason(row),
          suggestedSpace: expr('$space'),
          suggestedMerchant: merchantExpr || '',
          suggestedCategory: categoryExpr,
          confidence: 0.25,
          notes: `Imported from ${path.basename(inputPath)}`,
        })});`,
      );
      lines.push(`fn::createEdge($${txVar}.id, "TransactionClarificationTasks", $${taskVar}.id, { boundId: true, overwrite: false, skipExists: true });`);
    }
  }

  lines.push('');
  lines.push('-- Final import snapshot');
  lines.push(
    `fn::updateStatementImport($import.id, ${renderObject({
      rowCount: rows.length,
      normalizedCount: rows.length,
      clarificationCount,
      status: 'matched',
      statementDate: `${statementPeriodEnd}T00:00:00Z`,
      notes: `Imported from ${path.basename(inputPath)}`,
    })});`,
  );
  lines.push('');
  lines.push('-- End of generated import');

  await fs.writeFile(outputPath, `${lines.join('\n')}\n`, 'utf8');
  process.stdout.write(`${outputPath}\n`);
}

main().catch((error) => {
  console.error(error instanceof Error ? error.stack || error.message : String(error));
  process.exit(1);
});
