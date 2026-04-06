-- Generated from docs/statements/personal/credit/2025-08-19.import.md
-- Source: docs/statements/personal/credit/August 2025.pdf

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
  openingBalance: 109577.42,
  active: true,
  notes: "Imported from August 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-08-19-nedbank-credit",
  sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-08-19T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_foreign_account_funding = fn::createCategory({
  space: $space,
  key: "foreign-account-funding",
  name: "Foreign account funding",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_groceries_household = fn::createCategory({
  space: $space,
  key: "groceries-household",
  name: "Groceries / household",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_subscription_media = fn::createCategory({
  space: $space,
  key: "subscription-media",
  name: "Subscription / media",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_cash_advance = fn::createCategory({
  space: $space,
  key: "cash-advance",
  name: "Cash advance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_dining_lifestyle = fn::createCategory({
  space: $space,
  key: "dining-lifestyle",
  name: "Dining / lifestyle",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_fuel_transport = fn::createCategory({
  space: $space,
  key: "fuel-transport",
  name: "Fuel / transport",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_business_expenses_paid_personally_trading_tools = fn::createCategory({
  space: $space,
  key: "business-expenses-paid-personally-trading-tools",
  name: "Business expenses paid personally / trading tools",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_fees_electronic_payment_fee = fn::createCategory({
  space: $space,
  key: "fees-electronic-payment-fee",
  name: "Electronic Payment Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_fees_credit_facility_service_fee = fn::createCategory({
  space: $space,
  key: "fees-credit-facility-service-fee",
  name: "Credit Facility Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_fees_finance_charge = fn::createCategory({
  space: $space,
  key: "fees-finance-charge",
  name: "Finance Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});

-- Merchant records
LET $merchant_a_p_o_payment_thank_you = fn::createMerchant({
  space: $space,
  key: "a-p-o-payment-thank-you",
  name: "A P O Payment - Thank You",
  normalizedName: "A P O Payment - Thank You",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_000000000000001322_apo_reversal_no_funds_available = fn::createMerchant({
  space: $space,
  key: "000000000000001322-apo-reversal-no-funds-available",
  name: "000000000000001322     Apo Reversal - No Funds Available",
  normalizedName: "000000000000001322     Apo Reversal - No Funds Available",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_nedbank_current_account = fn::createMerchant({
  space: $space,
  key: "nedbank-current-account",
  name: "Nedbank Current Account",
  normalizedName: "Nedbank Current Account",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_returned_apo_fee = fn::createMerchant({
  space: $space,
  key: "returned-apo-fee",
  name: "Returned Apo Fee *",
  normalizedName: "Returned Apo Fee *",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_yoco_stompies_wood_paarl_za = fn::createMerchant({
  space: $space,
  key: "yoco-stompies-wood-paarl-za",
  name: "Yoco *Stompies Wood        Paarl        Za",
  normalizedName: "Yoco *Stompies Wood        Paarl        Za",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_wise = fn::createMerchant({
  space: $space,
  key: "wise",
  name: "Wise",
  normalizedName: "Wise",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_sorbet_drakenst_202132_paarl_za = fn::createMerchant({
  space: $space,
  key: "sorbet-drakenst-202132-paarl-za",
  name: "Sorbet Drakenst 202132 Paarl            Za",
  normalizedName: "Sorbet Drakenst 202132 Paarl            Za",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_woolworths_paarl_za = fn::createMerchant({
  space: $space,
  key: "woolworths-paarl-za",
  name: "Woolworths             Paarl       Za",
  normalizedName: "Woolworths             Paarl       Za",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_i_afrihost_com_4_cape_town_za = fn::createMerchant({
  space: $space,
  key: "i-afrihost-com-4-cape-town-za",
  name: "I Afrihost.Com 4        Cape Town       Za",
  normalizedName: "I Afrihost.Com 4        Cape Town       Za",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_backs_restaurant_and_d_paarl_za = fn::createMerchant({
  space: $space,
  key: "backs-restaurant-and-d-paarl-za",
  name: "Backs Restaurant And D Paarl             Za",
  normalizedName: "Backs Restaurant And D Paarl             Za",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_spotify = fn::createMerchant({
  space: $space,
  key: "spotify",
  name: "Spotify",
  normalizedName: "Spotify",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_nedbank_internet_banking = fn::createMerchant({
  space: $space,
  key: "nedbank-internet-banking",
  name: "Nedbank Internet Banking",
  normalizedName: "Nedbank Internet Banking",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_the_local_choic_202880_val_de_vie_e_za = fn::createMerchant({
  space: $space,
  key: "the-local-choic-202880-val-de-vie-e-za",
  name: "The Local Choic 202880 Val De Vie E Za",
  normalizedName: "The Local Choic 202880 Val De Vie E Za",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_backs_val_de_vie = fn::createMerchant({
  space: $space,
  key: "backs-val-de-vie",
  name: "Backs Val De Vie",
  normalizedName: "Backs Val De Vie",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_engen_wemmershoek_conv = fn::createMerchant({
  space: $space,
  key: "engen-wemmershoek-conv",
  name: "Engen Wemmershoek Conv",
  normalizedName: "Engen Wemmershoek Conv",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_c_total_ninja_black_riv_cape_town_za = fn::createMerchant({
  space: $space,
  key: "c-total-ninja-black-riv-cape-town-za",
  name: "C*Total Ninja Black Riv *Cape Town            Za",
  normalizedName: "C*Total Ninja Black Riv *Cape Town            Za",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_dis_chem_paarl_paarl_za = fn::createMerchant({
  space: $space,
  key: "dis-chem-paarl-paarl-za",
  name: "Dis-Chem Paarl          Paarl       Za",
  normalizedName: "Dis-Chem Paarl          Paarl       Za",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_trade_travel_chill = fn::createMerchant({
  space: $space,
  key: "trade-travel-chill",
  name: "Trade Travel Chill",
  normalizedName: "Trade Travel Chill",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_i_checkers_sixty60_cape_town_za = fn::createMerchant({
  space: $space,
  key: "i-checkers-sixty60-cape-town-za",
  name: "I Checkers Sixty60      Cape Town        Za",
  normalizedName: "I Checkers Sixty60      Cape Town        Za",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_showmax = fn::createMerchant({
  space: $space,
  key: "showmax",
  name: "Showmax",
  normalizedName: "Showmax",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_alana_banana_pty_ltd_stellenbosch_za = fn::createMerchant({
  space: $space,
  key: "alana-banana-pty-ltd-stellenbosch-za",
  name: "Alana Banana Pty Ltd       Stellenbosch Za",
  normalizedName: "Alana Banana Pty Ltd       Stellenbosch Za",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});
LET $merchant_giraffe_world_muldersvlei_za = fn::createMerchant({
  space: $space,
  key: "giraffe-world-muldersvlei-za",
  name: "Giraffe World          Muldersvlei Za",
  normalizedName: "Giraffe World          Muldersvlei Za",
  active: true,
  notes: "Imported from 2025-08-19.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-07-30T00:00:00Z",
  description: "A P O Payment - Thank You",
  normalizedDescription: "A P O Payment - Thank You",
  amount: 1970,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 1,
    rawRowText: "A P O Payment - Thank You; 1970.00",
    transactionType: "expense",
    normalizedMerchant: "A P O Payment - Thank You",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1970,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-07-30T00:00:00Z",
  description: "A P O Payment - Thank You",
  normalizedDescription: "A P O Payment - Thank You",
  amount: 1970,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "A P O Payment - Thank You",
  merchant: $merchant_a_p_o_payment_thank_you,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_08_19_row_01.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_01.id, "TransactionMerchant", $merchant_a_p_o_payment_thank_you.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_01.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_01 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-01",
  transaction: $tx_stmt_2025_08_19_row_01,
  status: "open",
  question: "What exactly is the Magtape Unpaid / Not Provided For reversal?",
  reason: "Returned item / reversal needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_a_p_o_payment_thank_you,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_01.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-08-01T00:00:00Z",
  description: "000000000000001322     Apo Reversal - No Funds Available",
  normalizedDescription: "000000000000001322     Apo Reversal - No Funds Available",
  amount: 1970,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 2,
    rawRowText: "000000000000001322     Apo Reversal - No Funds Available; 1970.00",
    transactionType: "expense",
    normalizedMerchant: "000000000000001322     Apo Reversal - No Funds Available",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1970,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-08-01T00:00:00Z",
  description: "000000000000001322     Apo Reversal - No Funds Available",
  normalizedDescription: "000000000000001322     Apo Reversal - No Funds Available",
  amount: 1970,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "000000000000001322     Apo Reversal - No Funds Available",
  merchant: $merchant_000000000000001322_apo_reversal_no_funds_available,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_08_19_row_02.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_02.id, "TransactionMerchant", $merchant_000000000000001322_apo_reversal_no_funds_available.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_02.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_02 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-02",
  transaction: $tx_stmt_2025_08_19_row_02,
  status: "open",
  question: "What is the exact purpose of this 000000000000001322     Apo Reversal - No Funds Available transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_000000000000001322_apo_reversal_no_funds_available,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_02.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-07-25T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 3500,
  balance: 3500,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
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
LET $tx_stmt_2025_08_19_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-07-25T00:00:00Z",
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_08_19_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_03.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_03.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-08-02T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2700,
  balance: 2700,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 4,
    rawRowText: "Internet Banking Transferselby       Za; 2700.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2700,
    bankChargeZar: null,
    balanceZar: 2700
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_08_19_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-08-02T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2700,
  balance: 2700,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_08_19_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_04.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_04.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-08-04T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1973,
  balance: 1973,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 5,
    rawRowText: "Internet Banking Transferselby       Za; 1973.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1973,
    bankChargeZar: null,
    balanceZar: 1973
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_08_19_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-08-04T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1973,
  balance: 1973,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_08_19_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_05.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_05.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-08-13T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 2000,
  balance: 2000,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 6,
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
LET $tx_stmt_2025_08_19_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-08-13T00:00:00Z",
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_08_19_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_06.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_06.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-08-13T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1680,
  balance: 1680,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 7,
    rawRowText: "Internet Banking Transferselby       Za; 1680.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1680,
    bankChargeZar: null,
    balanceZar: 1680
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_08_19_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-08-13T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 1680,
  balance: 1680,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_08_19_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_07.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_07.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-08-15T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 4045,
  balance: 4045,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 8,
    rawRowText: "Internet Banking Transferselby       Za; 4045.00 Cr",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 4045,
    bankChargeZar: null,
    balanceZar: 4045
},
  notes: "Payment received from personal current account."
});
LET $tx_stmt_2025_08_19_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-08-15T00:00:00Z",
  description: "Internet Banking Transferselby       Za",
  normalizedDescription: "Nedbank Current Account",
  amount: 4045,
  balance: 4045,
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
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_08_19_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_08.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_08.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-08-01T00:00:00Z",
  description: "Returned Apo Fee *",
  normalizedDescription: "Returned Apo Fee *",
  amount: 26.09,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 9,
    rawRowText: "Returned Apo Fee *; 26.09",
    transactionType: "expense",
    normalizedMerchant: "Returned Apo Fee *",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 26.09,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-08-01T00:00:00Z",
  description: "Returned Apo Fee *",
  normalizedDescription: "Returned Apo Fee *",
  amount: 26.09,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Returned Apo Fee *",
  merchant: $merchant_returned_apo_fee,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_08_19_row_09.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_09.id, "TransactionMerchant", $merchant_returned_apo_fee.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_09.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_09 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-09",
  transaction: $tx_stmt_2025_08_19_row_09,
  status: "open",
  question: "What is the exact purpose of this Returned Apo Fee * transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_returned_apo_fee,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_09.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-08-04T00:00:00Z",
  description: "Electronic Payment Fee *",
  normalizedDescription: "Electronic Payment Fee",
  amount: 8.69,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
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
LET $tx_stmt_2025_08_19_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-08-04T00:00:00Z",
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_08_19_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_10.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_10.id, "TransactionCategory", $cat_fees_electronic_payment_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-08-13T00:00:00Z",
  description: "Maintenance Fee",
  normalizedDescription: "Maintenance Fee",
  amount: 38.26,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
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
LET $tx_stmt_2025_08_19_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-08-13T00:00:00Z",
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_08_19_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_11.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_11.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-08-14T00:00:00Z",
  description: "Credit Facility Service Fee",
  normalizedDescription: "Credit Facility Service Fee",
  amount: 20,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
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
LET $tx_stmt_2025_08_19_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-08-14T00:00:00Z",
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_08_19_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_12.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_12.id, "TransactionCategory", $cat_fees_credit_facility_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-08-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 1922.36,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 13,
    rawRowText: "Finance Charge; 1922.36",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "finance charge",
    clarificationStatus: "clarified",
    amountZar: 1922.36,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Finance charge on the outstanding balance."
});
LET $tx_stmt_2025_08_19_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-08-19T00:00:00Z",
  description: "Finance Charge",
  normalizedDescription: "Finance Charge",
  amount: 1922.36,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_08_19_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_13.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_13.id, "TransactionCategory", $cat_fees_finance_charge.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-08-14T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 13.95,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 14,
    rawRowText: "Total V A T; 13.95",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 13.95,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "VAT on fees."
});
LET $tx_stmt_2025_08_19_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-08-14T00:00:00Z",
  description: "Total V A T",
  normalizedDescription: "Vat On Fees",
  amount: 13.95,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_08_19_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_14.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_14.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-07-25T00:00:00Z",
  description: "Yoco *Stompies Wood        Paarl        Za",
  normalizedDescription: "Yoco *Stompies Wood        Paarl        Za",
  amount: 600,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 15,
    rawRowText: "Yoco *Stompies Wood        Paarl        Za; 600.00",
    transactionType: "expense",
    normalizedMerchant: "Yoco *Stompies Wood        Paarl        Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 600,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-07-25T00:00:00Z",
  description: "Yoco *Stompies Wood        Paarl        Za",
  normalizedDescription: "Yoco *Stompies Wood        Paarl        Za",
  amount: 600,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Yoco *Stompies Wood        Paarl        Za",
  merchant: $merchant_yoco_stompies_wood_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_08_19_row_15.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_15.id, "TransactionMerchant", $merchant_yoco_stompies_wood_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_15.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_15 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-15",
  transaction: $tx_stmt_2025_08_19_row_15,
  status: "open",
  question: "What is the exact purpose of this Yoco *Stompies Wood        Paarl        Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_yoco_stompies_wood_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_15.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-07-26T00:00:00Z",
  description: "Wise             London    Gb",
  normalizedDescription: "Wise",
  amount: 523.5,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 16,
    rawRowText: "Wise             London    Gb; 523.50",
    transactionType: "transfer",
    normalizedMerchant: "Wise",
    category: "Foreign account funding",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 523.5,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Transfer via Wise to fund the UK account."
});
LET $tx_stmt_2025_08_19_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-07-26T00:00:00Z",
  description: "Wise             London    Gb",
  normalizedDescription: "Wise",
  amount: 523.5,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_08_19_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_16.id, "TransactionMerchant", $merchant_wise.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_16.id, "TransactionCategory", $cat_foreign_account_funding.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-07-30T00:00:00Z",
  description: "Sorbet Drakenst 202132 Paarl            Za",
  normalizedDescription: "Sorbet Drakenst 202132 Paarl            Za",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 17,
    rawRowText: "Sorbet Drakenst 202132 Paarl            Za; 500.00",
    transactionType: "expense",
    normalizedMerchant: "Sorbet Drakenst 202132 Paarl            Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 500,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-07-30T00:00:00Z",
  description: "Sorbet Drakenst 202132 Paarl            Za",
  normalizedDescription: "Sorbet Drakenst 202132 Paarl            Za",
  amount: 500,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Sorbet Drakenst 202132 Paarl            Za",
  merchant: $merchant_sorbet_drakenst_202132_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_08_19_row_17.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_17.id, "TransactionMerchant", $merchant_sorbet_drakenst_202132_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_17.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_17 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-17",
  transaction: $tx_stmt_2025_08_19_row_17,
  status: "open",
  question: "What is the exact purpose of this Sorbet Drakenst 202132 Paarl            Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_sorbet_drakenst_202132_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_17.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_17.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-07-30T00:00:00Z",
  description: "Woolworths             Paarl       Za",
  normalizedDescription: "Woolworths             Paarl       Za",
  amount: 1004.95,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 18,
    rawRowText: "Woolworths             Paarl       Za; 1004.95",
    transactionType: "expense",
    normalizedMerchant: "Woolworths             Paarl       Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1004.95,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_08_19_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-07-30T00:00:00Z",
  description: "Woolworths             Paarl       Za",
  normalizedDescription: "Woolworths             Paarl       Za",
  amount: 1004.95,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Woolworths             Paarl       Za",
  merchant: $merchant_woolworths_paarl_za,
  category: $cat_groceries_household,
  isTransfer: false,
  manualOverride: false,
  notes: "Grocery or household spend."
});
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_08_19_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_18.id, "TransactionMerchant", $merchant_woolworths_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_18.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-08-01T00:00:00Z",
  description: "I Afrihost.Com 4        Cape Town       Za",
  normalizedDescription: "I Afrihost.Com 4        Cape Town       Za",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 19,
    rawRowText: "I Afrihost.Com 4        Cape Town       Za; 419.00",
    transactionType: "expense",
    normalizedMerchant: "I Afrihost.Com 4        Cape Town       Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 419,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-08-01T00:00:00Z",
  description: "I Afrihost.Com 4        Cape Town       Za",
  normalizedDescription: "I Afrihost.Com 4        Cape Town       Za",
  amount: 419,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "I Afrihost.Com 4        Cape Town       Za",
  merchant: $merchant_i_afrihost_com_4_cape_town_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_08_19_row_19.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_19.id, "TransactionMerchant", $merchant_i_afrihost_com_4_cape_town_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_19.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_19 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-19",
  transaction: $tx_stmt_2025_08_19_row_19,
  status: "open",
  question: "What is the exact purpose of this I Afrihost.Com 4        Cape Town       Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_i_afrihost_com_4_cape_town_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_19.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_19.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-08-01T00:00:00Z",
  description: "Backs Restaurant And D Paarl             Za",
  normalizedDescription: "Backs Restaurant And D Paarl             Za",
  amount: 303,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 20,
    rawRowText: "Backs Restaurant And D Paarl             Za; 303.00",
    transactionType: "expense",
    normalizedMerchant: "Backs Restaurant And D Paarl             Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 303,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-08-01T00:00:00Z",
  description: "Backs Restaurant And D Paarl             Za",
  normalizedDescription: "Backs Restaurant And D Paarl             Za",
  amount: 303,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Backs Restaurant And D Paarl             Za",
  merchant: $merchant_backs_restaurant_and_d_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_08_19_row_20.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_20.id, "TransactionMerchant", $merchant_backs_restaurant_and_d_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_20.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_20 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-20",
  transaction: $tx_stmt_2025_08_19_row_20,
  status: "open",
  question: "What is the exact purpose of this Backs Restaurant And D Paarl             Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_backs_restaurant_and_d_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_20.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_20.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-08-02T00:00:00Z",
  description: "Spotifyza          Stockholm Se",
  normalizedDescription: "Spotify",
  amount: 64.99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 21,
    rawRowText: "Spotifyza          Stockholm Se; 64.99",
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
LET $tx_stmt_2025_08_19_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-08-02T00:00:00Z",
  description: "Spotifyza          Stockholm Se",
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
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_08_19_row_21.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_21.id, "TransactionMerchant", $merchant_spotify.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_21.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-08-04T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 162,
  balance: 0,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 22,
    rawRowText: "Electronic Payment From:Internet Banking; 162.00",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Internet Banking",
    category: "Cash advance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 162,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Cash advance or cash transfer from the credit card."
});
LET $tx_stmt_2025_08_19_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-08-04T00:00:00Z",
  description: "Electronic Payment From:Internet Banking",
  normalizedDescription: "Nedbank Internet Banking",
  amount: 162,
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
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_08_19_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_22.id, "TransactionMerchant", $merchant_nedbank_internet_banking.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_22.id, "TransactionCategory", $cat_cash_advance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-08-04T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 1507.47,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 23,
    rawRowText: "The Local Choic 202880 Val De Vie E Za; 1507.47",
    transactionType: "expense",
    normalizedMerchant: "The Local Choic 202880 Val De Vie E Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1507.47,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_08_19_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-08-04T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 1507.47,
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
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_08_19_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_23.id, "TransactionMerchant", $merchant_the_local_choic_202880_val_de_vie_e_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_23.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-08-04T00:00:00Z",
  description: "Yoco *Backs Val De V Paarl              Za",
  normalizedDescription: "Backs Val De Vie",
  amount: 185,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 24,
    rawRowText: "Yoco *Backs Val De V Paarl              Za; 185.00",
    transactionType: "expense",
    normalizedMerchant: "Backs Val De Vie",
    category: "Dining / lifestyle",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 185,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Dining spend."
});
LET $tx_stmt_2025_08_19_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-08-04T00:00:00Z",
  description: "Yoco *Backs Val De V Paarl              Za",
  normalizedDescription: "Backs Val De Vie",
  amount: 185,
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
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_08_19_row_24.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_24.id, "TransactionMerchant", $merchant_backs_val_de_vie.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_24.id, "TransactionCategory", $cat_dining_lifestyle.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-08-08T00:00:00Z",
  description: "Backs Restaurant And D Paarl             Za",
  normalizedDescription: "Backs Restaurant And D Paarl             Za",
  amount: 310,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 25,
    rawRowText: "Backs Restaurant And D Paarl             Za; 310.00",
    transactionType: "expense",
    normalizedMerchant: "Backs Restaurant And D Paarl             Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 310,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-08-08T00:00:00Z",
  description: "Backs Restaurant And D Paarl             Za",
  normalizedDescription: "Backs Restaurant And D Paarl             Za",
  amount: 310,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Backs Restaurant And D Paarl             Za",
  merchant: $merchant_backs_restaurant_and_d_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_08_19_row_25.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_25.id, "TransactionMerchant", $merchant_backs_restaurant_and_d_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_25.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_25 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-25",
  transaction: $tx_stmt_2025_08_19_row_25,
  status: "open",
  question: "What is the exact purpose of this Backs Restaurant And D Paarl             Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_backs_restaurant_and_d_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_25.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_25.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-08-09T00:00:00Z",
  description: "Engen Wemmershoek Conv 0000000000000za",
  normalizedDescription: "Engen Wemmershoek Conv",
  amount: 63.5,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 26,
    rawRowText: "Engen Wemmershoek Conv 0000000000000za; 63.50",
    transactionType: "expense",
    normalizedMerchant: "Engen Wemmershoek Conv",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 63.5,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_08_19_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-08-09T00:00:00Z",
  description: "Engen Wemmershoek Conv 0000000000000za",
  normalizedDescription: "Engen Wemmershoek Conv",
  amount: 63.5,
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
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_08_19_row_26.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_26.id, "TransactionMerchant", $merchant_engen_wemmershoek_conv.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_26.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-08-09T00:00:00Z",
  description: "Engen Wemmershoek Conv 0000000000000za",
  normalizedDescription: "Engen Wemmershoek Conv",
  amount: 1284.09,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 27,
    rawRowText: "Engen Wemmershoek Conv 0000000000000za; 1284.09",
    transactionType: "expense",
    normalizedMerchant: "Engen Wemmershoek Conv",
    category: "Fuel / transport",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1284.09,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Fuel or transport spend."
});
LET $tx_stmt_2025_08_19_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-08-09T00:00:00Z",
  description: "Engen Wemmershoek Conv 0000000000000za",
  normalizedDescription: "Engen Wemmershoek Conv",
  amount: 1284.09,
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
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_08_19_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_27.id, "TransactionMerchant", $merchant_engen_wemmershoek_conv.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_27.id, "TransactionCategory", $cat_fuel_transport.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-08-09T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 252.24,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 28,
    rawRowText: "The Local Choic 202880 Val De Vie E Za; 252.24",
    transactionType: "expense",
    normalizedMerchant: "The Local Choic 202880 Val De Vie E Za",
    category: "Groceries / household",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 252.24,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Grocery or household spend."
});
LET $tx_stmt_2025_08_19_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-08-09T00:00:00Z",
  description: "The Local Choic 202880 Val De Vie E Za",
  normalizedDescription: "The Local Choic 202880 Val De Vie E Za",
  amount: 252.24,
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
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_08_19_row_28.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_28.id, "TransactionMerchant", $merchant_the_local_choic_202880_val_de_vie_e_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_28.id, "TransactionCategory", $cat_groceries_household.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-08-10T00:00:00Z",
  description: "C*Total Ninja Black Riv *Cape Town            Za",
  normalizedDescription: "C*Total Ninja Black Riv *Cape Town            Za",
  amount: 45,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 29,
    rawRowText: "C*Total Ninja Black Riv *Cape Town            Za; 45.00",
    transactionType: "expense",
    normalizedMerchant: "C*Total Ninja Black Riv *Cape Town            Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 45,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-08-10T00:00:00Z",
  description: "C*Total Ninja Black Riv *Cape Town            Za",
  normalizedDescription: "C*Total Ninja Black Riv *Cape Town            Za",
  amount: 45,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "C*Total Ninja Black Riv *Cape Town            Za",
  merchant: $merchant_c_total_ninja_black_riv_cape_town_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_08_19_row_29.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_29.id, "TransactionMerchant", $merchant_c_total_ninja_black_riv_cape_town_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_29.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_29 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-29",
  transaction: $tx_stmt_2025_08_19_row_29,
  status: "open",
  question: "What is the exact purpose of this C*Total Ninja Black Riv *Cape Town            Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_c_total_ninja_black_riv_cape_town_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_29.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_29.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-08-13T00:00:00Z",
  description: "Dis-Chem Paarl          Paarl       Za",
  normalizedDescription: "Dis-Chem Paarl          Paarl       Za",
  amount: 4045.15,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 30,
    rawRowText: "Dis-Chem Paarl          Paarl       Za; 4045.15",
    transactionType: "expense",
    normalizedMerchant: "Dis-Chem Paarl          Paarl       Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 4045.15,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-08-13T00:00:00Z",
  description: "Dis-Chem Paarl          Paarl       Za",
  normalizedDescription: "Dis-Chem Paarl          Paarl       Za",
  amount: 4045.15,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Dis-Chem Paarl          Paarl       Za",
  merchant: $merchant_dis_chem_paarl_paarl_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_08_19_row_30.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_30.id, "TransactionMerchant", $merchant_dis_chem_paarl_paarl_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_30.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_30 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-30",
  transaction: $tx_stmt_2025_08_19_row_30,
  status: "open",
  question: "What is the exact purpose of this Dis-Chem Paarl          Paarl       Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_dis_chem_paarl_paarl_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_30.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_30.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-08-15T00:00:00Z",
  description: "Trade Travel Chill      Abu Dhabi       Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1082.84,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 31,
    rawRowText: "Trade Travel Chill      Abu Dhabi       Ae; 1082.84",
    transactionType: "expense",
    normalizedMerchant: "Trade Travel Chill",
    category: "Business expenses paid personally / trading tools",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1082.84,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Recurring trading-indicator or trading-service spend."
});
LET $tx_stmt_2025_08_19_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-08-15T00:00:00Z",
  description: "Trade Travel Chill      Abu Dhabi       Ae",
  normalizedDescription: "Trade Travel Chill",
  amount: 1082.84,
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
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_08_19_row_31.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_31.id, "TransactionMerchant", $merchant_trade_travel_chill.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_31.id, "TransactionCategory", $cat_business_expenses_paid_personally_trading_tools.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-08-16T00:00:00Z",
  description: "I Checkers Sixty60      Cape Town        Za",
  normalizedDescription: "I Checkers Sixty60      Cape Town        Za",
  amount: 509.39,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 32,
    rawRowText: "I Checkers Sixty60      Cape Town        Za; 509.39",
    transactionType: "expense",
    normalizedMerchant: "I Checkers Sixty60      Cape Town        Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 509.39,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-08-16T00:00:00Z",
  description: "I Checkers Sixty60      Cape Town        Za",
  normalizedDescription: "I Checkers Sixty60      Cape Town        Za",
  amount: 509.39,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "I Checkers Sixty60      Cape Town        Za",
  merchant: $merchant_i_checkers_sixty60_cape_town_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_08_19_row_32.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_32.id, "TransactionMerchant", $merchant_i_checkers_sixty60_cape_town_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_32.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_32 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-32",
  transaction: $tx_stmt_2025_08_19_row_32,
  status: "open",
  question: "What is the exact purpose of this I Checkers Sixty60      Cape Town        Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_i_checkers_sixty60_cape_town_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_32.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_32.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-08-17T00:00:00Z",
  description: "Pp *Showmax              Randburg       Za",
  normalizedDescription: "Showmax",
  amount: 99,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 33,
    rawRowText: "Pp *Showmax              Randburg       Za; 99.00",
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
LET $tx_stmt_2025_08_19_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-08-17T00:00:00Z",
  description: "Pp *Showmax              Randburg       Za",
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
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_08_19_row_33.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_33.id, "TransactionMerchant", $merchant_showmax.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_33.id, "TransactionCategory", $cat_subscription_media.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-08-17T00:00:00Z",
  description: "Alana Banana Pty Ltd       Stellenbosch Za",
  normalizedDescription: "Alana Banana Pty Ltd       Stellenbosch Za",
  amount: 33,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 34,
    rawRowText: "Alana Banana Pty Ltd       Stellenbosch Za; 33.00",
    transactionType: "expense",
    normalizedMerchant: "Alana Banana Pty Ltd       Stellenbosch Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 33,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-08-17T00:00:00Z",
  description: "Alana Banana Pty Ltd       Stellenbosch Za",
  normalizedDescription: "Alana Banana Pty Ltd       Stellenbosch Za",
  amount: 33,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Alana Banana Pty Ltd       Stellenbosch Za",
  merchant: $merchant_alana_banana_pty_ltd_stellenbosch_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_08_19_row_34.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_34.id, "TransactionMerchant", $merchant_alana_banana_pty_ltd_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_34.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_34 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-34",
  transaction: $tx_stmt_2025_08_19_row_34,
  status: "open",
  question: "What is the exact purpose of this Alana Banana Pty Ltd       Stellenbosch Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_alana_banana_pty_ltd_stellenbosch_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_34.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_34.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2025-08-17T00:00:00Z",
  description: "Alana Banana Pty Ltd       Stellenbosch Za",
  normalizedDescription: "Alana Banana Pty Ltd       Stellenbosch Za",
  amount: 53,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 35,
    rawRowText: "Alana Banana Pty Ltd       Stellenbosch Za; 53.00",
    transactionType: "expense",
    normalizedMerchant: "Alana Banana Pty Ltd       Stellenbosch Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 53,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-35",
  sourceRow: $row_row_35,
  postedAt: "2025-08-17T00:00:00Z",
  description: "Alana Banana Pty Ltd       Stellenbosch Za",
  normalizedDescription: "Alana Banana Pty Ltd       Stellenbosch Za",
  amount: 53,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Alana Banana Pty Ltd       Stellenbosch Za",
  merchant: $merchant_alana_banana_pty_ltd_stellenbosch_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_08_19_row_35.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_35.id, "TransactionMerchant", $merchant_alana_banana_pty_ltd_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_35.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_35 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-35",
  transaction: $tx_stmt_2025_08_19_row_35,
  status: "open",
  question: "What is the exact purpose of this Alana Banana Pty Ltd       Stellenbosch Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_alana_banana_pty_ltd_stellenbosch_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_35.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_35.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2025-08-17T00:00:00Z",
  description: "Alana Banana Pty Ltd       Stellenbosch Za",
  normalizedDescription: "Alana Banana Pty Ltd       Stellenbosch Za",
  amount: 15,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 36,
    rawRowText: "Alana Banana Pty Ltd       Stellenbosch Za; 15.00",
    transactionType: "expense",
    normalizedMerchant: "Alana Banana Pty Ltd       Stellenbosch Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 15,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-36",
  sourceRow: $row_row_36,
  postedAt: "2025-08-17T00:00:00Z",
  description: "Alana Banana Pty Ltd       Stellenbosch Za",
  normalizedDescription: "Alana Banana Pty Ltd       Stellenbosch Za",
  amount: 15,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Alana Banana Pty Ltd       Stellenbosch Za",
  merchant: $merchant_alana_banana_pty_ltd_stellenbosch_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_08_19_row_36.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_36.id, "TransactionMerchant", $merchant_alana_banana_pty_ltd_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_36.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_36 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-36",
  transaction: $tx_stmt_2025_08_19_row_36,
  status: "open",
  question: "What is the exact purpose of this Alana Banana Pty Ltd       Stellenbosch Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_alana_banana_pty_ltd_stellenbosch_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_36.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_36.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 37
LET $row_row_37 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 37,
  postedAt: "2025-08-17T00:00:00Z",
  description: "Alana Banana Pty Ltd       Stellenbosch Za",
  normalizedDescription: "Alana Banana Pty Ltd       Stellenbosch Za",
  amount: 190,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 37,
    rawRowText: "Alana Banana Pty Ltd       Stellenbosch Za; 190.00",
    transactionType: "expense",
    normalizedMerchant: "Alana Banana Pty Ltd       Stellenbosch Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 190,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_37 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-37",
  sourceRow: $row_row_37,
  postedAt: "2025-08-17T00:00:00Z",
  description: "Alana Banana Pty Ltd       Stellenbosch Za",
  normalizedDescription: "Alana Banana Pty Ltd       Stellenbosch Za",
  amount: 190,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Alana Banana Pty Ltd       Stellenbosch Za",
  merchant: $merchant_alana_banana_pty_ltd_stellenbosch_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_37.id, { transaction: $tx_stmt_2025_08_19_row_37.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_37.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_37.id, "TransactionMerchant", $merchant_alana_banana_pty_ltd_stellenbosch_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_37.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_37 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-37",
  transaction: $tx_stmt_2025_08_19_row_37,
  status: "open",
  question: "What is the exact purpose of this Alana Banana Pty Ltd       Stellenbosch Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_alana_banana_pty_ltd_stellenbosch_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_37.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_37.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 38
LET $row_row_38 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 38,
  postedAt: "2025-08-17T00:00:00Z",
  description: "Giraffe World          Muldersvlei Za",
  normalizedDescription: "Giraffe World          Muldersvlei Za",
  amount: 195,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/credit/August 2025.pdf",
    statementPeriodStart: "2025-07-20",
    statementPeriodEnd: "2025-08-19",
    rowNo: 38,
    rawRowText: "Giraffe World          Muldersvlei Za; 195.00",
    transactionType: "expense",
    normalizedMerchant: "Giraffe World          Muldersvlei Za",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 195,
    bankChargeZar: null,
    balanceZar: 0
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_19_row_38 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-19-row-38",
  sourceRow: $row_row_38,
  postedAt: "2025-08-17T00:00:00Z",
  description: "Giraffe World          Muldersvlei Za",
  normalizedDescription: "Giraffe World          Muldersvlei Za",
  amount: 195,
  balance: 0,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Giraffe World          Muldersvlei Za",
  merchant: $merchant_giraffe_world_muldersvlei_za,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_38.id, { transaction: $tx_stmt_2025_08_19_row_38.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_38.id, "StatementRowTransactions", $tx_stmt_2025_08_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_38.id, "TransactionMerchant", $merchant_giraffe_world_muldersvlei_za.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_19_row_38.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_19_row_38 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-19-row-38",
  transaction: $tx_stmt_2025_08_19_row_38,
  status: "open",
  question: "What is the exact purpose of this Giraffe World          Muldersvlei Za transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_giraffe_world_muldersvlei_za,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-19.import.md"
});
fn::createEdge($tx_stmt_2025_08_19_row_38.id, "TransactionClarificationTasks", $task_stmt_2025_08_19_row_38.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 38,
  normalizedCount: 38,
  clarificationCount: 16,
  status: "matched",
  statementDate: "2025-08-19T00:00:00Z",
  notes: "Imported from 2025-08-19.import.md"
});

-- End of generated import
