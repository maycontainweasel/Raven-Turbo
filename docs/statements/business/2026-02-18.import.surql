-- Generated from docs/statements/business/2026-02-18.import.md
-- Source: docs/statements/business/18 February 2026.pdf

USE NS raven DB raven1;

-- Base environment and account
LET $space = fn::createFinancialSpace({
  key: "mpire-business",
  name: "MPIRE Business",
  spaceType: "business",
  currency: "ZAR",
  active: true,
  description: "Business environment for MPIRE"
});
LET $account = fn::createAccount({
  space: $space,
  key: "fnb-gold-business-27821",
  name: "FNB Gold Business Account",
  bankName: "FNB",
  accountType: "current",
  currency: "ZAR",
  accountNumberLast4: "27821",
  openingBalance: 1478.39,
  active: true,
  notes: "Imported from 18 February 2026.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2026-02-18-fnb-business",
  sourceFileName: "docs/statements/business/18 February 2026.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2026-02-18T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2026-02-18.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $cat_crypto_trading = fn::createCategory({
  space: $space,
  key: "crypto-trading",
  name: "Crypto / trading",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $cat_ai_software = fn::createCategory({
  space: $space,
  key: "ai-software",
  name: "AI / software",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $cat_insurance = fn::createCategory({
  space: $space,
  key: "insurance",
  name: "Insurance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $cat_software_hosting = fn::createCategory({
  space: $space,
  key: "software-hosting",
  name: "Software / hosting",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $cat_online_services = fn::createCategory({
  space: $space,
  key: "online-services",
  name: "Online services",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $cat_transfer_services = fn::createCategory({
  space: $space,
  key: "transfer-services",
  name: "Transfer services",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $cat_software_productivity = fn::createCategory({
  space: $space,
  key: "software-productivity",
  name: "Software / productivity",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $cat_fees_service_fee = fn::createCategory({
  space: $space,
  key: "fees-service-fee",
  name: "Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $cat_fees_excess_item_fee = fn::createCategory({
  space: $space,
  key: "fees-excess-item-fee",
  name: "Excess Item Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $cat_fees_debit_interest = fn::createCategory({
  space: $space,
  key: "fees-debit-interest",
  name: "Debit Interest",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $cat_fees_monthly_account_fee = fn::createCategory({
  space: $space,
  key: "fees-monthly-account-fee",
  name: "Monthly Account Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});

-- Merchant records
LET $merchant_outsurance = fn::createMerchant({
  space: $space,
  key: "outsurance",
  name: "Outsurance",
  normalizedName: "Outsurance",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_fnb = fn::createMerchant({
  space: $space,
  key: "fnb",
  name: "FNB",
  normalizedName: "FNB",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_ets = fn::createMerchant({
  space: $space,
  key: "ets",
  name: "Ets",
  normalizedName: "Ets",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_valr = fn::createMerchant({
  space: $space,
  key: "valr",
  name: "VALR",
  normalizedName: "VALR",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_sansor = fn::createMerchant({
  space: $space,
  key: "sansor",
  name: "Sansor",
  normalizedName: "Sansor",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_true_fit = fn::createMerchant({
  space: $space,
  key: "true-fit",
  name: "True Fit",
  normalizedName: "True Fit",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_openai = fn::createMerchant({
  space: $space,
  key: "openai",
  name: "OpenAI",
  normalizedName: "OpenAI",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_diamatrix = fn::createMerchant({
  space: $space,
  key: "diamatrix",
  name: "Diamatrix",
  normalizedName: "Diamatrix",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_b_peters = fn::createMerchant({
  space: $space,
  key: "b-peters",
  name: "B Peters",
  normalizedName: "B Peters",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "Mpire Digital Market",
  normalizedName: "Mpire Digital Market",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_paypal_elite = fn::createMerchant({
  space: $space,
  key: "paypal-elite",
  name: "PayPal / Elite",
  normalizedName: "PayPal / Elite",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_paypal_ivec = fn::createMerchant({
  space: $space,
  key: "paypal-ivec",
  name: "PayPal / Ivec",
  normalizedName: "PayPal / Ivec",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_wise = fn::createMerchant({
  space: $space,
  key: "wise",
  name: "Wise",
  normalizedName: "Wise",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_afrihost = fn::createMerchant({
  space: $space,
  key: "afrihost",
  name: "Afrihost",
  normalizedName: "Afrihost",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_atlassian = fn::createMerchant({
  space: $space,
  key: "atlassian",
  name: "Atlassian",
  normalizedName: "Atlassian",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_country_meat_lonehil = fn::createMerchant({
  space: $space,
  key: "country-meat-lonehil",
  name: "Country Meat Lonehil",
  normalizedName: "Country Meat Lonehil",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_notion_labs = fn::createMerchant({
  space: $space,
  key: "notion-labs",
  name: "Notion Labs",
  normalizedName: "Notion Labs",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});
LET $merchant_aam = fn::createMerchant({
  space: $space,
  key: "aam",
  name: "Aam",
  normalizedName: "Aam",
  active: true,
  notes: "Imported from 2026-02-18.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2026-01-20T00:00:00Z",
  description: "Magtape Credit Outsuranceot87677302Outbonus",
  normalizedDescription: "Outsurance",
  amount: 2510.59,
  balance: 3988.98,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 1,
    rawRowText: "Magtape Credit Outsuranceot87677302Outbonus; 2,510.59 Cr; 3,988.98 Cr",
    transactionType: "income",
    normalizedMerchant: "Outsurance",
    category: "Income",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 2510.59,
    bankChargeZar: null,
    balanceZar: 3988.98
},
  notes: "Insurance bonus or rebate credit; confirm later."
});
LET $tx_stmt_2026_02_18_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-01",
  sourceRow: $row_row_01,
  postedAt: "2026-01-20T00:00:00Z",
  description: "Magtape Credit Outsuranceot87677302Outbonus",
  normalizedDescription: "Outsurance",
  amount: 2510.59,
  balance: 3988.98,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Outsurance",
  merchant: $merchant_outsurance,
  category: $cat_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Insurance bonus or rebate credit; confirm later."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2026_02_18_row_01.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_01.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_01.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_02_18_row_01 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-02-18-row-01",
  transaction: $tx_stmt_2026_02_18_row_01,
  status: "open",
  question: "What exactly is the Magtape Unpaid / Not Provided For reversal?",
  reason: "Returned item / reversal needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_outsurance,
  suggestedCategory: $cat_income,
  confidence: 0.25,
  notes: "Imported from 2026-02-18.import.md"
});
fn::createEdge($tx_stmt_2026_02_18_row_01.id, "TransactionClarificationTasks", $task_stmt_2026_02_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2026-01-21T00:00:00Z",
  description: "1.29",
  normalizedDescription: "Service Fee",
  amount: 1.29,
  balance: 3987.69,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 2,
    rawRowText: "1.29; 3,987.69 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 1.29,
    bankChargeZar: null,
    balanceZar: 3987.69
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-02",
  sourceRow: $row_row_02,
  postedAt: "2026-01-21T00:00:00Z",
  description: "1.29",
  normalizedDescription: "Service Fee",
  amount: 1.29,
  balance: 3987.69,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2026_02_18_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_02.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_02.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2026-01-21T00:00:00Z",
  description: "1.63",
  normalizedDescription: "Service Fee",
  amount: 1.63,
  balance: 3986.06,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 3,
    rawRowText: "1.63; 3,986.06 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 1.63,
    bankChargeZar: null,
    balanceZar: 3986.06
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-03",
  sourceRow: $row_row_03,
  postedAt: "2026-01-21T00:00:00Z",
  description: "1.63",
  normalizedDescription: "Service Fee",
  amount: 1.63,
  balance: 3986.06,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2026_02_18_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_03.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_03.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2026-01-21T00:00:00Z",
  description: "6.08",
  normalizedDescription: "Service Fee",
  amount: 6.08,
  balance: 3979.98,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 4,
    rawRowText: "6.08; 3,979.98 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6.08,
    bankChargeZar: null,
    balanceZar: 3979.98
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-04",
  sourceRow: $row_row_04,
  postedAt: "2026-01-21T00:00:00Z",
  description: "6.08",
  normalizedDescription: "Service Fee",
  amount: 6.08,
  balance: 3979.98,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2026_02_18_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_04.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_04.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2026-01-21T00:00:00Z",
  description: "7.72",
  normalizedDescription: "Service Fee",
  amount: 7.72,
  balance: 3972.26,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 5,
    rawRowText: "7.72; 3,972.26 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 7.72,
    bankChargeZar: null,
    balanceZar: 3972.26
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-05",
  sourceRow: $row_row_05,
  postedAt: "2026-01-21T00:00:00Z",
  description: "7.72",
  normalizedDescription: "Service Fee",
  amount: 7.72,
  balance: 3972.26,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2026_02_18_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_05.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_05.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2026-01-21T00:00:00Z",
  description: "9.39",
  normalizedDescription: "Service Fee",
  amount: 9.39,
  balance: 3962.87,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 6,
    rawRowText: "9.39; 3,962.87 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 9.39,
    bankChargeZar: null,
    balanceZar: 3962.87
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-06",
  sourceRow: $row_row_06,
  postedAt: "2026-01-21T00:00:00Z",
  description: "9.39",
  normalizedDescription: "Service Fee",
  amount: 9.39,
  balance: 3962.87,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2026_02_18_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_06.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_06.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2026-01-21T00:00:00Z",
  description: "9.39",
  normalizedDescription: "Service Fee",
  amount: 9.39,
  balance: 3953.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 7,
    rawRowText: "9.39; 3,953.48 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 9.39,
    bankChargeZar: null,
    balanceZar: 3953.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-07",
  sourceRow: $row_row_07,
  postedAt: "2026-01-21T00:00:00Z",
  description: "9.39",
  normalizedDescription: "Service Fee",
  amount: 9.39,
  balance: 3953.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2026_02_18_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_07.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_07.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2026-01-22T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 3947.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 8,
    rawRowText: "6.00; 3,947.48 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 3947.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-08",
  sourceRow: $row_row_08,
  postedAt: "2026-01-22T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 3947.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2026_02_18_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_08.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_08.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2026-01-23T00:00:00Z",
  description: "Magtape Credit Ets",
  normalizedDescription: "Ets",
  amount: 1780,
  balance: 5727.48,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 9,
    rawRowText: "Magtape Credit Ets; 1,780.00 Cr; 5,727.48 Cr",
    transactionType: "income",
    normalizedMerchant: "Ets",
    category: "Income",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1780,
    bankChargeZar: null,
    balanceZar: 5727.48
},
  notes: "Incoming credit; source to confirm later."
});
LET $tx_stmt_2026_02_18_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-09",
  sourceRow: $row_row_09,
  postedAt: "2026-01-23T00:00:00Z",
  description: "Magtape Credit Ets",
  normalizedDescription: "Ets",
  amount: 1780,
  balance: 5727.48,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Ets",
  merchant: $merchant_ets,
  category: $cat_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Incoming credit; source to confirm later."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2026_02_18_row_09.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_09.id, "TransactionMerchant", $merchant_ets.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_09.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_02_18_row_09 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-02-18-row-09",
  transaction: $tx_stmt_2026_02_18_row_09,
  status: "open",
  question: "What is the exact purpose of this Ets transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_ets,
  suggestedCategory: $cat_income,
  confidence: 0.25,
  notes: "Imported from 2026-02-18.import.md"
});
fn::createEdge($tx_stmt_2026_02_18_row_09.id, "TransactionClarificationTasks", $task_stmt_2026_02_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2026-01-23T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 5721.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 10,
    rawRowText: "6.00; 5,721.48 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 5721.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-10",
  sourceRow: $row_row_10,
  postedAt: "2026-01-23T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 5721.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2026_02_18_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_10.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_10.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2026-01-24T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 5715.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 11,
    rawRowText: "6.00; 5,715.48 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 5715.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-11",
  sourceRow: $row_row_11,
  postedAt: "2026-01-24T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 5715.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2026_02_18_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_11.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_11.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2026-01-24T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 5709.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 12,
    rawRowText: "6.00; 5,709.48 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 5709.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-12",
  sourceRow: $row_row_12,
  postedAt: "2026-01-24T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 5709.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2026_02_18_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_12.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_12.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2026-01-24T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 4709.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 13,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 21 Jan; 1,000.00; 4,709.48 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: 3.68,
    balanceZar: 4709.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-13",
  sourceRow: $row_row_13,
  postedAt: "2026-01-24T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 4709.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2026_02_18_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_13.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_13.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2026-01-24T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 2709.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 14,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 21 Jan; 2,000.00; 2,709.48 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: 3.68,
    balanceZar: 2709.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-14",
  sourceRow: $row_row_14,
  postedAt: "2026-01-24T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 2709.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2026_02_18_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_14.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_14.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2026-01-26T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 2703.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 15,
    rawRowText: "6.00; 2,703.48 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 2703.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-15",
  sourceRow: $row_row_15,
  postedAt: "2026-01-26T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 2703.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2026_02_18_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_15.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_15.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2026-01-26T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 2697.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 16,
    rawRowText: "6.00; 2,697.48 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 2697.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-16",
  sourceRow: $row_row_16,
  postedAt: "2026-01-26T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 2697.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2026_02_18_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_16.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_16.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2026-01-27T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 450,
  balance: 2247.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 17,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 23 Jan; 450.00; 2,247.48 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 450,
    bankChargeZar: 3.68,
    balanceZar: 2247.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-17",
  sourceRow: $row_row_17,
  postedAt: "2026-01-27T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 450,
  balance: 2247.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2026_02_18_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_17.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_17.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2026-01-28T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 2241.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 18,
    rawRowText: "6.00; 2,241.48 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 2241.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-18",
  sourceRow: $row_row_18,
  postedAt: "2026-01-28T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 2241.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2026_02_18_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_18.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_18.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2026-01-28T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 2235.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 19,
    rawRowText: "6.00; 2,235.48 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 2235.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-19",
  sourceRow: $row_row_19,
  postedAt: "2026-01-28T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 2235.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2026_02_18_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_19.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_19.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2026-01-28T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 200,
  balance: 2035.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 20,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 24 Jan; 200.00; 2,035.48 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 200,
    bankChargeZar: 3.68,
    balanceZar: 2035.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-20",
  sourceRow: $row_row_20,
  postedAt: "2026-01-28T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 200,
  balance: 2035.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2026_02_18_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_20.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_20.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2026-01-28T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 250,
  balance: 1785.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 21,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 24 Jan; 250.00; 1,785.48 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 250,
    bankChargeZar: 3.68,
    balanceZar: 1785.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-21",
  sourceRow: $row_row_21,
  postedAt: "2026-01-28T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 250,
  balance: 1785.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2026_02_18_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_21.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_21.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2026-01-28T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 350,
  balance: 1435.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 22,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 24 Jan; 350.00; 1,435.48 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 350,
    bankChargeZar: 3.68,
    balanceZar: 1435.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-22",
  sourceRow: $row_row_22,
  postedAt: "2026-01-28T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 350,
  balance: 1435.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2026_02_18_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_22.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_22.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2026-01-28T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 400,
  balance: 1035.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 23,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 24 Jan; 400.00; 1,035.48 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 400,
    bankChargeZar: 3.68,
    balanceZar: 1035.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-23",
  sourceRow: $row_row_23,
  postedAt: "2026-01-28T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 400,
  balance: 1035.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2026_02_18_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_23.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_23.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2026-01-28T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 535.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 24,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 24 Jan; 500.00; 535.48 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 500,
    bankChargeZar: 3.68,
    balanceZar: 535.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-24",
  sourceRow: $row_row_24,
  postedAt: "2026-01-28T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 535.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2026_02_18_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_24.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_24.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2026-01-29T00:00:00Z",
  description: "FNB OB Pmt Sansor Inv-127608",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 7385.48,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 25,
    rawRowText: "FNB OB Pmt Sansor Inv-127608; 6,850.00 Cr; 7,385.48 Cr",
    transactionType: "income",
    normalizedMerchant: "Sansor",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6850,
    bankChargeZar: null,
    balanceZar: 7385.48
},
  notes: "Monthly customer retainer / recurring payment."
});
LET $tx_stmt_2026_02_18_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-25",
  sourceRow: $row_row_25,
  postedAt: "2026-01-29T00:00:00Z",
  description: "FNB OB Pmt Sansor Inv-127608",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 7385.48,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Sansor",
  merchant: $merchant_sansor,
  category: $cat_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Monthly customer retainer / recurring payment."
});
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2026_02_18_row_25.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_25.id, "TransactionMerchant", $merchant_sansor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_25.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2026-01-29T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "True Fit",
  amount: 1000,
  balance: 8385.48,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 26,
    rawRowText: "Magtape Credit 127167 True Fit; 1,000.00 Cr; 8,385.48 Cr",
    transactionType: "income",
    normalizedMerchant: "True Fit",
    category: "Income",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: 8385.48
},
  notes: "Incoming credit; source to confirm later."
});
LET $tx_stmt_2026_02_18_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-26",
  sourceRow: $row_row_26,
  postedAt: "2026-01-29T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "True Fit",
  amount: 1000,
  balance: 8385.48,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  merchantName: "True Fit",
  merchant: $merchant_true_fit,
  category: $cat_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Incoming credit; source to confirm later."
});
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2026_02_18_row_26.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_26.id, "TransactionMerchant", $merchant_true_fit.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_26.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_02_18_row_26 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-02-18-row-26",
  transaction: $tx_stmt_2026_02_18_row_26,
  status: "open",
  question: "What is the exact purpose of this True Fit transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_true_fit,
  suggestedCategory: $cat_income,
  confidence: 0.25,
  notes: "Imported from 2026-02-18.import.md"
});
fn::createEdge($tx_stmt_2026_02_18_row_26.id, "TransactionClarificationTasks", $task_stmt_2026_02_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2026-01-29T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 8379.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 27,
    rawRowText: "6.00; 8,379.48 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 8379.48
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-27",
  sourceRow: $row_row_27,
  postedAt: "2026-01-29T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 8379.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2026_02_18_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_27.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_27.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2026-01-31T00:00:00Z",
  description: "POS Purchase 230.00 Openai *Chat",
  normalizedDescription: "OpenAI",
  amount: 3768.54,
  balance: 4610.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 28,
    rawRowText: "POS Purchase 230.00 Openai *Chat; 485442*7050 29 Jan; 3,768.54; 4,610.94 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "OpenAI",
    category: "AI / software",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 3768.54,
    bankChargeZar: 3.68,
    balanceZar: 4610.94
},
  notes: "AI / software expense."
});
LET $tx_stmt_2026_02_18_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-28",
  sourceRow: $row_row_28,
  postedAt: "2026-01-31T00:00:00Z",
  description: "POS Purchase 230.00 Openai *Chat",
  normalizedDescription: "OpenAI",
  amount: 3768.54,
  balance: 4610.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "OpenAI",
  merchant: $merchant_openai,
  category: $cat_ai_software,
  isTransfer: false,
  manualOverride: false,
  notes: "AI / software expense."
});
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2026_02_18_row_28.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_28.id, "TransactionMerchant", $merchant_openai.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_28.id, "TransactionCategory", $cat_ai_software.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2026-02-02T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 4604.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 29,
    rawRowText: "6.00; 4,604.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 4604.94
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-29",
  sourceRow: $row_row_29,
  postedAt: "2026-02-02T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 4604.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2026_02_18_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_29.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_29.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2026-02-02T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 4598.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 30,
    rawRowText: "6.00; 4,598.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 4598.94
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-30",
  sourceRow: $row_row_30,
  postedAt: "2026-02-02T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 4598.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2026_02_18_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_30.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_30.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2026-02-02T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 4592.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 31,
    rawRowText: "6.00; 4,592.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 4592.94
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-31",
  sourceRow: $row_row_31,
  postedAt: "2026-02-02T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 4592.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2026_02_18_row_31.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_31.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_31.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2026-02-02T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 4586.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 32,
    rawRowText: "6.00; 4,586.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 4586.94
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-32",
  sourceRow: $row_row_32,
  postedAt: "2026-02-02T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 4586.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2026_02_18_row_32.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_32.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_32.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2026-02-02T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Mr0066",
  normalizedDescription: "Outsurance",
  amount: 774.86,
  balance: 3812.08,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 33,
    rawRowText: "Magtape Debit Outsurance Ot87677302 Mr0066; 774.86; 3,812.08 Cr; 12.00",
    transactionType: "expense",
    normalizedMerchant: "Outsurance",
    category: "Insurance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 774.86,
    bankChargeZar: 12,
    balanceZar: 3812.08
},
  notes: "Insurance expense."
});
LET $tx_stmt_2026_02_18_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-33",
  sourceRow: $row_row_33,
  postedAt: "2026-02-02T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Mr0066",
  normalizedDescription: "Outsurance",
  amount: 774.86,
  balance: 3812.08,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Outsurance",
  merchant: $merchant_outsurance,
  category: $cat_insurance,
  isTransfer: false,
  manualOverride: false,
  notes: "Insurance expense."
});
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2026_02_18_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_33.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_33.id, "TransactionCategory", $cat_insurance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2026-02-03T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 1812.08,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 34,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 30 Jan; 2,000.00; 1,812.08 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: 3.68,
    balanceZar: 1812.08
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-34",
  sourceRow: $row_row_34,
  postedAt: "2026-02-03T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 1812.08,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2026_02_18_row_34.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_34.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_34.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2026-02-04T00:00:00Z",
  description: "Magtape Unpaid Not Provided For",
  normalizedDescription: "Outsurance",
  amount: 774.86,
  balance: 2586.94,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 35,
    rawRowText: "Magtape Unpaid Not Provided For; 774.86 Cr; 2,586.94 Cr",
    transactionType: "reversal",
    normalizedMerchant: "Outsurance",
    category: "Reversal / refund",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 774.86,
    bankChargeZar: null,
    balanceZar: 2586.94
},
  notes: "Returned item / reversal of earlier Outsurance debit."
});
LET $tx_stmt_2026_02_18_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-35",
  sourceRow: $row_row_35,
  postedAt: "2026-02-04T00:00:00Z",
  description: "Magtape Unpaid Not Provided For",
  normalizedDescription: "Outsurance",
  amount: 774.86,
  balance: 2586.94,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Outsurance",
  merchant: $merchant_outsurance,
  category: $cat_reversal_refund,
  isTransfer: false,
  manualOverride: false,
  notes: "Returned item / reversal of earlier Outsurance debit."
});
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2026_02_18_row_35.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_35.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_35.id, "TransactionCategory", $cat_reversal_refund.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_02_18_row_35 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-02-18-row-35",
  transaction: $tx_stmt_2026_02_18_row_35,
  status: "open",
  question: "What is the exact purpose of this Outsurance transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_outsurance,
  suggestedCategory: $cat_reversal_refund,
  confidence: 0.25,
  notes: "Imported from 2026-02-18.import.md"
});
fn::createEdge($tx_stmt_2026_02_18_row_35.id, "TransactionClarificationTasks", $task_stmt_2026_02_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2026-02-04T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 2580.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 36,
    rawRowText: "6.00; 2,580.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 2580.94
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-36",
  sourceRow: $row_row_36,
  postedAt: "2026-02-04T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 2580.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2026_02_18_row_36.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_36.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_36.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 37
LET $row_row_37 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 37,
  postedAt: "2026-02-04T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 2574.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 37,
    rawRowText: "6.00; 2,574.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 2574.94
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_37 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-37",
  sourceRow: $row_row_37,
  postedAt: "2026-02-04T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 2574.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_37.id, { transaction: $tx_stmt_2026_02_18_row_37.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_37.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_37.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_37.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 38
LET $row_row_38 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 38,
  postedAt: "2026-02-04T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 2568.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 38,
    rawRowText: "6.00; 2,568.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 2568.94
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_38 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-38",
  sourceRow: $row_row_38,
  postedAt: "2026-02-04T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 2568.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_38.id, { transaction: $tx_stmt_2026_02_18_row_38.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_38.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_38.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_38.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 39
LET $row_row_39 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 39,
  postedAt: "2026-02-04T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 400,
  balance: 2168.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 39,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 31 Jan; 400.00; 2,168.94 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 400,
    bankChargeZar: 3.68,
    balanceZar: 2168.94
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_39 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-39",
  sourceRow: $row_row_39,
  postedAt: "2026-02-04T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 400,
  balance: 2168.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_39.id, { transaction: $tx_stmt_2026_02_18_row_39.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_39.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_39.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_39.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 40
LET $row_row_40 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 40,
  postedAt: "2026-02-04T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 1668.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 40,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 31 Jan; 500.00; 1,668.94 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 500,
    bankChargeZar: 3.68,
    balanceZar: 1668.94
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_40 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-40",
  sourceRow: $row_row_40,
  postedAt: "2026-02-04T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 1668.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_40.id, { transaction: $tx_stmt_2026_02_18_row_40.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_40.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_40.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_40.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 41
LET $row_row_41 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 41,
  postedAt: "2026-02-04T00:00:00Z",
  description: "POS Purchase Diamatrix",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 1140.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 41,
    rawRowText: "POS Purchase Diamatrix; 485442*7050 01 Feb; 528.00; 1,140.94 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Diamatrix",
    category: "Software / hosting",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 528,
    bankChargeZar: 3.68,
    balanceZar: 1140.94
},
  notes: "Hosting / software expense."
});
LET $tx_stmt_2026_02_18_row_41 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-41",
  sourceRow: $row_row_41,
  postedAt: "2026-02-04T00:00:00Z",
  description: "POS Purchase Diamatrix",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 1140.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Diamatrix",
  merchant: $merchant_diamatrix,
  category: $cat_software_hosting,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting / software expense."
});
fn::updateStatementRow($row_row_41.id, { transaction: $tx_stmt_2026_02_18_row_41.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_41.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_41.id, "TransactionMerchant", $merchant_diamatrix.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_41.id, "TransactionCategory", $cat_software_hosting.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 42
LET $row_row_42 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 42,
  postedAt: "2026-02-04T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 140.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 42,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 31 Jan; 1,000.00; 140.94 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: 3.68,
    balanceZar: 140.94
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_42 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-42",
  sourceRow: $row_row_42,
  postedAt: "2026-02-04T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 140.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_42.id, { transaction: $tx_stmt_2026_02_18_row_42.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_42.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_42.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_42.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 43
LET $row_row_43 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 43,
  postedAt: "2026-02-05T00:00:00Z",
  description: "155.00",
  normalizedDescription: "Excess Item Fee",
  amount: 155,
  balance: 155,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 43,
    rawRowText: "155.00; 14.06",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "excess item fee",
    clarificationStatus: "clarified",
    amountZar: 155,
    bankChargeZar: null,
    balanceZar: 155
},
  notes: "Likely excess item fee."
});
LET $tx_stmt_2026_02_18_row_43 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-43",
  sourceRow: $row_row_43,
  postedAt: "2026-02-05T00:00:00Z",
  description: "155.00",
  normalizedDescription: "Excess Item Fee",
  amount: 155,
  balance: 155,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_excess_item_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Likely excess item fee."
});
fn::updateStatementRow($row_row_43.id, { transaction: $tx_stmt_2026_02_18_row_43.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_43.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_43.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_43.id, "TransactionCategory", $cat_fees_excess_item_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 44
LET $row_row_44 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 44,
  postedAt: "2026-02-05T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 130,
  balance: 144.06,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 44,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 02 Feb; 130.00; 144.06; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 130,
    bankChargeZar: 3.68,
    balanceZar: 144.06
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_44 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-44",
  sourceRow: $row_row_44,
  postedAt: "2026-02-05T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 130,
  balance: 144.06,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_44.id, { transaction: $tx_stmt_2026_02_18_row_44.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_44.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_44.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_44.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 45
LET $row_row_45 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 45,
  postedAt: "2026-02-06T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 6,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 45,
    rawRowText: "6.00; 150.06",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 6
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_45 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-45",
  sourceRow: $row_row_45,
  postedAt: "2026-02-06T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Service Fee",
  amount: 6,
  balance: 6,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_45.id, { transaction: $tx_stmt_2026_02_18_row_45.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_45.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_45.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_45.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 46
LET $row_row_46 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 46,
  postedAt: "2026-02-07T00:00:00Z",
  description: "Magtape Credit B Peters",
  normalizedDescription: "B Peters",
  amount: 20000,
  balance: 19849.94,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 46,
    rawRowText: "Magtape Credit B Peters; 20,000.00 Cr; 19,849.94 Cr",
    transactionType: "income",
    normalizedMerchant: "B Peters",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 20000,
    bankChargeZar: null,
    balanceZar: 19849.94
},
  notes: "Confirmed business income."
});
LET $tx_stmt_2026_02_18_row_46 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-46",
  sourceRow: $row_row_46,
  postedAt: "2026-02-07T00:00:00Z",
  description: "Magtape Credit B Peters",
  normalizedDescription: "B Peters",
  amount: 20000,
  balance: 19849.94,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "B Peters",
  merchant: $merchant_b_peters,
  category: $cat_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Confirmed business income."
});
fn::updateStatementRow($row_row_46.id, { transaction: $tx_stmt_2026_02_18_row_46.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_46.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_46.id, "TransactionMerchant", $merchant_b_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_46.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 47
LET $row_row_47 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 47,
  postedAt: "2026-02-10T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet",
  normalizedDescription: "Mpire Digital Market",
  amount: 12500,
  balance: 7349.94,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 47,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet; Mpire Digital Market; 12,500.00; 7,349.94 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 12500,
    bankChargeZar: 15,
    balanceZar: 7349.94
},
  notes: "Likely internal transfer to owner/personal account."
});
LET $tx_stmt_2026_02_18_row_47 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-47",
  sourceRow: $row_row_47,
  postedAt: "2026-02-10T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet",
  normalizedDescription: "Mpire Digital Market",
  amount: 12500,
  balance: 7349.94,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Mpire Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Likely internal transfer to owner/personal account."
});
fn::updateStatementRow($row_row_47.id, { transaction: $tx_stmt_2026_02_18_row_47.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_47.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_47.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_47.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 48
LET $row_row_48 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 48,
  postedAt: "2026-02-11T00:00:00Z",
  description: "POS Purchase Diamatrix",
  normalizedDescription: "Diamatrix",
  amount: 109,
  balance: 7240.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 48,
    rawRowText: "POS Purchase Diamatrix; 485442*7050 09 Feb; 109.00; 7,240.94 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Diamatrix",
    category: "Software / hosting",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 109,
    bankChargeZar: 3.68,
    balanceZar: 7240.94
},
  notes: "Hosting / software expense."
});
LET $tx_stmt_2026_02_18_row_48 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-48",
  sourceRow: $row_row_48,
  postedAt: "2026-02-11T00:00:00Z",
  description: "POS Purchase Diamatrix",
  normalizedDescription: "Diamatrix",
  amount: 109,
  balance: 7240.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Diamatrix",
  merchant: $merchant_diamatrix,
  category: $cat_software_hosting,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting / software expense."
});
fn::updateStatementRow($row_row_48.id, { transaction: $tx_stmt_2026_02_18_row_48.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_48.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_48.id, "TransactionMerchant", $merchant_diamatrix.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_48.id, "TransactionCategory", $cat_software_hosting.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 49
LET $row_row_49 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 49,
  postedAt: "2026-02-11T00:00:00Z",
  description: "POS Purchase 111.32 Paypal *Elit",
  normalizedDescription: "PayPal / Elite",
  amount: 111.32,
  balance: 7129.62,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 49,
    rawRowText: "POS Purchase 111.32 Paypal *Elit; 485442*7050 09 Feb; 111.32; 7,129.62 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal / Elite",
    category: "Online services",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 111.32,
    bankChargeZar: 3.68,
    balanceZar: 7129.62
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2026_02_18_row_49 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-49",
  sourceRow: $row_row_49,
  postedAt: "2026-02-11T00:00:00Z",
  description: "POS Purchase 111.32 Paypal *Elit",
  normalizedDescription: "PayPal / Elite",
  amount: 111.32,
  balance: 7129.62,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal / Elite",
  merchant: $merchant_paypal_elite,
  category: $cat_online_services,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs confirmation."
});
fn::updateStatementRow($row_row_49.id, { transaction: $tx_stmt_2026_02_18_row_49.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_49.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_49.id, "TransactionMerchant", $merchant_paypal_elite.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_49.id, "TransactionCategory", $cat_online_services.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_02_18_row_49 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-02-18-row-49",
  transaction: $tx_stmt_2026_02_18_row_49,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal / Elite charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal_elite,
  suggestedCategory: $cat_online_services,
  confidence: 0.25,
  notes: "Imported from 2026-02-18.import.md"
});
fn::createEdge($tx_stmt_2026_02_18_row_49.id, "TransactionClarificationTasks", $task_stmt_2026_02_18_row_49.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 50
LET $row_row_50 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 50,
  postedAt: "2026-02-11T00:00:00Z",
  description: "POS Purchase 292.07 Paypal *Ivec",
  normalizedDescription: "PayPal / Ivec",
  amount: 292.07,
  balance: 6837.55,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 50,
    rawRowText: "POS Purchase 292.07 Paypal *Ivec; 485442*7050 09 Feb; 292.07; 6,837.55 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal / Ivec",
    category: "Online services",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 292.07,
    bankChargeZar: 3.68,
    balanceZar: 6837.55
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2026_02_18_row_50 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-50",
  sourceRow: $row_row_50,
  postedAt: "2026-02-11T00:00:00Z",
  description: "POS Purchase 292.07 Paypal *Ivec",
  normalizedDescription: "PayPal / Ivec",
  amount: 292.07,
  balance: 6837.55,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal / Ivec",
  merchant: $merchant_paypal_ivec,
  category: $cat_online_services,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs confirmation."
});
fn::updateStatementRow($row_row_50.id, { transaction: $tx_stmt_2026_02_18_row_50.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_50.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_50.id, "TransactionMerchant", $merchant_paypal_ivec.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_50.id, "TransactionCategory", $cat_online_services.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_02_18_row_50 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-02-18-row-50",
  transaction: $tx_stmt_2026_02_18_row_50,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal / Ivec charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal_ivec,
  suggestedCategory: $cat_online_services,
  confidence: 0.25,
  notes: "Imported from 2026-02-18.import.md"
});
fn::createEdge($tx_stmt_2026_02_18_row_50.id, "TransactionClarificationTasks", $task_stmt_2026_02_18_row_50.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 51
LET $row_row_51 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 51,
  postedAt: "2026-02-11T00:00:00Z",
  description: "POS Purchase 424.25 Paypal *Elit",
  normalizedDescription: "PayPal / Elite",
  amount: 424.25,
  balance: 6413.3,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 51,
    rawRowText: "POS Purchase 424.25 Paypal *Elit; 485442*7050 09 Feb; 424.25; 6,413.30 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal / Elite",
    category: "Online services",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 424.25,
    bankChargeZar: 3.68,
    balanceZar: 6413.3
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2026_02_18_row_51 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-51",
  sourceRow: $row_row_51,
  postedAt: "2026-02-11T00:00:00Z",
  description: "POS Purchase 424.25 Paypal *Elit",
  normalizedDescription: "PayPal / Elite",
  amount: 424.25,
  balance: 6413.3,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal / Elite",
  merchant: $merchant_paypal_elite,
  category: $cat_online_services,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs confirmation."
});
fn::updateStatementRow($row_row_51.id, { transaction: $tx_stmt_2026_02_18_row_51.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_51.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_51.id, "TransactionMerchant", $merchant_paypal_elite.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_51.id, "TransactionCategory", $cat_online_services.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_02_18_row_51 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-02-18-row-51",
  transaction: $tx_stmt_2026_02_18_row_51,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal / Elite charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal_elite,
  suggestedCategory: $cat_online_services,
  confidence: 0.25,
  notes: "Imported from 2026-02-18.import.md"
});
fn::createEdge($tx_stmt_2026_02_18_row_51.id, "TransactionClarificationTasks", $task_stmt_2026_02_18_row_51.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 52
LET $row_row_52 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 52,
  postedAt: "2026-02-11T00:00:00Z",
  description: "POS Purchase 38.93 Wise",
  normalizedDescription: "Wise",
  amount: 885.94,
  balance: 5527.36,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 52,
    rawRowText: "POS Purchase 38.93 Wise; 485442*7050 09 Feb; 885.94; 5,527.36 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Wise",
    category: "Transfer services",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 885.94,
    bankChargeZar: 3.68,
    balanceZar: 5527.36
},
  notes: "Wise spend / transfer rail; confirm purpose later."
});
LET $tx_stmt_2026_02_18_row_52 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-52",
  sourceRow: $row_row_52,
  postedAt: "2026-02-11T00:00:00Z",
  description: "POS Purchase 38.93 Wise",
  normalizedDescription: "Wise",
  amount: 885.94,
  balance: 5527.36,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Wise",
  merchant: $merchant_wise,
  category: $cat_transfer_services,
  isTransfer: false,
  manualOverride: false,
  notes: "Wise spend / transfer rail; confirm purpose later."
});
fn::updateStatementRow($row_row_52.id, { transaction: $tx_stmt_2026_02_18_row_52.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_52.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_52.id, "TransactionMerchant", $merchant_wise.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_52.id, "TransactionCategory", $cat_transfer_services.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_02_18_row_52 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-02-18-row-52",
  transaction: $tx_stmt_2026_02_18_row_52,
  status: "open",
  question: "What was the purpose of this Wise spend or transfer?",
  reason: "Wise spend or transfer rail needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_wise,
  suggestedCategory: $cat_transfer_services,
  confidence: 0.25,
  notes: "Imported from 2026-02-18.import.md"
});
fn::createEdge($tx_stmt_2026_02_18_row_52.id, "TransactionClarificationTasks", $task_stmt_2026_02_18_row_52.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 53
LET $row_row_53 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 53,
  postedAt: "2026-02-12T00:00:00Z",
  description: "POS Purchase Afrihost.Com",
  normalizedDescription: "Afrihost",
  amount: 1,
  balance: 5526.36,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 53,
    rawRowText: "POS Purchase Afrihost.Com; 485442*7050 09 Feb; 1.00; 5,526.36 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Afrihost",
    category: "Software / hosting",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1,
    bankChargeZar: 3.68,
    balanceZar: 5526.36
},
  notes: "Hosting expense."
});
LET $tx_stmt_2026_02_18_row_53 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-53",
  sourceRow: $row_row_53,
  postedAt: "2026-02-12T00:00:00Z",
  description: "POS Purchase Afrihost.Com",
  normalizedDescription: "Afrihost",
  amount: 1,
  balance: 5526.36,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Afrihost",
  merchant: $merchant_afrihost,
  category: $cat_software_hosting,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting expense."
});
fn::updateStatementRow($row_row_53.id, { transaction: $tx_stmt_2026_02_18_row_53.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_53.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_53.id, "TransactionMerchant", $merchant_afrihost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_53.id, "TransactionCategory", $cat_software_hosting.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 54
LET $row_row_54 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 54,
  postedAt: "2026-02-12T00:00:00Z",
  description: "POS Purchase 20.99 Atlassian",
  normalizedDescription: "Atlassian",
  amount: 343.89,
  balance: 5182.47,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 54,
    rawRowText: "POS Purchase 20.99 Atlassian; 485442*7050 11 Feb; 343.89; 5,182.47 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Atlassian",
    category: "Software / hosting",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 343.89,
    bankChargeZar: 3.68,
    balanceZar: 5182.47
},
  notes: "Software / collaboration expense."
});
LET $tx_stmt_2026_02_18_row_54 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-54",
  sourceRow: $row_row_54,
  postedAt: "2026-02-12T00:00:00Z",
  description: "POS Purchase 20.99 Atlassian",
  normalizedDescription: "Atlassian",
  amount: 343.89,
  balance: 5182.47,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Atlassian",
  merchant: $merchant_atlassian,
  category: $cat_software_hosting,
  isTransfer: false,
  manualOverride: false,
  notes: "Software / collaboration expense."
});
fn::updateStatementRow($row_row_54.id, { transaction: $tx_stmt_2026_02_18_row_54.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_54.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_54.id, "TransactionMerchant", $merchant_atlassian.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_54.id, "TransactionCategory", $cat_software_hosting.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 55
LET $row_row_55 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 55,
  postedAt: "2026-02-13T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 3182.47,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 55,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 10 Feb; 2,000.00; 3,182.47 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: 3.68,
    balanceZar: 3182.47
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_55 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-55",
  sourceRow: $row_row_55,
  postedAt: "2026-02-13T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 3182.47,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_55.id, { transaction: $tx_stmt_2026_02_18_row_55.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_55.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_55.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_55.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 56
LET $row_row_56 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 56,
  postedAt: "2026-02-13T00:00:00Z",
  description: "POS Purchase 270.89 Paypal *Ivec",
  normalizedDescription: "PayPal / Ivec",
  amount: 270.89,
  balance: 2911.58,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 56,
    rawRowText: "POS Purchase 270.89 Paypal *Ivec; 485442*7050 11 Feb; 270.89; 2,911.58 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal / Ivec",
    category: "Online services",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 270.89,
    bankChargeZar: 3.68,
    balanceZar: 2911.58
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2026_02_18_row_56 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-56",
  sourceRow: $row_row_56,
  postedAt: "2026-02-13T00:00:00Z",
  description: "POS Purchase 270.89 Paypal *Ivec",
  normalizedDescription: "PayPal / Ivec",
  amount: 270.89,
  balance: 2911.58,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal / Ivec",
  merchant: $merchant_paypal_ivec,
  category: $cat_online_services,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs confirmation."
});
fn::updateStatementRow($row_row_56.id, { transaction: $tx_stmt_2026_02_18_row_56.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_56.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_56.id, "TransactionMerchant", $merchant_paypal_ivec.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_56.id, "TransactionCategory", $cat_online_services.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_02_18_row_56 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-02-18-row-56",
  transaction: $tx_stmt_2026_02_18_row_56,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal / Ivec charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal_ivec,
  suggestedCategory: $cat_online_services,
  confidence: 0.25,
  notes: "Imported from 2026-02-18.import.md"
});
fn::createEdge($tx_stmt_2026_02_18_row_56.id, "TransactionClarificationTasks", $task_stmt_2026_02_18_row_56.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 57
LET $row_row_57 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 57,
  postedAt: "2026-02-16T00:00:00Z",
  description: "FNB OB Pmt Country Meat Lonehil",
  normalizedDescription: "Country Meat Lonehil",
  amount: 8000,
  balance: 10911.58,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 57,
    rawRowText: "FNB OB Pmt Country Meat Lonehil; 8,000.00 Cr; 10,911.58 Cr",
    transactionType: "income",
    normalizedMerchant: "Country Meat Lonehil",
    category: "Income",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 8000,
    bankChargeZar: null,
    balanceZar: 10911.58
},
  notes: "Incoming customer payment; source to confirm later."
});
LET $tx_stmt_2026_02_18_row_57 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-57",
  sourceRow: $row_row_57,
  postedAt: "2026-02-16T00:00:00Z",
  description: "FNB OB Pmt Country Meat Lonehil",
  normalizedDescription: "Country Meat Lonehil",
  amount: 8000,
  balance: 10911.58,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Country Meat Lonehil",
  merchant: $merchant_country_meat_lonehil,
  category: $cat_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Incoming customer payment; source to confirm later."
});
fn::updateStatementRow($row_row_57.id, { transaction: $tx_stmt_2026_02_18_row_57.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_57.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_57.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_57.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_57.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_57.id, "TransactionMerchant", $merchant_country_meat_lonehil.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_57.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_02_18_row_57 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-02-18-row-57",
  transaction: $tx_stmt_2026_02_18_row_57,
  status: "open",
  question: "What is the exact purpose of this Country Meat Lonehil transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_country_meat_lonehil,
  suggestedCategory: $cat_income,
  confidence: 0.25,
  notes: "Imported from 2026-02-18.import.md"
});
fn::createEdge($tx_stmt_2026_02_18_row_57.id, "TransactionClarificationTasks", $task_stmt_2026_02_18_row_57.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 58
LET $row_row_58 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 58,
  postedAt: "2026-02-16T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet",
  normalizedDescription: "Mpire Digital Market",
  amount: 8000,
  balance: 2911.58,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 58,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet; Mpire Digital Market; 8,000.00; 2,911.58 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 8000,
    bankChargeZar: 15,
    balanceZar: 2911.58
},
  notes: "Likely internal transfer to owner/personal account."
});
LET $tx_stmt_2026_02_18_row_58 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-58",
  sourceRow: $row_row_58,
  postedAt: "2026-02-16T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet",
  normalizedDescription: "Mpire Digital Market",
  amount: 8000,
  balance: 2911.58,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Mpire Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Likely internal transfer to owner/personal account."
});
fn::updateStatementRow($row_row_58.id, { transaction: $tx_stmt_2026_02_18_row_58.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_58.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_58.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_58.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_58.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_58.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_58.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 59
LET $row_row_59 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 59,
  postedAt: "2026-02-16T00:00:00Z",
  description: "POS Purchase 13.80 Notion Labs,",
  normalizedDescription: "Notion Labs",
  amount: 227.51,
  balance: 2684.07,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 59,
    rawRowText: "POS Purchase 13.80 Notion Labs,; 485442*7050 14 Feb; 227.51; 2,684.07 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Notion Labs",
    category: "Software / productivity",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 227.51,
    bankChargeZar: 3.68,
    balanceZar: 2684.07
},
  notes: "Productivity software expense."
});
LET $tx_stmt_2026_02_18_row_59 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-59",
  sourceRow: $row_row_59,
  postedAt: "2026-02-16T00:00:00Z",
  description: "POS Purchase 13.80 Notion Labs,",
  normalizedDescription: "Notion Labs",
  amount: 227.51,
  balance: 2684.07,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Notion Labs",
  merchant: $merchant_notion_labs,
  category: $cat_software_productivity,
  isTransfer: false,
  manualOverride: false,
  notes: "Productivity software expense."
});
fn::updateStatementRow($row_row_59.id, { transaction: $tx_stmt_2026_02_18_row_59.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_59.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_59.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_59.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_59.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_59.id, "TransactionMerchant", $merchant_notion_labs.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_59.id, "TransactionCategory", $cat_software_productivity.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 60
LET $row_row_60 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 60,
  postedAt: "2026-02-17T00:00:00Z",
  description: "Magtape Credit Aam",
  normalizedDescription: "Aam",
  amount: 500,
  balance: 3184.07,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 60,
    rawRowText: "Magtape Credit Aam; 500.00 Cr; 3,184.07 Cr",
    transactionType: "income",
    normalizedMerchant: "Aam",
    category: "Income",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 500,
    bankChargeZar: null,
    balanceZar: 3184.07
},
  notes: "Incoming credit; source to confirm later."
});
LET $tx_stmt_2026_02_18_row_60 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-60",
  sourceRow: $row_row_60,
  postedAt: "2026-02-17T00:00:00Z",
  description: "Magtape Credit Aam",
  normalizedDescription: "Aam",
  amount: 500,
  balance: 3184.07,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Aam",
  merchant: $merchant_aam,
  category: $cat_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Incoming credit; source to confirm later."
});
fn::updateStatementRow($row_row_60.id, { transaction: $tx_stmt_2026_02_18_row_60.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_60.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_60.id, "TransactionMerchant", $merchant_aam.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_60.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_02_18_row_60 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-02-18-row-60",
  transaction: $tx_stmt_2026_02_18_row_60,
  status: "open",
  question: "What is the exact purpose of this Aam transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_aam,
  suggestedCategory: $cat_income,
  confidence: 0.25,
  notes: "Imported from 2026-02-18.import.md"
});
fn::createEdge($tx_stmt_2026_02_18_row_60.id, "TransactionClarificationTasks", $task_stmt_2026_02_18_row_60.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 61
LET $row_row_61 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 61,
  postedAt: "2026-02-17T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 2184.07,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 61,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 13 Feb; 1,000.00; 2,184.07 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: 3.68,
    balanceZar: 2184.07
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_61 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-61",
  sourceRow: $row_row_61,
  postedAt: "2026-02-17T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 2184.07,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_61.id, { transaction: $tx_stmt_2026_02_18_row_61.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_61.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_61.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_61.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_61.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_61.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_61.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 62
LET $row_row_62 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 62,
  postedAt: "2026-02-17T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 1184.07,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 62,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 13 Feb; 1,000.00; 1,184.07 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: 3.68,
    balanceZar: 1184.07
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_62 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-62",
  sourceRow: $row_row_62,
  postedAt: "2026-02-17T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 1184.07,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_62.id, { transaction: $tx_stmt_2026_02_18_row_62.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_62.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_62.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_62.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_62.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_62.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_62.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 63
LET $row_row_63 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 63,
  postedAt: "2026-02-18T00:00:00Z",
  description: "2.50",
  normalizedDescription: "Service Fee",
  amount: 2.5,
  balance: 1181.57,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 63,
    rawRowText: "2.50; 1,181.57 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 2.5,
    bankChargeZar: null,
    balanceZar: 1181.57
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_63 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-63",
  sourceRow: $row_row_63,
  postedAt: "2026-02-18T00:00:00Z",
  description: "2.50",
  normalizedDescription: "Service Fee",
  amount: 2.5,
  balance: 1181.57,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_63.id, { transaction: $tx_stmt_2026_02_18_row_63.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_63.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_63.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_63.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_63.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_63.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_63.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 64
LET $row_row_64 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 64,
  postedAt: "2026-02-18T00:00:00Z",
  description: "6.10",
  normalizedDescription: "Service Fee",
  amount: 6.1,
  balance: 1175.47,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 64,
    rawRowText: "6.10; 1,175.47 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6.1,
    bankChargeZar: null,
    balanceZar: 1175.47
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_64 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-64",
  sourceRow: $row_row_64,
  postedAt: "2026-02-18T00:00:00Z",
  description: "6.10",
  normalizedDescription: "Service Fee",
  amount: 6.1,
  balance: 1175.47,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_64.id, { transaction: $tx_stmt_2026_02_18_row_64.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_64.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_64.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_64.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_64.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_64.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_64.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 65
LET $row_row_65 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 65,
  postedAt: "2026-02-18T00:00:00Z",
  description: "6.57",
  normalizedDescription: "Service Fee",
  amount: 6.57,
  balance: 1168.9,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 65,
    rawRowText: "6.57; 1,168.90 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 6.57,
    bankChargeZar: null,
    balanceZar: 1168.9
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_65 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-65",
  sourceRow: $row_row_65,
  postedAt: "2026-02-18T00:00:00Z",
  description: "6.57",
  normalizedDescription: "Service Fee",
  amount: 6.57,
  balance: 1168.9,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_65.id, { transaction: $tx_stmt_2026_02_18_row_65.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_65.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_65.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_65.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_65.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_65.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_65.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 66
LET $row_row_66 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 66,
  postedAt: "2026-02-18T00:00:00Z",
  description: "9.55",
  normalizedDescription: "Service Fee",
  amount: 9.55,
  balance: 1159.35,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 66,
    rawRowText: "9.55; 1,159.35 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 9.55,
    bankChargeZar: null,
    balanceZar: 1159.35
},
  notes: ""
});
LET $tx_stmt_2026_02_18_row_66 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-66",
  sourceRow: $row_row_66,
  postedAt: "2026-02-18T00:00:00Z",
  description: "9.55",
  normalizedDescription: "Service Fee",
  amount: 9.55,
  balance: 1159.35,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: ""
});
fn::updateStatementRow($row_row_66.id, { transaction: $tx_stmt_2026_02_18_row_66.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_66.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_66.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_66.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_66.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_66.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_66.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 67
LET $row_row_67 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 67,
  postedAt: "2026-02-18T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Pd9376",
  normalizedDescription: "Outsurance",
  amount: 774.86,
  balance: 384.49,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 67,
    rawRowText: "Magtape Debit Outsurance Ot87677302 Pd9376; 774.86; 384.49 Cr; 12.00",
    transactionType: "expense",
    normalizedMerchant: "Outsurance",
    category: "Insurance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 774.86,
    bankChargeZar: 12,
    balanceZar: 384.49
},
  notes: "Insurance expense."
});
LET $tx_stmt_2026_02_18_row_67 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-67",
  sourceRow: $row_row_67,
  postedAt: "2026-02-18T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Pd9376",
  normalizedDescription: "Outsurance",
  amount: 774.86,
  balance: 384.49,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Outsurance",
  merchant: $merchant_outsurance,
  category: $cat_insurance,
  isTransfer: false,
  manualOverride: false,
  notes: "Insurance expense."
});
fn::updateStatementRow($row_row_67.id, { transaction: $tx_stmt_2026_02_18_row_67.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_67.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_67.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_67.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_67.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_67.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_67.id, "TransactionCategory", $cat_insurance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 68
LET $row_row_68 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 68,
  postedAt: "2026-02-18T00:00:00Z",
  description: "Int On Debit Balance",
  normalizedDescription: "Debit Interest",
  amount: 0.19,
  balance: 384.3,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 68,
    rawRowText: "Int On Debit Balance; 0.19; 384.30 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "debit interest",
    clarificationStatus: "clarified",
    amountZar: 0.19,
    bankChargeZar: null,
    balanceZar: 384.3
},
  notes: "Interest on debit balance."
});
LET $tx_stmt_2026_02_18_row_68 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-68",
  sourceRow: $row_row_68,
  postedAt: "2026-02-18T00:00:00Z",
  description: "Int On Debit Balance",
  normalizedDescription: "Debit Interest",
  amount: 0.19,
  balance: 384.3,
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
fn::updateStatementRow($row_row_68.id, { transaction: $tx_stmt_2026_02_18_row_68.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_68.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_68.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_68.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_68.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_68.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_68.id, "TransactionCategory", $cat_fees_debit_interest.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 69
LET $row_row_69 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 69,
  postedAt: "2026-02-18T00:00:00Z",
  description: "93.00",
  normalizedDescription: "Monthly Account Fee",
  amount: 93,
  balance: 291.3,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 69,
    rawRowText: "93.00; 291.30 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "monthly account fee",
    clarificationStatus: "clarified",
    amountZar: 93,
    bankChargeZar: null,
    balanceZar: 291.3
},
  notes: "Monthly account fee."
});
LET $tx_stmt_2026_02_18_row_69 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-69",
  sourceRow: $row_row_69,
  postedAt: "2026-02-18T00:00:00Z",
  description: "93.00",
  normalizedDescription: "Monthly Account Fee",
  amount: 93,
  balance: 291.3,
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
fn::updateStatementRow($row_row_69.id, { transaction: $tx_stmt_2026_02_18_row_69.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_69.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_69.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_69.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_69.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_69.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_69.id, "TransactionCategory", $cat_fees_monthly_account_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 70
LET $row_row_70 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 70,
  postedAt: "2026-02-18T00:00:00Z",
  description: "153.36",
  normalizedDescription: "Service Fee",
  amount: 153.36,
  balance: 137.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 February 2026.pdf",
    statementPeriodStart: "2026-01-17",
    statementPeriodEnd: "2026-02-18",
    rowNo: 70,
    rawRowText: "153.36; 137.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 153.36,
    bankChargeZar: null,
    balanceZar: 137.94
},
  notes: "Statement service fee total."
});
LET $tx_stmt_2026_02_18_row_70 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-18-row-70",
  sourceRow: $row_row_70,
  postedAt: "2026-02-18T00:00:00Z",
  description: "153.36",
  normalizedDescription: "Service Fee",
  amount: 153.36,
  balance: 137.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Statement service fee total."
});
fn::updateStatementRow($row_row_70.id, { transaction: $tx_stmt_2026_02_18_row_70.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_70.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_70.id, "StatementRowTransactions", $tx_stmt_2026_02_18_row_70.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_18_row_70.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_70.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_18_row_70.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 70,
  normalizedCount: 70,
  clarificationCount: 11,
  status: "matched",
  statementDate: "2026-02-18T00:00:00Z",
  notes: "Imported from 2026-02-18.import.md"
});

-- End of generated import
