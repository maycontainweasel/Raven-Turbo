-- Generated from docs/statements/personal/credit/2025-06-19.import.md
-- Source: docs/statements/personal/credit/June 2025.pdf

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
  openingBalance: 110998.38,
  active: true,
  notes: "Imported from June 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-06-19-nedbank-credit",
  sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-06-19T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-06-19.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_fast_food_takeout = fn::createCategory({
  space: $space,
  key: "fast-food-takeout",
  name: "Fast food / takeout",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_domains_hosting = fn::createCategory({
  space: $space,
  key: "domains-hosting",
  name: "Domains / hosting",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_groceries_household = fn::createCategory({
  space: $space,
  key: "groceries-household",
  name: "Groceries / household",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_business_expenses_paid_personally_trading_tools = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-trading-tools",
  name: "Business expenses paid personally / trading tools",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_fuel_transport = fn::createCategory({
  space: $space,
  key: "fuel-transport",
  name: "Fuel / transport",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_dining_lifestyle = fn::createCategory({
  space: $space,
  key: "dining-lifestyle",
  name: "Dining / lifestyle",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_coffee_takeaway = fn::createCategory({
  space: $space,
  key: "coffee-takeaway",
  name: "Coffee / takeaway",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_crypto_trading = fn::createCategory({
  space: $space,
  key: "crypto-trading",
  name: "Crypto / trading",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_haircut_grooming = fn::createCategory({
  space: $space,
  key: "haircut-grooming",
  name: "Haircut / grooming",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_social_going_out = fn::createCategory({
  space: $space,
  key: "social-going-out",
  name: "Social / going out",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_business_expenses_paid_personally_mobile_phone = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-mobile-phone",
  name: "Business expenses paid personally / mobile phone",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_subscription_media = fn::createCategory({
  space: $space,
  key: "subscription-media",
  name: "Subscription / media",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_retail_books = fn::createCategory({
  space: $space,
  key: "retail-books",
  name: "Retail / books",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_social_wine_bar = fn::createCategory({
  space: $space,
  key: "social-wine-bar",
  name: "Social / wine bar",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_fees_declined_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-declined-payment-fee",
  name: "Declined Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_fees_credit_facility_service_fee = fn::createCategory({
  space: $space,
  key: "fees-credit-facility-service-fee",
  name: "Credit Facility Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_fees_finance_charge = fn::createCategory({
  space: $space,
  key: "fees-finance-charge",
  name: "Finance Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});

-- Merchant records
LET $merchant_nedbank_current_account = fn::createMerchant({
  space: $space,
  key: "nedbank-current-account",
  name: "Nedbank Current Account",
  normalizedName: "Nedbank Current Account",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_backs_restaurant_and_d = fn::createMerchant({
  space: $space,
  key: "backs-restaurant-and-d",
  name: "Backs Restaurant And D",
  normalizedName: "Backs Restaurant And D",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_name_com = fn::createMerchant({
  space: $space,
  key: "name-com",
  name: "Name.com",
  normalizedName: "Name.com",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_the_local_choic_202880_val_de_vie_e_za = fn::createMerchant({
  space: $space,
  key: "the-local-choic-202880-val-de-vie-e-za",
  name: "The Local Choic 202880 Val De Vie E Za",
  normalizedName: "The Local Choic 202880 Val De Vie E Za",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_trade_travel_chill = fn::createMerchant({
  space: $space,
  key: "trade-travel-chill",
  name: "Trade Travel Chill",
  normalizedName: "Trade Travel Chill",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_engen_wemmershoek_conv = fn::createMerchant({
  space: $space,
  key: "engen-wemmershoek-conv",
  name: "Engen Wemmershoek Conv",
  normalizedName: "Engen Wemmershoek Conv",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_panarottis_paarl = fn::createMerchant({
  space: $space,
  key: "panarottis-paarl",
  name: "Panarottis Paarl",
  normalizedName: "Panarottis Paarl",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_ashtons_coffee = fn::createMerchant({
  space: $space,
  key: "ashtons-coffee",
  name: "Ashtons Coffee",
  normalizedName: "Ashtons Coffee",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_yoco_john_martin_ph_paarl_za = fn::createMerchant({
  space: $space,
  key: "yoco-john-martin-ph-paarl-za",
  name: "Yoco *John Martin Ph Paarl                Za",
  normalizedName: "Yoco *John Martin Ph Paarl                Za",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_valr = fn::createMerchant({
  space: $space,
  key: "valr",
  name: "VALR",
  normalizedName: "VALR",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_vdv_barber = fn::createMerchant({
  space: $space,
  key: "vdv-barber",
  name: "VDV Barber",
  normalizedName: "VDV Barber",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_barcadia = fn::createMerchant({
  space: $space,
  key: "barcadia",
  name: "Barcadia",
  normalizedName: "Barcadia",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_bk_3_arts_dt_u_plplumstead_za = fn::createMerchant({
  space: $space,
  key: "bk-3-arts-dt-u-plplumstead-za",
  name: "Bk 3 Arts Dt U         Plplumstead      Za",
  normalizedName: "Bk 3 Arts Dt U         Plplumstead      Za",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_afrihost = fn::createMerchant({
  space: $space,
  key: "afrihost",
  name: "Afrihost",
  normalizedName: "Afrihost",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_spotify = fn::createMerchant({
  space: $space,
  key: "spotify",
  name: "Spotify",
  normalizedName: "Spotify",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_wwh_drakenstein_sentru = fn::createMerchant({
  space: $space,
  key: "wwh-drakenstein-sentru",
  name: "Wwh Drakenstein Sentru",
  normalizedName: "Wwh Drakenstein Sentru",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_pna_drakenstein_paarl_za = fn::createMerchant({
  space: $space,
  key: "pna-drakenstein-paarl-za",
  name: "Pna Drakenstein         Paarl        Za",
  normalizedName: "Pna Drakenstein         Paarl        Za",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_yoco_feedem_group_t_franchhoek_za = fn::createMerchant({
  space: $space,
  key: "yoco-feedem-group-t-franchhoek-za",
  name: "Yoco *Feedem Group T Franchhoek Za",
  normalizedName: "Yoco *Feedem Group T Franchhoek Za",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_checkers_sixty60 = fn::createMerchant({
  space: $space,
  key: "checkers-sixty60",
  name: "Checkers Sixty60",
  normalizedName: "Checkers Sixty60",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_plato_val_de_vie = fn::createMerchant({
  space: $space,
  key: "plato-val-de-vie",
  name: "Plato Val De Vie",
  normalizedName: "Plato Val De Vie",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});
LET $merchant_huguenot_villa = fn::createMerchant({
  space: $space,
  key: "huguenot-villa",
  name: "Huguenot Villa",
  normalizedName: "Huguenot Villa",
  active: true,
  notes: "Imported from 2025-06-19.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-05-20T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1000,
  balance: 1000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 1,
    rawRowText: "Internet Banking Transferselby       Za; 1000.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: 1000
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_06_19_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-05-20T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1000,
  balance: 1000,
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_06_19_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_01.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_01.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-05-23T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 5000,
  balance: 5000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 2,
    rawRowText: "Internet Banking Transferselby       Za; 5000.00 Cr",
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
LET $tx_stmt_2025_06_19_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-05-23T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_06_19_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_02.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_02.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-05-27T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 3500,
  balance: 3500,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 3,
    rawRowText: "Internet Banking Transferselby       Za; 3500.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 3500,
    bankChargeZar: null,
    balanceZar: 3500
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_06_19_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-05-27T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 3500,
  balance: 3500,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_06_19_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_03.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_03.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 5770,
  balance: 5770,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 4,
    rawRowText: "Internet Banking Transferselby       Za; 5770.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 5770,
    bankChargeZar: null,
    balanceZar: 5770
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_06_19_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 5770,
  balance: 5770,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_06_19_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_04.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_04.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-06-12T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2500,
  balance: 2500,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 5,
    rawRowText: "Internet Banking Transferselby       Za; 2500.00 Cr",
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
LET $tx_stmt_2025_06_19_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-06-12T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_06_19_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_05.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_05.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-05-20T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
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
LET $tx_stmt_2025_06_19_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-05-20T00:00:00Z",
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_06_19_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_06.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_06.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-06-13T00:00:00Z",
  description: "Maintenance Fee",
  normalizedDescription: "Maintenance Fee",
  amount: 38.26,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 7,
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
LET $tx_stmt_2025_06_19_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-06-13T00:00:00Z",
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_06_19_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_07.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_07.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-06-14T00:00:00Z",
  description: "Credit Facility Service Fee",
  normalizedDescription: "Credit Facility Service Fee",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 8,
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
LET $tx_stmt_2025_06_19_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-06-14T00:00:00Z",
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_06_19_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_08.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_08.id, "TransactionCategory", $cat_fees_credit_facility_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-06-17T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
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
LET $tx_stmt_2025_06_19_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-06-17T00:00:00Z",
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_06_19_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_09.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_09.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-06-17T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
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
LET $tx_stmt_2025_06_19_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-06-17T00:00:00Z",
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_06_19_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_10.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_10.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-06-17T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
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
LET $tx_stmt_2025_06_19_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-06-17T00:00:00Z",
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_06_19_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_11.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_11.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-06-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 1952.97,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 12,
    rawRowText: "Finance Charge; 1952.97",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "finance charge",
    clarificationStatus: "clarified",
    amountZar: 1952.97,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Finance charge on the outstanding balance."
});
LET $tx_stmt_2025_06_19_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-06-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 1952.97,
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_06_19_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_12.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_12.id, "TransactionCategory", $cat_fees_finance_charge.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-06-17T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 13.94,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 13,
    rawRowText: "Total V A T; 13.94",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 13.94,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "VAT on fees."
});
LET $tx_stmt_2025_06_19_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-06-17T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 13.94,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_06_19_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_13.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_13.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-05-17T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D",
  amount: 160,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 15,
    rawRowText: "Backs Restaurant And D Paarl              Za; 160.00",
    transactionType: "expense",
    normalizedMerchant: "Backs Restaurant And D",
    category: "Fast food / takeout",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 160,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fast-food takeout."
});
LET $tx_stmt_2025_06_19_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-05-17T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D",
  amount: 160,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_06_19_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_15.id, "TransactionMerchant", $merchant_backs_restaurant_and_d.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_15.id, "TransactionCategory", $cat_fast_food_takeout.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Paypal *Namecominc     4029357733 Us",
  normalizedDescription: "Name.com",
  amount: 248.93,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 16,
    rawRowText: "Paypal *Namecominc     4029357733 Us; 248.93",
    transactionType: "expense",
    normalizedMerchant: "Name.com",
    category: "Domains / hosting",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 248.93,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Domain-related payment on Name.com."
});
LET $tx_stmt_2025_06_19_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Paypal *Namecominc     4029357733 Us",
  normalizedDescription: "Name.com",
  amount: 248.93,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Name.com",
  merchant: $merchant_name_com,
  category: $cat_domains_hosting,
  isTransfer: false,
  manualOverride: false,
  notes: "Domain-related payment on Name.com."
});
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_06_19_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_16.id, "TransactionMerchant", $merchant_name_com.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_16.id, "TransactionCategory", $cat_domains_hosting.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-05-23T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 1409.73,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 17,
    rawRowText: "The Local Choic 202880 Val De Vie E Za; 1409.73",
    transactionType: "expense",
    normalizedMerchant: "The Local Choic 202880 Val De Vie E Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1409.73,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_06_19_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-05-23T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 1409.73,
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_06_19_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_17.id, "TransactionMerchant", $merchant_the_local_choic_202880_val_de_vie_e_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_17.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-05-23T00:00:00Z",
  description: "Trade Travel Chill Abu Dhabi Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1105.25,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 18,
    rawRowText: "Trade Travel Chill Abu Dhabi Ae; 1105.25",
    transactionType: "expense",
    normalizedMerchant: "Trade Travel Chill",
    category: "Business expenses paid personally / trading tools",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1105.25,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Recurring trading-indicator or trading-service spend."
});
LET $tx_stmt_2025_06_19_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-05-23T00:00:00Z",
  description: "Trade Travel Chill Abu Dhabi Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1105.25,
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_06_19_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_18.id, "TransactionMerchant", $merchant_trade_travel_chill.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_18.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-05-24T00:00:00Z",
  description: "Engen Wemmershoek Conv 0000000000000za",
  normalizedDescription: "Engen Wemmershoek Conv",
  amount: 1391.42,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 19,
    rawRowText: "Engen Wemmershoek Conv 0000000000000za; 1391.42",
    transactionType: "expense",
    normalizedMerchant: "Engen Wemmershoek Conv",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1391.42,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_06_19_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-05-24T00:00:00Z",
  description: "Engen Wemmershoek Conv 0000000000000za",
  normalizedDescription: "Engen Wemmershoek Conv",
  amount: 1391.42,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Engen Wemmershoek Conv",
  merchant: $merchant_engen_wemmershoek_conv,
  category: $cat_fuel_transport,
  isTransfer: false,
  manualOverride: false,
  notes: "Fuel or transport spend."
});
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_06_19_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_19.id, "TransactionMerchant", $merchant_engen_wemmershoek_conv.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_19.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-05-27T00:00:00Z",
  description: "Panarottis Paarl 107690 Paarl           Za",
  normalizedDescription: "Panarottis Paarl",
  amount: 700,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 20,
    rawRowText: "Panarottis Paarl 107690 Paarl           Za; 700.00",
    transactionType: "expense",
    normalizedMerchant: "Panarottis Paarl",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 700,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Restaurant spend."
});
LET $tx_stmt_2025_06_19_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-05-27T00:00:00Z",
  description: "Panarottis Paarl 107690 Paarl           Za",
  normalizedDescription: "Panarottis Paarl",
  amount: 700,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Panarottis Paarl",
  merchant: $merchant_panarottis_paarl,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Restaurant spend."
});
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_06_19_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_20.id, "TransactionMerchant", $merchant_panarottis_paarl.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_20.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-05-27T00:00:00Z",
  description: "Yoco *Ashtons Coffee Cape Town               Za",
  normalizedDescription: "Ashtons Coffee",
  amount: 90,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 21,
    rawRowText: "Yoco *Ashtons Coffee Cape Town               Za; 90.00",
    transactionType: "expense",
    normalizedMerchant: "Ashtons Coffee",
    category: "Coffee / takeaway",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 90,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Coffee spend."
});
LET $tx_stmt_2025_06_19_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-05-27T00:00:00Z",
  description: "Yoco *Ashtons Coffee Cape Town               Za",
  normalizedDescription: "Ashtons Coffee",
  amount: 90,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Ashtons Coffee",
  merchant: $merchant_ashtons_coffee,
  category: $cat_coffee_takeaway,
  isTransfer: false,
  manualOverride: false,
  notes: "Coffee spend."
});
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_06_19_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_21.id, "TransactionMerchant", $merchant_ashtons_coffee.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_21.id, "TransactionCategory", $cat_coffee_takeaway.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-05-27T00:00:00Z",
  description: "Yoco *John Martin Ph Paarl                Za",
  normalizedDescription: "Yoco *John Martin Ph Paarl                Za",
  amount: 60,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 22,
    rawRowText: "Yoco *John Martin Ph Paarl                Za; 60.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *John Martin Ph Paarl                Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 60,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_06_19_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-05-27T00:00:00Z",
  description: "Yoco *John Martin Ph Paarl                Za",
  normalizedDescription: "Yoco *John Martin Ph Paarl                Za",
  amount: 60,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Yoco *John Martin Ph Paarl                Za",
  merchant: $merchant_yoco_john_martin_ph_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_06_19_row_22.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_22.id, "TransactionMerchant", $merchant_yoco_john_martin_ph_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_22.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_19_row_22 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-19-row-22",
  transaction: $tx_stmt_2025_06_19_row_22,
  status: "open",
  question: "What is the exact purpose of this Yoco *John Martin Ph Paarl                Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_yoco_john_martin_ph_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-06-19.import.md"
});
fn::createEdge($tx_stmt_2025_06_19_row_22.id, "TransactionClarificationTasks", $task_stmt_2025_06_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-05-27T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 23,
    rawRowText: "I Valr Pty Ltd         Cape Town        Za; 500.00",
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
LET $tx_stmt_2025_06_19_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-05-27T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town        Za",
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_06_19_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_23.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_23.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-05-27T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 800,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 24,
    rawRowText: "I Valr Pty Ltd         Cape Town        Za; 800.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 800,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2025_06_19_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-05-27T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 800,
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
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_06_19_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_24.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_24.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-05-30T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D",
  amount: 315,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 25,
    rawRowText: "Backs Restaurant And D Paarl              Za; 315.00",
    transactionType: "expense",
    normalizedMerchant: "Backs Restaurant And D",
    category: "Fast food / takeout",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 315,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fast-food takeout."
});
LET $tx_stmt_2025_06_19_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-05-30T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D",
  amount: 315,
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
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_06_19_row_25.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_25.id, "TransactionMerchant", $merchant_backs_restaurant_and_d.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_25.id, "TransactionCategory", $cat_fast_food_takeout.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-05-31T00:00:00Z",
  description: "Yoco *Vdv Barber         Paarl       Za",
  normalizedDescription: "VDV Barber",
  amount: 220,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 26,
    rawRowText: "Yoco *Vdv Barber         Paarl       Za; 220.00",
    transactionType: "expense",
    normalizedMerchant: "VDV Barber",
    category: "Haircut / grooming",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 220,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Haircut spend."
});
LET $tx_stmt_2025_06_19_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-05-31T00:00:00Z",
  description: "Yoco *Vdv Barber         Paarl       Za",
  normalizedDescription: "VDV Barber",
  amount: 220,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "VDV Barber",
  merchant: $merchant_vdv_barber,
  category: $cat_haircut_grooming,
  isTransfer: false,
  manualOverride: false,
  notes: "Haircut spend."
});
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_06_19_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_26.id, "TransactionMerchant", $merchant_vdv_barber.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_26.id, "TransactionCategory", $cat_haircut_grooming.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-05-31T00:00:00Z",
  description: "Yoco *Barcadia          Cape Town         Za",
  normalizedDescription: "Barcadia",
  amount: 35,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 27,
    rawRowText: "Yoco *Barcadia          Cape Town         Za; 35.00",
    transactionType: "expense",
    normalizedMerchant: "Barcadia",
    category: "Social / going out",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 35,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Social or going-out spend."
});
LET $tx_stmt_2025_06_19_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-05-31T00:00:00Z",
  description: "Yoco *Barcadia          Cape Town         Za",
  normalizedDescription: "Barcadia",
  amount: 35,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Barcadia",
  merchant: $merchant_barcadia,
  category: $cat_social_going_out,
  isTransfer: false,
  manualOverride: false,
  notes: "Social or going-out spend."
});
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_06_19_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_27.id, "TransactionMerchant", $merchant_barcadia.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_27.id, "TransactionCategory", $cat_social_going_out.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-06-01T00:00:00Z",
  description: "Bk 3 Arts Dt U         Plplumstead      Za",
  normalizedDescription: "Bk 3 Arts Dt U         Plplumstead      Za",
  amount: 205.8,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 28,
    rawRowText: "Bk 3 Arts Dt U         Plplumstead      Za; 205.80",
    transactionType: "expense",
    normalizedMerchant: "Bk 3 Arts Dt U         Plplumstead      Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 205.8,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_06_19_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-06-01T00:00:00Z",
  description: "Bk 3 Arts Dt U         Plplumstead      Za",
  normalizedDescription: "Bk 3 Arts Dt U         Plplumstead      Za",
  amount: 205.8,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Bk 3 Arts Dt U         Plplumstead      Za",
  merchant: $merchant_bk_3_arts_dt_u_plplumstead_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_06_19_row_28.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_28.id, "TransactionMerchant", $merchant_bk_3_arts_dt_u_plplumstead_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_28.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_19_row_28 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-19-row-28",
  transaction: $tx_stmt_2025_06_19_row_28,
  status: "open",
  question: "What is the exact purpose of this Bk 3 Arts Dt U         Plplumstead      Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_bk_3_arts_dt_u_plplumstead_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-06-19.import.md"
});
fn::createEdge($tx_stmt_2025_06_19_row_28.id, "TransactionClarificationTasks", $task_stmt_2025_06_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-06-01T00:00:00Z",
  description: "I Afrihost.Com 4        Cape Town         Za",
  normalizedDescription: "Afrihost",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 29,
    rawRowText: "I Afrihost.Com 4        Cape Town         Za; 419.00",
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
LET $tx_stmt_2025_06_19_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-06-01T00:00:00Z",
  description: "I Afrihost.Com 4        Cape Town         Za",
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
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_06_19_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_29.id, "TransactionMerchant", $merchant_afrihost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_29.id, "TransactionCategory", $cat_business_expenses_paid_personally_mobile_phone.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Spotifyza            Stockholm     Se",
  normalizedDescription: "Spotify",
  amount: 64.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 30,
    rawRowText: "Spotifyza            Stockholm     Se; 64.99",
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
LET $tx_stmt_2025_06_19_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Spotifyza            Stockholm     Se",
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
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_06_19_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_30.id, "TransactionMerchant", $merchant_spotify.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_30.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-06-02T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 523,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 31,
    rawRowText: "I Valr Pty Ltd         Cape Town        Za; 523.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 523,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2025_06_19_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-06-02T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 523,
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
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_06_19_row_31.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_31.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_31.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-06-02T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 1600,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 32,
    rawRowText: "I Valr Pty Ltd         Cape Town        Za; 1600.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1600,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2025_06_19_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-06-02T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 1600,
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
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_06_19_row_32.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_32.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_32.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-06-06T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D",
  amount: 315,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 33,
    rawRowText: "Backs Restaurant And D Paarl              Za; 315.00",
    transactionType: "expense",
    normalizedMerchant: "Backs Restaurant And D",
    category: "Fast food / takeout",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 315,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fast-food takeout."
});
LET $tx_stmt_2025_06_19_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-06-06T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D",
  amount: 315,
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
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_06_19_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_33.id, "TransactionMerchant", $merchant_backs_restaurant_and_d.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_33.id, "TransactionCategory", $cat_fast_food_takeout.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-06-08T00:00:00Z",
  description: "Wwh Drakenstein Sentru 0000000000000za",
  normalizedDescription: "Wwh Drakenstein Sentru",
  amount: 929.9,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 34,
    rawRowText: "Wwh Drakenstein Sentru 0000000000000za; 929.90",
    transactionType: "expense",
    normalizedMerchant: "Wwh Drakenstein Sentru",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 929.9,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_06_19_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-06-08T00:00:00Z",
  description: "Wwh Drakenstein Sentru 0000000000000za",
  normalizedDescription: "Wwh Drakenstein Sentru",
  amount: 929.9,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Wwh Drakenstein Sentru",
  merchant: $merchant_wwh_drakenstein_sentru,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_06_19_row_34.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_34.id, "TransactionMerchant", $merchant_wwh_drakenstein_sentru.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_34.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2025-06-08T00:00:00Z",
  description: "Bk 3 Arts Dt U         Plplumstead      Za",
  normalizedDescription: "Bk 3 Arts Dt U         Plplumstead      Za",
  amount: 251.1,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 35,
    rawRowText: "Bk 3 Arts Dt U         Plplumstead      Za; 251.10",
    transactionType: "expense",
    normalizedMerchant: "Bk 3 Arts Dt U         Plplumstead      Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 251.1,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_06_19_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-35",
  sourceRow: $row_row_35,
  postedAt: "2025-06-08T00:00:00Z",
  description: "Bk 3 Arts Dt U         Plplumstead      Za",
  normalizedDescription: "Bk 3 Arts Dt U         Plplumstead      Za",
  amount: 251.1,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Bk 3 Arts Dt U         Plplumstead      Za",
  merchant: $merchant_bk_3_arts_dt_u_plplumstead_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_06_19_row_35.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_35.id, "TransactionMerchant", $merchant_bk_3_arts_dt_u_plplumstead_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_35.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_19_row_35 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-19-row-35",
  transaction: $tx_stmt_2025_06_19_row_35,
  status: "open",
  question: "What is the exact purpose of this Bk 3 Arts Dt U         Plplumstead      Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_bk_3_arts_dt_u_plplumstead_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-06-19.import.md"
});
fn::createEdge($tx_stmt_2025_06_19_row_35.id, "TransactionClarificationTasks", $task_stmt_2025_06_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2025-06-08T00:00:00Z",
  description: "Bk 3 Arts Dt U         Plplumstead      Za",
  normalizedDescription: "Bk 3 Arts Dt U         Plplumstead      Za",
  amount: 34.9,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 36,
    rawRowText: "Bk 3 Arts Dt U         Plplumstead      Za; 34.90",
    transactionType: "expense",
    normalizedMerchant: "Bk 3 Arts Dt U         Plplumstead      Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 34.9,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_06_19_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-36",
  sourceRow: $row_row_36,
  postedAt: "2025-06-08T00:00:00Z",
  description: "Bk 3 Arts Dt U         Plplumstead      Za",
  normalizedDescription: "Bk 3 Arts Dt U         Plplumstead      Za",
  amount: 34.9,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Bk 3 Arts Dt U         Plplumstead      Za",
  merchant: $merchant_bk_3_arts_dt_u_plplumstead_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_06_19_row_36.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_36.id, "TransactionMerchant", $merchant_bk_3_arts_dt_u_plplumstead_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_36.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_19_row_36 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-19-row-36",
  transaction: $tx_stmt_2025_06_19_row_36,
  status: "open",
  question: "What is the exact purpose of this Bk 3 Arts Dt U         Plplumstead      Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_bk_3_arts_dt_u_plplumstead_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-06-19.import.md"
});
fn::createEdge($tx_stmt_2025_06_19_row_36.id, "TransactionClarificationTasks", $task_stmt_2025_06_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 37
LET $row_row_37 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 37,
  postedAt: "2025-06-08T00:00:00Z",
  description: "Pna Drakenstein         Paarl        Za",
  normalizedDescription: "Pna Drakenstein         Paarl        Za",
  amount: 570.97,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 37,
    rawRowText: "Pna Drakenstein         Paarl        Za; 570.97",
    transactionType: "expense",
    normalizedMerchant: "Pna Drakenstein         Paarl        Za",
    category: "Retail / books",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 570.97,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Retail, stationery, or book spend."
});
LET $tx_stmt_2025_06_19_row_37 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-37",
  sourceRow: $row_row_37,
  postedAt: "2025-06-08T00:00:00Z",
  description: "Pna Drakenstein         Paarl        Za",
  normalizedDescription: "Pna Drakenstein         Paarl        Za",
  amount: 570.97,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Pna Drakenstein         Paarl        Za",
  merchant: $merchant_pna_drakenstein_paarl_za,
  category: $cat_retail_books,
  isTransfer: false,
  manualOverride: false,
  notes: "Retail, stationery, or book spend."
});
fn::updateStatementRow($row_row_37.id, { transaction: $tx_stmt_2025_06_19_row_37.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_37.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_37.id, "TransactionMerchant", $merchant_pna_drakenstein_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_37.id, "TransactionCategory", $cat_retail_books.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 38
LET $row_row_38 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 38,
  postedAt: "2025-06-09T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 38,
    rawRowText: "I Valr Pty Ltd         Cape Town        Za; 500.00",
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
LET $tx_stmt_2025_06_19_row_38 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-38",
  sourceRow: $row_row_38,
  postedAt: "2025-06-09T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town        Za",
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
fn::updateStatementRow($row_row_38.id, { transaction: $tx_stmt_2025_06_19_row_38.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_38.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_38.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_38.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 39
LET $row_row_39 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 39,
  postedAt: "2025-06-13T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 68,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 39,
    rawRowText: "Yoco *Feedem Group T Franchhoek Za; 68.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Feedem Group T Franchhoek Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 68,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_06_19_row_39 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-39",
  sourceRow: $row_row_39,
  postedAt: "2025-06-13T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 68,
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
fn::updateStatementRow($row_row_39.id, { transaction: $tx_stmt_2025_06_19_row_39.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_39.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_39.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_39.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 40
LET $row_row_40 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 40,
  postedAt: "2025-06-13T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 34,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 40,
    rawRowText: "Yoco *Feedem Group T Franchhoek Za; 34.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Feedem Group T Franchhoek Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 34,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_06_19_row_40 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-40",
  sourceRow: $row_row_40,
  postedAt: "2025-06-13T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 34,
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
fn::updateStatementRow($row_row_40.id, { transaction: $tx_stmt_2025_06_19_row_40.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_40.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_40.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_40.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 41
LET $row_row_41 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 41,
  postedAt: "2025-06-13T00:00:00Z",
  description: "I Checkers Sixty60      Cape Town         Za",
  normalizedDescription: "Checkers Sixty60",
  amount: 30,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 41,
    rawRowText: "I Checkers Sixty60      Cape Town         Za; 30.00",
    transactionType: "expense",
    normalizedMerchant: "Checkers Sixty60",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 30,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery delivery spend."
});
LET $tx_stmt_2025_06_19_row_41 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-41",
  sourceRow: $row_row_41,
  postedAt: "2025-06-13T00:00:00Z",
  description: "I Checkers Sixty60      Cape Town         Za",
  normalizedDescription: "Checkers Sixty60",
  amount: 30,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Checkers Sixty60",
  merchant: $merchant_checkers_sixty60,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery delivery spend."
});
fn::updateStatementRow($row_row_41.id, { transaction: $tx_stmt_2025_06_19_row_41.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_41.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_41.id, "TransactionMerchant", $merchant_checkers_sixty60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_41.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 42
LET $row_row_42 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 42,
  postedAt: "2025-06-13T00:00:00Z",
  description: "I Checkers Sixty60      Cape Town         Za",
  normalizedDescription: "Checkers Sixty60",
  amount: 360.95,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 42,
    rawRowText: "I Checkers Sixty60      Cape Town         Za; 360.95",
    transactionType: "expense",
    normalizedMerchant: "Checkers Sixty60",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 360.95,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery delivery spend."
});
LET $tx_stmt_2025_06_19_row_42 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-42",
  sourceRow: $row_row_42,
  postedAt: "2025-06-13T00:00:00Z",
  description: "I Checkers Sixty60      Cape Town         Za",
  normalizedDescription: "Checkers Sixty60",
  amount: 360.95,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Checkers Sixty60",
  merchant: $merchant_checkers_sixty60,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery delivery spend."
});
fn::updateStatementRow($row_row_42.id, { transaction: $tx_stmt_2025_06_19_row_42.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_42.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_42.id, "TransactionMerchant", $merchant_checkers_sixty60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_42.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 43
LET $row_row_43 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 43,
  postedAt: "2025-06-13T00:00:00Z",
  description: "Trade Travel Chill Abu Dhabi Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1105.85,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 43,
    rawRowText: "Trade Travel Chill Abu Dhabi Ae; 1105.85",
    transactionType: "expense",
    normalizedMerchant: "Trade Travel Chill",
    category: "Business expenses paid personally / trading tools",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1105.85,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Recurring trading-indicator or trading-service spend."
});
LET $tx_stmt_2025_06_19_row_43 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-43",
  sourceRow: $row_row_43,
  postedAt: "2025-06-13T00:00:00Z",
  description: "Trade Travel Chill Abu Dhabi Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1105.85,
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
fn::updateStatementRow($row_row_43.id, { transaction: $tx_stmt_2025_06_19_row_43.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_43.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_43.id, "TransactionMerchant", $merchant_trade_travel_chill.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_43.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 44
LET $row_row_44 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 44,
  postedAt: "2025-06-13T00:00:00Z",
  description: "Engen Wemmershoek Conv 0000000000000za",
  normalizedDescription: "Engen Wemmershoek Conv",
  amount: 1183.82,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 44,
    rawRowText: "Engen Wemmershoek Conv 0000000000000za; 1183.82",
    transactionType: "expense",
    normalizedMerchant: "Engen Wemmershoek Conv",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1183.82,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_06_19_row_44 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-44",
  sourceRow: $row_row_44,
  postedAt: "2025-06-13T00:00:00Z",
  description: "Engen Wemmershoek Conv 0000000000000za",
  normalizedDescription: "Engen Wemmershoek Conv",
  amount: 1183.82,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Engen Wemmershoek Conv",
  merchant: $merchant_engen_wemmershoek_conv,
  category: $cat_fuel_transport,
  isTransfer: false,
  manualOverride: false,
  notes: "Fuel or transport spend."
});
fn::updateStatementRow($row_row_44.id, { transaction: $tx_stmt_2025_06_19_row_44.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_44.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_44.id, "TransactionMerchant", $merchant_engen_wemmershoek_conv.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_44.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 45
LET $row_row_45 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 45,
  postedAt: "2025-06-13T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D",
  amount: 255,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 45,
    rawRowText: "Backs Restaurant And D Paarl              Za; 255.00",
    transactionType: "expense",
    normalizedMerchant: "Backs Restaurant And D",
    category: "Fast food / takeout",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 255,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fast-food takeout."
});
LET $tx_stmt_2025_06_19_row_45 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-45",
  sourceRow: $row_row_45,
  postedAt: "2025-06-13T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D",
  amount: 255,
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
fn::updateStatementRow($row_row_45.id, { transaction: $tx_stmt_2025_06_19_row_45.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_45.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_45.id, "TransactionMerchant", $merchant_backs_restaurant_and_d.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_45.id, "TransactionCategory", $cat_fast_food_takeout.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 46
LET $row_row_46 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 46,
  postedAt: "2025-06-14T00:00:00Z",
  description: "Yoco *Plato Val De V Val De Vie Wiza",
  normalizedDescription: "Plato Val De Vie",
  amount: 47,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 46,
    rawRowText: "Yoco *Plato Val De V Val De Vie Wiza; 47.00",
    transactionType: "expense",
    normalizedMerchant: "Plato Val De Vie",
    category: "Coffee / takeaway",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 47,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Coffee spend."
});
LET $tx_stmt_2025_06_19_row_46 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-46",
  sourceRow: $row_row_46,
  postedAt: "2025-06-14T00:00:00Z",
  description: "Yoco *Plato Val De V Val De Vie Wiza",
  normalizedDescription: "Plato Val De Vie",
  amount: 47,
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
fn::updateStatementRow($row_row_46.id, { transaction: $tx_stmt_2025_06_19_row_46.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_46.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_46.id, "TransactionMerchant", $merchant_plato_val_de_vie.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_46.id, "TransactionCategory", $cat_coffee_takeaway.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 47
LET $row_row_47 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 47,
  postedAt: "2025-06-14T00:00:00Z",
  description: "Yoco *Huguenot Villa Cape Town               Za",
  normalizedDescription: "Huguenot Villa",
  amount: 82,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 47,
    rawRowText: "Yoco *Huguenot Villa Cape Town               Za; 82.00",
    transactionType: "expense",
    normalizedMerchant: "Huguenot Villa",
    category: "Social / wine bar",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 82,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Social spend at a beer or wine bar."
});
LET $tx_stmt_2025_06_19_row_47 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-47",
  sourceRow: $row_row_47,
  postedAt: "2025-06-14T00:00:00Z",
  description: "Yoco *Huguenot Villa Cape Town               Za",
  normalizedDescription: "Huguenot Villa",
  amount: 82,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Huguenot Villa",
  merchant: $merchant_huguenot_villa,
  category: $cat_social_wine_bar,
  isTransfer: false,
  manualOverride: false,
  notes: "Social spend at a beer or wine bar."
});
fn::updateStatementRow($row_row_47.id, { transaction: $tx_stmt_2025_06_19_row_47.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_47.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_47.id, "TransactionMerchant", $merchant_huguenot_villa.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_47.id, "TransactionCategory", $cat_social_wine_bar.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 48
LET $row_row_48 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 48,
  postedAt: "2025-06-14T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/June 2025.pdf",
    statementPeriodStart: "2025-05-20",
    statementPeriodEnd: "2025-06-19",
    rowNo: 48,
    rawRowText: "I Valr Pty Ltd         Cape Town        Za; 500.00",
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
LET $tx_stmt_2025_06_19_row_48 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-19-row-48",
  sourceRow: $row_row_48,
  postedAt: "2025-06-14T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town        Za",
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
fn::updateStatementRow($row_row_48.id, { transaction: $tx_stmt_2025_06_19_row_48.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_48.id, "StatementRowTransactions", $tx_stmt_2025_06_19_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_19_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_48.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_19_row_48.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 47,
  normalizedCount: 47,
  clarificationCount: 4,
  status: "matched",
  statementDate: "2025-06-19T00:00:00Z",
  notes: "Imported from 2025-06-19.import.md"
});

-- End of generated import
