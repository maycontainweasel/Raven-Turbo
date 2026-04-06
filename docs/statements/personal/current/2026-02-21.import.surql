-- Generated from docs/statements/personal/current/2026-02-21.import.md
-- Source: docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf

USE NS raven DB raven1;

-- Base environment and account
LET $space = fn::createFinancialSpace({
  key: "personal",
  name: "Personal",
  spaceType: "personal",
  currency: "ZAR",
  active: true,
  description: "Personal banking, debt, savings, and transfer flows"
});
LET $account = fn::createAccount({
  space: $space,
  key: "nedbank-current-07185",
  name: "Nedbank Current Account",
  bankName: "Nedbank",
  accountType: "current",
  currency: "ZAR",
  accountNumberLast4: "7185",
  openingBalance: -34999.72,
  active: true,
  notes: "Imported from 21 Jan 2026 - 21 Feb 2026.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2026-02-21-nedbank-current",
  sourceFileName: "docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2026-02-21T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2026-02-21.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});
LET $cat_debt_payment_reversal = fn::createCategory({
  space: $space,
  key: "debt-payment-reversal",
  name: "Debt payment reversal",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});
LET $cat_fees_overdraft_interest = fn::createCategory({
  space: $space,
  key: "fees-overdraft-interest",
  name: "Overdraft Interest",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});
LET $cat_fees_service_fee = fn::createCategory({
  space: $space,
  key: "fees-service-fee",
  name: "Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});
LET $cat_fees_overdraft_facility_fee = fn::createCategory({
  space: $space,
  key: "fees-overdraft-facility-fee",
  name: "Overdraft Facility Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});
LET $cat_fees_no_funds_alert_sms_fee = fn::createCategory({
  space: $space,
  key: "fees-no-funds-alert-sms-fee",
  name: "No Funds Alert Sms Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});

-- Merchant records
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});
LET $merchant_nedbank_credit_card = fn::createMerchant({
  space: $space,
  key: "nedbank-credit-card",
  name: "Nedbank Credit Card",
  normalizedName: "Nedbank Credit Card",
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "MPIRE Digital Market",
  normalizedName: "MPIRE Digital Market",
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});
LET $merchant_nedbank_savings_account = fn::createMerchant({
  space: $space,
  key: "nedbank-savings-account",
  name: "Nedbank Savings Account",
  normalizedName: "Nedbank Savings Account",
  active: true,
  notes: "Imported from 2026-02-21.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2026-01-28T00:00:00Z",
  description: "VAT 27/12-27/01 = R17.08",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -34999.72,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf",
    statementPeriodStart: "2026-01-21",
    statementPeriodEnd: "2026-02-21",
    rowNo: 1,
    rawRowText: "VAT 27/12-27/01 = R17.08; 0.00; -34999.72",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: -34999.72
},
  notes: "VAT summary row for bank charges period."
});
LET $tx_stmt_2026_02_21_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-21-row-01",
  sourceRow: $row_row_01,
  postedAt: "2026-01-28T00:00:00Z",
  description: "VAT 27/12-27/01 = R17.08",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -34999.72,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_vat_on_fees,
  isTransfer: false,
  manualOverride: false,
  notes: "VAT summary row for bank charges period."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2026_02_21_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2026_02_21_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_21_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_01.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_01.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2026-01-28T00:00:00Z",
  description: "INTEREST 27/12 - 27/01",
  normalizedDescription: "Overdraft Interest",
  amount: 304.5,
  balance: -35304.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf",
    statementPeriodStart: "2026-01-21",
    statementPeriodEnd: "2026-02-21",
    rowNo: 2,
    rawRowText: "INTEREST 27/12 - 27/01; 304.50; -35304.22",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft interest",
    clarificationStatus: "clarified",
    amountZar: 304.5,
    bankChargeZar: null,
    balanceZar: -35304.22
},
  notes: "Overdraft interest charge."
});
LET $tx_stmt_2026_02_21_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-21-row-02",
  sourceRow: $row_row_02,
  postedAt: "2026-01-28T00:00:00Z",
  description: "INTEREST 27/12 - 27/01",
  normalizedDescription: "Overdraft Interest",
  amount: 304.5,
  balance: -35304.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_overdraft_interest,
  isTransfer: false,
  manualOverride: false,
  notes: "Overdraft interest charge."
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2026_02_21_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2026_02_21_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_21_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_02.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_02.id, "TransactionCategory", $cat_fees_overdraft_interest.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2026-01-28T00:00:00Z",
  description: "SERVICE FEE 27/12 - 27/01",
  normalizedDescription: "Service Fee",
  amount: 5,
  balance: -35309.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf",
    statementPeriodStart: "2026-01-21",
    statementPeriodEnd: "2026-02-21",
    rowNo: 3,
    rawRowText: "SERVICE FEE 27/12 - 27/01; 5.00; -35309.22",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 5,
    bankChargeZar: null,
    balanceZar: -35309.22
},
  notes: "Monthly service fee."
});
LET $tx_stmt_2026_02_21_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-21-row-03",
  sourceRow: $row_row_03,
  postedAt: "2026-01-28T00:00:00Z",
  description: "SERVICE FEE 27/12 - 27/01",
  normalizedDescription: "Service Fee",
  amount: 5,
  balance: -35309.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Monthly service fee."
});
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2026_02_21_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2026_02_21_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_21_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_03.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_03.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2026-01-28T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -35378.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf",
    statementPeriodStart: "2026-01-21",
    statementPeriodEnd: "2026-02-21",
    rowNo: 4,
    rawRowText: "Facility Fee; 69.00; -35378.22",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft facility fee",
    clarificationStatus: "clarified",
    amountZar: 69,
    bankChargeZar: null,
    balanceZar: -35378.22
},
  notes: "Overdraft facility fee."
});
LET $tx_stmt_2026_02_21_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-21-row-04",
  sourceRow: $row_row_04,
  postedAt: "2026-01-28T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -35378.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_overdraft_facility_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Overdraft facility fee."
});
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2026_02_21_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2026_02_21_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_21_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_04.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_04.id, "TransactionCategory", $cat_fees_overdraft_facility_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2026-01-28T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 57,
  balance: -35435.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf",
    statementPeriodStart: "2026-01-21",
    statementPeriodEnd: "2026-02-21",
    rowNo: 5,
    rawRowText: "MAINTENANCE FEE; 57.00; -35435.22",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "maintenance fee",
    clarificationStatus: "clarified",
    amountZar: 57,
    bankChargeZar: null,
    balanceZar: -35435.22
},
  notes: "Maintenance fee."
});
LET $tx_stmt_2026_02_21_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-21-row-05",
  sourceRow: $row_row_05,
  postedAt: "2026-01-28T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 57,
  balance: -35435.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_maintenance_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Maintenance fee."
});
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2026_02_21_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2026_02_21_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_21_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_05.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_05.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2026-01-30T00:00:00Z",
  description: "A P O PAYMENT 5898460810785253",
  normalizedDescription: "Nedbank Credit Card",
  amount: 7740,
  balance: -43175.22,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf",
    statementPeriodStart: "2026-01-21",
    statementPeriodEnd: "2026-02-21",
    rowNo: 6,
    rawRowText: "A P O PAYMENT 5898460810785253; 7740.00; -43175.22",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 7740,
    bankChargeZar: 5,
    balanceZar: -43175.22
},
  notes: "Automatic payment order against the credit card."
});
LET $tx_stmt_2026_02_21_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-21-row-06",
  sourceRow: $row_row_06,
  postedAt: "2026-01-30T00:00:00Z",
  description: "A P O PAYMENT 5898460810785253",
  normalizedDescription: "Nedbank Credit Card",
  amount: 7740,
  balance: -43175.22,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Automatic payment order against the credit card."
});
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2026_02_21_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2026_02_21_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_21_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_06.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_06.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2026-01-31T00:00:00Z",
  description: "No funds alert SMS fee",
  normalizedDescription: "No Funds Alert Sms Fee",
  amount: 10,
  balance: -43185.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf",
    statementPeriodStart: "2026-01-21",
    statementPeriodEnd: "2026-02-21",
    rowNo: 7,
    rawRowText: "No funds alert SMS fee; 10.00; -43185.22",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "no funds alert sms fee",
    clarificationStatus: "clarified",
    amountZar: 10,
    bankChargeZar: null,
    balanceZar: -43185.22
},
  notes: "No-funds alert SMS fee."
});
LET $tx_stmt_2026_02_21_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-21-row-07",
  sourceRow: $row_row_07,
  postedAt: "2026-01-31T00:00:00Z",
  description: "No funds alert SMS fee",
  normalizedDescription: "No Funds Alert Sms Fee",
  amount: 10,
  balance: -43185.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_no_funds_alert_sms_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "No-funds alert SMS fee."
});
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2026_02_21_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2026_02_21_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_21_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_07.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_07.id, "TransactionCategory", $cat_fees_no_funds_alert_sms_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2026-02-02T00:00:00Z",
  description: "REV_5898460810785253",
  normalizedDescription: "Nedbank Credit Card",
  amount: 7740,
  balance: -35445.22,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf",
    statementPeriodStart: "2026-01-21",
    statementPeriodEnd: "2026-02-21",
    rowNo: 8,
    rawRowText: "REV_5898460810785253; 7740.00; -35445.22",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment reversal",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 7740,
    bankChargeZar: null,
    balanceZar: -35445.22
},
  notes: "Reversal of the failed APO payment."
});
LET $tx_stmt_2026_02_21_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-21-row-08",
  sourceRow: $row_row_08,
  postedAt: "2026-02-02T00:00:00Z",
  description: "REV_5898460810785253",
  normalizedDescription: "Nedbank Credit Card",
  amount: 7740,
  balance: -35445.22,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_debt_payment_reversal,
  isTransfer: true,
  manualOverride: false,
  notes: "Reversal of the failed APO payment."
});
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2026_02_21_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2026_02_21_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_21_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_08.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_08.id, "TransactionCategory", $cat_debt_payment_reversal.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2026-02-10T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 12500,
  balance: -22945.22,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf",
    statementPeriodStart: "2026-01-21",
    statementPeriodEnd: "2026-02-21",
    rowNo: 9,
    rawRowText: "MPIRE DIGITAL MARKET; 12500.00; -22945.22",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 12500,
    bankChargeZar: null,
    balanceZar: -22945.22
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2026_02_21_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-21-row-09",
  sourceRow: $row_row_09,
  postedAt: "2026-02-10T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 12500,
  balance: -22945.22,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "MPIRE Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2026_02_21_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2026_02_21_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_21_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_09.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_09.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2026-02-10T00:00:00Z",
  description: "SAVINGS AC - 2578012946",
  normalizedDescription: "Nedbank Savings Account",
  amount: 100,
  balance: -23045.22,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf",
    statementPeriodStart: "2026-01-21",
    statementPeriodEnd: "2026-02-21",
    rowNo: 10,
    rawRowText: "SAVINGS AC - 2578012946; 100.00; -23045.22",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Savings Account",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 100,
    bankChargeZar: null,
    balanceZar: -23045.22
},
  notes: "Transfer out from current to savings."
});
LET $tx_stmt_2026_02_21_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-21-row-10",
  sourceRow: $row_row_10,
  postedAt: "2026-02-10T00:00:00Z",
  description: "SAVINGS AC - 2578012946",
  normalizedDescription: "Nedbank Savings Account",
  amount: 100,
  balance: -23045.22,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Savings Account",
  merchant: $merchant_nedbank_savings_account,
  category: $cat_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer out from current to savings."
});
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2026_02_21_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2026_02_21_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_21_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_10.id, "TransactionMerchant", $merchant_nedbank_savings_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_10.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2026-02-10T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 11500,
  balance: -34545.22,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf",
    statementPeriodStart: "2026-01-21",
    statementPeriodEnd: "2026-02-21",
    rowNo: 11,
    rawRowText: "CREDIT CRD - 4922130003088996; 11500.00; -34545.22",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 11500,
    bankChargeZar: null,
    balanceZar: -34545.22
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2026_02_21_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-21-row-11",
  sourceRow: $row_row_11,
  postedAt: "2026-02-10T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 11500,
  balance: -34545.22,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer out to settle the credit card."
});
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2026_02_21_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2026_02_21_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_21_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_11.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_11.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2026-02-16T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 8000,
  balance: -26545.22,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf",
    statementPeriodStart: "2026-01-21",
    statementPeriodEnd: "2026-02-21",
    rowNo: 12,
    rawRowText: "MPIRE DIGITAL MARKET; 8000.00; -26545.22",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 8000,
    bankChargeZar: null,
    balanceZar: -26545.22
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2026_02_21_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-21-row-12",
  sourceRow: $row_row_12,
  postedAt: "2026-02-16T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 8000,
  balance: -26545.22,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "MPIRE Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2026_02_21_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2026_02_21_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_21_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_12.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_12.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2026-02-16T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 450,
  balance: -26995.22,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf",
    statementPeriodStart: "2026-01-21",
    statementPeriodEnd: "2026-02-21",
    rowNo: 13,
    rawRowText: "CREDIT CRD - 4922130003088996; 450.00; -26995.22",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 450,
    bankChargeZar: null,
    balanceZar: -26995.22
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2026_02_21_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-21-row-13",
  sourceRow: $row_row_13,
  postedAt: "2026-02-16T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 450,
  balance: -26995.22,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer out to settle the credit card."
});
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2026_02_21_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2026_02_21_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_21_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_13.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_13.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2026-02-16T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 8000,
  balance: -34995.22,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jan 2026 - 21 Feb 2026.pdf",
    statementPeriodStart: "2026-01-21",
    statementPeriodEnd: "2026-02-21",
    rowNo: 14,
    rawRowText: "CREDIT CRD - 4922130003088996; 8000.00; -34995.22",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 8000,
    bankChargeZar: null,
    balanceZar: -34995.22
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2026_02_21_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-21-row-14",
  sourceRow: $row_row_14,
  postedAt: "2026-02-16T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 8000,
  balance: -34995.22,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer out to settle the credit card."
});
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2026_02_21_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2026_02_21_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_21_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_14.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_21_row_14.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 14,
  normalizedCount: 14,
  clarificationCount: 0,
  status: "matched",
  statementDate: "2026-02-21T00:00:00Z",
  notes: "Imported from 2026-02-21.import.md"
});

-- End of generated import
