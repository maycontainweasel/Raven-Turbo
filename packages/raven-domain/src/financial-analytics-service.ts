import type {
  AccountRecord,
  CategoryRecord,
  TransactionRecord,
} from "./contracts.js";
import { RavenDomainError } from "./errors.js";
import {
  FINANCIAL_ANALYTICS_DRILL_DOWN_LIMIT,
  FINANCIAL_ANALYTICS_FORMULA_VERSION,
  type FeeEvidenceRuleInput,
  type FinancialAmountCount,
  type FinancialAnalyticsApi,
  type FinancialAnalyticsAuthorityBucket,
  type FinancialAnalyticsAuthorityScope,
  type FinancialAnalyticsExclusion,
  type FinancialAnalyticsExclusionReason,
  type FinancialAnalyticsMeta,
  type FinancialAnalyticsPeriod,
  type FinancialAnalyticsScopeInput,
  type FinancialCategorySpendRow,
  type FinancialFeeSubtotal,
  type FinancialMerchantSpendRow,
  type FinancialMovementTotals,
  type FinancialUncategorizedTransaction,
  type GetCategorySpendSummaryInput,
  type GetCategorySpendSummaryOutput,
  type GetFeeSummaryInput,
  type GetFeeSummaryOutput,
  type GetFinancialDataQualitySummaryInput,
  type GetFinancialDataQualitySummaryOutput,
  type GetMerchantSpendSummaryInput,
  type GetMerchantSpendSummaryOutput,
  type GetMonthlyFinancialTrendInput,
  type GetMonthlyFinancialTrendOutput,
  type GetPeriodFinancialSummaryInput,
  type GetPeriodFinancialSummaryOutput,
  type ListUncategorizedTransactionsInput,
  type ListUncategorizedTransactionsOutput,
} from "./financial-analytics-contracts.js";
import type { FinancialAnalyticsRepository } from "./financial-analytics-repository.js";
import { addMoney, money, subtractMoney, zeroMoney } from "./money.js";
import {
  normalizeFinancialDate,
  normalizeMonth,
  transactionEvidenceState,
  transactionFinancialDate,
  transactionLedgerAuthority,
} from "./transaction.js";

type QualifiedRecord = Readonly<{
  record: TransactionRecord;
  date: string;
  authority: "ordinary" | "legacy";
}>;

type ExcludedRecord = Readonly<{
  record: TransactionRecord;
  reason: FinancialAnalyticsExclusionReason;
}>;

type AnalyticsDataset = Readonly<{
  period: FinancialAnalyticsPeriod;
  currency: string;
  authorityScope: FinancialAnalyticsAuthorityScope;
  accounts: AccountRecord[];
  categories: CategoryRecord[];
  ordinary: QualifiedRecord[];
  legacy: QualifiedRecord[];
  excluded: ExcludedRecord[];
  asOf: string;
  asOfFinancialDate: string;
}>;

const INVALID_WARNING_CODES = new Set([
  "LEGACY_TRANSACTION_INVALID",
  "PARTIAL_CANONICAL_TRANSACTION",
  "CANONICAL_LEGACY_CONFLICT",
  "TRANSACTION_DATE_INVALID",
]);

const EXCLUSION_ORDER: FinancialAnalyticsExclusionReason[] = [
  "ignored",
  "unresolved",
  "invalid",
  "transfer",
  "adjustment",
  "historical_authority",
  "future",
];

const FINANCIAL_TIME_ZONE = "Africa/Johannesburg";

function normalizeAsOf(
  explicit: string | undefined,
  clock: () => Date,
): { instant: string; financialDate: string } {
  const date = explicit === undefined ? clock() : new Date(explicit);
  if (!Number.isFinite(date.getTime())) {
    throw new RavenDomainError(
      "INVALID_TRANSACTION_DATE",
      "Financial analytics asOf must be a valid instant",
    );
  }
  if (
    explicit !== undefined &&
    !/^\d{4}-\d{2}-\d{2}T.+(?:Z|[+-]\d{2}:\d{2})$/.test(explicit.trim())
  ) {
    throw new RavenDomainError(
      "INVALID_TRANSACTION_DATE",
      "Financial analytics asOf must include an explicit timezone offset",
    );
  }
  const parts = new Intl.DateTimeFormat("en-ZA", {
    timeZone: FINANCIAL_TIME_ZONE,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  })
    .formatToParts(date)
    .reduce<Record<string, string>>((result, part) => {
      if (part.type !== "literal") result[part.type] = part.value;
      return result;
    }, {});
  return {
    instant: date.toISOString(),
    financialDate: `${parts.year}-${parts.month}-${parts.day}`,
  };
}

function nextMonth(month: string): string {
  const [year, value] = month.split("-").map(Number);
  return value === 12
    ? `${(year ?? 0) + 1}-01`
    : `${year}-${String((value ?? 0) + 1).padStart(2, "0")}`;
}

function previousDate(date: string): string {
  const value = new Date(`${date}T00:00:00.000Z`);
  value.setUTCDate(value.getUTCDate() - 1);
  return value.toISOString().slice(0, 10);
}

export function normalizeFinancialAnalyticsPeriod(
  input: Pick<FinancialAnalyticsScopeInput, "month" | "from" | "through">,
): FinancialAnalyticsPeriod {
  if (input.month) {
    if (input.from || input.through) {
      throw new RavenDomainError(
        "INVALID_TRANSACTION_DATE",
        "Use either month or an explicit from/through range",
      );
    }
    const month = normalizeMonth(input.month);
    return {
      month,
      from: `${month}-01`,
      through: previousDate(`${nextMonth(month)}-01`),
    };
  }
  if (!input.from || !input.through) {
    throw new RavenDomainError(
      "INVALID_TRANSACTION_DATE",
      "Financial analytics requires month or both from and through",
    );
  }
  const from = normalizeFinancialDate(input.from);
  const through = normalizeFinancialDate(input.through);
  if (from > through) {
    throw new RavenDomainError(
      "INVALID_TRANSACTION_DATE",
      "Financial analytics from date must not follow through date",
    );
  }
  return { month: null, from, through };
}

function inPeriod(date: string, period: FinancialAnalyticsPeriod): boolean {
  return date >= period.from && date <= period.through;
}

function normalizedRecordedDate(record: TransactionRecord): string | null {
  const candidate = record.recordedAt?.slice(0, 10);
  if (!candidate) return null;
  try {
    return normalizeFinancialDate(candidate);
  } catch {
    return null;
  }
}

function checkedAmount(
  currency: string,
  records: readonly { record: TransactionRecord }[],
): FinancialAmountCount {
  let amount = zeroMoney(currency);
  const count = records.length;
  for (const { record } of records) {
    if (record.amountMinor === null) continue;
    amount = addMoney(
      amount,
      money(
        { currency, minorUnits: record.amountMinor },
        { nonNegative: true },
      ),
    );
  }
  return { amount, count };
}

function movementTotals(
  currency: string,
  records: readonly QualifiedRecord[],
): FinancialMovementTotals {
  let income = zeroMoney(currency);
  let outflow = zeroMoney(currency);
  let incomeCount = 0;
  let outflowCount = 0;
  for (const { record } of records) {
    const amount = money(
      { currency, minorUnits: record.amountMinor! },
      { nonNegative: true },
    );
    if (record.kind === "income" && record.flowDirection === "inflow") {
      income = addMoney(income, amount);
      incomeCount += 1;
    } else if (
      record.kind === "expense" &&
      record.flowDirection === "outflow"
    ) {
      outflow = addMoney(outflow, amount);
      outflowCount += 1;
    }
  }
  return {
    income,
    outflow,
    net: subtractMoney(income, outflow),
    incomeCount,
    outflowCount,
  };
}

function expenseRecords(
  records: readonly QualifiedRecord[],
): QualifiedRecord[] {
  return records.filter(
    ({ record }) =>
      record.kind === "expense" && record.flowDirection === "outflow",
  );
}

function recordRefSummary(records: readonly { record: TransactionRecord }[]): {
  transactionRefs: string[];
  transactionRefCount: number;
  transactionRefsTruncated: boolean;
} {
  const refs = [...new Set(records.map(({ record }) => record.id))].sort();
  return {
    transactionRefs: refs.slice(0, FINANCIAL_ANALYTICS_DRILL_DOWN_LIMIT),
    transactionRefCount: refs.length,
    transactionRefsTruncated:
      refs.length > FINANCIAL_ANALYTICS_DRILL_DOWN_LIMIT,
  };
}

function normalText(value: string): string {
  return value.trim().toLocaleLowerCase("en-ZA").replace(/\s+/g, " ");
}

function exclusionRows(
  dataset: AnalyticsDataset,
): FinancialAnalyticsExclusion[] {
  return EXCLUSION_ORDER.map((reason) => {
    const records = dataset.excluded.filter((item) => item.reason === reason);
    const known = checkedAmount(dataset.currency, records);
    return {
      reason,
      grossKnownMovementVolume: known.amount,
      count: known.count,
      ...recordRefSummary(records),
    };
  }).filter((row) => row.count > 0 || row.transactionRefs.length > 0);
}

function authorityBuckets(
  dataset: AnalyticsDataset,
): FinancialAnalyticsAuthorityBucket[] {
  const provisionalManual = dataset.ordinary.filter(
    ({ record }) =>
      transactionEvidenceState(record) === "provisional" &&
      record.entrySource === "manual",
  );
  const provisionalGenerated = dataset.ordinary.filter(
    ({ record }) =>
      transactionEvidenceState(record) === "provisional" &&
      record.entrySource !== "manual",
  );
  const statementBacked = dataset.ordinary.filter(
    ({ record }) => transactionEvidenceState(record) === "statement_backed",
  );
  const unresolved = dataset.excluded.filter(
    ({ reason }) => reason === "unresolved" || reason === "invalid",
  );
  const provisionalManualKnown = checkedAmount(
    dataset.currency,
    provisionalManual,
  );
  const provisionalGeneratedKnown = checkedAmount(
    dataset.currency,
    provisionalGenerated,
  );
  const statementKnown = checkedAmount(dataset.currency, statementBacked);
  const legacyKnown = checkedAmount(dataset.currency, dataset.legacy);
  const unresolvedKnown = checkedAmount(dataset.currency, unresolved);
  return [
    {
      authority: "provisional_manual",
      evidenceState: "provisional",
      includedInOrdinaryTotals: true,
      grossKnownMovementVolume: provisionalManualKnown.amount,
      count: provisionalManualKnown.count,
      ...recordRefSummary(provisionalManual),
    },
    {
      authority: "provisional_generated",
      evidenceState: "provisional",
      includedInOrdinaryTotals: true,
      grossKnownMovementVolume: provisionalGeneratedKnown.amount,
      count: provisionalGeneratedKnown.count,
      ...recordRefSummary(provisionalGenerated),
    },
    {
      authority: "canonical_statement_backed",
      evidenceState: "statement_backed",
      includedInOrdinaryTotals: true,
      grossKnownMovementVolume: statementKnown.amount,
      count: statementKnown.count,
      ...recordRefSummary(statementBacked),
    },
    {
      authority: "legacy_unreconciled",
      evidenceState: "legacy_unreconciled",
      includedInOrdinaryTotals: false,
      grossKnownMovementVolume: legacyKnown.amount,
      count: legacyKnown.count,
      ...recordRefSummary(dataset.legacy),
    },
    {
      authority: "other_active_unresolved",
      evidenceState: "unresolved",
      includedInOrdinaryTotals: false,
      grossKnownMovementVolume: unresolvedKnown.amount,
      count: unresolvedKnown.count,
      ...recordRefSummary(unresolved),
    },
  ];
}

function meta(
  dataset: AnalyticsDataset,
  filters: Readonly<Record<string, string[]>>,
  drillDown: readonly { record: TransactionRecord }[],
): FinancialAnalyticsMeta {
  const exclusions = exclusionRows(dataset);
  const unresolved = dataset.excluded.filter(
    ({ reason }) => reason === "unresolved" || reason === "invalid",
  );
  const drillDownRefs = recordRefSummary(drillDown);
  return {
    asOf: dataset.asOf,
    formulaVersion: FINANCIAL_ANALYTICS_FORMULA_VERSION,
    period: dataset.period,
    currency: dataset.currency,
    authorityScope: dataset.authorityScope,
    spaces: [
      ...new Set(dataset.accounts.map((account) => account.spaceKey)),
    ].sort(),
    accounts: dataset.accounts.map((account) => ({
      spaceKey: account.spaceKey,
      accountKey: account.key,
    })),
    filters,
    exclusions,
    unresolvedGrossKnownMovementVolume: checkedAmount(
      dataset.currency,
      unresolved,
    ),
    authorityBuckets: authorityBuckets(dataset),
    drillDownRefs: drillDownRefs.transactionRefs,
    drillDownRefCount: drillDownRefs.transactionRefCount,
    drillDownRefsTruncated: drillDownRefs.transactionRefsTruncated,
    drillDownRefLimit: FINANCIAL_ANALYTICS_DRILL_DOWN_LIMIT,
    categoryMeaning: "management_only_no_tax_inference",
  };
}

function categoryIdentity(spaceKey: string, categoryKey: string): string {
  return `${spaceKey}\u0000${categoryKey}`;
}

function categoryIdentitiesFor(
  categories: readonly CategoryRecord[],
  requested: readonly string[],
  includeDescendants: boolean,
): Set<string> {
  const requestedKeys = new Set(
    requested.map((key) => key.trim()).filter(Boolean),
  );
  const identities = new Set(
    categories
      .filter((category) => requestedKeys.has(category.key))
      .map((category) => categoryIdentity(category.spaceKey, category.key)),
  );
  if (!includeDescendants) return identities;
  let changed = true;
  while (changed) {
    changed = false;
    for (const category of categories) {
      if (
        category.parentKey &&
        identities.has(
          categoryIdentity(category.spaceKey, category.parentKey),
        ) &&
        !identities.has(categoryIdentity(category.spaceKey, category.key))
      ) {
        identities.add(categoryIdentity(category.spaceKey, category.key));
        changed = true;
      }
    }
  }
  return identities;
}

function categoryFilter(
  categories: readonly CategoryRecord[],
  keys: readonly string[] | undefined,
  includeDescendants: boolean,
): Set<string> | null {
  if (keys === undefined) return null;
  const normalized = keys.map((key) => key.trim()).filter(Boolean);
  return categoryIdentitiesFor(categories, normalized, includeDescendants);
}

function amountCountForQualified(
  currency: string,
  records: readonly QualifiedRecord[],
): FinancialAmountCount {
  return checkedAmount(currency, records);
}

function monthlyRange(period: FinancialAnalyticsPeriod): string[] {
  const months: string[] = [];
  let cursor = period.from.slice(0, 7);
  const finalMonth = period.through.slice(0, 7);
  while (cursor <= finalMonth) {
    months.push(cursor);
    cursor = nextMonth(cursor);
  }
  return months;
}

function classifyRecords(
  records: readonly TransactionRecord[],
  period: FinancialAnalyticsPeriod,
  authorityScope: FinancialAnalyticsAuthorityScope,
  asOfFinancialDate: string,
): Pick<AnalyticsDataset, "ordinary" | "legacy" | "excluded"> {
  const ordinary: QualifiedRecord[] = [];
  const legacy: QualifiedRecord[] = [];
  const excluded: ExcludedRecord[] = [];
  for (const record of records) {
    const financialDate = transactionFinancialDate(record);
    if (!financialDate) {
      const recordedDate = normalizedRecordedDate(record);
      if (recordedDate && inPeriod(recordedDate, period)) {
        excluded.push({
          record,
          reason: recordedDate > asOfFinancialDate ? "future" : "invalid",
        });
      }
      continue;
    }
    if (!inPeriod(financialDate, period)) continue;
    if (financialDate > asOfFinancialDate) {
      excluded.push({ record, reason: "future" });
      continue;
    }
    if (record.status === "ignored") {
      excluded.push({ record, reason: "ignored" });
      continue;
    }
    const invalid =
      record.amountMinor === null ||
      record.amountMinor <= 0 ||
      record.warnings.some((warning) => INVALID_WARNING_CODES.has(warning));
    if (invalid) {
      excluded.push({ record, reason: "invalid" });
      continue;
    }
    if (record.kind === "transfer") {
      excluded.push({ record, reason: "transfer" });
      continue;
    }
    if (record.kind === "adjustment") {
      excluded.push({ record, reason: "adjustment" });
      continue;
    }
    const coherentMovement =
      (record.kind === "income" && record.flowDirection === "inflow") ||
      (record.kind === "expense" && record.flowDirection === "outflow");
    if (!coherentMovement) {
      excluded.push({ record, reason: "unresolved" });
      continue;
    }
    const ledgerAuthority = transactionLedgerAuthority(record);
    if (ledgerAuthority === "canonical_historical_superseded") {
      excluded.push({ record, reason: "historical_authority" });
      continue;
    }
    if (ledgerAuthority === "legacy_unreconciled") {
      if (authorityScope === "active_ledger_with_legacy_unreconciled") {
        legacy.push({ record, date: financialDate, authority: "legacy" });
      } else {
        excluded.push({ record, reason: "historical_authority" });
      }
      continue;
    }
    if (transactionEvidenceState(record) === "unresolved") {
      excluded.push({ record, reason: "unresolved" });
      continue;
    }
    ordinary.push({ record, date: financialDate, authority: "ordinary" });
  }
  return { ordinary, legacy, excluded };
}

export class FinancialAnalyticsService implements FinancialAnalyticsApi {
  constructor(
    private readonly repository: FinancialAnalyticsRepository,
    private readonly clock: () => Date = () => new Date(),
  ) {}

  private async dataset(
    input: FinancialAnalyticsScopeInput,
  ): Promise<AnalyticsDataset> {
    const period = normalizeFinancialAnalyticsPeriod(input);
    const asOf = normalizeAsOf(input.asOf, this.clock);
    const currency = money({
      currency: input.currency,
      minorUnits: 0,
    }).currency;
    if (input.spaceKeys !== undefined && input.accountRefs !== undefined) {
      throw new RavenDomainError(
        "INVALID_TRANSACTION",
        "Use Financial Spaces or Accounts as the scope, not both",
      );
    }
    const hasExplicitEmptyScope =
      input.spaceKeys?.length === 0 || input.accountRefs?.length === 0;
    const allAccounts = hasExplicitEmptyScope
      ? []
      : await this.repository.listAccounts(input.spaceKeys);
    let accounts = allAccounts;
    if (input.accountRefs !== undefined) {
      const requested = new Set(
        input.accountRefs.map(
          (ref) => `${ref.spaceKey.trim()}\u0000${ref.accountKey.trim()}`,
        ),
      );
      accounts = allAccounts.filter((account) =>
        requested.has(`${account.spaceKey}\u0000${account.key}`),
      );
      if (accounts.length !== requested.size) {
        throw new RavenDomainError(
          "NOT_FOUND",
          "Financial analytics Account not found",
        );
      }
    }
    const currencyMismatch = accounts.some(
      (account) => account.currency !== currency,
    );
    if (input.accountRefs !== undefined && currencyMismatch) {
      throw new RavenDomainError(
        "CURRENCY_MISMATCH",
        "Requested Account currency does not match the analytics currency",
      );
    }
    accounts = accounts
      .filter((account) => account.currency === currency)
      .sort(
        (left, right) =>
          left.spaceKey.localeCompare(right.spaceKey) ||
          left.key.localeCompare(right.key),
      );
    const authorityScope = input.authorityScope ?? "active_ledger";
    const records = accounts.length
      ? await this.repository.listFinancialAnalyticsTransactions({
          accountIds: accounts.map((account) => account.id),
          currency,
          authorityScope,
          from: period.from,
          through: period.through,
        })
      : [];
    const spaces = [
      ...new Set(accounts.map((account) => account.spaceKey)),
    ].sort();
    const categories = (
      await Promise.all(
        spaces.map((spaceKey) => this.repository.listCategories(spaceKey)),
      )
    )
      .flat()
      .sort(
        (left, right) =>
          left.spaceKey.localeCompare(right.spaceKey) ||
          left.key.localeCompare(right.key),
      );
    return {
      period,
      currency,
      authorityScope,
      accounts,
      categories,
      ...classifyRecords(records, period, authorityScope, asOf.financialDate),
      asOf: asOf.instant,
      asOfFinancialDate: asOf.financialDate,
    };
  }

  async getPeriodFinancialSummary(
    input: GetPeriodFinancialSummaryInput,
  ): Promise<GetPeriodFinancialSummaryOutput> {
    const dataset = await this.dataset(input);
    const rows = dataset.accounts.map((account) => {
      const ordinary = dataset.ordinary.filter(
        ({ record }) => record.accountId === account.id,
      );
      const legacy = dataset.legacy.filter(
        ({ record }) => record.accountId === account.id,
      );
      return {
        account: { spaceKey: account.spaceKey, accountKey: account.key },
        ordinary: movementTotals(dataset.currency, ordinary),
        legacyUnreconciled: movementTotals(dataset.currency, legacy),
      };
    });
    const drillDown = [...dataset.ordinary, ...dataset.legacy];
    return {
      ordinary: movementTotals(dataset.currency, dataset.ordinary),
      legacyUnreconciled: movementTotals(dataset.currency, dataset.legacy),
      accounts: rows,
      meta: meta(dataset, {}, drillDown),
    };
  }

  async getCategorySpendSummary(
    input: GetCategorySpendSummaryInput,
  ): Promise<GetCategorySpendSummaryOutput> {
    const dataset = await this.dataset(input);
    const filter = categoryFilter(
      dataset.categories,
      input.categoryKeys,
      input.includeDescendants === true,
    );
    const ordinary = expenseRecords(dataset.ordinary).filter(
      ({ record }) =>
        record.categoryKey &&
        (!filter ||
          filter.has(categoryIdentity(record.spaceKey, record.categoryKey))),
    );
    const legacy = expenseRecords(dataset.legacy).filter(
      ({ record }) =>
        record.categoryKey &&
        (!filter ||
          filter.has(categoryIdentity(record.spaceKey, record.categoryKey))),
    );
    const keys = new Set(
      [...ordinary, ...legacy].map(
        ({ record }) => `${record.spaceKey}\u0000${record.categoryKey}`,
      ),
    );
    const categories: FinancialCategorySpendRow[] = [...keys]
      .map((identity) => {
        const [spaceKey, key] = identity.split("\u0000") as [string, string];
        const category = dataset.categories.find(
          (item) => item.spaceKey === spaceKey && item.key === key,
        );
        const activeRecords = ordinary.filter(
          ({ record }) =>
            record.spaceKey === spaceKey && record.categoryKey === key,
        );
        const legacyRecords = legacy.filter(
          ({ record }) =>
            record.spaceKey === spaceKey && record.categoryKey === key,
        );
        return {
          category: {
            spaceKey,
            key,
            name: category?.name ?? key,
            kind: category?.kind ?? "other",
          },
          ordinary: amountCountForQualified(dataset.currency, activeRecords),
          legacyUnreconciled: amountCountForQualified(
            dataset.currency,
            legacyRecords,
          ),
          ...recordRefSummary([...activeRecords, ...legacyRecords]),
        };
      })
      .sort(
        (left, right) =>
          right.ordinary.amount.minorUnits - left.ordinary.amount.minorUnits ||
          left.category.spaceKey.localeCompare(right.category.spaceKey) ||
          left.category.key.localeCompare(right.category.key),
      );
    return {
      categories,
      ordinary: amountCountForQualified(dataset.currency, ordinary),
      legacyUnreconciled: amountCountForQualified(dataset.currency, legacy),
      meta: meta(
        dataset,
        input.categoryKeys
          ? { categoryKeys: [...input.categoryKeys].sort() }
          : {},
        [...ordinary, ...legacy],
      ),
    };
  }

  async getMerchantSpendSummary(
    input: GetMerchantSpendSummaryInput,
  ): Promise<GetMerchantSpendSummaryOutput> {
    const dataset = await this.dataset(input);
    const filter = input.merchantNames
      ? new Set(input.merchantNames.map(normalText).filter(Boolean))
      : null;
    const predicate = ({ record }: QualifiedRecord) => {
      const merchant = record.merchantName
        ? normalText(record.merchantName)
        : "";
      return Boolean(merchant) && (!filter || filter.has(merchant));
    };
    const ordinary = expenseRecords(dataset.ordinary).filter(predicate);
    const legacy = expenseRecords(dataset.legacy).filter(predicate);
    const names = new Set(
      [...ordinary, ...legacy].map(({ record }) =>
        normalText(record.merchantName!),
      ),
    );
    const merchants: FinancialMerchantSpendRow[] = [...names]
      .map((normalizedName) => {
        const activeRecords = ordinary.filter(
          ({ record }) => normalText(record.merchantName!) === normalizedName,
        );
        const legacyRecords = legacy.filter(
          ({ record }) => normalText(record.merchantName!) === normalizedName,
        );
        const displayNames = [...activeRecords, ...legacyRecords]
          .map(({ record }) => record.merchantName!.trim())
          .sort((left, right) => left.localeCompare(right));
        return {
          merchantName: displayNames[0] ?? normalizedName,
          ordinary: amountCountForQualified(dataset.currency, activeRecords),
          legacyUnreconciled: amountCountForQualified(
            dataset.currency,
            legacyRecords,
          ),
          ...recordRefSummary([...activeRecords, ...legacyRecords]),
        };
      })
      .sort(
        (left, right) =>
          right.ordinary.amount.minorUnits - left.ordinary.amount.minorUnits ||
          left.merchantName.localeCompare(right.merchantName),
      );
    return {
      merchants,
      ordinary: amountCountForQualified(dataset.currency, ordinary),
      legacyUnreconciled: amountCountForQualified(dataset.currency, legacy),
      meta: meta(
        dataset,
        input.merchantNames
          ? { merchantNames: [...input.merchantNames].sort() }
          : {},
        [...ordinary, ...legacy],
      ),
    };
  }

  private matchesFeeRule(
    rule: FeeEvidenceRuleInput,
    item: QualifiedRecord,
    categories: readonly CategoryRecord[],
  ): boolean {
    if (rule.type === "category") {
      const identities = categoryIdentitiesFor(
        categories,
        rule.categoryKeys,
        rule.includeDescendants === true,
      );
      return Boolean(
        item.record.categoryKey &&
        identities.has(
          categoryIdentity(item.record.spaceKey, item.record.categoryKey),
        ),
      );
    }
    if (rule.type === "merchant_exact") {
      const names = new Set(rule.merchantNames.map(normalText).filter(Boolean));
      return Boolean(
        item.record.merchantName &&
        names.has(normalText(item.record.merchantName)),
      );
    }
    const description = normalText(item.record.description);
    return rule.phrases
      .map(normalText)
      .filter(Boolean)
      .some((phrase) => description.includes(phrase));
  }

  async getFeeSummary(input: GetFeeSummaryInput): Promise<GetFeeSummaryOutput> {
    if (input.rules.length === 0) {
      throw new RavenDomainError(
        "INVALID_CATEGORY",
        "Fee summary requires at least one reviewed evidence rule",
      );
    }
    const ids = new Set<string>();
    for (const rule of input.rules) {
      const id = rule.id.trim();
      if (!id || ids.has(id)) {
        throw new RavenDomainError(
          "INVALID_CATEGORY",
          "Fee evidence rule ids must be non-empty and unique",
        );
      }
      ids.add(id);
    }
    const dataset = await this.dataset(input);
    const ordinaryFees = expenseRecords(dataset.ordinary);
    const legacyFees = expenseRecords(dataset.legacy);
    const assignments = new Map<string, number>();
    for (const item of [...ordinaryFees, ...legacyFees]) {
      const index = input.rules.findIndex((rule) =>
        this.matchesFeeRule(rule, item, dataset.categories),
      );
      if (index >= 0) assignments.set(item.record.id, index);
    }
    const subtotals: FinancialFeeSubtotal[] = input.rules.map((rule, index) => {
      const ordinary = ordinaryFees.filter(
        (item) => assignments.get(item.record.id) === index,
      );
      const legacy = legacyFees.filter(
        (item) => assignments.get(item.record.id) === index,
      );
      return {
        ruleId: rule.id.trim(),
        label: rule.label.trim(),
        ruleType: rule.type,
        precedence: index,
        ordinary: amountCountForQualified(dataset.currency, ordinary),
        legacyUnreconciled: amountCountForQualified(dataset.currency, legacy),
        ...recordRefSummary([...ordinary, ...legacy]),
      };
    });
    const matchedOrdinary = ordinaryFees.filter((item) =>
      assignments.has(item.record.id),
    );
    const matchedLegacy = legacyFees.filter((item) =>
      assignments.has(item.record.id),
    );
    return {
      subtotals,
      ordinary: amountCountForQualified(dataset.currency, matchedOrdinary),
      legacyUnreconciled: amountCountForQualified(
        dataset.currency,
        matchedLegacy,
      ),
      meta: meta(
        dataset,
        { feeRuleIds: input.rules.map((rule) => rule.id.trim()) },
        [...matchedOrdinary, ...matchedLegacy],
      ),
    };
  }

  async getMonthlyFinancialTrend(
    input: GetMonthlyFinancialTrendInput,
  ): Promise<GetMonthlyFinancialTrendOutput> {
    const dataset = await this.dataset(input);
    return {
      months: monthlyRange(dataset.period).map((month) => {
        const ordinary = dataset.ordinary.filter((item) =>
          item.date.startsWith(month),
        );
        const legacy = dataset.legacy.filter((item) =>
          item.date.startsWith(month),
        );
        return {
          month,
          ordinary: movementTotals(dataset.currency, ordinary),
          legacyUnreconciled: movementTotals(dataset.currency, legacy),
          accounts: dataset.accounts.map((account) => ({
            account: {
              spaceKey: account.spaceKey,
              accountKey: account.key,
            },
            ordinary: movementTotals(
              dataset.currency,
              ordinary.filter(({ record }) => record.accountId === account.id),
            ),
            legacyUnreconciled: movementTotals(
              dataset.currency,
              legacy.filter(({ record }) => record.accountId === account.id),
            ),
          })),
        };
      }),
      meta: meta(dataset, {}, [...dataset.ordinary, ...dataset.legacy]),
    };
  }

  async listUncategorizedTransactions(
    input: ListUncategorizedTransactionsInput,
  ): Promise<ListUncategorizedTransactionsOutput> {
    const dataset = await this.dataset(input);
    const all = [...dataset.ordinary, ...dataset.legacy]
      .filter(({ record }) => !record.categoryId && !record.categoryKey)
      .sort(
        (left, right) =>
          right.date.localeCompare(left.date) ||
          right.record.id.localeCompare(left.record.id),
      );
    const limit = Math.min(100, Math.max(1, input.limit ?? 50));
    const cursorIndex = input.cursor
      ? all.findIndex(({ record }) => record.id === input.cursor)
      : -1;
    if (input.cursor && cursorIndex < 0) {
      throw new RavenDomainError(
        "NOT_FOUND",
        "Uncategorized cursor was not found",
      );
    }
    const start = cursorIndex + 1;
    const page = all.slice(start, start + limit);
    const ordinaryPage = page.filter((item) => item.authority === "ordinary");
    const legacyPage = page.filter((item) => item.authority === "legacy");
    const ordinaryAll = all.filter((item) => item.authority === "ordinary");
    const legacyAll = all.filter((item) => item.authority === "legacy");
    const transactions: FinancialUncategorizedTransaction[] = page.map(
      (item) => ({
        transactionRef: item.record.id,
        account: {
          spaceKey: item.record.spaceKey,
          accountKey: item.record.accountKey,
        },
        financialDate: item.date,
        amount: money(
          { currency: dataset.currency, minorUnits: item.record.amountMinor! },
          { nonNegative: true },
        ),
        kind: item.record.kind as "income" | "expense",
        flowDirection: item.record.flowDirection as "inflow" | "outflow",
        authority:
          item.authority === "ordinary"
            ? "active_ledger"
            : "legacy_unreconciled",
        evidenceState:
          item.authority === "legacy"
            ? "legacy_unreconciled"
            : transactionEvidenceState(item.record),
      }),
    );
    return {
      transactions,
      page: {
        ordinary: amountCountForQualified(dataset.currency, ordinaryPage),
        legacyUnreconciled: amountCountForQualified(
          dataset.currency,
          legacyPage,
        ),
      },
      total: {
        ordinary: amountCountForQualified(dataset.currency, ordinaryAll),
        legacyUnreconciled: amountCountForQualified(
          dataset.currency,
          legacyAll,
        ),
      },
      nextCursor:
        start + page.length < all.length
          ? page[page.length - 1]!.record.id
          : null,
      meta: meta(dataset, {}, all),
    };
  }

  async getFinancialDataQualitySummary(
    input: GetFinancialDataQualitySummaryInput,
  ): Promise<GetFinancialDataQualitySummaryOutput> {
    const dataset = await this.dataset(input);
    const uncategorized = dataset.ordinary.filter(
      ({ record }) => !record.categoryId && !record.categoryKey,
    );
    return {
      activeIncludedGrossKnownMovementVolume: amountCountForQualified(
        dataset.currency,
        dataset.ordinary,
      ),
      legacyUnreconciledGrossKnownMovementVolume: amountCountForQualified(
        dataset.currency,
        dataset.legacy,
      ),
      uncategorizedGrossKnownMovementVolume: amountCountForQualified(
        dataset.currency,
        uncategorized,
      ),
      excludedGrossKnownMovementVolume: checkedAmount(
        dataset.currency,
        dataset.excluded,
      ),
      meta: meta(dataset, {}, [...dataset.ordinary, ...dataset.legacy]),
    };
  }
}

export function createFinancialAnalyticsService(
  repository: FinancialAnalyticsRepository,
  clock?: () => Date,
): FinancialAnalyticsApi {
  return new FinancialAnalyticsService(repository, clock);
}
