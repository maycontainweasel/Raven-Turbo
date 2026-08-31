import type {
  CashflowOccurrenceRecord,
  CashflowScheduleRecord,
  CashflowScheduleStatus,
} from "./contracts.js";
import type {
  CashflowOccurrenceDraft,
  CashflowOccurrencePatch,
  CashflowScheduleMutation,
  CashflowSchedulePatch,
} from "./repository.js";
import {
  addCalendarDays,
  generateRecurrenceDates,
  type RecurrenceSpec,
} from "./recurrence.js";

export type CashflowScheduleMutationMode =
  | "update"
  | "pause"
  | "resume"
  | "end"
  | "cancel";

export type CashflowSchedulePlanInput = Readonly<{
  current: CashflowScheduleRecord;
  occurrences: CashflowOccurrenceRecord[];
  mode: CashflowScheduleMutationMode;
  effectiveOn: string;
  proposedPatch: CashflowSchedulePatch;
  operationId: string;
  recordedAt: string;
}>;

export type CashflowSchedulePlan = Readonly<{
  next: CashflowScheduleRecord;
  mutation: CashflowScheduleMutation;
  affectedOccurrenceIds: string[];
}>;

export const CASHFLOW_SCHEDULE_TRANSITIONS: Readonly<
  Record<CashflowScheduleStatus, readonly CashflowScheduleMutationMode[]>
> = {
  active: ["update", "pause", "end", "cancel"],
  paused: ["update", "resume", "end", "cancel"],
  ended: [],
  cancelled: [],
};

function recurrence(
  schedule: Pick<
    CashflowScheduleRecord,
    | "cadence"
    | "interval"
    | "startDate"
    | "endDate"
    | "onceDueOn"
    | "dayOfWeek"
    | "dayOfMonth"
    | "monthOfYear"
    | "timezone"
  >,
): RecurrenceSpec {
  return {
    cadence: schedule.cadence,
    interval: schedule.interval,
    startDate: schedule.startDate,
    endDate: schedule.endDate,
    onceDueOn: schedule.onceDueOn,
    dayOfWeek: schedule.dayOfWeek,
    dayOfMonth: schedule.dayOfMonth,
    monthOfYear: schedule.monthOfYear,
    timezone: schedule.timezone,
  };
}

function occurrenceId(scheduleId: string, scheduledDueOn: string): string {
  return `cashflowOccurrence:${scheduleId}|${scheduledDueOn}`;
}

function occurrenceDraft(
  schedule: CashflowScheduleRecord,
  scheduledDueOn: string,
  operationId: string,
  recordedAt: string,
): CashflowOccurrenceDraft {
  return {
    scheduleId: schedule.id,
    spaceId: schedule.spaceId,
    spaceKey: schedule.spaceKey,
    accountId: schedule.accountId,
    accountKey: schedule.accountKey,
    categoryId: schedule.categoryId,
    categoryKey: schedule.categoryKey,
    categoryName: schedule.categoryName,
    scheduledDueOn,
    dueOn: scheduledDueOn,
    scheduleRevision: schedule.revision,
    revision: 1,
    title: schedule.title,
    direction: schedule.direction,
    certainty: schedule.certainty,
    cadence: schedule.cadence,
    scheduledAmountMinor: schedule.amountMinor,
    amountMinor: schedule.amountMinor,
    currency: schedule.currency,
    status: "due",
    settledAt: null,
    transactionId: null,
    overrideReason: null,
    statusReason: null,
    notes: null,
    lastOperationId: operationId,
    recordedAt,
    updatedAt: recordedAt,
  };
}

function termsPatch(
  occurrence: CashflowOccurrenceRecord,
  schedule: CashflowScheduleRecord,
  operationId: string,
  recordedAt: string,
): CashflowOccurrencePatch {
  return {
    accountId: schedule.accountId,
    accountKey: schedule.accountKey,
    categoryId: schedule.categoryId,
    categoryKey: schedule.categoryKey,
    categoryName: schedule.categoryName,
    scheduleRevision: schedule.revision,
    title: schedule.title,
    direction: schedule.direction,
    certainty: schedule.certainty,
    cadence: schedule.cadence,
    scheduledAmountMinor: schedule.amountMinor,
    amountMinor:
      occurrence.amountMinor !== occurrence.scheduledAmountMinor
        ? occurrence.amountMinor
        : schedule.amountMinor,
    currency: schedule.currency,
    revision: occurrence.revision + 1,
    lastOperationId: operationId,
    updatedAt: recordedAt,
  };
}

function cancellationPatch(
  occurrence: CashflowOccurrenceRecord,
  reason: string,
  operationId: string,
  recordedAt: string,
): CashflowOccurrencePatch {
  return {
    status: "cancelled",
    statusReason: reason,
    revision: occurrence.revision + 1,
    lastOperationId: operationId,
    updatedAt: recordedAt,
  };
}

export function planCashflowScheduleMutation(
  input: CashflowSchedulePlanInput,
): CashflowSchedulePlan {
  const { current, occurrences, mode, effectiveOn, operationId, recordedAt } =
    input;
  const boundary =
    current.materializedThrough ?? addCalendarDays(current.startDate, -1);
  let materializedThrough = boundary;
  const next = {
    ...current,
    ...input.proposedPatch,
    revision: current.revision + 1,
    lastOperationId: operationId,
    updatedAt: recordedAt,
  } as CashflowScheduleRecord;

  const byDate = new Map(
    occurrences.map((item) => [item.scheduledDueOn, item]),
  );
  const createByDate = new Map<string, CashflowOccurrenceDraft>();
  const patches = new Map<
    string,
    CashflowScheduleMutation["occurrencePatches"][number]
  >();

  const createDates = (
    schedule: CashflowScheduleRecord,
    from: string,
    through: string,
  ) => {
    if (from > through) return;
    for (const date of generateRecurrenceDates(
      recurrence(schedule),
      through,
      from,
    )) {
      if (!byDate.has(date) && !createByDate.has(date)) {
        createByDate.set(
          date,
          occurrenceDraft(schedule, date, operationId, recordedAt),
        );
      }
    }
  };
  const patchOccurrence = (
    occurrence: CashflowOccurrenceRecord,
    patch: CashflowOccurrencePatch,
  ) => {
    patches.set(occurrence.id, {
      occurrenceId: occurrence.id,
      expectedRevision: occurrence.revision,
      expectedStatus: occurrence.status,
      patch,
    });
  };

  if (mode === "update") {
    if (current.status === "active" && effectiveOn > boundary) {
      const oldThrough = addCalendarDays(effectiveOn, -1);
      const oldFrom = [
        addCalendarDays(boundary, 1),
        current.resumedOn ?? current.startDate,
        current.termsEffectiveFrom,
      ]
        .sort()
        .at(-1)!;
      createDates(current, oldFrom, oldThrough);
      materializedThrough = oldThrough;
    }
    const reconcileThrough = materializedThrough;
    const nextDates =
      effectiveOn <= reconcileThrough
        ? new Set(
            generateRecurrenceDates(
              recurrence(next),
              reconcileThrough,
              effectiveOn,
            ),
          )
        : new Set<string>();
    for (const date of nextDates) {
      const occurrence = byDate.get(date);
      if (!occurrence)
        createByDate.set(
          date,
          occurrenceDraft(next, date, operationId, recordedAt),
        );
      else if (occurrence.status === "due")
        patchOccurrence(
          occurrence,
          termsPatch(occurrence, next, operationId, recordedAt),
        );
    }
    for (const occurrence of occurrences) {
      if (
        occurrence.status === "due" &&
        occurrence.scheduledDueOn >= effectiveOn &&
        occurrence.scheduledDueOn <= reconcileThrough &&
        !nextDates.has(occurrence.scheduledDueOn)
      ) {
        patchOccurrence(
          occurrence,
          cancellationPatch(
            occurrence,
            "Schedule terms changed",
            operationId,
            recordedAt,
          ),
        );
      }
    }
  }

  if (mode === "pause") {
    if (effectiveOn > boundary) {
      const from = [
        addCalendarDays(boundary, 1),
        current.resumedOn ?? current.startDate,
        current.termsEffectiveFrom,
      ]
        .sort()
        .at(-1)!;
      createDates(current, from, effectiveOn);
      materializedThrough = effectiveOn;
    }
  }

  if (mode === "resume") {
    const resumeFrom = [effectiveOn, next.termsEffectiveFrom].sort().at(-1)!;
    const nextDates =
      resumeFrom <= boundary
        ? new Set(
            generateRecurrenceDates(recurrence(next), boundary, resumeFrom),
          )
        : new Set<string>();
    for (const occurrence of occurrences) {
      if (occurrence.status !== "due") continue;
      if (
        current.pausedOn &&
        occurrence.dueOn > current.pausedOn &&
        occurrence.dueOn < resumeFrom
      ) {
        patchOccurrence(
          occurrence,
          cancellationPatch(
            occurrence,
            "Schedule paused",
            operationId,
            recordedAt,
          ),
        );
      } else if (
        occurrence.scheduledDueOn >= resumeFrom &&
        occurrence.scheduledDueOn <= boundary
      ) {
        if (nextDates.has(occurrence.scheduledDueOn))
          patchOccurrence(
            occurrence,
            termsPatch(occurrence, next, operationId, recordedAt),
          );
        else
          patchOccurrence(
            occurrence,
            cancellationPatch(
              occurrence,
              "Schedule terms changed",
              operationId,
              recordedAt,
            ),
          );
      }
    }
    for (const date of nextDates) {
      if (!byDate.has(date))
        createByDate.set(
          date,
          occurrenceDraft(next, date, operationId, recordedAt),
        );
    }
  }

  if (mode === "end" || mode === "cancel") {
    const terminalReason =
      mode === "end" ? "Schedule ended" : "Schedule cancelled";
    const pauseBoundary = current.status === "paused" ? current.pausedOn : null;
    const createThrough =
      pauseBoundary && pauseBoundary < effectiveOn
        ? pauseBoundary
        : effectiveOn;
    if (createThrough > boundary) {
      const from = [
        addCalendarDays(boundary, 1),
        current.resumedOn ?? current.startDate,
        current.termsEffectiveFrom,
      ]
        .sort()
        .at(-1)!;
      createDates(current, from, createThrough);
    }
    // Advancing the processed horizon is monotonic even when a pause forbids
    // recurrence creation inside the paused-to-terminal gap.
    if (effectiveOn > boundary) materializedThrough = effectiveOn;
    const inclusive = mode === "cancel";
    for (const occurrence of occurrences) {
      if (occurrence.status !== "due") continue;
      const inPausedGap = Boolean(
        pauseBoundary && occurrence.scheduledDueOn > pauseBoundary,
      );
      const beyondTerminal = inclusive
        ? occurrence.scheduledDueOn >= effectiveOn
        : occurrence.scheduledDueOn > effectiveOn;
      if (!inPausedGap && !beyondTerminal) continue;
      const reason = inPausedGap
        ? mode === "end"
          ? "Schedule paused before ending"
          : "Schedule paused before cancellation"
        : terminalReason;
      patchOccurrence(
        occurrence,
        cancellationPatch(occurrence, reason, operationId, recordedAt),
      );
    }
    if (mode === "cancel") {
      for (const [date, draft] of createByDate) {
        if (draft.scheduledDueOn >= effectiveOn) {
          createByDate.set(date, {
            ...draft,
            status: "cancelled",
            statusReason: terminalReason,
          });
        }
      }
    }
  }

  const patch: CashflowSchedulePatch = {
    ...input.proposedPatch,
    revision: next.revision,
    materializedThrough:
      materializedThrough > boundary
        ? materializedThrough
        : current.materializedThrough,
    lastOperationId: operationId,
    updatedAt: recordedAt,
  };
  const createOccurrences = [...createByDate.values()].sort((left, right) =>
    left.scheduledDueOn.localeCompare(right.scheduledDueOn),
  );
  const occurrencePatches = [...patches.values()].sort((left, right) =>
    left.occurrenceId.localeCompare(right.occurrenceId),
  );
  const affectedOccurrenceIds = [
    ...occurrencePatches.map((item) => item.occurrenceId),
    ...createOccurrences.map((item) =>
      occurrenceId(current.id, item.scheduledDueOn),
    ),
  ];

  return {
    next: { ...next, materializedThrough: patch.materializedThrough ?? null },
    mutation: {
      scheduleId: current.id,
      expectedRevision: current.revision,
      expectedStatus: current.status,
      patch,
      createOccurrences,
      occurrencePatches,
    },
    affectedOccurrenceIds: [...new Set(affectedOccurrenceIds)],
  };
}
