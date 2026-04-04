-- Generated from docs/statements/business/2026-03-18.import.md
-- Source: docs/statements/business/18 March 2026.pdf

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
  openingBalance: 137.94,
  active: true,
  notes: "Imported from 18 March 2026.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2026-03-18-fnb-business",
  sourceFileName: "docs/statements/business/18 March 2026.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2026-03-18T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2026-03-18.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_crypto_trading = fn::createCategory({
  space: $space,
  key: "crypto-trading",
  name: "Crypto / trading",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_online_services = fn::createCategory({
  space: $space,
  key: "online-services",
  name: "Online services",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_software_hosting = fn::createCategory({
  space: $space,
  key: "software-hosting",
  name: "Software / hosting",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_insurance = fn::createCategory({
  space: $space,
  key: "insurance",
  name: "Insurance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_transfer_services = fn::createCategory({
  space: $space,
  key: "transfer-services",
  name: "Transfer services",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_ai_software = fn::createCategory({
  space: $space,
  key: "ai-software",
  name: "AI / software",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_fees_unpaid_item_fee = fn::createCategory({
  space: $space,
  key: "fees-unpaid-item-fee",
  name: "Unpaid Item Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_fees_card_charge = fn::createCategory({
  space: $space,
  key: "fees-card-charge",
  name: "Card Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_fees_excess_item_fee = fn::createCategory({
  space: $space,
  key: "fees-excess-item-fee",
  name: "Excess Item Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_fees_paypal_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-paypal-payment-fee",
  name: "Paypal Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_fees_declined_foreign_card_fee = fn::createCategory({
  space: $space,
  key: "fees-declined-foreign-card-fee",
  name: "Declined Foreign Card Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_fees_debit_interest = fn::createCategory({
  space: $space,
  key: "fees-debit-interest",
  name: "Debit Interest",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_fees_electronic_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-electronic-payment-fee",
  name: "Electronic Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_fees_monthly_account_fee = fn::createCategory({
  space: $space,
  key: "fees-monthly-account-fee",
  name: "Monthly Account Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_fees_service_fee = fn::createCategory({
  space: $space,
  key: "fees-service-fee",
  name: "Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});

-- Merchant records
LET $merchant_fnb_magtape = fn::createMerchant({
  space: $space,
  key: "fnb-magtape",
  name: "FNB / Magtape",
  normalizedName: "FNB / Magtape",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_fnb = fn::createMerchant({
  space: $space,
  key: "fnb",
  name: "FNB",
  normalizedName: "FNB",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_valr = fn::createMerchant({
  space: $space,
  key: "valr",
  name: "VALR",
  normalizedName: "VALR",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_b_peters = fn::createMerchant({
  space: $space,
  key: "b-peters",
  name: "B Peters",
  normalizedName: "B Peters",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_sansor = fn::createMerchant({
  space: $space,
  key: "sansor",
  name: "Sansor",
  normalizedName: "Sansor",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "Mpire Digital Market",
  normalizedName: "Mpire Digital Market",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_paypal_elite = fn::createMerchant({
  space: $space,
  key: "paypal-elite",
  name: "PayPal / Elite",
  normalizedName: "PayPal / Elite",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_google_workspace = fn::createMerchant({
  space: $space,
  key: "google-workspace",
  name: "Google Workspace",
  normalizedName: "Google Workspace",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_outsurance = fn::createMerchant({
  space: $space,
  key: "outsurance",
  name: "Outsurance",
  normalizedName: "Outsurance",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_wise = fn::createMerchant({
  space: $space,
  key: "wise",
  name: "Wise",
  normalizedName: "Wise",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_fnb_paypal = fn::createMerchant({
  space: $space,
  key: "fnb-paypal",
  name: "FNB / PayPal",
  normalizedName: "FNB / PayPal",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_paypal_ivec = fn::createMerchant({
  space: $space,
  key: "paypal-ivec",
  name: "PayPal / Ivec",
  normalizedName: "PayPal / Ivec",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_openai = fn::createMerchant({
  space: $space,
  key: "openai",
  name: "OpenAI",
  normalizedName: "OpenAI",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_afrihost = fn::createMerchant({
  space: $space,
  key: "afrihost",
  name: "Afrihost",
  normalizedName: "Afrihost",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_diamatrix = fn::createMerchant({
  space: $space,
  key: "diamatrix",
  name: "Diamatrix",
  normalizedName: "Diamatrix",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2026-02-19T00:00:00Z",
  description: "Magtape Unpaid",
  normalizedDescription: "FNB / Magtape",
  amount: 774.86,
  balance: 912.8,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 1,
    rawRowText: "Magtape Unpaid; Not Provided For; 774.86 Cr; 912.80 Cr",
    transactionType: "reversal",
    normalizedMerchant: "FNB / Magtape",
    category: "Reversal / refund",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 774.86,
    bankChargeZar: null,
    balanceZar: 912.8
},
  notes: "Likely returned item / reversal; keep raw wording."
});
LET $tx_stmt_2026_03_18_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-01",
  sourceRow: $row_row_01,
  postedAt: "2026-02-19T00:00:00Z",
  description: "Magtape Unpaid",
  normalizedDescription: "FNB / Magtape",
  amount: 774.86,
  balance: 912.8,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB / Magtape",
  merchant: $merchant_fnb_magtape,
  category: $cat_reversal_refund,
  isTransfer: false,
  manualOverride: false,
  notes: "Likely returned item / reversal; keep raw wording."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2026_03_18_row_01.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_01.id, "TransactionMerchant", $merchant_fnb_magtape.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_01.id, "TransactionCategory", $cat_reversal_refund.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_18_row_01 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-18-row-01",
  transaction: $tx_stmt_2026_03_18_row_01,
  status: "open",
  question: "What exactly is the Magtape Unpaid / Not Provided For reversal?",
  reason: "Returned item / reversal needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb_magtape,
  suggestedCategory: $cat_reversal_refund,
  confidence: 0.25,
  notes: "Imported from 2026-03-18.import.md"
});
fn::createEdge($tx_stmt_2026_03_18_row_01.id, "TransactionClarificationTasks", $task_stmt_2026_03_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2026-02-19T00:00:00Z",
  description: "#Item Unpaid No Funds 03",
  normalizedDescription: "Unpaid Item Fee",
  amount: 6,
  balance: 906.8,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 2,
    rawRowText: "#Item Unpaid No Funds 03; 6.00; 906.80 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "unpaid item fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 906.8
},
  notes: "Bank fee for unpaid item."
});
LET $tx_stmt_2026_03_18_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-02",
  sourceRow: $row_row_02,
  postedAt: "2026-02-19T00:00:00Z",
  description: "#Item Unpaid No Funds 03",
  normalizedDescription: "Unpaid Item Fee",
  amount: 6,
  balance: 906.8,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_unpaid_item_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Bank fee for unpaid item."
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2026_03_18_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_02.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_02.id, "TransactionCategory", $cat_fees_unpaid_item_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2026-02-19T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 406.8,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 3,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 16 Feb; 500.00; 406.80 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 500,
    bankChargeZar: 3.68,
    balanceZar: 406.8
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2026_03_18_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-03",
  sourceRow: $row_row_03,
  postedAt: "2026-02-19T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 406.8,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: "Crypto / trading spend."
});
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2026_03_18_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_03.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_03.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2026-02-20T00:00:00Z",
  description: "#Excess Item Fee 1 Items On 26/02/19",
  normalizedDescription: "Excess Item Fee",
  amount: 155,
  balance: 251.8,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 4,
    rawRowText: "#Excess Item Fee 1 Items On 26/02/19; 155.00; 251.80 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "excess item fee",
    clarificationStatus: "clarified",
    amountZar: 155,
    bankChargeZar: null,
    balanceZar: 251.8
},
  notes: "Bank fee."
});
LET $tx_stmt_2026_03_18_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-04",
  sourceRow: $row_row_04,
  postedAt: "2026-02-20T00:00:00Z",
  description: "#Excess Item Fee 1 Items On 26/02/19",
  normalizedDescription: "Excess Item Fee",
  amount: 155,
  balance: 251.8,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_excess_item_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Bank fee."
});
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2026_03_18_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_04.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_04.id, "TransactionCategory", $cat_fees_excess_item_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2026-02-24T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 400,
  balance: 148.2,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 5,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 20 Feb; 400.00; 148.20; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 400,
    bankChargeZar: 3.68,
    balanceZar: 148.2
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2026_03_18_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-05",
  sourceRow: $row_row_05,
  postedAt: "2026-02-24T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 400,
  balance: 148.2,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: "Crypto / trading spend."
});
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2026_03_18_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_05.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_05.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2026-02-25T00:00:00Z",
  description: "#Excess Item Fee 1 Items On 26/02/24",
  normalizedDescription: "Excess Item Fee",
  amount: 155,
  balance: 155,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 6,
    rawRowText: "#Excess Item Fee 1 Items On 26/02/24; 155.00; 303.20",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "excess item fee",
    clarificationStatus: "clarified",
    amountZar: 155,
    bankChargeZar: null,
    balanceZar: 155
},
  notes: "Bank fee."
});
LET $tx_stmt_2026_03_18_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-06",
  sourceRow: $row_row_06,
  postedAt: "2026-02-25T00:00:00Z",
  description: "#Excess Item Fee 1 Items On 26/02/24",
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
  notes: "Bank fee."
});
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2026_03_18_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_06.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_06.id, "TransactionCategory", $cat_fees_excess_item_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2026-02-25T00:00:00Z",
  description: "Magtape Credit B Peters",
  normalizedDescription: "B Peters",
  amount: 25000,
  balance: 24696.8,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 7,
    rawRowText: "Magtape Credit B Peters; 25,000.00 Cr; 24,696.80 Cr",
    transactionType: "income",
    normalizedMerchant: "B Peters",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 25000,
    bankChargeZar: null,
    balanceZar: 24696.8
},
  notes: "Confirmed business income."
});
LET $tx_stmt_2026_03_18_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-07",
  sourceRow: $row_row_07,
  postedAt: "2026-02-25T00:00:00Z",
  description: "Magtape Credit B Peters",
  normalizedDescription: "B Peters",
  amount: 25000,
  balance: 24696.8,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2026_03_18_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_07.id, "TransactionMerchant", $merchant_b_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_07.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2026-02-26T00:00:00Z",
  description: "FNB OB Pmt Sansor Inv-127612",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 31546.8,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 8,
    rawRowText: "FNB OB Pmt Sansor Inv-127612; 6,850.00 Cr; 31,546.80 Cr",
    transactionType: "income",
    normalizedMerchant: "Sansor",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6850,
    bankChargeZar: null,
    balanceZar: 31546.8
},
  notes: "Monthly customer retainer / recurring payment."
});
LET $tx_stmt_2026_03_18_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-08",
  sourceRow: $row_row_08,
  postedAt: "2026-02-26T00:00:00Z",
  description: "FNB OB Pmt Sansor Inv-127612",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 31546.8,
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2026_03_18_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_08.id, "TransactionMerchant", $merchant_sansor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_08.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2026-02-27T00:00:00Z",
  description: "Internet Pmt To Supplier Michael Pet",
  normalizedDescription: "Mpire Digital Market",
  amount: 27000,
  balance: 4546.8,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 9,
    rawRowText: "Internet Pmt To Supplier Michael Pet; Mpire Digital Market; 27,000.00; 4,546.80 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 27000,
    bankChargeZar: null,
    balanceZar: 4546.8
},
  notes: "Likely internal transfer; confirm destination/account later."
});
LET $tx_stmt_2026_03_18_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-09",
  sourceRow: $row_row_09,
  postedAt: "2026-02-27T00:00:00Z",
  description: "Internet Pmt To Supplier Michael Pet",
  normalizedDescription: "Mpire Digital Market",
  amount: 27000,
  balance: 4546.8,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Mpire Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Likely internal transfer; confirm destination/account later."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2026_03_18_row_09.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_09.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_09.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_18_row_09 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-18-row-09",
  transaction: $tx_stmt_2026_03_18_row_09,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_transfer,
  confidence: 0.25,
  notes: "Imported from 2026-03-18.import.md"
});
fn::createEdge($tx_stmt_2026_03_18_row_09.id, "TransactionClarificationTasks", $task_stmt_2026_03_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2026-02-27T00:00:00Z",
  description: "Magtape Credit B Peters",
  normalizedDescription: "B Peters",
  amount: 5000,
  balance: 9546.8,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 10,
    rawRowText: "Magtape Credit B Peters; 5,000.00 Cr; 9,546.80 Cr",
    transactionType: "income",
    normalizedMerchant: "B Peters",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 5000,
    bankChargeZar: null,
    balanceZar: 9546.8
},
  notes: "Confirmed business income."
});
LET $tx_stmt_2026_03_18_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-10",
  sourceRow: $row_row_10,
  postedAt: "2026-02-27T00:00:00Z",
  description: "Magtape Credit B Peters",
  normalizedDescription: "B Peters",
  amount: 5000,
  balance: 9546.8,
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2026_03_18_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_10.id, "TransactionMerchant", $merchant_b_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_10.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2026-02-27T00:00:00Z",
  description: "Magtape Credit B Peters",
  normalizedDescription: "B Peters",
  amount: 20000,
  balance: 29546.8,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 11,
    rawRowText: "Magtape Credit B Peters; 20,000.00 Cr; 29,546.80 Cr",
    transactionType: "income",
    normalizedMerchant: "B Peters",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 20000,
    bankChargeZar: null,
    balanceZar: 29546.8
},
  notes: "Confirmed business income."
});
LET $tx_stmt_2026_03_18_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-11",
  sourceRow: $row_row_11,
  postedAt: "2026-02-27T00:00:00Z",
  description: "Magtape Credit B Peters",
  normalizedDescription: "B Peters",
  amount: 20000,
  balance: 29546.8,
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2026_03_18_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_11.id, "TransactionMerchant", $merchant_b_peters.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_11.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2026-02-28T00:00:00Z",
  description: "POS Purchase 57.83 Paypal *Elite",
  normalizedDescription: "PayPal / Elite",
  amount: 57.83,
  balance: 29488.97,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 12,
    rawRowText: "POS Purchase 57.83 Paypal *Elite; 485442*7050 26 Feb; 57.83; 29,488.97 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal / Elite",
    category: "Online services",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 57.83,
    bankChargeZar: 3.68,
    balanceZar: 29488.97
},
  notes: "Underlying PayPal purchase still needs a later pass."
});
LET $tx_stmt_2026_03_18_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-12",
  sourceRow: $row_row_12,
  postedAt: "2026-02-28T00:00:00Z",
  description: "POS Purchase 57.83 Paypal *Elite",
  normalizedDescription: "PayPal / Elite",
  amount: 57.83,
  balance: 29488.97,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal / Elite",
  merchant: $merchant_paypal_elite,
  category: $cat_online_services,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs a later pass."
});
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2026_03_18_row_12.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_12.id, "TransactionMerchant", $merchant_paypal_elite.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_12.id, "TransactionCategory", $cat_online_services.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_18_row_12 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-18-row-12",
  transaction: $tx_stmt_2026_03_18_row_12,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal / Elite charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal_elite,
  suggestedCategory: $cat_online_services,
  confidence: 0.25,
  notes: "Imported from 2026-03-18.import.md"
});
fn::createEdge($tx_stmt_2026_03_18_row_12.id, "TransactionClarificationTasks", $task_stmt_2026_03_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2026-02-28T00:00:00Z",
  description: "POS Purchase 57.83 Paypal *Elite",
  normalizedDescription: "PayPal / Elite",
  amount: 57.83,
  balance: 29431.14,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 13,
    rawRowText: "POS Purchase 57.83 Paypal *Elite; 485442*7050 26 Feb; 57.83; 29,431.14 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal / Elite",
    category: "Online services",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 57.83,
    bankChargeZar: 3.68,
    balanceZar: 29431.14
},
  notes: "Underlying PayPal purchase still needs a later pass."
});
LET $tx_stmt_2026_03_18_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-13",
  sourceRow: $row_row_13,
  postedAt: "2026-02-28T00:00:00Z",
  description: "POS Purchase 57.83 Paypal *Elite",
  normalizedDescription: "PayPal / Elite",
  amount: 57.83,
  balance: 29431.14,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal / Elite",
  merchant: $merchant_paypal_elite,
  category: $cat_online_services,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs a later pass."
});
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2026_03_18_row_13.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_13.id, "TransactionMerchant", $merchant_paypal_elite.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_13.id, "TransactionCategory", $cat_online_services.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_18_row_13 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-18-row-13",
  transaction: $tx_stmt_2026_03_18_row_13,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal / Elite charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal_elite,
  suggestedCategory: $cat_online_services,
  confidence: 0.25,
  notes: "Imported from 2026-03-18.import.md"
});
fn::createEdge($tx_stmt_2026_03_18_row_13.id, "TransactionClarificationTasks", $task_stmt_2026_03_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2026-02-28T00:00:00Z",
  description: "POS Purchase 272.13 Paypal *Elit",
  normalizedDescription: "PayPal / Elite",
  amount: 272.13,
  balance: 29159.01,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 14,
    rawRowText: "POS Purchase 272.13 Paypal *Elit; 485442*7050 26 Feb; 272.13; 29,159.01 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal / Elite",
    category: "Online services",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 272.13,
    bankChargeZar: 3.68,
    balanceZar: 29159.01
},
  notes: "Underlying PayPal purchase still needs a later pass."
});
LET $tx_stmt_2026_03_18_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-14",
  sourceRow: $row_row_14,
  postedAt: "2026-02-28T00:00:00Z",
  description: "POS Purchase 272.13 Paypal *Elit",
  normalizedDescription: "PayPal / Elite",
  amount: 272.13,
  balance: 29159.01,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal / Elite",
  merchant: $merchant_paypal_elite,
  category: $cat_online_services,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs a later pass."
});
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2026_03_18_row_14.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_14.id, "TransactionMerchant", $merchant_paypal_elite.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_14.id, "TransactionCategory", $cat_online_services.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_18_row_14 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-18-row-14",
  transaction: $tx_stmt_2026_03_18_row_14,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal / Elite charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal_elite,
  suggestedCategory: $cat_online_services,
  confidence: 0.25,
  notes: "Imported from 2026-03-18.import.md"
});
fn::createEdge($tx_stmt_2026_03_18_row_14.id, "TransactionClarificationTasks", $task_stmt_2026_03_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2026-02-28T00:00:00Z",
  description: "POS Purchase 272.13 Paypal *Elit",
  normalizedDescription: "PayPal / Elite",
  amount: 272.13,
  balance: 28886.88,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 15,
    rawRowText: "POS Purchase 272.13 Paypal *Elit; 485442*7050 26 Feb; 272.13; 28,886.88 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal / Elite",
    category: "Online services",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 272.13,
    bankChargeZar: 3.68,
    balanceZar: 28886.88
},
  notes: "Underlying PayPal purchase still needs a later pass."
});
LET $tx_stmt_2026_03_18_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-15",
  sourceRow: $row_row_15,
  postedAt: "2026-02-28T00:00:00Z",
  description: "POS Purchase 272.13 Paypal *Elit",
  normalizedDescription: "PayPal / Elite",
  amount: 272.13,
  balance: 28886.88,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal / Elite",
  merchant: $merchant_paypal_elite,
  category: $cat_online_services,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs a later pass."
});
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2026_03_18_row_15.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_15.id, "TransactionMerchant", $merchant_paypal_elite.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_15.id, "TransactionCategory", $cat_online_services.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_18_row_15 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-18-row-15",
  transaction: $tx_stmt_2026_03_18_row_15,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal / Elite charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal_elite,
  suggestedCategory: $cat_online_services,
  confidence: 0.25,
  notes: "Imported from 2026-03-18.import.md"
});
fn::createEdge($tx_stmt_2026_03_18_row_15.id, "TransactionClarificationTasks", $task_stmt_2026_03_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2026-02-28T00:00:00Z",
  description: "POS Purchase 16.88 Google Worksp",
  normalizedDescription: "Google Workspace",
  amount: 325.92,
  balance: 28560.96,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 16,
    rawRowText: "POS Purchase 16.88 Google Worksp; 485442*7050 26 Feb; 325.92; 28,560.96 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Google Workspace",
    category: "Software / hosting",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 325.92,
    bankChargeZar: 3.68,
    balanceZar: 28560.96
},
  notes: "Hosting / software expense."
});
LET $tx_stmt_2026_03_18_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-16",
  sourceRow: $row_row_16,
  postedAt: "2026-02-28T00:00:00Z",
  description: "POS Purchase 16.88 Google Worksp",
  normalizedDescription: "Google Workspace",
  amount: 325.92,
  balance: 28560.96,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Google Workspace",
  merchant: $merchant_google_workspace,
  category: $cat_software_hosting,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting / software expense."
});
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2026_03_18_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_16.id, "TransactionMerchant", $merchant_google_workspace.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_16.id, "TransactionCategory", $cat_software_hosting.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2026-02-28T00:00:00Z",
  description: "POS Purchase 420.28 Paypal *Elit",
  normalizedDescription: "PayPal / Elite",
  amount: 420.28,
  balance: 28140.68,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 17,
    rawRowText: "POS Purchase 420.28 Paypal *Elit; 485442*7050 26 Feb; 420.28; 28,140.68 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal / Elite",
    category: "Online services",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 420.28,
    bankChargeZar: 3.68,
    balanceZar: 28140.68
},
  notes: "Underlying PayPal purchase still needs a later pass."
});
LET $tx_stmt_2026_03_18_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-17",
  sourceRow: $row_row_17,
  postedAt: "2026-02-28T00:00:00Z",
  description: "POS Purchase 420.28 Paypal *Elit",
  normalizedDescription: "PayPal / Elite",
  amount: 420.28,
  balance: 28140.68,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal / Elite",
  merchant: $merchant_paypal_elite,
  category: $cat_online_services,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs a later pass."
});
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2026_03_18_row_17.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_17.id, "TransactionMerchant", $merchant_paypal_elite.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_17.id, "TransactionCategory", $cat_online_services.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_18_row_17 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-18-row-17",
  transaction: $tx_stmt_2026_03_18_row_17,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal / Elite charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal_elite,
  suggestedCategory: $cat_online_services,
  confidence: 0.25,
  notes: "Imported from 2026-03-18.import.md"
});
fn::createEdge($tx_stmt_2026_03_18_row_17.id, "TransactionClarificationTasks", $task_stmt_2026_03_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2026-03-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet",
  normalizedDescription: "Mpire Digital Market",
  amount: 15000,
  balance: 13140.68,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 18,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet; Mpire Digital Market; 15,000.00; 13,140.68 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Transfer",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 15000,
    bankChargeZar: 15,
    balanceZar: 13140.68
},
  notes: "Likely internal transfer; confirm destination/account later."
});
LET $tx_stmt_2026_03_18_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-18",
  sourceRow: $row_row_18,
  postedAt: "2026-03-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet",
  normalizedDescription: "Mpire Digital Market",
  amount: 15000,
  balance: 13140.68,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Mpire Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Likely internal transfer; confirm destination/account later."
});
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2026_03_18_row_18.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_18.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_18.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_18_row_18 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-18-row-18",
  transaction: $tx_stmt_2026_03_18_row_18,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_transfer,
  confidence: 0.25,
  notes: "Imported from 2026-03-18.import.md"
});
fn::createEdge($tx_stmt_2026_03_18_row_18.id, "TransactionClarificationTasks", $task_stmt_2026_03_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2026-03-02T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Ql2477",
  normalizedDescription: "Outsurance",
  amount: 774.86,
  balance: 12365.82,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 19,
    rawRowText: "Magtape Debit Outsurance Ot87677302 Ql2477; 774.86; 12,365.82 Cr; 12.00",
    transactionType: "expense",
    normalizedMerchant: "Outsurance",
    category: "Insurance",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 774.86,
    bankChargeZar: 12,
    balanceZar: 12365.82
},
  notes: "Insurance expense."
});
LET $tx_stmt_2026_03_18_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-19",
  sourceRow: $row_row_19,
  postedAt: "2026-03-02T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Ql2477",
  normalizedDescription: "Outsurance",
  amount: 774.86,
  balance: 12365.82,
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
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2026_03_18_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_19.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_19.id, "TransactionCategory", $cat_insurance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2026-03-02T00:00:00Z",
  description: "POS Purchase 74.14 Wise",
  normalizedDescription: "Wise",
  amount: 1647.79,
  balance: 10718.03,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 20,
    rawRowText: "POS Purchase 74.14 Wise; 485442*7050 27 Feb; 1,647.79; 10,718.03 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Wise",
    category: "Transfer services",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 1647.79,
    bankChargeZar: 3.68,
    balanceZar: 10718.03
},
  notes: "Wise spend / transfer rail; confirm exact purpose later."
});
LET $tx_stmt_2026_03_18_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-20",
  sourceRow: $row_row_20,
  postedAt: "2026-03-02T00:00:00Z",
  description: "POS Purchase 74.14 Wise",
  normalizedDescription: "Wise",
  amount: 1647.79,
  balance: 10718.03,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Wise",
  merchant: $merchant_wise,
  category: $cat_transfer_services,
  isTransfer: false,
  manualOverride: false,
  notes: "Wise spend / transfer rail; confirm exact purpose later."
});
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2026_03_18_row_20.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_20.id, "TransactionMerchant", $merchant_wise.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_20.id, "TransactionCategory", $cat_transfer_services.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_18_row_20 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-18-row-20",
  transaction: $tx_stmt_2026_03_18_row_20,
  status: "open",
  question: "What was the purpose of this Wise spend or transfer?",
  reason: "Wise spend or transfer rail needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_wise,
  suggestedCategory: $cat_transfer_services,
  confidence: 0.25,
  notes: "Imported from 2026-03-18.import.md"
});
fn::createEdge($tx_stmt_2026_03_18_row_20.id, "TransactionClarificationTasks", $task_stmt_2026_03_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2026-03-03T00:00:00Z",
  description: "#Service Fees #Int Pymt Fee-57.83 Payp",
  normalizedDescription: "Paypal Payment Fee",
  amount: 1.3,
  balance: 10716.73,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 21,
    rawRowText: "#Service Fees #Int Pymt Fee-57.83 Payp; 1.30; 10,716.73 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB / PayPal",
    category: "Fees",
    feeType: "paypal payment fee",
    clarificationStatus: "clarified",
    amountZar: 1.3,
    bankChargeZar: null,
    balanceZar: 10716.73
},
  notes: "Fee tied to PayPal payment."
});
LET $tx_stmt_2026_03_18_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-21",
  sourceRow: $row_row_21,
  postedAt: "2026-03-03T00:00:00Z",
  description: "#Service Fees #Int Pymt Fee-57.83 Payp",
  normalizedDescription: "Paypal Payment Fee",
  amount: 1.3,
  balance: 10716.73,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB / PayPal",
  merchant: $merchant_fnb_paypal,
  category: $cat_fees_paypal_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Fee tied to PayPal payment."
});
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2026_03_18_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_21.id, "TransactionMerchant", $merchant_fnb_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_21.id, "TransactionCategory", $cat_fees_paypal_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2026-03-03T00:00:00Z",
  description: "#Service Fees #Int Pymt Fee-57.83 Payp",
  normalizedDescription: "Paypal Payment Fee",
  amount: 1.3,
  balance: 10715.43,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 22,
    rawRowText: "#Service Fees #Int Pymt Fee-57.83 Payp; 1.30; 10,715.43 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB / PayPal",
    category: "Fees",
    feeType: "paypal payment fee",
    clarificationStatus: "clarified",
    amountZar: 1.3,
    bankChargeZar: null,
    balanceZar: 10715.43
},
  notes: "Fee tied to PayPal payment."
});
LET $tx_stmt_2026_03_18_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-22",
  sourceRow: $row_row_22,
  postedAt: "2026-03-03T00:00:00Z",
  description: "#Service Fees #Int Pymt Fee-57.83 Payp",
  normalizedDescription: "Paypal Payment Fee",
  amount: 1.3,
  balance: 10715.43,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB / PayPal",
  merchant: $merchant_fnb_paypal,
  category: $cat_fees_paypal_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Fee tied to PayPal payment."
});
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2026_03_18_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_22.id, "TransactionMerchant", $merchant_fnb_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_22.id, "TransactionCategory", $cat_fees_paypal_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2026-03-03T00:00:00Z",
  description: "#Service Fees #Int Pymt Fee-272.13 Payp",
  normalizedDescription: "Paypal Payment Fee",
  amount: 6.12,
  balance: 10709.31,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 23,
    rawRowText: "#Service Fees #Int Pymt Fee-272.13 Payp; 6.12; 10,709.31 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB / PayPal",
    category: "Fees",
    feeType: "paypal payment fee",
    clarificationStatus: "clarified",
    amountZar: 6.12,
    bankChargeZar: null,
    balanceZar: 10709.31
},
  notes: "Fee tied to PayPal payment."
});
LET $tx_stmt_2026_03_18_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-23",
  sourceRow: $row_row_23,
  postedAt: "2026-03-03T00:00:00Z",
  description: "#Service Fees #Int Pymt Fee-272.13 Payp",
  normalizedDescription: "Paypal Payment Fee",
  amount: 6.12,
  balance: 10709.31,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB / PayPal",
  merchant: $merchant_fnb_paypal,
  category: $cat_fees_paypal_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Fee tied to PayPal payment."
});
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2026_03_18_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_23.id, "TransactionMerchant", $merchant_fnb_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_23.id, "TransactionCategory", $cat_fees_paypal_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2026-03-03T00:00:00Z",
  description: "#Service Fees #Int Pymt Fee-272.13 Payp",
  normalizedDescription: "Paypal Payment Fee",
  amount: 6.12,
  balance: 10703.19,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 24,
    rawRowText: "#Service Fees #Int Pymt Fee-272.13 Payp; 6.12; 10,703.19 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB / PayPal",
    category: "Fees",
    feeType: "paypal payment fee",
    clarificationStatus: "clarified",
    amountZar: 6.12,
    bankChargeZar: null,
    balanceZar: 10703.19
},
  notes: "Fee tied to PayPal payment."
});
LET $tx_stmt_2026_03_18_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-24",
  sourceRow: $row_row_24,
  postedAt: "2026-03-03T00:00:00Z",
  description: "#Service Fees #Int Pymt Fee-272.13 Payp",
  normalizedDescription: "Paypal Payment Fee",
  amount: 6.12,
  balance: 10703.19,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB / PayPal",
  merchant: $merchant_fnb_paypal,
  category: $cat_fees_paypal_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Fee tied to PayPal payment."
});
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2026_03_18_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_24.id, "TransactionMerchant", $merchant_fnb_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_24.id, "TransactionCategory", $cat_fees_paypal_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2026-03-03T00:00:00Z",
  description: "#Service Fees #Int Pymt Fee-420.28 Payp",
  normalizedDescription: "Paypal Payment Fee",
  amount: 9.46,
  balance: 10693.73,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 25,
    rawRowText: "#Service Fees #Int Pymt Fee-420.28 Payp; 9.46; 10,693.73 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB / PayPal",
    category: "Fees",
    feeType: "paypal payment fee",
    clarificationStatus: "clarified",
    amountZar: 9.46,
    bankChargeZar: null,
    balanceZar: 10693.73
},
  notes: "Fee tied to PayPal payment."
});
LET $tx_stmt_2026_03_18_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-25",
  sourceRow: $row_row_25,
  postedAt: "2026-03-03T00:00:00Z",
  description: "#Service Fees #Int Pymt Fee-420.28 Payp",
  normalizedDescription: "Paypal Payment Fee",
  amount: 9.46,
  balance: 10693.73,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB / PayPal",
  merchant: $merchant_fnb_paypal,
  category: $cat_fees_paypal_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Fee tied to PayPal payment."
});
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2026_03_18_row_25.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_25.id, "TransactionMerchant", $merchant_fnb_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_25.id, "TransactionCategory", $cat_fees_paypal_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2026-03-03T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 9693.73,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 26,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 27 Feb; 1,000.00; 9,693.73 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: 3.68,
    balanceZar: 9693.73
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2026_03_18_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-26",
  sourceRow: $row_row_26,
  postedAt: "2026-03-03T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 9693.73,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: "Crypto / trading spend."
});
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2026_03_18_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_26.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_26.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2026-03-03T00:00:00Z",
  description: "POS Purchase 1.01 Google Workspa",
  normalizedDescription: "Google Workspace",
  amount: 19.55,
  balance: 9674.18,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 27,
    rawRowText: "POS Purchase 1.01 Google Workspa; 485442*7050 01 Mar; 19.55; 9,674.18 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Google Workspace",
    category: "Software / hosting",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 19.55,
    bankChargeZar: 3.68,
    balanceZar: 9674.18
},
  notes: "Hosting / software expense."
});
LET $tx_stmt_2026_03_18_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-27",
  sourceRow: $row_row_27,
  postedAt: "2026-03-03T00:00:00Z",
  description: "POS Purchase 1.01 Google Workspa",
  normalizedDescription: "Google Workspace",
  amount: 19.55,
  balance: 9674.18,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Google Workspace",
  merchant: $merchant_google_workspace,
  category: $cat_software_hosting,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting / software expense."
});
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2026_03_18_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_27.id, "TransactionMerchant", $merchant_google_workspace.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_27.id, "TransactionCategory", $cat_software_hosting.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2026-03-03T00:00:00Z",
  description: "POS Purchase 271.36 Paypal *Ivec",
  normalizedDescription: "PayPal / Ivec",
  amount: 271.36,
  balance: 9402.82,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 28,
    rawRowText: "POS Purchase 271.36 Paypal *Ivec; 485442*7050 01 Mar; 271.36; 9,402.82 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal / Ivec",
    category: "Online services",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 271.36,
    bankChargeZar: 3.68,
    balanceZar: 9402.82
},
  notes: "Underlying PayPal purchase still needs a later pass."
});
LET $tx_stmt_2026_03_18_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-28",
  sourceRow: $row_row_28,
  postedAt: "2026-03-03T00:00:00Z",
  description: "POS Purchase 271.36 Paypal *Ivec",
  normalizedDescription: "PayPal / Ivec",
  amount: 271.36,
  balance: 9402.82,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal / Ivec",
  merchant: $merchant_paypal_ivec,
  category: $cat_online_services,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs a later pass."
});
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2026_03_18_row_28.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_28.id, "TransactionMerchant", $merchant_paypal_ivec.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_28.id, "TransactionCategory", $cat_online_services.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_18_row_28 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-18-row-28",
  transaction: $tx_stmt_2026_03_18_row_28,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal / Ivec charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal_ivec,
  suggestedCategory: $cat_online_services,
  confidence: 0.25,
  notes: "Imported from 2026-03-18.import.md"
});
fn::createEdge($tx_stmt_2026_03_18_row_28.id, "TransactionClarificationTasks", $task_stmt_2026_03_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2026-03-03T00:00:00Z",
  description: "POS Purchase 73.66 Wise",
  normalizedDescription: "Wise",
  amount: 1628.06,
  balance: 7774.76,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 29,
    rawRowText: "POS Purchase 73.66 Wise; 485442*7050 02 Mar; 1,628.06; 7,774.76 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Wise",
    category: "Transfer services",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 1628.06,
    bankChargeZar: 3.68,
    balanceZar: 7774.76
},
  notes: "Wise spend / transfer rail; confirm exact purpose later."
});
LET $tx_stmt_2026_03_18_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-29",
  sourceRow: $row_row_29,
  postedAt: "2026-03-03T00:00:00Z",
  description: "POS Purchase 73.66 Wise",
  normalizedDescription: "Wise",
  amount: 1628.06,
  balance: 7774.76,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Wise",
  merchant: $merchant_wise,
  category: $cat_transfer_services,
  isTransfer: false,
  manualOverride: false,
  notes: "Wise spend / transfer rail; confirm exact purpose later."
});
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2026_03_18_row_29.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_29.id, "TransactionMerchant", $merchant_wise.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_29.id, "TransactionCategory", $cat_transfer_services.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_18_row_29 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-18-row-29",
  transaction: $tx_stmt_2026_03_18_row_29,
  status: "open",
  question: "What was the purpose of this Wise spend or transfer?",
  reason: "Wise spend or transfer rail needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_wise,
  suggestedCategory: $cat_transfer_services,
  confidence: 0.25,
  notes: "Imported from 2026-03-18.import.md"
});
fn::createEdge($tx_stmt_2026_03_18_row_29.id, "TransactionClarificationTasks", $task_stmt_2026_03_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2026-03-03T00:00:00Z",
  description: "POS Purchase 230.00 Openai *Chat",
  normalizedDescription: "OpenAI",
  amount: 3774.71,
  balance: 4000.05,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 30,
    rawRowText: "POS Purchase 230.00 Openai *Chat; 485442*7050 01 Mar; 3,774.71; 4,000.05 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "OpenAI",
    category: "AI / software",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 3774.71,
    bankChargeZar: 3.68,
    balanceZar: 4000.05
},
  notes: "AI / software expense."
});
LET $tx_stmt_2026_03_18_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-30",
  sourceRow: $row_row_30,
  postedAt: "2026-03-03T00:00:00Z",
  description: "POS Purchase 230.00 Openai *Chat",
  normalizedDescription: "OpenAI",
  amount: 3774.71,
  balance: 4000.05,
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
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2026_03_18_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_30.id, "TransactionMerchant", $merchant_openai.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_30.id, "TransactionCategory", $cat_ai_software.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2026-03-04T00:00:00Z",
  description: "POS Purchase Afrihost.Com",
  normalizedDescription: "Afrihost",
  amount: 419,
  balance: 3581.05,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 31,
    rawRowText: "POS Purchase Afrihost.Com; 485442*7050 01 Mar; 419.00; 3,581.05 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Afrihost",
    category: "Software / hosting",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 419,
    bankChargeZar: 3.68,
    balanceZar: 3581.05
},
  notes: "Hosting expense."
});
LET $tx_stmt_2026_03_18_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-31",
  sourceRow: $row_row_31,
  postedAt: "2026-03-04T00:00:00Z",
  description: "POS Purchase Afrihost.Com",
  normalizedDescription: "Afrihost",
  amount: 419,
  balance: 3581.05,
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
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2026_03_18_row_31.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_31.id, "TransactionMerchant", $merchant_afrihost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_31.id, "TransactionCategory", $cat_software_hosting.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2026-03-04T00:00:00Z",
  description: "POS Purchase Diamatrix",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 3053.05,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 32,
    rawRowText: "POS Purchase Diamatrix; 485442*7050 01 Mar; 528.00; 3,053.05 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Diamatrix",
    category: "Software / hosting",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 528,
    bankChargeZar: 3.68,
    balanceZar: 3053.05
},
  notes: "Hosting / software expense."
});
LET $tx_stmt_2026_03_18_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-32",
  sourceRow: $row_row_32,
  postedAt: "2026-03-04T00:00:00Z",
  description: "POS Purchase Diamatrix",
  normalizedDescription: "Diamatrix",
  amount: 528,
  balance: 3053.05,
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
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2026_03_18_row_32.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_32.id, "TransactionMerchant", $merchant_diamatrix.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_32.id, "TransactionCategory", $cat_software_hosting.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2026-03-09T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 2053.05,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 33,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 05 Mar; 1,000.00; 2,053.05 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: 3.68,
    balanceZar: 2053.05
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2026_03_18_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-33",
  sourceRow: $row_row_33,
  postedAt: "2026-03-09T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 2053.05,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: "Crypto / trading spend."
});
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2026_03_18_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_33.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_33.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2026-03-10T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 1553.05,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 34,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 06 Mar; 500.00; 1,553.05 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 500,
    bankChargeZar: 3.68,
    balanceZar: 1553.05
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2026_03_18_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-34",
  sourceRow: $row_row_34,
  postedAt: "2026-03-10T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 1553.05,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: "Crypto / trading spend."
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2026_03_18_row_34.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_34.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_34.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2026-03-10T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 553.05,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 35,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 06 Mar; 1,000.00; 553.05 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: 3.68,
    balanceZar: 553.05
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2026_03_18_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-35",
  sourceRow: $row_row_35,
  postedAt: "2026-03-10T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 553.05,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: "Crypto / trading spend."
});
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2026_03_18_row_35.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_35.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_35.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2026-03-11T00:00:00Z",
  description: "#Service Fees #Int Pymt Fee-271.36 Payp",
  normalizedDescription: "Paypal Payment Fee",
  amount: 6.11,
  balance: 546.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 36,
    rawRowText: "#Service Fees #Int Pymt Fee-271.36 Payp; 6.11; 546.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB / PayPal",
    category: "Fees",
    feeType: "paypal payment fee",
    clarificationStatus: "clarified",
    amountZar: 6.11,
    bankChargeZar: null,
    balanceZar: 546.94
},
  notes: "Fee tied to PayPal payment."
});
LET $tx_stmt_2026_03_18_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-36",
  sourceRow: $row_row_36,
  postedAt: "2026-03-11T00:00:00Z",
  description: "#Service Fees #Int Pymt Fee-271.36 Payp",
  normalizedDescription: "Paypal Payment Fee",
  amount: 6.11,
  balance: 546.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB / PayPal",
  merchant: $merchant_fnb_paypal,
  category: $cat_fees_paypal_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Fee tied to PayPal payment."
});
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2026_03_18_row_36.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_36.id, "TransactionMerchant", $merchant_fnb_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_36.id, "TransactionCategory", $cat_fees_paypal_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 37
LET $row_row_37 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 37,
  postedAt: "2026-03-11T00:00:00Z",
  description: "#Debit Card Intl POS Unsuccess #Fee Declined Foreign Tr 4854422134327050",
  normalizedDescription: "Declined Foreign Card Fee",
  amount: 6,
  balance: 540.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 37,
    rawRowText: "#Debit Card Intl POS Unsuccess #Fee Declined Foreign Tr 4854422134327050; 6.00; 540.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "declined foreign card fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 540.94
},
  notes: "Declined foreign card fee."
});
LET $tx_stmt_2026_03_18_row_37 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-37",
  sourceRow: $row_row_37,
  postedAt: "2026-03-11T00:00:00Z",
  description: "#Debit Card Intl POS Unsuccess #Fee Declined Foreign Tr 4854422134327050",
  normalizedDescription: "Declined Foreign Card Fee",
  amount: 6,
  balance: 540.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_declined_foreign_card_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Declined foreign card fee."
});
fn::updateStatementRow($row_row_37.id, { transaction: $tx_stmt_2026_03_18_row_37.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_37.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_37.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_37.id, "TransactionCategory", $cat_fees_declined_foreign_card_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 38
LET $row_row_38 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 38,
  postedAt: "2026-03-12T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 250,
  balance: 290.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 38,
    rawRowText: "POS Purchase Valr Pty Ltd; 485442*7050 09 Mar; 250.00; 290.94 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 250,
    bankChargeZar: 3.68,
    balanceZar: 290.94
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2026_03_18_row_38 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-38",
  sourceRow: $row_row_38,
  postedAt: "2026-03-12T00:00:00Z",
  description: "POS Purchase Valr Pty Ltd",
  normalizedDescription: "VALR",
  amount: 250,
  balance: 290.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VALR",
  merchant: $merchant_valr,
  category: $cat_crypto_trading,
  isTransfer: false,
  manualOverride: false,
  notes: "Crypto / trading spend."
});
fn::updateStatementRow($row_row_38.id, { transaction: $tx_stmt_2026_03_18_row_38.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_38.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_38.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_38.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 39
LET $row_row_39 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 39,
  postedAt: "2026-03-13T00:00:00Z",
  description: "#Debit Card Intl POS Unsuccess #Fee Declined Foreign Tr 4854422134327050",
  normalizedDescription: "Declined Foreign Card Fee",
  amount: 6,
  balance: 284.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 39,
    rawRowText: "#Debit Card Intl POS Unsuccess #Fee Declined Foreign Tr 4854422134327050; 6.00; 284.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "declined foreign card fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 284.94
},
  notes: "Declined foreign card fee."
});
LET $tx_stmt_2026_03_18_row_39 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-39",
  sourceRow: $row_row_39,
  postedAt: "2026-03-13T00:00:00Z",
  description: "#Debit Card Intl POS Unsuccess #Fee Declined Foreign Tr 4854422134327050",
  normalizedDescription: "Declined Foreign Card Fee",
  amount: 6,
  balance: 284.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_declined_foreign_card_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Declined foreign card fee."
});
fn::updateStatementRow($row_row_39.id, { transaction: $tx_stmt_2026_03_18_row_39.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_39.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_39.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_39.id, "TransactionCategory", $cat_fees_declined_foreign_card_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 40
LET $row_row_40 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 40,
  postedAt: "2026-03-16T00:00:00Z",
  description: "#Debit Card Intl POS Unsuccess #Fee Declined Foreign Tr 4854422134327050",
  normalizedDescription: "Declined Foreign Card Fee",
  amount: 6,
  balance: 278.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 40,
    rawRowText: "#Debit Card Intl POS Unsuccess #Fee Declined Foreign Tr 4854422134327050; 6.00; 278.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "declined foreign card fee",
    clarificationStatus: "clarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 278.94
},
  notes: "Declined foreign card fee."
});
LET $tx_stmt_2026_03_18_row_40 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-40",
  sourceRow: $row_row_40,
  postedAt: "2026-03-16T00:00:00Z",
  description: "#Debit Card Intl POS Unsuccess #Fee Declined Foreign Tr 4854422134327050",
  normalizedDescription: "Declined Foreign Card Fee",
  amount: 6,
  balance: 278.94,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_declined_foreign_card_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Declined foreign card fee."
});
fn::updateStatementRow($row_row_40.id, { transaction: $tx_stmt_2026_03_18_row_40.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_40.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_40.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_40.id, "TransactionCategory", $cat_fees_declined_foreign_card_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 41
LET $row_row_41 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 41,
  postedAt: "2026-03-18T00:00:00Z",
  description: "Int On Debit Balance",
  normalizedDescription: "Debit Interest",
  amount: 0.09,
  balance: 278.85,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 41,
    rawRowText: "Int On Debit Balance; 0.09; 278.85 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "debit interest",
    clarificationStatus: "clarified",
    amountZar: 0.09,
    bankChargeZar: null,
    balanceZar: 278.85
},
  notes: "Interest on debit balance."
});
LET $tx_stmt_2026_03_18_row_41 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-41",
  sourceRow: $row_row_41,
  postedAt: "2026-03-18T00:00:00Z",
  description: "Int On Debit Balance",
  normalizedDescription: "Debit Interest",
  amount: 0.09,
  balance: 278.85,
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
fn::updateStatementRow($row_row_41.id, { transaction: $tx_stmt_2026_03_18_row_41.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_41.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_41.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_41.id, "TransactionCategory", $cat_fees_debit_interest.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 42
LET $row_row_42 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 42,
  postedAt: "2026-03-18T00:00:00Z",
  description: "Electronic Payments Bis/Int 1 On True Tiering = 5.00",
  normalizedDescription: "Electronic Payment Fee",
  amount: 0,
  balance: 278.85,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 42,
    rawRowText: "Electronic Payments Bis/Int 1 On True Tiering = 5.00; 0.00; 278.85 Cr; 5.00",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "electronic payment fee",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: 5,
    balanceZar: 278.85
},
  notes: "Zero-amount line with separate electronic payment fee."
});
LET $tx_stmt_2026_03_18_row_42 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-42",
  sourceRow: $row_row_42,
  postedAt: "2026-03-18T00:00:00Z",
  description: "Electronic Payments Bis/Int 1 On True Tiering = 5.00",
  normalizedDescription: "Electronic Payment Fee",
  amount: 0,
  balance: 278.85,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_electronic_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Zero-amount line with separate electronic payment fee."
});
fn::updateStatementRow($row_row_42.id, { transaction: $tx_stmt_2026_03_18_row_42.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_42.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_42.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_42.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 43
LET $row_row_43 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 43,
  postedAt: "2026-03-18T00:00:00Z",
  description: "#Monthly Account Fee",
  normalizedDescription: "Monthly Account Fee",
  amount: 93,
  balance: 185.85,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 43,
    rawRowText: "#Monthly Account Fee; 93.00; 185.85 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "monthly account fee",
    clarificationStatus: "clarified",
    amountZar: 93,
    bankChargeZar: null,
    balanceZar: 185.85
},
  notes: "Monthly account fee."
});
LET $tx_stmt_2026_03_18_row_43 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-43",
  sourceRow: $row_row_43,
  postedAt: "2026-03-18T00:00:00Z",
  description: "#Monthly Account Fee",
  normalizedDescription: "Monthly Account Fee",
  amount: 93,
  balance: 185.85,
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
fn::updateStatementRow($row_row_43.id, { transaction: $tx_stmt_2026_03_18_row_43.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_43.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_43.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_43.id, "TransactionCategory", $cat_fees_monthly_account_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 44
LET $row_row_44 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 44,
  postedAt: "2026-03-18T00:00:00Z",
  description: "#Service Fees",
  normalizedDescription: "Service Fee",
  amount: 105.6,
  balance: 80.25,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/18 March 2026.pdf",
    statementPeriodStart: "2026-02-18",
    statementPeriodEnd: "2026-03-18",
    rowNo: 44,
    rawRowText: "#Service Fees; 105.60; 80.25 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "service fee",
    clarificationStatus: "clarified",
    amountZar: 105.6,
    bankChargeZar: null,
    balanceZar: 80.25
},
  notes: "Statement service fees total."
});
LET $tx_stmt_2026_03_18_row_44 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-44",
  sourceRow: $row_row_44,
  postedAt: "2026-03-18T00:00:00Z",
  description: "#Service Fees",
  normalizedDescription: "Service Fee",
  amount: 105.6,
  balance: 80.25,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Statement service fees total."
});
fn::updateStatementRow($row_row_44.id, { transaction: $tx_stmt_2026_03_18_row_44.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_44.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_44.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_44.id, "TransactionCategory", $cat_fees_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 44,
  normalizedCount: 44,
  clarificationCount: 11,
  status: "matched",
  statementDate: "2026-03-18T00:00:00Z",
  notes: "Imported from 2026-03-18.import.md"
});

-- End of generated import
