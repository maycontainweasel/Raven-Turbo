-- Generated from docs/statements/personal/current/2025-08-21.import.md
-- Source: docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf

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
  openingBalance: 18995.63,
  active: true,
  notes: "Imported from 21 Jul 2025 - 21 Aug 2025.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-08-21-nedbank-current",
  sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-08-21T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-08-21.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $cat_debt_payment = fn::createCategory({
  space: $space,
  key: "debt-payment",
  name: "Debt payment",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $cat_fees_vat_on_fees = fn::createCategory({
  space: $space,
  key: "fees-vat-on-fees",
  name: "Vat On Fees",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $cat_fees_overdraft_interest = fn::createCategory({
  space: $space,
  key: "fees-overdraft-interest",
  name: "Overdraft Interest",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $cat_fees_overdraft_facility_fee = fn::createCategory({
  space: $space,
  key: "fees-overdraft-facility-fee",
  name: "Overdraft Facility Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $cat_fees_maintenance_fee = fn::createCategory({
  space: $space,
  key: "fees-maintenance-fee",
  name: "Maintenance Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});

-- Merchant records
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "MPIRE Digital Market",
  normalizedName: "MPIRE Digital Market",
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $merchant_nedbank_credit_card = fn::createMerchant({
  space: $space,
  key: "nedbank-credit-card",
  name: "Nedbank Credit Card",
  normalizedName: "Nedbank Credit Card",
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $merchant_nedbank = fn::createMerchant({
  space: $space,
  key: "nedbank",
  name: "Nedbank",
  normalizedName: "Nedbank",
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $merchant_a_p_o_payment_5898460810785253 = fn::createMerchant({
  space: $space,
  key: "a-p-o-payment-5898460810785253",
  name: "A P O PAYMENT 5898460810785253",
  normalizedName: "A P O PAYMENT 5898460810785253",
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $merchant_no_funds_alert_sms_fee = fn::createMerchant({
  space: $space,
  key: "no-funds-alert-sms-fee",
  name: "No funds alert SMS fee",
  normalizedName: "No funds alert SMS fee",
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $merchant_rev_5898460810785253 = fn::createMerchant({
  space: $space,
  key: "rev-5898460810785253",
  name: "REV_5898460810785253",
  normalizedName: "REV_5898460810785253",
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $merchant_debit_rate_decreased_to_11_50 = fn::createMerchant({
  space: $space,
  key: "debit-rate-decreased-to-11-50",
  name: "DEBIT RATE DECREASED TO 11,50%",
  normalizedName: "DEBIT RATE DECREASED TO 11,50%",
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});
LET $merchant_investecpbgowjow = fn::createMerchant({
  space: $space,
  key: "investecpbgowjow",
  name: "INVESTECPBGowjow",
  normalizedName: "INVESTECPBGowjow",
  active: true,
  notes: "Imported from 2025-08-21.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-07-25T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 3500,
  balance: -15495.63,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 1,
    rawRowText: "MPIRE DIGITAL MARKET; 3500.00; -15495.63",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 3500,
    bankChargeZar: null,
    balanceZar: -15495.63
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_08_21_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-07-25T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 3500,
  balance: -15495.63,
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
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_08_21_row_01.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_01.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_01.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-07-25T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 3500,
  balance: -18995.63,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 2,
    rawRowText: "CREDIT CRD - 4922130003088996; 3500.00; -18995.63",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 3500,
    bankChargeZar: null,
    balanceZar: -18995.63
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_08_21_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-07-25T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 3500,
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
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_08_21_row_02.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_02.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_02.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-07-28T00:00:00Z",
  description: "VAT 26/06-27/07 = R16.17",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -18995.63,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 3,
    rawRowText: "VAT 26/06-27/07 = R16.17; 0.00; -18995.63",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "vat on fees",
    clarificationStatus: "clarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: -18995.63
},
  notes: "VAT summary row for bank charges period."
});
LET $tx_stmt_2025_08_21_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-07-28T00:00:00Z",
  description: "VAT 26/06-27/07 = R16.17",
  normalizedDescription: "Vat On Fees",
  amount: 0,
  balance: -18995.63,
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
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_08_21_row_03.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_03.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_03.id, "TransactionCategory", $cat_fees_vat_on_fees.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-07-28T00:00:00Z",
  description: "INTEREST 26/06 - 27/07",
  normalizedDescription: "Overdraft Interest",
  amount: 196.97,
  balance: -19192.6,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 4,
    rawRowText: "INTEREST 26/06 - 27/07; 196.97; -19192.60",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft interest",
    clarificationStatus: "clarified",
    amountZar: 196.97,
    bankChargeZar: null,
    balanceZar: -19192.6
},
  notes: "Overdraft interest charge."
});
LET $tx_stmt_2025_08_21_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-07-28T00:00:00Z",
  description: "INTEREST 26/06 - 27/07",
  normalizedDescription: "Overdraft Interest",
  amount: 196.97,
  balance: -19192.6,
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
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_08_21_row_04.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_04.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_04.id, "TransactionCategory", $cat_fees_overdraft_interest.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-07-28T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -19261.6,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 5,
    rawRowText: "Facility Fee; 69.00; -19261.60",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "overdraft facility fee",
    clarificationStatus: "clarified",
    amountZar: 69,
    bankChargeZar: null,
    balanceZar: -19261.6
},
  notes: "Overdraft facility fee."
});
LET $tx_stmt_2025_08_21_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-07-28T00:00:00Z",
  description: "Facility Fee",
  normalizedDescription: "Overdraft Facility Fee",
  amount: 69,
  balance: -19261.6,
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
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_08_21_row_05.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_05.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_05.id, "TransactionCategory", $cat_fees_overdraft_facility_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-07-28T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 55,
  balance: -19316.6,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 6,
    rawRowText: "MAINTENANCE FEE; 55.00; -19316.60",
    transactionType: "fee",
    normalizedMerchant: "Nedbank",
    category: "Fees",
    feeType: "maintenance fee",
    clarificationStatus: "clarified",
    amountZar: 55,
    bankChargeZar: null,
    balanceZar: -19316.6
},
  notes: "Maintenance fee."
});
LET $tx_stmt_2025_08_21_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-07-28T00:00:00Z",
  description: "MAINTENANCE FEE",
  normalizedDescription: "Maintenance Fee",
  amount: 55,
  balance: -19316.6,
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
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_08_21_row_06.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_06.id, "TransactionMerchant", $merchant_nedbank.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_06.id, "TransactionCategory", $cat_fees_maintenance_fee.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-07-30T00:00:00Z",
  description: "A P O PAYMENT 5898460810785253",
  normalizedDescription: "A P O PAYMENT 5898460810785253",
  amount: 1970,
  balance: -21286.6,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 7,
    rawRowText: "A P O PAYMENT 5898460810785253; 1970.00; -21286.60",
    transactionType: "expense",
    normalizedMerchant: "A P O PAYMENT 5898460810785253",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1970,
    bankChargeZar: 5,
    balanceZar: -21286.6
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_21_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-07-30T00:00:00Z",
  description: "A P O PAYMENT 5898460810785253",
  normalizedDescription: "A P O PAYMENT 5898460810785253",
  amount: 1970,
  balance: -21286.6,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "A P O PAYMENT 5898460810785253",
  merchant: $merchant_a_p_o_payment_5898460810785253,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_08_21_row_07.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_07.id, "TransactionMerchant", $merchant_a_p_o_payment_5898460810785253.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_07.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_21_row_07 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-21-row-07",
  transaction: $tx_stmt_2025_08_21_row_07,
  status: "open",
  question: "What is the exact purpose of this A P O PAYMENT 5898460810785253 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_a_p_o_payment_5898460810785253,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-21.import.md"
});
fn::createEdge($tx_stmt_2025_08_21_row_07.id, "TransactionClarificationTasks", $task_stmt_2025_08_21_row_07.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-07-31T00:00:00Z",
  description: "No funds alert SMS fee",
  normalizedDescription: "No funds alert SMS fee",
  amount: 10,
  balance: -21296.6,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 8,
    rawRowText: "No funds alert SMS fee; 10.00; -21296.60",
    transactionType: "expense",
    normalizedMerchant: "No funds alert SMS fee",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 10,
    bankChargeZar: null,
    balanceZar: -21296.6
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_21_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-07-31T00:00:00Z",
  description: "No funds alert SMS fee",
  normalizedDescription: "No funds alert SMS fee",
  amount: 10,
  balance: -21296.6,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "No funds alert SMS fee",
  merchant: $merchant_no_funds_alert_sms_fee,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_08_21_row_08.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_08.id, "TransactionMerchant", $merchant_no_funds_alert_sms_fee.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_08.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_21_row_08 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-21-row-08",
  transaction: $tx_stmt_2025_08_21_row_08,
  status: "open",
  question: "What is the exact purpose of this No funds alert SMS fee transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_no_funds_alert_sms_fee,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-21.import.md"
});
fn::createEdge($tx_stmt_2025_08_21_row_08.id, "TransactionClarificationTasks", $task_stmt_2025_08_21_row_08.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-08-01T00:00:00Z",
  description: "REV_5898460810785253",
  normalizedDescription: "REV_5898460810785253",
  amount: 1970,
  balance: -19326.6,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 9,
    rawRowText: "REV_5898460810785253; 1970.00; -19326.60",
    transactionType: "expense",
    normalizedMerchant: "REV_5898460810785253",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1970,
    bankChargeZar: null,
    balanceZar: -19326.6
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_21_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-08-01T00:00:00Z",
  description: "REV_5898460810785253",
  normalizedDescription: "REV_5898460810785253",
  amount: 1970,
  balance: -19326.6,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "REV_5898460810785253",
  merchant: $merchant_rev_5898460810785253,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_08_21_row_09.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_09.id, "TransactionMerchant", $merchant_rev_5898460810785253.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_09.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_21_row_09 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-21-row-09",
  transaction: $tx_stmt_2025_08_21_row_09,
  status: "open",
  question: "What is the exact purpose of this REV_5898460810785253 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_rev_5898460810785253,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-21.import.md"
});
fn::createEdge($tx_stmt_2025_08_21_row_09.id, "TransactionClarificationTasks", $task_stmt_2025_08_21_row_09.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-08-01T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 5000,
  balance: -14326.6,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 10,
    rawRowText: "MPIRE DIGITAL MARKET; 5000.00; -14326.60",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 5000,
    bankChargeZar: null,
    balanceZar: -14326.6
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_08_21_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-08-01T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 5000,
  balance: -14326.6,
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
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_08_21_row_10.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_10.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_10.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-08-01T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2700,
  balance: -17026.6,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 11,
    rawRowText: "CREDIT CRD - 4922130003088996; 2700.00; -17026.60",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2700,
    bankChargeZar: null,
    balanceZar: -17026.6
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_08_21_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-08-01T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2700,
  balance: -17026.6,
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
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_08_21_row_11.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_11.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_11.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-08-01T00:00:00Z",
  description: "DEBIT RATE DECREASED TO 11,50%",
  normalizedDescription: "DEBIT RATE DECREASED TO 11,50%",
  amount: 0,
  balance: -17026.6,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 12,
    rawRowText: "DEBIT RATE DECREASED TO 11,50%; 0.00; -17026.60",
    transactionType: "expense",
    normalizedMerchant: "DEBIT RATE DECREASED TO 11,50%",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 0,
    bankChargeZar: null,
    balanceZar: -17026.6
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_21_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-08-01T00:00:00Z",
  description: "DEBIT RATE DECREASED TO 11,50%",
  normalizedDescription: "DEBIT RATE DECREASED TO 11,50%",
  amount: 0,
  balance: -17026.6,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "DEBIT RATE DECREASED TO 11,50%",
  merchant: $merchant_debit_rate_decreased_to_11_50,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_08_21_row_12.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_12.id, "TransactionMerchant", $merchant_debit_rate_decreased_to_11_50.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_12.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_21_row_12 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-21-row-12",
  transaction: $tx_stmt_2025_08_21_row_12,
  status: "open",
  question: "What is the exact purpose of this DEBIT RATE DECREASED TO 11,50% transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_debit_rate_decreased_to_11_50,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-21.import.md"
});
fn::createEdge($tx_stmt_2025_08_21_row_12.id, "TransactionClarificationTasks", $task_stmt_2025_08_21_row_12.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-08-04T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1973,
  balance: -18999.6,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 13,
    rawRowText: "CREDIT CRD - 4922130003088996; 1973.00; -18999.60",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1973,
    bankChargeZar: null,
    balanceZar: -18999.6
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_08_21_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-08-04T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1973,
  balance: -18999.6,
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
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_08_21_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_13.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_13.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-08-13T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2000,
  balance: -16999.6,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 14,
    rawRowText: "MPIRE DIGITAL MARKET; 2000.00; -16999.60",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: -16999.6
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_08_21_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-08-13T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 2000,
  balance: -16999.6,
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
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_08_21_row_14.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_14.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_14.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-08-13T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1680,
  balance: -15319.6,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 15,
    rawRowText: "MPIRE DIGITAL MARKET; 1680.00; -15319.60",
    transactionType: "income",
    normalizedMerchant: "MPIRE Digital Market",
    category: "Income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1680,
    bankChargeZar: null,
    balanceZar: -15319.6
},
  notes: "Owner draw or business-to-personal payment from MPIRE."
});
LET $tx_stmt_2025_08_21_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-08-13T00:00:00Z",
  description: "MPIRE DIGITAL MARKET",
  normalizedDescription: "MPIRE Digital Market",
  amount: 1680,
  balance: -15319.6,
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
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_08_21_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_15.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_15.id, "TransactionCategory", $cat_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-08-13T00:00:00Z",
  description: "INVESTECPBGowjow",
  normalizedDescription: "INVESTECPBGowjow",
  amount: 4045,
  balance: -11274.6,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 16,
    rawRowText: "INVESTECPBGowjow; 4045.00; -11274.60",
    transactionType: "expense",
    normalizedMerchant: "INVESTECPBGowjow",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 4045,
    bankChargeZar: null,
    balanceZar: -11274.6
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_08_21_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-08-13T00:00:00Z",
  description: "INVESTECPBGowjow",
  normalizedDescription: "INVESTECPBGowjow",
  amount: 4045,
  balance: -11274.6,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "INVESTECPBGowjow",
  merchant: $merchant_investecpbgowjow,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_08_21_row_16.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_16.id, "TransactionMerchant", $merchant_investecpbgowjow.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_16.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_08_21_row_16 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-08-21-row-16",
  transaction: $tx_stmt_2025_08_21_row_16,
  status: "open",
  question: "What is the exact purpose of this INVESTECPBGowjow transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_investecpbgowjow,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-08-21.import.md"
});
fn::createEdge($tx_stmt_2025_08_21_row_16.id, "TransactionClarificationTasks", $task_stmt_2025_08_21_row_16.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-08-13T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -13274.6,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 17,
    rawRowText: "CREDIT CRD - 4922130003088996; 2000.00; -13274.60",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 2000,
    bankChargeZar: null,
    balanceZar: -13274.6
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_08_21_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-08-13T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 2000,
  balance: -13274.6,
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
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_08_21_row_17.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_17.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_17.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-08-13T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1680,
  balance: -14954.6,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 18,
    rawRowText: "CREDIT CRD - 4922130003088996; 1680.00; -14954.60",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 1680,
    bankChargeZar: null,
    balanceZar: -14954.6
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_08_21_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-08-13T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 1680,
  balance: -14954.6,
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
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_08_21_row_18.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_18.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_18.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-08-15T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 4045,
  balance: -18999.6,
  currency: "ZAR",
  direction: "transfer",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/personal/current/21 Jul 2025 - 21 Aug 2025.pdf",
    statementPeriodStart: "2025-07-21",
    statementPeriodEnd: "2025-08-21",
    rowNo: 19,
    rawRowText: "CREDIT CRD - 4922130003088996; 4045.00; -18999.60",
    transactionType: "transfer",
    normalizedMerchant: "Nedbank Credit Card",
    category: "Debt payment",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 4045,
    bankChargeZar: null,
    balanceZar: -18999.6
},
  notes: "Transfer out to settle the credit card."
});
LET $tx_stmt_2025_08_21_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-08-21-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-08-15T00:00:00Z",
  description: "CREDIT CRD - 4922130003088996",
  normalizedDescription: "Nedbank Credit Card",
  amount: 4045,
  balance: -18999.6,
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
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_08_21_row_19.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_08_21_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_08_21_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_19.id, "TransactionMerchant", $merchant_nedbank_credit_card.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_08_21_row_19.id, "TransactionCategory", $cat_debt_payment.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 19,
  normalizedCount: 19,
  clarificationCount: 5,
  status: "matched",
  statementDate: "2025-08-21T00:00:00Z",
  notes: "Imported from 2025-08-21.import.md"
});

-- End of generated import
