-- Generated from docs/statements/business/2025-07-18.import.md
-- Source: docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf

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
  openingBalance: 3649.5,
  active: true,
  notes: "Imported from GOLD_BUSINESS_ACCOUNT_81.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-07-18-fnb-gold-business-27821",
  sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-07-18T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-07-18.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_hosting_internet = fn::createCategory({
  space: $space,
  key: "hosting-internet",
  name: "Hosting / internet",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $cat_business_to_personal_transfer = fn::createCategory({
  space: $space,
  key: "business-to-personal-transfer",
  name: "Business to personal transfer",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $cat_client_income = fn::createCategory({
  space: $space,
  key: "client-income",
  name: "Client income",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $cat_hosting_income = fn::createCategory({
  space: $space,
  key: "hosting-income",
  name: "Hosting income",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $cat_internet_connectivity = fn::createCategory({
  space: $space,
  key: "internet-connectivity",
  name: "Internet / connectivity",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $cat_software_saas = fn::createCategory({
  space: $space,
  key: "software-saas",
  name: "Software / SaaS",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $cat_insurance = fn::createCategory({
  space: $space,
  key: "insurance",
  name: "Insurance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $cat_ai_tools = fn::createCategory({
  space: $space,
  key: "ai-tools",
  name: "AI tools",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $cat_domains_hosting = fn::createCategory({
  space: $space,
  key: "domains-hosting",
  name: "Domains / hosting",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $cat_fees_card_charge = fn::createCategory({
  space: $space,
  key: "fees-card-charge",
  name: "Card Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $cat_fees_bank_fee = fn::createCategory({
  space: $space,
  key: "fees-bank-fee",
  name: "Bank Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});

-- Merchant records
LET $merchant_elitehost = fn::createMerchant({
  space: $space,
  key: "elitehost",
  name: "Elitehost",
  normalizedName: "Elitehost",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_fnb = fn::createMerchant({
  space: $space,
  key: "fnb",
  name: "FNB",
  normalizedName: "FNB",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_michael_peters = fn::createMerchant({
  space: $space,
  key: "michael-peters",
  name: "Michael Peters",
  normalizedName: "Michael Peters",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_esta_van_coppenhagen = fn::createMerchant({
  space: $space,
  key: "esta-van-coppenhagen",
  name: "Esta van Coppenhagen",
  normalizedName: "Esta van Coppenhagen",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_vdv_internet = fn::createMerchant({
  space: $space,
  key: "vdv-internet",
  name: "VDV Internet",
  normalizedName: "VDV Internet",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_cursor = fn::createMerchant({
  space: $space,
  key: "cursor",
  name: "Cursor",
  normalizedName: "Cursor",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_sansor = fn::createMerchant({
  space: $space,
  key: "sansor",
  name: "Sansor",
  normalizedName: "Sansor",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_diamatrix = fn::createMerchant({
  space: $space,
  key: "diamatrix",
  name: "Diamatrix",
  normalizedName: "Diamatrix",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_outsurance = fn::createMerchant({
  space: $space,
  key: "outsurance",
  name: "Outsurance",
  normalizedName: "Outsurance",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_openai = fn::createMerchant({
  space: $space,
  key: "openai",
  name: "OpenAI",
  normalizedName: "OpenAI",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_google_workspace = fn::createMerchant({
  space: $space,
  key: "google-workspace",
  name: "Google Workspace",
  normalizedName: "Google Workspace",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_notion = fn::createMerchant({
  space: $space,
  key: "notion",
  name: "Notion",
  normalizedName: "Notion",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_atlassian = fn::createMerchant({
  space: $space,
  key: "atlassian",
  name: "Atlassian",
  normalizedName: "Atlassian",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_vecteezy = fn::createMerchant({
  space: $space,
  key: "vecteezy",
  name: "Vecteezy",
  normalizedName: "Vecteezy",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_magic_pattern = fn::createMerchant({
  space: $space,
  key: "magic-pattern",
  name: "Magic Pattern",
  normalizedName: "Magic Pattern",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_claude = fn::createMerchant({
  space: $space,
  key: "claude",
  name: "Claude",
  normalizedName: "Claude",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});
LET $merchant_name_com = fn::createMerchant({
  space: $space,
  key: "name-com",
  name: "Name.com",
  normalizedName: "Name.com",
  active: true,
  notes: "Imported from 2025-07-18.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-06-19T00:00:00Z",
  description: "POS Purchase 57.97 Paypal *Elite                                                    485442*7050 17 Jun",
  normalizedDescription: "Elitehost",
  amount: 57.97,
  balance: 3591.53,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 1,
    rawRowText: "POS Purchase 57.97 Paypal *Elite                                                    485442*7050 17 Jun; 57.97; 3,591.53 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 57.97,
    bankChargeZar: 3.68,
    balanceZar: 3591.53
},
  notes: "Elitehost hosting payment."
});
LET $tx_stmt_2025_07_18_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-06-19T00:00:00Z",
  description: "POS Purchase 57.97 Paypal *Elite                                                    485442*7050 17 Jun",
  normalizedDescription: "Elitehost",
  amount: 57.97,
  balance: 3591.53,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Elitehost",
  merchant: $merchant_elitehost,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Elitehost hosting payment."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_07_18_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_01.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_01.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-06-19T00:00:00Z",
  description: "POS Purchase 57.97 Paypal *Elite                                                    485442*7050 17 Jun",
  normalizedDescription: "Elitehost",
  amount: 57.97,
  balance: 3533.56,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 2,
    rawRowText: "POS Purchase 57.97 Paypal *Elite                                                    485442*7050 17 Jun; 57.97; 3,533.56 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 57.97,
    bankChargeZar: 3.68,
    balanceZar: 3533.56
},
  notes: "Elitehost hosting payment."
});
LET $tx_stmt_2025_07_18_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-06-19T00:00:00Z",
  description: "POS Purchase 57.97 Paypal *Elite                                                    485442*7050 17 Jun",
  normalizedDescription: "Elitehost",
  amount: 57.97,
  balance: 3533.56,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Elitehost",
  merchant: $merchant_elitehost,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Elitehost hosting payment."
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_07_18_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_02.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_02.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-06-20T00:00:00Z",
  description: "2.08",
  normalizedDescription: "Bank Fee",
  amount: 2.08,
  balance: 3531.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 3,
    rawRowText: "2.08; 3,531.48 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 2.08,
    bankChargeZar: null,
    balanceZar: 3531.48
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_07_18_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-06-20T00:00:00Z",
  description: "2.08",
  normalizedDescription: "Bank Fee",
  amount: 2.08,
  balance: 3531.48,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_07_18_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_03.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_03.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-06-20T00:00:00Z",
  description: "POS Purchase 58.09 Paypal *Elite                                                    485442*7050 18 Jun",
  normalizedDescription: "Elitehost",
  amount: 58.09,
  balance: 3473.39,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 4,
    rawRowText: "POS Purchase 58.09 Paypal *Elite                                                    485442*7050 18 Jun; 58.09; 3,473.39 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 58.09,
    bankChargeZar: 3.68,
    balanceZar: 3473.39
},
  notes: "Elitehost hosting payment."
});
LET $tx_stmt_2025_07_18_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-06-20T00:00:00Z",
  description: "POS Purchase 58.09 Paypal *Elite                                                    485442*7050 18 Jun",
  normalizedDescription: "Elitehost",
  amount: 58.09,
  balance: 3473.39,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Elitehost",
  merchant: $merchant_elitehost,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Elitehost hosting payment."
});
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_07_18_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_04.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_04.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-06-20T00:00:00Z",
  description: "POS Purchase 633.00 Paypal *Elit                                                    485442*7050 17 Jun",
  normalizedDescription: "Elitehost",
  amount: 633,
  balance: 2840.39,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 5,
    rawRowText: "POS Purchase 633.00 Paypal *Elit                                                    485442*7050 17 Jun; 633.00; 2,840.39 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 633,
    bankChargeZar: 3.68,
    balanceZar: 2840.39
},
  notes: "Elitehost hosting payment bundle."
});
LET $tx_stmt_2025_07_18_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-06-20T00:00:00Z",
  description: "POS Purchase 633.00 Paypal *Elit                                                    485442*7050 17 Jun",
  normalizedDescription: "Elitehost",
  amount: 633,
  balance: 2840.39,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_07_18_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_05.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_05.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-06-24T00:00:00Z",
  description: "FNB App Rtc Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2000,
  balance: 840.39,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 6,
    rawRowText: "FNB App Rtc Pmt To Supplier Michael Pet                                             Mpire Digital Market; 2,000.00; 840.39 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: 8,
    balanceZar: 840.39
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_07_18_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-06-24T00:00:00Z",
  description: "FNB App Rtc Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2000,
  balance: 840.39,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_07_18_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_06.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_06.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-06-24T00:00:00Z",
  description: "Rtc Credit Estavcoppenhagen                                                         28Dtbsqy85",
  normalizedDescription: "Esta van Coppenhagen",
  amount: 25000,
  balance: 25840.39,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 7,
    rawRowText: "Rtc Credit Estavcoppenhagen                                                         28Dtbsqy85; 25,000.00 Cr; 25,840.39 Cr",
    transactionType: "income",
    normalizedMerchant: "Esta van Coppenhagen",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 25000,
    bankChargeZar: null,
    balanceZar: 25840.39
},
  notes: "Stage 2 completion invoice income for the Esta van Coppenhagen website project."
});
LET $tx_stmt_2025_07_18_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-06-24T00:00:00Z",
  description: "Rtc Credit Estavcoppenhagen                                                         28Dtbsqy85",
  normalizedDescription: "Esta van Coppenhagen",
  amount: 25000,
  balance: 25840.39,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Esta van Coppenhagen",
  merchant: $merchant_esta_van_coppenhagen,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Stage 2 completion invoice income for the Esta van Coppenhagen website project."
});
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_07_18_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_07.id, "TransactionMerchant", $merchant_esta_van_coppenhagen.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_07.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-06-24T00:00:00Z",
  description: "Internet Pmt To Esta Stage 2                                                        Mpire Digital:Esta V",
  normalizedDescription: "Esta van Coppenhagen",
  amount: 4000,
  balance: 21840.39,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 8,
    rawRowText: "Internet Pmt To Esta Stage 2                                                        Mpire Digital:Esta V; 4,000.00; 21,840.39 Cr",
    transactionType: "income",
    normalizedMerchant: "Esta van Coppenhagen",
    category: "Hosting income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 4000,
    bankChargeZar: null,
    balanceZar: 21840.39
},
  notes: "Hosting income for Esta van Coppenhagen's site."
});
LET $tx_stmt_2025_07_18_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-06-24T00:00:00Z",
  description: "Internet Pmt To Esta Stage 2                                                        Mpire Digital:Esta V",
  normalizedDescription: "Esta van Coppenhagen",
  amount: 4000,
  balance: 21840.39,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Esta van Coppenhagen",
  merchant: $merchant_esta_van_coppenhagen,
  category: $cat_hosting_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting income for Esta van Coppenhagen's site."
});
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_07_18_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_08.id, "TransactionMerchant", $merchant_esta_van_coppenhagen.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_08.id, "TransactionCategory", $cat_hosting_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-06-24T00:00:00Z",
  description: "FNB App Rtc Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 15000,
  balance: 6840.39,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 9,
    rawRowText: "FNB App Rtc Pmt To Supplier Michael Pet                                             Mpire Digital Market; 15,000.00; 6,840.39 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 15000,
    bankChargeZar: 15,
    balanceZar: 6840.39
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_07_18_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-06-24T00:00:00Z",
  description: "FNB App Rtc Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 15000,
  balance: 6840.39,
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_07_18_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_09.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_09.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-06-24T00:00:00Z",
  description: "1.16",
  normalizedDescription: "Bank Fee",
  amount: 1.16,
  balance: 6839.23,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 10,
    rawRowText: "1.16; 6,839.23 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 1.16,
    bankChargeZar: null,
    balanceZar: 6839.23
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_07_18_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-06-24T00:00:00Z",
  description: "1.16",
  normalizedDescription: "Bank Fee",
  amount: 1.16,
  balance: 6839.23,
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_07_18_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_10.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_10.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-06-24T00:00:00Z",
  description: "1.16",
  normalizedDescription: "Bank Fee",
  amount: 1.16,
  balance: 6838.07,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 11,
    rawRowText: "1.16; 6,838.07 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 1.16,
    bankChargeZar: null,
    balanceZar: 6838.07
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_07_18_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-06-24T00:00:00Z",
  description: "1.16",
  normalizedDescription: "Bank Fee",
  amount: 1.16,
  balance: 6838.07,
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_07_18_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_11.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_11.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-06-24T00:00:00Z",
  description: "1.16",
  normalizedDescription: "Bank Fee",
  amount: 1.16,
  balance: 6836.91,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 12,
    rawRowText: "1.16; 6,836.91 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 1.16,
    bankChargeZar: null,
    balanceZar: 6836.91
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_07_18_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-06-24T00:00:00Z",
  description: "1.16",
  normalizedDescription: "Bank Fee",
  amount: 1.16,
  balance: 6836.91,
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_07_18_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_12.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_12.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-06-24T00:00:00Z",
  description: "12.66",
  normalizedDescription: "Bank Fee",
  amount: 12.66,
  balance: 6824.25,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 13,
    rawRowText: "12.66; 6,824.25 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 12.66,
    bankChargeZar: null,
    balanceZar: 6824.25
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_07_18_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-06-24T00:00:00Z",
  description: "12.66",
  normalizedDescription: "Bank Fee",
  amount: 12.66,
  balance: 6824.25,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_07_18_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_13.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_13.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-06-25T00:00:00Z",
  description: "Internet Pmt To Vdv Internet                                                        Mic00017",
  normalizedDescription: "VDV Internet",
  amount: 849,
  balance: 5975.25,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 14,
    rawRowText: "Internet Pmt To Vdv Internet                                                        Mic00017; 849.00; 5,975.25 Cr",
    transactionType: "expense",
    normalizedMerchant: "VDV Internet",
    category: "Internet / connectivity",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 849,
    bankChargeZar: null,
    balanceZar: 5975.25
},
  notes: "Monthly business internet bill."
});
LET $tx_stmt_2025_07_18_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-06-25T00:00:00Z",
  description: "Internet Pmt To Vdv Internet                                                        Mic00017",
  normalizedDescription: "VDV Internet",
  amount: 849,
  balance: 5975.25,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_07_18_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_14.id, "TransactionMerchant", $merchant_vdv_internet.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_14.id, "TransactionCategory", $cat_internet_connectivity.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-06-25T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 23 Jun",
  normalizedDescription: "Cursor",
  amount: 369.51,
  balance: 5605.74,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 15,
    rawRowText: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 23 Jun; 369.51; 5,605.74 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Cursor",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 369.51,
    bankChargeZar: 3.68,
    balanceZar: 5605.74
},
  notes: "Cursor AI tooling spend."
});
LET $tx_stmt_2025_07_18_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-06-25T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 23 Jun",
  normalizedDescription: "Cursor",
  amount: 369.51,
  balance: 5605.74,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_07_18_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_15.id, "TransactionMerchant", $merchant_cursor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_15.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-06-27T00:00:00Z",
  description: "FNB OB Pmt Sansor",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 12455.74,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 16,
    rawRowText: "FNB OB Pmt Sansor; 6,850.00 Cr; 12,455.74 Cr",
    transactionType: "income",
    normalizedMerchant: "Sansor",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6850,
    bankChargeZar: null,
    balanceZar: 12455.74
},
  notes: "Recurring client payment from Sansor."
});
LET $tx_stmt_2025_07_18_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-06-27T00:00:00Z",
  description: "FNB OB Pmt Sansor",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 12455.74,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_07_18_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_16.id, "TransactionMerchant", $merchant_sansor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_16.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-06-27T00:00:00Z",
  description: "POS Purchase Diamatrix                                                              485442*7050 25 Jun",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 11927.74,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 17,
    rawRowText: "POS Purchase Diamatrix                                                              485442*7050 25 Jun; 528.00; 11,927.74 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Diamatrix",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 528,
    bankChargeZar: 3.68,
    balanceZar: 11927.74
},
  notes: "Hosting or software-service spend."
});
LET $tx_stmt_2025_07_18_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-06-27T00:00:00Z",
  description: "POS Purchase Diamatrix                                                              485442*7050 25 Jun",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 11927.74,
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_07_18_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_17.id, "TransactionMerchant", $merchant_diamatrix.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_17.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-06-27T00:00:00Z",
  description: "POS Purchase 293.59 Paypal *Elit                                                    485442*7050 25 Jun",
  normalizedDescription: "Elitehost",
  amount: 293.59,
  balance: 11634.15,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 18,
    rawRowText: "POS Purchase 293.59 Paypal *Elit                                                    485442*7050 25 Jun; 293.59; 11,634.15 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 293.59,
    bankChargeZar: 3.68,
    balanceZar: 11634.15
},
  notes: "Elitehost hosting payment bundle."
});
LET $tx_stmt_2025_07_18_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-06-27T00:00:00Z",
  description: "POS Purchase 293.59 Paypal *Elit                                                    485442*7050 25 Jun",
  normalizedDescription: "Elitehost",
  amount: 293.59,
  balance: 11634.15,
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_07_18_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_18.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_18.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-06-28T00:00:00Z",
  description: "POS Purchase 478.93 Paypal *Elit                                                    485442*7050 25 Jun",
  normalizedDescription: "Elitehost",
  amount: 478.93,
  balance: 11155.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 19,
    rawRowText: "POS Purchase 478.93 Paypal *Elit                                                    485442*7050 25 Jun; 478.93; 11,155.22 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 478.93,
    bankChargeZar: 3.68,
    balanceZar: 11155.22
},
  notes: "Elitehost hosting payment bundle."
});
LET $tx_stmt_2025_07_18_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-06-28T00:00:00Z",
  description: "POS Purchase 478.93 Paypal *Elit                                                    485442*7050 25 Jun",
  normalizedDescription: "Elitehost",
  amount: 478.93,
  balance: 11155.22,
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
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_07_18_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_19.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_19.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-07-01T00:00:00Z",
  description: "5.87",
  normalizedDescription: "Bank Fee",
  amount: 5.87,
  balance: 11149.35,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 20,
    rawRowText: "5.87; 11,149.35 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 5.87,
    bankChargeZar: null,
    balanceZar: 11149.35
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_07_18_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-07-01T00:00:00Z",
  description: "5.87",
  normalizedDescription: "Bank Fee",
  amount: 5.87,
  balance: 11149.35,
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
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_07_18_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_20.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_20.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-07-01T00:00:00Z",
  description: "9.58",
  normalizedDescription: "Bank Fee",
  amount: 9.58,
  balance: 11139.77,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 21,
    rawRowText: "9.58; 11,139.77 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 9.58,
    bankChargeZar: null,
    balanceZar: 11139.77
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_07_18_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-07-01T00:00:00Z",
  description: "9.58",
  normalizedDescription: "Bank Fee",
  amount: 9.58,
  balance: 11139.77,
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
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_07_18_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_21.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_21.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-07-01T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 We0373",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 10362.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 22,
    rawRowText: "Magtape Debit Outsurance Ot87677302 We0373; 777.55; 10,362.22 Cr; 12.00",
    transactionType: "expense",
    normalizedMerchant: "Outsurance",
    category: "Insurance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 777.55,
    bankChargeZar: 12,
    balanceZar: 10362.22
},
  notes: "Insurance debit."
});
LET $tx_stmt_2025_07_18_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-07-01T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 We0373",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 10362.22,
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
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_07_18_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_22.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_22.id, "TransactionCategory", $cat_insurance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-07-01T00:00:00Z",
  description: "POS Purchase 23.00 Openai *Chatg                                                  485442*7050 28 Jun",
  normalizedDescription: "OpenAI",
  amount: 421.17,
  balance: 9941.05,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 23,
    rawRowText: "POS Purchase 23.00 Openai *Chatg                                                  485442*7050 28 Jun; 421.17; 9,941.05 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "OpenAI",
    category: "AI tools",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 421.17,
    bankChargeZar: 3.68,
    balanceZar: 9941.05
},
  notes: "OpenAI business tooling spend."
});
LET $tx_stmt_2025_07_18_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-07-01T00:00:00Z",
  description: "POS Purchase 23.00 Openai *Chatg                                                  485442*7050 28 Jun",
  normalizedDescription: "OpenAI",
  amount: 421.17,
  balance: 9941.05,
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_07_18_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_23.id, "TransactionMerchant", $merchant_openai.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_23.id, "TransactionCategory", $cat_ai_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-07-03T00:00:00Z",
  description: "POS Purchase 8.38 Google Gsuite_                                                  485442*7050 01 Jul",
  normalizedDescription: "Google Workspace",
  amount: 179.63,
  balance: 9761.42,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 24,
    rawRowText: "POS Purchase 8.38 Google Gsuite_                                                  485442*7050 01 Jul; 179.63; 9,761.42 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Google Workspace",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 179.63,
    bankChargeZar: 3.68,
    balanceZar: 9761.42
},
  notes: "Google Workspace subscription spend."
});
LET $tx_stmt_2025_07_18_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-07-03T00:00:00Z",
  description: "POS Purchase 8.38 Google Gsuite_                                                  485442*7050 01 Jul",
  normalizedDescription: "Google Workspace",
  amount: 179.63,
  balance: 9761.42,
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
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_07_18_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_24.id, "TransactionMerchant", $merchant_google_workspace.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_24.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-07-07T00:00:00Z",
  description: "POS Purchase 12.00 Notion Labs,                                                   485442*7050 04 Jul",
  normalizedDescription: "Notion",
  amount: 216.16,
  balance: 9545.26,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 25,
    rawRowText: "POS Purchase 12.00 Notion Labs,                                                   485442*7050 04 Jul; 216.16; 9,545.26 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Notion",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 216.16,
    bankChargeZar: 3.68,
    balanceZar: 9545.26
},
  notes: "Notion subscription spend."
});
LET $tx_stmt_2025_07_18_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-07-07T00:00:00Z",
  description: "POS Purchase 12.00 Notion Labs,                                                   485442*7050 04 Jul",
  normalizedDescription: "Notion",
  amount: 216.16,
  balance: 9545.26,
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
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_07_18_row_25.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_25.id, "TransactionMerchant", $merchant_notion.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_25.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-07-07T00:00:00Z",
  description: "POS Purchase 18.98 Atlassian                                                      485442*7050 05 Jul",
  normalizedDescription: "Atlassian",
  amount: 341.78,
  balance: 9203.48,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 26,
    rawRowText: "POS Purchase 18.98 Atlassian                                                      485442*7050 05 Jul; 341.78; 9,203.48 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Atlassian",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 341.78,
    bankChargeZar: 3.68,
    balanceZar: 9203.48
},
  notes: "Atlassian subscription spend."
});
LET $tx_stmt_2025_07_18_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-07-07T00:00:00Z",
  description: "POS Purchase 18.98 Atlassian                                                      485442*7050 05 Jul",
  normalizedDescription: "Atlassian",
  amount: 341.78,
  balance: 9203.48,
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
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_07_18_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_26.id, "TransactionMerchant", $merchant_atlassian.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_26.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-07-08T00:00:00Z",
  description: "POS Purchase 128.77 Paypal *Vect                                                  485442*7050 04 Jul",
  normalizedDescription: "Vecteezy",
  amount: 128.77,
  balance: 9074.71,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 27,
    rawRowText: "POS Purchase 128.77 Paypal *Vect                                                  485442*7050 04 Jul; 128.77; 9,074.71 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Vecteezy",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 128.77,
    bankChargeZar: 3.68,
    balanceZar: 9074.71
},
  notes: "Vecteezy stock image and video subscription."
});
LET $tx_stmt_2025_07_18_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-07-08T00:00:00Z",
  description: "POS Purchase 128.77 Paypal *Vect                                                  485442*7050 04 Jul",
  normalizedDescription: "Vecteezy",
  amount: 128.77,
  balance: 9074.71,
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
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_07_18_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_27.id, "TransactionMerchant", $merchant_vecteezy.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_27.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-07-10T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                           Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 7000,
  balance: 2074.71,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 28,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                           Mpire Digital Market; 7,000.00; 2,074.71 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 7000,
    bankChargeZar: 15,
    balanceZar: 2074.71
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_07_18_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-07-10T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                           Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 7000,
  balance: 2074.71,
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
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_07_18_row_28.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_28.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_28.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-07-11T00:00:00Z",
  description: "POS Purchase 19.00 Magic Pattern                                                  485442*7050 10 Jul",
  normalizedDescription: "Magic Pattern",
  amount: 346.51,
  balance: 1728.2,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 29,
    rawRowText: "POS Purchase 19.00 Magic Pattern                                                  485442*7050 10 Jul; 346.51; 1,728.20 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Magic Pattern",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 346.51,
    bankChargeZar: 3.68,
    balanceZar: 1728.2
},
  notes: "Digital subscription for an online prototyping SaaS."
});
LET $tx_stmt_2025_07_18_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-07-11T00:00:00Z",
  description: "POS Purchase 19.00 Magic Pattern                                                  485442*7050 10 Jul",
  normalizedDescription: "Magic Pattern",
  amount: 346.51,
  balance: 1728.2,
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
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_07_18_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_29.id, "TransactionMerchant", $merchant_magic_pattern.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_29.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-07-15T00:00:00Z",
  description: "2.90",
  normalizedDescription: "Bank Fee",
  amount: 2.9,
  balance: 1725.3,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 30,
    rawRowText: "2.90; 1,725.30 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 2.9,
    bankChargeZar: null,
    balanceZar: 1725.3
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_07_18_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-07-15T00:00:00Z",
  description: "2.90",
  normalizedDescription: "Bank Fee",
  amount: 2.9,
  balance: 1725.3,
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
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_07_18_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_30.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_30.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-07-16T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                           Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1100,
  balance: 625.3,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 31,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                           Mpire Digital Market; 1,100.00; 625.30 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1100,
    bankChargeZar: 8,
    balanceZar: 625.3
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_07_18_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-07-16T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                           Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1100,
  balance: 625.3,
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
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_07_18_row_31.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_31.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_31.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-07-17T00:00:00Z",
  description: "POS Purchase 20.00 Claude.Ai Sub                                                  485442*7050 16 Jul",
  normalizedDescription: "Claude",
  amount: 368.4,
  balance: 256.9,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 32,
    rawRowText: "POS Purchase 20.00 Claude.Ai Sub                                                  485442*7050 16 Jul; 368.40; 256.90 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Claude",
    category: "AI tools",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 368.4,
    bankChargeZar: 3.68,
    balanceZar: 256.9
},
  notes: "Claude AI business tooling spend."
});
LET $tx_stmt_2025_07_18_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-07-17T00:00:00Z",
  description: "POS Purchase 20.00 Claude.Ai Sub                                                  485442*7050 16 Jul",
  normalizedDescription: "Claude",
  amount: 368.4,
  balance: 256.9,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Claude",
  merchant: $merchant_claude,
  category: $cat_ai_tools,
  isTransfer: false,
  manualOverride: false,
  notes: "Claude AI business tooling spend."
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_07_18_row_32.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_32.id, "TransactionMerchant", $merchant_claude.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_32.id, "TransactionCategory", $cat_ai_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-07-18T00:00:00Z",
  description: "POS Purchase 78.06 Paypal *Namec                                                  485442*7050 16 Jul",
  normalizedDescription: "Name.com",
  amount: 78.06,
  balance: 178.84,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 33,
    rawRowText: "POS Purchase 78.06 Paypal *Namec                                                  485442*7050 16 Jul; 78.06; 178.84 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Name.com",
    category: "Domains / hosting",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 78.06,
    bankChargeZar: 3.68,
    balanceZar: 178.84
},
  notes: "Domain-related payment on Name.com."
});
LET $tx_stmt_2025_07_18_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-07-18T00:00:00Z",
  description: "POS Purchase 78.06 Paypal *Namec                                                  485442*7050 16 Jul",
  normalizedDescription: "Name.com",
  amount: 78.06,
  balance: 178.84,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Name.com",
  merchant: $merchant_name_com,
  category: $cat_domains_hosting,
  isTransfer: false,
  manualOverride: false,
  notes: "Domain-related payment on Name.com."
});
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_07_18_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_33.id, "TransactionMerchant", $merchant_name_com.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_33.id, "TransactionCategory", $cat_domains_hosting.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-07-18T00:00:00Z",
  description: "0.00",
  normalizedDescription: "Bank Fee",
  amount: 10,
  balance: 178.84,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 34,
    rawRowText: "0.00; 178.84 Cr; 10.00",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 10,
    bankChargeZar: null,
    balanceZar: 178.84
},
  notes: "Inferred month-end FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_07_18_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-07-18T00:00:00Z",
  description: "0.00",
  normalizedDescription: "Bank Fee",
  amount: 10,
  balance: 178.84,
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
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_07_18_row_34.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_34.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_34.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2025-07-18T00:00:00Z",
  description: "93.00",
  normalizedDescription: "Bank Fee",
  amount: 93,
  balance: 85.84,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 35,
    rawRowText: "93.00; 85.84 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 93,
    bankChargeZar: null,
    balanceZar: 85.84
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_07_18_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-35",
  sourceRow: $row_row_35,
  postedAt: "2025-07-18T00:00:00Z",
  description: "93.00",
  normalizedDescription: "Bank Fee",
  amount: 93,
  balance: 85.84,
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
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_07_18_row_35.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_35.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_35.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2025-07-18T00:00:00Z",
  description: "126.88",
  normalizedDescription: "Bank Fee",
  amount: 126.88,
  balance: 41.04,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_81.pdf",
    statementPeriodStart: "2025-06-18",
    statementPeriodEnd: "2025-07-18",
    rowNo: 36,
    rawRowText: "126.88; 41.04",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 126.88,
    bankChargeZar: null,
    balanceZar: 41.04
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_07_18_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-18-row-36",
  sourceRow: $row_row_36,
  postedAt: "2025-07-18T00:00:00Z",
  description: "126.88",
  normalizedDescription: "Bank Fee",
  amount: 126.88,
  balance: 41.04,
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
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_07_18_row_36.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_07_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_36.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_18_row_36.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 36,
  normalizedCount: 36,
  clarificationCount: 0,
  status: "matched",
  statementDate: "2025-07-18T00:00:00Z",
  notes: "Imported from 2025-07-18.import.md"
});

-- End of generated import
