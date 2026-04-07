-- Generated from docs/statements/personal/credit/2025-05-19.import.md
-- Source: docs/statements/personal/credit/May 2025.pdf

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
  openingBalance: 106453.34,
  active: true,
  notes: "Imported from May 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-05-19-nedbank-credit",
  sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-05-19T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-05-19.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_fast_food_takeout = fn::createCategory({
  space: $space,
  key: "fast-food-takeout",
  name: "Fast food / takeout",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_crypto_trading = fn::createCategory({
  space: $space,
  key: "crypto-trading",
  name: "Crypto / trading",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_household_firewood = fn::createCategory({
  space: $space,
  key: "household-firewood",
  name: "Household / firewood",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_cash_advance = fn::createCategory({
  space: $space,
  key: "cash-advance",
  name: "Cash advance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_dining_lifestyle = fn::createCategory({
  space: $space,
  key: "dining-lifestyle",
  name: "Dining / lifestyle",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_business_expenses_paid_personally_mobile_phone = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-mobile-phone",
  name: "Business expenses paid personally / mobile phone",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_subscription_media = fn::createCategory({
  space: $space,
  key: "subscription-media",
  name: "Subscription / media",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_fuel_transport = fn::createCategory({
  space: $space,
  key: "fuel-transport",
  name: "Fuel / transport",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_social_restaurant = fn::createCategory({
  space: $space,
  key: "social-restaurant",
  name: "Social / restaurant",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_food_takeaway = fn::createCategory({
  space: $space,
  key: "food-takeaway",
  name: "Food / takeaway",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_fuel_station_snacks = fn::createCategory({
  space: $space,
  key: "fuel-station-snacks",
  name: "Fuel-station snacks",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_business_expenses_paid_personally_trading_tools = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-trading-tools",
  name: "Business expenses paid personally / trading tools",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_groceries_household = fn::createCategory({
  space: $space,
  key: "groceries-household",
  name: "Groceries / household",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_kids_books = fn::createCategory({
  space: $space,
  key: "kids-books",
  name: "Kids / books",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_parking = fn::createCategory({
  space: $space,
  key: "parking",
  name: "Parking",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_fees_electronic_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-electronic-payment-fee",
  name: "Electronic Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_fees_declined_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-declined-payment-fee",
  name: "Declined Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_fees_credit_facility_service_fee = fn::createCategory({
  space: $space,
  key: "fees-credit-facility-service-fee",
  name: "Credit Facility Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_fees_finance_charge = fn::createCategory({
  space: $space,
  key: "fees-finance-charge",
  name: "Finance Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});

-- Merchant records
LET $merchant_nedbank_current_account = fn::createMerchant({
  space: $space,
  key: "nedbank-current-account",
  name: "Nedbank Current Account",
  normalizedName: "Nedbank Current Account",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_backs_restaurant_and_d = fn::createMerchant({
  space: $space,
  key: "backs-restaurant-and-d",
  name: "Backs Restaurant And D",
  normalizedName: "Backs Restaurant And D",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_valr = fn::createMerchant({
  space: $space,
  key: "valr",
  name: "VALR",
  normalizedName: "VALR",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_stompies_wood = fn::createMerchant({
  space: $space,
  key: "stompies-wood",
  name: "Stompies Wood",
  normalizedName: "Stompies Wood",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_nedbank_internet_banking = fn::createMerchant({
  space: $space,
  key: "nedbank-internet-banking",
  name: "Nedbank Internet Banking",
  normalizedName: "Nedbank Internet Banking",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_hey_joe_brewery = fn::createMerchant({
  space: $space,
  key: "hey-joe-brewery",
  name: "Hey Joe Brewery",
  normalizedName: "Hey Joe Brewery",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_afrihost = fn::createMerchant({
  space: $space,
  key: "afrihost",
  name: "Afrihost",
  normalizedName: "Afrihost",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_spotify = fn::createMerchant({
  space: $space,
  key: "spotify",
  name: "Spotify",
  normalizedName: "Spotify",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_aegir_project = fn::createMerchant({
  space: $space,
  key: "aegir-project",
  name: "Aegir Project",
  normalizedName: "Aegir Project",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_c_valley_motors_bp_noordhoek_za = fn::createMerchant({
  space: $space,
  key: "c-valley-motors-bp-noordhoek-za",
  name: "C*Valley Motors Bp       Noordhoek          Za",
  normalizedName: "C*Valley Motors Bp       Noordhoek          Za",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_the_village_roast = fn::createMerchant({
  space: $space,
  key: "the-village-roast",
  name: "The Village Roast",
  normalizedName: "The Village Roast",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_cafe_roux = fn::createMerchant({
  space: $space,
  key: "cafe-roux",
  name: "Cafe Roux",
  normalizedName: "Cafe Roux",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_valley_motors = fn::createMerchant({
  space: $space,
  key: "valley-motors",
  name: "Valley Motors",
  normalizedName: "Valley Motors",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_our_pizza_place = fn::createMerchant({
  space: $space,
  key: "our-pizza-place",
  name: "Our Pizza Place",
  normalizedName: "Our Pizza Place",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_wicked_bites = fn::createMerchant({
  space: $space,
  key: "wicked-bites",
  name: "Wicked Bites",
  normalizedName: "Wicked Bites",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_squirrel_games = fn::createMerchant({
  space: $space,
  key: "squirrel-games",
  name: "Squirrel Games",
  normalizedName: "Squirrel Games",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_total_table_view = fn::createMerchant({
  space: $space,
  key: "total-table-view",
  name: "Total Table View",
  normalizedName: "Total Table View",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_hyrotrader = fn::createMerchant({
  space: $space,
  key: "hyrotrader",
  name: "HyroTrader",
  normalizedName: "HyroTrader",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_takealot = fn::createMerchant({
  space: $space,
  key: "takealot",
  name: "Takealot",
  normalizedName: "Takealot",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_checkers_capegate = fn::createMerchant({
  space: $space,
  key: "checkers-capegate",
  name: "Checkers Capegate",
  normalizedName: "Checkers Capegate",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_woolworths_paarl_za = fn::createMerchant({
  space: $space,
  key: "woolworths-paarl-za",
  name: "Woolworths            Paarl       Za",
  normalizedName: "Woolworths            Paarl       Za",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_bargain_books_capegate = fn::createMerchant({
  space: $space,
  key: "bargain-books-capegate",
  name: "Bargain Books Capegate",
  normalizedName: "Bargain Books Capegate",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});
LET $merchant_advance_cape_gate = fn::createMerchant({
  space: $space,
  key: "advance-cape-gate",
  name: "Advance Cape Gate",
  normalizedName: "Advance Cape Gate",
  active: true,
  notes: "Imported from 2025-05-19.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-04-30T00:00:00Z",
  description: "A P O Payment - Thank You",
  normalizedDescription: "Nedbank Current Account",
  amount: 2326,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 1,
    rawRowText: "A P O Payment - Thank You; 2326.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2326,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Automatic debt-payment receipt from the personal current account."
});
LET $tx_stmt_2025_05_19_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-04-30T00:00:00Z",
  description: "A P O Payment - Thank You",
  normalizedDescription: "Nedbank Current Account",
  amount: 2326,
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
  notes: "Automatic debt-payment receipt from the personal current account."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_05_19_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_01.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_01.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-04-22T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2190,
  balance: 2190,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 2,
    rawRowText: "Internet Banking Transferselby     Za; 2190.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2190,
    bankChargeZar: null,
    balanceZar: 2190
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_05_19_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-04-22T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2190,
  balance: 2190,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_05_19_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_02.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_02.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-04-29T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 944,
  balance: 944,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 3,
    rawRowText: "Internet Banking Transferselby     Za; 944.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 944,
    bankChargeZar: null,
    balanceZar: 944
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_05_19_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-04-29T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 944,
  balance: 944,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_05_19_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_03.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_03.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-05-02T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 3650,
  balance: 3650,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 4,
    rawRowText: "Internet Banking Transferselby     Za; 3650.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 3650,
    bankChargeZar: null,
    balanceZar: 3650
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_05_19_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-05-02T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 3650,
  balance: 3650,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_05_19_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_04.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_04.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-05-05T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 12500,
  balance: 12500,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 5,
    rawRowText: "Internet Banking Transferselby     Za; 12500.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 12500,
    bankChargeZar: null,
    balanceZar: 12500
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_05_19_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-05-05T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 12500,
  balance: 12500,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_05_19_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_05.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_05.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-05-08T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2000,
  balance: 2000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 6,
    rawRowText: "Internet Banking Transferselby     Za; 2000.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: 2000
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_05_19_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-05-08T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2000,
  balance: 2000,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_05_19_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_06.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_06.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-05-10T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1260,
  balance: 1260,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 7,
    rawRowText: "Internet Banking Transferselby     Za; 1260.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1260,
    bankChargeZar: null,
    balanceZar: 1260
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_05_19_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-05-10T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1260,
  balance: 1260,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_05_19_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_07.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_07.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 204,
  balance: 204,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 8,
    rawRowText: "Internet Banking Transferselby     Za; 204.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 204,
    bankChargeZar: null,
    balanceZar: 204
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_05_19_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 204,
  balance: 204,
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_05_19_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_08.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_08.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-04-23T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 9,
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
LET $tx_stmt_2025_05_19_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-04-23T00:00:00Z",
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_05_19_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_09.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_09.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-05-08T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
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
LET $tx_stmt_2025_05_19_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-05-08T00:00:00Z",
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_05_19_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_10.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_10.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-05-13T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
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
LET $tx_stmt_2025_05_19_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-05-13T00:00:00Z",
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_05_19_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_11.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_11.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-05-13T00:00:00Z",
  description: "Maintenance Fee",
  normalizedDescription: "Maintenance Fee",
  amount: 38.26,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 12,
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
LET $tx_stmt_2025_05_19_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-05-13T00:00:00Z",
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_05_19_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_12.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_12.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-05-14T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
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
LET $tx_stmt_2025_05_19_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-05-14T00:00:00Z",
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_05_19_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_13.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_13.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-05-14T00:00:00Z",
  description: "Credit Facility Service Fee",
  normalizedDescription: "Credit Facility Service Fee",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 14,
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
LET $tx_stmt_2025_05_19_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-05-14T00:00:00Z",
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_05_19_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_14.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_14.id, "TransactionCategory", $cat_fees_credit_facility_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
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
LET $tx_stmt_2025_05_19_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-05-19T00:00:00Z",
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_05_19_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_15.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_15.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 1922.11,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 16,
    rawRowText: "Finance Charge; 1922.11",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "finance charge",
    clarificationStatus: "clarified",
    amountZar: 1922.11,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Finance charge on the outstanding balance."
});
LET $tx_stmt_2025_05_19_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 1922.11,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_05_19_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_16.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_16.id, "TransactionCategory", $cat_fees_finance_charge.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 15.24,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 17,
    rawRowText: "Total V A T; 15.24",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 15.24,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "VAT on fees."
});
LET $tx_stmt_2025_05_19_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 15.24,
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_05_19_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_17.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_17.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-04-17T00:00:00Z",
  description: "Backs Restaurant And D Paarl            Za",
  normalizedDescription: "Backs Restaurant And D",
  amount: 305,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 19,
    rawRowText: "Backs Restaurant And D Paarl            Za; 305.00",
    transactionType: "expense",
    normalizedMerchant: "Backs Restaurant And D",
    category: "Fast food / takeout",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 305,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fast-food takeout."
});
LET $tx_stmt_2025_05_19_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-04-17T00:00:00Z",
  description: "Backs Restaurant And D Paarl            Za",
  normalizedDescription: "Backs Restaurant And D",
  amount: 305,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Backs Restaurant And D",
  merchant: $merchant_backs_restaurant_and_d,
  category: $cat_fast_food_takeout,
  isTransfer: false,
  manualOverride: false,
  notes: "Fast-food takeout."
});
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_05_19_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_19.id, "TransactionMerchant", $merchant_backs_restaurant_and_d.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_19.id, "TransactionCategory", $cat_fast_food_takeout.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-04-17T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 20,
    rawRowText: "I Valr Pty Ltd        Cape Town        Za; 2000.00",
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
LET $tx_stmt_2025_05_19_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-04-17T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
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
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_05_19_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_20.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_20.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-04-20T00:00:00Z",
  description: "Yoco *Stompies Wood       Paarl         Za",
  normalizedDescription: "Stompies Wood",
  amount: 310,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 21,
    rawRowText: "Yoco *Stompies Wood       Paarl         Za; 310.00",
    transactionType: "expense",
    normalizedMerchant: "Stompies Wood",
    category: "Household / firewood",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 310,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Firewood purchase."
});
LET $tx_stmt_2025_05_19_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-04-20T00:00:00Z",
  description: "Yoco *Stompies Wood       Paarl         Za",
  normalizedDescription: "Stompies Wood",
  amount: 310,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Stompies Wood",
  merchant: $merchant_stompies_wood,
  category: $cat_household_firewood,
  isTransfer: false,
  manualOverride: false,
  notes: "Firewood purchase."
});
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_05_19_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_21.id, "TransactionMerchant", $merchant_stompies_wood.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_21.id, "TransactionCategory", $cat_household_firewood.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-04-20T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 22,
    rawRowText: "I Valr Pty Ltd        Cape Town        Za; 2000.00",
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
LET $tx_stmt_2025_05_19_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-04-20T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
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
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_05_19_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_22.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_22.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-04-22T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 23,
    rawRowText: "Electronic Payment From:Internet Banking; 500.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 500,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2025_05_19_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-04-22T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 500,
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_05_19_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_23.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_23.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-04-26T00:00:00Z",
  description: "Backs Restaurant And D Paarl            Za",
  normalizedDescription: "Backs Restaurant And D",
  amount: 155,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 24,
    rawRowText: "Backs Restaurant And D Paarl            Za; 155.00",
    transactionType: "expense",
    normalizedMerchant: "Backs Restaurant And D",
    category: "Fast food / takeout",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 155,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fast-food takeout."
});
LET $tx_stmt_2025_05_19_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-04-26T00:00:00Z",
  description: "Backs Restaurant And D Paarl            Za",
  normalizedDescription: "Backs Restaurant And D",
  amount: 155,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Backs Restaurant And D",
  merchant: $merchant_backs_restaurant_and_d,
  category: $cat_fast_food_takeout,
  isTransfer: false,
  manualOverride: false,
  notes: "Fast-food takeout."
});
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_05_19_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_24.id, "TransactionMerchant", $merchant_backs_restaurant_and_d.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_24.id, "TransactionCategory", $cat_fast_food_takeout.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-04-27T00:00:00Z",
  description: "Ik *Hey Joe Brewery      Dalpark        Za",
  normalizedDescription: "Hey Joe Brewery",
  amount: 800,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 25,
    rawRowText: "Ik *Hey Joe Brewery      Dalpark        Za; 800.00",
    transactionType: "expense",
    normalizedMerchant: "Hey Joe Brewery",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 800,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Eating-out spend."
});
LET $tx_stmt_2025_05_19_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-04-27T00:00:00Z",
  description: "Ik *Hey Joe Brewery      Dalpark        Za",
  normalizedDescription: "Hey Joe Brewery",
  amount: 800,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Hey Joe Brewery",
  merchant: $merchant_hey_joe_brewery,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Eating-out spend."
});
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_05_19_row_25.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_25.id, "TransactionMerchant", $merchant_hey_joe_brewery.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_25.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-05-01T00:00:00Z",
  description: "I Afrihost.Com 4       Cape Town        Za",
  normalizedDescription: "Afrihost",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 26,
    rawRowText: "I Afrihost.Com 4       Cape Town        Za; 419.00",
    transactionType: "expense",
    normalizedMerchant: "Afrihost",
    category: "Business expenses paid personally / mobile phone",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 419,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Mobile phone contract that should be paid by the business."
});
LET $tx_stmt_2025_05_19_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-05-01T00:00:00Z",
  description: "I Afrihost.Com 4       Cape Town        Za",
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
  notes: "Mobile phone contract that should be paid by the business."
});
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_05_19_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_26.id, "TransactionMerchant", $merchant_afrihost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_26.id, "TransactionCategory", $cat_business_expenses_paid_personally_mobile_phone.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-05-02T00:00:00Z",
  description: "Spotifyza         Stockholm Se",
  normalizedDescription: "Spotify",
  amount: 64.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 27,
    rawRowText: "Spotifyza         Stockholm Se; 64.99",
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
LET $tx_stmt_2025_05_19_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-05-02T00:00:00Z",
  description: "Spotifyza         Stockholm Se",
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
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_05_19_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_27.id, "TransactionMerchant", $merchant_spotify.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_27.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-05-03T00:00:00Z",
  description: "Yoco *Aegir Project Cape Town Za",
  normalizedDescription: "Aegir Project",
  amount: 460,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 28,
    rawRowText: "Yoco *Aegir Project Cape Town Za; 460.00",
    transactionType: "expense",
    normalizedMerchant: "Aegir Project",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 460,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Merchant identified, but the underlying spend is still not known."
});
LET $tx_stmt_2025_05_19_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-05-03T00:00:00Z",
  description: "Yoco *Aegir Project Cape Town Za",
  normalizedDescription: "Aegir Project",
  amount: 460,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Aegir Project",
  merchant: $merchant_aegir_project,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Merchant identified, but the underlying spend is still not known."
});
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_05_19_row_28.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_28.id, "TransactionMerchant", $merchant_aegir_project.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_28.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_05_19_row_28 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-05-19-row-28",
  transaction: $tx_stmt_2025_05_19_row_28,
  status: "open",
  question: "What is the exact purpose of this Aegir Project transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_aegir_project,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-05-19.import.md"
});
fn::createEdge($tx_stmt_2025_05_19_row_28.id, "TransactionClarificationTasks", $task_stmt_2025_05_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-05-03T00:00:00Z",
  description: "C*Valley Motors Bp       Noordhoek          Za",
  normalizedDescription: "C*Valley Motors Bp       Noordhoek          Za",
  amount: 1262.38,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 29,
    rawRowText: "C*Valley Motors Bp       Noordhoek          Za; 1262.38",
    transactionType: "expense",
    normalizedMerchant: "C*Valley Motors Bp       Noordhoek          Za",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1262.38,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_05_19_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-05-03T00:00:00Z",
  description: "C*Valley Motors Bp       Noordhoek          Za",
  normalizedDescription: "C*Valley Motors Bp       Noordhoek          Za",
  amount: 1262.38,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "C*Valley Motors Bp       Noordhoek          Za",
  merchant: $merchant_c_valley_motors_bp_noordhoek_za,
  category: $cat_fuel_transport,
  isTransfer: false,
  manualOverride: false,
  notes: "Fuel or transport spend."
});
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_05_19_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_29.id, "TransactionMerchant", $merchant_c_valley_motors_bp_noordhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_29.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-05-03T00:00:00Z",
  description: "The Village Roast      Cae Town        Za",
  normalizedDescription: "The Village Roast",
  amount: 10,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 30,
    rawRowText: "The Village Roast      Cae Town        Za; 10.00",
    transactionType: "expense",
    normalizedMerchant: "The Village Roast",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 10,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Eating-out spend."
});
LET $tx_stmt_2025_05_19_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-05-03T00:00:00Z",
  description: "The Village Roast      Cae Town        Za",
  normalizedDescription: "The Village Roast",
  amount: 10,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "The Village Roast",
  merchant: $merchant_the_village_roast,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Eating-out spend."
});
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_05_19_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_30.id, "TransactionMerchant", $merchant_the_village_roast.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_30.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-05-03T00:00:00Z",
  description: "The Village Roast      Cae Town        Za",
  normalizedDescription: "The Village Roast",
  amount: 160,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 31,
    rawRowText: "The Village Roast      Cae Town        Za; 160.00",
    transactionType: "expense",
    normalizedMerchant: "The Village Roast",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 160,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Eating-out spend."
});
LET $tx_stmt_2025_05_19_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-05-03T00:00:00Z",
  description: "The Village Roast      Cae Town        Za",
  normalizedDescription: "The Village Roast",
  amount: 160,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "The Village Roast",
  merchant: $merchant_the_village_roast,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Eating-out spend."
});
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_05_19_row_31.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_31.id, "TransactionMerchant", $merchant_the_village_roast.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_31.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-05-03T00:00:00Z",
  description: "Cafe Roux             Cape Town        Za",
  normalizedDescription: "Cafe Roux",
  amount: 60,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 32,
    rawRowText: "Cafe Roux             Cape Town        Za; 60.00",
    transactionType: "expense",
    normalizedMerchant: "Cafe Roux",
    category: "Social / restaurant",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 60,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Social or restaurant spend."
});
LET $tx_stmt_2025_05_19_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-05-03T00:00:00Z",
  description: "Cafe Roux             Cape Town        Za",
  normalizedDescription: "Cafe Roux",
  amount: 60,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Cafe Roux",
  merchant: $merchant_cafe_roux,
  category: $cat_social_restaurant,
  isTransfer: false,
  manualOverride: false,
  notes: "Social or restaurant spend."
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_05_19_row_32.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_32.id, "TransactionMerchant", $merchant_cafe_roux.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_32.id, "TransactionCategory", $cat_social_restaurant.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-05-03T00:00:00Z",
  description: "Valley Motors         Noordhoek        Za",
  normalizedDescription: "Valley Motors",
  amount: 167.5,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 33,
    rawRowText: "Valley Motors         Noordhoek        Za; 167.50",
    transactionType: "expense",
    normalizedMerchant: "Valley Motors",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 167.5,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Merchant identified, but the underlying spend is still not known."
});
LET $tx_stmt_2025_05_19_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-05-03T00:00:00Z",
  description: "Valley Motors         Noordhoek        Za",
  normalizedDescription: "Valley Motors",
  amount: 167.5,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Valley Motors",
  merchant: $merchant_valley_motors,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Merchant identified, but the underlying spend is still not known."
});
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_05_19_row_33.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_33.id, "TransactionMerchant", $merchant_valley_motors.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_33.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_05_19_row_33 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-05-19-row-33",
  transaction: $tx_stmt_2025_05_19_row_33,
  status: "open",
  question: "What is the exact purpose of this Valley Motors transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_valley_motors,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-05-19.import.md"
});
fn::createEdge($tx_stmt_2025_05_19_row_33.id, "TransactionClarificationTasks", $task_stmt_2025_05_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-05-04T00:00:00Z",
  description: "Our Pizza Place 131567 Muizenberg Za",
  normalizedDescription: "Our Pizza Place",
  amount: 230,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 34,
    rawRowText: "Our Pizza Place 131567 Muizenberg Za; 230.00",
    transactionType: "expense",
    normalizedMerchant: "Our Pizza Place",
    category: "Fast food / takeout",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 230,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fast-food spend."
});
LET $tx_stmt_2025_05_19_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-05-04T00:00:00Z",
  description: "Our Pizza Place 131567 Muizenberg Za",
  normalizedDescription: "Our Pizza Place",
  amount: 230,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Our Pizza Place",
  merchant: $merchant_our_pizza_place,
  category: $cat_fast_food_takeout,
  isTransfer: false,
  manualOverride: false,
  notes: "Fast-food spend."
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_05_19_row_34.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_34.id, "TransactionMerchant", $merchant_our_pizza_place.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_34.id, "TransactionCategory", $cat_fast_food_takeout.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2025-05-04T00:00:00Z",
  description: "Yoco *Aegir Project     Cape Town       Za",
  normalizedDescription: "Aegir Project",
  amount: 185,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 35,
    rawRowText: "Yoco *Aegir Project     Cape Town       Za; 185.00",
    transactionType: "expense",
    normalizedMerchant: "Aegir Project",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 185,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Merchant identified, but the underlying spend is still not known."
});
LET $tx_stmt_2025_05_19_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-35",
  sourceRow: $row_row_35,
  postedAt: "2025-05-04T00:00:00Z",
  description: "Yoco *Aegir Project     Cape Town       Za",
  normalizedDescription: "Aegir Project",
  amount: 185,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Aegir Project",
  merchant: $merchant_aegir_project,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Merchant identified, but the underlying spend is still not known."
});
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_05_19_row_35.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_35.id, "TransactionMerchant", $merchant_aegir_project.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_35.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_05_19_row_35 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-05-19-row-35",
  transaction: $tx_stmt_2025_05_19_row_35,
  status: "open",
  question: "What is the exact purpose of this Aegir Project transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_aegir_project,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-05-19.import.md"
});
fn::createEdge($tx_stmt_2025_05_19_row_35.id, "TransactionClarificationTasks", $task_stmt_2025_05_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2025-05-04T00:00:00Z",
  description: "Yoco *Aegir Project     Cape Town       Za",
  normalizedDescription: "Aegir Project",
  amount: 620,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 36,
    rawRowText: "Yoco *Aegir Project     Cape Town       Za; 620.00",
    transactionType: "expense",
    normalizedMerchant: "Aegir Project",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 620,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Merchant identified, but the underlying spend is still not known."
});
LET $tx_stmt_2025_05_19_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-36",
  sourceRow: $row_row_36,
  postedAt: "2025-05-04T00:00:00Z",
  description: "Yoco *Aegir Project     Cape Town       Za",
  normalizedDescription: "Aegir Project",
  amount: 620,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Aegir Project",
  merchant: $merchant_aegir_project,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Merchant identified, but the underlying spend is still not known."
});
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_05_19_row_36.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_36.id, "TransactionMerchant", $merchant_aegir_project.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_36.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_05_19_row_36 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-05-19-row-36",
  transaction: $tx_stmt_2025_05_19_row_36,
  status: "open",
  question: "What is the exact purpose of this Aegir Project transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_aegir_project,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-05-19.import.md"
});
fn::createEdge($tx_stmt_2025_05_19_row_36.id, "TransactionClarificationTasks", $task_stmt_2025_05_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 37
LET $row_row_37 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 37,
  postedAt: "2025-05-04T00:00:00Z",
  description: "Yoco *Wicked Bites      Cape Town           Za",
  normalizedDescription: "Wicked Bites",
  amount: 110,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 37,
    rawRowText: "Yoco *Wicked Bites      Cape Town           Za; 110.00",
    transactionType: "expense",
    normalizedMerchant: "Wicked Bites",
    category: "Food / takeaway",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 110,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Food spend."
});
LET $tx_stmt_2025_05_19_row_37 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-37",
  sourceRow: $row_row_37,
  postedAt: "2025-05-04T00:00:00Z",
  description: "Yoco *Wicked Bites      Cape Town           Za",
  normalizedDescription: "Wicked Bites",
  amount: 110,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Wicked Bites",
  merchant: $merchant_wicked_bites,
  category: $cat_food_takeaway,
  isTransfer: false,
  manualOverride: false,
  notes: "Food spend."
});
fn::updateStatementRow($row_row_37.id, { transaction: $tx_stmt_2025_05_19_row_37.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_37.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_37.id, "TransactionMerchant", $merchant_wicked_bites.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_37.id, "TransactionCategory", $cat_food_takeaway.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 38
LET $row_row_38 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 38,
  postedAt: "2025-05-04T00:00:00Z",
  description: "Yoco *Squirrel Games Cape Town              Za",
  normalizedDescription: "Squirrel Games",
  amount: 250,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 38,
    rawRowText: "Yoco *Squirrel Games Cape Town              Za; 250.00",
    transactionType: "expense",
    normalizedMerchant: "Squirrel Games",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 250,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Merchant identified, but the underlying spend is still not known."
});
LET $tx_stmt_2025_05_19_row_38 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-38",
  sourceRow: $row_row_38,
  postedAt: "2025-05-04T00:00:00Z",
  description: "Yoco *Squirrel Games Cape Town              Za",
  normalizedDescription: "Squirrel Games",
  amount: 250,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Squirrel Games",
  merchant: $merchant_squirrel_games,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Merchant identified, but the underlying spend is still not known."
});
fn::updateStatementRow($row_row_38.id, { transaction: $tx_stmt_2025_05_19_row_38.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_38.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_38.id, "TransactionMerchant", $merchant_squirrel_games.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_38.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_05_19_row_38 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-05-19-row-38",
  transaction: $tx_stmt_2025_05_19_row_38,
  status: "open",
  question: "What is the exact purpose of this Squirrel Games transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_squirrel_games,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-05-19.import.md"
});
fn::createEdge($tx_stmt_2025_05_19_row_38.id, "TransactionClarificationTasks", $task_stmt_2025_05_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 39
LET $row_row_39 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 39,
  postedAt: "2025-05-04T00:00:00Z",
  description: "Total Table View       Table View Za",
  normalizedDescription: "Total Table View",
  amount: 173,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 39,
    rawRowText: "Total Table View       Table View Za; 173.00",
    transactionType: "expense",
    normalizedMerchant: "Total Table View",
    category: "Fuel-station snacks",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 173,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Petrol-station food or snacks."
});
LET $tx_stmt_2025_05_19_row_39 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-39",
  sourceRow: $row_row_39,
  postedAt: "2025-05-04T00:00:00Z",
  description: "Total Table View       Table View Za",
  normalizedDescription: "Total Table View",
  amount: 173,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Total Table View",
  merchant: $merchant_total_table_view,
  category: $cat_fuel_station_snacks,
  isTransfer: false,
  manualOverride: false,
  notes: "Petrol-station food or snacks."
});
fn::updateStatementRow($row_row_39.id, { transaction: $tx_stmt_2025_05_19_row_39.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_39.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_39.id, "TransactionMerchant", $merchant_total_table_view.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_39.id, "TransactionCategory", $cat_fuel_station_snacks.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 40
LET $row_row_40 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 40,
  postedAt: "2025-05-05T00:00:00Z",
  description: "Hyrotrader            Bratislava Sk",
  normalizedDescription: "HyroTrader",
  amount: 11479.37,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 40,
    rawRowText: "Hyrotrader            Bratislava Sk; 11479.37",
    transactionType: "expense",
    normalizedMerchant: "HyroTrader",
    category: "Business expenses paid personally / trading tools",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 11479.37,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Trading challenge or prop-firm fee."
});
LET $tx_stmt_2025_05_19_row_40 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-40",
  sourceRow: $row_row_40,
  postedAt: "2025-05-05T00:00:00Z",
  description: "Hyrotrader            Bratislava Sk",
  normalizedDescription: "HyroTrader",
  amount: 11479.37,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "HyroTrader",
  merchant: $merchant_hyrotrader,
  category: $cat_business_expenses_paid_personally_trading_tools,
  isTransfer: false,
  manualOverride: false,
  notes: "Trading challenge or prop-firm fee."
});
fn::updateStatementRow($row_row_40.id, { transaction: $tx_stmt_2025_05_19_row_40.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_40.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_40.id, "TransactionMerchant", $merchant_hyrotrader.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_40.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 41
LET $row_row_41 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 41,
  postedAt: "2025-05-06T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 41,
    rawRowText: "I Valr Pty Ltd        Cape Town        Za; 1000.00",
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
LET $tx_stmt_2025_05_19_row_41 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-41",
  sourceRow: $row_row_41,
  postedAt: "2025-05-06T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
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
fn::updateStatementRow($row_row_41.id, { transaction: $tx_stmt_2025_05_19_row_41.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_41.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_41.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_41.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 42
LET $row_row_42 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 42,
  postedAt: "2025-05-07T00:00:00Z",
  description: "Takealo*T             Cape Town        Za",
  normalizedDescription: "Takealot",
  amount: 425,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 42,
    rawRowText: "Takealo*T             Cape Town        Za; 425.00",
    transactionType: "expense",
    normalizedMerchant: "Takealot",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 425,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Takealot purchase; exact item still needs review."
});
LET $tx_stmt_2025_05_19_row_42 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-42",
  sourceRow: $row_row_42,
  postedAt: "2025-05-07T00:00:00Z",
  description: "Takealo*T             Cape Town        Za",
  normalizedDescription: "Takealot",
  amount: 425,
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
  notes: "Takealot purchase; exact item still needs review."
});
fn::updateStatementRow($row_row_42.id, { transaction: $tx_stmt_2025_05_19_row_42.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_42.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_42.id, "TransactionMerchant", $merchant_takealot.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_42.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_05_19_row_42 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-05-19-row-42",
  transaction: $tx_stmt_2025_05_19_row_42,
  status: "open",
  question: "What is the exact purpose of this Takealot transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_takealot,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-05-19.import.md"
});
fn::createEdge($tx_stmt_2025_05_19_row_42.id, "TransactionClarificationTasks", $task_stmt_2025_05_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 43
LET $row_row_43 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 43,
  postedAt: "2025-05-07T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 43,
    rawRowText: "I Valr Pty Ltd        Cape Town        Za; 1000.00",
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
LET $tx_stmt_2025_05_19_row_43 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-43",
  sourceRow: $row_row_43,
  postedAt: "2025-05-07T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
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
fn::updateStatementRow($row_row_43.id, { transaction: $tx_stmt_2025_05_19_row_43.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_43.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_43.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_43.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 44
LET $row_row_44 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 44,
  postedAt: "2025-05-08T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 44,
    rawRowText: "I Valr Pty Ltd        Cape Town        Za; 2000.00",
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
LET $tx_stmt_2025_05_19_row_44 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-44",
  sourceRow: $row_row_44,
  postedAt: "2025-05-08T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
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
fn::updateStatementRow($row_row_44.id, { transaction: $tx_stmt_2025_05_19_row_44.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_44.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_44.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_44.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 45
LET $row_row_45 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 45,
  postedAt: "2025-05-10T00:00:00Z",
  description: "Checkers Capegate       Brackenfell Za",
  normalizedDescription: "Checkers Capegate",
  amount: 112.92,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 45,
    rawRowText: "Checkers Capegate       Brackenfell Za; 112.92",
    transactionType: "expense",
    normalizedMerchant: "Checkers Capegate",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 112.92,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery spend."
});
LET $tx_stmt_2025_05_19_row_45 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-45",
  sourceRow: $row_row_45,
  postedAt: "2025-05-10T00:00:00Z",
  description: "Checkers Capegate       Brackenfell Za",
  normalizedDescription: "Checkers Capegate",
  amount: 112.92,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Checkers Capegate",
  merchant: $merchant_checkers_capegate,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery spend."
});
fn::updateStatementRow($row_row_45.id, { transaction: $tx_stmt_2025_05_19_row_45.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_45.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_45.id, "TransactionMerchant", $merchant_checkers_capegate.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_45.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 46
LET $row_row_46 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 46,
  postedAt: "2025-05-10T00:00:00Z",
  description: "Woolworths            Paarl       Za",
  normalizedDescription: "Woolworths            Paarl       Za",
  amount: 769.95,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 46,
    rawRowText: "Woolworths            Paarl       Za; 769.95",
    transactionType: "expense",
    normalizedMerchant: "Woolworths            Paarl       Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 769.95,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_05_19_row_46 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-46",
  sourceRow: $row_row_46,
  postedAt: "2025-05-10T00:00:00Z",
  description: "Woolworths            Paarl       Za",
  normalizedDescription: "Woolworths            Paarl       Za",
  amount: 769.95,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Woolworths            Paarl       Za",
  merchant: $merchant_woolworths_paarl_za,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_46.id, { transaction: $tx_stmt_2025_05_19_row_46.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_46.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_46.id, "TransactionMerchant", $merchant_woolworths_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_46.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 47
LET $row_row_47 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 47,
  postedAt: "2025-05-10T00:00:00Z",
  description: "C*Bargain Books Capegate Brackenfell Za",
  normalizedDescription: "Bargain Books Capegate",
  amount: 538,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 47,
    rawRowText: "C*Bargain Books Capegate Brackenfell Za; 538.00",
    transactionType: "expense",
    normalizedMerchant: "Bargain Books Capegate",
    category: "Kids / books",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 538,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Books for the girls."
});
LET $tx_stmt_2025_05_19_row_47 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-47",
  sourceRow: $row_row_47,
  postedAt: "2025-05-10T00:00:00Z",
  description: "C*Bargain Books Capegate Brackenfell Za",
  normalizedDescription: "Bargain Books Capegate",
  amount: 538,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Bargain Books Capegate",
  merchant: $merchant_bargain_books_capegate,
  category: $cat_kids_books,
  isTransfer: false,
  manualOverride: false,
  notes: "Books for the girls."
});
fn::updateStatementRow($row_row_47.id, { transaction: $tx_stmt_2025_05_19_row_47.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_47.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_47.id, "TransactionMerchant", $merchant_bargain_books_capegate.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_47.id, "TransactionCategory", $cat_kids_books.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 48
LET $row_row_48 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 48,
  postedAt: "2025-05-10T00:00:00Z",
  description: "Advance Cape Gate        Cape Town          Za",
  normalizedDescription: "Advance Cape Gate",
  amount: 10,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/May 2025.pdf",
    statementPeriodStart: "2025-04-20",
    statementPeriodEnd: "2025-05-19",
    rowNo: 48,
    rawRowText: "Advance Cape Gate        Cape Town          Za; 10.00",
    transactionType: "expense",
    normalizedMerchant: "Advance Cape Gate",
    category: "Parking",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 10,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Parking charge."
});
LET $tx_stmt_2025_05_19_row_48 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-05-19-row-48",
  sourceRow: $row_row_48,
  postedAt: "2025-05-10T00:00:00Z",
  description: "Advance Cape Gate        Cape Town          Za",
  normalizedDescription: "Advance Cape Gate",
  amount: 10,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Advance Cape Gate",
  merchant: $merchant_advance_cape_gate,
  category: $cat_parking,
  isTransfer: false,
  manualOverride: false,
  notes: "Parking charge."
});
fn::updateStatementRow($row_row_48.id, { transaction: $tx_stmt_2025_05_19_row_48.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_48.id, "StatementRowTransactions", $tx_stmt_2025_05_19_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_05_19_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_48.id, "TransactionMerchant", $merchant_advance_cape_gate.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_05_19_row_48.id, "TransactionCategory", $cat_parking.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 47,
  normalizedCount: 47,
  clarificationCount: 6,
  status: "matched",
  statementDate: "2025-05-19T00:00:00Z",
  notes: "Imported from 2025-05-19.import.md"
});

-- End of generated import
