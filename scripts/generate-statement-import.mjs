#!/usr/bin/env node
import fs from 'node:fs/promises';
import path from 'node:path';
import { execFileSync } from 'node:child_process';

function parseArgs(argv) {
  const args = {
    profile: '',
    input: '',
    output: '',
  };

  for (let i = 0; i < argv.length; i += 1) {
    const value = argv[i];
    if (value === '--profile' && argv[i + 1]) {
      args.profile = argv[i + 1];
      i += 1;
      continue;
    }
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
  }

  if (!args.profile || !args.input || !args.output) {
    throw new Error('Usage: generate-statement-import.mjs --profile <profile> --input <pdf> --output <md>');
  }

  return args;
}

function readPdfText(pdfPath) {
  return execFileSync('pdftotext', ['-layout', pdfPath, '-'], {
    encoding: 'utf8',
    maxBuffer: 20 * 1024 * 1024,
  });
}

function readPlainPdfText(pdfPath) {
  return execFileSync('pdftotext', [pdfPath, '-'], {
    encoding: 'utf8',
    maxBuffer: 20 * 1024 * 1024,
  });
}

function parseMoney(value) {
  if (!value) return null;
  return Number.parseFloat(String(value).replace(/R/g, '').replace(/,/g, '').replace(/\s+/g, '').replace(/Cr|Dr/gi, ''));
}

function formatMoney(value) {
  if (value === null || value === undefined || Number.isNaN(value)) return '';
  return String(Number(value.toFixed(2)));
}

function isoDateFromDmy(value) {
  const [day, month, year] = value.split('/');
  return `${year}-${month}-${day}`;
}

function shortDateFromDmy(value) {
  const [day, month] = value.split('/');
  const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return `${Number.parseInt(day, 10)} ${labels[Number.parseInt(month, 10) - 1]}`;
}

function parseDmyRangeFromFilename(filePath) {
  const base = path.basename(filePath);
  const match = base.match(/(\d{2} \w{3} \d{4}) - (\d{2} \w{3} \d{4})/i);
  if (!match) {
    return null;
  }

  const parseHuman = (value) => {
    const [day, monthName, year] = value.split(' ');
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
    const month = months[monthName.toLowerCase()];
    return month ? `${year}-${month}-${day}` : null;
  };

  const start = parseHuman(match[1]);
  const end = parseHuman(match[2]);
  if (!start || !end) {
    return null;
  }

  return { start, end };
}

function shortDateFromBusiness(value) {
  return value;
}

function quoteCell(value) {
  return String(value ?? '').replace(/\|/g, '\\|');
}

function renderMarkdown(meta, rows, notes) {
  const lines = [];
  lines.push(`# ${meta.statementEnd} ${meta.title} Import Sheet`);
  lines.push('');
  lines.push('Source:');
  lines.push(`- \`${meta.sourceFile}\``);
  lines.push('');
  lines.push(`Environment key: \`${meta.environment.key}\``);
  lines.push(`Environment name: \`${meta.environment.name}\``);
  lines.push(`Environment type: \`${meta.environment.type}\``);
  lines.push(`Environment currency: \`${meta.environment.currency}\``);
  lines.push(`Environment description: \`${meta.environment.description}\``);
  lines.push('');
  lines.push('Account:');
  lines.push(`- ${meta.account.label}`);
  lines.push('');
  lines.push(`Account key: \`${meta.account.key}\``);
  lines.push(`Account name: \`${meta.account.name}\``);
  lines.push(`Account bank: \`${meta.account.bank}\``);
  lines.push(`Account type: \`${meta.account.type}\``);
  lines.push(`Account currency: \`${meta.account.currency}\``);
  lines.push(`Account last4: \`${meta.account.last4}\``);
  lines.push(`Import key: \`${meta.importKey}\``);
  lines.push('');
  lines.push('Statement period:');
  lines.push(`- \`${meta.statementStart}\` to \`${meta.statementEnd}\``);
  lines.push('');
  lines.push('Balances:');
  lines.push(`- Opening balance: \`${meta.openingBalance}\``);
  lines.push(`- Closing balance: \`${meta.closingBalance}\``);
  lines.push('');
  lines.push('## Import Sheet');
  lines.push('');
  lines.push('| row_no | date | raw_row_text | transaction_type | normalized_merchant | category | fee_type | amount_zar | bank_charge_zar | balance_zar | clarification_status | notes |');
  lines.push('| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |');
  for (const row of rows) {
    lines.push(`| ${row.row_no} | ${quoteCell(row.date)} | ${quoteCell(row.raw_row_text)} | ${quoteCell(row.transaction_type)} | ${quoteCell(row.normalized_merchant)} | ${quoteCell(row.category)} | ${quoteCell(row.fee_type)} | ${quoteCell(row.amount_zar)} | ${quoteCell(row.bank_charge_zar)} | ${quoteCell(row.balance_zar)} | ${quoteCell(row.clarification_status)} | ${quoteCell(row.notes)} |`);
  }
  lines.push('');
  lines.push('## Notes');
  lines.push('');
  for (const note of notes) {
    lines.push(`- ${note}`);
  }
  lines.push('');
  return `${lines.join('\n')}\n`;
}

function classifyCurrent(description, debit, credit, fee) {
  const upper = description.toUpperCase();
  if (upper.startsWith('VAT ')) {
    return {
      transaction_type: 'fee',
      normalized_merchant: 'Nedbank',
      category: 'Fees',
      fee_type: 'vat on fees',
      clarification_status: 'clarified',
      notes: 'VAT summary row for bank charges period.',
    };
  }
  if (upper.startsWith('INTEREST ')) {
    return {
      transaction_type: 'fee',
      normalized_merchant: 'Nedbank',
      category: 'Fees',
      fee_type: 'overdraft interest',
      clarification_status: 'clarified',
      notes: 'Overdraft interest charge.',
    };
  }
  if (upper === 'FACILITY FEE') {
    return {
      transaction_type: 'fee',
      normalized_merchant: 'Nedbank',
      category: 'Fees',
      fee_type: 'overdraft facility fee',
      clarification_status: 'clarified',
      notes: 'Overdraft facility fee.',
    };
  }
  if (upper === 'MAINTENANCE FEE') {
    return {
      transaction_type: 'fee',
      normalized_merchant: 'Nedbank',
      category: 'Fees',
      fee_type: 'maintenance fee',
      clarification_status: 'clarified',
      notes: 'Maintenance fee.',
    };
  }
  if (upper === 'DIGITAL STATEMENT FEE') {
    return {
      transaction_type: 'fee',
      normalized_merchant: 'Nedbank',
      category: 'Fees',
      fee_type: 'digital statement fee',
      clarification_status: 'clarified',
      notes: 'Digital statement fee.',
    };
  }
  if (upper.startsWith('CREDIT CRD - ')) {
    return {
      transaction_type: 'transfer',
      normalized_merchant: 'Nedbank Credit Card',
      category: 'Debt payment',
      fee_type: '',
      clarification_status: 'clarified',
      notes: 'Transfer out to settle the credit card.',
    };
  }
  if (upper.startsWith('SAVINGS AC - ')) {
    return {
      transaction_type: 'transfer',
      normalized_merchant: 'Nedbank Savings Account',
      category: 'Transfer',
      fee_type: '',
      clarification_status: 'clarified',
      notes: 'Transfer out from current to savings.',
    };
  }
  if (upper === 'MPIRE DIGITAL MARKET') {
    return {
      transaction_type: 'income',
      normalized_merchant: 'MPIRE Digital Market',
      category: 'Income',
      fee_type: '',
      clarification_status: 'clarified',
      notes: 'Owner draw or business-to-personal payment from MPIRE.',
    };
  }
  if (upper === 'BASIL PETERS') {
    return {
      transaction_type: 'income',
      normalized_merchant: 'Basil Peters',
      category: 'Income',
      fee_type: '',
      clarification_status: 'clarified',
      notes: 'Family or owner-support transfer into the current account.',
    };
  }
  if (upper.includes('WISE PAYMENTS LIMITED')) {
    return {
      transaction_type: 'income',
      normalized_merchant: 'Wise / Family Support',
      category: 'Family support',
      fee_type: '',
      clarification_status: 'clarified',
      notes: 'Incoming support payment from overseas via Wise.',
    };
  }
  if (upper === 'OZ-LUCKY ISIBAYA') {
    return {
      transaction_type: 'expense',
      normalized_merchant: 'Oz-Lucky Isibaya',
      category: 'Business expenses paid personally / voucher testing',
      fee_type: fee ? 'payment rail fee' : '',
      clarification_status: 'unclarified',
      notes: 'Likely business voucher testing paid from the personal account; keep visible for review.',
    };
  }

  return {
    transaction_type: credit ? 'income' : 'expense',
    normalized_merchant: description,
    category: credit ? 'Income' : 'Unclassified',
    fee_type: '',
    clarification_status: 'unclarified',
    notes: 'Needs manual confirmation from the statement import.',
  };
}

function creditExpenseClassification(description) {
  const upper = description.toUpperCase();
  if (upper.includes('I VALR PTY LTD')) return ['expense', 'VALR', 'Crypto / trading', '', 'clarified', 'Crypto / trading spend.'];
  if (upper.includes('TRADE TRAVEL CHILL')) return ['expense', 'Trade Travel Chill', 'Business expenses paid personally / trading tools', '', 'clarified', 'Recurring trading-indicator or trading-service spend.'];
  if (upper.includes('TRADINGVIEWV*PRODUCT')) return ['expense', 'TradingView', 'Business expenses paid personally / trading tools', '', 'clarified', 'TradingView subscription or tooling spend.'];
  if (upper.includes('OPENAI *CHATGPT')) return ['expense', 'OpenAI', 'Business expenses paid personally / AI tools', '', 'clarified', 'AI tooling paid from the personal credit card.'];
  if (upper.includes('I AFRIHOST.COM 2')) return ['expense', 'Afrihost', 'Business expenses paid personally / hosting / software', '', 'clarified', 'Hosting or internet spend.'];
  if (upper.includes('WISE') && upper.includes('LONDON')) return ['transfer', 'Wise', 'Foreign account funding', '', 'clarified', 'Transfer via Wise to fund the UK account.'];
  if (upper.includes('SPOTIFYZA')) return ['expense', 'Spotify', 'Subscription / media', '', 'clarified', 'Media subscription.'];
  if (upper.includes('AUDIBLE*')) return ['expense', 'Audible', 'Subscription / media', '', 'clarified', 'Audible subscription or media spend.'];
  if (upper.includes('SHOWMAX')) return ['expense', 'Showmax', 'Subscription / media', '', 'clarified', 'Media subscription.'];
  if (upper.includes('GOOGLE ONE')) return ['expense', 'Google One', 'Subscription / storage', '', 'clarified', 'Storage subscription.'];
  if (upper.includes('HYROTRADER')) return ['expense', 'HyroTrader', 'Business expenses paid personally / trading tools', '', 'unclarified', 'Likely prop-firm or trading-service spend; confirm exact product later.'];
  if (upper.includes('PICK N PAY') || upper.includes('WWH ') || upper.includes('WOOLWORTHS') || upper.includes('KWIKSPAR') || upper.includes('THE LOCAL CHOIC') || upper.includes('DE WARENMARKT')) {
    return ['expense', description.replace(/\s+0000000000000ZA/i, '').trim(), 'Groceries / household', '', 'clarified', 'Grocery or household spend.'];
  }
  if (upper.includes('ENGEN') || upper.includes('SHELL ') || upper.includes('BP ') ) {
    return ['expense', description.replace(/\s+0000000000000ZA/i, '').trim(), 'Fuel / transport', '', 'clarified', 'Fuel or transport spend.'];
  }
  if (upper.includes('YOCO *FEEDEM') || upper.includes('YOCO *BCO TASTE') || upper.includes('GIOVANNIS') || upper.includes('BLAAUWKLIPPEN') || upper.includes('BK SANCTUARY') || upper.includes('MCD ') || upper.includes('YOCO *HELLO INDIGO') || upper.includes('DE BLAAUW KITCHEN')) {
    return ['expense', description.replace(/\s+0000000000000ZA/i, '').trim(), 'Dining / lifestyle', '', 'clarified', 'Dining or lifestyle spend.'];
  }
  if (upper.includes('CLICKS')) return ['expense', 'Clicks Stellenbosch Square', 'Personal care / pharmacy', '', 'clarified', 'Pharmacy or personal-care spend.'];
  if (upper.includes('PNA ') || upper.includes('TOY PLANET') || upper.includes('C*WORDSWORTH')) return ['expense', description.trim(), 'Retail / books', '', 'clarified', 'Retail, stationery, or book spend.'];
  if (upper.includes('WONDERDAL') || upper.includes('HAZENDAL PUTT PUTT')) return ['expense', description.trim(), 'Entertainment / family', '', 'clarified', 'Family entertainment spend.'];
  if (upper.includes('PAYFAST*IVECLOUD')) return ['expense', 'Ivecloud', 'Business expenses paid personally / hosting / software', '', 'unclarified', 'Likely software or hosting-related spend; keep open for confirmation.'];
  if (upper.includes('YOCO *BACKS VAL DE V')) return ['expense', 'Backs Val De Vie', 'Dining / lifestyle', '', 'clarified', 'Dining spend.'];

  return ['expense', description.trim(), 'Unclassified', '', 'unclarified', 'Needs manual confirmation from the statement import.'];
}

function parseNedbankCurrent(pdfPath, outputPath) {
  const text = readPdfText(pdfPath);
  const plainText = readPlainPdfText(pdfPath);
  const lines = text.split(/\r?\n/);

  const statementPeriodMatch = plainText.match(/Statement period:\s*([0-9/]+)\s+[–-]\s+([0-9/]+)/);
  const filenamePeriod = parseDmyRangeFromFilename(pdfPath);
  const openingBalanceMatch = plainText.match(/Opening balance\s*([-\w\s]*)\s*(-?R[0-9,]+\.[0-9]{2})/);
  const closingBalanceMatch = plainText.match(/Closing balance\s*([-\w\s]*)\s*(-?R[0-9,]+\.[0-9]{2})/);

  let inTable = false;
  const rawRows = [];
  let openingBalanceFromTable = null;
  for (const line of lines) {
    if (line.includes('Tran list no') && line.includes('Balance (R)')) {
      inTable = true;
      continue;
    }
    if (!inTable) continue;
    if (line.includes('Closing balance')) break;
    if (!line.trim()) continue;
    const match = line.match(/^\s*(\d{6})?\s*(\d{2}\/\d{2}\/\d{4})\s+(.+?)\s{2,}([\d,]+\.\d{2})?\s*\*?\s*([\d,]+\.\d{2})?\s*([\d,]+\.\d{2})?\s*(-?[\d,]+\.\d{2})\s*$/);
    if (!match) continue;
    const [, , date, description, feeValue, debitValue, creditValue, balanceValue] = match;
    if (description === 'Opening balance') {
      openingBalanceFromTable = parseMoney(balanceValue);
      continue;
    }
    rawRows.push({
      date,
      description: description.trim(),
      feeValue: parseMoney(feeValue),
      debitValue: parseMoney(debitValue),
      creditValue: parseMoney(creditValue),
      balanceValue: parseMoney(balanceValue),
    });
  }

  const rows = rawRows.map((row, index) => {
    const classification = classifyCurrent(row.description, row.debitValue, row.creditValue, row.feeValue);
    const amount = row.creditValue ?? row.debitValue ?? row.feeValue ?? 0;
    const bankCharge = row.debitValue !== null || row.creditValue !== null ? row.feeValue : null;
    const rawParts = [row.description, amount?.toFixed?.(2) ?? amount, row.balanceValue?.toFixed?.(2) ?? row.balanceValue]
      .filter((value) => value !== null && value !== undefined && value !== '')
      .join('; ');

    return {
      row_no: index + 1,
      date: shortDateFromDmy(row.date),
      raw_row_text: rawParts,
      transaction_type: classification.transaction_type,
      normalized_merchant: classification.normalized_merchant,
      category: classification.category,
      fee_type: classification.fee_type,
      amount_zar: formatMoney(amount),
      bank_charge_zar: formatMoney(bankCharge),
      balance_zar: formatMoney(row.balanceValue),
      clarification_status: classification.clarification_status,
      notes: classification.notes,
    };
  });

  const meta = {
    title: 'Personal Current',
    sourceFile: path.relative(process.cwd(), pdfPath),
    environment: {
      key: 'personal',
      name: 'Personal',
      type: 'personal',
      currency: 'ZAR',
      description: 'Personal banking, debt, savings, and transfer flows',
    },
    account: {
      label: 'Nedbank Current Account `1092107185`',
      key: 'nedbank-current-07185',
      name: 'Nedbank Current Account',
      bank: 'Nedbank',
      type: 'current',
      currency: 'ZAR',
      last4: '7185',
    },
    statementStart: statementPeriodMatch?.[1] ? isoDateFromDmy(statementPeriodMatch[1]) : (filenamePeriod?.start || '2025-11-21'),
    statementEnd: statementPeriodMatch?.[2] ? isoDateFromDmy(statementPeriodMatch[2]) : (filenamePeriod?.end || '2025-12-20'),
    openingBalance: parseMoney(openingBalanceMatch?.[2]) ?? openingBalanceFromTable ?? 0,
    closingBalance: parseMoney(closingBalanceMatch?.[2]) ?? rawRows.at(-1)?.balanceValue ?? 0,
    importKey: `${statementPeriodMatch?.[2] ? isoDateFromDmy(statementPeriodMatch[2]) : (filenamePeriod?.end || '2025-12-20')}-nedbank-current`,
  };

  return renderMarkdown(meta, rows, [
    'Keep overdraft, facility, interest, and statement-charge rows explicit.',
    'Model credit-card repayments and savings transfers as transfers, not day-to-day spending.',
    'Keep business-origin inflows visible while preserving the possibility of later cross-environment linking.',
  ]);
}

function parseNedbankCredit(pdfPath, outputPath) {
  const text = readPdfText(pdfPath);
  const plainText = readPlainPdfText(pdfPath);
  const lines = text.split(/\r?\n/);

  const statementPeriodMatch = plainText.match(/Statement period:\s*([0-9]{2} [A-Za-z]+ [0-9]{4}|[0-9/]+)\s*-\s*([0-9]{2} [A-Za-z]+ [0-9]{4}|[0-9/]+)/);
  const statementBalanceMatch = plainText.match(/Statement balance\s*R([0-9,]+\.[0-9]{2})/);
  const previousBalanceMatch = plainText.match(/Previous balance\s*R([0-9,]+\.[0-9]{2})/);

  const rows = [];
  let section = '';
  for (const line of lines) {
    if (line.includes('•     Account transaction details')) {
      section = 'account';
      continue;
    }
    if (line.includes('•     Card transaction details')) {
      section = 'card';
      continue;
    }
    if (line.includes('Interest rates and facility details')) {
      section = '';
      break;
    }
    if (!section) continue;

    if (section === 'account') {
      const withRef = line.match(/^\s*(\d{2}\/\d{2}\/\d{4})\s+(\d{20,})\s+(.+?)\s+(R[\d,]+\.\d{2})\s*(R[\d,]+\.\d{2})?\s*$/);
      if (withRef) {
        const [, date, , description, first, second] = withRef;
        const debit = description.includes('Internet Banking Transferselby') ? null : parseMoney(first);
        const credit = description.includes('Internet Banking Transferselby') ? parseMoney(first) : parseMoney(second);
        rows.push({ source: 'account', date, description: description.trim(), debit, credit });
        continue;
      }
      const feeOnly = line.match(/^\s*(\d{2}\/\d{2}\/\d{4})\s+(.+?)\s+(R[\d,]+\.\d{2})\s*$/);
      if (feeOnly && !line.includes('Description')) {
        const [, date, description, debit] = feeOnly;
        rows.push({ source: 'account', date, description: description.trim(), debit: parseMoney(debit), credit: null });
      }
      continue;
    }

    const match = line.match(/^\s*(\d{2}\/\d{2}\/\d{4})\s+(\d{20,})\s+(.+?)\s+(R[\d,]+\.\d{2})\s*(R[\d,]+\.\d{2})?\s*$/);
    if (!match) continue;
    const [, date, , description, debit, credit] = match;
    rows.push({
      source: 'card',
      date,
      description: description.trim(),
      debit: parseMoney(debit),
      credit: parseMoney(credit),
    });
  }

  const mapped = rows.map((row, index) => {
    let transaction_type = 'expense';
    let normalized_merchant = row.description;
    let category = 'Unclassified';
    let fee_type = '';
    let clarification_status = 'unclarified';
    let notes = 'Needs manual confirmation from the statement import.';

    if (row.source === 'account') {
      const upper = row.description.toUpperCase();
      if (upper.includes('INTERNET BANKING TRANSFERSELBY')) {
        transaction_type = 'transfer';
        normalized_merchant = 'Nedbank Current Account';
        category = 'Debt payment';
        clarification_status = 'clarified';
        notes = 'Payment received from personal current account.';
      }
      else if (upper.includes('DECLINED-INSUFFICIENT FUNDS-POS')) {
        transaction_type = 'fee';
        normalized_merchant = 'Nedbank';
        category = 'Fees';
        fee_type = 'declined payment fee';
        clarification_status = 'clarified';
        notes = 'Declined transaction fee.';
      }
      else if (upper.includes('ELECTRONIC PAYMENT FEE')) {
        transaction_type = 'fee';
        normalized_merchant = 'Nedbank';
        category = 'Fees';
        fee_type = 'electronic payment fee';
        clarification_status = 'clarified';
        notes = 'Electronic payment fee.';
      }
      else if (upper === 'MAINTENANCE FEE') {
        transaction_type = 'fee';
        normalized_merchant = 'Nedbank';
        category = 'Fees';
        fee_type = 'maintenance fee';
        clarification_status = 'clarified';
        notes = 'Card maintenance fee.';
      }
      else if (upper === 'CREDIT FACILITY SERVICE FEE') {
        transaction_type = 'fee';
        normalized_merchant = 'Nedbank';
        category = 'Fees';
        fee_type = 'credit facility service fee';
        clarification_status = 'clarified';
        notes = 'Credit facility service fee.';
      }
      else if (upper === 'FINANCE CHARGE') {
        transaction_type = 'fee';
        normalized_merchant = 'Nedbank';
        category = 'Fees';
        fee_type = 'finance charge';
        clarification_status = 'clarified';
        notes = 'Finance charge on the outstanding balance.';
      }
      else if (upper === 'TOTAL V A T') {
        transaction_type = 'fee';
        normalized_merchant = 'Nedbank';
        category = 'Fees';
        fee_type = 'vat on fees';
        clarification_status = 'clarified';
        notes = 'VAT on fees.';
      }
    }
    else {
      [transaction_type, normalized_merchant, category, fee_type, clarification_status, notes] = creditExpenseClassification(row.description);
      if (row.description.toUpperCase().includes('ELECTRONIC PAYMENT FROM:INTERNET BANKING')) {
        transaction_type = 'transfer';
        normalized_merchant = 'Nedbank Internet Banking';
        category = 'Cash advance';
        fee_type = '';
        clarification_status = 'clarified';
        notes = 'Cash advance or cash transfer from the credit card.';
      }
    }

    const amount = row.credit ?? row.debit ?? 0;
    const rawRowText = row.credit
      ? `${row.description}; ${amount.toFixed(2)} Cr`
      : `${row.description}; ${amount.toFixed(2)}`;

    return {
      row_no: index + 1,
      date: shortDateFromDmy(row.date),
      raw_row_text: rawRowText,
      transaction_type,
      normalized_merchant,
      category,
      fee_type,
      amount_zar: formatMoney(amount),
      bank_charge_zar: '',
      balance_zar: '',
      clarification_status,
      notes,
    };
  });

  const start = statementPeriodMatch?.[1] || '20 November 2025';
  const end = statementPeriodMatch?.[2] || '19 December 2025';
  const monthName = {
    January: '01',
    February: '02',
    March: '03',
    April: '04',
    May: '05',
    June: '06',
    July: '07',
    August: '08',
    September: '09',
    October: '10',
    November: '11',
    December: '12',
  };
  const toIsoLong = (value) => {
    if (value.includes('/')) return isoDateFromDmy(value);
    const [day, month, year] = value.split(/\s+/);
    return `${year}-${monthName[month]}-${String(day).padStart(2, '0')}`;
  };

  const meta = {
    title: 'Personal Credit',
    sourceFile: path.relative(process.cwd(), pdfPath),
    environment: {
      key: 'personal',
      name: 'Personal',
      type: 'personal',
      currency: 'ZAR',
      description: 'Personal banking, debt, savings, and transfer flows',
    },
    account: {
      label: 'Nedbank Credit Card `492213XXXXXX8996`',
      key: 'nedbank-credit-08996',
      name: 'Nedbank Credit Card',
      bank: 'Nedbank',
      type: 'credit_card',
      currency: 'ZAR',
      last4: '8996',
    },
    statementStart: toIsoLong(start),
    statementEnd: toIsoLong(end),
    openingBalance: parseMoney(previousBalanceMatch?.[1]) ?? 0,
    closingBalance: parseMoney(statementBalanceMatch?.[1]) ?? 0,
    importKey: `${toIsoLong(end)}-nedbank-credit`,
  };

  return renderMarkdown(meta, mapped, [
    'Keep card repayments explicit as transfers into the credit account.',
    'Keep finance charges, payment fees, and other service rows explicit.',
    'Treat internet-banking transfer-outs from the card as cash advances rather than ordinary spending.',
  ]);
}

function classifyBusinessDescription(description) {
  const compact = description.replace(/\s+/g, ' ').trim();
  const upper = compact.toUpperCase();
  if (!description) return ['fee', 'FNB', 'Fees', 'bank fee', 'unclarified', 'FNB fee line without an explicit label on the statement.'];
  if (upper.startsWith('INT ON DEBIT BALANCE')) return ['fee', 'FNB', 'Fees', 'debit interest', 'clarified', 'Interest on debit balance.'];
  if (upper.includes('POS PURCHASE') && upper.includes('VALR PTY LTD')) return ['expense', 'VALR', 'Crypto / trading', 'card charge', 'clarified', 'Crypto / trading spend.'];
  if (upper.includes('POS PURCHASE') && upper.includes('GOOGLE WORKSPA')) return ['expense', 'Google Workspace', 'Software / SaaS', 'card charge', 'clarified', 'Google Workspace subscription spend.'];
  if (upper.includes('POS PURCHASE') && upper.includes('ATLASSIAN')) return ['expense', 'Atlassian', 'Software / SaaS', 'card charge', 'clarified', 'Atlassian subscription spend.'];
  if (upper.includes('POS PURCHASE') && upper.includes('NOTION LABS')) return ['expense', 'Notion', 'Software / SaaS', 'card charge', 'clarified', 'Notion subscription spend.'];
  if (upper.includes('POS PURCHASE') && upper.includes('CURSOR')) return ['expense', 'Cursor', 'Software / SaaS', 'card charge', 'clarified', 'Cursor AI tooling spend.'];
  if (upper.includes('POS PURCHASE') && upper.includes('DIAMATRIX')) return ['expense', 'Diamatrix', 'Hosting / internet', 'card charge', 'clarified', 'Hosting or software-service spend.'];
  if (upper.includes('POS PURCHASE') && upper.includes('PAYPAL')) return ['expense', 'PayPal', 'Software / SaaS', 'card charge', 'unclarified', 'Underlying PayPal purchase still needs confirmation.'];
  if (upper.startsWith('RTC EXPRESS PMT TO SUPPLIER')) return ['transfer', 'Mpire Digital Market', 'Internal transfer', '', 'unclarified', 'Likely internal transfer, but the destination still needs confirmation.'];
  if (upper.startsWith('FNB OB PMT SANSOR')) return ['income', 'Sansor', 'Client income', '', 'clarified', 'Recurring client payment from Sansor.'];
  if (upper.startsWith('FNB APP PAYMENT FROM LUCKY ISIBAYA')) return ['income', 'Lucky Isibaya', 'Client income', '', 'unclarified', 'Likely client income; keep open until the exact project allocation is confirmed.'];
  if (upper.startsWith('FNB APP PAYMENT FROM HALF STAGE')) return ['income', 'Half Stage', 'Client income', '', 'unclarified', 'Likely client income; confirm exact source or invoice later.'];
  if (upper.startsWith('INTERNET PMT TO TAX MANAGEMENT')) return ['expense', 'Tax Management', 'Accounting / compliance', '', 'clarified', 'Accounting or compliance payment.'];
  if (upper.startsWith('MAGTAPE DEBIT OUTSURANCE')) return ['expense', 'Outsurance', 'Insurance', '', 'clarified', 'Insurance debit.'];
  if (upper.startsWith('MAGTAPE CREDIT')) return ['income', 'Magtape Credit', 'Transfer', '', 'unclarified', 'Magtape credit or reversal still needs exact source confirmation.'];

  return ['expense', compact, 'Unclassified', '', 'unclarified', 'Needs manual confirmation from the statement import.'];
}

function parseFnbBusiness(pdfPath) {
  const text = readPdfText(pdfPath);
  const lines = text.split(/\r?\n/);

  const periodMatch = text.match(/Statement Period : ([0-9]{1,2} [A-Za-z]+ [0-9]{4}) to ([0-9]{1,2} [A-Za-z]+ [0-9]{4})/);
  const openingMatch = text.match(/Opening Balance\s+([0-9,]+\.[0-9]{2}) Cr/);
  const closingMatch = text.match(/Closing Balance\s+([0-9,]+\.[0-9]{2}) Cr/);

  const txLines = [];
  for (const line of lines) {
    if (/^\d{2} [A-Z][a-z]{2}\s/.test(line.trim())) {
      txLines.push(line.trim());
    }
  }

  const rows = [];
  for (const line of txLines) {
    const match = line.match(/^(\d{2} [A-Z][a-z]{2})\s+(.*?)\s{2,}([0-9,]+\.[0-9]{2}(?: Cr)?)\s+([0-9,]+\.[0-9]{2} Cr|[0-9,]+\.[0-9]{2})\s*([0-9,]+\.[0-9]{2})?$/);
    if (!match) continue;
    const [, date, description, amountCell, balanceCell, chargeCell] = match;
    const amount = parseMoney(amountCell);
    const balance = parseMoney(balanceCell);
    const bankCharge = parseMoney(chargeCell);
    const cleanDescription = description.trim();
    const [transaction_type, normalized_merchant, category, fee_type, clarification_status, notes] = classifyBusinessDescription(cleanDescription);
    rows.push({
      row_no: rows.length + 1,
      date: shortDateFromBusiness(date),
      raw_row_text: [cleanDescription, amountCell, balanceCell, chargeCell].filter(Boolean).join('; '),
      transaction_type,
      normalized_merchant,
      category,
      fee_type,
      amount_zar: formatMoney(amount),
      bank_charge_zar: formatMoney(bankCharge),
      balance_zar: formatMoney(balance),
      clarification_status,
      notes,
    });
  }

  const monthName = {
    January: '01',
    February: '02',
    March: '03',
    April: '04',
    May: '05',
    June: '06',
    July: '07',
    August: '08',
    September: '09',
    October: '10',
    November: '11',
    December: '12',
  };
  const toIsoLong = (value) => {
    const [day, month, year] = value.split(/\s+/);
    return `${year}-${monthName[month]}-${String(day).padStart(2, '0')}`;
  };

  const meta = {
    title: 'Business',
    sourceFile: path.relative(process.cwd(), pdfPath),
    environment: {
      key: 'mpire-business',
      name: 'MPIRE Business',
      type: 'business',
      currency: 'ZAR',
      description: 'Business banking environment for MPIRE',
    },
    account: {
      label: 'FNB Gold Business Account `62782327821`',
      key: 'fnb-gold-business-27821',
      name: 'FNB Gold Business Account',
      bank: 'FNB',
      type: 'current',
      currency: 'ZAR',
      last4: '27821',
    },
    statementStart: toIsoLong(periodMatch?.[1] || '18 November 2025'),
    statementEnd: toIsoLong(periodMatch?.[2] || '18 December 2025'),
    openingBalance: parseMoney(openingMatch?.[1]) ?? 0,
    closingBalance: parseMoney(closingMatch?.[1]) ?? 0,
    importKey: `${toIsoLong(periodMatch?.[2] || '18 December 2025')}-fnb-gold-business-27821`,
  };

  return renderMarkdown(meta, rows, [
    'Keep generic bank-fee rows explicit even when FNB omits the fee description on the line itself.',
    'Keep internal-transfer candidates visible rather than flattening them into ordinary expenses.',
    'Preserve recurring software and PayPal rows so the subscription view can be derived from real history.',
  ]);
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const inputPath = path.resolve(process.cwd(), args.input);
  const outputPath = path.resolve(process.cwd(), args.output);

  let markdown = '';
  if (args.profile === 'nedbank-current') {
    markdown = parseNedbankCurrent(inputPath, outputPath);
  }
  else if (args.profile === 'nedbank-credit') {
    markdown = parseNedbankCredit(inputPath, outputPath);
  }
  else if (args.profile === 'fnb-business') {
    markdown = parseFnbBusiness(inputPath, outputPath);
  }
  else {
    throw new Error(`Unsupported profile: ${args.profile}`);
  }

  await fs.writeFile(outputPath, markdown, 'utf8');
}

main().catch((error) => {
  console.error(error.stack || error.message || String(error));
  process.exitCode = 1;
});
