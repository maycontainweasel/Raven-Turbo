-- Generated from docs/statements/personal/credit/2025-12-19.import.md
-- Source: docs/statements/personal/credit/December 2025.pdf

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
  openingBalance: 116217.25,
  active: true,
  notes: "Imported from December 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-12-19-nedbank-credit",
  sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-12-19T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-12-19.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_crypto_trading = fn::createCategory({
  space: $space,
  key: "crypto-trading",
  name: "Crypto / trading",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_fuel_transport = fn::createCategory({
  space: $space,
  key: "fuel-transport",
  name: "Fuel / transport",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_dining_lifestyle = fn::createCategory({
  space: $space,
  key: "dining-lifestyle",
  name: "Dining / lifestyle",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_business_expenses_paid_personally_trading_tools = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-trading-tools",
  name: "Business expenses paid personally / trading tools",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_groceries_household = fn::createCategory({
  space: $space,
  key: "groceries-household",
  name: "Groceries / household",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_business_expenses_paid_personally_ai_tools = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-ai-tools",
  name: "Business expenses paid personally / AI tools",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_business_expenses_paid_personally_hosting_software = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-hosting-software",
  name: "Business expenses paid personally / hosting / software",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_foreign_account_funding = fn::createCategory({
  space: $space,
  key: "foreign-account-funding",
  name: "Foreign account funding",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_retail_books = fn::createCategory({
  space: $space,
  key: "retail-books",
  name: "Retail / books",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_subscription_media = fn::createCategory({
  space: $space,
  key: "subscription-media",
  name: "Subscription / media",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_cash_advance = fn::createCategory({
  space: $space,
  key: "cash-advance",
  name: "Cash advance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_personal_care_pharmacy = fn::createCategory({
  space: $space,
  key: "personal-care-pharmacy",
  name: "Personal care / pharmacy",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_fees_declined_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-declined-payment-fee",
  name: "Declined Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_fees_electronic_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-electronic-payment-fee",
  name: "Electronic Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_fees_credit_facility_service_fee = fn::createCategory({
  space: $space,
  key: "fees-credit-facility-service-fee",
  name: "Credit Facility Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_fees_finance_charge = fn::createCategory({
  space: $space,
  key: "fees-finance-charge",
  name: "Finance Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});

-- Merchant records
LET $merchant_nedbank_current_account = fn::createMerchant({
  space: $space,
  key: "nedbank-current-account",
  name: "Nedbank Current Account",
  normalizedName: "Nedbank Current Account",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_valr = fn::createMerchant({
  space: $space,
  key: "valr",
  name: "VALR",
  normalizedName: "VALR",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_engen_paradyskloof = fn::createMerchant({
  space: $space,
  key: "engen-paradyskloof",
  name: "Engen Paradyskloof",
  normalizedName: "Engen Paradyskloof",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_yoco_feedem_group_t_franchhoek_za = fn::createMerchant({
  space: $space,
  key: "yoco-feedem-group-t-franchhoek-za",
  name: "Yoco *Feedem Group T Franchhoek Za",
  normalizedName: "Yoco *Feedem Group T Franchhoek Za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_yoco_bco_taste_kitc_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "yoco-bco-taste-kitc-stellenbosch-za",
  name: "Yoco *Bco Taste Kitc Stellenbosch Za",
  normalizedName: "Yoco *Bco Taste Kitc Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_tradingview = fn::createMerchant({
  space: $space,
  key: "tradingview",
  name: "TradingView",
  normalizedName: "TradingView",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_pick_n_pay_asap_kenilworth_za = fn::createMerchant({
  space: $space,
  key: "pick-n-pay-asap-kenilworth-za",
  name: "Pick N Pay Asap     Kenilworth Za",
  normalizedName: "Pick N Pay Asap     Kenilworth Za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_giovannis_eikendal = fn::createMerchant({
  space: $space,
  key: "giovannis-eikendal",
  name: "Giovannis Eikendal",
  normalizedName: "Giovannis Eikendal",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_openai = fn::createMerchant({
  space: $space,
  key: "openai",
  name: "OpenAI",
  normalizedName: "OpenAI",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_kwikspar_paradyskloof = fn::createMerchant({
  space: $space,
  key: "kwikspar-paradyskloof",
  name: "Kwikspar Paradyskloof",
  normalizedName: "Kwikspar Paradyskloof",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_ivecloud = fn::createMerchant({
  space: $space,
  key: "ivecloud",
  name: "Ivecloud",
  normalizedName: "Ivecloud",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_wwh_stellenbosch_sq = fn::createMerchant({
  space: $space,
  key: "wwh-stellenbosch-sq",
  name: "Wwh Stellenbosch Sq",
  normalizedName: "Wwh Stellenbosch Sq",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_wise = fn::createMerchant({
  space: $space,
  key: "wise",
  name: "Wise",
  normalizedName: "Wise",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_pna_stellenbosch_square_thermanus_za = fn::createMerchant({
  space: $space,
  key: "pna-stellenbosch-square-thermanus-za",
  name: "Pna Stellenbosch Square Thermanus      Za",
  normalizedName: "Pna Stellenbosch Square Thermanus      Za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_toy_planet_square_stel_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "toy-planet-square-stel-stellenbosch-za",
  name: "Toy Planet Square Stel Stellenbosch Za",
  normalizedName: "Toy Planet Square Stel Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_blaauwklippen_h_135297_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "blaauwklippen-h-135297-stellenbosch-za",
  name: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedName: "Blaauwklippen H 135297 Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_blaauwklippen_266384_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "blaauwklippen-266384-stellenbosch-za",
  name: "Blaauwklippen      266384 Stellenbosch Za",
  normalizedName: "Blaauwklippen      266384 Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_de_blaauw_kitchen_ne_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "de-blaauw-kitchen-ne-stellenbosch-za",
  name: "De Blaauw Kitchen - Ne Stellenbosch Za",
  normalizedName: "De Blaauw Kitchen - Ne Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_afrihost = fn::createMerchant({
  space: $space,
  key: "afrihost",
  name: "Afrihost",
  normalizedName: "Afrihost",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_spotify = fn::createMerchant({
  space: $space,
  key: "spotify",
  name: "Spotify",
  normalizedName: "Spotify",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_audible = fn::createMerchant({
  space: $space,
  key: "audible",
  name: "Audible",
  normalizedName: "Audible",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_showmax = fn::createMerchant({
  space: $space,
  key: "showmax",
  name: "Showmax",
  normalizedName: "Showmax",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_pna_stellenbosch_square_thermanus_za = fn::createMerchant({
  space: $space,
  key: "pna-stellenbosch-square-thermanus-za",
  name: "Pna Stellenbosch Square Thermanus        Za",
  normalizedName: "Pna Stellenbosch Square Thermanus        Za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_woolworths_jamestown_za = fn::createMerchant({
  space: $space,
  key: "woolworths-jamestown-za",
  name: "Woolworths             Jamestown    Za",
  normalizedName: "Woolworths             Jamestown    Za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_c_wordsworth_stellenboschwestern_cape_za = fn::createMerchant({
  space: $space,
  key: "c-wordsworth-stellenboschwestern-cape-za",
  name: "C*Wordsworth Stellenboschwestern Cape Za",
  normalizedName: "C*Wordsworth Stellenboschwestern Cape Za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_nedbank_internet_banking = fn::createMerchant({
  space: $space,
  key: "nedbank-internet-banking",
  name: "Nedbank Internet Banking",
  normalizedName: "Nedbank Internet Banking",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_spar_paarl_junction_ex_paarl_za = fn::createMerchant({
  space: $space,
  key: "spar-paarl-junction-ex-paarl-za",
  name: "Spar Paarl Junction Ex Paarl        Za",
  normalizedName: "Spar Paarl Junction Ex Paarl        Za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_mcd_paarl_0078 = fn::createMerchant({
  space: $space,
  key: "mcd-paarl-0078",
  name: "Mcd Paarl (0078)",
  normalizedName: "Mcd Paarl (0078)",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_shell_paarl_junction = fn::createMerchant({
  space: $space,
  key: "shell-paarl-junction",
  name: "Shell Paarl Junction",
  normalizedName: "Shell Paarl Junction",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_trade_travel_chill = fn::createMerchant({
  space: $space,
  key: "trade-travel-chill",
  name: "Trade Travel Chill",
  normalizedName: "Trade Travel Chill",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_bossa_stellenbosch_0000000000000za = fn::createMerchant({
  space: $space,
  key: "bossa-stellenbosch-0000000000000za",
  name: "Bossa Stellenbosch      0000000000000za",
  normalizedName: "Bossa Stellenbosch      0000000000000za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_adenes_flowers_stellenbo_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "adenes-flowers-stellenbo-stellenbosch-za",
  name: "Adenes Flowers Stellenbo Stellenbosch Za",
  normalizedName: "Adenes Flowers Stellenbo Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_woolworths_jamestown_za = fn::createMerchant({
  space: $space,
  key: "woolworths-jamestown-za",
  name: "Woolworths             Jamestown     Za",
  normalizedName: "Woolworths             Jamestown     Za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_clipper_club_0000000000000za = fn::createMerchant({
  space: $space,
  key: "clipper-club-0000000000000za",
  name: "Clipper Club          0000000000000za",
  normalizedName: "Clipper Club          0000000000000za",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});
LET $merchant_clicks_stellenbosch_square = fn::createMerchant({
  space: $space,
  key: "clicks-stellenbosch-square",
  name: "Clicks Stellenbosch Square",
  normalizedName: "Clicks Stellenbosch Square",
  active: true,
  notes: "Imported from 2025-12-19.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-11-22T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 19000,
  balance: 19000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 1,
    rawRowText: "Internet Banking Transferselby     Za; 19000.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 19000,
    bankChargeZar: null,
    balanceZar: 19000
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_12_19_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-11-22T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 19000,
  balance: 19000,
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_12_19_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_01.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_01.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-11-26T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2000,
  balance: 2000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 2,
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
LET $tx_stmt_2025_12_19_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-11-26T00:00:00Z",
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_12_19_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_02.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_02.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-11-28T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 4750,
  balance: 4750,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 3,
    rawRowText: "Internet Banking Transferselby     Za; 4750.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 4750,
    bankChargeZar: null,
    balanceZar: 4750
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_12_19_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-11-28T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 4750,
  balance: 4750,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_12_19_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_03.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_03.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-12-06T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 10900,
  balance: 10900,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 4,
    rawRowText: "Internet Banking Transferselby     Za; 10900.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 10900,
    bankChargeZar: null,
    balanceZar: 10900
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_12_19_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-12-06T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 10900,
  balance: 10900,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_12_19_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_04.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_04.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-12-08T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 19040,
  balance: 19040,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 5,
    rawRowText: "Internet Banking Transferselby     Za; 19040.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 19040,
    bankChargeZar: null,
    balanceZar: 19040
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_12_19_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-12-08T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 19040,
  balance: 19040,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_12_19_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_05.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_05.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-12-09T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 10000,
  balance: 10000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 6,
    rawRowText: "Internet Banking Transferselby     Za; 10000.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 10000,
    bankChargeZar: null,
    balanceZar: 10000
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_12_19_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-12-09T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 10000,
  balance: 10000,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_12_19_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_06.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_06.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-12-12T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 6390,
  balance: 6390,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 7,
    rawRowText: "Internet Banking Transferselby     Za; 6390.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6390,
    bankChargeZar: null,
    balanceZar: 6390
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_12_19_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-12-12T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 6390,
  balance: 6390,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_12_19_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_07.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_07.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-12-15T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 11160,
  balance: 11160,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 8,
    rawRowText: "Internet Banking Transferselby     Za; 11160.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 11160,
    bankChargeZar: null,
    balanceZar: 11160
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_12_19_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-12-15T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 11160,
  balance: 11160,
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_12_19_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_08.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_08.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-12-06T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
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
LET $tx_stmt_2025_12_19_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-12-06T00:00:00Z",
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_12_19_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_09.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_09.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-12-06T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
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
LET $tx_stmt_2025_12_19_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-12-06T00:00:00Z",
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_12_19_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_10.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_10.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-12-09T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
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
LET $tx_stmt_2025_12_19_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-12-09T00:00:00Z",
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_12_19_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_11.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_11.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-12-09T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 12,
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
LET $tx_stmt_2025_12_19_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-12-09T00:00:00Z",
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_12_19_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_12.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_12.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-12-13T00:00:00Z",
  description: "Maintenance Fee",
  normalizedDescription: "Maintenance Fee",
  amount: 38.26,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 13,
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
LET $tx_stmt_2025_12_19_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-12-13T00:00:00Z",
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_12_19_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_13.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_13.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-12-15T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
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
LET $tx_stmt_2025_12_19_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-12-15T00:00:00Z",
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_12_19_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_14.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_14.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-12-15T00:00:00Z",
  description: "Credit Facility Service Fee",
  normalizedDescription: "Credit Facility Service Fee",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 15,
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
LET $tx_stmt_2025_12_19_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-12-15T00:00:00Z",
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_12_19_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_15.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_15.id, "TransactionCategory", $cat_fees_credit_facility_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-12-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 2112.84,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 16,
    rawRowText: "Finance Charge; 2112.84",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "finance charge",
    clarificationStatus: "clarified",
    amountZar: 2112.84,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Finance charge on the outstanding balance."
});
LET $tx_stmt_2025_12_19_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-12-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 2112.84,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_12_19_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_16.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_16.id, "TransactionCategory", $cat_fees_finance_charge.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-12-15T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 15.24,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
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
LET $tx_stmt_2025_12_19_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-12-15T00:00:00Z",
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_12_19_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_17.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_17.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-11-19T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 18,
    rawRowText: "I Valr Pty Ltd        Cape Town   Za; 2000.00",
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
LET $tx_stmt_2025_12_19_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-11-19T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_12_19_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_18.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_18.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-11-20T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 71,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 19,
    rawRowText: "Engen Paradyskloof      0000000000000za; 71.00",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 71,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_12_19_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-11-20T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 71,
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
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_12_19_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_19.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_19.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-11-20T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 20,
    rawRowText: "I Valr Pty Ltd        Cape Town   Za; 2000.00",
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
LET $tx_stmt_2025_12_19_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-11-20T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
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
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_12_19_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_20.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_20.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-11-21T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 94,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 21,
    rawRowText: "Yoco *Feedem Group T Franchhoek Za; 94.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Feedem Group T Franchhoek Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 94,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_12_19_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-11-21T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 94,
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
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_12_19_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_21.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_21.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-11-21T00:00:00Z",
  description: "Yoco *Bco Taste Kitc Stellenbosch Za",
  normalizedDescription: "Yoco *Bco Taste Kitc Stellenbosch Za",
  amount: 260,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 22,
    rawRowText: "Yoco *Bco Taste Kitc Stellenbosch Za; 260.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Bco Taste Kitc Stellenbosch Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 260,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_12_19_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-11-21T00:00:00Z",
  description: "Yoco *Bco Taste Kitc Stellenbosch Za",
  normalizedDescription: "Yoco *Bco Taste Kitc Stellenbosch Za",
  amount: 260,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Yoco *Bco Taste Kitc Stellenbosch Za",
  merchant: $merchant_yoco_bco_taste_kitc_stellenbosch_za,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_12_19_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_22.id, "TransactionMerchant", $merchant_yoco_bco_taste_kitc_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_22.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-11-21T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 23,
    rawRowText: "I Valr Pty Ltd        Cape Town   Za; 2000.00",
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
LET $tx_stmt_2025_12_19_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-11-21T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_12_19_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_23.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_23.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-11-21T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 24,
    rawRowText: "I Valr Pty Ltd        Cape Town   Za; 2000.00",
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
LET $tx_stmt_2025_12_19_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-11-21T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
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
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_12_19_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_24.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_24.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-11-21T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 25,
    rawRowText: "I Valr Pty Ltd        Cape Town   Za; 2000.00",
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
LET $tx_stmt_2025_12_19_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-11-21T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
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
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_12_19_row_25.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_25.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_25.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-11-22T00:00:00Z",
  description: "Tradingviewv*Product Westerville Us",
  normalizedDescription: "TradingView",
  amount: 4492.07,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 26,
    rawRowText: "Tradingviewv*Product Westerville Us; 4492.07",
    transactionType: "expense",
    normalizedMerchant: "TradingView",
    category: "Business expenses paid personally / trading tools",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 4492.07,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "TradingView subscription or tooling spend."
});
LET $tx_stmt_2025_12_19_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-11-22T00:00:00Z",
  description: "Tradingviewv*Product Westerville Us",
  normalizedDescription: "TradingView",
  amount: 4492.07,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "TradingView",
  merchant: $merchant_tradingview,
  category: $cat_business_expenses_paid_personally_trading_tools,
  isTransfer: false,
  manualOverride: false,
  notes: "TradingView subscription or tooling spend."
});
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_12_19_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_26.id, "TransactionMerchant", $merchant_tradingview.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_26.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-11-22T00:00:00Z",
  description: "Pick N Pay Asap     Kenilworth Za",
  normalizedDescription: "Pick N Pay Asap     Kenilworth Za",
  amount: 724.94,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 27,
    rawRowText: "Pick N Pay Asap     Kenilworth Za; 724.94",
    transactionType: "expense",
    normalizedMerchant: "Pick N Pay Asap     Kenilworth Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 724.94,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_12_19_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-11-22T00:00:00Z",
  description: "Pick N Pay Asap     Kenilworth Za",
  normalizedDescription: "Pick N Pay Asap     Kenilworth Za",
  amount: 724.94,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Pick N Pay Asap     Kenilworth Za",
  merchant: $merchant_pick_n_pay_asap_kenilworth_za,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_12_19_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_27.id, "TransactionMerchant", $merchant_pick_n_pay_asap_kenilworth_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_27.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-11-22T00:00:00Z",
  description: "Giovannis Eikendal      0000000000000za",
  normalizedDescription: "Giovannis Eikendal",
  amount: 397,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 28,
    rawRowText: "Giovannis Eikendal      0000000000000za; 397.00",
    transactionType: "expense",
    normalizedMerchant: "Giovannis Eikendal",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 397,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_12_19_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-11-22T00:00:00Z",
  description: "Giovannis Eikendal      0000000000000za",
  normalizedDescription: "Giovannis Eikendal",
  amount: 397,
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
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_12_19_row_28.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_28.id, "TransactionMerchant", $merchant_giovannis_eikendal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_28.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-11-23T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 29,
    rawRowText: "I Valr Pty Ltd        Cape Town   Za; 2000.00",
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
LET $tx_stmt_2025_12_19_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-11-23T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
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
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_12_19_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_29.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_29.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-11-24T00:00:00Z",
  description: "Openai *Chatgpt Subscr Openai.Com Us",
  normalizedDescription: "OpenAI",
  amount: 4171.68,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 30,
    rawRowText: "Openai *Chatgpt Subscr Openai.Com Us; 4171.68",
    transactionType: "expense",
    normalizedMerchant: "OpenAI",
    category: "Business expenses paid personally / AI tools",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 4171.68,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "AI tooling paid from the personal credit card."
});
LET $tx_stmt_2025_12_19_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-11-24T00:00:00Z",
  description: "Openai *Chatgpt Subscr Openai.Com Us",
  normalizedDescription: "OpenAI",
  amount: 4171.68,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "OpenAI",
  merchant: $merchant_openai,
  category: $cat_business_expenses_paid_personally_ai_tools,
  isTransfer: false,
  manualOverride: false,
  notes: "AI tooling paid from the personal credit card."
});
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_12_19_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_30.id, "TransactionMerchant", $merchant_openai.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_30.id, "TransactionCategory", $cat_business_expenses_paid_personally_ai_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-11-24T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 31,
    rawRowText: "I Valr Pty Ltd     Cape Town Za; 500.00",
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
LET $tx_stmt_2025_12_19_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-11-24T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town Za",
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
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_12_19_row_31.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_31.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_31.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-11-24T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 32,
    rawRowText: "I Valr Pty Ltd        Cape Town   Za; 500.00",
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
LET $tx_stmt_2025_12_19_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-11-24T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
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
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_12_19_row_32.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_32.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_32.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-11-24T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 33,
    rawRowText: "I Valr Pty Ltd        Cape Town   Za; 1000.00",
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
LET $tx_stmt_2025_12_19_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-11-24T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
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
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_12_19_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_33.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_33.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-11-25T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 34,
    rawRowText: "I Valr Pty Ltd        Cape Town   Za; 500.00",
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
LET $tx_stmt_2025_12_19_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-11-25T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
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
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_12_19_row_34.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_34.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_34.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2025-11-25T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 35,
    rawRowText: "I Valr Pty Ltd        Cape Town   Za; 2000.00",
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
LET $tx_stmt_2025_12_19_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-35",
  sourceRow: $row_row_35,
  postedAt: "2025-11-25T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
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
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_12_19_row_35.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_35.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_35.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2025-11-26T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 36,
    rawRowText: "I Valr Pty Ltd        Cape Town   Za; 2000.00",
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
LET $tx_stmt_2025_12_19_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-36",
  sourceRow: $row_row_36,
  postedAt: "2025-11-26T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
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
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_12_19_row_36.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_36.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_36.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 37
LET $row_row_37 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 37,
  postedAt: "2025-11-28T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 28,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 37,
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
LET $tx_stmt_2025_12_19_row_37 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-37",
  sourceRow: $row_row_37,
  postedAt: "2025-11-28T00:00:00Z",
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
fn::updateStatementRow($row_row_37.id, { transaction: $tx_stmt_2025_12_19_row_37.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_37.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_37.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_37.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 38
LET $row_row_38 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 38,
  postedAt: "2025-11-28T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 105,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 38,
    rawRowText: "Yoco *Feedem Group T Franchhoek Za; 105.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Feedem Group T Franchhoek Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 105,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_12_19_row_38 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-38",
  sourceRow: $row_row_38,
  postedAt: "2025-11-28T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 105,
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
fn::updateStatementRow($row_row_38.id, { transaction: $tx_stmt_2025_12_19_row_38.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_38.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_38.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_38.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 39
LET $row_row_39 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 39,
  postedAt: "2025-11-28T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 351.19,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 39,
    rawRowText: "Engen Paradyskloof      0000000000000za; 351.19",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 351.19,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_12_19_row_39 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-39",
  sourceRow: $row_row_39,
  postedAt: "2025-11-28T00:00:00Z",
  description: "Engen Paradyskloof      0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 351.19,
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
fn::updateStatementRow($row_row_39.id, { transaction: $tx_stmt_2025_12_19_row_39.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_39.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_39.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_39.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 40
LET $row_row_40 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 40,
  postedAt: "2025-11-28T00:00:00Z",
  description: "Kwikspar Paradyskloof    0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 329.14,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 40,
    rawRowText: "Kwikspar Paradyskloof    0000000000000za; 329.14",
    transactionType: "expense",
    normalizedMerchant: "Kwikspar Paradyskloof",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 329.14,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_12_19_row_40 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-40",
  sourceRow: $row_row_40,
  postedAt: "2025-11-28T00:00:00Z",
  description: "Kwikspar Paradyskloof    0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 329.14,
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
fn::updateStatementRow($row_row_40.id, { transaction: $tx_stmt_2025_12_19_row_40.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_40.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_40.id, "TransactionMerchant", $merchant_kwikspar_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_40.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 41
LET $row_row_41 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 41,
  postedAt: "2025-11-28T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 41,
    rawRowText: "I Valr Pty Ltd        Cape Town   Za; 1000.00",
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
LET $tx_stmt_2025_12_19_row_41 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-41",
  sourceRow: $row_row_41,
  postedAt: "2025-11-28T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
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
fn::updateStatementRow($row_row_41.id, { transaction: $tx_stmt_2025_12_19_row_41.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_41.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_41.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_41.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 42
LET $row_row_42 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 42,
  postedAt: "2025-11-28T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 42,
    rawRowText: "I Valr Pty Ltd        Cape Town   Za; 2000.00",
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
LET $tx_stmt_2025_12_19_row_42 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-42",
  sourceRow: $row_row_42,
  postedAt: "2025-11-28T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
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
fn::updateStatementRow($row_row_42.id, { transaction: $tx_stmt_2025_12_19_row_42.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_42.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_42.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_42.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 43
LET $row_row_43 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 43,
  postedAt: "2025-11-29T00:00:00Z",
  description: "Payfast*Ivecloud Pty L Hoedspruit Za",
  normalizedDescription: "Ivecloud",
  amount: 292.78,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 43,
    rawRowText: "Payfast*Ivecloud Pty L Hoedspruit Za; 292.78",
    transactionType: "expense",
    normalizedMerchant: "Ivecloud",
    category: "Business expenses paid personally / hosting / software",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 292.78,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Likely software or hosting-related spend; keep open for confirmation."
});
LET $tx_stmt_2025_12_19_row_43 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-43",
  sourceRow: $row_row_43,
  postedAt: "2025-11-29T00:00:00Z",
  description: "Payfast*Ivecloud Pty L Hoedspruit Za",
  normalizedDescription: "Ivecloud",
  amount: 292.78,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Ivecloud",
  merchant: $merchant_ivecloud,
  category: $cat_business_expenses_paid_personally_hosting_software,
  isTransfer: false,
  manualOverride: false,
  notes: "Likely software or hosting-related spend; keep open for confirmation."
});
fn::updateStatementRow($row_row_43.id, { transaction: $tx_stmt_2025_12_19_row_43.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_43.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_43.id, "TransactionMerchant", $merchant_ivecloud.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_43.id, "TransactionCategory", $cat_business_expenses_paid_personally_hosting_software.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_19_row_43 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-19-row-43",
  transaction: $tx_stmt_2025_12_19_row_43,
  status: "open",
  question: "What is the exact purpose of this Ivecloud transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_ivecloud,
  suggestedCategory: $cat_business_expenses_paid_personally_hosting_software,
  confidence: 0.25,
  notes: "Imported from 2025-12-19.import.md"
});
fn::createEdge($tx_stmt_2025_12_19_row_43.id, "TransactionClarificationTasks", $task_stmt_2025_12_19_row_43.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 44
LET $row_row_44 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 44,
  postedAt: "2025-11-29T00:00:00Z",
  description: "Wwh Stellenbosch Sq     0000000000000za",
  normalizedDescription: "Wwh Stellenbosch Sq",
  amount: 399.95,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 44,
    rawRowText: "Wwh Stellenbosch Sq     0000000000000za; 399.95",
    transactionType: "expense",
    normalizedMerchant: "Wwh Stellenbosch Sq",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 399.95,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_12_19_row_44 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-44",
  sourceRow: $row_row_44,
  postedAt: "2025-11-29T00:00:00Z",
  description: "Wwh Stellenbosch Sq     0000000000000za",
  normalizedDescription: "Wwh Stellenbosch Sq",
  amount: 399.95,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Wwh Stellenbosch Sq",
  merchant: $merchant_wwh_stellenbosch_sq,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_44.id, { transaction: $tx_stmt_2025_12_19_row_44.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_44.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_44.id, "TransactionMerchant", $merchant_wwh_stellenbosch_sq.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_44.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 45
LET $row_row_45 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 45,
  postedAt: "2025-11-29T00:00:00Z",
  description: "Wise              London     Gb",
  normalizedDescription: "Wise",
  amount: 551.1,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 45,
    rawRowText: "Wise              London     Gb; 551.10",
    transactionType: "transfer",
    normalizedMerchant: "Wise",
    category: "Foreign account funding",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 551.1,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Transfer via Wise to fund the UK account."
});
LET $tx_stmt_2025_12_19_row_45 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-45",
  sourceRow: $row_row_45,
  postedAt: "2025-11-29T00:00:00Z",
  description: "Wise              London     Gb",
  normalizedDescription: "Wise",
  amount: 551.1,
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
fn::updateStatementRow($row_row_45.id, { transaction: $tx_stmt_2025_12_19_row_45.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_45.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_45.id, "TransactionMerchant", $merchant_wise.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_45.id, "TransactionCategory", $cat_foreign_account_funding.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 46
LET $row_row_46 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 46,
  postedAt: "2025-11-29T00:00:00Z",
  description: "Pna Stellenbosch Square Thermanus      Za",
  normalizedDescription: "Pna Stellenbosch Square Thermanus      Za",
  amount: 548.2,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 46,
    rawRowText: "Pna Stellenbosch Square Thermanus      Za; 548.20",
    transactionType: "expense",
    normalizedMerchant: "Pna Stellenbosch Square Thermanus      Za",
    category: "Retail / books",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 548.2,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Retail, stationery, or book spend."
});
LET $tx_stmt_2025_12_19_row_46 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-46",
  sourceRow: $row_row_46,
  postedAt: "2025-11-29T00:00:00Z",
  description: "Pna Stellenbosch Square Thermanus      Za",
  normalizedDescription: "Pna Stellenbosch Square Thermanus      Za",
  amount: 548.2,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Pna Stellenbosch Square Thermanus      Za",
  merchant: $merchant_pna_stellenbosch_square_thermanus_za,
  category: $cat_retail_books,
  isTransfer: false,
  manualOverride: false,
  notes: "Retail, stationery, or book spend."
});
fn::updateStatementRow($row_row_46.id, { transaction: $tx_stmt_2025_12_19_row_46.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_46.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_46.id, "TransactionMerchant", $merchant_pna_stellenbosch_square_thermanus_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_46.id, "TransactionCategory", $cat_retail_books.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 47
LET $row_row_47 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 47,
  postedAt: "2025-11-29T00:00:00Z",
  description: "Toy Planet Square Stel Stellenbosch Za",
  normalizedDescription: "Toy Planet Square Stel Stellenbosch Za",
  amount: 929.85,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 47,
    rawRowText: "Toy Planet Square Stel Stellenbosch Za; 929.85",
    transactionType: "expense",
    normalizedMerchant: "Toy Planet Square Stel Stellenbosch Za",
    category: "Retail / books",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 929.85,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Retail, stationery, or book spend."
});
LET $tx_stmt_2025_12_19_row_47 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-47",
  sourceRow: $row_row_47,
  postedAt: "2025-11-29T00:00:00Z",
  description: "Toy Planet Square Stel Stellenbosch Za",
  normalizedDescription: "Toy Planet Square Stel Stellenbosch Za",
  amount: 929.85,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Toy Planet Square Stel Stellenbosch Za",
  merchant: $merchant_toy_planet_square_stel_stellenbosch_za,
  category: $cat_retail_books,
  isTransfer: false,
  manualOverride: false,
  notes: "Retail, stationery, or book spend."
});
fn::updateStatementRow($row_row_47.id, { transaction: $tx_stmt_2025_12_19_row_47.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_47.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_47.id, "TransactionMerchant", $merchant_toy_planet_square_stel_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_47.id, "TransactionCategory", $cat_retail_books.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 48
LET $row_row_48 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 48,
  postedAt: "2025-11-29T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 48,
    rawRowText: "I Valr Pty Ltd        Cape Town   Za; 500.00",
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
LET $tx_stmt_2025_12_19_row_48 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-48",
  sourceRow: $row_row_48,
  postedAt: "2025-11-29T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town   Za",
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
fn::updateStatementRow($row_row_48.id, { transaction: $tx_stmt_2025_12_19_row_48.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_48.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_48.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_48.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 49
LET $row_row_49 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 49,
  postedAt: "2025-11-30T00:00:00Z",
  description: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen H 135297 Stellenbosch Za",
  amount: 40,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 49,
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
LET $tx_stmt_2025_12_19_row_49 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-49",
  sourceRow: $row_row_49,
  postedAt: "2025-11-30T00:00:00Z",
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
fn::updateStatementRow($row_row_49.id, { transaction: $tx_stmt_2025_12_19_row_49.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_49.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_49.id, "TransactionMerchant", $merchant_blaauwklippen_h_135297_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_49.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 50
LET $row_row_50 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 50,
  postedAt: "2025-11-30T00:00:00Z",
  description: "Blaauwklippen      266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen      266384 Stellenbosch Za",
  amount: 115,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 50,
    rawRowText: "Blaauwklippen      266384 Stellenbosch Za; 115.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen      266384 Stellenbosch Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 115,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_12_19_row_50 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-50",
  sourceRow: $row_row_50,
  postedAt: "2025-11-30T00:00:00Z",
  description: "Blaauwklippen      266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen      266384 Stellenbosch Za",
  amount: 115,
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
fn::updateStatementRow($row_row_50.id, { transaction: $tx_stmt_2025_12_19_row_50.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_50.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_50.id, "TransactionMerchant", $merchant_blaauwklippen_266384_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_50.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 51
LET $row_row_51 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 51,
  postedAt: "2025-11-30T00:00:00Z",
  description: "Blaauwklippen      266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen      266384 Stellenbosch Za",
  amount: 80,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 51,
    rawRowText: "Blaauwklippen      266384 Stellenbosch Za; 80.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen      266384 Stellenbosch Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 80,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_12_19_row_51 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-51",
  sourceRow: $row_row_51,
  postedAt: "2025-11-30T00:00:00Z",
  description: "Blaauwklippen      266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen      266384 Stellenbosch Za",
  amount: 80,
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
fn::updateStatementRow($row_row_51.id, { transaction: $tx_stmt_2025_12_19_row_51.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_51.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_51.id, "TransactionMerchant", $merchant_blaauwklippen_266384_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_51.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 52
LET $row_row_52 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 52,
  postedAt: "2025-11-30T00:00:00Z",
  description: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen H 135297 Stellenbosch Za",
  amount: 80,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 52,
    rawRowText: "Blaauwklippen H 135297 Stellenbosch Za; 80.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen H 135297 Stellenbosch Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 80,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_12_19_row_52 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-52",
  sourceRow: $row_row_52,
  postedAt: "2025-11-30T00:00:00Z",
  description: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen H 135297 Stellenbosch Za",
  amount: 80,
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
fn::updateStatementRow($row_row_52.id, { transaction: $tx_stmt_2025_12_19_row_52.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_52.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_52.id, "TransactionMerchant", $merchant_blaauwklippen_h_135297_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_52.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 53
LET $row_row_53 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 53,
  postedAt: "2025-11-30T00:00:00Z",
  description: "De Blaauw Kitchen - Ne Stellenbosch Za",
  normalizedDescription: "De Blaauw Kitchen - Ne Stellenbosch Za",
  amount: 155,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 53,
    rawRowText: "De Blaauw Kitchen - Ne Stellenbosch Za; 155.00",
    transactionType: "expense",
    normalizedMerchant: "De Blaauw Kitchen - Ne Stellenbosch Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 155,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_12_19_row_53 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-53",
  sourceRow: $row_row_53,
  postedAt: "2025-11-30T00:00:00Z",
  description: "De Blaauw Kitchen - Ne Stellenbosch Za",
  normalizedDescription: "De Blaauw Kitchen - Ne Stellenbosch Za",
  amount: 155,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "De Blaauw Kitchen - Ne Stellenbosch Za",
  merchant: $merchant_de_blaauw_kitchen_ne_stellenbosch_za,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_53.id, { transaction: $tx_stmt_2025_12_19_row_53.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_53.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_53.id, "TransactionMerchant", $merchant_de_blaauw_kitchen_ne_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_53.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 54
LET $row_row_54 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 54,
  postedAt: "2025-12-01T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 42,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 54,
    rawRowText: "Yoco *Feedem Group T Franchhoek Za; 42.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Feedem Group T Franchhoek Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 42,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_12_19_row_54 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-54",
  sourceRow: $row_row_54,
  postedAt: "2025-12-01T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 42,
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
fn::updateStatementRow($row_row_54.id, { transaction: $tx_stmt_2025_12_19_row_54.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_54.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_54.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_54.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 55
LET $row_row_55 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 55,
  postedAt: "2025-12-01T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 39,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 55,
    rawRowText: "Yoco *Feedem Group T Franchhoek Za; 39.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Feedem Group T Franchhoek Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 39,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_12_19_row_55 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-55",
  sourceRow: $row_row_55,
  postedAt: "2025-12-01T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 39,
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
fn::updateStatementRow($row_row_55.id, { transaction: $tx_stmt_2025_12_19_row_55.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_55.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_55.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_55.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 56
LET $row_row_56 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 56,
  postedAt: "2025-12-01T00:00:00Z",
  description: "I Afrihost.Com 2        Cape Town    Za",
  normalizedDescription: "Afrihost",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 56,
    rawRowText: "I Afrihost.Com 2        Cape Town    Za; 419.00",
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
LET $tx_stmt_2025_12_19_row_56 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-56",
  sourceRow: $row_row_56,
  postedAt: "2025-12-01T00:00:00Z",
  description: "I Afrihost.Com 2        Cape Town    Za",
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
fn::updateStatementRow($row_row_56.id, { transaction: $tx_stmt_2025_12_19_row_56.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_56.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_56.id, "TransactionMerchant", $merchant_afrihost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_56.id, "TransactionCategory", $cat_business_expenses_paid_personally_hosting_software.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 57
LET $row_row_57 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 57,
  postedAt: "2025-12-02T00:00:00Z",
  description: "Spotifyza         Stockholm Se",
  normalizedDescription: "Spotify",
  amount: 69.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 57,
    rawRowText: "Spotifyza         Stockholm Se; 69.99",
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
LET $tx_stmt_2025_12_19_row_57 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-57",
  sourceRow: $row_row_57,
  postedAt: "2025-12-02T00:00:00Z",
  description: "Spotifyza         Stockholm Se",
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
fn::updateStatementRow($row_row_57.id, { transaction: $tx_stmt_2025_12_19_row_57.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_57.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_57.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_57.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_57.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_57.id, "TransactionMerchant", $merchant_spotify.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_57.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 58
LET $row_row_58 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 58,
  postedAt: "2025-12-05T00:00:00Z",
  description: "Audible*Bi5q51gy1     Amzn.Com/Billus",
  normalizedDescription: "Audible",
  amount: 17.55,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 58,
    rawRowText: "Audible*Bi5q51gy1     Amzn.Com/Billus; 17.55",
    transactionType: "expense",
    normalizedMerchant: "Audible",
    category: "Subscription / media",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 17.55,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Audible subscription or media spend."
});
LET $tx_stmt_2025_12_19_row_58 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-58",
  sourceRow: $row_row_58,
  postedAt: "2025-12-05T00:00:00Z",
  description: "Audible*Bi5q51gy1     Amzn.Com/Billus",
  normalizedDescription: "Audible",
  amount: 17.55,
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
fn::updateStatementRow($row_row_58.id, { transaction: $tx_stmt_2025_12_19_row_58.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_58.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_58.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_58.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_58.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_58.id, "TransactionMerchant", $merchant_audible.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_58.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 59
LET $row_row_59 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 59,
  postedAt: "2025-12-06T00:00:00Z",
  description: "Engen Paradyskloof       0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 348.28,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 59,
    rawRowText: "Engen Paradyskloof       0000000000000za; 348.28",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 348.28,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_12_19_row_59 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-59",
  sourceRow: $row_row_59,
  postedAt: "2025-12-06T00:00:00Z",
  description: "Engen Paradyskloof       0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 348.28,
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
fn::updateStatementRow($row_row_59.id, { transaction: $tx_stmt_2025_12_19_row_59.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_59.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_59.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_59.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_59.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_59.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_59.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 60
LET $row_row_60 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 60,
  postedAt: "2025-12-06T00:00:00Z",
  description: "Pp *Showmax             Randburg     Za",
  normalizedDescription: "Showmax",
  amount: 99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 60,
    rawRowText: "Pp *Showmax             Randburg     Za; 99.00",
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
LET $tx_stmt_2025_12_19_row_60 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-60",
  sourceRow: $row_row_60,
  postedAt: "2025-12-06T00:00:00Z",
  description: "Pp *Showmax             Randburg     Za",
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
fn::updateStatementRow($row_row_60.id, { transaction: $tx_stmt_2025_12_19_row_60.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_60.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_60.id, "TransactionMerchant", $merchant_showmax.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_60.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 61
LET $row_row_61 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 61,
  postedAt: "2025-12-06T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 61,
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
LET $tx_stmt_2025_12_19_row_61 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-61",
  sourceRow: $row_row_61,
  postedAt: "2025-12-06T00:00:00Z",
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
fn::updateStatementRow($row_row_61.id, { transaction: $tx_stmt_2025_12_19_row_61.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_61.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_61.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_61.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_61.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_61.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_61.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 62
LET $row_row_62 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 62,
  postedAt: "2025-12-07T00:00:00Z",
  description: "Pna Stellenbosch Square Thermanus        Za",
  normalizedDescription: "Pna Stellenbosch Square Thermanus        Za",
  amount: 199.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 62,
    rawRowText: "Pna Stellenbosch Square Thermanus        Za; 199.99",
    transactionType: "expense",
    normalizedMerchant: "Pna Stellenbosch Square Thermanus        Za",
    category: "Retail / books",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 199.99,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Retail, stationery, or book spend."
});
LET $tx_stmt_2025_12_19_row_62 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-62",
  sourceRow: $row_row_62,
  postedAt: "2025-12-07T00:00:00Z",
  description: "Pna Stellenbosch Square Thermanus        Za",
  normalizedDescription: "Pna Stellenbosch Square Thermanus        Za",
  amount: 199.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Pna Stellenbosch Square Thermanus        Za",
  merchant: $merchant_pna_stellenbosch_square_thermanus_za,
  category: $cat_retail_books,
  isTransfer: false,
  manualOverride: false,
  notes: "Retail, stationery, or book spend."
});
fn::updateStatementRow($row_row_62.id, { transaction: $tx_stmt_2025_12_19_row_62.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_62.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_62.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_62.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_62.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_62.id, "TransactionMerchant", $merchant_pna_stellenbosch_square_thermanus_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_62.id, "TransactionCategory", $cat_retail_books.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 63
LET $row_row_63 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 63,
  postedAt: "2025-12-07T00:00:00Z",
  description: "Pna Stellenbosch Square Thermanus        Za",
  normalizedDescription: "Pna Stellenbosch Square Thermanus        Za",
  amount: 149.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 63,
    rawRowText: "Pna Stellenbosch Square Thermanus        Za; 149.99",
    transactionType: "expense",
    normalizedMerchant: "Pna Stellenbosch Square Thermanus        Za",
    category: "Retail / books",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 149.99,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Retail, stationery, or book spend."
});
LET $tx_stmt_2025_12_19_row_63 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-63",
  sourceRow: $row_row_63,
  postedAt: "2025-12-07T00:00:00Z",
  description: "Pna Stellenbosch Square Thermanus        Za",
  normalizedDescription: "Pna Stellenbosch Square Thermanus        Za",
  amount: 149.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Pna Stellenbosch Square Thermanus        Za",
  merchant: $merchant_pna_stellenbosch_square_thermanus_za,
  category: $cat_retail_books,
  isTransfer: false,
  manualOverride: false,
  notes: "Retail, stationery, or book spend."
});
fn::updateStatementRow($row_row_63.id, { transaction: $tx_stmt_2025_12_19_row_63.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_63.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_63.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_63.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_63.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_63.id, "TransactionMerchant", $merchant_pna_stellenbosch_square_thermanus_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_63.id, "TransactionCategory", $cat_retail_books.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 64
LET $row_row_64 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 64,
  postedAt: "2025-12-07T00:00:00Z",
  description: "Pna Stellenbosch Square Thermanus        Za",
  normalizedDescription: "Pna Stellenbosch Square Thermanus        Za",
  amount: 1056.84,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 64,
    rawRowText: "Pna Stellenbosch Square Thermanus        Za; 1056.84",
    transactionType: "expense",
    normalizedMerchant: "Pna Stellenbosch Square Thermanus        Za",
    category: "Retail / books",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1056.84,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Retail, stationery, or book spend."
});
LET $tx_stmt_2025_12_19_row_64 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-64",
  sourceRow: $row_row_64,
  postedAt: "2025-12-07T00:00:00Z",
  description: "Pna Stellenbosch Square Thermanus        Za",
  normalizedDescription: "Pna Stellenbosch Square Thermanus        Za",
  amount: 1056.84,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Pna Stellenbosch Square Thermanus        Za",
  merchant: $merchant_pna_stellenbosch_square_thermanus_za,
  category: $cat_retail_books,
  isTransfer: false,
  manualOverride: false,
  notes: "Retail, stationery, or book spend."
});
fn::updateStatementRow($row_row_64.id, { transaction: $tx_stmt_2025_12_19_row_64.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_64.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_64.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_64.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_64.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_64.id, "TransactionMerchant", $merchant_pna_stellenbosch_square_thermanus_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_64.id, "TransactionCategory", $cat_retail_books.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 65
LET $row_row_65 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 65,
  postedAt: "2025-12-07T00:00:00Z",
  description: "Woolworths             Jamestown    Za",
  normalizedDescription: "Woolworths             Jamestown    Za",
  amount: 1695.7,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 65,
    rawRowText: "Woolworths             Jamestown    Za; 1695.70",
    transactionType: "expense",
    normalizedMerchant: "Woolworths             Jamestown    Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1695.7,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_12_19_row_65 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-65",
  sourceRow: $row_row_65,
  postedAt: "2025-12-07T00:00:00Z",
  description: "Woolworths             Jamestown    Za",
  normalizedDescription: "Woolworths             Jamestown    Za",
  amount: 1695.7,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Woolworths             Jamestown    Za",
  merchant: $merchant_woolworths_jamestown_za,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_65.id, { transaction: $tx_stmt_2025_12_19_row_65.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_65.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_65.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_65.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_65.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_65.id, "TransactionMerchant", $merchant_woolworths_jamestown_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_65.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 66
LET $row_row_66 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 66,
  postedAt: "2025-12-07T00:00:00Z",
  description: "C*Wordsworth Stellenboschwestern Cape Za",
  normalizedDescription: "C*Wordsworth Stellenboschwestern Cape Za",
  amount: 535,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 66,
    rawRowText: "C*Wordsworth Stellenboschwestern Cape Za; 535.00",
    transactionType: "expense",
    normalizedMerchant: "C*Wordsworth Stellenboschwestern Cape Za",
    category: "Retail / books",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 535,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Retail, stationery, or book spend."
});
LET $tx_stmt_2025_12_19_row_66 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-66",
  sourceRow: $row_row_66,
  postedAt: "2025-12-07T00:00:00Z",
  description: "C*Wordsworth Stellenboschwestern Cape Za",
  normalizedDescription: "C*Wordsworth Stellenboschwestern Cape Za",
  amount: 535,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "C*Wordsworth Stellenboschwestern Cape Za",
  merchant: $merchant_c_wordsworth_stellenboschwestern_cape_za,
  category: $cat_retail_books,
  isTransfer: false,
  manualOverride: false,
  notes: "Retail, stationery, or book spend."
});
fn::updateStatementRow($row_row_66.id, { transaction: $tx_stmt_2025_12_19_row_66.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_66.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_66.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_66.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_66.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_66.id, "TransactionMerchant", $merchant_c_wordsworth_stellenboschwestern_cape_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_66.id, "TransactionCategory", $cat_retail_books.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 67
LET $row_row_67 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 67,
  postedAt: "2025-12-07T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 67,
    rawRowText: "I Valr Pty Ltd         Cape Town    Za; 500.00",
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
LET $tx_stmt_2025_12_19_row_67 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-67",
  sourceRow: $row_row_67,
  postedAt: "2025-12-07T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
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
fn::updateStatementRow($row_row_67.id, { transaction: $tx_stmt_2025_12_19_row_67.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_67.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_67.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_67.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_67.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_67.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_67.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 68
LET $row_row_68 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 68,
  postedAt: "2025-12-08T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 15000,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 68,
    rawRowText: "Electronic Payment From:Internet Banking; 15000.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 15000,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2025_12_19_row_68 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-68",
  sourceRow: $row_row_68,
  postedAt: "2025-12-08T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 15000,
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
fn::updateStatementRow($row_row_68.id, { transaction: $tx_stmt_2025_12_19_row_68.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_68.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_68.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_68.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_68.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_68.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_68.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 69
LET $row_row_69 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 69,
  postedAt: "2025-12-08T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 69,
    rawRowText: "I Valr Pty Ltd         Cape Town    Za; 500.00",
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
LET $tx_stmt_2025_12_19_row_69 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-69",
  sourceRow: $row_row_69,
  postedAt: "2025-12-08T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
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
fn::updateStatementRow($row_row_69.id, { transaction: $tx_stmt_2025_12_19_row_69.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_69.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_69.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_69.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_69.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_69.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_69.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 70
LET $row_row_70 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 70,
  postedAt: "2025-12-09T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 13593,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 70,
    rawRowText: "Electronic Payment From:Internet Banking; 13593.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 13593,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2025_12_19_row_70 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-70",
  sourceRow: $row_row_70,
  postedAt: "2025-12-09T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 13593,
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
fn::updateStatementRow($row_row_70.id, { transaction: $tx_stmt_2025_12_19_row_70.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_70.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_70.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_70.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_70.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_70.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_70.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 71
LET $row_row_71 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 71,
  postedAt: "2025-12-09T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 71,
    rawRowText: "I Valr Pty Ltd         Cape Town    Za; 500.00",
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
LET $tx_stmt_2025_12_19_row_71 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-71",
  sourceRow: $row_row_71,
  postedAt: "2025-12-09T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
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
fn::updateStatementRow($row_row_71.id, { transaction: $tx_stmt_2025_12_19_row_71.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_71.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_71.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_71.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_71.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_71.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_71.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 72
LET $row_row_72 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 72,
  postedAt: "2025-12-09T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 72,
    rawRowText: "I Valr Pty Ltd         Cape Town    Za; 500.00",
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
LET $tx_stmt_2025_12_19_row_72 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-72",
  sourceRow: $row_row_72,
  postedAt: "2025-12-09T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
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
fn::updateStatementRow($row_row_72.id, { transaction: $tx_stmt_2025_12_19_row_72.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_72.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_72.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_72.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_72.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_72.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_72.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 73
LET $row_row_73 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 73,
  postedAt: "2025-12-09T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 73,
    rawRowText: "I Valr Pty Ltd         Cape Town    Za; 500.00",
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
LET $tx_stmt_2025_12_19_row_73 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-73",
  sourceRow: $row_row_73,
  postedAt: "2025-12-09T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
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
fn::updateStatementRow($row_row_73.id, { transaction: $tx_stmt_2025_12_19_row_73.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_73.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_73.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_73.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_73.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_73.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_73.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 74
LET $row_row_74 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 74,
  postedAt: "2025-12-10T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 74,
    rawRowText: "I Valr Pty Ltd         Cape Town    Za; 500.00",
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
LET $tx_stmt_2025_12_19_row_74 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-74",
  sourceRow: $row_row_74,
  postedAt: "2025-12-10T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
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
fn::updateStatementRow($row_row_74.id, { transaction: $tx_stmt_2025_12_19_row_74.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_74.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_74.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_74.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_74.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_74.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_74.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 75
LET $row_row_75 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 75,
  postedAt: "2025-12-10T00:00:00Z",
  description: "Spar Paarl Junction Ex Paarl        Za",
  normalizedDescription: "Spar Paarl Junction Ex Paarl        Za",
  amount: 34.88,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 75,
    rawRowText: "Spar Paarl Junction Ex Paarl        Za; 34.88",
    transactionType: "expense",
    normalizedMerchant: "Spar Paarl Junction Ex Paarl        Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 34.88,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_12_19_row_75 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-75",
  sourceRow: $row_row_75,
  postedAt: "2025-12-10T00:00:00Z",
  description: "Spar Paarl Junction Ex Paarl        Za",
  normalizedDescription: "Spar Paarl Junction Ex Paarl        Za",
  amount: 34.88,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Spar Paarl Junction Ex Paarl        Za",
  merchant: $merchant_spar_paarl_junction_ex_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_75.id, { transaction: $tx_stmt_2025_12_19_row_75.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_75.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_75.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_75.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_75.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_75.id, "TransactionMerchant", $merchant_spar_paarl_junction_ex_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_75.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_19_row_75 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-19-row-75",
  transaction: $tx_stmt_2025_12_19_row_75,
  status: "open",
  question: "What is the exact purpose of this Spar Paarl Junction Ex Paarl        Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_spar_paarl_junction_ex_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-12-19.import.md"
});
fn::createEdge($tx_stmt_2025_12_19_row_75.id, "TransactionClarificationTasks", $task_stmt_2025_12_19_row_75.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 76
LET $row_row_76 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 76,
  postedAt: "2025-12-10T00:00:00Z",
  description: "Mcd Paarl (0078)         0000000000000za",
  normalizedDescription: "Mcd Paarl (0078)",
  amount: 216.6,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 76,
    rawRowText: "Mcd Paarl (0078)         0000000000000za; 216.60",
    transactionType: "expense",
    normalizedMerchant: "Mcd Paarl (0078)",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 216.6,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_12_19_row_76 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-76",
  sourceRow: $row_row_76,
  postedAt: "2025-12-10T00:00:00Z",
  description: "Mcd Paarl (0078)         0000000000000za",
  normalizedDescription: "Mcd Paarl (0078)",
  amount: 216.6,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Mcd Paarl (0078)",
  merchant: $merchant_mcd_paarl_0078,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_76.id, { transaction: $tx_stmt_2025_12_19_row_76.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_76.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_76.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_76.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_76.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_76.id, "TransactionMerchant", $merchant_mcd_paarl_0078.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_76.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 77
LET $row_row_77 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 77,
  postedAt: "2025-12-10T00:00:00Z",
  description: "Shell Paarl Junction    0000000000000za",
  normalizedDescription: "Shell Paarl Junction",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 77,
    rawRowText: "Shell Paarl Junction    0000000000000za; 500.00",
    transactionType: "expense",
    normalizedMerchant: "Shell Paarl Junction",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 500,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_12_19_row_77 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-77",
  sourceRow: $row_row_77,
  postedAt: "2025-12-10T00:00:00Z",
  description: "Shell Paarl Junction    0000000000000za",
  normalizedDescription: "Shell Paarl Junction",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Shell Paarl Junction",
  merchant: $merchant_shell_paarl_junction,
  category: $cat_fuel_transport,
  isTransfer: false,
  manualOverride: false,
  notes: "Fuel or transport spend."
});
fn::updateStatementRow($row_row_77.id, { transaction: $tx_stmt_2025_12_19_row_77.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_77.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_77.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_77.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_77.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_77.id, "TransactionMerchant", $merchant_shell_paarl_junction.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_77.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 78
LET $row_row_78 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 78,
  postedAt: "2025-12-11T00:00:00Z",
  description: "Engen Paradyskloof       0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 407.19,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 78,
    rawRowText: "Engen Paradyskloof       0000000000000za; 407.19",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 407.19,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_12_19_row_78 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-78",
  sourceRow: $row_row_78,
  postedAt: "2025-12-11T00:00:00Z",
  description: "Engen Paradyskloof       0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 407.19,
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
fn::updateStatementRow($row_row_78.id, { transaction: $tx_stmt_2025_12_19_row_78.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_78.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_78.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_78.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_78.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_78.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_78.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 79
LET $row_row_79 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 79,
  postedAt: "2025-12-11T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 79,
    rawRowText: "I Valr Pty Ltd         Cape Town    Za; 500.00",
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
LET $tx_stmt_2025_12_19_row_79 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-79",
  sourceRow: $row_row_79,
  postedAt: "2025-12-11T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
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
fn::updateStatementRow($row_row_79.id, { transaction: $tx_stmt_2025_12_19_row_79.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_79.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_79.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_79.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_79.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_79.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_79.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 80
LET $row_row_80 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 80,
  postedAt: "2025-12-12T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 80,
    rawRowText: "I Valr Pty Ltd         Cape Town    Za; 500.00",
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
LET $tx_stmt_2025_12_19_row_80 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-80",
  sourceRow: $row_row_80,
  postedAt: "2025-12-12T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
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
fn::updateStatementRow($row_row_80.id, { transaction: $tx_stmt_2025_12_19_row_80.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_80.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_80.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_80.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_80.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_80.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_80.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 81
LET $row_row_81 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 81,
  postedAt: "2025-12-12T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 81,
    rawRowText: "I Valr Pty Ltd         Cape Town    Za; 1000.00",
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
LET $tx_stmt_2025_12_19_row_81 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-81",
  sourceRow: $row_row_81,
  postedAt: "2025-12-12T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
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
fn::updateStatementRow($row_row_81.id, { transaction: $tx_stmt_2025_12_19_row_81.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_81.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_81.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_81.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_81.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_81.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_81.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 82
LET $row_row_82 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 82,
  postedAt: "2025-12-12T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 82,
    rawRowText: "I Valr Pty Ltd         Cape Town    Za; 1000.00",
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
LET $tx_stmt_2025_12_19_row_82 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-82",
  sourceRow: $row_row_82,
  postedAt: "2025-12-12T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
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
fn::updateStatementRow($row_row_82.id, { transaction: $tx_stmt_2025_12_19_row_82.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_82.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_82.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_82.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_82.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_82.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_82.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 83
LET $row_row_83 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 83,
  postedAt: "2025-12-12T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 83,
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
LET $tx_stmt_2025_12_19_row_83 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-83",
  sourceRow: $row_row_83,
  postedAt: "2025-12-12T00:00:00Z",
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
fn::updateStatementRow($row_row_83.id, { transaction: $tx_stmt_2025_12_19_row_83.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_83.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_83.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_83.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_83.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_83.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_83.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 84
LET $row_row_84 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 84,
  postedAt: "2025-12-13T00:00:00Z",
  description: "Woolworths             Jamestown    Za",
  normalizedDescription: "Woolworths             Jamestown    Za",
  amount: 229.45,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 84,
    rawRowText: "Woolworths             Jamestown    Za; 229.45",
    transactionType: "expense",
    normalizedMerchant: "Woolworths             Jamestown    Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 229.45,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_12_19_row_84 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-84",
  sourceRow: $row_row_84,
  postedAt: "2025-12-13T00:00:00Z",
  description: "Woolworths             Jamestown    Za",
  normalizedDescription: "Woolworths             Jamestown    Za",
  amount: 229.45,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Woolworths             Jamestown    Za",
  merchant: $merchant_woolworths_jamestown_za,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_84.id, { transaction: $tx_stmt_2025_12_19_row_84.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_84.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_84.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_84.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_84.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_84.id, "TransactionMerchant", $merchant_woolworths_jamestown_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_84.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 85
LET $row_row_85 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 85,
  postedAt: "2025-12-13T00:00:00Z",
  description: "Woolworths             Jamestown    Za",
  normalizedDescription: "Woolworths             Jamestown    Za",
  amount: 82.8,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 85,
    rawRowText: "Woolworths             Jamestown    Za; 82.80",
    transactionType: "expense",
    normalizedMerchant: "Woolworths             Jamestown    Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 82.8,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_12_19_row_85 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-85",
  sourceRow: $row_row_85,
  postedAt: "2025-12-13T00:00:00Z",
  description: "Woolworths             Jamestown    Za",
  normalizedDescription: "Woolworths             Jamestown    Za",
  amount: 82.8,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Woolworths             Jamestown    Za",
  merchant: $merchant_woolworths_jamestown_za,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_85.id, { transaction: $tx_stmt_2025_12_19_row_85.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_85.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_85.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_85.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_85.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_85.id, "TransactionMerchant", $merchant_woolworths_jamestown_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_85.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 86
LET $row_row_86 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 86,
  postedAt: "2025-12-13T00:00:00Z",
  description: "C*Wordsworth Stellenboschwestern Cape Za",
  normalizedDescription: "C*Wordsworth Stellenboschwestern Cape Za",
  amount: 535,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 86,
    rawRowText: "C*Wordsworth Stellenboschwestern Cape Za; 535.00",
    transactionType: "expense",
    normalizedMerchant: "C*Wordsworth Stellenboschwestern Cape Za",
    category: "Retail / books",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 535,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Retail, stationery, or book spend."
});
LET $tx_stmt_2025_12_19_row_86 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-86",
  sourceRow: $row_row_86,
  postedAt: "2025-12-13T00:00:00Z",
  description: "C*Wordsworth Stellenboschwestern Cape Za",
  normalizedDescription: "C*Wordsworth Stellenboschwestern Cape Za",
  amount: 535,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "C*Wordsworth Stellenboschwestern Cape Za",
  merchant: $merchant_c_wordsworth_stellenboschwestern_cape_za,
  category: $cat_retail_books,
  isTransfer: false,
  manualOverride: false,
  notes: "Retail, stationery, or book spend."
});
fn::updateStatementRow($row_row_86.id, { transaction: $tx_stmt_2025_12_19_row_86.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_86.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_86.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_86.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_86.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_86.id, "TransactionMerchant", $merchant_c_wordsworth_stellenboschwestern_cape_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_86.id, "TransactionCategory", $cat_retail_books.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 87
LET $row_row_87 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 87,
  postedAt: "2025-12-13T00:00:00Z",
  description: "Trade Travel Chill      Abu Dhabi    Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1030.45,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 87,
    rawRowText: "Trade Travel Chill      Abu Dhabi    Ae; 1030.45",
    transactionType: "expense",
    normalizedMerchant: "Trade Travel Chill",
    category: "Business expenses paid personally / trading tools",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1030.45,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Recurring trading-indicator or trading-service spend."
});
LET $tx_stmt_2025_12_19_row_87 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-87",
  sourceRow: $row_row_87,
  postedAt: "2025-12-13T00:00:00Z",
  description: "Trade Travel Chill      Abu Dhabi    Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1030.45,
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
fn::updateStatementRow($row_row_87.id, { transaction: $tx_stmt_2025_12_19_row_87.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_87.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_87.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_87.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_87.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_87.id, "TransactionMerchant", $merchant_trade_travel_chill.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_87.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 88
LET $row_row_88 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 88,
  postedAt: "2025-12-13T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 88,
    rawRowText: "I Valr Pty Ltd         Cape Town    Za; 1000.00",
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
LET $tx_stmt_2025_12_19_row_88 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-88",
  sourceRow: $row_row_88,
  postedAt: "2025-12-13T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
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
fn::updateStatementRow($row_row_88.id, { transaction: $tx_stmt_2025_12_19_row_88.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_88.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_88.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_88.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_88.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_88.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_88.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 89
LET $row_row_89 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 89,
  postedAt: "2025-12-14T00:00:00Z",
  description: "Engen Paradyskloof       0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 195.98,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 89,
    rawRowText: "Engen Paradyskloof       0000000000000za; 195.98",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 195.98,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_12_19_row_89 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-89",
  sourceRow: $row_row_89,
  postedAt: "2025-12-14T00:00:00Z",
  description: "Engen Paradyskloof       0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 195.98,
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
fn::updateStatementRow($row_row_89.id, { transaction: $tx_stmt_2025_12_19_row_89.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_89.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_89.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_89.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_89.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_89.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_89.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 90
LET $row_row_90 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 90,
  postedAt: "2025-12-15T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 90,
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
LET $tx_stmt_2025_12_19_row_90 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-90",
  sourceRow: $row_row_90,
  postedAt: "2025-12-15T00:00:00Z",
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
fn::updateStatementRow($row_row_90.id, { transaction: $tx_stmt_2025_12_19_row_90.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_90.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_90.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_90.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_90.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_90.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_90.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 91
LET $row_row_91 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 91,
  postedAt: "2025-12-16T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 91,
    rawRowText: "I Valr Pty Ltd         Cape Town    Za; 500.00",
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
LET $tx_stmt_2025_12_19_row_91 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-91",
  sourceRow: $row_row_91,
  postedAt: "2025-12-16T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town    Za",
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
fn::updateStatementRow($row_row_91.id, { transaction: $tx_stmt_2025_12_19_row_91.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_91.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_91.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_91.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_91.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_91.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_91.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 92
LET $row_row_92 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 92,
  postedAt: "2025-12-16T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 92,
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
LET $tx_stmt_2025_12_19_row_92 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-92",
  sourceRow: $row_row_92,
  postedAt: "2025-12-16T00:00:00Z",
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
fn::updateStatementRow($row_row_92.id, { transaction: $tx_stmt_2025_12_19_row_92.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_92.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_92.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_92.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_92.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_92.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_92.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 93
LET $row_row_93 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 93,
  postedAt: "2025-12-16T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 93,
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
LET $tx_stmt_2025_12_19_row_93 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-93",
  sourceRow: $row_row_93,
  postedAt: "2025-12-16T00:00:00Z",
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
fn::updateStatementRow($row_row_93.id, { transaction: $tx_stmt_2025_12_19_row_93.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_93.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_93.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_93.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_93.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_93.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_93.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 94
LET $row_row_94 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 94,
  postedAt: "2025-12-16T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 94,
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
LET $tx_stmt_2025_12_19_row_94 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-94",
  sourceRow: $row_row_94,
  postedAt: "2025-12-16T00:00:00Z",
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
fn::updateStatementRow($row_row_94.id, { transaction: $tx_stmt_2025_12_19_row_94.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_94.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_94.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_94.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_94.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_94.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_94.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 95
LET $row_row_95 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 95,
  postedAt: "2025-12-16T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 95,
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
LET $tx_stmt_2025_12_19_row_95 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-95",
  sourceRow: $row_row_95,
  postedAt: "2025-12-16T00:00:00Z",
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
fn::updateStatementRow($row_row_95.id, { transaction: $tx_stmt_2025_12_19_row_95.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_95.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_95.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_95.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_95.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_95.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_95.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 96
LET $row_row_96 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 96,
  postedAt: "2025-12-17T00:00:00Z",
  description: "Bossa Stellenbosch      0000000000000za",
  normalizedDescription: "Bossa Stellenbosch      0000000000000za",
  amount: 420,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 96,
    rawRowText: "Bossa Stellenbosch      0000000000000za; 420.00",
    transactionType: "expense",
    normalizedMerchant: "Bossa Stellenbosch      0000000000000za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 420,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_12_19_row_96 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-96",
  sourceRow: $row_row_96,
  postedAt: "2025-12-17T00:00:00Z",
  description: "Bossa Stellenbosch      0000000000000za",
  normalizedDescription: "Bossa Stellenbosch      0000000000000za",
  amount: 420,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Bossa Stellenbosch      0000000000000za",
  merchant: $merchant_bossa_stellenbosch_0000000000000za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_96.id, { transaction: $tx_stmt_2025_12_19_row_96.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_96.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_96.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_96.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_96.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_96.id, "TransactionMerchant", $merchant_bossa_stellenbosch_0000000000000za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_96.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_19_row_96 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-19-row-96",
  transaction: $tx_stmt_2025_12_19_row_96,
  status: "open",
  question: "What is the exact purpose of this Bossa Stellenbosch      0000000000000za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_bossa_stellenbosch_0000000000000za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-12-19.import.md"
});
fn::createEdge($tx_stmt_2025_12_19_row_96.id, "TransactionClarificationTasks", $task_stmt_2025_12_19_row_96.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 97
LET $row_row_97 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 97,
  postedAt: "2025-12-17T00:00:00Z",
  description: "Adenes Flowers Stellenbo Stellenbosch Za",
  normalizedDescription: "Adenes Flowers Stellenbo Stellenbosch Za",
  amount: 280,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 97,
    rawRowText: "Adenes Flowers Stellenbo Stellenbosch Za; 280.00",
    transactionType: "expense",
    normalizedMerchant: "Adenes Flowers Stellenbo Stellenbosch Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 280,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_12_19_row_97 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-97",
  sourceRow: $row_row_97,
  postedAt: "2025-12-17T00:00:00Z",
  description: "Adenes Flowers Stellenbo Stellenbosch Za",
  normalizedDescription: "Adenes Flowers Stellenbo Stellenbosch Za",
  amount: 280,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Adenes Flowers Stellenbo Stellenbosch Za",
  merchant: $merchant_adenes_flowers_stellenbo_stellenbosch_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_97.id, { transaction: $tx_stmt_2025_12_19_row_97.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_97.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_97.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_97.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_97.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_97.id, "TransactionMerchant", $merchant_adenes_flowers_stellenbo_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_97.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_19_row_97 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-19-row-97",
  transaction: $tx_stmt_2025_12_19_row_97,
  status: "open",
  question: "What is the exact purpose of this Adenes Flowers Stellenbo Stellenbosch Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_adenes_flowers_stellenbo_stellenbosch_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-12-19.import.md"
});
fn::createEdge($tx_stmt_2025_12_19_row_97.id, "TransactionClarificationTasks", $task_stmt_2025_12_19_row_97.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 98
LET $row_row_98 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 98,
  postedAt: "2025-12-17T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 98,
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
LET $tx_stmt_2025_12_19_row_98 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-98",
  sourceRow: $row_row_98,
  postedAt: "2025-12-17T00:00:00Z",
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
fn::updateStatementRow($row_row_98.id, { transaction: $tx_stmt_2025_12_19_row_98.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_98.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_98.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_98.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_98.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_98.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_98.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 99
LET $row_row_99 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 99,
  postedAt: "2025-12-17T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 99,
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
LET $tx_stmt_2025_12_19_row_99 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-99",
  sourceRow: $row_row_99,
  postedAt: "2025-12-17T00:00:00Z",
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
fn::updateStatementRow($row_row_99.id, { transaction: $tx_stmt_2025_12_19_row_99.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_99.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_99.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_99.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_99.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_99.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_99.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 100
LET $row_row_100 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 100,
  postedAt: "2025-12-17T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town     Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 100,
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
LET $tx_stmt_2025_12_19_row_100 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-100",
  sourceRow: $row_row_100,
  postedAt: "2025-12-17T00:00:00Z",
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
fn::updateStatementRow($row_row_100.id, { transaction: $tx_stmt_2025_12_19_row_100.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_100.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_100.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_100.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_100.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_100.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_100.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 101
LET $row_row_101 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 101,
  postedAt: "2025-12-18T00:00:00Z",
  description: "Woolworths             Jamestown     Za",
  normalizedDescription: "Woolworths             Jamestown     Za",
  amount: 82.8,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 101,
    rawRowText: "Woolworths             Jamestown     Za; 82.80",
    transactionType: "expense",
    normalizedMerchant: "Woolworths             Jamestown     Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 82.8,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_12_19_row_101 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-101",
  sourceRow: $row_row_101,
  postedAt: "2025-12-18T00:00:00Z",
  description: "Woolworths             Jamestown     Za",
  normalizedDescription: "Woolworths             Jamestown     Za",
  amount: 82.8,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Woolworths             Jamestown     Za",
  merchant: $merchant_woolworths_jamestown_za,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_101.id, { transaction: $tx_stmt_2025_12_19_row_101.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_101.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_101.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_101.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_101.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_101.id, "TransactionMerchant", $merchant_woolworths_jamestown_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_101.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 102
LET $row_row_102 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 102,
  postedAt: "2025-12-18T00:00:00Z",
  description: "Clipper Club          0000000000000za",
  normalizedDescription: "Clipper Club          0000000000000za",
  amount: 270,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 102,
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
LET $tx_stmt_2025_12_19_row_102 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-102",
  sourceRow: $row_row_102,
  postedAt: "2025-12-18T00:00:00Z",
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
fn::updateStatementRow($row_row_102.id, { transaction: $tx_stmt_2025_12_19_row_102.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_102.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_102.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_102.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_102.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_102.id, "TransactionMerchant", $merchant_clipper_club_0000000000000za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_102.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_12_19_row_102 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-12-19-row-102",
  transaction: $tx_stmt_2025_12_19_row_102,
  status: "open",
  question: "What is the exact purpose of this Clipper Club          0000000000000za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_clipper_club_0000000000000za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-12-19.import.md"
});
fn::createEdge($tx_stmt_2025_12_19_row_102.id, "TransactionClarificationTasks", $task_stmt_2025_12_19_row_102.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 103
LET $row_row_103 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 103,
  postedAt: "2025-12-18T00:00:00Z",
  description: "Clicks Stellenbosch Sq 0000000000000za",
  normalizedDescription: "Clicks Stellenbosch Square",
  amount: 1308.13,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/December 2025.pdf",
    statementPeriodStart: "2025-11-20",
    statementPeriodEnd: "2025-12-19",
    rowNo: 103,
    rawRowText: "Clicks Stellenbosch Sq 0000000000000za; 1308.13",
    transactionType: "expense",
    normalizedMerchant: "Clicks Stellenbosch Square",
    category: "Personal care / pharmacy",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1308.13,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Pharmacy or personal-care spend."
});
LET $tx_stmt_2025_12_19_row_103 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-12-19-row-103",
  sourceRow: $row_row_103,
  postedAt: "2025-12-18T00:00:00Z",
  description: "Clicks Stellenbosch Sq 0000000000000za",
  normalizedDescription: "Clicks Stellenbosch Square",
  amount: 1308.13,
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
fn::updateStatementRow($row_row_103.id, { transaction: $tx_stmt_2025_12_19_row_103.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_103.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_103.id, "StatementRowTransactions", $tx_stmt_2025_12_19_row_103.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_12_19_row_103.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_103.id, "TransactionMerchant", $merchant_clicks_stellenbosch_square.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_12_19_row_103.id, "TransactionCategory", $cat_personal_care_pharmacy.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 103,
  normalizedCount: 103,
  clarificationCount: 5,
  status: "matched",
  statementDate: "2025-12-19T00:00:00Z",
  notes: "Imported from 2025-12-19.import.md"
});

-- End of generated import
