-- Generated from docs/statements/personal/savings/2025-03-14.import.md
-- Source: docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf

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
  openingBalance: 606.47,
  active: true,
  notes: "Imported from 30 Aug 2024 - 14 Mar 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-03-14-nedbank-savings",
  sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-03-14T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-03-14.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-03-14.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-03-14.import.md"
});
LET $cat_interest_income = fn::createCategory({
  space: $space,
  key: "interest-income",
  name: "Interest income",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-03-14.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-03-14.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-03-14.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-03-14.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-03-14.import.md"
});
LET $cat_fees_enote_service_fee = fn::createCategory({
  space: $space,
  key: "fees-enote-service-fee",
  name: "Enote Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-03-14.import.md"
});
LET $cat_fees_monthly_service_fee = fn::createCategory({
  space: $space,
  key: "fees-monthly-service-fee",
  name: "Monthly Service Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-03-14.import.md"
});

-- Merchant records
LET $merchant_unknown = fn::createMerchant({
  space: $space,
  key: "unknown",
  name: "Unknown",
  normalizedName: "Unknown",
  active: true,
  notes: "Imported from 2025-03-14.import.md"
});
LET $merchant_unknown_transfer = fn::createMerchant({
  space: $space,
  key: "unknown-transfer",
  name: "Unknown transfer",
  normalizedName: "Unknown transfer",
  active: true,
  notes: "Imported from 2025-03-14.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-03-14.import.md"
});
LET $merchant_nedbank_credit_card = fn::createMerchant({
  space: $space,
  key: "nedbank-credit-card",
  name: "Nedbank Credit Card",
  normalizedName: "Nedbank Credit Card",
  active: true,
  notes: "Imported from 2025-03-14.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2024-09-09T00:00:00Z",
  description: "m",
  normalizedDescription: "Unknown",
  amount: 200,
  balance: 406.47,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 1,
    rawRowText: "m; 200.00; 406.47",
    transactionType: "expense",
    normalizedMerchant: "Unknown",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 200,
    bankChargeZar: null,
    balanceZar: 406.47
},
  notes: "Historical label is too short to identify; keep as unknown debit for now."
});
LET $tx_stmt_2025_03_14_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-01",
  sourceRow: $row_row_01,
  postedAt: "2024-09-09T00:00:00Z",
  description: "m",
  normalizedDescription: "Unknown",
  amount: 200,
  balance: 406.47,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Unknown",
  merchant: $merchant_unknown,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Historical label is too short to identify; keep as unknown debit for now."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_03_14_row_01.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_01.id, "TransactionMerchant", $merchant_unknown.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_01.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_03_14_row_01 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-03-14-row-01",
  transaction: $tx_stmt_2025_03_14_row_01,
  status: "open",
  question: "What exactly is the Magtape Unpaid / Not Provided For reversal?",
  reason: "Returned item / reversal needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_unknown,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-03-14.import.md"
});
fn::createEdge($tx_stmt_2025_03_14_row_01.id, "TransactionClarificationTasks", $task_stmt_2025_03_14_row_01.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2024-09-10T00:00:00Z",
  description: "transfer",
  normalizedDescription: "Unknown transfer",
  amount: 370,
  balance: 36.47,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 2,
    rawRowText: "transfer; 370.00; 36.47",
    transactionType: "transfer",
    normalizedMerchant: "Unknown transfer",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 370,
    bankChargeZar: null,
    balanceZar: 36.47
},
  notes: "Historical transfer label without counter-account detail."
});
LET $tx_stmt_2025_03_14_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-02",
  sourceRow: $row_row_02,
  postedAt: "2024-09-10T00:00:00Z",
  description: "transfer",
  normalizedDescription: "Unknown transfer",
  amount: 370,
  balance: 36.47,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Unknown transfer",
  merchant: $merchant_unknown_transfer,
  category: $cat_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Historical transfer label without counter-account detail."
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_03_14_row_02.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_02.id, "TransactionMerchant", $merchant_unknown_transfer.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_02.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_03_14_row_02 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-03-14-row-02",
  transaction: $tx_stmt_2025_03_14_row_02,
  status: "open",
  question: "What is the exact purpose of this Unknown transfer transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_unknown_transfer,
  suggestedCategory: $cat_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-03-14.import.md"
});
fn::createEdge($tx_stmt_2025_03_14_row_02.id, "TransactionClarificationTasks", $task_stmt_2025_03_14_row_02.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2024-09-17T00:00:00Z",
  description: "INTEREST",
  normalizedDescription: "Nedbank",
  amount: 0.08,
  balance: 36.55,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 3,
    rawRowText: "INTEREST; 0.08; 36.55",
    transactionType: "income",
    normalizedMerchant: "Nedbank",
    category: "Interest income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 0.08,
    bankChargeZar: null,
    balanceZar: 36.55
},
  notes: "Savings interest credit."
});
LET $tx_stmt_2025_03_14_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-03",
  sourceRow: $row_row_03,
  postedAt: "2024-09-17T00:00:00Z",
  description: "INTEREST",
  normalizedDescription: "Nedbank",
  amount: 0.08,
  balance: 36.55,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_interest_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Savings interest credit."
});
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_03_14_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_03.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_03.id, "TransactionCategory", $cat_interest_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2024-09-25T00:00:00Z",
  description: "VAT 27/08 - 23/09 = R8,15",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: 36.55,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 4,
    rawRowText: "VAT 27/08 - 23/09 = R8,15; 0.00; 36.55",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: 36.55
},
  notes: "VAT summary row from bank charges period."
});
LET $tx_stmt_2025_03_14_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-04",
  sourceRow: $row_row_04,
  postedAt: "2024-09-25T00:00:00Z",
  description: "VAT 27/08 - 23/09 = R8,15",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: 36.55,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_03_14_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_04.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_04.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2024-09-25T00:00:00Z",
  description: "eNote Service Fee",
  normalizedDescription: "Enote Service Fee",
  amount: 12.5,
  balance: 24.05,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 5,
    rawRowText: "eNote Service Fee; 12.50; 24.05",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "enote service fee",
    clarificationStatus: "clarified",
    amountZar: 12.5,
    bankChargeZar: null,
    balanceZar: 24.05
},
  notes: "Monthly eNote service fee."
});
LET $tx_stmt_2025_03_14_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-05",
  sourceRow: $row_row_05,
  postedAt: "2024-09-25T00:00:00Z",
  description: "eNote Service Fee",
  normalizedDescription: "Enote Service Fee",
  amount: 12.5,
  balance: 24.05,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_03_14_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_05.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_05.id, "TransactionCategory", $cat_fees_enote_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2024-09-25T00:00:00Z",
  description: "MONTHLY SERVICE FEE",
  normalizedDescription: "Monthly Service Fee",
  amount: 50,
  balance: -25.95,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 6,
    rawRowText: "MONTHLY SERVICE FEE; 50.00; -25.95",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "monthly service fee",
    clarificationStatus: "clarified",
    amountZar: 50,
    bankChargeZar: null,
    balanceZar: -25.95
},
  notes: "Monthly savings-account service fee."
});
LET $tx_stmt_2025_03_14_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-06",
  sourceRow: $row_row_06,
  postedAt: "2024-09-25T00:00:00Z",
  description: "MONTHLY SERVICE FEE",
  normalizedDescription: "Monthly Service Fee",
  amount: 50,
  balance: -25.95,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_03_14_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_06.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_06.id, "TransactionCategory", $cat_fees_monthly_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2024-09-30T00:00:00Z",
  description: "INT ELEC 32DAY 573895529996",
  normalizedDescription: "Nedbank",
  amount: 2.28,
  balance: -23.67,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 7,
    rawRowText: "INT ELEC 32DAY 573895529996; 2.28; -23.67",
    transactionType: "income",
    normalizedMerchant: "Nedbank",
    category: "Interest income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2.28,
    bankChargeZar: null,
    balanceZar: -23.67
},
  notes: "Interest earned on the savings product."
});
LET $tx_stmt_2025_03_14_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-07",
  sourceRow: $row_row_07,
  postedAt: "2024-09-30T00:00:00Z",
  description: "INT ELEC 32DAY 573895529996",
  normalizedDescription: "Nedbank",
  amount: 2.28,
  balance: -23.67,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_interest_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Interest earned on the savings product."
});
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_03_14_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_07.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_07.id, "TransactionCategory", $cat_interest_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2024-10-30T00:00:00Z",
  description: "INT ELEC 32DAY 573895529996",
  normalizedDescription: "Nedbank",
  amount: 13.38,
  balance: -10.29,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 8,
    rawRowText: "INT ELEC 32DAY 573895529996; 13.38; -10.29",
    transactionType: "income",
    normalizedMerchant: "Nedbank",
    category: "Interest income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 13.38,
    bankChargeZar: null,
    balanceZar: -10.29
},
  notes: "Interest earned on the savings product."
});
LET $tx_stmt_2025_03_14_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-08",
  sourceRow: $row_row_08,
  postedAt: "2024-10-30T00:00:00Z",
  description: "INT ELEC 32DAY 573895529996",
  normalizedDescription: "Nedbank",
  amount: 13.38,
  balance: -10.29,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_interest_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Interest earned on the savings product."
});
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_03_14_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_08.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_08.id, "TransactionCategory", $cat_interest_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2024-11-07T00:00:00Z",
  description: "INT ELEC 32DAY 573895529996",
  normalizedDescription: "Nedbank",
  amount: 4.73,
  balance: -5.56,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 9,
    rawRowText: "INT ELEC 32DAY 573895529996; 4.73; -5.56",
    transactionType: "income",
    normalizedMerchant: "Nedbank",
    category: "Interest income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 4.73,
    bankChargeZar: null,
    balanceZar: -5.56
},
  notes: "Interest earned on the savings product."
});
LET $tx_stmt_2025_03_14_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-09",
  sourceRow: $row_row_09,
  postedAt: "2024-11-07T00:00:00Z",
  description: "INT ELEC 32DAY 573895529996",
  normalizedDescription: "Nedbank",
  amount: 4.73,
  balance: -5.56,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_interest_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Interest earned on the savings product."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_03_14_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_09.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_09.id, "TransactionCategory", $cat_interest_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2024-11-30T00:00:00Z",
  description: "INT ELEC 32DAY 573895529996",
  normalizedDescription: "Nedbank",
  amount: 2.54,
  balance: -3.02,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 10,
    rawRowText: "INT ELEC 32DAY 573895529996; 2.54; -3.02",
    transactionType: "income",
    normalizedMerchant: "Nedbank",
    category: "Interest income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2.54,
    bankChargeZar: null,
    balanceZar: -3.02
},
  notes: "Interest earned on the savings product."
});
LET $tx_stmt_2025_03_14_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-10",
  sourceRow: $row_row_10,
  postedAt: "2024-11-30T00:00:00Z",
  description: "INT ELEC 32DAY 573895529996",
  normalizedDescription: "Nedbank",
  amount: 2.54,
  balance: -3.02,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_interest_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Interest earned on the savings product."
});
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_03_14_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_10.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_10.id, "TransactionCategory", $cat_interest_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2024-12-07T00:00:00Z",
  description: "INT ELEC 32DAY 573895529996",
  normalizedDescription: "Nedbank",
  amount: 1.24,
  balance: -1.78,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 11,
    rawRowText: "INT ELEC 32DAY 573895529996; 1.24; -1.78",
    transactionType: "income",
    normalizedMerchant: "Nedbank",
    category: "Interest income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1.24,
    bankChargeZar: null,
    balanceZar: -1.78
},
  notes: "Interest earned on the savings product."
});
LET $tx_stmt_2025_03_14_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-11",
  sourceRow: $row_row_11,
  postedAt: "2024-12-07T00:00:00Z",
  description: "INT ELEC 32DAY 573895529996",
  normalizedDescription: "Nedbank",
  amount: 1.24,
  balance: -1.78,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_interest_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Interest earned on the savings product."
});
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_03_14_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_11.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_11.id, "TransactionCategory", $cat_interest_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-01-13T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 20,
  balance: 18.22,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 12,
    rawRowText: "CREDIT CRD - 4922130003088996; 20.00; 18.22",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 20,
    bankChargeZar: null,
    balanceZar: 18.22
},
  notes: "Credit from the credit-card rail; exact purpose still needs confirmation."
});
LET $tx_stmt_2025_03_14_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-01-13T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 20,
  balance: 18.22,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Credit from the credit-card rail; exact purpose still needs confirmation."
});
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_03_14_row_12.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_12.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_12.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_03_14_row_12 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-03-14-row-12",
  transaction: $tx_stmt_2025_03_14_row_12,
  status: "open",
  question: "What is the exact purpose of this Nedbank Credit Card transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_nedbank_credit_card,
  suggestedCategory: $cat_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-03-14.import.md"
});
fn::createEdge($tx_stmt_2025_03_14_row_12.id, "TransactionClarificationTasks", $task_stmt_2025_03_14_row_12.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-01-27T00:00:00Z",
  description: "VAT 24/12 - 25/01 = R8,80",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: 18.22,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 13,
    rawRowText: "VAT 24/12 - 25/01 = R8,80; 0.00; 18.22",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: 18.22
},
  notes: "VAT summary row from bank charges period."
});
LET $tx_stmt_2025_03_14_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-01-27T00:00:00Z",
  description: "VAT 24/12 - 25/01 = R8,80",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: 18.22,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_03_14_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_13.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_13.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-01-27T00:00:00Z",
  description: "eNote Service Fee",
  normalizedDescription: "Enote Service Fee",
  amount: 12.5,
  balance: 5.72,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 14,
    rawRowText: "eNote Service Fee; 12.50; 5.72",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "enote service fee",
    clarificationStatus: "clarified",
    amountZar: 12.5,
    bankChargeZar: null,
    balanceZar: 5.72
},
  notes: "Monthly eNote service fee."
});
LET $tx_stmt_2025_03_14_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-01-27T00:00:00Z",
  description: "eNote Service Fee",
  normalizedDescription: "Enote Service Fee",
  amount: 12.5,
  balance: 5.72,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_03_14_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_14.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_14.id, "TransactionCategory", $cat_fees_enote_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-01-27T00:00:00Z",
  description: "MONTHLY SERVICE FEE",
  normalizedDescription: "Monthly Service Fee",
  amount: 55,
  balance: -49.28,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 15,
    rawRowText: "MONTHLY SERVICE FEE; 55.00; -49.28",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "monthly service fee",
    clarificationStatus: "clarified",
    amountZar: 55,
    bankChargeZar: null,
    balanceZar: -49.28
},
  notes: "Monthly savings-account service fee."
});
LET $tx_stmt_2025_03_14_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-01-27T00:00:00Z",
  description: "MONTHLY SERVICE FEE",
  normalizedDescription: "Monthly Service Fee",
  amount: 55,
  balance: -49.28,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_03_14_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_15.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_15.id, "TransactionCategory", $cat_fees_monthly_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-02-24T00:00:00Z",
  description: "VAT 27/01 - 22/02 = R8,80",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -49.28,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 16,
    rawRowText: "VAT 27/01 - 22/02 = R8,80; 0.00; -49.28",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: -49.28
},
  notes: "VAT summary row from bank charges period."
});
LET $tx_stmt_2025_03_14_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-02-24T00:00:00Z",
  description: "VAT 27/01 - 22/02 = R8,80",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -49.28,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_03_14_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_16.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_16.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-02-24T00:00:00Z",
  description: "eNote Service Fee",
  normalizedDescription: "Enote Service Fee",
  amount: 12.5,
  balance: -61.78,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 17,
    rawRowText: "eNote Service Fee; 12.50; -61.78",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "enote service fee",
    clarificationStatus: "clarified",
    amountZar: 12.5,
    bankChargeZar: null,
    balanceZar: -61.78
},
  notes: "Monthly eNote service fee."
});
LET $tx_stmt_2025_03_14_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-02-24T00:00:00Z",
  description: "eNote Service Fee",
  normalizedDescription: "Enote Service Fee",
  amount: 12.5,
  balance: -61.78,
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_03_14_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_17.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_17.id, "TransactionCategory", $cat_fees_enote_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-02-24T00:00:00Z",
  description: "MONTHLY SERVICE FEE",
  normalizedDescription: "Monthly Service Fee",
  amount: 55,
  balance: -116.78,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 18,
    rawRowText: "MONTHLY SERVICE FEE; 55.00; -116.78",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "monthly service fee",
    clarificationStatus: "clarified",
    amountZar: 55,
    bankChargeZar: null,
    balanceZar: -116.78
},
  notes: "Monthly savings-account service fee."
});
LET $tx_stmt_2025_03_14_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-02-24T00:00:00Z",
  description: "MONTHLY SERVICE FEE",
  normalizedDescription: "Monthly Service Fee",
  amount: 55,
  balance: -116.78,
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_03_14_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_18.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_18.id, "TransactionCategory", $cat_fees_monthly_service_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-03-13T00:00:00Z",
  description: "transfer",
  normalizedDescription: "Unknown transfer",
  amount: 121,
  balance: 4.22,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 19,
    rawRowText: "transfer; 121.00; 4.22",
    transactionType: "transfer",
    normalizedMerchant: "Unknown transfer",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 121,
    bankChargeZar: null,
    balanceZar: 4.22
},
  notes: "Historical transfer credit without counter-account detail."
});
LET $tx_stmt_2025_03_14_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-03-13T00:00:00Z",
  description: "transfer",
  normalizedDescription: "Unknown transfer",
  amount: 121,
  balance: 4.22,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Unknown transfer",
  merchant: $merchant_unknown_transfer,
  category: $cat_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Historical transfer credit without counter-account detail."
});
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_03_14_row_19.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_19.id, "TransactionMerchant", $merchant_unknown_transfer.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_19.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_03_14_row_19 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-03-14-row-19",
  transaction: $tx_stmt_2025_03_14_row_19,
  status: "open",
  question: "What is the exact purpose of this Unknown transfer transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_unknown_transfer,
  suggestedCategory: $cat_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-03-14.import.md"
});
fn::createEdge($tx_stmt_2025_03_14_row_19.id, "TransactionClarificationTasks", $task_stmt_2025_03_14_row_19.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-03-14T00:00:00Z",
  description: "transfer",
  normalizedDescription: "Unknown transfer",
  amount: 2100,
  balance: 2104.22,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/savings/30 Aug 2024 - 14 Mar 2025.pdf",
    statementPeriodStart: "2024-08-30",
    statementPeriodEnd: "2025-03-14",
    rowNo: 20,
    rawRowText: "transfer; 2100.00; 2104.22",
    transactionType: "transfer",
    normalizedMerchant: "Unknown transfer",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 2100,
    bankChargeZar: null,
    balanceZar: 2104.22
},
  notes: "Historical transfer credit without counter-account detail."
});
LET $tx_stmt_2025_03_14_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-03-14-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-03-14T00:00:00Z",
  description: "transfer",
  normalizedDescription: "Unknown transfer",
  amount: 2100,
  balance: 2104.22,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Unknown transfer",
  merchant: $merchant_unknown_transfer,
  category: $cat_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Historical transfer credit without counter-account detail."
});
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_03_14_row_20.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_03_14_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_03_14_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_20.id, "TransactionMerchant", $merchant_unknown_transfer.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_03_14_row_20.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_03_14_row_20 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-03-14-row-20",
  transaction: $tx_stmt_2025_03_14_row_20,
  status: "open",
  question: "What is the exact purpose of this Unknown transfer transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_unknown_transfer,
  suggestedCategory: $cat_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-03-14.import.md"
});
fn::createEdge($tx_stmt_2025_03_14_row_20.id, "TransactionClarificationTasks", $task_stmt_2025_03_14_row_20.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 20,
  normalizedCount: 20,
  clarificationCount: 5,
  status: "matched",
  statementDate: "2025-03-14T00:00:00Z",
  notes: "Imported from 2025-03-14.import.md"
});

-- End of generated import
