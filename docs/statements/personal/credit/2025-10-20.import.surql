-- Generated from docs/statements/personal/credit/2025-10-20.import.md
-- Source: docs/statements/personal/credit/October 2025.pdf

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
  openingBalance: 110795.32,
  active: true,
  notes: "Imported from October 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-10-20-nedbank-credit",
  sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-10-20T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_crypto_trading = fn::createCategory({
  space: $space,
  key: "crypto-trading",
  name: "Crypto / trading",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_groceries_household = fn::createCategory({
  space: $space,
  key: "groceries-household",
  name: "Groceries / household",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_cash_advance = fn::createCategory({
  space: $space,
  key: "cash-advance",
  name: "Cash advance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_dining_lifestyle = fn::createCategory({
  space: $space,
  key: "dining-lifestyle",
  name: "Dining / lifestyle",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_business_expenses_paid_personally_hosting_software = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-hosting-software",
  name: "Business expenses paid personally / hosting / software",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_business_expenses_paid_personally_trading_tools = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-trading-tools",
  name: "Business expenses paid personally / trading tools",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_subscription_media = fn::createCategory({
  space: $space,
  key: "subscription-media",
  name: "Subscription / media",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_fuel_transport = fn::createCategory({
  space: $space,
  key: "fuel-transport",
  name: "Fuel / transport",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_fees_electronic_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-electronic-payment-fee",
  name: "Electronic Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_fees_declined_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-declined-payment-fee",
  name: "Declined Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_fees_credit_facility_service_fee = fn::createCategory({
  space: $space,
  key: "fees-credit-facility-service-fee",
  name: "Credit Facility Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_fees_finance_charge = fn::createCategory({
  space: $space,
  key: "fees-finance-charge",
  name: "Finance Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});

-- Merchant records
LET $merchant_nedbank_current_account = fn::createMerchant({
  space: $space,
  key: "nedbank-current-account",
  name: "Nedbank Current Account",
  normalizedName: "Nedbank Current Account",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_cross_border_transaction_fee = fn::createMerchant({
  space: $space,
  key: "cross-border-transaction-fee",
  name: "Cross Border Transaction Fee",
  normalizedName: "Cross Border Transaction Fee",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_valr = fn::createMerchant({
  space: $space,
  key: "valr",
  name: "VALR",
  normalizedName: "VALR",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_male_ego_barber_142793_paarl_za = fn::createMerchant({
  space: $space,
  key: "male-ego-barber-142793-paarl-za",
  name: "Male Ego Barber 142793 Paarl               Za",
  normalizedName: "Male Ego Barber 142793 Paarl               Za",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_wwh_drakenstein_sentru = fn::createMerchant({
  space: $space,
  key: "wwh-drakenstein-sentru",
  name: "Wwh Drakenstein Sentru",
  normalizedName: "Wwh Drakenstein Sentru",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_totalsports_paarl_mall_0000000000000za = fn::createMerchant({
  space: $space,
  key: "totalsports-paarl-mall-0000000000000za",
  name: "Totalsports Paarl Mall 0000000000000za",
  normalizedName: "Totalsports Paarl Mall 0000000000000za",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_nedbank_internet_banking = fn::createMerchant({
  space: $space,
  key: "nedbank-internet-banking",
  name: "Nedbank Internet Banking",
  normalizedName: "Nedbank Internet Banking",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_transfer_to_internet_banking_transfer = fn::createMerchant({
  space: $space,
  key: "transfer-to-internet-banking-transfer",
  name: "Transfer To:Internet Banking Transfer",
  normalizedName: "Transfer To:Internet Banking Transfer",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_the_local_choic_202880_val_de_vie_e_za = fn::createMerchant({
  space: $space,
  key: "the-local-choic-202880-val-de-vie-e-za",
  name: "The Local Choic 202880 Val De Vie E Za",
  normalizedName: "The Local Choic 202880 Val De Vie E Za",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_yoco_bco_taste_kitc_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "yoco-bco-taste-kitc-stellenbosch-za",
  name: "Yoco *Bco Taste Kitc Stellenbosch Za",
  normalizedName: "Yoco *Bco Taste Kitc Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_afrihost = fn::createMerchant({
  space: $space,
  key: "afrihost",
  name: "Afrihost",
  normalizedName: "Afrihost",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_i_afrihost_com_4_cape_town_za = fn::createMerchant({
  space: $space,
  key: "i-afrihost-com-4-cape-town-za",
  name: "I Afrihost.Com 4        Cape Town         Za",
  normalizedName: "I Afrihost.Com 4        Cape Town         Za",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_hyrotrader = fn::createMerchant({
  space: $space,
  key: "hyrotrader",
  name: "HyroTrader",
  normalizedName: "HyroTrader",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_spotify = fn::createMerchant({
  space: $space,
  key: "spotify",
  name: "Spotify",
  normalizedName: "Spotify",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_sunset_b51000002213225_western_cape_za = fn::createMerchant({
  space: $space,
  key: "sunset-b51000002213225-western-cape-za",
  name: "Sunset B51000002213225 Western Cape Za",
  normalizedName: "Sunset B51000002213225 Western Cape Za",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_giovannis_eikendal_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "giovannis-eikendal-stellenbosch-za",
  name: "Giovannis Eikendal       Stellenbosch Za",
  normalizedName: "Giovannis Eikendal       Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_mr_d_food_cape_town_za = fn::createMerchant({
  space: $space,
  key: "mr-d-food-cape-town-za",
  name: "Mr D Food              Cape Town       Za",
  normalizedName: "Mr D Food              Cape Town       Za",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_kwikspar_paradyskloof = fn::createMerchant({
  space: $space,
  key: "kwikspar-paradyskloof",
  name: "Kwikspar Paradyskloof",
  normalizedName: "Kwikspar Paradyskloof",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_netflorist_gauteng_za = fn::createMerchant({
  space: $space,
  key: "netflorist-gauteng-za",
  name: "Netflorist          Gauteng     Za",
  normalizedName: "Netflorist          Gauteng     Za",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_vsa_inner_theliven_com_limassol_cy = fn::createMerchant({
  space: $space,
  key: "vsa-inner-theliven-com-limassol-cy",
  name: "Vsa_Inner-Theliven.Com Limassol Cy",
  normalizedName: "Vsa_Inner-Theliven.Com Limassol Cy",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_yoco_feedem_group_t_franchhoek_za = fn::createMerchant({
  space: $space,
  key: "yoco-feedem-group-t-franchhoek-za",
  name: "Yoco *Feedem Group T Franchhoek Za",
  normalizedName: "Yoco *Feedem Group T Franchhoek Za",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_pbrands_warsaw_pl = fn::createMerchant({
  space: $space,
  key: "pbrands-warsaw-pl",
  name: "Pbrands              Warsaw       Pl",
  normalizedName: "Pbrands              Warsaw       Pl",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_paypal_madmusl_w_o14g_35314369001_cy = fn::createMerchant({
  space: $space,
  key: "paypal-madmusl-w-o14g-35314369001-cy",
  name: "Paypal *Madmusl W O14g 35314369001 Cy",
  normalizedName: "Paypal *Madmusl W O14g 35314369001 Cy",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_showmax = fn::createMerchant({
  space: $space,
  key: "showmax",
  name: "Showmax",
  normalizedName: "Showmax",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_str_parking_ct_104_sea_point_za = fn::createMerchant({
  space: $space,
  key: "str-parking-ct-104-sea-point-za",
  name: "Str Parking Ct 104      Sea Point      Za",
  normalizedName: "Str Parking Ct 104      Sea Point      Za",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_c_mcd_long_street_long_za = fn::createMerchant({
  space: $space,
  key: "c-mcd-long-street-long-za",
  name: "C*Mcd Long Street        Long          Za",
  normalizedName: "C*Mcd Long Street        Long          Za",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_ik_museum_of_illusion_johannesburg_za = fn::createMerchant({
  space: $space,
  key: "ik-museum-of-illusion-johannesburg-za",
  name: "Ik *Museum Of Illusion Johannesburg Za",
  normalizedName: "Ik *Museum Of Illusion Johannesburg Za",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_blaauwklippen_h_135297_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "blaauwklippen-h-135297-stellenbosch-za",
  name: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedName: "Blaauwklippen H 135297 Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_blaauwklippen_266384_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "blaauwklippen-266384-stellenbosch-za",
  name: "Blaauwklippen      266384 Stellenbosch Za",
  normalizedName: "Blaauwklippen      266384 Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});
LET $merchant_engen_paradyskloof = fn::createMerchant({
  space: $space,
  key: "engen-paradyskloof",
  name: "Engen Paradyskloof",
  normalizedName: "Engen Paradyskloof",
  active: true,
  notes: "Imported from 2025-10-20.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-09-29T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 40700,
  balance: 40700,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 1,
    rawRowText: "Internet Banking Transferselby     Za; 40700.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 40700,
    bankChargeZar: null,
    balanceZar: 40700
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_10_20_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-09-29T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 40700,
  balance: 40700,
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_10_20_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_01.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_01.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-09-30T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 10000,
  balance: 10000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 2,
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
LET $tx_stmt_2025_10_20_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-09-30T00:00:00Z",
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_10_20_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_02.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_02.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-10-01T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 9000,
  balance: 9000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 3,
    rawRowText: "Internet Banking Transferselby     Za; 9000.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 9000,
    bankChargeZar: null,
    balanceZar: 9000
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_10_20_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-10-01T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 9000,
  balance: 9000,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_10_20_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_03.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_03.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 31000,
  balance: 31000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
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
LET $tx_stmt_2025_10_20_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-10-02T00:00:00Z",
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_10_20_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_04.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_04.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 19000,
  balance: 19000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 5,
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
LET $tx_stmt_2025_10_20_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-10-02T00:00:00Z",
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_10_20_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_05.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_05.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-10-06T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2500,
  balance: 2500,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 6,
    rawRowText: "Internet Banking Transferselby     Za; 2500.00 Cr",
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
LET $tx_stmt_2025_10_20_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-10-06T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_10_20_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_06.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_06.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-10-07T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1109,
  balance: 1109,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 7,
    rawRowText: "Internet Banking Transferselby     Za; 1109.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1109,
    bankChargeZar: null,
    balanceZar: 1109
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_10_20_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-10-07T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1109,
  balance: 1109,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_10_20_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_07.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_07.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-10-08T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 20000,
  balance: 20000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 8,
    rawRowText: "Internet Banking Transferselby     Za; 20000.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 20000,
    bankChargeZar: null,
    balanceZar: 20000
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_10_20_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-10-08T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 20000,
  balance: 20000,
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_10_20_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_08.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_08.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-10-10T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2500,
  balance: 2500,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 9,
    rawRowText: "Internet Banking Transferselby     Za; 2500.00 Cr",
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
LET $tx_stmt_2025_10_20_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-10-10T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_10_20_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_09.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_09.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-10-13T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2000,
  balance: 2000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 10,
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
LET $tx_stmt_2025_10_20_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-10-13T00:00:00Z",
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_10_20_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_10.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_10.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-10-17T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1000,
  balance: 1000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 11,
    rawRowText: "Internet Banking Transferselby     Za; 1000.00 Cr",
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
LET $tx_stmt_2025_10_20_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-10-17T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_10_20_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_11.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_11.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-10-20T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1000,
  balance: 1000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 12,
    rawRowText: "Internet Banking Transferselby     Za; 1000.00 Cr",
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
LET $tx_stmt_2025_10_20_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-10-20T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_10_20_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_12.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_12.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-10-20T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 20000,
  balance: 20000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 13,
    rawRowText: "Internet Banking Transferselby     Za; 20000.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 20000,
    bankChargeZar: null,
    balanceZar: 20000
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_10_20_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-10-20T00:00:00Z",
  description: "Internet Banking Transferselby     Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 20000,
  balance: 20000,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_10_20_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_13.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_13.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-09-29T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 14,
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
LET $tx_stmt_2025_10_20_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-09-29T00:00:00Z",
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_10_20_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_14.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_14.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-09-29T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 15,
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
LET $tx_stmt_2025_10_20_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-09-29T00:00:00Z",
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_10_20_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_15.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_15.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-09-30T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 16,
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
LET $tx_stmt_2025_10_20_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-09-30T00:00:00Z",
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_10_20_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_16.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_16.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 17,
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
LET $tx_stmt_2025_10_20_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-10-02T00:00:00Z",
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_10_20_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_17.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_17.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 18,
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
LET $tx_stmt_2025_10_20_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-10-02T00:00:00Z",
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_10_20_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_18.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_18.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-10-03T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 19,
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
LET $tx_stmt_2025_10_20_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-10-03T00:00:00Z",
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
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_10_20_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_19.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_19.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-10-06T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 20,
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
LET $tx_stmt_2025_10_20_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-10-06T00:00:00Z",
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
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_10_20_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_20.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_20.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-10-06T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 21,
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
LET $tx_stmt_2025_10_20_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-10-06T00:00:00Z",
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
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_10_20_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_21.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_21.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-10-09T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 22,
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
LET $tx_stmt_2025_10_20_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-10-09T00:00:00Z",
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
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_10_20_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_22.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_22.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-10-13T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 23,
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
LET $tx_stmt_2025_10_20_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-10-13T00:00:00Z",
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_10_20_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_23.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_23.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-10-13T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 24,
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
LET $tx_stmt_2025_10_20_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-10-13T00:00:00Z",
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
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_10_20_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_24.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_24.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-10-13T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 25,
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
LET $tx_stmt_2025_10_20_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-10-13T00:00:00Z",
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
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_10_20_row_25.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_25.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_25.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-10-13T00:00:00Z",
  description: "Maintenance Fee",
  normalizedDescription: "Maintenance Fee",
  amount: 38.26,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 26,
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
LET $tx_stmt_2025_10_20_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-10-13T00:00:00Z",
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
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_10_20_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_26.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_26.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-10-14T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 27,
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
LET $tx_stmt_2025_10_20_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-10-14T00:00:00Z",
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
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_10_20_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_27.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_27.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-10-15T00:00:00Z",
  description: "Credit Facility Service Fee",
  normalizedDescription: "Credit Facility Service Fee",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 28,
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
LET $tx_stmt_2025_10_20_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-10-15T00:00:00Z",
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
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_10_20_row_28.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_28.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_28.id, "TransactionCategory", $cat_fees_credit_facility_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-10-17T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 29,
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
LET $tx_stmt_2025_10_20_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-10-17T00:00:00Z",
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
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_10_20_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_29.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_29.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-10-20T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 1436.06,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 30,
    rawRowText: "Finance Charge; 1436.06",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "finance charge",
    clarificationStatus: "clarified",
    amountZar: 1436.06,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Finance charge on the outstanding balance."
});
LET $tx_stmt_2025_10_20_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-10-20T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 1436.06,
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
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_10_20_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_30.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_30.id, "TransactionCategory", $cat_fees_finance_charge.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-10-17T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 26.94,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 31,
    rawRowText: "Total V A T; 26.94",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 26.94,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "VAT on fees."
});
LET $tx_stmt_2025_10_20_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-10-17T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 26.94,
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
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_10_20_row_31.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_31.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_31.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-10-15T00:00:00Z",
  description: "Cross Border Transaction Fee",
  normalizedDescription: "Cross Border Transaction Fee",
  amount: 5.01,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 32,
    rawRowText: "Cross Border Transaction Fee; 5.01",
    transactionType: "expense",
    normalizedMerchant: "Cross Border Transaction Fee",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 5.01,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_20_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-10-15T00:00:00Z",
  description: "Cross Border Transaction Fee",
  normalizedDescription: "Cross Border Transaction Fee",
  amount: 5.01,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Cross Border Transaction Fee",
  merchant: $merchant_cross_border_transaction_fee,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_10_20_row_32.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_32.id, "TransactionMerchant", $merchant_cross_border_transaction_fee.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_32.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_32 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-32",
  transaction: $tx_stmt_2025_10_20_row_32,
  status: "open",
  question: "What is the exact purpose of this Cross Border Transaction Fee transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_cross_border_transaction_fee,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_32.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_32.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-09-18T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town          Za",
  normalizedDescription: "VALR",
  amount: 200,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 33,
    rawRowText: "I Valr Pty Ltd         Cape Town          Za; 200.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 200,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2025_10_20_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-09-18T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town          Za",
  normalizedDescription: "VALR",
  amount: 200,
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
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_10_20_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_33.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_33.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-09-28T00:00:00Z",
  description: "Male Ego Barber 142793 Paarl               Za",
  normalizedDescription: "Male Ego Barber 142793 Paarl               Za",
  amount: 350,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 34,
    rawRowText: "Male Ego Barber 142793 Paarl               Za; 350.00",
    transactionType: "expense",
    normalizedMerchant: "Male Ego Barber 142793 Paarl               Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 350,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_20_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-09-28T00:00:00Z",
  description: "Male Ego Barber 142793 Paarl               Za",
  normalizedDescription: "Male Ego Barber 142793 Paarl               Za",
  amount: 350,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Male Ego Barber 142793 Paarl               Za",
  merchant: $merchant_male_ego_barber_142793_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_10_20_row_34.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_34.id, "TransactionMerchant", $merchant_male_ego_barber_142793_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_34.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_34 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-34",
  transaction: $tx_stmt_2025_10_20_row_34,
  status: "open",
  question: "What is the exact purpose of this Male Ego Barber 142793 Paarl               Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_male_ego_barber_142793_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_34.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_34.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2025-09-28T00:00:00Z",
  description: "Wwh Drakenstein Sentru 0000000000000za",
  normalizedDescription: "Wwh Drakenstein Sentru",
  amount: 809.95,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 35,
    rawRowText: "Wwh Drakenstein Sentru 0000000000000za; 809.95",
    transactionType: "expense",
    normalizedMerchant: "Wwh Drakenstein Sentru",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 809.95,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_10_20_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-35",
  sourceRow: $row_row_35,
  postedAt: "2025-09-28T00:00:00Z",
  description: "Wwh Drakenstein Sentru 0000000000000za",
  normalizedDescription: "Wwh Drakenstein Sentru",
  amount: 809.95,
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
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_10_20_row_35.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_35.id, "TransactionMerchant", $merchant_wwh_drakenstein_sentru.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_35.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2025-09-28T00:00:00Z",
  description: "Totalsports Paarl Mall 0000000000000za",
  normalizedDescription: "Totalsports Paarl Mall 0000000000000za",
  amount: 651.95,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 36,
    rawRowText: "Totalsports Paarl Mall 0000000000000za; 651.95",
    transactionType: "expense",
    normalizedMerchant: "Totalsports Paarl Mall 0000000000000za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 651.95,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_20_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-36",
  sourceRow: $row_row_36,
  postedAt: "2025-09-28T00:00:00Z",
  description: "Totalsports Paarl Mall 0000000000000za",
  normalizedDescription: "Totalsports Paarl Mall 0000000000000za",
  amount: 651.95,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Totalsports Paarl Mall 0000000000000za",
  merchant: $merchant_totalsports_paarl_mall_0000000000000za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_10_20_row_36.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_36.id, "TransactionMerchant", $merchant_totalsports_paarl_mall_0000000000000za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_36.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_36 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-36",
  transaction: $tx_stmt_2025_10_20_row_36,
  status: "open",
  question: "What is the exact purpose of this Totalsports Paarl Mall 0000000000000za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_totalsports_paarl_mall_0000000000000za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_36.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_36.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 37
LET $row_row_37 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 37,
  postedAt: "2025-09-29T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 4000,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 37,
    rawRowText: "Electronic Payment From:Internet Banking; 4000.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 4000,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2025_10_20_row_37 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-37",
  sourceRow: $row_row_37,
  postedAt: "2025-09-29T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 4000,
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
fn::updateStatementRow($row_row_37.id, { transaction: $tx_stmt_2025_10_20_row_37.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_37.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_37.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_37.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 38
LET $row_row_38 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 38,
  postedAt: "2025-09-29T00:00:00Z",
  description: "Transfer To:Internet Banking Transfer",
  normalizedDescription: "Transfer To:Internet Banking Transfer",
  amount: 70,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 38,
    rawRowText: "Transfer To:Internet Banking Transfer; 70.00",
    transactionType: "expense",
    normalizedMerchant: "Transfer To:Internet Banking Transfer",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 70,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_20_row_38 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-38",
  sourceRow: $row_row_38,
  postedAt: "2025-09-29T00:00:00Z",
  description: "Transfer To:Internet Banking Transfer",
  normalizedDescription: "Transfer To:Internet Banking Transfer",
  amount: 70,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Transfer To:Internet Banking Transfer",
  merchant: $merchant_transfer_to_internet_banking_transfer,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_38.id, { transaction: $tx_stmt_2025_10_20_row_38.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_38.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_38.id, "TransactionMerchant", $merchant_transfer_to_internet_banking_transfer.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_38.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_38 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-38",
  transaction: $tx_stmt_2025_10_20_row_38,
  status: "open",
  question: "What is the exact purpose of this Transfer To:Internet Banking Transfer transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_transfer_to_internet_banking_transfer,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_38.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_38.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 39
LET $row_row_39 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 39,
  postedAt: "2025-09-29T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 650,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 39,
    rawRowText: "Electronic Payment From:Internet Banking; 650.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 650,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2025_10_20_row_39 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-39",
  sourceRow: $row_row_39,
  postedAt: "2025-09-29T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 650,
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
fn::updateStatementRow($row_row_39.id, { transaction: $tx_stmt_2025_10_20_row_39.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_39.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_39.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_39.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 40
LET $row_row_40 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 40,
  postedAt: "2025-09-29T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 1362.3,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 40,
    rawRowText: "The Local Choic 202880 Val De Vie E Za; 1362.30",
    transactionType: "expense",
    normalizedMerchant: "The Local Choic 202880 Val De Vie E Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1362.3,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_10_20_row_40 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-40",
  sourceRow: $row_row_40,
  postedAt: "2025-09-29T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 1362.3,
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
fn::updateStatementRow($row_row_40.id, { transaction: $tx_stmt_2025_10_20_row_40.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_40.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_40.id, "TransactionMerchant", $merchant_the_local_choic_202880_val_de_vie_e_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_40.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 41
LET $row_row_41 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 41,
  postedAt: "2025-09-30T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 43643.39,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 41,
    rawRowText: "Electronic Payment From:Internet Banking; 43643.39",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 43643.39,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2025_10_20_row_41 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-41",
  sourceRow: $row_row_41,
  postedAt: "2025-09-30T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 43643.39,
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
fn::updateStatementRow($row_row_41.id, { transaction: $tx_stmt_2025_10_20_row_41.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_41.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_41.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_41.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 42
LET $row_row_42 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 42,
  postedAt: "2025-10-01T00:00:00Z",
  description: "Yoco *Bco Taste Kitc Stellenbosch Za",
  normalizedDescription: "Yoco *Bco Taste Kitc Stellenbosch Za",
  amount: 76,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 42,
    rawRowText: "Yoco *Bco Taste Kitc Stellenbosch Za; 76.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Bco Taste Kitc Stellenbosch Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 76,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_10_20_row_42 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-42",
  sourceRow: $row_row_42,
  postedAt: "2025-10-01T00:00:00Z",
  description: "Yoco *Bco Taste Kitc Stellenbosch Za",
  normalizedDescription: "Yoco *Bco Taste Kitc Stellenbosch Za",
  amount: 76,
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
fn::updateStatementRow($row_row_42.id, { transaction: $tx_stmt_2025_10_20_row_42.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_42.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_42.id, "TransactionMerchant", $merchant_yoco_bco_taste_kitc_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_42.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 43
LET $row_row_43 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 43,
  postedAt: "2025-10-01T00:00:00Z",
  description: "I Afrihost.Com 2        Cape Town         Za",
  normalizedDescription: "Afrihost",
  amount: 1,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 43,
    rawRowText: "I Afrihost.Com 2        Cape Town         Za; 1.00",
    transactionType: "expense",
    normalizedMerchant: "Afrihost",
    category: "Business expenses paid personally / hosting / software",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Hosting or internet spend."
});
LET $tx_stmt_2025_10_20_row_43 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-43",
  sourceRow: $row_row_43,
  postedAt: "2025-10-01T00:00:00Z",
  description: "I Afrihost.Com 2        Cape Town         Za",
  normalizedDescription: "Afrihost",
  amount: 1,
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
fn::updateStatementRow($row_row_43.id, { transaction: $tx_stmt_2025_10_20_row_43.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_43.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_43.id, "TransactionMerchant", $merchant_afrihost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_43.id, "TransactionCategory", $cat_business_expenses_paid_personally_hosting_software.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 44
LET $row_row_44 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 44,
  postedAt: "2025-10-01T00:00:00Z",
  description: "I Afrihost.Com 4        Cape Town         Za",
  normalizedDescription: "I Afrihost.Com 4        Cape Town         Za",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 44,
    rawRowText: "I Afrihost.Com 4        Cape Town         Za; 419.00",
    transactionType: "expense",
    normalizedMerchant: "I Afrihost.Com 4        Cape Town         Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 419,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_20_row_44 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-44",
  sourceRow: $row_row_44,
  postedAt: "2025-10-01T00:00:00Z",
  description: "I Afrihost.Com 4        Cape Town         Za",
  normalizedDescription: "I Afrihost.Com 4        Cape Town         Za",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "I Afrihost.Com 4        Cape Town         Za",
  merchant: $merchant_i_afrihost_com_4_cape_town_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_44.id, { transaction: $tx_stmt_2025_10_20_row_44.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_44.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_44.id, "TransactionMerchant", $merchant_i_afrihost_com_4_cape_town_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_44.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_44 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-44",
  transaction: $tx_stmt_2025_10_20_row_44,
  status: "open",
  question: "What is the exact purpose of this I Afrihost.Com 4        Cape Town         Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_i_afrihost_com_4_cape_town_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_44.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_44.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 45
LET $row_row_45 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 45,
  postedAt: "2025-10-01T00:00:00Z",
  description: "Hyrotrader          Bratislava Sk",
  normalizedDescription: "HyroTrader",
  amount: 9722.72,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 45,
    rawRowText: "Hyrotrader          Bratislava Sk; 9722.72",
    transactionType: "expense",
    normalizedMerchant: "HyroTrader",
    category: "Business expenses paid personally / trading tools",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 9722.72,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Likely prop-firm or trading-service spend; confirm exact product later."
});
LET $tx_stmt_2025_10_20_row_45 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-45",
  sourceRow: $row_row_45,
  postedAt: "2025-10-01T00:00:00Z",
  description: "Hyrotrader          Bratislava Sk",
  normalizedDescription: "HyroTrader",
  amount: 9722.72,
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
fn::updateStatementRow($row_row_45.id, { transaction: $tx_stmt_2025_10_20_row_45.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_45.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_45.id, "TransactionMerchant", $merchant_hyrotrader.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_45.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_tools.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_45 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-45",
  transaction: $tx_stmt_2025_10_20_row_45,
  status: "open",
  question: "What is the exact purpose of this HyroTrader transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_hyrotrader,
  suggestedCategory: $cat_business_expenses_paid_personally_trading_tools,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_45.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_45.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 46
LET $row_row_46 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 46,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 43883.87,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 46,
    rawRowText: "Electronic Payment From:Internet Banking; 43883.87",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 43883.87,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2025_10_20_row_46 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-46",
  sourceRow: $row_row_46,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 43883.87,
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
fn::updateStatementRow($row_row_46.id, { transaction: $tx_stmt_2025_10_20_row_46.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_46.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_46.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_46.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 47
LET $row_row_47 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 47,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 1450,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 47,
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
LET $tx_stmt_2025_10_20_row_47 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-47",
  sourceRow: $row_row_47,
  postedAt: "2025-10-02T00:00:00Z",
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
fn::updateStatementRow($row_row_47.id, { transaction: $tx_stmt_2025_10_20_row_47.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_47.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_47.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_47.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 48
LET $row_row_48 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 48,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Spotifyza            Stockholm       Se",
  normalizedDescription: "Spotify",
  amount: 69.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 48,
    rawRowText: "Spotifyza            Stockholm       Se; 69.99",
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
LET $tx_stmt_2025_10_20_row_48 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-48",
  sourceRow: $row_row_48,
  postedAt: "2025-10-02T00:00:00Z",
  description: "Spotifyza            Stockholm       Se",
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
fn::updateStatementRow($row_row_48.id, { transaction: $tx_stmt_2025_10_20_row_48.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_48.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_48.id, "TransactionMerchant", $merchant_spotify.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_48.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 49
LET $row_row_49 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 49,
  postedAt: "2025-10-02T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town          Za",
  normalizedDescription: "VALR",
  amount: 2500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 49,
    rawRowText: "I Valr Pty Ltd         Cape Town          Za; 2500.00",
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
LET $tx_stmt_2025_10_20_row_49 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-49",
  sourceRow: $row_row_49,
  postedAt: "2025-10-02T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town          Za",
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
fn::updateStatementRow($row_row_49.id, { transaction: $tx_stmt_2025_10_20_row_49.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_49.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_49.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_49.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 50
LET $row_row_50 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 50,
  postedAt: "2025-10-03T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 1360,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 50,
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
LET $tx_stmt_2025_10_20_row_50 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-50",
  sourceRow: $row_row_50,
  postedAt: "2025-10-03T00:00:00Z",
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
fn::updateStatementRow($row_row_50.id, { transaction: $tx_stmt_2025_10_20_row_50.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_50.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_50.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_50.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 51
LET $row_row_51 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 51,
  postedAt: "2025-10-03T00:00:00Z",
  description: "Hyrotrader            Bratislava Sk",
  normalizedDescription: "HyroTrader",
  amount: 10827.63,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 51,
    rawRowText: "Hyrotrader            Bratislava Sk; 10827.63",
    transactionType: "expense",
    normalizedMerchant: "HyroTrader",
    category: "Business expenses paid personally / trading tools",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 10827.63,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Likely prop-firm or trading-service spend; confirm exact product later."
});
LET $tx_stmt_2025_10_20_row_51 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-51",
  sourceRow: $row_row_51,
  postedAt: "2025-10-03T00:00:00Z",
  description: "Hyrotrader            Bratislava Sk",
  normalizedDescription: "HyroTrader",
  amount: 10827.63,
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
fn::updateStatementRow($row_row_51.id, { transaction: $tx_stmt_2025_10_20_row_51.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_51.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_51.id, "TransactionMerchant", $merchant_hyrotrader.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_51.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_tools.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_51 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-51",
  transaction: $tx_stmt_2025_10_20_row_51,
  status: "open",
  question: "What is the exact purpose of this HyroTrader transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_hyrotrader,
  suggestedCategory: $cat_business_expenses_paid_personally_trading_tools,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_51.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_51.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 52
LET $row_row_52 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 52,
  postedAt: "2025-10-03T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town          Za",
  normalizedDescription: "VALR",
  amount: 1900,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 52,
    rawRowText: "I Valr Pty Ltd         Cape Town          Za; 1900.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1900,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2025_10_20_row_52 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-52",
  sourceRow: $row_row_52,
  postedAt: "2025-10-03T00:00:00Z",
  description: "I Valr Pty Ltd         Cape Town          Za",
  normalizedDescription: "VALR",
  amount: 1900,
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
fn::updateStatementRow($row_row_52.id, { transaction: $tx_stmt_2025_10_20_row_52.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_52.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_52.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_52.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 53
LET $row_row_53 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 53,
  postedAt: "2025-10-04T00:00:00Z",
  description: "Sunset B51000002213225 Western Cape Za",
  normalizedDescription: "Sunset B51000002213225 Western Cape Za",
  amount: 97,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 53,
    rawRowText: "Sunset B51000002213225 Western Cape Za; 97.00",
    transactionType: "expense",
    normalizedMerchant: "Sunset B51000002213225 Western Cape Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 97,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_20_row_53 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-53",
  sourceRow: $row_row_53,
  postedAt: "2025-10-04T00:00:00Z",
  description: "Sunset B51000002213225 Western Cape Za",
  normalizedDescription: "Sunset B51000002213225 Western Cape Za",
  amount: 97,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Sunset B51000002213225 Western Cape Za",
  merchant: $merchant_sunset_b51000002213225_western_cape_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_53.id, { transaction: $tx_stmt_2025_10_20_row_53.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_53.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_53.id, "TransactionMerchant", $merchant_sunset_b51000002213225_western_cape_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_53.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_53 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-53",
  transaction: $tx_stmt_2025_10_20_row_53,
  status: "open",
  question: "What is the exact purpose of this Sunset B51000002213225 Western Cape Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_sunset_b51000002213225_western_cape_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_53.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_53.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 54
LET $row_row_54 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 54,
  postedAt: "2025-10-04T00:00:00Z",
  description: "Giovannis Eikendal       Stellenbosch Za",
  normalizedDescription: "Giovannis Eikendal       Stellenbosch Za",
  amount: 570,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 54,
    rawRowText: "Giovannis Eikendal       Stellenbosch Za; 570.00",
    transactionType: "expense",
    normalizedMerchant: "Giovannis Eikendal       Stellenbosch Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 570,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_10_20_row_54 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-54",
  sourceRow: $row_row_54,
  postedAt: "2025-10-04T00:00:00Z",
  description: "Giovannis Eikendal       Stellenbosch Za",
  normalizedDescription: "Giovannis Eikendal       Stellenbosch Za",
  amount: 570,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Giovannis Eikendal       Stellenbosch Za",
  merchant: $merchant_giovannis_eikendal_stellenbosch_za,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_54.id, { transaction: $tx_stmt_2025_10_20_row_54.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_54.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_54.id, "TransactionMerchant", $merchant_giovannis_eikendal_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_54.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 55
LET $row_row_55 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 55,
  postedAt: "2025-10-05T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 1250,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 55,
    rawRowText: "I Valr Pty Ltd        Cape Town        Za; 1250.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1250,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2025_10_20_row_55 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-55",
  sourceRow: $row_row_55,
  postedAt: "2025-10-05T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 1250,
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
fn::updateStatementRow($row_row_55.id, { transaction: $tx_stmt_2025_10_20_row_55.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_55.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_55.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_55.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 56
LET $row_row_56 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 56,
  postedAt: "2025-10-06T00:00:00Z",
  description: "Mr D Food              Cape Town       Za",
  normalizedDescription: "Mr D Food              Cape Town       Za",
  amount: 176.45,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 56,
    rawRowText: "Mr D Food              Cape Town       Za; 176.45",
    transactionType: "expense",
    normalizedMerchant: "Mr D Food              Cape Town       Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 176.45,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_20_row_56 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-56",
  sourceRow: $row_row_56,
  postedAt: "2025-10-06T00:00:00Z",
  description: "Mr D Food              Cape Town       Za",
  normalizedDescription: "Mr D Food              Cape Town       Za",
  amount: 176.45,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Mr D Food              Cape Town       Za",
  merchant: $merchant_mr_d_food_cape_town_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_56.id, { transaction: $tx_stmt_2025_10_20_row_56.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_56.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_56.id, "TransactionMerchant", $merchant_mr_d_food_cape_town_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_56.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_56 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-56",
  transaction: $tx_stmt_2025_10_20_row_56,
  status: "open",
  question: "What is the exact purpose of this Mr D Food              Cape Town       Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mr_d_food_cape_town_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_56.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_56.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 57
LET $row_row_57 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 57,
  postedAt: "2025-10-06T00:00:00Z",
  description: "Kwikspar Paradyskloof     0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 160.03,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 57,
    rawRowText: "Kwikspar Paradyskloof     0000000000000za; 160.03",
    transactionType: "expense",
    normalizedMerchant: "Kwikspar Paradyskloof",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 160.03,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_10_20_row_57 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-57",
  sourceRow: $row_row_57,
  postedAt: "2025-10-06T00:00:00Z",
  description: "Kwikspar Paradyskloof     0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 160.03,
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
fn::updateStatementRow($row_row_57.id, { transaction: $tx_stmt_2025_10_20_row_57.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_57.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_57.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_57.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_57.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_57.id, "TransactionMerchant", $merchant_kwikspar_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_57.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 58
LET $row_row_58 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 58,
  postedAt: "2025-10-06T00:00:00Z",
  description: "Netflorist          Gauteng     Za",
  normalizedDescription: "Netflorist          Gauteng     Za",
  amount: 839.85,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 58,
    rawRowText: "Netflorist          Gauteng     Za; 839.85",
    transactionType: "expense",
    normalizedMerchant: "Netflorist          Gauteng     Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 839.85,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_20_row_58 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-58",
  sourceRow: $row_row_58,
  postedAt: "2025-10-06T00:00:00Z",
  description: "Netflorist          Gauteng     Za",
  normalizedDescription: "Netflorist          Gauteng     Za",
  amount: 839.85,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Netflorist          Gauteng     Za",
  merchant: $merchant_netflorist_gauteng_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_58.id, { transaction: $tx_stmt_2025_10_20_row_58.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_58.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_58.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_58.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_58.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_58.id, "TransactionMerchant", $merchant_netflorist_gauteng_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_58.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_58 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-58",
  transaction: $tx_stmt_2025_10_20_row_58,
  status: "open",
  question: "What is the exact purpose of this Netflorist          Gauteng     Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_netflorist_gauteng_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_58.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_58.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 59
LET $row_row_59 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 59,
  postedAt: "2025-10-06T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 1250,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 59,
    rawRowText: "I Valr Pty Ltd        Cape Town        Za; 1250.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1250,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2025_10_20_row_59 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-59",
  sourceRow: $row_row_59,
  postedAt: "2025-10-06T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 1250,
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
fn::updateStatementRow($row_row_59.id, { transaction: $tx_stmt_2025_10_20_row_59.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_59.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_59.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_59.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_59.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_59.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_59.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 60
LET $row_row_60 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 60,
  postedAt: "2025-10-07T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 800,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 60,
    rawRowText: "I Valr Pty Ltd        Cape Town        Za; 800.00",
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
LET $tx_stmt_2025_10_20_row_60 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-60",
  sourceRow: $row_row_60,
  postedAt: "2025-10-07T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
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
fn::updateStatementRow($row_row_60.id, { transaction: $tx_stmt_2025_10_20_row_60.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_60.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_60.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_60.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_60.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 61
LET $row_row_61 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 61,
  postedAt: "2025-10-07T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 1100,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 61,
    rawRowText: "I Valr Pty Ltd        Cape Town        Za; 1100.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1100,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2025_10_20_row_61 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-61",
  sourceRow: $row_row_61,
  postedAt: "2025-10-07T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 1100,
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
fn::updateStatementRow($row_row_61.id, { transaction: $tx_stmt_2025_10_20_row_61.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_61.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_61.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_61.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_61.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_61.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_61.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 62
LET $row_row_62 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 62,
  postedAt: "2025-10-08T00:00:00Z",
  description: "Hyrotrader            Bratislava Sk",
  normalizedDescription: "HyroTrader",
  amount: 10245.35,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 62,
    rawRowText: "Hyrotrader            Bratislava Sk; 10245.35",
    transactionType: "expense",
    normalizedMerchant: "HyroTrader",
    category: "Business expenses paid personally / trading tools",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 10245.35,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Likely prop-firm or trading-service spend; confirm exact product later."
});
LET $tx_stmt_2025_10_20_row_62 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-62",
  sourceRow: $row_row_62,
  postedAt: "2025-10-08T00:00:00Z",
  description: "Hyrotrader            Bratislava Sk",
  normalizedDescription: "HyroTrader",
  amount: 10245.35,
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
fn::updateStatementRow($row_row_62.id, { transaction: $tx_stmt_2025_10_20_row_62.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_62.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_62.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_62.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_62.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_62.id, "TransactionMerchant", $merchant_hyrotrader.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_62.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_tools.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_62 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-62",
  transaction: $tx_stmt_2025_10_20_row_62,
  status: "open",
  question: "What is the exact purpose of this HyroTrader transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_hyrotrader,
  suggestedCategory: $cat_business_expenses_paid_personally_trading_tools,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_62.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_62.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 63
LET $row_row_63 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 63,
  postedAt: "2025-10-08T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 63,
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
LET $tx_stmt_2025_10_20_row_63 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-63",
  sourceRow: $row_row_63,
  postedAt: "2025-10-08T00:00:00Z",
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
fn::updateStatementRow($row_row_63.id, { transaction: $tx_stmt_2025_10_20_row_63.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_63.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_63.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_63.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_63.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_63.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_63.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 64
LET $row_row_64 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 64,
  postedAt: "2025-10-08T00:00:00Z",
  description: "Vsa_Inner-Theliven.Com Limassol Cy",
  normalizedDescription: "Vsa_Inner-Theliven.Com Limassol Cy",
  amount: 233.97,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 64,
    rawRowText: "Vsa_Inner-Theliven.Com Limassol Cy; 233.97",
    transactionType: "expense",
    normalizedMerchant: "Vsa_Inner-Theliven.Com Limassol Cy",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 233.97,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_20_row_64 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-64",
  sourceRow: $row_row_64,
  postedAt: "2025-10-08T00:00:00Z",
  description: "Vsa_Inner-Theliven.Com Limassol Cy",
  normalizedDescription: "Vsa_Inner-Theliven.Com Limassol Cy",
  amount: 233.97,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Vsa_Inner-Theliven.Com Limassol Cy",
  merchant: $merchant_vsa_inner_theliven_com_limassol_cy,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_64.id, { transaction: $tx_stmt_2025_10_20_row_64.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_64.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_64.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_64.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_64.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_64.id, "TransactionMerchant", $merchant_vsa_inner_theliven_com_limassol_cy.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_64.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_64 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-64",
  transaction: $tx_stmt_2025_10_20_row_64,
  status: "open",
  question: "What is the exact purpose of this Vsa_Inner-Theliven.Com Limassol Cy transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_vsa_inner_theliven_com_limassol_cy,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_64.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_64.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 65
LET $row_row_65 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 65,
  postedAt: "2025-10-09T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 1450,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 65,
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
LET $tx_stmt_2025_10_20_row_65 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-65",
  sourceRow: $row_row_65,
  postedAt: "2025-10-09T00:00:00Z",
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
fn::updateStatementRow($row_row_65.id, { transaction: $tx_stmt_2025_10_20_row_65.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_65.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_65.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_65.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_65.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_65.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_65.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 66
LET $row_row_66 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 66,
  postedAt: "2025-10-09T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 66,
    rawRowText: "I Valr Pty Ltd        Cape Town        Za; 500.00",
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
LET $tx_stmt_2025_10_20_row_66 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-66",
  sourceRow: $row_row_66,
  postedAt: "2025-10-09T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
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
fn::updateStatementRow($row_row_66.id, { transaction: $tx_stmt_2025_10_20_row_66.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_66.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_66.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_66.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_66.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_66.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_66.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 67
LET $row_row_67 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 67,
  postedAt: "2025-10-09T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 67,
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
LET $tx_stmt_2025_10_20_row_67 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-67",
  sourceRow: $row_row_67,
  postedAt: "2025-10-09T00:00:00Z",
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
fn::updateStatementRow($row_row_67.id, { transaction: $tx_stmt_2025_10_20_row_67.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_67.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_67.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_67.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_67.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_67.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_67.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 68
LET $row_row_68 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 68,
  postedAt: "2025-10-10T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 28,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 68,
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
LET $tx_stmt_2025_10_20_row_68 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-68",
  sourceRow: $row_row_68,
  postedAt: "2025-10-10T00:00:00Z",
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
fn::updateStatementRow($row_row_68.id, { transaction: $tx_stmt_2025_10_20_row_68.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_68.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_68.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_68.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_68.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_68.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_68.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 69
LET $row_row_69 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 69,
  postedAt: "2025-10-10T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 47,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 69,
    rawRowText: "Yoco *Feedem Group T Franchhoek Za; 47.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Feedem Group T Franchhoek Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 47,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_10_20_row_69 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-69",
  sourceRow: $row_row_69,
  postedAt: "2025-10-10T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 47,
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
fn::updateStatementRow($row_row_69.id, { transaction: $tx_stmt_2025_10_20_row_69.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_69.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_69.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_69.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_69.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_69.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_69.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 70
LET $row_row_70 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 70,
  postedAt: "2025-10-10T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 2500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 70,
    rawRowText: "I Valr Pty Ltd        Cape Town        Za; 2500.00",
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
LET $tx_stmt_2025_10_20_row_70 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-70",
  sourceRow: $row_row_70,
  postedAt: "2025-10-10T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
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
fn::updateStatementRow($row_row_70.id, { transaction: $tx_stmt_2025_10_20_row_70.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_70.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_70.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_70.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_70.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_70.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_70.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 71
LET $row_row_71 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 71,
  postedAt: "2025-10-11T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 71,
    rawRowText: "I Valr Pty Ltd        Cape Town        Za; 500.00",
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
LET $tx_stmt_2025_10_20_row_71 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-71",
  sourceRow: $row_row_71,
  postedAt: "2025-10-11T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
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
fn::updateStatementRow($row_row_71.id, { transaction: $tx_stmt_2025_10_20_row_71.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_71.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_71.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_71.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_71.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_71.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_71.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 72
LET $row_row_72 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 72,
  postedAt: "2025-10-12T00:00:00Z",
  description: "Pbrands              Warsaw       Pl",
  normalizedDescription: "Pbrands              Warsaw       Pl",
  amount: 499.62,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 72,
    rawRowText: "Pbrands              Warsaw       Pl; 499.62",
    transactionType: "expense",
    normalizedMerchant: "Pbrands              Warsaw       Pl",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 499.62,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_20_row_72 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-72",
  sourceRow: $row_row_72,
  postedAt: "2025-10-12T00:00:00Z",
  description: "Pbrands              Warsaw       Pl",
  normalizedDescription: "Pbrands              Warsaw       Pl",
  amount: 499.62,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Pbrands              Warsaw       Pl",
  merchant: $merchant_pbrands_warsaw_pl,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_72.id, { transaction: $tx_stmt_2025_10_20_row_72.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_72.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_72.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_72.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_72.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_72.id, "TransactionMerchant", $merchant_pbrands_warsaw_pl.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_72.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_72 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-72",
  transaction: $tx_stmt_2025_10_20_row_72,
  status: "open",
  question: "What is the exact purpose of this Pbrands              Warsaw       Pl transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_pbrands_warsaw_pl,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_72.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_72.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 73
LET $row_row_73 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 73,
  postedAt: "2025-10-12T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 73,
    rawRowText: "I Valr Pty Ltd        Cape Town        Za; 500.00",
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
LET $tx_stmt_2025_10_20_row_73 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-73",
  sourceRow: $row_row_73,
  postedAt: "2025-10-12T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
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
fn::updateStatementRow($row_row_73.id, { transaction: $tx_stmt_2025_10_20_row_73.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_73.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_73.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_73.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_73.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_73.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_73.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 74
LET $row_row_74 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 74,
  postedAt: "2025-10-12T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 74,
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
LET $tx_stmt_2025_10_20_row_74 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-74",
  sourceRow: $row_row_74,
  postedAt: "2025-10-12T00:00:00Z",
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
fn::updateStatementRow($row_row_74.id, { transaction: $tx_stmt_2025_10_20_row_74.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_74.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_74.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_74.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_74.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_74.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_74.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 75
LET $row_row_75 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 75,
  postedAt: "2025-10-12T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 75,
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
LET $tx_stmt_2025_10_20_row_75 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-75",
  sourceRow: $row_row_75,
  postedAt: "2025-10-12T00:00:00Z",
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
fn::updateStatementRow($row_row_75.id, { transaction: $tx_stmt_2025_10_20_row_75.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_75.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_75.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_75.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_75.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_75.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_75.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 76
LET $row_row_76 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 76,
  postedAt: "2025-10-12T00:00:00Z",
  description: "Paypal *Madmusl W O14g 35314369001 Cy",
  normalizedDescription: "Paypal *Madmusl W O14g 35314369001 Cy",
  amount: 182.45,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 76,
    rawRowText: "Paypal *Madmusl W O14g 35314369001 Cy; 182.45",
    transactionType: "expense",
    normalizedMerchant: "Paypal *Madmusl W O14g 35314369001 Cy",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 182.45,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_20_row_76 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-76",
  sourceRow: $row_row_76,
  postedAt: "2025-10-12T00:00:00Z",
  description: "Paypal *Madmusl W O14g 35314369001 Cy",
  normalizedDescription: "Paypal *Madmusl W O14g 35314369001 Cy",
  amount: 182.45,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Paypal *Madmusl W O14g 35314369001 Cy",
  merchant: $merchant_paypal_madmusl_w_o14g_35314369001_cy,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_76.id, { transaction: $tx_stmt_2025_10_20_row_76.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_76.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_76.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_76.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_76.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_76.id, "TransactionMerchant", $merchant_paypal_madmusl_w_o14g_35314369001_cy.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_76.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_76 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-76",
  transaction: $tx_stmt_2025_10_20_row_76,
  status: "open",
  question: "What is the exact purpose of this Paypal *Madmusl W O14g 35314369001 Cy transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal_madmusl_w_o14g_35314369001_cy,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_76.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_76.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 77
LET $row_row_77 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 77,
  postedAt: "2025-10-13T00:00:00Z",
  description: "I Valr Pty Ltd   Cape Town Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 77,
    rawRowText: "I Valr Pty Ltd   Cape Town Za; 1000.00",
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
LET $tx_stmt_2025_10_20_row_77 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-77",
  sourceRow: $row_row_77,
  postedAt: "2025-10-13T00:00:00Z",
  description: "I Valr Pty Ltd   Cape Town Za",
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
fn::updateStatementRow($row_row_77.id, { transaction: $tx_stmt_2025_10_20_row_77.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_77.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_77.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_77.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_77.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_77.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_77.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 78
LET $row_row_78 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 78,
  postedAt: "2025-10-13T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 78,
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
LET $tx_stmt_2025_10_20_row_78 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-78",
  sourceRow: $row_row_78,
  postedAt: "2025-10-13T00:00:00Z",
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
fn::updateStatementRow($row_row_78.id, { transaction: $tx_stmt_2025_10_20_row_78.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_78.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_78.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_78.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_78.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_78.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_78.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 79
LET $row_row_79 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 79,
  postedAt: "2025-10-14T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 79,
    rawRowText: "I Valr Pty Ltd        Cape Town        Za; 500.00",
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
LET $tx_stmt_2025_10_20_row_79 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-79",
  sourceRow: $row_row_79,
  postedAt: "2025-10-14T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
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
fn::updateStatementRow($row_row_79.id, { transaction: $tx_stmt_2025_10_20_row_79.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_79.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_79.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_79.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_79.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_79.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_79.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 80
LET $row_row_80 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 80,
  postedAt: "2025-10-16T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 400,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 80,
    rawRowText: "I Valr Pty Ltd        Cape Town        Za; 400.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 400,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2025_10_20_row_80 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-80",
  sourceRow: $row_row_80,
  postedAt: "2025-10-16T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town        Za",
  normalizedDescription: "VALR",
  amount: 400,
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
fn::updateStatementRow($row_row_80.id, { transaction: $tx_stmt_2025_10_20_row_80.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_80.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_80.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_80.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_80.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_80.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_80.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 81
LET $row_row_81 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 81,
  postedAt: "2025-10-17T00:00:00Z",
  description: "Pp *Showmax             Randburg       Za",
  normalizedDescription: "Showmax",
  amount: 99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 81,
    rawRowText: "Pp *Showmax             Randburg       Za; 99.00",
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
LET $tx_stmt_2025_10_20_row_81 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-81",
  sourceRow: $row_row_81,
  postedAt: "2025-10-17T00:00:00Z",
  description: "Pp *Showmax             Randburg       Za",
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
fn::updateStatementRow($row_row_81.id, { transaction: $tx_stmt_2025_10_20_row_81.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_81.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_81.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_81.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_81.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_81.id, "TransactionMerchant", $merchant_showmax.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_81.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 82
LET $row_row_82 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 82,
  postedAt: "2025-10-18T00:00:00Z",
  description: "Str Parking Ct 104      Sea Point      Za",
  normalizedDescription: "Str Parking Ct 104      Sea Point      Za",
  amount: 20.39,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 82,
    rawRowText: "Str Parking Ct 104      Sea Point      Za; 20.39",
    transactionType: "expense",
    normalizedMerchant: "Str Parking Ct 104      Sea Point      Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 20.39,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_20_row_82 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-82",
  sourceRow: $row_row_82,
  postedAt: "2025-10-18T00:00:00Z",
  description: "Str Parking Ct 104      Sea Point      Za",
  normalizedDescription: "Str Parking Ct 104      Sea Point      Za",
  amount: 20.39,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Str Parking Ct 104      Sea Point      Za",
  merchant: $merchant_str_parking_ct_104_sea_point_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_82.id, { transaction: $tx_stmt_2025_10_20_row_82.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_82.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_82.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_82.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_82.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_82.id, "TransactionMerchant", $merchant_str_parking_ct_104_sea_point_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_82.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_82 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-82",
  transaction: $tx_stmt_2025_10_20_row_82,
  status: "open",
  question: "What is the exact purpose of this Str Parking Ct 104      Sea Point      Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_str_parking_ct_104_sea_point_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_82.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_82.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 83
LET $row_row_83 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 83,
  postedAt: "2025-10-18T00:00:00Z",
  description: "I Afrihost.Com 2       Cape Town       Za",
  normalizedDescription: "Afrihost",
  amount: 89,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 83,
    rawRowText: "I Afrihost.Com 2       Cape Town       Za; 89.00",
    transactionType: "expense",
    normalizedMerchant: "Afrihost",
    category: "Business expenses paid personally / hosting / software",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 89,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Hosting or internet spend."
});
LET $tx_stmt_2025_10_20_row_83 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-83",
  sourceRow: $row_row_83,
  postedAt: "2025-10-18T00:00:00Z",
  description: "I Afrihost.Com 2       Cape Town       Za",
  normalizedDescription: "Afrihost",
  amount: 89,
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
fn::updateStatementRow($row_row_83.id, { transaction: $tx_stmt_2025_10_20_row_83.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_83.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_83.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_83.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_83.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_83.id, "TransactionMerchant", $merchant_afrihost.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_83.id, "TransactionCategory", $cat_business_expenses_paid_personally_hosting_software.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 84
LET $row_row_84 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 84,
  postedAt: "2025-10-18T00:00:00Z",
  description: "C*Mcd Long Street        Long          Za",
  normalizedDescription: "C*Mcd Long Street        Long          Za",
  amount: 139.7,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 84,
    rawRowText: "C*Mcd Long Street        Long          Za; 139.70",
    transactionType: "expense",
    normalizedMerchant: "C*Mcd Long Street        Long          Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 139.7,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_10_20_row_84 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-84",
  sourceRow: $row_row_84,
  postedAt: "2025-10-18T00:00:00Z",
  description: "C*Mcd Long Street        Long          Za",
  normalizedDescription: "C*Mcd Long Street        Long          Za",
  amount: 139.7,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "C*Mcd Long Street        Long          Za",
  merchant: $merchant_c_mcd_long_street_long_za,
  category: $cat_dining_lifestyle,
  isTransfer: false,
  manualOverride: false,
  notes: "Dining or lifestyle spend."
});
fn::updateStatementRow($row_row_84.id, { transaction: $tx_stmt_2025_10_20_row_84.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_84.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_84.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_84.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_84.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_84.id, "TransactionMerchant", $merchant_c_mcd_long_street_long_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_84.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 85
LET $row_row_85 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 85,
  postedAt: "2025-10-18T00:00:00Z",
  description: "Ik *Museum Of Illusion Johannesburg Za",
  normalizedDescription: "Ik *Museum Of Illusion Johannesburg Za",
  amount: 450,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 85,
    rawRowText: "Ik *Museum Of Illusion Johannesburg Za; 450.00",
    transactionType: "expense",
    normalizedMerchant: "Ik *Museum Of Illusion Johannesburg Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 450,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_10_20_row_85 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-85",
  sourceRow: $row_row_85,
  postedAt: "2025-10-18T00:00:00Z",
  description: "Ik *Museum Of Illusion Johannesburg Za",
  normalizedDescription: "Ik *Museum Of Illusion Johannesburg Za",
  amount: 450,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Ik *Museum Of Illusion Johannesburg Za",
  merchant: $merchant_ik_museum_of_illusion_johannesburg_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_85.id, { transaction: $tx_stmt_2025_10_20_row_85.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_85.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_85.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_85.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_85.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_85.id, "TransactionMerchant", $merchant_ik_museum_of_illusion_johannesburg_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_85.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_10_20_row_85 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-10-20-row-85",
  transaction: $tx_stmt_2025_10_20_row_85,
  status: "open",
  question: "What is the exact purpose of this Ik *Museum Of Illusion Johannesburg Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_ik_museum_of_illusion_johannesburg_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-10-20.import.md"
});
fn::createEdge($tx_stmt_2025_10_20_row_85.id, "TransactionClarificationTasks", $task_stmt_2025_10_20_row_85.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 86
LET $row_row_86 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 86,
  postedAt: "2025-10-19T00:00:00Z",
  description: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen H 135297 Stellenbosch Za",
  amount: 60,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 86,
    rawRowText: "Blaauwklippen H 135297 Stellenbosch Za; 60.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen H 135297 Stellenbosch Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 60,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_10_20_row_86 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-86",
  sourceRow: $row_row_86,
  postedAt: "2025-10-19T00:00:00Z",
  description: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen H 135297 Stellenbosch Za",
  amount: 60,
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
fn::updateStatementRow($row_row_86.id, { transaction: $tx_stmt_2025_10_20_row_86.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_86.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_86.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_86.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_86.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_86.id, "TransactionMerchant", $merchant_blaauwklippen_h_135297_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_86.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 87
LET $row_row_87 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 87,
  postedAt: "2025-10-19T00:00:00Z",
  description: "Blaauwklippen      266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen      266384 Stellenbosch Za",
  amount: 150,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 87,
    rawRowText: "Blaauwklippen      266384 Stellenbosch Za; 150.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen      266384 Stellenbosch Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 150,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_10_20_row_87 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-87",
  sourceRow: $row_row_87,
  postedAt: "2025-10-19T00:00:00Z",
  description: "Blaauwklippen      266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen      266384 Stellenbosch Za",
  amount: 150,
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
fn::updateStatementRow($row_row_87.id, { transaction: $tx_stmt_2025_10_20_row_87.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_87.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_87.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_87.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_87.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_87.id, "TransactionMerchant", $merchant_blaauwklippen_266384_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_87.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 88
LET $row_row_88 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 88,
  postedAt: "2025-10-19T00:00:00Z",
  description: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen H 135297 Stellenbosch Za",
  amount: 70,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 88,
    rawRowText: "Blaauwklippen H 135297 Stellenbosch Za; 70.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen H 135297 Stellenbosch Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 70,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_10_20_row_88 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-88",
  sourceRow: $row_row_88,
  postedAt: "2025-10-19T00:00:00Z",
  description: "Blaauwklippen H 135297 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen H 135297 Stellenbosch Za",
  amount: 70,
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
fn::updateStatementRow($row_row_88.id, { transaction: $tx_stmt_2025_10_20_row_88.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_88.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_88.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_88.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_88.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_88.id, "TransactionMerchant", $merchant_blaauwklippen_h_135297_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_88.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 89
LET $row_row_89 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 89,
  postedAt: "2025-10-19T00:00:00Z",
  description: "Blaauwklippen      266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen      266384 Stellenbosch Za",
  amount: 55,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 89,
    rawRowText: "Blaauwklippen      266384 Stellenbosch Za; 55.00",
    transactionType: "expense",
    normalizedMerchant: "Blaauwklippen      266384 Stellenbosch Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 55,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_10_20_row_89 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-89",
  sourceRow: $row_row_89,
  postedAt: "2025-10-19T00:00:00Z",
  description: "Blaauwklippen      266384 Stellenbosch Za",
  normalizedDescription: "Blaauwklippen      266384 Stellenbosch Za",
  amount: 55,
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
fn::updateStatementRow($row_row_89.id, { transaction: $tx_stmt_2025_10_20_row_89.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_89.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_89.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_89.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_89.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_89.id, "TransactionMerchant", $merchant_blaauwklippen_266384_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_89.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 90
LET $row_row_90 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 90,
  postedAt: "2025-10-19T00:00:00Z",
  description: "Engen Paradyskloof       0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 164.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 90,
    rawRowText: "Engen Paradyskloof       0000000000000za; 164.99",
    transactionType: "expense",
    normalizedMerchant: "Engen Paradyskloof",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 164.99,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_10_20_row_90 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-90",
  sourceRow: $row_row_90,
  postedAt: "2025-10-19T00:00:00Z",
  description: "Engen Paradyskloof       0000000000000za",
  normalizedDescription: "Engen Paradyskloof",
  amount: 164.99,
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
fn::updateStatementRow($row_row_90.id, { transaction: $tx_stmt_2025_10_20_row_90.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_90.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_90.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_90.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_90.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_90.id, "TransactionMerchant", $merchant_engen_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_90.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 91
LET $row_row_91 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 91,
  postedAt: "2025-10-19T00:00:00Z",
  description: "Kwikspar Paradyskloof     0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 153.2,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/October 2025.pdf",
    statementPeriodStart: "2025-09-20",
    statementPeriodEnd: "2025-10-20",
    rowNo: 91,
    rawRowText: "Kwikspar Paradyskloof     0000000000000za; 153.20",
    transactionType: "expense",
    normalizedMerchant: "Kwikspar Paradyskloof",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 153.2,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_10_20_row_91 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-10-20-row-91",
  sourceRow: $row_row_91,
  postedAt: "2025-10-19T00:00:00Z",
  description: "Kwikspar Paradyskloof     0000000000000za",
  normalizedDescription: "Kwikspar Paradyskloof",
  amount: 153.2,
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
fn::updateStatementRow($row_row_91.id, { transaction: $tx_stmt_2025_10_20_row_91.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_91.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_91.id, "StatementRowTransactions", $tx_stmt_2025_10_20_row_91.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_10_20_row_91.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_91.id, "TransactionMerchant", $merchant_kwikspar_paradyskloof.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_10_20_row_91.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 91,
  normalizedCount: 91,
  clarificationCount: 16,
  status: "matched",
  statementDate: "2025-10-20T00:00:00Z",
  notes: "Imported from 2025-10-20.import.md"
});

-- End of generated import
