import type {
  CashflowOccurrenceRecord,
  CashflowScheduleRecord,
  CashflowScheduleStatus,
} from "./contracts.js";

export type CashflowLifecycleTransition = Readonly<{
  status: CashflowScheduleStatus;
  effectiveOn: string;
}>;

export type CashflowLifecycleProjection = Readonly<{
  configuredStatus: CashflowScheduleStatus;
  effectiveStatus: CashflowScheduleStatus;
  pendingTransition: CashflowLifecycleTransition | null;
}>;

type DatedTransition = CashflowLifecycleTransition &
  Readonly<{ order: number }>;

export function projectCashflowScheduleLifecycle(
  schedule: Pick<
    CashflowScheduleRecord,
    "status" | "pausedOn" | "resumedOn" | "endedOn" | "cancelledOn"
  >,
  localAsOf: string,
): CashflowLifecycleProjection {
  const transitions: DatedTransition[] = [];
  if (schedule.resumedOn)
    transitions.push({
      status: "active",
      effectiveOn: schedule.resumedOn,
      order: 1,
    });
  if (schedule.pausedOn)
    transitions.push({
      status: "paused",
      effectiveOn: schedule.pausedOn,
      order: 2,
    });
  if (schedule.status === "ended" && schedule.endedOn) {
    transitions.push({
      status: "ended",
      effectiveOn: schedule.endedOn,
      order: 3,
    });
  }
  if (schedule.status === "cancelled" && schedule.cancelledOn) {
    transitions.push({
      status: "cancelled",
      effectiveOn: schedule.cancelledOn,
      order: 3,
    });
  }
  transitions.sort(
    (left, right) =>
      left.effectiveOn.localeCompare(right.effectiveOn) ||
      left.order - right.order,
  );

  // A retained resume date proves the immediately preceding state was paused,
  // even though resume clears pausedOn to keep one current lifecycle boundary.
  let effectiveStatus: CashflowScheduleStatus = schedule.resumedOn
    ? "paused"
    : "active";
  for (const transition of transitions) {
    if (transition.effectiveOn > localAsOf) break;
    effectiveStatus = transition.status;
  }

  const pending = transitions.find(
    (transition) => transition.effectiveOn > localAsOf,
  );
  return {
    configuredStatus: schedule.status,
    effectiveStatus,
    pendingTransition: pending
      ? { status: pending.status, effectiveOn: pending.effectiveOn }
      : null,
  };
}

export function isCashflowOccurrenceLifecycleEligible(
  schedule: Pick<
    CashflowScheduleRecord,
    "pausedOn" | "endedOn" | "cancelledOn"
  >,
  occurrence: Pick<CashflowOccurrenceRecord, "scheduledDueOn">,
): boolean {
  const dueOn = occurrence.scheduledDueOn;
  if (schedule.pausedOn && dueOn > schedule.pausedOn) return false;
  if (schedule.endedOn && dueOn > schedule.endedOn) return false;
  if (schedule.cancelledOn && dueOn >= schedule.cancelledOn) return false;
  return true;
}
