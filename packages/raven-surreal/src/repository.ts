import {
  normalizeLegacyFinancialDate,
  parseDecimalMoney,
  RavenDomainError,
} from "@raven/domain";
import {
  type AccountControlRepository,
  type AccountRecord,
  type AccountTransferRecord,
  type BalanceSnapshotDraft,
  type BalanceSnapshotRecord,
  type CategoryKind,
  type CategoryRecord,
  type CashflowOccurrenceDraft,
  type CashflowOccurrenceMutation,
  type CashflowOccurrenceReadFilter,
  type CashflowOccurrenceRecord,
  type CashflowScheduleDraft,
  type CashflowScheduleMutation,
  type CashflowScheduleReadFilter,
  type CashflowScheduleRecord,
  type ClarificationSummary,
  type CreateAccountInput,
  type FinancialOperationRecord,
  type FinancialSpaceRecord,
  type FacilitySnapshotDraft,
  type FacilitySnapshotRecord,
  type FinancialAnalyticsRepository,
  type FinancialAnalyticsTransactionFilter,
  type OperationDraft,
  type TransactionDraft,
  type TransactionReadFilter,
  type TransactionRecord,
  type TransferDraft,
} from "@raven/domain/server";

export interface SurrealQueryClient {
  query(query: string, vars?: Record<string, unknown>): Promise<unknown>;
}

type Statement = {
  status?: string;
  result?: unknown;
  detail?: string;
  error?: unknown;
};

function statementError(statement: Statement): string {
  return (
    statement.detail ||
    (typeof statement.error === "string" ? statement.error : "") ||
    (statement.error == null ? "" : JSON.stringify(statement.error)) ||
    (typeof statement.result === "string" ? statement.result : "") ||
    (statement.result == null ? "" : JSON.stringify(statement.result)) ||
    JSON.stringify(statement)
  );
}

function unwrapResults(response: unknown): unknown[] {
  if (!Array.isArray(response)) return response == null ? [] : [response];
  const failures = response
    .filter((statement): statement is Statement =>
      Boolean(
        statement && typeof statement === "object" && "result" in statement,
      ),
    )
    .filter((statement) =>
      Boolean(statement.status && statement.status !== "OK"),
    );
  if (failures.length) {
    rethrowCashflowPersistenceError(
      new Error(failures.map(statementError).join("\n")),
    );
  }
  return response.map((statement) => {
    if (statement && typeof statement === "object" && "result" in statement) {
      const wrapped = statement as Statement;
      return wrapped.result;
    }
    return statement;
  });
}

function rows<T>(response: unknown): T[] {
  const values = unwrapResults(response);
  for (let index = values.length - 1; index >= 0; index -= 1) {
    const value = values[index];
    if (Array.isArray(value)) return value as T[];
    if (value && typeof value === "object") return [value as T];
  }
  return [];
}

function transactionResult<T extends object>(
  response: unknown,
  key: keyof T,
): T {
  const values = unwrapResults(response);
  for (let index = values.length - 1; index >= 0; index -= 1) {
    const value = values[index];
    const candidates = Array.isArray(value) ? value : [value];
    for (const candidate of candidates) {
      if (candidate && typeof candidate === "object" && key in candidate)
        return candidate as T;
    }
  }
  throw new RavenDomainError(
    "INTERNAL",
    "SurrealDB transaction result was missing",
  );
}

function rethrowAccountCreateError(error: unknown): never {
  const message = error instanceof Error ? error.message : String(error);
  if (/already exists|record.*exists|duplicate/i.test(message)) {
    throw new RavenDomainError(
      "ALREADY_EXISTS",
      "An account with this key already exists in the financial space",
    );
  }
  throw error;
}

function rethrowCashflowPersistenceError(error: unknown): never {
  const message = error instanceof Error ? error.message : String(error);
  if (message.includes("SCHEDULE_REVISION_CONFLICT")) {
    throw new RavenDomainError(
      "SCHEDULE_REVISION_CONFLICT",
      "Cashflow schedule revision changed",
    );
  }
  if (message.includes("OCCURRENCE_REVISION_CONFLICT")) {
    throw new RavenDomainError(
      "OCCURRENCE_REVISION_CONFLICT",
      "Cashflow occurrence revision changed",
    );
  }
  if (message.includes("INVALID_SCHEDULE_TRANSITION")) {
    throw new RavenDomainError(
      "INVALID_SCHEDULE_TRANSITION",
      "Cashflow schedule transition is not allowed",
    );
  }
  if (message.includes("INVALID_SETTLEMENT_TRANSACTION")) {
    throw new RavenDomainError(
      "INVALID_SETTLEMENT_TRANSACTION",
      "Settlement evidence is not canonical or does not match the occurrence",
    );
  }
  if (
    message.includes("OCCURRENCE_CONFLICT") ||
    /cashflow.*transaction.*unique|transaction.*already.*contains/i.test(
      message,
    )
  ) {
    throw new RavenDomainError(
      "OCCURRENCE_CONFLICT",
      "Cashflow occurrence changed or settlement evidence is already linked",
    );
  }
  throw new RavenDomainError("INTERNAL", message || "SurrealDB query failed");
}

async function cashflowQuery(
  client: SurrealQueryClient,
  query: string,
  vars?: Record<string, unknown>,
): Promise<unknown> {
  try {
    return await client.query(query, vars);
  } catch (error) {
    rethrowCashflowPersistenceError(error);
  }
}

function recordId(value: unknown): string {
  if (typeof value === "string")
    return value.replace(/^([^:]+):`([\s\S]*)`$/, "$1:$2");
  if (!value || typeof value !== "object") return String(value ?? "");
  const input = value as Record<string, unknown>;
  const table = input.tb ?? input.table;
  const tableName =
    typeof table === "string"
      ? table
      : (table as { name?: string } | undefined)?.name;
  const id = input.id;
  return tableName ? `${tableName}:${String(id ?? "")}` : String(id ?? "");
}

function recordKey(value: unknown): string {
  return recordId(value)
    .split(":")
    .slice(1)
    .join(":")
    .replace(/^`([\s\S]*)`$/, "$1");
}

function accountNature(
  accountType: string,
  value?: unknown,
): AccountRecord["normalNature"] {
  if (value === "asset" || value === "liability") return value;
  return ["credit_card", "loan", "debt"].includes(accountType)
    ? "liability"
    : "asset";
}

function liquidityClass(
  accountType: string,
  value?: unknown,
): AccountRecord["liquidityClass"] {
  if (value === "liquid" || value === "non_liquid") return value;
  return ["current", "savings", "cash"].includes(accountType)
    ? "liquid"
    : "non_liquid";
}

type RawAccount = Record<string, unknown>;
type RawSnapshot = Record<string, unknown>;
type RawFacilitySnapshot = Record<string, unknown>;
type RawOperation = Record<string, unknown>;
type RawTransaction = Record<string, unknown>;
type RawTransfer = Record<string, unknown>;
type RawCashflowSchedule = Record<string, unknown>;
type RawCashflowOccurrence = Record<string, unknown>;

function normalizeAccount(raw: RawAccount): AccountRecord {
  const accountType = String(raw.accountType ?? "other");
  const inferredFacilityKind =
    accountType === "credit_card"
      ? "credit_card"
      : accountType === "loan"
        ? "loan"
        : "none";
  return {
    id: recordId(raw.id),
    spaceId: recordId(raw.spaceId ?? raw.space),
    spaceKey: String(raw.spaceKey ?? ""),
    key: String(raw.key ?? ""),
    name: String(raw.name ?? ""),
    bankName: String(raw.bankName ?? ""),
    accountType,
    facilityKind: [
      "none",
      "credit_card",
      "overdraft",
      "revolving_credit",
      "loan",
      "other",
    ].includes(String(raw.facilityKind))
      ? (String(raw.facilityKind) as AccountRecord["facilityKind"])
      : inferredFacilityKind,
    currency: String(raw.currency ?? "ZAR").toUpperCase(),
    accountNumberLast4: raw.accountNumberLast4
      ? String(raw.accountNumberLast4)
      : null,
    normalNature: accountNature(accountType, raw.normalNature),
    liquidityClass: liquidityClass(accountType, raw.liquidityClass),
    freshnessWindowHours: Number.isSafeInteger(raw.freshnessWindowHours)
      ? Number(raw.freshnessWindowHours)
      : 72,
    active: raw.active !== false,
  };
}

function normalizeFacilitySnapshot(
  raw: RawFacilitySnapshot,
): FacilitySnapshotRecord {
  const optionalMinor = (flag: unknown, value: unknown) =>
    flag === true && Number.isSafeInteger(value) ? Number(value) : null;
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? ""),
    spaceId: recordId(raw.spaceId ?? raw.space),
    accountId: recordId(raw.accountId ?? raw.account),
    facilityKind:
      raw.facilityKind as FacilitySnapshotRecord["facilityKind"],
    currency: String(raw.currency ?? "ZAR").toUpperCase(),
    asOf: String(raw.asOf),
    effectiveFrom: raw.effectiveFrom ? String(raw.effectiveFrom) : null,
    recordedAt: String(raw.recordedAt),
    evidenceLevel:
      raw.evidenceLevel as FacilitySnapshotRecord["evidenceLevel"],
    sourceKind: raw.sourceKind as FacilitySnapshotRecord["sourceKind"],
    sourceRef: raw.sourceRef ? String(raw.sourceRef) : null,
    statementImportId: optionalRecordId(raw.statementImportId ?? raw.statementImport),
    facilityLimitMinor: optionalMinor(
      raw.hasFacilityLimit,
      raw.facilityLimitMinor,
    ),
    availableCreditMinor: optionalMinor(
      raw.hasAvailableCredit,
      raw.availableCreditMinor,
    ),
    minimumPaymentMinor: optionalMinor(
      raw.hasMinimumPayment,
      raw.minimumPaymentMinor,
    ),
    paymentDueOn: raw.paymentDueOn ? String(raw.paymentDueOn) : null,
    interestRates:
      raw.interestRates && typeof raw.interestRates === "object"
        ? (raw.interestRates as Record<string, unknown>)
        : {},
    feeTerms:
      raw.feeTerms && typeof raw.feeTerms === "object"
        ? (raw.feeTerms as Record<string, unknown>)
        : {},
    terms:
      raw.terms && typeof raw.terms === "object"
        ? (raw.terms as Record<string, unknown>)
        : {},
    operationId: optionalRecordId(raw.operationId ?? raw.operation),
    notes: raw.notes ? String(raw.notes) : null,
  };
}

function normalizeSnapshot(raw: RawSnapshot): BalanceSnapshotRecord {
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? ""),
    spaceId: recordId(raw.spaceId ?? raw.space),
    accountId: recordId(raw.accountId ?? raw.account),
    balanceKind: raw.balanceKind as BalanceSnapshotRecord["balanceKind"],
    amountMinor: Number(raw.amountMinor),
    currency: String(raw.currency ?? "ZAR").toUpperCase(),
    economicNature:
      raw.economicNature as BalanceSnapshotRecord["economicNature"],
    asOf: String(raw.asOf),
    recordedAt: String(raw.recordedAt),
    evidenceLevel: raw.evidenceLevel as BalanceSnapshotRecord["evidenceLevel"],
    sourceKind: raw.sourceKind as BalanceSnapshotRecord["sourceKind"],
    sourceRef: raw.sourceRef ? String(raw.sourceRef) : null,
    operationId: raw.operation ? recordId(raw.operation) : null,
    notes: raw.notes ? String(raw.notes) : null,
  };
}

function normalizeOperation(raw: RawOperation): FinancialOperationRecord {
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? ""),
    command: raw.command as FinancialOperationRecord["command"],
    idempotencyKey: String(raw.idempotencyKey ?? ""),
    requestHash: String(raw.requestHash ?? ""),
    channel: raw.channel as FinancialOperationRecord["channel"],
    actorId: raw.actorId ? String(raw.actorId) : null,
    status: raw.status as FinancialOperationRecord["status"],
    resultRefs: Array.isArray(raw.resultRefs)
      ? raw.resultRefs.map(recordId)
      : [],
    warningCodes: Array.isArray(raw.warningCodes)
      ? (raw.warningCodes.map(
          String,
        ) as FinancialOperationRecord["warningCodes"])
      : [],
    auditMeta:
      raw.auditMeta && typeof raw.auditMeta === "object"
        ? (raw.auditMeta as Record<string, unknown>)
        : {},
    recordedAt: String(raw.recordedAt),
    completedAt: raw.completedAt ? String(raw.completedAt) : null,
    failureCode: raw.failureCode ? String(raw.failureCode) : null,
  };
}

function nullableString(value: unknown): string | null {
  return value === null ||
    value === undefined ||
    value === "" ||
    value === "NONE"
    ? null
    : String(value);
}

function normalizeCashflowSchedule(
  raw: RawCashflowSchedule,
): CashflowScheduleRecord {
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? ""),
    spaceId: recordId(raw.space),
    spaceKey: String(raw.spaceKey ?? ""),
    accountId: optionalRecordId(raw.account),
    accountKey: nullableString(raw.accountKey),
    categoryId: optionalRecordId(raw.category),
    categoryKey: nullableString(raw.categoryKey),
    categoryName: nullableString(raw.categoryName),
    title: String(raw.title ?? ""),
    direction: raw.direction as CashflowScheduleRecord["direction"],
    certainty: raw.certainty as CashflowScheduleRecord["certainty"],
    amountMinor: Number(raw.amountMinor),
    currency: String(raw.currency ?? "ZAR").toUpperCase(),
    timezone: String(raw.timezone ?? "Africa/Johannesburg"),
    cadence: raw.cadence as CashflowScheduleRecord["cadence"],
    interval: Number(raw.interval),
    startDate: String(raw.startDate),
    endDate: nullableString(raw.endDate),
    onceDueOn: nullableString(raw.onceDueOn),
    dayOfWeek:
      raw.dayOfWeek === null || raw.dayOfWeek === undefined
        ? null
        : Number(raw.dayOfWeek),
    dayOfMonth:
      raw.dayOfMonth === null || raw.dayOfMonth === undefined
        ? null
        : Number(raw.dayOfMonth),
    monthOfYear:
      raw.monthOfYear === null || raw.monthOfYear === undefined
        ? null
        : Number(raw.monthOfYear),
    status: raw.status as CashflowScheduleRecord["status"],
    revision: Number(raw.revision),
    materializedThrough: nullableString(raw.materializedThrough),
    termsEffectiveFrom:
      nullableString(raw.termsEffectiveFrom) ?? String(raw.startDate),
    pausedOn: nullableString(raw.pausedOn),
    resumedOn: nullableString(raw.resumedOn),
    endedOn: nullableString(raw.endedOn),
    cancelledOn: nullableString(raw.cancelledOn),
    createdOperationId: recordId(raw.createdOperation),
    lastOperationId: recordId(raw.lastOperation),
    recordedAt: String(raw.recordedAt),
    updatedAt: String(raw.updatedAt),
    notes: nullableString(raw.notes),
  };
}

function normalizeCashflowOccurrence(
  raw: RawCashflowOccurrence,
): CashflowOccurrenceRecord {
  return {
    id: recordId(raw.id),
    scheduleId: recordId(raw.schedule),
    spaceId: recordId(raw.space),
    spaceKey: String(raw.spaceKey ?? ""),
    accountId: optionalRecordId(raw.account),
    accountKey: nullableString(raw.accountKey),
    categoryId: optionalRecordId(raw.category),
    categoryKey: nullableString(raw.categoryKey),
    categoryName: nullableString(raw.categoryName),
    scheduledDueOn: String(raw.scheduledDueOn),
    dueOn: String(raw.dueOn),
    scheduleRevision: Number(raw.scheduleRevision),
    revision: Number(raw.revision),
    title: String(raw.title ?? ""),
    direction: raw.direction as CashflowOccurrenceRecord["direction"],
    certainty: raw.certainty as CashflowOccurrenceRecord["certainty"],
    cadence: raw.cadence as CashflowOccurrenceRecord["cadence"],
    scheduledAmountMinor: Number(raw.scheduledAmountMinor),
    amountMinor: Number(raw.amountMinor),
    currency: String(raw.currency ?? "ZAR").toUpperCase(),
    status: raw.status as CashflowOccurrenceRecord["status"],
    settledAt: nullableString(raw.settledAt),
    transactionId: optionalRecordId(raw.transaction),
    overrideReason: nullableString(raw.overrideReason),
    statusReason: nullableString(raw.statusReason),
    notes: nullableString(raw.notes),
    lastOperationId: recordId(raw.lastOperation),
    recordedAt: String(raw.recordedAt),
    updatedAt: String(raw.updatedAt),
  };
}

const transactionKinds = new Set([
  "income",
  "expense",
  "transfer",
  "adjustment",
]);
const flowDirections = new Set(["inflow", "outflow"]);
const entrySources = new Set(["imported", "manual", "generated"]);
const transactionStatuses = new Set([
  "imported",
  "normalized",
  "matched",
  "classified",
  "clarified",
  "ignored",
]);
const categoryKinds = new Set([
  "income",
  "expense",
  "transfer",
  "tax",
  "savings",
  "other",
]);

function optionalRecordId(value: unknown): string | null {
  if (value === null || value === undefined || value === "" || value === "NONE")
    return null;
  const id = recordId(value);
  return id && id !== "[object Object]" ? id : null;
}

export function normalizeTransaction(raw: RawTransaction): TransactionRecord {
  const warnings = new Set<TransactionRecord["warnings"][number]>();
  const currency = String(raw.currency ?? "ZAR").toUpperCase();
  const postedAt = normalizeLegacyFinancialDate(raw.postedAt);
  if (!postedAt) warnings.add("TRANSACTION_DATE_INVALID");
  const effectiveAt = normalizeLegacyFinancialDate(raw.effectiveAt);
  if (raw.effectiveAt && !effectiveAt) warnings.add("TRANSACTION_DATE_INVALID");

  const canonicalAmount =
    typeof raw.amountMinor === "number" &&
    Number.isSafeInteger(raw.amountMinor) &&
    raw.amountMinor > 0
      ? raw.amountMinor
      : null;
  const canonicalKind = [...transactionKinds, "unresolved"].includes(
    String(raw.transactionKind),
  )
    ? (String(raw.transactionKind) as TransactionRecord["kind"])
    : null;
  const canonicalFlow = flowDirections.has(String(raw.flowDirection))
    ? (String(raw.flowDirection) as NonNullable<
        TransactionRecord["flowDirection"]
      >)
    : null;
  const canonicalEntrySource = entrySources.has(String(raw.entrySource))
    ? (String(raw.entrySource) as TransactionRecord["entrySource"])
    : null;
  const canonicalRecordedAt =
    raw.recordedAt && Number.isFinite(Date.parse(String(raw.recordedAt)))
      ? String(raw.recordedAt)
      : null;
  const legacyDirection = String(raw.direction ?? "");
  const legacyTransfer =
    raw.isTransfer === true || legacyDirection === "transfer";
  const coherentCanonicalSemantics =
    (canonicalKind === "income" && canonicalFlow === "inflow") ||
    (canonicalKind === "expense" && canonicalFlow === "outflow") ||
    (canonicalKind === "adjustment" && canonicalFlow !== null) ||
    (canonicalKind === "transfer" && canonicalFlow !== null) ||
    (canonicalKind === "transfer" &&
      canonicalFlow === null &&
      canonicalEntrySource === "imported" &&
      legacyTransfer) ||
    (canonicalKind === "unresolved" && canonicalFlow === null);
  const canonicalComplete =
    canonicalAmount !== null &&
    postedAt !== null &&
    canonicalEntrySource !== null &&
    canonicalRecordedAt !== null &&
    coherentCanonicalSemantics;
  const oldGeneratedSentinel =
    raw.amountMinor === 0 &&
    raw.transactionKind === "expense" &&
    raw.flowDirection === "outflow" &&
    raw.entrySource === "imported" &&
    !canonicalRecordedAt;
  const hasPartialCanonicalEvidence =
    !oldGeneratedSentinel &&
    !canonicalComplete &&
    (canonicalAmount !== null ||
      canonicalKind !== null ||
      canonicalFlow !== null ||
      canonicalEntrySource !== null ||
      canonicalRecordedAt !== null);
  if (hasPartialCanonicalEvidence)
    warnings.add("PARTIAL_CANONICAL_TRANSACTION");

  let legacyAmount: number | null = null;
  if (!canonicalComplete) {
    try {
      const legacy = parseDecimalMoney(String(raw.amount ?? ""), currency);
      const magnitude = Math.abs(legacy.minorUnits);
      if (!Number.isSafeInteger(magnitude) || magnitude <= 0)
        throw new Error("invalid legacy magnitude");
      legacyAmount = magnitude;
      warnings.add("LEGACY_MONEY_FALLBACK");
    } catch {
      warnings.add("LEGACY_TRANSACTION_INVALID");
    }
  }

  let kind: TransactionRecord["kind"];
  let flowDirection: TransactionRecord["flowDirection"];
  if (canonicalComplete) {
    kind = canonicalKind!;
    flowDirection = canonicalFlow;
    const legacyKind =
      legacyDirection === "credit"
        ? "income"
        : legacyDirection === "debit"
          ? "expense"
          : legacyDirection === "transfer"
            ? "transfer"
            : null;
    const legacyFlow =
      legacyDirection === "credit"
        ? "inflow"
        : legacyDirection === "debit"
          ? "outflow"
          : null;
    if (
      legacyKind &&
      (legacyKind !== kind || (legacyFlow && legacyFlow !== flowDirection))
    ) {
      warnings.add("CANONICAL_LEGACY_CONFLICT");
    }
  } else if (legacyTransfer) {
    kind = "transfer";
    flowDirection = null;
    warnings.add("LEGACY_TRANSFER_AMBIGUOUS");
  } else if (legacyDirection === "credit") {
    kind = "income";
    flowDirection = "inflow";
  } else if (legacyDirection === "debit") {
    kind = "expense";
    flowDirection = "outflow";
  } else {
    kind = "unresolved";
    flowDirection = null;
    warnings.add("TRANSACTION_SEMANTICS_UNRESOLVED");
    warnings.add("LEGACY_TRANSACTION_INVALID");
  }
  if (kind === "transfer" && flowDirection === null)
    warnings.add("LEGACY_TRANSFER_AMBIGUOUS");
  if (kind === "unresolved") warnings.add("TRANSACTION_SEMANTICS_UNRESOLVED");

  const categoryKind = categoryKinds.has(String(raw.categoryKind))
    ? (String(raw.categoryKind) as CategoryKind)
    : null;
  const statementMatchId = optionalRecordId(
    raw.statementMatchId ?? raw.statementMatch,
  );
  const statementMatchState = raw.statementMatchState
    ? String(raw.statementMatchState)
    : null;
  const statementMatchSourceState = raw.statementMatchSourceState
    ? String(raw.statementMatchSourceState)
    : null;
  const statementImportSourceState = raw.statementImportSourceState
    ? String(raw.statementImportSourceState)
    : null;
  const hasActiveStatementClaim =
    raw.hasActiveStatementClaim === true ||
    (Boolean(statementMatchId) &&
      statementMatchState === "confirmed" &&
      statementMatchSourceState === "committed" &&
      statementImportSourceState === "committed");
  const hasCanonicalStatementMatchHistory =
    raw.hasCanonicalStatementMatchHistory === true ||
    (Boolean(statementMatchId) &&
      (statementMatchState === "confirmed" ||
        statementMatchState === "superseded") &&
      (statementMatchSourceState === "committed" ||
        statementMatchSourceState === "superseded"));
  const entrySource = canonicalComplete ? canonicalEntrySource! : "imported";
  const sourceRowId = optionalRecordId(raw.sourceRowId ?? raw.sourceRow);
  let reportedBalanceMinor: number | null = null;
  if (sourceRowId) {
    if (
      typeof raw.sourceReportedBalanceMinor === "number" &&
      Number.isSafeInteger(raw.sourceReportedBalanceMinor)
    ) {
      reportedBalanceMinor = raw.sourceReportedBalanceMinor;
    } else {
      const legacyReportedBalance =
        raw.sourceLegacyBalance ?? raw.transactionLegacyBalance;
      if (
        legacyReportedBalance !== null &&
        legacyReportedBalance !== undefined &&
        legacyReportedBalance !== ""
      ) {
        try {
          reportedBalanceMinor = parseDecimalMoney(
            String(legacyReportedBalance),
            currency,
          ).minorUnits;
        } catch {
          reportedBalanceMinor = null;
        }
      }
    }
  }
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? recordId(raw.id).split(":").slice(1).join(":")),
    spaceId: recordId(raw.spaceId ?? raw.space),
    spaceKey: String(raw.spaceKey ?? ""),
    accountId: recordId(raw.accountId ?? raw.account),
    accountKey: String(raw.accountKey ?? ""),
    postedAt,
    effectiveAt,
    recordedAt: canonicalComplete
      ? canonicalRecordedAt
      : raw.recordedAt
        ? String(raw.recordedAt)
        : null,
    description: String(raw.description ?? ""),
    amountMinor: canonicalComplete ? canonicalAmount : legacyAmount,
    reportedBalanceMinor,
    currency,
    kind,
    flowDirection,
    entrySource,
    status: transactionStatuses.has(String(raw.status))
      ? (String(raw.status) as TransactionRecord["status"])
      : "imported",
    categoryId: optionalRecordId(raw.categoryId ?? raw.category),
    categoryKey: raw.categoryKey ? String(raw.categoryKey) : null,
    categoryName: raw.categoryName ? String(raw.categoryName) : null,
    categoryKind,
    merchantName: raw.merchantName ? String(raw.merchantName) : null,
    notes: raw.notes ? String(raw.notes) : null,
    sourceRowId,
    statementMatchId,
    statementImportId: optionalRecordId(
      raw.statementImportId ?? raw.statementMatchImport,
    ),
    statementMatchState,
    statementMatchSourceState,
    statementImportSourceState,
    hasActiveStatementClaim,
    hasCanonicalStatementMatchHistory,
    ledgerAuthority: hasActiveStatementClaim
      ? "active"
      : entrySource === "imported" && sourceRowId
        ? hasCanonicalStatementMatchHistory
          ? "canonical_historical_superseded"
          : "legacy_unreconciled"
        : "active",
    operationId: optionalRecordId(raw.operationId ?? raw.operation),
    transferId: optionalRecordId(raw.transferId ?? raw.transfer),
    warnings: [...warnings],
  };
}

function normalizeCategory(raw: Record<string, unknown>): CategoryRecord {
  return {
    id: recordId(raw.id),
    spaceId: recordId(raw.spaceId ?? raw.space),
    spaceKey: String(raw.spaceKey ?? ""),
    key: String(raw.key ?? ""),
    name: String(raw.name ?? ""),
    kind: raw.categoryKind as CategoryKind,
    parentId: optionalRecordId(raw.parentId ?? raw.parentCategory),
    parentKey: raw.parentKey ? String(raw.parentKey) : null,
    parentName: raw.parentName ? String(raw.parentName) : null,
    active: raw.active !== false,
  };
}

function normalizeTransfer(raw: RawTransfer): AccountTransferRecord {
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? ""),
    source: {
      accountId: recordId(raw.sourceAccount),
      spaceKey: String(raw.sourceSpaceKey ?? ""),
      accountKey: String(raw.sourceAccountKey ?? ""),
    },
    target: {
      accountId: recordId(raw.targetAccount),
      spaceKey: String(raw.targetSpaceKey ?? ""),
      accountKey: String(raw.targetAccountKey ?? ""),
    },
    amountMinor: Number(raw.amountMinor),
    currency: String(raw.currency ?? "ZAR").toUpperCase(),
    postedAt: String(raw.postedAt),
    description: raw.description ? String(raw.description) : null,
    sourceTransactionId: recordId(raw.sourceTransaction),
    targetTransactionId: recordId(raw.targetTransaction),
    operationId: recordId(raw.operation),
    recordedAt: String(raw.recordedAt),
  };
}

function nextMonth(month: string): string {
  const [year, value] = month.split("-").map(Number);
  const safeYear = year ?? 0;
  const safeValue = value ?? 0;
  return safeValue === 12
    ? `${safeYear + 1}-01`
    : `${safeYear}-${String(safeValue + 1).padStart(2, "0")}`;
}

function scheduleStorage(
  record: CashflowScheduleDraft | CashflowScheduleRecord,
): Record<string, unknown> {
  return {
    ...record,
    spaceKey: recordKey(record.spaceId),
    accountKey: record.accountId ? recordKey(record.accountId) : "",
    categoryKey: record.categoryId ? recordKey(record.categoryId) : "",
    createdOperationKey: recordKey(record.createdOperationId),
    lastOperationKey: recordKey(record.lastOperationId),
  };
}

function occurrenceStorage(
  record: CashflowOccurrenceDraft | CashflowOccurrenceRecord,
): Record<string, unknown> {
  return {
    ...record,
    scheduleKey: recordKey(record.scheduleId),
    spaceKey: recordKey(record.spaceId),
    accountKey: record.accountId ? recordKey(record.accountId) : "",
    categoryKey: record.categoryId ? recordKey(record.categoryId) : "",
    transactionKey: record.transactionId ? recordKey(record.transactionId) : "",
    lastOperationKey: recordKey(record.lastOperationId),
  };
}

const cashflowScheduleProjection = `
  id, key, space, space.key AS spaceKey, account, account.key AS accountKey,
  category, category.key AS categoryKey, category.name AS categoryName,
  title, direction, certainty, amountMinor, currency, timezone, cadence, interval,
  startDate, endDate, onceDueOn, dayOfWeek, dayOfMonth, monthOfYear, status, revision,
  materializedThrough, termsEffectiveFrom, pausedOn, resumedOn, endedOn, cancelledOn,
  createdOperation, lastOperation, recordedAt, updatedAt, notes
`;

const cashflowOccurrenceProjection = `
  id, schedule, space, space.key AS spaceKey, account, account.key AS accountKey,
  category, category.key AS categoryKey, category.name AS categoryName,
  scheduledDueOn, dueOn, scheduleRevision, revision, title, direction, certainty, cadence,
  scheduledAmountMinor, amountMinor, currency, status, settledAt, transaction,
  overrideReason, statusReason, notes, lastOperation, recordedAt, updatedAt
`;

const scheduleContent = `{
  space: type::record("financialSpace", $schedule.spaceKey),
  account: IF $schedule.accountKey = "" THEN NONE ELSE type::record("account", $schedule.accountKey) END,
  category: IF $schedule.categoryKey = "" THEN NONE ELSE type::record("category", $schedule.categoryKey) END,
  key: $schedule.key, title: $schedule.title, direction: $schedule.direction,
  certainty: $schedule.certainty, amountMinor: <int> $schedule.amountMinor,
  currency: $schedule.currency, timezone: $schedule.timezone, cadence: $schedule.cadence,
  interval: <int> $schedule.interval, startDate: $schedule.startDate, endDate: $schedule.endDate,
  onceDueOn: $schedule.onceDueOn, dayOfWeek: $schedule.dayOfWeek,
  dayOfMonth: $schedule.dayOfMonth, monthOfYear: $schedule.monthOfYear,
  status: $schedule.status, revision: <int> $schedule.revision,
  materializedThrough: $schedule.materializedThrough, termsEffectiveFrom: $schedule.termsEffectiveFrom,
  pausedOn: $schedule.pausedOn,
  resumedOn: $schedule.resumedOn, endedOn: $schedule.endedOn,
  cancelledOn: $schedule.cancelledOn,
  createdOperation: type::record("financialOperation", $schedule.createdOperationKey),
  lastOperation: type::record("financialOperation", $schedule.lastOperationKey),
  recordedAt: $schedule.recordedAt, updatedAt: $schedule.updatedAt, notes: $schedule.notes
}`;

const occurrenceContent = `{
  schedule: $scheduleId, space: type::record("financialSpace", $item.spaceKey),
  account: IF $item.accountKey = "" THEN NONE ELSE type::record("account", $item.accountKey) END,
  category: IF $item.categoryKey = "" THEN NONE ELSE type::record("category", $item.categoryKey) END,
  scheduledDueOn: $item.scheduledDueOn, dueOn: $item.dueOn,
  scheduleRevision: <int> $item.scheduleRevision, revision: <int> $item.revision,
  title: $item.title, direction: $item.direction, certainty: $item.certainty, cadence: $item.cadence,
  scheduledAmountMinor: <int> $item.scheduledAmountMinor, amountMinor: <int> $item.amountMinor,
  currency: $item.currency, status: $item.status, settledAt: $item.settledAt,
  transaction: IF $item.transactionKey = "" THEN NONE ELSE type::record("transaction", $item.transactionKey) END,
  overrideReason: $item.overrideReason, statusReason: $item.statusReason, notes: $item.notes,
  lastOperation: type::record("financialOperation", $item.lastOperationKey),
  recordedAt: $item.recordedAt, updatedAt: $item.updatedAt
}`;

export class SurrealAccountControlRepository
  implements AccountControlRepository, FinancialAnalyticsRepository
{
  constructor(private readonly client: SurrealQueryClient) {}

  async listSpaces(spaceKeys?: string[]): Promise<FinancialSpaceRecord[]> {
    const response = await this.client.query(
      `
        SELECT id, key, name, spaceType, currency
        FROM financialSpace
        WHERE active = true AND ($filterBySpace = false OR key IN $spaceKeys)
        ORDER BY name;
      `,
      { filterBySpace: Boolean(spaceKeys?.length), spaceKeys: spaceKeys ?? [] },
    );
    return rows<Record<string, unknown>>(response).map((raw) => ({
      id: recordId(raw.id),
      key: String(raw.key ?? ""),
      name: String(raw.name ?? ""),
      spaceType: String(raw.spaceType ?? "other"),
      currency: String(raw.currency ?? "ZAR").toUpperCase(),
    }));
  }

  async listAccounts(spaceKeys?: string[]): Promise<AccountRecord[]> {
    if (spaceKeys?.length === 0) return [];
    const response = await this.client.query(
      `
        SELECT id, space AS spaceId, space.key AS spaceKey, key, name, bankName, accountType, facilityKind,
          currency, accountNumberLast4, normalNature, liquidityClass, freshnessWindowHours, active
        FROM account
        WHERE active = true AND ($filterBySpace = false OR space.key IN $spaceKeys)
        ORDER BY space.key, name;
      `,
      { filterBySpace: Boolean(spaceKeys?.length), spaceKeys: spaceKeys ?? [] },
    );
    return rows<RawAccount>(response).map(normalizeAccount);
  }

  async getAccount(
    spaceKey: string,
    accountKey: string,
  ): Promise<AccountRecord | null> {
    const response = await this.client.query(
      `
        SELECT id, space AS spaceId, space.key AS spaceKey, key, name, bankName, accountType, facilityKind,
          currency, accountNumberLast4, normalNature, liquidityClass, freshnessWindowHours, active
        FROM account
        WHERE active = true AND key = $accountKey AND space.key = $spaceKey
        LIMIT 1;
      `,
      { spaceKey, accountKey },
    );
    const raw = rows<RawAccount>(response)[0];
    return raw ? normalizeAccount(raw) : null;
  }

  async listBalanceSnapshots(
    accountIds: string[],
  ): Promise<BalanceSnapshotRecord[]> {
    if (accountIds.length === 0) return [];
    const accountRecordKeys = accountIds.map((id) =>
      id.replace(/^account:/, ""),
    );
    const response = await this.client.query(
      `
        SELECT id, key, space AS spaceId, account AS accountId, balanceKind, amountMinor, currency,
          economicNature, asOf, recordedAt, evidenceLevel, sourceKind, sourceRef, operation, notes
        FROM accountBalanceSnapshot
        WHERE record::id(account) IN $accountRecordKeys
        ORDER BY asOf DESC, recordedAt DESC;
      `,
      { accountRecordKeys },
    );
    const supersededResponse = await this.client.query(
      `SELECT VALUE type::string(id) FROM statementImport
       WHERE sourceState = "superseded";`,
    );
    const supersededImports = new Set(
      unwrapResults(supersededResponse).flat(Infinity).map(String),
    );
    return rows<RawSnapshot>(response)
      .map(normalizeSnapshot)
      .filter(
        (snapshot) =>
          snapshot.sourceKind !== "statement_closing" ||
          !snapshot.sourceRef ||
          !supersededImports.has(snapshot.sourceRef),
      );
  }

  async getBalanceSnapshot(
    idOrKey: string,
  ): Promise<BalanceSnapshotRecord | null> {
    const key = idOrKey.startsWith("accountBalanceSnapshot:")
      ? idOrKey.slice("accountBalanceSnapshot:".length)
      : idOrKey;
    const response = await this.client.query(
      `
        SELECT id, key, space AS spaceId, account AS accountId, balanceKind, amountMinor, currency,
          economicNature, asOf, recordedAt, evidenceLevel, sourceKind, sourceRef, operation, notes
        FROM accountBalanceSnapshot
        WHERE key = $key
        LIMIT 1;
      `,
      { key },
    );
    const raw = rows<RawSnapshot>(response)[0];
    return raw ? normalizeSnapshot(raw) : null;
  }

  async listFacilitySnapshots(
    accountIds: string[],
  ): Promise<FacilitySnapshotRecord[]> {
    if (accountIds.length === 0) return [];
    const accountRecordKeys = accountIds.map((id) => recordKey(id));
    const response = await this.client.query(
      `
        SELECT id, key, space AS spaceId, account AS accountId, facilityKind,
          currency, asOf, effectiveFrom, recordedAt, evidenceLevel, sourceKind,
          sourceRef, statementImport, hasFacilityLimit, facilityLimitMinor,
          hasAvailableCredit, availableCreditMinor, hasMinimumPayment,
          minimumPaymentMinor, paymentDueOn, interestRates, feeTerms, terms,
          operation, notes
        FROM accountFacilitySnapshot
        WHERE record::id(account) IN $accountRecordKeys
        ORDER BY asOf DESC, recordedAt DESC;
      `,
      { accountRecordKeys },
    );
    return rows<RawFacilitySnapshot>(response).map(normalizeFacilitySnapshot);
  }

  async getFacilitySnapshot(
    idOrKey: string,
  ): Promise<FacilitySnapshotRecord | null> {
    const isRecordId = idOrKey.startsWith("accountFacilitySnapshot:");
    const key = isRecordId
      ? idOrKey.slice("accountFacilitySnapshot:".length)
      : idOrKey;
    const response = await this.client.query(
      `
        SELECT id, key, space AS spaceId, account AS accountId, facilityKind,
          currency, asOf, effectiveFrom, recordedAt, evidenceLevel, sourceKind,
          sourceRef, statementImport, hasFacilityLimit, facilityLimitMinor,
          hasAvailableCredit, availableCreditMinor, hasMinimumPayment,
          minimumPaymentMinor, paymentDueOn, interestRates, feeTerms, terms,
          operation, notes
        FROM accountFacilitySnapshot
        WHERE ($isRecordId = true AND id = type::record("accountFacilitySnapshot", $key))
           OR ($isRecordId = false AND key = $key)
        LIMIT 1;
      `,
      { key, isRecordId },
    );
    const raw = rows<RawFacilitySnapshot>(response)[0];
    return raw ? normalizeFacilitySnapshot(raw) : null;
  }

  async listTransactions(
    filter: TransactionReadFilter = {},
  ): Promise<TransactionRecord[]> {
    if (filter.accountIds !== undefined && filter.accountIds.length === 0)
      return [];
    const accountRecordKeys = (filter.accountIds ?? []).map((id) =>
      id.replace(/^account:/, ""),
    );
    const response = await this.client.query(
      `
        SELECT id, key, space AS spaceId, space.key AS spaceKey, account AS accountId,
          account.key AS accountKey, postedAt, effectiveAt, recordedAt, description, amount, amountMinor,
          currency, direction, transactionKind, flowDirection, entrySource, category AS categoryId,
          category.key AS categoryKey, category.name AS categoryName, category.categoryKind AS categoryKind,
          status, merchantName, notes, sourceRow AS sourceRowId,
          sourceRow.reportedBalanceMinor AS sourceReportedBalanceMinor,
          sourceRow.balance AS sourceLegacyBalance,
          balance AS transactionLegacyBalance,
          statementMatch AS statementMatchId,
          statementMatch.statementImport AS statementImportId,
          statementMatch.state AS statementMatchState,
          statementMatch.sourceState AS statementMatchSourceState,
          statementMatch.statementImport.sourceState AS statementImportSourceState,
          operation AS operationId, transfer AS transferId,
          isTransfer
        FROM transaction
        WHERE ($filterAccounts = false OR record::id(account) IN $accountRecordKeys)
        ORDER BY postedAt DESC, recordedAt DESC, id DESC;
      `,
      {
        filterAccounts: filter.accountIds !== undefined,
        accountRecordKeys,
        filterMonth: Boolean(filter.month),
        monthStart: filter.month ? `${filter.month}-01` : "",
        monthEnd: filter.month ? `${nextMonth(filter.month)}-01` : "",
      },
    );
    return rows<RawTransaction>(response)
      .map(normalizeTransaction)
      .filter(
        (transaction) =>
          transaction.ledgerAuthority === "active" ||
          (filter.includeLegacyUnreconciled === true &&
            transaction.ledgerAuthority === "legacy_unreconciled"),
      )
      .filter(
        (transaction) =>
          !filter.month ||
          (transaction.hasActiveStatementClaim
            ? (transaction.effectiveAt ?? transaction.postedAt)
            : transaction.postedAt
          )?.startsWith(filter.month),
      )
      .sort((left, right) => {
        const rightDate = right.hasActiveStatementClaim
          ? (right.effectiveAt ?? right.postedAt)
          : right.postedAt;
        const leftDate = left.hasActiveStatementClaim
          ? (left.effectiveAt ?? left.postedAt)
          : left.postedAt;
        const date = (rightDate ?? "").localeCompare(leftDate ?? "");
        return date || right.id.localeCompare(left.id);
      });
  }

  async listFinancialAnalyticsTransactions(
    filter: FinancialAnalyticsTransactionFilter,
  ): Promise<TransactionRecord[]> {
    if (filter.accountIds.length === 0) return [];
    const accountRecordKeys = filter.accountIds.map((id) =>
      id.replace(/^account:/, ""),
    );
    const response = await this.client.query(
      `
        LET $canonicalHistoryTransactions = (
          SELECT VALUE transaction FROM statementTransactionMatch
          WHERE record::id(account) IN $accountRecordKeys
            AND state IN ["confirmed", "superseded"]
            AND sourceState IN ["committed", "superseded"]
        );
        SELECT id, key, space AS spaceId, space.key AS spaceKey, account AS accountId,
          account.key AS accountKey, postedAt, effectiveAt, recordedAt, description, amount, amountMinor,
          currency, direction, transactionKind, flowDirection, entrySource, category AS categoryId,
          category.key AS categoryKey, category.name AS categoryName, category.categoryKind AS categoryKind,
          status, merchantName, notes, sourceRow AS sourceRowId,
          sourceRow.reportedBalanceMinor AS sourceReportedBalanceMinor,
          sourceRow.balance AS sourceLegacyBalance,
          balance AS transactionLegacyBalance,
          statementMatch AS statementMatchId,
          statementMatch.statementImport AS statementImportId,
          statementMatch.state AS statementMatchState,
          statementMatch.sourceState AS statementMatchSourceState,
          statementMatch.statementImport.sourceState AS statementImportSourceState,
          id IN $canonicalHistoryTransactions AS hasCanonicalStatementMatchHistory,
          operation AS operationId, transfer AS transferId,
          isTransfer
        FROM transaction
        WHERE record::id(account) IN $accountRecordKeys
          AND currency = $currency
          AND (
            (postedAt >= $from AND postedAt <= $through)
            OR (effectiveAt >= $from AND effectiveAt <= $through)
            OR (
              string::slice(type::string(recordedAt), 0, 10) >= $from
              AND string::slice(type::string(recordedAt), 0, 10) <= $through
            )
          )
        ORDER BY postedAt DESC, recordedAt DESC, id DESC;
      `,
      {
        accountRecordKeys,
        currency: filter.currency,
        from: filter.from,
        through: filter.through,
      },
    );
    return rows<RawTransaction>(response)
      .map(normalizeTransaction)
      .filter(
        (transaction) =>
          filter.accountIds.includes(transaction.accountId) &&
          transaction.currency === filter.currency,
      );
  }

  async getTransaction(idOrKey: string): Promise<TransactionRecord | null> {
    const key = idOrKey.replace(/^transaction:/, "");
    const response = await this.client.query(
      `
        SELECT id, key, space AS spaceId, space.key AS spaceKey, account AS accountId,
          account.key AS accountKey, postedAt, effectiveAt, recordedAt, description, amount, amountMinor,
          currency, direction, transactionKind, flowDirection, entrySource, category AS categoryId,
          category.key AS categoryKey, category.name AS categoryName, category.categoryKind AS categoryKind,
          status, merchantName, notes, sourceRow AS sourceRowId,
          sourceRow.reportedBalanceMinor AS sourceReportedBalanceMinor,
          sourceRow.balance AS sourceLegacyBalance,
          balance AS transactionLegacyBalance,
          statementMatch AS statementMatchId,
          statementMatch.statementImport AS statementImportId,
          statementMatch.state AS statementMatchState,
          statementMatch.sourceState AS statementMatchSourceState,
          statementMatch.statementImport.sourceState AS statementImportSourceState,
          operation AS operationId, transfer AS transferId,
          isTransfer
        FROM transaction
        WHERE record::id(id) = $key
        LIMIT 1;
      `,
      { key },
    );
    const raw = rows<RawTransaction>(response)[0];
    return raw ? normalizeTransaction(raw) : null;
  }

  async listCategories(spaceKey: string): Promise<CategoryRecord[]> {
    const response = await this.client.query(
      `
        SELECT id, space AS spaceId, space.key AS spaceKey, key, name, categoryKind,
          parentCategory AS parentId, parentCategory.key AS parentKey,
          parentCategory.name AS parentName, active
        FROM category
        WHERE space.key = $spaceKey AND active = true
        ORDER BY name, key;
      `,
      { spaceKey },
    );
    return rows<Record<string, unknown>>(response).map(normalizeCategory);
  }

  async getCategory(
    spaceKey: string,
    categoryKey: string,
  ): Promise<CategoryRecord | null> {
    const response = await this.client.query(
      `
        SELECT id, space AS spaceId, space.key AS spaceKey, key, name, categoryKind,
          parentCategory AS parentId, parentCategory.key AS parentKey,
          parentCategory.name AS parentName, active
        FROM category
        WHERE space.key = $spaceKey AND key = $categoryKey
        LIMIT 1;
      `,
      { spaceKey, categoryKey },
    );
    const raw = rows<Record<string, unknown>>(response)[0];
    return raw ? normalizeCategory(raw) : null;
  }

  async getOperationById(
    idOrKey: string,
  ): Promise<FinancialOperationRecord | null> {
    const key = idOrKey.replace(/^financialOperation:/, "");
    const response = await this.client.query(
      "SELECT * FROM financialOperation WHERE record::id(id) = $key LIMIT 1;",
      { key },
    );
    const raw = rows<RawOperation>(response)[0];
    return raw ? normalizeOperation(raw) : null;
  }

  async getTransfer(idOrKey: string): Promise<AccountTransferRecord | null> {
    const key = idOrKey.replace(/^accountTransfer:/, "");
    const response = await this.client.query(
      `
        SELECT id, key, sourceAccount, sourceAccount.key AS sourceAccountKey,
          sourceSpace.key AS sourceSpaceKey, targetAccount, targetAccount.key AS targetAccountKey,
          targetSpace.key AS targetSpaceKey, amountMinor, currency, postedAt, description,
          sourceTransaction, targetTransaction, operation, recordedAt
        FROM accountTransfer
        WHERE record::id(id) = $key
        LIMIT 1;
      `,
      { key },
    );
    const raw = rows<RawTransfer>(response)[0];
    return raw ? normalizeTransfer(raw) : null;
  }

  async listClarifications(
    transactionId: string,
  ): Promise<ClarificationSummary[]> {
    const transactionKey = transactionId.replace(/^transaction:/, "");
    const response = await this.client.query(
      `
        SELECT id, status, taskType
        FROM clarificationTask
        WHERE record::id(transaction) = $transactionKey
        ORDER BY id;
      `,
      { transactionKey },
    );
    return rows<Record<string, unknown>>(response).map((raw) => ({
      id: recordId(raw.id),
      status: String(raw.status ?? "open"),
      taskType: raw.taskType ? String(raw.taskType) : null,
    }));
  }

  async getOperation(
    command: FinancialOperationRecord["command"],
    idempotencyKey: string,
  ): Promise<FinancialOperationRecord | null> {
    const response = await this.client.query(
      `
        SELECT *
        FROM financialOperation
        WHERE command = $command AND idempotencyKey = $idempotencyKey
        LIMIT 1;
      `,
      { command, idempotencyKey },
    );
    const raw = rows<RawOperation>(response)[0];
    return raw ? normalizeOperation(raw) : null;
  }

  async listOperationsForEntity(
    entityId: string,
  ): Promise<FinancialOperationRecord[]> {
    const response = await this.client.query(
      `
        SELECT *
        FROM financialOperation
        WHERE $entityId IN resultRefs
        ORDER BY recordedAt DESC, id DESC;
      `,
      { entityId },
    );
    return rows<RawOperation>(response).map(normalizeOperation);
  }

  async listCashflowSchedules(
    filter: CashflowScheduleReadFilter = {},
  ): Promise<CashflowScheduleRecord[]> {
    const response = await cashflowQuery(
      this.client,
      `
        SELECT ${cashflowScheduleProjection}
        FROM cashflowSchedule
        WHERE (!$filterSpaces OR space.key IN $spaceKeys)
          AND (!$filterStatuses OR status IN $statuses)
        ORDER BY title, id;
      `,
      {
        filterSpaces: filter.spaceKeys !== undefined,
        spaceKeys: filter.spaceKeys ?? [],
        filterStatuses: filter.statuses !== undefined,
        statuses: filter.statuses ?? [],
      },
    );
    return rows<RawCashflowSchedule>(response).map(normalizeCashflowSchedule);
  }

  async getCashflowSchedule(
    idOrKey: string,
  ): Promise<CashflowScheduleRecord | null> {
    const response = await cashflowQuery(
      this.client,
      `SELECT ${cashflowScheduleProjection} FROM cashflowSchedule WHERE record::id(id) = $key LIMIT 1;`,
      { key: recordKey(idOrKey) },
    );
    const raw = rows<RawCashflowSchedule>(response)[0];
    return raw ? normalizeCashflowSchedule(raw) : null;
  }

  async listCashflowOccurrences(
    filter: CashflowOccurrenceReadFilter = {},
  ): Promise<CashflowOccurrenceRecord[]> {
    const response = await cashflowQuery(
      this.client,
      `
        SELECT ${cashflowOccurrenceProjection}
        FROM cashflowOccurrence
        WHERE (!$filterSchedules OR record::id(schedule) IN $scheduleKeys)
          AND (!$filterSpaces OR space.key IN $spaceKeys)
          AND (!$filterStatuses OR status IN $statuses)
          AND (!$filterFrom OR dueOn >= $from)
          AND (!$filterThrough OR dueOn <= $through)
        ORDER BY dueOn, id;
      `,
      {
        filterSchedules: filter.scheduleIds !== undefined,
        scheduleKeys: (filter.scheduleIds ?? []).map(recordKey),
        filterSpaces: filter.spaceKeys !== undefined,
        spaceKeys: filter.spaceKeys ?? [],
        filterStatuses: filter.statuses !== undefined,
        statuses: filter.statuses ?? [],
        filterFrom: filter.from !== undefined,
        from: filter.from ?? "",
        filterThrough: filter.through !== undefined,
        through: filter.through ?? "",
      },
    );
    return rows<RawCashflowOccurrence>(response).map(
      normalizeCashflowOccurrence,
    );
  }

  async getCashflowOccurrence(
    idOrKey: string,
  ): Promise<CashflowOccurrenceRecord | null> {
    const response = await cashflowQuery(
      this.client,
      `SELECT ${cashflowOccurrenceProjection} FROM cashflowOccurrence WHERE record::id(id) = $key LIMIT 1;`,
      { key: recordKey(idOrKey) },
    );
    const raw = rows<RawCashflowOccurrence>(response)[0];
    return raw ? normalizeCashflowOccurrence(raw) : null;
  }

  async createCashflowScheduleWithOperation(
    schedule: CashflowScheduleDraft,
    occurrences: CashflowOccurrenceDraft[],
    operation: OperationDraft,
  ): Promise<{
    schedule: CashflowScheduleRecord;
    occurrences: CashflowOccurrenceRecord[];
    operation: FinancialOperationRecord;
  }> {
    const response = await cashflowQuery(
      this.client,
      `
        BEGIN TRANSACTION;
        LET $spaceId = type::record("financialSpace", $schedule.spaceKey);
        LET $scheduleId = type::record("cashflowSchedule", fn::stringID([$spaceId, $schedule.key]));
        LET $schedule = CREATE ONLY $scheduleId CONTENT ${scheduleContent};
        FOR $item IN $occurrences {
          LET $occurrenceId = type::record("cashflowOccurrence", fn::stringID([$scheduleId, $item.scheduledDueOn]));
          CREATE ONLY $occurrenceId CONTENT ${occurrenceContent};
        };
        LET $createdOccurrences = SELECT ${cashflowOccurrenceProjection} FROM cashflowOccurrence WHERE schedule = $scheduleId ORDER BY dueOn, id;
        LET $occurrenceRefs = SELECT VALUE type::string(id) FROM cashflowOccurrence WHERE schedule = $scheduleId;
        LET $operation = CREATE ONLY type::record("financialOperation", $operationKey) CONTENT {
          key: $operationKey, command: $command, idempotencyKey: $idempotencyKey,
          requestHash: $requestHash, channel: $channel, actorId: $actorId, status: "applied",
          resultRefs: array::concat([type::string($scheduleId)], $occurrenceRefs), warningCodes: $warningCodes, auditMeta: $auditMeta,
          recordedAt: $recordedAt, completedAt: $recordedAt, failureCode: ""
        };
        RETURN { schedule: $schedule, occurrences: $createdOccurrences, operation: $operation };
        COMMIT TRANSACTION;
      `,
      {
        schedule: scheduleStorage(schedule),
        occurrences: occurrences.map(occurrenceStorage),
        operationKey: operation.key,
        command: operation.command,
        idempotencyKey: operation.idempotencyKey,
        requestHash: operation.requestHash,
        channel: operation.channel,
        actorId: operation.actorId ?? "",
        warningCodes: operation.warningCodes ?? [],
        auditMeta: operation.auditMeta ?? {},
        recordedAt: operation.recordedAt,
      },
    );
    const result = transactionResult<{
      schedule: RawCashflowSchedule;
      occurrences: RawCashflowOccurrence[];
      operation: RawOperation;
    }>(response, "schedule");
    return {
      schedule: normalizeCashflowSchedule({
        ...result.schedule,
        spaceKey: schedule.spaceKey,
        accountKey: schedule.accountKey,
        categoryKey: schedule.categoryKey,
        categoryName: schedule.categoryName,
      }),
      occurrences: result.occurrences.map(normalizeCashflowOccurrence),
      operation: normalizeOperation(result.operation),
    };
  }

  async mutateCashflowScheduleWithOperation(
    mutation: CashflowScheduleMutation,
    operation: OperationDraft,
  ): Promise<{
    schedule: CashflowScheduleRecord;
    occurrences: CashflowOccurrenceRecord[];
    operation: FinancialOperationRecord;
  }> {
    const current = await this.getCashflowSchedule(mutation.scheduleId);
    if (!current)
      throw new RavenDomainError("NOT_FOUND", "Cashflow schedule not found");
    const next = { ...current, ...mutation.patch } as CashflowScheduleRecord;
    const existing = await this.listCashflowOccurrences({
      scheduleIds: [current.id],
    });
    const existingById = new Map(existing.map((item) => [item.id, item]));
    const occurrenceUpdates = mutation.occurrencePatches.map(
      ({ occurrenceId, patch }) => {
        const occurrence = existingById.get(occurrenceId);
        if (!occurrence)
          throw new RavenDomainError(
            "NOT_FOUND",
            "Cashflow occurrence not found",
          );
        const expected = mutation.occurrencePatches.find(
          (item) => item.occurrenceId === occurrenceId,
        )!;
        return {
          ...occurrenceStorage({ ...occurrence, ...patch }),
          idKey: recordKey(occurrenceId),
          expectedRevision: expected.expectedRevision,
          expectedStatus: expected.expectedStatus,
        };
      },
    );
    const response = await cashflowQuery(
      this.client,
      `
        BEGIN TRANSACTION;
        LET $scheduleId = type::record("cashflowSchedule", $scheduleKey);
        LET $current = SELECT * FROM ONLY $scheduleId;
        IF !$current OR $current.revision != $expectedRevision { THROW "SCHEDULE_REVISION_CONFLICT"; };
        IF $current.status != $expectedStatus { THROW "SCHEDULE_REVISION_CONFLICT"; };
        IF $current.status IN ["ended", "cancelled"] { THROW "INVALID_SCHEDULE_TRANSITION"; };
        IF $current.status = "active" AND !($schedule.status IN ["active", "paused", "ended", "cancelled"]) { THROW "INVALID_SCHEDULE_TRANSITION"; };
        IF $current.status = "paused" AND !($schedule.status IN ["paused", "active", "ended", "cancelled"]) { THROW "INVALID_SCHEDULE_TRANSITION"; };
        FOR $item IN $occurrenceUpdates {
          LET $occurrenceId = type::record("cashflowOccurrence", $item.idKey);
          LET $occurrence = SELECT * FROM ONLY $occurrenceId;
          IF !$occurrence OR $occurrence.revision != $item.expectedRevision OR $occurrence.status != $item.expectedStatus {
            THROW "OCCURRENCE_CONFLICT";
          };
        };
        FOR $item IN $createOccurrences {
          LET $occurrenceId = type::record("cashflowOccurrence", fn::stringID([$scheduleId, $item.scheduledDueOn]));
          IF record::exists($occurrenceId) { THROW "SCHEDULE_REVISION_CONFLICT"; };
        };
        LET $schedule = UPDATE ONLY $scheduleId CONTENT ${scheduleContent};
        FOR $item IN $occurrenceUpdates {
          LET $occurrenceId = type::record("cashflowOccurrence", $item.idKey);
          UPDATE ONLY $occurrenceId CONTENT ${occurrenceContent};
        };
        FOR $item IN $createOccurrences {
          LET $occurrenceId = type::record("cashflowOccurrence", fn::stringID([$scheduleId, $item.scheduledDueOn]));
          CREATE ONLY $occurrenceId CONTENT ${occurrenceContent};
        };
        LET $operationId = type::record("financialOperation", $operationKey);
        LET $affectedRefs = SELECT VALUE type::string(id) FROM cashflowOccurrence WHERE schedule = $scheduleId AND lastOperation = $operationId;
        LET $operation = CREATE ONLY $operationId CONTENT {
          key: $operationKey, command: $command, idempotencyKey: $idempotencyKey,
          requestHash: $requestHash, channel: $channel, actorId: $actorId, status: "applied",
          resultRefs: array::concat([type::string($scheduleId)], $affectedRefs), warningCodes: $warningCodes, auditMeta: $auditMeta,
          recordedAt: $recordedAt, completedAt: $recordedAt, failureCode: ""
        };
        LET $allOccurrences = SELECT ${cashflowOccurrenceProjection} FROM cashflowOccurrence WHERE schedule = $scheduleId ORDER BY dueOn, id;
        RETURN { schedule: $schedule, occurrences: $allOccurrences, operation: $operation };
        COMMIT TRANSACTION;
      `,
      {
        scheduleKey: recordKey(current.id),
        expectedRevision: mutation.expectedRevision,
        expectedStatus: mutation.expectedStatus,
        schedule: scheduleStorage(next),
        occurrenceUpdates,
        createOccurrences: mutation.createOccurrences.map(occurrenceStorage),
        operationKey: operation.key,
        command: operation.command,
        idempotencyKey: operation.idempotencyKey,
        requestHash: operation.requestHash,
        channel: operation.channel,
        actorId: operation.actorId ?? "",
        warningCodes: operation.warningCodes ?? [],
        auditMeta: operation.auditMeta ?? {},
        recordedAt: operation.recordedAt,
      },
    );
    const result = transactionResult<{
      schedule: RawCashflowSchedule;
      occurrences: RawCashflowOccurrence[];
      operation: RawOperation;
    }>(response, "schedule");
    return {
      schedule: normalizeCashflowSchedule({
        ...result.schedule,
        spaceKey: next.spaceKey,
        accountKey: next.accountKey,
        categoryKey: next.categoryKey,
        categoryName: next.categoryName,
      }),
      occurrences: result.occurrences.map(normalizeCashflowOccurrence),
      operation: normalizeOperation(result.operation),
    };
  }

  async materializeCashflowOccurrences(
    scheduleId: string,
    expectedRevision: number,
    through: string,
    occurrences: CashflowOccurrenceDraft[],
  ): Promise<{
    schedule: CashflowScheduleRecord;
    occurrences: CashflowOccurrenceRecord[];
  }> {
    const current = await this.getCashflowSchedule(scheduleId);
    if (!current)
      throw new RavenDomainError("NOT_FOUND", "Cashflow schedule not found");
    const response = await cashflowQuery(
      this.client,
      `
        BEGIN TRANSACTION;
        LET $scheduleId = type::record("cashflowSchedule", $scheduleKey);
        LET $current = SELECT * FROM ONLY $scheduleId;
        IF !$current OR $current.revision != $expectedRevision { THROW "SCHEDULE_REVISION_CONFLICT"; };
        IF $current.status != "active" { THROW "SCHEDULE_REVISION_CONFLICT"; };
        IF $current.materializedThrough = NONE OR $current.materializedThrough < $through {
          FOR $item IN $occurrences {
            LET $occurrenceId = type::record("cashflowOccurrence", fn::stringID([$scheduleId, $item.scheduledDueOn]));
            IF !record::exists($occurrenceId) { CREATE ONLY $occurrenceId CONTENT ${occurrenceContent}; };
          };
          UPDATE ONLY $scheduleId SET materializedThrough = $through;
        };
        LET $schedule = SELECT * FROM ONLY $scheduleId;
        LET $allOccurrences = SELECT ${cashflowOccurrenceProjection} FROM cashflowOccurrence WHERE schedule = $scheduleId ORDER BY dueOn, id;
        RETURN { schedule: $schedule, occurrences: $allOccurrences };
        COMMIT TRANSACTION;
      `,
      {
        scheduleKey: recordKey(scheduleId),
        expectedRevision,
        through,
        occurrences: occurrences.map(occurrenceStorage),
      },
    );
    const result = transactionResult<{
      schedule: RawCashflowSchedule;
      occurrences: RawCashflowOccurrence[];
    }>(response, "schedule");
    return {
      schedule: normalizeCashflowSchedule({
        ...result.schedule,
        spaceKey: current.spaceKey,
        accountKey: current.accountKey,
        categoryKey: current.categoryKey,
        categoryName: current.categoryName,
      }),
      occurrences: result.occurrences.map(normalizeCashflowOccurrence),
    };
  }

  async mutateCashflowOccurrenceWithOperation(
    mutation: CashflowOccurrenceMutation,
    operation: OperationDraft,
  ): Promise<{
    occurrence: CashflowOccurrenceRecord;
    operation: FinancialOperationRecord;
  }> {
    const current = await this.getCashflowOccurrence(mutation.occurrenceId);
    if (!current)
      throw new RavenDomainError("NOT_FOUND", "Cashflow occurrence not found");
    const next = occurrenceStorage({ ...current, ...mutation.patch });
    let response: unknown;
    try {
      response = await cashflowQuery(
        this.client,
        `
        BEGIN TRANSACTION;
        LET $scheduleId = type::record("cashflowSchedule", $item.scheduleKey);
        LET $occurrenceId = type::record("cashflowOccurrence", $occurrenceKey);
        LET $current = SELECT * FROM ONLY $occurrenceId;
        IF !$current OR $current.revision != $expectedRevision { THROW "OCCURRENCE_REVISION_CONFLICT"; };
        IF $current.status != $expectedStatus { THROW "OCCURRENCE_CONFLICT"; };
        IF $settlementTransactionKey != "" {
          LET $transactionId = type::record("transaction", $settlementTransactionKey);
          LET $transaction = SELECT * FROM ONLY $transactionId;
          IF !$transaction
            OR !type::is_int($transaction.amountMinor)
            OR $transaction.amountMinor <= 0
            OR $transaction.postedAt = NONE OR $transaction.postedAt = ""
            OR $transaction.recordedAt = NONE OR $transaction.recordedAt = ""
            OR !($transaction.entrySource IN ["imported", "manual", "generated"])
            OR $transaction.status = "ignored"
            OR $transaction.isTransfer = true
            OR $transaction.transactionKind != $expectedTransactionKind
            OR $transaction.flowDirection != $expectedFlowDirection
            OR $transaction.amountMinor != $expectedAmountMinor
            OR $transaction.currency != $expectedCurrency
            OR $transaction.space != $current.space
            OR ($current.account != NONE AND $transaction.account != $current.account) {
            THROW "INVALID_SETTLEMENT_TRANSACTION";
          };
          LET $linked = SELECT VALUE id FROM cashflowOccurrence WHERE transaction = $transactionId AND id != $occurrenceId LIMIT 1;
          IF array::len($linked) > 0 { THROW "OCCURRENCE_CONFLICT"; };
        };
        LET $occurrence = UPDATE ONLY $occurrenceId CONTENT ${occurrenceContent};
        LET $operation = CREATE ONLY type::record("financialOperation", $operationKey) CONTENT {
          key: $operationKey, command: $command, idempotencyKey: $idempotencyKey,
          requestHash: $requestHash, channel: $channel, actorId: $actorId, status: "applied",
          resultRefs: [type::string($occurrenceId)], warningCodes: $warningCodes, auditMeta: $auditMeta,
          recordedAt: $recordedAt, completedAt: $recordedAt, failureCode: ""
        };
        RETURN { occurrence: $occurrence, operation: $operation };
        COMMIT TRANSACTION;
        `,
        {
          occurrenceKey: recordKey(current.id),
          expectedRevision: mutation.expectedRevision,
          expectedStatus: mutation.expectedStatus,
          settlementTransactionKey: mutation.settlementTransactionId
            ? recordKey(mutation.settlementTransactionId)
            : "",
          expectedTransactionKind:
            current.direction === "outflow" ? "expense" : "income",
          expectedFlowDirection:
            current.direction === "outflow" ? "outflow" : "inflow",
          expectedAmountMinor: current.amountMinor,
          expectedCurrency: current.currency,
          item: next,
          operationKey: operation.key,
          command: operation.command,
          idempotencyKey: operation.idempotencyKey,
          requestHash: operation.requestHash,
          channel: operation.channel,
          actorId: operation.actorId ?? "",
          warningCodes: operation.warningCodes ?? [],
          auditMeta: operation.auditMeta ?? {},
          recordedAt: operation.recordedAt,
        },
      );
    } catch (error) {
      if (
        mutation.settlementTransactionId &&
        error instanceof RavenDomainError &&
        error.code === "INTERNAL" &&
        /failed transaction/i.test(error.message)
      ) {
        throw new RavenDomainError(
          "OCCURRENCE_CONFLICT",
          "Settlement evidence was linked by another occurrence",
        );
      }
      throw error;
    }
    let result: { occurrence: RawCashflowOccurrence; operation: RawOperation };
    try {
      result = transactionResult<{
        occurrence: RawCashflowOccurrence;
        operation: RawOperation;
      }>(response, "occurrence");
    } catch (error) {
      if (
        mutation.settlementTransactionId &&
        error instanceof RavenDomainError &&
        error.code === "INTERNAL" &&
        /failed transaction/i.test(error.message)
      ) {
        throw new RavenDomainError(
          "OCCURRENCE_CONFLICT",
          "Settlement evidence was linked by another occurrence",
        );
      }
      throw error;
    }
    return {
      occurrence: normalizeCashflowOccurrence({
        ...result.occurrence,
        spaceKey: current.spaceKey,
        accountKey: current.accountKey,
        categoryKey: current.categoryKey,
        categoryName: current.categoryName,
      }),
      operation: normalizeOperation(result.operation),
    };
  }

  async createAccountWithOperation(
    input: CreateAccountInput,
    operation: OperationDraft,
  ): Promise<{ account: AccountRecord; operation: FinancialOperationRecord }> {
    let response: unknown;
    try {
      response = await this.client.query(
        `
        BEGIN TRANSACTION;
        LET $space = (SELECT VALUE id FROM financialSpace WHERE key = $spaceKey AND active = true LIMIT 1)[0];
        LET $accountId = fn::stringID([$space, $accountKey]);
        LET $account = CREATE ONLY type::record("account", $accountId) CONTENT {
          space: $space,
          key: $accountKey,
          name: $name,
          bankName: $bankName,
          accountType: $accountType,
          facilityKind: $facilityKind,
          currency: $currency,
          openingBalance: 0,
          openingBalanceMinor: 0,
          normalNature: $normalNature,
          liquidityClass: $liquidityClass,
          freshnessWindowHours: $freshnessWindowHours,
          active: true,
          notes: ""
        };
        LET $operation = CREATE ONLY type::record("financialOperation", $operationKey) CONTENT {
          key: $operationKey,
          command: "create_account",
          idempotencyKey: $idempotencyKey,
          requestHash: $requestHash,
          channel: $channel,
          actorId: $actorId,
          status: "applied",
          resultRefs: [type::string($account.id)],
          warningCodes: [],
          recordedAt: $recordedAt,
          completedAt: $recordedAt,
          failureCode: ""
        };
        RETURN { account: $account, operation: $operation };
        COMMIT TRANSACTION;
      `,
        {
          ...input,
          bankName: input.bankName ?? "",
          facilityKind:
            input.facilityKind ??
            (input.accountType === "credit_card"
              ? "credit_card"
              : input.accountType === "loan"
                ? "loan"
                : "none"),
          operationKey: operation.key,
          idempotencyKey: operation.idempotencyKey,
          requestHash: operation.requestHash,
          channel: operation.channel,
          actorId: operation.actorId ?? "",
          recordedAt: operation.recordedAt,
        },
      );
    } catch (error) {
      rethrowAccountCreateError(error);
    }
    let result: { account: RawAccount; operation: RawOperation };
    try {
      result = transactionResult<{
        account: RawAccount;
        operation: RawOperation;
      }>(response, "account");
    } catch (error) {
      rethrowAccountCreateError(error);
    }
    return {
      account: normalizeAccount({
        ...result.account,
        spaceKey: input.spaceKey,
      }),
      operation: normalizeOperation(result.operation),
    };
  }

  async confirmBalanceWithOperation(
    snapshot: BalanceSnapshotDraft,
    operation: OperationDraft,
  ): Promise<{
    snapshot: BalanceSnapshotRecord;
    operation: FinancialOperationRecord;
  }> {
    const response = await this.client.query(
      `
        BEGIN TRANSACTION;
        LET $snapshot = CREATE ONLY type::record("accountBalanceSnapshot", $snapshotKey) CONTENT {
          space: type::record("financialSpace", $spaceKey),
          account: type::record("account", $accountKey),
          key: $snapshotKey,
          balanceKind: $balanceKind,
          amountMinor: <int> $amountMinor,
          currency: $currency,
          economicNature: $economicNature,
          asOf: $asOf,
          recordedAt: $recordedAt,
          evidenceLevel: "confirmed",
          sourceKind: "manual_confirmation",
          sourceRef: "",
          operation: type::record("financialOperation", $operationKey),
          notes: $notes
        };
        LET $operation = CREATE ONLY type::record("financialOperation", $operationKey) CONTENT {
          key: $operationKey,
          command: "confirm_account_balance",
          idempotencyKey: $idempotencyKey,
          requestHash: $requestHash,
          channel: $channel,
          actorId: $actorId,
          status: "applied",
          resultRefs: [$snapshotRef],
          warningCodes: [],
          recordedAt: $recordedAt,
          completedAt: $recordedAt,
          failureCode: ""
        };
        RETURN { snapshot: $snapshot, operation: $operation };
        COMMIT TRANSACTION;
      `,
      {
        snapshotKey: snapshot.key,
        snapshotRef: `accountBalanceSnapshot:${snapshot.key}`,
        spaceKey: snapshot.spaceId.split(":").slice(1).join(":"),
        accountKey: snapshot.accountId.split(":").slice(1).join(":"),
        balanceKind: snapshot.balanceKind,
        amountMinor: snapshot.amountMinor,
        currency: snapshot.currency,
        economicNature: snapshot.economicNature,
        asOf: snapshot.asOf,
        recordedAt: snapshot.recordedAt,
        notes: snapshot.notes ?? "",
        operationKey: operation.key,
        idempotencyKey: operation.idempotencyKey,
        requestHash: operation.requestHash,
        channel: operation.channel,
        actorId: operation.actorId ?? "",
      },
    );
    const result = transactionResult<{
      snapshot: RawSnapshot;
      operation: RawOperation;
    }>(response, "snapshot");
    return {
      snapshot: normalizeSnapshot(result.snapshot),
      operation: normalizeOperation(result.operation),
    };
  }

  async recordFacilitySnapshotWithOperation(
    snapshot: FacilitySnapshotDraft,
    operation: OperationDraft,
  ): Promise<{
    snapshot: FacilitySnapshotRecord;
    operation: FinancialOperationRecord;
  }> {
    const accountKey = recordKey(snapshot.accountId);
    const spaceKey = recordKey(snapshot.spaceId);
    const statementImportKey = snapshot.statementImportId
      ? recordKey(snapshot.statementImportId)
      : "";
    const response = await this.client.query(
      `
        BEGIN TRANSACTION;
        LET $account = (SELECT * FROM ONLY type::record("account", $accountKey));
        IF !$account OR $account.space != type::record("financialSpace", $spaceKey) {
          THROW "RAVEN_FACILITY_ACCOUNT_INVALID";
        };
        IF $account.facilityKind != NONE AND $account.facilityKind != "none" AND $account.facilityKind != $facilityKind {
          THROW "RAVEN_FACILITY_KIND_CONFLICT";
        };
        LET $statementImport = IF $statementImportKey = "" {
          NONE
        } ELSE {
          (SELECT * FROM ONLY type::record("statementImport", $statementImportKey))
        };
        IF $statementImportKey != "" AND (!$statementImport OR $statementImport.account != $account.id) {
          THROW "RAVEN_FACILITY_STATEMENT_INVALID";
        };
        LET $snapshotId = type::record(
          "accountFacilitySnapshot",
          fn::stringID([$account.id, $snapshotKey])
        );
        LET $operation = CREATE ONLY type::record("financialOperation", $operationKey) CONTENT {
          key: $operationKey,
          command: "record_account_facility_snapshot",
          idempotencyKey: $idempotencyKey,
          requestHash: $requestHash,
          channel: $channel,
          actorId: $actorId,
          status: "applied",
          resultRefs: [type::string($snapshotId)],
          warningCodes: [],
          auditMeta: {},
          recordedAt: $recordedAt,
          completedAt: $recordedAt,
          failureCode: ""
        };
        LET $snapshot = CREATE ONLY $snapshotId CONTENT {
          space: type::record("financialSpace", $spaceKey),
          account: $account.id,
          key: $snapshotKey,
          facilityKind: $facilityKind,
          currency: $currency,
          asOf: $asOf,
          effectiveFrom: $effectiveFrom,
          recordedAt: $recordedAt,
          evidenceLevel: $evidenceLevel,
          sourceKind: $sourceKind,
          sourceRef: $sourceRef,
          statementImport: IF $statementImportKey = "" THEN NONE ELSE $statementImport.id END,
          hasFacilityLimit: $hasFacilityLimit,
          facilityLimitMinor: <int> $facilityLimitMinor,
          hasAvailableCredit: $hasAvailableCredit,
          availableCreditMinor: <int> $availableCreditMinor,
          hasMinimumPayment: $hasMinimumPayment,
          minimumPaymentMinor: <int> $minimumPaymentMinor,
          paymentDueOn: $paymentDueOn,
          interestRates: $interestRates,
          feeTerms: $feeTerms,
          terms: $terms,
          operation: $operation.id,
          notes: $notes
        };
        UPDATE $account SET facilityKind = $facilityKind;
        RETURN { snapshot: $snapshot, operation: $operation };
        COMMIT TRANSACTION;
      `,
      {
        accountKey,
        spaceKey,
        statementImportKey,
        snapshotKey: snapshot.key,
        facilityKind: snapshot.facilityKind,
        currency: snapshot.currency,
        asOf: snapshot.asOf,
        effectiveFrom: snapshot.effectiveFrom ?? "",
        recordedAt: snapshot.recordedAt,
        evidenceLevel: snapshot.evidenceLevel,
        sourceKind: snapshot.sourceKind,
        sourceRef: snapshot.sourceRef ?? "",
        hasFacilityLimit: snapshot.facilityLimitMinor != null,
        facilityLimitMinor: snapshot.facilityLimitMinor ?? 0,
        hasAvailableCredit: snapshot.availableCreditMinor != null,
        availableCreditMinor: snapshot.availableCreditMinor ?? 0,
        hasMinimumPayment: snapshot.minimumPaymentMinor != null,
        minimumPaymentMinor: snapshot.minimumPaymentMinor ?? 0,
        paymentDueOn: snapshot.paymentDueOn ?? "",
        interestRates: snapshot.interestRates,
        feeTerms: snapshot.feeTerms,
        terms: snapshot.terms,
        notes: snapshot.notes ?? "",
        operationKey: operation.key,
        idempotencyKey: operation.idempotencyKey,
        requestHash: operation.requestHash,
        channel: operation.channel,
        actorId: operation.actorId ?? "",
      },
    );
    const result = transactionResult<{
      snapshot: RawFacilitySnapshot;
      operation: RawOperation;
    }>(response, "snapshot");
    return {
      snapshot: normalizeFacilitySnapshot(result.snapshot),
      operation: normalizeOperation(result.operation),
    };
  }

  async recordTransactionWithOperation(
    transaction: TransactionDraft,
    operation: OperationDraft,
  ): Promise<{
    transaction: TransactionRecord;
    operation: FinancialOperationRecord;
  }> {
    const response = await this.client.query(
      `
        BEGIN TRANSACTION;
        LET $accountRef = type::record("account", $accountKey);
        LET $transactionId = type::record("transaction", fn::stringID([$accountRef, $transactionKey]));
        LET $transaction = CREATE ONLY $transactionId CONTENT {
          space: type::record("financialSpace", $spaceKey),
          account: $accountRef,
          key: $transactionKey,
          postedAt: $postedAt,
          effectiveAt: "",
          description: $description,
          normalizedDescription: $description,
          amount: $legacyAmount,
          amountMinor: <int> $amountMinor,
          balance: 0,
          currency: $currency,
          direction: $legacyDirection,
          transactionKind: $transactionKind,
          flowDirection: $flowDirection,
          entrySource: "manual",
          recordedAt: $recordedAt,
          status: "clarified",
          confidence: 1,
          category: IF $categoryKey = "" THEN NONE ELSE type::record("category", $categoryKey) END,
          isTransfer: false,
          operation: type::record("financialOperation", $operationKey),
          manualOverride: true,
          notes: ""
        };
        LET $operation = CREATE ONLY type::record("financialOperation", $operationKey) CONTENT {
          key: $operationKey,
          command: $command,
          idempotencyKey: $idempotencyKey,
          requestHash: $requestHash,
          channel: $channel,
          actorId: $actorId,
          status: "applied",
          resultRefs: [type::string($transaction.id)],
          warningCodes: [],
          recordedAt: $recordedAt,
          completedAt: $recordedAt,
          failureCode: ""
        };
        RETURN { transaction: $transaction, operation: $operation };
        COMMIT TRANSACTION;
      `,
      {
        transactionKey: transaction.key,
        spaceKey: recordKey(transaction.spaceId),
        accountKey: recordKey(transaction.accountId),
        postedAt: transaction.postedAt,
        description: transaction.description,
        legacyAmount: transaction.amountMinor / 100,
        amountMinor: transaction.amountMinor,
        currency: transaction.currency,
        legacyDirection: transaction.kind === "expense" ? "debit" : "credit",
        transactionKind: transaction.kind,
        flowDirection: transaction.flowDirection,
        categoryKey: transaction.categoryId
          ? recordKey(transaction.categoryId)
          : "",
        operationKey: operation.key,
        command: operation.command,
        idempotencyKey: operation.idempotencyKey,
        requestHash: operation.requestHash,
        channel: operation.channel,
        actorId: operation.actorId ?? "",
        recordedAt: operation.recordedAt,
      },
    );
    const result = transactionResult<{
      transaction: RawTransaction;
      operation: RawOperation;
    }>(response, "transaction");
    return {
      transaction: normalizeTransaction({
        ...result.transaction,
        spaceKey: transaction.spaceKey,
        accountKey: transaction.accountKey,
      }),
      operation: normalizeOperation(result.operation),
    };
  }

  async recordTransferWithOperation(
    transfer: TransferDraft,
    operation: OperationDraft,
  ): Promise<{
    transfer: AccountTransferRecord;
    sourceTransaction: TransactionRecord;
    targetTransaction: TransactionRecord;
    operation: FinancialOperationRecord;
  }> {
    const response = await this.client.query(
      `
        BEGIN TRANSACTION;
        LET $sourceAccountRef = type::record("account", $sourceAccountKey);
        LET $targetAccountRef = type::record("account", $targetAccountKey);
        LET $sourceTransactionId = type::record("transaction", fn::stringID([$sourceAccountRef, $sourceTransactionKey]));
        LET $targetTransactionId = type::record("transaction", fn::stringID([$targetAccountRef, $targetTransactionKey]));
        LET $operation = CREATE ONLY type::record("financialOperation", $operationKey) CONTENT {
          key: $operationKey,
          command: "record_transfer",
          idempotencyKey: $idempotencyKey,
          requestHash: $requestHash,
          channel: $channel,
          actorId: $actorId,
          status: "applied",
          resultRefs: [$transferRef, type::string($sourceTransactionId), type::string($targetTransactionId)],
          warningCodes: [],
          recordedAt: $recordedAt,
          completedAt: $recordedAt,
          failureCode: ""
        };
        LET $transfer = CREATE ONLY type::record("accountTransfer", $transferKey) CONTENT {
          key: $transferKey,
          sourceSpace: type::record("financialSpace", $sourceSpaceKey),
          sourceAccount: $sourceAccountRef,
          targetSpace: type::record("financialSpace", $targetSpaceKey),
          targetAccount: $targetAccountRef,
          amountMinor: <int> $amountMinor,
          currency: $currency,
          postedAt: $postedAt,
          description: $description,
          sourceTransaction: $sourceTransactionId,
          targetTransaction: $targetTransactionId,
          operation: type::record("financialOperation", $operationKey),
          recordedAt: $recordedAt
        };
        LET $sourceTransaction = CREATE ONLY $sourceTransactionId CONTENT {
          space: type::record("financialSpace", $sourceSpaceKey), account: $sourceAccountRef,
          key: $sourceTransactionKey, postedAt: $postedAt, effectiveAt: "", description: $legDescription,
          normalizedDescription: $legDescription, amount: $legacyAmount, amountMinor: <int> $amountMinor,
          balance: 0, currency: $currency, direction: "transfer", transactionKind: "transfer",
          flowDirection: "outflow", entrySource: "manual", recordedAt: $recordedAt,
          status: "clarified", confidence: 1, isTransfer: true,
          operation: type::record("financialOperation", $operationKey),
          transfer: type::record("accountTransfer", $transferKey), manualOverride: true, notes: ""
        };
        LET $targetTransaction = CREATE ONLY $targetTransactionId CONTENT {
          space: type::record("financialSpace", $targetSpaceKey), account: $targetAccountRef,
          key: $targetTransactionKey, postedAt: $postedAt, effectiveAt: "", description: $legDescription,
          normalizedDescription: $legDescription, amount: $legacyAmount, amountMinor: <int> $amountMinor,
          balance: 0, currency: $currency, direction: "transfer", transactionKind: "transfer",
          flowDirection: "inflow", entrySource: "manual", recordedAt: $recordedAt,
          status: "clarified", confidence: 1, isTransfer: true,
          operation: type::record("financialOperation", $operationKey),
          transfer: type::record("accountTransfer", $transferKey), manualOverride: true, notes: ""
        };
        RETURN { transfer: $transfer, sourceTransaction: $sourceTransaction,
          targetTransaction: $targetTransaction, operation: $operation };
        COMMIT TRANSACTION;
      `,
      {
        transferKey: transfer.key,
        transferRef: `accountTransfer:${transfer.key}`,
        sourceTransactionKey: transfer.sourceTransactionKey,
        targetTransactionKey: transfer.targetTransactionKey,
        sourceSpaceKey: recordKey(transfer.sourceAccount.spaceId),
        sourceAccountKey: recordKey(transfer.sourceAccount.id),
        targetSpaceKey: recordKey(transfer.targetAccount.spaceId),
        targetAccountKey: recordKey(transfer.targetAccount.id),
        amountMinor: transfer.amountMinor,
        legacyAmount: transfer.amountMinor / 100,
        currency: transfer.currency,
        postedAt: transfer.postedAt,
        description: transfer.description ?? "",
        legDescription:
          transfer.description || "Transfer between tracked accounts",
        operationKey: operation.key,
        idempotencyKey: operation.idempotencyKey,
        requestHash: operation.requestHash,
        channel: operation.channel,
        actorId: operation.actorId ?? "",
        recordedAt: operation.recordedAt,
      },
    );
    const result = transactionResult<{
      transfer: RawTransfer;
      sourceTransaction: RawTransaction;
      targetTransaction: RawTransaction;
      operation: RawOperation;
    }>(response, "transfer");
    return {
      transfer: normalizeTransfer({
        ...result.transfer,
        sourceSpaceKey: transfer.sourceAccount.spaceKey,
        sourceAccountKey: transfer.sourceAccount.key,
        targetSpaceKey: transfer.targetAccount.spaceKey,
        targetAccountKey: transfer.targetAccount.key,
      }),
      sourceTransaction: normalizeTransaction({
        ...result.sourceTransaction,
        spaceKey: transfer.sourceAccount.spaceKey,
        accountKey: transfer.sourceAccount.key,
      }),
      targetTransaction: normalizeTransaction({
        ...result.targetTransaction,
        spaceKey: transfer.targetAccount.spaceKey,
        accountKey: transfer.targetAccount.key,
      }),
      operation: normalizeOperation(result.operation),
    };
  }
}

export function createSurrealAccountControlRepository(
  client: SurrealQueryClient,
): AccountControlRepository {
  return new SurrealAccountControlRepository(client);
}

export function createSurrealFinancialAnalyticsRepository(
  client: SurrealQueryClient,
): FinancialAnalyticsRepository {
  return new SurrealAccountControlRepository(client);
}
