import {
  createCommandIntentRegistry,
  type CashflowScheduleView,
} from "@raven/domain";

export type CashflowScheduleAction =
  | "update-schedule"
  | "pause-schedule"
  | "resume-schedule"
  | "end-schedule"
  | "cancel-schedule";

const LIFECYCLE_ACTIONS: CashflowScheduleAction[] = [
  "pause-schedule",
  "resume-schedule",
  "end-schedule",
  "cancel-schedule",
];

export function createCashflowScheduleIntentManager(
  createKey: (action: string) => string = (action) =>
    `ui-${action}-${crypto.randomUUID()}`,
) {
  const registry = createCommandIntentRegistry(createKey);
  return {
    current: (action: CashflowScheduleAction) => registry.current(action),
    peek: (action: CashflowScheduleAction) => registry.peek(action),
    invalidateTerms: () => registry.clear("update-schedule"),
    invalidateLifecycle: () =>
      LIFECYCLE_ACTIONS.forEach((action) => registry.clear(action)),
    succeeded: (action: CashflowScheduleAction) => registry.clear(action),
    clearAll: () => registry.clearAll(),
  };
}

export function financialDateInTimezone(
  instant: string,
  timezone: string,
): string {
  const values = Object.fromEntries(
    new Intl.DateTimeFormat("en-CA", {
      timeZone: timezone,
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
    })
      .formatToParts(new Date(instant))
      .map((part) => [part.type, part.value]),
  );
  return `${values.year}-${values.month}-${values.day}`;
}

export function latestFinancialDate(
  ...values: Array<string | null | undefined>
): string {
  return (
    values
      .filter((value): value is string => Boolean(value))
      .sort()
      .at(-1) ?? ""
  );
}

export function scheduleLifecycleMinimum(
  schedule: Pick<
    CashflowScheduleView,
    "startDate" | "termsEffectiveFrom" | "pausedOn" | "resumedOn"
  >,
): string {
  return latestFinancialDate(
    schedule.startDate,
    schedule.termsEffectiveFrom,
    schedule.pausedOn,
    schedule.resumedOn,
  );
}
