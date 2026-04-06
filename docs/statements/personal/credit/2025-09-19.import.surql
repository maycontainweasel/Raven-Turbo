-- Generated from docs/statements/personal/credit/2025-09-19.import.md
-- Source: docs/statements/personal/credit/September 2025.pdf

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
  openingBalance: 109155.89,
  active: true,
  notes: "Imported from September 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-09-19-nedbank-credit",
  sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-09-19T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_dining_lifestyle = fn::createCategory({
  space: $space,
  key: "dining-lifestyle",
  name: "Dining / lifestyle",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_groceries_household = fn::createCategory({
  space: $space,
  key: "groceries-household",
  name: "Groceries / household",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_fuel_transport = fn::createCategory({
  space: $space,
  key: "fuel-transport",
  name: "Fuel / transport",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_cash_advance = fn::createCategory({
  space: $space,
  key: "cash-advance",
  name: "Cash advance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_crypto_trading = fn::createCategory({
  space: $space,
  key: "crypto-trading",
  name: "Crypto / trading",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_subscription_media = fn::createCategory({
  space: $space,
  key: "subscription-media",
  name: "Subscription / media",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_business_expenses_paid_personally_trading_tools = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-trading-tools",
  name: "Business expenses paid personally / trading tools",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_fees_electronic_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-electronic-payment-fee",
  name: "Electronic Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_fees_declined_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-declined-payment-fee",
  name: "Declined Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_fees_credit_facility_service_fee = fn::createCategory({
  space: $space,
  key: "fees-credit-facility-service-fee",
  name: "Credit Facility Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_fees_finance_charge = fn::createCategory({
  space: $space,
  key: "fees-finance-charge",
  name: "Finance Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});

-- Merchant records
LET $merchant_nedbank_current_account = fn::createMerchant({
  space: $space,
  key: "nedbank-current-account",
  name: "Nedbank Current Account",
  normalizedName: "Nedbank Current Account",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_a_t_m_cash_advance_fee = fn::createMerchant({
  space: $space,
  key: "a-t-m-cash-advance-fee",
  name: "A T M Cash Advance Fee *",
  normalizedName: "A T M Cash Advance Fee *",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_cross_border_transaction_fee = fn::createMerchant({
  space: $space,
  key: "cross-border-transaction-fee",
  name: "Cross Border Transaction Fee",
  normalizedName: "Cross Border Transaction Fee",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_paypal_elitehost_4029357733_lu = fn::createMerchant({
  space: $space,
  key: "paypal-elitehost-4029357733-lu",
  name: "Paypal *Elitehost     4029357733 Lu",
  normalizedName: "Paypal *Elitehost     4029357733 Lu",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_transfer_to_internet_banking_transfer = fn::createMerchant({
  space: $space,
  key: "transfer-to-internet-banking-transfer",
  name: "Transfer To:Internet Banking Transfer",
  normalizedName: "Transfer To:Internet Banking Transfer",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_backs_val_de_vie = fn::createMerchant({
  space: $space,
  key: "backs-val-de-vie",
  name: "Backs Val De Vie",
  normalizedName: "Backs Val De Vie",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_the_local_choic_202880_val_de_vie_e_za = fn::createMerchant({
  space: $space,
  key: "the-local-choic-202880-val-de-vie-e-za",
  name: "The Local Choic 202880 Val De Vie E Za",
  normalizedName: "The Local Choic 202880 Val De Vie E Za",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_takealot_cape_town_za = fn::createMerchant({
  space: $space,
  key: "takealot-cape-town-za",
  name: "Takealot             Cape Town      Za",
  normalizedName: "Takealot             Cape Town      Za",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_dulce_cafe_0000000000000za = fn::createMerchant({
  space: $space,
  key: "dulce-cafe-0000000000000za",
  name: "Dulce Cafe            0000000000000za",
  normalizedName: "Dulce Cafe            0000000000000za",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_engen_wemmershoek_conv = fn::createMerchant({
  space: $space,
  key: "engen-wemmershoek-conv",
  name: "Engen Wemmershoek Conv",
  normalizedName: "Engen Wemmershoek Conv",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_yoco_feedem_group_t_franchhoek_za = fn::createMerchant({
  space: $space,
  key: "yoco-feedem-group-t-franchhoek-za",
  name: "Yoco *Feedem Group T Franchhoek Za",
  normalizedName: "Yoco *Feedem Group T Franchhoek Za",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_str_parking_ct_221_sea_point_za = fn::createMerchant({
  space: $space,
  key: "str-parking-ct-221-sea-point-za",
  name: "Str Parking Ct 221      Sea Point     Za",
  normalizedName: "Str Parking Ct 221      Sea Point     Za",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_c_dr_bruce_g_muir_cape_town_za = fn::createMerchant({
  space: $space,
  key: "c-dr-bruce-g-muir-cape-town-za",
  name: "C*Dr Bruce G Muir         Cape Town           Za",
  normalizedName: "C*Dr Bruce G Muir         Cape Town           Za",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_wwh_drakenstein_sentru = fn::createMerchant({
  space: $space,
  key: "wwh-drakenstein-sentru",
  name: "Wwh Drakenstein Sentru",
  normalizedName: "Wwh Drakenstein Sentru",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_nedbank_internet_banking = fn::createMerchant({
  space: $space,
  key: "nedbank-internet-banking",
  name: "Nedbank Internet Banking",
  normalizedName: "Nedbank Internet Banking",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_valr = fn::createMerchant({
  space: $space,
  key: "valr",
  name: "VALR",
  normalizedName: "VALR",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_playrock_176923_paarl_za = fn::createMerchant({
  space: $space,
  key: "playrock-176923-paarl-za",
  name: "Playrock         176923 Paarl        Za",
  normalizedName: "Playrock         176923 Paarl        Za",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_backs_restaurant_and_d_paarl_za = fn::createMerchant({
  space: $space,
  key: "backs-restaurant-and-d-paarl-za",
  name: "Backs Restaurant And D Paarl              Za",
  normalizedName: "Backs Restaurant And D Paarl              Za",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_i_afrihost_com_4_cape_town_za = fn::createMerchant({
  space: $space,
  key: "i-afrihost-com-4-cape-town-za",
  name: "I Afrihost.Com 4       Cape Town      Za",
  normalizedName: "I Afrihost.Com 4       Cape Town      Za",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_spotify = fn::createMerchant({
  space: $space,
  key: "spotify",
  name: "Spotify",
  normalizedName: "Spotify",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_bex_paarl_paarl_za = fn::createMerchant({
  space: $space,
  key: "bex-paarl-paarl-za",
  name: "Bex Paarl             Paarl     Za",
  normalizedName: "Bex Paarl             Paarl     Za",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_gordon_s_bay_ic_202496_cape_town_za = fn::createMerchant({
  space: $space,
  key: "gordon-s-bay-ic-202496-cape-town-za",
  name: "Gordon's Bay Ic 202496 Cape Town              Za",
  normalizedName: "Gordon's Bay Ic 202496 Cape Town              Za",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_trade_travel_chill = fn::createMerchant({
  space: $space,
  key: "trade-travel-chill",
  name: "Trade Travel Chill",
  normalizedName: "Trade Travel Chill",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_c_smw_0751_paarl_wc_za = fn::createMerchant({
  space: $space,
  key: "c-smw-0751-paarl-wc-za",
  name: "C*Smw 0751 Paarl          Wc          Za",
  normalizedName: "C*Smw 0751 Paarl          Wc          Za",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_paypal_elitehost_4029357733_lu = fn::createMerchant({
  space: $space,
  key: "paypal-elitehost-4029357733-lu",
  name: "Paypal *Elitehost      4029357733 Lu",
  normalizedName: "Paypal *Elitehost      4029357733 Lu",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});
LET $merchant_showmax = fn::createMerchant({
  space: $space,
  key: "showmax",
  name: "Showmax",
  normalizedName: "Showmax",
  active: true,
  notes: "Imported from 2025-09-19.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-08-23T00:00:00Z",
  description: "Internet Banking Transferselby        Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 31000,
  balance: 31000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 1,
    rawRowText: "Internet Banking Transferselby        Za; 31000.00 Cr",
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
LET $tx_stmt_2025_09_19_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-08-23T00:00:00Z",
  description: "Internet Banking Transferselby        Za",
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_09_19_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_01.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_01.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-08-29T00:00:00Z",
  description: "Internet Banking Transferselby        Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 18667,
  balance: 18667,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 2,
    rawRowText: "Internet Banking Transferselby        Za; 18667.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 18667,
    bankChargeZar: null,
    balanceZar: 18667
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_09_19_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-08-29T00:00:00Z",
  description: "Internet Banking Transferselby        Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 18667,
  balance: 18667,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_09_19_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_02.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_02.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-08-29T00:00:00Z",
  description: "Internet Banking Transferselby        Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 10000,
  balance: 10000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 3,
    rawRowText: "Internet Banking Transferselby        Za; 10000.00 Cr",
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
LET $tx_stmt_2025_09_19_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-08-29T00:00:00Z",
  description: "Internet Banking Transferselby        Za",
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_09_19_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_03.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_03.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-09-02T00:00:00Z",
  description: "Internet Banking Transferselby        Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2500,
  balance: 2500,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 4,
    rawRowText: "Internet Banking Transferselby        Za; 2500.00 Cr",
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
LET $tx_stmt_2025_09_19_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-09-02T00:00:00Z",
  description: "Internet Banking Transferselby        Za",
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_09_19_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_04.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_04.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-09-13T00:00:00Z",
  description: "Internet Banking Transferselby        Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2000,
  balance: 2000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 5,
    rawRowText: "Internet Banking Transferselby        Za; 2000.00 Cr",
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
LET $tx_stmt_2025_09_19_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-09-13T00:00:00Z",
  description: "Internet Banking Transferselby        Za",
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_09_19_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_05.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_05.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-09-15T00:00:00Z",
  description: "Internet Banking Transferselby        Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1000,
  balance: 1000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 6,
    rawRowText: "Internet Banking Transferselby        Za; 1000.00 Cr",
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
LET $tx_stmt_2025_09_19_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-09-15T00:00:00Z",
  description: "Internet Banking Transferselby        Za",
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_09_19_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_06.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_06.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-08-28T00:00:00Z",
  description: "A T M Cash Advance Fee *",
  normalizedDescription: "A T M Cash Advance Fee *",
  amount: 23.91,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 7,
    rawRowText: "A T M Cash Advance Fee *; 23.91",
    transactionType: "expense",
    normalizedMerchant: "A T M Cash Advance Fee *",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 23.91,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-08-28T00:00:00Z",
  description: "A T M Cash Advance Fee *",
  normalizedDescription: "A T M Cash Advance Fee *",
  amount: 23.91,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "A T M Cash Advance Fee *",
  merchant: $merchant_a_t_m_cash_advance_fee,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_09_19_row_07.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_07.id, "TransactionMerchant", $merchant_a_t_m_cash_advance_fee.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_07.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_07 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-07",
  transaction: $tx_stmt_2025_09_19_row_07,
  status: "open",
  question: "What is the exact purpose of this A T M Cash Advance Fee * transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_a_t_m_cash_advance_fee,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_07.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-08-29T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
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
LET $tx_stmt_2025_09_19_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-08-29T00:00:00Z",
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_09_19_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_08.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_08.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-09-02T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
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
LET $tx_stmt_2025_09_19_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-09-02T00:00:00Z",
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_09_19_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_09.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_09.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-09-02T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
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
LET $tx_stmt_2025_09_19_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-09-02T00:00:00Z",
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_09_19_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_10.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_10.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-09-02T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
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
LET $tx_stmt_2025_09_19_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-09-02T00:00:00Z",
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_09_19_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_11.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_11.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-09-13T00:00:00Z",
  description: "Maintenance Fee",
  normalizedDescription: "Maintenance Fee",
  amount: 38.26,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
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
LET $tx_stmt_2025_09_19_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-09-13T00:00:00Z",
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_09_19_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_12.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_12.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-09-15T00:00:00Z",
  description: "Credit Facility Service Fee",
  normalizedDescription: "Credit Facility Service Fee",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 13,
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
LET $tx_stmt_2025_09_19_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-09-15T00:00:00Z",
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_09_19_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_13.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_13.id, "TransactionCategory", $cat_fees_credit_facility_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-09-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 1852.52,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 14,
    rawRowText: "Finance Charge; 1852.52",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "finance charge",
    clarificationStatus: "clarified",
    amountZar: 1852.52,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Finance charge on the outstanding balance."
});
LET $tx_stmt_2025_09_19_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-09-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 1852.52,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_09_19_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_14.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_14.id, "TransactionCategory", $cat_fees_finance_charge.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-09-15T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 17.53,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 15,
    rawRowText: "Total V A T; 17.53",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 17.53,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "VAT on fees."
});
LET $tx_stmt_2025_09_19_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-09-15T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 17.53,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_09_19_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_15.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_15.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-09-18T00:00:00Z",
  description: "Cross Border Transaction Fee",
  normalizedDescription: "Cross Border Transaction Fee",
  amount: 10.67,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 16,
    rawRowText: "Cross Border Transaction Fee; 10.67",
    transactionType: "expense",
    normalizedMerchant: "Cross Border Transaction Fee",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 10.67,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-09-18T00:00:00Z",
  description: "Cross Border Transaction Fee",
  normalizedDescription: "Cross Border Transaction Fee",
  amount: 10.67,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_09_19_row_16.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_16.id, "TransactionMerchant", $merchant_cross_border_transaction_fee.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_16.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_16 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-16",
  transaction: $tx_stmt_2025_09_19_row_16,
  status: "open",
  question: "What is the exact purpose of this Cross Border Transaction Fee transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_cross_border_transaction_fee,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_16.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-08-18T00:00:00Z",
  description: "Paypal *Elitehost     4029357733 Lu",
  normalizedDescription: "Paypal *Elitehost     4029357733 Lu",
  amount: 476.03,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 17,
    rawRowText: "Paypal *Elitehost     4029357733 Lu; 476.03",
    transactionType: "expense",
    normalizedMerchant: "Paypal *Elitehost     4029357733 Lu",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 476.03,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-08-18T00:00:00Z",
  description: "Paypal *Elitehost     4029357733 Lu",
  normalizedDescription: "Paypal *Elitehost     4029357733 Lu",
  amount: 476.03,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Paypal *Elitehost     4029357733 Lu",
  merchant: $merchant_paypal_elitehost_4029357733_lu,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_09_19_row_17.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_17.id, "TransactionMerchant", $merchant_paypal_elitehost_4029357733_lu.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_17.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_17 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-17",
  transaction: $tx_stmt_2025_09_19_row_17,
  status: "open",
  question: "What is the exact purpose of this Paypal *Elitehost     4029357733 Lu transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal_elitehost_4029357733_lu,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_17.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-08-23T00:00:00Z",
  description: "Transfer To:Internet Banking Transfer",
  normalizedDescription: "Transfer To:Internet Banking Transfer",
  amount: 100,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 18,
    rawRowText: "Transfer To:Internet Banking Transfer; 100.00",
    transactionType: "expense",
    normalizedMerchant: "Transfer To:Internet Banking Transfer",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 100,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-08-23T00:00:00Z",
  description: "Transfer To:Internet Banking Transfer",
  normalizedDescription: "Transfer To:Internet Banking Transfer",
  amount: 100,
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_09_19_row_18.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_18.id, "TransactionMerchant", $merchant_transfer_to_internet_banking_transfer.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_18.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_18 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-18",
  transaction: $tx_stmt_2025_09_19_row_18,
  status: "open",
  question: "What is the exact purpose of this Transfer To:Internet Banking Transfer transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_transfer_to_internet_banking_transfer,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_18.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-08-23T00:00:00Z",
  description: "Yoco *Backs Val De V Paarl               Za",
  normalizedDescription: "Backs Val De Vie",
  amount: 182.65,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 19,
    rawRowText: "Yoco *Backs Val De V Paarl               Za; 182.65",
    transactionType: "expense",
    normalizedMerchant: "Backs Val De Vie",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 182.65,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining spend."
});
LET $tx_stmt_2025_09_19_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-08-23T00:00:00Z",
  description: "Yoco *Backs Val De V Paarl               Za",
  normalizedDescription: "Backs Val De Vie",
  amount: 182.65,
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
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_09_19_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_19.id, "TransactionMerchant", $merchant_backs_val_de_vie.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_19.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-08-24T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 1315.48,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 20,
    rawRowText: "The Local Choic 202880 Val De Vie E Za; 1315.48",
    transactionType: "expense",
    normalizedMerchant: "The Local Choic 202880 Val De Vie E Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1315.48,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_09_19_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-08-24T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 1315.48,
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
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_09_19_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_20.id, "TransactionMerchant", $merchant_the_local_choic_202880_val_de_vie_e_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_20.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-08-24T00:00:00Z",
  description: "Takealot             Cape Town      Za",
  normalizedDescription: "Takealot             Cape Town      Za",
  amount: 2459,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 21,
    rawRowText: "Takealot             Cape Town      Za; 2459.00",
    transactionType: "expense",
    normalizedMerchant: "Takealot             Cape Town      Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 2459,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-08-24T00:00:00Z",
  description: "Takealot             Cape Town      Za",
  normalizedDescription: "Takealot             Cape Town      Za",
  amount: 2459,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Takealot             Cape Town      Za",
  merchant: $merchant_takealot_cape_town_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_09_19_row_21.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_21.id, "TransactionMerchant", $merchant_takealot_cape_town_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_21.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_21 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-21",
  transaction: $tx_stmt_2025_09_19_row_21,
  status: "open",
  question: "What is the exact purpose of this Takealot             Cape Town      Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_takealot_cape_town_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_21.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-08-25T00:00:00Z",
  description: "Dulce Cafe            0000000000000za",
  normalizedDescription: "Dulce Cafe            0000000000000za",
  amount: 131.6,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 22,
    rawRowText: "Dulce Cafe            0000000000000za; 131.60",
    transactionType: "expense",
    normalizedMerchant: "Dulce Cafe            0000000000000za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 131.6,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-08-25T00:00:00Z",
  description: "Dulce Cafe            0000000000000za",
  normalizedDescription: "Dulce Cafe            0000000000000za",
  amount: 131.6,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Dulce Cafe            0000000000000za",
  merchant: $merchant_dulce_cafe_0000000000000za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_09_19_row_22.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_22.id, "TransactionMerchant", $merchant_dulce_cafe_0000000000000za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_22.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_22 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-22",
  transaction: $tx_stmt_2025_09_19_row_22,
  status: "open",
  question: "What is the exact purpose of this Dulce Cafe            0000000000000za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_dulce_cafe_0000000000000za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_22.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-08-25T00:00:00Z",
  description: "Engen Wemmershoek Conv 0000000000000za",
  normalizedDescription: "Engen Wemmershoek Conv",
  amount: 1337.3,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 23,
    rawRowText: "Engen Wemmershoek Conv 0000000000000za; 1337.30",
    transactionType: "expense",
    normalizedMerchant: "Engen Wemmershoek Conv",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1337.3,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_09_19_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-08-25T00:00:00Z",
  description: "Engen Wemmershoek Conv 0000000000000za",
  normalizedDescription: "Engen Wemmershoek Conv",
  amount: 1337.3,
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_09_19_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_23.id, "TransactionMerchant", $merchant_engen_wemmershoek_conv.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_23.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-08-28T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 28,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 24,
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
LET $tx_stmt_2025_09_19_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-08-28T00:00:00Z",
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
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_09_19_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_24.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_24.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-08-28T00:00:00Z",
  description: "Str Parking Ct 221      Sea Point     Za",
  normalizedDescription: "Str Parking Ct 221      Sea Point     Za",
  amount: 19.2,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 25,
    rawRowText: "Str Parking Ct 221      Sea Point     Za; 19.20",
    transactionType: "expense",
    normalizedMerchant: "Str Parking Ct 221      Sea Point     Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 19.2,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-08-28T00:00:00Z",
  description: "Str Parking Ct 221      Sea Point     Za",
  normalizedDescription: "Str Parking Ct 221      Sea Point     Za",
  amount: 19.2,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Str Parking Ct 221      Sea Point     Za",
  merchant: $merchant_str_parking_ct_221_sea_point_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_09_19_row_25.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_25.id, "TransactionMerchant", $merchant_str_parking_ct_221_sea_point_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_25.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_25 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-25",
  transaction: $tx_stmt_2025_09_19_row_25,
  status: "open",
  question: "What is the exact purpose of this Str Parking Ct 221      Sea Point     Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_str_parking_ct_221_sea_point_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_25.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-08-28T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 34,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 26,
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
LET $tx_stmt_2025_09_19_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-08-28T00:00:00Z",
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
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_09_19_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_26.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_26.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-08-28T00:00:00Z",
  description: "C*Dr Bruce G Muir         Cape Town           Za",
  normalizedDescription: "C*Dr Bruce G Muir         Cape Town           Za",
  amount: 3563,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 27,
    rawRowText: "C*Dr Bruce G Muir         Cape Town           Za; 3563.00",
    transactionType: "expense",
    normalizedMerchant: "C*Dr Bruce G Muir         Cape Town           Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 3563,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-08-28T00:00:00Z",
  description: "C*Dr Bruce G Muir         Cape Town           Za",
  normalizedDescription: "C*Dr Bruce G Muir         Cape Town           Za",
  amount: 3563,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "C*Dr Bruce G Muir         Cape Town           Za",
  merchant: $merchant_c_dr_bruce_g_muir_cape_town_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_09_19_row_27.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_27.id, "TransactionMerchant", $merchant_c_dr_bruce_g_muir_cape_town_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_27.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_27 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-27",
  transaction: $tx_stmt_2025_09_19_row_27,
  status: "open",
  question: "What is the exact purpose of this C*Dr Bruce G Muir         Cape Town           Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_c_dr_bruce_g_muir_cape_town_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_27.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-08-28T00:00:00Z",
  description: "Wwh Drakenstein Sentru 0000000000000za",
  normalizedDescription: "Wwh Drakenstein Sentru",
  amount: 422.9,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 28,
    rawRowText: "Wwh Drakenstein Sentru 0000000000000za; 422.90",
    transactionType: "expense",
    normalizedMerchant: "Wwh Drakenstein Sentru",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 422.9,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_09_19_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-08-28T00:00:00Z",
  description: "Wwh Drakenstein Sentru 0000000000000za",
  normalizedDescription: "Wwh Drakenstein Sentru",
  amount: 422.9,
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
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_09_19_row_28.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_28.id, "TransactionMerchant", $merchant_wwh_drakenstein_sentru.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_28.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-08-29T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 44608.58,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 29,
    rawRowText: "Electronic Payment From:Internet Banking; 44608.58",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 44608.58,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2025_09_19_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-08-29T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 44608.58,
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
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_09_19_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_29.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_29.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-08-29T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 30,
    rawRowText: "I Valr Pty Ltd        Cape Town      Za; 2000.00",
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
LET $tx_stmt_2025_09_19_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-08-29T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
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
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_09_19_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_30.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_30.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-08-30T00:00:00Z",
  description: "Playrock         176923 Paarl        Za",
  normalizedDescription: "Playrock         176923 Paarl        Za",
  amount: 160,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 31,
    rawRowText: "Playrock         176923 Paarl        Za; 160.00",
    transactionType: "expense",
    normalizedMerchant: "Playrock         176923 Paarl        Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 160,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-08-30T00:00:00Z",
  description: "Playrock         176923 Paarl        Za",
  normalizedDescription: "Playrock         176923 Paarl        Za",
  amount: 160,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Playrock         176923 Paarl        Za",
  merchant: $merchant_playrock_176923_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_09_19_row_31.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_31.id, "TransactionMerchant", $merchant_playrock_176923_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_31.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_31 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-31",
  transaction: $tx_stmt_2025_09_19_row_31,
  status: "open",
  question: "What is the exact purpose of this Playrock         176923 Paarl        Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_playrock_176923_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_31.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-08-30T00:00:00Z",
  description: "Playrock         176923 Paarl        Za",
  normalizedDescription: "Playrock         176923 Paarl        Za",
  amount: 110,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 32,
    rawRowText: "Playrock         176923 Paarl        Za; 110.00",
    transactionType: "expense",
    normalizedMerchant: "Playrock         176923 Paarl        Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 110,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-08-30T00:00:00Z",
  description: "Playrock         176923 Paarl        Za",
  normalizedDescription: "Playrock         176923 Paarl        Za",
  amount: 110,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Playrock         176923 Paarl        Za",
  merchant: $merchant_playrock_176923_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_09_19_row_32.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_32.id, "TransactionMerchant", $merchant_playrock_176923_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_32.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_32 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-32",
  transaction: $tx_stmt_2025_09_19_row_32,
  status: "open",
  question: "What is the exact purpose of this Playrock         176923 Paarl        Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_playrock_176923_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_32.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-08-30T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D Paarl              Za",
  amount: 160,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 33,
    rawRowText: "Backs Restaurant And D Paarl              Za; 160.00",
    transactionType: "expense",
    normalizedMerchant: "Backs Restaurant And D Paarl              Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 160,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-08-30T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D Paarl              Za",
  amount: 160,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Backs Restaurant And D Paarl              Za",
  merchant: $merchant_backs_restaurant_and_d_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_09_19_row_33.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_33.id, "TransactionMerchant", $merchant_backs_restaurant_and_d_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_33.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_33 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-33",
  transaction: $tx_stmt_2025_09_19_row_33,
  status: "open",
  question: "What is the exact purpose of this Backs Restaurant And D Paarl              Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_backs_restaurant_and_d_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_33.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-08-30T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
  normalizedDescription: "VALR",
  amount: 1100,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 34,
    rawRowText: "I Valr Pty Ltd        Cape Town      Za; 1100.00",
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
LET $tx_stmt_2025_09_19_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-08-30T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
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
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_09_19_row_34.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_34.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_34.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2025-09-01T00:00:00Z",
  description: "I Afrihost.Com 4       Cape Town      Za",
  normalizedDescription: "I Afrihost.Com 4       Cape Town      Za",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 35,
    rawRowText: "I Afrihost.Com 4       Cape Town      Za; 419.00",
    transactionType: "expense",
    normalizedMerchant: "I Afrihost.Com 4       Cape Town      Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 419,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-35",
  sourceRow: $row_row_35,
  postedAt: "2025-09-01T00:00:00Z",
  description: "I Afrihost.Com 4       Cape Town      Za",
  normalizedDescription: "I Afrihost.Com 4       Cape Town      Za",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "I Afrihost.Com 4       Cape Town      Za",
  merchant: $merchant_i_afrihost_com_4_cape_town_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_09_19_row_35.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_35.id, "TransactionMerchant", $merchant_i_afrihost_com_4_cape_town_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_35.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_35 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-35",
  transaction: $tx_stmt_2025_09_19_row_35,
  status: "open",
  question: "What is the exact purpose of this I Afrihost.Com 4       Cape Town      Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_i_afrihost_com_4_cape_town_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_35.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2025-09-01T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 36,
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
LET $tx_stmt_2025_09_19_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-36",
  sourceRow: $row_row_36,
  postedAt: "2025-09-01T00:00:00Z",
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
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_09_19_row_36.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_36.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_36.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 37
LET $row_row_37 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 37,
  postedAt: "2025-09-02T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
  normalizedDescription: "VALR",
  amount: 300,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 37,
    rawRowText: "I Valr Pty Ltd        Cape Town      Za; 300.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 300,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2025_09_19_row_37 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-37",
  sourceRow: $row_row_37,
  postedAt: "2025-09-02T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
  normalizedDescription: "VALR",
  amount: 300,
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
fn::updateStatementRow($row_row_37.id, { transaction: $tx_stmt_2025_09_19_row_37.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_37.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_37.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_37.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 38
LET $row_row_38 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 38,
  postedAt: "2025-09-04T00:00:00Z",
  description: "Spotifyza        Stockholm Se",
  normalizedDescription: "Spotify",
  amount: 64.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 38,
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
LET $tx_stmt_2025_09_19_row_38 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-38",
  sourceRow: $row_row_38,
  postedAt: "2025-09-04T00:00:00Z",
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
fn::updateStatementRow($row_row_38.id, { transaction: $tx_stmt_2025_09_19_row_38.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_38.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_38.id, "TransactionMerchant", $merchant_spotify.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_38.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 39
LET $row_row_39 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 39,
  postedAt: "2025-09-05T00:00:00Z",
  description: "Yoco *Backs Val De V Paarl    Za",
  normalizedDescription: "Backs Val De Vie",
  amount: 115.5,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 39,
    rawRowText: "Yoco *Backs Val De V Paarl    Za; 115.50",
    transactionType: "expense",
    normalizedMerchant: "Backs Val De Vie",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 115.5,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining spend."
});
LET $tx_stmt_2025_09_19_row_39 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-39",
  sourceRow: $row_row_39,
  postedAt: "2025-09-05T00:00:00Z",
  description: "Yoco *Backs Val De V Paarl    Za",
  normalizedDescription: "Backs Val De Vie",
  amount: 115.5,
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
fn::updateStatementRow($row_row_39.id, { transaction: $tx_stmt_2025_09_19_row_39.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_39.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_39.id, "TransactionMerchant", $merchant_backs_val_de_vie.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_39.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 40
LET $row_row_40 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 40,
  postedAt: "2025-09-05T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D Paarl              Za",
  amount: 340,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 40,
    rawRowText: "Backs Restaurant And D Paarl              Za; 340.00",
    transactionType: "expense",
    normalizedMerchant: "Backs Restaurant And D Paarl              Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 340,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_40 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-40",
  sourceRow: $row_row_40,
  postedAt: "2025-09-05T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D Paarl              Za",
  amount: 340,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Backs Restaurant And D Paarl              Za",
  merchant: $merchant_backs_restaurant_and_d_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_40.id, { transaction: $tx_stmt_2025_09_19_row_40.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_40.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_40.id, "TransactionMerchant", $merchant_backs_restaurant_and_d_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_40.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_40 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-40",
  transaction: $tx_stmt_2025_09_19_row_40,
  status: "open",
  question: "What is the exact purpose of this Backs Restaurant And D Paarl              Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_backs_restaurant_and_d_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_40.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_40.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 41
LET $row_row_41 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 41,
  postedAt: "2025-09-06T00:00:00Z",
  description: "Bex Paarl             Paarl     Za",
  normalizedDescription: "Bex Paarl             Paarl     Za",
  amount: 418.2,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 41,
    rawRowText: "Bex Paarl             Paarl     Za; 418.20",
    transactionType: "expense",
    normalizedMerchant: "Bex Paarl             Paarl     Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 418.2,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_41 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-41",
  sourceRow: $row_row_41,
  postedAt: "2025-09-06T00:00:00Z",
  description: "Bex Paarl             Paarl     Za",
  normalizedDescription: "Bex Paarl             Paarl     Za",
  amount: 418.2,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Bex Paarl             Paarl     Za",
  merchant: $merchant_bex_paarl_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_41.id, { transaction: $tx_stmt_2025_09_19_row_41.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_41.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_41.id, "TransactionMerchant", $merchant_bex_paarl_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_41.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_41 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-41",
  transaction: $tx_stmt_2025_09_19_row_41,
  status: "open",
  question: "What is the exact purpose of this Bex Paarl             Paarl     Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_bex_paarl_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_41.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_41.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 42
LET $row_row_42 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 42,
  postedAt: "2025-09-07T00:00:00Z",
  description: "Gordon's Bay Ic 202496 Cape Town              Za",
  normalizedDescription: "Gordon's Bay Ic 202496 Cape Town              Za",
  amount: 78,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 42,
    rawRowText: "Gordon's Bay Ic 202496 Cape Town              Za; 78.00",
    transactionType: "expense",
    normalizedMerchant: "Gordon's Bay Ic 202496 Cape Town              Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 78,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_42 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-42",
  sourceRow: $row_row_42,
  postedAt: "2025-09-07T00:00:00Z",
  description: "Gordon's Bay Ic 202496 Cape Town              Za",
  normalizedDescription: "Gordon's Bay Ic 202496 Cape Town              Za",
  amount: 78,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Gordon's Bay Ic 202496 Cape Town              Za",
  merchant: $merchant_gordon_s_bay_ic_202496_cape_town_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_42.id, { transaction: $tx_stmt_2025_09_19_row_42.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_42.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_42.id, "TransactionMerchant", $merchant_gordon_s_bay_ic_202496_cape_town_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_42.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_42 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-42",
  transaction: $tx_stmt_2025_09_19_row_42,
  status: "open",
  question: "What is the exact purpose of this Gordon's Bay Ic 202496 Cape Town              Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_gordon_s_bay_ic_202496_cape_town_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_42.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_42.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 43
LET $row_row_43 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 43,
  postedAt: "2025-09-09T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
  normalizedDescription: "VALR",
  amount: 200,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 43,
    rawRowText: "I Valr Pty Ltd        Cape Town      Za; 200.00",
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
LET $tx_stmt_2025_09_19_row_43 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-43",
  sourceRow: $row_row_43,
  postedAt: "2025-09-09T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
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
fn::updateStatementRow($row_row_43.id, { transaction: $tx_stmt_2025_09_19_row_43.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_43.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_43.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_43.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_43.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 44
LET $row_row_44 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 44,
  postedAt: "2025-09-10T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
  normalizedDescription: "VALR",
  amount: 200,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 44,
    rawRowText: "I Valr Pty Ltd        Cape Town      Za; 200.00",
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
LET $tx_stmt_2025_09_19_row_44 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-44",
  sourceRow: $row_row_44,
  postedAt: "2025-09-10T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
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
fn::updateStatementRow($row_row_44.id, { transaction: $tx_stmt_2025_09_19_row_44.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_44.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_44.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_44.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_44.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 45
LET $row_row_45 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 45,
  postedAt: "2025-09-11T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
  normalizedDescription: "VALR",
  amount: 200,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 45,
    rawRowText: "I Valr Pty Ltd        Cape Town      Za; 200.00",
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
LET $tx_stmt_2025_09_19_row_45 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-45",
  sourceRow: $row_row_45,
  postedAt: "2025-09-11T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
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
fn::updateStatementRow($row_row_45.id, { transaction: $tx_stmt_2025_09_19_row_45.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_45.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_45.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_45.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_45.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 46
LET $row_row_46 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 46,
  postedAt: "2025-09-12T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 79,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 46,
    rawRowText: "Yoco *Feedem Group T Franchhoek Za; 79.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Feedem Group T Franchhoek Za",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 79,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining or lifestyle spend."
});
LET $tx_stmt_2025_09_19_row_46 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-46",
  sourceRow: $row_row_46,
  postedAt: "2025-09-12T00:00:00Z",
  description: "Yoco *Feedem Group T Franchhoek Za",
  normalizedDescription: "Yoco *Feedem Group T Franchhoek Za",
  amount: 79,
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
fn::updateStatementRow($row_row_46.id, { transaction: $tx_stmt_2025_09_19_row_46.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_46.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_46.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_46.id, "TransactionMerchant", $merchant_yoco_feedem_group_t_franchhoek_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_46.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 47
LET $row_row_47 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 47,
  postedAt: "2025-09-12T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D Paarl              Za",
  amount: 96.6,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 47,
    rawRowText: "Backs Restaurant And D Paarl              Za; 96.60",
    transactionType: "expense",
    normalizedMerchant: "Backs Restaurant And D Paarl              Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 96.6,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_47 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-47",
  sourceRow: $row_row_47,
  postedAt: "2025-09-12T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D Paarl              Za",
  amount: 96.6,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Backs Restaurant And D Paarl              Za",
  merchant: $merchant_backs_restaurant_and_d_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_47.id, { transaction: $tx_stmt_2025_09_19_row_47.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_47.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_47.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_47.id, "TransactionMerchant", $merchant_backs_restaurant_and_d_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_47.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_47 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-47",
  transaction: $tx_stmt_2025_09_19_row_47,
  status: "open",
  question: "What is the exact purpose of this Backs Restaurant And D Paarl              Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_backs_restaurant_and_d_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_47.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_47.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 48
LET $row_row_48 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 48,
  postedAt: "2025-09-12T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D Paarl              Za",
  amount: 335,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 48,
    rawRowText: "Backs Restaurant And D Paarl              Za; 335.00",
    transactionType: "expense",
    normalizedMerchant: "Backs Restaurant And D Paarl              Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 335,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_48 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-48",
  sourceRow: $row_row_48,
  postedAt: "2025-09-12T00:00:00Z",
  description: "Backs Restaurant And D Paarl              Za",
  normalizedDescription: "Backs Restaurant And D Paarl              Za",
  amount: 335,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Backs Restaurant And D Paarl              Za",
  merchant: $merchant_backs_restaurant_and_d_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_48.id, { transaction: $tx_stmt_2025_09_19_row_48.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_48.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_48.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_48.id, "TransactionMerchant", $merchant_backs_restaurant_and_d_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_48.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_48 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-48",
  transaction: $tx_stmt_2025_09_19_row_48,
  status: "open",
  question: "What is the exact purpose of this Backs Restaurant And D Paarl              Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_backs_restaurant_and_d_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_48.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_48.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 49
LET $row_row_49 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 49,
  postedAt: "2025-09-12T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
  normalizedDescription: "VALR",
  amount: 200,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 49,
    rawRowText: "I Valr Pty Ltd        Cape Town      Za; 200.00",
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
LET $tx_stmt_2025_09_19_row_49 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-49",
  sourceRow: $row_row_49,
  postedAt: "2025-09-12T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
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
fn::updateStatementRow($row_row_49.id, { transaction: $tx_stmt_2025_09_19_row_49.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_49.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_49.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_49.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_49.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 50
LET $row_row_50 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 50,
  postedAt: "2025-09-12T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
  normalizedDescription: "VALR",
  amount: 200,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 50,
    rawRowText: "I Valr Pty Ltd        Cape Town      Za; 200.00",
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
LET $tx_stmt_2025_09_19_row_50 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-50",
  sourceRow: $row_row_50,
  postedAt: "2025-09-12T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
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
fn::updateStatementRow($row_row_50.id, { transaction: $tx_stmt_2025_09_19_row_50.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_50.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_50.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_50.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 51
LET $row_row_51 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 51,
  postedAt: "2025-09-13T00:00:00Z",
  description: "Bex Paarl             Paarl     Za",
  normalizedDescription: "Bex Paarl             Paarl     Za",
  amount: 35,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 51,
    rawRowText: "Bex Paarl             Paarl     Za; 35.00",
    transactionType: "expense",
    normalizedMerchant: "Bex Paarl             Paarl     Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 35,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_51 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-51",
  sourceRow: $row_row_51,
  postedAt: "2025-09-13T00:00:00Z",
  description: "Bex Paarl             Paarl     Za",
  normalizedDescription: "Bex Paarl             Paarl     Za",
  amount: 35,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Bex Paarl             Paarl     Za",
  merchant: $merchant_bex_paarl_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_51.id, { transaction: $tx_stmt_2025_09_19_row_51.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_51.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_51.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_51.id, "TransactionMerchant", $merchant_bex_paarl_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_51.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_51 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-51",
  transaction: $tx_stmt_2025_09_19_row_51,
  status: "open",
  question: "What is the exact purpose of this Bex Paarl             Paarl     Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_bex_paarl_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_51.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_51.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 52
LET $row_row_52 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 52,
  postedAt: "2025-09-13T00:00:00Z",
  description: "Trade Travel Chill      Abu Dhabi     Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1063.3,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 52,
    rawRowText: "Trade Travel Chill      Abu Dhabi     Ae; 1063.30",
    transactionType: "expense",
    normalizedMerchant: "Trade Travel Chill",
    category: "Business expenses paid personally / trading tools",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1063.3,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Recurring trading-indicator or trading-service spend."
});
LET $tx_stmt_2025_09_19_row_52 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-52",
  sourceRow: $row_row_52,
  postedAt: "2025-09-13T00:00:00Z",
  description: "Trade Travel Chill      Abu Dhabi     Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1063.3,
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
fn::updateStatementRow($row_row_52.id, { transaction: $tx_stmt_2025_09_19_row_52.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_52.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_52.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_52.id, "TransactionMerchant", $merchant_trade_travel_chill.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_52.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 53
LET $row_row_53 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 53,
  postedAt: "2025-09-13T00:00:00Z",
  description: "C*Smw 0751 Paarl          Wc          Za",
  normalizedDescription: "C*Smw 0751 Paarl          Wc          Za",
  amount: 349.9,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 53,
    rawRowText: "C*Smw 0751 Paarl          Wc          Za; 349.90",
    transactionType: "expense",
    normalizedMerchant: "C*Smw 0751 Paarl          Wc          Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 349.9,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_53 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-53",
  sourceRow: $row_row_53,
  postedAt: "2025-09-13T00:00:00Z",
  description: "C*Smw 0751 Paarl          Wc          Za",
  normalizedDescription: "C*Smw 0751 Paarl          Wc          Za",
  amount: 349.9,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "C*Smw 0751 Paarl          Wc          Za",
  merchant: $merchant_c_smw_0751_paarl_wc_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_53.id, { transaction: $tx_stmt_2025_09_19_row_53.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_53.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_53.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_53.id, "TransactionMerchant", $merchant_c_smw_0751_paarl_wc_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_53.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_53 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-53",
  transaction: $tx_stmt_2025_09_19_row_53,
  status: "open",
  question: "What is the exact purpose of this C*Smw 0751 Paarl          Wc          Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_c_smw_0751_paarl_wc_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_53.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_53.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 54
LET $row_row_54 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 54,
  postedAt: "2025-09-15T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
  normalizedDescription: "VALR",
  amount: 250,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 54,
    rawRowText: "I Valr Pty Ltd        Cape Town      Za; 250.00",
    transactionType: "expense",
    normalizedMerchant: "VALR",
    category: "Crypto / trading",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 250,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Crypto / trading spend."
});
LET $tx_stmt_2025_09_19_row_54 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-54",
  sourceRow: $row_row_54,
  postedAt: "2025-09-15T00:00:00Z",
  description: "I Valr Pty Ltd        Cape Town      Za",
  normalizedDescription: "VALR",
  amount: 250,
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
fn::updateStatementRow($row_row_54.id, { transaction: $tx_stmt_2025_09_19_row_54.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_54.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_54.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_54.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_54.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 55
LET $row_row_55 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 55,
  postedAt: "2025-09-16T00:00:00Z",
  description: "Paypal *Elitehost      4029357733 Lu",
  normalizedDescription: "Paypal *Elitehost      4029357733 Lu",
  amount: 57.55,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 55,
    rawRowText: "Paypal *Elitehost      4029357733 Lu; 57.55",
    transactionType: "expense",
    normalizedMerchant: "Paypal *Elitehost      4029357733 Lu",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 57.55,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_09_19_row_55 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-55",
  sourceRow: $row_row_55,
  postedAt: "2025-09-16T00:00:00Z",
  description: "Paypal *Elitehost      4029357733 Lu",
  normalizedDescription: "Paypal *Elitehost      4029357733 Lu",
  amount: 57.55,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Paypal *Elitehost      4029357733 Lu",
  merchant: $merchant_paypal_elitehost_4029357733_lu,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_55.id, { transaction: $tx_stmt_2025_09_19_row_55.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_55.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_55.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_55.id, "TransactionMerchant", $merchant_paypal_elitehost_4029357733_lu.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_55.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_09_19_row_55 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-09-19-row-55",
  transaction: $tx_stmt_2025_09_19_row_55,
  status: "open",
  question: "What is the exact purpose of this Paypal *Elitehost      4029357733 Lu transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal_elitehost_4029357733_lu,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-09-19.import.md"
});
fn::createEdge($tx_stmt_2025_09_19_row_55.id, "TransactionClarificationTasks", $task_stmt_2025_09_19_row_55.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 56
LET $row_row_56 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 56,
  postedAt: "2025-09-17T00:00:00Z",
  description: "Pp *Showmax             Randburg      Za",
  normalizedDescription: "Showmax",
  amount: 99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/September 2025.pdf",
    statementPeriodStart: "2025-08-20",
    statementPeriodEnd: "2025-09-19",
    rowNo: 56,
    rawRowText: "Pp *Showmax             Randburg      Za; 99.00",
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
LET $tx_stmt_2025_09_19_row_56 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-09-19-row-56",
  sourceRow: $row_row_56,
  postedAt: "2025-09-17T00:00:00Z",
  description: "Pp *Showmax             Randburg      Za",
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
fn::updateStatementRow($row_row_56.id, { transaction: $tx_stmt_2025_09_19_row_56.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_56.id, "StatementRowTransactions", $tx_stmt_2025_09_19_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_09_19_row_56.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_56.id, "TransactionMerchant", $merchant_showmax.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_09_19_row_56.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 56,
  normalizedCount: 56,
  clarificationCount: 20,
  status: "matched",
  statementDate: "2025-09-19T00:00:00Z",
  notes: "Imported from 2025-09-19.import.md"
});

-- End of generated import
