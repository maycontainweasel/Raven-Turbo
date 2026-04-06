-- Generated from docs/statements/business/2025-12-18.import.md
-- Source: docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf

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
  openingBalance: 9009.92,
  active: true,
  notes: "Imported from GOLD_BUSINESS_ACCOUNT_86.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-12-18-fnb-gold-business-27821",
  sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-12-18T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_software_saas = fn::createCategory({
  space: $space,
  key: "software-saas",
  name: "Software / SaaS",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $cat_accounting_compliance = fn::createCategory({
  space: $space,
  key: "accounting-compliance",
  name: "Accounting / compliance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $cat_internal_transfer = fn::createCategory({
  space: $space,
  key: "internal-transfer",
  name: "Internal transfer",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $cat_client_income = fn::createCategory({
  space: $space,
  key: "client-income",
  name: "Client income",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $cat_insurance = fn::createCategory({
  space: $space,
  key: "insurance",
  name: "Insurance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $cat_hosting_internet = fn::createCategory({
  space: $space,
  key: "hosting-internet",
  name: "Hosting / internet",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $cat_fees_card_charge = fn::createCategory({
  space: $space,
  key: "fees-card-charge",
  name: "Card Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $cat_fees_bank_fee = fn::createCategory({
  space: $space,
  key: "fees-bank-fee",
  name: "Bank Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $cat_fees_electronic_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-electronic-payment-fee",
  name: "Electronic Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $cat_fees_monthly_account_fee = fn::createCategory({
  space: $space,
  key: "fees-monthly-account-fee",
  name: "Monthly Account Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $cat_fees_service_fees = fn::createCategory({
  space: $space,
  key: "fees-service-fees",
  name: "Service Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});

-- Merchant records
LET $merchant_paypal = fn::createMerchant({
  space: $space,
  key: "paypal",
  name: "PayPal",
  normalizedName: "PayPal",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $merchant_tax_management = fn::createMerchant({
  space: $space,
  key: "tax-management",
  name: "Tax Management",
  normalizedName: "Tax Management",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $merchant_notion = fn::createMerchant({
  space: $space,
  key: "notion",
  name: "Notion",
  normalizedName: "Notion",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $merchant_fnb = fn::createMerchant({
  space: $space,
  key: "fnb",
  name: "FNB",
  normalizedName: "FNB",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $merchant_atlassian = fn::createMerchant({
  space: $space,
  key: "atlassian",
  name: "Atlassian",
  normalizedName: "Atlassian",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $merchant_cursor = fn::createMerchant({
  space: $space,
  key: "cursor",
  name: "Cursor",
  normalizedName: "Cursor",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "Mpire Digital Market",
  normalizedName: "Mpire Digital Market",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $merchant_sansor = fn::createMerchant({
  space: $space,
  key: "sansor",
  name: "Sansor",
  normalizedName: "Sansor",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $merchant_magtape_credit = fn::createMerchant({
  space: $space,
  key: "magtape-credit",
  name: "Magtape Credit",
  normalizedName: "Magtape Credit",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $merchant_outsurance = fn::createMerchant({
  space: $space,
  key: "outsurance",
  name: "Outsurance",
  normalizedName: "Outsurance",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $merchant_half_stage = fn::createMerchant({
  space: $space,
  key: "half-stage",
  name: "Half Stage",
  normalizedName: "Half Stage",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $merchant_google_workspace = fn::createMerchant({
  space: $space,
  key: "google-workspace",
  name: "Google Workspace",
  normalizedName: "Google Workspace",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});
LET $merchant_diamatrix = fn::createMerchant({
  space: $space,
  key: "diamatrix",
  name: "Diamatrix",
  normalizedName: "Diamatrix",
  active: true,
  notes: "Imported from 2025-12-18.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-11-19T00:00:00Z",
  description: "POS Purchase 57.55 Paypal *Elite                                                    485442*7050 17 Nov",
  normalizedDescription: "PayPal",
  amount: 57.55,
  balance: 8952.37,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 1,
    rawRowText: "POS Purchase 57.55 Paypal *Elite                                                    485442*7050 17 Nov; 57.55; 8,952.37 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 57.55,
    bankChargeZar: 3.68,
    balanceZar: 8952.37
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_12_18_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-11-19T00:00:00Z",
  description: "POS Purchase 57.55 Paypal *Elite                                                    485442*7050 17 Nov",
  normalizedDescription: "PayPal",
  amount: 57.55,
  balance: 8952.37,
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_12_18_row_01.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_01.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_01.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_01 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-01",
  transaction: $tx_stmt_2025_12_18_row_01,
  status: "open",
  question: "What exactly is the Magtape Unpaid / Not Provided For reversal?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_01.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-11-20T00:00:00Z",
  description: "Internet Pmt To Tax Management                                                      2023 Annual Financia",
  normalizedDescription: "Tax Management",
  amount: 3500,
  balance: 5452.37,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 2,
    rawRowText: "Internet Pmt To Tax Management                                                      2023 Annual Financia; 3,500.00; 5,452.37 Cr",
    transactionType: "expense",
    normalizedMerchant: "Tax Management",
    category: "Accounting / compliance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 3500,
    bankChargeZar: null,
    balanceZar: 5452.37
},
  notes: "Accounting or compliance payment."
});
LET $tx_stmt_2025_12_18_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-11-20T00:00:00Z",
  description: "Internet Pmt To Tax Management                                                      2023 Annual Financia",
  normalizedDescription: "Tax Management",
  amount: 3500,
  balance: 5452.37,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Tax Management",
  merchant: $merchant_tax_management,
  category: $cat_accounting_compliance,
  isTransfer: false,
  manualOverride: false,
  notes: "Accounting or compliance payment."
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_12_18_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_02.id, "TransactionMerchant", $merchant_tax_management.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_02.id, "TransactionCategory", $cat_accounting_compliance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-11-21T00:00:00Z",
  description: "POS Purchase 13.80 Notion Labs,                                                     485442*7050 19 Nov",
  normalizedDescription: "Notion",
  amount: 244.25,
  balance: 5208.12,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 3,
    rawRowText: "POS Purchase 13.80 Notion Labs,                                                     485442*7050 19 Nov; 244.25; 5,208.12 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Notion",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 244.25,
    bankChargeZar: 3.68,
    balanceZar: 5208.12
},
  notes: "Notion subscription spend."
});
LET $tx_stmt_2025_12_18_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-11-21T00:00:00Z",
  description: "POS Purchase 13.80 Notion Labs,                                                     485442*7050 19 Nov",
  normalizedDescription: "Notion",
  amount: 244.25,
  balance: 5208.12,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_12_18_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_03.id, "TransactionMerchant", $merchant_notion.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_03.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-11-21T00:00:00Z",
  description: "POS Purchase 400.78 Paypal *Elit                                                    485442*7050 18 Nov",
  normalizedDescription: "PayPal",
  amount: 400.78,
  balance: 4807.34,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 4,
    rawRowText: "POS Purchase 400.78 Paypal *Elit                                                    485442*7050 18 Nov; 400.78; 4,807.34 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 400.78,
    bankChargeZar: 3.68,
    balanceZar: 4807.34
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_12_18_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-11-21T00:00:00Z",
  description: "POS Purchase 400.78 Paypal *Elit                                                    485442*7050 18 Nov",
  normalizedDescription: "PayPal",
  amount: 400.78,
  balance: 4807.34,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_12_18_row_04.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_04.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_04.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_04 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-04",
  transaction: $tx_stmt_2025_12_18_row_04,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_04.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-11-22T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 4801.34,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 5,
    rawRowText: "6.00; 4,801.34 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 4801.34
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_12_18_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-11-22T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 4801.34,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_12_18_row_05.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_05.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_05.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_05 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-05",
  transaction: $tx_stmt_2025_12_18_row_05,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_05.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-11-22T00:00:00Z",
  description: "POS Purchase 11.50 Atlassian                                                        485442*7050 20 Nov",
  normalizedDescription: "Atlassian",
  amount: 203.62,
  balance: 4597.72,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 6,
    rawRowText: "POS Purchase 11.50 Atlassian                                                        485442*7050 20 Nov; 203.62; 4,597.72 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Atlassian",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 203.62,
    bankChargeZar: 3.68,
    balanceZar: 4597.72
},
  notes: "Atlassian subscription spend."
});
LET $tx_stmt_2025_12_18_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-11-22T00:00:00Z",
  description: "POS Purchase 11.50 Atlassian                                                        485442*7050 20 Nov",
  normalizedDescription: "Atlassian",
  amount: 203.62,
  balance: 4597.72,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_12_18_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_06.id, "TransactionMerchant", $merchant_atlassian.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_06.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-11-22T00:00:00Z",
  description: "POS Purchase 20.99 Atlassian                                                        485442*7050 21 Nov",
  normalizedDescription: "Atlassian",
  amount: 371.56,
  balance: 4226.16,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 7,
    rawRowText: "POS Purchase 20.99 Atlassian                                                        485442*7050 21 Nov; 371.56; 4,226.16 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Atlassian",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 371.56,
    bankChargeZar: 3.68,
    balanceZar: 4226.16
},
  notes: "Atlassian subscription spend."
});
LET $tx_stmt_2025_12_18_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-11-22T00:00:00Z",
  description: "POS Purchase 20.99 Atlassian                                                        485442*7050 21 Nov",
  normalizedDescription: "Atlassian",
  amount: 371.56,
  balance: 4226.16,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_12_18_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_07.id, "TransactionMerchant", $merchant_atlassian.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_07.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-11-22T00:00:00Z",
  description: "POS Purchase 520.27 Paypal *Help                                                    485442*7050 18 Nov",
  normalizedDescription: "PayPal",
  amount: 520.27,
  balance: 3705.89,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 8,
    rawRowText: "POS Purchase 520.27 Paypal *Help                                                    485442*7050 18 Nov; 520.27; 3,705.89 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 520.27,
    bankChargeZar: 3.68,
    balanceZar: 3705.89
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_12_18_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-11-22T00:00:00Z",
  description: "POS Purchase 520.27 Paypal *Help                                                    485442*7050 18 Nov",
  normalizedDescription: "PayPal",
  amount: 520.27,
  balance: 3705.89,
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_12_18_row_08.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_08.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_08.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_08 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-08",
  transaction: $tx_stmt_2025_12_18_row_08,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_08.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-11-25T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 23 Nov",
  normalizedDescription: "Cursor",
  amount: 358.43,
  balance: 3347.46,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 9,
    rawRowText: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 23 Nov; 358.43; 3,347.46 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Cursor",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 358.43,
    bankChargeZar: 3.68,
    balanceZar: 3347.46
},
  notes: "Cursor AI tooling spend."
});
LET $tx_stmt_2025_12_18_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-11-25T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 23 Nov",
  normalizedDescription: "Cursor",
  amount: 358.43,
  balance: 3347.46,
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_12_18_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_09.id, "TransactionMerchant", $merchant_cursor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_09.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-11-26T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 2000,
  balance: 1347.46,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 10,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 2,000.00; 1,347.46 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 2000,
    bankChargeZar: 8,
    balanceZar: 1347.46
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_12_18_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-11-26T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 2000,
  balance: 1347.46,
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_12_18_row_10.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_10.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_10.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_10 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-10",
  transaction: $tx_stmt_2025_12_18_row_10,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_10.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-11-26T00:00:00Z",
  description: "POS Purchase 728.33 Paypal *Madm                                                    485442*7050 22 Nov",
  normalizedDescription: "PayPal",
  amount: 728.33,
  balance: 619.13,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 11,
    rawRowText: "POS Purchase 728.33 Paypal *Madm                                                    485442*7050 22 Nov; 728.33; 619.13 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 728.33,
    bankChargeZar: 3.68,
    balanceZar: 619.13
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_12_18_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-11-26T00:00:00Z",
  description: "POS Purchase 728.33 Paypal *Madm                                                    485442*7050 22 Nov",
  normalizedDescription: "PayPal",
  amount: 728.33,
  balance: 619.13,
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_12_18_row_11.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_11.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_11.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_11 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-11",
  transaction: $tx_stmt_2025_12_18_row_11,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_11.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-11-27T00:00:00Z",
  description: "1.29",
  normalizedDescription: "Bank Fee",
  amount: 1.29,
  balance: 617.84,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 12,
    rawRowText: "1.29; 617.84 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 1.29,
    bankChargeZar: null,
    balanceZar: 617.84
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_12_18_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-11-27T00:00:00Z",
  description: "1.29",
  normalizedDescription: "Bank Fee",
  amount: 1.29,
  balance: 617.84,
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_12_18_row_12.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_12.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_12.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_12 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-12",
  transaction: $tx_stmt_2025_12_18_row_12,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_12.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-11-27T00:00:00Z",
  description: "9.02",
  normalizedDescription: "Bank Fee",
  amount: 9.02,
  balance: 608.82,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 13,
    rawRowText: "9.02; 608.82 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 9.02,
    bankChargeZar: null,
    balanceZar: 608.82
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_12_18_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-11-27T00:00:00Z",
  description: "9.02",
  normalizedDescription: "Bank Fee",
  amount: 9.02,
  balance: 608.82,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_12_18_row_13.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_13.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_13.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_13 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-13",
  transaction: $tx_stmt_2025_12_18_row_13,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_13.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-11-27T00:00:00Z",
  description: "11.71",
  normalizedDescription: "Bank Fee",
  amount: 11.71,
  balance: 597.11,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 14,
    rawRowText: "11.71; 597.11 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 11.71,
    bankChargeZar: null,
    balanceZar: 597.11
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_12_18_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-11-27T00:00:00Z",
  description: "11.71",
  normalizedDescription: "Bank Fee",
  amount: 11.71,
  balance: 597.11,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_12_18_row_14.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_14.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_14.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_14 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-14",
  transaction: $tx_stmt_2025_12_18_row_14,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_14.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-11-28T00:00:00Z",
  description: "FNB OB Pmt Sansor Inv127598",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 7447.11,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 15,
    rawRowText: "FNB OB Pmt Sansor Inv127598; 6,850.00 Cr; 7,447.11 Cr",
    transactionType: "income",
    normalizedMerchant: "Sansor",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6850,
    bankChargeZar: null,
    balanceZar: 7447.11
},
  notes: "Recurring client payment from Sansor."
});
LET $tx_stmt_2025_12_18_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-11-28T00:00:00Z",
  description: "FNB OB Pmt Sansor Inv127598",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 7447.11,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_12_18_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_15.id, "TransactionMerchant", $merchant_sansor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_15.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-11-28T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 5000,
  balance: 2447.11,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 16,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 5,000.00; 2,447.11 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 5000,
    bankChargeZar: 15,
    balanceZar: 2447.11
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_12_18_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-11-28T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 5000,
  balance: 2447.11,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_12_18_row_16.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_16.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_16.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_16 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-16",
  transaction: $tx_stmt_2025_12_18_row_16,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_16.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-12-01T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "Magtape Credit",
  amount: 1400,
  balance: 3847.11,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 17,
    rawRowText: "Magtape Credit 127167 True Fit; 1,400.00 Cr; 3,847.11 Cr",
    transactionType: "income",
    normalizedMerchant: "Magtape Credit",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1400,
    bankChargeZar: null,
    balanceZar: 3847.11
},
  notes: "Magtape credit or reversal still needs exact source confirmation."
});
LET $tx_stmt_2025_12_18_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-12-01T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "Magtape Credit",
  amount: 1400,
  balance: 3847.11,
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_12_18_row_17.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_17.id, "TransactionMerchant", $merchant_magtape_credit.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_17.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_17 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-17",
  transaction: $tx_stmt_2025_12_18_row_17,
  status: "open",
  question: "What is the exact purpose of this Magtape Credit transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_magtape_credit,
  suggestedCategory: $cat_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_17.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-12-01T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Dk8046",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 3069.56,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 18,
    rawRowText: "Magtape Debit Outsurance Ot87677302 Dk8046; 777.55; 3,069.56 Cr; 12.00",
    transactionType: "expense",
    normalizedMerchant: "Outsurance",
    category: "Insurance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 777.55,
    bankChargeZar: 12,
    balanceZar: 3069.56
},
  notes: "Insurance debit."
});
LET $tx_stmt_2025_12_18_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-12-01T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Dk8046",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 3069.56,
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_12_18_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_18.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_18.id, "TransactionCategory", $cat_insurance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-12-03T00:00:00Z",
  description: "FNB App Payment From Half Stage",
  normalizedDescription: "Half Stage",
  amount: 30000,
  balance: 33069.56,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 19,
    rawRowText: "FNB App Payment From Half Stage; 30,000.00 Cr; 33,069.56 Cr",
    transactionType: "income",
    normalizedMerchant: "Half Stage",
    category: "Client income",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 30000,
    bankChargeZar: null,
    balanceZar: 33069.56
},
  notes: "Likely client income; confirm exact source or invoice later."
});
LET $tx_stmt_2025_12_18_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-12-03T00:00:00Z",
  description: "FNB App Payment From Half Stage",
  normalizedDescription: "Half Stage",
  amount: 30000,
  balance: 33069.56,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Half Stage",
  merchant: $merchant_half_stage,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Likely client income; confirm exact source or invoice later."
});
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_12_18_row_19.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_19.id, "TransactionMerchant", $merchant_half_stage.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_19.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_19 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-19",
  transaction: $tx_stmt_2025_12_18_row_19,
  status: "open",
  question: "What is the exact purpose of this Half Stage transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_half_stage,
  suggestedCategory: $cat_client_income,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_19.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-12-03T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 30000,
  balance: 3069.56,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 20,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 30,000.00; 3,069.56 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 30000,
    bankChargeZar: 15,
    balanceZar: 3069.56
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_12_18_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-12-03T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 30000,
  balance: 3069.56,
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
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_12_18_row_20.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_20.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_20.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_20 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-20",
  transaction: $tx_stmt_2025_12_18_row_20,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_20.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-12-03T00:00:00Z",
  description: "POS Purchase 8.38 Google Workspa                                                    485442*7050 01 Dec",
  normalizedDescription: "Google Workspace",
  amount: 171.16,
  balance: 2898.4,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 21,
    rawRowText: "POS Purchase 8.38 Google Workspa                                                    485442*7050 01 Dec; 171.16; 2,898.40 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Google Workspace",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 171.16,
    bankChargeZar: 3.68,
    balanceZar: 2898.4
},
  notes: "Google Workspace subscription spend."
});
LET $tx_stmt_2025_12_18_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-12-03T00:00:00Z",
  description: "POS Purchase 8.38 Google Workspa                                                    485442*7050 01 Dec",
  normalizedDescription: "Google Workspace",
  amount: 171.16,
  balance: 2898.4,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Google Workspace",
  merchant: $merchant_google_workspace,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Google Workspace subscription spend."
});
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_12_18_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_21.id, "TransactionMerchant", $merchant_google_workspace.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_21.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-12-04T00:00:00Z",
  description: "POS Purchase Diamatrix                                                              485442*7050 02 Dec",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 2370.4,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 22,
    rawRowText: "POS Purchase Diamatrix                                                              485442*7050 02 Dec; 528.00; 2,370.40 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Diamatrix",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 528,
    bankChargeZar: 3.68,
    balanceZar: 2370.4
},
  notes: "Hosting or software-service spend."
});
LET $tx_stmt_2025_12_18_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-12-04T00:00:00Z",
  description: "POS Purchase Diamatrix                                                              485442*7050 02 Dec",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 2370.4,
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
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_12_18_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_22.id, "TransactionMerchant", $merchant_diamatrix.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_22.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-12-05T00:00:00Z",
  description: "POS Purchase 13.80 Notion Labs,                                                     485442*7050 04 Dec",
  normalizedDescription: "Notion",
  amount: 242.59,
  balance: 2127.81,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 23,
    rawRowText: "POS Purchase 13.80 Notion Labs,                                                     485442*7050 04 Dec; 242.59; 2,127.81 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Notion",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 242.59,
    bankChargeZar: 3.68,
    balanceZar: 2127.81
},
  notes: "Notion subscription spend."
});
LET $tx_stmt_2025_12_18_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-12-05T00:00:00Z",
  description: "POS Purchase 13.80 Notion Labs,                                                     485442*7050 04 Dec",
  normalizedDescription: "Notion",
  amount: 242.59,
  balance: 2127.81,
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_12_18_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_23.id, "TransactionMerchant", $merchant_notion.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_23.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-12-06T00:00:00Z",
  description: "POS Purchase 125.05 Paypal *Vect                                                    485442*7050 04 Dec",
  normalizedDescription: "PayPal",
  amount: 125.05,
  balance: 2002.76,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 24,
    rawRowText: "POS Purchase 125.05 Paypal *Vect                                                    485442*7050 04 Dec; 125.05; 2,002.76 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 125.05,
    bankChargeZar: 3.68,
    balanceZar: 2002.76
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_12_18_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-12-06T00:00:00Z",
  description: "POS Purchase 125.05 Paypal *Vect                                                    485442*7050 04 Dec",
  normalizedDescription: "PayPal",
  amount: 125.05,
  balance: 2002.76,
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
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_12_18_row_24.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_24.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_24.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_24 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-24",
  transaction: $tx_stmt_2025_12_18_row_24,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_24.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-12-06T00:00:00Z",
  description: "POS Purchase 354.04 Paypal *Scre                                                    485442*7050 04 Dec",
  normalizedDescription: "PayPal",
  amount: 354.04,
  balance: 1648.72,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 25,
    rawRowText: "POS Purchase 354.04 Paypal *Scre                                                    485442*7050 04 Dec; 354.04; 1,648.72 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 354.04,
    bankChargeZar: 3.68,
    balanceZar: 1648.72
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_12_18_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-12-06T00:00:00Z",
  description: "POS Purchase 354.04 Paypal *Scre                                                    485442*7050 04 Dec",
  normalizedDescription: "PayPal",
  amount: 354.04,
  balance: 1648.72,
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
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_12_18_row_25.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_25.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_25.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_25 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-25",
  transaction: $tx_stmt_2025_12_18_row_25,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_25.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-12-09T00:00:00Z",
  description: "2.81",
  normalizedDescription: "Bank Fee",
  amount: 2.81,
  balance: 1645.91,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 26,
    rawRowText: "2.81; 1,645.91 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 2.81,
    bankChargeZar: null,
    balanceZar: 1645.91
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_12_18_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-12-09T00:00:00Z",
  description: "2.81",
  normalizedDescription: "Bank Fee",
  amount: 2.81,
  balance: 1645.91,
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
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_12_18_row_26.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_26.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_26.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_26 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-26",
  transaction: $tx_stmt_2025_12_18_row_26,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_26.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-12-09T00:00:00Z",
  description: "7.97",
  normalizedDescription: "Bank Fee",
  amount: 7.97,
  balance: 1637.94,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 27,
    rawRowText: "7.97; 1,637.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 7.97,
    bankChargeZar: null,
    balanceZar: 1637.94
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_12_18_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-12-09T00:00:00Z",
  description: "7.97",
  normalizedDescription: "Bank Fee",
  amount: 7.97,
  balance: 1637.94,
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
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_12_18_row_27.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_27.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_27.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_27 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-27",
  transaction: $tx_stmt_2025_12_18_row_27,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_27.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-12-11T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 1000,
  balance: 637.94,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 28,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 1,000.00; 637.94 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1000,
    bankChargeZar: 8,
    balanceZar: 637.94
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_12_18_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-12-11T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 1000,
  balance: 637.94,
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
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_12_18_row_28.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_28.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_28.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_28 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-28",
  transaction: $tx_stmt_2025_12_18_row_28,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_28.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-12-12T00:00:00Z",
  description: "FNB OB Pmt Sansor Inv-127600",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 7487.94,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 29,
    rawRowText: "FNB OB Pmt Sansor Inv-127600; 6,850.00 Cr; 7,487.94 Cr",
    transactionType: "income",
    normalizedMerchant: "Sansor",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6850,
    bankChargeZar: null,
    balanceZar: 7487.94
},
  notes: "Recurring client payment from Sansor."
});
LET $tx_stmt_2025_12_18_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-12-12T00:00:00Z",
  description: "FNB OB Pmt Sansor Inv-127600",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 7487.94,
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
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_12_18_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_29.id, "TransactionMerchant", $merchant_sansor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_29.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-12-12T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 5500,
  balance: 1987.94,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 30,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 5,500.00; 1,987.94 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 5500,
    bankChargeZar: 15,
    balanceZar: 1987.94
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_12_18_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-12-12T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 5500,
  balance: 1987.94,
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
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_12_18_row_30.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_30.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_30.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_30 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-30",
  transaction: $tx_stmt_2025_12_18_row_30,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_30.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-12-13T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 1000,
  balance: 987.94,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 31,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 1,000.00; 987.94 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1000,
    bankChargeZar: 8,
    balanceZar: 987.94
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_12_18_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-12-13T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 1000,
  balance: 987.94,
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
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_12_18_row_31.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_31.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_31.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_18_row_31 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-18-row-31",
  transaction: $tx_stmt_2025_12_18_row_31,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-12-18.import.md"
});
fn::createEdge($tx_stmt_2025_12_18_row_31.id, "TransactionClarificationTasks", $task_stmt_2025_12_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-12-18T00:00:00Z",
  description: "Electronic Payment Fee",
  normalizedDescription: "Electronic Payment Fee",
  amount: 0,
  balance: 987.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 32,
    rawRowText: "Electronic Payment Fee; 0.00; 987.94 Cr; 5.00",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "electronic payment fee",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: 5,
    balanceZar: 987.94
},
  notes: "Electronic payment fee captured separately from the transaction amount."
});
LET $tx_stmt_2025_12_18_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-12-18T00:00:00Z",
  description: "Electronic Payment Fee",
  normalizedDescription: "Electronic Payment Fee",
  amount: 0,
  balance: 987.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_electronic_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Electronic payment fee captured separately from the transaction amount."
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_12_18_row_32.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_32.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_32.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-12-18T00:00:00Z",
  description: "Monthly Account Fee",
  normalizedDescription: "Monthly Account Fee",
  amount: 93,
  balance: 894.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 33,
    rawRowText: "Monthly Account Fee; 93.00; 894.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "monthly account fee",
    clarificationStatus: "clarified",
    amountZar: 93,
    bankChargeZar: null,
    balanceZar: 894.94
},
  notes: "Monthly account fee."
});
LET $tx_stmt_2025_12_18_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-12-18T00:00:00Z",
  description: "Monthly Account Fee",
  normalizedDescription: "Monthly Account Fee",
  amount: 93,
  balance: 894.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_monthly_account_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Monthly account fee."
});
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_12_18_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_33.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_33.id, "TransactionCategory", $cat_fees_monthly_account_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-12-18T00:00:00Z",
  description: "Service Fees",
  normalizedDescription: "Service Fees",
  amount: 133.84,
  balance: 761.1,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_86.pdf",
    statementPeriodStart: "2025-11-18",
    statementPeriodEnd: "2025-12-18",
    rowNo: 34,
    rawRowText: "Service Fees; 133.84; 761.10 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fees",
    clarificationStatus: "clarified",
    amountZar: 133.84,
    bankChargeZar: null,
    balanceZar: 761.1
},
  notes: "Service fees total for the statement period."
});
LET $tx_stmt_2025_12_18_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-18-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-12-18T00:00:00Z",
  description: "Service Fees",
  normalizedDescription: "Service Fees",
  amount: 133.84,
  balance: 761.1,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fees,
  isTransfer: false,
  manualOverride: false,
  notes: "Service fees total for the statement period."
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_12_18_row_34.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_12_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_34.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_18_row_34.id, "TransactionCategory", $cat_fees_service_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 34,
  normalizedCount: 34,
  clarificationCount: 20,
  status: "matched",
  statementDate: "2025-12-18T00:00:00Z",
  notes: "Imported from 2025-12-18.import.md"
});

-- End of generated import
