-- Generated from docs/statements/personal/credit/2025-04-20.import.md
-- Source: docs/statements/personal/credit/April 2025.pdf

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
  openingBalance: 104413.9,
  active: true,
  notes: "Imported from April 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-04-19-nedbank-credit",
  sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-04-19T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-04-20.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_debt_payment_reversal = fn::createCategory({
  space: $space,
  key: "debt-payment-reversal",
  name: "Debt payment reversal",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_crypto_trading = fn::createCategory({
  space: $space,
  key: "crypto-trading",
  name: "Crypto / trading",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_groceries_household = fn::createCategory({
  space: $space,
  key: "groceries-household",
  name: "Groceries / household",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_dining_lifestyle = fn::createCategory({
  space: $space,
  key: "dining-lifestyle",
  name: "Dining / lifestyle",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_business_expenses_paid_personally_software = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-software",
  name: "Business expenses paid personally / software",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_design_resources = fn::createCategory({
  space: $space,
  key: "design-resources",
  name: "Design resources",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_coffee_takeaway = fn::createCategory({
  space: $space,
  key: "coffee-takeaway",
  name: "Coffee / takeaway",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_foreign_account_funding = fn::createCategory({
  space: $space,
  key: "foreign-account-funding",
  name: "Foreign account funding",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_business_expenses_paid_personally_mobile_phone = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-mobile-phone",
  name: "Business expenses paid personally / mobile phone",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_subscription_media = fn::createCategory({
  space: $space,
  key: "subscription-media",
  name: "Subscription / media",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_healthcare_optometry = fn::createCategory({
  space: $space,
  key: "healthcare-optometry",
  name: "Healthcare / optometry",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_personal_care_pharmacy = fn::createCategory({
  space: $space,
  key: "personal-care-pharmacy",
  name: "Personal care / pharmacy",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_business_expenses_paid_personally_trading_challenge_fees = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-trading-challenge-fees",
  name: "Business expenses paid personally / trading challenge fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_business_expenses_paid_personally_trading_software = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-trading-software",
  name: "Business expenses paid personally / trading software",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_cash_advance = fn::createCategory({
  space: $space,
  key: "cash-advance",
  name: "Cash advance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_business_expenses_paid_personally_trading_tools = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-trading-tools",
  name: "Business expenses paid personally / trading tools",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_fees_declined_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-declined-payment-fee",
  name: "Declined Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_fees_returned_apo_fee = fn::createCategory({
  space: $space,
  key: "fees-returned-apo-fee",
  name: "Returned Apo Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_fees_electronic_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-electronic-payment-fee",
  name: "Electronic Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_fees_credit_facility_service_fee = fn::createCategory({
  space: $space,
  key: "fees-credit-facility-service-fee",
  name: "Credit Facility Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_fees_finance_charge = fn::createCategory({
  space: $space,
  key: "fees-finance-charge",
  name: "Finance Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_fees_cross_border_transaction_fee = fn::createCategory({
  space: $space,
  key: "fees-cross-border-transaction-fee",
  name: "Cross Border Transaction Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $cat_fees_budget_finance_charge = fn::createCategory({
  space: $space,
  key: "fees-budget-finance-charge",
  name: "Budget Finance Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});

-- Merchant records
LET $merchant_nedbank_current_account = fn::createMerchant({
  space: $space,
  key: "nedbank-current-account",
  name: "Nedbank Current Account",
  normalizedName: "Nedbank Current Account",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_valr = fn::createMerchant({
  space: $space,
  key: "valr",
  name: "VALR",
  normalizedName: "VALR",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_the_local_choic_202880_val_de_vie_e_za = fn::createMerchant({
  space: $space,
  key: "the-local-choic-202880-val-de-vie-e-za",
  name: "The Local Choic 202880 Val De Vie E Za",
  normalizedName: "The Local Choic 202880 Val De Vie E Za",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_backs_val_de_vie = fn::createMerchant({
  space: $space,
  key: "backs-val-de-vie",
  name: "Backs Val De Vie",
  normalizedName: "Backs Val De Vie",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_google_workspace = fn::createMerchant({
  space: $space,
  key: "google-workspace",
  name: "Google Workspace",
  normalizedName: "Google Workspace",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_la_concorde = fn::createMerchant({
  space: $space,
  key: "la-concorde",
  name: "La Concorde",
  normalizedName: "La Concorde",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_ui8 = fn::createMerchant({
  space: $space,
  key: "ui8",
  name: "UI8",
  normalizedName: "UI8",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_bootlegger_coffee = fn::createMerchant({
  space: $space,
  key: "bootlegger-coffee",
  name: "Bootlegger Coffee",
  normalizedName: "Bootlegger Coffee",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_kalahari_slate_waterfront = fn::createMerchant({
  space: $space,
  key: "kalahari-slate-waterfront",
  name: "Kalahari Slate Waterfront",
  normalizedName: "Kalahari Slate Waterfront",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_takealot = fn::createMerchant({
  space: $space,
  key: "takealot",
  name: "Takealot",
  normalizedName: "Takealot",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_wise = fn::createMerchant({
  space: $space,
  key: "wise",
  name: "Wise",
  normalizedName: "Wise",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_afrihost = fn::createMerchant({
  space: $space,
  key: "afrihost",
  name: "Afrihost",
  normalizedName: "Afrihost",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_spotify = fn::createMerchant({
  space: $space,
  key: "spotify",
  name: "Spotify",
  normalizedName: "Spotify",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_reza_ferreira_optometr = fn::createMerchant({
  space: $space,
  key: "reza-ferreira-optometr",
  name: "Reza Ferreira Optometr",
  normalizedName: "Reza Ferreira Optometr",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_clicks_stellenbosch_square = fn::createMerchant({
  space: $space,
  key: "clicks-stellenbosch-square",
  name: "Clicks Stellenbosch Square",
  normalizedName: "Clicks Stellenbosch Square",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_hyrotrader = fn::createMerchant({
  space: $space,
  key: "hyrotrader",
  name: "HyroTrader",
  normalizedName: "HyroTrader",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_tradinglite = fn::createMerchant({
  space: $space,
  key: "tradinglite",
  name: "Tradinglite",
  normalizedName: "Tradinglite",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_plato_val_de_vie = fn::createMerchant({
  space: $space,
  key: "plato-val-de-vie",
  name: "Plato Val De Vie",
  normalizedName: "Plato Val De Vie",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_paddle_net = fn::createMerchant({
  space: $space,
  key: "paddle-net",
  name: "Paddle.net",
  normalizedName: "Paddle.net",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_nedbank_internet_banking = fn::createMerchant({
  space: $space,
  key: "nedbank-internet-banking",
  name: "Nedbank Internet Banking",
  normalizedName: "Nedbank Internet Banking",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});
LET $merchant_trade_travel_chill = fn::createMerchant({
  space: $space,
  key: "trade-travel-chill",
  name: "Trade Travel Chill",
  normalizedName: "Trade Travel Chill",
  active: true,
  notes: "Imported from 2025-04-20.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-03-31T00:00:00Z",
  description: "A P O Payment - Thank You",
  normalizedDescription: "Nedbank Current Account",
  amount: 3150,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 1,
    rawRowText: "A P O Payment - Thank You; 3150.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 3150,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Automatic payment order toward the credit-card debt."
});
LET $tx_stmt_2025_04_19_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-03-31T00:00:00Z",
  description: "A P O Payment - Thank You",
  normalizedDescription: "Nedbank Current Account",
  amount: 3150,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Current Account",
  merchant: $merchant_nedbank_current_account,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Automatic payment order toward the credit-card debt."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_04_19_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_01.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_01.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-01" AND transaction = $tx_stmt_2025_04_19_row_01.id AND status = "open";

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-04-02T00:00:00Z",
  description: "000000000000003251     Apo Reversal - No Funds Available",
  normalizedDescription: "Nedbank Current Account",
  amount: 3150,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 2,
    rawRowText: "000000000000003251     Apo Reversal - No Funds Available; 3150.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment reversal",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 3150,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Reversal of the automatic payment order because there were not enough funds."
});
LET $tx_stmt_2025_04_19_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-04-02T00:00:00Z",
  description: "000000000000003251     Apo Reversal - No Funds Available",
  normalizedDescription: "Nedbank Current Account",
  amount: 3150,
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
  notes: "Reversal of the automatic payment order because there were not enough funds."
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_04_19_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_02.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_02.id, "TransactionCategory", $cat_debt_payment_reversal.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-02" AND transaction = $tx_stmt_2025_04_19_row_02.id AND status = "open";

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-03-28T00:00:00Z",
  description: "Internet Banking Transferselby      Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2200,
  balance: 2200,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 3,
    rawRowText: "Internet Banking Transferselby      Za; 2200.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2200,
    bankChargeZar: null,
    balanceZar: 2200
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_04_19_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-03-28T00:00:00Z",
  description: "Internet Banking Transferselby      Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2200,
  balance: 2200,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_04_19_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_03.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_03.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-03" AND transaction = $tx_stmt_2025_04_19_row_03.id AND status = "open";

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-04-05T00:00:00Z",
  description: "Internet Banking Transferselby      Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 25900,
  balance: 25900,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 4,
    rawRowText: "Internet Banking Transferselby      Za; 25900.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 25900,
    bankChargeZar: null,
    balanceZar: 25900
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_04_19_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-04-05T00:00:00Z",
  description: "Internet Banking Transferselby      Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 25900,
  balance: 25900,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_04_19_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_04.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_04.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-04" AND transaction = $tx_stmt_2025_04_19_row_04.id AND status = "open";

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-04-11T00:00:00Z",
  description: "Internet Banking Transferselby      Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 12000,
  balance: 12000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 5,
    rawRowText: "Internet Banking Transferselby      Za; 12000.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 12000,
    bankChargeZar: null,
    balanceZar: 12000
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_04_19_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-04-11T00:00:00Z",
  description: "Internet Banking Transferselby      Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 12000,
  balance: 12000,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_04_19_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_05.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_05.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-05" AND transaction = $tx_stmt_2025_04_19_row_05.id AND status = "open";

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-04-17T00:00:00Z",
  description: "Internet Banking Transferselby      Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 4500,
  balance: 4500,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 6,
    rawRowText: "Internet Banking Transferselby      Za; 4500.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 4500,
    bankChargeZar: null,
    balanceZar: 4500
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_04_19_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-04-17T00:00:00Z",
  description: "Internet Banking Transferselby      Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 4500,
  balance: 4500,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_04_19_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_06.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_06.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-06" AND transaction = $tx_stmt_2025_04_19_row_06.id AND status = "open";

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-03-22T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 7,
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
LET $tx_stmt_2025_04_19_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-03-22T00:00:00Z",
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_04_19_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_07.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_07.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-07" AND transaction = $tx_stmt_2025_04_19_row_07.id AND status = "open";

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-03-22T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
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
LET $tx_stmt_2025_04_19_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-03-22T00:00:00Z",
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_04_19_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_08.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_08.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-08" AND transaction = $tx_stmt_2025_04_19_row_08.id AND status = "open";

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-04-02T00:00:00Z",
  description: "Returned Apo Fee *",
  normalizedDescription: "Returned Apo Fee",
  amount: 26.09,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 9,
    rawRowText: "Returned Apo Fee *; 26.09",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "returned APO fee",
    clarificationStatus: "clarified",
    amountZar: 26.09,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fee charged when the automatic payment order was returned."
});
LET $tx_stmt_2025_04_19_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-04-02T00:00:00Z",
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
  notes: "Fee charged when the automatic payment order was returned."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_04_19_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_09.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_09.id, "TransactionCategory", $cat_fees_returned_apo_fee.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-09" AND transaction = $tx_stmt_2025_04_19_row_09.id AND status = "open";

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-04-11T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 10,
    rawRowText: "Electronic Payment Fee *; 8.69",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "electronic payment fee",
    clarificationStatus: "clarified",
    amountZar: 8.69,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Electronic payment fee."
});
LET $tx_stmt_2025_04_19_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-04-11T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_electronic_payment_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Electronic payment fee."
});
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_04_19_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_10.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_10.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-10" AND transaction = $tx_stmt_2025_04_19_row_10.id AND status = "open";

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-04-14T00:00:00Z",
  description: "Maintenance Fee",
  normalizedDescription: "Maintenance Fee",
  amount: 38.26,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 11,
    rawRowText: "Maintenance Fee; 38.26",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "maintenance fee",
    clarificationStatus: "clarified",
    amountZar: 38.26,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Card maintenance fee."
});
LET $tx_stmt_2025_04_19_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-04-14T00:00:00Z",
  description: "Maintenance Fee",
  normalizedDescription: "Maintenance Fee",
  amount: 38.26,
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_04_19_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_11.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_11.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-11" AND transaction = $tx_stmt_2025_04_19_row_11.id AND status = "open";

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-04-14T00:00:00Z",
  description: "Credit Facility Service Fee",
  normalizedDescription: "Credit Facility Service Fee",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 12,
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
LET $tx_stmt_2025_04_19_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-04-14T00:00:00Z",
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_04_19_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_12.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_12.id, "TransactionCategory", $cat_fees_credit_facility_service_fee.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-12" AND transaction = $tx_stmt_2025_04_19_row_12.id AND status = "open";

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-04-17T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
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
LET $tx_stmt_2025_04_19_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-04-17T00:00:00Z",
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_04_19_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_13.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_13.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-13" AND transaction = $tx_stmt_2025_04_19_row_13.id AND status = "open";

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-04-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 1922.57,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 14,
    rawRowText: "Finance Charge; 1922.57",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "finance charge",
    clarificationStatus: "clarified",
    amountZar: 1922.57,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Finance charge on the outstanding balance."
});
LET $tx_stmt_2025_04_19_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-04-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 1922.57,
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
  notes: "Finance charge on the outstanding balance."
});
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_04_19_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_14.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_14.id, "TransactionCategory", $cat_fees_finance_charge.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-14" AND transaction = $tx_stmt_2025_04_19_row_14.id AND status = "open";

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-04-17T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 17.85,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 15,
    rawRowText: "Total V A T; 17.85",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 17.85,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "VAT on fees."
});
LET $tx_stmt_2025_04_19_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-04-17T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 17.85,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_04_19_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_15.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_15.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-15" AND transaction = $tx_stmt_2025_04_19_row_15.id AND status = "open";

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-04-11T00:00:00Z",
  description: "Cross Border Transaction Fee",
  normalizedDescription: "Cross Border Transaction Fee",
  amount: 28.9,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 16,
    rawRowText: "Cross Border Transaction Fee; 28.90",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "cross border transaction fee",
    clarificationStatus: "clarified",
    amountZar: 28.9,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cross-border card transaction fee."
});
LET $tx_stmt_2025_04_19_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-04-11T00:00:00Z",
  description: "Cross Border Transaction Fee",
  normalizedDescription: "Cross Border Transaction Fee",
  amount: 28.9,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_cross_border_transaction_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Cross-border card transaction fee."
});
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_04_19_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_16.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_16.id, "TransactionCategory", $cat_fees_cross_border_transaction_fee.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-16" AND transaction = $tx_stmt_2025_04_19_row_16.id AND status = "open";

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-04-19T00:00:00Z",
  description: "00000000000               Budget Finance Charge",
  normalizedDescription: "Budget Finance Charge",
  amount: 5.89,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 17,
    rawRowText: "00000000000               Budget Finance Charge; 5.89",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "budget finance charge",
    clarificationStatus: "clarified",
    amountZar: 5.89,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Budget finance charge."
});
LET $tx_stmt_2025_04_19_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-04-19T00:00:00Z",
  description: "00000000000               Budget Finance Charge",
  normalizedDescription: "Budget Finance Charge",
  amount: 5.89,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_budget_finance_charge,
  isTransfer: false,
  manualOverride: false,
  notes: "Budget finance charge."
});
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_04_19_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_17.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_17.id, "TransactionCategory", $cat_fees_budget_finance_charge.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-17" AND transaction = $tx_stmt_2025_04_19_row_17.id AND status = "open";

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-03-18T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 18,
    rawRowText: "I Valr Pty Ltd         Cape Town    Za; 2000.00",
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
LET $tx_stmt_2025_04_19_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-03-18T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_04_19_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_18.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_18.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-18" AND transaction = $tx_stmt_2025_04_19_row_18.id AND status = "open";

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-03-19T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 1224.54,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 19,
    rawRowText: "The Local Choic 202880 Val De Vie E Za; 1224.54",
    transactionType: "expense",
    normalizedMerchant: "The Local Choic 202880 Val De Vie E Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1224.54,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_04_19_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-03-19T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 1224.54,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "The Local Choic 202880 Val De Vie E Za",
  merchant: $merchant_the_local_choic_202880_val_de_vie_e_za,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_04_19_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_19.id, "TransactionMerchant", $merchant_the_local_choic_202880_val_de_vie_e_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_19.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-19" AND transaction = $tx_stmt_2025_04_19_row_19.id AND status = "open";

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-03-19T00:00:00Z",
  description: "Yoco *Backs Val De V Paarl            Za",
  normalizedDescription: "Backs Val De Vie",
  amount: 423,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 20,
    rawRowText: "Yoco *Backs Val De V Paarl            Za; 423.00",
    transactionType: "expense",
    normalizedMerchant: "Backs Val De Vie",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 423,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining spend."
});
LET $tx_stmt_2025_04_19_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-03-19T00:00:00Z",
  description: "Yoco *Backs Val De V Paarl            Za",
  normalizedDescription: "Backs Val De Vie",
  amount: 423,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Backs Val De Vie",
  merchant: $merchant_backs_val_de_vie,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining spend."
});
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_04_19_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_20.id, "TransactionMerchant", $merchant_backs_val_de_vie.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_20.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-20" AND transaction = $tx_stmt_2025_04_19_row_20.id AND status = "open";

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-03-20T00:00:00Z",
  description: "Google Gsuite_Mpiredigitadublin       Ie",
  normalizedDescription: "Google Workspace",
  amount: 173.28,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 21,
    rawRowText: "Google Gsuite_Mpiredigitadublin       Ie; 173.28",
    transactionType: "expense",
    normalizedMerchant: "Google Workspace",
    category: "Business expenses paid personally / software",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 173.28,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Google Workspace / MPIRE business operating cost paid from the personal credit card."
});
LET $tx_stmt_2025_04_19_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-03-20T00:00:00Z",
  description: "Google Gsuite_Mpiredigitadublin       Ie",
  normalizedDescription: "Google Workspace",
  amount: 173.28,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Google Workspace",
  merchant: $merchant_google_workspace,
  category: $cat_business_expenses_paid_personally_software,
  isTransfer: false,
  manualOverride: false,
  notes: "Google Workspace / MPIRE business operating cost paid from the personal credit card."
});
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_04_19_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_21.id, "TransactionMerchant", $merchant_google_workspace.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_21.id, "TransactionCategory", $cat_business_expenses_paid_personally_software.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-21" AND transaction = $tx_stmt_2025_04_19_row_21.id AND status = "open";

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-03-20T00:00:00Z",
  description: "Google Gsuite_Mpiredigitadublin       Ie",
  normalizedDescription: "Google Workspace",
  amount: 279.58,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 22,
    rawRowText: "Google Gsuite_Mpiredigitadublin       Ie; 279.58",
    transactionType: "expense",
    normalizedMerchant: "Google Workspace",
    category: "Business expenses paid personally / software",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 279.58,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Google Workspace / MPIRE business operating cost paid from the personal credit card."
});
LET $tx_stmt_2025_04_19_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-03-20T00:00:00Z",
  description: "Google Gsuite_Mpiredigitadublin       Ie",
  normalizedDescription: "Google Workspace",
  amount: 279.58,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Google Workspace",
  merchant: $merchant_google_workspace,
  category: $cat_business_expenses_paid_personally_software,
  isTransfer: false,
  manualOverride: false,
  notes: "Google Workspace / MPIRE business operating cost paid from the personal credit card."
});
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_04_19_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_22.id, "TransactionMerchant", $merchant_google_workspace.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_22.id, "TransactionCategory", $cat_business_expenses_paid_personally_software.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-22" AND transaction = $tx_stmt_2025_04_19_row_22.id AND status = "open";

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-03-20T00:00:00Z",
  description: "Yoco *La Concorde So Paarl           Za",
  normalizedDescription: "La Concorde",
  amount: 610,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 23,
    rawRowText: "Yoco *La Concorde So Paarl           Za; 610.00",
    transactionType: "expense",
    normalizedMerchant: "La Concorde",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 610,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Unknown merchant; needs later review."
});
LET $tx_stmt_2025_04_19_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-03-20T00:00:00Z",
  description: "Yoco *La Concorde So Paarl           Za",
  normalizedDescription: "La Concorde",
  amount: 610,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "La Concorde",
  merchant: $merchant_la_concorde,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Unknown merchant; needs later review."
});
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_04_19_row_23.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_23.id, "TransactionMerchant", $merchant_la_concorde.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_23.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_19_row_23 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-19-row-23",
  transaction: $tx_stmt_2025_04_19_row_23,
  status: "open",
  question: "What is the exact purpose of this La Concorde transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_la_concorde,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-04-20.import.md"
});
fn::createEdge($tx_stmt_2025_04_19_row_23.id, "TransactionClarificationTasks", $task_stmt_2025_04_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-03-21T00:00:00Z",
  description: "Paypal *Ui8          4155490650 Us",
  normalizedDescription: "UI8",
  amount: 171.24,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 24,
    rawRowText: "Paypal *Ui8          4155490650 Us; 171.24",
    transactionType: "expense",
    normalizedMerchant: "UI8",
    category: "Design resources",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 171.24,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Design resource asset for a project."
});
LET $tx_stmt_2025_04_19_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-03-21T00:00:00Z",
  description: "Paypal *Ui8          4155490650 Us",
  normalizedDescription: "UI8",
  amount: 171.24,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "UI8",
  merchant: $merchant_ui8,
  category: $cat_design_resources,
  isTransfer: false,
  manualOverride: false,
  notes: "Design resource asset for a project."
});
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_04_19_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_24.id, "TransactionMerchant", $merchant_ui8.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_24.id, "TransactionCategory", $cat_design_resources.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-24" AND transaction = $tx_stmt_2025_04_19_row_24.id AND status = "open";

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-03-22T00:00:00Z",
  description: "Bootlegger Coffee107069 Cape Town Za",
  normalizedDescription: "Bootlegger Coffee",
  amount: 155,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 25,
    rawRowText: "Bootlegger Coffee107069 Cape Town Za; 155.00",
    transactionType: "expense",
    normalizedMerchant: "Bootlegger Coffee",
    category: "Coffee / takeaway",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 155,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Coffee spend."
});
LET $tx_stmt_2025_04_19_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-03-22T00:00:00Z",
  description: "Bootlegger Coffee107069 Cape Town Za",
  normalizedDescription: "Bootlegger Coffee",
  amount: 155,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Bootlegger Coffee",
  merchant: $merchant_bootlegger_coffee,
  category: $cat_coffee_takeaway,
  isTransfer: false,
  manualOverride: false,
  notes: "Coffee spend."
});
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_04_19_row_25.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_25.id, "TransactionMerchant", $merchant_bootlegger_coffee.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_25.id, "TransactionCategory", $cat_coffee_takeaway.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-25" AND transaction = $tx_stmt_2025_04_19_row_25.id AND status = "open";

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-03-22T00:00:00Z",
  description: "Kalahari Slate Waterfrontcape Town         Za",
  normalizedDescription: "Kalahari Slate Waterfront",
  amount: 110,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 26,
    rawRowText: "Kalahari Slate Waterfrontcape Town         Za; 110.00",
    transactionType: "expense",
    normalizedMerchant: "Kalahari Slate Waterfront",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 110,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Unknown merchant; needs later review."
});
LET $tx_stmt_2025_04_19_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-03-22T00:00:00Z",
  description: "Kalahari Slate Waterfrontcape Town         Za",
  normalizedDescription: "Kalahari Slate Waterfront",
  amount: 110,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Kalahari Slate Waterfront",
  merchant: $merchant_kalahari_slate_waterfront,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Unknown merchant; needs later review."
});
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_04_19_row_26.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_26.id, "TransactionMerchant", $merchant_kalahari_slate_waterfront.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_26.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_19_row_26 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-19-row-26",
  transaction: $tx_stmt_2025_04_19_row_26,
  status: "open",
  question: "What is the exact purpose of this Kalahari Slate Waterfront transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_kalahari_slate_waterfront,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-04-20.import.md"
});
fn::createEdge($tx_stmt_2025_04_19_row_26.id, "TransactionClarificationTasks", $task_stmt_2025_04_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-03-29T00:00:00Z",
  description: "Takealo*T              Cape Town    Za",
  normalizedDescription: "Takealot",
  amount: 374,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 27,
    rawRowText: "Takealo*T              Cape Town    Za; 374.00",
    transactionType: "expense",
    normalizedMerchant: "Takealot",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 374,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Unknown Takealot purchase; needs order-history review."
});
LET $tx_stmt_2025_04_19_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-03-29T00:00:00Z",
  description: "Takealo*T              Cape Town    Za",
  normalizedDescription: "Takealot",
  amount: 374,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Takealot",
  merchant: $merchant_takealot,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Unknown Takealot purchase; needs order-history review."
});
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_04_19_row_27.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_27.id, "TransactionMerchant", $merchant_takealot.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_27.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_19_row_27 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-19-row-27",
  transaction: $tx_stmt_2025_04_19_row_27,
  status: "open",
  question: "What is the exact purpose of this Takealot transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_takealot,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-04-20.import.md"
});
fn::createEdge($tx_stmt_2025_04_19_row_27.id, "TransactionClarificationTasks", $task_stmt_2025_04_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-03-29T00:00:00Z",
  description: "Wise             London    Gb",
  normalizedDescription: "Wise",
  amount: 550.13,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 28,
    rawRowText: "Wise             London    Gb; 550.13",
    transactionType: "transfer",
    normalizedMerchant: "Wise",
    category: "Foreign account funding",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 550.13,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Transfer via Wise to fund the UK account."
});
LET $tx_stmt_2025_04_19_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-03-29T00:00:00Z",
  description: "Wise             London    Gb",
  normalizedDescription: "Wise",
  amount: 550.13,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Wise",
  merchant: $merchant_wise,
  category: $cat_foreign_account_funding,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer via Wise to fund the UK account."
});
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_04_19_row_28.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_28.id, "TransactionMerchant", $merchant_wise.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_28.id, "TransactionCategory", $cat_foreign_account_funding.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-28" AND transaction = $tx_stmt_2025_04_19_row_28.id AND status = "open";

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-04-01T00:00:00Z",
  description: "I Afrihost.Com 4    Cape Town        Za",
  normalizedDescription: "Afrihost",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 29,
    rawRowText: "I Afrihost.Com 4    Cape Town        Za; 419.00",
    transactionType: "expense",
    normalizedMerchant: "Afrihost",
    category: "Business expenses paid personally / mobile phone",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 419,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Recurring Afrihost mobile phone contract that should be paid from the business."
});
LET $tx_stmt_2025_04_19_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-04-01T00:00:00Z",
  description: "I Afrihost.Com 4    Cape Town        Za",
  normalizedDescription: "Afrihost",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Afrihost",
  merchant: $merchant_afrihost,
  category: $cat_business_expenses_paid_personally_mobile_phone,
  isTransfer: false,
  manualOverride: false,
  notes: "Recurring Afrihost mobile phone contract that should be paid from the business."
});
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_04_19_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_29.id, "TransactionMerchant", $merchant_afrihost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_29.id, "TransactionCategory", $cat_business_expenses_paid_personally_mobile_phone.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-29" AND transaction = $tx_stmt_2025_04_19_row_29.id AND status = "open";

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-04-02T00:00:00Z",
  description: "Spotifyza        Stockholm Se",
  normalizedDescription: "Spotify",
  amount: 64.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 30,
    rawRowText: "Spotifyza        Stockholm Se; 64.99",
    transactionType: "expense",
    normalizedMerchant: "Spotify",
    category: "Subscription / media",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 64.99,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Media subscription."
});
LET $tx_stmt_2025_04_19_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-04-02T00:00:00Z",
  description: "Spotifyza        Stockholm Se",
  normalizedDescription: "Spotify",
  amount: 64.99,
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
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_04_19_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_30.id, "TransactionMerchant", $merchant_spotify.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_30.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-30" AND transaction = $tx_stmt_2025_04_19_row_30.id AND status = "open";

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-04-04T00:00:00Z",
  description: "Yoco *Backs Val De V Paarl    Za",
  normalizedDescription: "Backs Val De Vie",
  amount: 149.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 31,
    rawRowText: "Yoco *Backs Val De V Paarl    Za; 149.99",
    transactionType: "expense",
    normalizedMerchant: "Backs Val De Vie",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 149.99,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining spend."
});
LET $tx_stmt_2025_04_19_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-04-04T00:00:00Z",
  description: "Yoco *Backs Val De V Paarl    Za",
  normalizedDescription: "Backs Val De Vie",
  amount: 149.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Backs Val De Vie",
  merchant: $merchant_backs_val_de_vie,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining spend."
});
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_04_19_row_31.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_31.id, "TransactionMerchant", $merchant_backs_val_de_vie.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_31.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-31" AND transaction = $tx_stmt_2025_04_19_row_31.id AND status = "open";

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-04-05T00:00:00Z",
  description: "Reza Ferreira Optometr 0000000000000za",
  normalizedDescription: "Reza Ferreira Optometr",
  amount: 2266,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 32,
    rawRowText: "Reza Ferreira Optometr 0000000000000za; 2266.00",
    transactionType: "expense",
    normalizedMerchant: "Reza Ferreira Optometr",
    category: "Healthcare / optometry",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2266,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Contact lenses."
});
LET $tx_stmt_2025_04_19_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-04-05T00:00:00Z",
  description: "Reza Ferreira Optometr 0000000000000za",
  normalizedDescription: "Reza Ferreira Optometr",
  amount: 2266,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Reza Ferreira Optometr",
  merchant: $merchant_reza_ferreira_optometr,
  category: $cat_healthcare_optometry,
  isTransfer: false,
  manualOverride: false,
  notes: "Contact lenses."
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_04_19_row_32.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_32.id, "TransactionMerchant", $merchant_reza_ferreira_optometr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_32.id, "TransactionCategory", $cat_healthcare_optometry.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-32" AND transaction = $tx_stmt_2025_04_19_row_32.id AND status = "open";

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-04-05T00:00:00Z",
  description: "Clicks Drakenstein      0000000000000za",
  normalizedDescription: "Clicks Stellenbosch Square",
  amount: 1219.59,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 33,
    rawRowText: "Clicks Drakenstein      0000000000000za; 1219.59",
    transactionType: "expense",
    normalizedMerchant: "Clicks Stellenbosch Square",
    category: "Personal care / pharmacy",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1219.59,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Pharmacy or personal-care spend."
});
LET $tx_stmt_2025_04_19_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-04-05T00:00:00Z",
  description: "Clicks Drakenstein      0000000000000za",
  normalizedDescription: "Clicks Stellenbosch Square",
  amount: 1219.59,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Clicks Stellenbosch Square",
  merchant: $merchant_clicks_stellenbosch_square,
  category: $cat_personal_care_pharmacy,
  isTransfer: false,
  manualOverride: false,
  notes: "Pharmacy or personal-care spend."
});
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_04_19_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_33.id, "TransactionMerchant", $merchant_clicks_stellenbosch_square.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_33.id, "TransactionCategory", $cat_personal_care_pharmacy.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-33" AND transaction = $tx_stmt_2025_04_19_row_33.id AND status = "open";

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-04-07T00:00:00Z",
  description: "Hyrotrader        Bratislava Sk",
  normalizedDescription: "HyroTrader",
  amount: 12020.44,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 34,
    rawRowText: "Hyrotrader        Bratislava Sk; 12020.44",
    transactionType: "expense",
    normalizedMerchant: "HyroTrader",
    category: "Business expenses paid personally / trading challenge fees",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 12020.44,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Trading challenge fee paid from the personal credit card."
});
LET $tx_stmt_2025_04_19_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-04-07T00:00:00Z",
  description: "Hyrotrader        Bratislava Sk",
  normalizedDescription: "HyroTrader",
  amount: 12020.44,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "HyroTrader",
  merchant: $merchant_hyrotrader,
  category: $cat_business_expenses_paid_personally_trading_challenge_fees,
  isTransfer: false,
  manualOverride: false,
  notes: "Trading challenge fee paid from the personal credit card."
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_04_19_row_34.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_34.id, "TransactionMerchant", $merchant_hyrotrader.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_34.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_challenge_fees.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-34" AND transaction = $tx_stmt_2025_04_19_row_34.id AND status = "open";

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2025-04-08T00:00:00Z",
  description: "Tradinglite      Tallinn    Ee",
  normalizedDescription: "Tradinglite",
  amount: 500.68,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 35,
    rawRowText: "Tradinglite      Tallinn    Ee; 500.68",
    transactionType: "expense",
    normalizedMerchant: "Tradinglite",
    category: "Business expenses paid personally / trading software",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 500.68,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Trading software subscription."
});
LET $tx_stmt_2025_04_19_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-35",
  sourceRow: $row_row_35,
  postedAt: "2025-04-08T00:00:00Z",
  description: "Tradinglite      Tallinn    Ee",
  normalizedDescription: "Tradinglite",
  amount: 500.68,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Tradinglite",
  merchant: $merchant_tradinglite,
  category: $cat_business_expenses_paid_personally_trading_software,
  isTransfer: false,
  manualOverride: false,
  notes: "Trading software subscription."
});
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_04_19_row_35.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_35.id, "TransactionMerchant", $merchant_tradinglite.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_35.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_software.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-35" AND transaction = $tx_stmt_2025_04_19_row_35.id AND status = "open";

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2025-04-08T00:00:00Z",
  description: "Yoco *Plato Val De V Val De Vie Wiza",
  normalizedDescription: "Plato Val De Vie",
  amount: 76,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 36,
    rawRowText: "Yoco *Plato Val De V Val De Vie Wiza; 76.00",
    transactionType: "expense",
    normalizedMerchant: "Plato Val De Vie",
    category: "Coffee / takeaway",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 76,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Coffee spend."
});
LET $tx_stmt_2025_04_19_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-36",
  sourceRow: $row_row_36,
  postedAt: "2025-04-08T00:00:00Z",
  description: "Yoco *Plato Val De V Val De Vie Wiza",
  normalizedDescription: "Plato Val De Vie",
  amount: 76,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Plato Val De Vie",
  merchant: $merchant_plato_val_de_vie,
  category: $cat_coffee_takeaway,
  isTransfer: false,
  manualOverride: false,
  notes: "Coffee spend."
});
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_04_19_row_36.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_36.id, "TransactionMerchant", $merchant_plato_val_de_vie.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_36.id, "TransactionCategory", $cat_coffee_takeaway.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-36" AND transaction = $tx_stmt_2025_04_19_row_36.id AND status = "open";

-- Row 37
LET $row_row_37 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 37,
  postedAt: "2025-04-08T00:00:00Z",
  description: "Paypal *Paddle.Net    35314369001 Gb",
  normalizedDescription: "Paddle.net",
  amount: 1274.31,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 37,
    rawRowText: "Paypal *Paddle.Net    35314369001 Gb; 1274.31",
    transactionType: "expense",
    normalizedMerchant: "Paddle.net",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1274.31,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Unknown PayPal / Paddle charge; add to research list."
});
LET $tx_stmt_2025_04_19_row_37 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-37",
  sourceRow: $row_row_37,
  postedAt: "2025-04-08T00:00:00Z",
  description: "Paypal *Paddle.Net    35314369001 Gb",
  normalizedDescription: "Paddle.net",
  amount: 1274.31,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Paddle.net",
  merchant: $merchant_paddle_net,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Unknown PayPal / Paddle charge; add to research list."
});
fn::updateStatementRow($row_row_37.id, { transaction: $tx_stmt_2025_04_19_row_37.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_37.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_37.id, "TransactionMerchant", $merchant_paddle_net.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_37.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_04_19_row_37 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-04-19-row-37",
  transaction: $tx_stmt_2025_04_19_row_37,
  status: "open",
  question: "What is the exact purpose of this Paddle.net transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paddle_net,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-04-20.import.md"
});
fn::createEdge($tx_stmt_2025_04_19_row_37.id, "TransactionClarificationTasks", $task_stmt_2025_04_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 38
LET $row_row_38 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 38,
  postedAt: "2025-04-09T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 1324.78,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 38,
    rawRowText: "The Local Choic 202880 Val De Vie E Za; 1324.78",
    transactionType: "expense",
    normalizedMerchant: "The Local Choic 202880 Val De Vie E Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1324.78,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_04_19_row_38 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-38",
  sourceRow: $row_row_38,
  postedAt: "2025-04-09T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 1324.78,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "The Local Choic 202880 Val De Vie E Za",
  merchant: $merchant_the_local_choic_202880_val_de_vie_e_za,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_38.id, { transaction: $tx_stmt_2025_04_19_row_38.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_38.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_38.id, "TransactionMerchant", $merchant_the_local_choic_202880_val_de_vie_e_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_38.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-38" AND transaction = $tx_stmt_2025_04_19_row_38.id AND status = "open";

-- Row 39
LET $row_row_39 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 39,
  postedAt: "2025-04-11T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 10000,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 39,
    rawRowText: "Electronic Payment From:Internet Banking; 10000.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 10000,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2025_04_19_row_39 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-39",
  sourceRow: $row_row_39,
  postedAt: "2025-04-11T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 10000,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Internet Banking",
  merchant: $merchant_nedbank_internet_banking,
  category: $cat_cash_advance,
  isTransfer: true,
  manualOverride: false,
  notes: "Cash advance or cash transfer from the credit card."
});
fn::updateStatementRow($row_row_39.id, { transaction: $tx_stmt_2025_04_19_row_39.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_39.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_39.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_39.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-39" AND transaction = $tx_stmt_2025_04_19_row_39.id AND status = "open";

-- Row 40
LET $row_row_40 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 40,
  postedAt: "2025-04-11T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 40,
    rawRowText: "I Valr Pty Ltd         Cape Town    Za; 2000.00",
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
LET $tx_stmt_2025_04_19_row_40 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-40",
  sourceRow: $row_row_40,
  postedAt: "2025-04-11T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
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
fn::updateStatementRow($row_row_40.id, { transaction: $tx_stmt_2025_04_19_row_40.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_40.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_40.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_40.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-40" AND transaction = $tx_stmt_2025_04_19_row_40.id AND status = "open";

-- Row 41
LET $row_row_41 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 41,
  postedAt: "2025-04-13T00:00:00Z",
  description: "Trade Travel Chill    Abu Dhabi Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1171.86,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 41,
    rawRowText: "Trade Travel Chill    Abu Dhabi Ae; 1171.86",
    transactionType: "expense",
    normalizedMerchant: "Trade Travel Chill",
    category: "Business expenses paid personally / trading tools",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1171.86,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Recurring trading-indicator or trading-service spend."
});
LET $tx_stmt_2025_04_19_row_41 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-41",
  sourceRow: $row_row_41,
  postedAt: "2025-04-13T00:00:00Z",
  description: "Trade Travel Chill    Abu Dhabi Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1171.86,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Trade Travel Chill",
  merchant: $merchant_trade_travel_chill,
  category: $cat_business_expenses_paid_personally_trading_tools,
  isTransfer: false,
  manualOverride: false,
  notes: "Recurring trading-indicator or trading-service spend."
});
fn::updateStatementRow($row_row_41.id, { transaction: $tx_stmt_2025_04_19_row_41.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_41.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_41.id, "TransactionMerchant", $merchant_trade_travel_chill.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_41.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_tools.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-41" AND transaction = $tx_stmt_2025_04_19_row_41.id AND status = "open";

-- Row 42
LET $row_row_42 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 42,
  postedAt: "2025-04-13T00:00:00Z",
  description: "Wise               London   Gb",
  normalizedDescription: "Wise",
  amount: 5258.97,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 42,
    rawRowText: "Wise               London   Gb; 5258.97",
    transactionType: "transfer",
    normalizedMerchant: "Wise",
    category: "Foreign account funding",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 5258.97,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Transfer via Wise to fund the UK account."
});
LET $tx_stmt_2025_04_19_row_42 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-42",
  sourceRow: $row_row_42,
  postedAt: "2025-04-13T00:00:00Z",
  description: "Wise               London   Gb",
  normalizedDescription: "Wise",
  amount: 5258.97,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Wise",
  merchant: $merchant_wise,
  category: $cat_foreign_account_funding,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer via Wise to fund the UK account."
});
fn::updateStatementRow($row_row_42.id, { transaction: $tx_stmt_2025_04_19_row_42.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_42.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_42.id, "TransactionMerchant", $merchant_wise.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_42.id, "TransactionCategory", $cat_foreign_account_funding.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-42" AND transaction = $tx_stmt_2025_04_19_row_42.id AND status = "open";

-- Row 43
LET $row_row_43 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 43,
  postedAt: "2025-04-16T00:00:00Z",
  description: "Yoco *Plato Val De V Val De Vie Wiza",
  normalizedDescription: "Plato Val De Vie",
  amount: 43,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 43,
    rawRowText: "Yoco *Plato Val De V Val De Vie Wiza; 43.00",
    transactionType: "expense",
    normalizedMerchant: "Plato Val De Vie",
    category: "Coffee / takeaway",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 43,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Coffee spend."
});
LET $tx_stmt_2025_04_19_row_43 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-43",
  sourceRow: $row_row_43,
  postedAt: "2025-04-16T00:00:00Z",
  description: "Yoco *Plato Val De V Val De Vie Wiza",
  normalizedDescription: "Plato Val De Vie",
  amount: 43,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Plato Val De Vie",
  merchant: $merchant_plato_val_de_vie,
  category: $cat_coffee_takeaway,
  isTransfer: false,
  manualOverride: false,
  notes: "Coffee spend."
});
fn::updateStatementRow($row_row_43.id, { transaction: $tx_stmt_2025_04_19_row_43.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_43.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_43.id, "TransactionMerchant", $merchant_plato_val_de_vie.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_43.id, "TransactionCategory", $cat_coffee_takeaway.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-43" AND transaction = $tx_stmt_2025_04_19_row_43.id AND status = "open";

-- Row 44
LET $row_row_44 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 44,
  postedAt: "2025-04-16T00:00:00Z",
  description: "Yoco *Backs Val De V Paarl            Za",
  normalizedDescription: "Backs Val De Vie",
  amount: 684.74,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/April 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 44,
    rawRowText: "Yoco *Backs Val De V Paarl            Za; 684.74",
    transactionType: "expense",
    normalizedMerchant: "Backs Val De Vie",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 684.74,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining spend."
});
LET $tx_stmt_2025_04_19_row_44 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-44",
  sourceRow: $row_row_44,
  postedAt: "2025-04-16T00:00:00Z",
  description: "Yoco *Backs Val De V Paarl            Za",
  normalizedDescription: "Backs Val De Vie",
  amount: 684.74,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Backs Val De Vie",
  merchant: $merchant_backs_val_de_vie,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining spend."
});
fn::updateStatementRow($row_row_44.id, { transaction: $tx_stmt_2025_04_19_row_44.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_44.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_44.id, "TransactionMerchant", $merchant_backs_val_de_vie.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_44.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-44" AND transaction = $tx_stmt_2025_04_19_row_44.id AND status = "open";

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 44,
  normalizedCount: 44,
  clarificationCount: 4,
  status: "matched",
  statementDate: "2025-04-19T00:00:00Z",
  notes: "Imported from 2025-04-20.import.md"
});

-- End of generated import
