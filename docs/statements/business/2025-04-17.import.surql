-- Generated from docs/statements/business/2025-04-17.import.md
-- Source: docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf

USE NS raven DB raven1;

-- Base environment and account
LET $space = fn::createFinancialSpace({
  key: "mpire-business",
  name: "MPIRE Business",
  spaceType: "business",
  currency: "ZAR",
  active: true,
  description: "Business banking environment for MPIRE"
});
LET $account = fn::createAccount({
  space: $space,
  key: "fnb-gold-business-27821",
  name: "FNB Gold Business Account",
  bankName: "FNB",
  accountType: "current",
  currency: "ZAR",
  accountNumberLast4: "27821",
  openingBalance: 0,
  active: true,
  notes: "Imported from GOLD_BUSINESS_ACCOUNT_78.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-04-17-fnb-gold-business-27821",
  sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-04-17T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $cat_client_income = fn::createCategory({
  space: $space,
  key: "client-income",
  name: "Client income",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $cat_internal_transfer = fn::createCategory({
  space: $space,
  key: "internal-transfer",
  name: "Internal transfer",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $cat_insurance = fn::createCategory({
  space: $space,
  key: "insurance",
  name: "Insurance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $cat_software_saas = fn::createCategory({
  space: $space,
  key: "software-saas",
  name: "Software / SaaS",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $cat_fees_bank_fee = fn::createCategory({
  space: $space,
  key: "fees-bank-fee",
  name: "Bank Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $cat_fees_card_charge = fn::createCategory({
  space: $space,
  key: "fees-card-charge",
  name: "Card Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $cat_fees_debit_interest = fn::createCategory({
  space: $space,
  key: "fees-debit-interest",
  name: "Debit Interest",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});

-- Merchant records
LET $merchant_fnb = fn::createMerchant({
  space: $space,
  key: "fnb",
  name: "FNB",
  normalizedName: "FNB",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $merchant_sansor = fn::createMerchant({
  space: $space,
  key: "sansor",
  name: "Sansor",
  normalizedName: "Sansor",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "Mpire Digital Market",
  normalizedName: "Mpire Digital Market",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $merchant_pos_purchase_23_00_openai_chatg_485442_7050_28_mar = fn::createMerchant({
  space: $space,
  key: "pos-purchase-23-00-openai-chatg-485442-7050-28-mar",
  name: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 Mar",
  normalizedName: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 Mar",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $merchant_outsurance = fn::createMerchant({
  space: $space,
  key: "outsurance",
  name: "Outsurance",
  normalizedName: "Outsurance",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $merchant_cursor = fn::createMerchant({
  space: $space,
  key: "cursor",
  name: "Cursor",
  normalizedName: "Cursor",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $merchant_inward_swift_r025vrj4s0_altra_care_limited = fn::createMerchant({
  space: $space,
  key: "inward-swift-r025vrj4s0-altra-care-limited",
  name: "Inward Swift R025Vrj4S0 Altra Care Limited",
  normalizedName: "Inward Swift R025Vrj4S0 Altra Care Limited",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $merchant_internet_pmt_to_laptop_loan_payment_mpire_loan_repayment = fn::createMerchant({
  space: $space,
  key: "internet-pmt-to-laptop-loan-payment-mpire-loan-repayment",
  name: "Internet Pmt To Laptop Loan Payment Mpire Loan Repayment",
  normalizedName: "Internet Pmt To Laptop Loan Payment Mpire Loan Repayment",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $merchant_magtape_credit = fn::createMerchant({
  space: $space,
  key: "magtape-credit",
  name: "Magtape Credit",
  normalizedName: "Magtape Credit",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $merchant_notion = fn::createMerchant({
  space: $space,
  key: "notion",
  name: "Notion",
  normalizedName: "Notion",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $merchant_internet_pmt_to_accounting_fees_mpire_digital_inv106 = fn::createMerchant({
  space: $space,
  key: "internet-pmt-to-accounting-fees-mpire-digital-inv106",
  name: "Internet Pmt To Accounting Fees Mpire Digital Inv106",
  normalizedName: "Internet Pmt To Accounting Fees Mpire Digital Inv106",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $merchant_internet_pmt_to_nectar_esta_stage_1_mpire_digital_esta_v = fn::createMerchant({
  space: $space,
  key: "internet-pmt-to-nectar-esta-stage-1-mpire-digital-esta-v",
  name: "Internet Pmt To Nectar: Esta Stage 1 Mpire Digital:Esta V",
  normalizedName: "Internet Pmt To Nectar: Esta Stage 1 Mpire Digital:Esta V",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $merchant_paypal = fn::createMerchant({
  space: $space,
  key: "paypal",
  name: "PayPal",
  normalizedName: "PayPal",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});
LET $merchant_0_00 = fn::createMerchant({
  space: $space,
  key: "0-00",
  name: "0.00",
  normalizedName: "0.00",
  active: true,
  notes: "Imported from 2025-04-17.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-03-19T00:00:00Z",
  description: "13.86",
  normalizedDescription: "Bank Fee",
  amount: 13.86,
  balance: 89.07,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 1,
    rawRowText: "13.86; 89.07",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 13.86,
    bankChargeZar: null,
    balanceZar: 89.07
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-03-19T00:00:00Z",
  description: "13.86",
  normalizedDescription: "Bank Fee",
  amount: 13.86,
  balance: 89.07,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_04_17_row_01.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_01.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_01.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_01 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-01",
  transaction: $tx_stmt_2025_04_17_row_01,
  status: "open",
  question: "What exactly is the Magtape Unpaid / Not Provided For reversal?",
  reason: "Returned item / reversal needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_01.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_01.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-03-24T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 95.07,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 2,
    rawRowText: "6.00; 95.07",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 95.07
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-03-24T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 95.07,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_04_17_row_02.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_02.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_02.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_02 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-02",
  transaction: $tx_stmt_2025_04_17_row_02,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_02.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_02.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-03-27T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 101.07,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 3,
    rawRowText: "6.00; 101.07",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 101.07
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-03-27T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 101.07,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_04_17_row_03.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_03.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_03.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_03 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-03",
  transaction: $tx_stmt_2025_04_17_row_03,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_03.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_03.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-03-27T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 107.07,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 4,
    rawRowText: "6.00; 107.07",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 107.07
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-03-27T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 107.07,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_04_17_row_04.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_04.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_04.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_04 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-04",
  transaction: $tx_stmt_2025_04_17_row_04,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_04.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_04.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-03-28T00:00:00Z",
  description: "FNB OB Pmt Sansor",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 6742.93,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 5,
    rawRowText: "FNB OB Pmt Sansor; 6,850.00 Cr; 6,742.93 Cr",
    transactionType: "income",
    normalizedMerchant: "Sansor",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6850,
    bankChargeZar: null,
    balanceZar: 6742.93
},
  notes: "Recurring client payment from Sansor."
});
LET $tx_stmt_2025_04_17_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-03-28T00:00:00Z",
  description: "FNB OB Pmt Sansor",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 6742.93,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Sansor",
  merchant: $merchant_sansor,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Recurring client payment from Sansor."
});
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_04_17_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_05.id, "TransactionMerchant", $merchant_sansor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_05.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-03-28T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 2500,
  balance: 4242.93,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 6,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 2,500.00; 4,242.93 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 2500,
    bankChargeZar: 8,
    balanceZar: 4242.93
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_04_17_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-03-28T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 2500,
  balance: 4242.93,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Mpire Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_internal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_04_17_row_06.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_06.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_06.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_06 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-06",
  transaction: $tx_stmt_2025_04_17_row_06,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_06.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_06.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-03-28T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 4236.93,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 7,
    rawRowText: "6.00; 4,236.93 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 4236.93
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-03-28T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 4236.93,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_04_17_row_07.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_07.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_07.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_07 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-07",
  transaction: $tx_stmt_2025_04_17_row_07,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_07.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_07.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-03-28T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 4230.93,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 8,
    rawRowText: "6.00; 4,230.93 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 4230.93
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-03-28T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 4230.93,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_04_17_row_08.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_08.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_08.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_08 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-08",
  transaction: $tx_stmt_2025_04_17_row_08,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_08.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_08.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-03-31T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 1000,
  balance: 3230.93,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 9,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 1,000.00; 3,230.93 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1000,
    bankChargeZar: 8,
    balanceZar: 3230.93
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_04_17_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-03-31T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 1000,
  balance: 3230.93,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Mpire Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_internal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_04_17_row_09.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_09.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_09.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_09 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-09",
  transaction: $tx_stmt_2025_04_17_row_09,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_09.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_09.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-03-31T00:00:00Z",
  description: "POS Purchase 23.00 Openai *Chatg                                                    485442*7050 28 Mar",
  normalizedDescription: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 Mar",
  amount: 430.63,
  balance: 2800.3,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 10,
    rawRowText: "POS Purchase 23.00 Openai *Chatg                                                    485442*7050 28 Mar; 430.63; 2,800.30 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 Mar",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 430.63,
    bankChargeZar: 3.68,
    balanceZar: 2800.3
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_04_17_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-03-31T00:00:00Z",
  description: "POS Purchase 23.00 Openai *Chatg                                                    485442*7050 28 Mar",
  normalizedDescription: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 Mar",
  amount: 430.63,
  balance: 2800.3,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 Mar",
  merchant: $merchant_pos_purchase_23_00_openai_chatg_485442_7050_28_mar,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_04_17_row_10.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_10.id, "TransactionMerchant", $merchant_pos_purchase_23_00_openai_chatg_485442_7050_28_mar.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_10.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_10 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-10",
  transaction: $tx_stmt_2025_04_17_row_10,
  status: "open",
  question: "What is the exact purpose of this POS Purchase 23.00 Openai *Chatg 485442*7050 28 Mar transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_pos_purchase_23_00_openai_chatg_485442_7050_28_mar,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_10.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_10.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-04-01T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Jv2891",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 2022.75,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 11,
    rawRowText: "Magtape Debit Outsurance Ot87677302 Jv2891; 777.55; 2,022.75 Cr; 12.00",
    transactionType: "expense",
    normalizedMerchant: "Outsurance",
    category: "Insurance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 777.55,
    bankChargeZar: 12,
    balanceZar: 2022.75
},
  notes: "Insurance debit."
});
LET $tx_stmt_2025_04_17_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-04-01T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Jv2891",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 2022.75,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Outsurance",
  merchant: $merchant_outsurance,
  category: $cat_insurance,
  isTransfer: false,
  manualOverride: false,
  notes: "Insurance debit."
});
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_04_17_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_11.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_11.id, "TransactionCategory", $cat_insurance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-04-01T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 29 Mar",
  normalizedDescription: "Cursor",
  amount: 377.31,
  balance: 1645.44,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 12,
    rawRowText: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 29 Mar; 377.31; 1,645.44 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Cursor",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 377.31,
    bankChargeZar: 3.68,
    balanceZar: 1645.44
},
  notes: "Cursor AI tooling spend."
});
LET $tx_stmt_2025_04_17_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-04-01T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 29 Mar",
  normalizedDescription: "Cursor",
  amount: 377.31,
  balance: 1645.44,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Cursor",
  merchant: $merchant_cursor,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Cursor AI tooling spend."
});
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_04_17_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_12.id, "TransactionMerchant", $merchant_cursor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_12.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-04-04T00:00:00Z",
  description: "Inward Swift R025Vrj4S0 Altra Care Limited",
  normalizedDescription: "Inward Swift R025Vrj4S0 Altra Care Limited",
  amount: 32038.37,
  balance: 33683.81,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 13,
    rawRowText: "Inward Swift R025Vrj4S0 Altra Care Limited; 32,038.37 Cr; 33,683.81 Cr",
    transactionType: "expense",
    normalizedMerchant: "Inward Swift R025Vrj4S0 Altra Care Limited",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 32038.37,
    bankChargeZar: null,
    balanceZar: 33683.81
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_04_17_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-04-04T00:00:00Z",
  description: "Inward Swift R025Vrj4S0 Altra Care Limited",
  normalizedDescription: "Inward Swift R025Vrj4S0 Altra Care Limited",
  amount: 32038.37,
  balance: 33683.81,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Inward Swift R025Vrj4S0 Altra Care Limited",
  merchant: $merchant_inward_swift_r025vrj4s0_altra_care_limited,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_04_17_row_13.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_13.id, "TransactionMerchant", $merchant_inward_swift_r025vrj4s0_altra_care_limited.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_13.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_13 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-13",
  transaction: $tx_stmt_2025_04_17_row_13,
  status: "open",
  question: "What is the exact purpose of this Inward Swift R025Vrj4S0 Altra Care Limited transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_inward_swift_r025vrj4s0_altra_care_limited,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_13.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_13.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-04-04T00:00:00Z",
  description: "176.21",
  normalizedDescription: "Bank Fee",
  amount: 176.21,
  balance: 33507.6,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 14,
    rawRowText: "176.21; 33,507.60 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 176.21,
    bankChargeZar: null,
    balanceZar: 33507.6
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-04-04T00:00:00Z",
  description: "176.21",
  normalizedDescription: "Bank Fee",
  amount: 176.21,
  balance: 33507.6,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_04_17_row_14.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_14.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_14.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_14 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-14",
  transaction: $tx_stmt_2025_04_17_row_14,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_14.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_14.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-04-04T00:00:00Z",
  description: "Internet Pmt To Laptop Loan Payment                                                 Mpire Loan Repayment",
  normalizedDescription: "Internet Pmt To Laptop Loan Payment Mpire Loan Repayment",
  amount: 1919,
  balance: 31588.6,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 15,
    rawRowText: "Internet Pmt To Laptop Loan Payment                                                 Mpire Loan Repayment; 1,919.00; 31,588.60 Cr",
    transactionType: "expense",
    normalizedMerchant: "Internet Pmt To Laptop Loan Payment Mpire Loan Repayment",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1919,
    bankChargeZar: null,
    balanceZar: 31588.6
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_04_17_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-04-04T00:00:00Z",
  description: "Internet Pmt To Laptop Loan Payment                                                 Mpire Loan Repayment",
  normalizedDescription: "Internet Pmt To Laptop Loan Payment Mpire Loan Repayment",
  amount: 1919,
  balance: 31588.6,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Internet Pmt To Laptop Loan Payment Mpire Loan Repayment",
  merchant: $merchant_internet_pmt_to_laptop_loan_payment_mpire_loan_repayment,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_04_17_row_15.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_15.id, "TransactionMerchant", $merchant_internet_pmt_to_laptop_loan_payment_mpire_loan_repayment.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_15.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_15 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-15",
  transaction: $tx_stmt_2025_04_17_row_15,
  status: "open",
  question: "What is the exact purpose of this Internet Pmt To Laptop Loan Payment Mpire Loan Repayment transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_internet_pmt_to_laptop_loan_payment_mpire_loan_repayment,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_15.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_15.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-04-05T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 25000,
  balance: 6588.6,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 16,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 25,000.00; 6,588.60 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 25000,
    bankChargeZar: 15,
    balanceZar: 6588.6
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_04_17_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-04-05T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 25000,
  balance: 6588.6,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Mpire Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_internal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_04_17_row_16.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_16.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_16.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_16 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-16",
  transaction: $tx_stmt_2025_04_17_row_16,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_16.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_16.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-04-05T00:00:00Z",
  description: "12.60",
  normalizedDescription: "Bank Fee",
  amount: 12.6,
  balance: 6576,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 17,
    rawRowText: "12.60; 6,576.00 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 12.6,
    bankChargeZar: null,
    balanceZar: 6576
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-04-05T00:00:00Z",
  description: "12.60",
  normalizedDescription: "Bank Fee",
  amount: 12.6,
  balance: 6576,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_04_17_row_17.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_17.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_17.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_17 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-17",
  transaction: $tx_stmt_2025_04_17_row_17,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_17.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_17.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-04-05T00:00:00Z",
  description: "12.60",
  normalizedDescription: "Bank Fee",
  amount: 12.6,
  balance: 6563.4,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 18,
    rawRowText: "12.60; 6,563.40 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 12.6,
    bankChargeZar: null,
    balanceZar: 6563.4
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-04-05T00:00:00Z",
  description: "12.60",
  normalizedDescription: "Bank Fee",
  amount: 12.6,
  balance: 6563.4,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_04_17_row_18.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_18.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_18.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_18 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-18",
  transaction: $tx_stmt_2025_04_17_row_18,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_18.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_18.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-04-05T00:00:00Z",
  description: "12.60",
  normalizedDescription: "Bank Fee",
  amount: 12.6,
  balance: 6550.8,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 19,
    rawRowText: "12.60; 6,550.80 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 12.6,
    bankChargeZar: null,
    balanceZar: 6550.8
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-04-05T00:00:00Z",
  description: "12.60",
  normalizedDescription: "Bank Fee",
  amount: 12.6,
  balance: 6550.8,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_04_17_row_19.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_19.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_19.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_19 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-19",
  transaction: $tx_stmt_2025_04_17_row_19,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_19.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_19.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-04-05T00:00:00Z",
  description: "12.60",
  normalizedDescription: "Bank Fee",
  amount: 12.6,
  balance: 6538.2,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 20,
    rawRowText: "12.60; 6,538.20 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 12.6,
    bankChargeZar: null,
    balanceZar: 6538.2
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-04-05T00:00:00Z",
  description: "12.60",
  normalizedDescription: "Bank Fee",
  amount: 12.6,
  balance: 6538.2,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_04_17_row_20.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_20.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_20.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_20 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-20",
  transaction: $tx_stmt_2025_04_17_row_20,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_20.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_20.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-04-05T00:00:00Z",
  description: "Magtape Credit Investecpbau Pair Extraordinai",
  normalizedDescription: "Magtape Credit",
  amount: 22500,
  balance: 29038.2,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 21,
    rawRowText: "Magtape Credit Investecpbau Pair Extraordinai; 22,500.00 Cr; 29,038.20 Cr",
    transactionType: "income",
    normalizedMerchant: "Magtape Credit",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 22500,
    bankChargeZar: null,
    balanceZar: 29038.2
},
  notes: "Magtape credit or reversal still needs exact source confirmation."
});
LET $tx_stmt_2025_04_17_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-04-05T00:00:00Z",
  description: "Magtape Credit Investecpbau Pair Extraordinai",
  normalizedDescription: "Magtape Credit",
  amount: 22500,
  balance: 29038.2,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Magtape Credit",
  merchant: $merchant_magtape_credit,
  category: $cat_transfer,
  isTransfer: false,
  manualOverride: false,
  notes: "Magtape credit or reversal still needs exact source confirmation."
});
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_04_17_row_21.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_21.id, "TransactionMerchant", $merchant_magtape_credit.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_21.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_21 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-21",
  transaction: $tx_stmt_2025_04_17_row_21,
  status: "open",
  question: "What is the exact purpose of this Magtape Credit transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_magtape_credit,
  suggestedCategory: $cat_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_21.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_21.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-04-05T00:00:00Z",
  description: "POS Purchase 12.00 Notion Labs,                                                     485442*7050 04 Apr",
  normalizedDescription: "Notion",
  amount: 232.94,
  balance: 28805.26,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 22,
    rawRowText: "POS Purchase 12.00 Notion Labs,                                                     485442*7050 04 Apr; 232.94; 28,805.26 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Notion",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 232.94,
    bankChargeZar: 3.68,
    balanceZar: 28805.26
},
  notes: "Notion subscription spend."
});
LET $tx_stmt_2025_04_17_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-04-05T00:00:00Z",
  description: "POS Purchase 12.00 Notion Labs,                                                     485442*7050 04 Apr",
  normalizedDescription: "Notion",
  amount: 232.94,
  balance: 28805.26,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Notion",
  merchant: $merchant_notion,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Notion subscription spend."
});
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_04_17_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_22.id, "TransactionMerchant", $merchant_notion.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_22.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-04-07T00:00:00Z",
  description: "Internet Pmt To Accounting Fees                                                     Mpire Digital Inv106",
  normalizedDescription: "Internet Pmt To Accounting Fees Mpire Digital Inv106",
  amount: 3250,
  balance: 25555.26,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 23,
    rawRowText: "Internet Pmt To Accounting Fees                                                     Mpire Digital Inv106; 3,250.00; 25,555.26 Cr",
    transactionType: "expense",
    normalizedMerchant: "Internet Pmt To Accounting Fees Mpire Digital Inv106",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 3250,
    bankChargeZar: null,
    balanceZar: 25555.26
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_04_17_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-04-07T00:00:00Z",
  description: "Internet Pmt To Accounting Fees                                                     Mpire Digital Inv106",
  normalizedDescription: "Internet Pmt To Accounting Fees Mpire Digital Inv106",
  amount: 3250,
  balance: 25555.26,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Internet Pmt To Accounting Fees Mpire Digital Inv106",
  merchant: $merchant_internet_pmt_to_accounting_fees_mpire_digital_inv106,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_04_17_row_23.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_23.id, "TransactionMerchant", $merchant_internet_pmt_to_accounting_fees_mpire_digital_inv106.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_23.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_23 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-23",
  transaction: $tx_stmt_2025_04_17_row_23,
  status: "open",
  question: "What is the exact purpose of this Internet Pmt To Accounting Fees Mpire Digital Inv106 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_internet_pmt_to_accounting_fees_mpire_digital_inv106,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_23.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_23.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-04-07T00:00:00Z",
  description: "Internet Pmt To Nectar: Esta Stage 1                                                Mpire Digital:Esta V",
  normalizedDescription: "Internet Pmt To Nectar: Esta Stage 1 Mpire Digital:Esta V",
  amount: 4000,
  balance: 21555.26,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 24,
    rawRowText: "Internet Pmt To Nectar: Esta Stage 1                                                Mpire Digital:Esta V; 4,000.00; 21,555.26 Cr",
    transactionType: "expense",
    normalizedMerchant: "Internet Pmt To Nectar: Esta Stage 1 Mpire Digital:Esta V",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 4000,
    bankChargeZar: null,
    balanceZar: 21555.26
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_04_17_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-04-07T00:00:00Z",
  description: "Internet Pmt To Nectar: Esta Stage 1                                                Mpire Digital:Esta V",
  normalizedDescription: "Internet Pmt To Nectar: Esta Stage 1 Mpire Digital:Esta V",
  amount: 4000,
  balance: 21555.26,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Internet Pmt To Nectar: Esta Stage 1 Mpire Digital:Esta V",
  merchant: $merchant_internet_pmt_to_nectar_esta_stage_1_mpire_digital_esta_v,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_04_17_row_24.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_24.id, "TransactionMerchant", $merchant_internet_pmt_to_nectar_esta_stage_1_mpire_digital_esta_v.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_24.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_24 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-24",
  transaction: $tx_stmt_2025_04_17_row_24,
  status: "open",
  question: "What is the exact purpose of this Internet Pmt To Nectar: Esta Stage 1 Mpire Digital:Esta V transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_internet_pmt_to_nectar_esta_stage_1_mpire_digital_esta_v,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_24.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_24.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-04-08T00:00:00Z",
  description: "POS Purchase 138.77 Paypal *Vect                                                    485442*7050 04 Apr",
  normalizedDescription: "PayPal",
  amount: 138.77,
  balance: 21416.49,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 25,
    rawRowText: "POS Purchase 138.77 Paypal *Vect                                                    485442*7050 04 Apr; 138.77; 21,416.49 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 138.77,
    bankChargeZar: 3.68,
    balanceZar: 21416.49
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_04_17_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-04-08T00:00:00Z",
  description: "POS Purchase 138.77 Paypal *Vect                                                    485442*7050 04 Apr",
  normalizedDescription: "PayPal",
  amount: 138.77,
  balance: 21416.49,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal",
  merchant: $merchant_paypal,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs confirmation."
});
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_04_17_row_25.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_25.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_25.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_25 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-25",
  transaction: $tx_stmt_2025_04_17_row_25,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_25.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_25.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-04-09T00:00:00Z",
  description: "POS Purchase 47.18 Paypal *Elite                                                485442*7050 07 Apr",
  normalizedDescription: "PayPal",
  amount: 47.18,
  balance: 21369.31,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 26,
    rawRowText: "POS Purchase 47.18 Paypal *Elite                                                485442*7050 07 Apr; 47.18; 21,369.31 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 47.18,
    bankChargeZar: 3.68,
    balanceZar: 21369.31
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_04_17_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-04-09T00:00:00Z",
  description: "POS Purchase 47.18 Paypal *Elite                                                485442*7050 07 Apr",
  normalizedDescription: "PayPal",
  amount: 47.18,
  balance: 21369.31,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal",
  merchant: $merchant_paypal,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs confirmation."
});
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_04_17_row_26.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_26.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_26.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_26 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-26",
  transaction: $tx_stmt_2025_04_17_row_26,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_26.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_26.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-04-09T00:00:00Z",
  description: "POS Purchase 692.06 Paypal *Elit                                                485442*7050 07 Apr",
  normalizedDescription: "PayPal",
  amount: 692.06,
  balance: 20677.25,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 27,
    rawRowText: "POS Purchase 692.06 Paypal *Elit                                                485442*7050 07 Apr; 692.06; 20,677.25 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 692.06,
    bankChargeZar: 3.68,
    balanceZar: 20677.25
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_04_17_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-04-09T00:00:00Z",
  description: "POS Purchase 692.06 Paypal *Elit                                                485442*7050 07 Apr",
  normalizedDescription: "PayPal",
  amount: 692.06,
  balance: 20677.25,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal",
  merchant: $merchant_paypal,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs confirmation."
});
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_04_17_row_27.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_27.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_27.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_27 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-27",
  transaction: $tx_stmt_2025_04_17_row_27,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_27.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_27.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-04-11T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 12000,
  balance: 8677.25,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 28,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 12,000.00; 8,677.25 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 12000,
    bankChargeZar: 15,
    balanceZar: 8677.25
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_04_17_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-04-11T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 12000,
  balance: 8677.25,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Mpire Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_internal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_04_17_row_28.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_28.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_28.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_28 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-28",
  transaction: $tx_stmt_2025_04_17_row_28,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_28.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_28.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-04-15T00:00:00Z",
  description: "0.94",
  normalizedDescription: "Bank Fee",
  amount: 0.94,
  balance: 8676.31,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 29,
    rawRowText: "0.94; 8,676.31 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 0.94,
    bankChargeZar: null,
    balanceZar: 8676.31
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-04-15T00:00:00Z",
  description: "0.94",
  normalizedDescription: "Bank Fee",
  amount: 0.94,
  balance: 8676.31,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_04_17_row_29.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_29.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_29.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_29 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-29",
  transaction: $tx_stmt_2025_04_17_row_29,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_29.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_29.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-04-15T00:00:00Z",
  description: "2.78",
  normalizedDescription: "Bank Fee",
  amount: 2.78,
  balance: 8673.53,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 30,
    rawRowText: "2.78; 8,673.53 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 2.78,
    bankChargeZar: null,
    balanceZar: 8673.53
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-04-15T00:00:00Z",
  description: "2.78",
  normalizedDescription: "Bank Fee",
  amount: 2.78,
  balance: 8673.53,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_04_17_row_30.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_30.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_30.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_30 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-30",
  transaction: $tx_stmt_2025_04_17_row_30,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_30.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_30.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-04-15T00:00:00Z",
  description: "13.84",
  normalizedDescription: "Bank Fee",
  amount: 13.84,
  balance: 8659.69,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 31,
    rawRowText: "13.84; 8,659.69 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 13.84,
    bankChargeZar: null,
    balanceZar: 8659.69
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-04-15T00:00:00Z",
  description: "13.84",
  normalizedDescription: "Bank Fee",
  amount: 13.84,
  balance: 8659.69,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_04_17_row_31.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_31.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_31.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_31 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-31",
  transaction: $tx_stmt_2025_04_17_row_31,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_31.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_31.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-04-17T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 4500,
  balance: 4159.69,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 32,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 4,500.00; 4,159.69 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 4500,
    bankChargeZar: 15,
    balanceZar: 4159.69
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_04_17_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-04-17T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 4500,
  balance: 4159.69,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Mpire Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_internal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_04_17_row_32.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_32.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_32.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_32 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-32",
  transaction: $tx_stmt_2025_04_17_row_32,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_32.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_32.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-04-17T00:00:00Z",
  description: "Int On Debit Balance",
  normalizedDescription: "Debit Interest",
  amount: 0.55,
  balance: 4159.14,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 33,
    rawRowText: "Int On Debit Balance; 0.55; 4,159.14 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "debit interest",
    clarificationStatus: "clarified",
    amountZar: 0.55,
    bankChargeZar: null,
    balanceZar: 4159.14
},
  notes: "Interest on debit balance."
});
LET $tx_stmt_2025_04_17_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-04-17T00:00:00Z",
  description: "Int On Debit Balance",
  normalizedDescription: "Debit Interest",
  amount: 0.55,
  balance: 4159.14,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_debit_interest,
  isTransfer: false,
  manualOverride: false,
  notes: "Interest on debit balance."
});
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_04_17_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_33.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_33.id, "TransactionCategory", $cat_fees_debit_interest.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-04-17T00:00:00Z",
  description: "0.00",
  normalizedDescription: "0.00",
  amount: 4159.14,
  balance: 15,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 34,
    rawRowText: "0.00; 4,159.14 Cr; 15.00",
    transactionType: "expense",
    normalizedMerchant: "0.00",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 4159.14,
    bankChargeZar: null,
    balanceZar: 15
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_04_17_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-04-17T00:00:00Z",
  description: "0.00",
  normalizedDescription: "0.00",
  amount: 4159.14,
  balance: 15,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "0.00",
  merchant: $merchant_0_00,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_04_17_row_34.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_34.id, "TransactionMerchant", $merchant_0_00.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_34.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_34 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-34",
  transaction: $tx_stmt_2025_04_17_row_34,
  status: "open",
  question: "What is the exact purpose of this 0.00 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_0_00,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_34.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_34.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2025-04-17T00:00:00Z",
  description: "89.00",
  normalizedDescription: "Bank Fee",
  amount: 89,
  balance: 4070.14,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 35,
    rawRowText: "89.00; 4,070.14 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 89,
    bankChargeZar: null,
    balanceZar: 4070.14
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-35",
  sourceRow: $row_row_35,
  postedAt: "2025-04-17T00:00:00Z",
  description: "89.00",
  normalizedDescription: "Bank Fee",
  amount: 89,
  balance: 4070.14,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_04_17_row_35.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_35.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_35.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_35 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-35",
  transaction: $tx_stmt_2025_04_17_row_35,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_35.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_35.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2025-04-17T00:00:00Z",
  description: "110.08",
  normalizedDescription: "Bank Fee",
  amount: 110.08,
  balance: 3960.06,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_78.pdf",
    statementPeriodStart: "2025-03-18",
    statementPeriodEnd: "2025-04-17",
    rowNo: 36,
    rawRowText: "110.08; 3,960.06 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 110.08,
    bankChargeZar: null,
    balanceZar: 3960.06
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_04_17_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-17-row-36",
  sourceRow: $row_row_36,
  postedAt: "2025-04-17T00:00:00Z",
  description: "110.08",
  normalizedDescription: "Bank Fee",
  amount: 110.08,
  balance: 3960.06,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_04_17_row_36.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_04_17_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_17_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_36.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_17_row_36.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_17_row_36 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-17-row-36",
  transaction: $tx_stmt_2025_04_17_row_36,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-04-17.import.md"
});
fn::createEdge($tx_stmt_2025_04_17_row_36.id, "TransactionClarificationTasks", $task_stmt_2025_04_17_row_36.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 36,
  normalizedCount: 36,
  clarificationCount: 31,
  status: "matched",
  statementDate: "2025-04-17T00:00:00Z",
  notes: "Imported from 2025-04-17.import.md"
});

-- End of generated import
