import assert from "node:assert/strict";
import test from "node:test";
import {
  createCashflowScheduleIntentManager,
  financialDateInTimezone,
  latestFinancialDate,
  scheduleLifecycleMinimum,
} from "./cashflow-schedule-intents.js";

test("schedule actions keep distinct retry-stable intents", () => {
  let sequence = 0;
  const intents = createCashflowScheduleIntentManager(
    (action) => `${action}-${++sequence}`,
  );
  assert.equal(intents.current("pause-schedule"), "pause-schedule-1");
  assert.equal(intents.current("pause-schedule"), "pause-schedule-1");
  assert.equal(intents.current("end-schedule"), "end-schedule-2");
  assert.equal(intents.current("update-schedule"), "update-schedule-3");

  intents.invalidateTerms();
  assert.equal(intents.current("update-schedule"), "update-schedule-4");
  assert.equal(intents.peek("pause-schedule"), "pause-schedule-1");

  intents.invalidateLifecycle();
  assert.equal(intents.current("pause-schedule"), "pause-schedule-5");
  assert.equal(intents.current("end-schedule"), "end-schedule-6");
});

test("successful action rotation does not disturb other pending action intents", () => {
  let sequence = 0;
  const intents = createCashflowScheduleIntentManager(
    (action) => `${action}-${++sequence}`,
  );
  assert.equal(intents.current("cancel-schedule"), "cancel-schedule-1");
  assert.equal(intents.current("end-schedule"), "end-schedule-2");
  intents.succeeded("cancel-schedule");
  assert.equal(intents.current("cancel-schedule"), "cancel-schedule-3");
  assert.equal(intents.peek("end-schedule"), "end-schedule-2");
});

test("schedule timezone dates and lifecycle lower bounds are deterministic", () => {
  assert.equal(
    financialDateInTimezone("2026-03-30T22:00:00.000Z", "Africa/Johannesburg"),
    "2026-03-31",
  );
  assert.equal(
    latestFinancialDate("2026-01-31", null, "2026-03-31", "2026-02-01"),
    "2026-03-31",
  );
  assert.equal(
    scheduleLifecycleMinimum({
      startDate: "2026-01-31",
      termsEffectiveFrom: "2026-03-01",
      pausedOn: "2026-03-31",
      resumedOn: null,
    }),
    "2026-03-31",
  );
});
