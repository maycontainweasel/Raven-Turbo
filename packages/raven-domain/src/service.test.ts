import assert from "node:assert/strict";
import test from "node:test";
import type {
  AccountRecord,
  AccountTransferRecord,
  BalanceSnapshotRecord,
  CategoryRecord,
  ClarificationSummary,
  CreateAccountInput,
  FinancialOperationRecord,
  FinancialSpaceRecord,
  TransactionRecord,
} from "./contracts.js";
import { RavenDomainError } from "./errors.js";
import { money } from "./money.js";
import type {
  AccountControlRepository,
  BalanceSnapshotDraft,
  OperationDraft,
  TransactionDraft,
  TransactionReadFilter,
  TransferDraft,
} from "./repository.js";
import { AccountControlService } from "./service.js";

const NOW = "2026-07-11T10:00:00.000Z";

class MemoryRepository implements AccountControlRepository {
  readonly spaces: FinancialSpaceRecord[] = [
    {
      id: "financialSpace:test-personal",
      key: "test-personal",
      name: "Fictional Personal",
      spaceType: "personal",
      currency: "ZAR",
    },
    {
      id: "financialSpace:test-business",
      key: "test-business",
      name: "Fictional Business",
      spaceType: "business",
      currency: "ZAR",
    },
  ];

  readonly accounts: AccountRecord[] = [];
  readonly snapshots: BalanceSnapshotRecord[] = [];
  readonly operations: FinancialOperationRecord[] = [];
  readonly transactions: TransactionRecord[] = [];
  readonly categories: CategoryRecord[] = [];
  readonly transfers: AccountTransferRecord[] = [];
  readonly clarifications: ClarificationSummary[] = [];
  transactionQueries = 0;

  async listSpaces(spaceKeys?: string[]) {
    return spaceKeys?.length
      ? this.spaces.filter((space) => spaceKeys.includes(space.key))
      : this.spaces;
  }

  async listAccounts(spaceKeys?: string[]) {
    if (spaceKeys !== undefined && spaceKeys.length === 0) return [];
    return spaceKeys?.length
      ? this.accounts.filter((account) => spaceKeys.includes(account.spaceKey))
      : this.accounts;
  }

  async getAccount(spaceKey: string, accountKey: string) {
    return (
      this.accounts.find(
        (account) =>
          account.spaceKey === spaceKey && account.key === accountKey,
      ) ?? null
    );
  }

  async listBalanceSnapshots(accountIds: string[]) {
    return this.snapshots.filter((snapshot) =>
      accountIds.includes(snapshot.accountId),
    );
  }

  async getBalanceSnapshot(id: string) {
    return this.snapshots.find((snapshot) => snapshot.id === id) ?? null;
  }

  async listTransactions(filter: TransactionReadFilter = {}) {
    if (filter.accountIds !== undefined && filter.accountIds.length === 0)
      return [];
    this.transactionQueries += 1;
    return this.transactions.filter(
      (transaction) =>
        (filter.accountIds === undefined ||
          filter.accountIds.includes(transaction.accountId)) &&
        (!filter.month || transaction.postedAt?.startsWith(filter.month)) &&
        ((transaction.ledgerAuthority ?? "active") === "active" ||
          (filter.includeLegacyUnreconciled === true &&
            transaction.ledgerAuthority === "legacy_unreconciled")),
    );
  }

  async getTransaction(id: string) {
    return (
      this.transactions.find((transaction) => transaction.id === id) ?? null
    );
  }

  async listCategories(spaceKey: string) {
    return this.categories.filter((category) => category.spaceKey === spaceKey);
  }

  async getCategory(spaceKey: string, categoryKey: string) {
    return (
      this.categories.find(
        (category) =>
          category.spaceKey === spaceKey && category.key === categoryKey,
      ) ?? null
    );
  }

  async getOperationById(id: string) {
    return this.operations.find((operation) => operation.id === id) ?? null;
  }

  async getTransfer(id: string) {
    return this.transfers.find((transfer) => transfer.id === id) ?? null;
  }

  async listClarifications() {
    return this.clarifications;
  }

  async getOperation(
    command: FinancialOperationRecord["command"],
    idempotencyKey: string,
  ) {
    return (
      this.operations.find(
        (operation) =>
          operation.command === command &&
          operation.idempotencyKey === idempotencyKey,
      ) ?? null
    );
  }

  private operation(
    draft: OperationDraft,
    resultRefs: string[],
  ): FinancialOperationRecord {
    const operation: FinancialOperationRecord = {
      id: `financialOperation:${draft.key}`,
      ...draft,
      actorId: draft.actorId ?? null,
      status: "applied",
      resultRefs,
      warningCodes: [],
      auditMeta: draft.auditMeta ?? {},
      completedAt: draft.recordedAt,
      failureCode: null,
    };
    this.operations.push(operation);
    return operation;
  }

  async createAccountWithOperation(
    input: CreateAccountInput,
    draft: OperationDraft,
  ) {
    const account: AccountRecord = {
      id: `account:financialSpace:${input.spaceKey}|${input.accountKey}`,
      spaceId: `financialSpace:${input.spaceKey}`,
      spaceKey: input.spaceKey,
      key: input.accountKey,
      name: input.name,
      bankName: input.bankName ?? "",
      accountType: input.accountType,
      currency: input.currency,
      normalNature: input.normalNature,
      liquidityClass: input.liquidityClass,
      freshnessWindowHours: input.freshnessWindowHours,
      active: true,
    };
    this.accounts.push(account);
    return { account, operation: this.operation(draft, [account.id]) };
  }

  async confirmBalanceWithOperation(
    snapshotDraft: BalanceSnapshotDraft,
    draft: OperationDraft,
  ) {
    const snapshot: BalanceSnapshotRecord = {
      ...snapshotDraft,
      id: `accountBalanceSnapshot:${snapshotDraft.key}`,
    };
    this.snapshots.push(snapshot);
    return { snapshot, operation: this.operation(draft, [snapshot.id]) };
  }

  async recordTransactionWithOperation(
    transactionDraft: TransactionDraft,
    draft: OperationDraft,
  ) {
    const category = this.categories.find(
      (candidate) => candidate.id === transactionDraft.categoryId,
    );
    const accountRecord = this.accounts.find(
      (candidate) => candidate.id === transactionDraft.accountId,
    )!;
    const transaction: TransactionRecord = {
      id: `transaction:${transactionDraft.key}`,
      key: transactionDraft.key,
      spaceId: transactionDraft.spaceId,
      spaceKey: transactionDraft.spaceKey,
      accountId: transactionDraft.accountId,
      accountKey: transactionDraft.accountKey,
      postedAt: transactionDraft.postedAt,
      recordedAt: transactionDraft.recordedAt,
      description: transactionDraft.description,
      amountMinor: transactionDraft.amountMinor,
      currency: transactionDraft.currency,
      kind: transactionDraft.kind,
      flowDirection: transactionDraft.flowDirection,
      entrySource: "manual",
      status: "clarified",
      categoryId: category?.id ?? null,
      categoryKey: category?.key ?? null,
      categoryName: category?.name ?? null,
      categoryKind: category?.kind ?? null,
      operationId: transactionDraft.operationId,
      warnings: [],
    };
    const operation = this.operation(draft, [transaction.id]);
    this.transactions.push(transaction);
    return { transaction, operation };
  }

  async recordTransferWithOperation(
    transferDraft: TransferDraft,
    draft: OperationDraft,
  ) {
    const transferId = `accountTransfer:${transferDraft.key}`;
    const operation = this.operation(draft, [
      transferId,
      `transaction:${transferDraft.sourceTransactionKey}`,
      `transaction:${transferDraft.targetTransactionKey}`,
    ]);
    const sourceTransaction: TransactionRecord = {
      id: `transaction:${transferDraft.sourceTransactionKey}`,
      key: transferDraft.sourceTransactionKey,
      spaceId: transferDraft.sourceAccount.spaceId,
      spaceKey: transferDraft.sourceAccount.spaceKey,
      accountId: transferDraft.sourceAccount.id,
      accountKey: transferDraft.sourceAccount.key,
      postedAt: transferDraft.postedAt,
      recordedAt: transferDraft.recordedAt,
      description: transferDraft.description ?? "Transfer",
      amountMinor: transferDraft.amountMinor,
      currency: transferDraft.currency,
      kind: "transfer",
      flowDirection: "outflow",
      entrySource: "manual",
      status: "clarified",
      transferId,
      operationId: transferDraft.operationId,
      warnings: [],
    };
    const targetTransaction: TransactionRecord = {
      ...sourceTransaction,
      id: `transaction:${transferDraft.targetTransactionKey}`,
      key: transferDraft.targetTransactionKey,
      spaceId: transferDraft.targetAccount.spaceId,
      spaceKey: transferDraft.targetAccount.spaceKey,
      accountId: transferDraft.targetAccount.id,
      accountKey: transferDraft.targetAccount.key,
      flowDirection: "inflow",
    };
    const transfer: AccountTransferRecord = {
      id: transferId,
      key: transferDraft.key,
      source: {
        spaceKey: transferDraft.sourceAccount.spaceKey,
        accountKey: transferDraft.sourceAccount.key,
        accountId: transferDraft.sourceAccount.id,
      },
      target: {
        spaceKey: transferDraft.targetAccount.spaceKey,
        accountKey: transferDraft.targetAccount.key,
        accountId: transferDraft.targetAccount.id,
      },
      amountMinor: transferDraft.amountMinor,
      currency: transferDraft.currency,
      postedAt: transferDraft.postedAt,
      description: transferDraft.description ?? null,
      sourceTransactionId: sourceTransaction.id,
      targetTransactionId: targetTransaction.id,
      operationId: transferDraft.operationId,
      recordedAt: transferDraft.recordedAt,
    };
    this.transactions.push(sourceTransaction, targetTransaction);
    this.transfers.push(transfer);
    return { transfer, sourceTransaction, targetTransaction, operation };
  }
}

class RacingMemoryRepository extends MemoryRepository {
  private transactionWriteCount = 0;
  private transferWriteCount = 0;
  private releaseSecondTransaction!: () => void;
  private releaseCommittedTransaction!: () => void;
  private releaseSecondTransfer!: () => void;
  private releaseCommittedTransfer!: () => void;
  private readonly secondTransaction = new Promise<void>((resolve) => {
    this.releaseSecondTransaction = resolve;
  });
  private readonly committedTransaction = new Promise<void>((resolve) => {
    this.releaseCommittedTransaction = resolve;
  });
  private readonly secondTransfer = new Promise<void>((resolve) => {
    this.releaseSecondTransfer = resolve;
  });
  private readonly committedTransfer = new Promise<void>((resolve) => {
    this.releaseCommittedTransfer = resolve;
  });

  override async recordTransactionWithOperation(
    transactionDraft: TransactionDraft,
    draft: OperationDraft,
  ) {
    this.transactionWriteCount += 1;
    if (this.transactionWriteCount === 1) {
      await this.secondTransaction;
      const result = await super.recordTransactionWithOperation(
        transactionDraft,
        draft,
      );
      this.releaseCommittedTransaction();
      return result;
    }
    this.releaseSecondTransaction();
    await this.committedTransaction;
    throw new Error("duplicate record already exists");
  }

  override async recordTransferWithOperation(
    transferDraft: TransferDraft,
    draft: OperationDraft,
  ) {
    this.transferWriteCount += 1;
    if (this.transferWriteCount === 1) {
      await this.secondTransfer;
      const result = await super.recordTransferWithOperation(
        transferDraft,
        draft,
      );
      this.releaseCommittedTransfer();
      return result;
    }
    this.releaseSecondTransfer();
    await this.committedTransfer;
    throw new Error("CREATE ONLY duplicate record exists");
  }
}

function account(overrides: Partial<AccountRecord>): AccountRecord {
  const key = overrides.key ?? "daily";
  return {
    id: `account:${key}`,
    spaceId: "financialSpace:test-personal",
    spaceKey: "test-personal",
    key,
    name: `Fictional ${key}`,
    bankName: "Example Bank",
    accountType: "current",
    currency: "ZAR",
    normalNature: "asset",
    liquidityClass: "liquid",
    freshnessWindowHours: 72,
    active: true,
    ...overrides,
  };
}

function snapshot(
  accountRecord: AccountRecord,
  overrides: Partial<BalanceSnapshotRecord>,
): BalanceSnapshotRecord {
  const key = overrides.key ?? accountRecord.key;
  return {
    id: `accountBalanceSnapshot:${key}`,
    key,
    spaceId: accountRecord.spaceId,
    accountId: accountRecord.id,
    balanceKind:
      accountRecord.normalNature === "liability" ? "outstanding" : "ledger",
    amountMinor: 0,
    currency: accountRecord.currency,
    economicNature: accountRecord.normalNature,
    asOf: NOW,
    recordedAt: NOW,
    evidenceLevel: "confirmed",
    sourceKind: "manual_confirmation",
    ...overrides,
  };
}

function category(overrides: Partial<CategoryRecord>): CategoryRecord {
  const key = overrides.key ?? "groceries";
  return {
    id: `category:${key}`,
    spaceId: "financialSpace:test-personal",
    spaceKey: "test-personal",
    key,
    name: `Fictional ${key}`,
    kind: "expense",
    active: true,
    ...overrides,
  };
}

function transaction(
  accountRecord: AccountRecord,
  overrides: Partial<TransactionRecord>,
): TransactionRecord {
  const key = overrides.key ?? `${accountRecord.key}-transaction`;
  return {
    id: `transaction:${key}`,
    key,
    spaceId: accountRecord.spaceId,
    spaceKey: accountRecord.spaceKey,
    accountId: accountRecord.id,
    accountKey: accountRecord.key,
    postedAt: "2026-07-10",
    recordedAt: NOW,
    description: `Fictional ${key}`,
    amountMinor: 1_000,
    currency: accountRecord.currency,
    kind: "expense",
    flowDirection: "outflow",
    entrySource: "manual",
    warnings: [],
    ...overrides,
    status: overrides.status ?? "clarified",
  };
}

test("create account replays an identical idempotent command and rejects changed input", async () => {
  const repository = new MemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  const input: CreateAccountInput = {
    idempotencyKey: "test-create-daily-001",
    channel: "ui",
    spaceKey: "test-personal",
    accountKey: "daily",
    name: "Fictional Daily",
    bankName: "Example Bank",
    accountType: "current",
    currency: "ZAR",
    normalNature: "asset",
    liquidityClass: "liquid",
    freshnessWindowHours: 72,
  };

  const first = await service.createAccount(input);
  const replay = await service.createAccount(input);

  assert.equal(first.receipt.status, "applied");
  assert.equal(replay.receipt.status, "replayed");
  assert.equal(first.receipt.operationId, replay.receipt.operationId);
  assert.equal(repository.accounts.length, 1);
  assert.equal(repository.operations.length, 1);

  await assert.rejects(
    service.createAccount({ ...input, name: "Changed Name" }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "IDEMPOTENCY_CONFLICT",
  );
  await assert.rejects(
    service.createAccount({
      ...input,
      idempotencyKey: "test-create-daily-002",
    }),
    (error: unknown) =>
      error instanceof RavenDomainError && error.code === "ALREADY_EXISTS",
  );
});

test("equivalent account names and keys are valid in different financial spaces", async () => {
  const repository = new MemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  const shared = {
    channel: "ui" as const,
    accountKey: "current-account",
    name: "Current Account",
    bankName: "Example Bank",
    accountType: "current",
    currency: "ZAR",
    normalNature: "asset" as const,
    liquidityClass: "liquid" as const,
    freshnessWindowHours: 72,
  };

  const personal = await service.createAccount({
    ...shared,
    idempotencyKey: "test-personal-current-001",
    spaceKey: "test-personal",
  });
  const business = await service.createAccount({
    ...shared,
    idempotencyKey: "test-business-current-001",
    spaceKey: "test-business",
  });

  assert.notEqual(personal.entity.id, business.entity.id);
  assert.equal(personal.entity.accountKey, business.entity.accountKey);
  assert.equal(repository.accounts.length, 2);
});

test("current position reports known totals while an unknown liquid balance blocks liquid cash", async () => {
  const repository = new MemoryRepository();
  const daily = account({ key: "daily" });
  const missing = account({ key: "missing-liquid" });
  const investment = account({
    key: "investment",
    accountType: "investment",
    liquidityClass: "non_liquid",
  });
  const debt = account({
    key: "debt",
    accountType: "loan",
    normalNature: "liability",
    liquidityClass: "non_liquid",
  });
  repository.accounts.push(daily, missing, investment, debt);
  repository.snapshots.push(
    snapshot(daily, { key: "daily-fresh", amountMinor: 10_000 }),
    snapshot(investment, {
      key: "investment-stale",
      balanceKind: "market_value",
      amountMinor: 25_000,
      asOf: "2026-06-01T10:00:00.000Z",
    }),
    snapshot(debt, { key: "debt-fresh", amountMinor: 4_000 }),
    snapshot(daily, {
      key: "daily-informational",
      balanceKind: "available",
      amountMinor: 999_999,
      economicNature: "informational",
    }),
  );

  const result = await new AccountControlService(
    repository,
    () => new Date(NOW),
  ).getCurrentPosition({
    currency: "ZAR",
    asOf: NOW,
  });

  assert.equal(result.liquidCash, null);
  assert.deepEqual(
    result.knownAssets,
    money({ currency: "ZAR", minorUnits: 35_000 }),
  );
  assert.deepEqual(
    result.knownLiabilities,
    money({ currency: "ZAR", minorUnits: 4_000 }),
  );
  assert.deepEqual(
    result.knownNetPosition,
    money({ currency: "ZAR", minorUnits: 31_000 }),
  );
  assert.deepEqual(result.missingAccountIds, [missing.id]);
  assert.deepEqual(result.staleAccountIds, [investment.id]);
  assert.equal(result.meta.quality, "unavailable");
  assert.deepEqual(result.meta.warnings.sort(), [
    "BALANCE_STALE",
    "BALANCE_UNKNOWN",
    "PARTIAL_POSITION",
  ]);
});

test("invalid-future balance evidence is excluded and exposed across account queries and position metadata", async () => {
  const repository = new MemoryRepository();
  const futureOnly = account({ key: "future-only" });
  repository.accounts.push(futureOnly);
  repository.snapshots.push(
    snapshot(futureOnly, {
      key: "future-only-balance",
      amountMinor: 99_999,
      asOf: "2026-07-12T10:00:00.000Z",
    }),
  );
  const service = new AccountControlService(repository, () => new Date(NOW));

  const [listed, detail, freshness, position] = await Promise.all([
    service.listAccounts({ asOf: NOW }),
    service.getAccount({
      spaceKey: futureOnly.spaceKey,
      accountKey: futureOnly.key,
      asOf: NOW,
    }),
    service.getAccountFreshness({ accountKeys: [futureOnly.key], asOf: NOW }),
    service.getCurrentPosition({ currency: "ZAR", asOf: NOW }),
  ]);

  const listedAccount = listed.spaces.flatMap((space) => space.accounts)[0];
  assert.equal(listedAccount?.selectedBalance, null);
  assert.equal(listedAccount?.freshness.state, "invalid_future");
  assert.equal(listedAccount?.freshness.asOf, "2026-07-12T10:00:00.000Z");
  assert.equal(detail.account.freshness.state, "invalid_future");
  assert.equal(freshness.accounts[0]?.freshness.state, "invalid_future");
  for (const result of [listed, detail, freshness]) {
    assert.equal(result.meta.quality, "partial");
    assert.deepEqual(result.meta.warnings.sort(), [
      "BALANCE_INVALID_FUTURE",
      "PARTIAL_POSITION",
    ]);
  }

  assert.equal(position.liquidCash, null);
  assert.deepEqual(
    position.knownAssets,
    money({ currency: "ZAR", minorUnits: 0 }),
  );
  assert.deepEqual(
    position.knownLiabilities,
    money({ currency: "ZAR", minorUnits: 0 }),
  );
  assert.deepEqual(
    position.knownNetPosition,
    money({ currency: "ZAR", minorUnits: 0 }),
  );
  assert.deepEqual(position.missingAccountIds, []);
  assert.deepEqual(position.invalidFutureAccountIds, [futureOnly.id]);
  assert.deepEqual(position.staleAccountIds, []);
  assert.equal(position.meta.quality, "unavailable");
  assert.deepEqual(position.meta.warnings.sort(), [
    "BALANCE_INVALID_FUTURE",
    "PARTIAL_POSITION",
  ]);
});

test("confirmed balance is append-only and replays without creating a duplicate snapshot", async () => {
  const repository = new MemoryRepository();
  repository.accounts.push(account({ key: "daily" }));
  const service = new AccountControlService(repository, () => new Date(NOW));
  const input = {
    idempotencyKey: "test-confirm-balance-001",
    channel: "mcp" as const,
    spaceKey: "test-personal",
    accountKey: "daily",
    balanceKind: "available" as const,
    money: money({ currency: "ZAR", minorUnits: 12_345 }),
    economicNature: "asset" as const,
    asOf: NOW,
    note: "Fictional reconciliation note",
  };

  const first = await service.confirmAccountBalance(input);
  const replay = await service.confirmAccountBalance(input);

  assert.equal(first.receipt.status, "applied");
  assert.equal(replay.receipt.status, "replayed");
  assert.equal(first.entity.snapshotId, replay.entity.snapshotId);
  assert.equal(first.entity.note, "Fictional reconciliation note");
  assert.equal(replay.entity.note, "Fictional reconciliation note");
  assert.equal(repository.snapshots.length, 1);
  assert.equal(repository.snapshots[0]?.notes, "Fictional reconciliation note");
  assert.equal(repository.operations.length, 1);
});

test("expense and income commands create exact positive movement without changing balance truth", async () => {
  const repository = new MemoryRepository();
  const daily = account({ key: "movement-daily" });
  repository.accounts.push(daily);
  repository.categories.push(
    category({ key: "groceries" }),
    category({ key: "salary", kind: "income" }),
  );
  const service = new AccountControlService(repository, () => new Date(NOW));
  const expenseInput = {
    idempotencyKey: "fictional-expense-001",
    channel: "ui" as const,
    spaceKey: daily.spaceKey,
    accountKey: daily.key,
    money: money({ currency: "ZAR", minorUnits: 1_250 }),
    postedAt: "2026-07-10",
    description: "Fictional groceries",
    categoryKey: "groceries",
  };
  const incomeInput = {
    ...expenseInput,
    idempotencyKey: "fictional-income-001",
    channel: "mcp" as const,
    money: money({ currency: "ZAR", minorUnits: 8_000 }),
    description: "Fictional income",
    categoryKey: "salary",
  };

  const expense = await service.recordExpense(expenseInput);
  const expenseReplay = await service.recordExpense(expenseInput);
  const income = await service.recordIncome(incomeInput);

  assert.equal(expense.entity.kind, "expense");
  assert.equal(expense.entity.flowDirection, "outflow");
  assert.equal(expense.entity.amount?.minorUnits, 1_250);
  assert.equal(expenseReplay.receipt.status, "replayed");
  assert.equal(expenseReplay.entity.id, expense.entity.id);
  assert.equal(income.entity.kind, "income");
  assert.equal(income.entity.flowDirection, "inflow");
  assert.equal(income.entity.amount?.minorUnits, 8_000);
  assert.equal(repository.snapshots.length, 0);
  assert.equal(repository.transactions.length, 2);
  await assert.rejects(
    service.recordExpense({
      ...expenseInput,
      description: "Changed fictional expense",
    }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "IDEMPOTENCY_CONFLICT",
  );
});

test("manual movements resolve repeated category keys within the account financial space", async () => {
  const repository = new MemoryRepository();
  const personal = account({ key: "category-personal" });
  const business = account({
    id: "account:category-business",
    spaceId: "financialSpace:test-business",
    spaceKey: "test-business",
    key: "category-business",
  });
  const personalFees = category({
    id: "category:financialSpace:test-personal|fees",
    key: "fees",
    name: "Personal fees",
  });
  const businessFees = category({
    id: "category:financialSpace:test-business|fees",
    spaceId: "financialSpace:test-business",
    spaceKey: "test-business",
    key: "fees",
    name: "Business fees",
  });
  repository.accounts.push(personal, business);
  repository.categories.push(personalFees, businessFees);
  const service = new AccountControlService(repository, () => new Date(NOW));

  const personalExpense = await service.recordExpense({
    idempotencyKey: "fictional-personal-fee-001",
    channel: "ui",
    spaceKey: personal.spaceKey,
    accountKey: personal.key,
    money: money({ currency: "ZAR", minorUnits: 125 }),
    postedAt: "2026-07-10",
    description: "Fictional personal fee",
    categoryKey: "fees",
  });
  const businessExpense = await service.recordExpense({
    idempotencyKey: "fictional-business-fee-001",
    channel: "mcp",
    spaceKey: business.spaceKey,
    accountKey: business.key,
    money: money({ currency: "ZAR", minorUnits: 250 }),
    postedAt: "2026-07-10",
    description: "Fictional business fee",
    categoryKey: "fees",
  });

  assert.equal(personalExpense.entity.category?.name, personalFees.name);
  assert.equal(businessExpense.entity.category?.name, businessFees.name);
  assert.equal(
    repository.transactions.find((item) => item.accountId === personal.id)
      ?.categoryId,
    personalFees.id,
  );
  assert.equal(
    repository.transactions.find((item) => item.accountId === business.id)
      ?.categoryId,
    businessFees.id,
  );
});

test("movement validation rejects invalid money, dates, currencies, and categories predictably", async () => {
  const repository = new MemoryRepository();
  const daily = account({ key: "validation-daily" });
  repository.accounts.push(daily);
  repository.categories.push(
    category({ key: "income-only", kind: "income" }),
    category({ key: "legacy-tax", kind: "tax" }),
  );
  const service = new AccountControlService(repository, () => new Date(NOW));
  const base = {
    idempotencyKey: "fictional-validation-001",
    channel: "ui" as const,
    spaceKey: daily.spaceKey,
    accountKey: daily.key,
    money: { currency: "ZAR", minorUnits: 100 },
    postedAt: "2026-07-10",
    description: "Fictional validation",
  };

  await assert.rejects(
    service.recordExpense({
      ...base,
      money: { currency: "ZAR", minorUnits: 0 },
    }),
  );
  await assert.rejects(
    service.recordExpense({
      ...base,
      money: { currency: "ZAR", minorUnits: -1 },
    }),
  );
  await assert.rejects(
    service.recordExpense({
      ...base,
      money: { currency: "ZAR", minorUnits: Number.MAX_VALUE },
    }),
  );
  await assert.rejects(
    service.recordExpense({
      ...base,
      money: { currency: "USD", minorUnits: 100 },
    }),
  );
  await assert.rejects(
    service.recordExpense({ ...base, postedAt: "2026-02-30" }),
  );
  await assert.rejects(
    service.recordExpense({ ...base, categoryKey: "income-only" }),
  );
  await assert.rejects(
    service.recordExpense({ ...base, categoryKey: "legacy-tax" }),
    (error: unknown) =>
      error instanceof RavenDomainError && error.code === "INVALID_CATEGORY",
  );
  assert.equal(repository.transactions.length, 0);
  assert.equal(repository.operations.length, 0);
});

test("transfer creates one aggregate and opposite linked legs atomically with stable replay", async () => {
  const repository = new MemoryRepository();
  const source = account({ key: "transfer-source" });
  const target = account({ key: "transfer-target" });
  const foreign = account({ key: "transfer-foreign", currency: "USD" });
  repository.accounts.push(source, target, foreign);
  const service = new AccountControlService(repository, () => new Date(NOW));
  const input = {
    idempotencyKey: "fictional-transfer-001",
    channel: "ui" as const,
    source: { spaceKey: source.spaceKey, accountKey: source.key },
    target: { spaceKey: target.spaceKey, accountKey: target.key },
    money: money({ currency: "ZAR", minorUnits: 3_500 }),
    postedAt: "2026-07-09",
    description: "Fictional tracked transfer",
  };

  const applied = await service.recordTransfer(input);
  const replay = await service.recordTransfer(input);
  assert.equal(applied.sourceTransaction.kind, "transfer");
  assert.equal(applied.sourceTransaction.flowDirection, "outflow");
  assert.equal(applied.targetTransaction.flowDirection, "inflow");
  assert.equal(applied.sourceTransaction.transferId, applied.transfer.id);
  assert.equal(applied.targetTransaction.transferId, applied.transfer.id);
  assert.equal(replay.receipt.status, "replayed");
  assert.equal(replay.transfer.id, applied.transfer.id);
  assert.equal(repository.transfers.length, 1);
  assert.equal(repository.transactions.length, 2);

  await assert.rejects(
    service.recordTransfer({
      ...input,
      idempotencyKey: "fictional-transfer-same",
      target: input.source,
    }),
    (error: unknown) =>
      error instanceof RavenDomainError && error.code === "DUPLICATE_TRANSFER",
  );
  await assert.rejects(
    service.recordTransfer({
      ...input,
      idempotencyKey: "fictional-transfer-foreign",
      target: { spaceKey: foreign.spaceKey, accountKey: foreign.key },
    }),
    (error: unknown) =>
      error instanceof RavenDomainError && error.code === "CURRENCY_MISMATCH",
  );
  await assert.rejects(
    service.recordTransfer({
      ...input,
      description: "Changed transfer request",
    }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "IDEMPOTENCY_CONFLICT",
  );
  assert.equal(repository.transfers.length, 1);
  assert.equal(repository.transactions.length, 2);
});

test("concurrent first movement and transfer commands resolve as applied plus stable replay", async () => {
  const repository = new RacingMemoryRepository();
  const source = account({ key: "race-source" });
  const target = account({ key: "race-target" });
  repository.accounts.push(source, target);
  const service = new AccountControlService(repository, () => new Date(NOW));
  const expenseInput = {
    idempotencyKey: "fictional-race-expense-001",
    channel: "ui" as const,
    spaceKey: source.spaceKey,
    accountKey: source.key,
    money: money({ currency: "ZAR", minorUnits: 750 }),
    postedAt: "2026-07-10",
    description: "Fictional concurrent expense",
  };
  const expenses = await Promise.all([
    service.recordExpense(expenseInput),
    service.recordExpense(expenseInput),
  ]);
  assert.deepEqual(expenses.map((result) => result.receipt.status).sort(), [
    "applied",
    "replayed",
  ]);
  assert.equal(new Set(expenses.map((result) => result.entity.id)).size, 1);
  assert.equal(repository.transactions.length, 1);

  const transferInput = {
    idempotencyKey: "fictional-race-transfer-001",
    channel: "mcp" as const,
    source: { spaceKey: source.spaceKey, accountKey: source.key },
    target: { spaceKey: target.spaceKey, accountKey: target.key },
    money: money({ currency: "ZAR", minorUnits: 500 }),
    postedAt: "2026-07-10",
    description: "Fictional concurrent transfer",
  };
  const transfers = await Promise.all([
    service.recordTransfer(transferInput),
    service.recordTransfer(transferInput),
  ]);
  assert.deepEqual(transfers.map((result) => result.receipt.status).sort(), [
    "applied",
    "replayed",
  ]);
  assert.equal(new Set(transfers.map((result) => result.transfer.id)).size, 1);
  assert.equal(repository.transfers.length, 1);
  assert.equal(repository.transactions.length, 3);
});

test("concurrent changed movement commands resolve as one write plus idempotency conflict", async () => {
  const repository = new RacingMemoryRepository();
  const daily = account({ key: "race-conflict" });
  repository.accounts.push(daily);
  const service = new AccountControlService(repository, () => new Date(NOW));
  const input = {
    idempotencyKey: "fictional-race-conflict-001",
    channel: "ui" as const,
    spaceKey: daily.spaceKey,
    accountKey: daily.key,
    money: money({ currency: "ZAR", minorUnits: 750 }),
    postedAt: "2026-07-10",
    description: "Fictional first request",
  };

  const results = await Promise.allSettled([
    service.recordExpense(input),
    service.recordExpense({
      ...input,
      description: "Fictional changed request",
    }),
  ]);
  const fulfilled = results.filter((result) => result.status === "fulfilled");
  const rejected = results.filter((result) => result.status === "rejected");

  assert.equal(fulfilled.length, 1);
  assert.equal(rejected.length, 1);
  assert.equal(
    fulfilled[0]?.status === "fulfilled" && fulfilled[0].value.receipt.status,
    "applied",
  );
  assert.equal(
    rejected[0]?.status === "rejected" &&
      rejected[0].reason instanceof RavenDomainError &&
      rejected[0].reason.code,
    "IDEMPOTENCY_CONFLICT",
  );
  assert.equal(repository.transactions.length, 1);
  assert.equal(repository.operations.length, 1);
});

test("month progress excludes canonical and ambiguous legacy transfers from exact totals", async () => {
  const repository = new MemoryRepository();
  const daily = account({ key: "progress-daily" });
  repository.accounts.push(daily);
  repository.transactions.push(
    transaction(daily, {
      key: "income",
      kind: "income",
      flowDirection: "inflow",
      amountMinor: 10_000,
    }),
    transaction(daily, { key: "expense", amountMinor: 2_500 }),
    transaction(daily, {
      key: "transfer-out",
      kind: "transfer",
      flowDirection: "outflow",
      amountMinor: 7_000,
    }),
    transaction(daily, {
      key: "transfer-in",
      kind: "transfer",
      flowDirection: "inflow",
      amountMinor: 7_000,
    }),
    transaction(daily, {
      key: "legacy-transfer",
      kind: "transfer",
      flowDirection: null,
      amountMinor: 9_000,
      warnings: ["LEGACY_TRANSFER_AMBIGUOUS"],
    }),
  );
  const result = await new AccountControlService(
    repository,
    () => new Date(NOW),
  ).getMonthProgress({
    month: "2026-07",
    currency: "ZAR",
    accountRefs: [{ spaceKey: daily.spaceKey, accountKey: daily.key }],
    asOf: NOW,
  });

  assert.equal(result.income.minorUnits, 10_000);
  assert.equal(result.outflow.minorUnits, 2_500);
  assert.equal(result.net.minorUnits, 7_500);
  assert.equal(result.counts.transfer, 3);
  assert.equal(result.meta.quality, "partial");
  assert.deepEqual(result.meta.warnings, ["LEGACY_TRANSFER_AMBIGUOUS"]);
});

test("month progress keeps explicit empty and mismatched account scopes isolated", async () => {
  const repository = new MemoryRepository();
  const zar = account({ key: "scope-zar" });
  const usd = account({ key: "scope-usd", currency: "USD" });
  repository.accounts.push(zar, usd);
  repository.transactions.push(
    transaction(zar, {
      key: "scope-income",
      kind: "income",
      flowDirection: "inflow",
      amountMinor: 5_000,
    }),
    transaction(usd, {
      key: "scope-usd-income",
      kind: "income",
      flowDirection: "inflow",
      amountMinor: 9_000,
      currency: "USD",
    }),
  );
  const service = new AccountControlService(repository, () => new Date(NOW));

  const emptyRefs = await service.getMonthProgress({
    month: "2026-07",
    currency: "ZAR",
    accountRefs: [],
    asOf: NOW,
  });
  const emptySpaces = await service.getMonthProgress({
    month: "2026-07",
    currency: "ZAR",
    spaceKeys: [],
    asOf: NOW,
  });
  const unmatchedSpace = await service.getMonthProgress({
    month: "2026-07",
    currency: "ZAR",
    spaceKeys: ["missing-space"],
    asOf: NOW,
  });
  assert.equal(emptyRefs.income.minorUnits, 0);
  assert.equal(emptySpaces.income.minorUnits, 0);
  assert.equal(unmatchedSpace.income.minorUnits, 0);
  assert.equal(repository.transactionQueries, 0);

  await assert.rejects(
    service.getMonthProgress({
      month: "2026-07",
      currency: "ZAR",
      accountRefs: [{ spaceKey: usd.spaceKey, accountKey: usd.key }],
      asOf: NOW,
    }),
    (error: unknown) =>
      error instanceof RavenDomainError && error.code === "CURRENCY_MISMATCH",
  );
  assert.equal(repository.transactionQueries, 0);

  const unscoped = await service.getMonthProgress({
    month: "2026-07",
    currency: "ZAR",
    asOf: NOW,
  });
  assert.equal(unscoped.income.minorUnits, 5_000);
  assert.equal(repository.transactionQueries, 1);
});

test("month progress uses Johannesburg financial dates and excludes ignored, unresolved, and future facts", async () => {
  const repository = new MemoryRepository();
  const daily = account({ key: "cutoff-daily" });
  repository.accounts.push(daily);
  repository.transactions.push(
    transaction(daily, {
      key: "july-10",
      postedAt: "2026-07-10",
      kind: "income",
      flowDirection: "inflow",
      amountMinor: 1_000,
    }),
    transaction(daily, {
      key: "july-11",
      postedAt: "2026-07-11",
      kind: "income",
      flowDirection: "inflow",
      amountMinor: 2_000,
    }),
    transaction(daily, {
      key: "ignored",
      postedAt: "2026-07-10",
      status: "ignored",
      amountMinor: 7_000,
      warnings: ["LEGACY_MONEY_FALLBACK"],
    }),
    transaction(daily, {
      key: "unresolved",
      postedAt: "2026-07-10",
      kind: "unresolved",
      flowDirection: null,
      warnings: ["TRANSACTION_SEMANTICS_UNRESOLVED"],
      amountMinor: 8_000,
    }),
    transaction(daily, {
      key: "past",
      postedAt: "2026-06-30",
      kind: "income",
      flowDirection: "inflow",
      amountMinor: 4_000,
    }),
    transaction(daily, {
      key: "future-month",
      postedAt: "2026-08-01",
      kind: "income",
      flowDirection: "inflow",
      amountMinor: 9_000,
    }),
  );
  const service = new AccountControlService(repository, () => new Date(NOW));
  const beforeMidnight = await service.getMonthProgress({
    month: "2026-07",
    currency: "ZAR",
    accountRefs: [{ spaceKey: daily.spaceKey, accountKey: daily.key }],
    asOf: "2026-07-10T21:59:59.000Z",
  });
  const afterMidnight = await service.getMonthProgress({
    month: "2026-07",
    currency: "ZAR",
    accountRefs: [{ spaceKey: daily.spaceKey, accountKey: daily.key }],
    asOf: "2026-07-10T22:00:00.000Z",
  });
  const past = await service.getMonthProgress({
    month: "2026-06",
    currency: "ZAR",
    accountRefs: [{ spaceKey: daily.spaceKey, accountKey: daily.key }],
    asOf: NOW,
  });
  const future = await service.getMonthProgress({
    month: "2026-08",
    currency: "ZAR",
    accountRefs: [{ spaceKey: daily.spaceKey, accountKey: daily.key }],
    asOf: NOW,
  });

  assert.equal(beforeMidnight.income.minorUnits, 1_000);
  assert.equal(beforeMidnight.outflow.minorUnits, 0);
  assert.equal(beforeMidnight.counts.expense, 0);
  assert.equal(beforeMidnight.counts.uncategorized, 1);
  assert.equal(beforeMidnight.meta.quality, "partial");
  assert.deepEqual(beforeMidnight.meta.warnings, [
    "TRANSACTION_SEMANTICS_UNRESOLVED",
  ]);
  assert.equal(afterMidnight.income.minorUnits, 3_000);
  assert.equal(past.income.minorUnits, 4_000);
  assert.equal(future.income.minorUnits, 0);
  assert.equal(future.outflow.minorUnits, 0);
});

test("whole-month warnings remain visible when an unresolved row is outside the current ledger page", async () => {
  const repository = new MemoryRepository();
  const daily = account({ key: "off-page-warning" });
  repository.accounts.push(daily);
  for (let day = 1; day <= 40; day += 1) {
    repository.transactions.push(
      transaction(daily, {
        key: `visible-${String(day).padStart(2, "0")}`,
        postedAt: `2026-07-${String(Math.min(day, 31)).padStart(2, "0")}`,
        recordedAt: `2026-07-11T${String(day % 24).padStart(2, "0")}:00:00.000Z`,
      }),
    );
  }
  repository.transactions.push(
    transaction(daily, {
      key: "off-page-unresolved",
      postedAt: "2026-07-01",
      recordedAt: "2026-07-01T00:00:00.000Z",
      kind: "unresolved",
      flowDirection: null,
      warnings: ["TRANSACTION_SEMANTICS_UNRESOLVED"],
    }),
  );
  const service = new AccountControlService(repository, () => new Date(NOW));

  const ledger = await service.listAccountTransactions({
    spaceKey: daily.spaceKey,
    accountKey: daily.key,
    month: "2026-07",
    limit: 40,
  });
  const progress = await service.getMonthProgress({
    month: "2026-07",
    currency: "ZAR",
    accountRefs: [{ spaceKey: daily.spaceKey, accountKey: daily.key }],
    asOf: NOW,
  });

  assert.equal(ledger.transactions.length, 40);
  assert.deepEqual(ledger.meta.warnings, []);
  assert.equal(progress.meta.quality, "partial");
  assert.deepEqual(progress.meta.warnings, [
    "TRANSACTION_SEMANTICS_UNRESOLVED",
  ]);
});

test("transaction months, filters, ordering, pagination, categories, and detail are deterministic", async () => {
  const repository = new MemoryRepository();
  const daily = account({ key: "ledger-daily" });
  repository.accounts.push(daily);
  const groceries = category({ key: "groceries" });
  repository.categories.push(groceries);
  repository.snapshots.push(
    snapshot(daily, {
      key: "ledger-daily-statement",
      asOf: "2026-05-31T21:59:59.999Z",
    }),
  );
  repository.transactions.push(
    transaction(daily, { key: "older", postedAt: "2026-06-01" }),
    transaction(daily, {
      key: "newer-b",
      postedAt: "2026-07-11",
      recordedAt: "2026-07-11T09:00:00.000Z",
      description: "Fictional market beta",
      categoryId: groceries.id,
      categoryKey: groceries.key,
      categoryName: groceries.name,
      categoryKind: groceries.kind,
    }),
    transaction(daily, {
      key: "newer-a",
      postedAt: "2026-07-11",
      recordedAt: "2026-07-11T08:00:00.000Z",
      description: "Fictional market alpha",
      categoryId: groceries.id,
      categoryKey: groceries.key,
      categoryName: groceries.name,
      categoryKind: groceries.kind,
    }),
  );
  const service = new AccountControlService(repository, () => new Date(NOW));
  const detail = await service.getAccount({
    spaceKey: daily.spaceKey,
    accountKey: daily.key,
    asOf: NOW,
  });
  const firstPage = await service.listAccountTransactions({
    spaceKey: daily.spaceKey,
    accountKey: daily.key,
    month: "2026-07",
    categoryKey: groceries.key,
    search: "market",
    limit: 1,
  });
  const secondPage = await service.listAccountTransactions({
    spaceKey: daily.spaceKey,
    accountKey: daily.key,
    month: "2026-07",
    cursor: firstPage.nextCursor ?? undefined,
    limit: 1,
  });
  const categories = await service.listCategories({
    spaceKey: daily.spaceKey,
    kinds: ["expense"],
  });
  const transactionDetail = await service.getTransaction({
    transactionId: "transaction:newer-b",
  });

  assert.deepEqual(detail.availableMonths, ["2026-07", "2026-06", "2026-05"]);
  assert.equal(firstPage.transactions[0]?.id, "transaction:newer-b");
  assert.equal(firstPage.nextCursor, "transaction:newer-b");
  assert.equal(secondPage.transactions[0]?.id, "transaction:newer-a");
  assert.deepEqual(
    categories.categories.map((item) => item.key),
    ["groceries"],
  );
  assert.equal(transactionDetail.transaction.id, "transaction:newer-b");
  assert.equal(transactionDetail.transaction.category?.key, "groceries");
});

test("account evidence reads can include legacy statement rows without changing the active-ledger default", async () => {
  const repository = new MemoryRepository();
  const daily = account({ key: "evidence-ledger" });
  repository.accounts.push(daily);
  repository.transactions.push(
    transaction(daily, {
      key: "legacy-source-row",
      postedAt: "2025-08-11",
      entrySource: "imported",
      sourceRowId: "statementRow:fictional-legacy-row",
      ledgerAuthority: "legacy_unreconciled",
      description: "Fictional raw statement description",
      kind: "expense",
      flowDirection: "outflow",
    }),
  );
  const service = new AccountControlService(repository, () => new Date(NOW));

  const accountDetail = await service.getAccount({
    spaceKey: daily.spaceKey,
    accountKey: daily.key,
  });
  const activeOnly = await service.listAccountTransactions({
    spaceKey: daily.spaceKey,
    accountKey: daily.key,
    month: "2025-08",
  });
  const evidenceLedger = await service.listAccountTransactions({
    spaceKey: daily.spaceKey,
    accountKey: daily.key,
    month: "2025-08",
    authorityScope: "active_ledger_with_legacy_unreconciled",
  });
  const strictProgress = await service.getMonthProgress({
    month: "2025-08",
    currency: "ZAR",
    accountRefs: [{ spaceKey: daily.spaceKey, accountKey: daily.key }],
    asOf: NOW,
  });
  const evidenceProgress = await service.getMonthProgress({
    month: "2025-08",
    currency: "ZAR",
    accountRefs: [{ spaceKey: daily.spaceKey, accountKey: daily.key }],
    authorityScope: "active_ledger_with_legacy_unreconciled",
    asOf: NOW,
  });

  assert.deepEqual(accountDetail.availableMonths, ["2025-08"]);
  assert.equal(activeOnly.transactions.length, 0);
  assert.equal(evidenceLedger.transactions.length, 1);
  assert.equal(
    evidenceLedger.transactions[0]?.description,
    "Fictional raw statement description",
  );
  assert.equal(
    evidenceLedger.transactions[0]?.ledgerAuthority,
    "legacy_unreconciled",
  );
  assert.equal(strictProgress.outflow.minorUnits, 0);
  assert.equal(evidenceProgress.outflow.minorUnits, 1_000);
});
