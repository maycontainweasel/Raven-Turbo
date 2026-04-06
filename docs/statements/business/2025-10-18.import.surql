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
LET $cat_hosting_internet = fn::createCategory({
  space: $space,
  key: "hosting-internet",
  name: "Hosting / internet",
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
LET $cat_utilities_internet = fn::createCategory({
  space: $space,
  key: "utilities-internet",
  name: "Utilities / internet",
  categoryKind: "expense",
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
LET $cat_business_to_personal_transfer = fn::createCategory({
  space: $space,
  key: "business-to-personal-transfer",
  name: "Business to personal transfer",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $cat_software_saas = fn::createCategory({
  space: $space,
  key: "software-saas",
  name: "Software / SaaS",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $cat_design_media_assets = fn::createCategory({
  space: $space,
  key: "design-media-assets",
  name: "Design / media assets",
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
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
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
LET $cat_fees_electronic_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-electronic-payment-fee",
  name: "Electronic Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});

-- Merchant records
LET $merchant_elitehost = fn::createMerchant({
  space: $space,
  key: "elitehost",
  name: "Elitehost",
  normalizedName: "Elitehost",
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
LET $merchant_vdv_internet = fn::createMerchant({
  space: $space,
  key: "vdv-internet",
  name: "VDV Internet",
  normalizedName: "VDV Internet",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_truefit = fn::createMerchant({
  space: $space,
  key: "truefit",
  name: "TrueFit",
  normalizedName: "TrueFit",
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
LET $merchant_passmed_pte_ltd = fn::createMerchant({
  space: $space,
  key: "passmed-pte-ltd",
  name: "Passmed Pte Ltd",
  normalizedName: "Passmed Pte Ltd",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_michael_peters = fn::createMerchant({
  space: $space,
  key: "michael-peters",
  name: "Michael Peters",
  normalizedName: "Michael Peters",
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
LET $merchant_google_workspace = fn::createMerchant({
  space: $space,
  key: "google-workspace",
  name: "Google Workspace",
  normalizedName: "Google Workspace",
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
LET $merchant_vecteezy = fn::createMerchant({
  space: $space,
  key: "vecteezy",
  name: "Vecteezy",
  normalizedName: "Vecteezy",
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
LET $merchant_altra_care_limited = fn::createMerchant({
  space: $space,
  key: "altra-care-limited",
  name: "Altra Care Limited",
  normalizedName: "Altra Care Limited",
  active: true,
  notes: "Imported from 2025-10-18.import.md"
});
LET $merchant_ivecloud = fn::createMerchant({
  space: $space,
  key: "ivecloud",
  name: "Ivecloud",
  normalizedName: "Ivecloud",
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
  normalizedDescription: "Elitehost",
  amount: 476.91,
  balance: 374.9,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 1,
    rawRowText: "POS Purchase 476.91 Paypal *Elit                                                   485442*7050 16 Sep; 476.91; 374.90 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 476.91,
    bankChargeZar: 3.68,
    balanceZar: 374.9
},
  notes: "Elitehost hosting payment; exact hosted service can be broken down later."
});
LET $tx_stmt_2025_10_18_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-09-19T00:00:00Z",
  description: "POS Purchase 476.91 Paypal *Elit                                                   485442*7050 16 Sep",
  normalizedDescription: "Elitehost",
  amount: 476.91,
  balance: 374.9,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Elitehost",
  merchant: $merchant_elitehost,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Elitehost hosting payment; exact hosted service can be broken down later."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_10_18_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_01.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_01.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-09-19T00:00:00Z",
  description: "POS Purchase 476.91 Paypal *Elit                                                   485442*7050 16 Sep",
  normalizedDescription: "Elitehost",
  amount: 476.91,
  balance: 102.01,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 2,
    rawRowText: "POS Purchase 476.91 Paypal *Elit                                                   485442*7050 16 Sep; 476.91; 102.01; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 476.91,
    bankChargeZar: 3.68,
    balanceZar: 102.01
},
  notes: "Elitehost hosting payment; exact hosted service can be broken down later."
});
LET $tx_stmt_2025_10_18_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-09-19T00:00:00Z",
  description: "POS Purchase 476.91 Paypal *Elit                                                   485442*7050 16 Sep",
  normalizedDescription: "Elitehost",
  amount: 476.91,
  balance: 102.01,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Elitehost",
  merchant: $merchant_elitehost,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Elitehost hosting payment; exact hosted service can be broken down later."
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_10_18_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_02.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_02.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

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
  status: "clarified",
  confidence: 0.95,
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
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 108.01
},
  notes: "FNB fee. Exact bank reason still needs later review."
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
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee. Exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_10_18_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_03.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_03.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

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
  status: "clarified",
  confidence: 0.95,
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
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 114.01
},
  notes: "FNB fee. Exact bank reason still needs later review."
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
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee. Exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_10_18_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_04.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_04.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

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
  status: "clarified",
  confidence: 0.95,
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
    clarificationStatus: "clarified",
    amountZar: 1.29,
    bankChargeZar: null,
    balanceZar: 115.3
},
  notes: "FNB fee. Exact bank reason still needs later review."
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
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee. Exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_10_18_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_05.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_05.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

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
  status: "clarified",
  confidence: 0.95,
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
    clarificationStatus: "clarified",
    amountZar: 10.73,
    bankChargeZar: null,
    balanceZar: 126.03
},
  notes: "FNB fee. Exact bank reason still needs later review."
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
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee. Exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_10_18_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_06.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_06.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

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
  status: "clarified",
  confidence: 0.95,
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
    clarificationStatus: "clarified",
    amountZar: 10.73,
    bankChargeZar: null,
    balanceZar: 136.76
},
  notes: "FNB fee. Exact bank reason still needs later review."
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
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee. Exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_10_18_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_07.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_07.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

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
  status: "clarified",
  confidence: 0.95,
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
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 142.76
},
  notes: "FNB fee. Exact bank reason still needs later review."
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
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee. Exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_10_18_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_08.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_08.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

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
  status: "clarified",
  confidence: 0.95,
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
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 148.76
},
  notes: "FNB fee. Exact bank reason still needs later review."
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
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee. Exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_10_18_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_09.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_09.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

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
  normalizedDescription: "VDV Internet",
  amount: 849,
  balance: 5852.24,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 11,
    rawRowText: "Internet Pmt To Vdv Internet                                                       Mic00017; 849.00; 5,852.24 Cr",
    transactionType: "expense",
    normalizedMerchant: "VDV Internet",
    category: "Utilities / internet",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 849,
    bankChargeZar: null,
    balanceZar: 5852.24
},
  notes: "Monthly business internet bill."
});
LET $tx_stmt_2025_10_18_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-09-30T00:00:00Z",
  description: "Internet Pmt To Vdv Internet                                                       Mic00017",
  normalizedDescription: "VDV Internet",
  amount: 849,
  balance: 5852.24,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VDV Internet",
  merchant: $merchant_vdv_internet,
  category: $cat_utilities_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Monthly business internet bill."
});
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_10_18_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_11.id, "TransactionMerchant", $merchant_vdv_internet.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_11.id, "TransactionCategory", $cat_utilities_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-09-30T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "TrueFit",
  amount: 1000,
  balance: 6852.24,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 12,
    rawRowText: "Magtape Credit 127167 True Fit; 1,000.00 Cr; 6,852.24 Cr",
    transactionType: "income",
    normalizedMerchant: "TrueFit",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: 6852.24
},
  notes: "TrueFit golf maintenance payment income."
});
LET $tx_stmt_2025_10_18_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-09-30T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "TrueFit",
  amount: 1000,
  balance: 6852.24,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "TrueFit",
  merchant: $merchant_truefit,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "TrueFit golf maintenance payment income."
});
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_10_18_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_12.id, "TransactionMerchant", $merchant_truefit.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_12.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

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
  normalizedDescription: "Passmed Pte Ltd",
  amount: 49825,
  balance: 55899.69,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 14,
    rawRowText: "Inward Swift R025Mqp3R0 Passmed Pte Ltd; 49,825.00 Cr; 55,899.69 Cr",
    transactionType: "income",
    normalizedMerchant: "Passmed Pte Ltd",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 49825,
    bankChargeZar: null,
    balanceZar: 55899.69
},
  notes: "Passmed project stage 5 payment."
});
LET $tx_stmt_2025_10_18_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Inward Swift R025Mqp3R0 Passmed Pte Ltd",
  normalizedDescription: "Passmed Pte Ltd",
  amount: 49825,
  balance: 55899.69,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Passmed Pte Ltd",
  merchant: $merchant_passmed_pte_ltd,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Passmed project stage 5 payment."
});
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_10_18_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_14.id, "TransactionMerchant", $merchant_passmed_pte_ltd.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_14.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 50000,
  balance: 5899.69,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 15,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market; 50,000.00; 5,899.69 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 50000,
    bankChargeZar: 15,
    balanceZar: 5899.69
},
  notes: "Payment from the business account into the personal current account."
});
LET $tx_stmt_2025_10_18_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 50000,
  balance: 5899.69,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Payment from the business account into the personal current account."
});
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_10_18_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_15.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_15.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

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
  normalizedDescription: "Google Workspace",
  amount: 174.66,
  balance: 5368.15,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 17,
    rawRowText: "POS Purchase 8.38 Google Gsuite_                                                   485442*7050 01 Oct; 174.66; 5,368.15 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Google Workspace",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 174.66,
    bankChargeZar: 3.68,
    balanceZar: 5368.15
},
  notes: "Google Workspace subscription."
});
LET $tx_stmt_2025_10_18_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-10-03T00:00:00Z",
  description: "POS Purchase 8.38 Google Gsuite_                                                   485442*7050 01 Oct",
  normalizedDescription: "Google Workspace",
  amount: 174.66,
  balance: 5368.15,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Google Workspace",
  merchant: $merchant_google_workspace,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Google Workspace subscription."
});
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_10_18_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_17.id, "TransactionMerchant", $merchant_google_workspace.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_17.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-10-03T00:00:00Z",
  description: "POS Purchase 395.95 Paypal *Elit                                                   485442*7050 01 Oct",
  normalizedDescription: "Elitehost",
  amount: 395.95,
  balance: 4972.2,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 18,
    rawRowText: "POS Purchase 395.95 Paypal *Elit                                                   485442*7050 01 Oct; 395.95; 4,972.20 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 395.95,
    bankChargeZar: 3.68,
    balanceZar: 4972.2
},
  notes: "Elitehost hosting payment."
});
LET $tx_stmt_2025_10_18_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-10-03T00:00:00Z",
  description: "POS Purchase 395.95 Paypal *Elit                                                   485442*7050 01 Oct",
  normalizedDescription: "Elitehost",
  amount: 395.95,
  balance: 4972.2,
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_10_18_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_18.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_18.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

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
  normalizedDescription: "Michael Peters",
  amount: 2500,
  balance: 1944.2,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 20,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market; 2,500.00; 1,944.20 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2500,
    bankChargeZar: 8,
    balanceZar: 1944.2
},
  notes: "Payment from the business account into the personal current account."
});
LET $tx_stmt_2025_10_18_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-10-06T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2500,
  balance: 1944.2,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Payment from the business account into the personal current account."
});
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_10_18_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_20.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_20.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-10-07T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1100,
  balance: 844.2,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 21,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market; 1,100.00; 844.20 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1100,
    bankChargeZar: 8,
    balanceZar: 844.2
},
  notes: "Payment from the business account into the personal current account."
});
LET $tx_stmt_2025_10_18_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-10-07T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                            Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1100,
  balance: 844.2,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Payment from the business account into the personal current account."
});
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_10_18_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_21.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_21.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-10-07T00:00:00Z",
  description: "POS Purchase 126.43 Paypal *Vect                                                   485442*7050 04 Oct",
  normalizedDescription: "Vecteezy",
  amount: 126.43,
  balance: 717.77,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 22,
    rawRowText: "POS Purchase 126.43 Paypal *Vect                                                   485442*7050 04 Oct; 126.43; 717.77 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Vecteezy",
    category: "Design / media assets",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 126.43,
    bankChargeZar: 3.68,
    balanceZar: 717.77
},
  notes: "Vecteezy stock image and video subscription."
});
LET $tx_stmt_2025_10_18_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-10-07T00:00:00Z",
  description: "POS Purchase 126.43 Paypal *Vect                                                   485442*7050 04 Oct",
  normalizedDescription: "Vecteezy",
  amount: 126.43,
  balance: 717.77,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Vecteezy",
  merchant: $merchant_vecteezy,
  category: $cat_design_media_assets,
  isTransfer: false,
  manualOverride: false,
  notes: "Vecteezy stock image and video subscription."
});
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_10_18_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_22.id, "TransactionMerchant", $merchant_vecteezy.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_22.id, "TransactionCategory", $cat_design_media_assets.id, { boundId: true, overwrite: false, skipExists: true });

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
  normalizedDescription: "Altra Care Limited",
  amount: 25598.85,
  balance: 25734.04,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 25,
    rawRowText: "Inward Swift R025Mjftj0 Altra Care Limited; 25,598.85 Cr; 25,734.04 Cr",
    transactionType: "income",
    normalizedMerchant: "Altra Care Limited",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 25598.85,
    bankChargeZar: null,
    balanceZar: 25734.04
},
  notes: "Income for completion of the Altra Care project."
});
LET $tx_stmt_2025_10_18_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-10-08T00:00:00Z",
  description: "Inward Swift R025Mjftj0 Altra Care Limited",
  normalizedDescription: "Altra Care Limited",
  amount: 25598.85,
  balance: 25734.04,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Altra Care Limited",
  merchant: $merchant_altra_care_limited,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Income for completion of the Altra Care project."
});
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_10_18_row_25.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_25.id, "TransactionMerchant", $merchant_altra_care_limited.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_25.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-10-08T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 20000,
  balance: 5734.04,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 26,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 20,000.00; 5,734.04 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 20000,
    bankChargeZar: 15,
    balanceZar: 5734.04
},
  notes: "Payment from the business account into the personal current account."
});
LET $tx_stmt_2025_10_18_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-10-08T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 20000,
  balance: 5734.04,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Payment from the business account into the personal current account."
});
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_10_18_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_26.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_26.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-10-10T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2500,
  balance: 3234.04,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 27,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 2,500.00; 3,234.04 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2500,
    bankChargeZar: 8,
    balanceZar: 3234.04
},
  notes: "Payment from the business account into the personal current account."
});
LET $tx_stmt_2025_10_18_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-10-10T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2500,
  balance: 3234.04,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Payment from the business account into the personal current account."
});
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_10_18_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_27.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_27.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

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
  status: "clarified",
  confidence: 0.95,
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
    clarificationStatus: "clarified",
    amountZar: 8.91,
    bankChargeZar: null,
    balanceZar: 3225.13
},
  notes: "FNB fee. Exact bank reason still needs later review."
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
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee. Exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_10_18_row_28.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_28.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_28.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-10-13T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2000,
  balance: 1225.13,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 29,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 2,000.00; 1,225.13 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: 8,
    balanceZar: 1225.13
},
  notes: "Payment from the business account into the personal current account."
});
LET $tx_stmt_2025_10_18_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-10-13T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2000,
  balance: 1225.13,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Payment from the business account into the personal current account."
});
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_10_18_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_29.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_29.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-10-14T00:00:00Z",
  description: "POS Purchase Payfast*Ivecloud Pt                                                485442*7050 11 Oct",
  normalizedDescription: "Ivecloud",
  amount: 100,
  balance: 1125.13,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 30,
    rawRowText: "POS Purchase Payfast*Ivecloud Pt                                                485442*7050 11 Oct; 100.00; 1,125.13 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Ivecloud",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 100,
    bankChargeZar: 3.68,
    balanceZar: 1125.13
},
  notes: "Hosting fee; discounted down to R100 for this month."
});
LET $tx_stmt_2025_10_18_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-10-14T00:00:00Z",
  description: "POS Purchase Payfast*Ivecloud Pt                                                485442*7050 11 Oct",
  normalizedDescription: "Ivecloud",
  amount: 100,
  balance: 1125.13,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Ivecloud",
  merchant: $merchant_ivecloud,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting fee; discounted down to R100 for this month."
});
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_10_18_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_30.id, "TransactionMerchant", $merchant_ivecloud.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_30.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

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
  status: "clarified",
  confidence: 0.95,
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
    clarificationStatus: "clarified",
    amountZar: 2.84,
    bankChargeZar: null,
    balanceZar: 1122.29
},
  notes: "FNB fee. Exact bank reason still needs later review."
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
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee. Exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_10_18_row_31.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_31.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_31.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-10-17T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1000,
  balance: 122.29,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 32,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 1,000.00; 122.29 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: 8,
    balanceZar: 122.29
},
  notes: "Payment from the business account into the personal current account."
});
LET $tx_stmt_2025_10_18_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-10-17T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1000,
  balance: 122.29,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Michael Peters",
  merchant: $merchant_michael_peters,
  category: $cat_business_to_personal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Payment from the business account into the personal current account."
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_10_18_row_32.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_32.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_32.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

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
  normalizedDescription: "Electronic Payment Fee",
  amount: 0,
  balance: 121.41,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_84.pdf",
    statementPeriodStart: "2025-09-18",
    statementPeriodEnd: "2025-10-18",
    rowNo: 34,
    rawRowText: "0.00; 121.41 Cr; 5.00",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "electronic payment fee",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: 5,
    balanceZar: 121.41
},
  notes: "Inferred electronic payment fee based on the same FNB statement pattern seen in later months."
});
LET $tx_stmt_2025_10_18_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-18-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-10-18T00:00:00Z",
  description: "0.00",
  normalizedDescription: "Electronic Payment Fee",
  amount: 0,
  balance: 121.41,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_electronic_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Inferred electronic payment fee based on the same FNB statement pattern seen in later months."
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_10_18_row_34.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_34.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_34.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

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
  status: "clarified",
  confidence: 0.95,
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
    clarificationStatus: "clarified",
    amountZar: 93,
    bankChargeZar: null,
    balanceZar: 28.41
},
  notes: "FNB fee. Exact bank reason still needs later review."
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
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee. Exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_10_18_row_35.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_35.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_35.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

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
  status: "clarified",
  confidence: 0.95,
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
    clarificationStatus: "clarified",
    amountZar: 123.8,
    bankChargeZar: null,
    balanceZar: 95.39
},
  notes: "FNB fee. Exact bank reason still needs later review."
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
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee. Exact bank reason still needs later review."
});
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_10_18_row_36.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_10_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_36.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_18_row_36.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 36,
  normalizedCount: 36,
  clarificationCount: 0,
  status: "matched",
  statementDate: "2025-10-18T00:00:00Z",
  notes: "Imported from 2025-10-18.import.md"
});

-- End of generated import
