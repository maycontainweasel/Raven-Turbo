import { createHash } from "node:crypto";
import { RavenDomainError } from "./errors.js";
import {
  STATEMENT_EXTRACTION_CONTRACT_VERSION,
  type NormalizedStatementExtraction,
  type StatementAdapter,
  type StatementAdapterRegistry,
  type StatementBalanceConvention,
  type StatementComponentKind,
  type StatementComponentRole,
  type StatementExtractionCoverage,
  type StatementIssue,
  type StatementProfileDetection,
  type StatementProfileRef,
  type StatementProfileView,
  type StatementSourceBundle,
  type StatementSourceComponent,
  type StatementSourceDirection,
  type StatementSourceFlow,
  type StatementSourceLocator,
  type StatementSourceRow,
} from "./statement-contracts.js";

const PROFILE_VERSION = "1" as const;
const EXTRACTOR_VERSION = "statement-neutral-v0.3" as const;
const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;
const FORBIDDEN_MEANING_KEYS = new Set([
  "account",
  "accountId",
  "accountKey",
  "category",
  "categoryId",
  "categoryKey",
  "merchant",
  "merchantId",
  "taxTreatment",
  "taxCategory",
  "transactionKind",
  "checksum",
  "originalFileSha256",
]);

type JsonObject = Record<string, unknown>;

const PROFILE_DEFINITIONS: readonly StatementProfileView[] = [
  {
    profileId: "nedbank-current",
    profileVersion: PROFILE_VERSION,
    extractorVersion: EXTRACTOR_VERSION,
    institution: "Nedbank",
    supportedSourceKinds: ["pdf", "csv", "image"],
    extractionAssistRequired: true,
    balanceConventionAuthority: "positive_is_asset",
  },
  {
    profileId: "nedbank-savings",
    profileVersion: PROFILE_VERSION,
    extractorVersion: EXTRACTOR_VERSION,
    institution: "Nedbank",
    supportedSourceKinds: ["pdf", "csv", "image"],
    extractionAssistRequired: true,
    balanceConventionAuthority: "positive_is_asset",
  },
  {
    profileId: "nedbank-credit",
    profileVersion: PROFILE_VERSION,
    extractorVersion: EXTRACTOR_VERSION,
    institution: "Nedbank",
    supportedSourceKinds: ["pdf", "csv", "image"],
    extractionAssistRequired: true,
    balanceConventionAuthority: "positive_is_liability",
  },
  {
    profileId: "fnb-business",
    profileVersion: PROFILE_VERSION,
    extractorVersion: EXTRACTOR_VERSION,
    institution: "FNB",
    supportedSourceKinds: ["pdf", "csv", "image"],
    extractionAssistRequired: true,
    balanceConventionAuthority: "positive_is_asset",
  },
  {
    profileId: "normalized-json-v1",
    profileVersion: PROFILE_VERSION,
    extractorVersion: EXTRACTOR_VERSION,
    institution: "Operator-assisted",
    supportedSourceKinds: ["pdf", "csv", "ofx", "qif", "image"],
    extractionAssistRequired: true,
    balanceConventionAuthority: null,
  },
];

function object(value: unknown, label: string): JsonObject {
  if (!value || typeof value !== "object" || Array.isArray(value)) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      `${label} must be an object`,
    );
  }
  return value as JsonObject;
}

function string(value: unknown, label: string, required = true): string | null {
  if (value === null || value === undefined || value === "") {
    if (!required) return null;
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      `${label} is required`,
    );
  }
  if (typeof value !== "string") {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      `${label} must be text`,
    );
  }
  return value;
}

function date(value: unknown, label: string, required = false): string | null {
  const result = string(value, label, required);
  if (result === null) return null;
  const match = DATE_ONLY.exec(result);
  const parsed = match ? new Date(`${result}T00:00:00.000Z`) : null;
  if (
    !match ||
    !parsed ||
    !Number.isFinite(parsed.getTime()) ||
    parsed.getUTCFullYear() !== Number(result.slice(0, 4)) ||
    parsed.getUTCMonth() + 1 !== Number(result.slice(5, 7)) ||
    parsed.getUTCDate() !== Number(result.slice(8, 10))
  ) {
    throw new RavenDomainError(
      "STATEMENT_PERIOD_INVALID",
      `${label} must be an exact date`,
    );
  }
  return result;
}

function assertAllowedKeys(
  input: JsonObject,
  label: string,
  allowed: readonly string[],
): void {
  const allowedKeys = new Set(allowed);
  const unknown = Object.keys(input).filter((key) => !allowedKeys.has(key));
  if (unknown.length > 0) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      `${label} contains unsupported fields: ${unknown.sort().join(", ")}`,
    );
  }
}

function requiredArray(value: unknown, label: string): unknown[] {
  if (!Array.isArray(value)) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      `${label} must be an array`,
    );
  }
  return value;
}

function checkedAdd(left: number, right: number, label: string): number {
  const result = left + right;
  if (!Number.isSafeInteger(result)) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      `${label} exceeds the safe integer range`,
    );
  }
  return result;
}

function safeInteger(
  value: unknown,
  label: string,
  optional = false,
): number | null {
  if (value === null || value === undefined) {
    if (optional) return null;
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      `${label} is required`,
    );
  }
  if (!Number.isSafeInteger(value)) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      `${label} must be a safe integer`,
    );
  }
  return Number(value);
}

function confidence(value: unknown, label: string): number {
  if (
    typeof value !== "number" ||
    !Number.isFinite(value) ||
    value < 0 ||
    value > 1
  ) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      `${label} must be between zero and one`,
    );
  }
  return value;
}

function enumValue<T extends string>(
  value: unknown,
  label: string,
  allowed: readonly T[],
): T {
  if (typeof value !== "string" || !allowed.includes(value as T)) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      `${label} is unsupported`,
    );
  }
  return value as T;
}

function assertNoAcceptedMeaning(value: unknown): void {
  if (Array.isArray(value)) {
    value.forEach(assertNoAcceptedMeaning);
    return;
  }
  if (!value || typeof value !== "object") return;
  for (const [key, nested] of Object.entries(value as JsonObject)) {
    if (FORBIDDEN_MEANING_KEYS.has(key)) {
      throw new RavenDomainError(
        "STATEMENT_EXTRACTION_INVALID",
        "Extraction assistance contains fields outside neutral source truth",
      );
    }
    assertNoAcceptedMeaning(nested);
  }
}

function canonicalize(value: unknown): unknown {
  if (Array.isArray(value)) return value.map(canonicalize);
  if (!value || typeof value !== "object") return value;
  return Object.fromEntries(
    Object.entries(value as JsonObject)
      .filter(([, nested]) => nested !== undefined)
      .sort(([left], [right]) => left.localeCompare(right))
      .map(([key, nested]) => [key, canonicalize(nested)]),
  );
}

export function canonicalStatementJson(value: unknown): string {
  return JSON.stringify(canonicalize(value));
}

export function statementSha256(value: Uint8Array | string): string {
  return createHash("sha256").update(value).digest("hex");
}

function locator(value: unknown): StatementSourceLocator | null {
  if (value === null || value === undefined) return null;
  const input = object(value, "locator");
  assertAllowedKeys(input, "locator", [
    "page",
    "line",
    "region",
    "sourceToken",
  ]);
  const output: {
    page?: number;
    line?: number;
    region?: { x: number; y: number; width: number; height: number };
    sourceToken?: string;
  } = {};
  if (input.page !== undefined)
    output.page = safeInteger(input.page, "locator.page")!;
  if (input.line !== undefined)
    output.line = safeInteger(input.line, "locator.line")!;
  if (output.page !== undefined && output.page < 1) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "locator.page must be a positive integer",
    );
  }
  if (output.line !== undefined && output.line < 1) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "locator.line must be a positive integer",
    );
  }
  if (input.sourceToken !== undefined)
    output.sourceToken = string(input.sourceToken, "locator.sourceToken")!;
  if (input.region !== undefined) {
    const region = object(input.region, "locator.region");
    assertAllowedKeys(region, "locator.region", ["x", "y", "width", "height"]);
    const x = Number(region.x);
    const y = Number(region.y);
    const width = Number(region.width);
    const height = Number(region.height);
    if (
      ![x, y, width, height].every(Number.isFinite) ||
      x < 0 ||
      y < 0 ||
      width <= 0 ||
      height <= 0
    ) {
      throw new RavenDomainError(
        "STATEMENT_EXTRACTION_INVALID",
        "locator.region is invalid",
      );
    }
    output.region = { x, y, width, height };
  }
  return output;
}

function uniqueStrings(value: unknown, label: string): string[] {
  const values = requiredArray(value, label).map((item, index) =>
    string(item, `${label}[${index}]`),
  ) as string[];
  if (new Set(values).size !== values.length) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      `${label} contains duplicate values`,
    );
  }
  return values;
}

function uniquePositiveIntegers(value: unknown, label: string): number[] {
  const values = requiredArray(value, label).map((item, index) => {
    const parsed = safeInteger(item, `${label}[${index}]`)!;
    if (parsed < 1) {
      throw new RavenDomainError(
        "STATEMENT_EXTRACTION_INVALID",
        `${label} values must be positive integers`,
      );
    }
    return parsed;
  });
  if (new Set(values).size !== values.length) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      `${label} contains duplicate values`,
    );
  }
  return values;
}

function parseCoverage(
  value: unknown,
  extractedRowCount: number,
): StatementExtractionCoverage {
  const input = object(value, "coverage");
  assertAllowedKeys(input, "coverage", [
    "status",
    "sourcePageCount",
    "processedPages",
    "sourceSections",
    "processedSections",
    "printedRowCount",
  ]);
  const status = enumValue(input.status, "coverage.status", [
    "complete",
    "incomplete",
    "indeterminate",
  ] as const);
  const sourcePageCount = safeInteger(
    input.sourcePageCount,
    "coverage.sourcePageCount",
    true,
  );
  if (sourcePageCount !== null && sourcePageCount < 1) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "coverage.sourcePageCount must be positive when supplied",
    );
  }
  const processedPages = uniquePositiveIntegers(
    input.processedPages,
    "coverage.processedPages",
  );
  if (
    sourcePageCount !== null &&
    processedPages.some((page) => page > sourcePageCount)
  ) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "coverage.processedPages exceeds the source page count",
    );
  }
  const sourceSections = uniqueStrings(
    input.sourceSections,
    "coverage.sourceSections",
  ).sort();
  const processedSections = uniqueStrings(
    input.processedSections,
    "coverage.processedSections",
  ).sort();
  const printedRowCount = safeInteger(
    input.printedRowCount,
    "coverage.printedRowCount",
    true,
  );
  if (printedRowCount !== null && printedRowCount < 0) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "coverage.printedRowCount cannot be negative",
    );
  }
  return {
    status,
    sourcePageCount,
    processedPages,
    sourceSections,
    processedSections,
    printedRowCount,
    extractedRowCount,
  };
}

function coverageIsComplete(coverage: StatementExtractionCoverage): boolean {
  const pagesComplete =
    coverage.sourcePageCount === null ||
    (coverage.processedPages.length === coverage.sourcePageCount &&
      coverage.processedPages.every((page, index) => page === index + 1));
  const sectionsComplete =
    coverage.sourceSections.length === coverage.processedSections.length &&
    coverage.sourceSections.every(
      (section, index) => section === coverage.processedSections[index],
    );
  return (
    coverage.status === "complete" &&
    pagesComplete &&
    sectionsComplete &&
    coverage.printedRowCount !== null &&
    coverage.printedRowCount === coverage.extractedRowCount
  );
}

function validateCoverageForSource(
  sourceKind: StatementSourceBundle["descriptor"]["sourceKind"],
  coverage: StatementExtractionCoverage,
): void {
  const paginated = sourceKind === "pdf" || sourceKind === "image";
  if (paginated) {
    if (coverage.status === "complete" && coverage.sourcePageCount === null) {
      throw new RavenDomainError(
        "STATEMENT_EXTRACTION_INVALID",
        "PDF and image coverage requires a positive source page count",
      );
    }
    if (
      coverage.status === "complete" &&
      coverage.sourcePageCount !== null &&
      (coverage.processedPages.length !== coverage.sourcePageCount ||
        coverage.processedPages.some((page, index) => page !== index + 1))
    ) {
      throw new RavenDomainError(
        "STATEMENT_EXTRACTION_INVALID",
        "PDF and image processed pages must be exactly 1 through the source page count",
      );
    }
    return;
  }
  if (
    coverage.sourcePageCount !== null ||
    coverage.processedPages.length !== 0
  ) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "CSV, OFX and QIF sources are nonpaginated and require null page count with no processed pages",
    );
  }
}

function validateLocatorForSource(
  locatorValue: StatementSourceLocator | null,
  sourceKind: StatementSourceBundle["descriptor"]["sourceKind"],
  sourcePageCount: number | null,
): void {
  if (!locatorValue) return;
  const paginated = sourceKind === "pdf" || sourceKind === "image";
  if (!paginated && locatorValue.page !== undefined) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "Nonpaginated source locators cannot contain page numbers",
    );
  }
  if (
    paginated &&
    locatorValue.page !== undefined &&
    sourcePageCount !== null &&
    locatorValue.page > sourcePageCount
  ) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "A source locator page exceeds the declared source page count",
    );
  }
}

function issue(
  code: StatementIssue["code"],
  severity: StatementIssue["severity"],
  message: string,
  rowKey?: string,
  componentKey?: string,
): StatementIssue {
  return {
    code,
    severity,
    blocking: severity === "blocking",
    message,
    rowKey,
    componentKey,
  };
}

function parseComponent(
  value: unknown,
  rowKey: string,
  index: number,
  balanceConvention: StatementBalanceConvention,
  parentHasPrintedDate: boolean,
): StatementSourceComponent {
  const input = object(value, `rows[].components[${index}]`);
  assertAllowedKeys(input, `rows[].components[${index}]`, [
    "componentKey",
    "componentKind",
    "componentRole",
    "transactionDate",
    "postingDate",
    "valueDate",
    "description",
    "sourceReference",
    "amountMinor",
    "currency",
    "sourceDirection",
    "sourceFlow",
    "balanceEffectMinor",
    "locator",
    "confidence",
  ]);
  const componentKey = string(input.componentKey, "componentKey")!;
  const componentKind = enumValue<StatementComponentKind>(
    input.componentKind,
    "componentKind",
    ["principal", "bank_fee", "vat", "interest", "adjustment", "unknown"],
  );
  const componentRole = enumValue<StatementComponentRole>(
    input.componentRole,
    "componentRole",
    ["movement", "informational_breakdown"],
  );
  const amountMinor = safeInteger(input.amountMinor, "amountMinor")!;
  const balanceEffectMinor = safeInteger(
    input.balanceEffectMinor,
    "balanceEffectMinor",
  )!;
  if (amountMinor <= 0) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "Component amount must be positive",
    );
  }
  if (
    (componentRole === "movement" && balanceEffectMinor === 0) ||
    (componentRole === "informational_breakdown" && balanceEffectMinor !== 0)
  ) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "Component role and signed balance effect are inconsistent",
    );
  }
  if (
    componentRole === "movement" &&
    Math.abs(balanceEffectMinor) !== amountMinor
  ) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "Movement amount must equal the absolute signed balance effect",
    );
  }
  const currency = string(input.currency, "currency")?.toUpperCase();
  if (currency !== "ZAR") {
    throw new RavenDomainError(
      "UNSUPPORTED_CURRENCY",
      "ST-01 supports ZAR statement sources only",
    );
  }
  const parsedConfidence = confidence(input.confidence, "component.confidence");
  const issues: StatementIssue[] = [];
  if (parsedConfidence < 0.8) {
    issues.push(
      issue(
        "STATEMENT_COMPONENT_UNRESOLVED",
        "blocking",
        "A monetary component does not have sufficient extraction confidence",
        rowKey,
        componentKey,
      ),
    );
  } else if (componentKind === "unknown") {
    issues.push(
      issue(
        "STATEMENT_COMPONENT_UNRESOLVED",
        "warning",
        "The source component kind is unresolved",
        rowKey,
        componentKey,
      ),
    );
  }
  const transactionDate = date(
    input.transactionDate,
    "component.transactionDate",
  );
  const postingDate = date(input.postingDate, "component.postingDate");
  const valueDate = date(input.valueDate, "component.valueDate");
  const sourceFlow = enumValue<StatementSourceFlow>(
    input.sourceFlow,
    "sourceFlow",
    ["inflow", "outflow", "unknown"],
  );
  if (componentRole === "movement") {
    if (
      !parentHasPrintedDate &&
      transactionDate === null &&
      postingDate === null &&
      valueDate === null
    ) {
      throw new RavenDomainError(
        "STATEMENT_EXTRACTION_INVALID",
        "Every movement requires an exact printed date on the component or parent row",
      );
    }
    if (sourceFlow === "unknown") {
      throw new RavenDomainError(
        "STATEMENT_EXTRACTION_INVALID",
        "Every movement requires a known source flow",
      );
    }
    const expectedFlow =
      balanceConvention === "positive_is_asset"
        ? balanceEffectMinor > 0
          ? "inflow"
          : "outflow"
        : balanceEffectMinor > 0
          ? "outflow"
          : "inflow";
    if (sourceFlow !== expectedFlow) {
      throw new RavenDomainError(
        "STATEMENT_EXTRACTION_INVALID",
        "Source flow conflicts with the balance convention and signed effect",
      );
    }
  }
  const normalized = {
    componentKey,
    componentKind,
    componentRole,
    transactionDate,
    postingDate,
    valueDate,
    description: string(input.description, "component.description")!,
    sourceReference: string(
      input.sourceReference,
      "component.sourceReference",
      false,
    ),
    amountMinor,
    currency: "ZAR" as const,
    sourceDirection: enumValue<StatementSourceDirection>(
      input.sourceDirection,
      "sourceDirection",
      ["debit", "credit", "unknown"],
    ),
    sourceFlow,
    balanceEffectMinor,
    locator: locator(input.locator),
    confidence: parsedConfidence,
  };
  return {
    ...normalized,
    sourceChecksum: statementSha256(canonicalStatementJson(normalized)),
    issues,
  };
}

function parseRow(
  value: unknown,
  index: number,
  balanceConvention: StatementBalanceConvention,
): StatementSourceRow {
  const input = object(value, `rows[${index}]`);
  assertAllowedKeys(input, `rows[${index}]`, [
    "rowKey",
    "rowNumber",
    "rowKind",
    "transactionDate",
    "postingDate",
    "valueDate",
    "rawText",
    "sourceReference",
    "reportedBalanceMinor",
    "locator",
    "confidence",
    "components",
  ]);
  const rowKey = string(input.rowKey, "rowKey")!;
  const transactionDate = date(input.transactionDate, "row.transactionDate");
  const postingDate = date(input.postingDate, "row.postingDate");
  const valueDate = date(input.valueDate, "row.valueDate");
  const componentsInput = requiredArray(input.components, "row.components");
  const components = componentsInput.map((component, componentIndex) =>
    parseComponent(
      component,
      rowKey,
      componentIndex,
      balanceConvention,
      transactionDate !== null || postingDate !== null || valueDate !== null,
    ),
  );
  const componentKeys = components.map((component) => component.componentKey);
  if (new Set(componentKeys).size !== componentKeys.length) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      `Row ${rowKey} contains duplicate component keys`,
    );
  }
  const parsedConfidence = confidence(input.confidence, "row.confidence");
  const rowKind = enumValue<StatementSourceRow["rowKind"]>(
    input.rowKind,
    "rowKind",
    ["movement", "informational", "composite", "unresolved"],
  );
  const movementCount = components.filter(
    (component) => component.componentRole === "movement",
  ).length;
  if (
    ((rowKind === "movement" || rowKind === "composite") &&
      movementCount === 0) ||
    (rowKind === "informational" && movementCount > 0)
  ) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "Row kind and movement components are inconsistent",
    );
  }
  const issues: StatementIssue[] = [];
  if (
    parsedConfidence < 0.8 &&
    components.some((component) => component.componentRole === "movement")
  ) {
    issues.push(
      issue(
        "STATEMENT_ROW_LOW_CONFIDENCE",
        "blocking",
        "A monetary row does not have sufficient extraction confidence",
        rowKey,
      ),
    );
  } else if (parsedConfidence < 0.9) {
    issues.push(
      issue(
        "STATEMENT_ROW_LOW_CONFIDENCE",
        "warning",
        "The source row has low confidence",
        rowKey,
      ),
    );
  }
  if (rowKind === "unresolved") {
    issues.push(
      issue(
        "STATEMENT_ROW_UNRESOLVED",
        components.some((component) => component.componentRole === "movement")
          ? "blocking"
          : "warning",
        "The source row is unresolved",
        rowKey,
      ),
    );
  }
  const normalized = {
    rowKey,
    rowNumber: safeInteger(input.rowNumber, "rowNumber")!,
    rowKind,
    transactionDate,
    postingDate,
    valueDate,
    rawText: string(input.rawText, "row.rawText")!,
    sourceReference: string(
      input.sourceReference,
      "row.sourceReference",
      false,
    ),
    reportedBalanceMinor: safeInteger(
      input.reportedBalanceMinor,
      "reportedBalanceMinor",
      true,
    ),
    locator: locator(input.locator),
    confidence: parsedConfidence,
  };
  return {
    ...normalized,
    rowHash: statementSha256(canonicalStatementJson(normalized)),
    components,
    issues,
  };
}

function parseAssist(bundle: StatementSourceBundle): JsonObject {
  if (
    !bundle.extractionAssistBytes ||
    !bundle.descriptor.extractionInputSha256
  ) {
    throw new RavenDomainError(
      "STATEMENT_PROFILE_UNSUPPORTED",
      "This profile requires a separate normalized extraction assistance artifact",
    );
  }
  let parsed: unknown;
  try {
    parsed = JSON.parse(
      Buffer.from(bundle.extractionAssistBytes).toString("utf8"),
    );
  } catch {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "Extraction assistance is not valid JSON",
    );
  }
  assertNoAcceptedMeaning(parsed);
  const input = object(parsed, "extraction assistance");
  assertAllowedKeys(input, "extraction assistance", [
    "contractVersion",
    "profileHint",
    "sourceKind",
    "currency",
    "periodStart",
    "periodEnd",
    "balanceConvention",
    "openingBalanceMinor",
    "closingBalanceMinor",
    "accountHints",
    "coverage",
    "rows",
  ]);
  if (input.contractVersion !== "statement-extraction-input-v0.1") {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "Extraction assistance contract version is unsupported",
    );
  }
  return input;
}

function profileRef(view: StatementProfileView): StatementProfileRef {
  return {
    profileId: view.profileId,
    profileVersion: view.profileVersion,
    extractorVersion: view.extractorVersion,
  };
}

function normalizeExtraction(
  profile: StatementProfileView,
  bundle: StatementSourceBundle,
): NormalizedStatementExtraction {
  const input = parseAssist(bundle);
  const sourceKind = enumValue(input.sourceKind, "sourceKind", [
    "pdf",
    "csv",
    "ofx",
    "qif",
    "image",
  ] as const);
  if (sourceKind !== bundle.descriptor.sourceKind) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "Extraction source kind does not match the staged source evidence",
    );
  }
  const periodStart = date(input.periodStart, "periodStart", true)!;
  const periodEnd = date(input.periodEnd, "periodEnd", true)!;
  if (periodStart > periodEnd) {
    throw new RavenDomainError(
      "STATEMENT_PERIOD_INVALID",
      "Statement period is invalid",
    );
  }
  const currency = string(input.currency, "currency")?.toUpperCase();
  if (currency !== "ZAR") {
    throw new RavenDomainError(
      "UNSUPPORTED_CURRENCY",
      "ST-01 supports ZAR statement sources only",
    );
  }
  const balanceConvention = enumValue<StatementBalanceConvention>(
    input.balanceConvention,
    "balanceConvention",
    ["positive_is_asset", "positive_is_liability"],
  );
  if (
    profile.balanceConventionAuthority !== null &&
    balanceConvention !== profile.balanceConventionAuthority
  ) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "Extraction balance convention does not match the selected profile authority",
    );
  }
  const openingBalanceMinor = safeInteger(
    input.openingBalanceMinor,
    "openingBalanceMinor",
    true,
  );
  const closingBalanceMinor = safeInteger(
    input.closingBalanceMinor,
    "closingBalanceMinor",
    true,
  );
  const closingBalanceEconomicNature: NormalizedStatementExtraction["closingBalanceEconomicNature"] =
    closingBalanceMinor === null
      ? null
      : balanceConvention === "positive_is_asset"
        ? closingBalanceMinor >= 0
          ? "asset"
          : "liability"
        : closingBalanceMinor >= 0
          ? "liability"
          : "asset";
  const rowsInput = requiredArray(input.rows, "rows");
  let rows = rowsInput.map((row, index) =>
    parseRow(row, index, balanceConvention),
  );
  const rowKeys = rows.map((row) => row.rowKey);
  const rowNumbers = rows.map((row) => row.rowNumber);
  if (
    new Set(rowKeys).size !== rowKeys.length ||
    rowNumbers.some((rowNumber, index) => rowNumber !== index + 1)
  ) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "Statement rows must remain in source order with contiguous row numbers 1 through N and unique keys",
    );
  }
  const coverage = parseCoverage(input.coverage, rows.length);
  validateCoverageForSource(sourceKind, coverage);
  for (const row of rows) {
    validateLocatorForSource(row.locator, sourceKind, coverage.sourcePageCount);
    for (const component of row.components) {
      validateLocatorForSource(
        component.locator,
        sourceKind,
        coverage.sourcePageCount,
      );
    }
  }
  const issues: StatementIssue[] = [];
  if (!coverageIsComplete(coverage)) {
    issues.push(
      issue(
        "STATEMENT_PARTIAL_PERIOD",
        "blocking",
        "Extraction coverage is incomplete or cannot prove the full printed monetary period",
      ),
    );
  }
  if (
    rows.length === 0 &&
    (!coverageIsComplete(coverage) ||
      openingBalanceMinor === null ||
      closingBalanceMinor === null ||
      openingBalanceMinor !== closingBalanceMinor)
  ) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "A zero-row statement requires complete coverage and equal exact opening and closing balances",
    );
  }
  let runningBalance = openingBalanceMinor;
  rows = rows.map((row) => {
    const rowEffect = row.components
      .filter((component) => component.componentRole === "movement")
      .reduce(
        (total, component) =>
          checkedAdd(
            total,
            component.balanceEffectMinor,
            `row ${row.rowKey} balance effect`,
          ),
        0,
      );
    runningBalance =
      runningBalance === null
        ? null
        : checkedAdd(
            runningBalance,
            rowEffect,
            `row ${row.rowKey} running balance`,
          );
    if (
      runningBalance !== null &&
      row.reportedBalanceMinor !== null &&
      runningBalance !== row.reportedBalanceMinor
    ) {
      return {
        ...row,
        issues: [
          ...row.issues,
          issue(
            "STATEMENT_BALANCE_DIFFERENCE",
            "blocking",
            "The row movement does not reproduce its printed running balance",
            row.rowKey,
          ),
        ],
      };
    }
    return row;
  });
  if (openingBalanceMinor === null || closingBalanceMinor === null) {
    issues.push(
      issue(
        "STATEMENT_BALANCE_MISSING",
        "warning",
        "The source does not provide both opening and closing balances",
      ),
    );
  }
  const accountHints = object(input.accountHints, "accountHints");
  assertAllowedKeys(accountHints, "accountHints", [
    "maskedAccount",
    "sourceAccountType",
  ]);
  const extractionWithoutHash = {
    contractVersion: STATEMENT_EXTRACTION_CONTRACT_VERSION,
    profile: profileRef(profile),
    institution: profile.institution,
    accountHints: {
      maskedAccount: string(accountHints.maskedAccount, "maskedAccount", false),
      sourceAccountType: string(
        accountHints.sourceAccountType,
        "sourceAccountType",
        false,
      ),
    },
    currency: "ZAR" as const,
    periodStart,
    periodEnd,
    balanceConvention,
    balanceConventionAuthority:
      profile.balanceConventionAuthority === null
        ? ("operator_unverified" as const)
        : ("profile" as const),
    openingBalanceMinor,
    closingBalanceMinor,
    closingBalanceEconomicNature,
    coverage,
    rows,
    issues,
  };
  return {
    ...extractionWithoutHash,
    canonicalExtractionSha256: statementSha256(
      canonicalStatementJson(extractionWithoutHash),
    ),
  };
}

class NeutralJsonAssistedAdapter implements StatementAdapter {
  constructor(readonly profile: StatementProfileView) {}

  async detect(
    bundle: StatementSourceBundle,
  ): Promise<StatementProfileDetection | null> {
    if (!bundle.extractionAssistBytes) return null;
    try {
      const input = parseAssist(bundle);
      const hint =
        typeof input.profileHint === "string" ? input.profileHint : "";
      if (hint === this.profile.profileId) {
        return {
          profile: profileRef(this.profile),
          confidence: 0.99,
          evidenceCodes: [
            "EXTRACTION_ASSIST_PROFILE_HINT",
            "VALID_NEUTRAL_EXTRACTION_INPUT",
          ],
          issues: [],
        };
      }
      if (this.profile.profileId === "normalized-json-v1") {
        return {
          profile: profileRef(this.profile),
          confidence: 0.6,
          evidenceCodes: ["VALID_NEUTRAL_EXTRACTION_INPUT"],
          issues: [],
        };
      }
      return null;
    } catch {
      return null;
    }
  }

  async extract(
    bundle: StatementSourceBundle,
  ): Promise<NormalizedStatementExtraction> {
    if (
      !this.profile.supportedSourceKinds.includes(bundle.descriptor.sourceKind)
    ) {
      throw new RavenDomainError(
        "STATEMENT_PROFILE_UNSUPPORTED",
        "The selected profile does not support this source format",
      );
    }
    const input = parseAssist(bundle);
    const hint =
      typeof input.profileHint === "string" ? input.profileHint : null;
    if (
      this.profile.profileId !== "normalized-json-v1" &&
      hint !== this.profile.profileId
    ) {
      throw new RavenDomainError(
        "STATEMENT_PROFILE_UNSUPPORTED",
        "The extraction assistance does not identify the selected profile",
      );
    }
    return normalizeExtraction(this.profile, bundle);
  }
}

export class DefaultStatementAdapterRegistry implements StatementAdapterRegistry {
  readonly #adapters = PROFILE_DEFINITIONS.map(
    (profile) => new NeutralJsonAssistedAdapter(profile),
  );

  list(): readonly StatementProfileView[] {
    return PROFILE_DEFINITIONS;
  }

  get(
    profileId: StatementProfileRef["profileId"],
    profileVersion: string,
  ): StatementAdapter | null {
    return (
      this.#adapters.find(
        (adapter) =>
          adapter.profile.profileId === profileId &&
          adapter.profile.profileVersion === profileVersion,
      ) ?? null
    );
  }

  async detect(
    bundle: StatementSourceBundle,
  ): Promise<readonly StatementProfileDetection[]> {
    const candidates = (
      await Promise.all(this.#adapters.map((adapter) => adapter.detect(bundle)))
    ).filter(
      (candidate): candidate is StatementProfileDetection => candidate !== null,
    );
    return candidates.sort(
      (left, right) =>
        right.confidence - left.confidence ||
        left.profile.profileId.localeCompare(right.profile.profileId),
    );
  }
}

export function createDefaultStatementAdapterRegistry(): StatementAdapterRegistry {
  return new DefaultStatementAdapterRegistry();
}
