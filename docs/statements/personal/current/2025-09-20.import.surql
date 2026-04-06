-- Generated from docs/statements/personal/current/2025-09-20.import.md
-- Source: docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf

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
  openingBalance: 18999.6,
  active: true,
  notes: "Imported from 21 Aug 2025 - 20 Sep 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-09-20-nedbank-current",
  sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-09-20T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-09-20.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-09-20.import.md"
});
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-20.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-20.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-09-20.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-09-20.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-09-20.import.md"
});
LET $cat_fees_overdraft_interest = fn::createCategory({
  space: $space,
  key: "fees-overdraft-interest",
  name: "Overdraft Interest",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-09-20.import.md"
});
LET $cat_fees_service_fee = fn::createCategory({
  space: $space,
  key: "fees-service-fee",
  name: "Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-09-20.import.md"
});
LET $cat_fees_overdraft_facility_fee = fn::createCategory({
  space: $space,
  key: "fees-overdraft-facility-fee",
  name: "Overdraft Facility Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-09-20.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-09-20.import.md"
});

-- Merchant records
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "MPIRE Digital Market",
  normalizedName: "MPIRE Digital Market",
  active: true,
  notes: "Imported from 2025-09-20.import.md"
});
LET $merchant_nedbank_credit_card = fn::createMerchant({
  space: $space,
  key: "nedbank-credit-card",
  name: "Nedbank Credit Card",
  normalizedName: "Nedbank Credit Card",
  active: true,
  notes: "Imported from 2025-09-20.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-09-20.import.md"
});
LET $merchant_nedbank_savings_account = fn::createMerchant({
  space: $space,
  key: "nedbank-savings-account",
  name: "Nedbank Savings Account",
  normalizedName: "Nedbank Savings Account",
  active: true,
  notes: "Imported from 2025-09-20.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-08-23T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 50000,
  balance: 31000.4,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 1,
    rawRowText: "MPIRE DIGITAL MARKET; 50000.00; 31000.40",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 50000,
    bankChargeZar: null,
    balanceZar: 31000.4
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_09_20_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-08-23T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 50000,
  balance: 31000.4,
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_09_20_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_01.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_01.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-08-23T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 31000,
  balance: 0.4,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 2,
    rawRowText: "CREDIT CRD - 4922130003088996; 31000.00; 0.40",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 31000,
    bankChargeZar: null,
    balanceZar: 0.4
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_09_20_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-08-23T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 31000,
  balance: 0.4,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_09_20_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_02.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_02.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-08-27T00:00:00Z",
  description: "VAT 28/07-26/08 = R18.12",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: 0.4,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 3,
    rawRowText: "VAT 28/07-26/08 = R18.12; 0.00; 0.40",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: 0.4
},
  notes: "VAT summary row for bank charges period."
});
LET $tx_stmt_2025_09_20_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-08-27T00:00:00Z",
  description: "VAT 28/07-26/08 = R18.12",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: 0.4,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_09_20_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_03.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_03.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-08-27T00:00:00Z",
  description: "INTEREST 28/07 - 26/08",
  normalizedDescription: "Overdraft Interest",
  amount: 153.43,
  balance: -153.03,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 4,
    rawRowText: "INTEREST 28/07 - 26/08; 153.43; -153.03",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft interest",
    clarificationStatus: "clarified",
    amountZar: 153.43,
    bankChargeZar: null,
    balanceZar: -153.03
},
  notes: "Overdraft interest charge."
});
LET $tx_stmt_2025_09_20_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-08-27T00:00:00Z",
  description: "INTEREST 28/07 - 26/08",
  normalizedDescription: "Overdraft Interest",
  amount: 153.43,
  balance: -153.03,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_09_20_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_04.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_04.id, "TransactionCategory", $cat_fees_overdraft_interest.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-08-27T00:00:00Z",
  description: "SERVICE FEE 28/07 - 26/08",
  normalizedDescription: "Service Fee",
  amount: 5,
  balance: -158.03,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 5,
    rawRowText: "SERVICE FEE 28/07 - 26/08; 5.00; -158.03",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 5,
    bankChargeZar: null,
    balanceZar: -158.03
},
  notes: "Nedbank service fee."
});
LET $tx_stmt_2025_09_20_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-08-27T00:00:00Z",
  description: "SERVICE FEE 28/07 - 26/08",
  normalizedDescription: "Service Fee",
  amount: 5,
  balance: -158.03,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Nedbank service fee."
});
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_09_20_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_05.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_05.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-08-27T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -227.03,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 6,
    rawRowText: "Facility Fee; 69.00; -227.03",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft facility fee",
    clarificationStatus: "clarified",
    amountZar: 69,
    bankChargeZar: null,
    balanceZar: -227.03
},
  notes: "Overdraft facility fee."
});
LET $tx_stmt_2025_09_20_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-08-27T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -227.03,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_09_20_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_06.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_06.id, "TransactionCategory", $cat_fees_overdraft_facility_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-08-27T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 55,
  balance: -282.03,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 7,
    rawRowText: "MAINTENANCE FEE; 55.00; -282.03",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "maintenance fee",
    clarificationStatus: "clarified",
    amountZar: 55,
    bankChargeZar: null,
    balanceZar: -282.03
},
  notes: "Maintenance fee."
});
LET $tx_stmt_2025_09_20_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-08-27T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 55,
  balance: -282.03,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_09_20_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_07.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_07.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-08-29T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 10000,
  balance: 9717.97,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 8,
    rawRowText: "MPIRE DIGITAL MARKET; 10000.00; 9717.97",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 10000,
    bankChargeZar: null,
    balanceZar: 9717.97
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_09_20_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-08-29T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 10000,
  balance: 9717.97,
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_09_20_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_08.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_08.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-08-29T00:00:00Z",
  description: "transfer",
  normalizedDescription: "Nedbank Credit Card",
  amount: 18667,
  balance: -8949.03,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 9,
    rawRowText: "transfer; 18667.00; -8949.03",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 18667,
    bankChargeZar: null,
    balanceZar: -8949.03
},
  notes: "Transfer from current account to the credit card."
});
LET $tx_stmt_2025_09_20_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-08-29T00:00:00Z",
  description: "transfer",
  normalizedDescription: "Nedbank Credit Card",
  amount: 18667,
  balance: -8949.03,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer from current account to the credit card."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_09_20_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_09.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_09.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-08-29T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 10000,
  balance: -18949.03,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 10,
    rawRowText: "CREDIT CRD - 4922130003088996; 10000.00; -18949.03",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 10000,
    bankChargeZar: null,
    balanceZar: -18949.03
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_09_20_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-08-29T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 10000,
  balance: -18949.03,
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_09_20_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_10.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_10.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-08-29T00:00:00Z",
  description: "SAVINGS AC - 2578012946",
  normalizedDescription: "Nedbank Savings Account",
  amount: 50,
  balance: -18999.03,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 11,
    rawRowText: "SAVINGS AC - 2578012946; 50.00; -18999.03",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Savings Account",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 50,
    bankChargeZar: null,
    balanceZar: -18999.03
},
  notes: "Transfer out from current to savings."
});
LET $tx_stmt_2025_09_20_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-08-29T00:00:00Z",
  description: "SAVINGS AC - 2578012946",
  normalizedDescription: "Nedbank Savings Account",
  amount: 50,
  balance: -18999.03,
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_09_20_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_11.id, "TransactionMerchant", $merchant_nedbank_savings_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_11.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-09-02T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2500,
  balance: -16499.03,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 12,
    rawRowText: "MPIRE DIGITAL MARKET; 2500.00; -16499.03",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2500,
    bankChargeZar: null,
    balanceZar: -16499.03
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_09_20_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-09-02T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2500,
  balance: -16499.03,
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_09_20_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_12.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_12.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-09-02T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2500,
  balance: -18999.03,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 13,
    rawRowText: "CREDIT CRD - 4922130003088996; 2500.00; -18999.03",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2500,
    bankChargeZar: null,
    balanceZar: -18999.03
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_09_20_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-09-02T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2500,
  balance: -18999.03,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_09_20_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_13.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_13.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-09-12T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2000,
  balance: -16999.03,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 14,
    rawRowText: "MPIRE DIGITAL MARKET; 2000.00; -16999.03",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: -16999.03
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_09_20_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-09-12T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2000,
  balance: -16999.03,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_09_20_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_14.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_14.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-09-12T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -18999.03,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 15,
    rawRowText: "CREDIT CRD - 4922130003088996; 2000.00; -18999.03",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: -18999.03
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_09_20_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-09-12T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -18999.03,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_09_20_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_15.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_15.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-09-15T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1000,
  balance: -17999.03,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 16,
    rawRowText: "MPIRE DIGITAL MARKET; 1000.00; -17999.03",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: -17999.03
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_09_20_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-09-15T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1000,
  balance: -17999.03,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_09_20_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_16.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_16.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-09-15T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1000,
  balance: -18999.03,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Aug 2025 - 20 Sep 2025.pdf",
    statementPeriodStart: "2025-08-21",
    statementPeriodEnd: "2025-09-20",
    rowNo: 17,
    rawRowText: "CREDIT CRD - 4922130003088996; 1000.00; -18999.03",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: -18999.03
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_09_20_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-20-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-09-15T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1000,
  balance: -18999.03,
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_09_20_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_09_20_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_20_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_17.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_20_row_17.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 17,
  normalizedCount: 17,
  clarificationCount: 0,
  status: "matched",
  statementDate: "2025-09-20T00:00:00Z",
  notes: "Imported from 2025-09-20.import.md"
});

-- End of generated import
