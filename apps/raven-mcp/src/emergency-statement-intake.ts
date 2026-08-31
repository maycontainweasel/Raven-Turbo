#!/usr/bin/env node
import {
  createLocalStatementTruthRuntime,
  createSurrealAccountControlRepository,
} from "@raven/surreal";
import type {
  AccountRecord,
  FinancialSpaceRecord,
  StatementPreviewResult,
  StatementTruthApi,
} from "@raven/domain/server";
import { readFile } from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { Surreal } from "surrealdb";
import {
  buildSourceInventory,
  deterministicJson,
  exactTransferCandidates,
  extractStatementAssistance,
  inventoryAggregate,
  preparePrivateRunRoot,
  PROVISIONAL_AUTHORITY,
  readPdfLayout,
  writePrivateJson,
  writePrivateNdjson,
  type AccountClass,
  type AssistanceComponent,
  type ExtractionAssistance,
  type IntakeIssue,
  type SourceInventory,
  type SourceOccurrence,
} from "./emergency-statement-intake-lib.js";
import {
  defaultRepositoryRoot,
  loadRavenLocalConnectionConfig,
} from "./local-config.js";

type IntakeMode = "inventory" | "run" | "query";

type QueryClient = Readonly<{
  query(query: string, variables?: Record<string, unknown>): Promise<unknown>;
}>;

type PrivateAccountBinding = Readonly<{
  accountRef: string;
  spaceKey: string;
  accountKey: string;
}>;

type PrivateSourceRecord = Readonly<{
  sourceRef: string;
  occurrenceKey: string;
  sourceFingerprint: string;
  sourceKind: SourceOccurrence["sourceKind"];
  mimeType: string;
  byteSize: number;
  pageCount: number | null;
  relativePrivateLocator: string;
  accountClass: AccountClass;
  proposedAccountRef: string | null;
  duplicateGroup: string;
  canonicalOccurrence: boolean;
  compatibilityOnly: boolean;
  extractionState:
    | "pending"
    | "duplicate"
    | "compatibility_only"
    | "accountant_compilation"
    | "preview_valid"
    | "preview_blocked"
    | "unsupported";
  legacyOverlapState: "none" | "confirmed" | "requires_review";
  canonicalStatus:
    | "clean_canonical_commit_eligible"
    | "legacy_overlap_requires_hp04a"
    | "duplicate_source"
    | "blocked_extraction"
    | "blocked_account_or_profile"
    | "unsupported_currency"
    | "source_incomplete"
    | "compatibility_only";
  authority: typeof PROVISIONAL_AUTHORITY;
}>;

type PrivatePreviewRecord = Readonly<{
  sourceRef: string;
  accountRef: string;
  periodStart: string;
  periodEnd: string;
  currency: string;
  openingBalanceMinor: number | null;
  closingBalanceMinor: number | null;
  previewHash: string;
  profileId: string;
  profileVersion: string;
  canonicalExtractionSha256: string;
  coverageState: string;
  statementDifferenceMinor: number | null;
  movementRowCount: number;
  informationalRowCount: number;
  movementComponentCount: number;
  informationalComponentCount: number;
  grossCreditsMinor: number;
  grossDebitsMinor: number;
  legacyOverlapState: "none" | "confirmed" | "requires_review";
  commitEligible: boolean;
  authority: typeof PROVISIONAL_AUTHORITY;
}>;

type PrivateRowRecord = Readonly<{
  rowRef: string;
  sourceRef: string;
  accountRef: string;
  rowKey: string;
  rowNumber: number;
  rowKind: string;
  transactionDate: string | null;
  postingDate: string | null;
  valueDate: string | null;
  rawDescription: string;
  sourceReference: string | null;
  reportedBalanceMinor: number | null;
  locator: unknown;
  confidence: number;
  rowHash: string;
  authority: typeof PROVISIONAL_AUTHORITY;
}>;

type PrivateComponentRecord = Readonly<{
  componentRef: string;
  rowRef: string;
  sourceRef: string;
  accountRef: string;
  componentKey: string;
  componentKind: string;
  componentRole: string;
  financialDate: string | null;
  transactionDate: string | null;
  postingDate: string | null;
  valueDate: string | null;
  rawDescription: string;
  sourceReference: string | null;
  amountMinor: number;
  balanceEffectMinor: number;
  currency: string;
  sourceDirection: string;
  sourceFlow: string;
  locator: unknown;
  confidence: number;
  sourceChecksum: string;
  authority: typeof PROVISIONAL_AUTHORITY;
}>;

type PrivateIssueRecord = Readonly<{
  issueRef: string;
  sourceRef: string;
  rowRef: string | null;
  componentRef: string | null;
  code: string;
  severity: string;
  blocking: boolean;
  explanation: string;
  authority: typeof PROVISIONAL_AUTHORITY;
}>;

type RunState = Readonly<{
  inventory: SourceInventory;
  sourceFiles: readonly PrivateSourceRecord[];
  previews: readonly PrivatePreviewRecord[];
  rows: readonly PrivateRowRecord[];
  components: readonly PrivateComponentRecord[];
  issues: readonly PrivateIssueRecord[];
}>;

const CANONICAL_GUARD_TABLES = [
  "financialOperation",
  "transaction",
  "accountBalanceSnapshot",
  "statementImport",
  "statementRow",
  "statementSourceClaim",
  "statementPeriodClaim",
  "statementRowComponent",
  "statementIssue",
  "statementTransactionMatch",
  "statementComponentResolutionClaim",
  "statementTransactionResolutionClaim",
  "statementReconciliation",
  "statementReconciliationEvent",
] as const;

const ALLOWED_SERVICE_CALLS = new Set<keyof StatementTruthApi>([
  "stageStatementSource",
  "listStatementProfiles",
  "detectStatementProfile",
  "previewStatementImport",
  "validateStatementPreview",
]);

function argument(name: string): string | undefined {
  const index = process.argv.indexOf(name);
  return index >= 0 ? process.argv[index + 1] : undefined;
}

function mode(): IntakeMode {
  const value = argument("--mode") ?? "run";
  if (value === "inventory" || value === "run" || value === "query")
    return value;
  throw new Error("INTAKE_INVALID_MODE");
}

function safeRunRef(value: string): string {
  if (!/^EI-[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}$/.test(value)) {
    throw new Error("INTAKE_INVALID_RUN_REF");
  }
  return value;
}

function runTimestamp(runRef: string): string {
  return `${runRef.slice(3, 13)}T00:00:00.000Z`;
}

function readOnlyClient(client: Surreal): QueryClient {
  return {
    async query(query, variables) {
      const normalized = query.trim().replace(/^\(+/, "").trimStart();
      if (!/^SELECT\b/i.test(normalized)) {
        throw new Error("INTAKE_NON_SELECT_QUERY_BLOCKED");
      }
      return client.query(query, variables);
    },
  };
}

function responseRows(response: unknown): Array<Record<string, unknown>> {
  if (!Array.isArray(response)) return [];
  for (let index = response.length - 1; index >= 0; index -= 1) {
    const statement = response[index];
    const result =
      statement && typeof statement === "object" && "result" in statement
        ? (statement as { result?: unknown }).result
        : statement;
    if (Array.isArray(result)) return result as Array<Record<string, unknown>>;
  }
  return [];
}

async function countGuard(
  client: QueryClient,
): Promise<Record<string, number>> {
  const counts: Record<string, number> = {};
  for (const table of CANONICAL_GUARD_TABLES) {
    const rows = responseRows(
      await client.query(`SELECT count() AS count FROM ${table} GROUP ALL;`),
    );
    counts[table] = Number(rows[0]?.count ?? 0);
  }
  return counts;
}

function checkedAdd(left: number, right: number): number {
  const value = left + right;
  if (!Number.isSafeInteger(value)) throw new Error("INTAKE_MONEY_OVERFLOW");
  return value;
}

function sumExact(values: readonly number[]): number {
  return values.reduce(checkedAdd, 0);
}

function safeErrorCode(error: unknown): string {
  if (error && typeof error === "object" && "code" in error) {
    const code = String((error as { code?: unknown }).code ?? "");
    if (/^[A-Z][A-Z0-9_]{2,80}$/.test(code)) return code;
  }
  const message = error instanceof Error ? error.message : "";
  const code = message.match(/\b[A-Z][A-Z0-9_]{2,80}\b/)?.[0];
  return code ?? "INTAKE_OPERATION_FAILED";
}

function sourceRef(occurrence: SourceOccurrence): string {
  return `source-${occurrence.occurrenceKey.slice(0, 24)}`;
}

function issueRef(source: string, index: number): string {
  return `${source}:issue:${String(index + 1).padStart(4, "0")}`;
}

function accountCandidates(
  accountClass: AccountClass,
  accounts: readonly AccountRecord[],
  spaces: readonly FinancialSpaceRecord[],
  maskedAccount: string | null,
  sourceText: string,
): AccountRecord[] {
  const spaceType = new Map(
    spaces.map((space) => [space.key, space.spaceType]),
  );
  const desiredType: Partial<Record<AccountClass, string>> = {
    business: "current",
    personal_current: "current",
    personal_credit: "credit_card",
    personal_savings: "savings",
    personal_investment: "investment",
  };
  const digits = maskedAccount?.replace(/\D/g, "") ?? "";
  const structural = accounts.filter((account) => {
    if (!account.active || account.currency !== "ZAR") return false;
    if (account.accountType !== desiredType[accountClass]) return false;
    const candidateSpaceType = spaceType.get(account.spaceKey);
    if (accountClass === "business" && candidateSpaceType !== "business")
      return false;
    if (accountClass !== "business" && candidateSpaceType !== "personal")
      return false;
    return true;
  });
  const explicit = digits
    ? structural.filter((account) => {
        const stored = account.accountNumberLast4?.replace(/\D/g, "") ?? "";
        return Boolean(stored) && digits.endsWith(stored);
      })
    : [];
  if (explicit.length > 0) return explicit;
  const header = sourceText.slice(0, 12_000);
  const observedIdentifiers = [...header.matchAll(/\b\d{8,24}\b/g)].map(
    (match) => match[0],
  );
  const headerMatches = structural.filter((account) => {
    const stored = account.accountNumberLast4?.replace(/\D/g, "") ?? "";
    return (
      Boolean(stored) &&
      observedIdentifiers.some((identifier) => identifier.endsWith(stored))
    );
  });
  if (headerMatches.length > 0) return headerMatches;
  return structural.length === 1 ? structural : digits ? [] : structural;
}

function bindingFor(
  accountClass: AccountClass,
  accounts: readonly AccountRecord[],
  spaces: readonly FinancialSpaceRecord[],
  assistance: ExtractionAssistance,
  sourceText: string,
): PrivateAccountBinding | null {
  const candidates = accountCandidates(
    accountClass,
    accounts,
    spaces,
    assistance.accountHints.maskedAccount,
    sourceText,
  );
  if (candidates.length !== 1) return null;
  const account = candidates[0]!;
  return {
    accountRef: account.id,
    spaceKey: account.spaceKey,
    accountKey: account.key,
  };
}

function privateIssues(
  source: string,
  issues: readonly Readonly<{
    code: string;
    severity: string;
    blocking: boolean;
    message?: string;
    explanation?: string;
    rowKey?: string;
    componentKey?: string;
  }>[],
  startIndex = 0,
): PrivateIssueRecord[] {
  return issues.map((item, index) => ({
    issueRef: issueRef(source, startIndex + index),
    sourceRef: source,
    rowRef: item.rowKey ? `${source}:row:${item.rowKey}` : null,
    componentRef:
      item.rowKey && item.componentKey
        ? `${source}:row:${item.rowKey}:component:${item.componentKey}`
        : null,
    code: item.code,
    severity: item.severity,
    blocking: item.blocking,
    explanation: item.message ?? item.explanation ?? item.code,
    authority: PROVISIONAL_AUTHORITY,
  }));
}

function previewRecords(input: {
  source: string;
  accountRef: string;
  preview: StatementPreviewResult;
}): {
  preview: PrivatePreviewRecord;
  rows: PrivateRowRecord[];
  components: PrivateComponentRecord[];
  issues: PrivateIssueRecord[];
} {
  const rows: PrivateRowRecord[] = [];
  const components: PrivateComponentRecord[] = [];
  for (const row of input.preview.extraction.rows) {
    const rowRef = `${input.source}:row:${row.rowKey}`;
    rows.push({
      rowRef,
      sourceRef: input.source,
      accountRef: input.accountRef,
      rowKey: row.rowKey,
      rowNumber: row.rowNumber,
      rowKind: row.rowKind,
      transactionDate: row.transactionDate,
      postingDate: row.postingDate,
      valueDate: row.valueDate,
      rawDescription: row.rawText,
      sourceReference: row.sourceReference,
      reportedBalanceMinor: row.reportedBalanceMinor,
      locator: row.locator,
      confidence: row.confidence,
      rowHash: row.rowHash,
      authority: PROVISIONAL_AUTHORITY,
    });
    for (const component of row.components) {
      const financialDate =
        component.valueDate ??
        component.postingDate ??
        component.transactionDate;
      components.push({
        componentRef: `${rowRef}:component:${component.componentKey}`,
        rowRef,
        sourceRef: input.source,
        accountRef: input.accountRef,
        componentKey: component.componentKey,
        componentKind: component.componentKind,
        componentRole: component.componentRole,
        financialDate,
        transactionDate: component.transactionDate,
        postingDate: component.postingDate,
        valueDate: component.valueDate,
        rawDescription: component.description,
        sourceReference: component.sourceReference,
        amountMinor: component.amountMinor,
        balanceEffectMinor: component.balanceEffectMinor,
        currency: component.currency,
        sourceDirection: component.sourceDirection,
        sourceFlow: component.sourceFlow,
        locator: component.locator,
        confidence: component.confidence,
        sourceChecksum: component.sourceChecksum,
        authority: PROVISIONAL_AUTHORITY,
      });
    }
  }
  const movement = components.filter(
    (item) => item.componentRole === "movement",
  );
  const legacyOverlapState = input.preview.issues.some((item) =>
    [
      "STATEMENT_LEGACY_PERIOD_CONFLICT",
      "STATEMENT_LEGACY_COMPATIBILITY_REQUIRED",
    ].includes(item.code),
  )
    ? "confirmed"
    : "none";
  return {
    preview: {
      sourceRef: input.source,
      accountRef: input.accountRef,
      periodStart: input.preview.extraction.periodStart,
      periodEnd: input.preview.extraction.periodEnd,
      currency: input.preview.extraction.currency,
      openingBalanceMinor: input.preview.extraction.openingBalanceMinor,
      closingBalanceMinor: input.preview.extraction.closingBalanceMinor,
      previewHash: input.preview.previewHash,
      profileId: input.preview.profile.profileId,
      profileVersion: input.preview.profile.profileVersion,
      canonicalExtractionSha256:
        input.preview.extraction.canonicalExtractionSha256,
      coverageState: input.preview.extraction.coverage.status,
      statementDifferenceMinor: input.preview.differenceMinor,
      movementRowCount: rows.filter((item) => item.rowKind !== "informational")
        .length,
      informationalRowCount: input.preview.informationalRowCount,
      movementComponentCount: movement.length,
      informationalComponentCount: components.length - movement.length,
      grossCreditsMinor: input.preview.inflowMinor,
      grossDebitsMinor: input.preview.outflowMinor,
      legacyOverlapState,
      commitEligible: input.preview.commitAllowed,
      authority: PROVISIONAL_AUTHORITY,
    },
    rows,
    components,
    issues: privateIssues(input.source, input.preview.issues),
  };
}

function sourceStatus(input: {
  occurrence: SourceOccurrence;
  accountRef: string | null;
  state: PrivateSourceRecord["extractionState"];
  preview?: PrivatePreviewRecord;
}): PrivateSourceRecord {
  const legacy = input.preview?.legacyOverlapState ?? "none";
  let canonicalStatus: PrivateSourceRecord["canonicalStatus"];
  if (input.occurrence.compatibilityOnly)
    canonicalStatus = "compatibility_only";
  else if (!input.occurrence.canonicalOccurrence)
    canonicalStatus = "duplicate_source";
  else if (!input.accountRef) canonicalStatus = "blocked_account_or_profile";
  else if (legacy === "confirmed")
    canonicalStatus = "legacy_overlap_requires_hp04a";
  else if (input.preview?.commitEligible)
    canonicalStatus = "clean_canonical_commit_eligible";
  else if (input.state === "unsupported")
    canonicalStatus = "blocked_extraction";
  else canonicalStatus = "source_incomplete";
  return {
    sourceRef: sourceRef(input.occurrence),
    occurrenceKey: input.occurrence.occurrenceKey,
    sourceFingerprint: input.occurrence.fingerprint,
    sourceKind: input.occurrence.sourceKind,
    mimeType: input.occurrence.mimeType,
    byteSize: input.occurrence.byteSize,
    pageCount: input.occurrence.pageCount,
    relativePrivateLocator: input.occurrence.relativePrivateLocator,
    accountClass: input.occurrence.accountClass,
    proposedAccountRef: input.accountRef,
    duplicateGroup: input.occurrence.duplicateGroup,
    canonicalOccurrence: input.occurrence.canonicalOccurrence,
    compatibilityOnly: input.occurrence.compatibilityOnly,
    extractionState: input.state,
    legacyOverlapState: legacy,
    canonicalStatus,
    authority: PROVISIONAL_AUTHORITY,
  };
}

async function connectDatabase() {
  const config = await loadRavenLocalConnectionConfig();
  const client = new Surreal();
  await client.connect(config.url);
  await client.signin({ username: config.username, password: config.password });
  await client.use({ namespace: config.namespace, database: config.database });
  return { client, config };
}

async function writeIndexes(
  privateRoot: string,
  state: RunState,
): Promise<void> {
  await writePrivateJson(
    path.join(privateRoot, "index", "source-manifest.json"),
    state.inventory,
  );
  await writePrivateNdjson(
    path.join(privateRoot, "index", "source-file.ndjson"),
    state.sourceFiles,
  );
  await writePrivateNdjson(
    path.join(privateRoot, "index", "statement-preview.ndjson"),
    state.previews,
  );
  await writePrivateNdjson(
    path.join(privateRoot, "index", "statement-row.ndjson"),
    state.rows,
  );
  await writePrivateNdjson(
    path.join(privateRoot, "index", "statement-component.ndjson"),
    state.components,
  );
  await writePrivateNdjson(
    path.join(privateRoot, "issues", "statement-issue.ndjson"),
    state.issues,
  );
  await writePrivateJson(path.join(privateRoot, "state", "run-state.json"), {
    contractVersion: "raven.emergency-statement-intake.v1",
    authority: PROVISIONAL_AUTHORITY,
    sourceFileCount: state.sourceFiles.length,
    previewCount: state.previews.length,
    rowCount: state.rows.length,
    componentCount: state.components.length,
    issueCount: state.issues.length,
  });
}

function monthRange(start: string, end: string): string[] {
  const output: string[] = [];
  let year = Number(start.slice(0, 4));
  let month = Number(start.slice(5, 7));
  const endKey = end.slice(0, 7);
  for (;;) {
    const key = `${year}-${String(month).padStart(2, "0")}`;
    output.push(key);
    if (key === endKey) return output;
    month += 1;
    if (month === 13) {
      year += 1;
      month = 1;
    }
    if (output.length > 1200) throw new Error("INTAKE_PERIOD_RANGE_INVALID");
  }
}

function feeRule(description: string): string | null {
  const rules: ReadonlyArray<readonly [string, RegExp]> = [
    ["explicit_bank_charge", /\bbank charge\b/i],
    ["explicit_service_fee", /\bservice fee\b/i],
    ["explicit_unpaid_item", /\bunpaid item\b/i],
    ["explicit_failed_debit", /\b(?:failed|unpaid) debit order\b/i],
    ["explicit_insufficient_funds", /\binsufficient funds\b/i],
    ["explicit_overdraft_interest", /\boverdraft interest\b/i],
    ["explicit_credit_interest", /\bcredit interest\b/i],
    ["explicit_late_payment_fee", /\blate(?: payment)? fee\b/i],
    ["explicit_cash_withdrawal_fee", /\b(?:cash|atm) withdrawal fee\b/i],
    ["explicit_foreign_exchange_fee", /\b(?:foreign exchange|forex|fx) fee\b/i],
  ];
  return rules.find(([, pattern]) => pattern.test(description))?.[0] ?? null;
}

async function writeReports(
  privateRoot: string,
  state: RunState,
): Promise<{
  periodCount: number;
  missingPeriodCount: number;
  exchangeCandidateCount: number;
  feeCandidateCount: number;
}> {
  const monthly = new Map<
    string,
    {
      month: string;
      accountRef: string;
      currency: string;
      grossCreditsMinor: number;
      grossDebitsMinor: number;
      netBankMovementMinor: number;
      movementComponentCount: number;
      authority: typeof PROVISIONAL_AUTHORITY;
    }
  >();
  for (const component of state.components) {
    if (component.componentRole !== "movement" || !component.financialDate)
      continue;
    const month = component.financialDate.slice(0, 7);
    const key = `${month}\0${component.accountRef}\0${component.currency}`;
    const record = monthly.get(key) ?? {
      month,
      accountRef: component.accountRef,
      currency: component.currency,
      grossCreditsMinor: 0,
      grossDebitsMinor: 0,
      netBankMovementMinor: 0,
      movementComponentCount: 0,
      authority: PROVISIONAL_AUTHORITY,
    };
    record.grossCreditsMinor = checkedAdd(
      record.grossCreditsMinor,
      component.sourceFlow === "inflow" ? component.amountMinor : 0,
    );
    record.grossDebitsMinor = checkedAdd(
      record.grossDebitsMinor,
      component.sourceFlow === "outflow" ? component.amountMinor : 0,
    );
    record.netBankMovementMinor = checkedAdd(
      record.netBankMovementMinor,
      component.balanceEffectMinor,
    );
    record.movementComponentCount += 1;
    monthly.set(key, record);
  }
  const transferCandidates = exactTransferCandidates(
    state.components
      .filter(
        (
          item,
        ): item is PrivateComponentRecord & {
          financialDate: string;
          sourceFlow: "inflow" | "outflow";
        } =>
          item.componentRole === "movement" &&
          Boolean(item.financialDate) &&
          (item.sourceFlow === "inflow" || item.sourceFlow === "outflow"),
      )
      .map((item) => ({
        componentRef: item.componentRef,
        accountRef: item.accountRef,
        currency: item.currency,
        date: item.financialDate,
        amountMinor: item.amountMinor,
        sourceFlow: item.sourceFlow,
      })),
  );
  const aliases = ["VALR", "LUNO"].map((term) => ({
    aliasType: "exchange",
    normalizedTerm: term,
    ownerReviewed: true,
    notes: "owner_supplied",
    authority: PROVISIONAL_AUTHORITY,
  }));
  const exchangeCandidates = state.components
    .filter((item) => /\b(?:VALR|LUNO)\b/i.test(item.rawDescription))
    .map((item) => ({
      componentRef: item.componentRef,
      accountRef: item.accountRef,
      financialDate: item.financialDate,
      amountMinor: item.amountMinor,
      sourceFlow: item.sourceFlow,
      rawDescription: item.rawDescription,
      locator: item.locator,
      matchReason: item.rawDescription.match(/\bVALR\b/i) ? "VALR" : "LUNO",
      confidence: 1,
      reviewState: "pending",
      authority: PROVISIONAL_AUTHORITY,
      notice:
        "Bank cash transferred to or from an exchange is not the same as trading profit, loss, asset value, or platform fee.",
    }));
  const exchangeCashflow = new Map<
    string,
    {
      alias: string;
      accountRef: string;
      periodKind: "month" | "year" | "all";
      periodKey: string;
      grossSentMinor: number;
      grossReceivedMinor: number;
      netBankCashCommittedMinor: number;
      authority: typeof PROVISIONAL_AUTHORITY;
      notice: string;
    }
  >();
  for (const candidate of exchangeCandidates) {
    const periods = [
      ["month", candidate.financialDate?.slice(0, 7) ?? "undated"],
      ["year", candidate.financialDate?.slice(0, 4) ?? "undated"],
      ["all", "all"],
    ] as const;
    for (const [periodKind, periodKey] of periods) {
      for (const alias of [candidate.matchReason, "COMBINED_EXCHANGE"]) {
        const key = `${alias}\0${candidate.accountRef}\0${periodKind}\0${periodKey}`;
        const record = exchangeCashflow.get(key) ?? {
          alias,
          accountRef: candidate.accountRef,
          periodKind,
          periodKey,
          grossSentMinor: 0,
          grossReceivedMinor: 0,
          netBankCashCommittedMinor: 0,
          authority: PROVISIONAL_AUTHORITY,
          notice:
            "Bank cash transferred to or from an exchange is not the same as trading profit, loss, asset value, or platform fee.",
        };
        record.grossSentMinor = checkedAdd(
          record.grossSentMinor,
          candidate.sourceFlow === "outflow" ? candidate.amountMinor : 0,
        );
        record.grossReceivedMinor = checkedAdd(
          record.grossReceivedMinor,
          candidate.sourceFlow === "inflow" ? candidate.amountMinor : 0,
        );
        record.netBankCashCommittedMinor = checkedAdd(
          record.grossSentMinor,
          -record.grossReceivedMinor,
        );
        exchangeCashflow.set(key, record);
      }
    }
  }
  const feeCandidates = state.components.flatMap((item) => {
    const rule =
      item.componentKind === "bank_fee"
        ? "explicit_source_component"
        : feeRule(item.rawDescription);
    return rule
      ? [
          {
            componentRef: item.componentRef,
            accountRef: item.accountRef,
            financialDate: item.financialDate,
            amountMinor: item.amountMinor,
            rawDescription: item.rawDescription,
            locator: item.locator,
            evidenceRule: rule,
            reviewState: "pending",
            authority: PROVISIONAL_AUTHORITY,
          },
        ]
      : [];
  });
  const feeSummary = new Map<
    string,
    {
      accountRef: string;
      periodKind: "month" | "year";
      periodKey: string;
      evidenceRule: string;
      amountMinor: number;
      itemCount: number;
      recurringCandidate: boolean;
      avoidableCandidate: boolean;
      authority: typeof PROVISIONAL_AUTHORITY;
    }
  >();
  const feeMonthsByRule = new Map<string, Set<string>>();
  for (const candidate of feeCandidates) {
    const month = candidate.financialDate?.slice(0, 7) ?? "undated";
    const year = candidate.financialDate?.slice(0, 4) ?? "undated";
    const recurrenceKey = `${candidate.accountRef}\0${candidate.evidenceRule}`;
    const observed = feeMonthsByRule.get(recurrenceKey) ?? new Set<string>();
    observed.add(month);
    feeMonthsByRule.set(recurrenceKey, observed);
    for (const [periodKind, periodKey] of [
      ["month", month],
      ["year", year],
    ] as const) {
      const key = `${candidate.accountRef}\0${periodKind}\0${periodKey}\0${candidate.evidenceRule}`;
      const record = feeSummary.get(key) ?? {
        accountRef: candidate.accountRef,
        periodKind,
        periodKey,
        evidenceRule: candidate.evidenceRule,
        amountMinor: 0,
        itemCount: 0,
        recurringCandidate: false,
        avoidableCandidate: /unpaid|failed|insufficient|late/.test(
          candidate.evidenceRule,
        ),
        authority: PROVISIONAL_AUTHORITY,
      };
      record.amountMinor = checkedAdd(
        record.amountMinor,
        candidate.amountMinor,
      );
      record.itemCount += 1;
      feeSummary.set(key, record);
    }
  }
  for (const record of feeSummary.values()) {
    record.recurringCandidate =
      (feeMonthsByRule.get(`${record.accountRef}\0${record.evidenceRule}`)
        ?.size ?? 0) > 1;
  }
  const byAccount = new Map<string, PrivatePreviewRecord[]>();
  for (const preview of state.previews) {
    const group = byAccount.get(preview.accountRef) ?? [];
    group.push(preview);
    byAccount.set(preview.accountRef, group);
  }
  const coverageGaps: Array<{
    accountRef: string;
    month: string;
    state: "missing";
    authority: typeof PROVISIONAL_AUTHORITY;
  }> = [];
  for (const [accountRef, previews] of byAccount) {
    const covered = new Set(previews.map((item) => item.periodEnd.slice(0, 7)));
    const sorted = [...covered].sort();
    if (sorted.length < 2) continue;
    for (const month of monthRange(sorted[0]!, sorted.at(-1)!)) {
      if (!covered.has(month)) {
        coverageGaps.push({
          accountRef,
          month,
          state: "missing",
          authority: PROVISIONAL_AUTHORITY,
        });
      }
    }
  }
  const accountPeriods = state.previews.map((preview) => ({
    ...preview,
    netSignedMovementMinor: checkedAdd(
      preview.grossCreditsMinor,
      -preview.grossDebitsMinor,
    ),
  }));
  const activationPlan = [...state.sourceFiles]
    .filter((item) => item.sourceKind === "pdf" && item.canonicalOccurrence)
    .sort((left, right) => {
      const rank = (status: PrivateSourceRecord["canonicalStatus"]) =>
        ({
          clean_canonical_commit_eligible: 1,
          legacy_overlap_requires_hp04a: 2,
          source_incomplete: 3,
          blocked_extraction: 4,
          blocked_account_or_profile: 5,
          unsupported_currency: 6,
          duplicate_source: 7,
          compatibility_only: 8,
        })[status];
      return (
        rank(left.canonicalStatus) - rank(right.canonicalStatus) ||
        left.sourceRef.localeCompare(right.sourceRef)
      );
    })
    .map((item, index) => ({
      order: index + 1,
      sourceRef: item.sourceRef,
      accountRef: item.proposedAccountRef,
      status: item.canonicalStatus,
      authority: PROVISIONAL_AUTHORITY,
    }));
  const accountantCrosscheck = state.sourceFiles
    .filter((item) => item.extractionState === "accountant_compilation")
    .map((item) => ({
      sourceRef: item.sourceRef,
      documentClass: "accountant_compilation",
      extractionState: "separate_crosscheck_required",
      mixedIntoTransactionTotals: false,
      authority: PROVISIONAL_AUTHORITY,
    }));
  await Promise.all([
    writePrivateNdjson(
      path.join(privateRoot, "index", "candidate-internal-transfer.ndjson"),
      transferCandidates,
    ),
    writePrivateNdjson(
      path.join(privateRoot, "index", "private-alias.ndjson"),
      aliases,
    ),
    writePrivateNdjson(
      path.join(privateRoot, "reports", "monthly-account-matrix.ndjson"),
      [...monthly.values()].sort((a, b) =>
        `${a.month}:${a.accountRef}`.localeCompare(
          `${b.month}:${b.accountRef}`,
        ),
      ),
    ),
    writePrivateNdjson(
      path.join(privateRoot, "reports", "account-period-summary.ndjson"),
      accountPeriods,
    ),
    writePrivateNdjson(
      path.join(privateRoot, "reports", "coverage-gaps.ndjson"),
      coverageGaps,
    ),
    writePrivateNdjson(
      path.join(privateRoot, "reports", "exchange-candidates.ndjson"),
      exchangeCandidates,
    ),
    writePrivateNdjson(
      path.join(privateRoot, "reports", "exchange-cashflow-summary.ndjson"),
      [...exchangeCashflow.values()].sort((left, right) =>
        `${left.alias}:${left.accountRef}:${left.periodKind}:${left.periodKey}`.localeCompare(
          `${right.alias}:${right.accountRef}:${right.periodKind}:${right.periodKey}`,
        ),
      ),
    ),
    writePrivateNdjson(
      path.join(privateRoot, "reports", "fee-candidates.ndjson"),
      feeCandidates,
    ),
    writePrivateNdjson(
      path.join(privateRoot, "reports", "fee-summary.ndjson"),
      [...feeSummary.values()].sort((left, right) =>
        `${left.accountRef}:${left.periodKind}:${left.periodKey}:${left.evidenceRule}`.localeCompare(
          `${right.accountRef}:${right.periodKind}:${right.periodKey}:${right.evidenceRule}`,
        ),
      ),
    ),
    writePrivateNdjson(
      path.join(privateRoot, "reports", "activation-plan.ndjson"),
      activationPlan,
    ),
    writePrivateNdjson(
      path.join(privateRoot, "reports", "accountant-crosscheck.ndjson"),
      accountantCrosscheck,
    ),
    writePrivateJson(
      path.join(privateRoot, "reports", "accountant-question-schedule.json"),
      {
        authority: PROVISIONAL_AUTHORITY,
        state: "awaiting_accountant_evidence",
        questions: [
          "Which bank transactions support director emoluments?",
          "Was each amount paid in cash, allocated through a loan account, journaled, or mixed?",
          "Which transactions created the shareholder-loan movement?",
          "Which bank or exchange items were included in finance income or finance costs?",
          "Which workpapers support each annual line?",
          "Which figures were used for company and personal tax returns?",
        ],
      },
    ),
    writePrivateJson(
      path.join(privateRoot, "reports", "recipient-alias-review.json"),
      {
        authority: PROVISIONAL_AUTHORITY,
        state: "awaiting_owner_aliases",
        acceptedAliases: [],
        schedulesGenerated: false,
      },
    ),
    writePrivateJson(
      path.join(privateRoot, "reports", "legal-neutral-views.json"),
      {
        authority: PROVISIONAL_AUTHORITY,
        strictBankOnly: { rowRefs: state.rows.map((item) => item.rowRef) },
        ownerExplained: { rowRefs: [], state: "awaiting_owner_review" },
        unresolvedOrDisputed: {
          sourceRefs: state.sourceFiles
            .filter(
              (item) =>
                !["preview_valid", "duplicate", "compatibility_only"].includes(
                  item.extractionState,
                ),
            )
            .map((item) => item.sourceRef),
        },
      },
    ),
  ]);
  return {
    periodCount: state.previews.length,
    missingPeriodCount: coverageGaps.length,
    exchangeCandidateCount: exchangeCandidates.length,
    feeCandidateCount: feeCandidates.length,
  };
}

function aggregateSummary(input: {
  runRef: string;
  state: RunState;
  reports: Awaited<ReturnType<typeof writeReports>>;
  zeroWriteVerified: boolean;
}) {
  const inventory = inventoryAggregate(input.state.inventory);
  const issueCounts = Object.fromEntries(
    [...new Set(input.state.issues.map((item) => item.code))]
      .sort()
      .map((code) => [
        code,
        input.state.issues.filter((item) => item.code === code).length,
      ]),
  );
  const movementComponents = input.state.components.filter(
    (item) => item.componentRole === "movement",
  ).length;
  return {
    authority: PROVISIONAL_AUTHORITY,
    totalSourceFiles: inventory.totalInventoryFiles,
    uniqueSourceFiles: inventory.uniqueSourceEvidenceFiles,
    duplicateFiles: inventory.duplicateSourceEvidenceFiles,
    pdfsByAccountClass: inventory.pdfsByAccountClass,
    periodsCovered: input.reports.periodCount,
    periodsMissing: input.reports.missingPeriodCount,
    previewsPassed: input.state.previews.filter((item) => item.commitEligible)
      .length,
    previewsBlocked: input.state.previews.filter((item) => !item.commitEligible)
      .length,
    cleanPeriods: input.state.previews.filter(
      (item) => item.commitEligible && item.legacyOverlapState === "none",
    ).length,
    legacyOverlapPeriods: input.state.previews.filter(
      (item) => item.legacyOverlapState === "confirmed",
    ).length,
    totalMovementComponents: movementComponents,
    informationalComponents: input.state.components.length - movementComponents,
    issueCountsByCode: issueCounts,
    exchangeCandidateCount: input.reports.exchangeCandidateCount,
    feeCandidateCount: input.reports.feeCandidateCount,
    privateSourceOnlyQueryDatabaseCreated: false,
    privateFilesystemIndexCreated: true,
    privateOutputReference: input.runRef,
    zeroCanonicalWriteVerified: input.zeroWriteVerified,
    nextApprovalRequired:
      "Review blocked mappings and extraction issues before any canonical ST-01/ST-02 activation.",
  };
}

async function runInventory(input: {
  sourceRoot: string;
  privateRoot: string;
  generatedAt?: string;
}): Promise<SourceInventory> {
  const inventory = await buildSourceInventory({
    sourceRoot: input.sourceRoot,
    generatedAt: input.generatedAt,
  });
  await writePrivateJson(
    path.join(input.privateRoot, "index", "source-manifest.json"),
    inventory,
  );
  return inventory;
}

async function runIntake(input: {
  repositoryRoot: string;
  sourceRoot: string;
  privateRoot: string;
  runRef: string;
}): Promise<unknown> {
  const inventory = await runInventory({
    sourceRoot: input.sourceRoot,
    privateRoot: input.privateRoot,
    generatedAt: runTimestamp(input.runRef),
  });
  const sourceFiles: PrivateSourceRecord[] = [];
  const previews: PrivatePreviewRecord[] = [];
  const rows: PrivateRowRecord[] = [];
  const components: PrivateComponentRecord[] = [];
  const issues: PrivateIssueRecord[] = [];
  const { client, config } = await connectDatabase();
  const readClient = readOnlyClient(client);
  const before = await countGuard(readClient);
  let after: Record<string, number> | null = null;
  try {
    const repository = createSurrealAccountControlRepository(readClient);
    const [accounts, spaces] = await Promise.all([
      repository.listAccounts(),
      repository.listSpaces(),
    ]);
    const service = createLocalStatementTruthRuntime({
      client: readClient,
      repositoryRoot: config.repositoryRoot,
      vaultRoot: path.join(input.privateRoot, "vault"),
      allowedInboxRoots: [input.sourceRoot, input.privateRoot],
      databaseFingerprint: "provisional-source-only-read-guard",
    });
    const profiles = await service.listStatementProfiles();
    const profileKeys = new Set(
      profiles.profiles.map(
        (profile) => `${profile.profileId}@${profile.profileVersion}`,
      ),
    );
    for (const occurrence of inventory.occurrences) {
      const privateSourceRef = sourceRef(occurrence);
      if (occurrence.compatibilityOnly) {
        sourceFiles.push(
          sourceStatus({
            occurrence,
            accountRef: null,
            state: "compatibility_only",
          }),
        );
        continue;
      }
      if (!occurrence.canonicalOccurrence) {
        sourceFiles.push(
          sourceStatus({ occurrence, accountRef: null, state: "duplicate" }),
        );
        continue;
      }
      if (occurrence.sourceKind !== "pdf" || occurrence.pageCount === null) {
        const sourceIssue = privateIssues(privateSourceRef, [
          {
            code: "INTAKE_UNSUPPORTED_SOURCE",
            severity: "blocking",
            blocking: true,
            explanation:
              "Source is not currently extractable by this bounded operator",
          },
        ]);
        issues.push(...sourceIssue);
        sourceFiles.push(
          sourceStatus({ occurrence, accountRef: null, state: "unsupported" }),
        );
        continue;
      }
      const originalPath = path.join(
        input.sourceRoot,
        ...occurrence.relativePrivateLocator.split("/"),
      );
      let assistance: ExtractionAssistance | null = null;
      let sourceText = "";
      let extractionIssues: readonly IntakeIssue[] = [];
      let documentClass:
        | "bank_statement"
        | "accountant_compilation"
        | "unsupported" = "unsupported";
      try {
        sourceText = await readPdfLayout(originalPath);
        const extraction = extractStatementAssistance({
          text: sourceText,
          pageCount: occurrence.pageCount,
          accountClass: occurrence.accountClass,
        });
        assistance = extraction.assistance;
        extractionIssues = extraction.issues;
        documentClass = extraction.sourceDocumentClass;
      } catch (error) {
        extractionIssues = [
          {
            code: safeErrorCode(error),
            severity: "blocking",
            blocking: true,
            explanation:
              "Source extraction failed without changing source authority",
          },
        ];
      }
      if (documentClass === "accountant_compilation") {
        sourceFiles.push(
          sourceStatus({
            occurrence,
            accountRef: null,
            state: "accountant_compilation",
          }),
        );
        continue;
      }
      if (!assistance) {
        issues.push(...privateIssues(privateSourceRef, extractionIssues));
        sourceFiles.push(
          sourceStatus({ occurrence, accountRef: null, state: "unsupported" }),
        );
        continue;
      }
      const assistancePath = path.join(
        input.privateRoot,
        "assistance",
        `${occurrence.occurrenceKey}.json`,
      );
      await writePrivateJson(assistancePath, assistance);
      const binding = bindingFor(
        occurrence.accountClass,
        accounts,
        spaces,
        assistance,
        sourceText,
      );
      if (!binding) {
        const mappingIssue: IntakeIssue = {
          code: "INTAKE_ACCOUNT_MAPPING_REQUIRED",
          severity: "blocking",
          blocking: true,
          explanation: "Account mapping requires owner review",
        };
        issues.push(
          ...privateIssues(privateSourceRef, [
            ...extractionIssues,
            mappingIssue,
          ]),
        );
        sourceFiles.push(
          sourceStatus({
            occurrence,
            accountRef: null,
            state: "preview_blocked",
          }),
        );
        continue;
      }
      const profileKey = `${assistance.profileHint}@1`;
      if (!profileKeys.has(profileKey)) {
        const profileIssue: IntakeIssue = {
          code: "INTAKE_PROFILE_UNAVAILABLE",
          severity: "blocking",
          blocking: true,
          explanation: "Required accepted profile is unavailable",
        };
        issues.push(
          ...privateIssues(privateSourceRef, [
            ...extractionIssues,
            profileIssue,
          ]),
        );
        sourceFiles.push(
          sourceStatus({
            occurrence,
            accountRef: binding.accountRef,
            state: "preview_blocked",
          }),
        );
        continue;
      }
      try {
        const staged = await service.stageStatementSource({
          transport: "local_path",
          originalPath,
          mimeType: "application/pdf",
          sourceKind: "pdf",
          extractionAssistPath: assistancePath,
          extractionAssistMimeType: "application/json",
        });
        await service.detectStatementProfile({ sourceRef: staged.sourceRef });
        const selection = {
          sourceRef: staged.sourceRef,
          spaceKey: binding.spaceKey,
          accountKey: binding.accountKey,
          profileId: assistance.profileHint,
          profileVersion: "1" as const,
        };
        const preview = await service.previewStatementImport(selection);
        const validated = await service.validateStatementPreview({
          ...selection,
          previewHash: preview.previewHash,
        });
        await writePrivateJson(
          path.join(
            input.privateRoot,
            "previews",
            `${occurrence.occurrenceKey}.json`,
          ),
          validated,
        );
        const privateRecords = previewRecords({
          source: privateSourceRef,
          accountRef: binding.accountRef,
          preview: validated,
        });
        previews.push(privateRecords.preview);
        rows.push(...privateRecords.rows);
        components.push(...privateRecords.components);
        const localIssues = privateIssues(
          privateSourceRef,
          extractionIssues,
          privateRecords.issues.length,
        );
        issues.push(...privateRecords.issues, ...localIssues);
        sourceFiles.push(
          sourceStatus({
            occurrence,
            accountRef: binding.accountRef,
            state: validated.commitAllowed
              ? "preview_valid"
              : "preview_blocked",
            preview: privateRecords.preview,
          }),
        );
      } catch (error) {
        const operationIssue: IntakeIssue = {
          code: safeErrorCode(error),
          severity: "blocking",
          blocking: true,
          explanation:
            "Statement Truth preview failed without a canonical write",
        };
        issues.push(
          ...privateIssues(privateSourceRef, [
            ...extractionIssues,
            operationIssue,
          ]),
        );
        sourceFiles.push(
          sourceStatus({
            occurrence,
            accountRef: binding.accountRef,
            state: "preview_blocked",
          }),
        );
      }
    }
    after = await countGuard(readClient);
  } finally {
    await client.close();
  }
  const zeroWriteVerified =
    after !== null && deterministicJson(before) === deterministicJson(after);
  if (!zeroWriteVerified)
    throw new Error("INTAKE_CANONICAL_COUNT_GUARD_CHANGED");
  const state: RunState = {
    inventory,
    sourceFiles,
    previews,
    rows,
    components,
    issues,
  };
  await writeIndexes(input.privateRoot, state);
  const reports = await writeReports(input.privateRoot, state);
  const summary = aggregateSummary({
    runRef: input.runRef,
    state,
    reports,
    zeroWriteVerified,
  });
  await writePrivateJson(
    path.join(input.privateRoot, "reports", "aggregate-summary.json"),
    summary,
  );
  return summary;
}

async function runQuery(privateRoot: string, runRef: string): Promise<unknown> {
  const query = argument("--query") ?? "description";
  const term = argument("--term")?.trim();
  const limit = Math.min(Math.max(Number(argument("--limit") ?? 100), 1), 1000);
  if (query !== "description" || !term) throw new Error("INTAKE_QUERY_INVALID");
  const source = await readFile(
    path.join(privateRoot, "index", "statement-component.ndjson"),
    "utf8",
  );
  const records = source
    .split(/\r?\n/)
    .filter(Boolean)
    .map((line) => JSON.parse(line) as PrivateComponentRecord);
  const normalized = term.toLocaleUpperCase("en-ZA");
  const matches = records
    .filter((item) =>
      item.rawDescription.toLocaleUpperCase("en-ZA").includes(normalized),
    )
    .slice(0, limit);
  const reportRef = `query-${Date.now()}`;
  await writePrivateNdjson(
    path.join(privateRoot, "reports", `${reportRef}.ndjson`),
    matches,
  );
  return {
    authority: PROVISIONAL_AUTHORITY,
    query: "description",
    resultCount: matches.length,
    truncated: matches.length === limit,
    reportReference: `${runRef}:${reportRef}`,
  };
}

async function main(): Promise<void> {
  const selectedMode = mode();
  const repositoryRoot = path.resolve(
    process.env.RAVEN_REPOSITORY_ROOT ?? defaultRepositoryRoot(),
  );
  const runRef = safeRunRef(
    argument("--run-ref") ?? process.env.RAVEN_EMERGENCY_INTAKE_RUN_REF ?? "",
  );
  const sourceRoot = path.resolve(
    argument("--source-root") ??
      process.env.RAVEN_STATEMENT_SOURCE_ROOT ??
      path.join(repositoryRoot, "docs", "statements"),
  );
  const privateRoot = path.resolve(
    argument("--private-run-root") ??
      process.env.RAVEN_EMERGENCY_INTAKE_ROOT ??
      path.join(
        os.homedir(),
        ".raven-private",
        "emergency-statement-intake",
        runRef,
      ),
  );
  await preparePrivateRunRoot({ repositoryRoot, privateRunRoot: privateRoot });
  if (selectedMode === "query") {
    process.stdout.write(
      `${deterministicJson(await runQuery(privateRoot, runRef))}`,
    );
    return;
  }
  if (selectedMode === "inventory") {
    const inventory = await runInventory({
      sourceRoot,
      privateRoot,
      generatedAt: runTimestamp(runRef),
    });
    process.stdout.write(
      deterministicJson({
        authority: PROVISIONAL_AUTHORITY,
        ...inventoryAggregate(inventory),
        privateOutputReference: runRef,
      }),
    );
    return;
  }
  process.stdout.write(
    `${deterministicJson(
      await runIntake({
        repositoryRoot,
        sourceRoot,
        privateRoot,
        runRef,
      }),
    )}`,
  );
}

export const internal = {
  ALLOWED_SERVICE_CALLS,
  accountCandidates,
  aggregateSummary,
  checkedAdd,
  feeRule,
  monthRange,
  previewRecords,
  readOnlyClient,
  safeErrorCode,
  runTimestamp,
  sourceStatus,
  sumExact,
};

if (import.meta.url === `file://${process.argv[1]}`) {
  main().catch((error) => {
    process.stderr.write(
      deterministicJson({ status: "blocked", code: safeErrorCode(error) }),
    );
    process.exitCode = 1;
  });
}
