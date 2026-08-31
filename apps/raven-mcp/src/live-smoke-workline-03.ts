import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { Surreal } from "surrealdb";
import YAML from "yaml";
import { RavenDomainError } from "@raven/domain";
import { createAccountControlService } from "@raven/domain/server";
import { createSurrealAccountControlRepository } from "@raven/surreal";

type DatabaseConfig = {
  url: string;
  namespace: string;
  database: string;
  username: string;
  password: string;
};
type LocalAppConfig = {
  environment: { defaultDatabase: string };
  databases: Record<string, DatabaseConfig>;
};

const SPACE = "wl03-fictional-space";
const OTHER_SPACE = "wl03-fictional-other-space";
const ACCOUNT = "wl03-fictional-current";
const SECOND_ACCOUNT = "wl03-fictional-secondary";
const OTHER_ACCOUNT = "wl03-fictional-other-current";
const CATEGORY = "wl03-fictional-rent";
const NOW = "2026-07-12T10:00:00.000Z";
const ACTOR = "workline03-smoke";
const operationKeys = [
  "wl03-account-create-001",
  "wl03-account-secondary-001",
  "wl03-account-other-001",
  "wl03-schedule-create-001",
  "wl03-confirmed-create-001",
  "wl03-expected-create-001",
  "wl03-possible-create-001",
  "wl03-schedule-update-001",
  "wl03-schedule-pause-001",
  "wl03-schedule-resume-001",
  "wl03-occurrence-amount-001",
  "wl03-occurrence-date-001",
  "wl03-expense-001",
  "wl03-income-001",
  "wl03-cross-space-expense-001",
  "wl03-wrong-account-expense-001",
  "wl03-invalid-settlement-001",
  "wl03-cross-space-settlement-001",
  "wl03-wrong-account-settlement-001",
  "wl03-occurrence-settle-linked-001",
  "wl03-occurrence-skip-001",
  "wl03-occurrence-waive-001",
  "wl03-occurrence-cancel-001",
  "wl03-occurrence-settle-unlinked-001",
  "wl03-reconcile-income-001",
  "wl03-occurrence-reconcile-001",
  "wl03-unique-income-001",
  "wl03-unique-settle-expected-001",
  "wl03-unique-settle-possible-001",
  "wl03-monotonic-create-001",
  "wl03-monotonic-cancel-001",
  "wl03-cancel-boundary-create-001",
  "wl03-cancel-boundary-001",
  "wl03-race-create-001",
  "wl03-race-expense-001",
  "wl03-race-update-001",
  "wl03-race-settle-001",
  "wl03-race-cancel-001",
  "wl03-schedule-end-001",
  "wl03-paused-terminal-create-001",
  "wl03-paused-terminal-pause-001",
  "wl03-paused-terminal-end-001",
];

function rows(response: unknown): unknown[] {
  if (!Array.isArray(response)) return [];
  if (response.length === 1 && Array.isArray(response[0])) return response[0];
  return response;
}

async function main() {
  const config = YAML.parse(
    await readFile(
      new URL("../../schema/config/app.config.yaml", import.meta.url),
      "utf8",
    ),
  ) as LocalAppConfig;
  const database =
    config.databases.local ??
    config.databases[config.environment.defaultDatabase];
  if (!database)
    throw new Error("Local Raven database configuration is unavailable");
  const client = new Surreal();
  await client.connect(database.url);
  await client.signin({
    username: database.username,
    password: database.password,
  });
  await client.use({
    namespace: database.namespace,
    database: database.database,
  });
  const spaces = [SPACE, OTHER_SPACE];
  const cleanup = () =>
    client.query(
      `
    DELETE cashflowOccurrence WHERE space.key IN $spaces;
    DELETE cashflowSchedule WHERE space.key IN $spaces;
    DELETE accountBalanceSnapshot WHERE space.key IN $spaces;
    DELETE transaction WHERE space.key IN $spaces;
    DELETE financialOperation WHERE actorId = $actor OR idempotencyKey IN $operationKeys;
    DELETE category WHERE space.key IN $spaces;
    DELETE account WHERE space.key IN $spaces;
    DELETE financialSpace WHERE key IN $spaces;
  `,
      { spaces, actor: ACTOR, operationKeys },
    );
  const count = async (table: "transaction" | "accountBalanceSnapshot") =>
    rows(
      await client.query(
        `SELECT id FROM ${table} WHERE space.key IN $spaces;`,
        { spaces },
      ),
    ).length;
  const meta = (idempotencyKey: string) => ({
    idempotencyKey,
    channel: "system" as const,
    actorId: ACTOR,
  });

  try {
    await cleanup();
    await client.query(
      `
      CREATE ONLY type::record("financialSpace", $space) CONTENT {
        key: $space, name: "Workline 03 Fictional Space", spaceType: "personal", currency: "ZAR", active: true
      };
      CREATE ONLY type::record("financialSpace", $otherSpace) CONTENT {
        key: $otherSpace, name: "Workline 03 Other Fictional Space", spaceType: "personal", currency: "ZAR", active: true
      };
    `,
      { space: SPACE, otherSpace: OTHER_SPACE },
    );
    const service = createAccountControlService(
      createSurrealAccountControlRepository(client),
      () => new Date(NOW),
    );
    await service.createAccount({
      ...meta("wl03-account-create-001"),
      spaceKey: SPACE,
      accountKey: ACCOUNT,
      name: "Workline 03 Fictional Current",
      accountType: "current",
      currency: "ZAR",
      normalNature: "asset",
      liquidityClass: "liquid",
      freshnessWindowHours: 72,
    });
    await service.createAccount({
      ...meta("wl03-account-secondary-001"),
      spaceKey: SPACE,
      accountKey: SECOND_ACCOUNT,
      name: "Workline 03 Fictional Secondary",
      accountType: "current",
      currency: "ZAR",
      normalNature: "asset",
      liquidityClass: "liquid",
      freshnessWindowHours: 72,
    });
    await service.createAccount({
      ...meta("wl03-account-other-001"),
      spaceKey: OTHER_SPACE,
      accountKey: OTHER_ACCOUNT,
      name: "Workline 03 Other Fictional Current",
      accountType: "current",
      currency: "ZAR",
      normalNature: "asset",
      liquidityClass: "liquid",
      freshnessWindowHours: 72,
    });
    await client.query(
      `CREATE ONLY type::record("category", $category) CONTENT {
      space: type::record("financialSpace", $space), key: $category, name: "Fictional Rent",
      categoryKind: "expense", active: true
    };`,
      { space: SPACE, category: CATEGORY },
    );
    assert.equal(await count("transaction"), 0);
    assert.equal(await count("accountBalanceSnapshot"), 0);

    const createInput = {
      ...meta("wl03-schedule-create-001"),
      spaceKey: SPACE,
      accountKey: ACCOUNT,
      categoryKey: CATEGORY,
      title: "Fictional monthly rent",
      direction: "outflow" as const,
      certainty: "committed" as const,
      money: { currency: "ZAR", minorUnits: 1_250_000 },
      cadence: "monthly" as const,
      interval: 1,
      startDate: "2026-07-31",
      dayOfMonth: 31,
      timezone: "Africa/Johannesburg",
      materializeThrough: "2026-10-31",
    };
    const created = await service.createScheduledCashflow(createInput);
    const replay = await service.createScheduledCashflow(createInput);
    assert.equal(created.receipt.status, "applied");
    assert.equal(replay.receipt.status, "replayed");
    assert.deepEqual(
      created.occurrences.map((item) => item.scheduledDueOn),
      ["2026-07-31", "2026-08-31", "2026-09-30", "2026-10-31"],
    );
    await assert.rejects(
      service.createScheduledCashflow({
        ...createInput,
        title: "Changed fictional request",
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "IDEMPOTENCY_CONFLICT",
    );

    const confirmed = await service.createScheduledCashflow({
      ...meta("wl03-confirmed-create-001"),
      spaceKey: SPACE,
      accountKey: ACCOUNT,
      title: "Fictional confirmed receipt",
      direction: "inflow",
      certainty: "confirmed",
      money: { currency: "ZAR", minorUnits: 250_000 },
      cadence: "once",
      interval: 1,
      startDate: "2026-07-20",
      onceDueOn: "2026-07-20",
      timezone: "Africa/Johannesburg",
      materializeThrough: "2026-07-31",
    });
    const expected = await service.createScheduledCashflow({
      ...meta("wl03-expected-create-001"),
      spaceKey: SPACE,
      accountKey: ACCOUNT,
      title: "Fictional expected receipt",
      direction: "inflow",
      certainty: "expected",
      money: { currency: "ZAR", minorUnits: 125_000 },
      cadence: "once",
      interval: 1,
      startDate: "2026-08-15",
      onceDueOn: "2026-08-15",
      timezone: "Africa/Johannesburg",
      materializeThrough: "2026-08-31",
    });
    const possible = await service.createScheduledCashflow({
      ...meta("wl03-possible-create-001"),
      spaceKey: SPACE,
      accountKey: ACCOUNT,
      title: "Fictional possible receipt",
      direction: "inflow",
      certainty: "possible",
      money: { currency: "ZAR", minorUnits: 125_000 },
      cadence: "once",
      interval: 1,
      startDate: "2026-08-15",
      onceDueOn: "2026-08-15",
      timezone: "Africa/Johannesburg",
      materializeThrough: "2026-08-31",
    });
    const summary = await service.listUpcomingCashflows({
      from: "2026-07-01",
      through: "2026-10-31",
      spaceKeys: [SPACE],
      asOf: NOW,
    });
    assert.deepEqual(summary.summaries[0], {
      currency: "ZAR",
      committedOutflow: { currency: "ZAR", minorUnits: 5_000_000 },
      confirmedInflow: { currency: "ZAR", minorUnits: 250_000 },
      expectedInflow: { currency: "ZAR", minorUnits: 125_000 },
      possibleInflow: { currency: "ZAR", minorUnits: 125_000 },
      dueCount: 7,
      unreconciledCount: 0,
    });
    assert.equal("net" in summary.summaries[0]!, false);
    assert.equal(await count("transaction"), 0);
    assert.equal(await count("accountBalanceSnapshot"), 0);

    const pauseInput = {
      scheduleId: created.schedule.id,
      expectedRevision: 1,
      effectiveOn: "2026-08-01",
      note: "Fictional pause",
      ...meta("wl03-schedule-pause-001"),
    };
    const pauses = await Promise.all([
      service.pauseScheduledCashflow(pauseInput),
      service.pauseScheduledCashflow(pauseInput),
    ]);
    assert.deepEqual(pauses.map((item) => item.receipt.status).sort(), [
      "applied",
      "replayed",
    ]);
    const paused = pauses[0]!;
    const resumed = await service.resumeScheduledCashflow({
      scheduleId: created.schedule.id,
      expectedRevision: paused.schedule.revision,
      resumeOn: "2026-08-15",
      note: "Fictional resume",
      ...meta("wl03-schedule-resume-001"),
    });
    const updateInput = {
      scheduleId: created.schedule.id,
      expectedRevision: resumed.schedule.revision,
      effectiveFrom: "2026-09-01",
      money: { currency: "ZAR", minorUnits: 1_260_000 },
      ...meta("wl03-schedule-update-001"),
    };
    const updates = await Promise.all([
      service.updateScheduledCashflow(updateInput),
      service.updateScheduledCashflow(updateInput),
    ]);
    assert.deepEqual(updates.map((item) => item.receipt.status).sort(), [
      "applied",
      "replayed",
    ]);
    const updated = updates[0]!;
    assert.equal(
      updated.occurrences.find((item) => item.scheduledDueOn === "2026-08-31")
        ?.money.minorUnits,
      1_250_000,
    );
    assert.equal(
      updated.occurrences.find((item) => item.scheduledDueOn === "2026-09-30")
        ?.money.minorUnits,
      1_260_000,
    );

    const target = updated.occurrences.find(
      (item) => item.scheduledDueOn === "2026-07-31",
    )!;
    const amountInput = {
      occurrenceId: target.id,
      expectedRevision: target.revision,
      money: { currency: "ZAR", minorUnits: 1_300_000 },
      reason: "Fictional escalation",
      ...meta("wl03-occurrence-amount-001"),
    };
    const amounts = await Promise.all([
      service.overrideCashflowOccurrenceAmount(amountInput),
      service.overrideCashflowOccurrenceAmount(amountInput),
    ]);
    assert.deepEqual(amounts.map((item) => item.receipt.status).sort(), [
      "applied",
      "replayed",
    ]);
    const moved = await service.overrideCashflowOccurrenceDueDate({
      occurrenceId: target.id,
      expectedRevision: amounts[0]!.occurrence.revision,
      dueOn: "2026-08-02",
      reason: "Fictional timing change",
      ...meta("wl03-occurrence-date-001"),
    });

    const wrongEvidence = await service.recordIncome({
      ...meta("wl03-income-001"),
      spaceKey: SPACE,
      accountKey: ACCOUNT,
      money: { currency: "ZAR", minorUnits: 1_300_000 },
      postedAt: "2026-08-02",
      description: "Fictional wrong-direction evidence",
    });
    await assert.rejects(
      service.settleCashflowOccurrence({
        occurrenceId: target.id,
        expectedRevision: moved.occurrence.revision,
        settledAt: NOW,
        transactionId: wrongEvidence.entity.id,
        ...meta("wl03-invalid-settlement-001"),
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "INVALID_SETTLEMENT_TRANSACTION",
    );
    const crossSpaceEvidence = await service.recordExpense({
      ...meta("wl03-cross-space-expense-001"),
      spaceKey: OTHER_SPACE,
      accountKey: OTHER_ACCOUNT,
      money: { currency: "ZAR", minorUnits: 1_300_000 },
      postedAt: "2026-08-02",
      description: "Fictional cross-space evidence",
    });
    await assert.rejects(
      service.settleCashflowOccurrence({
        occurrenceId: target.id,
        expectedRevision: moved.occurrence.revision,
        settledAt: NOW,
        transactionId: crossSpaceEvidence.entity.id,
        ...meta("wl03-cross-space-settlement-001"),
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "INVALID_SETTLEMENT_TRANSACTION",
    );
    const wrongAccountEvidence = await service.recordExpense({
      ...meta("wl03-wrong-account-expense-001"),
      spaceKey: SPACE,
      accountKey: SECOND_ACCOUNT,
      money: { currency: "ZAR", minorUnits: 1_300_000 },
      postedAt: "2026-08-02",
      description: "Fictional wrong-account evidence",
    });
    await assert.rejects(
      service.settleCashflowOccurrence({
        occurrenceId: target.id,
        expectedRevision: moved.occurrence.revision,
        settledAt: NOW,
        transactionId: wrongAccountEvidence.entity.id,
        ...meta("wl03-wrong-account-settlement-001"),
      }),
      (error: unknown) =>
        error instanceof RavenDomainError &&
        error.code === "INVALID_SETTLEMENT_TRANSACTION",
    );

    const observed = await service.recordExpense({
      ...meta("wl03-expense-001"),
      spaceKey: SPACE,
      accountKey: ACCOUNT,
      money: { currency: "ZAR", minorUnits: 1_300_000 },
      postedAt: "2026-08-02",
      description: "Fictional matching evidence",
    });
    const observedBefore = await service.getTransaction({
      transactionId: observed.entity.id,
    });
    const settleInput = {
      occurrenceId: target.id,
      expectedRevision: moved.occurrence.revision,
      settledAt: NOW,
      transactionId: observed.entity.id,
      ...meta("wl03-occurrence-settle-linked-001"),
    };
    const settlements = await Promise.all([
      service.settleCashflowOccurrence(settleInput),
      service.settleCashflowOccurrence(settleInput),
    ]);
    assert.deepEqual(settlements.map((item) => item.receipt.status).sort(), [
      "applied",
      "replayed",
    ]);
    assert.ok(settlements.every((item) => item.occurrence.reconciled));
    assert.deepEqual(
      await service.getTransaction({ transactionId: observed.entity.id }),
      observedBefore,
    );

    const remaining = updated.occurrences
      .filter((item) => item.id !== target.id && item.status === "due")
      .sort((a, b) => a.scheduledDueOn.localeCompare(b.scheduledDueOn));
    await service.skipCashflowOccurrence({
      occurrenceId: remaining[0]!.id,
      expectedRevision: remaining[0]!.revision,
      ...meta("wl03-occurrence-skip-001"),
    });
    await service.waiveCashflowOccurrence({
      occurrenceId: remaining[1]!.id,
      expectedRevision: remaining[1]!.revision,
      ...meta("wl03-occurrence-waive-001"),
    });
    await service.cancelCashflowOccurrence({
      occurrenceId: remaining[2]!.id,
      expectedRevision: remaining[2]!.revision,
      ...meta("wl03-occurrence-cancel-001"),
    });

    const unlinked = await service.settleCashflowOccurrence({
      occurrenceId: confirmed.occurrences[0]!.id,
      expectedRevision: 1,
      settledAt: NOW,
      ...meta("wl03-occurrence-settle-unlinked-001"),
    });
    assert.deepEqual(unlinked.receipt.warnings, ["UNRECONCILED_SETTLEMENT"]);
    const reconciliationEvidence = await service.recordIncome({
      ...meta("wl03-reconcile-income-001"),
      spaceKey: SPACE,
      accountKey: ACCOUNT,
      money: { currency: "ZAR", minorUnits: 250_000 },
      postedAt: "2026-07-20",
      description: "Fictional reconciliation evidence",
    });
    const reconciled = await service.reconcileCashflowOccurrence({
      occurrenceId: confirmed.occurrences[0]!.id,
      expectedRevision: unlinked.occurrence.revision,
      transactionId: reconciliationEvidence.entity.id,
      ...meta("wl03-occurrence-reconcile-001"),
    });
    assert.equal(reconciled.occurrence.reconciled, true);

    const uniquenessEvidence = await service.recordIncome({
      ...meta("wl03-unique-income-001"),
      spaceKey: SPACE,
      accountKey: ACCOUNT,
      money: { currency: "ZAR", minorUnits: 125_000 },
      postedAt: "2026-08-15",
      description: "Fictional one-link evidence",
    });
    const uniqueResults = await Promise.allSettled([
      service.settleCashflowOccurrence({
        occurrenceId: expected.occurrences[0]!.id,
        expectedRevision: 1,
        settledAt: NOW,
        transactionId: uniquenessEvidence.entity.id,
        ...meta("wl03-unique-settle-expected-001"),
      }),
      service.settleCashflowOccurrence({
        occurrenceId: possible.occurrences[0]!.id,
        expectedRevision: 1,
        settledAt: NOW,
        transactionId: uniquenessEvidence.entity.id,
        ...meta("wl03-unique-settle-possible-001"),
      }),
    ]);
    assert.equal(
      uniqueResults.filter((result) => result.status === "fulfilled").length,
      1,
    );
    const uniqueFailure = uniqueResults.find(
      (result): result is PromiseRejectedResult => result.status === "rejected",
    );
    assert.ok(uniqueFailure?.reason instanceof RavenDomainError);
    assert.equal(
      uniqueFailure.reason.code,
      "OCCURRENCE_CONFLICT",
      uniqueFailure.reason.message,
    );
    assert.equal(
      rows(
        await client.query(
          'SELECT id FROM cashflowOccurrence WHERE transaction = type::record("transaction", $key);',
          { key: uniquenessEvidence.entity.id.replace(/^transaction:/, "") },
        ),
      ).length,
      1,
    );

    const monotonic = await service.createScheduledCashflow({
      ...meta("wl03-monotonic-create-001"),
      spaceKey: SPACE,
      title: "Fictional monotonic horizon",
      direction: "outflow",
      certainty: "committed",
      money: { currency: "ZAR", minorUnits: 10_000 },
      cadence: "monthly",
      interval: 1,
      startDate: "2026-07-01",
      dayOfMonth: 1,
      timezone: "Africa/Johannesburg",
      materializeThrough: "2026-08-01",
    });
    await service.listUpcomingCashflows({
      from: "2026-07-01",
      through: "2026-12-31",
      spaceKeys: [SPACE],
      asOf: NOW,
    });
    assert.equal(
      (await service.getCashflowSchedule({ scheduleId: monotonic.schedule.id }))
        .schedule.materializedThrough,
      "2026-12-31",
    );
    await service.listUpcomingCashflows({
      from: "2026-07-01",
      through: "2026-09-30",
      spaceKeys: [SPACE],
      asOf: NOW,
    });
    const monotonicDetail = await service.getCashflowSchedule({
      scheduleId: monotonic.schedule.id,
    });
    assert.equal(monotonicDetail.schedule.materializedThrough, "2026-12-31");
    await service.cancelScheduledCashflow({
      scheduleId: monotonic.schedule.id,
      expectedRevision: monotonicDetail.schedule.revision,
      effectiveOn: "2026-07-01",
      ...meta("wl03-monotonic-cancel-001"),
    });

    const cancelBoundary = await service.createScheduledCashflow({
      ...meta("wl03-cancel-boundary-create-001"),
      spaceKey: SPACE,
      title: "Fictional cancel boundary",
      direction: "outflow",
      certainty: "committed",
      money: { currency: "ZAR", minorUnits: 20_000 },
      cadence: "monthly",
      interval: 1,
      startDate: "2026-07-31",
      dayOfMonth: 31,
      timezone: "Africa/Johannesburg",
      materializeThrough: "2026-10-31",
    });
    const cancelled = await service.cancelScheduledCashflow({
      scheduleId: cancelBoundary.schedule.id,
      expectedRevision: 1,
      effectiveOn: "2026-09-30",
      note: "Fictional cancellation boundary",
      ...meta("wl03-cancel-boundary-001"),
    });
    assert.equal(
      cancelled.occurrences.find((item) => item.scheduledDueOn === "2026-08-31")
        ?.status,
      "due",
    );
    assert.equal(
      cancelled.occurrences.find((item) => item.scheduledDueOn === "2026-09-30")
        ?.status,
      "cancelled",
    );

    const pausedTerminal = await service.createScheduledCashflow({
      ...meta("wl03-paused-terminal-create-001"),
      spaceKey: SPACE,
      accountKey: ACCOUNT,
      title: "Fictional paused terminal schedule",
      direction: "outflow",
      certainty: "committed",
      money: { currency: "ZAR", minorUnits: 30_000 },
      cadence: "monthly",
      interval: 1,
      startDate: "2026-01-31",
      dayOfMonth: 31,
      timezone: "Africa/Johannesburg",
      materializeThrough: "2026-06-30",
    });
    const pausedTerminalPause = await service.pauseScheduledCashflow({
      scheduleId: pausedTerminal.schedule.id,
      expectedRevision: 1,
      effectiveOn: "2026-03-31",
      note: "Fictional terminal-gap pause",
      ...meta("wl03-paused-terminal-pause-001"),
    });
    const pausedTerminalEnd = await service.endScheduledCashflow({
      scheduleId: pausedTerminal.schedule.id,
      expectedRevision: pausedTerminalPause.schedule.revision,
      effectiveOn: "2026-05-31",
      note: "Fictional end from paused state",
      ...meta("wl03-paused-terminal-end-001"),
    });
    assert.equal(pausedTerminalEnd.schedule.status, "ended");
    assert.equal(pausedTerminalEnd.schedule.materializedThrough, "2026-06-30");
    assert.equal(
      pausedTerminalEnd.occurrences.some(
        (item) => item.status === "due" && item.scheduledDueOn > "2026-03-31",
      ),
      false,
    );
    assert.equal(
      pausedTerminalEnd.occurrences.find(
        (item) => item.scheduledDueOn === "2026-04-30",
      )?.statusReason,
      "Schedule paused before ending",
    );
    const beforePause = await service.getCashflowSchedule({
      scheduleId: pausedTerminal.schedule.id,
      asOf: "2026-03-30T21:59:59.000Z",
    });
    assert.equal(beforePause.schedule.configuredStatus, "ended");
    assert.equal(beforePause.schedule.effectiveStatus, "active");
    assert.deepEqual(beforePause.schedule.pendingTransition, {
      status: "paused",
      effectiveOn: "2026-03-31",
    });
    const insideGap = await service.getCashflowSchedule({
      scheduleId: pausedTerminal.schedule.id,
      asOf: "2026-04-30T10:00:00.000Z",
    });
    assert.equal(insideGap.schedule.effectiveStatus, "paused");
    assert.deepEqual(insideGap.schedule.pendingTransition, {
      status: "ended",
      effectiveOn: "2026-05-31",
    });
    const pausedGapUpcoming = await service.listUpcomingCashflows({
      from: "2026-04-01",
      through: "2026-06-30",
      spaceKeys: [SPACE],
      search: "Fictional paused terminal schedule",
      asOf: "2026-04-30T10:00:00.000Z",
    });
    assert.equal(pausedGapUpcoming.occurrences.length, 0);
    const persistedGapDue = rows(
      await client.query(
        `
      SELECT id FROM cashflowOccurrence
      WHERE schedule = type::record("cashflowSchedule", $scheduleKey)
        AND scheduledDueOn > "2026-03-31"
        AND status = "due";
    `,
        {
          scheduleKey: pausedTerminal.schedule.id.replace(
            /^cashflowSchedule:/,
            "",
          ),
        },
      ),
    );
    assert.equal(persistedGapDue.length, 0);

    const race = await service.createScheduledCashflow({
      ...meta("wl03-race-create-001"),
      spaceKey: SPACE,
      accountKey: ACCOUNT,
      title: "Fictional mutation race",
      direction: "outflow",
      certainty: "committed",
      money: { currency: "ZAR", minorUnits: 55_000 },
      cadence: "once",
      interval: 1,
      startDate: "2026-09-15",
      onceDueOn: "2026-09-15",
      timezone: "Africa/Johannesburg",
      materializeThrough: "2026-09-30",
    });
    const raceEvidence = await service.recordExpense({
      ...meta("wl03-race-expense-001"),
      spaceKey: SPACE,
      accountKey: ACCOUNT,
      money: { currency: "ZAR", minorUnits: 55_000 },
      postedAt: "2026-09-15",
      description: "Fictional race evidence",
    });
    const raceResults = await Promise.allSettled([
      service.updateScheduledCashflow({
        scheduleId: race.schedule.id,
        expectedRevision: 1,
        effectiveFrom: "2026-09-15",
        title: "Fictional mutation race revised",
        ...meta("wl03-race-update-001"),
      }),
      service.settleCashflowOccurrence({
        occurrenceId: race.occurrences[0]!.id,
        expectedRevision: 1,
        settledAt: NOW,
        transactionId: raceEvidence.entity.id,
        ...meta("wl03-race-settle-001"),
      }),
    ]);
    assert.equal(
      raceResults.filter((result) => result.status === "fulfilled").length,
      1,
    );
    const raceDetail = await service.getCashflowOccurrence({
      occurrenceId: race.occurrences[0]!.id,
    });
    assert.ok(
      raceDetail.occurrence.status === "settled" ||
        (raceDetail.occurrence.status === "due" &&
          raceDetail.occurrence.revision === 2),
    );
    const raceSchedule = await service.getCashflowSchedule({
      scheduleId: race.schedule.id,
    });
    await service.cancelScheduledCashflow({
      scheduleId: race.schedule.id,
      expectedRevision: raceSchedule.schedule.revision,
      effectiveOn: "2026-09-15",
      ...meta("wl03-race-cancel-001"),
    });

    const ended = await service.endScheduledCashflow({
      scheduleId: created.schedule.id,
      expectedRevision: updated.schedule.revision,
      effectiveOn: "2026-09-01",
      note: "Fictional end boundary",
      ...meta("wl03-schedule-end-001"),
    });
    assert.equal(ended.schedule.status, "ended");
    const upcoming = await service.listUpcomingCashflows({
      from: "2026-07-01",
      through: "2026-12-31",
      includeTerminal: true,
      spaceKeys: [SPACE],
      asOf: NOW,
    });
    assert.equal(
      upcoming.occurrences.find((item) => item.id === target.id)?.status,
      "settled",
    );
    assert.equal(
      upcoming.occurrences.find((item) => item.id === target.id)?.timing.group,
      "history",
    );
    assert.ok(
      upcoming.occurrences.some((item) => item.certainty === "expected"),
    );
    assert.equal(await count("transaction"), 7);
    assert.equal(await count("accountBalanceSnapshot"), 0);
    process.stdout.write(
      "Account Control Workline 03 live smoke: PASS (replay, paused-terminal lifecycle, materialization, races, settlement uniqueness, summaries, cleanup)\n",
    );
  } finally {
    await cleanup();
    assert.equal(await count("transaction"), 0);
    assert.equal(await count("accountBalanceSnapshot"), 0);
    await client.close();
  }
}

main().catch((error) => {
  process.stderr.write(
    `${error instanceof Error ? (error.stack ?? error.message) : String(error)}\n`,
  );
  process.exitCode = 1;
});
