-- Generated from docs/statements/personal/current/2025-11-21.import.md
-- Source: docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf

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
  openingBalance: 18999.82,
  active: true,
  notes: "Imported from 21 Oct 2025 - 21 Nov 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-11-21-nedbank-current",
  sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-11-21T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-11-21.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $cat_fees_overdraft_interest = fn::createCategory({
  space: $space,
  key: "fees-overdraft-interest",
  name: "Overdraft Interest",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $cat_fees_overdraft_facility_fee = fn::createCategory({
  space: $space,
  key: "fees-overdraft-facility-fee",
  name: "Overdraft Facility Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});

-- Merchant records
LET $merchant_service_fee_reversal = fn::createMerchant({
  space: $space,
  key: "service-fee-reversal",
  name: "Service Fee Reversal",
  normalizedName: "Service Fee Reversal",
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $merchant_service_fee_26_09_27_10 = fn::createMerchant({
  space: $space,
  key: "service-fee-26-09-27-10",
  name: "SERVICE FEE 26/09 - 27/10",
  normalizedName: "SERVICE FEE 26/09 - 27/10",
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "MPIRE Digital Market",
  normalizedName: "MPIRE Digital Market",
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $merchant_nedbank_savings_account = fn::createMerchant({
  space: $space,
  key: "nedbank-savings-account",
  name: "Nedbank Savings Account",
  normalizedName: "Nedbank Savings Account",
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $merchant_nedbank_credit_card = fn::createMerchant({
  space: $space,
  key: "nedbank-credit-card",
  name: "Nedbank Credit Card",
  normalizedName: "Nedbank Credit Card",
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $merchant_basil_peters = fn::createMerchant({
  space: $space,
  key: "basil-peters",
  name: "Basil Peters",
  normalizedName: "Basil Peters",
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $merchant_transfer = fn::createMerchant({
  space: $space,
  key: "transfer",
  name: "transfer",
  normalizedName: "transfer",
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});
LET $merchant_debit_rate_decreased_to_11_25 = fn::createMerchant({
  space: $space,
  key: "debit-rate-decreased-to-11-25",
  name: "DEBIT RATE DECREASED TO 11,25%",
  normalizedName: "DEBIT RATE DECREASED TO 11,25%",
  active: true,
  notes: "Imported from 2025-11-21.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-10-28T00:00:00Z",
  description: "Service Fee Reversal",
  normalizedDescription: "Service Fee Reversal",
  amount: 800,
  balance: -18199.82,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 1,
    rawRowText: "Service Fee Reversal; 800.00; -18199.82",
    transactionType: "expense",
    normalizedMerchant: "Service Fee Reversal",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 800,
    bankChargeZar: null,
    balanceZar: -18199.82
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_11_21_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-10-28T00:00:00Z",
  description: "Service Fee Reversal",
  normalizedDescription: "Service Fee Reversal",
  amount: 800,
  balance: -18199.82,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Service Fee Reversal",
  merchant: $merchant_service_fee_reversal,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_11_21_row_01.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_01.id, "TransactionMerchant", $merchant_service_fee_reversal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_01.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_21_row_01 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-21-row-01",
  transaction: $tx_stmt_2025_11_21_row_01,
  status: "open",
  question: "What exactly is the Magtape Unpaid / Not Provided For reversal?",
  reason: "Returned item / reversal needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_service_fee_reversal,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-11-21.import.md"
});
fn::createEdge($tx_stmt_2025_11_21_row_01.id, "TransactionClarificationTasks", $task_stmt_2025_11_21_row_01.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-10-28T00:00:00Z",
  description: "VAT 26/09-27/10 = R120.53",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -18199.82,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 2,
    rawRowText: "VAT 26/09-27/10 = R120.53; 0.00; -18199.82",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: -18199.82
},
  notes: "VAT summary row for bank charges period."
});
LET $tx_stmt_2025_11_21_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-10-28T00:00:00Z",
  description: "VAT 26/09-27/10 = R120.53",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -18199.82,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_11_21_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_02.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_02.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-10-28T00:00:00Z",
  description: "INTEREST 26/09 - 27/10",
  normalizedDescription: "Overdraft Interest",
  amount: 182.36,
  balance: -18382.18,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 3,
    rawRowText: "INTEREST 26/09 - 27/10; 182.36; -18382.18",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft interest",
    clarificationStatus: "clarified",
    amountZar: 182.36,
    bankChargeZar: null,
    balanceZar: -18382.18
},
  notes: "Overdraft interest charge."
});
LET $tx_stmt_2025_11_21_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-10-28T00:00:00Z",
  description: "INTEREST 26/09 - 27/10",
  normalizedDescription: "Overdraft Interest",
  amount: 182.36,
  balance: -18382.18,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_11_21_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_03.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_03.id, "TransactionCategory", $cat_fees_overdraft_interest.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-10-28T00:00:00Z",
  description: "SERVICE FEE 26/09 - 27/10",
  normalizedDescription: "SERVICE FEE 26/09 - 27/10",
  amount: 800,
  balance: -19182.18,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 4,
    rawRowText: "SERVICE FEE 26/09 - 27/10; 800.00; -19182.18",
    transactionType: "expense",
    normalizedMerchant: "SERVICE FEE 26/09 - 27/10",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 800,
    bankChargeZar: null,
    balanceZar: -19182.18
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_11_21_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-10-28T00:00:00Z",
  description: "SERVICE FEE 26/09 - 27/10",
  normalizedDescription: "SERVICE FEE 26/09 - 27/10",
  amount: 800,
  balance: -19182.18,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "SERVICE FEE 26/09 - 27/10",
  merchant: $merchant_service_fee_26_09_27_10,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_11_21_row_04.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_04.id, "TransactionMerchant", $merchant_service_fee_26_09_27_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_04.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_21_row_04 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-21-row-04",
  transaction: $tx_stmt_2025_11_21_row_04,
  status: "open",
  question: "What is the exact purpose of this SERVICE FEE 26/09 - 27/10 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_service_fee_26_09_27_10,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-11-21.import.md"
});
fn::createEdge($tx_stmt_2025_11_21_row_04.id, "TransactionClarificationTasks", $task_stmt_2025_11_21_row_04.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-10-28T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -19251.18,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 5,
    rawRowText: "Facility Fee; 69.00; -19251.18",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft facility fee",
    clarificationStatus: "clarified",
    amountZar: 69,
    bankChargeZar: null,
    balanceZar: -19251.18
},
  notes: "Overdraft facility fee."
});
LET $tx_stmt_2025_11_21_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-10-28T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -19251.18,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_11_21_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_05.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_05.id, "TransactionCategory", $cat_fees_overdraft_facility_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-10-28T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 55,
  balance: -19306.18,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 6,
    rawRowText: "MAINTENANCE FEE; 55.00; -19306.18",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "maintenance fee",
    clarificationStatus: "clarified",
    amountZar: 55,
    bankChargeZar: null,
    balanceZar: -19306.18
},
  notes: "Maintenance fee."
});
LET $tx_stmt_2025_11_21_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-10-28T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 55,
  balance: -19306.18,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_11_21_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_06.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_06.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-10-29T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 4000,
  balance: -15306.18,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 7,
    rawRowText: "MPIRE DIGITAL MARKET; 4000.00; -15306.18",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 4000,
    bankChargeZar: null,
    balanceZar: -15306.18
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_11_21_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-10-29T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 4000,
  balance: -15306.18,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_11_21_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_07.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_07.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-10-29T00:00:00Z",
  description: "SAVINGS AC - 2578012946",
  normalizedDescription: "Nedbank Savings Account",
  amount: 70,
  balance: -15376.18,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 8,
    rawRowText: "SAVINGS AC - 2578012946; 70.00; -15376.18",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Savings Account",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 70,
    bankChargeZar: null,
    balanceZar: -15376.18
},
  notes: "Transfer out from current to savings."
});
LET $tx_stmt_2025_11_21_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-10-29T00:00:00Z",
  description: "SAVINGS AC - 2578012946",
  normalizedDescription: "Nedbank Savings Account",
  amount: 70,
  balance: -15376.18,
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_11_21_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_08.id, "TransactionMerchant", $merchant_nedbank_savings_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_08.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-10-29T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 3623,
  balance: -18999.18,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 9,
    rawRowText: "CREDIT CRD - 4922130003088996; 3623.00; -18999.18",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 3623,
    bankChargeZar: null,
    balanceZar: -18999.18
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_11_21_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-10-29T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 3623,
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_11_21_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_09.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_09.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-10-29T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 5000,
  balance: -13999.18,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 10,
    rawRowText: "MPIRE DIGITAL MARKET; 5000.00; -13999.18",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 5000,
    bankChargeZar: null,
    balanceZar: -13999.18
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_11_21_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-10-29T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 5000,
  balance: -13999.18,
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_11_21_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_10.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_10.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-10-30T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1500,
  balance: -12499.18,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 11,
    rawRowText: "MPIRE DIGITAL MARKET; 1500.00; -12499.18",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1500,
    bankChargeZar: null,
    balanceZar: -12499.18
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_11_21_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-10-30T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1500,
  balance: -12499.18,
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_11_21_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_11.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_11.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-10-30T00:00:00Z",
  description: "BASIL PETERS",
  normalizedDescription: "Basil Peters",
  amount: 36000,
  balance: 23500.82,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 12,
    rawRowText: "BASIL PETERS; 36000.00; 23500.82",
    transactionType: "income",
    normalizedMerchant: "Basil Peters",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 36000,
    bankChargeZar: null,
    balanceZar: 23500.82
},
  notes: "Family or owner-support transfer into the current account."
});
LET $tx_stmt_2025_11_21_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-10-30T00:00:00Z",
  description: "BASIL PETERS",
  normalizedDescription: "Basil Peters",
  amount: 36000,
  balance: 23500.82,
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_11_21_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_12.id, "TransactionMerchant", $merchant_basil_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_12.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-10-30T00:00:00Z",
  description: "transfer",
  normalizedDescription: "transfer",
  amount: 5000,
  balance: 18500.82,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 13,
    rawRowText: "transfer; 5000.00; 18500.82",
    transactionType: "expense",
    normalizedMerchant: "transfer",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 5000,
    bankChargeZar: null,
    balanceZar: 18500.82
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_11_21_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-10-30T00:00:00Z",
  description: "transfer",
  normalizedDescription: "transfer",
  amount: 5000,
  balance: 18500.82,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "transfer",
  merchant: $merchant_transfer,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_11_21_row_13.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_13.id, "TransactionMerchant", $merchant_transfer.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_13.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_21_row_13 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-21-row-13",
  transaction: $tx_stmt_2025_11_21_row_13,
  status: "open",
  question: "What is the exact purpose of this transfer transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_transfer,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-11-21.import.md"
});
fn::createEdge($tx_stmt_2025_11_21_row_13.id, "TransactionClarificationTasks", $task_stmt_2025_11_21_row_13.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-10-31T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 37500,
  balance: -18999.18,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 14,
    rawRowText: "CREDIT CRD - 4922130003088996; 37500.00; -18999.18",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 37500,
    bankChargeZar: null,
    balanceZar: -18999.18
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_11_21_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-10-31T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 37500,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_11_21_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_14.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_14.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-11-15T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 50000,
  balance: 31000.82,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 15,
    rawRowText: "MPIRE DIGITAL MARKET; 50000.00; 31000.82",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 50000,
    bankChargeZar: null,
    balanceZar: 31000.82
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_11_21_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-11-15T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 50000,
  balance: 31000.82,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_11_21_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_15.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_15.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-11-17T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 31000,
  balance: 0.82,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 16,
    rawRowText: "CREDIT CRD - 4922130003088996; 31000.00; 0.82",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 31000,
    bankChargeZar: null,
    balanceZar: 0.82
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_11_21_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-11-17T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 31000,
  balance: 0.82,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_11_21_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_16.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_16.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-11-21T00:00:00Z",
  description: "DEBIT RATE DECREASED TO 11,25%",
  normalizedDescription: "DEBIT RATE DECREASED TO 11,25%",
  amount: 0,
  balance: 0.82,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Oct 2025 - 21 Nov 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-21",
    rowNo: 17,
    rawRowText: "DEBIT RATE DECREASED TO 11,25%; 0.00; 0.82",
    transactionType: "expense",
    normalizedMerchant: "DEBIT RATE DECREASED TO 11,25%",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: 0.82
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_11_21_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-21-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-11-21T00:00:00Z",
  description: "DEBIT RATE DECREASED TO 11,25%",
  normalizedDescription: "DEBIT RATE DECREASED TO 11,25%",
  amount: 0,
  balance: 0.82,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "DEBIT RATE DECREASED TO 11,25%",
  merchant: $merchant_debit_rate_decreased_to_11_25,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_11_21_row_17.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_11_21_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_21_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_17.id, "TransactionMerchant", $merchant_debit_rate_decreased_to_11_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_21_row_17.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_21_row_17 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-21-row-17",
  transaction: $tx_stmt_2025_11_21_row_17,
  status: "open",
  question: "What is the exact purpose of this DEBIT RATE DECREASED TO 11,25% transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_debit_rate_decreased_to_11_25,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-11-21.import.md"
});
fn::createEdge($tx_stmt_2025_11_21_row_17.id, "TransactionClarificationTasks", $task_stmt_2025_11_21_row_17.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 17,
  normalizedCount: 17,
  clarificationCount: 4,
  status: "matched",
  statementDate: "2025-11-21T00:00:00Z",
  notes: "Imported from 2025-11-21.import.md"
});

-- End of generated import
