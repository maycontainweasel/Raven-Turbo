-- Generated from docs/statements/business/2025-06-18.import.md
-- Source: docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf

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
  openingBalance: 839.94,
  active: true,
  notes: "Imported from GOLD_BUSINESS_ACCOUNT_80.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-06-18-fnb-gold-business-27821",
  sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-06-18T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_business_to_personal_transfer = fn::createCategory({
  space: $space,
  key: "business-to-personal-transfer",
  name: "Business to personal transfer",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_client_income = fn::createCategory({
  space: $space,
  key: "client-income",
  name: "Client income",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_hosting_internet = fn::createCategory({
  space: $space,
  key: "hosting-internet",
  name: "Hosting / internet",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_design_contractor_expense = fn::createCategory({
  space: $space,
  key: "design-contractor-expense",
  name: "Design / contractor expense",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_software_saas = fn::createCategory({
  space: $space,
  key: "software-saas",
  name: "Software / SaaS",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_ai_tools = fn::createCategory({
  space: $space,
  key: "ai-tools",
  name: "AI tools",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_insurance = fn::createCategory({
  space: $space,
  key: "insurance",
  name: "Insurance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_internet_connectivity = fn::createCategory({
  space: $space,
  key: "internet-connectivity",
  name: "Internet / connectivity",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_hosting_income = fn::createCategory({
  space: $space,
  key: "hosting-income",
  name: "Hosting income",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_fees_bank_fee = fn::createCategory({
  space: $space,
  key: "fees-bank-fee",
  name: "Bank Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_fees_card_charge = fn::createCategory({
  space: $space,
  key: "fees-card-charge",
  name: "Card Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});

-- Merchant records
LET $merchant_michael_peters = fn::createMerchant({
  space: $space,
  key: "michael-peters",
  name: "Michael Peters",
  normalizedName: "Michael Peters",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_esta_van_coppenhagen = fn::createMerchant({
  space: $space,
  key: "esta-van-coppenhagen",
  name: "Esta van Coppenhagen",
  normalizedName: "Esta van Coppenhagen",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_fnb = fn::createMerchant({
  space: $space,
  key: "fnb",
  name: "FNB",
  normalizedName: "FNB",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_elitehost = fn::createMerchant({
  space: $space,
  key: "elitehost",
  name: "Elitehost",
  normalizedName: "Elitehost",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_lucky_isibaya = fn::createMerchant({
  space: $space,
  key: "lucky-isibaya",
  name: "Lucky Isibaya",
  normalizedName: "Lucky Isibaya",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_nectar_studio = fn::createMerchant({
  space: $space,
  key: "nectar-studio",
  name: "Nectar Studio",
  normalizedName: "Nectar Studio",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_cursor = fn::createMerchant({
  space: $space,
  key: "cursor",
  name: "Cursor",
  normalizedName: "Cursor",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_sansor = fn::createMerchant({
  space: $space,
  key: "sansor",
  name: "Sansor",
  normalizedName: "Sansor",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_openai = fn::createMerchant({
  space: $space,
  key: "openai",
  name: "OpenAI",
  normalizedName: "OpenAI",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_inv_127566 = fn::createMerchant({
  space: $space,
  key: "inv-127566",
  name: "Inv-127566",
  normalizedName: "Inv-127566",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_true_fit = fn::createMerchant({
  space: $space,
  key: "true-fit",
  name: "True Fit",
  normalizedName: "True Fit",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_outsurance = fn::createMerchant({
  space: $space,
  key: "outsurance",
  name: "Outsurance",
  normalizedName: "Outsurance",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_google_workspace = fn::createMerchant({
  space: $space,
  key: "google-workspace",
  name: "Google Workspace",
  normalizedName: "Google Workspace",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_notion = fn::createMerchant({
  space: $space,
  key: "notion",
  name: "Notion",
  normalizedName: "Notion",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_diamatrix = fn::createMerchant({
  space: $space,
  key: "diamatrix",
  name: "Diamatrix",
  normalizedName: "Diamatrix",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_vecteezy = fn::createMerchant({
  space: $space,
  key: "vecteezy",
  name: "Vecteezy",
  normalizedName: "Vecteezy",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_vdv_internet = fn::createMerchant({
  space: $space,
  key: "vdv-internet",
  name: "VDV Internet",
  normalizedName: "VDV Internet",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_wazo_host = fn::createMerchant({
  space: $space,
  key: "wazo-host",
  name: "Wazo Host",
  normalizedName: "Wazo Host",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_magic_pattern = fn::createMerchant({
  space: $space,
  key: "magic-pattern",
  name: "Magic Pattern",
  normalizedName: "Magic Pattern",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_liquor_express = fn::createMerchant({
  space: $space,
  key: "liquor-express",
  name: "Liquor Express",
  normalizedName: "Liquor Express",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 200,
  balance: 639.94,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 1,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 200.00; 639.94 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 200,
    bankChargeZar: 8,
    balanceZar: 639.94
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_06_18_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 200,
  balance: 639.94,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Business-to-personal transfer to the personal current account."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_06_18_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_01.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_01.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Magtape Credit Estavcoppenhagen",
  normalizedDescription: "Esta van Coppenhagen",
  amount: 2430,
  balance: 3069.94,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 2,
    rawRowText: "Magtape Credit Estavcoppenhagen; 2,430.00 Cr; 3,069.94 Cr",
    transactionType: "income",
    normalizedMerchant: "Esta van Coppenhagen",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2430,
    bankChargeZar: null,
    balanceZar: 3069.94
},
  notes: "Income related to the Esta van Coppenhagen project."
});
LET $tx_stmt_2025_06_18_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Magtape Credit Estavcoppenhagen",
  normalizedDescription: "Esta van Coppenhagen",
  amount: 2430,
  balance: 3069.94,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Esta van Coppenhagen",
  merchant: $merchant_esta_van_coppenhagen,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Income related to the Esta van Coppenhagen project."
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_06_18_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_02.id, "TransactionMerchant", $merchant_esta_van_coppenhagen.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_02.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-05-19T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 3063.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 3,
    rawRowText: "6.00; 3,063.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 3063.94
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_06_18_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-05-19T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 3063.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line; exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_06_18_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_03.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_03.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-05-19T00:00:00Z",
  description: "POS Purchase 633.03 Paypal *Elit                                                    485442*7050 16 May",
  normalizedDescription: "Elitehost",
  amount: 633.03,
  balance: 2430.91,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 4,
    rawRowText: "POS Purchase 633.03 Paypal *Elit                                                    485442*7050 16 May; 633.03; 2,430.91 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 633.03,
    bankChargeZar: 3.68,
    balanceZar: 2430.91
},
  notes: "Elitehost hosting payment bundle."
});
LET $tx_stmt_2025_06_18_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-05-19T00:00:00Z",
  description: "POS Purchase 633.03 Paypal *Elit                                                    485442*7050 16 May",
  normalizedDescription: "Elitehost",
  amount: 633.03,
  balance: 2430.91,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Elitehost",
  merchant: $merchant_elitehost,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Elitehost hosting payment bundle."
});
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_06_18_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_04.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_04.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-05-20T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1000,
  balance: 1430.91,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 5,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 1,000.00; 1,430.91 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: 8,
    balanceZar: 1430.91
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_06_18_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-05-20T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1000,
  balance: 1430.91,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Business-to-personal transfer to the personal current account."
});
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_06_18_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_05.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_05.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-05-20T00:00:00Z",
  description: "1.15",
  normalizedDescription: "Bank Fee",
  amount: 1.15,
  balance: 1429.76,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 6,
    rawRowText: "1.15; 1,429.76 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 1.15,
    bankChargeZar: null,
    balanceZar: 1429.76
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_06_18_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-05-20T00:00:00Z",
  description: "1.15",
  normalizedDescription: "Bank Fee",
  amount: 1.15,
  balance: 1429.76,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line; exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_06_18_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_06.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_06.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-05-20T00:00:00Z",
  description: "2.07",
  normalizedDescription: "Bank Fee",
  amount: 2.07,
  balance: 1427.69,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 7,
    rawRowText: "2.07; 1,427.69 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 2.07,
    bankChargeZar: null,
    balanceZar: 1427.69
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_06_18_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-05-20T00:00:00Z",
  description: "2.07",
  normalizedDescription: "Bank Fee",
  amount: 2.07,
  balance: 1427.69,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line; exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_06_18_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_07.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_07.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-05-20T00:00:00Z",
  description: "24.52",
  normalizedDescription: "Bank Fee",
  amount: 24.52,
  balance: 1403.17,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 8,
    rawRowText: "24.52; 1,403.17 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 24.52,
    bankChargeZar: null,
    balanceZar: 1403.17
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_06_18_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-05-20T00:00:00Z",
  description: "24.52",
  normalizedDescription: "Bank Fee",
  amount: 24.52,
  balance: 1403.17,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line; exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_06_18_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_08.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_08.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-05-21T00:00:00Z",
  description: "Magtape Credit Phil Melouney",
  normalizedDescription: "Lucky Isibaya",
  amount: 10000,
  balance: 11403.17,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 9,
    rawRowText: "Magtape Credit Phil Melouney; 10,000.00 Cr; 11,403.17 Cr",
    transactionType: "income",
    normalizedMerchant: "Lucky Isibaya",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 10000,
    bankChargeZar: null,
    balanceZar: 11403.17
},
  notes: "Income for an aspect of the Lucky Isibaya project."
});
LET $tx_stmt_2025_06_18_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-05-21T00:00:00Z",
  description: "Magtape Credit Phil Melouney",
  normalizedDescription: "Lucky Isibaya",
  amount: 10000,
  balance: 11403.17,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Lucky Isibaya",
  merchant: $merchant_lucky_isibaya,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Income for an aspect of the Lucky Isibaya project."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_06_18_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_09.id, "TransactionMerchant", $merchant_lucky_isibaya.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_09.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-05-22T00:00:00Z",
  description: "Internet Pmt To Nectar Design Stage                                                 Phil Ux Stage 1",
  normalizedDescription: "Nectar Studio",
  amount: 5000,
  balance: 6403.17,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 10,
    rawRowText: "Internet Pmt To Nectar Design Stage                                                 Phil Ux Stage 1; 5,000.00; 6,403.17 Cr",
    transactionType: "expense",
    normalizedMerchant: "Nectar Studio",
    category: "Design / contractor expense",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 5000,
    bankChargeZar: null,
    balanceZar: 6403.17
},
  notes: "Design payment to Nectar Studio for Phil UX stage 1."
});
LET $tx_stmt_2025_06_18_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-05-22T00:00:00Z",
  description: "Internet Pmt To Nectar Design Stage                                                 Phil Ux Stage 1",
  normalizedDescription: "Nectar Studio",
  amount: 5000,
  balance: 6403.17,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nectar Studio",
  merchant: $merchant_nectar_studio,
  category: $cat_design_contractor_expense,
  isTransfer: false,
  manualOverride: false,
  notes: "Design payment to Nectar Studio for Phil UX stage 1."
});
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_06_18_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_10.id, "TransactionMerchant", $merchant_nectar_studio.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_10.id, "TransactionCategory", $cat_design_contractor_expense.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-05-23T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 5000,
  balance: 1403.17,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 11,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 5,000.00; 1,403.17 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 5000,
    bankChargeZar: 15,
    balanceZar: 1403.17
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_06_18_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-05-23T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 5000,
  balance: 1403.17,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Business-to-personal transfer to the personal current account."
});
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_06_18_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_11.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_11.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-05-23T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 990,
  balance: 413.17,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 12,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 990.00; 413.17 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 990,
    bankChargeZar: 8,
    balanceZar: 413.17
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_06_18_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-05-23T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 990,
  balance: 413.17,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Business-to-personal transfer to the personal current account."
});
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_06_18_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_12.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_12.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-05-26T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 23 May",
  normalizedDescription: "Cursor",
  amount: 368.73,
  balance: 44.44,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 13,
    rawRowText: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 23 May; 368.73; 44.44 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Cursor",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 368.73,
    bankChargeZar: 3.68,
    balanceZar: 44.44
},
  notes: "Cursor AI tooling spend."
});
LET $tx_stmt_2025_06_18_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-05-26T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 23 May",
  normalizedDescription: "Cursor",
  amount: 368.73,
  balance: 44.44,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_06_18_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_13.id, "TransactionMerchant", $merchant_cursor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_13.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-05-27T00:00:00Z",
  description: "12.66",
  normalizedDescription: "Bank Fee",
  amount: 12.66,
  balance: 31.78,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 14,
    rawRowText: "12.66; 31.78 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 12.66,
    bankChargeZar: null,
    balanceZar: 31.78
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_06_18_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-05-27T00:00:00Z",
  description: "12.66",
  normalizedDescription: "Bank Fee",
  amount: 12.66,
  balance: 31.78,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line; exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_06_18_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_14.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_14.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-05-28T00:00:00Z",
  description: "FNB OB Pmt Sansor",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 6881.78,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 15,
    rawRowText: "FNB OB Pmt Sansor; 6,850.00 Cr; 6,881.78 Cr",
    transactionType: "income",
    normalizedMerchant: "Sansor",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6850,
    bankChargeZar: null,
    balanceZar: 6881.78
},
  notes: "Recurring client payment from Sansor."
});
LET $tx_stmt_2025_06_18_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-05-28T00:00:00Z",
  description: "FNB OB Pmt Sansor",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 6881.78,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_06_18_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_15.id, "TransactionMerchant", $merchant_sansor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_15.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-05-30T00:00:00Z",
  description: "POS Purchase 23.00 Openai *Chatg                                                    485442*7050 28 May",
  normalizedDescription: "OpenAI",
  amount: 421.5,
  balance: 6460.28,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 16,
    rawRowText: "POS Purchase 23.00 Openai *Chatg                                                    485442*7050 28 May; 421.50; 6,460.28 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "OpenAI",
    category: "AI tools",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 421.5,
    bankChargeZar: 3.68,
    balanceZar: 6460.28
},
  notes: "OpenAI business tooling spend."
});
LET $tx_stmt_2025_06_18_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-05-30T00:00:00Z",
  description: "POS Purchase 23.00 Openai *Chatg                                                    485442*7050 28 May",
  normalizedDescription: "OpenAI",
  amount: 421.5,
  balance: 6460.28,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "OpenAI",
  merchant: $merchant_openai,
  category: $cat_ai_tools,
  isTransfer: false,
  manualOverride: false,
  notes: "OpenAI business tooling spend."
});
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_06_18_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_16.id, "TransactionMerchant", $merchant_openai.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_16.id, "TransactionCategory", $cat_ai_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 6000,
  balance: 460.28,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 17,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 6,000.00; 460.28 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6000,
    bankChargeZar: 15,
    balanceZar: 460.28
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_06_18_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 6000,
  balance: 460.28,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Business-to-personal transfer to the personal current account."
});
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_06_18_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_17.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_17.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Int-Banking Pmt Frm Inv-127566",
  normalizedDescription: "Inv-127566",
  amount: 6880,
  balance: 7340.28,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 18,
    rawRowText: "Int-Banking Pmt Frm Inv-127566; 6,880.00 Cr; 7,340.28 Cr",
    transactionType: "income",
    normalizedMerchant: "Inv-127566",
    category: "Client income",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 6880,
    bankChargeZar: null,
    balanceZar: 7340.28
},
  notes: "Income linked to invoice 127566; exact client/source still needs later review."
});
LET $tx_stmt_2025_06_18_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Int-Banking Pmt Frm Inv-127566",
  normalizedDescription: "Inv-127566",
  amount: 6880,
  balance: 7340.28,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Inv-127566",
  merchant: $merchant_inv_127566,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Income linked to invoice 127566; exact client/source still needs later review."
});
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_06_18_row_18.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_18.id, "TransactionMerchant", $merchant_inv_127566.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_18.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_18 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-18",
  transaction: $tx_stmt_2025_06_18_row_18,
  status: "open",
  question: "What is the exact purpose of this Inv-127566 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_inv_127566,
  suggestedCategory: $cat_client_income,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_18.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "True Fit",
  amount: 1000,
  balance: 8340.28,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 19,
    rawRowText: "Magtape Credit 127167 True Fit; 1,000.00 Cr; 8,340.28 Cr",
    transactionType: "income",
    normalizedMerchant: "True Fit",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: 8340.28
},
  notes: "True Fit maintenance income."
});
LET $tx_stmt_2025_06_18_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "True Fit",
  amount: 1000,
  balance: 8340.28,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "True Fit",
  merchant: $merchant_true_fit,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "True Fit maintenance income."
});
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_06_18_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_19.id, "TransactionMerchant", $merchant_true_fit.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_19.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Sk8363",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 7562.73,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 20,
    rawRowText: "Magtape Debit Outsurance Ot87677302 Sk8363; 777.55; 7,562.73 Cr; 12.00",
    transactionType: "expense",
    normalizedMerchant: "Outsurance",
    category: "Insurance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 777.55,
    bankChargeZar: 12,
    balanceZar: 7562.73
},
  notes: "Insurance debit."
});
LET $tx_stmt_2025_06_18_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Sk8363",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 7562.73,
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
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_06_18_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_20.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_20.id, "TransactionCategory", $cat_insurance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-06-03T00:00:00Z",
  description: "POS Purchase 8.38 Google Gsuite_                                                    485442*7050 01 Jun",
  normalizedDescription: "Google Workspace",
  amount: 175.32,
  balance: 7387.41,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 21,
    rawRowText: "POS Purchase 8.38 Google Gsuite_                                                    485442*7050 01 Jun; 175.32; 7,387.41 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Google Workspace",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 175.32,
    bankChargeZar: 3.68,
    balanceZar: 7387.41
},
  notes: "Google Workspace subscription spend."
});
LET $tx_stmt_2025_06_18_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-06-03T00:00:00Z",
  description: "POS Purchase 8.38 Google Gsuite_                                                    485442*7050 01 Jun",
  normalizedDescription: "Google Workspace",
  amount: 175.32,
  balance: 7387.41,
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
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_06_18_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_21.id, "TransactionMerchant", $merchant_google_workspace.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_21.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-06-05T00:00:00Z",
  description: "POS Purchase 12.00 Notion Labs,                                                     485442*7050 04 Jun",
  normalizedDescription: "Notion",
  amount: 219.63,
  balance: 7167.78,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 22,
    rawRowText: "POS Purchase 12.00 Notion Labs,                                                     485442*7050 04 Jun; 219.63; 7,167.78 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Notion",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 219.63,
    bankChargeZar: 3.68,
    balanceZar: 7167.78
},
  notes: "Notion subscription spend."
});
LET $tx_stmt_2025_06_18_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-06-05T00:00:00Z",
  description: "POS Purchase 12.00 Notion Labs,                                                     485442*7050 04 Jun",
  normalizedDescription: "Notion",
  amount: 219.63,
  balance: 7167.78,
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
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_06_18_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_22.id, "TransactionMerchant", $merchant_notion.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_22.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-06-07T00:00:00Z",
  description: "POS Purchase Diamatrix CC                                                           485442*7050 05 Jun",
  normalizedDescription: "Diamatrix",
  amount: 405.03,
  balance: 6762.75,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 23,
    rawRowText: "POS Purchase Diamatrix CC                                                           485442*7050 05 Jun; 405.03; 6,762.75 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Diamatrix",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 405.03,
    bankChargeZar: 3.68,
    balanceZar: 6762.75
},
  notes: "Hosting or software-service spend."
});
LET $tx_stmt_2025_06_18_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-06-07T00:00:00Z",
  description: "POS Purchase Diamatrix CC                                                           485442*7050 05 Jun",
  normalizedDescription: "Diamatrix",
  amount: 405.03,
  balance: 6762.75,
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_06_18_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_23.id, "TransactionMerchant", $merchant_diamatrix.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_23.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-06-07T00:00:00Z",
  description: "POS Purchase 130.84 Paypal *Vect                                                    485442*7050 04 Jun",
  normalizedDescription: "Vecteezy",
  amount: 130.84,
  balance: 6631.91,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 24,
    rawRowText: "POS Purchase 130.84 Paypal *Vect                                                    485442*7050 04 Jun; 130.84; 6,631.91 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Vecteezy",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 130.84,
    bankChargeZar: 3.68,
    balanceZar: 6631.91
},
  notes: "Vecteezy stock image and video subscription."
});
LET $tx_stmt_2025_06_18_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-06-07T00:00:00Z",
  description: "POS Purchase 130.84 Paypal *Vect                                                    485442*7050 04 Jun",
  normalizedDescription: "Vecteezy",
  amount: 130.84,
  balance: 6631.91,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Vecteezy",
  merchant: $merchant_vecteezy,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Vecteezy stock image and video subscription."
});
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_06_18_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_24.id, "TransactionMerchant", $merchant_vecteezy.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_24.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-06-09T00:00:00Z",
  description: "Internet Pmt To Vdv Internet                                                        Mic00017",
  normalizedDescription: "VDV Internet",
  amount: 848.5,
  balance: 5783.41,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 25,
    rawRowText: "Internet Pmt To Vdv Internet                                                        Mic00017; 848.50; 5,783.41 Cr",
    transactionType: "expense",
    normalizedMerchant: "VDV Internet",
    category: "Internet / connectivity",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 848.5,
    bankChargeZar: null,
    balanceZar: 5783.41
},
  notes: "Monthly business internet bill."
});
LET $tx_stmt_2025_06_18_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-06-09T00:00:00Z",
  description: "Internet Pmt To Vdv Internet                                                        Mic00017",
  normalizedDescription: "VDV Internet",
  amount: 848.5,
  balance: 5783.41,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VDV Internet",
  merchant: $merchant_vdv_internet,
  category: $cat_internet_connectivity,
  isTransfer: false,
  manualOverride: false,
  notes: "Monthly business internet bill."
});
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_06_18_row_25.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_25.id, "TransactionMerchant", $merchant_vdv_internet.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_25.id, "TransactionCategory", $cat_internet_connectivity.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-06-09T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2500,
  balance: 3283.41,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 26,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 2,500.00; 3,283.41 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2500,
    bankChargeZar: 8,
    balanceZar: 3283.41
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_06_18_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-06-09T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2500,
  balance: 3283.41,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Business-to-personal transfer to the personal current account."
});
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_06_18_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_26.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_26.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-06-09T00:00:00Z",
  description: "POS Purchase Diamatrix                                                          485442*7050 06 Jun",
  normalizedDescription: "Diamatrix",
  amount: 90.83,
  balance: 3192.58,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 27,
    rawRowText: "POS Purchase Diamatrix                                                          485442*7050 06 Jun; 90.83; 3,192.58 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Diamatrix",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 90.83,
    bankChargeZar: 3.68,
    balanceZar: 3192.58
},
  notes: "Hosting or software-service spend."
});
LET $tx_stmt_2025_06_18_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-06-09T00:00:00Z",
  description: "POS Purchase Diamatrix                                                          485442*7050 06 Jun",
  normalizedDescription: "Diamatrix",
  amount: 90.83,
  balance: 3192.58,
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
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_06_18_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_27.id, "TransactionMerchant", $merchant_diamatrix.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_27.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-06-10T00:00:00Z",
  description: "POS Purchase 22000.00 Dpo*Wazoho                                                485442*7050 06 Jun",
  normalizedDescription: "Wazo Host",
  amount: 151.34,
  balance: 3041.24,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 28,
    rawRowText: "POS Purchase 22000.00 Dpo*Wazoho                                                485442*7050 06 Jun; 151.34; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Wazo Host",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 151.34,
    bankChargeZar: 3.68,
    balanceZar: 3041.24
},
  notes: "Hosting expense paid to Wazo Host via DPO."
});
LET $tx_stmt_2025_06_18_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-06-10T00:00:00Z",
  description: "POS Purchase 22000.00 Dpo*Wazoho                                                485442*7050 06 Jun",
  normalizedDescription: "Wazo Host",
  amount: 151.34,
  balance: 3041.24,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Wazo Host",
  merchant: $merchant_wazo_host,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting expense paid to Wazo Host via DPO."
});
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_06_18_row_28.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_28.id, "TransactionMerchant", $merchant_wazo_host.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_28.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-06-10T00:00:00Z",
  description: "POS Purchase 13.56 Cursor Usage                                                 485442*7050 09 Jun",
  normalizedDescription: "Cursor",
  amount: 246.37,
  balance: 2794.87,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 29,
    rawRowText: "POS Purchase 13.56 Cursor Usage                                                 485442*7050 09 Jun; 246.37; 2,794.87 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Cursor",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 246.37,
    bankChargeZar: 3.68,
    balanceZar: 2794.87
},
  notes: "Cursor AI tooling spend."
});
LET $tx_stmt_2025_06_18_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-06-10T00:00:00Z",
  description: "POS Purchase 13.56 Cursor Usage                                                 485442*7050 09 Jun",
  normalizedDescription: "Cursor",
  amount: 246.37,
  balance: 2794.87,
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
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_06_18_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_29.id, "TransactionMerchant", $merchant_cursor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_29.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-06-11T00:00:00Z",
  description: "POS Purchase 19.00 Magic Pattern                                                485442*7050 10 Jun",
  normalizedDescription: "Magic Pattern",
  amount: 345.36,
  balance: 2449.51,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 30,
    rawRowText: "POS Purchase 19.00 Magic Pattern                                                485442*7050 10 Jun; 345.36; 2,449.51 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Magic Pattern",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 345.36,
    bankChargeZar: 3.68,
    balanceZar: 2449.51
},
  notes: "Digital subscription for an online prototyping SaaS."
});
LET $tx_stmt_2025_06_18_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-06-11T00:00:00Z",
  description: "POS Purchase 19.00 Magic Pattern                                                485442*7050 10 Jun",
  normalizedDescription: "Magic Pattern",
  amount: 345.36,
  balance: 2449.51,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Magic Pattern",
  merchant: $merchant_magic_pattern,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Digital subscription for an online prototyping SaaS."
});
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_06_18_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_30.id, "TransactionMerchant", $merchant_magic_pattern.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_30.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-06-12T00:00:00Z",
  description: "2.62",
  normalizedDescription: "Bank Fee",
  amount: 2.62,
  balance: 2446.89,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 31,
    rawRowText: "2.62; 2,446.89 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 2.62,
    bankChargeZar: null,
    balanceZar: 2446.89
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_06_18_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-06-12T00:00:00Z",
  description: "2.62",
  normalizedDescription: "Bank Fee",
  amount: 2.62,
  balance: 2446.89,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line; exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_06_18_row_31.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_31.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_31.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-06-13T00:00:00Z",
  description: "Magtape Credit Liq Express",
  normalizedDescription: "Liquor Express",
  amount: 1680,
  balance: 4126.89,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 32,
    rawRowText: "Magtape Credit Liq Express; 1,680.00 Cr; 4,126.89 Cr",
    transactionType: "income",
    normalizedMerchant: "Liquor Express",
    category: "Hosting income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1680,
    bankChargeZar: null,
    balanceZar: 4126.89
},
  notes: "Hosting-services income from Liquor Express."
});
LET $tx_stmt_2025_06_18_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-06-13T00:00:00Z",
  description: "Magtape Credit Liq Express",
  normalizedDescription: "Liquor Express",
  amount: 1680,
  balance: 4126.89,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Liquor Express",
  merchant: $merchant_liquor_express,
  category: $cat_hosting_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting-services income from Liquor Express."
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_06_18_row_32.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_32.id, "TransactionMerchant", $merchant_liquor_express.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_32.id, "TransactionCategory", $cat_hosting_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-06-13T00:00:00Z",
  description: "POS Purchase 103.92 Paypal *Elit                                                485442*7050 11 Jun",
  normalizedDescription: "Elitehost",
  amount: 103.92,
  balance: 4022.97,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 33,
    rawRowText: "POS Purchase 103.92 Paypal *Elit                                                485442*7050 11 Jun; 103.92; 4,022.97 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 103.92,
    bankChargeZar: 3.68,
    balanceZar: 4022.97
},
  notes: "Elitehost hosting expense."
});
LET $tx_stmt_2025_06_18_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-06-13T00:00:00Z",
  description: "POS Purchase 103.92 Paypal *Elit                                                485442*7050 11 Jun",
  normalizedDescription: "Elitehost",
  amount: 103.92,
  balance: 4022.97,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Elitehost",
  merchant: $merchant_elitehost,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Elitehost hosting expense."
});
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_06_18_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_33.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_33.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-06-13T00:00:00Z",
  description: "POS Purchase 22000.00 Dpo*Wazoho                                                485442*7050 10 Jun",
  normalizedDescription: "Wazo Host",
  amount: 152.63,
  balance: 3870.34,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 34,
    rawRowText: "POS Purchase 22000.00 Dpo*Wazoho                                                485442*7050 10 Jun; 152.63; 3,870.34 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Wazo Host",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 152.63,
    bankChargeZar: 3.68,
    balanceZar: 3870.34
},
  notes: "Hosting expense paid to Wazo Host via DPO."
});
LET $tx_stmt_2025_06_18_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-06-13T00:00:00Z",
  description: "POS Purchase 22000.00 Dpo*Wazoho                                                485442*7050 10 Jun",
  normalizedDescription: "Wazo Host",
  amount: 152.63,
  balance: 3870.34,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Wazo Host",
  merchant: $merchant_wazo_host,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting expense paid to Wazo Host via DPO."
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_06_18_row_34.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_34.id, "TransactionMerchant", $merchant_wazo_host.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_34.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2025-06-18T00:00:00Z",
  description: "0.00",
  normalizedDescription: "Bank Fee",
  amount: 10,
  balance: 3870.34,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 35,
    rawRowText: "0.00; 3,870.34 Cr; 10.00",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 10,
    bankChargeZar: null,
    balanceZar: 3870.34
},
  notes: "Inferred month-end FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_06_18_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-35",
  sourceRow: $row_row_35,
  postedAt: "2025-06-18T00:00:00Z",
  description: "0.00",
  normalizedDescription: "Bank Fee",
  amount: 10,
  balance: 3870.34,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Inferred month-end FNB fee line; exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_06_18_row_35.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_35.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_35.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2025-06-18T00:00:00Z",
  description: "89.00",
  normalizedDescription: "Bank Fee",
  amount: 89,
  balance: 3781.34,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 36,
    rawRowText: "89.00; 3,781.34 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 89,
    bankChargeZar: null,
    balanceZar: 3781.34
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_06_18_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-36",
  sourceRow: $row_row_36,
  postedAt: "2025-06-18T00:00:00Z",
  description: "89.00",
  normalizedDescription: "Bank Fee",
  amount: 89,
  balance: 3781.34,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line; exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_06_18_row_36.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_36.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_36.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 37
LET $row_row_37 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 37,
  postedAt: "2025-06-18T00:00:00Z",
  description: "131.84",
  normalizedDescription: "Bank Fee",
  amount: 131.84,
  balance: 3649.5,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 37,
    rawRowText: "131.84; 3,649.50 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 131.84,
    bankChargeZar: null,
    balanceZar: 3649.5
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_06_18_row_37 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-37",
  sourceRow: $row_row_37,
  postedAt: "2025-06-18T00:00:00Z",
  description: "131.84",
  normalizedDescription: "Bank Fee",
  amount: 131.84,
  balance: 3649.5,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line; exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_37.id, { transaction: $tx_stmt_2025_06_18_row_37.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_37.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_37.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_37.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 37,
  normalizedCount: 37,
  clarificationCount: 1,
  status: "matched",
  statementDate: "2025-06-18T00:00:00Z",
  notes: "Imported from 2025-06-18.import.md"
});

-- End of generated import
