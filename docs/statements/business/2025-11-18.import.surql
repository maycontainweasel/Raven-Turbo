-- Generated from docs/statements/business/2025-11-18.import.md
-- Source: docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf

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
  notes: "Imported from GOLD_BUSINESS_ACCOUNT_85.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-11-18-fnb-gold-business-27821",
  sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-11-18T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_client_income = fn::createCategory({
  space: $space,
  key: "client-income",
  name: "Client income",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $cat_business_to_personal_transfer = fn::createCategory({
  space: $space,
  key: "business-to-personal-transfer",
  name: "Business to personal transfer",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $cat_ai_tools = fn::createCategory({
  space: $space,
  key: "ai-tools",
  name: "AI tools",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $cat_software_saas = fn::createCategory({
  space: $space,
  key: "software-saas",
  name: "Software / SaaS",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $cat_hosting_internet = fn::createCategory({
  space: $space,
  key: "hosting-internet",
  name: "Hosting / internet",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $cat_insurance = fn::createCategory({
  space: $space,
  key: "insurance",
  name: "Insurance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $cat_reversal_returned_debit = fn::createCategory({
  space: $space,
  key: "reversal-returned-debit",
  name: "Reversal / returned debit",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $cat_fees_card_charge = fn::createCategory({
  space: $space,
  key: "fees-card-charge",
  name: "Card Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $cat_fees_bank_fee = fn::createCategory({
  space: $space,
  key: "fees-bank-fee",
  name: "Bank Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});

-- Merchant records
LET $merchant_lucky_isibaya = fn::createMerchant({
  space: $space,
  key: "lucky-isibaya",
  name: "Lucky Isibaya",
  normalizedName: "Lucky Isibaya",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $merchant_michael_peters = fn::createMerchant({
  space: $space,
  key: "michael-peters",
  name: "Michael Peters",
  normalizedName: "Michael Peters",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $merchant_openai = fn::createMerchant({
  space: $space,
  key: "openai",
  name: "OpenAI",
  normalizedName: "OpenAI",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $merchant_cursor = fn::createMerchant({
  space: $space,
  key: "cursor",
  name: "Cursor",
  normalizedName: "Cursor",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $merchant_elitehost = fn::createMerchant({
  space: $space,
  key: "elitehost",
  name: "Elitehost",
  normalizedName: "Elitehost",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $merchant_sansor = fn::createMerchant({
  space: $space,
  key: "sansor",
  name: "Sansor",
  normalizedName: "Sansor",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $merchant_diamatrix = fn::createMerchant({
  space: $space,
  key: "diamatrix",
  name: "Diamatrix",
  normalizedName: "Diamatrix",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $merchant_outsurance = fn::createMerchant({
  space: $space,
  key: "outsurance",
  name: "Outsurance",
  normalizedName: "Outsurance",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $merchant_outsurance_reversal = fn::createMerchant({
  space: $space,
  key: "outsurance-reversal",
  name: "Outsurance Reversal",
  normalizedName: "Outsurance Reversal",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $merchant_fnb = fn::createMerchant({
  space: $space,
  key: "fnb",
  name: "FNB",
  normalizedName: "FNB",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});
LET $merchant_google_workspace = fn::createMerchant({
  space: $space,
  key: "google-workspace",
  name: "Google Workspace",
  normalizedName: "Google Workspace",
  active: true,
  notes: "Imported from 2025-11-18.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-10-20T00:00:00Z",
  description: "FNB App Payment From Lucky Isibaya1st Pay",
  normalizedDescription: "Lucky Isibaya",
  amount: 30000,
  balance: 29904.61,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 1,
    rawRowText: "FNB App Payment From Lucky Isibaya1st Pay; 30,000.00 Cr; 29,904.61 Cr",
    transactionType: "income",
    normalizedMerchant: "Lucky Isibaya",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 30000,
    bankChargeZar: null,
    balanceZar: 29904.61
},
  notes: "First part-payment of the R60k owed for the Lucky Isibaya stage work."
});
LET $tx_stmt_2025_11_18_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-10-20T00:00:00Z",
  description: "FNB App Payment From Lucky Isibaya1st Pay",
  normalizedDescription: "Lucky Isibaya",
  amount: 30000,
  balance: 29904.61,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Lucky Isibaya",
  merchant: $merchant_lucky_isibaya,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "First part-payment of the R60k owed for the Lucky Isibaya stage work."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_11_18_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_01.id, "TransactionMerchant", $merchant_lucky_isibaya.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_01.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-10-20T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 20000,
  balance: 9904.61,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 2,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 20,000.00; 9,904.61 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 20000,
    bankChargeZar: 15,
    balanceZar: 9904.61
},
  notes: "Express supplier payment from the business account into the personal current account."
});
LET $tx_stmt_2025_11_18_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-10-20T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 20000,
  balance: 9904.61,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Express supplier payment from the business account into the personal current account."
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_11_18_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_02.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_02.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-10-23T00:00:00Z",
  description: "POS Purchase 230.00 Openai *Chat                                                    485442*7050 22 Oct",
  normalizedDescription: "OpenAI",
  amount: 4120.11,
  balance: 5784.5,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 3,
    rawRowText: "POS Purchase 230.00 Openai *Chat                                                    485442*7050 22 Oct; 4,120.11; 5,784.50 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "OpenAI",
    category: "AI tools",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 4120.11,
    bankChargeZar: 3.68,
    balanceZar: 5784.5
},
  notes: "OpenAI / ChatGPT spend."
});
LET $tx_stmt_2025_11_18_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-10-23T00:00:00Z",
  description: "POS Purchase 230.00 Openai *Chat                                                    485442*7050 22 Oct",
  normalizedDescription: "OpenAI",
  amount: 4120.11,
  balance: 5784.5,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "OpenAI",
  merchant: $merchant_openai,
  category: $cat_ai_tools,
  isTransfer: false,
  manualOverride: false,
  notes: "OpenAI / ChatGPT spend."
});
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_11_18_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_03.id, "TransactionMerchant", $merchant_openai.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_03.id, "TransactionCategory", $cat_ai_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-10-25T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 23 Oct",
  normalizedDescription: "Cursor",
  amount: 358.76,
  balance: 5425.74,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 4,
    rawRowText: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 23 Oct; 358.76; 5,425.74 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Cursor",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 358.76,
    bankChargeZar: 3.68,
    balanceZar: 5425.74
},
  notes: "Cursor AI tooling spend."
});
LET $tx_stmt_2025_11_18_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-10-25T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 23 Oct",
  normalizedDescription: "Cursor",
  amount: 358.76,
  balance: 5425.74,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_11_18_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_04.id, "TransactionMerchant", $merchant_cursor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_04.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-10-28T00:00:00Z",
  description: "POS Purchase 57.43 Paypal *Elite                                                    485442*7050 25 Oct",
  normalizedDescription: "Elitehost",
  amount: 57.43,
  balance: 5368.31,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 5,
    rawRowText: "POS Purchase 57.43 Paypal *Elite                                                    485442*7050 25 Oct; 57.43; 5,368.31 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 57.43,
    bankChargeZar: 3.68,
    balanceZar: 5368.31
},
  notes: "Elitehost hosting payment; exact underlying hosted service can be broken down later."
});
LET $tx_stmt_2025_11_18_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-10-28T00:00:00Z",
  description: "POS Purchase 57.43 Paypal *Elite                                                    485442*7050 25 Oct",
  normalizedDescription: "Elitehost",
  amount: 57.43,
  balance: 5368.31,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Elitehost",
  merchant: $merchant_elitehost,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Elitehost hosting payment; exact underlying hosted service can be broken down later."
});
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_11_18_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_05.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_05.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-10-28T00:00:00Z",
  description: "POS Purchase 475.72 Paypal *Elit                                                    485442*7050 25 Oct",
  normalizedDescription: "Elitehost",
  amount: 475.72,
  balance: 4892.59,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 6,
    rawRowText: "POS Purchase 475.72 Paypal *Elit                                                    485442*7050 25 Oct; 475.72; 4,892.59 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 475.72,
    bankChargeZar: 3.68,
    balanceZar: 4892.59
},
  notes: "Elitehost reseller/shared-hosting payment; exact service split can be broken down later."
});
LET $tx_stmt_2025_11_18_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-10-28T00:00:00Z",
  description: "POS Purchase 475.72 Paypal *Elit                                                    485442*7050 25 Oct",
  normalizedDescription: "Elitehost",
  amount: 475.72,
  balance: 4892.59,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Elitehost",
  merchant: $merchant_elitehost,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Elitehost reseller/shared-hosting payment; exact service split can be broken down later."
});
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_11_18_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_06.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_06.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-10-29T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 4000,
  balance: 892.59,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 7,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 4,000.00; 892.59 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 4000,
    bankChargeZar: 15,
    balanceZar: 892.59
},
  notes: "Express supplier payment from the business account into the personal current account."
});
LET $tx_stmt_2025_11_18_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-10-29T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 4000,
  balance: 892.59,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Express supplier payment from the business account into the personal current account."
});
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_11_18_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_07.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_07.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-10-29T00:00:00Z",
  description: "6,850.00 Cr",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 7742.59,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 8,
    rawRowText: "6,850.00 Cr; 7,742.59 Cr",
    transactionType: "income",
    normalizedMerchant: "Sansor",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6850,
    bankChargeZar: null,
    balanceZar: 7742.59
},
  notes: "Sansor maintenance payment."
});
LET $tx_stmt_2025_11_18_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-10-29T00:00:00Z",
  description: "6,850.00 Cr",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 7742.59,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Sansor",
  merchant: $merchant_sansor,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Sansor maintenance payment."
});
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_11_18_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_08.id, "TransactionMerchant", $merchant_sansor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_08.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-10-29T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 5000,
  balance: 2742.59,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 9,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 5,000.00; 2,742.59 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 5000,
    bankChargeZar: 15,
    balanceZar: 2742.59
},
  notes: "Express supplier payment from the business account into the personal current account."
});
LET $tx_stmt_2025_11_18_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-10-29T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 5000,
  balance: 2742.59,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Express supplier payment from the business account into the personal current account."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_11_18_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_09.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_09.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-10-30T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1500,
  balance: 1242.59,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 10,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 1,500.00; 1,242.59 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1500,
    bankChargeZar: 8,
    balanceZar: 1242.59
},
  notes: "Express supplier payment from the business account into the personal current account."
});
LET $tx_stmt_2025_11_18_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-10-30T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1500,
  balance: 1242.59,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Express supplier payment from the business account into the personal current account."
});
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_11_18_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_10.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_10.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-10-31T00:00:00Z",
  description: "POS Purchase Diamatrix                                                              485442*7050 29 Oct",
  normalizedDescription: "Diamatrix",
  amount: 299,
  balance: 943.59,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 11,
    rawRowText: "POS Purchase Diamatrix                                                              485442*7050 29 Oct; 299.00; 943.59 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Diamatrix",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 299,
    bankChargeZar: 3.68,
    balanceZar: 943.59
},
  notes: "Hosting or software-service spend."
});
LET $tx_stmt_2025_11_18_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-10-31T00:00:00Z",
  description: "POS Purchase Diamatrix                                                              485442*7050 29 Oct",
  normalizedDescription: "Diamatrix",
  amount: 299,
  balance: 943.59,
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_11_18_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_11.id, "TransactionMerchant", $merchant_diamatrix.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_11.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-11-01T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Am9002",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 166.04,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 12,
    rawRowText: "Magtape Debit Outsurance Ot87677302 Am9002; 777.55; 166.04 Cr; 12.00",
    transactionType: "expense",
    normalizedMerchant: "Outsurance",
    category: "Insurance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 777.55,
    bankChargeZar: 12,
    balanceZar: 166.04
},
  notes: "Insurance debit."
});
LET $tx_stmt_2025_11_18_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-11-01T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Am9002",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 166.04,
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_11_18_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_12.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_12.id, "TransactionCategory", $cat_insurance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-11-04T00:00:00Z",
  description: "Magtape Unpaid                                                                      Not Provided For",
  normalizedDescription: "Outsurance Reversal",
  amount: 777.55,
  balance: 943.59,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 13,
    rawRowText: "Magtape Unpaid                                                                      Not Provided For; 777.55 Cr; 943.59 Cr",
    transactionType: "income",
    normalizedMerchant: "Outsurance Reversal",
    category: "Reversal / returned debit",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 777.55,
    bankChargeZar: null,
    balanceZar: 943.59
},
  notes: "Likely reversal of the failed Outsurance debit because the account could not cover it."
});
LET $tx_stmt_2025_11_18_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-11-04T00:00:00Z",
  description: "Magtape Unpaid                                                                      Not Provided For",
  normalizedDescription: "Outsurance Reversal",
  amount: 777.55,
  balance: 943.59,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Outsurance Reversal",
  merchant: $merchant_outsurance_reversal,
  category: $cat_reversal_returned_debit,
  isTransfer: false,
  manualOverride: false,
  notes: "Likely reversal of the failed Outsurance debit because the account could not cover it."
});
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_11_18_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_13.id, "TransactionMerchant", $merchant_outsurance_reversal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_13.id, "TransactionCategory", $cat_reversal_returned_debit.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-11-04T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 937.59,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 14,
    rawRowText: "6.00; 937.59 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 937.59
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-11-04T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 937.59,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_11_18_row_14.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_14.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_14.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_14 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-14",
  transaction: $tx_stmt_2025_11_18_row_14,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_14.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-11-04T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 931.59,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 15,
    rawRowText: "6.00; 931.59 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 931.59
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-11-04T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 931.59,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_11_18_row_15.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_15.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_15.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_15 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-15",
  transaction: $tx_stmt_2025_11_18_row_15,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_15.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-11-04T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 925.59,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 16,
    rawRowText: "6.00; 925.59 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 925.59
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-11-04T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 925.59,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_11_18_row_16.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_16.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_16.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_16 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-16",
  transaction: $tx_stmt_2025_11_18_row_16,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_16.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-11-04T00:00:00Z",
  description: "POS Purchase Diamatrix                                                              485442*7050 01 Nov",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 397.59,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 17,
    rawRowText: "POS Purchase Diamatrix                                                              485442*7050 01 Nov; 528.00; 397.59 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Diamatrix",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 528,
    bankChargeZar: 3.68,
    balanceZar: 397.59
},
  notes: "Hosting or software-service spend."
});
LET $tx_stmt_2025_11_18_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-11-04T00:00:00Z",
  description: "POS Purchase Diamatrix                                                              485442*7050 01 Nov",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 397.59,
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_11_18_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_17.id, "TransactionMerchant", $merchant_diamatrix.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_17.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-11-04T00:00:00Z",
  description: "POS Purchase 8.38 Google Gsuite_                                                    485442*7050 01 Nov",
  normalizedDescription: "Google Workspace",
  amount: 172.37,
  balance: 225.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 18,
    rawRowText: "POS Purchase 8.38 Google Gsuite_                                                    485442*7050 01 Nov; 172.37; 225.22 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Google Workspace",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 172.37,
    bankChargeZar: 3.68,
    balanceZar: 225.22
},
  notes: "Google Workspace for mpiredigital.co.za."
});
LET $tx_stmt_2025_11_18_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-11-04T00:00:00Z",
  description: "POS Purchase 8.38 Google Gsuite_                                                    485442*7050 01 Nov",
  normalizedDescription: "Google Workspace",
  amount: 172.37,
  balance: 225.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Google Workspace",
  merchant: $merchant_google_workspace,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Google Workspace for mpiredigital.co.za."
});
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_11_18_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_18.id, "TransactionMerchant", $merchant_google_workspace.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_18.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-11-05T00:00:00Z",
  description: "155.00",
  normalizedDescription: "Bank Fee",
  amount: 155,
  balance: 70.22,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 19,
    rawRowText: "155.00; 70.22 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 155,
    bankChargeZar: null,
    balanceZar: 70.22
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-11-05T00:00:00Z",
  description: "155.00",
  normalizedDescription: "Bank Fee",
  amount: 155,
  balance: 70.22,
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
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_11_18_row_19.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_19.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_19.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_19 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-19",
  transaction: $tx_stmt_2025_11_18_row_19,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_19.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-11-05T00:00:00Z",
  description: "1.29",
  normalizedDescription: "Bank Fee",
  amount: 1.29,
  balance: 68.93,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 20,
    rawRowText: "1.29; 68.93 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 1.29,
    bankChargeZar: null,
    balanceZar: 68.93
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-11-05T00:00:00Z",
  description: "1.29",
  normalizedDescription: "Bank Fee",
  amount: 1.29,
  balance: 68.93,
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
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_11_18_row_20.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_20.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_20.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_20 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-20",
  transaction: $tx_stmt_2025_11_18_row_20,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_20.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-11-05T00:00:00Z",
  description: "10.70",
  normalizedDescription: "Bank Fee",
  amount: 10.7,
  balance: 58.23,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 21,
    rawRowText: "10.70; 58.23 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 10.7,
    bankChargeZar: null,
    balanceZar: 58.23
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-11-05T00:00:00Z",
  description: "10.70",
  normalizedDescription: "Bank Fee",
  amount: 10.7,
  balance: 58.23,
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
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_11_18_row_21.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_21.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_21.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_21 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-21",
  transaction: $tx_stmt_2025_11_18_row_21,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_21.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-11-05T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 52.23,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 22,
    rawRowText: "6.00; 52.23 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 52.23
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-11-05T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 52.23,
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
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_11_18_row_22.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_22.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_22.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_22 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-22",
  transaction: $tx_stmt_2025_11_18_row_22,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_22.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-11-06T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 46.23,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 23,
    rawRowText: "6.00; 46.23 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 46.23
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-11-06T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 46.23,
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_11_18_row_23.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_23.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_23.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_23 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-23",
  transaction: $tx_stmt_2025_11_18_row_23,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_23.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-11-07T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 40.23,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 24,
    rawRowText: "6.00; 40.23 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 40.23
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-11-07T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 40.23,
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
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_11_18_row_24.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_24.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_24.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_24 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-24",
  transaction: $tx_stmt_2025_11_18_row_24,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_24.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-11-07T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 34.23,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 25,
    rawRowText: "6.00; 34.23 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 34.23
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-11-07T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 34.23,
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
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_11_18_row_25.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_25.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_25.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_25 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-25",
  transaction: $tx_stmt_2025_11_18_row_25,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_25.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-11-10T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 28.23,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 26,
    rawRowText: "6.00; 28.23 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 28.23
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-11-10T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 28.23,
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
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_11_18_row_26.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_26.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_26.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_26 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-26",
  transaction: $tx_stmt_2025_11_18_row_26,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_26.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-11-10T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 22.23,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 27,
    rawRowText: "6.00; 22.23 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 22.23
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-11-10T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 22.23,
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
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_11_18_row_27.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_27.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_27.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_27 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-27",
  transaction: $tx_stmt_2025_11_18_row_27,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_27.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-11-11T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 16.23,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 28,
    rawRowText: "6.00; 16.23 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 16.23
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-11-11T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 16.23,
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
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_11_18_row_28.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_28.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_28.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_28 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-28",
  transaction: $tx_stmt_2025_11_18_row_28,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_28.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-11-11T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 10.23,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 29,
    rawRowText: "6.00; 10.23 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 10.23
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-11-11T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 10.23,
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
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_11_18_row_29.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_29.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_29.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_29 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-29",
  transaction: $tx_stmt_2025_11_18_row_29,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_29.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-11-15T00:00:00Z",
  description: "FNB App Payment From Lucky Isibayastage3",
  normalizedDescription: "Lucky Isibaya",
  amount: 60000,
  balance: 60010.23,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 30,
    rawRowText: "FNB App Payment From Lucky Isibayastage3; 60,000.00 Cr; 60,010.23 Cr",
    transactionType: "income",
    normalizedMerchant: "Lucky Isibaya",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 60000,
    bankChargeZar: null,
    balanceZar: 60010.23
},
  notes: "Stage 3 payment from Lucky Isibaya."
});
LET $tx_stmt_2025_11_18_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-11-15T00:00:00Z",
  description: "FNB App Payment From Lucky Isibayastage3",
  normalizedDescription: "Lucky Isibaya",
  amount: 60000,
  balance: 60010.23,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Lucky Isibaya",
  merchant: $merchant_lucky_isibaya,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Stage 3 payment from Lucky Isibaya."
});
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_11_18_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_30.id, "TransactionMerchant", $merchant_lucky_isibaya.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_30.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-11-15T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 50000,
  balance: 10010.23,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 31,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 50,000.00; 10,010.23 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 50000,
    bankChargeZar: 15,
    balanceZar: 10010.23
},
  notes: "Express supplier payment from the business account into the personal current account."
});
LET $tx_stmt_2025_11_18_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-11-15T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 50000,
  balance: 10010.23,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Express supplier payment from the business account into the personal current account."
});
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_11_18_row_31.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_31.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_31.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-11-15T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 10004.23,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 32,
    rawRowText: "6.00; 10,004.23 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 10004.23
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-11-15T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 10004.23,
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
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_11_18_row_32.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_32.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_32.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_32 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-32",
  transaction: $tx_stmt_2025_11_18_row_32,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_32.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-11-15T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 9998.23,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 33,
    rawRowText: "6.00; 9,998.23 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 9998.23
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-11-15T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 9998.23,
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
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_11_18_row_33.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_33.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_33.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_33 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-33",
  transaction: $tx_stmt_2025_11_18_row_33,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_33.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-11-17T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Cb5115",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 9220.68,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 34,
    rawRowText: "Magtape Debit Outsurance Ot87677302 Cb5115; 777.55; 9,220.68 Cr; 12.00",
    transactionType: "expense",
    normalizedMerchant: "Outsurance",
    category: "Insurance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 777.55,
    bankChargeZar: 12,
    balanceZar: 9220.68
},
  notes: "Insurance debit."
});
LET $tx_stmt_2025_11_18_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-11-17T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Cb5115",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 9220.68,
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
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_11_18_row_34.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_34.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_34.id, "TransactionCategory", $cat_insurance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2025-11-18T00:00:00Z",
  description: "93.00",
  normalizedDescription: "Bank Fee",
  amount: 93,
  balance: 9127.68,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 35,
    rawRowText: "93.00; 9,127.68 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 93,
    bankChargeZar: null,
    balanceZar: 9127.68
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-35",
  sourceRow: $row_row_35,
  postedAt: "2025-11-18T00:00:00Z",
  description: "93.00",
  normalizedDescription: "Bank Fee",
  amount: 93,
  balance: 9127.68,
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
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_11_18_row_35.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_35.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_35.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_35 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-35",
  transaction: $tx_stmt_2025_11_18_row_35,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_35.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2025-11-18T00:00:00Z",
  description: "117.76",
  normalizedDescription: "Bank Fee",
  amount: 117.76,
  balance: 9009.92,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_85.pdf",
    statementPeriodStart: "2025-10-18",
    statementPeriodEnd: "2025-11-18",
    rowNo: 36,
    rawRowText: "117.76; 9,009.92 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 117.76,
    bankChargeZar: null,
    balanceZar: 9009.92
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_11_18_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-18-row-36",
  sourceRow: $row_row_36,
  postedAt: "2025-11-18T00:00:00Z",
  description: "117.76",
  normalizedDescription: "Bank Fee",
  amount: 117.76,
  balance: 9009.92,
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
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_11_18_row_36.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_11_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_36.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_18_row_36.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_18_row_36 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-18-row-36",
  transaction: $tx_stmt_2025_11_18_row_36,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-11-18.import.md"
});
fn::createEdge($tx_stmt_2025_11_18_row_36.id, "TransactionClarificationTasks", $task_stmt_2025_11_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 36,
  normalizedCount: 36,
  clarificationCount: 18,
  status: "matched",
  statementDate: "2025-11-18T00:00:00Z",
  notes: "Imported from 2025-11-18.import.md"
});

-- End of generated import
