import type {
  AccountRef,
  CategoryKind,
  TransactionEvidenceState,
} from "./contracts.js";
import type { MoneyWire } from "./money.js";

export const FINANCIAL_ANALYTICS_FORMULA_VERSION =
  "raven.financial-read-analytics.v2" as const;

export const FINANCIAL_ANALYTICS_DRILL_DOWN_LIMIT = 250 as const;

export type FinancialAnalyticsAuthorityScope =
  | "active_ledger"
  | "active_ledger_with_legacy_unreconciled";

export type FinancialAnalyticsPeriodInput = Readonly<{
  month?: string;
  from?: string;
  through?: string;
}>;

export type FinancialAnalyticsScopeInput = FinancialAnalyticsPeriodInput &
  Readonly<{
    currency: string;
    spaceKeys?: string[];
    accountRefs?: AccountRef[];
    authorityScope?: FinancialAnalyticsAuthorityScope;
    asOf?: string;
  }>;

export type FinancialAnalyticsPeriod = Readonly<{
  from: string;
  through: string;
  month: string | null;
}>;

export type FinancialAmountCount = Readonly<{
  amount: MoneyWire;
  count: number;
}>;

export type FinancialMovementTotals = Readonly<{
  income: MoneyWire;
  outflow: MoneyWire;
  net: MoneyWire;
  incomeCount: number;
  outflowCount: number;
}>;

export type FinancialAnalyticsExclusionReason =
  | "ignored"
  | "unresolved"
  | "invalid"
  | "transfer"
  | "adjustment"
  | "historical_authority"
  | "future";

export type FinancialAnalyticsExclusion = Readonly<{
  reason: FinancialAnalyticsExclusionReason;
  grossKnownMovementVolume: MoneyWire;
  count: number;
  transactionRefs: string[];
  transactionRefCount: number;
  transactionRefsTruncated: boolean;
}>;

export type FinancialAnalyticsAuthorityBucket = Readonly<{
  authority:
    | "provisional_manual"
    | "provisional_generated"
    | "canonical_statement_backed"
    | "legacy_unreconciled"
    | "other_active_unresolved";
  evidenceState: TransactionEvidenceState | "legacy_unreconciled";
  includedInOrdinaryTotals: boolean;
  grossKnownMovementVolume: MoneyWire;
  count: number;
  transactionRefs: string[];
  transactionRefCount: number;
  transactionRefsTruncated: boolean;
}>;

export type FinancialAnalyticsMeta = Readonly<{
  asOf: string;
  formulaVersion: typeof FINANCIAL_ANALYTICS_FORMULA_VERSION;
  period: FinancialAnalyticsPeriod;
  currency: string;
  authorityScope: FinancialAnalyticsAuthorityScope;
  spaces: string[];
  accounts: AccountRef[];
  filters: Readonly<Record<string, string[]>>;
  exclusions: FinancialAnalyticsExclusion[];
  unresolvedGrossKnownMovementVolume: FinancialAmountCount;
  authorityBuckets: FinancialAnalyticsAuthorityBucket[];
  drillDownRefs: string[];
  drillDownRefCount: number;
  drillDownRefsTruncated: boolean;
  drillDownRefLimit: typeof FINANCIAL_ANALYTICS_DRILL_DOWN_LIMIT;
  categoryMeaning: "management_only_no_tax_inference";
}>;

export type GetPeriodFinancialSummaryInput = FinancialAnalyticsScopeInput;
export type GetPeriodFinancialSummaryOutput = Readonly<{
  ordinary: FinancialMovementTotals;
  legacyUnreconciled: FinancialMovementTotals;
  accounts: Array<{
    account: AccountRef;
    ordinary: FinancialMovementTotals;
    legacyUnreconciled: FinancialMovementTotals;
  }>;
  meta: FinancialAnalyticsMeta;
}>;

export type GetCategorySpendSummaryInput = FinancialAnalyticsScopeInput &
  Readonly<{
    categoryKeys?: string[];
    includeDescendants?: boolean;
  }>;
export type FinancialCategorySpendRow = Readonly<{
  category: Readonly<{
    spaceKey: string;
    key: string;
    name: string;
    kind: CategoryKind;
  }>;
  ordinary: FinancialAmountCount;
  legacyUnreconciled: FinancialAmountCount;
  transactionRefs: string[];
  transactionRefCount: number;
  transactionRefsTruncated: boolean;
}>;
export type GetCategorySpendSummaryOutput = Readonly<{
  categories: FinancialCategorySpendRow[];
  ordinary: FinancialAmountCount;
  legacyUnreconciled: FinancialAmountCount;
  meta: FinancialAnalyticsMeta;
}>;

export type GetMerchantSpendSummaryInput = FinancialAnalyticsScopeInput &
  Readonly<{ merchantNames?: string[] }>;
export type FinancialMerchantSpendRow = Readonly<{
  merchantName: string;
  ordinary: FinancialAmountCount;
  legacyUnreconciled: FinancialAmountCount;
  transactionRefs: string[];
  transactionRefCount: number;
  transactionRefsTruncated: boolean;
}>;
export type GetMerchantSpendSummaryOutput = Readonly<{
  merchants: FinancialMerchantSpendRow[];
  ordinary: FinancialAmountCount;
  legacyUnreconciled: FinancialAmountCount;
  meta: FinancialAnalyticsMeta;
}>;

export type FeeEvidenceRuleInput =
  | Readonly<{
      id: string;
      label: string;
      type: "category";
      categoryKeys: string[];
      includeDescendants?: boolean;
    }>
  | Readonly<{
      id: string;
      label: string;
      type: "merchant_exact";
      merchantNames: string[];
    }>
  | Readonly<{
      id: string;
      label: string;
      type: "description_contains";
      phrases: string[];
    }>;

export type GetFeeSummaryInput = FinancialAnalyticsScopeInput &
  Readonly<{ rules: FeeEvidenceRuleInput[] }>;
export type FinancialFeeSubtotal = Readonly<{
  ruleId: string;
  label: string;
  ruleType: FeeEvidenceRuleInput["type"];
  precedence: number;
  ordinary: FinancialAmountCount;
  legacyUnreconciled: FinancialAmountCount;
  transactionRefs: string[];
  transactionRefCount: number;
  transactionRefsTruncated: boolean;
}>;
export type GetFeeSummaryOutput = Readonly<{
  subtotals: FinancialFeeSubtotal[];
  ordinary: FinancialAmountCount;
  legacyUnreconciled: FinancialAmountCount;
  meta: FinancialAnalyticsMeta;
}>;

export type GetMonthlyFinancialTrendInput = FinancialAnalyticsScopeInput;
export type FinancialMonthlyTrendRow = Readonly<{
  month: string;
  ordinary: FinancialMovementTotals;
  legacyUnreconciled: FinancialMovementTotals;
  accounts: Array<{
    account: AccountRef;
    ordinary: FinancialMovementTotals;
    legacyUnreconciled: FinancialMovementTotals;
  }>;
}>;
export type GetMonthlyFinancialTrendOutput = Readonly<{
  months: FinancialMonthlyTrendRow[];
  meta: FinancialAnalyticsMeta;
}>;

export type ListUncategorizedTransactionsInput = FinancialAnalyticsScopeInput &
  Readonly<{
    cursor?: string;
    limit?: number;
  }>;
export type FinancialUncategorizedTransaction = Readonly<{
  transactionRef: string;
  account: AccountRef;
  financialDate: string;
  amount: MoneyWire;
  kind: "income" | "expense";
  flowDirection: "inflow" | "outflow";
  authority: "active_ledger" | "legacy_unreconciled";
  evidenceState: TransactionEvidenceState | "legacy_unreconciled";
}>;
export type ListUncategorizedTransactionsOutput = Readonly<{
  transactions: FinancialUncategorizedTransaction[];
  page: Readonly<{
    ordinary: FinancialAmountCount;
    legacyUnreconciled: FinancialAmountCount;
  }>;
  total: Readonly<{
    ordinary: FinancialAmountCount;
    legacyUnreconciled: FinancialAmountCount;
  }>;
  nextCursor: string | null;
  meta: FinancialAnalyticsMeta;
}>;

export type GetFinancialDataQualitySummaryInput = FinancialAnalyticsScopeInput;
export type GetFinancialDataQualitySummaryOutput = Readonly<{
  activeIncludedGrossKnownMovementVolume: FinancialAmountCount;
  legacyUnreconciledGrossKnownMovementVolume: FinancialAmountCount;
  uncategorizedGrossKnownMovementVolume: FinancialAmountCount;
  excludedGrossKnownMovementVolume: FinancialAmountCount;
  meta: FinancialAnalyticsMeta;
}>;

export interface FinancialAnalyticsApi {
  getPeriodFinancialSummary(
    input: GetPeriodFinancialSummaryInput,
  ): Promise<GetPeriodFinancialSummaryOutput>;
  getCategorySpendSummary(
    input: GetCategorySpendSummaryInput,
  ): Promise<GetCategorySpendSummaryOutput>;
  getMerchantSpendSummary(
    input: GetMerchantSpendSummaryInput,
  ): Promise<GetMerchantSpendSummaryOutput>;
  getFeeSummary(input: GetFeeSummaryInput): Promise<GetFeeSummaryOutput>;
  getMonthlyFinancialTrend(
    input: GetMonthlyFinancialTrendInput,
  ): Promise<GetMonthlyFinancialTrendOutput>;
  listUncategorizedTransactions(
    input: ListUncategorizedTransactionsInput,
  ): Promise<ListUncategorizedTransactionsOutput>;
  getFinancialDataQualitySummary(
    input: GetFinancialDataQualitySummaryInput,
  ): Promise<GetFinancialDataQualitySummaryOutput>;
}
