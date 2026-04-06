-- Generated from docs/statements/personal/credit/2026-01-19.import.md
-- Source: docs/statements/personal/credit/January 2026.pdf

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
  openingBalance: 127781.56,
  active: true,
  notes: "Imported from January 2026.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2026-01-19-nedbank-credit",
  sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2026-01-19T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2026-01-19.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_crypto_trading = fn::createCategory({
  space: $space,
  key: "crypto-trading",
  name: "Crypto / trading",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_subscription_media = fn::createCategory({
  space: $space,
  key: "subscription-media",
  name: "Subscription / media",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_hosting_internet = fn::createCategory({
  space: $space,
  key: "hosting-internet",
  name: "Hosting / internet",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_fuel_transport = fn::createCategory({
  space: $space,
  key: "fuel-transport",
  name: "Fuel / transport",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_transfer_services = fn::createCategory({
  space: $space,
  key: "transfer-services",
  name: "Transfer services",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_groceries_household = fn::createCategory({
  space: $space,
  key: "groceries-household",
  name: "Groceries / household",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_retail_books = fn::createCategory({
  space: $space,
  key: "retail-books",
  name: "Retail / books",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_personal_care_pharmacy = fn::createCategory({
  space: $space,
  key: "personal-care-pharmacy",
  name: "Personal care / pharmacy",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_cash_advance = fn::createCategory({
  space: $space,
  key: "cash-advance",
  name: "Cash advance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_children_activities = fn::createCategory({
  space: $space,
  key: "children-activities",
  name: "Children / activities",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_entertainment_family = fn::createCategory({
  space: $space,
  key: "entertainment-family",
  name: "Entertainment / family",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_dining_lifestyle = fn::createCategory({
  space: $space,
  key: "dining-lifestyle",
  name: "Dining / lifestyle",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_travel = fn::createCategory({
  space: $space,
  key: "travel",
  name: "Travel",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_education_children = fn::createCategory({
  space: $space,
  key: "education-children",
  name: "Education / children",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_fees_declined_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-declined-payment-fee",
  name: "Declined Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_fees_electronic_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-electronic-payment-fee",
  name: "Electronic Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_fees_credit_facility_service_fee = fn::createCategory({
  space: $space,
  key: "fees-credit-facility-service-fee",
  name: "Credit Facility Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_fees_finance_charge = fn::createCategory({
  space: $space,
  key: "fees-finance-charge",
  name: "Finance Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});

-- Merchant records
LET $merchant_nedbank_current_account = fn::createMerchant({
  space: $space,
  key: "nedbank-current-account",
  name: "Nedbank Current Account",
  normalizedName: "Nedbank Current Account",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_valr = fn::createMerchant({
  space: $space,
  key: "valr",
  name: "VALR",
  normalizedName: "VALR",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_spotify = fn::createMerchant({
  space: $space,
  key: "spotify",
  name: "Spotify",
  normalizedName: "Spotify",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_audible = fn::createMerchant({
  space: $space,
  key: "audible",
  name: "Audible",
  normalizedName: "Audible",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_afrihost = fn::createMerchant({
  space: $space,
  key: "afrihost",
  name: "Afrihost",
  normalizedName: "Afrihost",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_engen_paradyskloof = fn::createMerchant({
  space: $space,
  key: "engen-paradyskloof",
  name: "Engen Paradyskloof",
  normalizedName: "Engen Paradyskloof",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_showmax = fn::createMerchant({
  space: $space,
  key: "showmax",
  name: "Showmax",
  normalizedName: "Showmax",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_wise = fn::createMerchant({
  space: $space,
  key: "wise",
  name: "Wise",
  normalizedName: "Wise",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_woolworths_jamestown = fn::createMerchant({
  space: $space,
  key: "woolworths-jamestown",
  name: "Woolworths Jamestown",
  normalizedName: "Woolworths Jamestown",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_wordsworth_stellenbosch = fn::createMerchant({
  space: $space,
  key: "wordsworth-stellenbosch",
  name: "Wordsworth Stellenbosch",
  normalizedName: "Wordsworth Stellenbosch",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_clicks_stellenbosch_square = fn::createMerchant({
  space: $space,
  key: "clicks-stellenbosch-square",
  name: "Clicks Stellenbosch Square",
  normalizedName: "Clicks Stellenbosch Square",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_nedbank_internet_banking = fn::createMerchant({
  space: $space,
  key: "nedbank-internet-banking",
  name: "Nedbank Internet Banking",
  normalizedName: "Nedbank Internet Banking",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_alana_banana = fn::createMerchant({
  space: $space,
  key: "alana-banana",
  name: "Alana Banana",
  normalizedName: "Alana Banana",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_giraffe_house = fn::createMerchant({
  space: $space,
  key: "giraffe-house",
  name: "Giraffe House",
  normalizedName: "Giraffe House",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_grandwest_cinema = fn::createMerchant({
  space: $space,
  key: "grandwest-cinema",
  name: "GrandWest Cinema",
  normalizedName: "GrandWest Cinema",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_the_magic_company = fn::createMerchant({
  space: $space,
  key: "the-magic-company",
  name: "The Magic Company",
  normalizedName: "The Magic Company",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_grandwest_casino = fn::createMerchant({
  space: $space,
  key: "grandwest-casino",
  name: "GrandWest Casino",
  normalizedName: "GrandWest Casino",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_burger_king_grand_west = fn::createMerchant({
  space: $space,
  key: "burger-king-grand-west",
  name: "Burger King Grand West",
  normalizedName: "Burger King Grand West",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_candylicious_grandwest = fn::createMerchant({
  space: $space,
  key: "candylicious-grandwest",
  name: "Candylicious GrandWest",
  normalizedName: "Candylicious GrandWest",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_cape_ice_skating = fn::createMerchant({
  space: $space,
  key: "cape-ice-skating",
  name: "Cape Ice Skating",
  normalizedName: "Cape Ice Skating",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_nedbank_savings_account = fn::createMerchant({
  space: $space,
  key: "nedbank-savings-account",
  name: "Nedbank Savings Account",
  normalizedName: "Nedbank Savings Account",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_trade_travel_chill = fn::createMerchant({
  space: $space,
  key: "trade-travel-chill",
  name: "Trade Travel Chill",
  normalizedName: "Trade Travel Chill",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_the_local_choice = fn::createMerchant({
  space: $space,
  key: "the-local-choice",
  name: "The Local Choice",
  normalizedName: "The Local Choice",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_bridge_house_school = fn::createMerchant({
  space: $space,
  key: "bridge-house-school",
  name: "Bridge House School",
  normalizedName: "Bridge House School",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_graceland_venues = fn::createMerchant({
  space: $space,
  key: "graceland-venues",
  name: "Graceland Venues",
  normalizedName: "Graceland Venues",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_bp_wine_route = fn::createMerchant({
  space: $space,
  key: "bp-wine-route",
  name: "BP Wine Route",
  normalizedName: "BP Wine Route",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});
LET $merchant_blaauwklippen = fn::createMerchant({
  space: $space,
  key: "blaauwklippen",
  name: "Blaauwklippen",
  normalizedName: "Blaauwklippen",
  active: true,
  notes: "Imported from 2026-01-19.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-12-30T00:00:00Z",
  description: "A P O Payment - Thank You",
  normalizedDescription: "Nedbank Current Account",
  amount: 6380,
  balance: 6380,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 1,
    rawRowText: "A P O Payment - Thank You; 6380.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6380,
    bankChargeZar: null,
    balanceZar: 6380
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2026_01_19_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-12-30T00:00:00Z",
  description: "A P O Payment - Thank You",
  normalizedDescription: "Nedbank Current Account",
  amount: 6380,
  balance: 6380,
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2026_01_19_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_01.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_01.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2026-01-06T00:00:00Z",
  description: "Internet Banking Transferselby Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 35344,
  balance: 35344,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 2,
    rawRowText: "Internet Banking Transferselby Za; 35344.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 35344,
    bankChargeZar: null,
    balanceZar: 35344
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2026_01_19_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-02",
  sourceRow: $row_row_02,
  postedAt: "2026-01-06T00:00:00Z",
  description: "Internet Banking Transferselby Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 35344,
  balance: 35344,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2026_01_19_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_02.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_02.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Internet Banking Transferselby Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 15000,
  balance: 15000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 3,
    rawRowText: "Internet Banking Transferselby Za; 15000.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 15000,
    bankChargeZar: null,
    balanceZar: 15000
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2026_01_19_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-03",
  sourceRow: $row_row_03,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Internet Banking Transferselby Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 15000,
  balance: 15000,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2026_01_19_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_03.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_03.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2026-01-13T00:00:00Z",
  description: "Internet Banking Transferselby Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 12000,
  balance: 12000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 4,
    rawRowText: "Internet Banking Transferselby Za; 12000.00 Cr",
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
LET $tx_stmt_2026_01_19_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-04",
  sourceRow: $row_row_04,
  postedAt: "2026-01-13T00:00:00Z",
  description: "Internet Banking Transferselby Za",
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2026_01_19_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_04.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_04.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2026-01-16T00:00:00Z",
  description: "Internet Banking Transferselby Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2500,
  balance: 2500,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 5,
    rawRowText: "Internet Banking Transferselby Za; 2500.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2500,
    bankChargeZar: null,
    balanceZar: 2500
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2026_01_19_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-05",
  sourceRow: $row_row_05,
  postedAt: "2026-01-16T00:00:00Z",
  description: "Internet Banking Transferselby Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2500,
  balance: 2500,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2026_01_19_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_05.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_05.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-12-20T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
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
LET $tx_stmt_2026_01_19_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-12-20T00:00:00Z",
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2026_01_19_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_06.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_06.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2026-01-02T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
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
LET $tx_stmt_2026_01_19_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-07",
  sourceRow: $row_row_07,
  postedAt: "2026-01-02T00:00:00Z",
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2026_01_19_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_07.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_07.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2026-01-02T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
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
LET $tx_stmt_2026_01_19_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-08",
  sourceRow: $row_row_08,
  postedAt: "2026-01-02T00:00:00Z",
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2026_01_19_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_08.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_08.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
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
LET $tx_stmt_2026_01_19_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-09",
  sourceRow: $row_row_09,
  postedAt: "2026-01-08T00:00:00Z",
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2026_01_19_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_09.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_09.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2026-01-13T00:00:00Z",
  description: "Maintenance Fee",
  normalizedDescription: "Maintenance Fee",
  amount: 36.52,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 10,
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
LET $tx_stmt_2026_01_19_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-10",
  sourceRow: $row_row_10,
  postedAt: "2026-01-13T00:00:00Z",
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2026_01_19_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_10.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_10.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2026-01-14T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 11,
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
LET $tx_stmt_2026_01_19_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-11",
  sourceRow: $row_row_11,
  postedAt: "2026-01-14T00:00:00Z",
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2026_01_19_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_11.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_11.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2026-01-15T00:00:00Z",
  description: "Credit Facility Service Fee",
  normalizedDescription: "Credit Facility Service Fee",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
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
LET $tx_stmt_2026_01_19_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-12",
  sourceRow: $row_row_12,
  postedAt: "2026-01-15T00:00:00Z",
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2026_01_19_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_12.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_12.id, "TransactionCategory", $cat_fees_credit_facility_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2026-01-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 2190.51,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 13,
    rawRowText: "Finance Charge; 2190.51",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "finance charge",
    clarificationStatus: "clarified",
    amountZar: 2190.51,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Finance charge on outstanding balance."
});
LET $tx_stmt_2026_01_19_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-13",
  sourceRow: $row_row_13,
  postedAt: "2026-01-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 2190.51,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2026_01_19_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_13.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_13.id, "TransactionCategory", $cat_fees_finance_charge.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2026-01-15T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 14.98,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 14,
    rawRowText: "Total V A T; 14.98",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 14.98,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "VAT on fees."
});
LET $tx_stmt_2026_01_19_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-14",
  sourceRow: $row_row_14,
  postedAt: "2026-01-15T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 14.98,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2026_01_19_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_14.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_14.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-12-18T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 15,
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
LET $tx_stmt_2026_01_19_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-12-18T00:00:00Z",
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2026_01_19_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_15.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_15.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-12-18T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 16,
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
LET $tx_stmt_2026_01_19_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-12-18T00:00:00Z",
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2026_01_19_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_16.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_16.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-12-19T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 17,
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
LET $tx_stmt_2026_01_19_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-12-19T00:00:00Z",
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2026_01_19_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_17.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_17.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2026-01-04T00:00:00Z",
  description: "Spotifyza Stockholm Se",
  normalizedDescription: "Spotify",
  amount: 69.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 18,
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
LET $tx_stmt_2026_01_19_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-18",
  sourceRow: $row_row_18,
  postedAt: "2026-01-04T00:00:00Z",
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2026_01_19_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_18.id, "TransactionMerchant", $merchant_spotify.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_18.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2026-01-05T00:00:00Z",
  description: "Audible*Lf5325ik3 Amzn.Com/Billus",
  normalizedDescription: "Audible",
  amount: 17.1,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 19,
    rawRowText: "Audible*Lf5325ik3 Amzn.Com/Billus; 17.10",
    transactionType: "expense",
    normalizedMerchant: "Audible",
    category: "Subscription / media",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 17.1,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Audible subscription or media spend."
});
LET $tx_stmt_2026_01_19_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-19",
  sourceRow: $row_row_19,
  postedAt: "2026-01-05T00:00:00Z",
  description: "Audible*Lf5325ik3 Amzn.Com/Billus",
  normalizedDescription: "Audible",
  amount: 17.1,
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
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2026_01_19_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_19.id, "TransactionMerchant", $merchant_audible.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_19.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2026-01-06T00:00:00Z",
  description: "I Afrihost.Com 2 Cape Town Za",
  normalizedDescription: "Afrihost",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 20,
    rawRowText: "I Afrihost.Com 2 Cape Town Za; 419.00",
    transactionType: "expense",
    normalizedMerchant: "Afrihost",
    category: "Hosting / internet",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 419,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Hosting or internet spend."
});
LET $tx_stmt_2026_01_19_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-20",
  sourceRow: $row_row_20,
  postedAt: "2026-01-06T00:00:00Z",
  description: "I Afrihost.Com 2 Cape Town Za",
  normalizedDescription: "Afrihost",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Afrihost",
  merchant: $merchant_afrihost,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting or internet spend."
});
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2026_01_19_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_20.id, "TransactionMerchant", $merchant_afrihost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_20.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2026-01-06T00:00:00Z",
  description: "Engen Paradyskloof",
  normalizedDescription: "Engen Paradyskloof",
  amount: 613.75,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 21,
    rawRowText: "Engen Paradyskloof; 613.75",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 613.75,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel spend."
});
LET $tx_stmt_2026_01_19_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-21",
  sourceRow: $row_row_21,
  postedAt: "2026-01-06T00:00:00Z",
  description: "Engen Paradyskloof",
  normalizedDescription: "Engen Paradyskloof",
  amount: 613.75,
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
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2026_01_19_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_21.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_21.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2026-01-06T00:00:00Z",
  description: "Engen Paradyskloof",
  normalizedDescription: "Engen Paradyskloof",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 22,
    rawRowText: "Engen Paradyskloof; 500.00",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 500,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel spend."
});
LET $tx_stmt_2026_01_19_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-22",
  sourceRow: $row_row_22,
  postedAt: "2026-01-06T00:00:00Z",
  description: "Engen Paradyskloof",
  normalizedDescription: "Engen Paradyskloof",
  amount: 500,
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
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2026_01_19_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_22.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_22.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2026-01-06T00:00:00Z",
  description: "Pp *Showmax Randburg Za",
  normalizedDescription: "Showmax",
  amount: 99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 23,
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
LET $tx_stmt_2026_01_19_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-23",
  sourceRow: $row_row_23,
  postedAt: "2026-01-06T00:00:00Z",
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2026_01_19_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_23.id, "TransactionMerchant", $merchant_showmax.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_23.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2026-01-06T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 9000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 24,
    rawRowText: "I Valr Pty Ltd Cape Town Za; 9000.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 9000,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2026_01_19_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-24",
  sourceRow: $row_row_24,
  postedAt: "2026-01-06T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 9000,
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
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2026_01_19_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_24.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_24.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2026-01-07T00:00:00Z",
  description: "Wise London Gb",
  normalizedDescription: "Wise",
  amount: 1112.72,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 25,
    rawRowText: "Wise London Gb; 1112.72",
    transactionType: "expense",
    normalizedMerchant: "Wise",
    category: "Transfer services",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1112.72,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Wise transaction needs exact purpose confirmation."
});
LET $tx_stmt_2026_01_19_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-25",
  sourceRow: $row_row_25,
  postedAt: "2026-01-07T00:00:00Z",
  description: "Wise London Gb",
  normalizedDescription: "Wise",
  amount: 1112.72,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Wise",
  merchant: $merchant_wise,
  category: $cat_transfer_services,
  isTransfer: false,
  manualOverride: false,
  notes: "Wise transaction needs exact purpose confirmation."
});
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2026_01_19_row_25.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_25.id, "TransactionMerchant", $merchant_wise.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_25.id, "TransactionCategory", $cat_transfer_services.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_01_19_row_25 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-01-19-row-25",
  transaction: $tx_stmt_2026_01_19_row_25,
  status: "open",
  question: "What was the purpose of this Wise spend or transfer?",
  reason: "Wise spend or transfer rail needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_wise,
  suggestedCategory: $cat_transfer_services,
  confidence: 0.25,
  notes: "Imported from 2026-01-19.import.md"
});
fn::createEdge($tx_stmt_2026_01_19_row_25.id, "TransactionClarificationTasks", $task_stmt_2026_01_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2026-01-07T00:00:00Z",
  description: "Woolworths Jamestown Za",
  normalizedDescription: "Woolworths Jamestown",
  amount: 227.94,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 26,
    rawRowText: "Woolworths Jamestown Za; 227.94",
    transactionType: "expense",
    normalizedMerchant: "Woolworths Jamestown",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 227.94,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery / household spend."
});
LET $tx_stmt_2026_01_19_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-26",
  sourceRow: $row_row_26,
  postedAt: "2026-01-07T00:00:00Z",
  description: "Woolworths Jamestown Za",
  normalizedDescription: "Woolworths Jamestown",
  amount: 227.94,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Woolworths Jamestown",
  merchant: $merchant_woolworths_jamestown,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery / household spend."
});
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2026_01_19_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_26.id, "TransactionMerchant", $merchant_woolworths_jamestown.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_26.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2026-01-07T00:00:00Z",
  description: "Woolworths Jamestown Za",
  normalizedDescription: "Woolworths Jamestown",
  amount: 41.4,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 27,
    rawRowText: "Woolworths Jamestown Za; 41.40",
    transactionType: "expense",
    normalizedMerchant: "Woolworths Jamestown",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 41.4,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery / household spend."
});
LET $tx_stmt_2026_01_19_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-27",
  sourceRow: $row_row_27,
  postedAt: "2026-01-07T00:00:00Z",
  description: "Woolworths Jamestown Za",
  normalizedDescription: "Woolworths Jamestown",
  amount: 41.4,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Woolworths Jamestown",
  merchant: $merchant_woolworths_jamestown,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery / household spend."
});
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2026_01_19_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_27.id, "TransactionMerchant", $merchant_woolworths_jamestown.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_27.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2026-01-07T00:00:00Z",
  description: "C*Wordsworth Stellenboschwestern Cape Za",
  normalizedDescription: "Wordsworth Stellenbosch",
  amount: 700,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 28,
    rawRowText: "C*Wordsworth Stellenboschwestern Cape Za; 700.00",
    transactionType: "expense",
    normalizedMerchant: "Wordsworth Stellenbosch",
    category: "Retail / books",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 700,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Books or retail spend."
});
LET $tx_stmt_2026_01_19_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-28",
  sourceRow: $row_row_28,
  postedAt: "2026-01-07T00:00:00Z",
  description: "C*Wordsworth Stellenboschwestern Cape Za",
  normalizedDescription: "Wordsworth Stellenbosch",
  amount: 700,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Wordsworth Stellenbosch",
  merchant: $merchant_wordsworth_stellenbosch,
  category: $cat_retail_books,
  isTransfer: false,
  manualOverride: false,
  notes: "Books or retail spend."
});
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2026_01_19_row_28.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_28.id, "TransactionMerchant", $merchant_wordsworth_stellenbosch.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_28.id, "TransactionCategory", $cat_retail_books.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2026-01-07T00:00:00Z",
  description: "Clicks Stellenbosch Sq",
  normalizedDescription: "Clicks Stellenbosch Square",
  amount: 232.43,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 29,
    rawRowText: "Clicks Stellenbosch Sq; 232.43",
    transactionType: "expense",
    normalizedMerchant: "Clicks Stellenbosch Square",
    category: "Personal care / pharmacy",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 232.43,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Pharmacy or personal-care spend."
});
LET $tx_stmt_2026_01_19_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-29",
  sourceRow: $row_row_29,
  postedAt: "2026-01-07T00:00:00Z",
  description: "Clicks Stellenbosch Sq",
  normalizedDescription: "Clicks Stellenbosch Square",
  amount: 232.43,
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
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2026_01_19_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_29.id, "TransactionMerchant", $merchant_clicks_stellenbosch_square.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_29.id, "TransactionCategory", $cat_personal_care_pharmacy.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 29819,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 30,
    rawRowText: "Electronic Payment From:Internet Banking; 29819.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 29819,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2026_01_19_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-30",
  sourceRow: $row_row_30,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 29819,
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
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2026_01_19_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_30.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_30.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Alana Banana Pty Ltd Stellenbosch Za",
  normalizedDescription: "Alana Banana",
  amount: 537,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 31,
    rawRowText: "Alana Banana Pty Ltd Stellenbosch Za; 537.00",
    transactionType: "expense",
    normalizedMerchant: "Alana Banana",
    category: "Children / activities",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 537,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Merchant likely family-related, but exact purpose needs confirmation."
});
LET $tx_stmt_2026_01_19_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-31",
  sourceRow: $row_row_31,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Alana Banana Pty Ltd Stellenbosch Za",
  normalizedDescription: "Alana Banana",
  amount: 537,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Alana Banana",
  merchant: $merchant_alana_banana,
  category: $cat_children_activities,
  isTransfer: false,
  manualOverride: false,
  notes: "Merchant likely family-related, but exact purpose needs confirmation."
});
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2026_01_19_row_31.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_31.id, "TransactionMerchant", $merchant_alana_banana.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_31.id, "TransactionCategory", $cat_children_activities.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_01_19_row_31 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-01-19-row-31",
  transaction: $tx_stmt_2026_01_19_row_31,
  status: "open",
  question: "What is the exact purpose of this Alana Banana transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_alana_banana,
  suggestedCategory: $cat_children_activities,
  confidence: 0.25,
  notes: "Imported from 2026-01-19.import.md"
});
fn::createEdge($tx_stmt_2026_01_19_row_31.id, "TransactionClarificationTasks", $task_stmt_2026_01_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Giraffe House Muldersvlei Za",
  normalizedDescription: "Giraffe House",
  amount: 210,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 32,
    rawRowText: "Giraffe House Muldersvlei Za; 210.00",
    transactionType: "expense",
    normalizedMerchant: "Giraffe House",
    category: "Children / activities",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 210,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Family or children entertainment spend."
});
LET $tx_stmt_2026_01_19_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-32",
  sourceRow: $row_row_32,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Giraffe House Muldersvlei Za",
  normalizedDescription: "Giraffe House",
  amount: 210,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Giraffe House",
  merchant: $merchant_giraffe_house,
  category: $cat_children_activities,
  isTransfer: false,
  manualOverride: false,
  notes: "Family or children entertainment spend."
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2026_01_19_row_32.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_32.id, "TransactionMerchant", $merchant_giraffe_house.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_32.id, "TransactionCategory", $cat_children_activities.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2026-01-08T00:00:00Z",
  description: "C*Grandwest Cinema Cape Town Za",
  normalizedDescription: "GrandWest Cinema",
  amount: 82,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 33,
    rawRowText: "C*Grandwest Cinema Cape Town Za; 82.00",
    transactionType: "expense",
    normalizedMerchant: "GrandWest Cinema",
    category: "Entertainment / family",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 82,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cinema spend."
});
LET $tx_stmt_2026_01_19_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-33",
  sourceRow: $row_row_33,
  postedAt: "2026-01-08T00:00:00Z",
  description: "C*Grandwest Cinema Cape Town Za",
  normalizedDescription: "GrandWest Cinema",
  amount: 82,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "GrandWest Cinema",
  merchant: $merchant_grandwest_cinema,
  category: $cat_entertainment_family,
  isTransfer: false,
  manualOverride: false,
  notes: "Cinema spend."
});
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2026_01_19_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_33.id, "TransactionMerchant", $merchant_grandwest_cinema.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_33.id, "TransactionCategory", $cat_entertainment_family.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2026-01-08T00:00:00Z",
  description: "The Magic Company X-Ridercape Town Za",
  normalizedDescription: "The Magic Company",
  amount: 100,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 34,
    rawRowText: "The Magic Company X-Ridercape Town Za; 100.00",
    transactionType: "expense",
    normalizedMerchant: "The Magic Company",
    category: "Children / activities",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 100,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Entertainment spend."
});
LET $tx_stmt_2026_01_19_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-34",
  sourceRow: $row_row_34,
  postedAt: "2026-01-08T00:00:00Z",
  description: "The Magic Company X-Ridercape Town Za",
  normalizedDescription: "The Magic Company",
  amount: 100,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "The Magic Company",
  merchant: $merchant_the_magic_company,
  category: $cat_children_activities,
  isTransfer: false,
  manualOverride: false,
  notes: "Entertainment spend."
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2026_01_19_row_34.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_34.id, "TransactionMerchant", $merchant_the_magic_company.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_34.id, "TransactionCategory", $cat_children_activities.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2026-01-08T00:00:00Z",
  description: "The Magic Company X-Ridercape Town Za",
  normalizedDescription: "The Magic Company",
  amount: 100,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 35,
    rawRowText: "The Magic Company X-Ridercape Town Za; 100.00",
    transactionType: "expense",
    normalizedMerchant: "The Magic Company",
    category: "Children / activities",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 100,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Entertainment spend."
});
LET $tx_stmt_2026_01_19_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-35",
  sourceRow: $row_row_35,
  postedAt: "2026-01-08T00:00:00Z",
  description: "The Magic Company X-Ridercape Town Za",
  normalizedDescription: "The Magic Company",
  amount: 100,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "The Magic Company",
  merchant: $merchant_the_magic_company,
  category: $cat_children_activities,
  isTransfer: false,
  manualOverride: false,
  notes: "Entertainment spend."
});
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2026_01_19_row_35.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_35.id, "TransactionMerchant", $merchant_the_magic_company.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_35.id, "TransactionCategory", $cat_children_activities.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2026-01-08T00:00:00Z",
  description: "The Magic Company X-Ridercape Town Za",
  normalizedDescription: "The Magic Company",
  amount: 100,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 36,
    rawRowText: "The Magic Company X-Ridercape Town Za; 100.00",
    transactionType: "expense",
    normalizedMerchant: "The Magic Company",
    category: "Children / activities",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 100,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Entertainment spend."
});
LET $tx_stmt_2026_01_19_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-36",
  sourceRow: $row_row_36,
  postedAt: "2026-01-08T00:00:00Z",
  description: "The Magic Company X-Ridercape Town Za",
  normalizedDescription: "The Magic Company",
  amount: 100,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "The Magic Company",
  merchant: $merchant_the_magic_company,
  category: $cat_children_activities,
  isTransfer: false,
  manualOverride: false,
  notes: "Entertainment spend."
});
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2026_01_19_row_36.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_36.id, "TransactionMerchant", $merchant_the_magic_company.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_36.id, "TransactionCategory", $cat_children_activities.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 37
LET $row_row_37 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 37,
  postedAt: "2026-01-08T00:00:00Z",
  description: "The Magic Company X-Ridercape Town Za",
  normalizedDescription: "The Magic Company",
  amount: 100,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 37,
    rawRowText: "The Magic Company X-Ridercape Town Za; 100.00",
    transactionType: "expense",
    normalizedMerchant: "The Magic Company",
    category: "Children / activities",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 100,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Entertainment spend."
});
LET $tx_stmt_2026_01_19_row_37 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-37",
  sourceRow: $row_row_37,
  postedAt: "2026-01-08T00:00:00Z",
  description: "The Magic Company X-Ridercape Town Za",
  normalizedDescription: "The Magic Company",
  amount: 100,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "The Magic Company",
  merchant: $merchant_the_magic_company,
  category: $cat_children_activities,
  isTransfer: false,
  manualOverride: false,
  notes: "Entertainment spend."
});
fn::updateStatementRow($row_row_37.id, { transaction: $tx_stmt_2026_01_19_row_37.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_37.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_37.id, "TransactionMerchant", $merchant_the_magic_company.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_37.id, "TransactionCategory", $cat_children_activities.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 38
LET $row_row_38 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 38,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Grand West Casino Parentepping Za",
  normalizedDescription: "GrandWest Casino",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 38,
    rawRowText: "Grand West Casino Parentepping Za; 20.00",
    transactionType: "expense",
    normalizedMerchant: "GrandWest Casino",
    category: "Entertainment / family",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 20,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Entertainment spend."
});
LET $tx_stmt_2026_01_19_row_38 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-38",
  sourceRow: $row_row_38,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Grand West Casino Parentepping Za",
  normalizedDescription: "GrandWest Casino",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "GrandWest Casino",
  merchant: $merchant_grandwest_casino,
  category: $cat_entertainment_family,
  isTransfer: false,
  manualOverride: false,
  notes: "Entertainment spend."
});
fn::updateStatementRow($row_row_38.id, { transaction: $tx_stmt_2026_01_19_row_38.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_38.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_38.id, "TransactionMerchant", $merchant_grandwest_casino.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_38.id, "TransactionCategory", $cat_entertainment_family.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 39
LET $row_row_39 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 39,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Bk Grand West Kiosk Epping Za",
  normalizedDescription: "Burger King Grand West",
  amount: 134.8,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 39,
    rawRowText: "Bk Grand West Kiosk Epping Za; 134.80",
    transactionType: "expense",
    normalizedMerchant: "Burger King Grand West",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 134.8,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Food spend."
});
LET $tx_stmt_2026_01_19_row_39 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-39",
  sourceRow: $row_row_39,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Bk Grand West Kiosk Epping Za",
  normalizedDescription: "Burger King Grand West",
  amount: 134.8,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Burger King Grand West",
  merchant: $merchant_burger_king_grand_west,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Food spend."
});
fn::updateStatementRow($row_row_39.id, { transaction: $tx_stmt_2026_01_19_row_39.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_39.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_39.id, "TransactionMerchant", $merchant_burger_king_grand_west.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_39.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 40
LET $row_row_40 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 40,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Candylicious Grandwest Bellville Za",
  normalizedDescription: "Candylicious GrandWest",
  amount: 90,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 40,
    rawRowText: "Candylicious Grandwest Bellville Za; 90.00",
    transactionType: "expense",
    normalizedMerchant: "Candylicious GrandWest",
    category: "Children / activities",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 90,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Family or children entertainment spend."
});
LET $tx_stmt_2026_01_19_row_40 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-40",
  sourceRow: $row_row_40,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Candylicious Grandwest Bellville Za",
  normalizedDescription: "Candylicious GrandWest",
  amount: 90,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Candylicious GrandWest",
  merchant: $merchant_candylicious_grandwest,
  category: $cat_children_activities,
  isTransfer: false,
  manualOverride: false,
  notes: "Family or children entertainment spend."
});
fn::updateStatementRow($row_row_40.id, { transaction: $tx_stmt_2026_01_19_row_40.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_40.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_40.id, "TransactionMerchant", $merchant_candylicious_grandwest.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_40.id, "TransactionCategory", $cat_children_activities.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 41
LET $row_row_41 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 41,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Cape Ice Skating Goodwood Za",
  normalizedDescription: "Cape Ice Skating",
  amount: 255,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 41,
    rawRowText: "Cape Ice Skating Goodwood Za; 255.00",
    transactionType: "expense",
    normalizedMerchant: "Cape Ice Skating",
    category: "Children / activities",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 255,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Family or children entertainment spend."
});
LET $tx_stmt_2026_01_19_row_41 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-41",
  sourceRow: $row_row_41,
  postedAt: "2026-01-08T00:00:00Z",
  description: "Cape Ice Skating Goodwood Za",
  normalizedDescription: "Cape Ice Skating",
  amount: 255,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Cape Ice Skating",
  merchant: $merchant_cape_ice_skating,
  category: $cat_children_activities,
  isTransfer: false,
  manualOverride: false,
  notes: "Family or children entertainment spend."
});
fn::updateStatementRow($row_row_41.id, { transaction: $tx_stmt_2026_01_19_row_41.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_41.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_41.id, "TransactionMerchant", $merchant_cape_ice_skating.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_41.id, "TransactionCategory", $cat_children_activities.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 42
LET $row_row_42 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 42,
  postedAt: "2026-01-09T00:00:00Z",
  description: "Transfer To:Internet Banking Transfer",
  normalizedDescription: "Nedbank Savings Account",
  amount: 30,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 42,
    rawRowText: "Transfer To:Internet Banking Transfer; 30.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Savings Account",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 30,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Transfer out from the credit card to the savings account."
});
LET $tx_stmt_2026_01_19_row_42 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-42",
  sourceRow: $row_row_42,
  postedAt: "2026-01-09T00:00:00Z",
  description: "Transfer To:Internet Banking Transfer",
  normalizedDescription: "Nedbank Savings Account",
  amount: 30,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Savings Account",
  merchant: $merchant_nedbank_savings_account,
  category: $cat_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer out from the credit card to the savings account."
});
fn::updateStatementRow($row_row_42.id, { transaction: $tx_stmt_2026_01_19_row_42.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_42.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_42.id, "TransactionMerchant", $merchant_nedbank_savings_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_42.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 43
LET $row_row_43 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 43,
  postedAt: "2026-01-09T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 43,
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
LET $tx_stmt_2026_01_19_row_43 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-43",
  sourceRow: $row_row_43,
  postedAt: "2026-01-09T00:00:00Z",
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
fn::updateStatementRow($row_row_43.id, { transaction: $tx_stmt_2026_01_19_row_43.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_43.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_43.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_43.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 44
LET $row_row_44 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 44,
  postedAt: "2026-01-09T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 1800,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 44,
    rawRowText: "I Valr Pty Ltd Cape Town Za; 1800.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1800,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2026_01_19_row_44 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-44",
  sourceRow: $row_row_44,
  postedAt: "2026-01-09T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 1800,
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
fn::updateStatementRow($row_row_44.id, { transaction: $tx_stmt_2026_01_19_row_44.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_44.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_44.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_44.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 45
LET $row_row_45 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 45,
  postedAt: "2026-01-10T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 45,
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
LET $tx_stmt_2026_01_19_row_45 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-45",
  sourceRow: $row_row_45,
  postedAt: "2026-01-10T00:00:00Z",
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
fn::updateStatementRow($row_row_45.id, { transaction: $tx_stmt_2026_01_19_row_45.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_45.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_45.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_45.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 46
LET $row_row_46 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 46,
  postedAt: "2026-01-12T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 46,
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
LET $tx_stmt_2026_01_19_row_46 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-46",
  sourceRow: $row_row_46,
  postedAt: "2026-01-12T00:00:00Z",
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
fn::updateStatementRow($row_row_46.id, { transaction: $tx_stmt_2026_01_19_row_46.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_46.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_46.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_46.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 47
LET $row_row_47 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 47,
  postedAt: "2026-01-12T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 47,
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
LET $tx_stmt_2026_01_19_row_47 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-47",
  sourceRow: $row_row_47,
  postedAt: "2026-01-12T00:00:00Z",
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
fn::updateStatementRow($row_row_47.id, { transaction: $tx_stmt_2026_01_19_row_47.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_47.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_47.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_47.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 48
LET $row_row_48 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 48,
  postedAt: "2026-01-13T00:00:00Z",
  description: "Trade Travel Chill Abu Dhabi Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1012.59,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 48,
    rawRowText: "Trade Travel Chill Abu Dhabi Ae; 1012.59",
    transactionType: "expense",
    normalizedMerchant: "Trade Travel Chill",
    category: "Travel",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1012.59,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Travel-related merchant needs exact purpose confirmation."
});
LET $tx_stmt_2026_01_19_row_48 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-48",
  sourceRow: $row_row_48,
  postedAt: "2026-01-13T00:00:00Z",
  description: "Trade Travel Chill Abu Dhabi Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1012.59,
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
fn::updateStatementRow($row_row_48.id, { transaction: $tx_stmt_2026_01_19_row_48.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_48.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_48.id, "TransactionMerchant", $merchant_trade_travel_chill.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_48.id, "TransactionCategory", $cat_travel.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_01_19_row_48 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-01-19-row-48",
  transaction: $tx_stmt_2026_01_19_row_48,
  status: "open",
  question: "What is the exact purpose of this Trade Travel Chill transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_trade_travel_chill,
  suggestedCategory: $cat_travel,
  confidence: 0.25,
  notes: "Imported from 2026-01-19.import.md"
});
fn::createEdge($tx_stmt_2026_01_19_row_48.id, "TransactionClarificationTasks", $task_stmt_2026_01_19_row_48.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 49
LET $row_row_49 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 49,
  postedAt: "2026-01-13T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 7577,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 49,
    rawRowText: "Electronic Payment From:Internet Banking; 7577.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 7577,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2026_01_19_row_49 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-49",
  sourceRow: $row_row_49,
  postedAt: "2026-01-13T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 7577,
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
fn::updateStatementRow($row_row_49.id, { transaction: $tx_stmt_2026_01_19_row_49.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_49.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_49.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_49.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 50
LET $row_row_50 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 50,
  postedAt: "2026-01-14T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choice",
  amount: 2384.72,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 50,
    rawRowText: "The Local Choic 202880 Val De Vie E Za; 2384.72",
    transactionType: "expense",
    normalizedMerchant: "The Local Choice",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2384.72,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery / household spend."
});
LET $tx_stmt_2026_01_19_row_50 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-50",
  sourceRow: $row_row_50,
  postedAt: "2026-01-14T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choice",
  amount: 2384.72,
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
fn::updateStatementRow($row_row_50.id, { transaction: $tx_stmt_2026_01_19_row_50.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_50.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_50.id, "TransactionMerchant", $merchant_the_local_choice.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_50.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 51
LET $row_row_51 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 51,
  postedAt: "2026-01-14T00:00:00Z",
  description: "Bridge House School",
  normalizedDescription: "Bridge House School",
  amount: 30,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 51,
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
LET $tx_stmt_2026_01_19_row_51 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-51",
  sourceRow: $row_row_51,
  postedAt: "2026-01-14T00:00:00Z",
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
fn::updateStatementRow($row_row_51.id, { transaction: $tx_stmt_2026_01_19_row_51.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_51.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_51.id, "TransactionMerchant", $merchant_bridge_house_school.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_51.id, "TransactionCategory", $cat_education_children.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 52
LET $row_row_52 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 52,
  postedAt: "2026-01-14T00:00:00Z",
  description: "Bridge House School",
  normalizedDescription: "Bridge House School",
  amount: 49,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 52,
    rawRowText: "Bridge House School; 49.00",
    transactionType: "expense",
    normalizedMerchant: "Bridge House School",
    category: "Education / children",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 49,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "School-related spend."
});
LET $tx_stmt_2026_01_19_row_52 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-52",
  sourceRow: $row_row_52,
  postedAt: "2026-01-14T00:00:00Z",
  description: "Bridge House School",
  normalizedDescription: "Bridge House School",
  amount: 49,
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
fn::updateStatementRow($row_row_52.id, { transaction: $tx_stmt_2026_01_19_row_52.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_52.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_52.id, "TransactionMerchant", $merchant_bridge_house_school.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_52.id, "TransactionCategory", $cat_education_children.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 53
LET $row_row_53 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 53,
  postedAt: "2026-01-14T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 53,
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
LET $tx_stmt_2026_01_19_row_53 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-53",
  sourceRow: $row_row_53,
  postedAt: "2026-01-14T00:00:00Z",
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
fn::updateStatementRow($row_row_53.id, { transaction: $tx_stmt_2026_01_19_row_53.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_53.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_53.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_53.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 54
LET $row_row_54 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 54,
  postedAt: "2026-01-14T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 54,
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
LET $tx_stmt_2026_01_19_row_54 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-54",
  sourceRow: $row_row_54,
  postedAt: "2026-01-14T00:00:00Z",
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
fn::updateStatementRow($row_row_54.id, { transaction: $tx_stmt_2026_01_19_row_54.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_54.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_54.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_54.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 55
LET $row_row_55 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 55,
  postedAt: "2026-01-15T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 55,
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
LET $tx_stmt_2026_01_19_row_55 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-55",
  sourceRow: $row_row_55,
  postedAt: "2026-01-15T00:00:00Z",
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
fn::updateStatementRow($row_row_55.id, { transaction: $tx_stmt_2026_01_19_row_55.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_55.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_55.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_55.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 56
LET $row_row_56 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 56,
  postedAt: "2026-01-16T00:00:00Z",
  description: "Graceland Venues 74148 Paarl Za",
  normalizedDescription: "Graceland Venues",
  amount: 56,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 56,
    rawRowText: "Graceland Venues 74148 Paarl Za; 56.00",
    transactionType: "expense",
    normalizedMerchant: "Graceland Venues",
    category: "Entertainment / family",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 56,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Leisure spend."
});
LET $tx_stmt_2026_01_19_row_56 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-56",
  sourceRow: $row_row_56,
  postedAt: "2026-01-16T00:00:00Z",
  description: "Graceland Venues 74148 Paarl Za",
  normalizedDescription: "Graceland Venues",
  amount: 56,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Graceland Venues",
  merchant: $merchant_graceland_venues,
  category: $cat_entertainment_family,
  isTransfer: false,
  manualOverride: false,
  notes: "Leisure spend."
});
fn::updateStatementRow($row_row_56.id, { transaction: $tx_stmt_2026_01_19_row_56.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_56.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_56.id, "TransactionMerchant", $merchant_graceland_venues.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_56.id, "TransactionCategory", $cat_entertainment_family.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 57
LET $row_row_57 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 57,
  postedAt: "2026-01-16T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 57,
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
LET $tx_stmt_2026_01_19_row_57 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-57",
  sourceRow: $row_row_57,
  postedAt: "2026-01-16T00:00:00Z",
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
fn::updateStatementRow($row_row_57.id, { transaction: $tx_stmt_2026_01_19_row_57.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_57.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_57.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_57.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_57.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_57.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_57.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 58
LET $row_row_58 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 58,
  postedAt: "2026-01-16T00:00:00Z",
  description: "I Valr Pty Ltd Cape Town Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 58,
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
LET $tx_stmt_2026_01_19_row_58 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-58",
  sourceRow: $row_row_58,
  postedAt: "2026-01-16T00:00:00Z",
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
fn::updateStatementRow($row_row_58.id, { transaction: $tx_stmt_2026_01_19_row_58.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_58.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_58.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_58.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_58.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_58.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_58.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 59
LET $row_row_59 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 59,
  postedAt: "2026-01-16T00:00:00Z",
  description: "Bp Wine Route Klapmuts Za",
  normalizedDescription: "BP Wine Route",
  amount: 438.7,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 59,
    rawRowText: "Bp Wine Route Klapmuts Za; 438.70",
    transactionType: "expense",
    normalizedMerchant: "BP Wine Route",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 438.7,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel spend."
});
LET $tx_stmt_2026_01_19_row_59 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-59",
  sourceRow: $row_row_59,
  postedAt: "2026-01-16T00:00:00Z",
  description: "Bp Wine Route Klapmuts Za",
  normalizedDescription: "BP Wine Route",
  amount: 438.7,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "BP Wine Route",
  merchant: $merchant_bp_wine_route,
  category: $cat_fuel_transport,
  isTransfer: false,
  manualOverride: false,
  notes: "Fuel spend."
});
fn::updateStatementRow($row_row_59.id, { transaction: $tx_stmt_2026_01_19_row_59.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_59.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_59.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_59.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_59.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_59.id, "TransactionMerchant", $merchant_bp_wine_route.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_59.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 60
LET $row_row_60 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 60,
  postedAt: "2026-01-17T00:00:00Z",
  description: "Engen Paradyskloof",
  normalizedDescription: "Engen Paradyskloof",
  amount: 228.88,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 60,
    rawRowText: "Engen Paradyskloof; 228.88",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 228.88,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel spend."
});
LET $tx_stmt_2026_01_19_row_60 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-60",
  sourceRow: $row_row_60,
  postedAt: "2026-01-17T00:00:00Z",
  description: "Engen Paradyskloof",
  normalizedDescription: "Engen Paradyskloof",
  amount: 228.88,
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
fn::updateStatementRow($row_row_60.id, { transaction: $tx_stmt_2026_01_19_row_60.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_60.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_60.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_60.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 61
LET $row_row_61 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 61,
  postedAt: "2026-01-18T00:00:00Z",
  description: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen",
  amount: 45,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 61,
    rawRowText: "Blaauwklippen H 135297 Stellenbosch Za; 45.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 45,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Lifestyle or hospitality spend."
});
LET $tx_stmt_2026_01_19_row_61 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-61",
  sourceRow: $row_row_61,
  postedAt: "2026-01-18T00:00:00Z",
  description: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen",
  amount: 45,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Blaauwklippen",
  merchant: $merchant_blaauwklippen,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Lifestyle or hospitality spend."
});
fn::updateStatementRow($row_row_61.id, { transaction: $tx_stmt_2026_01_19_row_61.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_61.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_61.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_61.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_61.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_61.id, "TransactionMerchant", $merchant_blaauwklippen.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_61.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 62
LET $row_row_62 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 62,
  postedAt: "2026-01-18T00:00:00Z",
  description: "Blaauwklippen 266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen",
  amount: 90,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 62,
    rawRowText: "Blaauwklippen 266384 Stellenbosch Za; 90.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 90,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Lifestyle or hospitality spend."
});
LET $tx_stmt_2026_01_19_row_62 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-62",
  sourceRow: $row_row_62,
  postedAt: "2026-01-18T00:00:00Z",
  description: "Blaauwklippen 266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen",
  amount: 90,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Blaauwklippen",
  merchant: $merchant_blaauwklippen,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Lifestyle or hospitality spend."
});
fn::updateStatementRow($row_row_62.id, { transaction: $tx_stmt_2026_01_19_row_62.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_62.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_62.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_62.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_62.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_62.id, "TransactionMerchant", $merchant_blaauwklippen.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_62.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 63
LET $row_row_63 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 63,
  postedAt: "2026-01-18T00:00:00Z",
  description: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen",
  amount: 40,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 63,
    rawRowText: "Blaauwklippen H 135297 Stellenbosch Za; 40.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 40,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Lifestyle or hospitality spend."
});
LET $tx_stmt_2026_01_19_row_63 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-63",
  sourceRow: $row_row_63,
  postedAt: "2026-01-18T00:00:00Z",
  description: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen",
  amount: 40,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Blaauwklippen",
  merchant: $merchant_blaauwklippen,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Lifestyle or hospitality spend."
});
fn::updateStatementRow($row_row_63.id, { transaction: $tx_stmt_2026_01_19_row_63.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_63.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_63.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_63.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_63.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_63.id, "TransactionMerchant", $merchant_blaauwklippen.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_63.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 64
LET $row_row_64 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 64,
  postedAt: "2026-01-18T00:00:00Z",
  description: "Blaauwklippen 266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen",
  amount: 100,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 64,
    rawRowText: "Blaauwklippen 266384 Stellenbosch Za; 100.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 100,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Lifestyle or hospitality spend."
});
LET $tx_stmt_2026_01_19_row_64 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-64",
  sourceRow: $row_row_64,
  postedAt: "2026-01-18T00:00:00Z",
  description: "Blaauwklippen 266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen",
  amount: 100,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Blaauwklippen",
  merchant: $merchant_blaauwklippen,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Lifestyle or hospitality spend."
});
fn::updateStatementRow($row_row_64.id, { transaction: $tx_stmt_2026_01_19_row_64.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_64.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_64.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_64.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_64.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_64.id, "TransactionMerchant", $merchant_blaauwklippen.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_64.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 65
LET $row_row_65 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 65,
  postedAt: "2026-01-18T00:00:00Z",
  description: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/January 2026.pdf",
    statementPeriodStart: "2025-12-20",
    statementPeriodEnd: "2026-01-19",
    rowNo: 65,
    rawRowText: "Blaauwklippen H 135297 Stellenbosch Za; 20.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 20,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Lifestyle or hospitality spend."
});
LET $tx_stmt_2026_01_19_row_65 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-01-19-row-65",
  sourceRow: $row_row_65,
  postedAt: "2026-01-18T00:00:00Z",
  description: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Blaauwklippen",
  merchant: $merchant_blaauwklippen,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Lifestyle or hospitality spend."
});
fn::updateStatementRow($row_row_65.id, { transaction: $tx_stmt_2026_01_19_row_65.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_65.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_65.id, "StatementRowTransactions", $tx_stmt_2026_01_19_row_65.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_01_19_row_65.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_65.id, "TransactionMerchant", $merchant_blaauwklippen.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_01_19_row_65.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 65,
  normalizedCount: 65,
  clarificationCount: 3,
  status: "matched",
  statementDate: "2026-01-19T00:00:00Z",
  notes: "Imported from 2026-01-19.import.md"
});

-- End of generated import
