import assert from "node:assert/strict";
import test from "node:test";
import type {
  CashflowOccurrenceRecord,
  CashflowScheduleRecord,
} from "./contracts.js";
import {
  isCashflowOccurrenceLifecycleEligible,
  projectCashflowScheduleLifecycle,
} from "./cashflow-lifecycle.js";

function schedule(
  overrides: Partial<CashflowScheduleRecord> = {},
): CashflowScheduleRecord {
  return {
    id: "cashflowSchedule:fictional",
    key: "fictional",
    spaceId: "financialSpace:fictional",
    spaceKey: "fictional",
    accountId: null,
    accountKey: null,
    categoryId: null,
    categoryKey: null,
    categoryName: null,
    title: "Fictional monthly schedule",
    direction: "outflow",
    certainty: "committed",
    amountMinor: 10_000,
    currency: "ZAR",
    timezone: "Africa/Johannesburg",
    cadence: "monthly",
    interval: 1,
    startDate: "2026-01-31",
    endDate: null,
    onceDueOn: null,
    dayOfWeek: null,
    dayOfMonth: 31,
    monthOfYear: null,
    status: "active",
    revision: 1,
    materializedThrough: "2026-06-30",
    termsEffectiveFrom: "2026-01-31",
    pausedOn: null,
    resumedOn: null,
    endedOn: null,
    cancelledOn: null,
    createdOperationId: "financialOperation:create",
    lastOperationId: "financialOperation:create",
    recordedAt: "2026-01-01T00:00:00.000Z",
    updatedAt: "2026-01-01T00:00:00.000Z",
    notes: null,
    ...overrides,
  };
}

function occurrence(
  scheduledDueOn: string,
): Pick<CashflowOccurrenceRecord, "scheduledDueOn"> {
  return { scheduledDueOn };
}

test("lifecycle projection separates configured, effective, and next pending status", () => {
  const futurePause = schedule({ status: "paused", pausedOn: "2026-03-31" });
  assert.deepEqual(
    projectCashflowScheduleLifecycle(futurePause, "2026-03-30"),
    {
      configuredStatus: "paused",
      effectiveStatus: "active",
      pendingTransition: { status: "paused", effectiveOn: "2026-03-31" },
    },
  );
  assert.deepEqual(
    projectCashflowScheduleLifecycle(futurePause, "2026-03-31"),
    {
      configuredStatus: "paused",
      effectiveStatus: "paused",
      pendingTransition: null,
    },
  );

  const futureEndFromPause = schedule({
    status: "ended",
    pausedOn: "2026-03-31",
    endedOn: "2026-05-31",
  });
  assert.deepEqual(
    projectCashflowScheduleLifecycle(futureEndFromPause, "2026-03-30"),
    {
      configuredStatus: "ended",
      effectiveStatus: "active",
      pendingTransition: { status: "paused", effectiveOn: "2026-03-31" },
    },
  );
  assert.deepEqual(
    projectCashflowScheduleLifecycle(futureEndFromPause, "2026-04-30"),
    {
      configuredStatus: "ended",
      effectiveStatus: "paused",
      pendingTransition: { status: "ended", effectiveOn: "2026-05-31" },
    },
  );
  assert.deepEqual(
    projectCashflowScheduleLifecycle(futureEndFromPause, "2026-05-31"),
    {
      configuredStatus: "ended",
      effectiveStatus: "ended",
      pendingTransition: null,
    },
  );
});

test("future resume remains effectively paused until its accepted date", () => {
  const futureResume = schedule({ status: "active", resumedOn: "2026-04-15" });
  assert.deepEqual(
    projectCashflowScheduleLifecycle(futureResume, "2026-04-14"),
    {
      configuredStatus: "active",
      effectiveStatus: "paused",
      pendingTransition: { status: "active", effectiveOn: "2026-04-15" },
    },
  );
  assert.equal(
    projectCashflowScheduleLifecycle(futureResume, "2026-04-15")
      .effectiveStatus,
    "active",
  );
});

test("occurrence eligibility respects pause, end, and inclusive cancellation boundaries", () => {
  const pausedThenEnded = schedule({
    status: "ended",
    pausedOn: "2026-03-31",
    endedOn: "2026-05-31",
  });
  assert.equal(
    isCashflowOccurrenceLifecycleEligible(
      pausedThenEnded,
      occurrence("2026-03-31"),
    ),
    true,
  );
  assert.equal(
    isCashflowOccurrenceLifecycleEligible(
      pausedThenEnded,
      occurrence("2026-04-30"),
    ),
    false,
  );

  const ended = schedule({ status: "ended", endedOn: "2026-05-31" });
  assert.equal(
    isCashflowOccurrenceLifecycleEligible(ended, occurrence("2026-05-31")),
    true,
  );
  assert.equal(
    isCashflowOccurrenceLifecycleEligible(ended, occurrence("2026-06-30")),
    false,
  );

  const cancelled = schedule({
    status: "cancelled",
    cancelledOn: "2026-05-31",
  });
  assert.equal(
    isCashflowOccurrenceLifecycleEligible(cancelled, occurrence("2026-04-30")),
    true,
  );
  assert.equal(
    isCashflowOccurrenceLifecycleEligible(cancelled, occurrence("2026-05-31")),
    false,
  );
});
