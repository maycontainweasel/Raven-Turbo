-- Generated from docs/statements/personal/current/2025-05-21.import.md
-- Source: docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf

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
  openingBalance: 18905.07,
  active: true,
  notes: "Imported from 19 Apr 2025 - 21 May 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-05-21-nedbank-current",
  sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-05-21T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-05-21.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});
LET $cat_fees_overdraft_interest = fn::createCategory({
  space: $space,
  key: "fees-overdraft-interest",
  name: "Overdraft Interest",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});
LET $cat_fees_overdraft_facility_fee = fn::createCategory({
  space: $space,
  key: "fees-overdraft-facility-fee",
  name: "Overdraft Facility Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});

-- Merchant records
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "MPIRE Digital Market",
  normalizedName: "MPIRE Digital Market",
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});
LET $merchant_nedbank_credit_card = fn::createMerchant({
  space: $space,
  key: "nedbank-credit-card",
  name: "Nedbank Credit Card",
  normalizedName: "Nedbank Credit Card",
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});
LET $merchant_service_fee_27_03_24_04 = fn::createMerchant({
  space: $space,
  key: "service-fee-27-03-24-04",
  name: "SERVICE FEE 27/03 - 24/04",
  normalizedName: "SERVICE FEE 27/03 - 24/04",
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});
LET $merchant_a_p_o_payment_5898460810785253 = fn::createMerchant({
  space: $space,
  key: "a-p-o-payment-5898460810785253",
  name: "A P O PAYMENT 5898460810785253",
  normalizedName: "A P O PAYMENT 5898460810785253",
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});
LET $merchant_no_funds_alert_sms_fee = fn::createMerchant({
  space: $space,
  key: "no-funds-alert-sms-fee",
  name: "No funds alert SMS fee",
  normalizedName: "No funds alert SMS fee",
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});
LET $merchant_transfer = fn::createMerchant({
  space: $space,
  key: "transfer",
  name: "transfer",
  normalizedName: "transfer",
  active: true,
  notes: "Imported from 2025-05-21.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-04-22T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2100,
  balance: -16805.07,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 1,
    rawRowText: "MPIRE DIGITAL MARKET; 2100.00; -16805.07",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2100,
    bankChargeZar: null,
    balanceZar: -16805.07
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_05_21_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-04-22T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2100,
  balance: -16805.07,
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_05_21_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_01.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_01.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-04-22T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2190,
  balance: -18995.07,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 2,
    rawRowText: "CREDIT CRD - 4922130003088996; 2190.00; -18995.07",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2190,
    bankChargeZar: null,
    balanceZar: -18995.07
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_05_21_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-04-22T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2190,
  balance: -18995.07,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_05_21_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_02.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_02.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-04-25T00:00:00Z",
  description: "VAT 27/03-24/04 = R18.12",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -18995.07,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 3,
    rawRowText: "VAT 27/03-24/04 = R18.12; 0.00; -18995.07",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: -18995.07
},
  notes: "VAT summary row for bank charges period."
});
LET $tx_stmt_2025_05_21_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-04-25T00:00:00Z",
  description: "VAT 27/03-24/04 = R18.12",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -18995.07,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_05_21_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_03.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_03.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-04-25T00:00:00Z",
  description: "INTEREST 27/03 - 24/04",
  normalizedDescription: "Overdraft Interest",
  amount: 181.14,
  balance: -19176.21,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 4,
    rawRowText: "INTEREST 27/03 - 24/04; 181.14; -19176.21",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft interest",
    clarificationStatus: "clarified",
    amountZar: 181.14,
    bankChargeZar: null,
    balanceZar: -19176.21
},
  notes: "Overdraft interest charge."
});
LET $tx_stmt_2025_05_21_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-04-25T00:00:00Z",
  description: "INTEREST 27/03 - 24/04",
  normalizedDescription: "Overdraft Interest",
  amount: 181.14,
  balance: -19176.21,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_05_21_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_04.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_04.id, "TransactionCategory", $cat_fees_overdraft_interest.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-04-25T00:00:00Z",
  description: "SERVICE FEE 27/03 - 24/04",
  normalizedDescription: "SERVICE FEE 27/03 - 24/04",
  amount: 5,
  balance: -19181.21,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 5,
    rawRowText: "SERVICE FEE 27/03 - 24/04; 5.00; -19181.21",
    transactionType: "expense",
    normalizedMerchant: "SERVICE FEE 27/03 - 24/04",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 5,
    bankChargeZar: null,
    balanceZar: -19181.21
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_05_21_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-04-25T00:00:00Z",
  description: "SERVICE FEE 27/03 - 24/04",
  normalizedDescription: "SERVICE FEE 27/03 - 24/04",
  amount: 5,
  balance: -19181.21,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "SERVICE FEE 27/03 - 24/04",
  merchant: $merchant_service_fee_27_03_24_04,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_05_21_row_05.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_05.id, "TransactionMerchant", $merchant_service_fee_27_03_24_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_05.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_05_21_row_05 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-05-21-row-05",
  transaction: $tx_stmt_2025_05_21_row_05,
  status: "open",
  question: "What is the exact purpose of this SERVICE FEE 27/03 - 24/04 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_service_fee_27_03_24_04,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-05-21.import.md"
});
fn::createEdge($tx_stmt_2025_05_21_row_05.id, "TransactionClarificationTasks", $task_stmt_2025_05_21_row_05.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-04-25T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -19250.21,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 6,
    rawRowText: "Facility Fee; 69.00; -19250.21",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft facility fee",
    clarificationStatus: "clarified",
    amountZar: 69,
    bankChargeZar: null,
    balanceZar: -19250.21
},
  notes: "Overdraft facility fee."
});
LET $tx_stmt_2025_05_21_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-04-25T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -19250.21,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_05_21_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_06.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_06.id, "TransactionCategory", $cat_fees_overdraft_facility_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-04-25T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 55,
  balance: -19305.21,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 7,
    rawRowText: "MAINTENANCE FEE; 55.00; -19305.21",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "maintenance fee",
    clarificationStatus: "clarified",
    amountZar: 55,
    bankChargeZar: null,
    balanceZar: -19305.21
},
  notes: "Maintenance fee."
});
LET $tx_stmt_2025_05_21_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-04-25T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 55,
  balance: -19305.21,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_05_21_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_07.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_07.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-04-26T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1250,
  balance: -18055.21,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 8,
    rawRowText: "MPIRE DIGITAL MARKET; 1250.00; -18055.21",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1250,
    bankChargeZar: null,
    balanceZar: -18055.21
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_05_21_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-04-26T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1250,
  balance: -18055.21,
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_05_21_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_08.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_08.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-04-29T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 944,
  balance: -18999.21,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 9,
    rawRowText: "CREDIT CRD - 4922130003088996; 944.00; -18999.21",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 944,
    bankChargeZar: null,
    balanceZar: -18999.21
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_05_21_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-04-29T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 944,
  balance: -18999.21,
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_05_21_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_09.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_09.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-04-30T00:00:00Z",
  description: "A P O PAYMENT 5898460810785253",
  normalizedDescription: "A P O PAYMENT 5898460810785253",
  amount: 2326,
  balance: -21325.21,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 10,
    rawRowText: "A P O PAYMENT 5898460810785253; 2326.00; -21325.21",
    transactionType: "expense",
    normalizedMerchant: "A P O PAYMENT 5898460810785253",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 2326,
    bankChargeZar: 5,
    balanceZar: -21325.21
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_05_21_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-04-30T00:00:00Z",
  description: "A P O PAYMENT 5898460810785253",
  normalizedDescription: "A P O PAYMENT 5898460810785253",
  amount: 2326,
  balance: -21325.21,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "A P O PAYMENT 5898460810785253",
  merchant: $merchant_a_p_o_payment_5898460810785253,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_05_21_row_10.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_10.id, "TransactionMerchant", $merchant_a_p_o_payment_5898460810785253.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_10.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_05_21_row_10 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-05-21-row-10",
  transaction: $tx_stmt_2025_05_21_row_10,
  status: "open",
  question: "What is the exact purpose of this A P O PAYMENT 5898460810785253 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_a_p_o_payment_5898460810785253,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-05-21.import.md"
});
fn::createEdge($tx_stmt_2025_05_21_row_10.id, "TransactionClarificationTasks", $task_stmt_2025_05_21_row_10.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-05-02T00:00:00Z",
  description: "No funds alert SMS fee",
  normalizedDescription: "No funds alert SMS fee",
  amount: 10,
  balance: -21335.21,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 11,
    rawRowText: "No funds alert SMS fee; 10.00; -21335.21",
    transactionType: "expense",
    normalizedMerchant: "No funds alert SMS fee",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 10,
    bankChargeZar: null,
    balanceZar: -21335.21
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_05_21_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-05-02T00:00:00Z",
  description: "No funds alert SMS fee",
  normalizedDescription: "No funds alert SMS fee",
  amount: 10,
  balance: -21335.21,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "No funds alert SMS fee",
  merchant: $merchant_no_funds_alert_sms_fee,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_05_21_row_11.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_11.id, "TransactionMerchant", $merchant_no_funds_alert_sms_fee.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_11.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_05_21_row_11 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-05-21-row-11",
  transaction: $tx_stmt_2025_05_21_row_11,
  status: "open",
  question: "What is the exact purpose of this No funds alert SMS fee transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_no_funds_alert_sms_fee,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-05-21.import.md"
});
fn::createEdge($tx_stmt_2025_05_21_row_11.id, "TransactionClarificationTasks", $task_stmt_2025_05_21_row_11.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-05-02T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 12500,
  balance: -8835.21,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 12,
    rawRowText: "MPIRE DIGITAL MARKET; 12500.00; -8835.21",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 12500,
    bankChargeZar: null,
    balanceZar: -8835.21
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_05_21_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-05-02T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 12500,
  balance: -8835.21,
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_05_21_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_12.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_12.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-05-02T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 6000,
  balance: -2835.21,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 13,
    rawRowText: "MPIRE DIGITAL MARKET; 6000.00; -2835.21",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6000,
    bankChargeZar: null,
    balanceZar: -2835.21
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_05_21_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-05-02T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 6000,
  balance: -2835.21,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_05_21_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_13.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_13.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-05-02T00:00:00Z",
  description: "transfer",
  normalizedDescription: "transfer",
  amount: 3650,
  balance: -6485.21,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 14,
    rawRowText: "transfer; 3650.00; -6485.21",
    transactionType: "expense",
    normalizedMerchant: "transfer",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 3650,
    bankChargeZar: null,
    balanceZar: -6485.21
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_05_21_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-05-02T00:00:00Z",
  description: "transfer",
  normalizedDescription: "transfer",
  amount: 3650,
  balance: -6485.21,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_05_21_row_14.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_14.id, "TransactionMerchant", $merchant_transfer.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_14.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_05_21_row_14 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-05-21-row-14",
  transaction: $tx_stmt_2025_05_21_row_14,
  status: "open",
  question: "What is the exact purpose of this transfer transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_transfer,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-05-21.import.md"
});
fn::createEdge($tx_stmt_2025_05_21_row_14.id, "TransactionClarificationTasks", $task_stmt_2025_05_21_row_14.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-05-05T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 12500,
  balance: -18985.21,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 15,
    rawRowText: "CREDIT CRD - 4922130003088996; 12500.00; -18985.21",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 12500,
    bankChargeZar: null,
    balanceZar: -18985.21
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_05_21_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-05-05T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 12500,
  balance: -18985.21,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_05_21_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_15.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_15.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-05-08T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2000,
  balance: -16985.21,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 16,
    rawRowText: "MPIRE DIGITAL MARKET; 2000.00; -16985.21",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: -16985.21
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_05_21_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-05-08T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2000,
  balance: -16985.21,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_05_21_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_16.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_16.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-05-08T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -18985.21,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 17,
    rawRowText: "CREDIT CRD - 4922130003088996; 2000.00; -18985.21",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: -18985.21
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_05_21_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-05-08T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -18985.21,
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_05_21_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_17.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_17.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-05-10T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1250,
  balance: -17735.21,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 18,
    rawRowText: "MPIRE DIGITAL MARKET; 1250.00; -17735.21",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1250,
    bankChargeZar: null,
    balanceZar: -17735.21
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_05_21_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-05-10T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1250,
  balance: -17735.21,
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_05_21_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_18.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_18.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-05-10T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1260,
  balance: -18995.21,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 19,
    rawRowText: "CREDIT CRD - 4922130003088996; 1260.00; -18995.21",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1260,
    bankChargeZar: null,
    balanceZar: -18995.21
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_05_21_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-05-10T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1260,
  balance: -18995.21,
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
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_05_21_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_19.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_19.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-05-19T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 200,
  balance: -18795.21,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 20,
    rawRowText: "MPIRE DIGITAL MARKET; 200.00; -18795.21",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 200,
    bankChargeZar: null,
    balanceZar: -18795.21
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_05_21_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-05-19T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 200,
  balance: -18795.21,
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
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_05_21_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_20.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_20.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-05-19T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 204,
  balance: -18999.21,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 21,
    rawRowText: "CREDIT CRD - 4922130003088996; 204.00; -18999.21",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 204,
    bankChargeZar: null,
    balanceZar: -18999.21
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_05_21_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-05-19T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 204,
  balance: -18999.21,
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
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_05_21_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_21.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_21.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-05-20T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1000,
  balance: -17999.21,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 22,
    rawRowText: "MPIRE DIGITAL MARKET; 1000.00; -17999.21",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: -17999.21
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_05_21_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-05-20T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1000,
  balance: -17999.21,
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
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_05_21_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_22.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_22.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-05-20T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1000,
  balance: -18999.21,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/19 Apr 2025 - 21 May 2025.pdf",
    statementPeriodStart: "2025-04-19",
    statementPeriodEnd: "2025-05-21",
    rowNo: 23,
    rawRowText: "CREDIT CRD - 4922130003088996; 1000.00; -18999.21",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: -18999.21
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_05_21_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-21-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-05-20T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1000,
  balance: -18999.21,
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_05_21_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_05_21_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_21_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_23.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_21_row_23.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 23,
  normalizedCount: 23,
  clarificationCount: 4,
  status: "matched",
  statementDate: "2025-05-21T00:00:00Z",
  notes: "Imported from 2025-05-21.import.md"
});

-- End of generated import
