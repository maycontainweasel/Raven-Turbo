import { RavenDomainError } from "@raven/domain";
import type {
  StatementAccountBinding,
  StatementCommitDraft,
  StatementCommitOperation,
  StatementImportReadFilter,
  StatementImportRecord,
  StatementIssueRecord,
  StatementRowComponentRecord,
  StatementRowRecord,
  StatementTruthRepository,
} from "@raven/domain/server";
import type { SurrealQueryClient } from "./repository.js";

type Raw = Record<string, unknown>;
type Statement = {
  status?: string;
  result?: unknown;
  detail?: string;
  error?: unknown;
};

function statementError(statement: Statement): string {
  return (
    statement.detail ??
    (typeof statement.error === "string"
      ? statement.error
      : JSON.stringify(statement.error ?? "")) ??
    ""
  );
}

function unwrap(response: unknown): unknown[] {
  if (!Array.isArray(response)) return response == null ? [] : [response];
  const failed = response.filter((item): item is Statement =>
    Boolean(
      item &&
      typeof item === "object" &&
      "status" in item &&
      (item as Statement).status !== "OK",
    ),
  );
  if (failed.length > 0) {
    throw new RavenDomainError(
      "INTERNAL",
      failed.map(statementError).filter(Boolean).join("\n") ||
        "Statement persistence failed",
    );
  }
  return response.map((item) =>
    item && typeof item === "object" && "result" in item
      ? (item as Statement).result
      : item,
  );
}

function rows<T>(response: unknown): T[] {
  const values = unwrap(response);
  for (let index = values.length - 1; index >= 0; index -= 1) {
    if (Array.isArray(values[index])) return values[index] as T[];
  }
  return [];
}

function transactionResult<T extends object>(
  response: unknown,
  key: keyof T,
): T {
  for (const value of unwrap(response).reverse()) {
    for (const candidate of Array.isArray(value) ? value : [value]) {
      if (candidate && typeof candidate === "object" && key in candidate)
        return candidate as T;
    }
  }
  throw new RavenDomainError(
    "INTERNAL",
    "Statement transaction result was missing",
  );
}

function recordId(value: unknown): string {
  if (typeof value === "string") {
    return value
      .replace(/^([^:]+):`([\s\S]*)`$/, "$1:$2")
      .replace(/^([^:]+):⟨([\s\S]*)⟩$/, "$1:$2");
  }
  if (!value || typeof value !== "object") return String(value ?? "");
  const input = value as Raw;
  const table = input.tb ?? input.table;
  const tableName =
    typeof table === "string"
      ? table
      : (table as { name?: string } | undefined)?.name;
  const key = String(input.id ?? "")
    .replace(/^`([\s\S]*)`$/, "$1")
    .replace(/^⟨([\s\S]*)⟩$/, "$1");
  return tableName ? `${tableName}:${key}` : key;
}

function recordKey(value: string): string {
  return value
    .split(":")
    .slice(1)
    .join(":")
    .replace(/^`([\s\S]*)`$/, "$1")
    .replace(/^⟨([\s\S]*)⟩$/, "$1");
}

function nullableString(value: unknown): string | null {
  return value === null ||
    value === undefined ||
    value === "" ||
    value === "NONE"
    ? null
    : String(value);
}

function nullableInteger(value: unknown): number | null {
  return Number.isSafeInteger(value) ? Number(value) : null;
}

function normalizeAccount(raw: Raw): StatementAccountBinding {
  const accountType = String(raw.accountType ?? "other");
  const normalNature =
    raw.normalNature === "asset" || raw.normalNature === "liability"
      ? raw.normalNature
      : ["credit_card", "loan", "debt"].includes(accountType)
        ? "liability"
        : "asset";
  return {
    id: recordId(raw.id),
    spaceId: recordId(raw.space),
    spaceKey: String(raw.spaceKey ?? ""),
    key: String(raw.key ?? ""),
    currency: String(raw.currency ?? "ZAR"),
    normalNature,
    accountNumberLast4: nullableString(raw.accountNumberLast4),
    spaceTimezone: String(raw.spaceTimezone ?? "Africa/Johannesburg"),
  };
}

export function normalizeStatementImport(raw: Raw): StatementImportRecord {
  const coverage =
    raw.coverage && typeof raw.coverage === "object"
      ? (raw.coverage as Raw)
      : null;
  const sourceState =
    raw.sourceState === "committed" || raw.sourceState === "superseded"
      ? raw.sourceState
      : "legacy";
  const periodStart = String(raw.periodStart ?? "");
  const periodEnd = String(raw.periodEnd ?? "");
  const statementDateValue = nullableString(raw.statementDate);
  const statementDate =
    statementDateValue?.match(/^\d{4}-\d{2}-\d{2}/)?.[0] ?? null;
  const key = String(raw.key ?? "");
  const keyDate = key.match(/^\d{4}-\d{2}-\d{2}(?=-|$)/)?.[0] ?? null;
  const legacyPeriodEvidence: StatementImportRecord["legacyPeriodEvidence"] =
    sourceState !== "legacy"
      ? { statementDate, keyDate, mapping: "not_legacy" }
      : periodStart && periodEnd
        ? { statementDate, keyDate, mapping: "exact_fields" }
        : !periodStart &&
            !periodEnd &&
            statementDate !== null &&
            keyDate === statementDate
          ? { statementDate, keyDate, mapping: "known_renderer_end_date" }
          : { statementDate, keyDate, mapping: "unmappable" };
  return {
    id: recordId(raw.id),
    spaceId: recordId(raw.space),
    accountId: recordId(raw.account),
    spaceKey: String(raw.spaceKey ?? ""),
    accountKey: String(raw.accountKey ?? ""),
    key,
    privateSourceRef: String(raw.privateSourceRef ?? ""),
    extractionAssistRef: nullableString(raw.extractionAssistRef),
    originalFileSha256: String(raw.originalFileSha256 ?? ""),
    extractionInputSha256: nullableString(raw.extractionInputSha256),
    canonicalExtractionSha256: String(raw.canonicalExtractionSha256 ?? ""),
    previewHash: String(raw.previewHash ?? ""),
    sourceKind: raw.sourceFormat as StatementImportRecord["sourceKind"],
    sourceMimeType: String(raw.sourceMimeType ?? ""),
    sourceByteSize: Number(raw.sourceByteSize ?? 0),
    profile: {
      profileId: String(raw.profileId ?? "legacy-unverified"),
      profileVersion: String(raw.profileVersion ?? "legacy-unverified"),
      extractorVersion: String(raw.extractorVersion ?? "legacy-unverified"),
    },
    validationRulesetVersion: String(
      raw.validationRulesetVersion ?? "legacy-unverified",
    ),
    periodStart,
    periodEnd,
    currency: String(raw.currency ?? "unknown"),
    balanceConvention:
      raw.balanceConvention === "positive_is_asset" ||
      raw.balanceConvention === "positive_is_liability"
        ? raw.balanceConvention
        : null,
    balanceConventionAuthority:
      raw.balanceConventionAuthority === "profile" ||
      raw.balanceConventionAuthority === "operator_unverified"
        ? raw.balanceConventionAuthority
        : null,
    accountContextFingerprint: String(raw.accountContextFingerprint ?? ""),
    openingBalanceMinor: nullableInteger(raw.openingBalanceMinor),
    closingBalanceMinor: nullableInteger(raw.closingBalanceMinor),
    closingBalanceEconomicNature:
      raw.closingBalanceEconomicNature === "asset" ||
      raw.closingBalanceEconomicNature === "liability"
        ? raw.closingBalanceEconomicNature
        : null,
    coverage: coverage
      ? {
          status:
            coverage.status === "complete" ||
            coverage.status === "incomplete" ||
            coverage.status === "indeterminate"
              ? coverage.status
              : "indeterminate",
          sourcePageCount: nullableInteger(coverage.sourcePageCount),
          processedPages: Array.isArray(coverage.processedPages)
            ? coverage.processedPages
                .filter(Number.isSafeInteger)
                .map((value) => Number(value))
            : [],
          sourceSections: Array.isArray(coverage.sourceSections)
            ? coverage.sourceSections.map(String)
            : [],
          processedSections: Array.isArray(coverage.processedSections)
            ? coverage.processedSections.map(String)
            : [],
          printedRowCount: nullableInteger(coverage.printedRowCount),
          extractedRowCount: Number(coverage.extractedRowCount ?? 0),
        }
      : null,
    sourceState,
    importedAt: String(raw.importedAt ?? ""),
    committedAt: String(raw.committedAt ?? ""),
    commitOperationId: raw.commitOperation
      ? recordId(raw.commitOperation)
      : null,
    replacementOfId: raw.replacementOf ? recordId(raw.replacementOf) : null,
    rowCount: Number(raw.rowCount ?? 0),
    componentCount: Number(raw.componentCount ?? 0),
    issueCount: Number(raw.issueCount ?? 0),
    revision: Number(raw.revision ?? 1),
    legacyPeriodEvidence,
  };
}

export function normalizeStatementRow(raw: Raw): StatementRowRecord {
  return {
    id: recordId(raw.id),
    spaceId: recordId(raw.space),
    accountId: recordId(raw.account),
    statementImportId: recordId(raw.statementImport),
    commitOperationId: recordId(raw.commitOperation),
    rowKey: String(raw.key ?? ""),
    rowNumber: Number(raw.rowNumber ?? 0),
    rowKind: raw.rowKind as StatementRowRecord["rowKind"],
    transactionDate: nullableString(raw.transactionDate),
    postingDate: nullableString(raw.postingDate),
    valueDate: nullableString(raw.valueDate),
    rawText: String(raw.description ?? ""),
    sourceReference: nullableString(raw.sourceReference),
    reportedBalanceMinor: nullableInteger(raw.reportedBalanceMinor),
    locator:
      raw.sourceLocator && typeof raw.sourceLocator === "object"
        ? (raw.sourceLocator as StatementRowRecord["locator"])
        : null,
    confidence: Number(raw.extractionConfidence ?? 0),
    rowHash: String(raw.rowHash ?? ""),
    componentCount: Number(raw.componentCount ?? 0),
  };
}

function normalizeComponent(raw: Raw): StatementRowComponentRecord {
  return {
    id: recordId(raw.id),
    spaceId: recordId(raw.space),
    accountId: recordId(raw.account),
    statementImportId: recordId(raw.statementImport),
    statementRowId: recordId(raw.statementRow),
    commitOperationId: recordId(raw.commitOperation),
    sourceState: raw.sourceState === "superseded" ? "superseded" : "committed",
    componentKey: String(raw.key ?? ""),
    componentKind:
      raw.componentKind as StatementRowComponentRecord["componentKind"],
    componentRole:
      raw.componentRole as StatementRowComponentRecord["componentRole"],
    transactionDate: nullableString(raw.transactionDate),
    postingDate: nullableString(raw.postingDate),
    valueDate: nullableString(raw.valueDate),
    description: String(raw.description ?? ""),
    sourceReference: nullableString(raw.sourceReference),
    amountMinor: Number(raw.amountMinor ?? 0),
    currency: "ZAR",
    sourceDirection:
      raw.sourceDirection as StatementRowComponentRecord["sourceDirection"],
    sourceFlow: raw.sourceFlow as StatementRowComponentRecord["sourceFlow"],
    balanceEffectMinor: Number(raw.balanceEffectMinor ?? 0),
    locator:
      raw.sourceLocator && typeof raw.sourceLocator === "object"
        ? (raw.sourceLocator as StatementRowComponentRecord["locator"])
        : null,
    confidence: Number(raw.confidence ?? 0),
    sourceChecksum: String(raw.sourceChecksum ?? ""),
    issues: [],
  };
}

function normalizeIssue(raw: Raw): StatementIssueRecord {
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? ""),
    spaceId: recordId(raw.space),
    accountId: recordId(raw.account),
    statementImportId: recordId(raw.statementImport),
    statementRowId: raw.statementRow ? recordId(raw.statementRow) : null,
    statementRowComponentId: raw.statementRowComponent
      ? recordId(raw.statementRowComponent)
      : null,
    code: String(raw.code) as StatementIssueRecord["code"],
    severity: raw.severity as StatementIssueRecord["severity"],
    blocking: raw.blocking === true,
    state: raw.state as StatementIssueRecord["state"],
    message: String(raw.message ?? ""),
    revision: Number(raw.revision ?? 1),
    detectedOperationId: recordId(raw.detectedOperation),
    dispositionOperationId: raw.dispositionOperation
      ? recordId(raw.dispositionOperation)
      : null,
    detectedAt: String(raw.detectedAt ?? ""),
    acknowledgedAt: nullableString(raw.acknowledgedAt),
    resolvedAt: nullableString(raw.resolvedAt),
    reviewedBy: nullableString(raw.reviewedBy),
    notes: nullableString(raw.notes),
  };
}

function normalizeOperation(raw: Raw): StatementCommitOperation {
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? ""),
    command: "commit_statement_import",
    idempotencyKey: String(raw.idempotencyKey ?? ""),
    requestHash: String(raw.requestHash ?? ""),
    channel: raw.channel as StatementCommitOperation["channel"],
    actorId: nullableString(raw.actorId),
    status: raw.status as StatementCommitOperation["status"],
    resultRefs: Array.isArray(raw.resultRefs)
      ? raw.resultRefs.map(recordId)
      : [],
    warningCodes: Array.isArray(raw.warningCodes)
      ? (raw.warningCodes.map(
          String,
        ) as StatementCommitOperation["warningCodes"])
      : [],
    auditMeta:
      raw.auditMeta && typeof raw.auditMeta === "object"
        ? (raw.auditMeta as Raw)
        : {},
    recordedAt: String(raw.recordedAt ?? ""),
    completedAt: nullableString(raw.completedAt),
    failureCode: nullableString(raw.failureCode),
  };
}

function rethrowCommitError(error: unknown): never {
  const message = error instanceof Error ? error.message : String(error);
  if (/STATEMENT_DUPLICATE_SOURCE|statementSourceClaim/i.test(message)) {
    throw new RavenDomainError(
      "STATEMENT_DUPLICATE_SOURCE",
      "This exact source is already committed for the selected account",
    );
  }
  if (/STATEMENT_IMMUTABLE_CONFLICT|statementPeriodClaim/i.test(message)) {
    throw new RavenDomainError(
      "STATEMENT_IMMUTABLE_CONFLICT",
      "The selected account and period already contain a different committed source",
    );
  }
  if (/STATEMENT_LEGACY_PERIOD_CONFLICT/i.test(message)) {
    throw new RavenDomainError(
      "STATEMENT_LEGACY_PERIOD_CONFLICT",
      "A legacy unverified import occupies this exact account period",
    );
  }
  if (/STATEMENT_LEGACY_COMPATIBILITY_REQUIRED/i.test(message)) {
    throw new RavenDomainError(
      "STATEMENT_LEGACY_COMPATIBILITY_REQUIRED",
      "An active legacy import cannot be mapped safely to a statement period",
    );
  }
  if (/STATEMENT_PREVIEW_STALE|STATEMENT_ACCOUNT_INACTIVE/i.test(message)) {
    throw new RavenDomainError(
      "STATEMENT_PREVIEW_STALE",
      "The reviewed account context changed before statement commit",
    );
  }
  throw error;
}

function isRetryableTransactionConflict(error: unknown): boolean {
  const message = error instanceof Error ? error.message : String(error);
  return /transaction conflict[\s\S]*retry/i.test(message);
}

async function rethrowCommitFailure(
  client: SurrealQueryClient,
  draft: StatementCommitDraft,
  error: unknown,
): Promise<never> {
  const message = error instanceof Error ? error.message : String(error);
  if (
    /STATEMENT_DUPLICATE_SOURCE|STATEMENT_IMMUTABLE_CONFLICT|STATEMENT_LEGACY_PERIOD_CONFLICT|STATEMENT_LEGACY_COMPATIBILITY_REQUIRED|STATEMENT_PREVIEW_STALE|STATEMENT_ACCOUNT_INACTIVE/i.test(
      message,
    )
  ) {
    rethrowCommitError(error);
  }
  try {
    const response = await client.query(
      `
      LET $accountId = type::record("account", $accountKey);
      LET $sourceClaimId = type::record(
        "statementSourceClaim",
        fn::stringID([$accountId, $originalFileSha256])
      );
      LET $periodClaimId = type::record(
        "statementPeriodClaim",
        fn::stringID([$accountId, $periodStart, $periodEnd])
      );
      LET $accountContext = SELECT *, space.active AS spaceActive, space.timezone AS spaceTimezone FROM ONLY $accountId;
      LET $accountCurrency = IF $accountContext.currency = NONE OR $accountContext.currency = ""
        THEN "ZAR" ELSE <string> $accountContext.currency END;
      LET $accountNature = IF $accountContext.normalNature = "liability"
        OR (
          $accountContext.normalNature = NONE
          AND $accountContext.accountType IN ["credit_card", "loan", "debt"]
        )
        THEN "liability" ELSE "asset" END;
      LET $accountLast4 = IF $accountContext.accountNumberLast4 = NONE
        THEN "" ELSE <string> $accountContext.accountNumberLast4 END;
      LET $accountTimezone = IF $accountContext.spaceTimezone = NONE OR $accountContext.spaceTimezone = ""
        THEN "Africa/Johannesburg" ELSE <string> $accountContext.spaceTimezone END;
      LET $legacyExact = SELECT id FROM statementImport
        WHERE account = $accountId
          AND (sourceState = NONE OR sourceState = "legacy")
          AND (
            (periodStart = $periodStart AND periodEnd = $periodEnd)
            OR (
              (periodStart = NONE OR periodStart = "")
              AND (periodEnd = NONE OR periodEnd = "")
              AND string::starts_with(<string> statementDate, $periodEnd)
              AND string::starts_with(<string> key, string::concat($periodEnd, "-"))
            )
          );
      LET $legacyUnmappable = SELECT id FROM statementImport
        WHERE account = $accountId
          AND (sourceState = NONE OR sourceState = "legacy")
          AND !(
            (periodStart != NONE AND periodStart != "" AND periodEnd != NONE AND periodEnd != "")
            OR (
              (periodStart = NONE OR periodStart = "")
              AND (periodEnd = NONE OR periodEnd = "")
              AND statementDate != NONE
              AND statementDate != ""
              AND string::starts_with(
                <string> key,
                string::concat(string::slice(<string> statementDate, 0, 10), "-")
              )
            )
          );
      RETURN {
        accountContextChanged: !$accountContext
          OR $accountContext.active != true
          OR $accountContext.spaceActive != true
          OR $accountContext.space != type::record("financialSpace", $spaceKey)
          OR $accountContext.key != $expectedAccount.accountKey
          OR $accountCurrency != $expectedAccount.currency
          OR $accountNature != $expectedAccount.normalNature
          OR $accountLast4 != $expectedAccount.accountNumberLast4
          OR $accountTimezone != $expectedAccount.spaceTimezone,
        legacyExactExists: array::len($legacyExact) > 0,
        legacyUnmappableExists: array::len($legacyUnmappable) > 0,
        sourceClaimExists: record::exists($sourceClaimId),
        periodClaimExists: record::exists($periodClaimId)
      };
      `,
      {
        accountKey: recordKey(draft.statementImport.accountId),
        spaceKey: recordKey(draft.statementImport.spaceId),
        expectedAccount: {
          ...draft.expectedAccountContext,
          accountNumberLast4:
            draft.expectedAccountContext.accountNumberLast4 ?? "",
        },
        originalFileSha256: draft.statementImport.originalFileSha256,
        periodStart: draft.statementImport.periodStart,
        periodEnd: draft.statementImport.periodEnd,
      },
    );
    const state = unwrap(response)
      .flatMap((value) => (Array.isArray(value) ? value : [value]))
      .find((value): value is Raw =>
        Boolean(
          value &&
          typeof value === "object" &&
          ("sourceClaimExists" in value ||
            "periodClaimExists" in value ||
            "accountContextChanged" in value),
        ),
      );
    if (state?.accountContextChanged === true) {
      throw new RavenDomainError(
        "STATEMENT_PREVIEW_STALE",
        "The reviewed account context changed before statement commit",
      );
    }
    if (state?.legacyExactExists === true) {
      throw new RavenDomainError(
        "STATEMENT_LEGACY_PERIOD_CONFLICT",
        "A legacy unverified import occupies this exact account period",
      );
    }
    if (state?.legacyUnmappableExists === true) {
      throw new RavenDomainError(
        "STATEMENT_LEGACY_COMPATIBILITY_REQUIRED",
        "An active legacy import cannot be mapped safely to a statement period",
      );
    }
    if (state?.sourceClaimExists === true) {
      throw new RavenDomainError(
        "STATEMENT_DUPLICATE_SOURCE",
        "This exact source is already committed for the selected account",
      );
    }
    if (state?.periodClaimExists === true) {
      throw new RavenDomainError(
        "STATEMENT_IMMUTABLE_CONFLICT",
        "The selected account and period already contain a different committed source",
      );
    }
  } catch (inspectionError) {
    if (inspectionError instanceof RavenDomainError) throw inspectionError;
  }
  rethrowCommitError(error);
}

export class SurrealStatementTruthRepository implements StatementTruthRepository {
  constructor(private readonly client: SurrealQueryClient) {}

  async getAccount(
    spaceKey: string,
    accountKey: string,
  ): Promise<StatementAccountBinding | null> {
    const response = await this.client.query(
      `SELECT *, space.key AS spaceKey, space.timezone AS spaceTimezone FROM account
       WHERE key = $accountKey AND space.key = $spaceKey AND active = true LIMIT 1;`,
      { spaceKey, accountKey },
    );
    const value = rows<Raw>(response)[0];
    return value ? normalizeAccount(value) : null;
  }

  async getCommitOperation(
    idempotencyKey: string,
  ): Promise<StatementCommitOperation | null> {
    const response = await this.client.query(
      `SELECT * FROM financialOperation
       WHERE command = "commit_statement_import" AND idempotencyKey = $idempotencyKey LIMIT 1;`,
      { idempotencyKey },
    );
    const value = rows<Raw>(response)[0];
    return value ? normalizeOperation(value) : null;
  }

  async listStatementImports(
    filter: StatementImportReadFilter,
  ): Promise<StatementImportRecord[]> {
    const response = await this.client.query(
      `SELECT *, space.key AS spaceKey, account.key AS accountKey FROM statementImport
       WHERE space.key = $spaceKey AND account.key = $accountKey
         AND (
           ($periodStart = "" AND $periodEnd = "")
           OR (periodStart = $periodStart AND periodEnd = $periodEnd)
           OR (
             (sourceState = NONE OR sourceState = "legacy")
             AND (periodStart = NONE OR periodStart = "")
             AND (periodEnd = NONE OR periodEnd = "")
             AND string::starts_with(<string> statementDate, $periodEnd)
             AND string::starts_with(<string> key, string::concat($periodEnd, "-"))
           )
         )
       ORDER BY periodEnd DESC, committedAt DESC;`,
      {
        ...filter,
        periodStart: filter.periodStart ?? "",
        periodEnd: filter.periodEnd ?? "",
      },
    );
    return rows<Raw>(response).map(normalizeStatementImport);
  }

  async getStatementImport(id: string): Promise<StatementImportRecord | null> {
    const response = await this.client.query(
      `SELECT *, space.key AS spaceKey, account.key AS accountKey
       FROM type::record("statementImport", $idKey) LIMIT 1;`,
      { idKey: recordKey(id) },
    );
    const value = rows<Raw>(response)[0];
    return value ? normalizeStatementImport(value) : null;
  }

  async listStatementRows(
    statementImportId: string,
  ): Promise<StatementRowRecord[]> {
    const response = await this.client.query(
      `SELECT * FROM statementRow WHERE statementImport = type::record("statementImport", $idKey)
       ORDER BY rowNumber ASC;`,
      { idKey: recordKey(statementImportId) },
    );
    return rows<Raw>(response).map(normalizeStatementRow);
  }

  async getStatementRow(id: string): Promise<StatementRowRecord | null> {
    const response = await this.client.query(
      `SELECT * FROM type::record("statementRow", $idKey) LIMIT 1;`,
      { idKey: recordKey(id) },
    );
    const value = rows<Raw>(response)[0];
    return value ? normalizeStatementRow(value) : null;
  }

  async listStatementRowComponents(filter: {
    statementImportId?: string;
    statementRowId?: string;
  }): Promise<StatementRowComponentRecord[]> {
    const response = await this.client.query(
      `SELECT * FROM statementRowComponent
       WHERE ($importKey = "" OR statementImport = type::record("statementImport", $importKey))
         AND ($rowKey = "" OR statementRow = type::record("statementRow", $rowKey))
       ORDER BY statementRow.rowNumber ASC, key ASC;`,
      {
        importKey: filter.statementImportId
          ? recordKey(filter.statementImportId)
          : "",
        rowKey: filter.statementRowId ? recordKey(filter.statementRowId) : "",
      },
    );
    return rows<Raw>(response).map(normalizeComponent);
  }

  async getStatementRowComponent(
    id: string,
  ): Promise<StatementRowComponentRecord | null> {
    const response = await this.client.query(
      `SELECT * FROM type::record("statementRowComponent", $idKey) LIMIT 1;`,
      { idKey: recordKey(id) },
    );
    const value = rows<Raw>(response)[0];
    return value ? normalizeComponent(value) : null;
  }

  async listStatementIssues(
    statementImportId: string,
  ): Promise<StatementIssueRecord[]> {
    const response = await this.client.query(
      `SELECT * FROM statementIssue
       WHERE statementImport = type::record("statementImport", $idKey)
       ORDER BY detectedAt ASC, key ASC;`,
      { idKey: recordKey(statementImportId) },
    );
    return rows<Raw>(response).map(normalizeIssue);
  }

  async getStatementIssue(id: string): Promise<StatementIssueRecord | null> {
    const response = await this.client.query(
      `SELECT * FROM type::record("statementIssue", $idKey) LIMIT 1;`,
      { idKey: recordKey(id) },
    );
    const value = rows<Raw>(response)[0];
    return value ? normalizeIssue(value) : null;
  }

  async commitStatementImport(draft: StatementCommitDraft) {
    const importRecord = draft.statementImport;
    const operation = draft.operation;
    let response: unknown;
    const execute = () =>
      this.client.query(
        `
        BEGIN TRANSACTION;
        LET $spaceId = type::record("financialSpace", $spaceKey);
        LET $accountId = type::record("account", $accountKey);
        LET $importId = type::record("statementImport", fn::stringID([$accountId, $import.key]));
        LET $operationId = type::record("financialOperation", $operation.key);
        LET $sourceClaimId = type::record(
          "statementSourceClaim",
          fn::stringID([$accountId, $import.originalFileSha256])
        );
        LET $periodClaimId = type::record(
          "statementPeriodClaim",
          fn::stringID([$accountId, $import.periodStart, $import.periodEnd])
        );
        LET $accountContext = SELECT *, space.active AS spaceActive, space.timezone AS spaceTimezone FROM ONLY $accountId;
        LET $accountCurrency = IF $accountContext.currency = NONE OR $accountContext.currency = ""
          THEN "ZAR" ELSE <string> $accountContext.currency END;
        LET $accountNature = IF $accountContext.normalNature = "liability"
          OR (
            $accountContext.normalNature = NONE
            AND $accountContext.accountType IN ["credit_card", "loan", "debt"]
          )
          THEN "liability" ELSE "asset" END;
        LET $accountLast4 = IF $accountContext.accountNumberLast4 = NONE
          THEN "" ELSE <string> $accountContext.accountNumberLast4 END;
        LET $accountTimezone = IF $accountContext.spaceTimezone = NONE OR $accountContext.spaceTimezone = ""
          THEN "Africa/Johannesburg" ELSE <string> $accountContext.spaceTimezone END;
        IF !$accountContext
          OR $accountContext.active != true
          OR $accountContext.space != $spaceId
          OR $accountContext.spaceActive != true
          OR $accountContext.key != $expectedAccount.accountKey
          OR $accountCurrency != $expectedAccount.currency
          OR $accountNature != $expectedAccount.normalNature
          OR $accountLast4 != $expectedAccount.accountNumberLast4
          OR $accountTimezone != $expectedAccount.spaceTimezone {
          THROW "STATEMENT_PREVIEW_STALE";
        };
        LET $legacyExact = SELECT id FROM statementImport
          WHERE account = $accountId
            AND (sourceState = NONE OR sourceState = "legacy")
            AND (
              (periodStart = $import.periodStart AND periodEnd = $import.periodEnd)
              OR (
                (periodStart = NONE OR periodStart = "")
                AND (periodEnd = NONE OR periodEnd = "")
                AND string::starts_with(<string> statementDate, $import.periodEnd)
                AND string::starts_with(<string> key, string::concat($import.periodEnd, "-"))
              )
            );
        IF array::len($legacyExact) > 0 { THROW "STATEMENT_LEGACY_PERIOD_CONFLICT"; };
        LET $legacyUnmappable = SELECT id FROM statementImport
          WHERE account = $accountId
            AND (sourceState = NONE OR sourceState = "legacy")
            AND !(
              (periodStart != NONE AND periodStart != "" AND periodEnd != NONE AND periodEnd != "")
              OR (
                (periodStart = NONE OR periodStart = "")
                AND (periodEnd = NONE OR periodEnd = "")
                AND statementDate != NONE
                AND statementDate != ""
                AND string::starts_with(
                  <string> key,
                  string::concat(string::slice(<string> statementDate, 0, 10), "-")
                )
              )
            );
        IF array::len($legacyUnmappable) > 0 { THROW "STATEMENT_LEGACY_COMPATIBILITY_REQUIRED"; };
        LET $snapshotId = IF $hasSnapshot
          THEN type::record("accountBalanceSnapshot", $snapshot.key)
          ELSE NONE
        END;
        LET $resultRefs = IF $hasSnapshot
          THEN [type::string($importId), type::string($snapshotId)]
          ELSE [type::string($importId)]
        END;
        LET $operationRecord = CREATE ONLY $operationId CONTENT {
          key: $operation.key,
          command: "commit_statement_import",
          idempotencyKey: $operation.idempotencyKey,
          requestHash: $operation.requestHash,
          channel: $operation.channel,
          actorId: IF $operation.hasActorId THEN $operation.actorId ELSE NONE END,
          status: "applied",
          resultRefs: $resultRefs,
          warningCodes: $operation.warningCodes,
          auditMeta: $operation.auditMeta,
          recordedAt: $operation.recordedAt,
          completedAt: $operation.recordedAt,
          failureCode: ""
        };
        IF record::exists($sourceClaimId) { THROW "STATEMENT_DUPLICATE_SOURCE"; };
        LET $sourceClaim = CREATE ONLY $sourceClaimId CONTENT {
          space: $spaceId,
          account: $accountId,
          statementImport: $importId,
          key: $import.originalFileSha256,
          originalFileSha256: $import.originalFileSha256,
          periodStart: $import.periodStart,
          periodEnd: $import.periodEnd,
          state: "active",
          claimedAt: $import.committedAt,
          operation: $operationId
        };
        IF record::exists($periodClaimId) { THROW "STATEMENT_IMMUTABLE_CONFLICT"; };
        LET $periodClaim = CREATE ONLY $periodClaimId CONTENT {
          space: $spaceId,
          account: $accountId,
          statementImport: $importId,
          key: string::concat($import.periodStart, "|", $import.periodEnd),
          periodStart: $import.periodStart,
          periodEnd: $import.periodEnd,
          originalFileSha256: $import.originalFileSha256,
          state: "active",
          claimedAt: $import.committedAt,
          operation: $operationId
        };
        LET $statementImport = CREATE ONLY $importId CONTENT {
          space: $spaceId,
          account: $accountId,
          key: $import.key,
          sourceFileName: "private-source",
          sourceFormat: $import.sourceKind,
          privateSourceRef: $import.privateSourceRef,
          extractionAssistRef: IF $import.hasExtractionAssist
            THEN $import.extractionAssistRef
            ELSE NONE
          END,
          originalFileSha256: $import.originalFileSha256,
          extractionInputSha256: IF $import.hasExtractionInputSha256
            THEN $import.extractionInputSha256
            ELSE NONE
          END,
          canonicalExtractionSha256: $import.canonicalExtractionSha256,
          previewHash: $import.previewHash,
          sourceMimeType: $import.sourceMimeType,
          sourceByteSize: <int> $import.sourceByteSize,
          profileId: $import.profileId,
          profileVersion: $import.profileVersion,
          extractorVersion: $import.extractorVersion,
          validationRulesetVersion: $import.validationRulesetVersion,
          periodStart: $import.periodStart,
          periodEnd: $import.periodEnd,
          currency: $import.currency,
          balanceConvention: $import.balanceConvention,
          balanceConventionAuthority: $import.balanceConventionAuthority,
          accountContextFingerprint: $import.accountContextFingerprint,
          openingBalanceMinor: IF $import.hasOpeningBalance
            THEN <int> $import.openingBalanceMinor
            ELSE NONE
          END,
          closingBalanceMinor: IF $import.hasClosingBalance
            THEN <int> $import.closingBalanceMinor
            ELSE NONE
          END,
          closingBalanceEconomicNature: IF $import.hasClosingBalanceEconomicNature
            THEN $import.closingBalanceEconomicNature
            ELSE NONE
          END,
          coverage: $import.coverage,
          sourceState: "committed",
          commitOperation: $operationId,
          committedAt: $import.committedAt,
          importedAt: $import.importedAt,
          statementDate: $import.periodEnd,
          status: "parsed",
          rowCount: <int> $import.rowCount,
          componentCount: <int> $import.componentCount,
          issueCount: <int> $import.issueCount,
          revision: <int> $import.revision,
          normalizedCount: 0,
          clarificationCount: 0,
          sourceChecksum: $import.originalFileSha256,
          notes: ""
        };
        RELATE $accountId->AccountStatementImports->$importId;
        FOR $row IN $rows {
          LET $rowId = type::record("statementRow", fn::stringID([$importId, $row.key]));
          LET $createdRow = CREATE ONLY $rowId CONTENT {
            space: $spaceId,
            account: $accountId,
            statementImport: $importId,
            key: $row.key,
            rowNumber: <int> $row.rowNumber,
            rowKind: $row.rowKind,
            transactionDate: IF $row.hasTransactionDate THEN $row.transactionDate ELSE NONE END,
            postingDate: IF $row.hasPostingDate THEN $row.postingDate ELSE NONE END,
            valueDate: IF $row.hasValueDate THEN $row.valueDate ELSE NONE END,
            sourceReference: IF $row.hasSourceReference THEN $row.sourceReference ELSE NONE END,
            sourceLocator: IF $row.hasLocator THEN $row.locator ELSE NONE END,
            reportedBalanceMinor: IF $row.hasReportedBalance
              THEN <int> $row.reportedBalanceMinor
              ELSE NONE
            END,
            componentCount: <int> $row.componentCount,
            extractionConfidence: $row.confidence,
            rowHash: $row.rowHash,
            commitOperation: $operationId,
            postedAt: IF $row.hasPostingDate THEN $row.postingDate ELSE "" END,
            description: $row.rawText,
            normalizedDescription: "",
            amount: 0,
            balance: 0,
            currency: $import.currency,
            direction: "unknown",
            status: "raw",
            confidence: $row.confidence,
            rawData: {},
            sourceChecksum: $row.rowHash,
            notes: ""
          };
          RELATE $importId->StatementImportRows->$rowId;
        };
        FOR $component IN $components {
          LET $rowId = type::record("statementRow", fn::stringID([$importId, $component.rowKey]));
          LET $componentId = type::record("statementRowComponent", fn::stringID([$rowId, $component.componentKey]));
          LET $createdComponent = CREATE ONLY $componentId CONTENT {
            space: $spaceId,
            account: $accountId,
            statementImport: $importId,
            statementRow: $rowId,
            key: $component.componentKey,
            componentKind: $component.componentKind,
            componentRole: $component.componentRole,
            transactionDate: IF $component.hasTransactionDate
              THEN $component.transactionDate
              ELSE NONE
            END,
            postingDate: IF $component.hasPostingDate THEN $component.postingDate ELSE NONE END,
            valueDate: IF $component.hasValueDate THEN $component.valueDate ELSE NONE END,
            description: $component.description,
            sourceReference: IF $component.hasSourceReference
              THEN $component.sourceReference
              ELSE NONE
            END,
            amountMinor: <int> $component.amountMinor,
            currency: $component.currency,
            sourceDirection: $component.sourceDirection,
            sourceFlow: $component.sourceFlow,
            balanceEffectMinor: <int> $component.balanceEffectMinor,
            sourceLocator: IF $component.hasLocator THEN $component.locator ELSE NONE END,
            confidence: $component.confidence,
            sourceChecksum: $component.sourceChecksum,
            sourceState: "committed",
            commitOperation: $operationId,
            notes: ""
          };
          RELATE $rowId->StatementRowComponents->$componentId;
        };
        FOR $issue IN $issues {
          LET $issueId = type::record("statementIssue", fn::stringID([$importId, $issue.key]));
          LET $rowId = IF $issue.rowKey = ""
            THEN NONE
            ELSE type::record("statementRow", fn::stringID([$importId, $issue.rowKey]))
          END;
          LET $componentId = IF $issue.componentKey = "" OR $issue.rowKey = ""
            THEN NONE
            ELSE type::record("statementRowComponent", fn::stringID([$rowId, $issue.componentKey]))
          END;
          LET $createdIssue = CREATE ONLY $issueId CONTENT {
            space: $spaceId,
            account: $accountId,
            statementImport: $importId,
            statementRow: $rowId,
            statementRowComponent: $componentId,
            key: $issue.key,
            code: $issue.code,
            severity: $issue.severity,
            blocking: false,
            state: "open",
            message: $issue.message,
            revision: 1,
            detectedOperation: $operationId,
            detectedAt: $issue.detectedAt,
            notes: ""
          };
          RELATE $importId->StatementImportIssues->$issueId;
        };
        LET $snapshotRecord = IF $hasSnapshot
          THEN CREATE ONLY $snapshotId CONTENT {
            space: $spaceId,
            account: $accountId,
            key: $snapshot.key,
            balanceKind: "statement",
            amountMinor: <int> $snapshot.amountMinor,
            currency: $snapshot.currency,
            economicNature: $snapshot.economicNature,
            asOf: $snapshot.asOf,
            recordedAt: $snapshot.recordedAt,
            evidenceLevel: "observed",
            sourceKind: "statement_closing",
            sourceRef: type::string($importId),
            operation: $operationId,
            notes: ""
          }
          ELSE NONE
        END;
        RETURN {
          statementImport: $statementImport,
          operation: $operationRecord,
          snapshotId: IF $hasSnapshot THEN type::string($snapshotId) ELSE NONE END
        };
        COMMIT TRANSACTION;
        `,
        {
          spaceKey: recordKey(importRecord.spaceId),
          accountKey: recordKey(importRecord.accountId),
          import: {
            ...importRecord,
            profileId: importRecord.profile.profileId,
            profileVersion: importRecord.profile.profileVersion,
            extractorVersion: importRecord.profile.extractorVersion,
            hasExtractionAssist: importRecord.extractionAssistRef !== null,
            extractionAssistRef: importRecord.extractionAssistRef ?? "",
            hasExtractionInputSha256:
              importRecord.extractionInputSha256 !== null,
            extractionInputSha256: importRecord.extractionInputSha256 ?? "",
            hasOpeningBalance: importRecord.openingBalanceMinor !== null,
            openingBalanceMinor: importRecord.openingBalanceMinor ?? 0,
            hasClosingBalance: importRecord.closingBalanceMinor !== null,
            closingBalanceMinor: importRecord.closingBalanceMinor ?? 0,
            hasClosingBalanceEconomicNature:
              importRecord.closingBalanceEconomicNature !== null,
            closingBalanceEconomicNature:
              importRecord.closingBalanceEconomicNature ?? "asset",
          },
          expectedAccount: {
            ...draft.expectedAccountContext,
            accountNumberLast4:
              draft.expectedAccountContext.accountNumberLast4 ?? "",
          },
          rows: draft.rows.map((row) => ({
            ...row,
            hasTransactionDate: row.transactionDate !== null,
            transactionDate: row.transactionDate ?? "",
            hasPostingDate: row.postingDate !== null,
            postingDate: row.postingDate ?? "",
            hasValueDate: row.valueDate !== null,
            valueDate: row.valueDate ?? "",
            hasSourceReference: row.sourceReference !== null,
            sourceReference: row.sourceReference ?? "",
            hasReportedBalance: row.reportedBalanceMinor !== null,
            reportedBalanceMinor: row.reportedBalanceMinor ?? 0,
            hasLocator: row.locator !== null,
            locator: row.locator ?? {},
          })),
          components: draft.components.map((component) => ({
            ...component,
            hasTransactionDate: component.transactionDate !== null,
            transactionDate: component.transactionDate ?? "",
            hasPostingDate: component.postingDate !== null,
            postingDate: component.postingDate ?? "",
            hasValueDate: component.valueDate !== null,
            valueDate: component.valueDate ?? "",
            hasSourceReference: component.sourceReference !== null,
            sourceReference: component.sourceReference ?? "",
            hasLocator: component.locator !== null,
            locator: component.locator ?? {},
          })),
          issues: draft.issues.map((issue) => ({
            ...issue,
            rowKey: issue.rowKey ?? "",
            componentKey: issue.componentKey ?? "",
          })),
          operation: {
            ...operation,
            hasActorId:
              operation.actorId !== null && operation.actorId !== undefined,
            actorId: operation.actorId ?? "",
            warningCodes: operation.warningCodes ?? [],
            auditMeta: operation.auditMeta ?? {},
          },
          hasSnapshot: draft.snapshot !== null,
          snapshot: draft.snapshot ?? {
            key: "",
            amountMinor: 0,
            currency: "ZAR",
            economicNature: "asset",
            asOf: "",
            recordedAt: operation.recordedAt,
          },
        },
      );
    for (let attempt = 0; attempt < 5; attempt += 1) {
      try {
        response = await execute();
        break;
      } catch (error) {
        if (attempt < 4 && isRetryableTransactionConflict(error)) {
          await new Promise((resolve) =>
            setTimeout(resolve, 10 * 2 ** attempt),
          );
          continue;
        }
        await rethrowCommitFailure(this.client, draft, error);
      }
    }
    const result = transactionResult<{
      statementImport: Raw;
      operation: Raw;
      snapshotId: unknown;
    }>(response, "statementImport");
    return {
      statementImport: normalizeStatementImport({
        ...result.statementImport,
        spaceKey: importRecord.spaceKey,
        accountKey: importRecord.accountKey,
      }),
      operation: normalizeOperation(result.operation),
      snapshotId: result.snapshotId ? recordId(result.snapshotId) : null,
    };
  }
}

export function createSurrealStatementTruthRepository(
  client: SurrealQueryClient,
): StatementTruthRepository {
  return new SurrealStatementTruthRepository(client);
}
