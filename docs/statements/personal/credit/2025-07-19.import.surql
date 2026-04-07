-- Generated from docs/statements/personal/credit/2025-07-19.import.md
-- Source: docs/statements/personal/credit/July 2025.pdf

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
  openingBalance: 111409.89,
  active: true,
  notes: "Imported from July 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-07-19-nedbank-credit",
  sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-07-19T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-07-19.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $cat_groceries_household = fn::createCategory({
  space: $space,
  key: "groceries-household",
  name: "Groceries / household",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $cat_crypto_trading = fn::createCategory({
  space: $space,
  key: "crypto-trading",
  name: "Crypto / trading",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $cat_subscription_media = fn::createCategory({
  space: $space,
  key: "subscription-media",
  name: "Subscription / media",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $cat_business_expenses_paid_personally_trading_tools = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-trading-tools",
  name: "Business expenses paid personally / trading tools",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $cat_fees_declined_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-declined-payment-fee",
  name: "Declined Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $cat_fees_credit_facility_service_fee = fn::createCategory({
  space: $space,
  key: "fees-credit-facility-service-fee",
  name: "Credit Facility Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $cat_fees_finance_charge = fn::createCategory({
  space: $space,
  key: "fees-finance-charge",
  name: "Finance Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});

-- Merchant records
LET $merchant_nedbank_current_account = fn::createMerchant({
  space: $space,
  key: "nedbank-current-account",
  name: "Nedbank Current Account",
  normalizedName: "Nedbank Current Account",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_cross_border_transaction_fee = fn::createMerchant({
  space: $space,
  key: "cross-border-transaction-fee",
  name: "Cross Border Transaction Fee",
  normalizedName: "Cross Border Transaction Fee",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_the_local_choic_202880_val_de_vie_e_za = fn::createMerchant({
  space: $space,
  key: "the-local-choic-202880-val-de-vie-e-za",
  name: "The Local Choic 202880 Val De Vie E Za",
  normalizedName: "The Local Choic 202880 Val De Vie E Za",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_backs_restaurant_and_d_paarl_za = fn::createMerchant({
  space: $space,
  key: "backs-restaurant-and-d-paarl-za",
  name: "Backs Restaurant And D Paarl     Za",
  normalizedName: "Backs Restaurant And D Paarl     Za",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_valr = fn::createMerchant({
  space: $space,
  key: "valr",
  name: "VALR",
  normalizedName: "VALR",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_rogers_hospitali9030263bel_ombre_mu = fn::createMerchant({
  space: $space,
  key: "rogers-hospitali9030263bel-ombre-mu",
  name: "Rogers Hospitali9030263bel Ombre   Mu",
  normalizedName: "Rogers Hospitali9030263bel Ombre   Mu",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_casa_pizza_2_casa_pizza_2_mu = fn::createMerchant({
  space: $space,
  key: "casa-pizza-2-casa-pizza-2-mu",
  name: "Casa Pizza 2        >Casa Pizza 2 Mu",
  normalizedName: "Casa Pizza 2        >Casa Pizza 2 Mu",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_i_afrihost_com_4_cape_town_za = fn::createMerchant({
  space: $space,
  key: "i-afrihost-com-4-cape-town-za",
  name: "I Afrihost.Com 4     Cape Town Za",
  normalizedName: "I Afrihost.Com 4     Cape Town Za",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_spotify = fn::createMerchant({
  space: $space,
  key: "spotify",
  name: "Spotify",
  normalizedName: "Spotify",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_london_supermarket_b_r_london_supermmu = fn::createMerchant({
  space: $space,
  key: "london-supermarket-b-r-london-supermmu",
  name: "London Supermarket B/R >London Supermmu",
  normalizedName: "London Supermarket B/R >London Supermmu",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_quiksilver_quiksilver_mu = fn::createMerchant({
  space: $space,
  key: "quiksilver-quiksilver-mu",
  name: "Quiksilver       >Quiksilver Mu",
  normalizedName: "Quiksilver       >Quiksilver Mu",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_living_the_food_1134634grand_baie_mu = fn::createMerchant({
  space: $space,
  key: "living-the-food-1134634grand-baie-mu",
  name: "Living The Food 1134634grand Baie Mu",
  normalizedName: "Living The Food 1134634grand Baie Mu",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_bakerlux_ltd_bakerlux_ltd_mu = fn::createMerchant({
  space: $space,
  key: "bakerlux-ltd-bakerlux-ltd-mu",
  name: "Bakerlux Ltd        >Bakerlux Ltd Mu",
  normalizedName: "Bakerlux Ltd        >Bakerlux Ltd Mu",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_trade_travel_chill = fn::createMerchant({
  space: $space,
  key: "trade-travel-chill",
  name: "Trade Travel Chill",
  normalizedName: "Trade Travel Chill",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_msf_leisure_company_ltd_msf_leisure_cmu = fn::createMerchant({
  space: $space,
  key: "msf-leisure-company-ltd-msf-leisure-cmu",
  name: "Msf Leisure Company Ltd >Msf Leisure Cmu",
  normalizedName: "Msf Leisure Company Ltd >Msf Leisure Cmu",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_emeralda_service_station_medine_mu = fn::createMerchant({
  space: $space,
  key: "emeralda-service-station-medine-mu",
  name: "Emeralda Service Station Medine   Mu",
  normalizedName: "Emeralda Service Station Medine   Mu",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});
LET $merchant_take_off_bar_plaisance_mu = fn::createMerchant({
  space: $space,
  key: "take-off-bar-plaisance-mu",
  name: "Take Off Bar         Plaisance Mu",
  normalizedName: "Take Off Bar         Plaisance Mu",
  active: true,
  notes: "Imported from 2025-07-19.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-06-24T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2000,
  balance: 2000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 1,
    rawRowText: "Internet Banking Transferselby       Za; 2000.00 Cr",
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
LET $tx_stmt_2025_07_19_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-06-24T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_07_19_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_01.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_01.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-06-25T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 13980,
  balance: 13980,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 2,
    rawRowText: "Internet Banking Transferselby       Za; 13980.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 13980,
    bankChargeZar: null,
    balanceZar: 13980
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_07_19_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-06-25T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 13980,
  balance: 13980,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_07_19_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_02.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_02.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-07-10T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 6720,
  balance: 6720,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 3,
    rawRowText: "Internet Banking Transferselby       Za; 6720.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6720,
    bankChargeZar: null,
    balanceZar: 6720
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_07_19_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-07-10T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 6720,
  balance: 6720,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_07_19_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_03.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_03.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-07-16T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1000,
  balance: 1000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 4,
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
LET $tx_stmt_2025_07_19_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-07-16T00:00:00Z",
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_07_19_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_04.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_04.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-07-16T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1100,
  balance: 1100,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 5,
    rawRowText: "Internet Banking Transferselby       Za; 1100.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1100,
    bankChargeZar: null,
    balanceZar: 1100
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_07_19_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-07-16T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1100,
  balance: 1100,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_07_19_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_05.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_05.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-07-14T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
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
LET $tx_stmt_2025_07_19_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-07-14T00:00:00Z",
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_07_19_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_06.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_06.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-07-14T00:00:00Z",
  description: "Maintenance Fee",
  normalizedDescription: "Maintenance Fee",
  amount: 38.26,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
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
LET $tx_stmt_2025_07_19_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-07-14T00:00:00Z",
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_07_19_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_07.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_07.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-07-14T00:00:00Z",
  description: "Credit Facility Service Fee",
  normalizedDescription: "Credit Facility Service Fee",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
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
LET $tx_stmt_2025_07_19_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-07-14T00:00:00Z",
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_07_19_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_08.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_08.id, "TransactionCategory", $cat_fees_credit_facility_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-07-16T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
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
LET $tx_stmt_2025_07_19_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-07-16T00:00:00Z",
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
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_07_19_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_09.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_09.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-07-16T00:00:00Z",
  description: "Declined-Insufficient Funds-Pos*",
  normalizedDescription: "Declined Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
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
LET $tx_stmt_2025_07_19_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-07-16T00:00:00Z",
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_07_19_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_10.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_10.id, "TransactionCategory", $cat_fees_declined_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-07-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 1830.03,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 11,
    rawRowText: "Finance Charge; 1830.03",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "finance charge",
    clarificationStatus: "clarified",
    amountZar: 1830.03,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Finance charge on the outstanding balance."
});
LET $tx_stmt_2025_07_19_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-07-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 1830.03,
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_07_19_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_11.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_11.id, "TransactionCategory", $cat_fees_finance_charge.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-07-16T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 12.64,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 12,
    rawRowText: "Total V A T; 12.64",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 12.64,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "VAT on fees."
});
LET $tx_stmt_2025_07_19_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-07-16T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 12.64,
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_07_19_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_12.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_12.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-07-01T00:00:00Z",
  description: "Cross Border Transaction Fee",
  normalizedDescription: "Cross Border Transaction Fee",
  amount: 81.91,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 13,
    rawRowText: "Cross Border Transaction Fee; 81.91",
    transactionType: "expense",
    normalizedMerchant: "Cross Border Transaction Fee",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 81.91,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_19_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-07-01T00:00:00Z",
  description: "Cross Border Transaction Fee",
  normalizedDescription: "Cross Border Transaction Fee",
  amount: 81.91,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_07_19_row_13.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_13.id, "TransactionMerchant", $merchant_cross_border_transaction_fee.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_13.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_19_row_13 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-19-row-13",
  transaction: $tx_stmt_2025_07_19_row_13,
  status: "open",
  question: "What is the exact purpose of this Cross Border Transaction Fee transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_cross_border_transaction_fee,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-19.import.md"
});
fn::createEdge($tx_stmt_2025_07_19_row_13.id, "TransactionClarificationTasks", $task_stmt_2025_07_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-06-24T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 49.94,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 14,
    rawRowText: "The Local Choic 202880 Val De Vie E Za; 49.94",
    transactionType: "expense",
    normalizedMerchant: "The Local Choic 202880 Val De Vie E Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 49.94,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_07_19_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-06-24T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 49.94,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_07_19_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_14.id, "TransactionMerchant", $merchant_the_local_choic_202880_val_de_vie_e_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_14.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-06-24T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 103.9,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 15,
    rawRowText: "The Local Choic 202880 Val De Vie E Za; 103.90",
    transactionType: "expense",
    normalizedMerchant: "The Local Choic 202880 Val De Vie E Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 103.9,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_07_19_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-06-24T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 103.9,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_07_19_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_15.id, "TransactionMerchant", $merchant_the_local_choic_202880_val_de_vie_e_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_15.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-06-24T00:00:00Z",
  description: "Backs Restaurant And D Paarl     Za",
  normalizedDescription: "Backs Restaurant And D Paarl     Za",
  amount: 295,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 16,
    rawRowText: "Backs Restaurant And D Paarl     Za; 295.00",
    transactionType: "expense",
    normalizedMerchant: "Backs Restaurant And D Paarl     Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 295,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_19_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-06-24T00:00:00Z",
  description: "Backs Restaurant And D Paarl     Za",
  normalizedDescription: "Backs Restaurant And D Paarl     Za",
  amount: 295,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Backs Restaurant And D Paarl     Za",
  merchant: $merchant_backs_restaurant_and_d_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_07_19_row_16.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_16.id, "TransactionMerchant", $merchant_backs_restaurant_and_d_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_16.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_19_row_16 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-19-row-16",
  transaction: $tx_stmt_2025_07_19_row_16,
  status: "open",
  question: "What is the exact purpose of this Backs Restaurant And D Paarl     Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_backs_restaurant_and_d_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-19.import.md"
});
fn::createEdge($tx_stmt_2025_07_19_row_16.id, "TransactionClarificationTasks", $task_stmt_2025_07_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-06-29T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 17,
    rawRowText: "I Valr Pty Ltd     Cape Town   Za; 2000.00",
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
LET $tx_stmt_2025_07_19_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-06-29T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town   Za",
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_07_19_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_17.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_17.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-06-30T00:00:00Z",
  description: "Rogers Hospitali9030263bel Ombre   Mu",
  normalizedDescription: "Rogers Hospitali9030263bel Ombre   Mu",
  amount: 4095.62,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 18,
    rawRowText: "Rogers Hospitali9030263bel Ombre   Mu; 4095.62",
    transactionType: "expense",
    normalizedMerchant: "Rogers Hospitali9030263bel Ombre   Mu",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 4095.62,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_19_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-06-30T00:00:00Z",
  description: "Rogers Hospitali9030263bel Ombre   Mu",
  normalizedDescription: "Rogers Hospitali9030263bel Ombre   Mu",
  amount: 4095.62,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Rogers Hospitali9030263bel Ombre   Mu",
  merchant: $merchant_rogers_hospitali9030263bel_ombre_mu,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_07_19_row_18.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_18.id, "TransactionMerchant", $merchant_rogers_hospitali9030263bel_ombre_mu.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_18.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_19_row_18 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-19-row-18",
  transaction: $tx_stmt_2025_07_19_row_18,
  status: "open",
  question: "What is the exact purpose of this Rogers Hospitali9030263bel Ombre   Mu transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_rogers_hospitali9030263bel_ombre_mu,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-19.import.md"
});
fn::createEdge($tx_stmt_2025_07_19_row_18.id, "TransactionClarificationTasks", $task_stmt_2025_07_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-06-30T00:00:00Z",
  description: "Casa Pizza 2        >Casa Pizza 2 Mu",
  normalizedDescription: "Casa Pizza 2        >Casa Pizza 2 Mu",
  amount: 1068.96,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 19,
    rawRowText: "Casa Pizza 2        >Casa Pizza 2 Mu; 1068.96",
    transactionType: "expense",
    normalizedMerchant: "Casa Pizza 2        >Casa Pizza 2 Mu",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1068.96,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_19_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-06-30T00:00:00Z",
  description: "Casa Pizza 2        >Casa Pizza 2 Mu",
  normalizedDescription: "Casa Pizza 2        >Casa Pizza 2 Mu",
  amount: 1068.96,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Casa Pizza 2        >Casa Pizza 2 Mu",
  merchant: $merchant_casa_pizza_2_casa_pizza_2_mu,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_07_19_row_19.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_19.id, "TransactionMerchant", $merchant_casa_pizza_2_casa_pizza_2_mu.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_19.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_19_row_19 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-19-row-19",
  transaction: $tx_stmt_2025_07_19_row_19,
  status: "open",
  question: "What is the exact purpose of this Casa Pizza 2        >Casa Pizza 2 Mu transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_casa_pizza_2_casa_pizza_2_mu,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-19.import.md"
});
fn::createEdge($tx_stmt_2025_07_19_row_19.id, "TransactionClarificationTasks", $task_stmt_2025_07_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-07-01T00:00:00Z",
  description: "I Afrihost.Com 4     Cape Town Za",
  normalizedDescription: "I Afrihost.Com 4     Cape Town Za",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 20,
    rawRowText: "I Afrihost.Com 4     Cape Town Za; 419.00",
    transactionType: "expense",
    normalizedMerchant: "I Afrihost.Com 4     Cape Town Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 419,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_19_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-07-01T00:00:00Z",
  description: "I Afrihost.Com 4     Cape Town Za",
  normalizedDescription: "I Afrihost.Com 4     Cape Town Za",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "I Afrihost.Com 4     Cape Town Za",
  merchant: $merchant_i_afrihost_com_4_cape_town_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_07_19_row_20.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_20.id, "TransactionMerchant", $merchant_i_afrihost_com_4_cape_town_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_20.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_19_row_20 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-19-row-20",
  transaction: $tx_stmt_2025_07_19_row_20,
  status: "open",
  question: "What is the exact purpose of this I Afrihost.Com 4     Cape Town Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_i_afrihost_com_4_cape_town_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-19.import.md"
});
fn::createEdge($tx_stmt_2025_07_19_row_20.id, "TransactionClarificationTasks", $task_stmt_2025_07_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-07-02T00:00:00Z",
  description: "Spotifyza        Stockholm Se",
  normalizedDescription: "Spotify",
  amount: 64.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 21,
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
LET $tx_stmt_2025_07_19_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-07-02T00:00:00Z",
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
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_07_19_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_21.id, "TransactionMerchant", $merchant_spotify.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_21.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-07-03T00:00:00Z",
  description: "London Supermarket B/R >London Supermmu",
  normalizedDescription: "London Supermarket B/R >London Supermmu",
  amount: 289.61,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 22,
    rawRowText: "London Supermarket B/R >London Supermmu; 289.61",
    transactionType: "expense",
    normalizedMerchant: "London Supermarket B/R >London Supermmu",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 289.61,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_19_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-07-03T00:00:00Z",
  description: "London Supermarket B/R >London Supermmu",
  normalizedDescription: "London Supermarket B/R >London Supermmu",
  amount: 289.61,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "London Supermarket B/R >London Supermmu",
  merchant: $merchant_london_supermarket_b_r_london_supermmu,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_07_19_row_22.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_22.id, "TransactionMerchant", $merchant_london_supermarket_b_r_london_supermmu.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_22.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_19_row_22 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-19-row-22",
  transaction: $tx_stmt_2025_07_19_row_22,
  status: "open",
  question: "What is the exact purpose of this London Supermarket B/R >London Supermmu transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_london_supermarket_b_r_london_supermmu,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-19.import.md"
});
fn::createEdge($tx_stmt_2025_07_19_row_22.id, "TransactionClarificationTasks", $task_stmt_2025_07_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-07-03T00:00:00Z",
  description: "Quiksilver       >Quiksilver Mu",
  normalizedDescription: "Quiksilver       >Quiksilver Mu",
  amount: 501.49,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 23,
    rawRowText: "Quiksilver       >Quiksilver Mu; 501.49",
    transactionType: "expense",
    normalizedMerchant: "Quiksilver       >Quiksilver Mu",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 501.49,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_19_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-07-03T00:00:00Z",
  description: "Quiksilver       >Quiksilver Mu",
  normalizedDescription: "Quiksilver       >Quiksilver Mu",
  amount: 501.49,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Quiksilver       >Quiksilver Mu",
  merchant: $merchant_quiksilver_quiksilver_mu,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_07_19_row_23.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_23.id, "TransactionMerchant", $merchant_quiksilver_quiksilver_mu.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_23.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_19_row_23 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-19-row-23",
  transaction: $tx_stmt_2025_07_19_row_23,
  status: "open",
  question: "What is the exact purpose of this Quiksilver       >Quiksilver Mu transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_quiksilver_quiksilver_mu,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-19.import.md"
});
fn::createEdge($tx_stmt_2025_07_19_row_23.id, "TransactionClarificationTasks", $task_stmt_2025_07_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-07-08T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 24,
    rawRowText: "I Valr Pty Ltd     Cape Town Za; 1000.00",
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
LET $tx_stmt_2025_07_19_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-07-08T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town Za",
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
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_07_19_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_24.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_24.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-07-08T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 25,
    rawRowText: "I Valr Pty Ltd     Cape Town   Za; 1000.00",
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
LET $tx_stmt_2025_07_19_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-07-08T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town   Za",
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
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_07_19_row_25.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_25.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_25.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-07-09T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 2000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 26,
    rawRowText: "I Valr Pty Ltd     Cape Town   Za; 2000.00",
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
LET $tx_stmt_2025_07_19_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-07-09T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town   Za",
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
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_07_19_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_26.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_26.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-07-10T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 27,
    rawRowText: "I Valr Pty Ltd     Cape Town   Za; 1000.00",
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
LET $tx_stmt_2025_07_19_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-07-10T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town   Za",
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
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_07_19_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_27.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_27.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-07-10T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 28,
    rawRowText: "I Valr Pty Ltd     Cape Town   Za; 1000.00",
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
LET $tx_stmt_2025_07_19_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-07-10T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town   Za",
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
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_07_19_row_28.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_28.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_28.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-07-11T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 29,
    rawRowText: "I Valr Pty Ltd     Cape Town   Za; 1000.00",
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
LET $tx_stmt_2025_07_19_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-07-11T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town   Za",
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
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_07_19_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_29.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_29.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-07-11T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town   Za",
  normalizedDescription: "VALR",
  amount: 1000,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 30,
    rawRowText: "I Valr Pty Ltd     Cape Town   Za; 1000.00",
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
LET $tx_stmt_2025_07_19_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-07-11T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town   Za",
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
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_07_19_row_30.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_30.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_30.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-07-12T00:00:00Z",
  description: "Living The Food 1134634grand Baie Mu",
  normalizedDescription: "Living The Food 1134634grand Baie Mu",
  amount: 81.84,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 31,
    rawRowText: "Living The Food 1134634grand Baie Mu; 81.84",
    transactionType: "expense",
    normalizedMerchant: "Living The Food 1134634grand Baie Mu",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 81.84,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_19_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-07-12T00:00:00Z",
  description: "Living The Food 1134634grand Baie Mu",
  normalizedDescription: "Living The Food 1134634grand Baie Mu",
  amount: 81.84,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Living The Food 1134634grand Baie Mu",
  merchant: $merchant_living_the_food_1134634grand_baie_mu,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_07_19_row_31.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_31.id, "TransactionMerchant", $merchant_living_the_food_1134634grand_baie_mu.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_31.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_19_row_31 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-19-row-31",
  transaction: $tx_stmt_2025_07_19_row_31,
  status: "open",
  question: "What is the exact purpose of this Living The Food 1134634grand Baie Mu transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_living_the_food_1134634grand_baie_mu,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-19.import.md"
});
fn::createEdge($tx_stmt_2025_07_19_row_31.id, "TransactionClarificationTasks", $task_stmt_2025_07_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-07-12T00:00:00Z",
  description: "Living The Food 1134634grand Baie Mu",
  normalizedDescription: "Living The Food 1134634grand Baie Mu",
  amount: 67.14,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 32,
    rawRowText: "Living The Food 1134634grand Baie Mu; 67.14",
    transactionType: "expense",
    normalizedMerchant: "Living The Food 1134634grand Baie Mu",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 67.14,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_19_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-07-12T00:00:00Z",
  description: "Living The Food 1134634grand Baie Mu",
  normalizedDescription: "Living The Food 1134634grand Baie Mu",
  amount: 67.14,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Living The Food 1134634grand Baie Mu",
  merchant: $merchant_living_the_food_1134634grand_baie_mu,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_07_19_row_32.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_32.id, "TransactionMerchant", $merchant_living_the_food_1134634grand_baie_mu.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_32.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_19_row_32 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-19-row-32",
  transaction: $tx_stmt_2025_07_19_row_32,
  status: "open",
  question: "What is the exact purpose of this Living The Food 1134634grand Baie Mu transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_living_the_food_1134634grand_baie_mu,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-19.import.md"
});
fn::createEdge($tx_stmt_2025_07_19_row_32.id, "TransactionClarificationTasks", $task_stmt_2025_07_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-07-12T00:00:00Z",
  description: "I Valr Pty Ltd     Cape Town Za",
  normalizedDescription: "VALR",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 33,
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
LET $tx_stmt_2025_07_19_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-07-12T00:00:00Z",
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
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_07_19_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_33.id, "TransactionMerchant", $merchant_valr.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_33.id, "TransactionCategory", $cat_crypto_trading.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-07-12T00:00:00Z",
  description: "London Supermarket B/R >London Supermmu",
  normalizedDescription: "London Supermarket B/R >London Supermmu",
  amount: 111.87,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 34,
    rawRowText: "London Supermarket B/R >London Supermmu; 111.87",
    transactionType: "expense",
    normalizedMerchant: "London Supermarket B/R >London Supermmu",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 111.87,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_19_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-07-12T00:00:00Z",
  description: "London Supermarket B/R >London Supermmu",
  normalizedDescription: "London Supermarket B/R >London Supermmu",
  amount: 111.87,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "London Supermarket B/R >London Supermmu",
  merchant: $merchant_london_supermarket_b_r_london_supermmu,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_07_19_row_34.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_34.id, "TransactionMerchant", $merchant_london_supermarket_b_r_london_supermmu.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_34.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_19_row_34 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-19-row-34",
  transaction: $tx_stmt_2025_07_19_row_34,
  status: "open",
  question: "What is the exact purpose of this London Supermarket B/R >London Supermmu transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_london_supermarket_b_r_london_supermmu,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-19.import.md"
});
fn::createEdge($tx_stmt_2025_07_19_row_34.id, "TransactionClarificationTasks", $task_stmt_2025_07_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2025-07-12T00:00:00Z",
  description: "Bakerlux Ltd        >Bakerlux Ltd Mu",
  normalizedDescription: "Bakerlux Ltd        >Bakerlux Ltd Mu",
  amount: 190.32,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 35,
    rawRowText: "Bakerlux Ltd        >Bakerlux Ltd Mu; 190.32",
    transactionType: "expense",
    normalizedMerchant: "Bakerlux Ltd        >Bakerlux Ltd Mu",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 190.32,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_19_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-35",
  sourceRow: $row_row_35,
  postedAt: "2025-07-12T00:00:00Z",
  description: "Bakerlux Ltd        >Bakerlux Ltd Mu",
  normalizedDescription: "Bakerlux Ltd        >Bakerlux Ltd Mu",
  amount: 190.32,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Bakerlux Ltd        >Bakerlux Ltd Mu",
  merchant: $merchant_bakerlux_ltd_bakerlux_ltd_mu,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_07_19_row_35.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_35.id, "TransactionMerchant", $merchant_bakerlux_ltd_bakerlux_ltd_mu.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_35.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_19_row_35 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-19-row-35",
  transaction: $tx_stmt_2025_07_19_row_35,
  status: "open",
  question: "What is the exact purpose of this Bakerlux Ltd        >Bakerlux Ltd Mu transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_bakerlux_ltd_bakerlux_ltd_mu,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-19.import.md"
});
fn::createEdge($tx_stmt_2025_07_19_row_35.id, "TransactionClarificationTasks", $task_stmt_2025_07_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2025-07-13T00:00:00Z",
  description: "Trade Travel Chill    Abu Dhabi Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1096.77,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 36,
    rawRowText: "Trade Travel Chill    Abu Dhabi Ae; 1096.77",
    transactionType: "expense",
    normalizedMerchant: "Trade Travel Chill",
    category: "Business expenses paid personally / trading tools",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1096.77,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Recurring trading-indicator or trading-service spend."
});
LET $tx_stmt_2025_07_19_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-36",
  sourceRow: $row_row_36,
  postedAt: "2025-07-13T00:00:00Z",
  description: "Trade Travel Chill    Abu Dhabi Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1096.77,
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
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_07_19_row_36.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_36.id, "TransactionMerchant", $merchant_trade_travel_chill.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_36.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 37
LET $row_row_37 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 37,
  postedAt: "2025-07-13T00:00:00Z",
  description: "Msf Leisure Company Ltd >Msf Leisure Cmu",
  normalizedDescription: "Msf Leisure Company Ltd >Msf Leisure Cmu",
  amount: 1091.22,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 37,
    rawRowText: "Msf Leisure Company Ltd >Msf Leisure Cmu; 1091.22",
    transactionType: "expense",
    normalizedMerchant: "Msf Leisure Company Ltd >Msf Leisure Cmu",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1091.22,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_19_row_37 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-37",
  sourceRow: $row_row_37,
  postedAt: "2025-07-13T00:00:00Z",
  description: "Msf Leisure Company Ltd >Msf Leisure Cmu",
  normalizedDescription: "Msf Leisure Company Ltd >Msf Leisure Cmu",
  amount: 1091.22,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Msf Leisure Company Ltd >Msf Leisure Cmu",
  merchant: $merchant_msf_leisure_company_ltd_msf_leisure_cmu,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_37.id, { transaction: $tx_stmt_2025_07_19_row_37.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_37.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_37.id, "TransactionMerchant", $merchant_msf_leisure_company_ltd_msf_leisure_cmu.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_37.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_19_row_37 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-19-row-37",
  transaction: $tx_stmt_2025_07_19_row_37,
  status: "open",
  question: "What is the exact purpose of this Msf Leisure Company Ltd >Msf Leisure Cmu transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_msf_leisure_company_ltd_msf_leisure_cmu,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-19.import.md"
});
fn::createEdge($tx_stmt_2025_07_19_row_37.id, "TransactionClarificationTasks", $task_stmt_2025_07_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 38
LET $row_row_38 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 38,
  postedAt: "2025-07-14T00:00:00Z",
  description: "Emeralda Service Station Medine   Mu",
  normalizedDescription: "Emeralda Service Station Medine   Mu",
  amount: 761.78,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 38,
    rawRowText: "Emeralda Service Station Medine   Mu; 761.78",
    transactionType: "expense",
    normalizedMerchant: "Emeralda Service Station Medine   Mu",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 761.78,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_19_row_38 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-38",
  sourceRow: $row_row_38,
  postedAt: "2025-07-14T00:00:00Z",
  description: "Emeralda Service Station Medine   Mu",
  normalizedDescription: "Emeralda Service Station Medine   Mu",
  amount: 761.78,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Emeralda Service Station Medine   Mu",
  merchant: $merchant_emeralda_service_station_medine_mu,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_38.id, { transaction: $tx_stmt_2025_07_19_row_38.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_38.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_38.id, "TransactionMerchant", $merchant_emeralda_service_station_medine_mu.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_38.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_19_row_38 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-19-row-38",
  transaction: $tx_stmt_2025_07_19_row_38,
  status: "open",
  question: "What is the exact purpose of this Emeralda Service Station Medine   Mu transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_emeralda_service_station_medine_mu,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-19.import.md"
});
fn::createEdge($tx_stmt_2025_07_19_row_38.id, "TransactionClarificationTasks", $task_stmt_2025_07_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 39
LET $row_row_39 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 39,
  postedAt: "2025-07-14T00:00:00Z",
  description: "Take Off Bar         Plaisance Mu",
  normalizedDescription: "Take Off Bar         Plaisance Mu",
  amount: 169.17,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/July 2025.pdf",
    statementPeriodStart: "2025-06-20",
    statementPeriodEnd: "2025-07-19",
    rowNo: 39,
    rawRowText: "Take Off Bar         Plaisance Mu; 169.17",
    transactionType: "expense",
    normalizedMerchant: "Take Off Bar         Plaisance Mu",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 169.17,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_19_row_39 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-19-row-39",
  sourceRow: $row_row_39,
  postedAt: "2025-07-14T00:00:00Z",
  description: "Take Off Bar         Plaisance Mu",
  normalizedDescription: "Take Off Bar         Plaisance Mu",
  amount: 169.17,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Take Off Bar         Plaisance Mu",
  merchant: $merchant_take_off_bar_plaisance_mu,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_39.id, { transaction: $tx_stmt_2025_07_19_row_39.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_39.id, "StatementRowTransactions", $tx_stmt_2025_07_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_39.id, "TransactionMerchant", $merchant_take_off_bar_plaisance_mu.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_19_row_39.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_19_row_39 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-19-row-39",
  transaction: $tx_stmt_2025_07_19_row_39,
  status: "open",
  question: "What is the exact purpose of this Take Off Bar         Plaisance Mu transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_take_off_bar_plaisance_mu,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-19.import.md"
});
fn::createEdge($tx_stmt_2025_07_19_row_39.id, "TransactionClarificationTasks", $task_stmt_2025_07_19_row_39.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 39,
  normalizedCount: 39,
  clarificationCount: 14,
  status: "matched",
  statementDate: "2025-07-19T00:00:00Z",
  notes: "Imported from 2025-07-19.import.md"
});

-- End of generated import
