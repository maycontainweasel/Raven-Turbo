-- Generated from docs/statements/personal/current/2025-04-19.import.md
-- Source: docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf

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
  openingBalance: 18989.85,
  active: true,
  notes: "Imported from 20 Mar 2025 - 19 Apr 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-04-19-nedbank-current",
  sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-04-19T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-04-19.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-19.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-04-19.import.md"
});
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-19.import.md"
});
LET $cat_debt_payment_reversal = fn::createCategory({
  space: $space,
  key: "debt-payment-reversal",
  name: "Debt payment reversal",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-04-19.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-04-19.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-04-19.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-19.import.md"
});
LET $cat_fees_overdraft_interest = fn::createCategory({
  space: $space,
  key: "fees-overdraft-interest",
  name: "Overdraft Interest",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-19.import.md"
});
LET $cat_fees_overdraft_facility_fee = fn::createCategory({
  space: $space,
  key: "fees-overdraft-facility-fee",
  name: "Overdraft Facility Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-19.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-19.import.md"
});
LET $cat_fees_insufficient_funds_alert_fee = fn::createCategory({
  space: $space,
  key: "fees-insufficient-funds-alert-fee",
  name: "Insufficient Funds Alert Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-04-19.import.md"
});

-- Merchant records
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-04-19.import.md"
});
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "MPIRE Digital Market",
  normalizedName: "MPIRE Digital Market",
  active: true,
  notes: "Imported from 2025-04-19.import.md"
});
LET $merchant_nedbank_credit_card = fn::createMerchant({
  space: $space,
  key: "nedbank-credit-card",
  name: "Nedbank Credit Card",
  normalizedName: "Nedbank Credit Card",
  active: true,
  notes: "Imported from 2025-04-19.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-03-27T00:00:00Z",
  description: "VAT 25/02-26/03 = R16.17",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -18989.85,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 1,
    rawRowText: "VAT 25/02-26/03 = R16.17; 0.00; -18989.85",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: -18989.85
},
  notes: "VAT summary row for bank charges period."
});
LET $tx_stmt_2025_04_19_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-03-27T00:00:00Z",
  description: "VAT 25/02-26/03 = R16.17",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -18989.85,
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_04_19_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_01.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_01.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-01" AND transaction = $tx_stmt_2025_04_19_row_01.id AND status = "open";

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-03-27T00:00:00Z",
  description: "INTEREST 25/02 - 26/03",
  normalizedDescription: "Overdraft Interest",
  amount: 181.22,
  balance: -19171.07,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 2,
    rawRowText: "INTEREST 25/02 - 26/03; 181.22; -19171.07",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft interest",
    clarificationStatus: "clarified",
    amountZar: 181.22,
    bankChargeZar: null,
    balanceZar: -19171.07
},
  notes: "Overdraft interest charge."
});
LET $tx_stmt_2025_04_19_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-03-27T00:00:00Z",
  description: "INTEREST 25/02 - 26/03",
  normalizedDescription: "Overdraft Interest",
  amount: 181.22,
  balance: -19171.07,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_04_19_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_02.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_02.id, "TransactionCategory", $cat_fees_overdraft_interest.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-02" AND transaction = $tx_stmt_2025_04_19_row_02.id AND status = "open";

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-03-27T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -19240.07,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 3,
    rawRowText: "Facility Fee; 69.00; -19240.07",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft facility fee",
    clarificationStatus: "clarified",
    amountZar: 69,
    bankChargeZar: null,
    balanceZar: -19240.07
},
  notes: "Overdraft facility fee."
});
LET $tx_stmt_2025_04_19_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-03-27T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -19240.07,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_04_19_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_03.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_03.id, "TransactionCategory", $cat_fees_overdraft_facility_fee.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-03" AND transaction = $tx_stmt_2025_04_19_row_03.id AND status = "open";

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-03-27T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 55,
  balance: -19295.07,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 4,
    rawRowText: "MAINTENANCE FEE; 55.00; -19295.07",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "maintenance fee",
    clarificationStatus: "clarified",
    amountZar: 55,
    bankChargeZar: null,
    balanceZar: -19295.07
},
  notes: "Maintenance fee."
});
LET $tx_stmt_2025_04_19_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-03-27T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 55,
  balance: -19295.07,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_04_19_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_04.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_04.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-04" AND transaction = $tx_stmt_2025_04_19_row_04.id AND status = "open";

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-03-28T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2500,
  balance: -16795.07,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 5,
    rawRowText: "MPIRE DIGITAL MARKET; 2500.00; -16795.07",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2500,
    bankChargeZar: null,
    balanceZar: -16795.07
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_04_19_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-03-28T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2500,
  balance: -16795.07,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_04_19_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_05.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_05.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-05" AND transaction = $tx_stmt_2025_04_19_row_05.id AND status = "open";

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-03-28T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2200,
  balance: -18995.07,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 6,
    rawRowText: "CREDIT CRD - 4922130003088996; 2200.00; -18995.07",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2200,
    bankChargeZar: null,
    balanceZar: -18995.07
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_04_19_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-03-28T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2200,
  balance: -18995.07,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_04_19_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_06.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_06.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-06" AND transaction = $tx_stmt_2025_04_19_row_06.id AND status = "open";

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-03-31T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1000,
  balance: -17995.07,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 7,
    rawRowText: "MPIRE DIGITAL MARKET; 1000.00; -17995.07",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: -17995.07
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_04_19_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-03-31T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1000,
  balance: -17995.07,
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
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_04_19_row_07.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_07.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_07.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-07" AND transaction = $tx_stmt_2025_04_19_row_07.id AND status = "open";

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-03-31T00:00:00Z",
  description: "A P O PAYMENT 5898460810785253",
  normalizedDescription: "Nedbank Credit Card",
  amount: 3150,
  balance: -21145.07,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 8,
    rawRowText: "A P O PAYMENT 5898460810785253; 3150.00; -21145.07",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 3150,
    bankChargeZar: 5,
    balanceZar: -21145.07
},
  notes: "Automatic payment order toward the credit-card debt."
});
LET $tx_stmt_2025_04_19_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-03-31T00:00:00Z",
  description: "A P O PAYMENT 5898460810785253",
  normalizedDescription: "Nedbank Credit Card",
  amount: 3150,
  balance: -21145.07,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_debt_payment,
  isTransfer: true,
  manualOverride: false,
  notes: "Automatic payment order toward the credit-card debt."
});
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_04_19_row_08.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_08.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_08.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-08" AND transaction = $tx_stmt_2025_04_19_row_08.id AND status = "open";

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-04-01T00:00:00Z",
  description: "No funds alert SMS fee",
  normalizedDescription: "Insufficient Funds Alert Fee",
  amount: 10,
  balance: -21155.07,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 9,
    rawRowText: "No funds alert SMS fee; 10.00; -21155.07",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "insufficient funds alert fee",
    clarificationStatus: "clarified",
    amountZar: 10,
    bankChargeZar: null,
    balanceZar: -21155.07
},
  notes: "Penalty / alert fee because the account did not have enough funds for a debit."
});
LET $tx_stmt_2025_04_19_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-04-01T00:00:00Z",
  description: "No funds alert SMS fee",
  normalizedDescription: "Insufficient Funds Alert Fee",
  amount: 10,
  balance: -21155.07,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank",
  merchant: $merchant_nedbank,
  category: $cat_fees_insufficient_funds_alert_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "Penalty / alert fee because the account did not have enough funds for a debit."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_04_19_row_09.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_09.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_09.id, "TransactionCategory", $cat_fees_insufficient_funds_alert_fee.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-09" AND transaction = $tx_stmt_2025_04_19_row_09.id AND status = "open";

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-04-02T00:00:00Z",
  description: "REV_5898460810785253",
  normalizedDescription: "Nedbank Credit Card",
  amount: 3150,
  balance: -18005.07,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 10,
    rawRowText: "REV_5898460810785253; 3150.00; -18005.07",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment reversal",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 3150,
    bankChargeZar: null,
    balanceZar: -18005.07
},
  notes: "Reversal of the automatic debt payment because there were not enough funds."
});
LET $tx_stmt_2025_04_19_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-04-02T00:00:00Z",
  description: "REV_5898460810785253",
  normalizedDescription: "Nedbank Credit Card",
  amount: 3150,
  balance: -18005.07,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Nedbank Credit Card",
  merchant: $merchant_nedbank_credit_card,
  category: $cat_debt_payment_reversal,
  isTransfer: true,
  manualOverride: false,
  notes: "Reversal of the automatic debt payment because there were not enough funds."
});
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_04_19_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_10.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_10.id, "TransactionCategory", $cat_debt_payment_reversal.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-10" AND transaction = $tx_stmt_2025_04_19_row_10.id AND status = "open";

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-04-05T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 25000,
  balance: 6994.93,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 11,
    rawRowText: "MPIRE DIGITAL MARKET; 25000.00; 6994.93",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 25000,
    bankChargeZar: null,
    balanceZar: 6994.93
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_04_19_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-04-05T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 25000,
  balance: 6994.93,
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_04_19_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_11.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_11.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-11" AND transaction = $tx_stmt_2025_04_19_row_11.id AND status = "open";

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-04-05T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 25900,
  balance: -18905.07,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 12,
    rawRowText: "CREDIT CRD - 4922130003088996; 25900.00; -18905.07",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 25900,
    bankChargeZar: null,
    balanceZar: -18905.07
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_04_19_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-04-05T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 25900,
  balance: -18905.07,
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
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_04_19_row_12.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_12.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_12.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-12" AND transaction = $tx_stmt_2025_04_19_row_12.id AND status = "open";

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-04-11T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 12000,
  balance: -6905.07,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 13,
    rawRowText: "MPIRE DIGITAL MARKET; 12000.00; -6905.07",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 12000,
    bankChargeZar: null,
    balanceZar: -6905.07
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_04_19_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-04-11T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 12000,
  balance: -6905.07,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_04_19_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_13.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_13.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-13" AND transaction = $tx_stmt_2025_04_19_row_13.id AND status = "open";

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-04-11T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 12000,
  balance: -18905.07,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 14,
    rawRowText: "CREDIT CRD - 4922130003088996; 12000.00; -18905.07",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 12000,
    bankChargeZar: null,
    balanceZar: -18905.07
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_04_19_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-04-11T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 12000,
  balance: -18905.07,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_04_19_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_14.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_14.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-14" AND transaction = $tx_stmt_2025_04_19_row_14.id AND status = "open";

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-04-17T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 4500,
  balance: -14405.07,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 15,
    rawRowText: "MPIRE DIGITAL MARKET; 4500.00; -14405.07",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 4500,
    bankChargeZar: null,
    balanceZar: -14405.07
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_04_19_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-04-17T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 4500,
  balance: -14405.07,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_04_19_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_15.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_15.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-15" AND transaction = $tx_stmt_2025_04_19_row_15.id AND status = "open";

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-04-17T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 4500,
  balance: -18905.07,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/20 Mar 2025 - 19 Apr 2025.pdf",
    statementPeriodStart: "2025-03-20",
    statementPeriodEnd: "2025-04-19",
    rowNo: 16,
    rawRowText: "CREDIT CRD - 4922130003088996; 4500.00; -18905.07",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 4500,
    bankChargeZar: null,
    balanceZar: -18905.07
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_04_19_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-04-19-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-04-17T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 4500,
  balance: -18905.07,
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
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_04_19_row_16.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_04_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_04_19_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_16.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_04_19_row_16.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });
UPDATE clarificationTask SET status = "resolved", resolutionNotes = "Resolved by regenerated statement import after the source row was clarified.", resolvedAt = time::now() WHERE key = "stmt-2025-04-19-row-16" AND transaction = $tx_stmt_2025_04_19_row_16.id AND status = "open";

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 16,
  normalizedCount: 16,
  clarificationCount: 0,
  status: "matched",
  statementDate: "2025-04-19T00:00:00Z",
  notes: "Imported from 2025-04-19.import.md"
});

-- End of generated import
