-- Generated from docs/statements/business/2025-08-18.import.md
-- Source: docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf

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
  notes: "Imported from GOLD_BUSINESS_ACCOUNT_82.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-08-18-fnb-gold-business-27821",
  sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-08-18T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $cat_internal_transfer = fn::createCategory({
  space: $space,
  key: "internal-transfer",
  name: "Internal transfer",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $cat_client_income = fn::createCategory({
  space: $space,
  key: "client-income",
  name: "Client income",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $cat_software_saas = fn::createCategory({
  space: $space,
  key: "software-saas",
  name: "Software / SaaS",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $cat_insurance = fn::createCategory({
  space: $space,
  key: "insurance",
  name: "Insurance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $cat_hosting_internet = fn::createCategory({
  space: $space,
  key: "hosting-internet",
  name: "Hosting / internet",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $cat_fees_bank_fee = fn::createCategory({
  space: $space,
  key: "fees-bank-fee",
  name: "Bank Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $cat_fees_card_charge = fn::createCategory({
  space: $space,
  key: "fees-card-charge",
  name: "Card Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $cat_fees_debit_interest = fn::createCategory({
  space: $space,
  key: "fees-debit-interest",
  name: "Debit Interest",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});

-- Merchant records
LET $merchant_fnb = fn::createMerchant({
  space: $space,
  key: "fnb",
  name: "FNB",
  normalizedName: "FNB",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $merchant_fnb_ob_pmt_isolvents = fn::createMerchant({
  space: $space,
  key: "fnb-ob-pmt-isolvents",
  name: "FNB OB Pmt Isolvents",
  normalizedName: "FNB OB Pmt Isolvents",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "Mpire Digital Market",
  normalizedName: "Mpire Digital Market",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $merchant_magtape_credit = fn::createMerchant({
  space: $space,
  key: "magtape-credit",
  name: "Magtape Credit",
  normalizedName: "Magtape Credit",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $merchant_sansor = fn::createMerchant({
  space: $space,
  key: "sansor",
  name: "Sansor",
  normalizedName: "Sansor",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $merchant_cursor = fn::createMerchant({
  space: $space,
  key: "cursor",
  name: "Cursor",
  normalizedName: "Cursor",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $merchant_pos_purchase_23_00_openai_chatg_485442_7050_28_jul = fn::createMerchant({
  space: $space,
  key: "pos-purchase-23-00-openai-chatg-485442-7050-28-jul",
  name: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 Jul",
  normalizedName: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 Jul",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $merchant_outsurance = fn::createMerchant({
  space: $space,
  key: "outsurance",
  name: "Outsurance",
  normalizedName: "Outsurance",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $merchant_pos_purchase_8_38_google_gsuite_485442_7050_01_aug = fn::createMerchant({
  space: $space,
  key: "pos-purchase-8-38-google-gsuite-485442-7050-01-aug",
  name: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Aug",
  normalizedName: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Aug",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $merchant_notion = fn::createMerchant({
  space: $space,
  key: "notion",
  name: "Notion",
  normalizedName: "Notion",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $merchant_diamatrix = fn::createMerchant({
  space: $space,
  key: "diamatrix",
  name: "Diamatrix",
  normalizedName: "Diamatrix",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $merchant_atlassian = fn::createMerchant({
  space: $space,
  key: "atlassian",
  name: "Atlassian",
  normalizedName: "Atlassian",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});
LET $merchant_paypal = fn::createMerchant({
  space: $space,
  key: "paypal",
  name: "PayPal",
  normalizedName: "PayPal",
  active: true,
  notes: "Imported from 2025-08-18.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-07-22T00:00:00Z",
  description: "1.76",
  normalizedDescription: "Bank Fee",
  amount: 1.76,
  balance: 42.8,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 1,
    rawRowText: "1.76; 42.80",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 1.76,
    bankChargeZar: null,
    balanceZar: 42.8
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_08_18_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-07-22T00:00:00Z",
  description: "1.76",
  normalizedDescription: "Bank Fee",
  amount: 1.76,
  balance: 42.8,
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_08_18_row_01.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_01.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_01.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_01 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-01",
  transaction: $tx_stmt_2025_08_18_row_01,
  status: "open",
  question: "What exactly is the Magtape Unpaid / Not Provided For reversal?",
  reason: "Returned item / reversal needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_01.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-07-23T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 48.8,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 2,
    rawRowText: "6.00; 48.80",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 48.8
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_08_18_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-07-23T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 48.8,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_08_18_row_02.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_02.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_02.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_02 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-02",
  transaction: $tx_stmt_2025_08_18_row_02,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_02.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-07-23T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 54.8,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 3,
    rawRowText: "6.00; 54.80",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 54.8
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_08_18_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-07-23T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 54.8,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_08_18_row_03.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_03.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_03.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_03 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-03",
  transaction: $tx_stmt_2025_08_18_row_03,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_03.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-07-23T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 60.8,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 4,
    rawRowText: "6.00; 60.80",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 60.8
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_08_18_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-07-23T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 60.8,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_08_18_row_04.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_04.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_04.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_04 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-04",
  transaction: $tx_stmt_2025_08_18_row_04,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_04.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-07-24T00:00:00Z",
  description: "FNB OB Pmt Isolvents",
  normalizedDescription: "FNB OB Pmt Isolvents",
  amount: 7500,
  balance: 7439.2,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 5,
    rawRowText: "FNB OB Pmt Isolvents; 7,500.00 Cr; 7,439.20 Cr",
    transactionType: "expense",
    normalizedMerchant: "FNB OB Pmt Isolvents",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 7500,
    bankChargeZar: null,
    balanceZar: 7439.2
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_18_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-07-24T00:00:00Z",
  description: "FNB OB Pmt Isolvents",
  normalizedDescription: "FNB OB Pmt Isolvents",
  amount: 7500,
  balance: 7439.2,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB OB Pmt Isolvents",
  merchant: $merchant_fnb_ob_pmt_isolvents,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_08_18_row_05.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_05.id, "TransactionMerchant", $merchant_fnb_ob_pmt_isolvents.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_05.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_05 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-05",
  transaction: $tx_stmt_2025_08_18_row_05,
  status: "open",
  question: "What is the exact purpose of this FNB OB Pmt Isolvents transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb_ob_pmt_isolvents,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_05.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-07-24T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 7433.2,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 6,
    rawRowText: "6.00; 7,433.20 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 7433.2
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_08_18_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-07-24T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 7433.2,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_08_18_row_06.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_06.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_06.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_06 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-06",
  transaction: $tx_stmt_2025_08_18_row_06,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_06.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-07-25T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                          Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 3500,
  balance: 3933.2,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 7,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                          Mpire Digital Market; 3,500.00; 3,933.20 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 3500,
    bankChargeZar: 15,
    balanceZar: 3933.2
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_08_18_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-07-25T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                          Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 3500,
  balance: 3933.2,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_08_18_row_07.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_07.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_07.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_07 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-07",
  transaction: $tx_stmt_2025_08_18_row_07,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_07.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-07-28T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "Magtape Credit",
  amount: 1000,
  balance: 4933.2,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 8,
    rawRowText: "Magtape Credit 127167 True Fit; 1,000.00 Cr; 4,933.20 Cr",
    transactionType: "income",
    normalizedMerchant: "Magtape Credit",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: 4933.2
},
  notes: "Magtape credit or reversal still needs exact source confirmation."
});
LET $tx_stmt_2025_08_18_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-07-28T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "Magtape Credit",
  amount: 1000,
  balance: 4933.2,
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_08_18_row_08.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_08.id, "TransactionMerchant", $merchant_magtape_credit.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_08.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_08 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-08",
  transaction: $tx_stmt_2025_08_18_row_08,
  status: "open",
  question: "What is the exact purpose of this Magtape Credit transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_magtape_credit,
  suggestedCategory: $cat_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_08.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-07-29T00:00:00Z",
  description: "FNB OB Pmt Sansor",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 11783.2,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 9,
    rawRowText: "FNB OB Pmt Sansor; 6,850.00 Cr; 11,783.20 Cr",
    transactionType: "income",
    normalizedMerchant: "Sansor",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6850,
    bankChargeZar: null,
    balanceZar: 11783.2
},
  notes: "Recurring client payment from Sansor."
});
LET $tx_stmt_2025_08_18_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-07-29T00:00:00Z",
  description: "FNB OB Pmt Sansor",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 11783.2,
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_08_18_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_09.id, "TransactionMerchant", $merchant_sansor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_09.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-07-29T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                 485442*7050 27 Jul",
  normalizedDescription: "Cursor",
  amount: 365.46,
  balance: 11417.74,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 10,
    rawRowText: "POS Purchase 20.00 Cursor, Ai Po                                                 485442*7050 27 Jul; 365.46; 11,417.74 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Cursor",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 365.46,
    bankChargeZar: 3.68,
    balanceZar: 11417.74
},
  notes: "Cursor AI tooling spend."
});
LET $tx_stmt_2025_08_18_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-07-29T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                 485442*7050 27 Jul",
  normalizedDescription: "Cursor",
  amount: 365.46,
  balance: 11417.74,
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_08_18_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_10.id, "TransactionMerchant", $merchant_cursor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_10.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-07-30T00:00:00Z",
  description: "POS Purchase 23.00 Openai *Chatg                                                 485442*7050 28 Jul",
  normalizedDescription: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 Jul",
  amount: 420.28,
  balance: 10997.46,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 11,
    rawRowText: "POS Purchase 23.00 Openai *Chatg                                                 485442*7050 28 Jul; 420.28; 10,997.46 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 Jul",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 420.28,
    bankChargeZar: 3.68,
    balanceZar: 10997.46
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_18_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-07-30T00:00:00Z",
  description: "POS Purchase 23.00 Openai *Chatg                                                 485442*7050 28 Jul",
  normalizedDescription: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 Jul",
  amount: 420.28,
  balance: 10997.46,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 Jul",
  merchant: $merchant_pos_purchase_23_00_openai_chatg_485442_7050_28_jul,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_08_18_row_11.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_11.id, "TransactionMerchant", $merchant_pos_purchase_23_00_openai_chatg_485442_7050_28_jul.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_11.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_11 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-11",
  transaction: $tx_stmt_2025_08_18_row_11,
  status: "open",
  question: "What is the exact purpose of this POS Purchase 23.00 Openai *Chatg 485442*7050 28 Jul transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_pos_purchase_23_00_openai_chatg_485442_7050_28_jul,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_11.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-08-01T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 5000,
  balance: 5997.46,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 12,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market; 5,000.00; 5,997.46 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 5000,
    bankChargeZar: 15,
    balanceZar: 5997.46
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_08_18_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-08-01T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 5000,
  balance: 5997.46,
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_08_18_row_12.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_12.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_12.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_12 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-12",
  transaction: $tx_stmt_2025_08_18_row_12,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_12.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-08-01T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 189132",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 5219.91,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 13,
    rawRowText: "Magtape Debit Outsurance Ot87677302 189132; 777.55; 5,219.91 Cr; 12.00",
    transactionType: "expense",
    normalizedMerchant: "Outsurance",
    category: "Insurance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 777.55,
    bankChargeZar: 12,
    balanceZar: 5219.91
},
  notes: "Insurance debit."
});
LET $tx_stmt_2025_08_18_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-08-01T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 189132",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 5219.91,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_08_18_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_13.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_13.id, "TransactionCategory", $cat_insurance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-08-04T00:00:00Z",
  description: "POS Purchase 8.38 Google Gsuite_                                                   485442*7050 01 Aug",
  normalizedDescription: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Aug",
  amount: 178.98,
  balance: 5040.93,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 14,
    rawRowText: "POS Purchase 8.38 Google Gsuite_                                                   485442*7050 01 Aug; 178.98; 5,040.93 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Aug",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 178.98,
    bankChargeZar: 3.68,
    balanceZar: 5040.93
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_18_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-08-04T00:00:00Z",
  description: "POS Purchase 8.38 Google Gsuite_                                                   485442*7050 01 Aug",
  normalizedDescription: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Aug",
  amount: 178.98,
  balance: 5040.93,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Aug",
  merchant: $merchant_pos_purchase_8_38_google_gsuite_485442_7050_01_aug,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_08_18_row_14.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_14.id, "TransactionMerchant", $merchant_pos_purchase_8_38_google_gsuite_485442_7050_01_aug.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_14.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_14 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-14",
  transaction: $tx_stmt_2025_08_18_row_14,
  status: "open",
  question: "What is the exact purpose of this POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Aug transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_pos_purchase_8_38_google_gsuite_485442_7050_01_aug,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_14.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-08-05T00:00:00Z",
  description: "POS Purchase 13.80 Notion Labs,                                                    485442*7050 04 Aug",
  normalizedDescription: "Notion",
  amount: 259.94,
  balance: 4780.99,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 15,
    rawRowText: "POS Purchase 13.80 Notion Labs,                                                    485442*7050 04 Aug; 259.94; 4,780.99 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Notion",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 259.94,
    bankChargeZar: 3.68,
    balanceZar: 4780.99
},
  notes: "Notion subscription spend."
});
LET $tx_stmt_2025_08_18_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-08-05T00:00:00Z",
  description: "POS Purchase 13.80 Notion Labs,                                                    485442*7050 04 Aug",
  normalizedDescription: "Notion",
  amount: 259.94,
  balance: 4780.99,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_08_18_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_15.id, "TransactionMerchant", $merchant_notion.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_15.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-08-06T00:00:00Z",
  description: "POS Purchase Diamatrix                                                             485442*7050 02 Aug",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 4252.99,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 16,
    rawRowText: "POS Purchase Diamatrix                                                             485442*7050 02 Aug; 528.00; 4,252.99 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Diamatrix",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 528,
    bankChargeZar: 3.68,
    balanceZar: 4252.99
},
  notes: "Hosting or software-service spend."
});
LET $tx_stmt_2025_08_18_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-08-06T00:00:00Z",
  description: "POS Purchase Diamatrix                                                             485442*7050 02 Aug",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 4252.99,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Diamatrix",
  merchant: $merchant_diamatrix,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting or software-service spend."
});
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_08_18_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_16.id, "TransactionMerchant", $merchant_diamatrix.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_16.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-08-06T00:00:00Z",
  description: "POS Purchase 18.98 Atlassian                                                       485442*7050 05 Aug",
  normalizedDescription: "Atlassian",
  amount: 351.74,
  balance: 3901.25,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 17,
    rawRowText: "POS Purchase 18.98 Atlassian                                                       485442*7050 05 Aug; 351.74; 3,901.25 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Atlassian",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 351.74,
    bankChargeZar: 3.68,
    balanceZar: 3901.25
},
  notes: "Atlassian subscription spend."
});
LET $tx_stmt_2025_08_18_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-08-06T00:00:00Z",
  description: "POS Purchase 18.98 Atlassian                                                       485442*7050 05 Aug",
  normalizedDescription: "Atlassian",
  amount: 351.74,
  balance: 3901.25,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Atlassian",
  merchant: $merchant_atlassian,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Atlassian subscription spend."
});
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_08_18_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_17.id, "TransactionMerchant", $merchant_atlassian.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_17.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-08-07T00:00:00Z",
  description: "POS Purchase 134.00 Paypal *Vect                                                   485442*7050 04 Aug",
  normalizedDescription: "PayPal",
  amount: 134,
  balance: 3767.25,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 18,
    rawRowText: "POS Purchase 134.00 Paypal *Vect                                                   485442*7050 04 Aug; 134.00; 3,767.25 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 134,
    bankChargeZar: 3.68,
    balanceZar: 3767.25
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_08_18_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-08-07T00:00:00Z",
  description: "POS Purchase 134.00 Paypal *Vect                                                   485442*7050 04 Aug",
  normalizedDescription: "PayPal",
  amount: 134,
  balance: 3767.25,
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_08_18_row_18.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_18.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_18.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_18 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-18",
  transaction: $tx_stmt_2025_08_18_row_18,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_18.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-08-13T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 2000,
  balance: 1767.25,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 19,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market; 2,000.00; 1,767.25 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 2000,
    bankChargeZar: 8,
    balanceZar: 1767.25
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_08_18_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-08-13T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 2000,
  balance: 1767.25,
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
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_08_18_row_19.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_19.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_19.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_19 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-19",
  transaction: $tx_stmt_2025_08_18_row_19,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_19.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-08-13T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 1680,
  balance: 87.25,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 20,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market; 1,680.00; 87.25 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1680,
    bankChargeZar: 8,
    balanceZar: 87.25
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_08_18_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-08-13T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 1680,
  balance: 87.25,
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
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_08_18_row_20.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_20.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_20.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_20 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-20",
  transaction: $tx_stmt_2025_08_18_row_20,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_20.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-08-18T00:00:00Z",
  description: "Int On Debit Balance",
  normalizedDescription: "Debit Interest",
  amount: 0.14,
  balance: 87.11,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 21,
    rawRowText: "Int On Debit Balance; 0.14; 87.11 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "debit interest",
    clarificationStatus: "clarified",
    amountZar: 0.14,
    bankChargeZar: null,
    balanceZar: 87.11
},
  notes: "Interest on debit balance."
});
LET $tx_stmt_2025_08_18_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-08-18T00:00:00Z",
  description: "Int On Debit Balance",
  normalizedDescription: "Debit Interest",
  amount: 0.14,
  balance: 87.11,
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
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_08_18_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_21.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_21.id, "TransactionCategory", $cat_fees_debit_interest.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-08-18T00:00:00Z",
  description: "93.00",
  normalizedDescription: "Bank Fee",
  amount: 93,
  balance: 5.89,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 22,
    rawRowText: "93.00; 5.89",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 93,
    bankChargeZar: null,
    balanceZar: 5.89
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_08_18_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-08-18T00:00:00Z",
  description: "93.00",
  normalizedDescription: "Bank Fee",
  amount: 93,
  balance: 5.89,
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
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_08_18_row_22.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_22.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_22.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_22 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-22",
  transaction: $tx_stmt_2025_08_18_row_22,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_22.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-08-18T00:00:00Z",
  description: "83.76",
  normalizedDescription: "Bank Fee",
  amount: 83.76,
  balance: 89.65,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_82.pdf",
    statementPeriodStart: "2025-07-18",
    statementPeriodEnd: "2025-08-18",
    rowNo: 23,
    rawRowText: "83.76; 89.65",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 83.76,
    bankChargeZar: null,
    balanceZar: 89.65
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_08_18_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-18-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-08-18T00:00:00Z",
  description: "83.76",
  normalizedDescription: "Bank Fee",
  amount: 83.76,
  balance: 89.65,
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_08_18_row_23.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_08_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_23.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_18_row_23.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_18_row_23 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-18-row-23",
  transaction: $tx_stmt_2025_08_18_row_23,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-08-18.import.md"
});
fn::createEdge($tx_stmt_2025_08_18_row_23.id, "TransactionClarificationTasks", $task_stmt_2025_08_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 23,
  normalizedCount: 23,
  clarificationCount: 16,
  status: "matched",
  statementDate: "2025-08-18T00:00:00Z",
  notes: "Imported from 2025-08-18.import.md"
});

-- End of generated import
