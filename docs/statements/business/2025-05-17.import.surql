-- Generated from docs/statements/business/2025-05-17.import.md
-- Source: docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf

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
  openingBalance: 3960.06,
  active: true,
  notes: "Imported from GOLD_BUSINESS_ACCOUNT_79.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-05-17-fnb-gold-business-27821",
  sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-05-17T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-05-17.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_business_to_personal_transfer = fn::createCategory({
  space: $space,
  key: "business-to-personal-transfer",
  name: "Business to personal transfer",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $cat_software_saas = fn::createCategory({
  space: $space,
  key: "software-saas",
  name: "Software / SaaS",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $cat_client_income = fn::createCategory({
  space: $space,
  key: "client-income",
  name: "Client income",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $cat_equipment_loan_repayment = fn::createCategory({
  space: $space,
  key: "equipment-loan-repayment",
  name: "Equipment / loan repayment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $cat_internet_connectivity = fn::createCategory({
  space: $space,
  key: "internet-connectivity",
  name: "Internet / connectivity",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $cat_insurance = fn::createCategory({
  space: $space,
  key: "insurance",
  name: "Insurance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $cat_ai_tools = fn::createCategory({
  space: $space,
  key: "ai-tools",
  name: "AI tools",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $cat_website_maintenance_income = fn::createCategory({
  space: $space,
  key: "website-maintenance-income",
  name: "Website maintenance income",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $cat_hosting_internet = fn::createCategory({
  space: $space,
  key: "hosting-internet",
  name: "Hosting / internet",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $cat_fees_card_charge = fn::createCategory({
  space: $space,
  key: "fees-card-charge",
  name: "Card Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $cat_fees_bank_fee = fn::createCategory({
  space: $space,
  key: "fees-bank-fee",
  name: "Bank Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});

-- Merchant records
LET $merchant_michael_peters = fn::createMerchant({
  space: $space,
  key: "michael-peters",
  name: "Michael Peters",
  normalizedName: "Michael Peters",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_cursor = fn::createMerchant({
  space: $space,
  key: "cursor",
  name: "Cursor",
  normalizedName: "Cursor",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_sansor = fn::createMerchant({
  space: $space,
  key: "sansor",
  name: "Sansor",
  normalizedName: "Sansor",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_fnb = fn::createMerchant({
  space: $space,
  key: "fnb",
  name: "FNB",
  normalizedName: "FNB",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_true_fit = fn::createMerchant({
  space: $space,
  key: "true-fit",
  name: "True Fit",
  normalizedName: "True Fit",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_augemus_global = fn::createMerchant({
  space: $space,
  key: "augemus-global",
  name: "Augemus Global",
  normalizedName: "Augemus Global",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_laptop_loan_payment = fn::createMerchant({
  space: $space,
  key: "laptop-loan-payment",
  name: "Laptop Loan Payment",
  normalizedName: "Laptop Loan Payment",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_vdv_internet = fn::createMerchant({
  space: $space,
  key: "vdv-internet",
  name: "VDV Internet",
  normalizedName: "VDV Internet",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_outsurance = fn::createMerchant({
  space: $space,
  key: "outsurance",
  name: "Outsurance",
  normalizedName: "Outsurance",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_openai = fn::createMerchant({
  space: $space,
  key: "openai",
  name: "OpenAI",
  normalizedName: "OpenAI",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_google_workspace = fn::createMerchant({
  space: $space,
  key: "google-workspace",
  name: "Google Workspace",
  normalizedName: "Google Workspace",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_pos_purchase_223_06_pp_fsprg_com_485442_7050_30_apr = fn::createMerchant({
  space: $space,
  key: "pos-purchase-223-06-pp-fsprg-com-485442-7050-30-apr",
  name: "POS Purchase 223.06 Pp*Fsprg.Com 485442*7050 30 Apr",
  normalizedName: "POS Purchase 223.06 Pp*Fsprg.Com 485442*7050 30 Apr",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_notion = fn::createMerchant({
  space: $space,
  key: "notion",
  name: "Notion",
  normalizedName: "Notion",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_vecteezy = fn::createMerchant({
  space: $space,
  key: "vecteezy",
  name: "Vecteezy",
  normalizedName: "Vecteezy",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_paypal = fn::createMerchant({
  space: $space,
  key: "paypal",
  name: "PayPal",
  normalizedName: "PayPal",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_au_pair_extraordinaire = fn::createMerchant({
  space: $space,
  key: "au-pair-extraordinaire",
  name: "Au Pair Extraordinaire",
  normalizedName: "Au Pair Extraordinaire",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});
LET $merchant_elitehost = fn::createMerchant({
  space: $space,
  key: "elitehost",
  name: "Elitehost",
  normalizedName: "Elitehost",
  active: true,
  notes: "Imported from 2025-05-17.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-04-19T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2100,
  balance: 1860.06,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 1,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market; 2,100.00; 1,860.06 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2100,
    bankChargeZar: 8,
    balanceZar: 1860.06
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_05_17_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-04-19T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2100,
  balance: 1860.06,
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_05_17_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_01.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_01.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-04-25T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                      485442*7050 23 Apr",
  normalizedDescription: "Cursor",
  amount: 384.11,
  balance: 1475.95,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 2,
    rawRowText: "POS Purchase 20.00 Cursor, Ai Po                                                      485442*7050 23 Apr; 384.11; 1,475.95 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Cursor",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 384.11,
    bankChargeZar: 3.68,
    balanceZar: 1475.95
},
  notes: "Cursor AI tooling spend."
});
LET $tx_stmt_2025_05_17_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-04-25T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                      485442*7050 23 Apr",
  normalizedDescription: "Cursor",
  amount: 384.11,
  balance: 1475.95,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_05_17_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_02.id, "TransactionMerchant", $merchant_cursor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_02.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-04-26T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1250,
  balance: 225.95,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 3,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market; 1,250.00; 225.95 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1250,
    bankChargeZar: 8,
    balanceZar: 225.95
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_05_17_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-04-26T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1250,
  balance: 225.95,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_05_17_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_03.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_03.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-04-29T00:00:00Z",
  description: "FNB OB Pmt Sansor",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 7075.95,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 4,
    rawRowText: "FNB OB Pmt Sansor; 6,850.00 Cr; 7,075.95 Cr",
    transactionType: "income",
    normalizedMerchant: "Sansor",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6850,
    bankChargeZar: null,
    balanceZar: 7075.95
},
  notes: "Recurring client payment from Sansor."
});
LET $tx_stmt_2025_05_17_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-04-29T00:00:00Z",
  description: "FNB OB Pmt Sansor",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 7075.95,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_05_17_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_04.id, "TransactionMerchant", $merchant_sansor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_04.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-04-29T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 7069.95,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 5,
    rawRowText: "6.00; 7,069.95 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 7069.95
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_05_17_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-04-29T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 7069.95,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_05_17_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_05.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_05.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-04-30T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "True Fit",
  amount: 2000,
  balance: 9069.95,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 6,
    rawRowText: "Magtape Credit 127167 True Fit; 2,000.00 Cr; 9,069.95 Cr",
    transactionType: "income",
    normalizedMerchant: "True Fit",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: 9069.95
},
  notes: "True Fit maintenance income covering two months."
});
LET $tx_stmt_2025_05_17_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-04-30T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "True Fit",
  amount: 2000,
  balance: 9069.95,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "True Fit",
  merchant: $merchant_true_fit,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "True Fit maintenance income covering two months."
});
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_05_17_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_06.id, "TransactionMerchant", $merchant_true_fit.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_06.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-05-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 6000,
  balance: 3069.95,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 7,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market; 6,000.00; 3,069.95 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6000,
    bankChargeZar: 15,
    balanceZar: 3069.95
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_05_17_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-05-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 6000,
  balance: 3069.95,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_05_17_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_07.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_07.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-05-02T00:00:00Z",
  description: "FNB OB Pmt Augemus Global",
  normalizedDescription: "Augemus Global",
  amount: 20000,
  balance: 23069.95,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 8,
    rawRowText: "FNB OB Pmt Augemus Global; 20,000.00 Cr; 23,069.95 Cr",
    transactionType: "income",
    normalizedMerchant: "Augemus Global",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 20000,
    bankChargeZar: null,
    balanceZar: 23069.95
},
  notes: "Project income for UX solution development."
});
LET $tx_stmt_2025_05_17_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-05-02T00:00:00Z",
  description: "FNB OB Pmt Augemus Global",
  normalizedDescription: "Augemus Global",
  amount: 20000,
  balance: 23069.95,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Augemus Global",
  merchant: $merchant_augemus_global,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Project income for UX solution development."
});
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_05_17_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_08.id, "TransactionMerchant", $merchant_augemus_global.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_08.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-05-02T00:00:00Z",
  description: "Internet Pmt To Laptop Loan Payment                                                   Mpire Loan Repayment",
  normalizedDescription: "Laptop Loan Payment",
  amount: 1919,
  balance: 21150.95,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 9,
    rawRowText: "Internet Pmt To Laptop Loan Payment                                                   Mpire Loan Repayment; 1,919.00; 21,150.95 Cr",
    transactionType: "expense",
    normalizedMerchant: "Laptop Loan Payment",
    category: "Equipment / loan repayment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1919,
    bankChargeZar: null,
    balanceZar: 21150.95
},
  notes: "Laptop repayment."
});
LET $tx_stmt_2025_05_17_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-05-02T00:00:00Z",
  description: "Internet Pmt To Laptop Loan Payment                                                   Mpire Loan Repayment",
  normalizedDescription: "Laptop Loan Payment",
  amount: 1919,
  balance: 21150.95,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Laptop Loan Payment",
  merchant: $merchant_laptop_loan_payment,
  category: $cat_equipment_loan_repayment,
  isTransfer: false,
  manualOverride: false,
  notes: "Laptop repayment."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_05_17_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_09.id, "TransactionMerchant", $merchant_laptop_loan_payment.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_09.id, "TransactionCategory", $cat_equipment_loan_repayment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-05-02T00:00:00Z",
  description: "Internet Pmt To Vdv Internet                                                          Mic00017",
  normalizedDescription: "VDV Internet",
  amount: 1698,
  balance: 19452.95,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 10,
    rawRowText: "Internet Pmt To Vdv Internet                                                          Mic00017; 1,698.00; 19,452.95 Cr",
    transactionType: "expense",
    normalizedMerchant: "VDV Internet",
    category: "Internet / connectivity",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1698,
    bankChargeZar: null,
    balanceZar: 19452.95
},
  notes: "Business internet bill."
});
LET $tx_stmt_2025_05_17_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-05-02T00:00:00Z",
  description: "Internet Pmt To Vdv Internet                                                          Mic00017",
  normalizedDescription: "VDV Internet",
  amount: 1698,
  balance: 19452.95,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VDV Internet",
  merchant: $merchant_vdv_internet,
  category: $cat_internet_connectivity,
  isTransfer: false,
  manualOverride: false,
  notes: "Business internet bill."
});
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_05_17_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_10.id, "TransactionMerchant", $merchant_vdv_internet.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_10.id, "TransactionCategory", $cat_internet_connectivity.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-05-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 12500,
  balance: 6952.95,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 11,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market; 12,500.00; 6,952.95 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 12500,
    bankChargeZar: 15,
    balanceZar: 6952.95
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_05_17_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-05-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 12500,
  balance: 6952.95,
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_05_17_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_11.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_11.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-05-02T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Nt0897",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 6175.4,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 12,
    rawRowText: "Magtape Debit Outsurance Ot87677302 Nt0897; 777.55; 6,175.40 Cr; 12.00",
    transactionType: "expense",
    normalizedMerchant: "Outsurance",
    category: "Insurance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 777.55,
    bankChargeZar: 12,
    balanceZar: 6175.4
},
  notes: "Insurance debit."
});
LET $tx_stmt_2025_05_17_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-05-02T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Nt0897",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 6175.4,
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_05_17_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_12.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_12.id, "TransactionCategory", $cat_insurance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-05-02T00:00:00Z",
  description: "POS Purchase 23.00 Openai *Chatg                                                      485442*7050 29 Apr",
  normalizedDescription: "OpenAI",
  amount: 440.79,
  balance: 5734.61,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 13,
    rawRowText: "POS Purchase 23.00 Openai *Chatg                                                      485442*7050 29 Apr; 440.79; 5,734.61 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "OpenAI",
    category: "AI tools",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 440.79,
    bankChargeZar: 3.68,
    balanceZar: 5734.61
},
  notes: "OpenAI business tooling spend."
});
LET $tx_stmt_2025_05_17_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-05-02T00:00:00Z",
  description: "POS Purchase 23.00 Openai *Chatg                                                      485442*7050 29 Apr",
  normalizedDescription: "OpenAI",
  amount: 440.79,
  balance: 5734.61,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_05_17_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_13.id, "TransactionMerchant", $merchant_openai.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_13.id, "TransactionCategory", $cat_ai_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-05-03T00:00:00Z",
  description: "POS Purchase 3.24 Google Gsuite_                                                      485442*7050 01 May",
  normalizedDescription: "Google Workspace",
  amount: 70.15,
  balance: 5664.46,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 14,
    rawRowText: "POS Purchase 3.24 Google Gsuite_                                                      485442*7050 01 May; 70.15; 5,664.46 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Google Workspace",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 70.15,
    bankChargeZar: 3.68,
    balanceZar: 5664.46
},
  notes: "Google Workspace subscription spend."
});
LET $tx_stmt_2025_05_17_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-05-03T00:00:00Z",
  description: "POS Purchase 3.24 Google Gsuite_                                                      485442*7050 01 May",
  normalizedDescription: "Google Workspace",
  amount: 70.15,
  balance: 5664.46,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_05_17_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_14.id, "TransactionMerchant", $merchant_google_workspace.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_14.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-05-03T00:00:00Z",
  description: "POS Purchase 223.06 Pp*Fsprg.Com                                                      485442*7050 30 Apr",
  normalizedDescription: "POS Purchase 223.06 Pp*Fsprg.Com 485442*7050 30 Apr",
  amount: 223.06,
  balance: 5441.4,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 15,
    rawRowText: "POS Purchase 223.06 Pp*Fsprg.Com                                                      485442*7050 30 Apr; 223.06; 5,441.40 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "POS Purchase 223.06 Pp*Fsprg.Com 485442*7050 30 Apr",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 223.06,
    bankChargeZar: 3.68,
    balanceZar: 5441.4
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_05_17_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-05-03T00:00:00Z",
  description: "POS Purchase 223.06 Pp*Fsprg.Com                                                      485442*7050 30 Apr",
  normalizedDescription: "POS Purchase 223.06 Pp*Fsprg.Com 485442*7050 30 Apr",
  amount: 223.06,
  balance: 5441.4,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "POS Purchase 223.06 Pp*Fsprg.Com 485442*7050 30 Apr",
  merchant: $merchant_pos_purchase_223_06_pp_fsprg_com_485442_7050_30_apr,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_05_17_row_15.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_15.id, "TransactionMerchant", $merchant_pos_purchase_223_06_pp_fsprg_com_485442_7050_30_apr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_15.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_05_17_row_15 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-05-17-row-15",
  transaction: $tx_stmt_2025_05_17_row_15,
  status: "open",
  question: "What is the exact purpose of this POS Purchase 223.06 Pp*Fsprg.Com 485442*7050 30 Apr transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_pos_purchase_223_06_pp_fsprg_com_485442_7050_30_apr,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-05-17.import.md"
});
fn::createEdge($tx_stmt_2025_05_17_row_15.id, "TransactionClarificationTasks", $task_stmt_2025_05_17_row_15.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-05-06T00:00:00Z",
  description: "POS Purchase 12.00 Notion Labs,                                                       485442*7050 04 May",
  normalizedDescription: "Notion",
  amount: 228.93,
  balance: 5212.47,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 16,
    rawRowText: "POS Purchase 12.00 Notion Labs,                                                       485442*7050 04 May; 228.93; 5,212.47 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Notion",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 228.93,
    bankChargeZar: 3.68,
    balanceZar: 5212.47
},
  notes: "Notion subscription spend."
});
LET $tx_stmt_2025_05_17_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-05-06T00:00:00Z",
  description: "POS Purchase 12.00 Notion Labs,                                                       485442*7050 04 May",
  normalizedDescription: "Notion",
  amount: 228.93,
  balance: 5212.47,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_05_17_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_16.id, "TransactionMerchant", $merchant_notion.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_16.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-05-07T00:00:00Z",
  description: "4.46",
  normalizedDescription: "Bank Fee",
  amount: 4.46,
  balance: 5208.01,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 17,
    rawRowText: "4.46; 5,208.01 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 4.46,
    bankChargeZar: null,
    balanceZar: 5208.01
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_05_17_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-05-07T00:00:00Z",
  description: "4.46",
  normalizedDescription: "Bank Fee",
  amount: 4.46,
  balance: 5208.01,
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_05_17_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_17.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_17.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-05-08T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2000,
  balance: 3208.01,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 18,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market; 2,000.00; 3,208.01 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: 8,
    balanceZar: 3208.01
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_05_17_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-05-08T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 2000,
  balance: 3208.01,
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_05_17_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_18.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_18.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-05-08T00:00:00Z",
  description: "POS Purchase 136.38 Paypal *Vect                                                      485442*7050 04 May",
  normalizedDescription: "Vecteezy",
  amount: 136.38,
  balance: 3071.63,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 19,
    rawRowText: "POS Purchase 136.38 Paypal *Vect                                                      485442*7050 04 May; 136.38; 3,071.63 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Vecteezy",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 136.38,
    bankChargeZar: 3.68,
    balanceZar: 3071.63
},
  notes: "Vecteezy stock image and video subscription."
});
LET $tx_stmt_2025_05_17_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-05-08T00:00:00Z",
  description: "POS Purchase 136.38 Paypal *Vect                                                      485442*7050 04 May",
  normalizedDescription: "Vecteezy",
  amount: 136.38,
  balance: 3071.63,
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
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_05_17_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_19.id, "TransactionMerchant", $merchant_vecteezy.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_19.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-05-10T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1250,
  balance: 1821.63,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 20,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market; 1,250.00; 1,821.63 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Michael Peters",
    category: "Business to personal transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1250,
    bankChargeZar: 8,
    balanceZar: 1821.63
},
  notes: "Business-to-personal transfer to the personal current account."
});
LET $tx_stmt_2025_05_17_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-05-10T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                               Mpire Digital Market",
  normalizedDescription: "Michael Peters",
  amount: 1250,
  balance: 1821.63,
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
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_05_17_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_20.id, "TransactionMerchant", $merchant_michael_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_20.id, "TransactionCategory", $cat_business_to_personal_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-05-12T00:00:00Z",
  description: "POS Purchase 1225.83 Paypal *Pad                                                      485442*7050 08 May",
  normalizedDescription: "PayPal",
  amount: 1225.83,
  balance: 595.8,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 21,
    rawRowText: "POS Purchase 1225.83 Paypal *Pad                                                      485442*7050 08 May; 1,225.83; 595.80 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 1225.83,
    bankChargeZar: 3.68,
    balanceZar: 595.8
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_05_17_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-05-12T00:00:00Z",
  description: "POS Purchase 1225.83 Paypal *Pad                                                      485442*7050 08 May",
  normalizedDescription: "PayPal",
  amount: 1225.83,
  balance: 595.8,
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
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_05_17_row_21.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_21.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_21.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_05_17_row_21 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-05-17-row-21",
  transaction: $tx_stmt_2025_05_17_row_21,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-05-17.import.md"
});
fn::createEdge($tx_stmt_2025_05_17_row_21.id, "TransactionClarificationTasks", $task_stmt_2025_05_17_row_21.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-05-13T00:00:00Z",
  description: "Rtc Credit Au Pair Extraordinai                                                       5156774322",
  normalizedDescription: "Au Pair Extraordinaire",
  amount: 1000,
  balance: 1595.8,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 22,
    rawRowText: "Rtc Credit Au Pair Extraordinai                                                       5156774322; 1,000.00 Cr; 1,595.80 Cr",
    transactionType: "income",
    normalizedMerchant: "Au Pair Extraordinaire",
    category: "Website maintenance income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: 1595.8
},
  notes: "Website maintenance income from Au Pair Extraordinaire."
});
LET $tx_stmt_2025_05_17_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-05-13T00:00:00Z",
  description: "Rtc Credit Au Pair Extraordinai                                                       5156774322",
  normalizedDescription: "Au Pair Extraordinaire",
  amount: 1000,
  balance: 1595.8,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Au Pair Extraordinaire",
  merchant: $merchant_au_pair_extraordinaire,
  category: $cat_website_maintenance_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Website maintenance income from Au Pair Extraordinaire."
});
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_05_17_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_22.id, "TransactionMerchant", $merchant_au_pair_extraordinaire.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_22.id, "TransactionCategory", $cat_website_maintenance_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-05-13T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 1589.8,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 23,
    rawRowText: "6.00; 1,589.80 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 1589.8
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_05_17_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-05-13T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 1589.8,
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_05_17_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_23.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_23.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-05-15T00:00:00Z",
  description: "POS Purchase 57.34 Paypal *Elite                                                      485442*7050 13 May",
  normalizedDescription: "Elitehost",
  amount: 57.34,
  balance: 1532.46,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 24,
    rawRowText: "POS Purchase 57.34 Paypal *Elite                                                      485442*7050 13 May; 57.34; 1,532.46 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 57.34,
    bankChargeZar: 3.68,
    balanceZar: 1532.46
},
  notes: "Elitehost hosting expense."
});
LET $tx_stmt_2025_05_17_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-05-15T00:00:00Z",
  description: "POS Purchase 57.34 Paypal *Elite                                                      485442*7050 13 May",
  normalizedDescription: "Elitehost",
  amount: 57.34,
  balance: 1532.46,
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
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_05_17_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_24.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_24.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-05-15T00:00:00Z",
  description: "POS Purchase 103.41 Paypal *Elit                                                      485442*7050 13 May",
  normalizedDescription: "Elitehost",
  amount: 103.41,
  balance: 1429.05,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 25,
    rawRowText: "POS Purchase 103.41 Paypal *Elit                                                      485442*7050 13 May; 103.41; 1,429.05 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Elitehost",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 103.41,
    bankChargeZar: 3.68,
    balanceZar: 1429.05
},
  notes: "Elitehost hosting expense."
});
LET $tx_stmt_2025_05_17_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-05-15T00:00:00Z",
  description: "POS Purchase 103.41 Paypal *Elit                                                      485442*7050 13 May",
  normalizedDescription: "Elitehost",
  amount: 103.41,
  balance: 1429.05,
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
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_05_17_row_25.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_25.id, "TransactionMerchant", $merchant_elitehost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_25.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-05-15T00:00:00Z",
  description: "POS Purchase 20.12 Cursor Usage                                               485442*7050 13 May",
  normalizedDescription: "Cursor",
  amount: 376.58,
  balance: 1052.47,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 26,
    rawRowText: "POS Purchase 20.12 Cursor Usage                                               485442*7050 13 May; 376.58; 1,052.47 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Cursor",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 376.58,
    bankChargeZar: 3.68,
    balanceZar: 1052.47
},
  notes: "Cursor AI tooling spend."
});
LET $tx_stmt_2025_05_17_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-05-15T00:00:00Z",
  description: "POS Purchase 20.12 Cursor Usage                                               485442*7050 13 May",
  normalizedDescription: "Cursor",
  amount: 376.58,
  balance: 1052.47,
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
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_05_17_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_26.id, "TransactionMerchant", $merchant_cursor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_26.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-05-16T00:00:00Z",
  description: "2.73",
  normalizedDescription: "Bank Fee",
  amount: 2.73,
  balance: 1049.74,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 27,
    rawRowText: "2.73; 1,049.74 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 2.73,
    bankChargeZar: null,
    balanceZar: 1049.74
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_05_17_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-05-16T00:00:00Z",
  description: "2.73",
  normalizedDescription: "Bank Fee",
  amount: 2.73,
  balance: 1049.74,
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
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_05_17_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_27.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_27.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-05-17T00:00:00Z",
  description: "0.00",
  normalizedDescription: "Bank Fee",
  amount: 10,
  balance: 1049.74,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 28,
    rawRowText: "0.00; 1,049.74 Cr; 10.00",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 10,
    bankChargeZar: null,
    balanceZar: 1049.74
},
  notes: "Inferred month-end FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_05_17_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-05-17T00:00:00Z",
  description: "0.00",
  normalizedDescription: "Bank Fee",
  amount: 10,
  balance: 1049.74,
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
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_05_17_row_28.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_28.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_28.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-05-17T00:00:00Z",
  description: "89.00",
  normalizedDescription: "Bank Fee",
  amount: 89,
  balance: 960.74,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 29,
    rawRowText: "89.00; 960.74 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 89,
    bankChargeZar: null,
    balanceZar: 960.74
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_05_17_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-05-17T00:00:00Z",
  description: "89.00",
  normalizedDescription: "Bank Fee",
  amount: 89,
  balance: 960.74,
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
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_05_17_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_29.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_29.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-05-17T00:00:00Z",
  description: "120.80",
  normalizedDescription: "Bank Fee",
  amount: 120.8,
  balance: 839.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_79.pdf",
    statementPeriodStart: "2025-04-17",
    statementPeriodEnd: "2025-05-17",
    rowNo: 30,
    rawRowText: "120.80; 839.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "clarified",
    amountZar: 120.8,
    bankChargeZar: null,
    balanceZar: 839.94
},
  notes: "FNB fee line; exact bank reason still needs later review."
});
LET $tx_stmt_2025_05_17_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-17-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-05-17T00:00:00Z",
  description: "120.80",
  normalizedDescription: "Bank Fee",
  amount: 120.8,
  balance: 839.94,
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
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_05_17_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_05_17_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_17_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_30.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_17_row_30.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 30,
  normalizedCount: 30,
  clarificationCount: 2,
  status: "matched",
  statementDate: "2025-05-17T00:00:00Z",
  notes: "Imported from 2025-05-17.import.md"
});

-- End of generated import
