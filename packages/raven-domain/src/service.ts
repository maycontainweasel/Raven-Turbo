import { createHash } from "node:crypto";
import { RavenDomainError, type RavenWarningCode } from "./errors.js";
import {
  selectBalanceSnapshot,
  snapshotFreshness,
  toAccountSummary,
  toBalanceView,
} from "./balance.js";
import { toFacilitySnapshotView } from "./facility.js";
import { addMoney, money, subtractMoney, zeroMoney } from "./money.js";
import {
  normalizeFinancialDate,
  normalizeMonth,
  toCategoryView,
  toTransactionDetailView,
  toTransactionView,
  transactionFinancialDate,
  transactionWarnings,
} from "./transaction.js";
import type {
  AccountControlApi,
  AccountRecord,
  AccountRef,
  CategoryKind,
  CommandReceipt,
  CommandMeta,
  ConfirmAccountBalanceInput,
  ConfirmAccountBalanceOutput,
  CreateAccountInput,
  CreateAccountOutput,
  FinancialOperationRecord,
  GetAccountFreshnessInput,
  GetAccountFreshnessOutput,
  GetAccountInput,
  GetAccountOutput,
  GetMonthProgressInput,
  GetMonthProgressOutput,
  GetTransactionInput,
  GetTransactionOutput,
  GetCurrentPositionInput,
  GetCurrentPositionOutput,
  ListAccountsInput,
  ListAccountsOutput,
  ListAccountTransactionsInput,
  ListAccountTransactionsOutput,
  ListCategoriesInput,
  ListCategoriesOutput,
  RecordExpenseInput,
  RecordAccountFacilitySnapshotInput,
  RecordAccountFacilitySnapshotOutput,
  RecordIncomeInput,
  RecordTransactionInput,
  RecordTransactionOutput,
  RecordTransferInput,
  RecordTransferOutput,
  TransactionRecord,
} from "./contracts.js";
import type { AccountControlRepository, OperationDraft } from "./repository.js";
import { CashflowControlService } from "./cashflow-service.js";

type Clock = () => Date;
export type AccountControlServiceOptions = Readonly<{
  financialTimeZone?: string;
}>;
export const DEFAULT_FINANCIAL_TIME_ZONE = "Africa/Johannesburg";

function canonicalize(value: unknown): unknown {
  if (Array.isArray(value)) return value.map(canonicalize);
  if (value && typeof value === "object") {
    return Object.fromEntries(
      Object.entries(value as Record<string, unknown>)
        .sort(([left], [right]) => left.localeCompare(right))
        .map(([key, nested]) => [key, canonicalize(nested)]),
    );
  }
  return value;
}

function requestHash(input: unknown): string {
  return createHash("sha256")
    .update(JSON.stringify(canonicalize(input)))
    .digest("hex");
}

function operationKey(command: string, idempotencyKey: string): string {
  return createHash("sha256")
    .update(`${command}\u0000${idempotencyKey}`)
    .digest("hex");
}

function validateIdempotencyKey(value: string): string {
  const key = value.trim();
  if (key.length < 8 || key.length > 128) {
    throw new RavenDomainError(
      "IDEMPOTENCY_CONFLICT",
      "Idempotency key must contain 8 to 128 characters",
    );
  }
  return key;
}

function validateInstant(value: string, field: string): string {
  if (!Number.isFinite(Date.parse(value))) {
    throw new RavenDomainError(
      "INVALID_BALANCE_KIND",
      `${field} must be an ISO date-time`,
    );
  }
  return new Date(value).toISOString();
}

function validateDateOnly(value: string | undefined, field: string): string | undefined {
  if (value == null) return undefined;
  const normalized = value.trim();
  if (!/^\d{4}-\d{2}-\d{2}$/.test(normalized)) {
    throw new RavenDomainError(
      "INVALID_ACCOUNT_CLASSIFICATION",
      `${field} must use YYYY-MM-DD`,
    );
  }
  return normalized;
}

function defaultFacilityKind(accountType: string) {
  if (accountType === "credit_card") return "credit_card" as const;
  if (accountType === "loan") return "loan" as const;
  return "none" as const;
}

function financialDateAt(instant: string, timeZone: string): string {
  const parts = new Intl.DateTimeFormat("en-CA", {
    timeZone,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(new Date(instant));
  const values = Object.fromEntries(
    parts.map((part) => [part.type, part.value]),
  );
  return `${values.year}-${values.month}-${values.day}`;
}

function duplicateWriteFailure(error: unknown): boolean {
  const message =
    error instanceof Error ? `${error.name} ${error.message}` : String(error);
  return /already exists|record.*exists|duplicate|create only|idempot/i.test(
    message,
  );
}

function warningsForAccounts(
  accounts: ReturnType<typeof toAccountSummary>[],
): RavenWarningCode[] {
  const warnings = new Set<RavenWarningCode>();
  if (accounts.some((account) => account.freshness.state === "unknown"))
    warnings.add("BALANCE_UNKNOWN");
  if (
    accounts.some((account) => account.freshness.state === "invalid_future")
  ) {
    warnings.add("BALANCE_INVALID_FUTURE");
  }
  if (accounts.some((account) => account.freshness.state === "stale"))
    warnings.add("BALANCE_STALE");
  if (warnings.size > 0) warnings.add("PARTIAL_POSITION");
  return [...warnings];
}

function qualityForAccounts(
  accounts: ReturnType<typeof toAccountSummary>[],
): "complete" | "partial" | "provisional" | "unavailable" {
  if (
    accounts.some((account) =>
      ["unknown", "invalid_future"].includes(account.freshness.state),
    )
  ) {
    return "partial";
  }
  if (accounts.some((account) => account.freshness.state === "stale"))
    return "provisional";
  return "complete";
}

function receipt(
  operation: FinancialOperationRecord,
  status: "applied" | "replayed",
): CommandReceipt {
  return {
    operationId: operation.id,
    idempotencyKey: operation.idempotencyKey,
    status,
    entityRefs: operation.resultRefs,
    recordedAt: operation.recordedAt,
    warnings: operation.warningCodes,
  };
}

function transactionQuality(
  warnings: RavenWarningCode[],
): "complete" | "partial" | "provisional" {
  if (
    warnings.includes("LEGACY_TRANSFER_AMBIGUOUS") ||
    warnings.includes("LEGACY_TRANSACTION_INVALID") ||
    warnings.includes("TRANSACTION_SEMANTICS_UNRESOLVED") ||
    warnings.includes("PARTIAL_CANONICAL_TRANSACTION") ||
    warnings.includes("CANONICAL_LEGACY_CONFLICT") ||
    warnings.includes("TRANSACTION_DATE_INVALID")
  ) {
    return "partial";
  }
  return warnings.includes("LEGACY_MONEY_FALLBACK")
    ? "provisional"
    : "complete";
}

function compareTransactions(
  left: TransactionRecord,
  right: TransactionRecord,
): number {
  const date = (transactionFinancialDate(right) ?? "").localeCompare(
    transactionFinancialDate(left) ?? "",
  );
  if (date !== 0) return date;
  const recorded = (right.recordedAt ?? "").localeCompare(
    left.recordedAt ?? "",
  );
  if (recorded !== 0) return recorded;
  return right.id.localeCompare(left.id);
}

export class AccountControlService implements AccountControlApi {
  private readonly cashflow: CashflowControlService;

  constructor(
    private readonly repository: AccountControlRepository,
    private readonly clock: Clock = () => new Date(),
    private readonly options: AccountControlServiceOptions = {},
  ) {
    this.cashflow = new CashflowControlService(repository, clock);
  }

  private get financialTimeZone(): string {
    return this.options.financialTimeZone ?? DEFAULT_FINANCIAL_TIME_ZONE;
  }

  private now(input?: string): string {
    return input ? validateInstant(input, "asOf") : this.clock().toISOString();
  }

  private async summaries(spaceKeys: string[] | undefined, asOf: string) {
    const [spaces, accounts] = await Promise.all([
      this.repository.listSpaces(spaceKeys),
      this.repository.listAccounts(spaceKeys),
    ]);
    const snapshots = await this.repository.listBalanceSnapshots(
      accounts.map((account) => account.id),
    );
    return {
      spaces,
      accounts,
      snapshots,
      summaries: accounts.map((account) =>
        toAccountSummary(account, snapshots, asOf),
      ),
    };
  }

  async listAccounts(
    input: ListAccountsInput = {},
  ): Promise<ListAccountsOutput> {
    const asOf = this.now(input.asOf);
    const data = await this.summaries(input.spaceKeys, asOf);
    return {
      spaces: data.spaces.map((space) => ({
        key: space.key,
        name: space.name,
        spaceType: space.spaceType,
        currency: space.currency,
        accounts: data.summaries.filter(
          (account) => account.spaceKey === space.key,
        ),
      })),
      meta: {
        asOf,
        quality: qualityForAccounts(data.summaries),
        warnings: warningsForAccounts(data.summaries),
      },
    };
  }

  async getAccount(input: GetAccountInput): Promise<GetAccountOutput> {
    const asOf = this.now(input.asOf);
    const account = await this.repository.getAccount(
      input.spaceKey,
      input.accountKey,
    );
    if (!account) throw new RavenDomainError("NOT_FOUND", "Account not found");
    const [snapshots, facilitySnapshots, transactions] = await Promise.all([
      this.repository.listBalanceSnapshots([account.id]),
      this.repository.listFacilitySnapshots?.([account.id]) ??
        Promise.resolve([]),
      this.repository.listTransactions({
        accountIds: [account.id],
        includeLegacyUnreconciled: true,
      }),
    ]);
    const summary = toAccountSummary(account, snapshots, asOf);
    const asOfTime = new Date(asOf).getTime();
    return {
      account: summary,
      facilityHistory: facilitySnapshots
        .filter((snapshot) => new Date(snapshot.asOf).getTime() <= asOfTime)
        .sort((left, right) => Date.parse(right.asOf) - Date.parse(left.asOf))
        .map(toFacilitySnapshotView),
      availableMonths: [
        ...new Set(
          [
            ...transactions.map((transaction) =>
              transaction.postedAt?.slice(0, 7),
            ),
            ...snapshots
              .filter(
                (snapshot) => new Date(snapshot.asOf).getTime() <= asOfTime,
              )
              .map((snapshot) => snapshot.asOf.slice(0, 7)),
            ...facilitySnapshots
              .filter(
                (snapshot) => new Date(snapshot.asOf).getTime() <= asOfTime,
              )
              .map((snapshot) => snapshot.asOf.slice(0, 7)),
          ].filter((month): month is string => Boolean(month)),
        ),
      ].sort((left, right) => right.localeCompare(left)),
      meta: {
        asOf,
        currency: account.currency,
        quality: qualityForAccounts([summary]),
        warnings: warningsForAccounts([summary]),
      },
    };
  }

  async getCurrentPosition(
    input: GetCurrentPositionInput,
  ): Promise<GetCurrentPositionOutput> {
    const asOf = this.now(input.asOf);
    const currency = input.currency.trim().toUpperCase();
    money({ currency, minorUnits: 0 });
    const data = await this.summaries(input.spaceKeys, asOf);
    const accounts = data.accounts.filter(
      (account) => account.currency === currency,
    );

    let knownAssets = zeroMoney(currency);
    let knownLiabilities = zeroMoney(currency);
    let liquidCash = zeroMoney(currency);
    const missingAccountIds: string[] = [];
    const invalidFutureAccountIds: string[] = [];
    const staleAccountIds: string[] = [];

    for (const account of accounts) {
      const snapshot = selectBalanceSnapshot(account, data.snapshots, asOf);
      const freshness =
        data.summaries.find((summary) => summary.id === account.id)
          ?.freshness ?? snapshotFreshness(snapshot, account, asOf);
      if (!snapshot) {
        if (freshness.state === "invalid_future")
          invalidFutureAccountIds.push(account.id);
        else missingAccountIds.push(account.id);
        continue;
      }
      if (freshness.state === "stale") staleAccountIds.push(account.id);
      const amount = money(
        { currency, minorUnits: snapshot.amountMinor },
        { nonNegative: true },
      );
      if (snapshot.economicNature === "asset") {
        knownAssets = addMoney(knownAssets, amount);
        if (account.liquidityClass === "liquid")
          liquidCash = addMoney(liquidCash, amount);
      } else if (snapshot.economicNature === "liability") {
        knownLiabilities = addMoney(knownLiabilities, amount);
      }
    }

    const liquidUnavailable = accounts.some(
      (account) =>
        account.liquidityClass === "liquid" &&
        (missingAccountIds.includes(account.id) ||
          invalidFutureAccountIds.includes(account.id)),
    );
    const warnings = new Set<RavenWarningCode>();
    if (missingAccountIds.length > 0) warnings.add("BALANCE_UNKNOWN");
    if (invalidFutureAccountIds.length > 0)
      warnings.add("BALANCE_INVALID_FUTURE");
    if (staleAccountIds.length > 0) warnings.add("BALANCE_STALE");
    if (warnings.size > 0) warnings.add("PARTIAL_POSITION");

    return {
      liquidCash: liquidUnavailable ? null : liquidCash,
      knownAssets,
      knownLiabilities,
      knownNetPosition: subtractMoney(knownAssets, knownLiabilities),
      missingAccountIds,
      invalidFutureAccountIds,
      staleAccountIds,
      meta: {
        asOf,
        currency,
        quality: liquidUnavailable
          ? "unavailable"
          : missingAccountIds.length > 0 || invalidFutureAccountIds.length > 0
            ? "partial"
            : staleAccountIds.length > 0
              ? "provisional"
              : "complete",
        warnings: [...warnings],
      },
    };
  }

  async getAccountFreshness(
    input: GetAccountFreshnessInput = {},
  ): Promise<GetAccountFreshnessOutput> {
    const asOf = this.now(input.asOf);
    const data = await this.summaries(input.spaceKeys, asOf);
    const filtered = input.accountKeys?.length
      ? data.summaries.filter((account) =>
          input.accountKeys?.includes(account.accountKey),
        )
      : data.summaries;
    return {
      accounts: filtered.map((account) => ({
        accountId: account.id,
        spaceKey: account.spaceKey,
        accountKey: account.accountKey,
        freshness: account.freshness,
      })),
      meta: {
        asOf,
        quality: qualityForAccounts(filtered),
        warnings: warningsForAccounts(filtered),
      },
    };
  }

  async listAccountTransactions(
    input: ListAccountTransactionsInput,
  ): Promise<ListAccountTransactionsOutput> {
    const month = normalizeMonth(input.month);
    const account = await this.repository.getAccount(
      input.spaceKey.trim(),
      input.accountKey.trim(),
    );
    if (!account) throw new RavenDomainError("NOT_FOUND", "Account not found");
    const search = input.search?.trim().toLocaleLowerCase();
    const limit = Math.min(100, Math.max(1, input.limit ?? 50));
    const records = (
      await this.repository.listTransactions({
        accountIds: [account.id],
        month,
        includeLegacyUnreconciled:
          input.authorityScope === "active_ledger_with_legacy_unreconciled",
      })
    )
      .filter((record) => transactionFinancialDate(record)?.startsWith(month))
      .filter((record) => !input.kind || record.kind === input.kind)
      .filter(
        (record) =>
          !input.flow ||
          (input.flow === "unknown"
            ? record.flowDirection === null
            : record.flowDirection === input.flow),
      )
      .filter(
        (record) =>
          !input.categoryKey || record.categoryKey === input.categoryKey.trim(),
      )
      .filter(
        (record) =>
          !search ||
          `${record.description} ${record.merchantName ?? ""} ${record.categoryName ?? ""}`
            .toLocaleLowerCase()
            .includes(search),
      )
      .sort(compareTransactions);
    const cursorIndex = input.cursor
      ? records.findIndex((record) => record.id === input.cursor)
      : -1;
    const page = records.slice(
      cursorIndex >= 0 ? cursorIndex + 1 : 0,
      (cursorIndex >= 0 ? cursorIndex + 1 : 0) + limit,
    );
    const warnings = transactionWarnings(page);
    return {
      account: { spaceKey: account.spaceKey, accountKey: account.key },
      month,
      transactions: page.map(toTransactionView),
      nextCursor:
        page.length === limit &&
        records.indexOf(page[page.length - 1]!) < records.length - 1
          ? page[page.length - 1]!.id
          : null,
      meta: {
        asOf: this.clock().toISOString(),
        currency: account.currency,
        quality: transactionQuality(warnings),
        warnings,
      },
    };
  }

  async getTransaction(
    input: GetTransactionInput,
  ): Promise<GetTransactionOutput> {
    const id = input.transactionId.trim();
    const record = await this.repository.getTransaction(id);
    if (!record)
      throw new RavenDomainError("NOT_FOUND", "Transaction not found");
    const [operation, transfer, clarifications] = await Promise.all([
      record.operationId
        ? this.repository.getOperationById(record.operationId)
        : Promise.resolve(null),
      record.transferId
        ? this.repository.getTransfer(record.transferId)
        : Promise.resolve(null),
      this.repository.listClarifications(record.id),
    ]);
    const warnings = record.warnings;
    return {
      transaction: toTransactionDetailView(
        record,
        operation,
        transfer,
        clarifications,
      ),
      meta: {
        asOf: this.clock().toISOString(),
        currency: record.currency,
        quality: transactionQuality(warnings),
        warnings,
      },
    };
  }

  async getMonthProgress(
    input: GetMonthProgressInput,
  ): Promise<GetMonthProgressOutput> {
    const month = normalizeMonth(input.month);
    const currency = input.currency.trim().toUpperCase();
    money({ currency, minorUnits: 0 });
    const asOf = this.now(input.asOf);
    const cutoffDate = financialDateAt(asOf, this.financialTimeZone);
    const cutoffMonth = cutoffDate.slice(0, 7);
    const explicitAccountScope = input.accountRefs !== undefined;
    const explicitSpaceScope = input.spaceKeys !== undefined;
    let accounts: AccountRecord[];
    if (explicitAccountScope) {
      accounts = (
        await Promise.all(
          (input.accountRefs ?? []).map((ref) =>
            this.repository.getAccount(
              ref.spaceKey.trim(),
              ref.accountKey.trim(),
            ),
          ),
        )
      ).filter((account): account is AccountRecord => Boolean(account));
      if (accounts.length !== input.accountRefs?.length)
        throw new RavenDomainError("NOT_FOUND", "Account not found");
      if (accounts.some((account) => account.currency !== currency)) {
        throw new RavenDomainError(
          "CURRENCY_MISMATCH",
          "Requested account currency does not match the month currency",
        );
      }
    } else if (explicitSpaceScope) {
      accounts = input.spaceKeys?.length
        ? await this.repository.listAccounts(input.spaceKeys)
        : [];
    } else {
      accounts = await this.repository.listAccounts();
    }
    accounts = accounts.filter((account) => account.currency === currency);
    const explicitScope = explicitAccountScope || explicitSpaceScope;
    const records =
      month > cutoffMonth
        ? []
        : (
            await this.repository.listTransactions({
              accountIds: explicitScope
                ? accounts.map((account) => account.id)
                : undefined,
              month,
              includeLegacyUnreconciled:
                input.authorityScope ===
                "active_ledger_with_legacy_unreconciled",
            })
          ).filter(
            (record) =>
              transactionFinancialDate(record)?.startsWith(month) &&
              record.currency === currency &&
              (month < cutoffMonth ||
                transactionFinancialDate(record)! <= cutoffDate),
          );
    let income = zeroMoney(currency);
    let outflow = zeroMoney(currency);
    const counts = { income: 0, expense: 0, transfer: 0, uncategorized: 0 };
    for (const record of records) {
      if (record.status === "ignored") continue;
      if (record.kind === "transfer") {
        counts.transfer += 1;
        continue;
      }
      if (
        record.kind === "unresolved" ||
        record.flowDirection === null ||
        record.amountMinor === null ||
        transactionFinancialDate(record) === null
      )
        continue;
      if (record.kind === "income") counts.income += 1;
      if (record.kind === "expense") counts.expense += 1;
      if (
        (record.kind === "income" || record.kind === "expense") &&
        !record.categoryId
      )
        counts.uncategorized += 1;
      const amount = money(
        { currency, minorUnits: record.amountMinor },
        { nonNegative: true },
      );
      if (record.kind === "income" && record.flowDirection === "inflow")
        income = addMoney(income, amount);
      if (record.kind === "expense" && record.flowDirection === "outflow")
        outflow = addMoney(outflow, amount);
    }
    const warnings = transactionWarnings(
      records.filter((record) => record.status !== "ignored"),
    );
    return {
      month,
      income,
      outflow,
      net: subtractMoney(income, outflow),
      counts,
      meta: {
        asOf,
        currency,
        quality: transactionQuality(warnings),
        warnings,
      },
    };
  }

  async listCategories(
    input: ListCategoriesInput,
  ): Promise<ListCategoriesOutput> {
    const spaceKey = input.spaceKey.trim();
    const spaces = await this.repository.listSpaces([spaceKey]);
    if (!spaces.some((space) => space.key === spaceKey)) {
      throw new RavenDomainError("NOT_FOUND", "Financial space not found");
    }
    const categories = (await this.repository.listCategories(spaceKey))
      .filter((category) => category.active)
      .filter(
        (category) =>
          !input.kinds?.length || input.kinds.includes(category.kind),
      )
      .sort(
        (left, right) =>
          left.name.localeCompare(right.name) ||
          left.key.localeCompare(right.key),
      );
    return {
      categories: categories.map(toCategoryView),
      meta: {
        asOf: this.clock().toISOString(),
        quality: "complete",
        warnings: [],
      },
    };
  }

  private async replay(
    command: FinancialOperationRecord["command"],
    idempotencyKey: string,
    hash: string,
  ): Promise<FinancialOperationRecord | null> {
    const existing = await this.repository.getOperation(
      command,
      idempotencyKey,
    );
    if (!existing) return null;
    if (existing.requestHash !== hash) {
      throw new RavenDomainError(
        "IDEMPOTENCY_CONFLICT",
        "This idempotency key was already used with a different request",
      );
    }
    return existing;
  }

  private operationDraft(
    command: FinancialOperationRecord["command"],
    input: CommandMeta,
    hash: string,
  ): OperationDraft {
    const idempotencyKey = validateIdempotencyKey(input.idempotencyKey);
    return {
      key: operationKey(command, idempotencyKey),
      command,
      idempotencyKey,
      requestHash: hash,
      channel: input.channel,
      actorId: input.actorId,
      recordedAt: this.clock().toISOString(),
    };
  }

  async createAccount(input: CreateAccountInput): Promise<CreateAccountOutput> {
    const normalized: CreateAccountInput = {
      ...input,
      idempotencyKey: validateIdempotencyKey(input.idempotencyKey),
      spaceKey: input.spaceKey.trim(),
      accountKey: input.accountKey.trim(),
      name: input.name.trim(),
      bankName: input.bankName?.trim(),
      facilityKind:
        input.facilityKind ?? defaultFacilityKind(input.accountType.trim()),
      currency: input.currency.trim().toUpperCase(),
    };
    if (
      normalized.accountType === "credit_card" &&
      normalized.facilityKind !== "credit_card"
    ) {
      throw new RavenDomainError(
        "INVALID_ACCOUNT_CLASSIFICATION",
        "Credit-card accounts must use the credit_card facility kind",
      );
    }
    if (!normalized.spaceKey || !normalized.accountKey || !normalized.name) {
      throw new RavenDomainError(
        "INVALID_ACCOUNT_CLASSIFICATION",
        "Space, account key, and name are required",
      );
    }
    if (
      !Number.isInteger(normalized.freshnessWindowHours) ||
      normalized.freshnessWindowHours < 1
    ) {
      throw new RavenDomainError(
        "INVALID_ACCOUNT_CLASSIFICATION",
        "Freshness window must be a positive whole hour",
      );
    }
    money({ currency: normalized.currency, minorUnits: 0 });
    const hash = requestHash(normalized);
    const existing = await this.replay(
      "create_account",
      normalized.idempotencyKey,
      hash,
    );
    if (existing) {
      const account = await this.repository.getAccount(
        normalized.spaceKey,
        normalized.accountKey,
      );
      if (!account)
        throw new RavenDomainError(
          "INTERNAL",
          "Idempotent account result is missing",
        );
      return {
        entity: toAccountSummary(account, [], this.clock().toISOString()),
        receipt: receipt(existing, "replayed"),
      };
    }

    const [spaces, duplicate] = await Promise.all([
      this.repository.listSpaces([normalized.spaceKey]),
      this.repository.getAccount(normalized.spaceKey, normalized.accountKey),
    ]);
    if (!spaces.some((space) => space.key === normalized.spaceKey)) {
      throw new RavenDomainError("NOT_FOUND", "Financial space not found");
    }
    if (duplicate) {
      throw new RavenDomainError(
        "ALREADY_EXISTS",
        "An account with this key already exists",
      );
    }

    const applied = await this.repository.createAccountWithOperation(
      normalized,
      this.operationDraft("create_account", normalized, hash),
    );
    return {
      entity: toAccountSummary(
        applied.account,
        [],
        applied.operation.recordedAt,
      ),
      receipt: receipt(applied.operation, "applied"),
    };
  }

  async confirmAccountBalance(
    input: ConfirmAccountBalanceInput,
  ): Promise<ConfirmAccountBalanceOutput> {
    const normalized: ConfirmAccountBalanceInput = {
      ...input,
      idempotencyKey: validateIdempotencyKey(input.idempotencyKey),
      spaceKey: input.spaceKey.trim(),
      accountKey: input.accountKey.trim(),
      money: money(input.money, { nonNegative: true }),
      asOf: validateInstant(input.asOf, "asOf"),
      note: input.note?.trim(),
    };
    const account = await this.repository.getAccount(
      normalized.spaceKey,
      normalized.accountKey,
    );
    if (!account) throw new RavenDomainError("NOT_FOUND", "Account not found");
    if (account.currency !== normalized.money.currency) {
      throw new RavenDomainError(
        "CURRENCY_MISMATCH",
        "Balance currency does not match the account",
      );
    }
    if (
      normalized.balanceKind === "outstanding" &&
      normalized.economicNature !== "liability"
    ) {
      throw new RavenDomainError(
        "INVALID_BALANCE_KIND",
        "Outstanding balances must be liabilities",
      );
    }
    if (
      normalized.balanceKind === "available" &&
      account.normalNature === "liability" &&
      normalized.economicNature !== "informational"
    ) {
      throw new RavenDomainError(
        "INVALID_BALANCE_KIND",
        "Available credit must be informational",
      );
    }

    const hash = requestHash(normalized);
    const existing = await this.replay(
      "confirm_account_balance",
      normalized.idempotencyKey,
      hash,
    );
    if (existing) {
      const snapshot = existing.resultRefs[0]
        ? await this.repository.getBalanceSnapshot(existing.resultRefs[0])
        : null;
      if (!snapshot)
        throw new RavenDomainError(
          "INTERNAL",
          "Idempotent balance result is missing",
        );
      return {
        entity: toBalanceView(snapshot),
        receipt: receipt(existing, "replayed"),
      };
    }

    const operation = this.operationDraft(
      "confirm_account_balance",
      normalized,
      hash,
    );
    const snapshotKey = createHash("sha256")
      .update(`${account.id}\u0000${operation.key}`)
      .digest("hex");
    const applied = await this.repository.confirmBalanceWithOperation(
      {
        key: snapshotKey,
        spaceId: account.spaceId,
        accountId: account.id,
        balanceKind: normalized.balanceKind,
        amountMinor: normalized.money.minorUnits,
        currency: normalized.money.currency,
        economicNature: normalized.economicNature,
        asOf: normalized.asOf,
        recordedAt: operation.recordedAt,
        evidenceLevel: "confirmed",
        sourceKind: "manual_confirmation",
        sourceRef: null,
        operationId: `financialOperation:${operation.key}`,
        notes: normalized.note || null,
      },
      operation,
    );
    return {
      entity: toBalanceView(applied.snapshot),
      receipt: receipt(applied.operation, "applied"),
    };
  }

  async recordAccountFacilitySnapshot(
    input: RecordAccountFacilitySnapshotInput,
  ): Promise<RecordAccountFacilitySnapshotOutput> {
    const normalized: RecordAccountFacilitySnapshotInput = {
      ...input,
      idempotencyKey: validateIdempotencyKey(input.idempotencyKey),
      spaceKey: input.spaceKey.trim(),
      accountKey: input.accountKey.trim(),
      asOf: validateInstant(input.asOf, "asOf"),
      effectiveFrom: validateDateOnly(input.effectiveFrom, "effectiveFrom"),
      paymentDueOn: validateDateOnly(input.paymentDueOn, "paymentDueOn"),
      sourceRef: input.sourceRef?.trim(),
      statementImportId: input.statementImportId?.trim(),
      facilityLimit: input.facilityLimit
        ? money(input.facilityLimit, { nonNegative: true })
        : undefined,
      availableCredit: input.availableCredit
        ? money(input.availableCredit, { nonNegative: true })
        : undefined,
      minimumPayment: input.minimumPayment
        ? money(input.minimumPayment, { nonNegative: true })
        : undefined,
      interestRates: input.interestRates ?? {},
      feeTerms: input.feeTerms ?? {},
      terms: input.terms ?? {},
      note: input.note?.trim(),
    };
    const account = await this.repository.getAccount(
      normalized.spaceKey,
      normalized.accountKey,
    );
    if (!account) throw new RavenDomainError("NOT_FOUND", "Account not found");
    const currentFacilityKind =
      account.facilityKind ?? defaultFacilityKind(account.accountType);
    if (
      currentFacilityKind !== "none" &&
      currentFacilityKind !== normalized.facilityKind
    ) {
      throw new RavenDomainError(
        "INVALID_ACCOUNT_CLASSIFICATION",
        "Facility evidence conflicts with the account facility kind",
      );
    }
    const suppliedMoney = [
      normalized.facilityLimit,
      normalized.availableCredit,
      normalized.minimumPayment,
    ].filter((value): value is NonNullable<typeof value> => Boolean(value));
    if (suppliedMoney.some((value) => value.currency !== account.currency)) {
      throw new RavenDomainError(
        "CURRENCY_MISMATCH",
        "Facility evidence currency does not match the account",
      );
    }
    if (
      normalized.sourceKind === "statement" &&
      !normalized.statementImportId
    ) {
      throw new RavenDomainError(
        "INVALID_ACCOUNT_CLASSIFICATION",
        "Statement facility evidence requires a statement import reference",
      );
    }
    if (
      suppliedMoney.length === 0 &&
      Object.keys(normalized.interestRates ?? {}).length === 0 &&
      Object.keys(normalized.feeTerms ?? {}).length === 0 &&
      Object.keys(normalized.terms ?? {}).length === 0
    ) {
      throw new RavenDomainError(
        "INVALID_ACCOUNT_CLASSIFICATION",
        "Facility evidence must include a limit, availability, payment, rate, fee, or term",
      );
    }

    const hash = requestHash(normalized);
    const existing = await this.replay(
      "record_account_facility_snapshot",
      normalized.idempotencyKey,
      hash,
    );
    if (existing) {
      const snapshot = existing.resultRefs[0]
        ? await this.repository.getFacilitySnapshot?.(existing.resultRefs[0])
        : null;
      if (!snapshot) {
        throw new RavenDomainError(
          "INTERNAL",
          "Idempotent facility snapshot result is missing",
        );
      }
      return {
        entity: toFacilitySnapshotView(snapshot),
        receipt: receipt(existing, "replayed"),
      };
    }

    const operation = this.operationDraft(
      "record_account_facility_snapshot",
      normalized,
      hash,
    );
    if (!this.repository.recordFacilitySnapshotWithOperation) {
      throw new RavenDomainError(
        "INTERNAL",
        "Facility snapshot persistence is unavailable",
      );
    }
    const applied = await this.repository.recordFacilitySnapshotWithOperation(
      {
        key: operation.key,
        spaceId: account.spaceId,
        accountId: account.id,
        facilityKind: normalized.facilityKind,
        currency: account.currency,
        asOf: normalized.asOf,
        effectiveFrom: normalized.effectiveFrom,
        recordedAt: operation.recordedAt,
        evidenceLevel: normalized.evidenceLevel,
        sourceKind: normalized.sourceKind,
        sourceRef: normalized.sourceRef,
        statementImportId: normalized.statementImportId,
        facilityLimitMinor: normalized.facilityLimit?.minorUnits,
        availableCreditMinor: normalized.availableCredit?.minorUnits,
        minimumPaymentMinor: normalized.minimumPayment?.minorUnits,
        paymentDueOn: normalized.paymentDueOn,
        interestRates: normalized.interestRates ?? {},
        feeTerms: normalized.feeTerms ?? {},
        terms: normalized.terms ?? {},
        operationId: `financialOperation:${operation.key}`,
        notes: normalized.note,
      },
      operation,
    );
    return {
      entity: toFacilitySnapshotView(applied.snapshot),
      receipt: receipt(applied.operation, "applied"),
    };
  }

  private async validateCategory(
    account: AccountRecord,
    categoryKey: string | undefined,
    compatibleKinds: CategoryKind[],
  ) {
    if (!categoryKey) return null;
    const category = await this.repository.getCategory(
      account.spaceKey,
      categoryKey,
    );
    if (
      !category ||
      !category.active ||
      !compatibleKinds.includes(category.kind)
    ) {
      throw new RavenDomainError(
        "INVALID_CATEGORY",
        "Category is not active and compatible with this transaction",
      );
    }
    return category;
  }

  private async recordMovement(
    command: "record_expense" | "record_income",
    input: RecordTransactionInput,
  ): Promise<RecordTransactionOutput> {
    const kind = command === "record_expense" ? "expense" : "income";
    const flowDirection = command === "record_expense" ? "outflow" : "inflow";
    const normalized = {
      ...input,
      idempotencyKey: validateIdempotencyKey(input.idempotencyKey),
      spaceKey: input.spaceKey.trim(),
      accountKey: input.accountKey.trim(),
      money: money(input.money, { nonNegative: true }),
      postedAt: normalizeFinancialDate(input.postedAt),
      description: input.description.trim(),
      categoryKey: input.categoryKey?.trim() || undefined,
    };
    if (normalized.money.minorUnits <= 0) {
      throw new RavenDomainError(
        "INVALID_MONEY",
        "Transaction amount must be greater than zero",
      );
    }
    if (!normalized.description) {
      throw new RavenDomainError(
        "INVALID_TRANSACTION",
        "Transaction description is required",
      );
    }
    const account = await this.repository.getAccount(
      normalized.spaceKey,
      normalized.accountKey,
    );
    if (!account) throw new RavenDomainError("NOT_FOUND", "Account not found");
    if (account.currency !== normalized.money.currency) {
      throw new RavenDomainError(
        "CURRENCY_MISMATCH",
        "Transaction currency does not match the account",
      );
    }
    const category = await this.validateCategory(
      account,
      normalized.categoryKey,
      kind === "expense"
        ? ["expense", "savings", "other"]
        : ["income", "other"],
    );
    const hash = requestHash(normalized);
    const existing = await this.replay(
      command,
      normalized.idempotencyKey,
      hash,
    );
    if (existing) {
      const record = existing.resultRefs[0]
        ? await this.repository.getTransaction(existing.resultRefs[0])
        : null;
      if (!record)
        throw new RavenDomainError(
          "INTERNAL",
          "Idempotent transaction result is missing",
        );
      return {
        entity: toTransactionView(record),
        receipt: receipt(existing, "replayed"),
      };
    }
    const operation = this.operationDraft(command, normalized, hash);
    const key = createHash("sha256")
      .update(`${account.id}\u0000${operation.key}\u0000${kind}`)
      .digest("hex");
    try {
      const applied = await this.repository.recordTransactionWithOperation(
        {
          key,
          spaceId: account.spaceId,
          spaceKey: account.spaceKey,
          accountId: account.id,
          accountKey: account.key,
          postedAt: normalized.postedAt,
          recordedAt: operation.recordedAt,
          description: normalized.description,
          amountMinor: normalized.money.minorUnits,
          currency: normalized.money.currency,
          kind,
          flowDirection,
          categoryId: category?.id ?? null,
          operationId: `financialOperation:${operation.key}`,
        },
        operation,
      );
      return {
        entity: toTransactionView(applied.transaction),
        receipt: receipt(applied.operation, "applied"),
      };
    } catch (error) {
      if (!duplicateWriteFailure(error)) throw error;
      const raced = await this.replay(command, normalized.idempotencyKey, hash);
      if (!raced) throw error;
      const record = raced.resultRefs[0]
        ? await this.repository.getTransaction(raced.resultRefs[0])
        : null;
      if (!record) throw error;
      return {
        entity: toTransactionView(record),
        receipt: receipt(raced, "replayed"),
      };
    }
  }

  async recordExpense(
    input: RecordExpenseInput,
  ): Promise<RecordTransactionOutput> {
    return this.recordMovement("record_expense", input);
  }

  async recordIncome(
    input: RecordIncomeInput,
  ): Promise<RecordTransactionOutput> {
    return this.recordMovement("record_income", input);
  }

  async recordTransfer(
    input: RecordTransferInput,
  ): Promise<RecordTransferOutput> {
    const normalized: RecordTransferInput = {
      ...input,
      idempotencyKey: validateIdempotencyKey(input.idempotencyKey),
      source: {
        spaceKey: input.source.spaceKey.trim(),
        accountKey: input.source.accountKey.trim(),
      },
      target: {
        spaceKey: input.target.spaceKey.trim(),
        accountKey: input.target.accountKey.trim(),
      },
      money: money(input.money, { nonNegative: true }),
      postedAt: normalizeFinancialDate(input.postedAt),
      description: input.description?.trim() || undefined,
    };
    if (normalized.money.minorUnits <= 0) {
      throw new RavenDomainError(
        "INVALID_MONEY",
        "Transfer amount must be greater than zero",
      );
    }
    if (
      normalized.source.spaceKey === normalized.target.spaceKey &&
      normalized.source.accountKey === normalized.target.accountKey
    ) {
      throw new RavenDomainError(
        "DUPLICATE_TRANSFER",
        "Source and target accounts must differ",
      );
    }
    const [source, target] = await Promise.all([
      this.repository.getAccount(
        normalized.source.spaceKey,
        normalized.source.accountKey,
      ),
      this.repository.getAccount(
        normalized.target.spaceKey,
        normalized.target.accountKey,
      ),
    ]);
    if (!source || !target)
      throw new RavenDomainError("NOT_FOUND", "Transfer account not found");
    if (
      source.currency !== target.currency ||
      source.currency !== normalized.money.currency
    ) {
      throw new RavenDomainError(
        "CURRENCY_MISMATCH",
        "Transfer accounts and amount must use the same currency",
      );
    }
    const hash = requestHash(normalized);
    const existing = await this.replay(
      "record_transfer",
      normalized.idempotencyKey,
      hash,
    );
    if (existing) {
      const transfer = existing.resultRefs[0]
        ? await this.repository.getTransfer(existing.resultRefs[0])
        : null;
      if (!transfer)
        throw new RavenDomainError(
          "INTERNAL",
          "Idempotent transfer result is missing",
        );
      const [sourceTransaction, targetTransaction] = await Promise.all([
        this.repository.getTransaction(transfer.sourceTransactionId),
        this.repository.getTransaction(transfer.targetTransactionId),
      ]);
      if (!sourceTransaction || !targetTransaction) {
        throw new RavenDomainError(
          "INTERNAL",
          "Idempotent transfer legs are missing",
        );
      }
      return this.transferOutput(
        transfer,
        sourceTransaction,
        targetTransaction,
        existing,
        "replayed",
      );
    }
    const operation = this.operationDraft("record_transfer", normalized, hash);
    const key = createHash("sha256")
      .update(`${source.id}\u0000${target.id}\u0000${operation.key}`)
      .digest("hex");
    try {
      const applied = await this.repository.recordTransferWithOperation(
        {
          key,
          sourceTransactionKey: createHash("sha256")
            .update(`${key}\u0000source`)
            .digest("hex"),
          targetTransactionKey: createHash("sha256")
            .update(`${key}\u0000target`)
            .digest("hex"),
          sourceAccount: source,
          targetAccount: target,
          postedAt: normalized.postedAt,
          recordedAt: operation.recordedAt,
          description: normalized.description ?? null,
          amountMinor: normalized.money.minorUnits,
          currency: normalized.money.currency,
          operationId: `financialOperation:${operation.key}`,
        },
        operation,
      );
      return this.transferOutput(
        applied.transfer,
        applied.sourceTransaction,
        applied.targetTransaction,
        applied.operation,
        "applied",
      );
    } catch (error) {
      if (!duplicateWriteFailure(error)) throw error;
      const raced = await this.replay(
        "record_transfer",
        normalized.idempotencyKey,
        hash,
      );
      if (!raced) throw error;
      const transfer = raced.resultRefs[0]
        ? await this.repository.getTransfer(raced.resultRefs[0])
        : null;
      if (!transfer) throw error;
      const [sourceTransaction, targetTransaction] = await Promise.all([
        this.repository.getTransaction(transfer.sourceTransactionId),
        this.repository.getTransaction(transfer.targetTransactionId),
      ]);
      if (!sourceTransaction || !targetTransaction) throw error;
      return this.transferOutput(
        transfer,
        sourceTransaction,
        targetTransaction,
        raced,
        "replayed",
      );
    }
  }

  private transferOutput(
    transfer: Awaited<ReturnType<AccountControlRepository["getTransfer"]>> & {},
    sourceTransaction: TransactionRecord,
    targetTransaction: TransactionRecord,
    operation: FinancialOperationRecord,
    status: "applied" | "replayed",
  ): RecordTransferOutput {
    return {
      transfer: {
        id: transfer.id,
        source: {
          spaceKey: transfer.source.spaceKey,
          accountKey: transfer.source.accountKey,
        },
        target: {
          spaceKey: transfer.target.spaceKey,
          accountKey: transfer.target.accountKey,
        },
        amount: money(
          { currency: transfer.currency, minorUnits: transfer.amountMinor },
          { nonNegative: true },
        ),
        postedAt: transfer.postedAt,
        description: transfer.description ?? null,
      },
      sourceTransaction: toTransactionView(sourceTransaction),
      targetTransaction: toTransactionView(targetTransaction),
      receipt: receipt(operation, status),
    };
  }

  listCashflowSchedules: AccountControlApi["listCashflowSchedules"] = (input) =>
    this.cashflow.listCashflowSchedules(input);
  getCashflowSchedule: AccountControlApi["getCashflowSchedule"] = (input) =>
    this.cashflow.getCashflowSchedule(input);
  listUpcomingCashflows: AccountControlApi["listUpcomingCashflows"] = (input) =>
    this.cashflow.listUpcomingCashflows(input);
  getCashflowOccurrence: AccountControlApi["getCashflowOccurrence"] = (input) =>
    this.cashflow.getCashflowOccurrence(input);
  createScheduledCashflow: AccountControlApi["createScheduledCashflow"] = (
    input,
  ) => this.cashflow.createScheduledCashflow(input);
  updateScheduledCashflow: AccountControlApi["updateScheduledCashflow"] = (
    input,
  ) => this.cashflow.updateScheduledCashflow(input);
  pauseScheduledCashflow: AccountControlApi["pauseScheduledCashflow"] = (
    input,
  ) => this.cashflow.pauseScheduledCashflow(input);
  resumeScheduledCashflow: AccountControlApi["resumeScheduledCashflow"] = (
    input,
  ) => this.cashflow.resumeScheduledCashflow(input);
  endScheduledCashflow: AccountControlApi["endScheduledCashflow"] = (input) =>
    this.cashflow.endScheduledCashflow(input);
  cancelScheduledCashflow: AccountControlApi["cancelScheduledCashflow"] = (
    input,
  ) => this.cashflow.cancelScheduledCashflow(input);
  settleCashflowOccurrence: AccountControlApi["settleCashflowOccurrence"] = (
    input,
  ) => this.cashflow.settleCashflowOccurrence(input);
  reconcileCashflowOccurrence: AccountControlApi["reconcileCashflowOccurrence"] =
    (input) => this.cashflow.reconcileCashflowOccurrence(input);
  skipCashflowOccurrence: AccountControlApi["skipCashflowOccurrence"] = (
    input,
  ) => this.cashflow.skipCashflowOccurrence(input);
  waiveCashflowOccurrence: AccountControlApi["waiveCashflowOccurrence"] = (
    input,
  ) => this.cashflow.waiveCashflowOccurrence(input);
  cancelCashflowOccurrence: AccountControlApi["cancelCashflowOccurrence"] = (
    input,
  ) => this.cashflow.cancelCashflowOccurrence(input);
  overrideCashflowOccurrenceAmount: AccountControlApi["overrideCashflowOccurrenceAmount"] =
    (input) => this.cashflow.overrideCashflowOccurrenceAmount(input);
  overrideCashflowOccurrenceDueDate: AccountControlApi["overrideCashflowOccurrenceDueDate"] =
    (input) => this.cashflow.overrideCashflowOccurrenceDueDate(input);
}

export function createAccountControlService(
  repository: AccountControlRepository,
  clock?: Clock,
  options?: AccountControlServiceOptions,
): AccountControlApi {
  return new AccountControlService(repository, clock, options);
}
