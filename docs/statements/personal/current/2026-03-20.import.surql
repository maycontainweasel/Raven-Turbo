-- Generated from docs/statements/personal/current/2026-03-20.import.md
-- Source: docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf

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
  openingBalance: -34995.22,
  active: true,
  notes: "Imported from 21 Feb 2026 - 20 Mar 2026.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2026-03-20-nedbank-current",
  sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2026-03-20T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2026-03-20.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});
LET $cat_fees_overdraft_interest = fn::createCategory({
  space: $space,
  key: "fees-overdraft-interest",
  name: "Overdraft Interest",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});
LET $cat_fees_service_fee = fn::createCategory({
  space: $space,
  key: "fees-service-fee",
  name: "Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});
LET $cat_fees_overdraft_facility_fee = fn::createCategory({
  space: $space,
  key: "fees-overdraft-facility-fee",
  name: "Overdraft Facility Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});
LET $cat_fees_ott_fee = fn::createCategory({
  space: $space,
  key: "fees-ott-fee",
  name: "Ott Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});

-- Merchant records
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "MPIRE Digital Market",
  normalizedName: "MPIRE Digital Market",
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});
LET $merchant_nedbank_credit_card = fn::createMerchant({
  space: $space,
  key: "nedbank-credit-card",
  name: "Nedbank Credit Card",
  normalizedName: "Nedbank Credit Card",
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});
LET $merchant_wise = fn::createMerchant({
  space: $space,
  key: "wise",
  name: "Wise",
  normalizedName: "Wise",
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});
LET $merchant_nedbank_savings_account = fn::createMerchant({
  space: $space,
  key: "nedbank-savings-account",
  name: "Nedbank Savings Account",
  normalizedName: "Nedbank Savings Account",
  active: true,
  notes: "Imported from 2026-03-20.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2026-02-25T00:00:00Z",
  description: "VAT 28/01-24/02 = R18.38",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -34995.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 1,
    rawRowText: "VAT 28/01-24/02 = R18.38; 0.00; -34995.22",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: -34995.22
},
  notes: "VAT summary row for bank charges period."
});
LET $tx_stmt_2026_03_20_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-01",
  sourceRow: $row_row_01,
  postedAt: "2026-02-25T00:00:00Z",
  description: "VAT 28/01-24/02 = R18.38",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -34995.22,
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2026_03_20_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_01.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_01.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2026-02-25T00:00:00Z",
  description: "INTEREST 28/01 - 24/02",
  normalizedDescription: "Overdraft Interest",
  amount: 310.13,
  balance: -35305.35,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 2,
    rawRowText: "INTEREST 28/01 - 24/02; 310.13; -35305.35",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft interest",
    clarificationStatus: "clarified",
    amountZar: 310.13,
    bankChargeZar: null,
    balanceZar: -35305.35
},
  notes: "Overdraft interest charge."
});
LET $tx_stmt_2026_03_20_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-02",
  sourceRow: $row_row_02,
  postedAt: "2026-02-25T00:00:00Z",
  description: "INTEREST 28/01 - 24/02",
  normalizedDescription: "Overdraft Interest",
  amount: 310.13,
  balance: -35305.35,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2026_03_20_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_02.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_02.id, "TransactionCategory", $cat_fees_overdraft_interest.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2026-02-25T00:00:00Z",
  description: "SERVICE FEE 28/01 - 24/02",
  normalizedDescription: "Service Fee",
  amount: 5,
  balance: -35310.35,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 3,
    rawRowText: "SERVICE FEE 28/01 - 24/02; 5.00; -35310.35",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 5,
    bankChargeZar: null,
    balanceZar: -35310.35
},
  notes: "Monthly service fee."
});
LET $tx_stmt_2026_03_20_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-03",
  sourceRow: $row_row_03,
  postedAt: "2026-02-25T00:00:00Z",
  description: "SERVICE FEE 28/01 - 24/02",
  normalizedDescription: "Service Fee",
  amount: 5,
  balance: -35310.35,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2026_03_20_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_03.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_03.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2026-02-25T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -35379.35,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 4,
    rawRowText: "Facility Fee; 69.00; -35379.35",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft facility fee",
    clarificationStatus: "clarified",
    amountZar: 69,
    bankChargeZar: null,
    balanceZar: -35379.35
},
  notes: "Overdraft facility fee."
});
LET $tx_stmt_2026_03_20_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-04",
  sourceRow: $row_row_04,
  postedAt: "2026-02-25T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -35379.35,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2026_03_20_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_04.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_04.id, "TransactionCategory", $cat_fees_overdraft_facility_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2026-02-25T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 57,
  balance: -35436.35,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 5,
    rawRowText: "MAINTENANCE FEE; 57.00; -35436.35",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "maintenance fee",
    clarificationStatus: "clarified",
    amountZar: 57,
    bankChargeZar: null,
    balanceZar: -35436.35
},
  notes: "Maintenance fee."
});
LET $tx_stmt_2026_03_20_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-05",
  sourceRow: $row_row_05,
  postedAt: "2026-02-25T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 57,
  balance: -35436.35,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2026_03_20_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_05.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_05.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2026-02-27T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 27000,
  balance: -8436.35,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 6,
    rawRowText: "MPIRE DIGITAL MARKET; 27000.00; -8436.35",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 27000,
    bankChargeZar: null,
    balanceZar: -8436.35
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2026_03_20_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-06",
  sourceRow: $row_row_06,
  postedAt: "2026-02-27T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 27000,
  balance: -8436.35,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2026_03_20_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_06.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_06.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2026-02-28T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 26500,
  balance: -34936.35,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 7,
    rawRowText: "CREDIT CRD - 4922130003088996; 26500.00; -34936.35",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 26500,
    bankChargeZar: null,
    balanceZar: -34936.35
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2026_03_20_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-07",
  sourceRow: $row_row_07,
  postedAt: "2026-02-28T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 26500,
  balance: -34936.35,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2026_03_20_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_07.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_07.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2026-03-02T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 15000,
  balance: -19936.35,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 8,
    rawRowText: "MPIRE DIGITAL MARKET; 15000.00; -19936.35",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 15000,
    bankChargeZar: null,
    balanceZar: -19936.35
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2026_03_20_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-08",
  sourceRow: $row_row_08,
  postedAt: "2026-03-02T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 15000,
  balance: -19936.35,
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2026_03_20_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_08.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_08.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2026-03-03T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 15000,
  balance: -34936.35,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 9,
    rawRowText: "CREDIT CRD - 4922130003088996; 15000.00; -34936.35",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 15000,
    bankChargeZar: null,
    balanceZar: -34936.35
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2026_03_20_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-09",
  sourceRow: $row_row_09,
  postedAt: "2026-03-03T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 15000,
  balance: -34936.35,
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2026_03_20_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_09.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_09.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2026-03-13T00:00:00Z",
  description: "IP2F687DWISE PAYMENTS LIMITED",
  normalizedDescription: "Wise",
  amount: 9748.76,
  balance: -25187.59,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 10,
    rawRowText: "IP2F687DWISE PAYMENTS LIMITED; 9748.76; -25187.59",
    transactionType: "income",
    normalizedMerchant: "Wise",
    category: "Income",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 9748.76,
    bankChargeZar: null,
    balanceZar: -25187.59
},
  notes: "Inbound Wise payment; likely payout or transfer, but needs exact source confirmation."
});
LET $tx_stmt_2026_03_20_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-10",
  sourceRow: $row_row_10,
  postedAt: "2026-03-13T00:00:00Z",
  description: "IP2F687DWISE PAYMENTS LIMITED",
  normalizedDescription: "Wise",
  amount: 9748.76,
  balance: -25187.59,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Wise",
  merchant: $merchant_wise,
  category: $cat_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Inbound Wise payment; likely payout or transfer, but needs exact source confirmation."
});
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2026_03_20_row_10.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_10.id, "TransactionMerchant", $merchant_wise.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_10.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_20_row_10 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-20-row-10",
  transaction: $tx_stmt_2026_03_20_row_10,
  status: "open",
  question: "What was the purpose of this Wise spend or transfer?",
  reason: "Wise spend or transfer rail needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_wise,
  suggestedCategory: $cat_income,
  confidence: 0.25,
  notes: "Imported from 2026-03-20.import.md"
});
fn::createEdge($tx_stmt_2026_03_20_row_10.id, "TransactionClarificationTasks", $task_stmt_2026_03_20_row_10.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2026-03-13T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -27187.59,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 11,
    rawRowText: "CREDIT CRD - 4922130003088996; 2000.00; -27187.59",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: -27187.59
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2026_03_20_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-11",
  sourceRow: $row_row_11,
  postedAt: "2026-03-13T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -27187.59,
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2026_03_20_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_11.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_11.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2026-03-13T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -29187.59,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 12,
    rawRowText: "CREDIT CRD - 4922130003088996; 2000.00; -29187.59",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: -29187.59
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2026_03_20_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-12",
  sourceRow: $row_row_12,
  postedAt: "2026-03-13T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -29187.59,
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2026_03_20_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_12.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_12.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2026-03-13T00:00:00Z",
  description: "OTT",
  normalizedDescription: "Ott Fee",
  amount: 10,
  balance: -29197.59,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 13,
    rawRowText: "OTT; 10.00; -29197.59",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "ott fee",
    clarificationStatus: "unclarified",
    amountZar: 10,
    bankChargeZar: null,
    balanceZar: -29197.59
},
  notes: "OTT fee label still needs confirmation."
});
LET $tx_stmt_2026_03_20_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-13",
  sourceRow: $row_row_13,
  postedAt: "2026-03-13T00:00:00Z",
  description: "OTT",
  normalizedDescription: "Ott Fee",
  amount: 10,
  balance: -29197.59,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_ott_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "OTT fee label still needs confirmation."
});
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2026_03_20_row_13.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_13.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_13.id, "TransactionCategory", $cat_fees_ott_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_20_row_13 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-20-row-13",
  transaction: $tx_stmt_2026_03_20_row_13,
  status: "open",
  question: "What is the exact purpose of this Nedbank transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_nedbank,
  suggestedCategory: $cat_fees_ott_fee,
  confidence: 0.25,
  notes: "Imported from 2026-03-20.import.md"
});
fn::createEdge($tx_stmt_2026_03_20_row_13.id, "TransactionClarificationTasks", $task_stmt_2026_03_20_row_13.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2026-03-14T00:00:00Z",
  description: "OTT",
  normalizedDescription: "Ott Fee",
  amount: 10,
  balance: -29207.59,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 14,
    rawRowText: "OTT; 10.00; -29207.59",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "ott fee",
    clarificationStatus: "unclarified",
    amountZar: 10,
    bankChargeZar: null,
    balanceZar: -29207.59
},
  notes: "OTT fee label still needs confirmation."
});
LET $tx_stmt_2026_03_20_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-14",
  sourceRow: $row_row_14,
  postedAt: "2026-03-14T00:00:00Z",
  description: "OTT",
  normalizedDescription: "Ott Fee",
  amount: 10,
  balance: -29207.59,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_ott_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "OTT fee label still needs confirmation."
});
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2026_03_20_row_14.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_14.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_14.id, "TransactionCategory", $cat_fees_ott_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_20_row_14 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-20-row-14",
  transaction: $tx_stmt_2026_03_20_row_14,
  status: "open",
  question: "What is the exact purpose of this Nedbank transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_nedbank,
  suggestedCategory: $cat_fees_ott_fee,
  confidence: 0.25,
  notes: "Imported from 2026-03-20.import.md"
});
fn::createEdge($tx_stmt_2026_03_20_row_14.id, "TransactionClarificationTasks", $task_stmt_2026_03_20_row_14.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2026-03-14T00:00:00Z",
  description: "OTT",
  normalizedDescription: "Ott Fee",
  amount: 10,
  balance: -29217.59,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 15,
    rawRowText: "OTT; 10.00; -29217.59",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "ott fee",
    clarificationStatus: "unclarified",
    amountZar: 10,
    bankChargeZar: null,
    balanceZar: -29217.59
},
  notes: "OTT fee label still needs confirmation."
});
LET $tx_stmt_2026_03_20_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-15",
  sourceRow: $row_row_15,
  postedAt: "2026-03-14T00:00:00Z",
  description: "OTT",
  normalizedDescription: "Ott Fee",
  amount: 10,
  balance: -29217.59,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_ott_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "OTT fee label still needs confirmation."
});
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2026_03_20_row_15.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_15.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_15.id, "TransactionCategory", $cat_fees_ott_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_20_row_15 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-20-row-15",
  transaction: $tx_stmt_2026_03_20_row_15,
  status: "open",
  question: "What is the exact purpose of this Nedbank transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_nedbank,
  suggestedCategory: $cat_fees_ott_fee,
  confidence: 0.25,
  notes: "Imported from 2026-03-20.import.md"
});
fn::createEdge($tx_stmt_2026_03_20_row_15.id, "TransactionClarificationTasks", $task_stmt_2026_03_20_row_15.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2026-03-14T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2500,
  balance: -31717.59,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 16,
    rawRowText: "CREDIT CRD - 4922130003088996; 2500.00; -31717.59",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2500,
    bankChargeZar: null,
    balanceZar: -31717.59
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2026_03_20_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-16",
  sourceRow: $row_row_16,
  postedAt: "2026-03-14T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2500,
  balance: -31717.59,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2026_03_20_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_16.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_16.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2026-03-16T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -33717.59,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 17,
    rawRowText: "CREDIT CRD - 4922130003088996; 2000.00; -33717.59",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: -33717.59
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2026_03_20_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-17",
  sourceRow: $row_row_17,
  postedAt: "2026-03-16T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -33717.59,
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2026_03_20_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_17.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_17.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2026-03-16T00:00:00Z",
  description: "SAVINGS AC - 2578012946",
  normalizedDescription: "Nedbank Savings Account",
  amount: 1282,
  balance: -34999.59,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Feb 2026 - 20 Mar 2026.pdf",
    statementPeriodStart: "2026-02-21",
    statementPeriodEnd: "2026-03-20",
    rowNo: 18,
    rawRowText: "SAVINGS AC - 2578012946; 1282.00; -34999.59",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Savings Account",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1282,
    bankChargeZar: null,
    balanceZar: -34999.59
},
  notes: "Transfer out from current to savings."
});
LET $tx_stmt_2026_03_20_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-20-row-18",
  sourceRow: $row_row_18,
  postedAt: "2026-03-16T00:00:00Z",
  description: "SAVINGS AC - 2578012946",
  normalizedDescription: "Nedbank Savings Account",
  amount: 1282,
  balance: -34999.59,
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2026_03_20_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2026_03_20_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_20_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_18.id, "TransactionMerchant", $merchant_nedbank_savings_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_20_row_18.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 18,
  normalizedCount: 18,
  clarificationCount: 4,
  status: "matched",
  statementDate: "2026-03-20T00:00:00Z",
  notes: "Imported from 2026-03-20.import.md"
});

-- End of generated import
