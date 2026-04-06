-- Generated from docs/statements/business/2025-09-18.import.md
-- Source: docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf

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
  notes: "Imported from GOLD_BUSINESS_ACCOUNT_83.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-09-18-fnb-gold-business-27821",
  sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-09-18T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-09-18.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_client_income = fn::createCategory({
  space: $space,
  key: "client-income",
  name: "Client income",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $cat_business_to_personal_transfer = fn::createCategory({
  space: $space,
  key: "business-to-personal-transfer",
  name: "Business to personal transfer",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $cat_contractor_design = fn::createCategory({
  space: $space,
  key: "contractor-design",
  name: "Contractor / design",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $cat_ai_tools = fn::createCategory({
  space: $space,
  key: "ai-tools",
  name: "AI tools",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $cat_software_saas = fn::createCategory({
  space: $space,
  key: "software-saas",
  name: "Software / SaaS",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $cat_hosting_internet = fn::createCategory({
  space: $space,
  key: "hosting-internet",
  name: "Hosting / internet",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $cat_internet_connectivity = fn::createCategory({
  space: $space,
  key: "internet-connectivity",
  name: "Internet / connectivity",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $cat_insurance = fn::createCategory({
  space: $space,
  key: "insurance",
  name: "Insurance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $cat_fees_bank_fee = fn::createCategory({
  space: $space,
  key: "fees-bank-fee",
  name: "Bank Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $cat_fees_card_charge = fn::createCategory({
  space: $space,
  key: "fees-card-charge",
  name: "Card Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $cat_fees_debit_interest = fn::createCategory({
  space: $space,
  key: "fees-debit-interest",
  name: "Debit Interest",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});

-- Merchant records
LET $merchant_lucky_isibaya = fn::createMerchant({
  space: $space,
  key: "lucky-isibaya",
  name: "Lucky Isibaya",
  normalizedName: "Lucky Isibaya",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_michael_peters = fn::createMerchant({
  space: $space,
  key: "michael-peters",
  name: "Michael Peters",
  normalizedName: "Michael Peters",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_fnb = fn::createMerchant({
  space: $space,
  key: "fnb",
  name: "FNB",
  normalizedName: "FNB",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_nectar_design = fn::createMerchant({
  space: $space,
  key: "nectar-design",
  name: "Nectar Design",
  normalizedName: "Nectar Design",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_claude = fn::createMerchant({
  space: $space,
  key: "claude",
  name: "Claude",
  normalizedName: "Claude",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_sansor = fn::createMerchant({
  space: $space,
  key: "sansor",
  name: "Sansor",
  normalizedName: "Sansor",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_cursor = fn::createMerchant({
  space: $space,
  key: "cursor",
  name: "Cursor",
  normalizedName: "Cursor",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_diamatrix = fn::createMerchant({
  space: $space,
  key: "diamatrix",
  name: "Diamatrix",
  normalizedName: "Diamatrix",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_vdv_internet = fn::createMerchant({
  space: $space,
  key: "vdv-internet",
  name: "VDV Internet",
  normalizedName: "VDV Internet",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_openai = fn::createMerchant({
  space: $space,
  key: "openai",
  name: "OpenAI",
  normalizedName: "OpenAI",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_outsurance = fn::createMerchant({
  space: $space,
  key: "outsurance",
  name: "Outsurance",
  normalizedName: "Outsurance",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_google_workspace = fn::createMerchant({
  space: $space,
  key: "google-workspace",
  name: "Google Workspace",
  normalizedName: "Google Workspace",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_true_fit = fn::createMerchant({
  space: $space,
  key: "true-fit",
  name: "True Fit",
  normalizedName: "True Fit",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_notion = fn::createMerchant({
  space: $space,
  key: "notion",
  name: "Notion",
  normalizedName: "Notion",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_atlassian = fn::createMerchant({
  space: $space,
  key: "atlassian",
  name: "Atlassian",
  normalizedName: "Atlassian",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_vecteezy = fn::createMerchant({
  space: $space,
  key: "vecteezy",
  name: "Vecteezy",
  normalizedName: "Vecteezy",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});
LET $merchant_elitehost = fn::createMerchant({
  space: $space,
  key: "elitehost",
  name: "Elitehost",
  normalizedName: "Elitehost",
  active: true,
  notes: "Imported from 2025-09-18.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-08-23T00:00:00Z",
  description: "FNB App Payment From Lucky Isibaya1st Pay",
  normalizedDescription: "Lucky Isibaya",
  amount: 70000,
  balance: 69910.35,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 1,
    rawRowText: "FNB App Payment From Lucky Isibaya1st Pay; 70,000.00 Cr; 69,910.35 Cr",
    transactionType: "income",
    normalizedMerchant: "Lucky Isibaya",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 70000,
    bankChargeZar: null,
    balanceZar: 69910.35
},
  notes: "Lucky Isibaya project income; stage label still needs later detail, but the inflow meaning is clear."
});
LET $tx_stmt_2025_09_18_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-08-23T00:00:00Z",
  description: "FNB App Payment From Lucky Isibaya1st Pay",
  normalizedDescription: "Lucky Isibaya",
  amount: 70000,
  balance: 69910.35,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Lucky Isibaya",
  merchant: $merchant_lucky_isibaya,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Lucky Isibaya project income; stage label still needs later detail, but the inflow meaning is clear."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_09_18_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_01.id, "TransactionMerchant", $merchant_lucky_isibaya.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_01.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-08-23T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 50000,
  balance: 19910.35,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 2,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market; 50,000.00; 19,910.35 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 50000,
    bankChargeZar: 15,
    balanceZar: 19910.35
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_09_18_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-08-23T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 50000,
  balance: 19910.35,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_09_18_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_02.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_02.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-08-23T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 19904.35,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 3,
    rawRowText: "6.00; 19,904.35 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 19904.35
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_09_18_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-08-23T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 19904.35,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_09_18_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_03.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_03.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-08-25T00:00:00Z",
  description: "Internet Pmt To Nectar Design Stage                                                Mpire Digital:Esta V",
  normalizedDescription: "Nectar Design",
  amount: 5000,
  balance: 14904.35,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 4,
    rawRowText: "Internet Pmt To Nectar Design Stage                                                Mpire Digital:Esta V; 5,000.00; 14,904.35 Cr",
    transactionType: "expense",
    normalizedMerchant: "Nectar Design",
    category: "Contractor / design",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 5000,
    bankChargeZar: null,
    balanceZar: 14904.35
},
  notes: "Payment out for design work to Nectar Design."
});
LET $tx_stmt_2025_09_18_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-08-25T00:00:00Z",
  description: "Internet Pmt To Nectar Design Stage                                                Mpire Digital:Esta V",
  normalizedDescription: "Nectar Design",
  amount: 5000,
  balance: 14904.35,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nectar Design",
  merchant: $merchant_nectar_design,
  category: $cat_contractor_design,
  isTransfer: false,
  manualOverride: false,
  notes: "Payment out for design work to Nectar Design."
});
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_09_18_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_04.id, "TransactionMerchant", $merchant_nectar_design.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_04.id, "TransactionCategory", $cat_contractor_design.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-08-26T00:00:00Z",
  description: "POS Purchase 100.00 Claude.Ai Su                                                   485442*7050 23 Aug",
  normalizedDescription: "Claude",
  amount: 1820.98,
  balance: 13083.37,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 5,
    rawRowText: "POS Purchase 100.00 Claude.Ai Su                                                   485442*7050 23 Aug; 1,820.98; 13,083.37 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Claude",
    category: "AI tools",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 1820.98,
    bankChargeZar: 3.68,
    balanceZar: 13083.37
},
  notes: "Claude AI business tooling spend."
});
LET $tx_stmt_2025_09_18_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-08-26T00:00:00Z",
  description: "POS Purchase 100.00 Claude.Ai Su                                                   485442*7050 23 Aug",
  normalizedDescription: "Claude",
  amount: 1820.98,
  balance: 13083.37,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_09_18_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_05.id, "TransactionMerchant", $merchant_claude.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_05.id, "TransactionCategory", $cat_ai_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-08-26T00:00:00Z",
  description: "POS Purchase 100.12 Claude.Ai Su                                                   485442*7050 23 Aug",
  normalizedDescription: "Claude",
  amount: 1823.17,
  balance: 11260.2,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 6,
    rawRowText: "POS Purchase 100.12 Claude.Ai Su                                                   485442*7050 23 Aug; 1,823.17; 11,260.20 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Claude",
    category: "AI tools",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 1823.17,
    bankChargeZar: 3.68,
    balanceZar: 11260.2
},
  notes: "Claude AI business tooling spend."
});
LET $tx_stmt_2025_09_18_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-08-26T00:00:00Z",
  description: "POS Purchase 100.12 Claude.Ai Su                                                   485442*7050 23 Aug",
  normalizedDescription: "Claude",
  amount: 1823.17,
  balance: 11260.2,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_09_18_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_06.id, "TransactionMerchant", $merchant_claude.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_06.id, "TransactionCategory", $cat_ai_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-08-27T00:00:00Z",
  description: "FNB OB Pmt Sansor",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 18110.2,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 7,
    rawRowText: "FNB OB Pmt Sansor; 6,850.00 Cr; 18,110.20 Cr",
    transactionType: "income",
    normalizedMerchant: "Sansor",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6850,
    bankChargeZar: null,
    balanceZar: 18110.2
},
  notes: "Recurring client payment from Sansor."
});
LET $tx_stmt_2025_09_18_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-08-27T00:00:00Z",
  description: "FNB OB Pmt Sansor",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 18110.2,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_09_18_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_07.id, "TransactionMerchant", $merchant_sansor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_07.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-08-27T00:00:00Z",
  description: "POS Purchase 364.66 Cursor, Ai P                                                   485442*7050 25 Aug",
  normalizedDescription: "Cursor",
  amount: 364.66,
  balance: 17745.54,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 8,
    rawRowText: "POS Purchase 364.66 Cursor, Ai P                                                   485442*7050 25 Aug; 364.66; 17,745.54 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Cursor",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 364.66,
    bankChargeZar: 3.68,
    balanceZar: 17745.54
},
  notes: "Cursor AI tooling spend."
});
LET $tx_stmt_2025_09_18_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-08-27T00:00:00Z",
  description: "POS Purchase 364.66 Cursor, Ai P                                                   485442*7050 25 Aug",
  normalizedDescription: "Cursor",
  amount: 364.66,
  balance: 17745.54,
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_09_18_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_08.id, "TransactionMerchant", $merchant_cursor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_08.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-08-28T00:00:00Z",
  description: "POS Purchase Diamatrix                                                             485442*7050 25 Aug",
  normalizedDescription: "Diamatrix",
  amount: 99,
  balance: 17646.54,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 9,
    rawRowText: "POS Purchase Diamatrix                                                             485442*7050 25 Aug; 99.00; 17,646.54 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Diamatrix",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 99,
    bankChargeZar: 3.68,
    balanceZar: 17646.54
},
  notes: "Hosting or software-service spend."
});
LET $tx_stmt_2025_09_18_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-08-28T00:00:00Z",
  description: "POS Purchase Diamatrix                                                             485442*7050 25 Aug",
  normalizedDescription: "Diamatrix",
  amount: 99,
  balance: 17646.54,
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_09_18_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_09.id, "TransactionMerchant", $merchant_diamatrix.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_09.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-08-28T00:00:00Z",
  description: "POS Purchase Diamatrix                                                             485442*7050 25 Aug",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 17118.54,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 10,
    rawRowText: "POS Purchase Diamatrix                                                             485442*7050 25 Aug; 528.00; 17,118.54 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Diamatrix",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 528,
    bankChargeZar: 3.68,
    balanceZar: 17118.54
},
  notes: "Hosting or software-service spend."
});
LET $tx_stmt_2025_09_18_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-08-28T00:00:00Z",
  description: "POS Purchase Diamatrix                                                             485442*7050 25 Aug",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 17118.54,
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_09_18_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_10.id, "TransactionMerchant", $merchant_diamatrix.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_10.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-08-29T00:00:00Z",
  description: "Internet Pmt To Vdv Internet                                                       Mic00017",
  normalizedDescription: "VDV Internet",
  amount: 849,
  balance: 16269.54,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 11,
    rawRowText: "Internet Pmt To Vdv Internet                                                       Mic00017; 849.00; 16,269.54 Cr",
    transactionType: "expense",
    normalizedMerchant: "VDV Internet",
    category: "Internet / connectivity",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 849,
    bankChargeZar: null,
    balanceZar: 16269.54
},
  notes: "Monthly business internet bill."
});
LET $tx_stmt_2025_09_18_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-08-29T00:00:00Z",
  description: "Internet Pmt To Vdv Internet                                                       Mic00017",
  normalizedDescription: "VDV Internet",
  amount: 849,
  balance: 16269.54,
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_09_18_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_11.id, "TransactionMerchant", $merchant_vdv_internet.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_11.id, "TransactionCategory", $cat_internet_connectivity.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-08-29T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 10000,
  balance: 6269.54,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 12,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market; 10,000.00; 6,269.54 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 10000,
    bankChargeZar: 15,
    balanceZar: 6269.54
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_09_18_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-08-29T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 10000,
  balance: 6269.54,
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_09_18_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_12.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_12.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-08-30T00:00:00Z",
  description: "POS Purchase 23.00 Openai *Chatg                                                   485442*7050 28 Aug",
  normalizedDescription: "OpenAI",
  amount: 419.55,
  balance: 5849.99,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 13,
    rawRowText: "POS Purchase 23.00 Openai *Chatg                                                   485442*7050 28 Aug; 419.55; 5,849.99 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "OpenAI",
    category: "AI tools",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 419.55,
    bankChargeZar: 3.68,
    balanceZar: 5849.99
},
  notes: "OpenAI business tooling spend."
});
LET $tx_stmt_2025_09_18_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-08-30T00:00:00Z",
  description: "POS Purchase 23.00 Openai *Chatg                                                   485442*7050 28 Aug",
  normalizedDescription: "OpenAI",
  amount: 419.55,
  balance: 5849.99,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_09_18_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_13.id, "TransactionMerchant", $merchant_openai.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_13.id, "TransactionCategory", $cat_ai_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-09-01T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 B96315",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 5072.44,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 14,
    rawRowText: "Magtape Debit Outsurance Ot87677302 B96315; 777.55; 5,072.44 Cr; 12.00",
    transactionType: "expense",
    normalizedMerchant: "Outsurance",
    category: "Insurance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 777.55,
    bankChargeZar: 12,
    balanceZar: 5072.44
},
  notes: "Insurance debit."
});
LET $tx_stmt_2025_09_18_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-09-01T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 B96315",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 5072.44,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_09_18_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_14.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_14.id, "TransactionCategory", $cat_insurance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-09-02T00:00:00Z",
  description: "8.20",
  normalizedDescription: "Bank Fee",
  amount: 8.2,
  balance: 5064.24,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 15,
    rawRowText: "8.20; 5,064.24 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 8.2,
    bankChargeZar: null,
    balanceZar: 5064.24
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_09_18_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-09-02T00:00:00Z",
  description: "8.20",
  normalizedDescription: "Bank Fee",
  amount: 8.2,
  balance: 5064.24,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_09_18_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_15.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_15.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-09-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2500,
  balance: 2564.24,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 16,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market; 2,500.00; 2,564.24 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2500,
    bankChargeZar: 8,
    balanceZar: 2564.24
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_09_18_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-09-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2500,
  balance: 2564.24,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_09_18_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_16.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_16.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-09-03T00:00:00Z",
  description: "POS Purchase 8.38 Google Gsuite_                                                   485442*7050 01 Sep",
  normalizedDescription: "Google Workspace",
  amount: 178.4,
  balance: 2385.84,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 17,
    rawRowText: "POS Purchase 8.38 Google Gsuite_                                                   485442*7050 01 Sep; 178.40; 2,385.84 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Google Workspace",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 178.4,
    bankChargeZar: 3.68,
    balanceZar: 2385.84
},
  notes: "Google Workspace subscription spend."
});
LET $tx_stmt_2025_09_18_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-09-03T00:00:00Z",
  description: "POS Purchase 8.38 Google Gsuite_                                                   485442*7050 01 Sep",
  normalizedDescription: "Google Workspace",
  amount: 178.4,
  balance: 2385.84,
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_09_18_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_17.id, "TransactionMerchant", $merchant_google_workspace.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_17.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-09-05T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "True Fit",
  amount: 1000,
  balance: 3385.84,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 18,
    rawRowText: "Magtape Credit 127167 True Fit; 1,000.00 Cr; 3,385.84 Cr",
    transactionType: "income",
    normalizedMerchant: "True Fit",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: 3385.84
},
  notes: "True Fit maintenance payment income."
});
LET $tx_stmt_2025_09_18_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-09-05T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "True Fit",
  amount: 1000,
  balance: 3385.84,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "True Fit",
  merchant: $merchant_true_fit,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "True Fit maintenance payment income."
});
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_09_18_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_18.id, "TransactionMerchant", $merchant_true_fit.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_18.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-09-05T00:00:00Z",
  description: "POS Purchase 13.80 Notion Labs,                                                    485442*7050 04 Sep",
  normalizedDescription: "Notion",
  amount: 251.49,
  balance: 3134.35,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 19,
    rawRowText: "POS Purchase 13.80 Notion Labs,                                                    485442*7050 04 Sep; 251.49; 3,134.35 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Notion",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 251.49,
    bankChargeZar: 3.68,
    balanceZar: 3134.35
},
  notes: "Notion subscription spend."
});
LET $tx_stmt_2025_09_18_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-09-05T00:00:00Z",
  description: "POS Purchase 13.80 Notion Labs,                                                    485442*7050 04 Sep",
  normalizedDescription: "Notion",
  amount: 251.49,
  balance: 3134.35,
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
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_09_18_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_19.id, "TransactionMerchant", $merchant_notion.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_19.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-09-06T00:00:00Z",
  description: "POS Purchase 18.98 Atlassian                                                       485442*7050 05 Sep",
  normalizedDescription: "Atlassian",
  amount: 346.89,
  balance: 2787.46,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 20,
    rawRowText: "POS Purchase 18.98 Atlassian                                                       485442*7050 05 Sep; 346.89; 2,787.46 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Atlassian",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 346.89,
    bankChargeZar: 3.68,
    balanceZar: 2787.46
},
  notes: "Atlassian subscription spend."
});
LET $tx_stmt_2025_09_18_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-09-06T00:00:00Z",
  description: "POS Purchase 18.98 Atlassian                                                       485442*7050 05 Sep",
  normalizedDescription: "Atlassian",
  amount: 346.89,
  balance: 2787.46,
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
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_09_18_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_20.id, "TransactionMerchant", $merchant_atlassian.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_20.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-09-08T00:00:00Z",
  description: "POS Purchase 129.65 Paypal *Vect                                                   485442*7050 04 Sep",
  normalizedDescription: "Vecteezy",
  amount: 129.65,
  balance: 2657.81,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 21,
    rawRowText: "POS Purchase 129.65 Paypal *Vect                                                   485442*7050 04 Sep; 129.65; 2,657.81 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Vecteezy",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 129.65,
    bankChargeZar: 3.68,
    balanceZar: 2657.81
},
  notes: "Vecteezy stock image and video subscription."
});
LET $tx_stmt_2025_09_18_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-09-08T00:00:00Z",
  description: "POS Purchase 129.65 Paypal *Vect                                                   485442*7050 04 Sep",
  normalizedDescription: "Vecteezy",
  amount: 129.65,
  balance: 2657.81,
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
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_09_18_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_21.id, "TransactionMerchant", $merchant_vecteezy.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_21.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-09-11T00:00:00Z",
  description: "FNB App Payment From Lucky Isibaya1st Pay",
  normalizedDescription: "Lucky Isibaya",
  amount: 1470,
  balance: 4127.81,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 22,
    rawRowText: "FNB App Payment From Lucky Isibaya1st Pay; 1,470.00 Cr; 4,127.81 Cr",
    transactionType: "income",
    normalizedMerchant: "Lucky Isibaya",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1470,
    bankChargeZar: null,
    balanceZar: 4127.81
},
  notes: "Lucky Isibaya hosting payment income."
});
LET $tx_stmt_2025_09_18_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-09-11T00:00:00Z",
  description: "FNB App Payment From Lucky Isibaya1st Pay",
  normalizedDescription: "Lucky Isibaya",
  amount: 1470,
  balance: 4127.81,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Lucky Isibaya",
  merchant: $merchant_lucky_isibaya,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Lucky Isibaya hosting payment income."
});
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_09_18_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_22.id, "TransactionMerchant", $merchant_lucky_isibaya.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_22.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-09-12T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2000,
  balance: 2127.81,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 23,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market; 2,000.00; 2,127.81 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: 8,
    balanceZar: 2127.81
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_09_18_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-09-12T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2000,
  balance: 2127.81,
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_09_18_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_23.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_23.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-09-15T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1000,
  balance: 1127.81,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 24,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market; 1,000.00; 1,127.81 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: 8,
    balanceZar: 1127.81
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_09_18_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-09-15T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1000,
  balance: 1127.81,
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
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_09_18_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_24.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_24.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-09-16T00:00:00Z",
  description: "POS Purchase 57.37 Paypal *Elite                                                   485442*7050 13 Sep",
  normalizedDescription: "Elitehost",
  amount: 57.37,
  balance: 1070.44,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 25,
    rawRowText: "POS Purchase 57.37 Paypal *Elite                                                   485442*7050 13 Sep; 57.37; 1,070.44 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 57.37,
    bankChargeZar: 3.68,
    balanceZar: 1070.44
},
  notes: "Elitehost hosting payment."
});
LET $tx_stmt_2025_09_18_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-09-16T00:00:00Z",
  description: "POS Purchase 57.37 Paypal *Elite                                                   485442*7050 13 Sep",
  normalizedDescription: "Elitehost",
  amount: 57.37,
  balance: 1070.44,
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
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_09_18_row_25.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_25.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_25.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-09-17T00:00:00Z",
  description: "2.92",
  normalizedDescription: "Bank Fee",
  amount: 2.92,
  balance: 1067.52,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 26,
    rawRowText: "2.92; 1,067.52 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 2.92,
    bankChargeZar: null,
    balanceZar: 1067.52
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_09_18_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-09-17T00:00:00Z",
  description: "2.92",
  normalizedDescription: "Bank Fee",
  amount: 2.92,
  balance: 1067.52,
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
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_09_18_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_26.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_26.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-09-17T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 1061.52,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 27,
    rawRowText: "6.00; 1,061.52 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 1061.52
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_09_18_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-09-17T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 1061.52,
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
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_09_18_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_27.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_27.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-09-18T00:00:00Z",
  description: "Int On Debit Balance",
  normalizedDescription: "Debit Interest",
  amount: 0.23,
  balance: 1061.29,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 28,
    rawRowText: "Int On Debit Balance; 0.23; 1,061.29 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "debit interest",
    clarificationStatus: "clarified",
    amountZar: 0.23,
    bankChargeZar: null,
    balanceZar: 1061.29
},
  notes: "Interest on debit balance."
});
LET $tx_stmt_2025_09_18_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-09-18T00:00:00Z",
  description: "Int On Debit Balance",
  normalizedDescription: "Debit Interest",
  amount: 0.23,
  balance: 1061.29,
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
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_09_18_row_28.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_28.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_28.id, "TransactionCategory", $cat_fees_debit_interest.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-09-18T00:00:00Z",
  description: "0.00",
  normalizedDescription: "Bank Fee",
  amount: 10,
  balance: 1061.29,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 29,
    rawRowText: "0.00; 1,061.29 Cr; 10.00",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 10,
    bankChargeZar: null,
    balanceZar: 1061.29
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_09_18_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-09-18T00:00:00Z",
  description: "0.00",
  normalizedDescription: "Bank Fee",
  amount: 10,
  balance: 1061.29,
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
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_09_18_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_29.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_29.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-09-18T00:00:00Z",
  description: "93.00",
  normalizedDescription: "Bank Fee",
  amount: 93,
  balance: 968.29,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 30,
    rawRowText: "93.00; 968.29 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 93,
    bankChargeZar: null,
    balanceZar: 968.29
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_09_18_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-09-18T00:00:00Z",
  description: "93.00",
  normalizedDescription: "Bank Fee",
  amount: 93,
  balance: 968.29,
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
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_09_18_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_30.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_30.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-09-18T00:00:00Z",
  description: "116.48",
  normalizedDescription: "Bank Fee",
  amount: 116.48,
  balance: 851.81,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_83.pdf",
    statementPeriodStart: "2025-08-18",
    statementPeriodEnd: "2025-09-18",
    rowNo: 31,
    rawRowText: "116.48; 851.81 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 116.48,
    bankChargeZar: null,
    balanceZar: 851.81
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_09_18_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-18-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-09-18T00:00:00Z",
  description: "116.48",
  normalizedDescription: "Bank Fee",
  amount: 116.48,
  balance: 851.81,
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
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_09_18_row_31.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_09_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_31.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_18_row_31.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 31,
  normalizedCount: 31,
  clarificationCount: 0,
  status: "matched",
  statementDate: "2025-09-18T00:00:00Z",
  notes: "Imported from 2025-09-18.import.md"
});

-- End of generated import
