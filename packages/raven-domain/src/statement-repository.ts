import type { BalanceSnapshotDraft, OperationDraft } from "./repository.js";
import type {
  StatementAccountBinding,
  StatementCommitOperation,
  StatementImportRecord,
  StatementIssue,
  StatementIssueRecord,
  StatementRowComponentRecord,
  StatementRowRecord,
  StatementSourceComponent,
  StatementSourceRow,
  StatementBalanceConvention,
  StatementBalanceConventionAuthority,
  StatementExtractionCoverage,
  StatementProfileRef,
  StatementSourceKind,
} from "./statement-contracts.js";

export type StatementImportReadFilter = Readonly<{
  spaceKey: string;
  accountKey: string;
  periodStart?: string;
  periodEnd?: string;
}>;

export type StatementImportDraft = Omit<
  StatementImportRecord,
  | "id"
  | "sourceKind"
  | "profile"
  | "currency"
  | "balanceConvention"
  | "coverage"
  | "sourceState"
  | "commitOperationId"
  | "legacyPeriodEvidence"
> &
  Readonly<{
    sourceKind: StatementSourceKind;
    profile: StatementProfileRef;
    currency: "ZAR";
    balanceConvention: StatementBalanceConvention;
    balanceConventionAuthority: StatementBalanceConventionAuthority;
    coverage: StatementExtractionCoverage;
    sourceState: "committed";
    commitOperationId: string;
  }>;

export type StatementReviewedAccountContext = Readonly<{
  spaceId: string;
  accountId: string;
  spaceKey: string;
  accountKey: string;
  currency: string;
  normalNature: StatementAccountBinding["normalNature"];
  accountNumberLast4: string | null;
  spaceTimezone: string;
  accountContextFingerprint: string;
}>;
export type StatementRowDraft = Omit<
  StatementRowRecord,
  "id" | "spaceId" | "accountId" | "statementImportId" | "commitOperationId"
> &
  Readonly<{ key: string }>;
export type StatementRowComponentDraft = Omit<
  StatementRowComponentRecord,
  | "id"
  | "spaceId"
  | "accountId"
  | "statementImportId"
  | "statementRowId"
  | "commitOperationId"
  | "sourceState"
  | "issues"
> &
  Readonly<{ rowKey: string }>;
export type StatementIssueDraft = Omit<
  StatementIssue,
  "rowKey" | "componentKey"
> &
  Readonly<{
    key: string;
    rowKey: string | null;
    componentKey: string | null;
    detectedAt: string;
  }>;

export type StatementCommitDraft = Readonly<{
  expectedAccountContext: StatementReviewedAccountContext;
  statementImport: StatementImportDraft;
  rows: readonly StatementRowDraft[];
  components: readonly StatementRowComponentDraft[];
  issues: readonly StatementIssueDraft[];
  operation: OperationDraft;
  snapshot: BalanceSnapshotDraft | null;
}>;

export interface StatementTruthRepository {
  getAccount(
    spaceKey: string,
    accountKey: string,
  ): Promise<StatementAccountBinding | null>;
  getCommitOperation(
    idempotencyKey: string,
  ): Promise<StatementCommitOperation | null>;
  listStatementImports(
    filter: StatementImportReadFilter,
  ): Promise<StatementImportRecord[]>;
  getStatementImport(id: string): Promise<StatementImportRecord | null>;
  listStatementRows(statementImportId: string): Promise<StatementRowRecord[]>;
  getStatementRow(id: string): Promise<StatementRowRecord | null>;
  listStatementRowComponents(filter: {
    statementImportId?: string;
    statementRowId?: string;
  }): Promise<StatementRowComponentRecord[]>;
  getStatementRowComponent(
    id: string,
  ): Promise<StatementRowComponentRecord | null>;
  listStatementIssues(
    statementImportId: string,
  ): Promise<StatementIssueRecord[]>;
  getStatementIssue(id: string): Promise<StatementIssueRecord | null>;
  commitStatementImport(draft: StatementCommitDraft): Promise<{
    statementImport: StatementImportRecord;
    operation: StatementCommitOperation;
    snapshotId: string | null;
  }>;
}

export function statementRowDraft(row: StatementSourceRow): StatementRowDraft {
  return {
    rowKey: row.rowKey,
    key: row.rowKey,
    rowNumber: row.rowNumber,
    rowKind: row.rowKind,
    transactionDate: row.transactionDate,
    postingDate: row.postingDate,
    valueDate: row.valueDate,
    rawText: row.rawText,
    sourceReference: row.sourceReference,
    reportedBalanceMinor: row.reportedBalanceMinor,
    locator: row.locator,
    confidence: row.confidence,
    rowHash: row.rowHash,
    componentCount: row.components.length,
  };
}

export function statementComponentDraft(
  rowKey: string,
  component: StatementSourceComponent,
): StatementRowComponentDraft {
  return {
    rowKey,
    componentKey: component.componentKey,
    componentKind: component.componentKind,
    componentRole: component.componentRole,
    transactionDate: component.transactionDate,
    postingDate: component.postingDate,
    valueDate: component.valueDate,
    description: component.description,
    sourceReference: component.sourceReference,
    amountMinor: component.amountMinor,
    currency: component.currency,
    sourceDirection: component.sourceDirection,
    sourceFlow: component.sourceFlow,
    balanceEffectMinor: component.balanceEffectMinor,
    locator: component.locator,
    confidence: component.confidence,
    sourceChecksum: component.sourceChecksum,
  };
}
