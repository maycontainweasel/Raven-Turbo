import assert from "node:assert/strict";
import test from "node:test";
import type {
  AccountRecord,
  CategoryRecord,
  TransactionRecord,
} from "./contracts.js";
import type {
  FinancialAnalyticsRepository,
  FinancialAnalyticsTransactionFilter,
} from "./financial-analytics-repository.js";
import {
  createFinancialAnalyticsService,
  normalizeFinancialAnalyticsPeriod,
} from "./financial-analytics-service.js";

const accounts: AccountRecord[] = [
  {
    id: "account:fictional-daily",
    spaceId: "financialSpace:fictional-personal",
    spaceKey: "fictional-personal",
    key: "fictional-daily",
    name: "Fictional Daily",
    bankName: "Fictional Bank",
    accountType: "current",
    currency: "ZAR",
    normalNature: "asset",
    liquidityClass: "liquid",
    freshnessWindowHours: 72,
    active: true,
  },
  {
    id: "account:fictional-business",
    spaceId: "financialSpace:fictional-business",
    spaceKey: "fictional-business",
    key: "fictional-business",
    name: "Fictional Business",
    bankName: "Fictional Bank",
    accountType: "current",
    currency: "ZAR",
    normalNature: "asset",
    liquidityClass: "liquid",
    freshnessWindowHours: 72,
    active: true,
  },
];

const categories: CategoryRecord[] = [
  {
    id: "category:fictional-personal-essentials",
    spaceId: "financialSpace:fictional-personal",
    spaceKey: "fictional-personal",
    key: "essentials",
    name: "Fictional Essentials",
    kind: "expense",
    active: true,
  },
  {
    id: "category:fictional-personal-groceries",
    spaceId: "financialSpace:fictional-personal",
    spaceKey: "fictional-personal",
    key: "groceries",
    name: "Fictional Groceries",
    kind: "expense",
    parentId: "category:fictional-personal-essentials",
    parentKey: "essentials",
    parentName: "Fictional Essentials",
    active: true,
  },
  {
    id: "category:fictional-business-fees",
    spaceId: "financialSpace:fictional-business",
    spaceKey: "fictional-business",
    key: "fees",
    name: "Fictional Fees",
    kind: "expense",
    active: true,
  },
  {
    id: "category:fictional-business-failed-fees",
    spaceId: "financialSpace:fictional-business",
    spaceKey: "fictional-business",
    key: "failed-payment-fees",
    name: "Fictional Failed Payment Fees",
    kind: "expense",
    parentId: "category:fictional-business-fees",
    parentKey: "fees",
    parentName: "Fictional Fees",
    active: true,
  },
  {
    id: "category:fictional-personal-failed-fees",
    spaceId: "financialSpace:fictional-personal",
    spaceKey: "fictional-personal",
    key: "failed-payment-fees",
    name: "Fictional Personal Standalone Fees",
    kind: "expense",
    active: true,
  },
  {
    id: "category:fictional-personal-income",
    spaceId: "financialSpace:fictional-personal",
    spaceKey: "fictional-personal",
    key: "income",
    name: "Fictional Income",
    kind: "income",
    active: true,
  },
  {
    id: "category:fictional-business-income",
    spaceId: "financialSpace:fictional-business",
    spaceKey: "fictional-business",
    key: "income",
    name: "Fictional Income",
    kind: "income",
    active: true,
  },
];

function transaction(
  id: string,
  input: Partial<TransactionRecord> = {},
): TransactionRecord {
  const business = input.accountId === "account:fictional-business";
  return {
    id: `transaction:${id}`,
    key: id,
    spaceId: business
      ? "financialSpace:fictional-business"
      : "financialSpace:fictional-personal",
    spaceKey: business ? "fictional-business" : "fictional-personal",
    accountId: business
      ? "account:fictional-business"
      : "account:fictional-daily",
    accountKey: business ? "fictional-business" : "fictional-daily",
    postedAt: "2026-07-10",
    effectiveAt: null,
    recordedAt: "2026-07-10T12:00:00.000Z",
    description: `Fictional movement ${id}`,
    amountMinor: 1_000,
    currency: "ZAR",
    kind: "expense",
    flowDirection: "outflow",
    entrySource: "manual",
    status: "classified",
    ledgerAuthority: "active",
    warnings: [],
    ...input,
  };
}

const records: TransactionRecord[] = [
  transaction("statement-income", {
    amountMinor: 100_000,
    kind: "income",
    flowDirection: "inflow",
    entrySource: "imported",
    categoryId: "category:fictional-personal-income",
    categoryKey: "income",
    categoryName: "Fictional Income",
    categoryKind: "income",
    sourceRowId: "statementRow:fictional-income",
    statementMatchId: "statementTransactionMatch:fictional-income",
    statementMatchState: "confirmed",
    statementMatchSourceState: "committed",
    statementImportSourceState: "committed",
    hasActiveStatementClaim: true,
  }),
  transaction("business-income", {
    accountId: "account:fictional-business",
    amountMinor: 50_000,
    kind: "income",
    flowDirection: "inflow",
    categoryId: "category:fictional-business-income",
    categoryKey: "income",
    categoryName: "Fictional Income",
    categoryKind: "income",
  }),
  transaction("groceries", {
    amountMinor: 20_000,
    categoryId: "category:fictional-personal-groceries",
    categoryKey: "groceries",
    categoryName: "Fictional Groceries",
    categoryKind: "expense",
    merchantName: "Fictional Market",
  }),
  transaction("failed-fee", {
    accountId: "account:fictional-business",
    amountMinor: 1_000,
    entrySource: "imported",
    description: "Fictional failed payment fee",
    categoryId: "category:fictional-business-failed-fees",
    categoryKey: "failed-payment-fees",
    categoryName: "Fictional Failed Payment Fees",
    categoryKind: "expense",
    merchantName: "Fictional Bank",
    sourceRowId: "statementRow:fictional-fee",
    statementMatchId: "statementTransactionMatch:fictional-fee",
    statementMatchState: "confirmed",
    statementMatchSourceState: "committed",
    statementImportSourceState: "committed",
    hasActiveStatementClaim: true,
  }),
  transaction("uncategorized-one", {
    amountMinor: 4_000,
    postedAt: "2026-07-20",
  }),
  transaction("uncategorized-two", {
    amountMinor: 2_000,
    postedAt: "2026-07-19",
  }),
  transaction("transfer-out", {
    amountMinor: 5_000,
    kind: "transfer",
    flowDirection: "outflow",
    transferId: "accountTransfer:fictional",
  }),
  transaction("transfer-in", {
    accountId: "account:fictional-business",
    amountMinor: 5_000,
    kind: "transfer",
    flowDirection: "inflow",
    transferId: "accountTransfer:fictional",
  }),
  transaction("ignored", { amountMinor: 3_000, status: "ignored" }),
  transaction("unresolved", {
    amountMinor: 4_000,
    kind: "unresolved",
    flowDirection: null,
    entrySource: "imported",
    warnings: ["TRANSACTION_SEMANTICS_UNRESOLVED"],
  }),
  transaction("invalid", {
    amountMinor: 500,
    warnings: ["CANONICAL_LEGACY_CONFLICT"],
  }),
  transaction("legacy-groceries", {
    amountMinor: 7_000,
    entrySource: "imported",
    sourceRowId: "statementRow:legacy-fictional",
    ledgerAuthority: "legacy_unreconciled",
    categoryId: "category:fictional-personal-groceries",
    categoryKey: "groceries",
    categoryName: "Fictional Groceries",
    categoryKind: "expense",
    merchantName: "Fictional Market",
  }),
  transaction("canonical-superseded", {
    amountMinor: 8_000,
    entrySource: "imported",
    sourceRowId: "statementRow:canonical-superseded",
    statementMatchId: "statementTransactionMatch:canonical-superseded",
    statementMatchState: "superseded",
    statementMatchSourceState: "superseded",
    statementImportSourceState: "superseded",
    ledgerAuthority: "canonical_historical_superseded",
  }),
  transaction("june-groceries", {
    postedAt: "2026-06-30",
    recordedAt: "2026-06-30T12:00:00.000Z",
    amountMinor: 10_000,
    categoryId: "category:fictional-personal-groceries",
    categoryKey: "groceries",
    categoryName: "Fictional Groceries",
    categoryKind: "expense",
    merchantName: "Fictional Market",
  }),
  transaction("outside-period", {
    postedAt: "2026-05-31",
    recordedAt: "2026-05-31T12:00:00.000Z",
    amountMinor: 99_999,
  }),
];

class FictionalRepository implements FinancialAnalyticsRepository {
  readonly calls: string[] = [];
  readonly transactionFilters: FinancialAnalyticsTransactionFilter[] = [];

  constructor(private readonly transactions = records) {}

  async listAccounts(spaceKeys?: string[]) {
    this.calls.push("listAccounts");
    return accounts.filter(
      (account) => !spaceKeys || spaceKeys.includes(account.spaceKey),
    );
  }

  async listCategories(spaceKey: string) {
    this.calls.push("listCategories");
    return categories.filter((category) => category.spaceKey === spaceKey);
  }

  async listFinancialAnalyticsTransactions(
    filter: FinancialAnalyticsTransactionFilter,
  ) {
    this.calls.push("listFinancialAnalyticsTransactions");
    this.transactionFilters.push(filter);
    return this.transactions;
  }
}

const clock = () => new Date("2026-08-12T08:00:00.000Z");
const july = { month: "2026-07", currency: "ZAR" } as const;

test("period summary is exact across Accounts and excludes transfers and bad authority", async () => {
  const repository = new FictionalRepository();
  const service = createFinancialAnalyticsService(repository, clock);
  const result = await service.getPeriodFinancialSummary(july);

  assert.equal(result.ordinary.income.minorUnits, 150_000);
  assert.equal(result.ordinary.outflow.minorUnits, 27_000);
  assert.equal(result.ordinary.net.minorUnits, 123_000);
  assert.deepEqual(
    result.accounts.map((row) => [
      row.account.accountKey,
      row.ordinary.income.minorUnits,
      row.ordinary.outflow.minorUnits,
    ]),
    [
      ["fictional-business", 50_000, 1_000],
      ["fictional-daily", 100_000, 26_000],
    ],
  );
  assert.equal(result.legacyUnreconciled.outflow.minorUnits, 0);
  assert.deepEqual(
    Object.fromEntries(
      result.meta.exclusions.map((row) => [row.reason, row.count]),
    ),
    {
      ignored: 1,
      unresolved: 1,
      invalid: 1,
      transfer: 2,
      historical_authority: 2,
    },
  );
  assert.equal(result.meta.formulaVersion, "raven.financial-read-analytics.v2");
  assert.equal(result.meta.categoryMeaning, "management_only_no_tax_inference");
  assert.ok(repository.calls.every((call) => call.startsWith("list")));
});

test("legacy unreconciled evidence is explicit and never enters ordinary totals", async () => {
  const service = createFinancialAnalyticsService(
    new FictionalRepository(),
    clock,
  );
  const result = await service.getPeriodFinancialSummary({
    ...july,
    authorityScope: "active_ledger_with_legacy_unreconciled",
  });
  assert.equal(result.ordinary.outflow.minorUnits, 27_000);
  assert.equal(result.legacyUnreconciled.outflow.minorUnits, 7_000);
  assert.equal(
    result.meta.authorityBuckets.find(
      (bucket) => bucket.authority === "legacy_unreconciled",
    )?.count,
    1,
  );
  assert.equal(
    result.meta.exclusions.some(
      (exclusion) => exclusion.reason === "historical_authority",
    ),
    true,
  );
  assert.equal(
    result.meta.exclusions.find(
      (exclusion) => exclusion.reason === "historical_authority",
    )?.count,
    1,
  );
});

test("legacy-inclusive totals contain only genuine renderer-era legacy after canonical supersession", async () => {
  const authorityRecords = [
    transaction("source-created-superseded", {
      amountMinor: 1_000,
      entrySource: "imported",
      sourceRowId: "statementRow:fictional-source-created",
      statementMatchId: null,
      effectiveAt: null,
      hasCanonicalStatementMatchHistory: true,
      ledgerAuthority: undefined,
    }),
    transaction("adopted-legacy-superseded", {
      amountMinor: 2_000,
      entrySource: "imported",
      sourceRowId: "statementRow:fictional-adopted-legacy",
      statementMatchId: null,
      effectiveAt: null,
      hasCanonicalStatementMatchHistory: true,
      ledgerAuthority: undefined,
    }),
    transaction("renderer-era-legacy", {
      amountMinor: 3_000,
      entrySource: "imported",
      sourceRowId: "statementRow:fictional-renderer-era",
      statementMatchId: null,
      hasCanonicalStatementMatchHistory: false,
      ledgerAuthority: undefined,
    }),
    transaction("manual-returned-to-provisional", {
      amountMinor: 4_000,
      postedAt: "2026-07-11",
      effectiveAt: null,
      entrySource: "manual",
      sourceRowId: null,
      statementMatchId: null,
      hasCanonicalStatementMatchHistory: true,
      ledgerAuthority: undefined,
    }),
  ];
  const service = createFinancialAnalyticsService(
    new FictionalRepository(authorityRecords),
    clock,
  );

  const active = await service.getPeriodFinancialSummary(july);
  const inclusive = await service.getPeriodFinancialSummary({
    ...july,
    authorityScope: "active_ledger_with_legacy_unreconciled",
  });

  assert.deepEqual(active.ordinary, inclusive.ordinary);
  assert.equal(active.ordinary.outflow.minorUnits, 4_000);
  assert.equal(active.legacyUnreconciled.outflow.minorUnits, 0);
  assert.equal(inclusive.legacyUnreconciled.outflow.minorUnits, 3_000);
  const legacyBucket = inclusive.meta.authorityBuckets.find(
    (bucket) => bucket.authority === "legacy_unreconciled",
  );
  assert.equal(legacyBucket?.count, 1);
  assert.deepEqual(legacyBucket?.transactionRefs, [
    "transaction:renderer-era-legacy",
  ]);
  assert.equal(
    inclusive.meta.exclusions.find(
      (exclusion) => exclusion.reason === "historical_authority",
    )?.count,
    2,
  );
});

test("category, merchant, and fee summaries retain exact rule authority", async () => {
  const service = createFinancialAnalyticsService(
    new FictionalRepository(),
    clock,
  );
  const category = await service.getCategorySpendSummary({
    ...july,
    categoryKeys: ["essentials"],
    includeDescendants: true,
  });
  assert.equal(category.ordinary.amount.minorUnits, 20_000);
  assert.equal(category.categories[0]?.category.key, "groceries");

  const merchant = await service.getMerchantSpendSummary({
    from: "2026-06-01",
    through: "2026-07-31",
    currency: "ZAR",
    merchantNames: ["fictional market"],
  });
  assert.equal(merchant.ordinary.amount.minorUnits, 30_000);
  assert.equal(merchant.merchants[0]?.ordinary.count, 2);

  const fees = await service.getFeeSummary({
    ...july,
    rules: [
      {
        id: "reviewed-fee-category",
        label: "Fictional reviewed fee Category",
        type: "category",
        categoryKeys: ["fees"],
        includeDescendants: true,
      },
      {
        id: "reviewed-fee-description",
        label: "Fictional explicit fee description",
        type: "description_contains",
        phrases: ["failed payment fee"],
      },
    ],
  });
  assert.equal(fees.ordinary.amount.minorUnits, 1_000);
  assert.equal(fees.subtotals[0]?.ordinary.count, 1);
  assert.equal(fees.subtotals[1]?.ordinary.count, 0);
  assert.deepEqual(
    fees.subtotals.map((row) => row.precedence),
    [0, 1],
  );
});

test("Category descendants and fee rules remain qualified by Financial Space", async () => {
  const personalDuplicate = transaction("personal-standalone-fee", {
    amountMinor: 900,
    categoryId: "category:fictional-personal-failed-fees",
    categoryKey: "failed-payment-fees",
    categoryName: "Fictional Personal Standalone Fees",
    categoryKind: "expense",
  });
  const service = createFinancialAnalyticsService(
    new FictionalRepository([...records, personalDuplicate]),
    clock,
  );

  const category = await service.getCategorySpendSummary({
    ...july,
    categoryKeys: ["fees"],
    includeDescendants: true,
  });
  assert.equal(category.ordinary.amount.minorUnits, 1_000);
  assert.deepEqual(
    category.categories.map((row) => [row.category.spaceKey, row.category.key]),
    [["fictional-business", "failed-payment-fees"]],
  );

  const fees = await service.getFeeSummary({
    ...july,
    rules: [
      {
        id: "business-fees",
        label: "Fictional Business fee hierarchy",
        type: "category",
        categoryKeys: ["fees"],
        includeDescendants: true,
      },
    ],
  });
  assert.equal(fees.ordinary.amount.minorUnits, 1_000);
  assert.equal(fees.subtotals[0]?.ordinary.count, 1);
});

test("monthly trend honors prior, current, and cross-month inclusive bounds", async () => {
  const service = createFinancialAnalyticsService(
    new FictionalRepository(),
    clock,
  );
  const result = await service.getMonthlyFinancialTrend({
    from: "2026-06-30",
    through: "2026-07-10",
    currency: "ZAR",
  });
  assert.deepEqual(
    result.months.map((row) => [
      row.month,
      row.ordinary.income.minorUnits,
      row.ordinary.outflow.minorUnits,
    ]),
    [
      ["2026-06", 0, 10_000],
      ["2026-07", 150_000, 21_000],
    ],
  );
  assert.deepEqual(
    result.months[1]?.accounts.map((row) => [
      row.account.accountKey,
      row.ordinary.income.minorUnits,
      row.ordinary.outflow.minorUnits,
    ]),
    [
      ["fictional-business", 50_000, 1_000],
      ["fictional-daily", 100_000, 20_000],
    ],
  );
  assert.deepEqual(normalizeFinancialAnalyticsPeriod(july), {
    month: "2026-07",
    from: "2026-07-01",
    through: "2026-07-31",
  });
});

test("uncategorized pages reconcile exactly to aggregate totals", async () => {
  const service = createFinancialAnalyticsService(
    new FictionalRepository(),
    clock,
  );
  const first = await service.listUncategorizedTransactions({
    ...july,
    limit: 1,
  });
  const second = await service.listUncategorizedTransactions({
    ...july,
    limit: 1,
    cursor: first.nextCursor!,
  });
  assert.equal(first.total.ordinary.amount.minorUnits, 6_000);
  assert.equal(first.total.ordinary.count, 2);
  assert.equal(
    first.page.ordinary.amount.minorUnits +
      second.page.ordinary.amount.minorUnits,
    first.total.ordinary.amount.minorUnits,
  );
  assert.equal(
    first.transactions[0]?.transactionRef,
    "transaction:uncategorized-one",
  );
  assert.equal(second.nextCursor, null);
});

test("quality summary separates provisional, statement-backed, legacy, and unresolved evidence", async () => {
  const service = createFinancialAnalyticsService(
    new FictionalRepository(),
    clock,
  );
  const result = await service.getFinancialDataQualitySummary({
    ...july,
    authorityScope: "active_ledger_with_legacy_unreconciled",
  });
  const buckets = Object.fromEntries(
    result.meta.authorityBuckets.map((bucket) => [
      bucket.authority,
      bucket.count,
    ]),
  );
  assert.deepEqual(buckets, {
    provisional_manual: 4,
    provisional_generated: 0,
    canonical_statement_backed: 2,
    legacy_unreconciled: 1,
    other_active_unresolved: 2,
  });
  assert.equal(result.uncategorizedGrossKnownMovementVolume.count, 2);
  assert.equal(result.meta.unresolvedGrossKnownMovementVolume.count, 2);
});

test("explicit Account scope supports multiple Accounts and rejects currency drift", async () => {
  const service = createFinancialAnalyticsService(
    new FictionalRepository(),
    clock,
  );
  const scoped = await service.getPeriodFinancialSummary({
    ...july,
    accountRefs: [
      { spaceKey: "fictional-personal", accountKey: "fictional-daily" },
      { spaceKey: "fictional-business", accountKey: "fictional-business" },
    ],
  });
  assert.equal(scoped.meta.accounts.length, 2);
  await assert.rejects(
    service.getPeriodFinancialSummary({ ...july, currency: "GBP" }),
    /Unsupported currency/,
  );
});

test("an explicit empty Financial Space scope returns empty without broad reads", async () => {
  const repository = new FictionalRepository();
  const service = createFinancialAnalyticsService(repository, clock);
  const result = await service.getPeriodFinancialSummary({
    ...july,
    spaceKeys: [],
  });

  assert.equal(result.ordinary.income.minorUnits, 0);
  assert.equal(result.ordinary.outflow.minorUnits, 0);
  assert.deepEqual(result.accounts, []);
  assert.deepEqual(repository.calls, []);
});

test("asOf uses Johannesburg financial dates and excludes later evidence", async () => {
  const service = createFinancialAnalyticsService(
    new FictionalRepository([
      transaction("august-visible", {
        postedAt: "2026-08-01",
        recordedAt: "2026-08-01T00:00:00.000Z",
        amountMinor: 1_000,
      }),
      transaction("august-future", {
        postedAt: "2026-08-02",
        recordedAt: "2026-08-02T00:00:00.000Z",
        amountMinor: 2_000,
      }),
    ]),
    () => new Date("2026-07-31T22:30:00.000Z"),
  );
  const result = await service.getPeriodFinancialSummary({
    month: "2026-08",
    currency: "ZAR",
  });

  assert.equal(result.meta.asOf, "2026-07-31T22:30:00.000Z");
  assert.equal(result.ordinary.outflow.minorUnits, 1_000);
  assert.equal(
    result.meta.exclusions.find((row) => row.reason === "future")?.count,
    1,
  );
  await assert.rejects(
    service.getPeriodFinancialSummary({
      ...july,
      asOf: "2026-07-31T23:00:00",
    }),
    /timezone offset/,
  );
});

test("repository reads receive the exact requested period bounds", async () => {
  const repository = new FictionalRepository();
  const service = createFinancialAnalyticsService(repository, clock);
  await service.getPeriodFinancialSummary({
    from: "2026-06-15",
    through: "2026-07-20",
    currency: "ZAR",
  });

  assert.deepEqual(repository.transactionFilters[0], {
    accountIds: ["account:fictional-business", "account:fictional-daily"],
    currency: "ZAR",
    authorityScope: "active_ledger",
    from: "2026-06-15",
    through: "2026-07-20",
  });
});

test("drill-down references are deterministically bounded and declared", async () => {
  const many = Array.from({ length: 251 }, (_, index) =>
    transaction(`bounded-${String(index).padStart(3, "0")}`, {
      amountMinor: 1_000,
    }),
  );
  const service = createFinancialAnalyticsService(
    new FictionalRepository(many),
    clock,
  );
  const result = await service.getPeriodFinancialSummary(july);

  assert.equal(result.ordinary.outflow.minorUnits, 251_000);
  assert.equal(result.meta.drillDownRefCount, 251);
  assert.equal(result.meta.drillDownRefs.length, 250);
  assert.equal(result.meta.drillDownRefsTruncated, true);
  assert.equal(result.meta.drillDownRefLimit, 250);
  assert.equal(result.meta.drillDownRefs[0], "transaction:bounded-000");
});

test("checked exact-money addition rejects safe-integer overflow", async () => {
  const overflowRecords = [
    transaction("overflow-one", { amountMinor: Number.MAX_SAFE_INTEGER }),
    transaction("overflow-two", { amountMinor: Number.MAX_SAFE_INTEGER }),
  ];
  const service = createFinancialAnalyticsService(
    new FictionalRepository(overflowRecords),
    clock,
  );
  await assert.rejects(service.getPeriodFinancialSummary(july), /safe integer/);
});
