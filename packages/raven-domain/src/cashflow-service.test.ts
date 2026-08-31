import assert from "node:assert/strict";
import test from "node:test";
import type {
  AccountRecord,
  CashflowOccurrenceRecord,
  CashflowScheduleRecord,
  CategoryRecord,
  FinancialOperationRecord,
  FinancialSpaceRecord,
  TransactionRecord,
} from "./contracts.js";
import { RavenDomainError } from "./errors.js";
import type {
  AccountControlRepository,
  CashflowOccurrenceDraft,
  CashflowOccurrenceMutation,
  CashflowOccurrenceReadFilter,
  CashflowScheduleDraft,
  CashflowScheduleMutation,
  CashflowScheduleReadFilter,
  OperationDraft,
} from "./repository.js";
import { AccountControlService } from "./service.js";

const NOW = "2026-07-12T10:00:00.000Z";

class CashflowMemoryRepository implements AccountControlRepository {
  readonly spaces: FinancialSpaceRecord[] = [
    {
      id: "financialSpace:test",
      key: "test",
      name: "Test",
      spaceType: "personal",
      currency: "ZAR",
    },
  ];
  readonly accounts: AccountRecord[] = [
    {
      id: "account:test-current",
      spaceId: "financialSpace:test",
      spaceKey: "test",
      key: "current",
      name: "Current",
      bankName: "Test Bank",
      accountType: "current",
      currency: "ZAR",
      normalNature: "asset",
      liquidityClass: "liquid",
      freshnessWindowHours: 72,
      active: true,
    },
  ];
  readonly categories: CategoryRecord[] = [
    {
      id: "category:rent",
      spaceId: "financialSpace:test",
      spaceKey: "test",
      key: "rent",
      name: "Rent",
      kind: "expense",
      active: true,
    },
  ];
  readonly schedules: CashflowScheduleRecord[] = [];
  readonly occurrences: CashflowOccurrenceRecord[] = [];
  readonly operations: FinancialOperationRecord[] = [];
  readonly transactions: TransactionRecord[] = [];
  scheduleMutationGate: Promise<void> | null = null;

  async listSpaces(keys?: string[]) {
    return keys
      ? this.spaces.filter((item) => keys.includes(item.key))
      : this.spaces;
  }
  async listAccounts(keys?: string[]) {
    return keys
      ? this.accounts.filter((item) => keys.includes(item.spaceKey))
      : this.accounts;
  }
  async getAccount(spaceKey: string, accountKey: string) {
    return (
      this.accounts.find(
        (item) => item.spaceKey === spaceKey && item.key === accountKey,
      ) ?? null
    );
  }
  async listBalanceSnapshots() {
    return [];
  }
  async getBalanceSnapshot() {
    return null;
  }
  async listTransactions() {
    return this.transactions;
  }
  async getTransaction(id: string) {
    return this.transactions.find((item) => item.id === id) ?? null;
  }
  async listCategories(spaceKey: string) {
    return this.categories.filter((item) => item.spaceKey === spaceKey);
  }
  async getCategory(spaceKey: string, categoryKey: string) {
    return (
      this.categories.find(
        (item) => item.spaceKey === spaceKey && item.key === categoryKey,
      ) ?? null
    );
  }
  async getOperationById(id: string) {
    return this.operations.find((item) => item.id === id) ?? null;
  }
  async getTransfer() {
    return null;
  }
  async listClarifications() {
    return [];
  }
  async getOperation(
    command: FinancialOperationRecord["command"],
    key: string,
  ) {
    return (
      this.operations.find(
        (item) => item.command === command && item.idempotencyKey === key,
      ) ?? null
    );
  }
  async listOperationsForEntity(entityId: string) {
    return this.operations
      .filter((item) => item.resultRefs.includes(entityId))
      .sort((a, b) => b.recordedAt.localeCompare(a.recordedAt));
  }

  async listCashflowSchedules(filter: CashflowScheduleReadFilter = {}) {
    return this.schedules.filter(
      (item) =>
        (!filter.spaceKeys || filter.spaceKeys.includes(item.spaceKey)) &&
        (!filter.statuses || filter.statuses.includes(item.status)),
    );
  }
  async getCashflowSchedule(id: string) {
    return this.schedules.find((item) => item.id === id) ?? null;
  }
  async listCashflowOccurrences(filter: CashflowOccurrenceReadFilter = {}) {
    return this.occurrences.filter(
      (item) =>
        (!filter.scheduleIds || filter.scheduleIds.includes(item.scheduleId)) &&
        (!filter.spaceKeys || filter.spaceKeys.includes(item.spaceKey)) &&
        (!filter.statuses || filter.statuses.includes(item.status)) &&
        (!filter.from || item.dueOn >= filter.from) &&
        (!filter.through || item.dueOn <= filter.through),
    );
  }
  async getCashflowOccurrence(id: string) {
    return this.occurrences.find((item) => item.id === id) ?? null;
  }

  private operation(
    draft: OperationDraft,
    refs: string[],
  ): FinancialOperationRecord {
    const operation: FinancialOperationRecord = {
      id: `financialOperation:${draft.key}`,
      key: draft.key,
      command: draft.command,
      idempotencyKey: draft.idempotencyKey,
      requestHash: draft.requestHash,
      channel: draft.channel,
      actorId: draft.actorId ?? null,
      status: "applied",
      resultRefs: refs,
      warningCodes: draft.warningCodes ?? [],
      recordedAt: draft.recordedAt,
      auditMeta: draft.auditMeta ?? {},
      completedAt: draft.recordedAt,
      failureCode: null,
    };
    this.operations.push(operation);
    return operation;
  }

  async createCashflowScheduleWithOperation(
    schedule: CashflowScheduleDraft,
    drafts: CashflowOccurrenceDraft[],
    operation: OperationDraft,
  ) {
    const stored: CashflowScheduleRecord = {
      ...schedule,
      id: `cashflowSchedule:${schedule.spaceId}|${schedule.key}`,
    };
    const occurrences = drafts.map((item) => ({
      ...item,
      scheduleId: stored.id,
      id: `cashflowOccurrence:${stored.key}|${item.scheduledDueOn}`,
    }));
    this.schedules.push(stored);
    this.occurrences.push(...occurrences);
    return {
      schedule: stored,
      occurrences,
      operation: this.operation(operation, operation.resultRefs ?? [stored.id]),
    };
  }

  async mutateCashflowScheduleWithOperation(
    mutation: CashflowScheduleMutation,
    operation: OperationDraft,
  ) {
    if (this.scheduleMutationGate) await this.scheduleMutationGate;
    const index = this.schedules.findIndex(
      (item) => item.id === mutation.scheduleId,
    );
    const current = this.schedules[index];
    if (
      !current ||
      current.revision !== mutation.expectedRevision ||
      current.status !== mutation.expectedStatus
    )
      throw new RavenDomainError("SCHEDULE_REVISION_CONFLICT", "revision");
    const schedule = { ...current, ...mutation.patch };
    for (const update of mutation.occurrencePatches) {
      const occurrenceIndex = this.occurrences.findIndex(
        (item) => item.id === update.occurrenceId,
      );
      const occurrence = this.occurrences[occurrenceIndex];
      if (
        !occurrence ||
        occurrence.revision !== update.expectedRevision ||
        occurrence.status !== update.expectedStatus
      ) {
        throw new RavenDomainError("OCCURRENCE_CONFLICT", "occurrence changed");
      }
    }
    this.schedules[index] = schedule;
    for (const update of mutation.occurrencePatches) {
      const occurrenceIndex = this.occurrences.findIndex(
        (item) => item.id === update.occurrenceId,
      );
      this.occurrences[occurrenceIndex] = {
        ...this.occurrences[occurrenceIndex]!,
        ...update.patch,
      };
    }
    this.occurrences.push(
      ...mutation.createOccurrences.map((item) => ({
        ...item,
        scheduleId: schedule.id,
        id: `cashflowOccurrence:${schedule.key}|${item.scheduledDueOn}`,
      })),
    );
    return {
      schedule,
      occurrences: this.occurrences.filter(
        (item) => item.scheduleId === schedule.id,
      ),
      operation: this.operation(
        operation,
        operation.resultRefs ?? [schedule.id],
      ),
    };
  }

  async materializeCashflowOccurrences(
    scheduleId: string,
    expectedRevision: number,
    through: string,
    drafts: CashflowOccurrenceDraft[],
  ) {
    const index = this.schedules.findIndex((item) => item.id === scheduleId);
    const current = this.schedules[index];
    if (!current || current.revision !== expectedRevision)
      throw new RavenDomainError("SCHEDULE_REVISION_CONFLICT", "revision");
    if (current.materializedThrough && current.materializedThrough >= through) {
      return {
        schedule: current,
        occurrences: this.occurrences.filter(
          (item) => item.scheduleId === scheduleId,
        ),
      };
    }
    const schedule = { ...current, materializedThrough: through };
    this.schedules[index] = schedule;
    const existing = new Set(
      this.occurrences.map(
        (item) => `${item.scheduleId}|${item.scheduledDueOn}`,
      ),
    );
    this.occurrences.push(
      ...drafts
        .filter((item) => !existing.has(`${scheduleId}|${item.scheduledDueOn}`))
        .map((item) => ({
          ...item,
          scheduleId,
          id: `cashflowOccurrence:${schedule.key}|${item.scheduledDueOn}`,
        })),
    );
    return {
      schedule,
      occurrences: this.occurrences.filter(
        (item) => item.scheduleId === scheduleId,
      ),
    };
  }

  async mutateCashflowOccurrenceWithOperation(
    mutation: CashflowOccurrenceMutation,
    operation: OperationDraft,
  ) {
    const index = this.occurrences.findIndex(
      (item) => item.id === mutation.occurrenceId,
    );
    const current = this.occurrences[index];
    if (!current || current.revision !== mutation.expectedRevision)
      throw new RavenDomainError("OCCURRENCE_REVISION_CONFLICT", "revision");
    if (current.status !== mutation.expectedStatus)
      throw new RavenDomainError("OCCURRENCE_CONFLICT", "status");
    if (
      mutation.settlementTransactionId &&
      this.occurrences.some(
        (item) =>
          item.id !== current.id &&
          item.transactionId === mutation.settlementTransactionId,
      )
    ) {
      throw new RavenDomainError(
        "OCCURRENCE_CONFLICT",
        "transaction already linked",
      );
    }
    const occurrence = { ...current, ...mutation.patch };
    this.occurrences[index] = occurrence;
    return {
      occurrence,
      operation: this.operation(
        operation,
        operation.resultRefs ?? [occurrence.id],
      ),
    };
  }

  async createAccountWithOperation(): Promise<never> {
    throw new Error("not used");
  }
  async confirmBalanceWithOperation(): Promise<never> {
    throw new Error("not used");
  }
  async recordTransactionWithOperation(): Promise<never> {
    throw new Error("not used");
  }
  async recordTransferWithOperation(): Promise<never> {
    throw new Error("not used");
  }
}

function createInput(idempotencyKey = "cashflow-create-001") {
  return {
    spaceKey: "test",
    accountKey: "current",
    categoryKey: "rent",
    title: "Fictional rent",
    direction: "outflow" as const,
    certainty: "committed" as const,
    money: { currency: "ZAR", minorUnits: 1_250_000 },
    cadence: "monthly" as const,
    interval: 1,
    startDate: "2026-01-31",
    dayOfMonth: 31,
    timezone: "Africa/Johannesburg",
    materializeThrough: "2026-04-30",
    idempotencyKey,
    channel: "ui" as const,
  };
}

test("scheduled cashflow materializes without month-end drift and replays idempotently", async () => {
  const repository = new CashflowMemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  const created = await service.createScheduledCashflow(createInput());
  assert.deepEqual(
    created.occurrences.map((item) => item.scheduledDueOn),
    ["2026-01-31", "2026-02-28", "2026-03-31", "2026-04-30"],
  );
  const replay = await service.createScheduledCashflow(createInput());
  assert.equal(replay.receipt.status, "replayed");
  assert.equal(repository.schedules.length, 1);
});

test("occurrence overrides are explicit and settlement without evidence remains partial", async () => {
  const repository = new CashflowMemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  const created = await service.createScheduledCashflow(
    createInput("cashflow-create-002"),
  );
  const occurrence = created.occurrences[0]!;
  const overridden = await service.overrideCashflowOccurrenceAmount({
    occurrenceId: occurrence.id,
    expectedRevision: occurrence.revision,
    money: { currency: "ZAR", minorUnits: 1_300_000 },
    reason: "Fictional escalation",
    idempotencyKey: "cashflow-override-001",
    channel: "ui",
  });
  assert.equal(overridden.occurrence.money.minorUnits, 1_300_000);
  assert.equal(overridden.occurrence.scheduledMoney.minorUnits, 1_250_000);
  const settled = await service.settleCashflowOccurrence({
    occurrenceId: occurrence.id,
    expectedRevision: overridden.occurrence.revision,
    settledAt: NOW,
    idempotencyKey: "cashflow-settle-001",
    channel: "ui",
  });
  assert.deepEqual(settled.receipt.warnings, ["UNRECONCILED_SETTLEMENT"]);
  await assert.rejects(
    service.skipCashflowOccurrence({
      occurrenceId: occurrence.id,
      expectedRevision: settled.occurrence.revision,
      idempotencyKey: "cashflow-skip-001",
      channel: "ui",
    }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "OCCURRENCE_ALREADY_SETTLED",
  );
});

test("schedule lifecycle uses revisions and cancels future due occurrences on end", async () => {
  const repository = new CashflowMemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  const created = await service.createScheduledCashflow(
    createInput("cashflow-create-003"),
  );
  const paused = await service.pauseScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: 1,
    effectiveOn: "2026-02-01",
    idempotencyKey: "cashflow-pause-001",
    channel: "ui",
  });
  assert.equal(paused.schedule.status, "paused");
  await assert.rejects(
    service.resumeScheduledCashflow({
      scheduleId: created.schedule.id,
      expectedRevision: 1,
      resumeOn: "2026-02-15",
      idempotencyKey: "cashflow-resume-stale",
      channel: "ui",
    }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "SCHEDULE_REVISION_CONFLICT",
  );
  const resumed = await service.resumeScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: 2,
    resumeOn: "2026-02-15",
    idempotencyKey: "cashflow-resume-001",
    channel: "ui",
  });
  const ended = await service.endScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: resumed.schedule.revision,
    effectiveOn: "2026-03-01",
    idempotencyKey: "cashflow-end-001",
    channel: "ui",
  });
  assert.equal(ended.schedule.status, "ended");
  assert.ok(
    ended.occurrences
      .filter((item) => item.dueOn > "2026-03-01")
      .every((item) => item.status === "cancelled"),
  );
});

test("certainty, terminal history, occurrence transitions, and settlement evidence remain explicit", async () => {
  const repository = new CashflowMemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  await assert.rejects(
    service.createScheduledCashflow({
      ...createInput("cashflow-invalid-certainty"),
      certainty: "expected" as any,
    }),
    (error: unknown) =>
      error instanceof RavenDomainError && error.code === "INVALID_CERTAINTY",
  );
  const created = await service.createScheduledCashflow(
    createInput("cashflow-create-004"),
  );
  await assert.rejects(
    service.createScheduledCashflow({
      ...createInput("cashflow-create-004"),
      title: "Changed request",
    }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "IDEMPOTENCY_CONFLICT",
  );
  const [settleTarget, skipTarget, waiveTarget, cancelTarget] =
    created.occurrences;
  repository.transactions.push({
    id: "transaction:matching",
    key: "matching",
    spaceId: "financialSpace:test",
    spaceKey: "test",
    accountId: "account:test-current",
    accountKey: "current",
    postedAt: "2026-01-31",
    recordedAt: NOW,
    description: "Fictional matching expense",
    amountMinor: 1_250_000,
    currency: "ZAR",
    kind: "expense",
    flowDirection: "outflow",
    entrySource: "manual",
    status: "clarified",
    warnings: [],
  });
  const settled = await service.settleCashflowOccurrence({
    occurrenceId: settleTarget!.id,
    expectedRevision: 1,
    settledAt: NOW,
    transactionId: "transaction:matching",
    idempotencyKey: "cashflow-linked-settle",
    channel: "ui",
  });
  assert.equal(settled.occurrence.reconciled, true);
  const before = { ...repository.transactions[0] };
  await service.skipCashflowOccurrence({
    occurrenceId: skipTarget!.id,
    expectedRevision: 1,
    idempotencyKey: "cashflow-skip-002",
    channel: "ui",
  });
  await service.waiveCashflowOccurrence({
    occurrenceId: waiveTarget!.id,
    expectedRevision: 1,
    idempotencyKey: "cashflow-waive-001",
    channel: "ui",
  });
  await service.cancelCashflowOccurrence({
    occurrenceId: cancelTarget!.id,
    expectedRevision: 1,
    idempotencyKey: "cashflow-cancel-001",
    channel: "ui",
  });
  assert.deepEqual(repository.transactions[0], before);
  await assert.rejects(
    service.skipCashflowOccurrence({
      occurrenceId: skipTarget!.id,
      expectedRevision: 1,
      idempotencyKey: "cashflow-skip-stale",
      channel: "ui",
    }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "OCCURRENCE_REVISION_CONFLICT",
  );
  const updated = await service.updateScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: 1,
    effectiveFrom: "2026-01-31",
    money: { currency: "ZAR", minorUnits: 1_400_000 },
    idempotencyKey: "cashflow-update-001",
    channel: "ui",
  });
  const frozen = updated.occurrences.find(
    (item) => item.id === settleTarget!.id,
  )!;
  assert.equal(frozen.status, "settled");
  assert.equal(frozen.money.minorUnits, 1_250_000);
  assert.equal(frozen.scheduleRevision, 1);
});

function transaction(
  overrides: Partial<TransactionRecord> = {},
): TransactionRecord {
  return {
    id: "transaction:matching",
    key: "matching",
    spaceId: "financialSpace:test",
    spaceKey: "test",
    accountId: "account:test-current",
    accountKey: "current",
    postedAt: "2026-01-31",
    recordedAt: NOW,
    description: "Fictional matching expense",
    amountMinor: 1_250_000,
    currency: "ZAR",
    kind: "expense",
    flowDirection: "outflow",
    entrySource: "manual",
    status: "clarified",
    warnings: [],
    ...overrides,
  };
}

test("concurrent identical schedule and occurrence mutations replay one semantic operation", async () => {
  const repository = new CashflowMemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  const created = await service.createScheduledCashflow(
    createInput("cashflow-concurrent-create"),
  );
  const update = {
    scheduleId: created.schedule.id,
    expectedRevision: 1,
    effectiveFrom: "2026-02-01",
    title: "Fictional revised rent",
    idempotencyKey: "cashflow-concurrent-update",
    channel: "ui" as const,
  };
  const updates = await Promise.all([
    service.updateScheduledCashflow(update),
    service.updateScheduledCashflow(update),
  ]);
  assert.deepEqual(updates.map((item) => item.receipt.status).sort(), [
    "applied",
    "replayed",
  ]);
  assert.equal(
    repository.operations.filter(
      (item) => item.command === "update_scheduled_cashflow",
    ).length,
    1,
  );

  const occurrence = updates[0]!.occurrences.find(
    (item) => item.status === "due",
  )!;
  const override = {
    occurrenceId: occurrence.id,
    expectedRevision: occurrence.revision,
    money: { currency: "ZAR", minorUnits: 1_300_000 },
    reason: "Fictional correction",
    idempotencyKey: "cashflow-concurrent-override",
    channel: "ui" as const,
  };
  const overrides = await Promise.all([
    service.overrideCashflowOccurrenceAmount(override),
    service.overrideCashflowOccurrenceAmount(override),
  ]);
  assert.deepEqual(overrides.map((item) => item.receipt.status).sort(), [
    "applied",
    "replayed",
  ]);
  assert.equal(
    repository.operations.filter(
      (item) => item.command === "override_cashflow_occurrence_amount",
    ).length,
    1,
  );
});

test("concurrent pause and linked settlement replay, while a changed hash conflicts", async () => {
  const repository = new CashflowMemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  const created = await service.createScheduledCashflow(
    createInput("cashflow-concurrent-lifecycle-create"),
  );
  const pause = {
    scheduleId: created.schedule.id,
    expectedRevision: 1,
    effectiveOn: "2026-02-01",
    note: "Fictional pause",
    idempotencyKey: "cashflow-concurrent-pause",
    channel: "ui" as const,
  };
  const pauses = await Promise.all([
    service.pauseScheduledCashflow(pause),
    service.pauseScheduledCashflow(pause),
  ]);
  assert.deepEqual(pauses.map((item) => item.receipt.status).sort(), [
    "applied",
    "replayed",
  ]);
  await assert.rejects(
    service.pauseScheduledCashflow({ ...pause, note: "Changed pause reason" }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "IDEMPOTENCY_CONFLICT",
  );

  const separate = await service.createScheduledCashflow(
    createInput("cashflow-concurrent-settle-create"),
  );
  const occurrence = separate.occurrences[0]!;
  repository.transactions.push(transaction());
  const settle = {
    occurrenceId: occurrence.id,
    expectedRevision: occurrence.revision,
    settledAt: NOW,
    transactionId: "transaction:matching",
    idempotencyKey: "cashflow-concurrent-settle",
    channel: "ui" as const,
  };
  const settlements = await Promise.all([
    service.settleCashflowOccurrence(settle),
    service.settleCashflowOccurrence(settle),
  ]);
  assert.deepEqual(settlements.map((item) => item.receipt.status).sort(), [
    "applied",
    "replayed",
  ]);
  assert.equal(repository.transactions.length, 1);
  assert.deepEqual(repository.transactions[0], transaction());
});

test("the canonical schedule transition matrix rejects every unsupported state mutation", async () => {
  const activeRepository = new CashflowMemoryRepository();
  const activeService = new AccountControlService(
    activeRepository,
    () => new Date(NOW),
  );
  const active = await activeService.createScheduledCashflow(
    createInput("cashflow-transition-active"),
  );
  await assert.rejects(
    activeService.resumeScheduledCashflow({
      scheduleId: active.schedule.id,
      expectedRevision: 1,
      resumeOn: "2026-02-01",
      idempotencyKey: "invalid-active-resume",
      channel: "ui",
    }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "INVALID_SCHEDULE_TRANSITION",
  );
  const paused = await activeService.pauseScheduledCashflow({
    scheduleId: active.schedule.id,
    expectedRevision: 1,
    effectiveOn: "2026-02-01",
    idempotencyKey: "valid-active-pause",
    channel: "ui",
  });
  await assert.rejects(
    activeService.pauseScheduledCashflow({
      scheduleId: active.schedule.id,
      expectedRevision: paused.schedule.revision,
      effectiveOn: "2026-02-02",
      idempotencyKey: "invalid-paused-pause",
      channel: "ui",
    }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "INVALID_SCHEDULE_TRANSITION",
  );

  for (const terminal of ["ended", "cancelled"] as const) {
    const repository = new CashflowMemoryRepository();
    const service = new AccountControlService(repository, () => new Date(NOW));
    const created = await service.createScheduledCashflow(
      createInput(`cashflow-transition-${terminal}`),
    );
    const result =
      terminal === "ended"
        ? await service.endScheduledCashflow({
            scheduleId: created.schedule.id,
            expectedRevision: 1,
            effectiveOn: "2026-02-01",
            idempotencyKey: `to-${terminal}-schedule`,
            channel: "ui",
          })
        : await service.cancelScheduledCashflow({
            scheduleId: created.schedule.id,
            expectedRevision: 1,
            effectiveOn: "2026-02-01",
            idempotencyKey: `to-${terminal}-schedule`,
            channel: "ui",
          });
    const commands = [
      () =>
        service.updateScheduledCashflow({
          scheduleId: created.schedule.id,
          expectedRevision: result.schedule.revision,
          effectiveFrom: "2026-02-02",
          title: "No",
          idempotencyKey: `${terminal}-update-invalid`,
          channel: "ui",
        }),
      () =>
        service.pauseScheduledCashflow({
          scheduleId: created.schedule.id,
          expectedRevision: result.schedule.revision,
          effectiveOn: "2026-02-02",
          idempotencyKey: `${terminal}-pause-invalid`,
          channel: "ui",
        }),
      () =>
        service.resumeScheduledCashflow({
          scheduleId: created.schedule.id,
          expectedRevision: result.schedule.revision,
          resumeOn: "2026-02-02",
          idempotencyKey: `${terminal}-resume-invalid`,
          channel: "ui",
        }),
      () =>
        service.endScheduledCashflow({
          scheduleId: created.schedule.id,
          expectedRevision: result.schedule.revision,
          effectiveOn: "2026-02-02",
          idempotencyKey: `${terminal}-end-invalid`,
          channel: "ui",
        }),
      () =>
        service.cancelScheduledCashflow({
          scheduleId: created.schedule.id,
          expectedRevision: result.schedule.revision,
          effectiveOn: "2026-02-02",
          idempotencyKey: `${terminal}-cancel-invalid`,
          channel: "ui",
        }),
    ];
    for (const command of commands) {
      await assert.rejects(
        command,
        (error: unknown) =>
          error instanceof RavenDomainError &&
          error.code === "INVALID_SCHEDULE_TRANSITION",
      );
    }
  }
});

test("future terms, pause/resume, end, and cancel preserve their effective boundaries", async () => {
  const repository = new CashflowMemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  const created = await service.createScheduledCashflow(
    createInput("cashflow-boundary-create"),
  );
  const updated = await service.updateScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: 1,
    effectiveFrom: "2026-03-01",
    money: { currency: "ZAR", minorUnits: 1_500_000 },
    idempotencyKey: "cashflow-boundary-update",
    channel: "ui",
  });
  assert.deepEqual(
    updated.occurrences.map((item) => [
      item.scheduledDueOn,
      item.money.minorUnits,
    ]),
    [
      ["2026-01-31", 1_250_000],
      ["2026-02-28", 1_250_000],
      ["2026-03-31", 1_500_000],
      ["2026-04-30", 1_500_000],
    ],
  );
  const paused = await service.pauseScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: 2,
    effectiveOn: "2026-03-31",
    idempotencyKey: "cashflow-boundary-pause",
    channel: "ui",
  });
  const resumed = await service.resumeScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: paused.schedule.revision,
    resumeOn: "2026-04-15",
    idempotencyKey: "cashflow-boundary-resume",
    channel: "ui",
  });
  assert.equal(
    resumed.occurrences.find((item) => item.scheduledDueOn === "2026-03-31")
      ?.status,
    "due",
  );
  assert.equal(
    resumed.occurrences.find((item) => item.scheduledDueOn === "2026-04-30")
      ?.status,
    "due",
  );
  await assert.rejects(
    service.endScheduledCashflow({
      scheduleId: created.schedule.id,
      expectedRevision: resumed.schedule.revision,
      effectiveOn: "2026-03-31",
      idempotencyKey: "cashflow-boundary-retroactive-end",
      channel: "ui",
    }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "INVALID_CASHFLOW_DATE_RANGE",
  );
  const ended = await service.endScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: resumed.schedule.revision,
    effectiveOn: "2026-04-15",
    idempotencyKey: "cashflow-boundary-end",
    channel: "ui",
  });
  assert.equal(
    ended.occurrences.find((item) => item.scheduledDueOn === "2026-03-31")
      ?.status,
    "due",
  );
  assert.equal(
    ended.occurrences.find((item) => item.scheduledDueOn === "2026-04-30")
      ?.status,
    "cancelled",
  );

  const cancelRepository = new CashflowMemoryRepository();
  const cancelService = new AccountControlService(
    cancelRepository,
    () => new Date(NOW),
  );
  const cancelCreated = await cancelService.createScheduledCashflow(
    createInput("cashflow-cancel-boundary-create"),
  );
  const cancelled = await cancelService.cancelScheduledCashflow({
    scheduleId: cancelCreated.schedule.id,
    expectedRevision: 1,
    effectiveOn: "2026-03-31",
    idempotencyKey: "cashflow-cancel-boundary",
    channel: "ui",
  });
  assert.equal(
    cancelled.occurrences.find((item) => item.scheduledDueOn === "2026-02-28")
      ?.status,
    "due",
  );
  assert.equal(
    cancelled.occurrences.find((item) => item.scheduledDueOn === "2026-03-31")
      ?.status,
    "cancelled",
  );
});

test("ending a paused month-end schedule terminalizes due gap rows without changing immutable history", async () => {
  const repository = new CashflowMemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  const created = await service.createScheduledCashflow({
    ...createInput("cashflow-paused-end-create"),
    materializeThrough: "2026-08-31",
  });
  const paused = await service.pauseScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: 1,
    effectiveOn: "2026-03-31",
    idempotencyKey: "cashflow-paused-end-pause",
    channel: "ui",
  });
  const immutableStates = new Map([
    ["2026-05-31", "settled"],
    ["2026-06-30", "skipped"],
    ["2026-07-31", "waived"],
    ["2026-08-31", "cancelled"],
  ] as const);
  for (const [dueOn, status] of immutableStates) {
    const index = repository.occurrences.findIndex(
      (item) =>
        item.scheduleId === created.schedule.id &&
        item.scheduledDueOn === dueOn,
    );
    repository.occurrences[index] = {
      ...repository.occurrences[index]!,
      status,
      revision: 2,
      settledAt: status === "settled" ? "2026-05-31T10:00:00.000Z" : null,
      statusReason: `Fictional ${status} history`,
    };
  }
  const immutableBefore = repository.occurrences
    .filter((item) => immutableStates.has(item.scheduledDueOn as never))
    .map((item) => ({ ...item }));

  const ended = await service.endScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: paused.schedule.revision,
    effectiveOn: "2026-05-31",
    note: "Fictional end from pause",
    idempotencyKey: "cashflow-paused-end-terminal",
    channel: "ui",
  });
  assert.equal(ended.schedule.status, "ended");
  assert.equal(ended.schedule.materializedThrough, "2026-08-31");
  assert.equal(
    repository.occurrences.find((item) => item.scheduledDueOn === "2026-04-30")
      ?.status,
    "cancelled",
  );
  assert.equal(
    repository.occurrences.find((item) => item.scheduledDueOn === "2026-04-30")
      ?.statusReason,
    "Schedule paused before ending",
  );
  assert.deepEqual(
    repository.occurrences.filter((item) =>
      immutableStates.has(item.scheduledDueOn as never),
    ),
    immutableBefore,
  );
  assert.equal(
    repository.occurrences.some(
      (item) => item.status === "due" && item.scheduledDueOn > "2026-03-31",
    ),
    false,
  );

  const detail = await service.getCashflowSchedule({
    scheduleId: created.schedule.id,
    from: "2026-04-01",
    through: "2026-08-31",
    asOf: "2026-05-31T00:00:00.000Z",
  });
  assert.equal(detail.occurrenceCounts.due, 0);
  const upcoming = await service.listUpcomingCashflows({
    from: "2026-04-01",
    through: "2026-08-31",
    spaceKeys: ["test"],
    asOf: "2026-05-31T00:00:00.000Z",
  });
  assert.equal(upcoming.occurrences.length, 0);
  assert.equal(upcoming.summaries.length, 0);
});

test("cancelling a paused month-end schedule does not materialize the paused gap and replays safely", async () => {
  const repository = new CashflowMemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  const created = await service.createScheduledCashflow({
    ...createInput("cashflow-paused-cancel-create"),
    materializeThrough: "2026-03-31",
  });
  const paused = await service.pauseScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: 1,
    effectiveOn: "2026-03-31",
    idempotencyKey: "cashflow-paused-cancel-pause",
    channel: "ui",
  });
  const command = {
    scheduleId: created.schedule.id,
    expectedRevision: paused.schedule.revision,
    effectiveOn: "2026-05-31",
    note: "Fictional cancellation from pause",
    idempotencyKey: "cashflow-paused-cancel-terminal",
    channel: "ui" as const,
  };
  const results = await Promise.all([
    service.cancelScheduledCashflow(command),
    service.cancelScheduledCashflow(command),
  ]);
  assert.deepEqual(results.map((item) => item.receipt.status).sort(), [
    "applied",
    "replayed",
  ]);
  assert.equal(results[0]!.schedule.materializedThrough, "2026-05-31");
  assert.deepEqual(
    repository.occurrences.map((item) => item.scheduledDueOn),
    ["2026-01-31", "2026-02-28", "2026-03-31"],
  );
  assert.equal(
    repository.occurrences.find((item) => item.scheduledDueOn === "2026-03-31")
      ?.status,
    "due",
  );
});

test("paused cancellation terminalizes pre-materialized due rows and shared reads reject stale gap obligations", async () => {
  const repository = new CashflowMemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  const created = await service.createScheduledCashflow({
    ...createInput("cashflow-paused-cancel-existing-create"),
    materializeThrough: "2026-06-30",
  });
  const paused = await service.pauseScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: 1,
    effectiveOn: "2026-03-31",
    idempotencyKey: "cashflow-paused-cancel-existing-pause",
    channel: "ui",
  });
  const cancelled = await service.cancelScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: paused.schedule.revision,
    effectiveOn: "2026-05-31",
    idempotencyKey: "cashflow-paused-cancel-existing-terminal",
    channel: "ui",
  });
  assert.equal(cancelled.schedule.status, "cancelled");
  for (const dueOn of ["2026-04-30", "2026-05-31", "2026-06-30"]) {
    const occurrence = repository.occurrences.find(
      (item) => item.scheduledDueOn === dueOn,
    );
    assert.equal(occurrence?.status, "cancelled");
    assert.equal(
      occurrence?.statusReason,
      "Schedule paused before cancellation",
    );
  }

  // Defensive read semantics also protect historical data written before this
  // closeout, even if a paused-gap row is still persisted as due.
  const staleIndex = repository.occurrences.findIndex(
    (item) => item.scheduledDueOn === "2026-04-30",
  );
  repository.occurrences[staleIndex] = {
    ...repository.occurrences[staleIndex]!,
    status: "due",
  };
  const schedules = await service.listCashflowSchedules({
    spaceKeys: ["test"],
    asOf: NOW,
  });
  assert.notEqual(schedules.schedules[0]?.nextDueOn, "2026-04-30");
  const detail = await service.getCashflowSchedule({
    scheduleId: created.schedule.id,
    from: "2026-04-01",
    through: "2026-06-30",
    asOf: NOW,
  });
  assert.equal(detail.occurrenceCounts.due, 0);
  assert.equal(
    detail.occurrences.some((item) => item.status === "due"),
    false,
  );
  const upcoming = await service.listUpcomingCashflows({
    from: "2026-04-01",
    through: "2026-06-30",
    spaceKeys: ["test"],
    asOf: NOW,
  });
  assert.equal(upcoming.occurrences.length, 0);
  assert.equal(upcoming.summaries.length, 0);
});

test("schedule views expose timezone-effective lifecycle state before, on, and after pending transitions", async () => {
  const repository = new CashflowMemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  const created = await service.createScheduledCashflow({
    ...createInput("cashflow-lifecycle-view-create"),
    materializeThrough: "2026-03-31",
  });
  const paused = await service.pauseScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: 1,
    effectiveOn: "2026-03-31",
    idempotencyKey: "cashflow-lifecycle-view-pause",
    channel: "ui",
  });
  const ended = await service.endScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: paused.schedule.revision,
    effectiveOn: "2026-05-31",
    idempotencyKey: "cashflow-lifecycle-view-end",
    channel: "ui",
  });
  const beforePause = (
    await service.getCashflowSchedule({
      scheduleId: created.schedule.id,
      asOf: "2026-03-30T21:59:59.000Z",
    })
  ).schedule;
  assert.equal(beforePause.configuredStatus, "ended");
  assert.equal(beforePause.effectiveStatus, "active");
  assert.deepEqual(beforePause.pendingTransition, {
    status: "paused",
    effectiveOn: "2026-03-31",
  });
  const onPause = (
    await service.getCashflowSchedule({
      scheduleId: created.schedule.id,
      asOf: "2026-03-30T22:00:00.000Z",
    })
  ).schedule;
  assert.equal(onPause.effectiveStatus, "paused");
  assert.deepEqual(onPause.pendingTransition, {
    status: "ended",
    effectiveOn: "2026-05-31",
  });
  const onEnd = (
    await service.getCashflowSchedule({
      scheduleId: ended.schedule.id,
      asOf: "2026-05-30T22:00:00.000Z",
    })
  ).schedule;
  assert.equal(onEnd.effectiveStatus, "ended");
  assert.equal(onEnd.pendingTransition, null);
});

test("materialization is monotonic and shorter horizons are no-ops", async () => {
  const repository = new CashflowMemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  const created = await service.createScheduledCashflow({
    ...createInput("cashflow-monotonic-create"),
    materializeThrough: "2026-02-28",
  });
  await service.listUpcomingCashflows({
    from: "2026-01-01",
    through: "2026-06-30",
    asOf: NOW,
  });
  const extended = await repository.getCashflowSchedule(created.schedule.id);
  assert.equal(extended?.materializedThrough, "2026-06-30");
  const before = repository.occurrences.length;
  await service.listUpcomingCashflows({
    from: "2026-01-01",
    through: "2026-04-30",
    asOf: NOW,
  });
  assert.equal(
    (await repository.getCashflowSchedule(created.schedule.id))
      ?.materializedThrough,
    "2026-06-30",
  );
  assert.equal(repository.occurrences.length, before);
});

test("a schedule mutation cannot overwrite a concurrently terminal occurrence", async () => {
  const repository = new CashflowMemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  const created = await service.createScheduledCashflow(
    createInput("cashflow-occurrence-race-create"),
  );
  let release!: () => void;
  repository.scheduleMutationGate = new Promise<void>((resolve) => {
    release = resolve;
  });
  const updatePromise = service.updateScheduledCashflow({
    scheduleId: created.schedule.id,
    expectedRevision: 1,
    effectiveFrom: "2026-01-31",
    money: { currency: "ZAR", minorUnits: 1_600_000 },
    idempotencyKey: "cashflow-occurrence-race-update",
    channel: "ui",
  });
  await new Promise((resolve) => setImmediate(resolve));
  const target = created.occurrences[0]!;
  const settled = await service.settleCashflowOccurrence({
    occurrenceId: target.id,
    expectedRevision: 1,
    settledAt: NOW,
    idempotencyKey: "cashflow-occurrence-race-settle",
    channel: "ui",
  });
  release();
  await assert.rejects(
    updatePromise,
    (error: unknown) =>
      error instanceof RavenDomainError && error.code === "OCCURRENCE_CONFLICT",
  );
  const current = await repository.getCashflowOccurrence(target.id);
  assert.equal(current?.status, "settled");
  assert.equal(current?.amountMinor, target.money.minorUnits);
  assert.equal(settled.occurrence.status, "settled");
});

test("settlement rejects noncanonical, cross-space, and wrong-account evidence", async () => {
  const invalid: Array<[string, Partial<TransactionRecord>]> = [
    ["legacy fallback", { warnings: ["LEGACY_MONEY_FALLBACK"] }],
    ["ignored", { status: "ignored" }],
    ["unresolved", { kind: "unresolved", flowDirection: null }],
    ["transfer", { kind: "transfer", flowDirection: null }],
    ["cross space", { spaceId: "financialSpace:other", spaceKey: "other" }],
    ["wrong account", { accountId: "account:test-other", accountKey: "other" }],
  ];
  for (const [label, override] of invalid) {
    const repository = new CashflowMemoryRepository();
    const service = new AccountControlService(repository, () => new Date(NOW));
    const created = await service.createScheduledCashflow(
      createInput(`cashflow-invalid-settlement-${label.replace(" ", "-")}`),
    );
    repository.transactions.push(transaction(override));
    await assert.rejects(
      service.settleCashflowOccurrence({
        occurrenceId: created.occurrences[0]!.id,
        expectedRevision: 1,
        settledAt: NOW,
        transactionId: "transaction:matching",
        idempotencyKey: `invalid-settlement-${label}`,
        channel: "ui",
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "INVALID_SETTLEMENT_TRANSACTION",
    );
  }
});

test("one observed transaction cannot settle two occurrences concurrently", async () => {
  const repository = new CashflowMemoryRepository();
  const service = new AccountControlService(repository, () => new Date(NOW));
  const created = await service.createScheduledCashflow(
    createInput("cashflow-unique-settlement-create"),
  );
  repository.transactions.push(transaction());
  const commands = created.occurrences.slice(0, 2).map((occurrence, index) =>
    service.settleCashflowOccurrence({
      occurrenceId: occurrence.id,
      expectedRevision: 1,
      settledAt: NOW,
      transactionId: "transaction:matching",
      idempotencyKey: `cashflow-unique-settlement-${index}`,
      channel: "ui" as const,
    }),
  );
  const results = await Promise.allSettled(commands);
  assert.equal(results.filter((item) => item.status === "fulfilled").length, 1);
  const rejected = results.find(
    (item): item is PromiseRejectedResult => item.status === "rejected",
  );
  assert.ok(rejected?.reason instanceof RavenDomainError);
  assert.equal(rejected.reason.code, "OCCURRENCE_CONFLICT");
  assert.equal(
    repository.occurrences.filter(
      (item) => item.transactionId === "transaction:matching",
    ).length,
    1,
  );
});

test("upcoming summaries keep certainty separate and timing follows each schedule timezone", async () => {
  const repository = new CashflowMemoryRepository();
  const service = new AccountControlService(
    repository,
    () => new Date("2026-07-12T10:30:00.000Z"),
  );
  const base = {
    ...createInput(),
    cadence: "once" as const,
    interval: 1,
    startDate: "2026-07-12",
    onceDueOn: "2026-07-12",
    materializeThrough: "2026-07-12",
    dayOfMonth: undefined,
    categoryKey: undefined,
  };
  await service.createScheduledCashflow({
    ...base,
    title: "Fictional committed out",
    idempotencyKey: "summary-committed",
    money: { currency: "ZAR", minorUnits: 10_000 },
    timezone: "Pacific/Kiritimati",
  });
  await service.createScheduledCashflow({
    ...base,
    title: "Fictional confirmed in",
    direction: "inflow",
    certainty: "confirmed",
    idempotencyKey: "summary-confirmed",
    money: { currency: "ZAR", minorUnits: 20_000 },
    timezone: "America/Adak",
  });
  await service.createScheduledCashflow({
    ...base,
    title: "Fictional expected in",
    direction: "inflow",
    certainty: "expected",
    idempotencyKey: "summary-expected",
    money: { currency: "ZAR", minorUnits: 30_000 },
    timezone: "Africa/Johannesburg",
  });
  await service.createScheduledCashflow({
    ...base,
    title: "Fictional possible in",
    direction: "inflow",
    certainty: "possible",
    idempotencyKey: "summary-possible",
    money: { currency: "ZAR", minorUnits: 40_000 },
    timezone: "Africa/Johannesburg",
  });
  const upcoming = await service.listUpcomingCashflows({
    from: "2026-07-12",
    through: "2026-07-12",
    asOf: "2026-07-12T10:30:00.000Z",
  });
  assert.deepEqual(upcoming.summaries[0], {
    currency: "ZAR",
    committedOutflow: { currency: "ZAR", minorUnits: 10_000 },
    confirmedInflow: { currency: "ZAR", minorUnits: 20_000 },
    expectedInflow: { currency: "ZAR", minorUnits: 30_000 },
    possibleInflow: { currency: "ZAR", minorUnits: 40_000 },
    dueCount: 4,
    unreconciledCount: 0,
  });
  assert.equal("net" in upcoming.summaries[0]!, false);
  assert.equal(
    upcoming.occurrences.find((item) => item.title.includes("committed"))
      ?.timing.group,
    "overdue",
  );
  assert.equal(
    upcoming.occurrences.find((item) => item.title.includes("confirmed"))
      ?.timing.group,
    "today",
  );

  const settledTarget = upcoming.occurrences.find((item) =>
    item.title.includes("expected"),
  )!;
  await service.settleCashflowOccurrence({
    occurrenceId: settledTarget.id,
    expectedRevision: 1,
    settledAt: NOW,
    idempotencyKey: "summary-unlinked-settle",
    channel: "ui",
  });
  const history = await service.listUpcomingCashflows({
    from: "2026-07-12",
    through: "2026-07-12",
    includeTerminal: true,
    asOf: "2026-07-12T10:30:00.000Z",
  });
  assert.equal(
    history.occurrences.find((item) => item.id === settledTarget.id)?.timing
      .group,
    "history",
  );
  assert.equal(history.summaries[0]?.unreconciledCount, 1);
  assert.deepEqual(
    (
      await service.listUpcomingCashflows({
        from: "2026-07-12",
        through: "2026-07-12",
        spaceKeys: [],
        asOf: NOW,
      })
    ).occurrences,
    [],
  );
});
