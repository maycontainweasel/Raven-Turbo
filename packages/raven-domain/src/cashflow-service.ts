import { createHash } from "node:crypto";
import type {
  AccountControlRepository,
  CashflowOccurrenceDraft,
  CashflowOccurrencePatch,
  CashflowScheduleDraft,
  CashflowSchedulePatch,
  OperationDraft,
} from "./repository.js";
import type {
  CashflowCertainty,
  CashflowDirection,
  CashflowOccurrenceRecord,
  CashflowOccurrenceView,
  CashflowScheduleRecord,
  CashflowScheduleView,
  CommandMeta,
  CommandReceipt,
  CreateScheduledCashflowInput,
  CreateScheduledCashflowOutput,
  FinancialOperationRecord,
  GetCashflowOccurrenceInput,
  GetCashflowOccurrenceOutput,
  GetCashflowScheduleInput,
  GetCashflowScheduleOutput,
  ListCashflowSchedulesInput,
  ListCashflowSchedulesOutput,
  ListUpcomingCashflowsInput,
  ListUpcomingCashflowsOutput,
  OccurrenceRevisionCommandInput,
  OverrideCashflowOccurrenceAmountInput,
  OverrideCashflowOccurrenceDueDateInput,
  ReconcileCashflowOccurrenceInput,
  ResumeScheduledCashflowInput,
  ScheduleRecurrenceInput,
  ScheduleRevisionCommandInput,
  SettleCashflowOccurrenceInput,
  UpdateCashflowOccurrenceOutput,
  UpdateScheduledCashflowInput,
  UpdateScheduledCashflowOutput,
} from "./contracts.js";
import { RavenDomainError, type RavenWarningCode } from "./errors.js";
import { addMoney, money, zeroMoney } from "./money.js";
import {
  addCalendarDays,
  calendarDayDistance,
  endOfMonth,
  generateRecurrenceDates,
  MAX_CASHFLOW_HORIZON_DAYS,
  parseFinancialDate,
  validateRecurrence,
  type RecurrenceSpec,
} from "./recurrence.js";
import {
  CASHFLOW_SCHEDULE_TRANSITIONS,
  planCashflowScheduleMutation,
  type CashflowScheduleMutationMode,
} from "./cashflow-planner.js";
import {
  isCashflowOccurrenceLifecycleEligible,
  projectCashflowScheduleLifecycle,
} from "./cashflow-lifecycle.js";
import { toTransactionView } from "./transaction.js";

type Clock = () => Date;
type CashflowRepository = AccountControlRepository &
  Required<
    Pick<
      AccountControlRepository,
      | "listCashflowSchedules"
      | "getCashflowSchedule"
      | "listCashflowOccurrences"
      | "getCashflowOccurrence"
      | "listOperationsForEntity"
      | "createCashflowScheduleWithOperation"
      | "mutateCashflowScheduleWithOperation"
      | "materializeCashflowOccurrences"
      | "mutateCashflowOccurrenceWithOperation"
    >
  >;

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

function hash(value: unknown): string {
  return createHash("sha256")
    .update(JSON.stringify(canonicalize(value)))
    .digest("hex");
}

function operationKey(command: string, idempotencyKey: string): string {
  return createHash("sha256")
    .update(`${command}\u0000${idempotencyKey}`)
    .digest("hex");
}

function validIntent(value: string): string {
  const key = value.trim();
  if (key.length < 8 || key.length > 128) {
    throw new RavenDomainError(
      "IDEMPOTENCY_CONFLICT",
      "Idempotency key must contain 8 to 128 characters",
    );
  }
  return key;
}

const CASHFLOW_TITLE_MAX = 160;
const CASHFLOW_NOTE_MAX = 500;
const CASHFLOW_SEARCH_MAX = 160;

function boundedText(
  value: string | null | undefined,
  label: string,
  maximum: number,
): string | undefined {
  const normalized = value?.trim() || undefined;
  if (normalized && normalized.length > maximum) {
    throw new RavenDomainError(
      "INVALID_RECURRENCE",
      `${label} cannot exceed ${maximum} characters`,
    );
  }
  return normalized;
}

function dateFromInstant(instant: string, timezone: string): string {
  const parts = new Intl.DateTimeFormat("en-CA", {
    timeZone: timezone,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(new Date(instant));
  const values = Object.fromEntries(
    parts.map((part) => [part.type, part.value]),
  );
  return `${values.year}-${values.month}-${values.day}`;
}

function validateInstant(value: string): string {
  if (!Number.isFinite(Date.parse(value)))
    throw new RavenDomainError(
      "INVALID_CASHFLOW_DATE_RANGE",
      "Settlement time must be an ISO instant",
    );
  return new Date(value).toISOString();
}

function scheduleId(spaceId: string, key: string): string {
  return `cashflowSchedule:${spaceId}|${key}`;
}

function occurrenceId(schedule: string, dueOn: string): string {
  return `cashflowOccurrence:${schedule}|${dueOn}`;
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

function recurrenceLabel(
  schedule: Pick<
    CashflowScheduleRecord,
    "cadence" | "interval" | "dayOfWeek" | "dayOfMonth" | "monthOfYear"
  >,
): string {
  const prefix = schedule.interval === 1 ? "" : `Every ${schedule.interval} `;
  if (schedule.cadence === "once") return "One-off";
  if (schedule.cadence === "weekly")
    return `${prefix}${schedule.interval === 1 ? "Weekly" : "weeks"} · weekday ${schedule.dayOfWeek}`;
  if (schedule.cadence === "monthly")
    return `${prefix}${schedule.interval === 1 ? "Monthly" : "months"} · day ${schedule.dayOfMonth}`;
  if (schedule.cadence === "quarterly")
    return `${prefix}${schedule.interval === 1 ? "Quarterly" : "quarters"} · day ${schedule.dayOfMonth}`;
  return `${prefix}${schedule.interval === 1 ? "Yearly" : "years"} · ${schedule.monthOfYear}/${schedule.dayOfMonth}`;
}

function eligibleDueOccurrences(
  schedule: CashflowScheduleRecord,
  occurrences: CashflowOccurrenceRecord[],
): CashflowOccurrenceRecord[] {
  return occurrences.filter(
    (occurrence) =>
      occurrence.status === "due" &&
      isCashflowOccurrenceLifecycleEligible(schedule, occurrence),
  );
}

function visibleScheduleOccurrences(
  schedule: CashflowScheduleRecord,
  occurrences: CashflowOccurrenceRecord[],
): CashflowOccurrenceRecord[] {
  return occurrences.filter(
    (occurrence) =>
      occurrence.status !== "due" ||
      isCashflowOccurrenceLifecycleEligible(schedule, occurrence),
  );
}

function toScheduleView(
  record: CashflowScheduleRecord,
  asOf: string,
  nextDueOn: string | null = null,
): CashflowScheduleView {
  const lifecycle = projectCashflowScheduleLifecycle(
    record,
    dateFromInstant(asOf, record.timezone),
  );
  return {
    id: record.id,
    key: record.key,
    spaceKey: record.spaceKey,
    account: record.accountKey
      ? { spaceKey: record.spaceKey, accountKey: record.accountKey }
      : null,
    category:
      record.categoryKey && record.categoryName
        ? { key: record.categoryKey, name: record.categoryName }
        : null,
    title: record.title,
    direction: record.direction,
    certainty: record.certainty,
    money: money(
      { currency: record.currency, minorUnits: record.amountMinor },
      { nonNegative: true },
    ),
    timezone: record.timezone,
    cadence: record.cadence,
    recurrenceLabel: recurrenceLabel(record),
    interval: record.interval,
    startDate: record.startDate,
    endDate: record.endDate ?? null,
    onceDueOn: record.onceDueOn ?? null,
    dayOfWeek: record.dayOfWeek ?? null,
    dayOfMonth: record.dayOfMonth ?? null,
    monthOfYear: record.monthOfYear ?? null,
    status: record.status,
    configuredStatus: lifecycle.configuredStatus,
    effectiveStatus: lifecycle.effectiveStatus,
    pendingTransition: lifecycle.pendingTransition,
    revision: record.revision,
    materializedThrough: record.materializedThrough ?? null,
    termsEffectiveFrom: record.termsEffectiveFrom,
    pausedOn: record.pausedOn ?? null,
    resumedOn: record.resumedOn ?? null,
    endedOn: record.endedOn ?? null,
    cancelledOn: record.cancelledOn ?? null,
    nextDueOn,
    createdOperationId: record.createdOperationId,
    lastOperationId: record.lastOperationId,
    recordedAt: record.recordedAt,
    updatedAt: record.updatedAt,
    notes: record.notes ?? null,
  };
}

function toOccurrenceView(
  record: CashflowOccurrenceRecord,
  schedule: CashflowScheduleRecord,
  asOf: string,
): CashflowOccurrenceView {
  const warnings: RavenWarningCode[] =
    record.status === "settled" && !record.transactionId
      ? ["UNRECONCILED_SETTLEMENT"]
      : [];
  const localToday = dateFromInstant(asOf, schedule.timezone);
  const timingGroup =
    record.status !== "due"
      ? "history"
      : record.dueOn < localToday
        ? "overdue"
        : record.dueOn === localToday
          ? "today"
          : record.dueOn <= addCalendarDays(localToday, 7)
            ? "next_seven_days"
            : record.dueOn <= endOfMonth(localToday)
              ? "later_this_month"
              : "later";
  return {
    id: record.id,
    scheduleId: record.scheduleId,
    spaceKey: record.spaceKey,
    account: record.accountKey
      ? { spaceKey: record.spaceKey, accountKey: record.accountKey }
      : null,
    category:
      record.categoryKey && record.categoryName
        ? { key: record.categoryKey, name: record.categoryName }
        : null,
    scheduledDueOn: record.scheduledDueOn,
    dueOn: record.dueOn,
    scheduleRevision: record.scheduleRevision,
    revision: record.revision,
    title: record.title,
    direction: record.direction,
    certainty: record.certainty,
    cadence: record.cadence,
    recurrenceLabel: recurrenceLabel(schedule),
    scheduledMoney: money(
      { currency: record.currency, minorUnits: record.scheduledAmountMinor },
      { nonNegative: true },
    ),
    money: money(
      { currency: record.currency, minorUnits: record.amountMinor },
      { nonNegative: true },
    ),
    status: record.status,
    overdue: timingGroup === "overdue",
    timing: { group: timingGroup, timezone: schedule.timezone, localToday },
    settledAt: record.settledAt ?? null,
    transactionId: record.transactionId ?? null,
    reconciled: Boolean(record.transactionId),
    overrideReason: record.overrideReason ?? null,
    statusReason: record.statusReason ?? null,
    notes: record.notes ?? null,
    lastOperationId: record.lastOperationId,
    recordedAt: record.recordedAt,
    updatedAt: record.updatedAt,
    warnings,
  };
}

function recurrence(
  record: Pick<
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
    cadence: record.cadence,
    interval: record.interval,
    startDate: record.startDate,
    endDate: record.endDate,
    onceDueOn: record.onceDueOn,
    dayOfWeek: record.dayOfWeek,
    dayOfMonth: record.dayOfMonth,
    monthOfYear: record.monthOfYear,
    timezone: record.timezone,
  };
}

function certainty(
  direction: CashflowDirection,
  value: CashflowCertainty,
): CashflowCertainty {
  if (direction === "outflow" && value !== "committed") {
    throw new RavenDomainError(
      "INVALID_CERTAINTY",
      "Outgoing cashflow certainty must be committed",
    );
  }
  if (direction === "inflow" && value === "committed") {
    throw new RavenDomainError(
      "INVALID_CERTAINTY",
      "Incoming cashflow certainty must be confirmed, expected, or possible",
    );
  }
  return value;
}

function boundedRange(from: string, through: string): void {
  parseFinancialDate(from);
  parseFinancialDate(through);
  if (from > through)
    throw new RavenDomainError(
      "INVALID_CASHFLOW_DATE_RANGE",
      "Cashflow from date must not exceed through date",
    );
  if (calendarDayDistance(from, through) > MAX_CASHFLOW_HORIZON_DAYS) {
    throw new RavenDomainError(
      "INVALID_CASHFLOW_DATE_RANGE",
      `Cashflow horizon cannot exceed ${MAX_CASHFLOW_HORIZON_DAYS} days`,
    );
  }
}

export class CashflowControlService {
  private readonly repository: CashflowRepository;

  constructor(
    repository: AccountControlRepository,
    private readonly clock: Clock,
  ) {
    this.repository = repository as CashflowRepository;
  }

  private now(value?: string): string {
    if (!value) return this.clock().toISOString();
    if (!Number.isFinite(Date.parse(value)))
      throw new RavenDomainError(
        "INVALID_CASHFLOW_DATE_RANGE",
        "asOf must be an ISO instant",
      );
    return new Date(value).toISOString();
  }

  private operation(
    command: FinancialOperationRecord["command"],
    meta: CommandMeta,
    request: unknown,
    warningCodes: RavenWarningCode[] = [],
    auditMeta: Record<string, unknown> = {},
    resultRefs: string[] = [],
  ): OperationDraft {
    const idempotencyKey = validIntent(meta.idempotencyKey);
    return {
      key: operationKey(command, idempotencyKey),
      command,
      idempotencyKey,
      requestHash: hash(request),
      channel: meta.channel,
      actorId: meta.actorId,
      recordedAt: this.clock().toISOString(),
      warningCodes,
      auditMeta,
      resultRefs,
    };
  }

  private async replay(
    command: FinancialOperationRecord["command"],
    meta: CommandMeta,
    request: unknown,
  ): Promise<FinancialOperationRecord | null> {
    const idempotencyKey = validIntent(meta.idempotencyKey);
    const existing = await this.repository.getOperation(
      command,
      idempotencyKey,
    );
    if (!existing) return null;
    if (existing.requestHash !== hash(request))
      throw new RavenDomainError(
        "IDEMPOTENCY_CONFLICT",
        "Idempotency key was used with different input",
      );
    return existing;
  }

  private async replaySchedule(
    operation: FinancialOperationRecord,
  ): Promise<UpdateScheduledCashflowOutput> {
    const schedule = operation.resultRefs[0]
      ? await this.repository.getCashflowSchedule(operation.resultRefs[0])
      : null;
    if (!schedule)
      throw new RavenDomainError(
        "INTERNAL",
        "Idempotent cashflow schedule result is missing",
      );
    const occurrences = await this.repository.listCashflowOccurrences({
      scheduleIds: [schedule.id],
    });
    const asOf = this.clock().toISOString();
    const visible = visibleScheduleOccurrences(schedule, occurrences);
    return {
      schedule: toScheduleView(
        schedule,
        asOf,
        eligibleDueOccurrences(schedule, occurrences).sort((a, b) =>
          a.dueOn.localeCompare(b.dueOn),
        )[0]?.dueOn ?? null,
      ),
      occurrences: visible.map((item) =>
        toOccurrenceView(item, schedule, asOf),
      ),
      receipt: receipt(operation, "replayed"),
    };
  }

  private async replayOccurrence(
    operation: FinancialOperationRecord,
  ): Promise<UpdateCashflowOccurrenceOutput> {
    const occurrence = operation.resultRefs[0]
      ? await this.repository.getCashflowOccurrence(operation.resultRefs[0])
      : null;
    if (!occurrence)
      throw new RavenDomainError(
        "INTERNAL",
        "Idempotent cashflow occurrence result is missing",
      );
    const schedule = await this.repository.getCashflowSchedule(
      occurrence.scheduleId,
    );
    if (!schedule)
      throw new RavenDomainError("INTERNAL", "Cashflow schedule is missing");
    return {
      occurrence: toOccurrenceView(
        occurrence,
        schedule,
        this.clock().toISOString(),
      ),
      receipt: receipt(operation, "replayed"),
    };
  }

  private occurrenceDraft(
    schedule: CashflowScheduleRecord | CashflowScheduleDraft,
    scheduledDueOn: string,
    operationId: string,
    recordedAt: string,
  ): CashflowOccurrenceDraft {
    return {
      scheduleId:
        "id" in schedule
          ? schedule.id
          : scheduleId(schedule.spaceId, schedule.key),
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

  private async validateScope(
    spaceKey: string,
    accountKey: string | null | undefined,
    categoryKey: string | null | undefined,
    direction: CashflowDirection,
    currency: string,
  ) {
    const spaces = await this.repository.listSpaces([spaceKey]);
    if (!spaces.some((space) => space.key === spaceKey))
      throw new RavenDomainError("NOT_FOUND", "Financial space not found");
    const account = accountKey
      ? await this.repository.getAccount(spaceKey, accountKey)
      : null;
    if (accountKey && (!account || !account.active))
      throw new RavenDomainError("NOT_FOUND", "Cashflow account not found");
    if (account && account.currency !== currency)
      throw new RavenDomainError(
        "CURRENCY_MISMATCH",
        "Cashflow account currency does not match",
      );
    const category = categoryKey
      ? await this.repository.getCategory(spaceKey, categoryKey)
      : null;
    const kinds =
      direction === "outflow"
        ? ["expense", "tax", "savings", "other"]
        : ["income", "other"];
    if (
      categoryKey &&
      (!category || !category.active || !kinds.includes(category.kind))
    ) {
      throw new RavenDomainError(
        "INVALID_CATEGORY",
        "Cashflow category is not active and direction-compatible",
      );
    }
    return { account, category };
  }

  async listCashflowSchedules(
    input: ListCashflowSchedulesInput,
  ): Promise<ListCashflowSchedulesOutput> {
    if (input.spaceKeys !== undefined && input.spaceKeys.length === 0) {
      return {
        schedules: [],
        meta: { asOf: this.now(input.asOf), quality: "complete", warnings: [] },
      };
    }
    const asOf = this.now(input.asOf);
    const records = (
      await this.repository.listCashflowSchedules({
        spaceKeys: input.spaceKeys,
        statuses: input.statuses,
      })
    )
      .filter(
        (item) =>
          !input.directions?.length ||
          input.directions.includes(item.direction),
      )
      .filter(
        (item) =>
          !input.certainties?.length ||
          input.certainties.includes(item.certainty),
      );
    const occurrences = await this.repository.listCashflowOccurrences({
      scheduleIds: records.map((item) => item.id),
      statuses: ["due"],
    });
    return {
      schedules: records.map((item) =>
        toScheduleView(
          item,
          asOf,
          eligibleDueOccurrences(
            item,
            occurrences.filter(
              (occurrence) => occurrence.scheduleId === item.id,
            ),
          ).sort((a, b) => a.dueOn.localeCompare(b.dueOn))[0]?.dueOn ?? null,
        ),
      ),
      meta: { asOf, quality: "complete", warnings: [] },
    };
  }

  async getCashflowSchedule(
    input: GetCashflowScheduleInput,
  ): Promise<GetCashflowScheduleOutput> {
    const schedule = await this.repository.getCashflowSchedule(
      input.scheduleId,
    );
    if (!schedule)
      throw new RavenDomainError("NOT_FOUND", "Cashflow schedule not found");
    const asOf = this.now(input.asOf);
    const persistedOccurrences = (
      await this.repository.listCashflowOccurrences({
        scheduleIds: [schedule.id],
        from: input.from,
        through: input.through,
      })
    ).sort(
      (a, b) => a.dueOn.localeCompare(b.dueOn) || a.id.localeCompare(b.id),
    );
    const occurrences = visibleScheduleOccurrences(
      schedule,
      persistedOccurrences,
    );
    const operations = await this.repository.listOperationsForEntity(
      schedule.id,
    );
    const occurrenceCounts = {
      due: occurrences.filter((item) => item.status === "due").length,
      settled: occurrences.filter((item) => item.status === "settled").length,
      skipped: occurrences.filter((item) => item.status === "skipped").length,
      waived: occurrences.filter((item) => item.status === "waived").length,
      cancelled: occurrences.filter((item) => item.status === "cancelled")
        .length,
    };
    return {
      schedule: toScheduleView(
        schedule,
        asOf,
        eligibleDueOccurrences(schedule, occurrences)[0]?.dueOn ?? null,
      ),
      occurrences: occurrences.map((item) =>
        toOccurrenceView(item, schedule, asOf),
      ),
      operation: await this.repository.getOperationById(
        schedule.lastOperationId,
      ),
      operations,
      occurrenceCounts,
      meta: {
        asOf,
        currency: schedule.currency,
        quality: "complete",
        warnings: [],
      },
    };
  }

  private async ensureScheduleMaterialized(
    schedule: CashflowScheduleRecord,
    through: string,
    attempt = 0,
  ): Promise<void> {
    if (
      schedule.status !== "active" ||
      (schedule.materializedThrough && schedule.materializedThrough >= through)
    )
      return;
    const boundary =
      schedule.materializedThrough ?? addCalendarDays(schedule.startDate, -1);
    const from = [
      addCalendarDays(boundary, 1),
      schedule.resumedOn ?? schedule.startDate,
      schedule.termsEffectiveFrom,
    ]
      .sort()
      .at(-1)!;
    const existing = await this.repository.listCashflowOccurrences({
      scheduleIds: [schedule.id],
    });
    const existingDates = new Set(existing.map((item) => item.scheduledDueOn));
    const dates = generateRecurrenceDates(recurrence(schedule), through, from);
    const drafts = dates
      .filter((date) => !existingDates.has(date))
      .map((date) =>
        this.occurrenceDraft(
          schedule,
          date,
          schedule.lastOperationId,
          this.clock().toISOString(),
        ),
      );
    try {
      await this.repository.materializeCashflowOccurrences(
        schedule.id,
        schedule.revision,
        through,
        drafts,
      );
    } catch (error) {
      if (
        attempt >= 2 ||
        !(error instanceof RavenDomainError) ||
        error.code !== "SCHEDULE_REVISION_CONFLICT"
      )
        throw error;
      const current = await this.repository.getCashflowSchedule(schedule.id);
      if (!current)
        throw new RavenDomainError("NOT_FOUND", "Cashflow schedule not found");
      await this.ensureScheduleMaterialized(current, through, attempt + 1);
    }
  }

  private async ensureMaterialized(
    schedules: CashflowScheduleRecord[],
    through: string,
  ): Promise<void> {
    for (const schedule of schedules) {
      await this.ensureScheduleMaterialized(schedule, through);
    }
  }

  async listUpcomingCashflows(
    input: ListUpcomingCashflowsInput,
  ): Promise<ListUpcomingCashflowsOutput> {
    boundedRange(input.from, input.through);
    const asOf = this.now(input.asOf);
    if (
      (input.spaceKeys !== undefined && input.spaceKeys.length === 0) ||
      (input.accountRefs !== undefined && input.accountRefs.length === 0)
    ) {
      return {
        occurrences: [],
        summaries: [],
        meta: { asOf, quality: "complete", warnings: [] },
      };
    }
    let accountIds: string[] | undefined;
    if (input.accountRefs) {
      const accounts = await Promise.all(
        input.accountRefs.map((ref) =>
          this.repository.getAccount(ref.spaceKey, ref.accountKey),
        ),
      );
      if (accounts.some((account) => !account))
        throw new RavenDomainError(
          "NOT_FOUND",
          "Cashflow account filter not found",
        );
      accountIds = accounts.map((account) => account!.id);
    }
    const initialSchedules = await this.repository.listCashflowSchedules({
      spaceKeys: input.spaceKeys,
    });
    await this.ensureMaterialized(initialSchedules, input.through);
    const schedules = await this.repository.listCashflowSchedules({
      spaceKeys: input.spaceKeys,
    });
    const scheduleMap = new Map(
      schedules.map((schedule) => [schedule.id, schedule]),
    );
    const defaultStatuses = input.includeTerminal
      ? undefined
      : ["due" as const];
    const search = boundedText(
      input.search,
      "Cashflow search",
      CASHFLOW_SEARCH_MAX,
    )?.toLocaleLowerCase();
    const records = (
      await this.repository.listCashflowOccurrences({
        scheduleIds: schedules.map((item) => item.id),
        spaceKeys: input.spaceKeys,
        statuses: input.statuses ?? defaultStatuses,
        from: input.from,
        through: input.through,
      })
    )
      .filter(
        (item) =>
          !input.directions?.length ||
          input.directions.includes(item.direction),
      )
      .filter(
        (item) =>
          !input.certainties?.length ||
          input.certainties.includes(item.certainty),
      )
      .filter(
        (item) =>
          !accountIds ||
          (item.accountId && accountIds.includes(item.accountId)),
      )
      .filter((item) => {
        const schedule = scheduleMap.get(item.scheduleId);
        return (
          item.status !== "due" ||
          Boolean(
            schedule && isCashflowOccurrenceLifecycleEligible(schedule, item),
          )
        );
      })
      .filter(
        (item) =>
          !search ||
          `${item.title} ${item.categoryName ?? ""}`
            .toLocaleLowerCase()
            .includes(search),
      )
      .sort(
        (left, right) =>
          left.dueOn.localeCompare(right.dueOn) ||
          left.direction.localeCompare(right.direction) ||
          left.title.localeCompare(right.title) ||
          left.id.localeCompare(right.id),
      );
    const views = records.map((item) => {
      const schedule = scheduleMap.get(item.scheduleId);
      if (!schedule)
        throw new RavenDomainError(
          "INTERNAL",
          "Cashflow occurrence schedule is missing",
        );
      return toOccurrenceView(item, schedule, asOf);
    });
    const warnings = [...new Set(views.flatMap((item) => item.warnings))];
    const currencies = [
      ...new Set(views.map((item) => item.money.currency)),
    ].sort();
    const summaries = currencies.map((currency) => {
      const matching = views.filter((item) => item.money.currency === currency);
      const sum = (predicate: (item: CashflowOccurrenceView) => boolean) =>
        matching
          .filter((item) => item.status === "due" && predicate(item))
          .reduce(
            (total, item) => addMoney(total, item.money),
            zeroMoney(currency),
          );
      return {
        currency,
        committedOutflow: sum(
          (item) =>
            item.direction === "outflow" && item.certainty === "committed",
        ),
        confirmedInflow: sum(
          (item) =>
            item.direction === "inflow" && item.certainty === "confirmed",
        ),
        expectedInflow: sum(
          (item) =>
            item.direction === "inflow" && item.certainty === "expected",
        ),
        possibleInflow: sum(
          (item) =>
            item.direction === "inflow" && item.certainty === "possible",
        ),
        dueCount: matching.filter((item) => item.status === "due").length,
        unreconciledCount: matching.filter(
          (item) => item.status === "settled" && !item.reconciled,
        ).length,
      };
    });
    return {
      occurrences: views,
      summaries,
      meta: {
        asOf,
        quality: warnings.length ? "partial" : "complete",
        warnings,
      },
    };
  }

  async getCashflowOccurrence(
    input: GetCashflowOccurrenceInput,
  ): Promise<GetCashflowOccurrenceOutput> {
    const record = await this.repository.getCashflowOccurrence(
      input.occurrenceId,
    );
    if (!record)
      throw new RavenDomainError("NOT_FOUND", "Cashflow occurrence not found");
    const schedule = await this.repository.getCashflowSchedule(
      record.scheduleId,
    );
    if (!schedule)
      throw new RavenDomainError("INTERNAL", "Cashflow schedule is missing");
    const asOf = this.now(input.asOf);
    const occurrence = toOccurrenceView(record, schedule, asOf);
    const transactions = await this.repository.listTransactions({
      accountIds: record.accountId ? [record.accountId] : undefined,
      month: record.dueOn.slice(0, 7),
    });
    const expectedKind = record.direction === "outflow" ? "expense" : "income";
    const expectedFlow = record.direction === "outflow" ? "outflow" : "inflow";
    const settlementCandidates = transactions
      .filter((item) => item.spaceId === record.spaceId)
      .filter(
        (item) => !record.accountId || item.accountId === record.accountId,
      )
      .filter(
        (item) =>
          item.status !== "ignored" &&
          item.kind === expectedKind &&
          item.flowDirection === expectedFlow,
      )
      .filter(
        (item) =>
          item.amountMinor === record.amountMinor &&
          item.currency === record.currency,
      )
      .filter(
        (item) =>
          item.postedAt !== null &&
          item.recordedAt !== null &&
          item.warnings.length === 0,
      )
      .map(toTransactionView)
      .slice(0, 50);
    const operations = await this.repository.listOperationsForEntity(record.id);
    return {
      occurrence,
      schedule: toScheduleView(schedule, asOf),
      operation: await this.repository.getOperationById(record.lastOperationId),
      operations,
      settlementCandidates,
      meta: {
        asOf,
        currency: record.currency,
        quality: occurrence.warnings.length ? "partial" : "complete",
        warnings: occurrence.warnings,
      },
    };
  }

  async createScheduledCashflow(
    input: CreateScheduledCashflowInput,
  ): Promise<CreateScheduledCashflowOutput> {
    const normalized = {
      ...input,
      idempotencyKey: validIntent(input.idempotencyKey),
      spaceKey: input.spaceKey.trim(),
      accountKey: input.accountKey?.trim() || undefined,
      categoryKey: input.categoryKey?.trim() || undefined,
      title:
        boundedText(input.title, "Cashflow title", CASHFLOW_TITLE_MAX) ?? "",
      certainty: certainty(input.direction, input.certainty),
      money: money(input.money, { nonNegative: true }),
      notes: boundedText(input.notes, "Cashflow notes", CASHFLOW_NOTE_MAX),
    };
    if (!normalized.title)
      throw new RavenDomainError(
        "INVALID_RECURRENCE",
        "Cashflow title is required",
      );
    if (normalized.money.minorUnits <= 0)
      throw new RavenDomainError(
        "INVALID_MONEY",
        "Cashflow amount must be positive",
      );
    boundedRange(normalized.startDate, normalized.materializeThrough);
    validateRecurrence(normalized);
    if (
      normalized.cadence === "once" &&
      normalized.onceDueOn! > normalized.materializeThrough
    ) {
      throw new RavenDomainError(
        "INVALID_CASHFLOW_DATE_RANGE",
        "One-off due date must fall within the initial materialization horizon",
      );
    }
    const existing = await this.replay(
      "create_scheduled_cashflow",
      normalized,
      normalized,
    );
    if (existing) return this.replaySchedule(existing);
    const { account, category } = await this.validateScope(
      normalized.spaceKey,
      normalized.accountKey,
      normalized.categoryKey,
      normalized.direction,
      normalized.money.currency,
    );
    const operation = this.operation(
      "create_scheduled_cashflow",
      normalized,
      normalized,
      [],
      {
        action: "create",
        materializeThrough: normalized.materializeThrough,
        note: normalized.notes ?? null,
      },
    );
    const spaceId = `financialSpace:${normalized.spaceKey}`;
    const key = createHash("sha256")
      .update(`${spaceId}\u0000${operation.key}`)
      .digest("hex");
    const id = scheduleId(spaceId, key);
    const draft: CashflowScheduleDraft = {
      key,
      spaceId,
      spaceKey: normalized.spaceKey,
      accountId: account?.id ?? null,
      accountKey: account?.key ?? null,
      categoryId: category?.id ?? null,
      categoryKey: category?.key ?? null,
      categoryName: category?.name ?? null,
      title: normalized.title,
      direction: normalized.direction,
      certainty: normalized.certainty,
      amountMinor: normalized.money.minorUnits,
      currency: normalized.money.currency,
      timezone: normalized.timezone,
      cadence: normalized.cadence,
      interval: normalized.interval,
      startDate: normalized.startDate,
      endDate: normalized.endDate ?? null,
      onceDueOn: normalized.onceDueOn ?? null,
      dayOfWeek: normalized.dayOfWeek ?? null,
      dayOfMonth: normalized.dayOfMonth ?? null,
      monthOfYear: normalized.monthOfYear ?? null,
      status: "active",
      revision: 1,
      materializedThrough: normalized.materializeThrough,
      termsEffectiveFrom: normalized.startDate,
      pausedOn: null,
      resumedOn: null,
      endedOn: null,
      cancelledOn: null,
      createdOperationId: `financialOperation:${operation.key}`,
      lastOperationId: `financialOperation:${operation.key}`,
      recordedAt: operation.recordedAt,
      updatedAt: operation.recordedAt,
      notes: normalized.notes ?? null,
    };
    const occurrences = generateRecurrenceDates(
      normalized,
      normalized.materializeThrough,
    ).map((date) =>
      this.occurrenceDraft(
        { ...draft, id },
        date,
        draft.lastOperationId,
        operation.recordedAt,
      ),
    );
    const appliedOperation: OperationDraft = {
      ...operation,
      resultRefs: [
        id,
        ...occurrences.map((item) => occurrenceId(id, item.scheduledDueOn)),
      ],
    };
    try {
      const applied = await this.repository.createCashflowScheduleWithOperation(
        draft,
        occurrences,
        appliedOperation,
      );
      return {
        schedule: toScheduleView(
          applied.schedule,
          operation.recordedAt,
          eligibleDueOccurrences(applied.schedule, applied.occurrences)[0]
            ?.dueOn ?? null,
        ),
        occurrences: applied.occurrences.map((item) =>
          toOccurrenceView(item, applied.schedule, operation.recordedAt),
        ),
        receipt: receipt(applied.operation, "applied"),
      };
    } catch (error) {
      const raced = await this.replay(
        "create_scheduled_cashflow",
        normalized,
        normalized,
      );
      if (!raced) throw error;
      return this.replaySchedule(raced);
    }
  }

  private async scheduleMutation(
    command: FinancialOperationRecord["command"],
    input:
      | ScheduleRevisionCommandInput
      | ResumeScheduledCashflowInput
      | UpdateScheduledCashflowInput,
    mode: CashflowScheduleMutationMode,
  ): Promise<UpdateScheduledCashflowOutput> {
    const normalized = {
      ...input,
      idempotencyKey: validIntent(input.idempotencyKey),
      ...("note" in input
        ? { note: boundedText(input.note, "Cashflow note", CASHFLOW_NOTE_MAX) }
        : {}),
      ...("notes" in input
        ? {
            notes: boundedText(
              input.notes,
              "Cashflow notes",
              CASHFLOW_NOTE_MAX,
            ),
          }
        : {}),
      ...("title" in input && input.title !== undefined
        ? {
            title: boundedText(
              input.title,
              "Cashflow title",
              CASHFLOW_TITLE_MAX,
            ),
          }
        : {}),
    };
    const replayed = await this.replay(command, normalized, normalized);
    if (replayed) return this.replaySchedule(replayed);
    try {
      const current = await this.repository.getCashflowSchedule(
        input.scheduleId,
      );
      if (!current)
        throw new RavenDomainError("NOT_FOUND", "Cashflow schedule not found");
      if (current.revision !== input.expectedRevision)
        throw new RavenDomainError(
          "SCHEDULE_REVISION_CONFLICT",
          "Cashflow schedule revision changed",
        );
      if (!CASHFLOW_SCHEDULE_TRANSITIONS[current.status].includes(mode)) {
        throw new RavenDomainError(
          "INVALID_SCHEDULE_TRANSITION",
          `Cannot ${mode} a ${current.status} cashflow schedule`,
        );
      }
      const effectiveOn =
        "effectiveFrom" in input
          ? input.effectiveFrom
          : "resumeOn" in input
            ? input.resumeOn
            : input.effectiveOn;
      parseFinancialDate(effectiveOn);
      boundedRange(current.startDate, effectiveOn);
      if (effectiveOn < current.startDate)
        throw new RavenDomainError(
          "INVALID_CASHFLOW_DATE_RANGE",
          "Schedule effective date precedes its start date",
        );
      if (mode === "update" && effectiveOn < current.termsEffectiveFrom) {
        throw new RavenDomainError(
          "INVALID_CASHFLOW_DATE_RANGE",
          "Schedule terms cannot be applied before the current terms authority boundary",
        );
      }
      const termsAndStartBoundary = [
        current.startDate,
        current.termsEffectiveFrom,
      ]
        .sort()
        .at(-1)!;
      const lifecycleBoundary = [
        termsAndStartBoundary,
        current.resumedOn,
        current.pausedOn,
      ]
        .filter((value): value is string => Boolean(value))
        .sort()
        .at(-1)!;
      if (
        mode === "pause" &&
        effectiveOn <
          [termsAndStartBoundary, current.resumedOn ?? termsAndStartBoundary]
            .sort()
            .at(-1)!
      ) {
        throw new RavenDomainError(
          "INVALID_CASHFLOW_DATE_RANGE",
          "Pause date precedes the current terms or latest resume authority boundary",
        );
      }
      if (
        mode === "resume" &&
        (!current.pausedOn ||
          effectiveOn <= current.pausedOn ||
          effectiveOn < current.termsEffectiveFrom)
      ) {
        throw new RavenDomainError(
          "INVALID_CASHFLOW_DATE_RANGE",
          "Resume date must follow the pause and current terms authority dates",
        );
      }
      if (
        (mode === "end" || mode === "cancel") &&
        effectiveOn < lifecycleBoundary
      ) {
        throw new RavenDomainError(
          "INVALID_CASHFLOW_DATE_RANGE",
          "Terminal date precedes the current terms or lifecycle authority boundary",
        );
      }

      const note = "note" in normalized ? normalized.note : undefined;
      const operation = this.operation(command, normalized, normalized, [], {
        action: mode,
        effectiveOn,
        note: note ?? null,
      });
      const operationId = `financialOperation:${operation.key}`;
      let proposedPatch: CashflowSchedulePatch = {};
      if (mode === "pause")
        proposedPatch = {
          status: "paused",
          pausedOn: effectiveOn,
          endedOn: null,
          cancelledOn: null,
        };
      if (mode === "resume")
        proposedPatch = {
          status: "active",
          resumedOn: effectiveOn,
          pausedOn: null,
          endedOn: null,
          cancelledOn: null,
        };
      if (mode === "end")
        proposedPatch = {
          status: "ended",
          endedOn: effectiveOn,
          cancelledOn: null,
          endDate:
            !current.endDate || effectiveOn < current.endDate
              ? effectiveOn
              : current.endDate,
        };
      if (mode === "cancel")
        proposedPatch = {
          status: "cancelled",
          cancelledOn: effectiveOn,
          endedOn: null,
        };
      if (mode === "update") {
        const update = normalized as UpdateScheduledCashflowInput;
        const direction = update.direction ?? current.direction;
        const nextMoney = update.money
          ? money(update.money, { nonNegative: true })
          : money({
              currency: current.currency,
              minorUnits: current.amountMinor,
            });
        if (nextMoney.currency !== current.currency) {
          throw new RavenDomainError(
            "UNSUPPORTED_CURRENCY",
            "Changing schedule currency is not supported in v0.1",
          );
        }
        if (nextMoney.minorUnits <= 0)
          throw new RavenDomainError(
            "INVALID_MONEY",
            "Cashflow amount must be positive",
          );
        const recurrenceInput: ScheduleRecurrenceInput = {
          cadence: update.cadence ?? current.cadence,
          interval: update.interval ?? current.interval,
          startDate: update.startDate ?? current.startDate,
          endDate: update.endDate ?? current.endDate ?? undefined,
          onceDueOn: update.onceDueOn ?? current.onceDueOn ?? undefined,
          dayOfWeek: update.dayOfWeek ?? current.dayOfWeek ?? undefined,
          dayOfMonth: update.dayOfMonth ?? current.dayOfMonth ?? undefined,
          monthOfYear: update.monthOfYear ?? current.monthOfYear ?? undefined,
          timezone: update.timezone ?? current.timezone,
        };
        validateRecurrence(recurrenceInput);
        const { account, category } = await this.validateScope(
          current.spaceKey,
          update.accountKey === null
            ? null
            : (update.accountKey ?? current.accountKey),
          update.categoryKey === null
            ? null
            : (update.categoryKey ?? current.categoryKey),
          direction,
          nextMoney.currency,
        );
        proposedPatch = {
          status: current.status,
          accountId: account?.id ?? null,
          accountKey: account?.key ?? null,
          categoryId: category?.id ?? null,
          categoryKey: category?.key ?? null,
          categoryName: category?.name ?? null,
          title: update.title || current.title,
          direction,
          certainty: certainty(
            direction,
            update.certainty ?? current.certainty,
          ),
          amountMinor: nextMoney.minorUnits,
          currency: current.currency,
          ...recurrenceInput,
          endDate: recurrenceInput.endDate ?? null,
          onceDueOn: recurrenceInput.onceDueOn ?? null,
          dayOfWeek: recurrenceInput.dayOfWeek ?? null,
          dayOfMonth: recurrenceInput.dayOfMonth ?? null,
          monthOfYear: recurrenceInput.monthOfYear ?? null,
          termsEffectiveFrom: effectiveOn,
          notes: update.notes ?? current.notes,
        };
      }
      const existing = await this.repository.listCashflowOccurrences({
        scheduleIds: [current.id],
      });
      const plan = planCashflowScheduleMutation({
        current,
        occurrences: existing,
        mode,
        effectiveOn,
        proposedPatch,
        operationId,
        recordedAt: operation.recordedAt,
      });
      const applied = await this.repository.mutateCashflowScheduleWithOperation(
        plan.mutation,
        {
          ...operation,
          resultRefs: [current.id, ...plan.affectedOccurrenceIds],
        },
      );
      const visible = visibleScheduleOccurrences(
        applied.schedule,
        applied.occurrences,
      );
      return {
        schedule: toScheduleView(
          applied.schedule,
          operation.recordedAt,
          eligibleDueOccurrences(applied.schedule, applied.occurrences)[0]
            ?.dueOn ?? null,
        ),
        occurrences: visible.map((item) =>
          toOccurrenceView(item, applied.schedule, operation.recordedAt),
        ),
        receipt: receipt(applied.operation, "applied"),
      };
    } catch (error) {
      const raced = await this.replay(command, normalized, normalized);
      if (raced) return this.replaySchedule(raced);
      throw error;
    }
  }

  updateScheduledCashflow(input: UpdateScheduledCashflowInput) {
    return this.scheduleMutation("update_scheduled_cashflow", input, "update");
  }
  pauseScheduledCashflow(input: ScheduleRevisionCommandInput) {
    return this.scheduleMutation("pause_scheduled_cashflow", input, "pause");
  }
  resumeScheduledCashflow(input: ResumeScheduledCashflowInput) {
    return this.scheduleMutation("resume_scheduled_cashflow", input, "resume");
  }
  endScheduledCashflow(input: ScheduleRevisionCommandInput) {
    return this.scheduleMutation("end_scheduled_cashflow", input, "end");
  }
  cancelScheduledCashflow(input: ScheduleRevisionCommandInput) {
    return this.scheduleMutation("cancel_scheduled_cashflow", input, "cancel");
  }

  private async validateSettlement(
    occurrence: CashflowOccurrenceRecord,
    transactionId: string,
  ): Promise<void> {
    const transaction = await this.repository.getTransaction(transactionId);
    if (
      !transaction ||
      transaction.status === "ignored" ||
      transaction.kind === "unresolved" ||
      transaction.kind === "transfer" ||
      transaction.amountMinor === null ||
      transaction.postedAt === null ||
      transaction.recordedAt === null ||
      transaction.warnings.length > 0
    ) {
      throw new RavenDomainError(
        "INVALID_SETTLEMENT_TRANSACTION",
        "Settlement transaction is not canonical observed money",
      );
    }
    const expectedKind =
      occurrence.direction === "outflow" ? "expense" : "income";
    const expectedFlow =
      occurrence.direction === "outflow" ? "outflow" : "inflow";
    if (
      transaction.kind !== expectedKind ||
      transaction.flowDirection !== expectedFlow ||
      transaction.currency !== occurrence.currency ||
      transaction.amountMinor !== occurrence.amountMinor ||
      transaction.spaceId !== occurrence.spaceId ||
      (occurrence.accountId && transaction.accountId !== occurrence.accountId)
    ) {
      throw new RavenDomainError(
        "INVALID_SETTLEMENT_TRANSACTION",
        "Settlement transaction does not match cashflow direction, money, Financial Space, or account",
      );
    }
  }

  private async occurrenceMutation(
    command: FinancialOperationRecord["command"],
    input:
      | OccurrenceRevisionCommandInput
      | SettleCashflowOccurrenceInput
      | ReconcileCashflowOccurrenceInput
      | OverrideCashflowOccurrenceAmountInput
      | OverrideCashflowOccurrenceDueDateInput,
    mode:
      | "settle"
      | "reconcile"
      | "skip"
      | "waive"
      | "cancel"
      | "amount"
      | "date",
  ): Promise<UpdateCashflowOccurrenceOutput> {
    const normalized = {
      ...input,
      idempotencyKey: validIntent(input.idempotencyKey),
      reason: boundedText(input.reason, "Cashflow reason", CASHFLOW_NOTE_MAX),
      note: boundedText(input.note, "Cashflow note", CASHFLOW_NOTE_MAX),
    };
    const replayed = await this.replay(command, normalized, normalized);
    if (replayed) return this.replayOccurrence(replayed);
    try {
      const current = await this.repository.getCashflowOccurrence(
        input.occurrenceId,
      );
      if (!current)
        throw new RavenDomainError(
          "NOT_FOUND",
          "Cashflow occurrence not found",
        );
      if (current.revision !== input.expectedRevision)
        throw new RavenDomainError(
          "OCCURRENCE_REVISION_CONFLICT",
          "Cashflow occurrence revision changed",
        );
      if (mode === "reconcile") {
        if (current.status !== "settled" || current.transactionId)
          throw new RavenDomainError(
            "INVALID_OCCURRENCE_TRANSITION",
            "Only an unlinked settled occurrence can be reconciled",
          );
      } else if (current.status !== "due") {
        if (current.status === "settled")
          throw new RavenDomainError(
            "OCCURRENCE_ALREADY_SETTLED",
            "Cashflow occurrence is already settled",
          );
        throw new RavenDomainError(
          "INVALID_OCCURRENCE_TRANSITION",
          "Terminal cashflow occurrence cannot be changed",
        );
      }
      const transactionId =
        "transactionId" in normalized ? normalized.transactionId : undefined;
      if (transactionId) await this.validateSettlement(current, transactionId);
      const warningCodes: RavenWarningCode[] =
        mode === "settle" && !transactionId ? ["UNRECONCILED_SETTLEMENT"] : [];
      const auditMeta: Record<string, unknown> = {
        action: mode,
        reason: normalized.reason ?? null,
        note: normalized.note ?? null,
      };
      const patch: CashflowOccurrencePatch = {
        revision: current.revision + 1,
        notes: normalized.note ?? current.notes,
      };
      if (mode === "settle") {
        const settledAt = validateInstant(
          (normalized as SettleCashflowOccurrenceInput).settledAt,
        );
        Object.assign(patch, {
          status: "settled",
          settledAt,
          transactionId: transactionId ?? null,
        });
        Object.assign(auditMeta, {
          settledAt,
          reconciliation: transactionId ? "linked" : "unreconciled",
        });
      }
      if (mode === "reconcile") {
        Object.assign(patch, { transactionId });
        Object.assign(auditMeta, { reconciliation: "linked" });
      }
      if (mode === "skip" || mode === "waive" || mode === "cancel") {
        Object.assign(patch, {
          status: mode === "cancel" ? "cancelled" : mode,
          statusReason: normalized.reason ?? null,
        });
      }
      if (mode === "amount") {
        const next = money(
          (normalized as OverrideCashflowOccurrenceAmountInput).money,
          { nonNegative: true },
        );
        if (next.currency !== current.currency || next.minorUnits <= 0)
          throw new RavenDomainError(
            "INVALID_MONEY",
            "Occurrence override must use matching positive money",
          );
        Object.assign(patch, {
          amountMinor: next.minorUnits,
          overrideReason: normalized.reason ?? "Amount override",
        });
        Object.assign(auditMeta, {
          previousAmountMinor: current.amountMinor,
          amountMinor: next.minorUnits,
          currency: next.currency,
        });
      }
      if (mode === "date") {
        const dueOn = (normalized as OverrideCashflowOccurrenceDueDateInput)
          .dueOn;
        parseFinancialDate(dueOn);
        Object.assign(patch, {
          dueOn,
          overrideReason: normalized.reason ?? "Due-date override",
        });
        Object.assign(auditMeta, { previousDueOn: current.dueOn, dueOn });
      }
      const operation = this.operation(
        command,
        normalized,
        normalized,
        warningCodes,
        auditMeta,
        [current.id],
      );
      Object.assign(patch, {
        lastOperationId: `financialOperation:${operation.key}`,
        updatedAt: operation.recordedAt,
      });
      const applied =
        await this.repository.mutateCashflowOccurrenceWithOperation(
          {
            occurrenceId: current.id,
            expectedRevision: current.revision,
            expectedStatus: current.status,
            patch,
            settlementTransactionId: transactionId,
          },
          operation,
        );
      const schedule = await this.repository.getCashflowSchedule(
        applied.occurrence.scheduleId,
      );
      if (!schedule)
        throw new RavenDomainError("INTERNAL", "Cashflow schedule is missing");
      return {
        occurrence: toOccurrenceView(
          applied.occurrence,
          schedule,
          operation.recordedAt,
        ),
        receipt: receipt(applied.operation, "applied"),
      };
    } catch (error) {
      const raced = await this.replay(command, normalized, normalized);
      if (raced) return this.replayOccurrence(raced);
      throw error;
    }
  }

  settleCashflowOccurrence(input: SettleCashflowOccurrenceInput) {
    return this.occurrenceMutation(
      "settle_cashflow_occurrence",
      input,
      "settle",
    );
  }
  reconcileCashflowOccurrence(input: ReconcileCashflowOccurrenceInput) {
    return this.occurrenceMutation(
      "reconcile_cashflow_occurrence",
      input,
      "reconcile",
    );
  }
  skipCashflowOccurrence(input: OccurrenceRevisionCommandInput) {
    return this.occurrenceMutation("skip_cashflow_occurrence", input, "skip");
  }
  waiveCashflowOccurrence(input: OccurrenceRevisionCommandInput) {
    return this.occurrenceMutation("waive_cashflow_occurrence", input, "waive");
  }
  cancelCashflowOccurrence(input: OccurrenceRevisionCommandInput) {
    return this.occurrenceMutation(
      "cancel_cashflow_occurrence",
      input,
      "cancel",
    );
  }
  overrideCashflowOccurrenceAmount(
    input: OverrideCashflowOccurrenceAmountInput,
  ) {
    return this.occurrenceMutation(
      "override_cashflow_occurrence_amount",
      input,
      "amount",
    );
  }
  overrideCashflowOccurrenceDueDate(
    input: OverrideCashflowOccurrenceDueDateInput,
  ) {
    return this.occurrenceMutation(
      "override_cashflow_occurrence_due_date",
      input,
      "date",
    );
  }
}
