-- Generated from docs/statements/business/2025-06-18.import.md
-- Source: docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf

USE NS raven DB raven1;

-- Base environment and account
LET $space = fn::createFinancialSpace({
  key: "mpire-business",
  name: "MPIRE Business",
  spaceType: "business",
  currency: "ZAR",
  active: true,
  description: "Business banking environment for MPIRE"
});
LET $account = fn::createAccount({
  space: $space,
  key: "fnb-gold-business-27821",
  name: "FNB Gold Business Account",
  bankName: "FNB",
  accountType: "current",
  currency: "ZAR",
  accountNumberLast4: "27821",
  openingBalance: 839.94,
  active: true,
  notes: "Imported from GOLD_BUSINESS_ACCOUNT_80.pdf"
});
fn::createEdge($space.id, "FinancialSpaceAccounts", $account.id, { boundId: true, overwrite: false, skipExists: true });

-- Statement import batch
LET $import = fn::createStatementImport({
  space: $space,
  account: $account,
  key: "2025-06-18-fnb-gold-business-27821",
  sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
  sourceFormat: "pdf",
  importedAt: time::now(),
  statementDate: "2025-06-18T00:00:00Z",
  status: "matched",
  rowCount: 0,
  normalizedCount: 0,
  clarificationCount: 0,
  sourceChecksum: "",
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($account.id, "AccountStatementImports", $import.id, { boundId: true, overwrite: false, skipExists: true });

-- Category records
LET $cat_internal_transfer = fn::createCategory({
  space: $space,
  key: "internal-transfer",
  name: "Internal transfer",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_transfer = fn::createCategory({
  space: $space,
  key: "transfer",
  name: "Transfer",
  categoryKind: "transfer",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_fees = fn::createCategory({
  space: $space,
  key: "fees",
  name: "Fees",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_software_saas = fn::createCategory({
  space: $space,
  key: "software-saas",
  name: "Software / SaaS",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_unclassified = fn::createCategory({
  space: $space,
  key: "unclassified",
  name: "Unclassified",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_client_income = fn::createCategory({
  space: $space,
  key: "client-income",
  name: "Client income",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_insurance = fn::createCategory({
  space: $space,
  key: "insurance",
  name: "Insurance",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_hosting_internet = fn::createCategory({
  space: $space,
  key: "hosting-internet",
  name: "Hosting / internet",
  categoryKind: "expense",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_income = fn::createCategory({
  space: $space,
  key: "income",
  name: "Income",
  categoryKind: "income",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_reversal_refund = fn::createCategory({
  space: $space,
  key: "reversal-refund",
  name: "Reversal / refund",
  categoryKind: "other",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_fees_bank_fee = fn::createCategory({
  space: $space,
  key: "fees-bank-fee",
  name: "Bank Fee",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $cat_fees_card_charge = fn::createCategory({
  space: $space,
  key: "fees-card-charge",
  name: "Card Charge",
  categoryKind: "expense",
  parentCategory: $cat_fees,
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});

-- Merchant records
LET $merchant_mpire_digital_market = fn::createMerchant({
  space: $space,
  key: "mpire-digital-market",
  name: "Mpire Digital Market",
  normalizedName: "Mpire Digital Market",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_magtape_credit = fn::createMerchant({
  space: $space,
  key: "magtape-credit",
  name: "Magtape Credit",
  normalizedName: "Magtape Credit",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_fnb = fn::createMerchant({
  space: $space,
  key: "fnb",
  name: "FNB",
  normalizedName: "FNB",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_paypal = fn::createMerchant({
  space: $space,
  key: "paypal",
  name: "PayPal",
  normalizedName: "PayPal",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_internet_pmt_to_nectar_design_stage_phil_ux_stage_1 = fn::createMerchant({
  space: $space,
  key: "internet-pmt-to-nectar-design-stage-phil-ux-stage-1",
  name: "Internet Pmt To Nectar Design Stage Phil Ux Stage 1",
  normalizedName: "Internet Pmt To Nectar Design Stage Phil Ux Stage 1",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_cursor = fn::createMerchant({
  space: $space,
  key: "cursor",
  name: "Cursor",
  normalizedName: "Cursor",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_sansor = fn::createMerchant({
  space: $space,
  key: "sansor",
  name: "Sansor",
  normalizedName: "Sansor",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_pos_purchase_23_00_openai_chatg_485442_7050_28_may = fn::createMerchant({
  space: $space,
  key: "pos-purchase-23-00-openai-chatg-485442-7050-28-may",
  name: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 May",
  normalizedName: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 May",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_int_banking_pmt_frm_inv_127566 = fn::createMerchant({
  space: $space,
  key: "int-banking-pmt-frm-inv-127566",
  name: "Int-Banking Pmt Frm Inv-127566",
  normalizedName: "Int-Banking Pmt Frm Inv-127566",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_outsurance = fn::createMerchant({
  space: $space,
  key: "outsurance",
  name: "Outsurance",
  normalizedName: "Outsurance",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_pos_purchase_8_38_google_gsuite_485442_7050_01_jun = fn::createMerchant({
  space: $space,
  key: "pos-purchase-8-38-google-gsuite-485442-7050-01-jun",
  name: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Jun",
  normalizedName: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Jun",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_notion = fn::createMerchant({
  space: $space,
  key: "notion",
  name: "Notion",
  normalizedName: "Notion",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_diamatrix = fn::createMerchant({
  space: $space,
  key: "diamatrix",
  name: "Diamatrix",
  normalizedName: "Diamatrix",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_internet_pmt_to_vdv_internet_mic00017 = fn::createMerchant({
  space: $space,
  key: "internet-pmt-to-vdv-internet-mic00017",
  name: "Internet Pmt To Vdv Internet Mic00017",
  normalizedName: "Internet Pmt To Vdv Internet Mic00017",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_pos_purchase_22000_00_dpo_wazoho_485442_7050_06_jun = fn::createMerchant({
  space: $space,
  key: "pos-purchase-22000-00-dpo-wazoho-485442-7050-06-jun",
  name: "POS Purchase 22000.00 Dpo*Wazoho 485442*7050 06 Jun",
  normalizedName: "POS Purchase 22000.00 Dpo*Wazoho 485442*7050 06 Jun",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_pos_purchase_19_00_magic_pattern_485442_7050_10_jun = fn::createMerchant({
  space: $space,
  key: "pos-purchase-19-00-magic-pattern-485442-7050-10-jun",
  name: "POS Purchase 19.00 Magic Pattern 485442*7050 10 Jun",
  normalizedName: "POS Purchase 19.00 Magic Pattern 485442*7050 10 Jun",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_pos_purchase_22000_00_dpo_wazoho_485442_7050_10_jun = fn::createMerchant({
  space: $space,
  key: "pos-purchase-22000-00-dpo-wazoho-485442-7050-10-jun",
  name: "POS Purchase 22000.00 Dpo*Wazoho 485442*7050 10 Jun",
  normalizedName: "POS Purchase 22000.00 Dpo*Wazoho 485442*7050 10 Jun",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});
LET $merchant_0_00 = fn::createMerchant({
  space: $space,
  key: "0-00",
  name: "0.00",
  normalizedName: "0.00",
  active: true,
  notes: "Imported from 2025-06-18.import.md"
});

-- Rows, transactions, and clarification tasks

-- Row 1
LET $row_row_01 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 1,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 200,
  balance: 639.94,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 1,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 200.00; 639.94 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 200,
    bankChargeZar: 8,
    balanceZar: 639.94
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_06_18_row_01 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-01",
  sourceRow: $row_row_01,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 200,
  balance: 639.94,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Mpire Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_internal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
fn::updateStatementRow($row_row_01.id, { transaction: $tx_stmt_2025_06_18_row_01.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_01.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_01.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_01.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_01 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-01",
  transaction: $tx_stmt_2025_06_18_row_01,
  status: "open",
  question: "What exactly is the Magtape Unpaid / Not Provided For reversal?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_01.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_01.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 2
LET $row_row_02 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 2,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Magtape Credit Estavcoppenhagen",
  normalizedDescription: "Magtape Credit",
  amount: 2430,
  balance: 3069.94,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 2,
    rawRowText: "Magtape Credit Estavcoppenhagen; 2,430.00 Cr; 3,069.94 Cr",
    transactionType: "income",
    normalizedMerchant: "Magtape Credit",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 2430,
    bankChargeZar: null,
    balanceZar: 3069.94
},
  notes: "Magtape credit or reversal still needs exact source confirmation."
});
LET $tx_stmt_2025_06_18_row_02 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-02",
  sourceRow: $row_row_02,
  postedAt: "2025-05-19T00:00:00Z",
  description: "Magtape Credit Estavcoppenhagen",
  normalizedDescription: "Magtape Credit",
  amount: 2430,
  balance: 3069.94,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Magtape Credit",
  merchant: $merchant_magtape_credit,
  category: $cat_transfer,
  isTransfer: false,
  manualOverride: false,
  notes: "Magtape credit or reversal still needs exact source confirmation."
});
fn::updateStatementRow($row_row_02.id, { transaction: $tx_stmt_2025_06_18_row_02.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_02.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_02.id, "TransactionMerchant", $merchant_magtape_credit.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_02.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_02 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-02",
  transaction: $tx_stmt_2025_06_18_row_02,
  status: "open",
  question: "What is the exact purpose of this Magtape Credit transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_magtape_credit,
  suggestedCategory: $cat_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_02.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_02.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 3
LET $row_row_03 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 3,
  postedAt: "2025-05-19T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 3063.94,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 3,
    rawRowText: "6.00; 3,063.94 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 6,
    bankChargeZar: null,
    balanceZar: 3063.94
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_06_18_row_03 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-03",
  sourceRow: $row_row_03,
  postedAt: "2025-05-19T00:00:00Z",
  description: "6.00",
  normalizedDescription: "Bank Fee",
  amount: 6,
  balance: 3063.94,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_03.id, { transaction: $tx_stmt_2025_06_18_row_03.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_03.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_03.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_03.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_03 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-03",
  transaction: $tx_stmt_2025_06_18_row_03,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_03.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_03.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 4
LET $row_row_04 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 4,
  postedAt: "2025-05-19T00:00:00Z",
  description: "POS Purchase 633.03 Paypal *Elit                                                    485442*7050 16 May",
  normalizedDescription: "PayPal",
  amount: 633.03,
  balance: 2430.91,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 4,
    rawRowText: "POS Purchase 633.03 Paypal *Elit                                                    485442*7050 16 May; 633.03; 2,430.91 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 633.03,
    bankChargeZar: 3.68,
    balanceZar: 2430.91
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_06_18_row_04 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-04",
  sourceRow: $row_row_04,
  postedAt: "2025-05-19T00:00:00Z",
  description: "POS Purchase 633.03 Paypal *Elit                                                    485442*7050 16 May",
  normalizedDescription: "PayPal",
  amount: 633.03,
  balance: 2430.91,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal",
  merchant: $merchant_paypal,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs confirmation."
});
fn::updateStatementRow($row_row_04.id, { transaction: $tx_stmt_2025_06_18_row_04.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_04.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_04.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_04.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_04 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-04",
  transaction: $tx_stmt_2025_06_18_row_04,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_04.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_04.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 5
LET $row_row_05 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 5,
  postedAt: "2025-05-20T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 1000,
  balance: 1430.91,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 5,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 1,000.00; 1,430.91 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1000,
    bankChargeZar: 8,
    balanceZar: 1430.91
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_06_18_row_05 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-05",
  sourceRow: $row_row_05,
  postedAt: "2025-05-20T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 1000,
  balance: 1430.91,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Mpire Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_internal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
fn::updateStatementRow($row_row_05.id, { transaction: $tx_stmt_2025_06_18_row_05.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_05.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_05.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_05.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_05 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-05",
  transaction: $tx_stmt_2025_06_18_row_05,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_05.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_05.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 6
LET $row_row_06 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 6,
  postedAt: "2025-05-20T00:00:00Z",
  description: "1.15",
  normalizedDescription: "Bank Fee",
  amount: 1.15,
  balance: 1429.76,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 6,
    rawRowText: "1.15; 1,429.76 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 1.15,
    bankChargeZar: null,
    balanceZar: 1429.76
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_06_18_row_06 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-06",
  sourceRow: $row_row_06,
  postedAt: "2025-05-20T00:00:00Z",
  description: "1.15",
  normalizedDescription: "Bank Fee",
  amount: 1.15,
  balance: 1429.76,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_06.id, { transaction: $tx_stmt_2025_06_18_row_06.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_06.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_06.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_06.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_06 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-06",
  transaction: $tx_stmt_2025_06_18_row_06,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_06.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_06.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 7
LET $row_row_07 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 7,
  postedAt: "2025-05-20T00:00:00Z",
  description: "2.07",
  normalizedDescription: "Bank Fee",
  amount: 2.07,
  balance: 1427.69,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 7,
    rawRowText: "2.07; 1,427.69 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 2.07,
    bankChargeZar: null,
    balanceZar: 1427.69
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_06_18_row_07 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-07",
  sourceRow: $row_row_07,
  postedAt: "2025-05-20T00:00:00Z",
  description: "2.07",
  normalizedDescription: "Bank Fee",
  amount: 2.07,
  balance: 1427.69,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_07.id, { transaction: $tx_stmt_2025_06_18_row_07.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_07.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_07.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_07.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_07 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-07",
  transaction: $tx_stmt_2025_06_18_row_07,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_07.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_07.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 8
LET $row_row_08 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 8,
  postedAt: "2025-05-20T00:00:00Z",
  description: "24.52",
  normalizedDescription: "Bank Fee",
  amount: 24.52,
  balance: 1403.17,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 8,
    rawRowText: "24.52; 1,403.17 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 24.52,
    bankChargeZar: null,
    balanceZar: 1403.17
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_06_18_row_08 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-08",
  sourceRow: $row_row_08,
  postedAt: "2025-05-20T00:00:00Z",
  description: "24.52",
  normalizedDescription: "Bank Fee",
  amount: 24.52,
  balance: 1403.17,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_08.id, { transaction: $tx_stmt_2025_06_18_row_08.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_08.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_08.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_08.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_08 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-08",
  transaction: $tx_stmt_2025_06_18_row_08,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_08.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_08.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 9
LET $row_row_09 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 9,
  postedAt: "2025-05-21T00:00:00Z",
  description: "Magtape Credit Phil Melouney",
  normalizedDescription: "Magtape Credit",
  amount: 10000,
  balance: 11403.17,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 9,
    rawRowText: "Magtape Credit Phil Melouney; 10,000.00 Cr; 11,403.17 Cr",
    transactionType: "income",
    normalizedMerchant: "Magtape Credit",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 10000,
    bankChargeZar: null,
    balanceZar: 11403.17
},
  notes: "Magtape credit or reversal still needs exact source confirmation."
});
LET $tx_stmt_2025_06_18_row_09 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-09",
  sourceRow: $row_row_09,
  postedAt: "2025-05-21T00:00:00Z",
  description: "Magtape Credit Phil Melouney",
  normalizedDescription: "Magtape Credit",
  amount: 10000,
  balance: 11403.17,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Magtape Credit",
  merchant: $merchant_magtape_credit,
  category: $cat_transfer,
  isTransfer: false,
  manualOverride: false,
  notes: "Magtape credit or reversal still needs exact source confirmation."
});
fn::updateStatementRow($row_row_09.id, { transaction: $tx_stmt_2025_06_18_row_09.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_09.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_09.id, "TransactionMerchant", $merchant_magtape_credit.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_09.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_09 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-09",
  transaction: $tx_stmt_2025_06_18_row_09,
  status: "open",
  question: "What is the exact purpose of this Magtape Credit transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_magtape_credit,
  suggestedCategory: $cat_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_09.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_09.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 10
LET $row_row_10 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 10,
  postedAt: "2025-05-22T00:00:00Z",
  description: "Internet Pmt To Nectar Design Stage                                                 Phil Ux Stage 1",
  normalizedDescription: "Internet Pmt To Nectar Design Stage Phil Ux Stage 1",
  amount: 5000,
  balance: 6403.17,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 10,
    rawRowText: "Internet Pmt To Nectar Design Stage                                                 Phil Ux Stage 1; 5,000.00; 6,403.17 Cr",
    transactionType: "expense",
    normalizedMerchant: "Internet Pmt To Nectar Design Stage Phil Ux Stage 1",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 5000,
    bankChargeZar: null,
    balanceZar: 6403.17
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_06_18_row_10 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-10",
  sourceRow: $row_row_10,
  postedAt: "2025-05-22T00:00:00Z",
  description: "Internet Pmt To Nectar Design Stage                                                 Phil Ux Stage 1",
  normalizedDescription: "Internet Pmt To Nectar Design Stage Phil Ux Stage 1",
  amount: 5000,
  balance: 6403.17,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Internet Pmt To Nectar Design Stage Phil Ux Stage 1",
  merchant: $merchant_internet_pmt_to_nectar_design_stage_phil_ux_stage_1,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_10.id, { transaction: $tx_stmt_2025_06_18_row_10.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_10.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_10.id, "TransactionMerchant", $merchant_internet_pmt_to_nectar_design_stage_phil_ux_stage_1.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_10.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_10 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-10",
  transaction: $tx_stmt_2025_06_18_row_10,
  status: "open",
  question: "What is the exact purpose of this Internet Pmt To Nectar Design Stage Phil Ux Stage 1 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_internet_pmt_to_nectar_design_stage_phil_ux_stage_1,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_10.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_10.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 11
LET $row_row_11 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 11,
  postedAt: "2025-05-23T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 5000,
  balance: 1403.17,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 11,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 5,000.00; 1,403.17 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 5000,
    bankChargeZar: 15,
    balanceZar: 1403.17
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_06_18_row_11 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-11",
  sourceRow: $row_row_11,
  postedAt: "2025-05-23T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 5000,
  balance: 1403.17,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Mpire Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_internal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
fn::updateStatementRow($row_row_11.id, { transaction: $tx_stmt_2025_06_18_row_11.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_11.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_11.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_11.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_11 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-11",
  transaction: $tx_stmt_2025_06_18_row_11,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_11.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_11.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 12
LET $row_row_12 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 12,
  postedAt: "2025-05-23T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 990,
  balance: 413.17,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 12,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 990.00; 413.17 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 990,
    bankChargeZar: 8,
    balanceZar: 413.17
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_06_18_row_12 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-12",
  sourceRow: $row_row_12,
  postedAt: "2025-05-23T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 990,
  balance: 413.17,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Mpire Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_internal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
fn::updateStatementRow($row_row_12.id, { transaction: $tx_stmt_2025_06_18_row_12.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_12.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_12.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_12.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_12 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-12",
  transaction: $tx_stmt_2025_06_18_row_12,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_12.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_12.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 13
LET $row_row_13 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 13,
  postedAt: "2025-05-26T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 23 May",
  normalizedDescription: "Cursor",
  amount: 368.73,
  balance: 44.44,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 13,
    rawRowText: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 23 May; 368.73; 44.44 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Cursor",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 368.73,
    bankChargeZar: 3.68,
    balanceZar: 44.44
},
  notes: "Cursor AI tooling spend."
});
LET $tx_stmt_2025_06_18_row_13 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-13",
  sourceRow: $row_row_13,
  postedAt: "2025-05-26T00:00:00Z",
  description: "POS Purchase 20.00 Cursor, Ai Po                                                    485442*7050 23 May",
  normalizedDescription: "Cursor",
  amount: 368.73,
  balance: 44.44,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Cursor",
  merchant: $merchant_cursor,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Cursor AI tooling spend."
});
fn::updateStatementRow($row_row_13.id, { transaction: $tx_stmt_2025_06_18_row_13.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_13.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_13.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_13.id, "TransactionMerchant", $merchant_cursor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_13.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 14
LET $row_row_14 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 14,
  postedAt: "2025-05-27T00:00:00Z",
  description: "12.66",
  normalizedDescription: "Bank Fee",
  amount: 12.66,
  balance: 31.78,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 14,
    rawRowText: "12.66; 31.78 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 12.66,
    bankChargeZar: null,
    balanceZar: 31.78
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_06_18_row_14 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-14",
  sourceRow: $row_row_14,
  postedAt: "2025-05-27T00:00:00Z",
  description: "12.66",
  normalizedDescription: "Bank Fee",
  amount: 12.66,
  balance: 31.78,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_14.id, { transaction: $tx_stmt_2025_06_18_row_14.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_14.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_14.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_14.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_14 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-14",
  transaction: $tx_stmt_2025_06_18_row_14,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_14.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_14.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 15
LET $row_row_15 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 15,
  postedAt: "2025-05-28T00:00:00Z",
  description: "FNB OB Pmt Sansor",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 6881.78,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 15,
    rawRowText: "FNB OB Pmt Sansor; 6,850.00 Cr; 6,881.78 Cr",
    transactionType: "income",
    normalizedMerchant: "Sansor",
    category: "Client income",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 6850,
    bankChargeZar: null,
    balanceZar: 6881.78
},
  notes: "Recurring client payment from Sansor."
});
LET $tx_stmt_2025_06_18_row_15 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-15",
  sourceRow: $row_row_15,
  postedAt: "2025-05-28T00:00:00Z",
  description: "FNB OB Pmt Sansor",
  normalizedDescription: "Sansor",
  amount: 6850,
  balance: 6881.78,
  currency: "ZAR",
  direction: "credit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Sansor",
  merchant: $merchant_sansor,
  category: $cat_client_income,
  isTransfer: false,
  manualOverride: false,
  notes: "Recurring client payment from Sansor."
});
fn::updateStatementRow($row_row_15.id, { transaction: $tx_stmt_2025_06_18_row_15.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_15.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_15.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_15.id, "TransactionMerchant", $merchant_sansor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_15.id, "TransactionCategory", $cat_client_income.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 16
LET $row_row_16 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 16,
  postedAt: "2025-05-30T00:00:00Z",
  description: "POS Purchase 23.00 Openai *Chatg                                                    485442*7050 28 May",
  normalizedDescription: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 May",
  amount: 421.5,
  balance: 6460.28,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 16,
    rawRowText: "POS Purchase 23.00 Openai *Chatg                                                    485442*7050 28 May; 421.50; 6,460.28 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 May",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 421.5,
    bankChargeZar: 3.68,
    balanceZar: 6460.28
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_06_18_row_16 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-16",
  sourceRow: $row_row_16,
  postedAt: "2025-05-30T00:00:00Z",
  description: "POS Purchase 23.00 Openai *Chatg                                                    485442*7050 28 May",
  normalizedDescription: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 May",
  amount: 421.5,
  balance: 6460.28,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "POS Purchase 23.00 Openai *Chatg 485442*7050 28 May",
  merchant: $merchant_pos_purchase_23_00_openai_chatg_485442_7050_28_may,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_16.id, { transaction: $tx_stmt_2025_06_18_row_16.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_16.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_16.id, "TransactionMerchant", $merchant_pos_purchase_23_00_openai_chatg_485442_7050_28_may.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_16.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_16 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-16",
  transaction: $tx_stmt_2025_06_18_row_16,
  status: "open",
  question: "What is the exact purpose of this POS Purchase 23.00 Openai *Chatg 485442*7050 28 May transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_pos_purchase_23_00_openai_chatg_485442_7050_28_may,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_16.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_16.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 17
LET $row_row_17 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 17,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 6000,
  balance: 460.28,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 17,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market; 6,000.00; 460.28 Cr; 15.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 6000,
    bankChargeZar: 15,
    balanceZar: 460.28
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_06_18_row_17 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-17",
  sourceRow: $row_row_17,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                             Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 6000,
  balance: 460.28,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Mpire Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_internal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
fn::updateStatementRow($row_row_17.id, { transaction: $tx_stmt_2025_06_18_row_17.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_17.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_17.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_17.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_17 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-17",
  transaction: $tx_stmt_2025_06_18_row_17,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_17.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_17.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 18
LET $row_row_18 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 18,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Int-Banking Pmt Frm Inv-127566",
  normalizedDescription: "Int-Banking Pmt Frm Inv-127566",
  amount: 6880,
  balance: 7340.28,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 18,
    rawRowText: "Int-Banking Pmt Frm Inv-127566; 6,880.00 Cr; 7,340.28 Cr",
    transactionType: "expense",
    normalizedMerchant: "Int-Banking Pmt Frm Inv-127566",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 6880,
    bankChargeZar: null,
    balanceZar: 7340.28
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_06_18_row_18 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-18",
  sourceRow: $row_row_18,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Int-Banking Pmt Frm Inv-127566",
  normalizedDescription: "Int-Banking Pmt Frm Inv-127566",
  amount: 6880,
  balance: 7340.28,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Int-Banking Pmt Frm Inv-127566",
  merchant: $merchant_int_banking_pmt_frm_inv_127566,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_18.id, { transaction: $tx_stmt_2025_06_18_row_18.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_18.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_18.id, "TransactionMerchant", $merchant_int_banking_pmt_frm_inv_127566.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_18.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_18 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-18",
  transaction: $tx_stmt_2025_06_18_row_18,
  status: "open",
  question: "What is the exact purpose of this Int-Banking Pmt Frm Inv-127566 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_int_banking_pmt_frm_inv_127566,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_18.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_18.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 19
LET $row_row_19 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 19,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "Magtape Credit",
  amount: 1000,
  balance: 8340.28,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 19,
    rawRowText: "Magtape Credit 127167 True Fit; 1,000.00 Cr; 8,340.28 Cr",
    transactionType: "income",
    normalizedMerchant: "Magtape Credit",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1000,
    bankChargeZar: null,
    balanceZar: 8340.28
},
  notes: "Magtape credit or reversal still needs exact source confirmation."
});
LET $tx_stmt_2025_06_18_row_19 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-19",
  sourceRow: $row_row_19,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Magtape Credit 127167 True Fit",
  normalizedDescription: "Magtape Credit",
  amount: 1000,
  balance: 8340.28,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Magtape Credit",
  merchant: $merchant_magtape_credit,
  category: $cat_transfer,
  isTransfer: false,
  manualOverride: false,
  notes: "Magtape credit or reversal still needs exact source confirmation."
});
fn::updateStatementRow($row_row_19.id, { transaction: $tx_stmt_2025_06_18_row_19.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_19.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_19.id, "TransactionMerchant", $merchant_magtape_credit.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_19.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_19 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-19",
  transaction: $tx_stmt_2025_06_18_row_19,
  status: "open",
  question: "What is the exact purpose of this Magtape Credit transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_magtape_credit,
  suggestedCategory: $cat_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_19.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_19.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 20
LET $row_row_20 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 20,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Sk8363",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 7562.73,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 20,
    rawRowText: "Magtape Debit Outsurance Ot87677302 Sk8363; 777.55; 7,562.73 Cr; 12.00",
    transactionType: "expense",
    normalizedMerchant: "Outsurance",
    category: "Insurance",
    feeType: "",
    clarificationStatus: "clarified",
    amountZar: 777.55,
    bankChargeZar: 12,
    balanceZar: 7562.73
},
  notes: "Insurance debit."
});
LET $tx_stmt_2025_06_18_row_20 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-20",
  sourceRow: $row_row_20,
  postedAt: "2025-06-02T00:00:00Z",
  description: "Magtape Debit Outsurance Ot87677302 Sk8363",
  normalizedDescription: "Outsurance",
  amount: 777.55,
  balance: 7562.73,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Outsurance",
  merchant: $merchant_outsurance,
  category: $cat_insurance,
  isTransfer: false,
  manualOverride: false,
  notes: "Insurance debit."
});
fn::updateStatementRow($row_row_20.id, { transaction: $tx_stmt_2025_06_18_row_20.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_20.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_20.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_20.id, "TransactionMerchant", $merchant_outsurance.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_20.id, "TransactionCategory", $cat_insurance.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 21
LET $row_row_21 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 21,
  postedAt: "2025-06-03T00:00:00Z",
  description: "POS Purchase 8.38 Google Gsuite_                                                    485442*7050 01 Jun",
  normalizedDescription: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Jun",
  amount: 175.32,
  balance: 7387.41,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 21,
    rawRowText: "POS Purchase 8.38 Google Gsuite_                                                    485442*7050 01 Jun; 175.32; 7,387.41 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Jun",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 175.32,
    bankChargeZar: 3.68,
    balanceZar: 7387.41
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_06_18_row_21 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-21",
  sourceRow: $row_row_21,
  postedAt: "2025-06-03T00:00:00Z",
  description: "POS Purchase 8.38 Google Gsuite_                                                    485442*7050 01 Jun",
  normalizedDescription: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Jun",
  amount: 175.32,
  balance: 7387.41,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Jun",
  merchant: $merchant_pos_purchase_8_38_google_gsuite_485442_7050_01_jun,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_21.id, { transaction: $tx_stmt_2025_06_18_row_21.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_21.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_21.id, "TransactionMerchant", $merchant_pos_purchase_8_38_google_gsuite_485442_7050_01_jun.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_21.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_21 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-21",
  transaction: $tx_stmt_2025_06_18_row_21,
  status: "open",
  question: "What is the exact purpose of this POS Purchase 8.38 Google Gsuite_ 485442*7050 01 Jun transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_pos_purchase_8_38_google_gsuite_485442_7050_01_jun,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_21.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_21.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 22
LET $row_row_22 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 22,
  postedAt: "2025-06-05T00:00:00Z",
  description: "POS Purchase 12.00 Notion Labs,                                                     485442*7050 04 Jun",
  normalizedDescription: "Notion",
  amount: 219.63,
  balance: 7167.78,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 22,
    rawRowText: "POS Purchase 12.00 Notion Labs,                                                     485442*7050 04 Jun; 219.63; 7,167.78 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Notion",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 219.63,
    bankChargeZar: 3.68,
    balanceZar: 7167.78
},
  notes: "Notion subscription spend."
});
LET $tx_stmt_2025_06_18_row_22 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-22",
  sourceRow: $row_row_22,
  postedAt: "2025-06-05T00:00:00Z",
  description: "POS Purchase 12.00 Notion Labs,                                                     485442*7050 04 Jun",
  normalizedDescription: "Notion",
  amount: 219.63,
  balance: 7167.78,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Notion",
  merchant: $merchant_notion,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Notion subscription spend."
});
fn::updateStatementRow($row_row_22.id, { transaction: $tx_stmt_2025_06_18_row_22.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_22.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_22.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_22.id, "TransactionMerchant", $merchant_notion.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_22.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 23
LET $row_row_23 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 23,
  postedAt: "2025-06-07T00:00:00Z",
  description: "POS Purchase Diamatrix CC                                                           485442*7050 05 Jun",
  normalizedDescription: "Diamatrix",
  amount: 405.03,
  balance: 6762.75,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 23,
    rawRowText: "POS Purchase Diamatrix CC                                                           485442*7050 05 Jun; 405.03; 6,762.75 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Diamatrix",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 405.03,
    bankChargeZar: 3.68,
    balanceZar: 6762.75
},
  notes: "Hosting or software-service spend."
});
LET $tx_stmt_2025_06_18_row_23 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-23",
  sourceRow: $row_row_23,
  postedAt: "2025-06-07T00:00:00Z",
  description: "POS Purchase Diamatrix CC                                                           485442*7050 05 Jun",
  normalizedDescription: "Diamatrix",
  amount: 405.03,
  balance: 6762.75,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Diamatrix",
  merchant: $merchant_diamatrix,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting or software-service spend."
});
fn::updateStatementRow($row_row_23.id, { transaction: $tx_stmt_2025_06_18_row_23.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_23.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_23.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_23.id, "TransactionMerchant", $merchant_diamatrix.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_23.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 24
LET $row_row_24 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 24,
  postedAt: "2025-06-07T00:00:00Z",
  description: "POS Purchase 130.84 Paypal *Vect                                                    485442*7050 04 Jun",
  normalizedDescription: "PayPal",
  amount: 130.84,
  balance: 6631.91,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 24,
    rawRowText: "POS Purchase 130.84 Paypal *Vect                                                    485442*7050 04 Jun; 130.84; 6,631.91 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 130.84,
    bankChargeZar: 3.68,
    balanceZar: 6631.91
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_06_18_row_24 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-24",
  sourceRow: $row_row_24,
  postedAt: "2025-06-07T00:00:00Z",
  description: "POS Purchase 130.84 Paypal *Vect                                                    485442*7050 04 Jun",
  normalizedDescription: "PayPal",
  amount: 130.84,
  balance: 6631.91,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal",
  merchant: $merchant_paypal,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs confirmation."
});
fn::updateStatementRow($row_row_24.id, { transaction: $tx_stmt_2025_06_18_row_24.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_24.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_24.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_24.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_24 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-24",
  transaction: $tx_stmt_2025_06_18_row_24,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_24.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_24.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 25
LET $row_row_25 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 25,
  postedAt: "2025-06-09T00:00:00Z",
  description: "Internet Pmt To Vdv Internet                                                        Mic00017",
  normalizedDescription: "Internet Pmt To Vdv Internet Mic00017",
  amount: 848.5,
  balance: 5783.41,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 25,
    rawRowText: "Internet Pmt To Vdv Internet                                                        Mic00017; 848.50; 5,783.41 Cr",
    transactionType: "expense",
    normalizedMerchant: "Internet Pmt To Vdv Internet Mic00017",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 848.5,
    bankChargeZar: null,
    balanceZar: 5783.41
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_06_18_row_25 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-25",
  sourceRow: $row_row_25,
  postedAt: "2025-06-09T00:00:00Z",
  description: "Internet Pmt To Vdv Internet                                                        Mic00017",
  normalizedDescription: "Internet Pmt To Vdv Internet Mic00017",
  amount: 848.5,
  balance: 5783.41,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Internet Pmt To Vdv Internet Mic00017",
  merchant: $merchant_internet_pmt_to_vdv_internet_mic00017,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_25.id, { transaction: $tx_stmt_2025_06_18_row_25.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_25.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_25.id, "TransactionMerchant", $merchant_internet_pmt_to_vdv_internet_mic00017.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_25.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_25 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-25",
  transaction: $tx_stmt_2025_06_18_row_25,
  status: "open",
  question: "What is the exact purpose of this Internet Pmt To Vdv Internet Mic00017 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_internet_pmt_to_vdv_internet_mic00017,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_25.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_25.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 26
LET $row_row_26 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 26,
  postedAt: "2025-06-09T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 2500,
  balance: 3283.41,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 26,
    rawRowText: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market; 2,500.00; 3,283.41 Cr; 8.00",
    transactionType: "transfer",
    normalizedMerchant: "Mpire Digital Market",
    category: "Internal transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 2500,
    bankChargeZar: 8,
    balanceZar: 3283.41
},
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
LET $tx_stmt_2025_06_18_row_26 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-26",
  sourceRow: $row_row_26,
  postedAt: "2025-06-09T00:00:00Z",
  description: "Rtc Express Pmt To Supplier Michael Pet                                         Mpire Digital Market",
  normalizedDescription: "Mpire Digital Market",
  amount: 2500,
  balance: 3283.41,
  currency: "ZAR",
  direction: "transfer",
  status: "matched",
  confidence: 0.55,
  merchantName: "Mpire Digital Market",
  merchant: $merchant_mpire_digital_market,
  category: $cat_internal_transfer,
  isTransfer: true,
  manualOverride: false,
  notes: "Likely internal transfer, but the destination still needs confirmation."
});
fn::updateStatementRow($row_row_26.id, { transaction: $tx_stmt_2025_06_18_row_26.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_26.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_26.id, "TransactionMerchant", $merchant_mpire_digital_market.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_26.id, "TransactionCategory", $cat_internal_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_26 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-26",
  transaction: $tx_stmt_2025_06_18_row_26,
  status: "open",
  question: "Which internal account or transfer does this Mpire Digital Market payment belong to?",
  reason: "Likely internal transfer, but the destination still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_mpire_digital_market,
  suggestedCategory: $cat_internal_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_26.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_26.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 27
LET $row_row_27 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 27,
  postedAt: "2025-06-09T00:00:00Z",
  description: "POS Purchase Diamatrix                                                          485442*7050 06 Jun",
  normalizedDescription: "Diamatrix",
  amount: 90.83,
  balance: 3192.58,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 27,
    rawRowText: "POS Purchase Diamatrix                                                          485442*7050 06 Jun; 90.83; 3,192.58 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Diamatrix",
    category: "Hosting / internet",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 90.83,
    bankChargeZar: 3.68,
    balanceZar: 3192.58
},
  notes: "Hosting or software-service spend."
});
LET $tx_stmt_2025_06_18_row_27 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-27",
  sourceRow: $row_row_27,
  postedAt: "2025-06-09T00:00:00Z",
  description: "POS Purchase Diamatrix                                                          485442*7050 06 Jun",
  normalizedDescription: "Diamatrix",
  amount: 90.83,
  balance: 3192.58,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Diamatrix",
  merchant: $merchant_diamatrix,
  category: $cat_hosting_internet,
  isTransfer: false,
  manualOverride: false,
  notes: "Hosting or software-service spend."
});
fn::updateStatementRow($row_row_27.id, { transaction: $tx_stmt_2025_06_18_row_27.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_27.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_27.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_27.id, "TransactionMerchant", $merchant_diamatrix.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_27.id, "TransactionCategory", $cat_hosting_internet.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 28
LET $row_row_28 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 28,
  postedAt: "2025-06-10T00:00:00Z",
  description: "POS Purchase 22000.00 Dpo*Wazoho                                                485442*7050 06 Jun",
  normalizedDescription: "POS Purchase 22000.00 Dpo*Wazoho 485442*7050 06 Jun",
  amount: 151.34,
  balance: 3041.24,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 28,
    rawRowText: "POS Purchase 22000.00 Dpo*Wazoho                                                485442*7050 06 Jun; 151.34; 3,041.24 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "POS Purchase 22000.00 Dpo*Wazoho 485442*7050 06 Jun",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 151.34,
    bankChargeZar: 3.68,
    balanceZar: 3041.24
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_06_18_row_28 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-28",
  sourceRow: $row_row_28,
  postedAt: "2025-06-10T00:00:00Z",
  description: "POS Purchase 22000.00 Dpo*Wazoho                                                485442*7050 06 Jun",
  normalizedDescription: "POS Purchase 22000.00 Dpo*Wazoho 485442*7050 06 Jun",
  amount: 151.34,
  balance: 3041.24,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "POS Purchase 22000.00 Dpo*Wazoho 485442*7050 06 Jun",
  merchant: $merchant_pos_purchase_22000_00_dpo_wazoho_485442_7050_06_jun,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_28.id, { transaction: $tx_stmt_2025_06_18_row_28.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_28.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_28.id, "TransactionMerchant", $merchant_pos_purchase_22000_00_dpo_wazoho_485442_7050_06_jun.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_28.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_28 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-28",
  transaction: $tx_stmt_2025_06_18_row_28,
  status: "open",
  question: "What is the exact purpose of this POS Purchase 22000.00 Dpo*Wazoho 485442*7050 06 Jun transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_pos_purchase_22000_00_dpo_wazoho_485442_7050_06_jun,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_28.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_28.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 29
LET $row_row_29 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 29,
  postedAt: "2025-06-10T00:00:00Z",
  description: "POS Purchase 13.56 Cursor Usage                                                 485442*7050 09 Jun",
  normalizedDescription: "Cursor",
  amount: 246.37,
  balance: 2794.87,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 29,
    rawRowText: "POS Purchase 13.56 Cursor Usage                                                 485442*7050 09 Jun; 246.37; 2,794.87 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "Cursor",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "clarified",
    amountZar: 246.37,
    bankChargeZar: 3.68,
    balanceZar: 2794.87
},
  notes: "Cursor AI tooling spend."
});
LET $tx_stmt_2025_06_18_row_29 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-29",
  sourceRow: $row_row_29,
  postedAt: "2025-06-10T00:00:00Z",
  description: "POS Purchase 13.56 Cursor Usage                                                 485442*7050 09 Jun",
  normalizedDescription: "Cursor",
  amount: 246.37,
  balance: 2794.87,
  currency: "ZAR",
  direction: "debit",
  status: "clarified",
  confidence: 0.95,
  merchantName: "Cursor",
  merchant: $merchant_cursor,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Cursor AI tooling spend."
});
fn::updateStatementRow($row_row_29.id, { transaction: $tx_stmt_2025_06_18_row_29.id, status: "clarified" });
fn::createEdge($import.id, "StatementImportRows", $row_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_29.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_29.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_29.id, "TransactionMerchant", $merchant_cursor.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_29.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 30
LET $row_row_30 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 30,
  postedAt: "2025-06-11T00:00:00Z",
  description: "POS Purchase 19.00 Magic Pattern                                                485442*7050 10 Jun",
  normalizedDescription: "POS Purchase 19.00 Magic Pattern 485442*7050 10 Jun",
  amount: 345.36,
  balance: 2449.51,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 30,
    rawRowText: "POS Purchase 19.00 Magic Pattern                                                485442*7050 10 Jun; 345.36; 2,449.51 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "POS Purchase 19.00 Magic Pattern 485442*7050 10 Jun",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 345.36,
    bankChargeZar: 3.68,
    balanceZar: 2449.51
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_06_18_row_30 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-30",
  sourceRow: $row_row_30,
  postedAt: "2025-06-11T00:00:00Z",
  description: "POS Purchase 19.00 Magic Pattern                                                485442*7050 10 Jun",
  normalizedDescription: "POS Purchase 19.00 Magic Pattern 485442*7050 10 Jun",
  amount: 345.36,
  balance: 2449.51,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "POS Purchase 19.00 Magic Pattern 485442*7050 10 Jun",
  merchant: $merchant_pos_purchase_19_00_magic_pattern_485442_7050_10_jun,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_30.id, { transaction: $tx_stmt_2025_06_18_row_30.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_30.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_30.id, "TransactionMerchant", $merchant_pos_purchase_19_00_magic_pattern_485442_7050_10_jun.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_30.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_30 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-30",
  transaction: $tx_stmt_2025_06_18_row_30,
  status: "open",
  question: "What is the exact purpose of this POS Purchase 19.00 Magic Pattern 485442*7050 10 Jun transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_pos_purchase_19_00_magic_pattern_485442_7050_10_jun,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_30.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_30.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 31
LET $row_row_31 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 31,
  postedAt: "2025-06-12T00:00:00Z",
  description: "2.62",
  normalizedDescription: "Bank Fee",
  amount: 2.62,
  balance: 2446.89,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 31,
    rawRowText: "2.62; 2,446.89 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 2.62,
    bankChargeZar: null,
    balanceZar: 2446.89
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_06_18_row_31 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-31",
  sourceRow: $row_row_31,
  postedAt: "2025-06-12T00:00:00Z",
  description: "2.62",
  normalizedDescription: "Bank Fee",
  amount: 2.62,
  balance: 2446.89,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_31.id, { transaction: $tx_stmt_2025_06_18_row_31.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_31.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_31.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_31.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_31 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-31",
  transaction: $tx_stmt_2025_06_18_row_31,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_31.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_31.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 32
LET $row_row_32 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 32,
  postedAt: "2025-06-13T00:00:00Z",
  description: "Magtape Credit Liq Express",
  normalizedDescription: "Magtape Credit",
  amount: 1680,
  balance: 4126.89,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 32,
    rawRowText: "Magtape Credit Liq Express; 1,680.00 Cr; 4,126.89 Cr",
    transactionType: "income",
    normalizedMerchant: "Magtape Credit",
    category: "Transfer",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 1680,
    bankChargeZar: null,
    balanceZar: 4126.89
},
  notes: "Magtape credit or reversal still needs exact source confirmation."
});
LET $tx_stmt_2025_06_18_row_32 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-32",
  sourceRow: $row_row_32,
  postedAt: "2025-06-13T00:00:00Z",
  description: "Magtape Credit Liq Express",
  normalizedDescription: "Magtape Credit",
  amount: 1680,
  balance: 4126.89,
  currency: "ZAR",
  direction: "credit",
  status: "matched",
  confidence: 0.55,
  merchantName: "Magtape Credit",
  merchant: $merchant_magtape_credit,
  category: $cat_transfer,
  isTransfer: false,
  manualOverride: false,
  notes: "Magtape credit or reversal still needs exact source confirmation."
});
fn::updateStatementRow($row_row_32.id, { transaction: $tx_stmt_2025_06_18_row_32.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_32.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_32.id, "TransactionMerchant", $merchant_magtape_credit.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_32.id, "TransactionCategory", $cat_transfer.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_32 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-32",
  transaction: $tx_stmt_2025_06_18_row_32,
  status: "open",
  question: "What is the exact purpose of this Magtape Credit transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_magtape_credit,
  suggestedCategory: $cat_transfer,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_32.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_32.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 33
LET $row_row_33 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 33,
  postedAt: "2025-06-13T00:00:00Z",
  description: "POS Purchase 103.92 Paypal *Elit                                                485442*7050 11 Jun",
  normalizedDescription: "PayPal",
  amount: 103.92,
  balance: 4022.97,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 33,
    rawRowText: "POS Purchase 103.92 Paypal *Elit                                                485442*7050 11 Jun; 103.92; 4,022.97 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "PayPal",
    category: "Software / SaaS",
    feeType: "card charge",
    clarificationStatus: "unclarified",
    amountZar: 103.92,
    bankChargeZar: 3.68,
    balanceZar: 4022.97
},
  notes: "Underlying PayPal purchase still needs confirmation."
});
LET $tx_stmt_2025_06_18_row_33 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-33",
  sourceRow: $row_row_33,
  postedAt: "2025-06-13T00:00:00Z",
  description: "POS Purchase 103.92 Paypal *Elit                                                485442*7050 11 Jun",
  normalizedDescription: "PayPal",
  amount: 103.92,
  balance: 4022.97,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "PayPal",
  merchant: $merchant_paypal,
  category: $cat_software_saas,
  isTransfer: false,
  manualOverride: false,
  notes: "Underlying PayPal purchase still needs confirmation."
});
fn::updateStatementRow($row_row_33.id, { transaction: $tx_stmt_2025_06_18_row_33.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_33.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_33.id, "TransactionMerchant", $merchant_paypal.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_33.id, "TransactionCategory", $cat_software_saas.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_33 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-33",
  transaction: $tx_stmt_2025_06_18_row_33,
  status: "open",
  question: "What is the underlying purchase or service behind this PayPal charge?",
  reason: "Underlying PayPal purchase still needs confirmation.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_paypal,
  suggestedCategory: $cat_software_saas,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_33.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_33.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 34
LET $row_row_34 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 34,
  postedAt: "2025-06-13T00:00:00Z",
  description: "POS Purchase 22000.00 Dpo*Wazoho                                                485442*7050 10 Jun",
  normalizedDescription: "POS Purchase 22000.00 Dpo*Wazoho 485442*7050 10 Jun",
  amount: 152.63,
  balance: 3870.34,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 34,
    rawRowText: "POS Purchase 22000.00 Dpo*Wazoho                                                485442*7050 10 Jun; 152.63; 3,870.34 Cr; 3.68",
    transactionType: "expense",
    normalizedMerchant: "POS Purchase 22000.00 Dpo*Wazoho 485442*7050 10 Jun",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 152.63,
    bankChargeZar: 3.68,
    balanceZar: 3870.34
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_06_18_row_34 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-34",
  sourceRow: $row_row_34,
  postedAt: "2025-06-13T00:00:00Z",
  description: "POS Purchase 22000.00 Dpo*Wazoho                                                485442*7050 10 Jun",
  normalizedDescription: "POS Purchase 22000.00 Dpo*Wazoho 485442*7050 10 Jun",
  amount: 152.63,
  balance: 3870.34,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "POS Purchase 22000.00 Dpo*Wazoho 485442*7050 10 Jun",
  merchant: $merchant_pos_purchase_22000_00_dpo_wazoho_485442_7050_10_jun,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_34.id, { transaction: $tx_stmt_2025_06_18_row_34.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_34.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_34.id, "TransactionMerchant", $merchant_pos_purchase_22000_00_dpo_wazoho_485442_7050_10_jun.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_34.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_34 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-34",
  transaction: $tx_stmt_2025_06_18_row_34,
  status: "open",
  question: "What is the exact purpose of this POS Purchase 22000.00 Dpo*Wazoho 485442*7050 10 Jun transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_pos_purchase_22000_00_dpo_wazoho_485442_7050_10_jun,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_34.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_34.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 35
LET $row_row_35 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 35,
  postedAt: "2025-06-18T00:00:00Z",
  description: "0.00",
  normalizedDescription: "0.00",
  amount: 3870.34,
  balance: 10,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 35,
    rawRowText: "0.00; 3,870.34 Cr; 10.00",
    transactionType: "expense",
    normalizedMerchant: "0.00",
    category: "Unclassified",
    feeType: "",
    clarificationStatus: "unclarified",
    amountZar: 3870.34,
    bankChargeZar: null,
    balanceZar: 10
},
  notes: "Needs manual confirmation from the statement import."
});
LET $tx_stmt_2025_06_18_row_35 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-35",
  sourceRow: $row_row_35,
  postedAt: "2025-06-18T00:00:00Z",
  description: "0.00",
  normalizedDescription: "0.00",
  amount: 3870.34,
  balance: 10,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "0.00",
  merchant: $merchant_0_00,
  category: $cat_unclassified,
  isTransfer: false,
  manualOverride: false,
  notes: "Needs manual confirmation from the statement import."
});
fn::updateStatementRow($row_row_35.id, { transaction: $tx_stmt_2025_06_18_row_35.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_35.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_35.id, "TransactionMerchant", $merchant_0_00.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_35.id, "TransactionCategory", $cat_unclassified.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_35 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-35",
  transaction: $tx_stmt_2025_06_18_row_35,
  status: "open",
  question: "What is the exact purpose of this 0.00 transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_0_00,
  suggestedCategory: $cat_unclassified,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_35.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_35.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 36
LET $row_row_36 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 36,
  postedAt: "2025-06-18T00:00:00Z",
  description: "89.00",
  normalizedDescription: "Bank Fee",
  amount: 89,
  balance: 3781.34,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 36,
    rawRowText: "89.00; 3,781.34 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 89,
    bankChargeZar: null,
    balanceZar: 3781.34
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_06_18_row_36 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-36",
  sourceRow: $row_row_36,
  postedAt: "2025-06-18T00:00:00Z",
  description: "89.00",
  normalizedDescription: "Bank Fee",
  amount: 89,
  balance: 3781.34,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_36.id, { transaction: $tx_stmt_2025_06_18_row_36.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_36.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_36.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_36.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_36 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-36",
  transaction: $tx_stmt_2025_06_18_row_36,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_36.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_36.id, { boundId: true, overwrite: false, skipExists: true });

-- Row 37
LET $row_row_37 = fn::createStatementRow({
  space: $space,
  account: $account,
  statementImport: $import,
  rowNumber: 37,
  postedAt: "2025-06-18T00:00:00Z",
  description: "131.84",
  normalizedDescription: "Bank Fee",
  amount: 131.84,
  balance: 3649.5,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  rawData: {
    sourceFileName: "docs/statements/business/GOLD_BUSINESS_ACCOUNT_80.pdf",
    statementPeriodStart: "2025-05-17",
    statementPeriodEnd: "2025-06-18",
    rowNo: 37,
    rawRowText: "131.84; 3,649.50 Cr",
    transactionType: "fee",
    normalizedMerchant: "FNB",
    category: "Fees",
    feeType: "bank fee",
    clarificationStatus: "unclarified",
    amountZar: 131.84,
    bankChargeZar: null,
    balanceZar: 3649.5
},
  notes: "FNB fee line without an explicit label on the statement."
});
LET $tx_stmt_2025_06_18_row_37 = fn::createTransaction({
  space: $space,
  account: $account,
  key: "stmt-2025-06-18-row-37",
  sourceRow: $row_row_37,
  postedAt: "2025-06-18T00:00:00Z",
  description: "131.84",
  normalizedDescription: "Bank Fee",
  amount: 131.84,
  balance: 3649.5,
  currency: "ZAR",
  direction: "debit",
  status: "matched",
  confidence: 0.55,
  merchantName: "FNB",
  merchant: $merchant_fnb,
  category: $cat_fees_bank_fee,
  isTransfer: false,
  manualOverride: false,
  notes: "FNB fee line without an explicit label on the statement."
});
fn::updateStatementRow($row_row_37.id, { transaction: $tx_stmt_2025_06_18_row_37.id, status: "matched" });
fn::createEdge($import.id, "StatementImportRows", $row_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($row_row_37.id, "StatementRowTransactions", $tx_stmt_2025_06_18_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($account.id, "AccountTransactions", $tx_stmt_2025_06_18_row_37.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_37.id, "TransactionMerchant", $merchant_fnb.id, { boundId: true, overwrite: false, skipExists: true });
fn::createEdge($tx_stmt_2025_06_18_row_37.id, "TransactionCategory", $cat_fees_bank_fee.id, { boundId: true, overwrite: false, skipExists: true });
LET $task_stmt_2025_06_18_row_37 = fn::createClarificationTask({
  space: $space,
  key: "stmt-2025-06-18-row-37",
  transaction: $tx_stmt_2025_06_18_row_37,
  status: "open",
  question: "What is the exact purpose of this FNB transaction?",
  reason: "Needs manual confirmation from the statement import.",
  suggestedSpace: $space,
  suggestedMerchant: $merchant_fnb,
  suggestedCategory: $cat_fees_bank_fee,
  confidence: 0.25,
  notes: "Imported from 2025-06-18.import.md"
});
fn::createEdge($tx_stmt_2025_06_18_row_37.id, "TransactionClarificationTasks", $task_stmt_2025_06_18_row_37.id, { boundId: true, overwrite: false, skipExists: true });

-- Final import snapshot
fn::updateStatementImport($import.id, {
  rowCount: 37,
  normalizedCount: 37,
  clarificationCount: 30,
  status: "matched",
  statementDate: "2025-06-18T00:00:00Z",
  notes: "Imported from 2025-06-18.import.md"
});

-- End of generated import
