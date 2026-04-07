-- Generated from docs/statements/personal/current/2025-07-21.import.md
-- Source: docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf

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
  key: "nedbank-current-07185",
  name: "Nedbank Current Account",
  bankName: "Nedbank",
  accountType: "current",
  currency: "ZAR",
  accountNumberLast4: "7185",
  openingBalance: 18999.7,
  active: true,
  notes: "Imported from 21 Jun 2025 - 21 Jul 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-07-21-nedbank-current",
  sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-07-21T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-07-21.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});
LET $cat_fees_overdraft_interest = fn::createCategory({
  space: $space,
  key: "fees-overdraft-interest",
  name: "Overdraft Interest",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});
LET $cat_fees_overdraft_facility_fee = fn::createCategory({
  space: $space,
  key: "fees-overdraft-facility-fee",
  name: "Overdraft Facility Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});

-- Merchant records
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "MPIRE Digital Market",
  normalizedName: "MPIRE Digital Market",
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});
LET $merchant_open_investment_deposit = fn::createMerchant({
  space: $space,
  key: "open-investment-deposit",
  name: "Open Investment deposit",
  normalizedName: "Open Investment deposit",
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});
LET $merchant_nedbank_credit_card = fn::createMerchant({
  space: $space,
  key: "nedbank-credit-card",
  name: "Nedbank Credit Card",
  normalizedName: "Nedbank Credit Card",
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});
LET $merchant_int_justinvest_573895529995 = fn::createMerchant({
  space: $space,
  key: "int-justinvest-573895529995",
  name: "INT JUSTINVEST 573895529995",
  normalizedName: "INT JUSTINVEST 573895529995",
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});
LET $merchant_cap_justinvest_573895529995 = fn::createMerchant({
  space: $space,
  key: "cap-justinvest-573895529995",
  name: "CAP JUSTINVEST 573895529995",
  normalizedName: "CAP JUSTINVEST 573895529995",
  active: true,
  notes: "Imported from 2025-07-21.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-06-24T00:00:00Z",
  description: "Mpire Digital Market",
  normalizedDescription: "MPIRE Digital Market",
  amount: 15000,
  balance: -3999.7,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 1,
    rawRowText: "Mpire Digital Market; 15000.00; -3999.70",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 15000,
    bankChargeZar: null,
    balanceZar: -3999.7
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_07_21_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-06-24T00:00:00Z",
  description: "Mpire Digital Market",
  normalizedDescription: "MPIRE Digital Market",
  amount: 15000,
  balance: -3999.7,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "MPIRE Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_07_21_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_01.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_01.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-06-24T00:00:00Z",
  description: "Mpire Digital Market",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2000,
  balance: -1999.7,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 2,
    rawRowText: "Mpire Digital Market; 2000.00; -1999.70",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: -1999.7
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_07_21_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-06-24T00:00:00Z",
  description: "Mpire Digital Market",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2000,
  balance: -1999.7,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "MPIRE Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_07_21_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_02.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_02.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-06-24T00:00:00Z",
  description: "Open Investment deposit",
  normalizedDescription: "Open Investment deposit",
  amount: 1000,
  balance: -2999.7,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 3,
    rawRowText: "Open Investment deposit; 1000.00; -2999.70",
    transactionType: "expense",
    normalizedMerchant: "Open Investment deposit",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: -2999.7
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_21_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-06-24T00:00:00Z",
  description: "Open Investment deposit",
  normalizedDescription: "Open Investment deposit",
  amount: 1000,
  balance: -2999.7,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Open Investment deposit",
  merchant: $merchant_open_investment_deposit,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_07_21_row_03.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_03.id, "TransactionMerchant", $merchant_open_investment_deposit.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_03.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_21_row_03 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-21-row-03",
  transaction: $tx_stmt_2025_07_21_row_03,
  status: "open",
  question: "What is the exact purpose of this Open Investment deposit transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_open_investment_deposit,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-21.import.md"
});
fn::createEdge($tx_stmt_2025_07_21_row_03.id, "TransactionClarificationTasks", $task_stmt_2025_07_21_row_03.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-06-24T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 13980,
  balance: -16979.7,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 4,
    rawRowText: "CREDIT CRD - 4922130003088996; 13980.00; -16979.70",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 13980,
    bankChargeZar: null,
    balanceZar: -16979.7
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_07_21_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-06-24T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 13980,
  balance: -16979.7,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer out to settle the credit card."
});
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_07_21_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_04.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_04.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-06-24T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -18979.7,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 5,
    rawRowText: "CREDIT CRD - 4922130003088996; 2000.00; -18979.70",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: -18979.7
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_07_21_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-06-24T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -18979.7,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer out to settle the credit card."
});
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_07_21_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_05.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_05.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-06-26T00:00:00Z",
  description: "VAT 28/05-25/06 = R16.17",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -18979.7,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 6,
    rawRowText: "VAT 28/05-25/06 = R16.17; 0.00; -18979.70",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: -18979.7
},
  notes: "VAT summary row for bank charges period."
});
LET $tx_stmt_2025_07_21_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-06-26T00:00:00Z",
  description: "VAT 28/05-25/06 = R16.17",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -18979.7,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_vat_on_fees,
  isTransfer: false,
  manualOverride: false,
  notes: "VAT summary row for bank charges period."
});
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_07_21_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_06.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_06.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-06-26T00:00:00Z",
  description: "INTEREST 28/05 - 25/06",
  normalizedDescription: "Overdraft Interest",
  amount: 175.58,
  balance: -19155.28,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 7,
    rawRowText: "INTEREST 28/05 - 25/06; 175.58; -19155.28",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft interest",
    clarificationStatus: "clarified",
    amountZar: 175.58,
    bankChargeZar: null,
    balanceZar: -19155.28
},
  notes: "Overdraft interest charge."
});
LET $tx_stmt_2025_07_21_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-06-26T00:00:00Z",
  description: "INTEREST 28/05 - 25/06",
  normalizedDescription: "Overdraft Interest",
  amount: 175.58,
  balance: -19155.28,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_overdraft_interest,
  isTransfer: false,
  manualOverride: false,
  notes: "Overdraft interest charge."
});
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_07_21_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_07.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_07.id, "TransactionCategory", $cat_fees_overdraft_interest.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-06-26T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -19224.28,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 8,
    rawRowText: "Facility Fee; 69.00; -19224.28",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft facility fee",
    clarificationStatus: "clarified",
    amountZar: 69,
    bankChargeZar: null,
    balanceZar: -19224.28
},
  notes: "Overdraft facility fee."
});
LET $tx_stmt_2025_07_21_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-06-26T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -19224.28,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_overdraft_facility_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Overdraft facility fee."
});
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_07_21_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_08.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_08.id, "TransactionCategory", $cat_fees_overdraft_facility_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-06-26T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 55,
  balance: -19279.28,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 9,
    rawRowText: "MAINTENANCE FEE; 55.00; -19279.28",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "maintenance fee",
    clarificationStatus: "clarified",
    amountZar: 55,
    bankChargeZar: null,
    balanceZar: -19279.28
},
  notes: "Maintenance fee."
});
LET $tx_stmt_2025_07_21_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-06-26T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 55,
  balance: -19279.28,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_maintenance_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Maintenance fee."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_07_21_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_09.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_09.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-07-10T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 7000,
  balance: -12279.28,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 10,
    rawRowText: "MPIRE DIGITAL MARKET; 7000.00; -12279.28",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 7000,
    bankChargeZar: null,
    balanceZar: -12279.28
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_07_21_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-07-10T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 7000,
  balance: -12279.28,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "MPIRE Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_07_21_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_10.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_10.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-07-10T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 6720,
  balance: -18999.28,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 11,
    rawRowText: "CREDIT CRD - 4922130003088996; 6720.00; -18999.28",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6720,
    bankChargeZar: null,
    balanceZar: -18999.28
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_07_21_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-07-10T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 6720,
  balance: -18999.28,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer out to settle the credit card."
});
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_07_21_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_11.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_11.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-07-16T00:00:00Z",
  description: "INT JUSTINVEST 573895529995",
  normalizedDescription: "INT JUSTINVEST 573895529995",
  amount: 3.48,
  balance: -18995.8,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 12,
    rawRowText: "INT JUSTINVEST 573895529995; 3.48; -18995.80",
    transactionType: "expense",
    normalizedMerchant: "INT JUSTINVEST 573895529995",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 3.48,
    bankChargeZar: null,
    balanceZar: -18995.8
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_21_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-07-16T00:00:00Z",
  description: "INT JUSTINVEST 573895529995",
  normalizedDescription: "INT JUSTINVEST 573895529995",
  amount: 3.48,
  balance: -18995.8,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "INT JUSTINVEST 573895529995",
  merchant: $merchant_int_justinvest_573895529995,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_07_21_row_12.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_12.id, "TransactionMerchant", $merchant_int_justinvest_573895529995.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_12.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_21_row_12 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-21-row-12",
  transaction: $tx_stmt_2025_07_21_row_12,
  status: "open",
  question: "What is the exact purpose of this INT JUSTINVEST 573895529995 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_int_justinvest_573895529995,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-21.import.md"
});
fn::createEdge($tx_stmt_2025_07_21_row_12.id, "TransactionClarificationTasks", $task_stmt_2025_07_21_row_12.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-07-16T00:00:00Z",
  description: "CAP JUSTINVEST 573895529995",
  normalizedDescription: "CAP JUSTINVEST 573895529995",
  amount: 1000.17,
  balance: -17995.63,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 13,
    rawRowText: "CAP JUSTINVEST 573895529995; 1000.17; -17995.63",
    transactionType: "expense",
    normalizedMerchant: "CAP JUSTINVEST 573895529995",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1000.17,
    bankChargeZar: null,
    balanceZar: -17995.63
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_07_21_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-07-16T00:00:00Z",
  description: "CAP JUSTINVEST 573895529995",
  normalizedDescription: "CAP JUSTINVEST 573895529995",
  amount: 1000.17,
  balance: -17995.63,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "CAP JUSTINVEST 573895529995",
  merchant: $merchant_cap_justinvest_573895529995,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_07_21_row_13.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_13.id, "TransactionMerchant", $merchant_cap_justinvest_573895529995.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_13.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_07_21_row_13 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-07-21-row-13",
  transaction: $tx_stmt_2025_07_21_row_13,
  status: "open",
  question: "What is the exact purpose of this CAP JUSTINVEST 573895529995 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_cap_justinvest_573895529995,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-07-21.import.md"
});
fn::createEdge($tx_stmt_2025_07_21_row_13.id, "TransactionClarificationTasks", $task_stmt_2025_07_21_row_13.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-07-16T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1100,
  balance: -16895.63,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 14,
    rawRowText: "MPIRE DIGITAL MARKET; 1100.00; -16895.63",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1100,
    bankChargeZar: null,
    balanceZar: -16895.63
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_07_21_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-07-16T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1100,
  balance: -16895.63,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "MPIRE Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_07_21_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_14.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_14.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-07-16T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1100,
  balance: -17995.63,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 15,
    rawRowText: "CREDIT CRD - 4922130003088996; 1100.00; -17995.63",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1100,
    bankChargeZar: null,
    balanceZar: -17995.63
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_07_21_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-07-16T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1100,
  balance: -17995.63,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer out to settle the credit card."
});
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_07_21_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_15.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_15.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-07-16T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1000,
  balance: -18995.63,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jun 2025 - 21 Jul 2025.pdf",
    statementPeriodStart: "2025-06-21",
    statementPeriodEnd: "2025-07-21",
    rowNo: 16,
    rawRowText: "CREDIT CRD - 4922130003088996; 1000.00; -18995.63",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: -18995.63
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_07_21_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-07-21-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-07-16T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1000,
  balance: -18995.63,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Transfer out to settle the credit card."
});
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_07_21_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_07_21_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_07_21_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_16.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_07_21_row_16.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 16,
  normalizedCount: 16,
  clarificationCount: 3,
  status: "matched",
  statementDate: "2025-07-21T00:00:00Z",
  notes: "Imported from 2025-07-21.import.md"
});

-- End of generated import
