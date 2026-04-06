-- Generated from docs/statements/personal/savings/2026-03-18.import.md
-- Source: docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf

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
  key: "nedbank-savings-12946",
  name: "Nedbank Savings Account",
  bankName: "Nedbank",
  accountType: "savings",
  currency: "ZAR",
  accountNumberLast4: "2946",
  openingBalance: -63.21,
  active: true,
  notes: "Imported from 27 Oct 2025 - 18 Mar 2026.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2026-03-18-nedbank-savings",
  sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2026-03-18T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2026-03-18.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_fees_enote_service_fee = fn::createCategory({
  space: $space,
  key: "fees-enote-service-fee",
  name: "Enote Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_fees_monthly_service_fee = fn::createCategory({
  space: $space,
  key: "fees-monthly-service-fee",
  name: "Monthly Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $cat_fees_ott_fee = fn::createCategory({
  space: $space,
  key: "fees-ott-fee",
  name: "Ott Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});

-- Merchant records
LET $merchant_nedbank_current_account = fn::createMerchant({
  space: $space,
  key: "nedbank-current-account",
  name: "Nedbank Current Account",
  normalizedName: "Nedbank Current Account",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});
LET $merchant_nedbank_credit_card = fn::createMerchant({
  space: $space,
  key: "nedbank-credit-card",
  name: "Nedbank Credit Card",
  normalizedName: "Nedbank Credit Card",
  active: true,
  notes: "Imported from 2026-03-18.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-10-29T00:00:00Z",
  description: "CURRENT ACC - 1092107185",
  normalizedDescription: "Nedbank Current Account",
  amount: 70,
  balance: 6.79,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 1,
    rawRowText: "CURRENT ACC - 1092107185; 70.00; 6.79",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 70,
    bankChargeZar: null,
    balanceZar: 6.79
},
  notes: "Transfer in from personal current account."
});
LET $tx_stmt_2026_03_18_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-10-29T00:00:00Z",
  description: "CURRENT ACC - 1092107185",
  normalizedDescription: "Nedbank Current Account",
  amount: 70,
  balance: 6.79,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Current Account",
  merchant: $merchant_nedbank_current_account,
  category: $cat_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer in from personal current account."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2026_03_18_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_01.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_01.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-11-25T00:00:00Z",
  description: "VAT 27/10 - 24/11 = R8,80",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: 6.79,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 2,
    rawRowText: "VAT 27/10 - 24/11 = R8,80; 0.00; 6.79",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: 6.79
},
  notes: "VAT summary row from bank charges period."
});
LET $tx_stmt_2026_03_18_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-11-25T00:00:00Z",
  description: "VAT 27/10 - 24/11 = R8,80",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: 6.79,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_vat_on_fees,
  isTransfer: false,
  manualOverride: false,
  notes: "VAT summary row from bank charges period."
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2026_03_18_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_02.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_02.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-11-25T00:00:00Z",
  description: "eNote Service Fee",
  normalizedDescription: "Enote Service Fee",
  amount: 12.5,
  balance: -5.71,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 3,
    rawRowText: "eNote Service Fee; 12.50; -5.71",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "enote service fee",
    clarificationStatus: "clarified",
    amountZar: 12.5,
    bankChargeZar: null,
    balanceZar: -5.71
},
  notes: "Monthly eNote service fee."
});
LET $tx_stmt_2026_03_18_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-11-25T00:00:00Z",
  description: "eNote Service Fee",
  normalizedDescription: "Enote Service Fee",
  amount: 12.5,
  balance: -5.71,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_enote_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Monthly eNote service fee."
});
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2026_03_18_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_03.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_03.id, "TransactionCategory", $cat_fees_enote_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-11-25T00:00:00Z",
  description: "MONTHLY SERVICE FEE",
  normalizedDescription: "Monthly Service Fee",
  amount: 55,
  balance: -60.71,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 4,
    rawRowText: "MONTHLY SERVICE FEE; 55.00; -60.71",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "monthly service fee",
    clarificationStatus: "clarified",
    amountZar: 55,
    bankChargeZar: null,
    balanceZar: -60.71
},
  notes: "Monthly savings-account service fee."
});
LET $tx_stmt_2026_03_18_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-11-25T00:00:00Z",
  description: "MONTHLY SERVICE FEE",
  normalizedDescription: "Monthly Service Fee",
  amount: 55,
  balance: -60.71,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_monthly_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Monthly savings-account service fee."
});
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2026_03_18_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_04.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_04.id, "TransactionCategory", $cat_fees_monthly_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-12-12T00:00:00Z",
  description: "CURRENT ACC - 1092107185",
  normalizedDescription: "Nedbank Current Account",
  amount: 6490,
  balance: 6429.29,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 5,
    rawRowText: "CURRENT ACC - 1092107185; 6,490.00; 6,429.29",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6490,
    bankChargeZar: null,
    balanceZar: 6429.29
},
  notes: "Transfer in from personal current account."
});
LET $tx_stmt_2026_03_18_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-12-12T00:00:00Z",
  description: "CURRENT ACC - 1092107185",
  normalizedDescription: "Nedbank Current Account",
  amount: 6490,
  balance: 6429.29,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Current Account",
  merchant: $merchant_nedbank_current_account,
  category: $cat_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer in from personal current account."
});
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2026_03_18_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_05.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_05.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-12-12T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 6390,
  balance: 39.29,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 6,
    rawRowText: "CREDIT CRD - 4922130003088996; 6,390.00; 39.29",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6390,
    bankChargeZar: null,
    balanceZar: 39.29
},
  notes: "Transfer out to credit card."
});
LET $tx_stmt_2026_03_18_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-12-12T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 6390,
  balance: 39.29,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer out to credit card."
});
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2026_03_18_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_06.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_06.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-12-24T00:00:00Z",
  description: "VAT 25/11 - 23/12 = R8,80",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: 39.29,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 7,
    rawRowText: "VAT 25/11 - 23/12 = R8,80; 0.00; 39.29",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: 39.29
},
  notes: "VAT summary row from bank charges period."
});
LET $tx_stmt_2026_03_18_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-12-24T00:00:00Z",
  description: "VAT 25/11 - 23/12 = R8,80",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: 39.29,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_vat_on_fees,
  isTransfer: false,
  manualOverride: false,
  notes: "VAT summary row from bank charges period."
});
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2026_03_18_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_07.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_07.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-12-24T00:00:00Z",
  description: "eNote Service Fee",
  normalizedDescription: "Enote Service Fee",
  amount: 12.5,
  balance: 26.79,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 8,
    rawRowText: "eNote Service Fee; 12.50; 26.79",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "enote service fee",
    clarificationStatus: "clarified",
    amountZar: 12.5,
    bankChargeZar: null,
    balanceZar: 26.79
},
  notes: "Monthly eNote service fee."
});
LET $tx_stmt_2026_03_18_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-12-24T00:00:00Z",
  description: "eNote Service Fee",
  normalizedDescription: "Enote Service Fee",
  amount: 12.5,
  balance: 26.79,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_enote_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Monthly eNote service fee."
});
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2026_03_18_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_08.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_08.id, "TransactionCategory", $cat_fees_enote_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-12-24T00:00:00Z",
  description: "MONTHLY SERVICE FEE",
  normalizedDescription: "Monthly Service Fee",
  amount: 55,
  balance: -28.21,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 9,
    rawRowText: "MONTHLY SERVICE FEE; 55.00; -28.21",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "monthly service fee",
    clarificationStatus: "clarified",
    amountZar: 55,
    bankChargeZar: null,
    balanceZar: -28.21
},
  notes: "Monthly savings-account service fee."
});
LET $tx_stmt_2026_03_18_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-12-24T00:00:00Z",
  description: "MONTHLY SERVICE FEE",
  normalizedDescription: "Monthly Service Fee",
  amount: 55,
  balance: -28.21,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_monthly_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Monthly savings-account service fee."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2026_03_18_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_09.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_09.id, "TransactionCategory", $cat_fees_monthly_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2026-01-09T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 30,
  balance: 1.79,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 10,
    rawRowText: "CREDIT CRD - 4922130003088996; 30.00; 1.79",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 30,
    bankChargeZar: null,
    balanceZar: 1.79
},
  notes: "Transfer in from the credit card; confirm exact purpose later."
});
LET $tx_stmt_2026_03_18_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-10",
  sourceRow: $row_row_10,
  postedAt: "2026-01-09T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 30,
  balance: 1.79,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer in from the credit card; confirm exact purpose later."
});
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2026_03_18_row_10.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_10.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_10.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_18_row_10 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-18-row-10",
  transaction: $tx_stmt_2026_03_18_row_10,
  status: "open",
  question: "What is the exact purpose of this Nedbank Credit Card transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_nedbank_credit_card,
  suggestedCategory: $cat_transfer,
  confidence: 0.25,
  notes: "Imported from 2026-03-18.import.md"
});
fn::createEdge($tx_stmt_2026_03_18_row_10.id, "TransactionClarificationTasks", $task_stmt_2026_03_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2026-01-27T00:00:00Z",
  description: "VAT 24/12 - 26/01 = R9,06",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: 1.79,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 11,
    rawRowText: "VAT 24/12 - 26/01 = R9,06; 0.00; 1.79",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: 1.79
},
  notes: "VAT summary row from bank charges period."
});
LET $tx_stmt_2026_03_18_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-11",
  sourceRow: $row_row_11,
  postedAt: "2026-01-27T00:00:00Z",
  description: "VAT 24/12 - 26/01 = R9,06",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: 1.79,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_vat_on_fees,
  isTransfer: false,
  manualOverride: false,
  notes: "VAT summary row from bank charges period."
});
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2026_03_18_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_11.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_11.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2026-01-27T00:00:00Z",
  description: "eNote Service Fee",
  normalizedDescription: "Enote Service Fee",
  amount: 12.5,
  balance: -10.71,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 12,
    rawRowText: "eNote Service Fee; 12.50; -10.71",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "enote service fee",
    clarificationStatus: "clarified",
    amountZar: 12.5,
    bankChargeZar: null,
    balanceZar: -10.71
},
  notes: "Monthly eNote service fee."
});
LET $tx_stmt_2026_03_18_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-12",
  sourceRow: $row_row_12,
  postedAt: "2026-01-27T00:00:00Z",
  description: "eNote Service Fee",
  normalizedDescription: "Enote Service Fee",
  amount: 12.5,
  balance: -10.71,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_enote_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Monthly eNote service fee."
});
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2026_03_18_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_12.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_12.id, "TransactionCategory", $cat_fees_enote_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2026-01-27T00:00:00Z",
  description: "MONTHLY SERVICE FEE",
  normalizedDescription: "Monthly Service Fee",
  amount: 57,
  balance: -67.71,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 13,
    rawRowText: "MONTHLY SERVICE FEE; 57.00; -67.71",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "monthly service fee",
    clarificationStatus: "clarified",
    amountZar: 57,
    bankChargeZar: null,
    balanceZar: -67.71
},
  notes: "Monthly savings-account service fee."
});
LET $tx_stmt_2026_03_18_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-13",
  sourceRow: $row_row_13,
  postedAt: "2026-01-27T00:00:00Z",
  description: "MONTHLY SERVICE FEE",
  normalizedDescription: "Monthly Service Fee",
  amount: 57,
  balance: -67.71,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_monthly_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Monthly savings-account service fee."
});
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2026_03_18_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_13.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_13.id, "TransactionCategory", $cat_fees_monthly_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2026-02-10T00:00:00Z",
  description: "CURRENT ACC - 1092107185",
  normalizedDescription: "Nedbank Current Account",
  amount: 100,
  balance: 32.29,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 14,
    rawRowText: "CURRENT ACC - 1092107185; 100.00; 32.29",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 100,
    bankChargeZar: null,
    balanceZar: 32.29
},
  notes: "Transfer in from personal current account."
});
LET $tx_stmt_2026_03_18_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-14",
  sourceRow: $row_row_14,
  postedAt: "2026-02-10T00:00:00Z",
  description: "CURRENT ACC - 1092107185",
  normalizedDescription: "Nedbank Current Account",
  amount: 100,
  balance: 32.29,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Current Account",
  merchant: $merchant_nedbank_current_account,
  category: $cat_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer in from personal current account."
});
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2026_03_18_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_14.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_14.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2026-02-24T00:00:00Z",
  description: "VAT 27/01 - 23/02 = R9,06",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: 32.29,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 15,
    rawRowText: "VAT 27/01 - 23/02 = R9,06; 0.00; 32.29",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: 32.29
},
  notes: "VAT summary row from bank charges period."
});
LET $tx_stmt_2026_03_18_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-15",
  sourceRow: $row_row_15,
  postedAt: "2026-02-24T00:00:00Z",
  description: "VAT 27/01 - 23/02 = R9,06",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: 32.29,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_vat_on_fees,
  isTransfer: false,
  manualOverride: false,
  notes: "VAT summary row from bank charges period."
});
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2026_03_18_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_15.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_15.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2026-02-24T00:00:00Z",
  description: "eNote Service Fee",
  normalizedDescription: "Enote Service Fee",
  amount: 12.5,
  balance: 19.79,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 16,
    rawRowText: "eNote Service Fee; 12.50; 19.79",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "enote service fee",
    clarificationStatus: "clarified",
    amountZar: 12.5,
    bankChargeZar: null,
    balanceZar: 19.79
},
  notes: "Monthly eNote service fee."
});
LET $tx_stmt_2026_03_18_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-16",
  sourceRow: $row_row_16,
  postedAt: "2026-02-24T00:00:00Z",
  description: "eNote Service Fee",
  normalizedDescription: "Enote Service Fee",
  amount: 12.5,
  balance: 19.79,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_enote_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Monthly eNote service fee."
});
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2026_03_18_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_16.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_16.id, "TransactionCategory", $cat_fees_enote_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2026-02-24T00:00:00Z",
  description: "MONTHLY SERVICE FEE",
  normalizedDescription: "Monthly Service Fee",
  amount: 57,
  balance: -37.21,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 17,
    rawRowText: "MONTHLY SERVICE FEE; 57.00; -37.21",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "monthly service fee",
    clarificationStatus: "clarified",
    amountZar: 57,
    bankChargeZar: null,
    balanceZar: -37.21
},
  notes: "Monthly savings-account service fee."
});
LET $tx_stmt_2026_03_18_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-17",
  sourceRow: $row_row_17,
  postedAt: "2026-02-24T00:00:00Z",
  description: "MONTHLY SERVICE FEE",
  normalizedDescription: "Monthly Service Fee",
  amount: 57,
  balance: -37.21,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_monthly_service_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Monthly savings-account service fee."
});
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2026_03_18_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_17.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_17.id, "TransactionCategory", $cat_fees_monthly_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2026-03-16T00:00:00Z",
  description: "CURRENT ACC - 1092107185",
  normalizedDescription: "Nedbank Current Account",
  amount: 1282,
  balance: 1244.79,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 18,
    rawRowText: "CURRENT ACC - 1092107185; 1,282.00; 1,244.79",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Current Account",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1282,
    bankChargeZar: null,
    balanceZar: 1244.79
},
  notes: "Transfer in from personal current account."
});
LET $tx_stmt_2026_03_18_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-18",
  sourceRow: $row_row_18,
  postedAt: "2026-03-16T00:00:00Z",
  description: "CURRENT ACC - 1092107185",
  normalizedDescription: "Nedbank Current Account",
  amount: 1282,
  balance: 1244.79,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Current Account",
  merchant: $merchant_nedbank_current_account,
  category: $cat_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer in from personal current account."
});
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2026_03_18_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_18.id, "TransactionMerchant", $merchant_nedbank_current_account.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_18.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2026-03-16T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1175,
  balance: 69.79,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 19,
    rawRowText: "CREDIT CRD - 4922130003088996; 1,175.00; 69.79",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1175,
    bankChargeZar: null,
    balanceZar: 69.79
},
  notes: "Transfer out to credit card."
});
LET $tx_stmt_2026_03_18_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-19",
  sourceRow: $row_row_19,
  postedAt: "2026-03-16T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1175,
  balance: 69.79,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer out to credit card."
});
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2026_03_18_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_19.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_19.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2026-03-18T00:00:00Z",
  description: "OTT",
  normalizedDescription: "Ott Fee",
  amount: 5,
  balance: 64.79,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/27 Oct 2025 - 18 Mar 2026.pdf",
    statementPeriodStart: "2025-10-27",
    statementPeriodEnd: "2026-03-18",
    rowNo: 20,
    rawRowText: "OTT; 5.00; 64.79",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "ott fee",
    clarificationStatus: "unclarified",
    amountZar: 5,
    bankChargeZar: null,
    balanceZar: 64.79
},
  notes: "OTT fee label still needs confirmation."
});
LET $tx_stmt_2026_03_18_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2026-03-18-row-20",
  sourceRow: $row_row_20,
  postedAt: "2026-03-18T00:00:00Z",
  description: "OTT",
  normalizedDescription: "Ott Fee",
  amount: 5,
  balance: 64.79,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_ott_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "OTT fee label still needs confirmation."
});
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2026_03_18_row_20.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2026_03_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2026_03_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_20.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2026_03_18_row_20.id, "TransactionCategory", $cat_fees_ott_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2026_03_18_row_20 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2026-03-18-row-20",
  transaction: $tx_stmt_2026_03_18_row_20,
  status: "open",
  question: "What is the exact purpose of this Nedbank transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_nedbank,
  suggestedCategory: $cat_fees_ott_fee,
  confidence: 0.25,
  notes: "Imported from 2026-03-18.import.md"
});
fn::createEdge($tx_stmt_2026_03_18_row_20.id, "TransactionClarificationTasks", $task_stmt_2026_03_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 20,
  normalizedCount: 20,
  clarificationCount: 2,
  status: "matched",
  statementDate: "2026-03-18T00:00:00Z",
  notes: "Imported from 2026-03-18.import.md"
});

-- End of generated import
