-- Generated from docs/statements/personal/credit/2025-11-19.import.md
-- Source: docs/statements/personal/credit/November 2025.pdf

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
  openingBalance: 108863.05,
  active: true,
  notes: "Imported from November 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-11-19-nedbank-credit",
  sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-11-19T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-11-19.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_business_expenses_paid_personally_trading_tools = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-trading-tools",
  name: "Business expenses paid personally / trading tools",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_crypto_trading = fn::createCategory({
  space: $space,
  key: "crypto-trading",
  name: "Crypto / trading",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_cash_advance = fn::createCategory({
  space: $space,
  key: "cash-advance",
  name: "Cash advance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_personal_care_pharmacy = fn::createCategory({
  space: $space,
  key: "personal-care-pharmacy",
  name: "Personal care / pharmacy",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_dining_lifestyle = fn::createCategory({
  space: $space,
  key: "dining-lifestyle",
  name: "Dining / lifestyle",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_business_expenses_paid_personally_hosting_software = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-hosting-software",
  name: "Business expenses paid personally / hosting / software",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_entertainment_family = fn::createCategory({
  space: $space,
  key: "entertainment-family",
  name: "Entertainment / family",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_groceries_household = fn::createCategory({
  space: $space,
  key: "groceries-household",
  name: "Groceries / household",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_subscription_media = fn::createCategory({
  space: $space,
  key: "subscription-media",
  name: "Subscription / media",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_fuel_transport = fn::createCategory({
  space: $space,
  key: "fuel-transport",
  name: "Fuel / transport",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_subscription_storage = fn::createCategory({
  space: $space,
  key: "subscription-storage",
  name: "Subscription / storage",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_fees_electronic_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-electronic-payment-fee",
  name: "Electronic Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_fees_declined_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-declined-payment-fee",
  name: "Declined Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_fees_credit_facility_service_fee = fn::createCategory({
  space: $space,
  key: "fees-credit-facility-service-fee",
  name: "Credit Facility Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_fees_finance_charge = fn::createCategory({
  space: $space,
  key: "fees-finance-charge",
  name: "Finance Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});

-- Merchant records
LET $merchant_nedbank_current_account = fn::createMerchant({
  space: $space,
  key: "nedbank-current-account",
  name: "Nedbank Current Account",
  normalizedName: "Nedbank Current Account",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_trade_travel_chill = fn::createMerchant({
  space: $space,
  key: "trade-travel-chill",
  name: "Trade Travel Chill",
  normalizedName: "Trade Travel Chill",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_valr = fn::createMerchant({
  space: $space,
  key: "valr",
  name: "VALR",
  normalizedName: "VALR",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_nedbank_internet_banking = fn::createMerchant({
  space: $space,
  key: "nedbank-internet-banking",
  name: "Nedbank Internet Banking",
  normalizedName: "Nedbank Internet Banking",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_clicks_stellenbosch_square = fn::createMerchant({
  space: $space,
  key: "clicks-stellenbosch-square",
  name: "Clicks Stellenbosch Square",
  normalizedName: "Clicks Stellenbosch Square",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_clipper_club_0000000000000za = fn::createMerchant({
  space: $space,
  key: "clipper-club-0000000000000za",
  name: "Clipper Club          0000000000000za",
  normalizedName: "Clipper Club          0000000000000za",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_yoco_feedem_group_t_franchhoek_za = fn::createMerchant({
  space: $space,
  key: "yoco-feedem-group-t-franchhoek-za",
  name: "Yoco *Feedem Group T Franchhoek Za",
  normalizedName: "Yoco *Feedem Group T Franchhoek Za",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_afrihost = fn::createMerchant({
  space: $space,
  key: "afrihost",
  name: "Afrihost",
  normalizedName: "Afrihost",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_backs_val_de_vie = fn::createMerchant({
  space: $space,
  key: "backs-val-de-vie",
  name: "Backs Val De Vie",
  normalizedName: "Backs Val De Vie",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_wonderdal_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "wonderdal-stellenbosch-za",
  name: "Wonderdal              Stellenbosch Za",
  normalizedName: "Wonderdal              Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_hazendal_putt_putt_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "hazendal-putt-putt-stellenbosch-za",
  name: "Hazendal Putt Putt       Stellenbosch Za",
  normalizedName: "Hazendal Putt Putt       Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_kwikspar_paradyskloof = fn::createMerchant({
  space: $space,
  key: "kwikspar-paradyskloof",
  name: "Kwikspar Paradyskloof",
  normalizedName: "Kwikspar Paradyskloof",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_blaauwklippen_266384_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "blaauwklippen-266384-stellenbosch-za",
  name: "Blaauwklippen      266384 Stellenbosch Za",
  normalizedName: "Blaauwklippen      266384 Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_blaauwklippen_266384_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "blaauwklippen-266384-stellenbosch-za",
  name: "Blaauwklippen    266384 Stellenbosch Za",
  normalizedName: "Blaauwklippen    266384 Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_blaauwklippen_h_135297_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "blaauwklippen-h-135297-stellenbosch-za",
  name: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedName: "Blaauwklippen H 135297 Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_spotify = fn::createMerchant({
  space: $space,
  key: "spotify",
  name: "Spotify",
  normalizedName: "Spotify",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_engen_paradyskloof = fn::createMerchant({
  space: $space,
  key: "engen-paradyskloof",
  name: "Engen Paradyskloof",
  normalizedName: "Engen Paradyskloof",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_giovannis_eikendal = fn::createMerchant({
  space: $space,
  key: "giovannis-eikendal",
  name: "Giovannis Eikendal",
  normalizedName: "Giovannis Eikendal",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_de_warenmarkt_144188_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "de-warenmarkt-144188-stellenbosch-za",
  name: "De Warenmarkt     144188 Stellenbosch Za",
  normalizedName: "De Warenmarkt     144188 Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_google_one = fn::createMerchant({
  space: $space,
  key: "google-one",
  name: "Google One",
  normalizedName: "Google One",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_yoco_hello_indigo_h_cape_town_za = fn::createMerchant({
  space: $space,
  key: "yoco-hello-indigo-h-cape-town-za",
  name: "Yoco *Hello Indigo H Cape Town         Za",
  normalizedName: "Yoco *Hello Indigo H Cape Town         Za",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_hyrotrader = fn::createMerchant({
  space: $space,
  key: "hyrotrader",
  name: "HyroTrader",
  normalizedName: "HyroTrader",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});
LET $merchant_bk_sanctuary_u_somerset_westza = fn::createMerchant({
  space: $space,
  key: "bk-sanctuary-u-somerset-westza",
  name: "Bk Sanctuary U          Somerset Westza",
  normalizedName: "Bk Sanctuary U          Somerset Westza",
  active: true,
  notes: "Imported from 2025-11-19.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-10-29T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 3623,
  balance: 3623,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 1,
    rawRowText: "Internet Banking Transferselby     Za; 3623.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 3623,
    bankChargeZar: null,
    balanceZar: 3623
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_11_19_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-10-29T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 3623,
  balance: 3623,
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_11_19_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_01.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_01.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-10-30T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 5000,
  balance: 5000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 2,
    rawRowText: "Internet Banking Transferselby     Za; 5000.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 5000,
    bankChargeZar: null,
    balanceZar: 5000
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_11_19_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-10-30T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 5000,
  balance: 5000,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_11_19_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_02.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_02.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-10-31T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 37500,
  balance: 37500,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 3,
    rawRowText: "Internet Banking Transferselby     Za; 37500.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 37500,
    bankChargeZar: null,
    balanceZar: 37500
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_11_19_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-10-31T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 37500,
  balance: 37500,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_11_19_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_03.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_03.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-11-17T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 31000,
  balance: 31000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 4,
    rawRowText: "Internet Banking Transferselby     Za; 31000.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 31000,
    bankChargeZar: null,
    balanceZar: 31000
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_11_19_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-11-17T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 31000,
  balance: 31000,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_11_19_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_04.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_04.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-10-21T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 5,
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
LET $tx_stmt_2025_11_19_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-10-21T00:00:00Z",
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_11_19_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_05.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_05.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-10-21T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 6,
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
LET $tx_stmt_2025_11_19_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-10-21T00:00:00Z",
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_11_19_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_06.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_06.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-10-29T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 7,
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
LET $tx_stmt_2025_11_19_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-10-29T00:00:00Z",
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_11_19_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_07.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_07.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-10-29T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 8,
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
LET $tx_stmt_2025_11_19_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-10-29T00:00:00Z",
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_11_19_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_08.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_08.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-10-31T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
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
LET $tx_stmt_2025_11_19_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-10-31T00:00:00Z",
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_11_19_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_09.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_09.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-11-11T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
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
LET $tx_stmt_2025_11_19_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-11-11T00:00:00Z",
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_11_19_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_10.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_10.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-11-12T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
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
LET $tx_stmt_2025_11_19_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-11-12T00:00:00Z",
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_11_19_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_11.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_11.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-11-13T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
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
LET $tx_stmt_2025_11_19_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-11-13T00:00:00Z",
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_11_19_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_12.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_12.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-11-13T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
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
LET $tx_stmt_2025_11_19_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-11-13T00:00:00Z",
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_11_19_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_13.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_13.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-11-13T00:00:00Z",
  description: "Maintenance Fee",
  normalizedDescription: "Maintenance Fee",
  amount: 38.26,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 14,
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
LET $tx_stmt_2025_11_19_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-11-13T00:00:00Z",
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_11_19_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_14.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_14.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-11-14T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
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
LET $tx_stmt_2025_11_19_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-11-14T00:00:00Z",
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_11_19_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_15.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_15.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-11-14T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
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
LET $tx_stmt_2025_11_19_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-11-14T00:00:00Z",
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_11_19_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_16.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_16.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-11-15T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
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
LET $tx_stmt_2025_11_19_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-11-15T00:00:00Z",
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_11_19_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_17.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_17.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-11-15T00:00:00Z",
  description: "Credit Facility Service Fee",
  normalizedDescription: "Credit Facility Service Fee",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 18,
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
LET $tx_stmt_2025_11_19_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-11-15T00:00:00Z",
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_11_19_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_18.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_18.id, "TransactionCategory", $cat_fees_credit_facility_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-11-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 2116.45,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 19,
    rawRowText: "Finance Charge; 2116.45",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "finance charge",
    clarificationStatus: "clarified",
    amountZar: 2116.45,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Finance charge on the outstanding balance."
});
LET $tx_stmt_2025_11_19_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-11-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 2116.45,
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
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_11_19_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_19.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_19.id, "TransactionCategory", $cat_fees_finance_charge.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-11-15T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 24.34,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 20,
    rawRowText: "Total V A T; 24.34",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 24.34,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "VAT on fees."
});
LET $tx_stmt_2025_11_19_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-11-15T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 24.34,
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
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_11_19_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_20.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_20.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-10-20T00:00:00Z",
  description: "Trade Travel Chill      Abu Dhabi        Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1068.9,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 21,
    rawRowText: "Trade Travel Chill      Abu Dhabi        Ae; 1068.90",
    transactionType: "expense",
    normalizedMerchant: "Trade Travel Chill",
    category: "Business expenses paid personally / trading tools",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1068.9,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Recurring trading-indicator or trading-service spend."
});
LET $tx_stmt_2025_11_19_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-10-20T00:00:00Z",
  description: "Trade Travel Chill      Abu Dhabi        Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1068.9,
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
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_11_19_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_21.id, "TransactionMerchant", $merchant_trade_travel_chill.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_21.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-10-20T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 2500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 22,
    rawRowText: "I Valr Pty Ltd         Cape Town     Za; 2500.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2500,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2025_11_19_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-10-20T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 2500,
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
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_11_19_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_22.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_22.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-10-21T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 1450,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 23,
    rawRowText: "Electronic Payment From:Internet Banking; 1450.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1450,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2025_11_19_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-10-21T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 1450,
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_11_19_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_23.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_23.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-10-21T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 1360,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 24,
    rawRowText: "Electronic Payment From:Internet Banking; 1360.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1360,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2025_11_19_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-10-21T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 1360,
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
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_11_19_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_24.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_24.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-10-21T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 25,
    rawRowText: "I Valr Pty Ltd         Cape Town     Za; 1000.00",
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
LET $tx_stmt_2025_11_19_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-10-21T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
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
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_11_19_row_25.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_25.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_25.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-10-21T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 26,
    rawRowText: "I Valr Pty Ltd         Cape Town     Za; 1000.00",
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
LET $tx_stmt_2025_11_19_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-10-21T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
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
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_11_19_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_26.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_26.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-10-21T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 27,
    rawRowText: "I Valr Pty Ltd         Cape Town     Za; 2000.00",
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
LET $tx_stmt_2025_11_19_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-10-21T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
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
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_11_19_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_27.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_27.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-10-22T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 28,
    rawRowText: "I Valr Pty Ltd         Cape Town     Za; 1000.00",
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
LET $tx_stmt_2025_11_19_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-10-22T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
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
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_11_19_row_28.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_28.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_28.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-10-22T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 29,
    rawRowText: "I Valr Pty Ltd         Cape Town     Za; 1000.00",
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
LET $tx_stmt_2025_11_19_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-10-22T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
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
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_11_19_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_29.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_29.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-10-22T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 30,
    rawRowText: "I Valr Pty Ltd         Cape Town     Za; 2000.00",
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
LET $tx_stmt_2025_11_19_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-10-22T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
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
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_11_19_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_30.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_30.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-10-23T00:00:00Z",
  description: "Clicks Stellenbosch Sq 0000000000000za",
  normalizedDescription: "Clicks Stellenbosch Square",
  amount: 119,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 31,
    rawRowText: "Clicks Stellenbosch Sq 0000000000000za; 119.00",
    transactionType: "expense",
    normalizedMerchant: "Clicks Stellenbosch Square",
    category: "Personal care / pharmacy",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 119,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Pharmacy or personal-care spend."
});
LET $tx_stmt_2025_11_19_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-10-23T00:00:00Z",
  description: "Clicks Stellenbosch Sq 0000000000000za",
  normalizedDescription: "Clicks Stellenbosch Square",
  amount: 119,
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
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_11_19_row_31.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_31.id, "TransactionMerchant", $merchant_clicks_stellenbosch_square.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_31.id, "TransactionCategory", $cat_personal_care_pharmacy.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-10-23T00:00:00Z",
  description: "Clipper Club          0000000000000za",
  normalizedDescription: "Clipper Club          0000000000000za",
  amount: 270,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 32,
    rawRowText: "Clipper Club          0000000000000za; 270.00",
    transactionType: "expense",
    normalizedMerchant: "Clipper Club          0000000000000za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 270,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_11_19_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-10-23T00:00:00Z",
  description: "Clipper Club          0000000000000za",
  normalizedDescription: "Clipper Club          0000000000000za",
  amount: 270,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Clipper Club          0000000000000za",
  merchant: $merchant_clipper_club_0000000000000za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_11_19_row_32.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_32.id, "TransactionMerchant", $merchant_clipper_club_0000000000000za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_32.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_19_row_32 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-19-row-32",
  transaction: $tx_stmt_2025_11_19_row_32,
  status: "open",
  question: "What is the exact purpose of this Clipper Club          0000000000000za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_clipper_club_0000000000000za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-11-19.import.md"
});
fn::createEdge($tx_stmt_2025_11_19_row_32.id, "TransactionClarificationTasks", $task_stmt_2025_11_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-10-24T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 28,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 33,
    rawRowText: "Yoco *Feedem Group T Franchhoek Za; 28.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Feedem Group T Franchhoek Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 28,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_11_19_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-10-24T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 28,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Yoco *Feedem Group T Franchhoek Za",
  merchant: $merchant_yoco_feedem_group_t_franchhoek_za,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_11_19_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_33.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_33.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-10-24T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 28,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 34,
    rawRowText: "Yoco *Feedem Group T Franchhoek Za; 28.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Feedem Group T Franchhoek Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 28,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_11_19_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-10-24T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 28,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Yoco *Feedem Group T Franchhoek Za",
  merchant: $merchant_yoco_feedem_group_t_franchhoek_za,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_11_19_row_34.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_34.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_34.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2025-10-24T00:00:00Z",
  description: "I Afrihost.Com 2        Cape Town        Za",
  normalizedDescription: "Afrihost",
  amount: 150,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 35,
    rawRowText: "I Afrihost.Com 2        Cape Town        Za; 150.00",
    transactionType: "expense",
    normalizedMerchant: "Afrihost",
    category: "Business expenses paid personally / hosting / software",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 150,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Hosting or internet spend."
});
LET $tx_stmt_2025_11_19_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-35",
  sourceRow: $row_row_35,
  postedAt: "2025-10-24T00:00:00Z",
  description: "I Afrihost.Com 2        Cape Town        Za",
  normalizedDescription: "Afrihost",
  amount: 150,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Afrihost",
  merchant: $merchant_afrihost,
  category: $cat_business_expenses_paid_personally_hosting_software,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting or internet spend."
});
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_11_19_row_35.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_35.id, "TransactionMerchant", $merchant_afrihost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_35.id, "TransactionCategory", $cat_business_expenses_paid_personally_hosting_software.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2025-10-25T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 36,
    rawRowText: "I Valr Pty Ltd         Cape Town     Za; 500.00",
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
LET $tx_stmt_2025_11_19_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-36",
  sourceRow: $row_row_36,
  postedAt: "2025-10-25T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
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
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_11_19_row_36.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_36.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_36.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 37
LET $row_row_37 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 37,
  postedAt: "2025-10-26T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 37,
    rawRowText: "I Valr Pty Ltd         Cape Town     Za; 500.00",
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
LET $tx_stmt_2025_11_19_row_37 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-37",
  sourceRow: $row_row_37,
  postedAt: "2025-10-26T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
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
fn::updateStatementRow($row_row_37.id, { transaction: $tx_stmt_2025_11_19_row_37.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_37.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_37.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_37.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 38
LET $row_row_38 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 38,
  postedAt: "2025-10-29T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 1360,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 38,
    rawRowText: "Electronic Payment From:Internet Banking; 1360.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1360,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2025_11_19_row_38 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-38",
  sourceRow: $row_row_38,
  postedAt: "2025-10-29T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 1360,
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
fn::updateStatementRow($row_row_38.id, { transaction: $tx_stmt_2025_11_19_row_38.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_38.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_38.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_38.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 39
LET $row_row_39 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 39,
  postedAt: "2025-10-29T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 725,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 39,
    rawRowText: "Electronic Payment From:Internet Banking; 725.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 725,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2025_11_19_row_39 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-39",
  sourceRow: $row_row_39,
  postedAt: "2025-10-29T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 725,
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
fn::updateStatementRow($row_row_39.id, { transaction: $tx_stmt_2025_11_19_row_39.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_39.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_39.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_39.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 40
LET $row_row_40 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 40,
  postedAt: "2025-10-29T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 2500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 40,
    rawRowText: "I Valr Pty Ltd         Cape Town     Za; 2500.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2500,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2025_11_19_row_40 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-40",
  sourceRow: $row_row_40,
  postedAt: "2025-10-29T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 2500,
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
fn::updateStatementRow($row_row_40.id, { transaction: $tx_stmt_2025_11_19_row_40.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_40.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_40.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_40.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 41
LET $row_row_41 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 41,
  postedAt: "2025-10-30T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 41,
    rawRowText: "I Valr Pty Ltd         Cape Town     Za; 1000.00",
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
LET $tx_stmt_2025_11_19_row_41 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-41",
  sourceRow: $row_row_41,
  postedAt: "2025-10-30T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
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
fn::updateStatementRow($row_row_41.id, { transaction: $tx_stmt_2025_11_19_row_41.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_41.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_41.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_41.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 42
LET $row_row_42 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 42,
  postedAt: "2025-10-30T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 42,
    rawRowText: "I Valr Pty Ltd         Cape Town     Za; 2000.00",
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
LET $tx_stmt_2025_11_19_row_42 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-42",
  sourceRow: $row_row_42,
  postedAt: "2025-10-30T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
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
fn::updateStatementRow($row_row_42.id, { transaction: $tx_stmt_2025_11_19_row_42.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_42.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_42.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_42.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 43
LET $row_row_43 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 43,
  postedAt: "2025-10-30T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 2500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 43,
    rawRowText: "I Valr Pty Ltd         Cape Town     Za; 2500.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2500,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2025_11_19_row_43 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-43",
  sourceRow: $row_row_43,
  postedAt: "2025-10-30T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 2500,
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
fn::updateStatementRow($row_row_43.id, { transaction: $tx_stmt_2025_11_19_row_43.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_43.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_43.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_43.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 44
LET $row_row_44 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 44,
  postedAt: "2025-10-31T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 35597,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 44,
    rawRowText: "Electronic Payment From:Internet Banking; 35597.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 35597,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2025_11_19_row_44 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-44",
  sourceRow: $row_row_44,
  postedAt: "2025-10-31T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 35597,
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
fn::updateStatementRow($row_row_44.id, { transaction: $tx_stmt_2025_11_19_row_44.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_44.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_44.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_44.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 45
LET $row_row_45 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 45,
  postedAt: "2025-10-31T00:00:00Z",
  description: "Yoco *Backs Val De V Paarl               Za",
  normalizedDescription: "Backs Val De Vie",
  amount: 306.88,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 45,
    rawRowText: "Yoco *Backs Val De V Paarl               Za; 306.88",
    transactionType: "expense",
    normalizedMerchant: "Backs Val De Vie",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 306.88,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining spend."
});
LET $tx_stmt_2025_11_19_row_45 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-45",
  sourceRow: $row_row_45,
  postedAt: "2025-10-31T00:00:00Z",
  description: "Yoco *Backs Val De V Paarl               Za",
  normalizedDescription: "Backs Val De Vie",
  amount: 306.88,
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
fn::updateStatementRow($row_row_45.id, { transaction: $tx_stmt_2025_11_19_row_45.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_45.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_45.id, "TransactionMerchant", $merchant_backs_val_de_vie.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_45.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 46
LET $row_row_46 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 46,
  postedAt: "2025-10-31T00:00:00Z",
  description: "I Afrihost.Com 2        Cape Town        Za",
  normalizedDescription: "Afrihost",
  amount: 30,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 46,
    rawRowText: "I Afrihost.Com 2        Cape Town        Za; 30.00",
    transactionType: "expense",
    normalizedMerchant: "Afrihost",
    category: "Business expenses paid personally / hosting / software",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 30,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Hosting or internet spend."
});
LET $tx_stmt_2025_11_19_row_46 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-46",
  sourceRow: $row_row_46,
  postedAt: "2025-10-31T00:00:00Z",
  description: "I Afrihost.Com 2        Cape Town        Za",
  normalizedDescription: "Afrihost",
  amount: 30,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Afrihost",
  merchant: $merchant_afrihost,
  category: $cat_business_expenses_paid_personally_hosting_software,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting or internet spend."
});
fn::updateStatementRow($row_row_46.id, { transaction: $tx_stmt_2025_11_19_row_46.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_46.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_46.id, "TransactionMerchant", $merchant_afrihost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_46.id, "TransactionCategory", $cat_business_expenses_paid_personally_hosting_software.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 47
LET $row_row_47 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 47,
  postedAt: "2025-10-31T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 47,
    rawRowText: "I Valr Pty Ltd         Cape Town     Za; 500.00",
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
LET $tx_stmt_2025_11_19_row_47 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-47",
  sourceRow: $row_row_47,
  postedAt: "2025-10-31T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
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
fn::updateStatementRow($row_row_47.id, { transaction: $tx_stmt_2025_11_19_row_47.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_47.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_47.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_47.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 48
LET $row_row_48 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 48,
  postedAt: "2025-11-01T00:00:00Z",
  description: "Wonderdal              Stellenbosch Za",
  normalizedDescription: "Wonderdal              Stellenbosch Za",
  amount: 690,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 48,
    rawRowText: "Wonderdal              Stellenbosch Za; 690.00",
    transactionType: "expense",
    normalizedMerchant: "Wonderdal              Stellenbosch Za",
    category: "Entertainment / family",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 690,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Family entertainment spend."
});
LET $tx_stmt_2025_11_19_row_48 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-48",
  sourceRow: $row_row_48,
  postedAt: "2025-11-01T00:00:00Z",
  description: "Wonderdal              Stellenbosch Za",
  normalizedDescription: "Wonderdal              Stellenbosch Za",
  amount: 690,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Wonderdal              Stellenbosch Za",
  merchant: $merchant_wonderdal_stellenbosch_za,
  category: $cat_entertainment_family,
  isTransfer: false,
  manualOverride: false,
  notes: "Family entertainment spend."
});
fn::updateStatementRow($row_row_48.id, { transaction: $tx_stmt_2025_11_19_row_48.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_48.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_48.id, "TransactionMerchant", $merchant_wonderdal_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_48.id, "TransactionCategory", $cat_entertainment_family.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 49
LET $row_row_49 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 49,
  postedAt: "2025-11-01T00:00:00Z",
  description: "Hazendal Putt Putt       Stellenbosch Za",
  normalizedDescription: "Hazendal Putt Putt       Stellenbosch Za",
  amount: 225,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 49,
    rawRowText: "Hazendal Putt Putt       Stellenbosch Za; 225.00",
    transactionType: "expense",
    normalizedMerchant: "Hazendal Putt Putt       Stellenbosch Za",
    category: "Entertainment / family",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 225,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Family entertainment spend."
});
LET $tx_stmt_2025_11_19_row_49 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-49",
  sourceRow: $row_row_49,
  postedAt: "2025-11-01T00:00:00Z",
  description: "Hazendal Putt Putt       Stellenbosch Za",
  normalizedDescription: "Hazendal Putt Putt       Stellenbosch Za",
  amount: 225,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Hazendal Putt Putt       Stellenbosch Za",
  merchant: $merchant_hazendal_putt_putt_stellenbosch_za,
  category: $cat_entertainment_family,
  isTransfer: false,
  manualOverride: false,
  notes: "Family entertainment spend."
});
fn::updateStatementRow($row_row_49.id, { transaction: $tx_stmt_2025_11_19_row_49.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_49.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_49.id, "TransactionMerchant", $merchant_hazendal_putt_putt_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_49.id, "TransactionCategory", $cat_entertainment_family.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 50
LET $row_row_50 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 50,
  postedAt: "2025-11-01T00:00:00Z",
  description: "Hazendal Putt Putt       Stellenbosch Za",
  normalizedDescription: "Hazendal Putt Putt       Stellenbosch Za",
  amount: 56,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 50,
    rawRowText: "Hazendal Putt Putt       Stellenbosch Za; 56.00",
    transactionType: "expense",
    normalizedMerchant: "Hazendal Putt Putt       Stellenbosch Za",
    category: "Entertainment / family",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 56,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Family entertainment spend."
});
LET $tx_stmt_2025_11_19_row_50 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-50",
  sourceRow: $row_row_50,
  postedAt: "2025-11-01T00:00:00Z",
  description: "Hazendal Putt Putt       Stellenbosch Za",
  normalizedDescription: "Hazendal Putt Putt       Stellenbosch Za",
  amount: 56,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Hazendal Putt Putt       Stellenbosch Za",
  merchant: $merchant_hazendal_putt_putt_stellenbosch_za,
  category: $cat_entertainment_family,
  isTransfer: false,
  manualOverride: false,
  notes: "Family entertainment spend."
});
fn::updateStatementRow($row_row_50.id, { transaction: $tx_stmt_2025_11_19_row_50.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_50.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_50.id, "TransactionMerchant", $merchant_hazendal_putt_putt_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_50.id, "TransactionCategory", $cat_entertainment_family.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 51
LET $row_row_51 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 51,
  postedAt: "2025-11-01T00:00:00Z",
  description: "I Afrihost.Com 2        Cape Town        Za",
  normalizedDescription: "Afrihost",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 51,
    rawRowText: "I Afrihost.Com 2        Cape Town        Za; 419.00",
    transactionType: "expense",
    normalizedMerchant: "Afrihost",
    category: "Business expenses paid personally / hosting / software",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 419,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Hosting or internet spend."
});
LET $tx_stmt_2025_11_19_row_51 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-51",
  sourceRow: $row_row_51,
  postedAt: "2025-11-01T00:00:00Z",
  description: "I Afrihost.Com 2        Cape Town        Za",
  normalizedDescription: "Afrihost",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Afrihost",
  merchant: $merchant_afrihost,
  category: $cat_business_expenses_paid_personally_hosting_software,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting or internet spend."
});
fn::updateStatementRow($row_row_51.id, { transaction: $tx_stmt_2025_11_19_row_51.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_51.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_51.id, "TransactionMerchant", $merchant_afrihost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_51.id, "TransactionCategory", $cat_business_expenses_paid_personally_hosting_software.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 52
LET $row_row_52 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 52,
  postedAt: "2025-11-01T00:00:00Z",
  description: "Kwikspar Paradyskloof      0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 144.76,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 52,
    rawRowText: "Kwikspar Paradyskloof      0000000000000za; 144.76",
    transactionType: "expense",
    normalizedMerchant: "Kwikspar Paradyskloof",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 144.76,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_11_19_row_52 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-52",
  sourceRow: $row_row_52,
  postedAt: "2025-11-01T00:00:00Z",
  description: "Kwikspar Paradyskloof      0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 144.76,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Kwikspar Paradyskloof",
  merchant: $merchant_kwikspar_paradyskloof,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_52.id, { transaction: $tx_stmt_2025_11_19_row_52.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_52.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_52.id, "TransactionMerchant", $merchant_kwikspar_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_52.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 53
LET $row_row_53 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 53,
  postedAt: "2025-11-02T00:00:00Z",
  description: "Blaauwklippen      266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen      266384 Stellenbosch Za",
  amount: 60,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 53,
    rawRowText: "Blaauwklippen      266384 Stellenbosch Za; 60.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen      266384 Stellenbosch Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 60,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_11_19_row_53 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-53",
  sourceRow: $row_row_53,
  postedAt: "2025-11-02T00:00:00Z",
  description: "Blaauwklippen      266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen      266384 Stellenbosch Za",
  amount: 60,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Blaauwklippen      266384 Stellenbosch Za",
  merchant: $merchant_blaauwklippen_266384_stellenbosch_za,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_53.id, { transaction: $tx_stmt_2025_11_19_row_53.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_53.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_53.id, "TransactionMerchant", $merchant_blaauwklippen_266384_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_53.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 54
LET $row_row_54 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 54,
  postedAt: "2025-11-02T00:00:00Z",
  description: "Blaauwklippen    266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen    266384 Stellenbosch Za",
  amount: 100,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 54,
    rawRowText: "Blaauwklippen    266384 Stellenbosch Za; 100.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen    266384 Stellenbosch Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 100,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_11_19_row_54 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-54",
  sourceRow: $row_row_54,
  postedAt: "2025-11-02T00:00:00Z",
  description: "Blaauwklippen    266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen    266384 Stellenbosch Za",
  amount: 100,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Blaauwklippen    266384 Stellenbosch Za",
  merchant: $merchant_blaauwklippen_266384_stellenbosch_za,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_54.id, { transaction: $tx_stmt_2025_11_19_row_54.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_54.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_54.id, "TransactionMerchant", $merchant_blaauwklippen_266384_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_54.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 55
LET $row_row_55 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 55,
  postedAt: "2025-11-02T00:00:00Z",
  description: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen H 135297 Stellenbosch Za",
  amount: 40,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 55,
    rawRowText: "Blaauwklippen H 135297 Stellenbosch Za; 40.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen H 135297 Stellenbosch Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 40,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_11_19_row_55 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-55",
  sourceRow: $row_row_55,
  postedAt: "2025-11-02T00:00:00Z",
  description: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen H 135297 Stellenbosch Za",
  amount: 40,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Blaauwklippen H 135297 Stellenbosch Za",
  merchant: $merchant_blaauwklippen_h_135297_stellenbosch_za,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_55.id, { transaction: $tx_stmt_2025_11_19_row_55.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_55.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_55.id, "TransactionMerchant", $merchant_blaauwklippen_h_135297_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_55.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 56
LET $row_row_56 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 56,
  postedAt: "2025-11-02T00:00:00Z",
  description: "Blaauwklippen    266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen    266384 Stellenbosch Za",
  amount: 120,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 56,
    rawRowText: "Blaauwklippen    266384 Stellenbosch Za; 120.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen    266384 Stellenbosch Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 120,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_11_19_row_56 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-56",
  sourceRow: $row_row_56,
  postedAt: "2025-11-02T00:00:00Z",
  description: "Blaauwklippen    266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen    266384 Stellenbosch Za",
  amount: 120,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Blaauwklippen    266384 Stellenbosch Za",
  merchant: $merchant_blaauwklippen_266384_stellenbosch_za,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_56.id, { transaction: $tx_stmt_2025_11_19_row_56.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_56.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_56.id, "TransactionMerchant", $merchant_blaauwklippen_266384_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_56.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 57
LET $row_row_57 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 57,
  postedAt: "2025-11-02T00:00:00Z",
  description: "Spotifyza       Stockholm Se",
  normalizedDescription: "Spotify",
  amount: 69.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 57,
    rawRowText: "Spotifyza       Stockholm Se; 69.99",
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
LET $tx_stmt_2025_11_19_row_57 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-57",
  sourceRow: $row_row_57,
  postedAt: "2025-11-02T00:00:00Z",
  description: "Spotifyza       Stockholm Se",
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
fn::updateStatementRow($row_row_57.id, { transaction: $tx_stmt_2025_11_19_row_57.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_57.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_57.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_57.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_57.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_57.id, "TransactionMerchant", $merchant_spotify.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_57.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 58
LET $row_row_58 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 58,
  postedAt: "2025-11-07T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 58,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 58,
    rawRowText: "Yoco *Feedem Group T Franchhoek Za; 58.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Feedem Group T Franchhoek Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 58,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_11_19_row_58 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-58",
  sourceRow: $row_row_58,
  postedAt: "2025-11-07T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 58,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Yoco *Feedem Group T Franchhoek Za",
  merchant: $merchant_yoco_feedem_group_t_franchhoek_za,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_58.id, { transaction: $tx_stmt_2025_11_19_row_58.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_58.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_58.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_58.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_58.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_58.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_58.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 59
LET $row_row_59 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 59,
  postedAt: "2025-11-07T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 45,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 59,
    rawRowText: "Yoco *Feedem Group T Franchhoek Za; 45.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Feedem Group T Franchhoek Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 45,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_11_19_row_59 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-59",
  sourceRow: $row_row_59,
  postedAt: "2025-11-07T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 45,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Yoco *Feedem Group T Franchhoek Za",
  merchant: $merchant_yoco_feedem_group_t_franchhoek_za,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_59.id, { transaction: $tx_stmt_2025_11_19_row_59.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_59.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_59.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_59.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_59.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_59.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_59.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 60
LET $row_row_60 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 60,
  postedAt: "2025-11-07T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 129.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 60,
    rawRowText: "Engen Paradyskloof      0000000000000za; 129.99",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 129.99,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_11_19_row_60 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-60",
  sourceRow: $row_row_60,
  postedAt: "2025-11-07T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 129.99,
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
  notes: "Fuel or transport spend."
});
fn::updateStatementRow($row_row_60.id, { transaction: $tx_stmt_2025_11_19_row_60.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_60.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_60.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_60.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 61
LET $row_row_61 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 61,
  postedAt: "2025-11-07T00:00:00Z",
  description: "Kwikspar Paradyskloof    0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 63.98,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 61,
    rawRowText: "Kwikspar Paradyskloof    0000000000000za; 63.98",
    transactionType: "expense",
    normalizedMerchant: "Kwikspar Paradyskloof",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 63.98,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_11_19_row_61 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-61",
  sourceRow: $row_row_61,
  postedAt: "2025-11-07T00:00:00Z",
  description: "Kwikspar Paradyskloof    0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 63.98,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Kwikspar Paradyskloof",
  merchant: $merchant_kwikspar_paradyskloof,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_61.id, { transaction: $tx_stmt_2025_11_19_row_61.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_61.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_61.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_61.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_61.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_61.id, "TransactionMerchant", $merchant_kwikspar_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_61.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 62
LET $row_row_62 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 62,
  postedAt: "2025-11-08T00:00:00Z",
  description: "Giovannis Eikendal      0000000000000za",
  normalizedDescription: "Giovannis Eikendal",
  amount: 304,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 62,
    rawRowText: "Giovannis Eikendal      0000000000000za; 304.00",
    transactionType: "expense",
    normalizedMerchant: "Giovannis Eikendal",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 304,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_11_19_row_62 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-62",
  sourceRow: $row_row_62,
  postedAt: "2025-11-08T00:00:00Z",
  description: "Giovannis Eikendal      0000000000000za",
  normalizedDescription: "Giovannis Eikendal",
  amount: 304,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Giovannis Eikendal",
  merchant: $merchant_giovannis_eikendal,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_62.id, { transaction: $tx_stmt_2025_11_19_row_62.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_62.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_62.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_62.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_62.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_62.id, "TransactionMerchant", $merchant_giovannis_eikendal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_62.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 63
LET $row_row_63 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 63,
  postedAt: "2025-11-10T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 74.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 63,
    rawRowText: "Engen Paradyskloof      0000000000000za; 74.99",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 74.99,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_11_19_row_63 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-63",
  sourceRow: $row_row_63,
  postedAt: "2025-11-10T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 74.99,
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
  notes: "Fuel or transport spend."
});
fn::updateStatementRow($row_row_63.id, { transaction: $tx_stmt_2025_11_19_row_63.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_63.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_63.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_63.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_63.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_63.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_63.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 64
LET $row_row_64 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 64,
  postedAt: "2025-11-13T00:00:00Z",
  description: "Kwikspar Paradyskloof    0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 87.98,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 64,
    rawRowText: "Kwikspar Paradyskloof    0000000000000za; 87.98",
    transactionType: "expense",
    normalizedMerchant: "Kwikspar Paradyskloof",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 87.98,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_11_19_row_64 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-64",
  sourceRow: $row_row_64,
  postedAt: "2025-11-13T00:00:00Z",
  description: "Kwikspar Paradyskloof    0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 87.98,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Kwikspar Paradyskloof",
  merchant: $merchant_kwikspar_paradyskloof,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_64.id, { transaction: $tx_stmt_2025_11_19_row_64.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_64.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_64.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_64.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_64.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_64.id, "TransactionMerchant", $merchant_kwikspar_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_64.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 65
LET $row_row_65 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 65,
  postedAt: "2025-11-16T00:00:00Z",
  description: "De Warenmarkt     144188 Stellenbosch Za",
  normalizedDescription: "De Warenmarkt     144188 Stellenbosch Za",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 65,
    rawRowText: "De Warenmarkt     144188 Stellenbosch Za; 500.00",
    transactionType: "expense",
    normalizedMerchant: "De Warenmarkt     144188 Stellenbosch Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 500,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_11_19_row_65 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-65",
  sourceRow: $row_row_65,
  postedAt: "2025-11-16T00:00:00Z",
  description: "De Warenmarkt     144188 Stellenbosch Za",
  normalizedDescription: "De Warenmarkt     144188 Stellenbosch Za",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "De Warenmarkt     144188 Stellenbosch Za",
  merchant: $merchant_de_warenmarkt_144188_stellenbosch_za,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_65.id, { transaction: $tx_stmt_2025_11_19_row_65.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_65.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_65.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_65.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_65.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_65.id, "TransactionMerchant", $merchant_de_warenmarkt_144188_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_65.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 66
LET $row_row_66 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 66,
  postedAt: "2025-11-16T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 239.98,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 66,
    rawRowText: "Engen Paradyskloof      0000000000000za; 239.98",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 239.98,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_11_19_row_66 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-66",
  sourceRow: $row_row_66,
  postedAt: "2025-11-16T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 239.98,
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
  notes: "Fuel or transport spend."
});
fn::updateStatementRow($row_row_66.id, { transaction: $tx_stmt_2025_11_19_row_66.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_66.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_66.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_66.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_66.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_66.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_66.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 67
LET $row_row_67 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 67,
  postedAt: "2025-11-16T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 660.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 67,
    rawRowText: "Engen Paradyskloof      0000000000000za; 660.99",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 660.99,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_11_19_row_67 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-67",
  sourceRow: $row_row_67,
  postedAt: "2025-11-16T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 660.99,
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
  notes: "Fuel or transport spend."
});
fn::updateStatementRow($row_row_67.id, { transaction: $tx_stmt_2025_11_19_row_67.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_67.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_67.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_67.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_67.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_67.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_67.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 68
LET $row_row_68 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 68,
  postedAt: "2025-11-16T00:00:00Z",
  description: "Kwikspar Paradyskloof    0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 187.19,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 68,
    rawRowText: "Kwikspar Paradyskloof    0000000000000za; 187.19",
    transactionType: "expense",
    normalizedMerchant: "Kwikspar Paradyskloof",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 187.19,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_11_19_row_68 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-68",
  sourceRow: $row_row_68,
  postedAt: "2025-11-16T00:00:00Z",
  description: "Kwikspar Paradyskloof    0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 187.19,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Kwikspar Paradyskloof",
  merchant: $merchant_kwikspar_paradyskloof,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_68.id, { transaction: $tx_stmt_2025_11_19_row_68.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_68.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_68.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_68.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_68.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_68.id, "TransactionMerchant", $merchant_kwikspar_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_68.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 69
LET $row_row_69 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 69,
  postedAt: "2025-11-16T00:00:00Z",
  description: "Google One         London    Gb",
  normalizedDescription: "Google One",
  amount: 349.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 69,
    rawRowText: "Google One         London    Gb; 349.99",
    transactionType: "expense",
    normalizedMerchant: "Google One",
    category: "Subscription / storage",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 349.99,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Storage subscription."
});
LET $tx_stmt_2025_11_19_row_69 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-69",
  sourceRow: $row_row_69,
  postedAt: "2025-11-16T00:00:00Z",
  description: "Google One         London    Gb",
  normalizedDescription: "Google One",
  amount: 349.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Google One",
  merchant: $merchant_google_one,
  category: $cat_subscription_storage,
  isTransfer: false,
  manualOverride: false,
  notes: "Storage subscription."
});
fn::updateStatementRow($row_row_69.id, { transaction: $tx_stmt_2025_11_19_row_69.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_69.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_69.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_69.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_69.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_69.id, "TransactionMerchant", $merchant_google_one.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_69.id, "TransactionCategory", $cat_subscription_storage.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 70
LET $row_row_70 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 70,
  postedAt: "2025-11-16T00:00:00Z",
  description: "Engen Paradyskloof   0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 1134,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 70,
    rawRowText: "Engen Paradyskloof   0000000000000za; 1134.00",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1134,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_11_19_row_70 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-70",
  sourceRow: $row_row_70,
  postedAt: "2025-11-16T00:00:00Z",
  description: "Engen Paradyskloof   0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 1134,
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
  notes: "Fuel or transport spend."
});
fn::updateStatementRow($row_row_70.id, { transaction: $tx_stmt_2025_11_19_row_70.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_70.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_70.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_70.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_70.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_70.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_70.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 71
LET $row_row_71 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 71,
  postedAt: "2025-11-16T00:00:00Z",
  description: "Yoco *Hello Indigo H Cape Town         Za",
  normalizedDescription: "Yoco *Hello Indigo H Cape Town         Za",
  amount: 1451,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 71,
    rawRowText: "Yoco *Hello Indigo H Cape Town         Za; 1451.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Hello Indigo H Cape Town         Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1451,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_11_19_row_71 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-71",
  sourceRow: $row_row_71,
  postedAt: "2025-11-16T00:00:00Z",
  description: "Yoco *Hello Indigo H Cape Town         Za",
  normalizedDescription: "Yoco *Hello Indigo H Cape Town         Za",
  amount: 1451,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Yoco *Hello Indigo H Cape Town         Za",
  merchant: $merchant_yoco_hello_indigo_h_cape_town_za,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_71.id, { transaction: $tx_stmt_2025_11_19_row_71.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_71.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_71.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_71.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_71.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_71.id, "TransactionMerchant", $merchant_yoco_hello_indigo_h_cape_town_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_71.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 72
LET $row_row_72 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 72,
  postedAt: "2025-11-17T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 56,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 72,
    rawRowText: "Yoco *Feedem Group T Franchhoek Za; 56.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Feedem Group T Franchhoek Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 56,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_11_19_row_72 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-72",
  sourceRow: $row_row_72,
  postedAt: "2025-11-17T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 56,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Yoco *Feedem Group T Franchhoek Za",
  merchant: $merchant_yoco_feedem_group_t_franchhoek_za,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_72.id, { transaction: $tx_stmt_2025_11_19_row_72.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_72.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_72.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_72.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_72.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_72.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_72.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 73
LET $row_row_73 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 73,
  postedAt: "2025-11-17T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 62,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 73,
    rawRowText: "Yoco *Feedem Group T Franchhoek Za; 62.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Feedem Group T Franchhoek Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 62,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_11_19_row_73 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-73",
  sourceRow: $row_row_73,
  postedAt: "2025-11-17T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 62,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Yoco *Feedem Group T Franchhoek Za",
  merchant: $merchant_yoco_feedem_group_t_franchhoek_za,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_73.id, { transaction: $tx_stmt_2025_11_19_row_73.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_73.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_73.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_73.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_73.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_73.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_73.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 74
LET $row_row_74 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 74,
  postedAt: "2025-11-17T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 124.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 74,
    rawRowText: "Engen Paradyskloof      0000000000000za; 124.99",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 124.99,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_11_19_row_74 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-74",
  sourceRow: $row_row_74,
  postedAt: "2025-11-17T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 124.99,
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
  notes: "Fuel or transport spend."
});
fn::updateStatementRow($row_row_74.id, { transaction: $tx_stmt_2025_11_19_row_74.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_74.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_74.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_74.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_74.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_74.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_74.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 75
LET $row_row_75 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 75,
  postedAt: "2025-11-17T00:00:00Z",
  description: "Kwikspar Paradyskloof    0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 28.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 75,
    rawRowText: "Kwikspar Paradyskloof    0000000000000za; 28.99",
    transactionType: "expense",
    normalizedMerchant: "Kwikspar Paradyskloof",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 28.99,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_11_19_row_75 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-75",
  sourceRow: $row_row_75,
  postedAt: "2025-11-17T00:00:00Z",
  description: "Kwikspar Paradyskloof    0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 28.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Kwikspar Paradyskloof",
  merchant: $merchant_kwikspar_paradyskloof,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_75.id, { transaction: $tx_stmt_2025_11_19_row_75.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_75.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_75.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_75.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_75.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_75.id, "TransactionMerchant", $merchant_kwikspar_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_75.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 76
LET $row_row_76 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 76,
  postedAt: "2025-11-17T00:00:00Z",
  description: "Trade Travel Chill      Abu Dhabi    Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1054.37,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 76,
    rawRowText: "Trade Travel Chill      Abu Dhabi    Ae; 1054.37",
    transactionType: "expense",
    normalizedMerchant: "Trade Travel Chill",
    category: "Business expenses paid personally / trading tools",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1054.37,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Recurring trading-indicator or trading-service spend."
});
LET $tx_stmt_2025_11_19_row_76 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-76",
  sourceRow: $row_row_76,
  postedAt: "2025-11-17T00:00:00Z",
  description: "Trade Travel Chill      Abu Dhabi    Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1054.37,
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
fn::updateStatementRow($row_row_76.id, { transaction: $tx_stmt_2025_11_19_row_76.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_76.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_76.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_76.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_76.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_76.id, "TransactionMerchant", $merchant_trade_travel_chill.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_76.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 77
LET $row_row_77 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 77,
  postedAt: "2025-11-18T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 142.89,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 77,
    rawRowText: "Engen Paradyskloof      0000000000000za; 142.89",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 142.89,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_11_19_row_77 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-77",
  sourceRow: $row_row_77,
  postedAt: "2025-11-18T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 142.89,
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
  notes: "Fuel or transport spend."
});
fn::updateStatementRow($row_row_77.id, { transaction: $tx_stmt_2025_11_19_row_77.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_77.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_77.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_77.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_77.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_77.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_77.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 78
LET $row_row_78 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 78,
  postedAt: "2025-11-18T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 104.98,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 78,
    rawRowText: "Engen Paradyskloof      0000000000000za; 104.98",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 104.98,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_11_19_row_78 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-78",
  sourceRow: $row_row_78,
  postedAt: "2025-11-18T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 104.98,
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
  notes: "Fuel or transport spend."
});
fn::updateStatementRow($row_row_78.id, { transaction: $tx_stmt_2025_11_19_row_78.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_78.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_78.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_78.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_78.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_78.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_78.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 79
LET $row_row_79 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 79,
  postedAt: "2025-11-18T00:00:00Z",
  description: "Kwikspar Paradyskloof    0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 17.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 79,
    rawRowText: "Kwikspar Paradyskloof    0000000000000za; 17.99",
    transactionType: "expense",
    normalizedMerchant: "Kwikspar Paradyskloof",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 17.99,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_11_19_row_79 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-79",
  sourceRow: $row_row_79,
  postedAt: "2025-11-18T00:00:00Z",
  description: "Kwikspar Paradyskloof    0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 17.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Kwikspar Paradyskloof",
  merchant: $merchant_kwikspar_paradyskloof,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_79.id, { transaction: $tx_stmt_2025_11_19_row_79.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_79.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_79.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_79.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_79.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_79.id, "TransactionMerchant", $merchant_kwikspar_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_79.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 80
LET $row_row_80 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 80,
  postedAt: "2025-11-18T00:00:00Z",
  description: "Hyrotrader           Bratislava Sk",
  normalizedDescription: "HyroTrader",
  amount: 10766.14,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 80,
    rawRowText: "Hyrotrader           Bratislava Sk; 10766.14",
    transactionType: "expense",
    normalizedMerchant: "HyroTrader",
    category: "Business expenses paid personally / trading tools",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 10766.14,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Likely prop-firm or trading-service spend; confirm exact product later."
});
LET $tx_stmt_2025_11_19_row_80 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-80",
  sourceRow: $row_row_80,
  postedAt: "2025-11-18T00:00:00Z",
  description: "Hyrotrader           Bratislava Sk",
  normalizedDescription: "HyroTrader",
  amount: 10766.14,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "HyroTrader",
  merchant: $merchant_hyrotrader,
  category: $cat_business_expenses_paid_personally_trading_tools,
  isTransfer: false,
  manualOverride: false,
  notes: "Likely prop-firm or trading-service spend; confirm exact product later."
});
fn::updateStatementRow($row_row_80.id, { transaction: $tx_stmt_2025_11_19_row_80.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_80.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_80.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_80.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_80.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_80.id, "TransactionMerchant", $merchant_hyrotrader.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_80.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_tools.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_11_19_row_80 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-11-19-row-80",
  transaction: $tx_stmt_2025_11_19_row_80,
  status: "open",
  question: "What is the exact purpose of this HyroTrader transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_hyrotrader,
  suggestedCategory: $cat_business_expenses_paid_personally_trading_tools,
  confidence: 0.25,
  notes: "Imported from 2025-11-19.import.md"
});
fn::createEdge($tx_stmt_2025_11_19_row_80.id, "TransactionClarificationTasks", $task_stmt_2025_11_19_row_80.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 81
LET $row_row_81 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 81,
  postedAt: "2025-11-18T00:00:00Z",
  description: "Bk Sanctuary U          Somerset Westza",
  normalizedDescription: "Bk Sanctuary U          Somerset Westza",
  amount: 110.9,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/November 2025.pdf",
    statementPeriodStart: "2025-10-21",
    statementPeriodEnd: "2025-11-19",
    rowNo: 81,
    rawRowText: "Bk Sanctuary U          Somerset Westza; 110.90",
    transactionType: "expense",
    normalizedMerchant: "Bk Sanctuary U          Somerset Westza",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 110.9,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_11_19_row_81 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-11-19-row-81",
  sourceRow: $row_row_81,
  postedAt: "2025-11-18T00:00:00Z",
  description: "Bk Sanctuary U          Somerset Westza",
  normalizedDescription: "Bk Sanctuary U          Somerset Westza",
  amount: 110.9,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Bk Sanctuary U          Somerset Westza",
  merchant: $merchant_bk_sanctuary_u_somerset_westza,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_81.id, { transaction: $tx_stmt_2025_11_19_row_81.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_81.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_81.id, "StatementRowTransactions", $tx_stmt_2025_11_19_row_81.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_11_19_row_81.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_81.id, "TransactionMerchant", $merchant_bk_sanctuary_u_somerset_westza.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_11_19_row_81.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 81,
  normalizedCount: 81,
  clarificationCount: 2,
  status: "matched",
  statementDate: "2025-11-19T00:00:00Z",
  notes: "Imported from 2025-11-19.import.md"
});

-- End of generated import
