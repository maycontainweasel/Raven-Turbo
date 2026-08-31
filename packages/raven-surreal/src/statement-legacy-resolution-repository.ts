import { RavenDomainError } from "@raven/domain";
import { canonicalStatementJson, statementSha256 } from "@raven/domain/server";
import { inspect } from "node:util";
import type {
  AccountTransferRecord,
  FinancialOperationRecord,
  RavenErrorCode,
  StatementLegacyApplyDraft,
  StatementLegacyResolutionItemRecord,
  StatementLegacyResolutionOperation,
  StatementLegacyResolutionRecord,
  StatementLegacyResolutionRepository,
  StatementLegacyResolutionResult,
  StatementLegacyReverseDraft,
  StatementReconciliationRecord,
  StatementTransactionMatchRecord,
  TransactionRecord,
} from "@raven/domain/server";

import { normalizeTransaction, type SurrealQueryClient } from "./repository.js";
import {
  createSurrealStatementTruthRepository,
  normalizeStatementImport,
} from "./statement-repository.js";
import {
  createSurrealStatementResolutionRepository,
  normalizeStatementReconciliation,
  normalizeStatementResolutionOperation,
  normalizeStatementTransactionMatch,
} from "./statement-resolution-repository.js";

type Raw = Record<string, unknown>;
type Statement = {
  status?: string;
  result?: unknown;
  detail?: string;
  error?: unknown;
};

function statementError(statement: Statement): string {
  return (
    statement.detail ||
    (typeof statement.error === "string"
      ? statement.error
      : JSON.stringify(statement.error ?? "")) ||
    (typeof statement.result === "string"
      ? statement.result
      : JSON.stringify(statement.result ?? "")) ||
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
    throw new Error(
      failed.map(statementError).filter(Boolean).join("\n") ||
        "Statement legacy-resolution persistence failed",
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
    const value = values[index];
    if (Array.isArray(value)) return value as T[];
    if (value && typeof value === "object") return [value as T];
  }
  return [];
}

async function detailedQuery(
  client: SurrealQueryClient,
  query: string,
  vars: Record<string, unknown>,
): Promise<unknown> {
  const request = client.query(query, vars) as unknown as {
    responses?: () => Promise<
      Array<
        | { success: true; result: unknown }
        | { success: false; error: unknown }
        | undefined
      >
    >;
    then?: Promise<unknown>["then"];
  };
  if (typeof request.responses !== "function") {
    return await (request as unknown as Promise<unknown>);
  }
  const responses = await request.responses();
  const failures = responses.filter(
    (response): response is { success: false; error: unknown } =>
      response?.success === false,
  );
  if (failures.length > 0) {
    const messages = failures
      .map((failure) =>
        failure.error && typeof failure.error === "object"
          ? inspect(failure.error, { depth: 4, showHidden: true })
          : String(failure.error ?? ""),
      )
      .filter(Boolean);
    throw new Error(
      messages.join("\n") || "Statement legacy-resolution persistence failed",
    );
  }
  return responses.map((response) =>
    response?.success === true ? response.result : undefined,
  );
}

function transactionResult<T extends object>(
  response: unknown,
  key: keyof T,
): T {
  for (const value of unwrap(response).reverse()) {
    for (const candidate of Array.isArray(value) ? value : [value]) {
      if (candidate && typeof candidate === "object" && key in candidate) {
        return candidate as T;
      }
    }
  }
  throw new RavenDomainError(
    "INTERNAL",
    "Legacy-resolution transaction result was missing",
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
  return recordId(value).split(":").slice(1).join(":");
}

function nullableString(value: unknown): string | null {
  return value === null ||
    value === undefined ||
    value === "" ||
    value === "NONE"
    ? null
    : recordId(value);
}

function normalizeOperation(raw: Raw): StatementLegacyResolutionOperation {
  return {
    ...normalizeStatementResolutionOperation(raw),
    command: raw.command as StatementLegacyResolutionOperation["command"],
  } as StatementLegacyResolutionOperation;
}

function normalizeResolution(raw: Raw): StatementLegacyResolutionRecord {
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? ""),
    spaceId: recordId(raw.space),
    accountId: recordId(raw.account),
    legacyStatementImportId: recordId(raw.legacyStatementImport),
    canonicalStatementImportId: recordId(raw.canonicalStatementImport),
    resolutionType: raw.resolutionType === "reversal" ? "reversal" : "apply",
    strategy: raw.strategy as StatementLegacyResolutionRecord["strategy"],
    authorityEffect:
      raw.authorityEffect === "restore_previous"
        ? "restore_previous"
        : "activate_canonical",
    previousLegacySourceState:
      raw.previousLegacySourceState === "committed" ? "committed" : "legacy",
    previousSourceClaimState:
      raw.previousSourceClaimState === "active" ||
      raw.previousSourceClaimState === "released"
        ? raw.previousSourceClaimState
        : "absent",
    previousPeriodClaimState:
      raw.previousPeriodClaimState === "active" ||
      raw.previousPeriodClaimState === "released"
        ? raw.previousPeriodClaimState
        : "absent",
    targetResolutionId: nullableString(raw.targetResolution),
    predecessorResolutionId: nullableString(raw.predecessorResolution),
    databaseFingerprint: String(raw.databaseFingerprint ?? ""),
    sourceIdentityHash: String(raw.sourceIdentityHash ?? ""),
    canonicalPreviewHash: String(raw.canonicalPreviewHash ?? ""),
    legacyEvidenceHash: String(raw.legacyEvidenceHash ?? ""),
    accountContextFingerprint: String(raw.accountContextFingerprint ?? ""),
    crosswalkHash: String(raw.crosswalkHash ?? ""),
    expectedRevisionClaimHash: String(raw.expectedRevisionClaimHash ?? ""),
    resultAuthorityHash: String(raw.resultAuthorityHash ?? ""),
    aggregateCounts:
      raw.aggregateCounts && typeof raw.aggregateCounts === "object"
        ? (raw.aggregateCounts as StatementLegacyResolutionRecord["aggregateCounts"])
        : ({} as StatementLegacyResolutionRecord["aggregateCounts"]),
    idempotencyKey: String(raw.idempotencyKey ?? ""),
    requestHash: String(raw.requestHash ?? ""),
    channel: raw.channel as StatementLegacyResolutionRecord["channel"],
    actorId:
      raw.actorId === null || raw.actorId === undefined
        ? null
        : String(raw.actorId),
    operationId: recordId(raw.operation),
    recordedAt: String(raw.recordedAt ?? ""),
  };
}

function normalizeItem(raw: Raw): StatementLegacyResolutionItemRecord {
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? ""),
    statementLegacyResolutionId: recordId(raw.statementLegacyResolution),
    compatibilityClass:
      raw.compatibilityClass as StatementLegacyResolutionItemRecord["compatibilityClass"],
    activeLedgerOutcome:
      raw.activeLedgerOutcome as StatementLegacyResolutionItemRecord["activeLedgerOutcome"],
    canonicalComponentIds: Array.isArray(raw.canonicalComponentIds)
      ? raw.canonicalComponentIds.map(recordId)
      : [],
    legacyStatementRowId: nullableString(raw.legacyStatementRow),
    legacyTransactionIds: Array.isArray(raw.legacyTransactionIds)
      ? raw.legacyTransactionIds.map(recordId)
      : [],
    primaryLegacyTransactionId: nullableString(raw.legacyTransaction),
    accountTransferId: nullableString(raw.accountTransfer),
    itemEvidenceHash: String(raw.itemEvidenceHash ?? ""),
    expectedClaimHash: String(raw.expectedClaimHash ?? ""),
    operationId: recordId(raw.operation),
    recordedAt: String(raw.recordedAt ?? ""),
  };
}

function normalizeTransfer(raw: Raw): AccountTransferRecord {
  return {
    id: recordId(raw.id),
    key: String(raw.key ?? ""),
    source: {
      spaceKey: String(raw.sourceSpaceKey ?? ""),
      accountKey: String(raw.sourceAccountKey ?? ""),
      accountId: recordId(raw.sourceAccount),
    },
    target: {
      spaceKey: String(raw.targetSpaceKey ?? ""),
      accountKey: String(raw.targetAccountKey ?? ""),
      accountId: recordId(raw.targetAccount),
    },
    amountMinor: Number(raw.amountMinor ?? 0),
    currency: String(raw.currency ?? "ZAR"),
    postedAt: String(raw.postedAt ?? ""),
    description:
      raw.description === null || raw.description === undefined
        ? null
        : String(raw.description),
    sourceTransactionId: recordId(raw.sourceTransaction),
    targetTransactionId: recordId(raw.targetTransaction),
    operationId: recordId(raw.operation),
    recordedAt: String(raw.recordedAt ?? ""),
  };
}

const TRANSACTION_SELECT = `id, key, space AS spaceId, space.key AS spaceKey,
  account AS accountId, account.key AS accountKey, postedAt, effectiveAt, recordedAt,
  description, amount, amountMinor, currency, direction, transactionKind,
  flowDirection, entrySource, category AS categoryId,
  category.key AS categoryKey, category.name AS categoryName,
  category.categoryKind AS categoryKind, status, merchantName, notes,
  sourceRow AS sourceRowId, statementMatch AS statementMatchId,
  statementMatch.statementImport AS statementImportId,
  statementMatch.state AS statementMatchState,
  statementMatch.sourceState AS statementMatchSourceState,
  statementMatch.statementImport.sourceState AS statementImportSourceState,
  operation AS operationId, transfer AS transferId, isTransfer`;

function sourceImportVars(
  value: StatementLegacyApplyDraft["source"]["statementImport"],
) {
  return {
    ...value,
    profileId: value.profile.profileId,
    profileVersion: value.profile.profileVersion,
    extractorVersion: value.profile.extractorVersion,
    hasExtractionAssist: value.extractionAssistRef !== null,
    extractionAssistRef: value.extractionAssistRef ?? "",
    hasExtractionInputSha256: value.extractionInputSha256 !== null,
    extractionInputSha256: value.extractionInputSha256 ?? "",
    hasOpeningBalance: value.openingBalanceMinor !== null,
    openingBalanceMinor: value.openingBalanceMinor ?? 0,
    hasClosingBalance: value.closingBalanceMinor !== null,
    closingBalanceMinor: value.closingBalanceMinor ?? 0,
    hasClosingBalanceEconomicNature:
      value.closingBalanceEconomicNature !== null,
    closingBalanceEconomicNature: value.closingBalanceEconomicNature ?? "asset",
  };
}

function sourceRowsVars(value: StatementLegacyApplyDraft["source"]["rows"]) {
  return value.map((row) => ({
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
  }));
}

function sourceComponentsVars(
  value: StatementLegacyApplyDraft["source"]["components"],
) {
  return value.map((component) => ({
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
  }));
}

function itemVars(draft: StatementLegacyApplyDraft) {
  const decisions = new Map(
    draft.decisions.map((decision) => [decision.itemKey, decision]),
  );
  return draft.plan.items.map((item) => {
    const decision = decisions.get(item.key);
    const activeLedgerOutcome =
      item.activeLedgerOutcome ?? decision?.outcome ?? "historical_only";
    const materializedTransactionKey = `legacy-resolution-${draft.source.statementImport.key}-${item.key}`;
    const componentDrafts = item.canonicalComponents.map((component) => {
      const source = draft.source.components.find(
        (candidate) =>
          candidate.rowKey === component.rowKey &&
          candidate.componentKey === component.componentKey,
      );
      if (!source) {
        throw new RavenDomainError(
          "STATEMENT_LEGACY_CROSSWALK_DRIFT",
          "A planned canonical component is absent from the source draft",
        );
      }
      return {
        rowKey: component.rowKey,
        componentKey: component.componentKey,
        description: source.description,
        financialDate:
          source.transactionDate ??
          source.postingDate ??
          source.valueDate ??
          "",
        amountMinor: source.amountMinor,
        balanceEffectMinor: source.balanceEffectMinor,
        currency: source.currency,
        sourceFlow: source.sourceFlow,
        componentKind: source.componentKind,
        sourceChecksum: source.sourceChecksum,
      };
    });
    return {
      key: item.key,
      compatibilityClass: item.compatibilityClass,
      activeLedgerOutcome,
      components: componentDrafts,
      legacyStatementRowKey: item.legacyStatementRowId
        ? recordKey(item.legacyStatementRowId)
        : "",
      hasLegacyStatementRow: item.legacyStatementRowId !== null,
      legacyTransactionKeys: item.legacyTransactionIds.map(recordKey),
      hasLegacyTransaction: item.primaryLegacyTransactionId !== null,
      legacyTransactionKey: item.primaryLegacyTransactionId
        ? recordKey(item.primaryLegacyTransactionId)
        : "",
      hasAccountTransfer: item.accountTransferId !== null,
      accountTransferKey: item.accountTransferId
        ? recordKey(item.accountTransferId)
        : "",
      itemEvidenceHash: item.itemEvidenceHash,
      expectedClaimHash: item.expectedClaimHash,
      materializedTransactionKey,
      targetTransactionKey:
        activeLedgerOutcome === "materialized"
          ? `account:${recordKey(draft.evidence.legacyStatementImport.accountId)}|${materializedTransactionKey}`
          : item.primaryLegacyTransactionId
            ? recordKey(item.primaryLegacyTransactionId)
            : "",
    };
  });
}

function rethrowPersistenceError(error: unknown): never {
  const message = error instanceof Error ? error.message : String(error);
  const errorRecord =
    error && typeof error === "object" ? (error as Record<string, unknown>) : {};
  const mappings: readonly [string, RavenErrorCode][] = [
    [
      "STATEMENT_LEGACY_ACTIVE_CLAIM_CONFLICT",
      "STATEMENT_LEGACY_ACTIVE_CLAIM_CONFLICT",
    ],
    [
      "STATEMENT_LEGACY_DUPLICATE_ACTIVE_MOVEMENT",
      "STATEMENT_LEGACY_DUPLICATE_ACTIVE_MOVEMENT",
    ],
    ["STATEMENT_LEGACY_EVIDENCE_DRIFT", "STATEMENT_LEGACY_EVIDENCE_DRIFT"],
    [
      "STATEMENT_LEGACY_ROLLBACK_INELIGIBLE",
      "STATEMENT_LEGACY_ROLLBACK_INELIGIBLE",
    ],
    ["STATEMENT_LEGACY_REPLAY_CONFLICT", "STATEMENT_LEGACY_REPLAY_CONFLICT"],
    [
      "STATEMENT_ACCOUNT_CONTEXT_STALE",
      "STATEMENT_LEGACY_ACCOUNT_CONTEXT_DRIFT",
    ],
  ];
  const mapped = mappings.find(([needle]) => message.includes(needle));
  throw new RavenDomainError(
    mapped?.[1] ?? "INTERNAL",
    mapped
      ? "Legacy-resolution persistence rejected stale or conflicting authority"
      : "Legacy-resolution persistence failed",
    {
      persistenceMessage: message,
      persistenceErrorName:
        error instanceof Error ? error.name : typeof error,
      persistenceErrorCode:
        typeof errorRecord.code === "string" ? errorRecord.code : null,
      persistenceErrorCause:
        errorRecord.cause === undefined
          ? null
          : errorRecord.cause instanceof Error
            ? `${errorRecord.cause.name}: ${errorRecord.cause.message}`
            : String(errorRecord.cause),
      persistenceErrorInspection: inspect(error, {
        depth: 5,
        showHidden: true,
        breakLength: 160,
      }).slice(0, 8_000),
    },
  );
}

export class SurrealStatementLegacyResolutionRepository implements StatementLegacyResolutionRepository {
  readonly #source;
  readonly #resolution;

  constructor(
    private readonly client: SurrealQueryClient,
    private readonly databaseFingerprint: string,
  ) {
    this.#source = createSurrealStatementTruthRepository(client);
    this.#resolution = createSurrealStatementResolutionRepository(client);
  }

  async getOperation(
    command: StatementLegacyResolutionOperation["command"],
    idempotencyKey: string,
  ): Promise<StatementLegacyResolutionOperation | null> {
    const response = await this.client.query(
      `SELECT * FROM financialOperation
       WHERE command = $command AND idempotencyKey = $idempotencyKey LIMIT 1;`,
      { command, idempotencyKey },
    );
    const value = rows<Raw>(response)[0];
    return value ? normalizeOperation(value) : null;
  }

  async getResolution(
    id: string,
  ): Promise<StatementLegacyResolutionRecord | null> {
    const response = await this.client.query(
      `SELECT * FROM type::record("statementLegacyResolution", $key) LIMIT 1;`,
      { key: recordKey(id) },
    );
    const value = rows<Raw>(response)[0];
    return value ? normalizeResolution(value) : null;
  }

  getStatementImport(id: string) {
    return this.#source.getStatementImport(id);
  }

  getReconciliation(statementImportId: string) {
    return this.#resolution.getStatementReconciliation(statementImportId);
  }

  async listResolutionItems(
    resolutionId: string,
  ): Promise<StatementLegacyResolutionItemRecord[]> {
    const response = await this.client.query(
      `SELECT * FROM statementLegacyResolutionItem
       WHERE statementLegacyResolution = type::record("statementLegacyResolution", $key)
       ORDER BY key ASC, id ASC;`,
      { key: recordKey(resolutionId) },
    );
    return rows<Raw>(response).map(normalizeItem);
  }

  async loadEvidence(legacyStatementImportId: string) {
    const legacyStatementImport = await this.#source.getStatementImport(
      legacyStatementImportId,
    );
    if (!legacyStatementImport) {
      throw new RavenDomainError(
        "NOT_FOUND",
        "The selected legacy statement import was not found",
      );
    }
    const [legacyRows, transactionResponse, activeClaimResponse] =
      await Promise.all([
        this.#source.listStatementRows(legacyStatementImport.id),
        this.client.query(
          `SELECT ${TRANSACTION_SELECT}
           FROM transaction
           WHERE sourceRow.statementImport = type::record("statementImport", $importKey)
           ORDER BY postedAt ASC, id ASC;`,
          { importKey: recordKey(legacyStatementImport.id) },
        ),
        this.client.query(
          `SELECT VALUE type::string(transaction)
           FROM statementTransactionResolutionClaim WHERE state = "active";`,
        ),
      ]);
    const activeClaims = new Set(
      unwrap(activeClaimResponse).flat(Infinity).map(String),
    );
    const legacyTransactions = rows<Raw>(transactionResponse).map((value) => {
      const normalized = normalizeTransaction(value);
      return {
        ...normalized,
        hasActiveStatementClaim:
          normalized.hasActiveStatementClaim || activeClaims.has(normalized.id),
      };
    });
    const amounts = [
      ...new Set(legacyTransactions.map((value) => value.amountMinor)),
    ].filter((value): value is number => value !== null);
    const [
      counterpartResponse,
      transferResponse,
      matchResponse,
      authorityResponse,
    ] = await Promise.all([
      amounts.length
        ? this.client.query(
            `SELECT ${TRANSACTION_SELECT}
               FROM transaction
               WHERE account != type::record("account", $accountKey)
                 AND account.active = true AND account.space.active = true
                 AND currency = $currency AND amountMinor IN $amounts
                 AND postedAt >= $periodStart AND postedAt <= $periodEnd
               ORDER BY postedAt ASC, id ASC;`,
            {
              accountKey: recordKey(legacyStatementImport.accountId),
              currency: legacyStatementImport.currency,
              amounts,
              periodStart: legacyStatementImport.periodStart,
              periodEnd: legacyStatementImport.periodEnd,
            },
          )
        : Promise.resolve([]),
      this.client.query(
        `SELECT *, sourceSpace.key AS sourceSpaceKey,
             sourceAccount.key AS sourceAccountKey,
             targetSpace.key AS targetSpaceKey,
             targetAccount.key AS targetAccountKey
           FROM accountTransfer
           WHERE postedAt >= $periodStart AND postedAt <= $periodEnd
           ORDER BY postedAt ASC, id ASC;`,
        {
          periodStart: legacyStatementImport.periodStart,
          periodEnd: legacyStatementImport.periodEnd,
        },
      ),
      this.client.query(
        `SELECT * FROM statementTransactionMatch
           WHERE state = "confirmed" AND sourceState = "committed";`,
      ),
      this.client.query(
        `SELECT id, resultAuthorityHash, resolutionType, authorityEffect,
             targetResolution, predecessorResolution, operation, recordedAt
           FROM statementLegacyResolution
           WHERE legacyStatementImport = type::record("statementImport", $importKey)
              OR canonicalStatementImport = type::record("statementImport", $importKey)
           ORDER BY recordedAt ASC, id ASC;`,
        { importKey: recordKey(legacyStatementImport.id) },
      ),
    ]);
    const legacyIds = new Set(legacyTransactions.map((value) => value.id));
    const activeMatches = rows<Raw>(matchResponse)
      .map(normalizeStatementTransactionMatch)
      .filter((value) => legacyIds.has(value.transactionId));
    const reconciliation = await this.#resolution.getStatementReconciliation(
      legacyStatementImport.id,
    );
    const dependentAuthorityHash = statementSha256(
      canonicalStatementJson(
        rows<Raw>(authorityResponse).map((value) => ({
          id: recordId(value.id),
          resultAuthorityHash: String(value.resultAuthorityHash ?? ""),
          resolutionType: String(value.resolutionType ?? ""),
          authorityEffect: String(value.authorityEffect ?? ""),
          targetResolution: nullableString(value.targetResolution),
          predecessorResolution: nullableString(value.predecessorResolution),
          operation: nullableString(value.operation),
        })),
      ),
    );
    return {
      databaseFingerprint: this.databaseFingerprint,
      legacyStatementImport,
      legacyRows,
      legacyTransactions,
      counterpartTransactions:
        rows<Raw>(counterpartResponse).map(normalizeTransaction),
      accountTransfers: rows<Raw>(transferResponse).map(normalizeTransfer),
      activeMatches,
      reconciliation,
      dependentAuthorityHash,
    };
  }

  async apply(
    draft: StatementLegacyApplyDraft,
  ): Promise<StatementLegacyResolutionResult> {
    const source = draft.source.statementImport;
    const operation = draft.operation;
    const items = itemVars(draft);
    const signedMovementEffectMinor = draft.source.components
      .filter((component) => component.componentRole === "movement")
      .reduce((total, component) => total + component.balanceEffectMinor, 0);
    const informationalComponentCount = draft.source.components.filter(
      (component) => component.componentRole === "informational_breakdown",
    ).length;
    const movementComponentCount =
      draft.source.components.length - informationalComponentCount;
    const expectedClosingBalanceMinor =
      source.openingBalanceMinor === null
        ? null
        : source.openingBalanceMinor + signedMovementEffectMinor;
    const differenceMinor =
      expectedClosingBalanceMinor === null ||
      source.closingBalanceMinor === null
        ? null
        : expectedClosingBalanceMinor - source.closingBalanceMinor;
    try {
      const response = await detailedQuery(
        this.client,
        `BEGIN TRANSACTION;
         LET $legacyImportId = type::record("statementImport", $legacyImportKey);
         LET $legacyImport = SELECT * FROM ONLY $legacyImportId;
         IF !$legacyImport
           OR $legacyImport.revision != <int> $expectedLegacyRevision
           OR $legacyImport.sourceState != $expectedLegacySourceState
           OR $legacyImport.account.key != $source.accountKey
           OR $legacyImport.space.key != $source.spaceKey
           OR $legacyImport.periodStart != $source.periodStart
           OR $legacyImport.periodEnd != $source.periodEnd
           OR $legacyImport.currency != $source.currency
           OR $legacyImport.accountContextFingerprint != $source.accountContextFingerprint {
           THROW "STATEMENT_LEGACY_EVIDENCE_DRIFT_SOURCE";
         };
         LET $accountContext = SELECT *, space.active AS spaceActive,
           space.timezone AS spaceTimezone FROM ONLY $legacyImport.account;
         LET $accountCurrency = IF $accountContext.currency = NONE OR $accountContext.currency = ""
           THEN "ZAR" ELSE <string> $accountContext.currency END;
         LET $accountNature = IF $accountContext.normalNature = "liability"
           OR $accountContext.normalNature = "asset"
           THEN $accountContext.normalNature
           ELSE IF $accountContext.accountType IN ["credit_card", "loan", "debt"]
             THEN "liability" ELSE "asset" END;
         LET $accountLast4 = IF $accountContext.accountNumberLast4 = NONE
           THEN "" ELSE <string> $accountContext.accountNumberLast4 END;
         LET $accountTimezone = IF $accountContext.spaceTimezone = NONE OR $accountContext.spaceTimezone = ""
           THEN "Africa/Johannesburg" ELSE <string> $accountContext.spaceTimezone END;
         IF !$accountContext OR $accountContext.active != true
           OR $accountContext.spaceActive != true
           OR $accountCurrency != $expectedAccount.currency
           OR $accountNature != $expectedAccount.normalNature
           OR $accountLast4 != $expectedAccount.accountNumberLast4
           OR $accountTimezone != $expectedAccount.spaceTimezone
           OR $source.accountContextFingerprint != $expectedAccount.accountContextFingerprint {
           THROW "STATEMENT_ACCOUNT_CONTEXT_STALE";
         };
         LET $operationId = type::record("financialOperation", $operation.key);
         IF record::exists($operationId) { THROW "STATEMENT_LEGACY_REPLAY_CONFLICT"; };
         LET $canonicalImportId = type::record("statementImport", fn::stringID([$legacyImport.account, $source.key]));
         IF record::exists($canonicalImportId)
           OR $source.originalFileSha256 = $legacyImport.originalFileSha256 {
           THROW "STATEMENT_LEGACY_DUPLICATE_ACTIVE_MOVEMENT";
         };
         LET $periodClaimId = type::record("statementPeriodClaim", fn::stringID([
           $legacyImport.account, $source.periodStart, $source.periodEnd
         ]));
         LET $periodClaim = SELECT * FROM ONLY $periodClaimId;
         IF $periodClaim AND $periodClaim.state = "active"
           AND $periodClaim.statementImport != $legacyImportId {
           THROW "STATEMENT_LEGACY_ACTIVE_CLAIM_CONFLICT";
         };
         LET $sourceClaimId = type::record("statementSourceClaim", fn::stringID([
           $legacyImport.account, $source.originalFileSha256
         ]));
         LET $sourceClaim = SELECT * FROM ONLY $sourceClaimId;
         IF $sourceClaim AND $sourceClaim.state = "active" {
           THROW "STATEMENT_LEGACY_ACTIVE_CLAIM_CONFLICT";
         };
         LET $canonicalImport = CREATE ONLY $canonicalImportId CONTENT {
           space: $legacyImport.space, account: $legacyImport.account,
           key: $source.key, sourceFileName: "private-source",
           sourceFormat: $source.sourceKind,
           privateSourceRef: $source.privateSourceRef,
           extractionAssistRef: IF $source.hasExtractionAssist THEN $source.extractionAssistRef ELSE NONE END,
           originalFileSha256: $source.originalFileSha256,
           extractionInputSha256: IF $source.hasExtractionInputSha256 THEN $source.extractionInputSha256 ELSE NONE END,
           canonicalExtractionSha256: $source.canonicalExtractionSha256,
           previewHash: $source.previewHash,
           sourceMimeType: $source.sourceMimeType,
           sourceByteSize: <int> $source.sourceByteSize,
           profileId: $source.profileId, profileVersion: $source.profileVersion,
           extractorVersion: $source.extractorVersion,
           validationRulesetVersion: $source.validationRulesetVersion,
           periodStart: $source.periodStart, periodEnd: $source.periodEnd,
           currency: $source.currency,
           balanceConvention: $source.balanceConvention,
           balanceConventionAuthority: $source.balanceConventionAuthority,
           accountContextFingerprint: $source.accountContextFingerprint,
           openingBalanceMinor: IF $source.hasOpeningBalance THEN <int> $source.openingBalanceMinor ELSE NONE END,
           closingBalanceMinor: IF $source.hasClosingBalance THEN <int> $source.closingBalanceMinor ELSE NONE END,
           closingBalanceEconomicNature: IF $source.hasClosingBalanceEconomicNature THEN $source.closingBalanceEconomicNature ELSE NONE END,
           coverage: $source.coverage, sourceState: "committed",
           commitOperation: $operationId, committedAt: $source.committedAt,
           importedAt: $source.importedAt, replacementOf: $legacyImportId,
           statementDate: $source.periodEnd, status: "parsed",
           rowCount: <int> $source.rowCount, componentCount: <int> $source.componentCount,
           issueCount: <int> $source.issueCount, revision: 1,
           normalizedCount: 0, clarificationCount: 0,
           sourceChecksum: $source.originalFileSha256, notes: ""
         };
         LET $sourceAccountId = $legacyImport.account;
         RELATE $sourceAccountId->AccountStatementImports->$canonicalImportId;
         FOR $row IN $rows {
           LET $rowId = type::record("statementRow", fn::stringID([$canonicalImportId, $row.key]));
           CREATE ONLY $rowId CONTENT {
             space: $legacyImport.space, account: $legacyImport.account,
             statementImport: $canonicalImportId, key: $row.key,
             rowNumber: <int> $row.rowNumber, rowKind: $row.rowKind,
             transactionDate: IF $row.hasTransactionDate THEN $row.transactionDate ELSE NONE END,
             postingDate: IF $row.hasPostingDate THEN $row.postingDate ELSE NONE END,
             valueDate: IF $row.hasValueDate THEN $row.valueDate ELSE NONE END,
             sourceReference: IF $row.hasSourceReference THEN $row.sourceReference ELSE NONE END,
             sourceLocator: IF $row.hasLocator THEN $row.locator ELSE NONE END,
             reportedBalanceMinor: IF $row.hasReportedBalance THEN <int> $row.reportedBalanceMinor ELSE NONE END,
             componentCount: <int> $row.componentCount,
             extractionConfidence: $row.confidence, rowHash: $row.rowHash,
             commitOperation: $operationId,
             postedAt: IF $row.hasPostingDate THEN $row.postingDate ELSE "" END,
             description: $row.rawText, normalizedDescription: "",
             amount: 0, balance: 0, currency: $source.currency,
             direction: "unknown", status: "raw", confidence: $row.confidence,
             rawData: {}, sourceChecksum: $row.rowHash, notes: ""
           };
           RELATE $canonicalImportId->StatementImportRows->$rowId;
         };
         FOR $component IN $components {
           LET $rowId = type::record("statementRow", fn::stringID([$canonicalImportId, $component.rowKey]));
           LET $componentId = type::record("statementRowComponent", fn::stringID([$rowId, $component.componentKey]));
           CREATE ONLY $componentId CONTENT {
             space: $legacyImport.space, account: $legacyImport.account,
             statementImport: $canonicalImportId, statementRow: $rowId,
             key: $component.componentKey, componentKind: $component.componentKind,
             componentRole: $component.componentRole,
             transactionDate: IF $component.hasTransactionDate THEN $component.transactionDate ELSE NONE END,
             postingDate: IF $component.hasPostingDate THEN $component.postingDate ELSE NONE END,
             valueDate: IF $component.hasValueDate THEN $component.valueDate ELSE NONE END,
             description: $component.description,
             sourceReference: IF $component.hasSourceReference THEN $component.sourceReference ELSE NONE END,
             amountMinor: <int> $component.amountMinor, currency: $component.currency,
             sourceDirection: $component.sourceDirection, sourceFlow: $component.sourceFlow,
             balanceEffectMinor: <int> $component.balanceEffectMinor,
             sourceLocator: IF $component.hasLocator THEN $component.locator ELSE NONE END,
             confidence: $component.confidence, sourceChecksum: $component.sourceChecksum,
             sourceState: "committed", commitOperation: $operationId, notes: ""
           };
           RELATE $rowId->StatementRowComponents->$componentId;
         };
         FOR $issue IN $issues {
           LET $issueId = type::record("statementIssue", fn::stringID([$canonicalImportId, $issue.key]));
           LET $rowId = IF $issue.rowKey = "" THEN NONE ELSE type::record("statementRow", fn::stringID([$canonicalImportId, $issue.rowKey])) END;
           LET $componentId = IF $issue.componentKey = "" OR $issue.rowKey = "" THEN NONE
             ELSE type::record("statementRowComponent", fn::stringID([$rowId, $issue.componentKey])) END;
           CREATE ONLY $issueId CONTENT {
             space: $legacyImport.space, account: $legacyImport.account,
             statementImport: $canonicalImportId, statementRow: $rowId,
             statementRowComponent: $componentId, key: $issue.key,
             code: $issue.code, severity: $issue.severity, blocking: false,
             state: "open", message: $issue.message, revision: 1,
             detectedOperation: $operationId, detectedAt: $issue.detectedAt, notes: ""
           };
           RELATE $canonicalImportId->StatementImportIssues->$issueId;
         };
         LET $resolutionKey = string::concat("apply-", $operation.key);
         LET $resolutionId = type::record("statementLegacyResolution", fn::stringID([$canonicalImportId, $resolutionKey]));
         LET $resolution = CREATE ONLY $resolutionId CONTENT {
           space: $legacyImport.space, account: $legacyImport.account,
           legacyStatementImport: $legacyImportId,
           canonicalStatementImport: $canonicalImportId,
           key: $resolutionKey, resolutionType: "apply", strategy: $strategy,
           authorityEffect: "activate_canonical", targetResolution: NONE,
           previousLegacySourceState: $expectedLegacySourceState,
           previousSourceClaimState: IF array::len((SELECT * FROM statementSourceClaim
             WHERE statementImport = $legacyImportId LIMIT 1)) = 0 THEN "absent"
             ELSE IF array::first((SELECT VALUE state FROM statementSourceClaim
               WHERE statementImport = $legacyImportId LIMIT 1)) = "active" THEN "active" ELSE "released" END,
           previousPeriodClaimState: IF !$periodClaim THEN "absent" ELSE $periodClaim.state END,
           predecessorResolution: NONE,
           databaseFingerprint: $plan.databaseFingerprint,
           sourceIdentityHash: $plan.sourceIdentityHash,
           canonicalPreviewHash: $plan.canonicalPreviewHash,
           legacyEvidenceHash: $plan.legacyEvidenceHash,
           accountContextFingerprint: $plan.accountContextFingerprint,
           crosswalkHash: $plan.crosswalkHash,
           expectedRevisionClaimHash: $plan.expectedRevisionClaimHash,
           resultAuthorityHash: $plan.resultAuthorityHash,
           aggregateCounts: $plan.aggregateCounts,
           idempotencyKey: $operation.idempotencyKey,
           requestHash: $operation.requestHash, channel: $operation.channel,
           actorId: IF $operation.hasActorId THEN $operation.actorId ELSE NONE END,
           operation: $operationId, recordedAt: $operation.recordedAt
         };
         FOR $materializationItem IN $materializationItemsInput {
           LET $componentRecords = $materializationItem.components.map(|$component| {
             LET $itemRowId = type::record("statementRow", fn::stringID([$canonicalImportId, $component.rowKey]));
             RETURN type::record("statementRowComponent", fn::stringID([$itemRowId, $component.componentKey]));
           });
           LET $primaryComponent = array::first($componentRecords);
           LET $newTransactionId = type::record("transaction", $materializationItem.targetTransactionKey);
           LET $effect = math::sum($materializationItem.components.balanceEffectMinor);
           LET $first = array::first($materializationItem.components);
           CREATE ONLY $newTransactionId CONTENT {
             space: $legacyImport.space, account: $legacyImport.account,
             key: $materializationItem.targetTransactionKey,
             sourceRow: $primaryComponent.statementRow,
             sourceChecksum: $first.sourceChecksum,
             postedAt: $first.financialDate, effectiveAt: $first.financialDate,
             description: $first.description, normalizedDescription: "",
             amount: math::abs($effect) / 100, amountMinor: <int> math::abs($effect),
             balance: 0, currency: $first.currency,
             direction: IF $effect < 0 THEN "debit" ELSE "credit" END,
             transactionKind: IF $first.componentKind = "adjustment" THEN "adjustment"
               ELSE IF $effect < 0 THEN "expense" ELSE "income" END,
             flowDirection: IF $effect < 0 THEN "outflow" ELSE "inflow" END,
             entrySource: "imported", recordedAt: $operation.recordedAt,
             status: "matched", confidence: 1, merchantName: "",
             isTransfer: false, operation: $operationId, manualOverride: false, notes: ""
           };
         };
         FOR $movementItem IN $movementItemsInput {
           LET $componentRecords = $movementItem.components.map(|$component| {
             LET $itemRowId = type::record("statementRow", fn::stringID([$canonicalImportId, $component.rowKey]));
             RETURN type::record("statementRowComponent", fn::stringID([$itemRowId, $component.componentKey]));
           });
           LET $primaryComponent = array::first($componentRecords);
           LET $transactionId = type::record("transaction", $movementItem.targetTransactionKey);
           LET $existingTransaction = SELECT * FROM ONLY $transactionId;
           LET $existingClaimId = type::record("statementTransactionResolutionClaim", fn::stringID([$transactionId, "active"]));
           LET $existingClaim = SELECT * FROM ONLY $existingClaimId;
           LET $effect = math::sum($movementItem.components.balanceEffectMinor);
           LET $first = array::first($movementItem.components);
           LET $existingAmountMinor = IF $existingTransaction.amountMinor = NONE
             OR <int> $existingTransaction.amountMinor <= 0
             THEN <int> math::round($existingTransaction.amount * 100)
             ELSE <int> $existingTransaction.amountMinor END;
           LET $existingFlowDirection = IF $existingTransaction.flowDirection = "inflow"
             OR $existingTransaction.flowDirection = "outflow"
             THEN $existingTransaction.flowDirection
             ELSE IF $existingTransaction.direction = "debit" THEN "outflow"
             ELSE IF $existingTransaction.direction = "credit" THEN "inflow"
             ELSE "" END;
           LET $existingFinancialDate = string::slice(
             <string> $existingTransaction.postedAt, 0, 10
           );
           LET $matchId = type::record("statementTransactionMatch", fn::stringID([$canonicalImportId, $movementItem.key]));
           CREATE ONLY $matchId CONTENT {
             space: $legacyImport.space, account: $legacyImport.account,
             statementImport: $canonicalImportId,
             primaryComponent: $primaryComponent, componentIds: $componentRecords,
             transaction: $transactionId, key: $movementItem.key,
             state: "confirmed", method: IF array::len($componentRecords) > 1 THEN "grouped_exact" ELSE "explicit" END,
             reasonCodes: ["EXPLICIT_OPERATOR_SELECTION", "EXACT_FINANCIAL_DATE"],
             confidence: 1, signedComponentTotalMinor: <int> $effect,
             currency: $source.currency, revision: 1,
             proposedOperation: $operationId, confirmedOperation: $operationId,
             proposedBy: IF $operation.hasActorId THEN $operation.actorId ELSE NONE END,
             reviewedBy: IF $operation.hasActorId THEN $operation.actorId ELSE NONE END,
             proposedAt: $operation.recordedAt, confirmedAt: $operation.recordedAt,
             sourceState: "committed"
           };
           FOR $componentId IN $componentRecords {
             LET $componentClaimId = type::record("statementComponentResolutionClaim", fn::stringID([$componentId, "active"]));
             CREATE ONLY $componentClaimId CONTENT {
               space: $legacyImport.space, account: $legacyImport.account,
               statementImport: $canonicalImportId, statementRowComponent: $componentId,
               statementTransactionMatch: $matchId, transaction: $transactionId,
               key: "active", state: "active", claimedAt: $operation.recordedAt,
               operation: $operationId
             };
           };
           UPSERT ONLY $existingClaimId CONTENT {
             space: $legacyImport.space, account: $legacyImport.account,
             statementImport: $canonicalImportId,
             statementTransactionMatch: $matchId, transaction: $transactionId,
             key: "active", periodStart: $source.periodStart, periodEnd: $source.periodEnd,
             state: "active", claimedAt: $operation.recordedAt, operation: $operationId
           };
           UPDATE ONLY $transactionId SET statementMatch = $matchId,
             effectiveAt = $first.financialDate;
           LET $guardError = IF $existingClaim AND $existingClaim.state = "active" {
             "STATEMENT_LEGACY_ACTIVE_CLAIM_CONFLICT"
           } ELSE IF array::len($componentRecords) != array::len($movementItem.components)
             OR !$existingTransaction OR $existingTransaction.account != $legacyImport.account
             OR $existingTransaction.currency != $first.currency
             OR $existingAmountMinor != math::abs($effect)
             OR $existingFinancialDate != string::slice(<string> $first.financialDate, 0, 10)
             OR $existingFlowDirection != IF $effect < 0 THEN "outflow" ELSE "inflow" END {
             "STATEMENT_LEGACY_EVIDENCE_DRIFT"
           } ELSE { "" };
           IF $guardError != "" {
             THROW $guardError;
           };
         };
         FOR $resolutionItem IN $resolutionItemsInput {
           LET $componentRecords = $resolutionItem.components.map(|$component| {
             LET $itemRowId = type::record("statementRow", fn::stringID([$canonicalImportId, $component.rowKey]));
             RETURN type::record("statementRowComponent", fn::stringID([$itemRowId, $component.componentKey]));
           });
           LET $componentIdStrings = $componentRecords.map(|$componentId| type::string($componentId));
           LET $primaryComponent = array::first($componentRecords);
           LET $itemId = type::record("statementLegacyResolutionItem", fn::stringID([$resolutionId, $resolutionItem.key]));
           CREATE ONLY $itemId CONTENT {
             space: $legacyImport.space, account: $legacyImport.account,
             statementLegacyResolution: $resolutionId,
             canonicalStatementImport: $canonicalImportId,
             legacyStatementImport: $legacyImportId, key: $resolutionItem.key,
             compatibilityClass: $resolutionItem.compatibilityClass,
             activeLedgerOutcome: $resolutionItem.activeLedgerOutcome,
             canonicalComponent: IF array::len($componentRecords) > 0 THEN $primaryComponent ELSE NONE END,
             canonicalComponentIds: $componentIdStrings,
             legacyStatementRow: IF $resolutionItem.hasLegacyStatementRow THEN type::record("statementRow", $resolutionItem.legacyStatementRowKey) ELSE NONE END,
             legacyTransaction: IF $resolutionItem.hasLegacyTransaction THEN type::record("transaction", $resolutionItem.legacyTransactionKey) ELSE NONE END,
             legacyTransactionIds: $resolutionItem.legacyTransactionKeys,
             accountTransfer: IF $resolutionItem.hasAccountTransfer THEN type::record("accountTransfer", $resolutionItem.accountTransferKey) ELSE NONE END,
             itemEvidenceHash: $resolutionItem.itemEvidenceHash,
             expectedClaimHash: $resolutionItem.expectedClaimHash,
             operation: $operationId, recordedAt: $operation.recordedAt
           };
         };
         UPDATE statementSourceClaim SET state = "released", operation = $operationId
           WHERE statementImport = $legacyImportId AND state = "active";
         LET $sourceClaimRecord = UPSERT ONLY $sourceClaimId CONTENT {
           space: $legacyImport.space, account: $legacyImport.account,
           statementImport: $canonicalImportId, key: $source.originalFileSha256,
           originalFileSha256: $source.originalFileSha256,
           periodStart: $source.periodStart, periodEnd: $source.periodEnd,
           state: "active", claimedAt: $operation.recordedAt, operation: $operationId
         };
         LET $periodClaimRecord = UPSERT ONLY $periodClaimId CONTENT {
           space: $legacyImport.space, account: $legacyImport.account,
           statementImport: $canonicalImportId,
           key: string::concat($source.periodStart, "|", $source.periodEnd),
           periodStart: $source.periodStart, periodEnd: $source.periodEnd,
           originalFileSha256: $source.originalFileSha256,
           state: "active", claimedAt: $operation.recordedAt, operation: $operationId
         };
         LET $supersededLegacy = UPDATE ONLY $legacyImportId SET sourceState = "superseded", revision += 1;
         LET $reconciliationId = type::record("statementReconciliation", fn::stringID([$canonicalImportId, "current"]));
         LET $reconciliation = CREATE ONLY $reconciliationId CONTENT {
           space: $legacyImport.space, account: $legacyImport.account,
           statementImport: $canonicalImportId, key: "current",
           periodStart: $source.periodStart, periodEnd: $source.periodEnd,
           currency: $source.currency,
           openingBalanceMinor: IF $reconciliation.hasOpening THEN <int> $reconciliation.openingBalanceMinor ELSE NONE END,
           signedMovementEffectMinor: <int> $reconciliation.signedMovementEffectMinor,
           expectedClosingBalanceMinor: IF $reconciliation.hasExpectedClosing THEN <int> $reconciliation.expectedClosingBalanceMinor ELSE NONE END,
           reportedClosingBalanceMinor: IF $reconciliation.hasReportedClosing THEN <int> $reconciliation.reportedClosingBalanceMinor ELSE NONE END,
           differenceMinor: IF $reconciliation.hasDifference THEN <int> $reconciliation.differenceMinor ELSE NONE END,
           printedRowCount: <int> $source.rowCount, extractedRowCount: <int> $source.rowCount,
           movementComponentCount: <int> $reconciliation.movementComponentCount,
           informationalComponentCount: <int> $reconciliation.informationalComponentCount,
           pendingCount: 0, proposedCount: 0,
           confirmedExistingCount: <int> $reconciliation.confirmedExistingCount,
           newlyMaterializedCount: <int> $reconciliation.newlyMaterializedCount,
           unresolvedCount: 0, transferCandidateCount: 0,
           activeIssueCount: <int> $source.issueCount, blockingIssueCount: 0,
           calculationState: IF $reconciliation.hasDifference AND $reconciliation.differenceMinor = 0 THEN "balanced" ELSE "unavailable" END,
           coverageState: "complete", attestationState: "ready",
           calculationHash: $reconciliation.calculationHash, revision: 1,
           calculatedAt: $operation.recordedAt, calculationOperation: $operationId,
           provenance: { legacyResolution: type::string($resolutionId), strategy: $strategy }
         };
         LET $resultRefs = [type::string($canonicalImportId), type::string($resolutionId), type::string($reconciliationId)];
         LET $operationRecord = CREATE ONLY $operationId CONTENT {
           key: $operation.key, command: $operation.command,
           idempotencyKey: $operation.idempotencyKey,
           requestHash: $operation.requestHash, channel: $operation.channel,
           actorId: IF $operation.hasActorId THEN $operation.actorId ELSE NONE END,
           status: "applied", resultRefs: $resultRefs,
           warningCodes: [], auditMeta: $operation.auditMeta,
           recordedAt: $operation.recordedAt, completedAt: $operation.recordedAt
         };
         LET $resolutionItems = SELECT * FROM statementLegacyResolutionItem
           WHERE statementLegacyResolution = $resolutionId ORDER BY key ASC;
         RETURN { resolution: $resolution, items: $resolutionItems,
           statementImport: $canonicalImport, reconciliation: $reconciliation,
           operation: $operationRecord };
         COMMIT TRANSACTION;`,
        {
          legacyImportKey: recordKey(draft.evidence.legacyStatementImport.id),
          expectedLegacyRevision: draft.evidence.legacyStatementImport.revision,
          expectedLegacySourceState:
            draft.evidence.legacyStatementImport.sourceState,
          source: sourceImportVars(source),
          expectedAccount: draft.source.expectedAccountContext,
          rows: sourceRowsVars(draft.source.rows),
          components: sourceComponentsVars(draft.source.components),
          issues: draft.source.issues.map((issue) => ({
            ...issue,
            rowKey: issue.rowKey ?? "",
            componentKey: issue.componentKey ?? "",
          })),
          resolutionItemsInput: items,
          movementItemsInput: items.filter((item) =>
            [
              "adopted_existing",
              "adopted_grouped",
              "materialized",
              "confirmed_transfer",
            ].includes(item.activeLedgerOutcome),
          ),
          materializationItemsInput: items.filter(
            (item) => item.activeLedgerOutcome === "materialized",
          ),
          strategy: draft.strategy,
          plan: draft.plan,
          operation: {
            ...operation,
            hasActorId:
              operation.actorId !== null && operation.actorId !== undefined,
            actorId: operation.actorId ?? "",
            auditMeta: operation.auditMeta ?? {},
          },
          reconciliation: {
            hasOpening: source.openingBalanceMinor !== null,
            openingBalanceMinor: source.openingBalanceMinor ?? 0,
            signedMovementEffectMinor,
            hasExpectedClosing: expectedClosingBalanceMinor !== null,
            expectedClosingBalanceMinor: expectedClosingBalanceMinor ?? 0,
            hasReportedClosing: source.closingBalanceMinor !== null,
            reportedClosingBalanceMinor: source.closingBalanceMinor ?? 0,
            hasDifference: differenceMinor !== null,
            differenceMinor: differenceMinor ?? 0,
            movementComponentCount,
            informationalComponentCount,
            confirmedExistingCount: items.filter((item) =>
              [
                "adopted_existing",
                "adopted_grouped",
                "confirmed_transfer",
              ].includes(item.activeLedgerOutcome),
            ).length,
            newlyMaterializedCount: items.filter(
              (item) => item.activeLedgerOutcome === "materialized",
            ).length,
            calculationHash: statementSha256(
              canonicalStatementJson({
                authority: draft.plan.resultAuthorityHash,
                openingBalanceMinor: source.openingBalanceMinor,
                signedMovementEffectMinor,
                expectedClosingBalanceMinor,
                reportedClosingBalanceMinor: source.closingBalanceMinor,
                differenceMinor,
              }),
            ),
          },
        },
      );
      const result = transactionResult<{
        resolution: Raw;
        items: Raw[];
        statementImport: Raw;
        reconciliation: Raw;
        operation: Raw;
      }>(response, "resolution");
      const operationRecord = normalizeOperation(result.operation);
      return {
        resolution: normalizeResolution(result.resolution),
        items: result.items.map(normalizeItem),
        statementImport: normalizeStatementImport({
          ...result.statementImport,
          spaceKey: source.spaceKey,
          accountKey: source.accountKey,
        }),
        reconciliation: normalizeStatementReconciliation(result.reconciliation),
        receipt: {
          operationId: operationRecord.id,
          status: "applied",
          resultRefs: operationRecord.resultRefs,
          completedAt:
            operationRecord.completedAt ?? operationRecord.recordedAt,
        },
      };
    } catch (error) {
      rethrowPersistenceError(error);
    }
  }

  async reverse(
    draft: StatementLegacyReverseDraft,
  ): Promise<StatementLegacyResolutionResult> {
    const operation = draft.operation;
    const reversalAuthorityHash = statementSha256(
      canonicalStatementJson({
        targetResolutionId: draft.target.id,
        targetAuthorityHash: draft.expectedAuthorityHash,
        operationRequestHash: operation.requestHash,
        effect: "restore_previous",
      }),
    );
    try {
      const response = await this.client.query(
        `BEGIN TRANSACTION;
         LET $targetResolutionId = type::record("statementLegacyResolution", $targetResolutionKey);
         LET $target = SELECT * FROM ONLY $targetResolutionId;
         IF !$target OR $target.resolutionType != "apply"
           OR $target.databaseFingerprint != $expectedDatabaseFingerprint
           OR $target.resultAuthorityHash != $expectedAuthorityHash {
           THROW "STATEMENT_LEGACY_ROLLBACK_INELIGIBLE";
         };
         LET $laterAuthority = SELECT * FROM statementLegacyResolution
           WHERE targetResolution = $targetResolutionId
              OR predecessorResolution = $targetResolutionId LIMIT 1;
         LET $canonicalImport = SELECT * FROM ONLY $target.canonicalStatementImport;
         LET $legacyImport = SELECT * FROM ONLY $target.legacyStatementImport;
         LET $periodClaimId = type::record("statementPeriodClaim", fn::stringID([
           $canonicalImport.account, $canonicalImport.periodStart, $canonicalImport.periodEnd
         ]));
         LET $periodClaim = SELECT * FROM ONLY $periodClaimId;
         IF array::len($laterAuthority) > 0 OR !$canonicalImport OR !$legacyImport
           OR $canonicalImport.sourceState != "committed"
           OR !$periodClaim OR $periodClaim.state != "active"
           OR $periodClaim.statementImport != $canonicalImport.id {
           THROW "STATEMENT_LEGACY_ROLLBACK_INELIGIBLE";
         };
         LET $operationId = type::record("financialOperation", $operation.key);
         IF record::exists($operationId) { THROW "STATEMENT_LEGACY_REPLAY_CONFLICT"; };
         LET $targetOperationId = $target.operation;
         FOR $match IN (SELECT * FROM statementTransactionMatch
           WHERE statementImport = $canonicalImport.id
             AND proposedOperation = $targetOperationId
             AND sourceState = "committed") {
           UPDATE ONLY $match.transaction SET
             statementMatch = NONE, effectiveAt = NONE,
             status = IF operation = $targetOperationId AND entrySource = "imported"
               THEN "ignored" ELSE status END
             WHERE statementMatch = $match.id;
         };
         UPDATE statementComponentResolutionClaim SET
           state = "released", releasedAt = $operation.recordedAt,
           operation = $operationId
           WHERE statementImport = $canonicalImport.id AND state = "active";
         UPDATE statementTransactionResolutionClaim SET
           state = "released", releasedAt = $operation.recordedAt,
           operation = $operationId
           WHERE statementImport = $canonicalImport.id AND state = "active";
         UPDATE statementTransactionMatch SET
           state = "superseded", sourceState = "superseded",
           supersededOperation = $operationId,
           supersededAt = $operation.recordedAt,
           supersessionReason = "legacy_resolution_reversed",
           revision += 1
           WHERE statementImport = $canonicalImport.id
             AND proposedOperation = $targetOperationId
             AND sourceState = "committed";
         UPDATE statementRowComponent SET sourceState = "superseded"
           WHERE statementImport = $canonicalImport.id AND sourceState = "committed";
         UPDATE statementIssue SET state = "superseded", revision += 1,
           dispositionOperation = $operationId, resolvedAt = $operation.recordedAt
           WHERE statementImport = $canonicalImport.id AND state != "superseded";
         LET $canonicalSourceClaimId = type::record("statementSourceClaim", fn::stringID([
           $canonicalImport.account, $canonicalImport.originalFileSha256
         ]));
         UPDATE ONLY $canonicalSourceClaimId SET state = "released", operation = $operationId
           WHERE state = "active" AND statementImport = $canonicalImport.id;
         LET $legacySourceClaimId = type::record("statementSourceClaim", fn::stringID([
           $legacyImport.account, $legacyImport.originalFileSha256
         ]));
         LET $legacySourceClaim = SELECT * FROM ONLY $legacySourceClaimId;
         LET $restoredSourceClaim = IF $target.previousSourceClaimState = "active" {
           UPSERT ONLY $legacySourceClaimId CONTENT {
             space: $legacyImport.space, account: $legacyImport.account,
             statementImport: $legacyImport.id, key: $legacyImport.originalFileSha256,
             originalFileSha256: $legacyImport.originalFileSha256,
             periodStart: $legacyImport.periodStart, periodEnd: $legacyImport.periodEnd,
             state: "active", claimedAt: $operation.recordedAt, operation: $operationId
           }
         } ELSE IF $legacySourceClaim {
           UPDATE ONLY $legacySourceClaimId SET state = "released", operation = $operationId
         } ELSE { NONE };
         LET $restoredPeriodClaim = UPDATE ONLY $periodClaimId SET
           statementImport = $legacyImport.id,
           originalFileSha256 = $legacyImport.originalFileSha256,
           state = IF $target.previousPeriodClaimState = "active" THEN "active" ELSE "released" END,
           claimedAt = $operation.recordedAt, operation = $operationId;
         LET $restoredLegacy = UPDATE ONLY $legacyImport.id SET
           sourceState = $target.previousLegacySourceState, revision += 1;
         LET $supersededCanonical = UPDATE ONLY $canonicalImport.id SET
           sourceState = "superseded", revision += 1;
         LET $reconciliationId = type::record("statementReconciliation", fn::stringID([$canonicalImport.id, "current"]));
         LET $reconciliation = UPDATE ONLY $reconciliationId SET
           attestationState = "reopened", revision += 1,
           reopenedAt = $operation.recordedAt,
           latestReopeningOperation = $operationId,
           provenance = object::extend(provenance, {
             legacyResolutionReversed: type::string($targetResolutionId)
           });
         LET $resolutionKey = string::concat("reversal-", $operation.key);
         LET $resolutionId = type::record("statementLegacyResolution", fn::stringID([$canonicalImport.id, $resolutionKey]));
         LET $resolution = CREATE ONLY $resolutionId CONTENT {
           space: $legacyImport.space, account: $legacyImport.account,
           legacyStatementImport: $legacyImport.id,
           canonicalStatementImport: $canonicalImport.id,
           key: $resolutionKey, resolutionType: "reversal",
           strategy: $target.strategy, authorityEffect: "restore_previous",
           previousLegacySourceState: $target.previousLegacySourceState,
           previousSourceClaimState: $target.previousSourceClaimState,
           previousPeriodClaimState: $target.previousPeriodClaimState,
           targetResolution: $targetResolutionId,
           predecessorResolution: $targetResolutionId,
           databaseFingerprint: $target.databaseFingerprint,
           sourceIdentityHash: $target.sourceIdentityHash,
           canonicalPreviewHash: $target.canonicalPreviewHash,
           legacyEvidenceHash: $target.legacyEvidenceHash,
           accountContextFingerprint: $target.accountContextFingerprint,
           crosswalkHash: $target.crosswalkHash,
           expectedRevisionClaimHash: $target.resultAuthorityHash,
           resultAuthorityHash: $reversalAuthorityHash,
           aggregateCounts: $target.aggregateCounts,
           idempotencyKey: $operation.idempotencyKey,
           requestHash: $operation.requestHash, channel: $operation.channel,
           actorId: IF $operation.hasActorId THEN $operation.actorId ELSE NONE END,
           operation: $operationId, recordedAt: $operation.recordedAt
         };
         FOR $targetItem IN (SELECT * FROM statementLegacyResolutionItem
           WHERE statementLegacyResolution = $targetResolutionId ORDER BY key ASC) {
           LET $itemKey = string::concat("release-", $targetItem.key);
           LET $itemId = type::record("statementLegacyResolutionItem", fn::stringID([$resolutionId, $itemKey]));
           CREATE ONLY $itemId CONTENT {
             space: $targetItem.space, account: $targetItem.account,
             statementLegacyResolution: $resolutionId,
             canonicalStatementImport: $targetItem.canonicalStatementImport,
             legacyStatementImport: $targetItem.legacyStatementImport,
             key: $itemKey, compatibilityClass: $targetItem.compatibilityClass,
             activeLedgerOutcome: "authority_released",
             canonicalComponent: $targetItem.canonicalComponent,
             canonicalComponentIds: $targetItem.canonicalComponentIds,
             legacyStatementRow: $targetItem.legacyStatementRow,
             legacyTransaction: $targetItem.legacyTransaction,
             legacyTransactionIds: $targetItem.legacyTransactionIds,
             accountTransfer: $targetItem.accountTransfer,
             itemEvidenceHash: $targetItem.itemEvidenceHash,
             expectedClaimHash: $targetItem.expectedClaimHash,
             operation: $operationId, recordedAt: $operation.recordedAt
           };
         };
         LET $resultRefs = [type::string($legacyImport.id), type::string($resolutionId), type::string($reconciliationId)];
         LET $operationRecord = CREATE ONLY $operationId CONTENT {
           key: $operation.key, command: $operation.command,
           idempotencyKey: $operation.idempotencyKey,
           requestHash: $operation.requestHash, channel: $operation.channel,
           actorId: IF $operation.hasActorId THEN $operation.actorId ELSE NONE END,
           status: "applied", resultRefs: $resultRefs,
           warningCodes: [], auditMeta: $operation.auditMeta,
           recordedAt: $operation.recordedAt, completedAt: $operation.recordedAt
         };
         LET $resolutionItems = SELECT * FROM statementLegacyResolutionItem
           WHERE statementLegacyResolution = $resolutionId ORDER BY key ASC;
         RETURN { resolution: $resolution, items: $resolutionItems,
           spaceKey: $legacyImport.space.key, accountKey: $legacyImport.account.key,
           statementImport: $restoredLegacy, reconciliation: $reconciliation,
           operation: $operationRecord };
         COMMIT TRANSACTION;`,
        {
          targetResolutionKey: recordKey(draft.target.id),
          expectedDatabaseFingerprint: draft.expectedDatabaseFingerprint,
          expectedAuthorityHash: draft.expectedAuthorityHash,
          reversalAuthorityHash,
          operation: {
            ...operation,
            hasActorId:
              operation.actorId !== null && operation.actorId !== undefined,
            actorId: operation.actorId ?? "",
            auditMeta: operation.auditMeta ?? {},
          },
        },
      );
      const result = transactionResult<{
        resolution: Raw;
        items: Raw[];
        spaceKey: string;
        accountKey: string;
        statementImport: Raw;
        reconciliation: Raw | null;
        operation: Raw;
      }>(response, "resolution");
      const operationRecord = normalizeOperation(result.operation);
      return {
        resolution: normalizeResolution(result.resolution),
        items: result.items.map(normalizeItem),
        statementImport: normalizeStatementImport({
          ...result.statementImport,
          spaceKey: result.spaceKey,
          accountKey: result.accountKey,
        }),
        reconciliation: result.reconciliation
          ? normalizeStatementReconciliation(result.reconciliation)
          : null,
        receipt: {
          operationId: operationRecord.id,
          status: "applied",
          resultRefs: operationRecord.resultRefs,
          completedAt:
            operationRecord.completedAt ?? operationRecord.recordedAt,
        },
      };
    } catch (error) {
      rethrowPersistenceError(error);
    }
  }
}

export function createSurrealStatementLegacyResolutionRepository(
  client: SurrealQueryClient,
  databaseFingerprint: string,
): StatementLegacyResolutionRepository {
  return new SurrealStatementLegacyResolutionRepository(
    client,
    databaseFingerprint,
  );
}
