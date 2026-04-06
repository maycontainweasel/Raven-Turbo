-- Generated from docs/statements/personal/credit/2026-02-19.import.md
-- Source: docs/statements/personal/credit/February 2026.pdf

USE NS raven DB raven1;

-- Base environment and account
LET $space = fn::createFinancialSpace({
  key: "personal",
  name: "Personal",
  spaceType: "personal",
  currency: "ZAR",
  active: true,
  description: "Personal banking, debt, savings, and transfer flows"
});
LET $account = fn::createAccount({
  space: $space,
  key: "nedbank-credit-08996",
  name: "Nedbank Credit Card",
  bankName: "Nedbank",
  accountType: "credit_card",
  currency: "ZAR",
  accountNumberLast4: "8996",
  openingBalance: 129346.04,
  active: true,
  notes: "Imported from February 2026.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2026-02-19-nedbank-credit",
  sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2026-02-19T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2026-02-19.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_debt_payment_reversal = fn::createCategory({
  space: $space,
  key: "debt-payment-reversal",
  name: "Debt payment reversal",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_education_children = fn::createCategory({
  space: $space,
  key: "education-children",
  name: "Education / children",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_subscription_media = fn::createCategory({
  space: $space,
  key: "subscription-media",
  name: "Subscription / media",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_crypto_trading = fn::createCategory({
  space: $space,
  key: "crypto-trading",
  name: "Crypto / trading",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_fuel_transport = fn::createCategory({
  space: $space,
  key: "fuel-transport",
  name: "Fuel / transport",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_dining_lifestyle = fn::createCategory({
  space: $space,
  key: "dining-lifestyle",
  name: "Dining / lifestyle",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_travel = fn::createCategory({
  space: $space,
  key: "travel",
  name: "Travel",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_groceries_household = fn::createCategory({
  space: $space,
  key: "groceries-household",
  name: "Groceries / household",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_cash_advance = fn::createCategory({
  space: $space,
  key: "cash-advance",
  name: "Cash advance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_fees_declined_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-declined-payment-fee",
  name: "Declined Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_fees_returned_apo_fee = fn::createCategory({
  space: $space,
  key: "fees-returned-apo-fee",
  name: "Returned Apo Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_fees_atm_cash_advance_fee = fn::createCategory({
  space: $space,
  key: "fees-atm-cash-advance-fee",
  name: "Atm Cash Advance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_fees_credit_facility_service_fee = fn::createCategory({
  space: $space,
  key: "fees-credit-facility-service-fee",
  name: "Credit Facility Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_fees_finance_charge = fn::createCategory({
  space: $space,
  key: "fees-finance-charge",
  name: "Finance Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});

-- Merchant records
LET $merchant_nedbank_current_account = fn::createMerchant({
  space: $space,
  key: "nedbank-current-account",
  name: "Nedbank Current Account",
  normalizedName: "Nedbank Current Account",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $merchant_bridge_house_school = fn::createMerchant({
  space: $space,
  key: "bridge-house-school",
  name: "Bridge House School",
  normalizedName: "Bridge House School",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $merchant_spotify = fn::createMerchant({
  space: $space,
  key: "spotify",
  name: "Spotify",
  normalizedName: "Spotify",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $merchant_showmax = fn::createMerchant({
  space: $space,
  key: "showmax",
  name: "Showmax",
  normalizedName: "Showmax",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $merchant_valr = fn::createMerchant({
  space: $space,
  key: "valr",
  name: "VALR",
  normalizedName: "VALR",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $merchant_engen_paradyskloof = fn::createMerchant({
  space: $space,
  key: "engen-paradyskloof",
  name: "Engen Paradyskloof",
  normalizedName: "Engen Paradyskloof",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $merchant_mr_d_food = fn::createMerchant({
  space: $space,
  key: "mr-d-food",
  name: "Mr D Food",
  normalizedName: "Mr D Food",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $merchant_audible = fn::createMerchant({
  space: $space,
  key: "audible",
  name: "Audible",
  normalizedName: "Audible",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $merchant_trade_travel_chill = fn::createMerchant({
  space: $space,
  key: "trade-travel-chill",
  name: "Trade Travel Chill",
  normalizedName: "Trade Travel Chill",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $merchant_the_local_choice = fn::createMerchant({
  space: $space,
  key: "the-local-choice",
  name: "The Local Choice",
  normalizedName: "The Local Choice",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});
LET $merchant_nedbank_atm = fn::createMerchant({
  space: $space,
  key: "nedbank-atm",
  name: "Nedbank ATM",
  normalizedName: "Nedbank ATM",
  active: true,
  notes: "Imported from 2026-02-19.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2026-01-30T00:00:00Z",
  description: "A P O Payment - Thank You",
  normalizedDescription: "Nedbank Current Account",
  amount: 7740,
  balance: 7740,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 1,
    rawRowText: "A P O Payment - Thank You; 7740.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 7740,
    bankChargeZar: null,
    balanceZar: 7740
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2026_02_19_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-01",
  sourceRow: $row_row_01,
  postedAt: "2026-01-30T00:00:00Z",
  description: "A P O Payment - Thank You",
  normalizedDescription: "Nedbank Current Account",
  amount: 7740,
  balance: 7740,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Current Account",
  merchant: $merchant_nedbank_current_account,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Payment received from personal current account."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2026_02_19_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_01.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_01.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2026-02-02T00:00:00Z",
  description: "Apo Reversal - No Funds Available",
  normalizedDescription: "Nedbank Current Account",
  amount: 7740,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 2,
    rawRowText: "Apo Reversal - No Funds Available; 7740.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment reversal",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 7740,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Reversal of the failed automatic payment."
});
LET $tx_stmt_2026_02_19_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-02",
  sourceRow: $row_row_02,
  postedAt: "2026-02-02T00:00:00Z",
  description: "Apo Reversal - No Funds Available",
  normalizedDescription: "Nedbank Current Account",
  amount: 7740,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Current Account",
  merchant: $merchant_nedbank_current_account,
  category: $cat_debt_payment_reversal,
  isTransfer: true,
  manualOverride: false,
  notes: "Reversal of the failed automatic payment."
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2026_02_19_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_02.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_02.id, "TransactionCategory", $cat_debt_payment_reversal.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2026-02-10T00:00:00Z",
  description: "Internet Banking Transferselby Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 11500,
  balance: 11500,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 3,
    rawRowText: "Internet Banking Transferselby Za; 11500.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 11500,
    bankChargeZar: null,
    balanceZar: 11500
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2026_02_19_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-03",
  sourceRow: $row_row_03,
  postedAt: "2026-02-10T00:00:00Z",
  description: "Internet Banking Transferselby Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 11500,
  balance: 11500,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Current Account",
  merchant: $merchant_nedbank_current_account,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Payment received from personal current account."
});
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2026_02_19_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_03.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_03.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2026-02-16T00:00:00Z",
  description: "Internet Banking Transferselby Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 8000,
  balance: 8000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 4,
    rawRowText: "Internet Banking Transferselby Za; 8000.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 8000,
    bankChargeZar: null,
    balanceZar: 8000
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2026_02_19_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-04",
  sourceRow: $row_row_04,
  postedAt: "2026-02-16T00:00:00Z",
  description: "Internet Banking Transferselby Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 8000,
  balance: 8000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Current Account",
  merchant: $merchant_nedbank_current_account,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Payment received from personal current account."
});
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2026_02_19_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_04.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_04.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2026-02-16T00:00:00Z",
  description: "Internet Banking Transferselby Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 450,
  balance: 450,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 5,
    rawRowText: "Internet Banking Transferselby Za; 450.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 450,
    bankChargeZar: null,
    balanceZar: 450
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2026_02_19_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-05",
  sourceRow: $row_row_05,
  postedAt: "2026-02-16T00:00:00Z",
  description: "Internet Banking Transferselby Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 450,
  balance: 450,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Current Account",
  merchant: $merchant_nedbank_current_account,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Payment received from personal current account."
});
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2026_02_19_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_05.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_05.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2026-02-02T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 6,
    rawRowText: "Declined-Insufficient Funds-Pos*; 8.69",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "declined payment fee",
    clarificationStatus: "clarified",
    amountZar: 8.69,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Declined transaction fee."
});
LET $tx_stmt_2026_02_19_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-06",
  sourceRow: $row_row_06,
  postedAt: "2026-02-02T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_declined_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Declined transaction fee."
});
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2026_02_19_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_06.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_06.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2026-02-02T00:00:00Z",
  description: "Returned Apo Fee *",
  normalizedDescription: "Returned Apo Fee",
  amount: 26.09,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 7,
    rawRowText: "Returned Apo Fee *; 26.09",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "returned apo fee",
    clarificationStatus: "clarified",
    amountZar: 26.09,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Returned automatic-payment fee."
});
LET $tx_stmt_2026_02_19_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-07",
  sourceRow: $row_row_07,
  postedAt: "2026-02-02T00:00:00Z",
  description: "Returned Apo Fee *",
  normalizedDescription: "Returned Apo Fee",
  amount: 26.09,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_returned_apo_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Returned automatic-payment fee."
});
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2026_02_19_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_07.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_07.id, "TransactionCategory", $cat_fees_returned_apo_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2026-02-02T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 8,
    rawRowText: "Declined-Insufficient Funds-Pos*; 8.69",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "declined payment fee",
    clarificationStatus: "clarified",
    amountZar: 8.69,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Declined transaction fee."
});
LET $tx_stmt_2026_02_19_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-08",
  sourceRow: $row_row_08,
  postedAt: "2026-02-02T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_declined_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Declined transaction fee."
});
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2026_02_19_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_08.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_08.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2026-02-05T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 9,
    rawRowText: "Declined-Insufficient Funds-Pos*; 8.69",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "declined payment fee",
    clarificationStatus: "clarified",
    amountZar: 8.69,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Declined transaction fee."
});
LET $tx_stmt_2026_02_19_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-09",
  sourceRow: $row_row_09,
  postedAt: "2026-02-05T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_declined_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Declined transaction fee."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2026_02_19_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_09.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_09.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2026-02-05T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 10,
    rawRowText: "Declined-Insufficient Funds-Pos*; 8.69",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "declined payment fee",
    clarificationStatus: "clarified",
    amountZar: 8.69,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Declined transaction fee."
});
LET $tx_stmt_2026_02_19_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-10",
  sourceRow: $row_row_10,
  postedAt: "2026-02-05T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_declined_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Declined transaction fee."
});
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2026_02_19_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_10.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_10.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2026-02-06T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 11,
    rawRowText: "Declined-Insufficient Funds-Pos*; 8.69",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "declined payment fee",
    clarificationStatus: "clarified",
    amountZar: 8.69,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Declined transaction fee."
});
LET $tx_stmt_2026_02_19_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-11",
  sourceRow: $row_row_11,
  postedAt: "2026-02-06T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_declined_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Declined transaction fee."
});
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2026_02_19_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_11.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_11.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2026-02-07T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 12,
    rawRowText: "Declined-Insufficient Funds-Pos*; 8.69",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "declined payment fee",
    clarificationStatus: "clarified",
    amountZar: 8.69,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Declined transaction fee."
});
LET $tx_stmt_2026_02_19_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-12",
  sourceRow: $row_row_12,
  postedAt: "2026-02-07T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_declined_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Declined transaction fee."
});
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2026_02_19_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_12.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_12.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2026-02-09T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 13,
    rawRowText: "Declined-Insufficient Funds-Pos*; 8.69",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "declined payment fee",
    clarificationStatus: "clarified",
    amountZar: 8.69,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Declined transaction fee."
});
LET $tx_stmt_2026_02_19_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-13",
  sourceRow: $row_row_13,
  postedAt: "2026-02-09T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_declined_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Declined transaction fee."
});
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2026_02_19_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_13.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_13.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2026-02-09T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 14,
    rawRowText: "Declined-Insufficient Funds-Pos*; 8.69",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "declined payment fee",
    clarificationStatus: "clarified",
    amountZar: 8.69,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Declined transaction fee."
});
LET $tx_stmt_2026_02_19_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-14",
  sourceRow: $row_row_14,
  postedAt: "2026-02-09T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_declined_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Declined transaction fee."
});
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2026_02_19_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_14.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_14.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2026-02-09T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 15,
    rawRowText: "Declined-Insufficient Funds-Pos*; 8.69",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "declined payment fee",
    clarificationStatus: "clarified",
    amountZar: 8.69,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Declined transaction fee."
});
LET $tx_stmt_2026_02_19_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-15",
  sourceRow: $row_row_15,
  postedAt: "2026-02-09T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_declined_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Declined transaction fee."
});
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2026_02_19_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_15.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_15.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2026-02-09T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 16,
    rawRowText: "Declined-Insufficient Funds-Pos*; 8.69",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "declined payment fee",
    clarificationStatus: "clarified",
    amountZar: 8.69,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Declined transaction fee."
});
LET $tx_stmt_2026_02_19_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-16",
  sourceRow: $row_row_16,
  postedAt: "2026-02-09T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_declined_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Declined transaction fee."
});
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2026_02_19_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_16.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_16.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2026-02-09T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 17,
    rawRowText: "Declined-Insufficient Funds-Pos*; 8.69",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "declined payment fee",
    clarificationStatus: "clarified",
    amountZar: 8.69,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Declined transaction fee."
});
LET $tx_stmt_2026_02_19_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-17",
  sourceRow: $row_row_17,
  postedAt: "2026-02-09T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_declined_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Declined transaction fee."
});
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2026_02_19_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_17.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_17.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2026-02-13T00:00:00Z",
  description: "Maintenance Fee",
  normalizedDescription: "Maintenance Fee",
  amount: 36.52,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 18,
    rawRowText: "Maintenance Fee; 36.52",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "maintenance fee",
    clarificationStatus: "clarified",
    amountZar: 36.52,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Card maintenance fee."
});
LET $tx_stmt_2026_02_19_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-18",
  sourceRow: $row_row_18,
  postedAt: "2026-02-13T00:00:00Z",
  description: "Maintenance Fee",
  normalizedDescription: "Maintenance Fee",
  amount: 36.52,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_maintenance_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Card maintenance fee."
});
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2026_02_19_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_18.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_18.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2026-02-16T00:00:00Z",
  description: "A T M Cash Advance Fee *",
  normalizedDescription: "Atm Cash Advance Fee",
  amount: 32.12,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 19,
    rawRowText: "A T M Cash Advance Fee *; 32.12",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "atm cash advance fee",
    clarificationStatus: "clarified",
    amountZar: 32.12,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash-advance fee charged by the card."
});
LET $tx_stmt_2026_02_19_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-19",
  sourceRow: $row_row_19,
  postedAt: "2026-02-16T00:00:00Z",
  description: "A T M Cash Advance Fee *",
  normalizedDescription: "Atm Cash Advance Fee",
  amount: 32.12,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_atm_cash_advance_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Cash-advance fee charged by the card."
});
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2026_02_19_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_19.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_19.id, "TransactionCategory", $cat_fees_atm_cash_advance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2026-02-16T00:00:00Z",
  description: "Credit Facility Service Fee",
  normalizedDescription: "Credit Facility Service Fee",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 20,
    rawRowText: "Credit Facility Service Fee; 20.00",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "credit facility service fee",
    clarificationStatus: "clarified",
    amountZar: 20,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Credit facility service fee."
});
LET $tx_stmt_2026_02_19_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-20",
  sourceRow: $row_row_20,
  postedAt: "2026-02-16T00:00:00Z",
  description: "Credit Facility Service Fee",
  normalizedDescription: "Credit Facility Service Fee",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_credit_facility_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Credit facility service fee."
});
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2026_02_19_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_20.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_20.id, "TransactionCategory", $cat_fees_credit_facility_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2026-02-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 2238.37,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 21,
    rawRowText: "Finance Charge; 2238.37",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "finance charge",
    clarificationStatus: "clarified",
    amountZar: 2238.37,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Finance charge on outstanding balance."
});
LET $tx_stmt_2026_02_19_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-21",
  sourceRow: $row_row_21,
  postedAt: "2026-02-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 2238.37,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_finance_charge,
  isTransfer: false,
  manualOverride: false,
  notes: "Finance charge on outstanding balance."
});
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2026_02_19_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_21.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_21.id, "TransactionCategory", $cat_fees_finance_charge.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2026-02-16T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 31.51,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 22,
    rawRowText: "Total V A T; 31.51",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 31.51,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "VAT on fees."
});
LET $tx_stmt_2026_02_19_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-22",
  sourceRow: $row_row_22,
  postedAt: "2026-02-16T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 31.51,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_vat_on_fees,
  isTransfer: false,
  manualOverride: false,
  notes: "VAT on fees."
});
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2026_02_19_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_22.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_22.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2026-01-19T00:00:00Z",
  description: "Bridge House School",
  normalizedDescription: "Bridge House School",
  amount: 30,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 23,
    rawRowText: "Bridge House School; 30.00",
    transactionType: "expense",
    normalizedMerchant: "Bridge House School",
    category: "Education / children",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 30,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "School-related spend."
});
LET $tx_stmt_2026_02_19_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-23",
  sourceRow: $row_row_23,
  postedAt: "2026-01-19T00:00:00Z",
  description: "Bridge House School",
  normalizedDescription: "Bridge House School",
  amount: 30,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Bridge House School",
  merchant: $merchant_bridge_house_school,
  category: $cat_education_children,
  isTransfer: false,
  manualOverride: false,
  notes: "School-related spend."
});
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2026_02_19_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_23.id, "TransactionMerchant", $merchant_bridge_house_school.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_23.id, "TransactionCategory", $cat_education_children.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2026-01-19T00:00:00Z",
  description: "Bridge House School",
  normalizedDescription: "Bridge House School",
  amount: 51,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 24,
    rawRowText: "Bridge House School; 51.00",
    transactionType: "expense",
    normalizedMerchant: "Bridge House School",
    category: "Education / children",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 51,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "School-related spend."
});
LET $tx_stmt_2026_02_19_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-24",
  sourceRow: $row_row_24,
  postedAt: "2026-01-19T00:00:00Z",
  description: "Bridge House School",
  normalizedDescription: "Bridge House School",
  amount: 51,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Bridge House School",
  merchant: $merchant_bridge_house_school,
  category: $cat_education_children,
  isTransfer: false,
  manualOverride: false,
  notes: "School-related spend."
});
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2026_02_19_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_24.id, "TransactionMerchant", $merchant_bridge_house_school.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_24.id, "TransactionCategory", $cat_education_children.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2026-02-10T00:00:00Z",
  description: "Spotifyza Stockholm Se",
  normalizedDescription: "Spotify",
  amount: 69.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 25,
    rawRowText: "Spotifyza Stockholm Se; 69.99",
    transactionType: "expense",
    normalizedMerchant: "Spotify",
    category: "Subscription / media",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 69.99,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Media subscription."
});
LET $tx_stmt_2026_02_19_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-25",
  sourceRow: $row_row_25,
  postedAt: "2026-02-10T00:00:00Z",
  description: "Spotifyza Stockholm Se",
  normalizedDescription: "Spotify",
  amount: 69.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Spotify",
  merchant: $merchant_spotify,
  category: $cat_subscription_media,
  isTransfer: false,
  manualOverride: false,
  notes: "Media subscription."
});
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2026_02_19_row_25.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_25.id, "TransactionMerchant", $merchant_spotify.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_25.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2026-02-10T00:00:00Z",
  description: "Pp *Showmax Randburg Za",
  normalizedDescription: "Showmax",
  amount: 99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 26,
    rawRowText: "Pp *Showmax Randburg Za; 99.00",
    transactionType: "expense",
    normalizedMerchant: "Showmax",
    category: "Subscription / media",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 99,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Media subscription."
});
LET $tx_stmt_2026_02_19_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-26",
  sourceRow: $row_row_26,
  postedAt: "2026-02-10T00:00:00Z",
  description: "Pp *Showmax Randburg Za",
  normalizedDescription: "Showmax",
  amount: 99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Showmax",
  merchant: $merchant_showmax,
  category: $cat_subscription_media,
  isTransfer: false,
  manualOverride: false,
  notes: "Media subscription."
});
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2026_02_19_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_26.id, "TransactionMerchant", $merchant_showmax.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_26.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2026-02-11T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 27,
    rawRowText: "I Valr Pty Ltd Cape Town Za; 1000.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2026_02_19_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-27",
  sourceRow: $row_row_27,
  postedAt: "2026-02-11T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
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
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2026_02_19_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_27.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_27.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2026-02-12T00:00:00Z",
  description: "Engen Paradyskloof",
  normalizedDescription: "Engen Paradyskloof",
  amount: 308.47,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 28,
    rawRowText: "Engen Paradyskloof; 308.47",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 308.47,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel spend."
});
LET $tx_stmt_2026_02_19_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-28",
  sourceRow: $row_row_28,
  postedAt: "2026-02-12T00:00:00Z",
  description: "Engen Paradyskloof",
  normalizedDescription: "Engen Paradyskloof",
  amount: 308.47,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Engen Paradyskloof",
  merchant: $merchant_engen_paradyskloof,
  category: $cat_fuel_transport,
  isTransfer: false,
  manualOverride: false,
  notes: "Fuel spend."
});
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2026_02_19_row_28.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_28.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_28.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2026-02-12T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 29,
    rawRowText: "I Valr Pty Ltd Cape Town Za; 1000.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2026_02_19_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-29",
  sourceRow: $row_row_29,
  postedAt: "2026-02-12T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
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
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2026_02_19_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_29.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_29.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2026-02-13T00:00:00Z",
  description: "Bridge House School",
  normalizedDescription: "Bridge House School",
  amount: 70,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 30,
    rawRowText: "Bridge House School; 70.00",
    transactionType: "expense",
    normalizedMerchant: "Bridge House School",
    category: "Education / children",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 70,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "School-related spend."
});
LET $tx_stmt_2026_02_19_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-30",
  sourceRow: $row_row_30,
  postedAt: "2026-02-13T00:00:00Z",
  description: "Bridge House School",
  normalizedDescription: "Bridge House School",
  amount: 70,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Bridge House School",
  merchant: $merchant_bridge_house_school,
  category: $cat_education_children,
  isTransfer: false,
  manualOverride: false,
  notes: "School-related spend."
});
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2026_02_19_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_30.id, "TransactionMerchant", $merchant_bridge_house_school.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_30.id, "TransactionCategory", $cat_education_children.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2026-02-13T00:00:00Z",
  description: "Bridge House School",
  normalizedDescription: "Bridge House School",
  amount: 30,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 31,
    rawRowText: "Bridge House School; 30.00",
    transactionType: "expense",
    normalizedMerchant: "Bridge House School",
    category: "Education / children",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 30,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "School-related spend."
});
LET $tx_stmt_2026_02_19_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-31",
  sourceRow: $row_row_31,
  postedAt: "2026-02-13T00:00:00Z",
  description: "Bridge House School",
  normalizedDescription: "Bridge House School",
  amount: 30,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Bridge House School",
  merchant: $merchant_bridge_house_school,
  category: $cat_education_children,
  isTransfer: false,
  manualOverride: false,
  notes: "School-related spend."
});
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2026_02_19_row_31.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_31.id, "TransactionMerchant", $merchant_bridge_house_school.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_31.id, "TransactionCategory", $cat_education_children.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2026-02-13T00:00:00Z",
  description: "Mr D Food Cape Town Za",
  normalizedDescription: "Mr D Food",
  amount: 188,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 32,
    rawRowText: "Mr D Food Cape Town Za; 188.00",
    transactionType: "expense",
    normalizedMerchant: "Mr D Food",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 188,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Food delivery spend."
});
LET $tx_stmt_2026_02_19_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-32",
  sourceRow: $row_row_32,
  postedAt: "2026-02-13T00:00:00Z",
  description: "Mr D Food Cape Town Za",
  normalizedDescription: "Mr D Food",
  amount: 188,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Mr D Food",
  merchant: $merchant_mr_d_food,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Food delivery spend."
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2026_02_19_row_32.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_32.id, "TransactionMerchant", $merchant_mr_d_food.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_32.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2026-02-13T00:00:00Z",
  description: "Audible*J45ol5aq3 Amzn.Com/Billus",
  normalizedDescription: "Audible",
  amount: 16.53,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 33,
    rawRowText: "Audible*J45ol5aq3 Amzn.Com/Billus; 16.53",
    transactionType: "expense",
    normalizedMerchant: "Audible",
    category: "Subscription / media",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 16.53,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Audible subscription or media spend."
});
LET $tx_stmt_2026_02_19_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-33",
  sourceRow: $row_row_33,
  postedAt: "2026-02-13T00:00:00Z",
  description: "Audible*J45ol5aq3 Amzn.Com/Billus",
  normalizedDescription: "Audible",
  amount: 16.53,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Audible",
  merchant: $merchant_audible,
  category: $cat_subscription_media,
  isTransfer: false,
  manualOverride: false,
  notes: "Audible subscription or media spend."
});
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2026_02_19_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_33.id, "TransactionMerchant", $merchant_audible.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_33.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2026-02-13T00:00:00Z",
  description: "Trade Travel Chill Abu Dhabi Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 985.34,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 34,
    rawRowText: "Trade Travel Chill Abu Dhabi Ae; 985.34",
    transactionType: "expense",
    normalizedMerchant: "Trade Travel Chill",
    category: "Travel",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 985.34,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Travel-related merchant needs exact purpose confirmation."
});
LET $tx_stmt_2026_02_19_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-34",
  sourceRow: $row_row_34,
  postedAt: "2026-02-13T00:00:00Z",
  description: "Trade Travel Chill Abu Dhabi Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 985.34,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Trade Travel Chill",
  merchant: $merchant_trade_travel_chill,
  category: $cat_travel,
  isTransfer: false,
  manualOverride: false,
  notes: "Travel-related merchant needs exact purpose confirmation."
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2026_02_19_row_34.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_34.id, "TransactionMerchant", $merchant_trade_travel_chill.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_34.id, "TransactionCategory", $cat_travel.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_02_19_row_34 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-02-19-row-34",
  transaction: $tx_stmt_2026_02_19_row_34,
  status: "open",
  question: "What is the exact purpose of this Trade Travel Chill transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_trade_travel_chill,
  suggestedCategory: $cat_travel,
  confidence: 0.25,
  notes: "Imported from 2026-02-19.import.md"
});
fn::createEdge($tx_stmt_2026_02_19_row_34.id, "TransactionClarificationTasks", $task_stmt_2026_02_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2026-02-14T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choice",
  amount: 2418.03,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 35,
    rawRowText: "The Local Choic 202880 Val De Vie E Za; 2418.03",
    transactionType: "expense",
    normalizedMerchant: "The Local Choice",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2418.03,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery / household spend."
});
LET $tx_stmt_2026_02_19_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-35",
  sourceRow: $row_row_35,
  postedAt: "2026-02-14T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choice",
  amount: 2418.03,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "The Local Choice",
  merchant: $merchant_the_local_choice,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery / household spend."
});
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2026_02_19_row_35.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_35.id, "TransactionMerchant", $merchant_the_local_choice.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_35.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2026-02-14T00:00:00Z",
  description: "Engen Paradyskloof",
  normalizedDescription: "Engen Paradyskloof",
  amount: 514.25,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 36,
    rawRowText: "Engen Paradyskloof; 514.25",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 514.25,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel spend."
});
LET $tx_stmt_2026_02_19_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-36",
  sourceRow: $row_row_36,
  postedAt: "2026-02-14T00:00:00Z",
  description: "Engen Paradyskloof",
  normalizedDescription: "Engen Paradyskloof",
  amount: 514.25,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Engen Paradyskloof",
  merchant: $merchant_engen_paradyskloof,
  category: $cat_fuel_transport,
  isTransfer: false,
  manualOverride: false,
  notes: "Fuel spend."
});
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2026_02_19_row_36.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_36.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_36.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 37
LET $row_row_37 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 37,
  postedAt: "2026-02-15T00:00:00Z",
  description: "Engen Paradyskloof",
  normalizedDescription: "Engen Paradyskloof",
  amount: 800,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 37,
    rawRowText: "Engen Paradyskloof; 800.00",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 800,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel spend."
});
LET $tx_stmt_2026_02_19_row_37 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-37",
  sourceRow: $row_row_37,
  postedAt: "2026-02-15T00:00:00Z",
  description: "Engen Paradyskloof",
  normalizedDescription: "Engen Paradyskloof",
  amount: 800,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Engen Paradyskloof",
  merchant: $merchant_engen_paradyskloof,
  category: $cat_fuel_transport,
  isTransfer: false,
  manualOverride: false,
  notes: "Fuel spend."
});
fn::updateStatementRow($row_row_37.id, { transaction: $tx_stmt_2026_02_19_row_37.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_37.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_37.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_37.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 38
LET $row_row_38 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 38,
  postedAt: "2026-02-15T00:00:00Z",
  description: "A T M Cash Advance:Atm Cash Cnr St",
  normalizedDescription: "Nedbank ATM",
  amount: 1300,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 38,
    rawRowText: "A T M Cash Advance:Atm Cash Cnr St; 1300.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank ATM",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1300,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "ATM cash advance taken from the credit card."
});
LET $tx_stmt_2026_02_19_row_38 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-38",
  sourceRow: $row_row_38,
  postedAt: "2026-02-15T00:00:00Z",
  description: "A T M Cash Advance:Atm Cash Cnr St",
  normalizedDescription: "Nedbank ATM",
  amount: 1300,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank ATM",
  merchant: $merchant_nedbank_atm,
  category: $cat_cash_advance,
  isTransfer: true,
  manualOverride: false,
  notes: "ATM cash advance taken from the credit card."
});
fn::updateStatementRow($row_row_38.id, { transaction: $tx_stmt_2026_02_19_row_38.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_38.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_38.id, "TransactionMerchant", $merchant_nedbank_atm.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_38.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 39
LET $row_row_39 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 39,
  postedAt: "2026-02-15T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 1500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 39,
    rawRowText: "I Valr Pty Ltd Cape Town Za; 1500.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1500,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2026_02_19_row_39 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-39",
  sourceRow: $row_row_39,
  postedAt: "2026-02-15T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 1500,
  balance: 0,
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
fn::updateStatementRow($row_row_39.id, { transaction: $tx_stmt_2026_02_19_row_39.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_39.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_39.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_39.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 40
LET $row_row_40 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 40,
  postedAt: "2026-02-16T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 40,
    rawRowText: "I Valr Pty Ltd Cape Town Za; 500.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 500,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2026_02_19_row_40 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-40",
  sourceRow: $row_row_40,
  postedAt: "2026-02-16T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
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
fn::updateStatementRow($row_row_40.id, { transaction: $tx_stmt_2026_02_19_row_40.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_40.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_40.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_40.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 41
LET $row_row_41 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 41,
  postedAt: "2026-02-16T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 41,
    rawRowText: "I Valr Pty Ltd Cape Town Za; 2000.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2026_02_19_row_41 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-41",
  sourceRow: $row_row_41,
  postedAt: "2026-02-16T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
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
fn::updateStatementRow($row_row_41.id, { transaction: $tx_stmt_2026_02_19_row_41.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_41.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_41.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_41.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 42
LET $row_row_42 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 42,
  postedAt: "2026-02-17T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/February 2026.pdf",
    statementPeriodStart: "2026-01-20",
    statementPeriodEnd: "2026-02-19",
    rowNo: 42,
    rawRowText: "I Valr Pty Ltd Cape Town Za; 2000.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2026_02_19_row_42 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-02-19-row-42",
  sourceRow: $row_row_42,
  postedAt: "2026-02-17T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
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
fn::updateStatementRow($row_row_42.id, { transaction: $tx_stmt_2026_02_19_row_42.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_42.id, "StatementRowTransactions", $tx_stmt_2026_02_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_02_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_42.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_02_19_row_42.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 42,
  normalizedCount: 42,
  clarificationCount: 1,
  status: "matched",
  statementDate: "2026-02-19T00:00:00Z",
  notes: "Imported from 2026-02-19.import.md"
});

-- End of generated import
