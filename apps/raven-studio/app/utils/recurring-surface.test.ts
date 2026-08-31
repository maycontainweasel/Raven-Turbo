import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

test("Recurring exposes the canonical cashflow schedules as income and expense registers", async () => {
  const [page, column, layout] = await Promise.all([
    readFile(new URL("../pages/recurring.vue", import.meta.url), "utf8"),
    readFile(new URL("../components/RecurringScheduleColumn.vue", import.meta.url), "utf8"),
    readFile(new URL("../layouts/default.vue", import.meta.url), "utf8"),
  ]);

  assert.match(page, /api\.listCashflowSchedules\(/);
  assert.match(page, /schedule\.cadence === "once"/);
  assert.match(page, /schedule\.direction === "inflow"/);
  assert.match(page, /schedule\.direction === "outflow"/);
  assert.match(page, /openCommand\("create-expected-income"\)/);
  assert.match(page, /openCommand\("create-upcoming-payment"\)/);
  assert.match(page, /<CashflowScheduleDrawer/);
  assert.match(page, /grid-template-columns: minmax\(0, 1fr\) minmax\(0, 1fr\)/);
  assert.match(column, /schedule\.recurrenceLabel/);
  assert.match(column, /schedule\.nextDueOn/);
  assert.match(column, /schedule\.effectiveStatus/);
  assert.match(layout, /<NuxtLink to="\/recurring"> Recurring <\/NuxtLink>/);
});
