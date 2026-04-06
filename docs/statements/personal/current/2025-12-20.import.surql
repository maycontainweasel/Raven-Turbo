-- Generated from docs/statements/personal/current/2025-12-20.import.md
-- Source: docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf

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
  openingBalance: 0.82,
  active: true,
  notes: "Imported from 21 Nov 2025 - 20 Dec 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-12-20-nedbank-current",
  sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-12-20T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-12-20.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $cat_client_income = fn::createCategory({
  space: $space,
  key: "client-income",
  name: "Client income",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $cat_family_support = fn::createCategory({
  space: $space,
  key: "family-support",
  name: "Family support",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $cat_fees_overdraft_interest = fn::createCategory({
  space: $space,
  key: "fees-overdraft-interest",
  name: "Overdraft Interest",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $cat_fees_overdraft_facility_fee = fn::createCategory({
  space: $space,
  key: "fees-overdraft-facility-fee",
  name: "Overdraft Facility Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $cat_fees_payment_rail_fee = fn::createCategory({
  space: $space,
  key: "fees-payment-rail-fee",
  name: "Payment Rail Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $cat_fees_digital_statement_fee = fn::createCategory({
  space: $space,
  key: "fees-digital-statement-fee",
  name: "Digital Statement Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});

-- Merchant records
LET $merchant_nedbank_credit_card = fn::createMerchant({
  space: $space,
  key: "nedbank-credit-card",
  name: "Nedbank Credit Card",
  normalizedName: "Nedbank Credit Card",
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "MPIRE Digital Market",
  normalizedName: "MPIRE Digital Market",
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $merchant_lucky_isibaya = fn::createMerchant({
  space: $space,
  key: "lucky-isibaya",
  name: "Lucky Isibaya",
  normalizedName: "Lucky Isibaya",
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $merchant_basil_peters = fn::createMerchant({
  space: $space,
  key: "basil-peters",
  name: "Basil Peters",
  normalizedName: "Basil Peters",
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $merchant_nedbank_savings_account = fn::createMerchant({
  space: $space,
  key: "nedbank-savings-account",
  name: "Nedbank Savings Account",
  normalizedName: "Nedbank Savings Account",
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});
LET $merchant_wise_family_support = fn::createMerchant({
  space: $space,
  key: "wise-family-support",
  name: "Wise / Family Support",
  normalizedName: "Wise / Family Support",
  active: true,
  notes: "Imported from 2025-12-20.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-11-22T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 19000,
  balance: -18999.18,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 1,
    rawRowText: "CREDIT CRD - 4922130003088996; 19000.00; -18999.18",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 19000,
    bankChargeZar: null,
    balanceZar: -18999.18
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_12_20_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-11-22T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 19000,
  balance: -18999.18,
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_12_20_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_01.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_01.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-11-26T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2000,
  balance: -16999.18,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 2,
    rawRowText: "MPIRE DIGITAL MARKET; 2000.00; -16999.18",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: -16999.18
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_12_20_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-11-26T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2000,
  balance: -16999.18,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_12_20_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_02.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_02.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-11-26T00:00:00Z",
  description: "VAT 28/10-25/11 = R88.18-",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -16999.18,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 3,
    rawRowText: "VAT 28/10-25/11 = R88.18-; 0.00; -16999.18",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: -16999.18
},
  notes: "VAT summary row for bank charges period."
});
LET $tx_stmt_2025_12_20_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-11-26T00:00:00Z",
  description: "VAT 28/10-25/11 = R88.18-",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -16999.18,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_12_20_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_03.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_03.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-11-26T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -18999.18,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 4,
    rawRowText: "CREDIT CRD - 4922130003088996; 2000.00; -18999.18",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: -18999.18
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_12_20_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-11-26T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -18999.18,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_12_20_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_04.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_04.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-11-26T00:00:00Z",
  description: "INTEREST 28/10 - 25/11",
  normalizedDescription: "Overdraft Interest",
  amount: 123.7,
  balance: -19122.88,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 5,
    rawRowText: "INTEREST 28/10 - 25/11; 123.70; -19122.88",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft interest",
    clarificationStatus: "clarified",
    amountZar: 123.7,
    bankChargeZar: null,
    balanceZar: -19122.88
},
  notes: "Overdraft interest charge."
});
LET $tx_stmt_2025_12_20_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-11-26T00:00:00Z",
  description: "INTEREST 28/10 - 25/11",
  normalizedDescription: "Overdraft Interest",
  amount: 123.7,
  balance: -19122.88,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_12_20_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_05.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_05.id, "TransactionCategory", $cat_fees_overdraft_interest.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-11-26T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -19191.88,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 6,
    rawRowText: "Facility Fee; 69.00; -19191.88",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft facility fee",
    clarificationStatus: "clarified",
    amountZar: 69,
    bankChargeZar: null,
    balanceZar: -19191.88
},
  notes: "Overdraft facility fee."
});
LET $tx_stmt_2025_12_20_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-11-26T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -19191.88,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_12_20_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_06.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_06.id, "TransactionCategory", $cat_fees_overdraft_facility_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-11-26T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 55,
  balance: -19246.88,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 7,
    rawRowText: "MAINTENANCE FEE; 55.00; -19246.88",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "maintenance fee",
    clarificationStatus: "clarified",
    amountZar: 55,
    bankChargeZar: null,
    balanceZar: -19246.88
},
  notes: "Maintenance fee."
});
LET $tx_stmt_2025_12_20_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-11-26T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 55,
  balance: -19246.88,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_12_20_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_07.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_07.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-11-28T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 5000,
  balance: -14246.88,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 8,
    rawRowText: "MPIRE DIGITAL MARKET; 5000.00; -14246.88",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 5000,
    bankChargeZar: null,
    balanceZar: -14246.88
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_12_20_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-11-28T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 5000,
  balance: -14246.88,
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_12_20_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_08.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_08.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-11-28T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 4750,
  balance: -18996.88,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 9,
    rawRowText: "CREDIT CRD - 4922130003088996; 4750.00; -18996.88",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 4750,
    bankChargeZar: null,
    balanceZar: -18996.88
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_12_20_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-11-28T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 4750,
  balance: -18996.88,
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_12_20_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_09.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_09.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-12-03T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 30000,
  balance: 11003.12,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 10,
    rawRowText: "MPIRE DIGITAL MARKET; 30000.00; 11003.12",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 30000,
    bankChargeZar: null,
    balanceZar: 11003.12
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_12_20_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-12-03T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 30000,
  balance: 11003.12,
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_12_20_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_10.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_10.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-12-04T00:00:00Z",
  description: "Oz-Lucky Isibaya",
  normalizedDescription: "Lucky Isibaya",
  amount: 50,
  balance: 10953.12,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 11,
    rawRowText: "Oz-Lucky Isibaya; 50.00; 10953.12",
    transactionType: "income",
    normalizedMerchant: "Lucky Isibaya",
    category: "Client income",
    feeType: "payment rail fee",
    clarificationStatus: "clarified",
    amountZar: 50,
    bankChargeZar: 7.8,
    balanceZar: 10953.12
},
  notes: "Stage payment from Lucky Isibaya routed into the personal current account."
});
LET $tx_stmt_2025_12_20_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-12-04T00:00:00Z",
  description: "Oz-Lucky Isibaya",
  normalizedDescription: "Lucky Isibaya",
  amount: 50,
  balance: 10953.12,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Lucky Isibaya",
  merchant: $merchant_lucky_isibaya,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Stage payment from Lucky Isibaya routed into the personal current account."
});
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_12_20_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_11.id, "TransactionMerchant", $merchant_lucky_isibaya.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_11.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-12-06T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 10900,
  balance: 53.12,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 12,
    rawRowText: "CREDIT CRD - 4922130003088996; 10900.00; 53.12",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 10900,
    bankChargeZar: null,
    balanceZar: 53.12
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_12_20_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-12-06T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 10900,
  balance: 53.12,
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_12_20_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_12.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_12.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-12-08T00:00:00Z",
  description: "BASIL PETERS",
  normalizedDescription: "Basil Peters",
  amount: 10000,
  balance: 10053.12,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 13,
    rawRowText: "BASIL PETERS; 10000.00; 10053.12",
    transactionType: "income",
    normalizedMerchant: "Basil Peters",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 10000,
    bankChargeZar: null,
    balanceZar: 10053.12
},
  notes: "Family or owner-support transfer into the current account."
});
LET $tx_stmt_2025_12_20_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-12-08T00:00:00Z",
  description: "BASIL PETERS",
  normalizedDescription: "Basil Peters",
  amount: 10000,
  balance: 10053.12,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Basil Peters",
  merchant: $merchant_basil_peters,
  category: $cat_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Family or owner-support transfer into the current account."
});
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_12_20_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_13.id, "TransactionMerchant", $merchant_basil_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_13.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-12-08T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 19040,
  balance: -8986.88,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 14,
    rawRowText: "CREDIT CRD - 4922130003088996; 19040.00; -8986.88",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 19040,
    bankChargeZar: null,
    balanceZar: -8986.88
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_12_20_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-12-08T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 19040,
  balance: -8986.88,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_12_20_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_14.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_14.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-12-09T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 10000,
  balance: -18986.88,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 15,
    rawRowText: "CREDIT CRD - 4922130003088996; 10000.00; -18986.88",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 10000,
    bankChargeZar: null,
    balanceZar: -18986.88
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_12_20_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-12-09T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 10000,
  balance: -18986.88,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_12_20_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_15.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_15.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-12-09T00:00:00Z",
  description: "Digital Statement Fee",
  normalizedDescription: "Digital Statement Fee",
  amount: 11,
  balance: -18997.88,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 16,
    rawRowText: "Digital Statement Fee; 11.00; -18997.88",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "digital statement fee",
    clarificationStatus: "clarified",
    amountZar: 11,
    bankChargeZar: null,
    balanceZar: -18997.88
},
  notes: "Digital statement fee."
});
LET $tx_stmt_2025_12_20_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-12-09T00:00:00Z",
  description: "Digital Statement Fee",
  normalizedDescription: "Digital Statement Fee",
  amount: 11,
  balance: -18997.88,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_digital_statement_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Digital statement fee."
});
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_12_20_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_16.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_16.id, "TransactionCategory", $cat_fees_digital_statement_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-12-09T00:00:00Z",
  description: "Digital Statement Fee",
  normalizedDescription: "Digital Statement Fee",
  amount: 11,
  balance: -19008.88,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 17,
    rawRowText: "Digital Statement Fee; 11.00; -19008.88",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "digital statement fee",
    clarificationStatus: "clarified",
    amountZar: 11,
    bankChargeZar: null,
    balanceZar: -19008.88
},
  notes: "Digital statement fee."
});
LET $tx_stmt_2025_12_20_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-12-09T00:00:00Z",
  description: "Digital Statement Fee",
  normalizedDescription: "Digital Statement Fee",
  amount: 11,
  balance: -19008.88,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_digital_statement_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Digital statement fee."
});
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_12_20_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_17.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_17.id, "TransactionCategory", $cat_fees_digital_statement_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-12-11T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1000,
  balance: -18008.88,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 18,
    rawRowText: "MPIRE DIGITAL MARKET; 1000.00; -18008.88",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: -18008.88
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_12_20_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-12-11T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1000,
  balance: -18008.88,
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_12_20_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_18.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_18.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-12-12T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 5500,
  balance: -12508.88,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 19,
    rawRowText: "MPIRE DIGITAL MARKET; 5500.00; -12508.88",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 5500,
    bankChargeZar: null,
    balanceZar: -12508.88
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_12_20_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-12-12T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 5500,
  balance: -12508.88,
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
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_12_20_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_19.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_19.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-12-12T00:00:00Z",
  description: "SAVINGS AC - 2578012946",
  normalizedDescription: "Nedbank Savings Account",
  amount: 6490,
  balance: -18998.88,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 20,
    rawRowText: "SAVINGS AC - 2578012946; 6490.00; -18998.88",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Savings Account",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6490,
    bankChargeZar: null,
    balanceZar: -18998.88
},
  notes: "Transfer out from current to savings."
});
LET $tx_stmt_2025_12_20_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-12-12T00:00:00Z",
  description: "SAVINGS AC - 2578012946",
  normalizedDescription: "Nedbank Savings Account",
  amount: 6490,
  balance: -18998.88,
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
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_12_20_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_20.id, "TransactionMerchant", $merchant_nedbank_savings_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_20.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-12-13T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1000,
  balance: -17998.88,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 21,
    rawRowText: "MPIRE DIGITAL MARKET; 1000.00; -17998.88",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: -17998.88
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_12_20_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-12-13T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1000,
  balance: -17998.88,
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
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_12_20_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_21.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_21.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-12-15T00:00:00Z",
  description: "IP29C68BWISE PAYMENTS LIMITED",
  normalizedDescription: "Wise / Family Support",
  amount: 10163.35,
  balance: -7835.53,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 22,
    rawRowText: "IP29C68BWISE PAYMENTS LIMITED; 10163.35; -7835.53",
    transactionType: "income",
    normalizedMerchant: "Wise / Family Support",
    category: "Family support",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 10163.35,
    bankChargeZar: null,
    balanceZar: -7835.53
},
  notes: "Incoming support payment from overseas via Wise."
});
LET $tx_stmt_2025_12_20_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-12-15T00:00:00Z",
  description: "IP29C68BWISE PAYMENTS LIMITED",
  normalizedDescription: "Wise / Family Support",
  amount: 10163.35,
  balance: -7835.53,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Wise / Family Support",
  merchant: $merchant_wise_family_support,
  category: $cat_family_support,
  isTransfer: false,
  manualOverride: false,
  notes: "Incoming support payment from overseas via Wise."
});
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_12_20_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_22.id, "TransactionMerchant", $merchant_wise_family_support.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_22.id, "TransactionCategory", $cat_family_support.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-12-15T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 11160,
  balance: -18995.53,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Nov 2025 - 20 Dec 2025.pdf",
    statementPeriodStart: "2025-11-21",
    statementPeriodEnd: "2025-12-20",
    rowNo: 23,
    rawRowText: "CREDIT CRD - 4922130003088996; 11160.00; -18995.53",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 11160,
    bankChargeZar: null,
    balanceZar: -18995.53
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_12_20_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-20-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-12-15T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 11160,
  balance: -18995.53,
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_12_20_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_12_20_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_20_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_23.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_20_row_23.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 23,
  normalizedCount: 23,
  clarificationCount: 0,
  status: "matched",
  statementDate: "2025-12-20T00:00:00Z",
  notes: "Imported from 2025-12-20.import.md"
});

-- End of generated import
