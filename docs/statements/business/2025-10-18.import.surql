-- Generated from docs/statements/business/2025-10-18.import.md
-- Source: docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf

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
  openingBalance: 851.81,
  active: true,
  notes: "Imported from GOLD_BUSINESS_ACCOUNT_84.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-10-18-fnb-gold-business-27821",
  sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-10-18T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_software_saas = fn::createCategory({
  space: $space,
  key: "software-saas",
  name: "Software / SaaS",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $cat_client_income = fn::createCategory({
  space: $space,
  key: "client-income",
  name: "Client income",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $cat_insurance = fn::createCategory({
  space: $space,
  key: "insurance",
  name: "Insurance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $cat_internal_transfer = fn::createCategory({
  space: $space,
  key: "internal-transfer",
  name: "Internal transfer",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $cat_hosting_internet = fn::createCategory({
  space: $space,
  key: "hosting-internet",
  name: "Hosting / internet",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $cat_fees_card_charge = fn::createCategory({
  space: $space,
  key: "fees-card-charge",
  name: "Card Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $cat_fees_bank_fee = fn::createCategory({
  space: $space,
  key: "fees-bank-fee",
  name: "Bank Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $cat_fees_debit_interest = fn::createCategory({
  space: $space,
  key: "fees-debit-interest",
  name: "Debit Interest",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});

-- Merchant records
LET $merchant_paypal = fn::createMerchant({
  space: $space,
  key: "paypal",
  name: "PayPal",
  normalizedName: "PayPal",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_fnb = fn::createMerchant({
  space: $space,
  key: "fnb",
  name: "FNB",
  normalizedName: "FNB",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_sansor = fn::createMerchant({
  space: $space,
  key: "sansor",
  name: "Sansor",
  normalizedName: "Sansor",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_internet_pmt_to_vdv_internet_mic00017 = fn::createMerchant({
  space: $space,
  key: "internet-pmt-to-vdv-internet-mic00017",
  name: "Internet Pmt To Vdv Internet Mic00017",
  normalizedName: "Internet Pmt To Vdv Internet Mic00017",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_magtape_credit = fn::createMerchant({
  space: $space,
  key: "magtape-credit",
  name: "Magtape Credit",
  normalizedName: "Magtape Credit",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_outsurance = fn::createMerchant({
  space: $space,
  key: "outsurance",
  name: "Outsurance",
  normalizedName: "Outsurance",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_inward_swift_r025mqp3r0_passmed_pte_ltd = fn::createMerchant({
  space: $space,
  key: "inward-swift-r025mqp3r0-passmed-pte-ltd",
  name: "Inward Swift R025Mqp3R0 Passmed Pte Ltd",
  normalizedName: "Inward Swift R025Mqp3R0 Passmed Pte Ltd",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "Mpire Digital Market",
  normalizedName: "Mpire Digital Market",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_cursor = fn::createMerchant({
  space: $space,
  key: "cursor",
  name: "Cursor",
  normalizedName: "Cursor",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_pos_purchase_8_38_google_gsuite_485442_7050_01_oct = fn::createMerchant({
  space: $space,
  key: "pos-purchase-8-38-google-gsuite-485442-7050-01-oct",
  name: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Oct",
  normalizedName: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Oct",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_diamatrix = fn::createMerchant({
  space: $space,
  key: "diamatrix",
  name: "Diamatrix",
  normalizedName: "Diamatrix",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_notion = fn::createMerchant({
  space: $space,
  key: "notion",
  name: "Notion",
  normalizedName: "Notion",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_atlassian = fn::createMerchant({
  space: $space,
  key: "atlassian",
  name: "Atlassian",
  normalizedName: "Atlassian",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_inward_swift_r025mjftj0_altra_care_limited = fn::createMerchant({
  space: $space,
  key: "inward-swift-r025mjftj0-altra-care-limited",
  name: "Inward Swift R025Mjftj0 Altra Care Limited",
  normalizedName: "Inward Swift R025Mjftj0 Altra Care Limited",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_pos_purchase_payfast_ivecloud_pt_485442_7050_11_oct = fn::createMerchant({
  space: $space,
  key: "pos-purchase-payfast-ivecloud-pt-485442-7050-11-oct",
  name: "POS Purchase Payfast*Ivecloud Pt 485442*7050 11 Oct",
  normalizedName: "POS Purchase Payfast*Ivecloud Pt 485442*7050 11 Oct",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_0_00 = fn::createMerchant({
  space: $space,
  key: "0-00",
  name: "0.00",
  normalizedName: "0.00",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-09-19T00:00:00Z",
  description: "POS Purchase 476.91 Paypal *Elit                                                   485442*7050 16 Sep",
  normalizedDescription: "PayPal",
  amount: 476.91,
  balance: 374.9,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 1,
    rawRowText: "POS Purchase 476.91 Paypal *Elit                                                   485442*7050 16 Sep; 476.91; 374.90 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 476.91,
    bankChargeZar: 3.68,
    balanceZar: 374.9
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_10_18_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-09-19T00:00:00Z",
  description: "POS Purchase 476.91 Paypal *Elit                                                   485442*7050 16 Sep",
  normalizedDescription: "PayPal",
  amount: 476.91,
  balance: 374.9,
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_10_18_row_01.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_01.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_01.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_01 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-01",
  transaction: $tx_stmt_2025_10_18_row_01,
  status: "open",
  question: "What exactly is the Magtape Unpaid / Not Provided For reversal?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_01.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-09-19T00:00:00Z",
  description: "POS Purchase 476.91 Paypal *Elit                                                   485442*7050 16 Sep",
  normalizedDescription: "PayPal",
  amount: 476.91,
  balance: 102.01,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 2,
    rawRowText: "POS Purchase 476.91 Paypal *Elit                                                   485442*7050 16 Sep; 476.91; 102.01; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 476.91,
    bankChargeZar: 3.68,
    balanceZar: 102.01
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_10_18_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-09-19T00:00:00Z",
  description: "POS Purchase 476.91 Paypal *Elit                                                   485442*7050 16 Sep",
  normalizedDescription: "PayPal",
  amount: 476.91,
  balance: 102.01,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_10_18_row_02.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_02.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_02.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_02 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-02",
  transaction: $tx_stmt_2025_10_18_row_02,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_02.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-09-22T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 108.01,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 3,
    rawRowText: "6.00; 108.01",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 108.01
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_10_18_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-09-22T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 108.01,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_10_18_row_03.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_03.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_03.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_03 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-03",
  transaction: $tx_stmt_2025_10_18_row_03,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_03.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-09-23T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 114.01,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 4,
    rawRowText: "6.00; 114.01",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 114.01
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_10_18_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-09-23T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 114.01,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_10_18_row_04.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_04.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_04.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_04 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-04",
  transaction: $tx_stmt_2025_10_18_row_04,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_04.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-09-25T00:00:00Z",
  description: "1.29",
  normalizedDescription: "Bank Fee",
  amount: 1.29,
  balance: 115.3,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 5,
    rawRowText: "1.29; 115.30",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 1.29,
    bankChargeZar: null,
    balanceZar: 115.3
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_10_18_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-09-25T00:00:00Z",
  description: "1.29",
  normalizedDescription: "Bank Fee",
  amount: 1.29,
  balance: 115.3,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_10_18_row_05.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_05.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_05.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_05 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-05",
  transaction: $tx_stmt_2025_10_18_row_05,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_05.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-09-25T00:00:00Z",
  description: "10.73",
  normalizedDescription: "Bank Fee",
  amount: 10.73,
  balance: 126.03,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 6,
    rawRowText: "10.73; 126.03",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 10.73,
    bankChargeZar: null,
    balanceZar: 126.03
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_10_18_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-09-25T00:00:00Z",
  description: "10.73",
  normalizedDescription: "Bank Fee",
  amount: 10.73,
  balance: 126.03,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_10_18_row_06.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_06.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_06.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_06 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-06",
  transaction: $tx_stmt_2025_10_18_row_06,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_06.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-09-25T00:00:00Z",
  description: "10.73",
  normalizedDescription: "Bank Fee",
  amount: 10.73,
  balance: 136.76,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 7,
    rawRowText: "10.73; 136.76",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 10.73,
    bankChargeZar: null,
    balanceZar: 136.76
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_10_18_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-09-25T00:00:00Z",
  description: "10.73",
  normalizedDescription: "Bank Fee",
  amount: 10.73,
  balance: 136.76,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_10_18_row_07.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_07.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_07.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_07 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-07",
  transaction: $tx_stmt_2025_10_18_row_07,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_07.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-09-27T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 142.76,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 8,
    rawRowText: "6.00; 142.76",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 142.76
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_10_18_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-09-27T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 142.76,
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_10_18_row_08.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_08.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_08.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_08 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-08",
  transaction: $tx_stmt_2025_10_18_row_08,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_08.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-09-29T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 148.76,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 9,
    rawRowText: "6.00; 148.76",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 148.76
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_10_18_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-09-29T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 148.76,
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_10_18_row_09.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_09.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_09.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_09 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-09",
  transaction: $tx_stmt_2025_10_18_row_09,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_09.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-09-30T00:00:00Z",
  description: "FNB OB Pmt Sansor Inv 127588",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 6701.24,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 10,
    rawRowText: "FNB OB Pmt Sansor Inv 127588; 6,850.00 Cr; 6,701.24 Cr",
    transactionType: "income",
    normalizedMerchant: "Sansor",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6850,
    bankChargeZar: null,
    balanceZar: 6701.24
},
  notes: "Recurring client payment from Sansor."
});
LET $tx_stmt_2025_10_18_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-09-30T00:00:00Z",
  description: "FNB OB Pmt Sansor Inv 127588",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 6701.24,
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_10_18_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_10.id, "TransactionMerchant", $merchant_sansor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_10.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-09-30T00:00:00Z",
  description: "Internet Pmt To Vdv Internet                                                       Mic00017",
  normalizedDescription: "Internet Pmt To Vdv Internet Mic00017",
  amount: 849,
  balance: 5852.24,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 11,
    rawRowText: "Internet Pmt To Vdv Internet                                                       Mic00017; 849.00; 5,852.24 Cr",
    transactionType: "expense",
    normalizedMerchant: "Internet Pmt To Vdv Internet Mic00017",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 849,
    bankChargeZar: null,
    balanceZar: 5852.24
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_18_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-09-30T00:00:00Z",
  description: "Internet Pmt To Vdv Internet                                                       Mic00017",
  normalizedDescription: "Internet Pmt To Vdv Internet Mic00017",
  amount: 849,
  balance: 5852.24,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Internet Pmt To Vdv Internet Mic00017",
  merchant: $merchant_internet_pmt_to_vdv_internet_mic00017,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_10_18_row_11.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_11.id, "TransactionMerchant", $merchant_internet_pmt_to_vdv_internet_mic00017.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_11.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_11 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-11",
  transaction: $tx_stmt_2025_10_18_row_11,
  status: "open",
  question: "What is the exact purpose of this Internet Pmt To Vdv Internet Mic00017 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_internet_pmt_to_vdv_internet_mic00017,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_11.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-09-30T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "Magtape Credit",
  amount: 1000,
  balance: 6852.24,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 12,
    rawRowText: "Magtape Credit 127167 True Fit; 1,000.00 Cr; 6,852.24 Cr",
    transactionType: "income",
    normalizedMerchant: "Magtape Credit",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: 6852.24
},
  notes: "Magtape credit or reversal still needs exact source confirmation."
});
LET $tx_stmt_2025_10_18_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-09-30T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "Magtape Credit",
  amount: 1000,
  balance: 6852.24,
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_10_18_row_12.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_12.id, "TransactionMerchant", $merchant_magtape_credit.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_12.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_12 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-12",
  transaction: $tx_stmt_2025_10_18_row_12,
  status: "open",
  question: "What is the exact purpose of this Magtape Credit transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_magtape_credit,
  suggestedCategory: $cat_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_12.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-10-01T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 N00903",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 6074.69,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 13,
    rawRowText: "Magtape Debit Outsurance Ot87677302 N00903; 777.55; 6,074.69 Cr; 12.00",
    transactionType: "expense",
    normalizedMerchant: "Outsurance",
    category: "Insurance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 777.55,
    bankChargeZar: 12,
    balanceZar: 6074.69
},
  notes: "Insurance debit."
});
LET $tx_stmt_2025_10_18_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-10-01T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 N00903",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 6074.69,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_10_18_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_13.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_13.id, "TransactionCategory", $cat_insurance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Inward Swift R025Mqp3R0 Passmed Pte Ltd",
  normalizedDescription: "Inward Swift R025Mqp3R0 Passmed Pte Ltd",
  amount: 49825,
  balance: 55899.69,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 14,
    rawRowText: "Inward Swift R025Mqp3R0 Passmed Pte Ltd; 49,825.00 Cr; 55,899.69 Cr",
    transactionType: "expense",
    normalizedMerchant: "Inward Swift R025Mqp3R0 Passmed Pte Ltd",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 49825,
    bankChargeZar: null,
    balanceZar: 55899.69
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_18_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Inward Swift R025Mqp3R0 Passmed Pte Ltd",
  normalizedDescription: "Inward Swift R025Mqp3R0 Passmed Pte Ltd",
  amount: 49825,
  balance: 55899.69,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Inward Swift R025Mqp3R0 Passmed Pte Ltd",
  merchant: $merchant_inward_swift_r025mqp3r0_passmed_pte_ltd,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_10_18_row_14.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_14.id, "TransactionMerchant", $merchant_inward_swift_r025mqp3r0_passmed_pte_ltd.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_14.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_14 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-14",
  transaction: $tx_stmt_2025_10_18_row_14,
  status: "open",
  question: "What is the exact purpose of this Inward Swift R025Mqp3R0 Passmed Pte Ltd transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_inward_swift_r025mqp3r0_passmed_pte_ltd,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_14.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 50000,
  balance: 5899.69,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 15,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market; 50,000.00; 5,899.69 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 50000,
    bankChargeZar: 15,
    balanceZar: 5899.69
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_10_18_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 50000,
  balance: 5899.69,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_10_18_row_15.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_15.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_15.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_15 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-15",
  transaction: $tx_stmt_2025_10_18_row_15,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_15.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-10-02T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                   485442*7050 30 Sep",
  normalizedDescription: "Cursor",
  amount: 356.88,
  balance: 5542.81,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 16,
    rawRowText: "POS Purchase 20.00 Cursor, Ai Po                                                   485442*7050 30 Sep; 356.88; 5,542.81 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Cursor",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 356.88,
    bankChargeZar: 3.68,
    balanceZar: 5542.81
},
  notes: "Cursor AI tooling spend."
});
LET $tx_stmt_2025_10_18_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-10-02T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                   485442*7050 30 Sep",
  normalizedDescription: "Cursor",
  amount: 356.88,
  balance: 5542.81,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_10_18_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_16.id, "TransactionMerchant", $merchant_cursor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_16.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-10-03T00:00:00Z",
  description: "POS Purchase 8.38 Google Gsuite_                                                   485442*7050 01 Oct",
  normalizedDescription: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Oct",
  amount: 174.66,
  balance: 5368.15,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 17,
    rawRowText: "POS Purchase 8.38 Google Gsuite_                                                   485442*7050 01 Oct; 174.66; 5,368.15 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Oct",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 174.66,
    bankChargeZar: 3.68,
    balanceZar: 5368.15
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_18_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-10-03T00:00:00Z",
  description: "POS Purchase 8.38 Google Gsuite_                                                   485442*7050 01 Oct",
  normalizedDescription: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Oct",
  amount: 174.66,
  balance: 5368.15,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Oct",
  merchant: $merchant_pos_purchase_8_38_google_gsuite_485442_7050_01_oct,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_10_18_row_17.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_17.id, "TransactionMerchant", $merchant_pos_purchase_8_38_google_gsuite_485442_7050_01_oct.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_17.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_17 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-17",
  transaction: $tx_stmt_2025_10_18_row_17,
  status: "open",
  question: "What is the exact purpose of this POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Oct transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_pos_purchase_8_38_google_gsuite_485442_7050_01_oct,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_17.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-10-03T00:00:00Z",
  description: "POS Purchase 395.95 Paypal *Elit                                                   485442*7050 01 Oct",
  normalizedDescription: "PayPal",
  amount: 395.95,
  balance: 4972.2,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 18,
    rawRowText: "POS Purchase 395.95 Paypal *Elit                                                   485442*7050 01 Oct; 395.95; 4,972.20 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 395.95,
    bankChargeZar: 3.68,
    balanceZar: 4972.2
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_10_18_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-10-03T00:00:00Z",
  description: "POS Purchase 395.95 Paypal *Elit                                                   485442*7050 01 Oct",
  normalizedDescription: "PayPal",
  amount: 395.95,
  balance: 4972.2,
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_10_18_row_18.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_18.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_18.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_18 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-18",
  transaction: $tx_stmt_2025_10_18_row_18,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_18.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-10-04T00:00:00Z",
  description: "POS Purchase Diamatrix                                                             485442*7050 02 Oct",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 4444.2,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 19,
    rawRowText: "POS Purchase Diamatrix                                                             485442*7050 02 Oct; 528.00; 4,444.20 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Diamatrix",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 528,
    bankChargeZar: 3.68,
    balanceZar: 4444.2
},
  notes: "Hosting or software-service spend."
});
LET $tx_stmt_2025_10_18_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-10-04T00:00:00Z",
  description: "POS Purchase Diamatrix                                                             485442*7050 02 Oct",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 4444.2,
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
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_10_18_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_19.id, "TransactionMerchant", $merchant_diamatrix.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_19.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-10-06T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 2500,
  balance: 1944.2,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 20,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market; 2,500.00; 1,944.20 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 2500,
    bankChargeZar: 8,
    balanceZar: 1944.2
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_10_18_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-10-06T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 2500,
  balance: 1944.2,
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
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_10_18_row_20.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_20.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_20.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_20 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-20",
  transaction: $tx_stmt_2025_10_18_row_20,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_20.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-10-07T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 1100,
  balance: 844.2,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 21,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market; 1,100.00; 844.20 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1100,
    bankChargeZar: 8,
    balanceZar: 844.2
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_10_18_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-10-07T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 1100,
  balance: 844.2,
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
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_10_18_row_21.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_21.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_21.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_21 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-21",
  transaction: $tx_stmt_2025_10_18_row_21,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_21.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-10-07T00:00:00Z",
  description: "POS Purchase 126.43 Paypal *Vect                                                   485442*7050 04 Oct",
  normalizedDescription: "PayPal",
  amount: 126.43,
  balance: 717.77,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 22,
    rawRowText: "POS Purchase 126.43 Paypal *Vect                                                   485442*7050 04 Oct; 126.43; 717.77 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 126.43,
    bankChargeZar: 3.68,
    balanceZar: 717.77
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_10_18_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-10-07T00:00:00Z",
  description: "POS Purchase 126.43 Paypal *Vect                                                   485442*7050 04 Oct",
  normalizedDescription: "PayPal",
  amount: 126.43,
  balance: 717.77,
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
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_10_18_row_22.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_22.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_22.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_22 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-22",
  transaction: $tx_stmt_2025_10_18_row_22,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_22.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-10-07T00:00:00Z",
  description: "POS Purchase 13.80 Notion Labs,                                                    485442*7050 04 Oct",
  normalizedDescription: "Notion",
  amount: 245.26,
  balance: 472.51,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 23,
    rawRowText: "POS Purchase 13.80 Notion Labs,                                                    485442*7050 04 Oct; 245.26; 472.51 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Notion",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 245.26,
    bankChargeZar: 3.68,
    balanceZar: 472.51
},
  notes: "Notion subscription spend."
});
LET $tx_stmt_2025_10_18_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-10-07T00:00:00Z",
  description: "POS Purchase 13.80 Notion Labs,                                                    485442*7050 04 Oct",
  normalizedDescription: "Notion",
  amount: 245.26,
  balance: 472.51,
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_10_18_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_23.id, "TransactionMerchant", $merchant_notion.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_23.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-10-07T00:00:00Z",
  description: "POS Purchase 18.98 Atlassian                                                       485442*7050 05 Oct",
  normalizedDescription: "Atlassian",
  amount: 337.32,
  balance: 135.19,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 24,
    rawRowText: "POS Purchase 18.98 Atlassian                                                       485442*7050 05 Oct; 337.32; 135.19 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Atlassian",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 337.32,
    bankChargeZar: 3.68,
    balanceZar: 135.19
},
  notes: "Atlassian subscription spend."
});
LET $tx_stmt_2025_10_18_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-10-07T00:00:00Z",
  description: "POS Purchase 18.98 Atlassian                                                       485442*7050 05 Oct",
  normalizedDescription: "Atlassian",
  amount: 337.32,
  balance: 135.19,
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
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_10_18_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_24.id, "TransactionMerchant", $merchant_atlassian.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_24.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-10-08T00:00:00Z",
  description: "Inward Swift R025Mjftj0 Altra Care Limited",
  normalizedDescription: "Inward Swift R025Mjftj0 Altra Care Limited",
  amount: 25598.85,
  balance: 25734.04,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 25,
    rawRowText: "Inward Swift R025Mjftj0 Altra Care Limited; 25,598.85 Cr; 25,734.04 Cr",
    transactionType: "expense",
    normalizedMerchant: "Inward Swift R025Mjftj0 Altra Care Limited",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 25598.85,
    bankChargeZar: null,
    balanceZar: 25734.04
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_18_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-10-08T00:00:00Z",
  description: "Inward Swift R025Mjftj0 Altra Care Limited",
  normalizedDescription: "Inward Swift R025Mjftj0 Altra Care Limited",
  amount: 25598.85,
  balance: 25734.04,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Inward Swift R025Mjftj0 Altra Care Limited",
  merchant: $merchant_inward_swift_r025mjftj0_altra_care_limited,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_10_18_row_25.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_25.id, "TransactionMerchant", $merchant_inward_swift_r025mjftj0_altra_care_limited.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_25.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_25 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-25",
  transaction: $tx_stmt_2025_10_18_row_25,
  status: "open",
  question: "What is the exact purpose of this Inward Swift R025Mjftj0 Altra Care Limited transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_inward_swift_r025mjftj0_altra_care_limited,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_25.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-10-08T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 20000,
  balance: 5734.04,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 26,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 20,000.00; 5,734.04 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 20000,
    bankChargeZar: 15,
    balanceZar: 5734.04
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_10_18_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-10-08T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 20000,
  balance: 5734.04,
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
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_10_18_row_26.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_26.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_26.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_26 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-26",
  transaction: $tx_stmt_2025_10_18_row_26,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_26.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-10-10T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 2500,
  balance: 3234.04,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 27,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 2,500.00; 3,234.04 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 2500,
    bankChargeZar: 8,
    balanceZar: 3234.04
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_10_18_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-10-10T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 2500,
  balance: 3234.04,
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
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_10_18_row_27.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_27.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_27.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_27 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-27",
  transaction: $tx_stmt_2025_10_18_row_27,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_27.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-10-10T00:00:00Z",
  description: "8.91",
  normalizedDescription: "Bank Fee",
  amount: 8.91,
  balance: 3225.13,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 28,
    rawRowText: "8.91; 3,225.13 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 8.91,
    bankChargeZar: null,
    balanceZar: 3225.13
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_10_18_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-10-10T00:00:00Z",
  description: "8.91",
  normalizedDescription: "Bank Fee",
  amount: 8.91,
  balance: 3225.13,
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
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_10_18_row_28.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_28.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_28.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_28 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-28",
  transaction: $tx_stmt_2025_10_18_row_28,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_28.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-10-13T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 2000,
  balance: 1225.13,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 29,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 2,000.00; 1,225.13 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 2000,
    bankChargeZar: 8,
    balanceZar: 1225.13
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_10_18_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-10-13T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 2000,
  balance: 1225.13,
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
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_10_18_row_29.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_29.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_29.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_29 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-29",
  transaction: $tx_stmt_2025_10_18_row_29,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_29.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-10-14T00:00:00Z",
  description: "POS Purchase Payfast*Ivecloud Pt                                                485442*7050 11 Oct",
  normalizedDescription: "POS Purchase Payfast*Ivecloud Pt 485442*7050 11 Oct",
  amount: 100,
  balance: 1125.13,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 30,
    rawRowText: "POS Purchase Payfast*Ivecloud Pt                                                485442*7050 11 Oct; 100.00; 1,125.13 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "POS Purchase Payfast*Ivecloud Pt 485442*7050 11 Oct",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 100,
    bankChargeZar: 3.68,
    balanceZar: 1125.13
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_18_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-10-14T00:00:00Z",
  description: "POS Purchase Payfast*Ivecloud Pt                                                485442*7050 11 Oct",
  normalizedDescription: "POS Purchase Payfast*Ivecloud Pt 485442*7050 11 Oct",
  amount: 100,
  balance: 1125.13,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "POS Purchase Payfast*Ivecloud Pt 485442*7050 11 Oct",
  merchant: $merchant_pos_purchase_payfast_ivecloud_pt_485442_7050_11_oct,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_10_18_row_30.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_30.id, "TransactionMerchant", $merchant_pos_purchase_payfast_ivecloud_pt_485442_7050_11_oct.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_30.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_30 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-30",
  transaction: $tx_stmt_2025_10_18_row_30,
  status: "open",
  question: "What is the exact purpose of this POS Purchase Payfast*Ivecloud Pt 485442*7050 11 Oct transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_pos_purchase_payfast_ivecloud_pt_485442_7050_11_oct,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_30.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-10-16T00:00:00Z",
  description: "2.84",
  normalizedDescription: "Bank Fee",
  amount: 2.84,
  balance: 1122.29,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 31,
    rawRowText: "2.84; 1,122.29 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 2.84,
    bankChargeZar: null,
    balanceZar: 1122.29
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_10_18_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-10-16T00:00:00Z",
  description: "2.84",
  normalizedDescription: "Bank Fee",
  amount: 2.84,
  balance: 1122.29,
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
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_10_18_row_31.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_31.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_31.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_31 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-31",
  transaction: $tx_stmt_2025_10_18_row_31,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_31.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-10-17T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 1000,
  balance: 122.29,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 32,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 1,000.00; 122.29 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1000,
    bankChargeZar: 8,
    balanceZar: 122.29
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_10_18_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-10-17T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 1000,
  balance: 122.29,
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
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_10_18_row_32.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_32.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_32.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_32 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-32",
  transaction: $tx_stmt_2025_10_18_row_32,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_32.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-10-18T00:00:00Z",
  description: "Int On Debit Balance",
  normalizedDescription: "Debit Interest",
  amount: 0.88,
  balance: 121.41,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 33,
    rawRowText: "Int On Debit Balance; 0.88; 121.41 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "debit interest",
    clarificationStatus: "clarified",
    amountZar: 0.88,
    bankChargeZar: null,
    balanceZar: 121.41
},
  notes: "Interest on debit balance."
});
LET $tx_stmt_2025_10_18_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-10-18T00:00:00Z",
  description: "Int On Debit Balance",
  normalizedDescription: "Debit Interest",
  amount: 0.88,
  balance: 121.41,
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
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_10_18_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_33.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_33.id, "TransactionCategory", $cat_fees_debit_interest.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-10-18T00:00:00Z",
  description: "0.00",
  normalizedDescription: "0.00",
  amount: 121.41,
  balance: 5,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 34,
    rawRowText: "0.00; 121.41 Cr; 5.00",
    transactionType: "expense",
    normalizedMerchant: "0.00",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 121.41,
    bankChargeZar: null,
    balanceZar: 5
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_18_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-10-18T00:00:00Z",
  description: "0.00",
  normalizedDescription: "0.00",
  amount: 121.41,
  balance: 5,
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
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_10_18_row_34.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_34.id, "TransactionMerchant", $merchant_0_00.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_34.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_34 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-34",
  transaction: $tx_stmt_2025_10_18_row_34,
  status: "open",
  question: "What is the exact purpose of this 0.00 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_0_00,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_34.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2025-10-18T00:00:00Z",
  description: "93.00",
  normalizedDescription: "Bank Fee",
  amount: 93,
  balance: 28.41,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 35,
    rawRowText: "93.00; 28.41 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 93,
    bankChargeZar: null,
    balanceZar: 28.41
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_10_18_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-35",
  sourceRow: $row_row_35,
  postedAt: "2025-10-18T00:00:00Z",
  description: "93.00",
  normalizedDescription: "Bank Fee",
  amount: 93,
  balance: 28.41,
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
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_10_18_row_35.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_35.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_35.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_35 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-35",
  transaction: $tx_stmt_2025_10_18_row_35,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_35.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2025-10-18T00:00:00Z",
  description: "123.80",
  normalizedDescription: "Bank Fee",
  amount: 123.8,
  balance: 95.39,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 36,
    rawRowText: "123.80; 95.39",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 123.8,
    bankChargeZar: null,
    balanceZar: 95.39
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_10_18_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-36",
  sourceRow: $row_row_36,
  postedAt: "2025-10-18T00:00:00Z",
  description: "123.80",
  normalizedDescription: "Bank Fee",
  amount: 123.8,
  balance: 95.39,
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
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_10_18_row_36.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_36.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_36.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_18_row_36 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-18-row-36",
  transaction: $tx_stmt_2025_10_18_row_36,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-10-18.import.md"
});
fn::createEdge($tx_stmt_2025_10_18_row_36.id, "TransactionClarificationTasks", $task_stmt_2025_10_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 36,
  normalizedCount: 36,
  clarificationCount: 29,
  status: "matched",
  statementDate: "2025-10-18T00:00:00Z",
  notes: "Imported from 2025-10-18.import.md"
});

-- End of generated import
