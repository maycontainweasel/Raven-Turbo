import type {
  AccountNature,
  AccountRecord,
  FinancialOperationRecord,
  OperationChannel,
} from "./contracts.js";
import type { StatementResolutionApi } from "./statement-resolution-contracts.js";
import type { StatementLegacyResolutionApi } from "./statement-legacy-resolution-contracts.js";

export const STATEMENT_TRUTH_CONTRACT_VERSION = "statement-truth-v0.1" as const;
export const STATEMENT_EXTRACTION_CONTRACT_VERSION =
  "statement-extraction-v0.1" as const;
export const STATEMENT_VALIDATION_RULESET_VERSION =
  "statement-validation-v0.3" as const;

export type StatementSourceKind = "pdf" | "csv" | "ofx" | "qif" | "image";
export type StatementComponentRole = "movement" | "informational_breakdown";
export type StatementComponentKind =
  | "principal"
  | "bank_fee"
  | "vat"
  | "interest"
  | "adjustment"
  | "unknown";
export type StatementIssueSeverity = "info" | "warning" | "blocking";
export type StatementSourceDirection = "debit" | "credit" | "unknown";
export type StatementSourceFlow = "inflow" | "outflow" | "unknown";
export type StatementRowKind =
  | "movement"
  | "informational"
  | "composite"
  | "unresolved";
export type StatementBalanceConvention =
  | "positive_is_asset"
  | "positive_is_liability";
export type StatementBalanceConventionAuthority =
  | "profile"
  | "operator_unverified";
export type StatementCoverageStatus =
  | "complete"
  | "incomplete"
  | "indeterminate";
export type StatementExtractionCoverage = Readonly<{
  status: StatementCoverageStatus;
  sourcePageCount: number | null;
  processedPages: readonly number[];
  sourceSections: readonly string[];
  processedSections: readonly string[];
  printedRowCount: number | null;
  extractedRowCount: number;
}>;

export type StatementWarningCode =
  | "STATEMENT_ROW_LOW_CONFIDENCE"
  | "STATEMENT_ROW_UNRESOLVED"
  | "STATEMENT_COMPONENT_UNRESOLVED"
  | "STATEMENT_BALANCE_MISSING"
  | "STATEMENT_BALANCE_DIFFERENCE"
  | "STATEMENT_BALANCE_CONVENTION_UNVERIFIED"
  | "STATEMENT_EXISTING_IMPORT_FOUND"
  | "STATEMENT_PARTIAL_PERIOD";

export type StatementErrorCode =
  | "STATEMENT_SOURCE_NOT_FOUND"
  | "STATEMENT_PROFILE_UNSUPPORTED"
  | "STATEMENT_PROFILE_AMBIGUOUS"
  | "STATEMENT_SOURCE_CHANGED"
  | "STATEMENT_PREVIEW_STALE"
  | "STATEMENT_DUPLICATE_SOURCE"
  | "STATEMENT_ACCOUNT_MISMATCH"
  | "STATEMENT_CURRENCY_MISMATCH"
  | "STATEMENT_PERIOD_INVALID"
  | "STATEMENT_EXTRACTION_INVALID"
  | "STATEMENT_LEGACY_PERIOD_CONFLICT"
  | "STATEMENT_LEGACY_COMPATIBILITY_REQUIRED"
  | "STATEMENT_IMMUTABLE_CONFLICT";

export type StatementSourceDescriptor = Readonly<{
  sourceRef: string;
  sourceKind: StatementSourceKind;
  mimeType: string;
  byteSize: number;
  originalFileSha256: string;
  extractionAssistRef: string | null;
  extractionAssistMimeType: string | null;
  extractionAssistByteSize: number | null;
  extractionInputSha256: string | null;
}>;

export type StatementSourceBundle = Readonly<{
  descriptor: StatementSourceDescriptor;
  originalBytes: Uint8Array;
  extractionAssistBytes: Uint8Array | null;
}>;

export type StatementProfileRef = Readonly<{
  profileId:
    | "nedbank-current"
    | "nedbank-savings"
    | "nedbank-credit"
    | "fnb-business"
    | "normalized-json-v1";
  profileVersion: "1";
  extractorVersion: "statement-neutral-v0.3";
}>;

export type StatementProfileView = StatementProfileRef &
  Readonly<{
    institution: string;
    supportedSourceKinds: readonly StatementSourceKind[];
    extractionAssistRequired: boolean;
    balanceConventionAuthority: StatementBalanceConvention | null;
  }>;

export type StatementSourceLocator = Readonly<{
  page?: number;
  line?: number;
  region?: Readonly<{ x: number; y: number; width: number; height: number }>;
  sourceToken?: string;
}>;

export type StatementIssue = Readonly<{
  code: StatementWarningCode | StatementErrorCode;
  severity: StatementIssueSeverity;
  blocking: boolean;
  message: string;
  rowKey?: string;
  componentKey?: string;
}>;

export type StatementSourceComponent = Readonly<{
  componentKey: string;
  componentKind: StatementComponentKind;
  componentRole: StatementComponentRole;
  transactionDate: string | null;
  postingDate: string | null;
  valueDate: string | null;
  description: string;
  sourceReference: string | null;
  amountMinor: number;
  currency: "ZAR";
  sourceDirection: StatementSourceDirection;
  sourceFlow: StatementSourceFlow;
  balanceEffectMinor: number;
  locator: StatementSourceLocator | null;
  confidence: number;
  sourceChecksum: string;
  issues: readonly StatementIssue[];
}>;

export type StatementSourceRow = Readonly<{
  rowKey: string;
  rowNumber: number;
  rowKind: StatementRowKind;
  transactionDate: string | null;
  postingDate: string | null;
  valueDate: string | null;
  rawText: string;
  sourceReference: string | null;
  reportedBalanceMinor: number | null;
  locator: StatementSourceLocator | null;
  confidence: number;
  rowHash: string;
  components: readonly StatementSourceComponent[];
  issues: readonly StatementIssue[];
}>;

export type NormalizedStatementExtraction = Readonly<{
  contractVersion: typeof STATEMENT_EXTRACTION_CONTRACT_VERSION;
  profile: StatementProfileRef;
  institution: string;
  accountHints: Readonly<{
    maskedAccount: string | null;
    sourceAccountType: string | null;
  }>;
  currency: "ZAR";
  periodStart: string;
  periodEnd: string;
  balanceConvention: StatementBalanceConvention;
  balanceConventionAuthority: StatementBalanceConventionAuthority;
  openingBalanceMinor: number | null;
  closingBalanceMinor: number | null;
  closingBalanceEconomicNature: AccountNature | null;
  coverage: StatementExtractionCoverage;
  rows: readonly StatementSourceRow[];
  canonicalExtractionSha256: string;
  issues: readonly StatementIssue[];
}>;

export type StatementProfileDetection = Readonly<{
  profile: StatementProfileRef;
  confidence: number;
  evidenceCodes: readonly string[];
  issues: readonly StatementIssue[];
}>;

export type StatementQueryMeta = Readonly<{
  requestId: string;
  generatedAt: string;
  contractVersion: typeof STATEMENT_TRUTH_CONTRACT_VERSION;
  warnings: readonly StatementWarningCode[];
}>;

export type StatementPreviewResult = Readonly<{
  source: StatementSourceDescriptor;
  profile: StatementProfileRef;
  account: Readonly<{
    spaceId: string;
    accountId: string;
    spaceKey: string;
    accountKey: string;
    currency: string;
    normalNature: AccountNature;
    accountNumberLast4: string | null;
    spaceTimezone: string;
    accountContextFingerprint: string;
  }>;
  extraction: NormalizedStatementExtraction;
  rowCount: number;
  componentCount: number;
  informationalRowCount: number;
  inflowMinor: number;
  outflowMinor: number;
  expectedClosingBalanceMinor: number | null;
  reportedClosingBalanceMinor: number | null;
  differenceMinor: number | null;
  duplicateImports: readonly string[];
  issues: readonly StatementIssue[];
  previewHash: string;
  closingSnapshotEligible: boolean;
  commitAllowed: boolean;
  meta: StatementQueryMeta;
}>;

export type StatementImportRecord = Readonly<{
  id: string;
  spaceId: string;
  accountId: string;
  spaceKey: string;
  accountKey: string;
  key: string;
  privateSourceRef: string;
  extractionAssistRef: string | null;
  originalFileSha256: string;
  extractionInputSha256: string | null;
  canonicalExtractionSha256: string;
  previewHash: string;
  sourceKind: StatementSourceKind | "normalized_json" | "manual";
  sourceMimeType: string;
  sourceByteSize: number;
  profile: Readonly<{
    profileId: string;
    profileVersion: string;
    extractorVersion: string;
  }>;
  validationRulesetVersion: string;
  periodStart: string;
  periodEnd: string;
  currency: string;
  balanceConvention: StatementBalanceConvention | null;
  balanceConventionAuthority: StatementBalanceConventionAuthority | null;
  accountContextFingerprint: string;
  openingBalanceMinor: number | null;
  closingBalanceMinor: number | null;
  closingBalanceEconomicNature: AccountNature | null;
  coverage: StatementExtractionCoverage | null;
  sourceState: "legacy" | "committed" | "superseded";
  importedAt: string;
  committedAt: string;
  commitOperationId: string | null;
  replacementOfId: string | null;
  rowCount: number;
  componentCount: number;
  issueCount: number;
  revision: number;
  legacyPeriodEvidence: Readonly<{
    statementDate: string | null;
    keyDate: string | null;
    mapping:
      | "not_legacy"
      | "exact_fields"
      | "known_renderer_end_date"
      | "unmappable";
  }>;
}>;

export type StatementRowRecord = Omit<
  StatementSourceRow,
  "components" | "issues"
> &
  Readonly<{
    id: string;
    spaceId: string;
    accountId: string;
    statementImportId: string;
    commitOperationId: string;
    componentCount: number;
  }>;

export type StatementRowComponentRecord = StatementSourceComponent &
  Readonly<{
    id: string;
    spaceId: string;
    accountId: string;
    statementImportId: string;
    statementRowId: string;
    commitOperationId: string;
    sourceState: "committed" | "superseded";
  }>;

export type StatementIssueRecord = StatementIssue &
  Readonly<{
    id: string;
    key: string;
    spaceId: string;
    accountId: string;
    statementImportId: string;
    statementRowId: string | null;
    statementRowComponentId: string | null;
    state: "open" | "acknowledged" | "resolved" | "superseded";
    revision: number;
    detectedOperationId: string;
    dispositionOperationId: string | null;
    detectedAt: string;
    acknowledgedAt: string | null;
    resolvedAt: string | null;
    reviewedBy: string | null;
    notes: string | null;
  }>;

export type StatementCommitReceipt = Readonly<{
  operationId: string;
  status: "applied" | "replayed";
  resultRefs: readonly string[];
  warningCodes: readonly StatementWarningCode[];
  completedAt: string;
}>;

export type StatementCommitResult = Readonly<{
  statementImport: StatementImportRecord;
  snapshotId: string | null;
  receipt: StatementCommitReceipt;
}>;

export type StageStatementSourceInput =
  | Readonly<{
      transport: "upload";
      originalBytes: Uint8Array;
      mimeType: string;
      sourceKind: StatementSourceKind;
      extractionAssistBytes?: Uint8Array;
      extractionAssistMimeType?: "application/json";
    }>
  | Readonly<{
      transport: "local_path";
      originalPath: string;
      mimeType: string;
      sourceKind: StatementSourceKind;
      extractionAssistPath?: string;
      extractionAssistMimeType?: "application/json";
    }>;

export type DetectStatementProfileInput = Readonly<{ sourceRef: string }>;
export type PreviewStatementImportInput = Readonly<{
  sourceRef: string;
  spaceKey: string;
  accountKey: string;
  profileId: StatementProfileRef["profileId"];
  profileVersion: StatementProfileRef["profileVersion"];
}>;
export type ValidateStatementPreviewInput = PreviewStatementImportInput &
  Readonly<{ previewHash: string }>;
export type CommitStatementImportInput = ValidateStatementPreviewInput &
  Readonly<{
    idempotencyKey: string;
    channel: OperationChannel;
    actorId?: string;
  }>;

export type ListStatementImportsInput = Readonly<{
  spaceKey: string;
  accountKey: string;
  periodStart?: string;
  periodEnd?: string;
}>;
export type GetStatementImportInput = Readonly<{ statementImportId: string }>;
export type ListStatementRowsInput = Readonly<{ statementImportId: string }>;
export type GetStatementRowInput = Readonly<{ statementRowId: string }>;
export type ListStatementRowComponentsInput = Readonly<{
  statementImportId?: string;
  statementRowId?: string;
}>;
export type GetStatementRowComponentInput = Readonly<{
  statementRowComponentId: string;
}>;
export type ListStatementImportIssuesInput = Readonly<{
  statementImportId: string;
}>;
export type GetStatementImportIssueInput = Readonly<{
  statementIssueId: string;
}>;

export interface StatementSourceVault {
  stageUpload(
    input: Extract<StageStatementSourceInput, { transport: "upload" }>,
  ): Promise<StatementSourceDescriptor>;
  stageLocalPath(
    input: Extract<StageStatementSourceInput, { transport: "local_path" }>,
  ): Promise<StatementSourceDescriptor>;
  describe(sourceRef: string): Promise<StatementSourceDescriptor>;
  readBundle(sourceRef: string): Promise<StatementSourceBundle>;
}

export interface StatementAdapter {
  readonly profile: StatementProfileView;
  detect(
    bundle: StatementSourceBundle,
  ): Promise<StatementProfileDetection | null>;
  extract(
    bundle: StatementSourceBundle,
  ): Promise<NormalizedStatementExtraction>;
}

export interface StatementAdapterRegistry {
  list(): readonly StatementProfileView[];
  get(
    profileId: StatementProfileRef["profileId"],
    profileVersion: string,
  ): StatementAdapter | null;
  detect(
    bundle: StatementSourceBundle,
  ): Promise<readonly StatementProfileDetection[]>;
}

export interface StatementTruthApi
  extends StatementResolutionApi, StatementLegacyResolutionApi {
  stageStatementSource(
    input: StageStatementSourceInput,
  ): Promise<StatementSourceDescriptor>;
  listStatementProfiles(): Promise<{
    profiles: readonly StatementProfileView[];
    meta: StatementQueryMeta;
  }>;
  detectStatementProfile(input: DetectStatementProfileInput): Promise<{
    source: StatementSourceDescriptor;
    candidates: readonly StatementProfileDetection[];
    meta: StatementQueryMeta;
  }>;
  previewStatementImport(
    input: PreviewStatementImportInput,
  ): Promise<StatementPreviewResult>;
  validateStatementPreview(
    input: ValidateStatementPreviewInput,
  ): Promise<StatementPreviewResult>;
  commitStatementImport(
    input: CommitStatementImportInput,
  ): Promise<StatementCommitResult>;
  listStatementImports(input: ListStatementImportsInput): Promise<{
    imports: readonly StatementImportRecord[];
    meta: StatementQueryMeta;
  }>;
  getStatementImport(input: GetStatementImportInput): Promise<{
    statementImport: StatementImportRecord;
    rows: readonly StatementRowRecord[];
    components: readonly StatementRowComponentRecord[];
    issues: readonly StatementIssueRecord[];
    meta: StatementQueryMeta;
  }>;
  listStatementRows(
    input: ListStatementRowsInput,
  ): Promise<{ rows: readonly StatementRowRecord[]; meta: StatementQueryMeta }>;
  getStatementRow(input: GetStatementRowInput): Promise<{
    row: StatementRowRecord;
    components: readonly StatementRowComponentRecord[];
    issues: readonly StatementIssueRecord[];
    meta: StatementQueryMeta;
  }>;
  listStatementRowComponents(input: ListStatementRowComponentsInput): Promise<{
    components: readonly StatementRowComponentRecord[];
    meta: StatementQueryMeta;
  }>;
  getStatementRowComponent(input: GetStatementRowComponentInput): Promise<{
    component: StatementRowComponentRecord;
    meta: StatementQueryMeta;
  }>;
  listStatementImportIssues(input: ListStatementImportIssuesInput): Promise<{
    issues: readonly StatementIssueRecord[];
    meta: StatementQueryMeta;
  }>;
  getStatementImportIssue(input: GetStatementImportIssueInput): Promise<{
    issue: StatementIssueRecord;
    meta: StatementQueryMeta;
  }>;
}

export type StatementAccountBinding = Pick<
  AccountRecord,
  | "id"
  | "spaceId"
  | "spaceKey"
  | "key"
  | "currency"
  | "normalNature"
  | "accountNumberLast4"
> &
  Readonly<{ spaceTimezone: string }>;

export type StatementCommitOperation = FinancialOperationRecord &
  Readonly<{ command: "commit_statement_import" }>;
