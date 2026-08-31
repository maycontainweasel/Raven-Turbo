import { createHash } from "node:crypto";
import { execFile } from "node:child_process";
import {
  chmod,
  lstat,
  mkdir,
  readFile,
  readdir,
  realpath,
  stat,
  writeFile,
} from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { promisify } from "node:util";

const execFileAsync = promisify(execFile);

export const PROVISIONAL_AUTHORITY = "provisional_source_only" as const;
export const INTAKE_CONTRACT_VERSION =
  "raven.emergency-statement-intake.v1" as const;

export type AccountClass =
  | "business"
  | "personal_current"
  | "personal_credit"
  | "personal_savings"
  | "personal_investment"
  | "unmapped";

export type IntakeIssue = Readonly<{
  code: string;
  severity: "warning" | "blocking";
  blocking: boolean;
  explanation: string;
  rowKey?: string;
}>;

export type SourceOccurrence = Readonly<{
  occurrenceKey: string;
  fingerprint: string;
  byteSize: number;
  mimeType: string;
  sourceKind: "pdf" | "csv" | "ofx" | "qif" | "image" | "compatibility_only";
  relativePrivateLocator: string;
  accountClass: AccountClass;
  pageCount: number | null;
  duplicateGroup: string;
  canonicalOccurrence: boolean;
  compatibilityOnly: boolean;
  authority: typeof PROVISIONAL_AUTHORITY;
}>;

export type SourceInventory = Readonly<{
  contractVersion: typeof INTAKE_CONTRACT_VERSION;
  authority: typeof PROVISIONAL_AUTHORITY;
  generatedAt: string;
  sourceRootRef: "configured_statement_source_root";
  occurrences: readonly SourceOccurrence[];
}>;

export type SourceLocator = Readonly<{ page: number; line: number }>;

export type AssistanceComponent = Readonly<{
  componentKey: string;
  componentKind:
    | "principal"
    | "bank_fee"
    | "vat"
    | "interest"
    | "adjustment"
    | "unknown";
  componentRole: "movement" | "informational_breakdown";
  transactionDate: string | null;
  postingDate: string | null;
  valueDate: string | null;
  description: string;
  sourceReference: string | null;
  amountMinor: number;
  currency: "ZAR";
  sourceDirection: "debit" | "credit" | "unknown";
  sourceFlow: "inflow" | "outflow" | "unknown";
  balanceEffectMinor: number;
  locator: SourceLocator;
  confidence: number;
}>;

export type AssistanceRow = Readonly<{
  rowKey: string;
  rowNumber: number;
  rowKind: "movement" | "informational" | "composite" | "unresolved";
  transactionDate: string | null;
  postingDate: string | null;
  valueDate: string | null;
  rawText: string;
  sourceReference: string | null;
  reportedBalanceMinor: number | null;
  locator: SourceLocator;
  confidence: number;
  components: readonly AssistanceComponent[];
}>;

export type ExtractionAssistance = Readonly<{
  contractVersion: "statement-extraction-input-v0.1";
  profileHint:
    | "nedbank-current"
    | "nedbank-savings"
    | "nedbank-credit"
    | "fnb-business"
    | "normalized-json-v1";
  sourceKind: "pdf";
  currency: "ZAR";
  periodStart: string;
  periodEnd: string;
  balanceConvention: "positive_is_asset" | "positive_is_liability";
  openingBalanceMinor: number | null;
  closingBalanceMinor: number | null;
  accountHints: Readonly<{
    maskedAccount: string | null;
    sourceAccountType: string | null;
  }>;
  coverage: Readonly<{
    status: "complete" | "incomplete" | "indeterminate";
    sourcePageCount: number;
    processedPages: readonly number[];
    sourceSections: readonly string[];
    processedSections: readonly string[];
    printedRowCount: number;
  }>;
  rows: readonly AssistanceRow[];
}>;

export type ExtractionResult = Readonly<{
  assistance: ExtractionAssistance | null;
  issues: readonly IntakeIssue[];
  sourceDocumentClass:
    | "bank_statement"
    | "accountant_compilation"
    | "unsupported";
}>;

type LocatedLine = Readonly<{ text: string; page: number; line: number }>;

function sha256(bytes: Uint8Array | string): string {
  return createHash("sha256").update(bytes).digest("hex");
}

function canonicalJson(value: unknown): string {
  if (Array.isArray(value)) return `[${value.map(canonicalJson).join(",")}]`;
  if (value && typeof value === "object") {
    return `{${Object.entries(value as Record<string, unknown>)
      .filter(([, nested]) => nested !== undefined)
      .sort(([left], [right]) => left.localeCompare(right))
      .map(([key, nested]) => `${JSON.stringify(key)}:${canonicalJson(nested)}`)
      .join(",")}}`;
  }
  return JSON.stringify(value);
}

export function deterministicJson(value: unknown): string {
  return `${canonicalJson(value)}\n`;
}

function pathContained(root: string, candidate: string): boolean {
  const relative = path.relative(root, candidate);
  return (
    relative === "" ||
    (!relative.startsWith(`..${path.sep}`) &&
      relative !== ".." &&
      !path.isAbsolute(relative))
  );
}

async function assertDirectoryNoSymlink(directory: string): Promise<void> {
  const details = await lstat(directory);
  if (details.isSymbolicLink() || !details.isDirectory()) {
    throw new Error("INTAKE_DIRECTORY_INVALID");
  }
}

export async function preparePrivateRunRoot(input: {
  repositoryRoot: string;
  privateRunRoot: string;
}): Promise<void> {
  const repositoryRoot = await realpath(input.repositoryRoot);
  const privateRunRoot = path.resolve(input.privateRunRoot);
  if (pathContained(repositoryRoot, privateRunRoot)) {
    throw new Error("PRIVATE_ROOT_INSIDE_REPOSITORY");
  }
  const home = await realpath(os.homedir());
  if (!pathContained(home, privateRunRoot)) {
    throw new Error("PRIVATE_ROOT_OUTSIDE_OWNER_HOME");
  }
  await mkdir(privateRunRoot, { recursive: true, mode: 0o700 });
  await chmod(privateRunRoot, 0o700);
  await assertDirectoryNoSymlink(privateRunRoot);
  const details = await stat(privateRunRoot);
  if (
    (typeof process.getuid === "function" &&
      details.uid !== process.getuid()) ||
    (details.mode & 0o077) !== 0
  ) {
    throw new Error("PRIVATE_ROOT_NOT_OWNER_ONLY");
  }
  for (const child of [
    "assistance",
    "index",
    "issues",
    "previews",
    "reports",
    "state",
    "vault",
  ]) {
    const target = path.join(privateRunRoot, child);
    await mkdir(target, { recursive: true, mode: 0o700 });
    await chmod(target, 0o700);
    await assertDirectoryNoSymlink(target);
  }
}

function accountClassFor(relativeLocator: string): AccountClass {
  const parts = relativeLocator.toLowerCase().split("/");
  if (parts[0] === "business") return "business";
  if (parts[0] !== "personal") return "unmapped";
  if (parts[1] === "current") return "personal_current";
  if (parts[1] === "credit") return "personal_credit";
  if (parts[1] === "savings") return "personal_savings";
  if (parts[1] === "investment") return "personal_investment";
  return "unmapped";
}

function ignoredName(name: string): boolean {
  return (
    name === ".DS_Store" ||
    name === "__MACOSX" ||
    name.startsWith("._") ||
    name.endsWith("~") ||
    name.endsWith(".tmp")
  );
}

async function walkFiles(root: string, current = root): Promise<string[]> {
  const output: string[] = [];
  for (const entry of await readdir(current, { withFileTypes: true })) {
    if (ignoredName(entry.name)) continue;
    const target = path.join(current, entry.name);
    if (entry.isSymbolicLink()) continue;
    if (entry.isDirectory()) output.push(...(await walkFiles(root, target)));
    else if (entry.isFile()) output.push(target);
  }
  return output;
}

function sourceKindFor(
  extension: string,
): SourceOccurrence["sourceKind"] | null {
  if (extension === ".pdf") return "pdf";
  if (extension === ".csv") return "csv";
  if (extension === ".ofx") return "ofx";
  if (extension === ".qif") return "qif";
  if ([".png", ".jpg", ".jpeg", ".tif", ".tiff"].includes(extension))
    return "image";
  if ([".md", ".surql"].includes(extension)) return "compatibility_only";
  return null;
}

async function pdfPageCount(sourcePath: string): Promise<number | null> {
  try {
    const { stdout } = await execFileAsync("pdfinfo", [sourcePath], {
      encoding: "utf8",
      maxBuffer: 1024 * 1024,
    });
    const match = stdout.match(/^Pages:\s+(\d+)\s*$/m);
    return match ? Number(match[1]) : null;
  } catch {
    return null;
  }
}

export async function buildSourceInventory(input: {
  sourceRoot: string;
  generatedAt?: string;
}): Promise<SourceInventory> {
  const sourceRoot = await realpath(input.sourceRoot);
  await assertDirectoryNoSymlink(sourceRoot);
  const pending: Array<
    Omit<SourceOccurrence, "duplicateGroup" | "canonicalOccurrence">
  > = [];
  for (const sourcePath of (await walkFiles(sourceRoot)).sort()) {
    const direct = await lstat(sourcePath);
    if (direct.isSymbolicLink() || !direct.isFile()) continue;
    const extension = path.extname(sourcePath).toLowerCase();
    const sourceKind = sourceKindFor(extension);
    if (!sourceKind) continue;
    const bytes = await readFile(sourcePath);
    const fingerprint = sha256(bytes);
    const relativePrivateLocator = path
      .relative(sourceRoot, sourcePath)
      .split(path.sep)
      .join("/");
    pending.push({
      occurrenceKey: sha256(`${relativePrivateLocator}\0${fingerprint}`),
      fingerprint,
      byteSize: bytes.byteLength,
      mimeType:
        sourceKind === "pdf"
          ? bytes.subarray(0, 5).toString("ascii") === "%PDF-"
            ? "application/pdf"
            : "application/octet-stream"
          : sourceKind === "compatibility_only"
            ? "text/plain"
            : "application/octet-stream",
      sourceKind,
      relativePrivateLocator,
      accountClass: accountClassFor(relativePrivateLocator),
      pageCount: sourceKind === "pdf" ? await pdfPageCount(sourcePath) : null,
      compatibilityOnly: sourceKind === "compatibility_only",
      authority: PROVISIONAL_AUTHORITY,
    });
  }
  const byFingerprint = new Map<string, typeof pending>();
  for (const item of pending) {
    const group = byFingerprint.get(item.fingerprint) ?? [];
    group.push(item);
    byFingerprint.set(item.fingerprint, group);
  }
  const occurrences = [...byFingerprint.entries()]
    .sort(([left], [right]) => left.localeCompare(right))
    .flatMap(([fingerprint, group]) =>
      [...group]
        .sort((left, right) =>
          left.relativePrivateLocator.localeCompare(
            right.relativePrivateLocator,
          ),
        )
        .map((item, index) => ({
          ...item,
          duplicateGroup: `dup-${fingerprint.slice(0, 16)}`,
          canonicalOccurrence: index === 0,
        })),
    );
  return {
    contractVersion: INTAKE_CONTRACT_VERSION,
    authority: PROVISIONAL_AUTHORITY,
    generatedAt: input.generatedAt ?? new Date().toISOString(),
    sourceRootRef: "configured_statement_source_root",
    occurrences,
  };
}

export async function writePrivateJson(
  target: string,
  value: unknown,
): Promise<void> {
  await writeFile(target, deterministicJson(value), {
    encoding: "utf8",
    mode: 0o600,
  });
  await chmod(target, 0o600);
}

export async function writePrivateNdjson(
  target: string,
  values: readonly unknown[],
): Promise<void> {
  const content = values.map((value) => canonicalJson(value)).join("\n");
  await writeFile(target, content ? `${content}\n` : "", {
    encoding: "utf8",
    mode: 0o600,
  });
  await chmod(target, 0o600);
}

export async function readPdfLayout(sourcePath: string): Promise<string> {
  try {
    const { stdout } = await execFileAsync(
      "pdftotext",
      ["-layout", sourcePath, "-"],
      { encoding: "utf8", maxBuffer: 30 * 1024 * 1024 },
    );
    return stdout;
  } catch {
    throw new Error("PDF_TEXT_EXTRACTION_FAILED");
  }
}

function locatedLines(text: string): LocatedLine[] {
  return text.split("\f").flatMap((pageText, pageIndex) =>
    pageText.split(/\r?\n/).map((lineText, lineIndex) => ({
      text: lineText,
      page: pageIndex + 1,
      line: lineIndex + 1,
    })),
  );
}

function exactMinor(raw: string): number {
  const normalized = raw
    .trim()
    .replace(/^([+-]?)R\s*/i, "$1")
    .replace(/\s+(Cr|Dr)$/i, "")
    .replace(/,/g, "")
    .replace(/\s/g, "");
  const match = /^([+-]?)(\d+)(?:\.(\d{1,2}))?$/.exec(normalized);
  if (!match) throw new Error("INVALID_EXACT_MONEY");
  const magnitude =
    BigInt(match[2]!) * 100n + BigInt((match[3] ?? "").padEnd(2, "0"));
  const signed = match[1] === "-" ? -magnitude : magnitude;
  if (
    signed > BigInt(Number.MAX_SAFE_INTEGER) ||
    signed < BigInt(Number.MIN_SAFE_INTEGER)
  ) {
    throw new Error("UNSAFE_EXACT_MONEY");
  }
  return Number(signed);
}

function checkedMinorAdd(left: number, right: number): number {
  const value = left + right;
  if (!Number.isSafeInteger(value)) throw new Error("UNSAFE_EXACT_MONEY");
  return value;
}

function signedBalance(raw: string, bareMeansDebit = false): number {
  const amount = Math.abs(exactMinor(raw));
  if (/\bCr\s*$/i.test(raw)) return amount;
  if (/\bDr\s*$/i.test(raw) || /^\s*-/.test(raw) || bareMeansDebit)
    return -amount;
  return amount;
}

const MONTHS: Readonly<Record<string, number>> = {
  jan: 1,
  january: 1,
  feb: 2,
  february: 2,
  mar: 3,
  march: 3,
  apr: 4,
  april: 4,
  may: 5,
  jun: 6,
  june: 6,
  jul: 7,
  july: 7,
  aug: 8,
  august: 8,
  sep: 9,
  september: 9,
  oct: 10,
  october: 10,
  nov: 11,
  november: 11,
  dec: 12,
  december: 12,
};

function isoDate(day: number, month: number, year: number): string {
  const result = `${year}-${String(month).padStart(2, "0")}-${String(day).padStart(2, "0")}`;
  const parsed = new Date(`${result}T00:00:00.000Z`);
  if (
    parsed.getUTCFullYear() !== year ||
    parsed.getUTCMonth() + 1 !== month ||
    parsed.getUTCDate() !== day
  ) {
    throw new Error("INVALID_SOURCE_DATE");
  }
  return result;
}

function parsePrintedDate(raw: string): string | null {
  const dmy = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/.exec(raw.trim());
  if (dmy) return isoDate(Number(dmy[1]), Number(dmy[2]), Number(dmy[3]));
  const long = /^(\d{1,2})\s+([A-Za-z]+)\s+(\d{4})$/.exec(raw.trim());
  if (!long) return null;
  const month = MONTHS[long[2]!.toLowerCase()];
  return month ? isoDate(Number(long[1]), month, Number(long[3])) : null;
}

function parsePeriod(text: string): { start: string; end: string } | null {
  const match = text.match(
    /Statement\s+(?:Period|period)\s*:\s*(\d{1,2}(?:\/\d{1,2}\/\d{4}|\s+[A-Za-z]+\s+\d{4}))\s+(?:to|[-–])\s+(\d{1,2}(?:\/\d{1,2}\/\d{4}|\s+[A-Za-z]+\s+\d{4}))/i,
  );
  if (!match) return null;
  const start = parsePrintedDate(match[1]!);
  const end = parsePrintedDate(match[2]!);
  return start && end ? { start, end } : null;
}

function dateWithinPeriod(
  shortDate: string,
  period: { start: string; end: string },
): string | null {
  const match = /^(\d{1,2})\s+([A-Za-z]+)$/.exec(shortDate.trim());
  if (!match) return null;
  const month = MONTHS[match[2]!.toLowerCase()];
  if (!month) return null;
  const years = [
    Number(period.start.slice(0, 4)),
    Number(period.end.slice(0, 4)),
  ];
  for (const year of [...new Set(years)]) {
    const candidate = isoDate(Number(match[1]), month, year);
    if (candidate >= period.start && candidate <= period.end) return candidate;
  }
  return null;
}

function issue(code: string, explanation: string): IntakeIssue {
  return { code, severity: "blocking", blocking: true, explanation };
}

function maskedAccountHint(text: string): string | null {
  const candidates = [
    /Account\s+(?:number|no\.?|#)\s*:?\s*([*Xx\d][*Xx\d \t-]{3,24})/i,
    /Account\s*:?\s*([*Xx\d][*Xx\d \t-]{3,24})/i,
  ];
  for (const candidate of candidates) {
    const match = text.match(candidate);
    if (match) return match[1]!.trim();
  }
  return null;
}

function openingClosing(
  text: string,
  convention: "positive_is_asset" | "positive_is_liability",
): { opening: number | null; closing: number | null } {
  const opening = text.match(
    /(?:Opening balance|Previous balance)\s+(?:[A-Za-z\s-]+\s+)?((?:-?R\s*)?[\d,]+\.\d{2}(?:\s+(?:Cr|Dr))?)/i,
  );
  const closing = text.match(
    /(?:Closing balance|Statement balance)\s+(?:[A-Za-z\s-]+\s+)?((?:-?R\s*)?[\d,]+\.\d{2}(?:\s+(?:Cr|Dr))?)/i,
  );
  const parse = (raw: string | undefined) => {
    if (!raw) return null;
    if (/\b(?:Cr|Dr)\s*$/i.test(raw) || /^\s*-/.test(raw))
      return signedBalance(raw);
    return convention === "positive_is_liability"
      ? Math.abs(exactMinor(raw))
      : Math.abs(exactMinor(raw));
  };
  return { opening: parse(opening?.[1]), closing: parse(closing?.[1]) };
}

function component(input: {
  key: string;
  kind: AssistanceComponent["componentKind"];
  role?: AssistanceComponent["componentRole"];
  date: string;
  description: string;
  amountMinor: number;
  effectMinor: number;
  direction: AssistanceComponent["sourceDirection"];
  flow: AssistanceComponent["sourceFlow"];
  locator: SourceLocator;
  confidence?: number;
}): AssistanceComponent {
  return {
    componentKey: input.key,
    componentKind: input.kind,
    componentRole: input.role ?? "movement",
    transactionDate: input.date,
    postingDate: null,
    valueDate: null,
    description: input.description,
    sourceReference: null,
    amountMinor: input.amountMinor,
    currency: "ZAR",
    sourceDirection: input.direction,
    sourceFlow: input.flow,
    balanceEffectMinor: input.effectMinor,
    locator: input.locator,
    confidence: input.confidence ?? 1,
  };
}

function assistance(input: {
  profileHint: ExtractionAssistance["profileHint"];
  period: { start: string; end: string };
  convention: ExtractionAssistance["balanceConvention"];
  opening: number | null;
  closing: number | null;
  pageCount: number;
  rows: readonly AssistanceRow[];
  complete: boolean;
  accountHint: string | null;
  sourceAccountType: string;
}): ExtractionAssistance {
  return {
    contractVersion: "statement-extraction-input-v0.1",
    profileHint: input.profileHint,
    sourceKind: "pdf",
    currency: "ZAR",
    periodStart: input.period.start,
    periodEnd: input.period.end,
    balanceConvention: input.convention,
    openingBalanceMinor: input.opening,
    closingBalanceMinor: input.closing,
    accountHints: {
      maskedAccount: input.accountHint,
      sourceAccountType: input.sourceAccountType,
    },
    coverage: {
      status: input.complete ? "complete" : "incomplete",
      sourcePageCount: input.pageCount,
      processedPages: Array.from(
        { length: input.pageCount },
        (_, index) => index + 1,
      ),
      sourceSections: ["transactions"],
      processedSections: ["transactions"],
      printedRowCount: input.rows.length,
    },
    rows: input.rows,
  };
}

function parseFnbBusiness(text: string, pageCount: number): ExtractionResult {
  const period = parsePeriod(text);
  if (!period)
    return {
      assistance: null,
      issues: [
        issue("INTAKE_PERIOD_UNRESOLVED", "Statement period was not extracted"),
      ],
      sourceDocumentClass: "unsupported",
    };
  const lines = locatedLines(text);
  const rows: AssistanceRow[] = [];
  let dateLines = 0;
  let previousBalance: number | null = null;
  const balances = openingClosing(text, "positive_is_asset");
  previousBalance = balances.opening;
  const issues: IntakeIssue[] = [];
  for (const located of lines) {
    const trimmed = located.text.trim();
    if (/^\d{2}\s+[A-Z][a-z]{2}\s+/.test(trimmed)) dateLines += 1;
    const dateMatch = trimmed.match(/^(\d{2}\s+[A-Z][a-z]{2})\s+/);
    if (!dateMatch) continue;
    const segments = trimmed
      .slice(dateMatch[1]!.length)
      .trim()
      .split(/\s{2,}/)
      .filter(Boolean);
    const isMoney = (value: string | undefined): value is string =>
      Boolean(value && /^[\d,]+\.\d{2}(?:\s+Cr)?$/i.test(value));
    const hasPrintedCharge =
      segments.length >= 3 && segments.slice(-3).every(isMoney);
    const monetaryColumnCount = hasPrintedCharge ? 3 : 2;
    const monetaryColumns = segments.slice(-monetaryColumnCount);
    const amountToken = monetaryColumns[0];
    const balanceToken = monetaryColumns[1];
    const chargeToken = hasPrintedCharge ? monetaryColumns[2] : undefined;
    if (!isMoney(amountToken) || !isMoney(balanceToken)) continue;
    const rowDate = dateWithinPeriod(dateMatch[1]!, period);
    if (!rowDate) {
      issues.push(
        issue("INTAKE_DATE_UNRESOLVED", "A printed row date is ambiguous"),
      );
      continue;
    }
    const description =
      segments.slice(0, -monetaryColumnCount).join(" ").trim() || trimmed;
    const amountMinor = Math.abs(exactMinor(amountToken));
    const inflow = /\bCr\s*$/i.test(amountToken);
    const principalEffect =
      amountMinor === 0 ? 0 : inflow ? amountMinor : -amountMinor;
    const reportedBalance = signedBalance(
      balanceToken,
      !/\bCr\s*$/i.test(balanceToken),
    );
    const locator = { page: located.page, line: located.line };
    const components: AssistanceComponent[] = [];
    if (amountMinor > 0) {
      components.push(component({
        key: "principal",
        kind: "principal",
        date: rowDate,
        description,
        amountMinor,
        effectMinor: principalEffect,
        direction: inflow ? "credit" : "debit",
        flow: inflow ? "inflow" : "outflow",
        locator,
      }));
    }
    const printedCharge = chargeToken ? Math.abs(exactMinor(chargeToken)) : null;
    if (printedCharge) {
      const principalMatches =
        previousBalance === null ||
        previousBalance + principalEffect === reportedBalance;
      const chargeIsMovement =
        previousBalance !== null &&
        previousBalance + principalEffect - printedCharge === reportedBalance;
      components.push(
        component({
          key: "printed-bank-charge",
          kind: "bank_fee",
          role: chargeIsMovement ? "movement" : "informational_breakdown",
          date: rowDate,
          description,
          amountMinor: printedCharge,
          effectMinor: chargeIsMovement ? -printedCharge : 0,
          direction: "debit",
          flow: chargeIsMovement ? "outflow" : "unknown",
          locator,
          confidence: chargeIsMovement || principalMatches ? 1 : 0.5,
        }),
      );
      if (!chargeIsMovement && !principalMatches) {
        issues.push(
          issue(
            "INTAKE_RUNNING_BALANCE_MISMATCH",
            "Printed row values do not reproduce the reported balance",
          ),
        );
      }
    } else if (
      previousBalance !== null &&
      previousBalance + principalEffect !== reportedBalance
    ) {
      issues.push(
        issue(
          "INTAKE_RUNNING_BALANCE_MISMATCH",
          "Printed row values do not reproduce the reported balance",
        ),
      );
    }
    const movementCount = components.filter(
      (item) => item.componentRole === "movement",
    ).length;
    const informationalRow =
      movementCount === 0 &&
      previousBalance !== null &&
      previousBalance === reportedBalance;
    if (components.length === 0 && !informationalRow) {
      issues.push(
        issue(
          "INTAKE_COMPONENT_UNRESOLVED",
          "A dated row has no exact printed monetary component",
        ),
      );
    }
    rows.push({
      rowKey: `row-${String(rows.length + 1).padStart(4, "0")}`,
      rowNumber: rows.length + 1,
      rowKind:
        movementCount > 0
          ? components.length > 1
            ? "composite"
            : "movement"
          : informationalRow
            ? "informational"
            : "unresolved",
      transactionDate: rowDate,
      postingDate: null,
      valueDate: null,
      rawText: trimmed,
      sourceReference: null,
      reportedBalanceMinor: reportedBalance,
      locator,
      confidence: components.length > 0 || informationalRow ? 1 : 0.5,
      components,
    });
    previousBalance = reportedBalance;
  }
  const complete =
    rows.length > 0 &&
    rows.length === dateLines &&
    balances.opening !== null &&
    balances.closing !== null &&
    issues.length === 0;
  if (!complete)
    issues.push(
      issue(
        "INTAKE_SOURCE_INCOMPLETE",
        "Full monetary row and balance coverage was not proved",
      ),
    );
  return {
    assistance: assistance({
      profileHint: "fnb-business",
      period,
      convention: "positive_is_asset",
      opening: balances.opening,
      closing: balances.closing,
      pageCount,
      rows,
      complete,
      accountHint: maskedAccountHint(text),
      sourceAccountType: "business current",
    }),
    issues,
    sourceDocumentClass: "bank_statement",
  };
}

function parseNedbankAsset(
  text: string,
  pageCount: number,
  accountClass: "personal_current" | "personal_savings",
): ExtractionResult {
  const period = parsePeriod(text);
  if (!period) {
    if (/annual financial statements|annual financial report/i.test(text)) {
      return {
        assistance: null,
        issues: [],
        sourceDocumentClass: "accountant_compilation",
      };
    }
    return {
      assistance: null,
      issues: [
        issue("INTAKE_PERIOD_UNRESOLVED", "Statement period was not extracted"),
      ],
      sourceDocumentClass: "unsupported",
    };
  }
  const rows: AssistanceRow[] = [];
  const issues: IntakeIssue[] = [];
  const lines = locatedLines(text);
  const balances = openingClosing(text, "positive_is_asset");
  let previousBalance = balances.opening;
  let dateLines = 0;
  let feeColumn: number | null = null;
  let debitColumn: number | null = null;
  let creditColumn: number | null = null;
  let balanceColumn: number | null = null;
  for (const located of lines) {
    const headerFee = located.text.search(/\bFees?\b/i);
    const headerDebit = located.text.search(/\bDebits?\b/i);
    const headerCredit = located.text.search(/\bCredits?\b/i);
    const headerBalance = located.text.search(/\bBalance\b/i);
    if (
      headerFee >= 0 &&
      headerDebit > headerFee &&
      headerCredit > headerDebit &&
      headerBalance > headerCredit
    ) {
      feeColumn = headerFee;
      debitColumn = headerDebit;
      creditColumn = headerCredit;
      balanceColumn = headerBalance;
      continue;
    }
    const prefix = located.text.match(
      /^\s*(?:(\d{6})\s+)?(\d{2}\/\d{2}\/\d{4})\s+/,
    );
    if (!prefix) continue;
    dateLines += 1;
    const date = parsePrintedDate(prefix[2]!);
    if (!date) continue;
    const money = [...located.text.matchAll(/-?[\d,]+\.\d{2}/g)];
    if (money.length === 0 || balanceColumn === null) continue;
    const balanceToken = money.at(-1)!;
    const description = located.text
      .slice(prefix[0].length, balanceToken.index)
      .replace(/-?[\d,]+\.\d{2}[*]?/g, " ")
      .trim();
    const reportedBalanceMinor = signedBalance(balanceToken[0]);
    let feeMinor = 0;
    let debitMinor = 0;
    let creditMinor = 0;
    if (feeColumn !== null && debitColumn !== null && creditColumn !== null) {
      const feeDebitBoundary = (feeColumn + debitColumn) / 2;
      const debitCreditBoundary = (debitColumn + creditColumn) / 2;
      const creditBalanceBoundary = (creditColumn + balanceColumn) / 2;
      for (const token of money.slice(0, -1)) {
        const amount = Math.abs(exactMinor(token[0]));
        const column = token.index;
        if (column < feeDebitBoundary)
          feeMinor = checkedMinorAdd(feeMinor, amount);
        else if (column < debitCreditBoundary)
          debitMinor = checkedMinorAdd(debitMinor, amount);
        else if (column < creditBalanceBoundary)
          creditMinor = checkedMinorAdd(creditMinor, amount);
        else
          issues.push(
            issue(
              "INTAKE_DIRECTION_UNRESOLVED",
              "A printed value is not contained by the statement columns",
            ),
          );
      }
    } else {
      issues.push(
        issue(
          "INTAKE_DIRECTION_UNRESOLVED",
          "Printed fee, debit, credit and balance columns are unavailable",
        ),
      );
    }
    if (/^opening balance$/i.test(description)) {
      previousBalance = reportedBalanceMinor;
      dateLines -= 1;
      continue;
    }
    const locator = { page: located.page, line: located.line };
    const components: AssistanceComponent[] = [];
    if (debitMinor > 0) {
      components.push(
        component({
          key: "principal",
          kind: "principal",
          date,
          description,
          amountMinor: debitMinor,
          effectMinor: -debitMinor,
          direction: "debit",
          flow: "outflow",
          locator,
        }),
      );
    }
    if (creditMinor > 0) {
      components.push(
        component({
          key: "principal-credit",
          kind: "principal",
          date,
          description,
          amountMinor: creditMinor,
          effectMinor: creditMinor,
          direction: "credit",
          flow: "inflow",
          locator,
        }),
      );
    }
    const principalEffect = creditMinor - debitMinor;
    const withFeeEffect = principalEffect - feeMinor;
    const feeIsMovement =
      feeMinor > 0 &&
      previousBalance !== null &&
      previousBalance + withFeeEffect === reportedBalanceMinor;
    const feeInformational =
      feeMinor > 0 &&
      previousBalance !== null &&
      previousBalance + principalEffect === reportedBalanceMinor;
    if (feeMinor > 0) {
      components.push(
        component({
          key: "printed-bank-charge",
          kind: "bank_fee",
          role: feeIsMovement ? "movement" : "informational_breakdown",
          date,
          description,
          amountMinor: feeMinor,
          effectMinor: feeIsMovement ? -feeMinor : 0,
          direction: "debit",
          flow: feeIsMovement ? "outflow" : "unknown",
          locator,
          confidence: feeIsMovement || feeInformational ? 1 : 0.5,
        }),
      );
    }
    const totalEffect = components.reduce(
      (sum, item) => sum + item.balanceEffectMinor,
      0,
    );
    const movementCount = components.filter(
      (item) => item.componentRole === "movement",
    ).length;
    const informationalRow =
      movementCount === 0 &&
      totalEffect === 0 &&
      previousBalance !== null &&
      previousBalance === reportedBalanceMinor;
    if (
      previousBalance !== null &&
      previousBalance + totalEffect !== reportedBalanceMinor
    ) {
      issues.push(
        issue(
          "INTAKE_RUNNING_BALANCE_MISMATCH",
          "Printed row values do not reproduce the reported balance",
        ),
      );
    }
    if (components.length === 0 && !informationalRow) {
      issues.push(
        issue(
          "INTAKE_COMPONENT_UNRESOLVED",
          "A dated row has no exact printed monetary component",
        ),
      );
    }
    rows.push({
      rowKey: `row-${String(rows.length + 1).padStart(4, "0")}`,
      rowNumber: rows.length + 1,
      rowKind:
        movementCount > 0
          ? components.length > 1
            ? "composite"
            : "movement"
          : informationalRow
            ? "informational"
            : "unresolved",
      transactionDate: date,
      postingDate: null,
      valueDate: null,
      rawText: located.text.trim(),
      sourceReference: prefix[1] ?? null,
      reportedBalanceMinor,
      locator,
      confidence: components.length > 0 || informationalRow ? 1 : 0.5,
      components,
    });
    previousBalance = reportedBalanceMinor;
  }
  const complete =
    rows.length > 0 &&
    rows.length === dateLines &&
    balances.opening !== null &&
    balances.closing !== null &&
    issues.length === 0;
  if (!complete)
    issues.push(
      issue(
        "INTAKE_SOURCE_INCOMPLETE",
        "Full monetary row and balance coverage was not proved",
      ),
    );
  return {
    assistance: assistance({
      profileHint:
        accountClass === "personal_current"
          ? "nedbank-current"
          : "nedbank-savings",
      period,
      convention: "positive_is_asset",
      opening: balances.opening,
      closing: balances.closing,
      pageCount,
      rows,
      complete,
      accountHint: maskedAccountHint(text),
      sourceAccountType:
        accountClass === "personal_current"
          ? "personal current"
          : "personal savings",
    }),
    issues,
    sourceDocumentClass: "bank_statement",
  };
}

function parseNedbankCredit(text: string, pageCount: number): ExtractionResult {
  const period = parsePeriod(text);
  if (!period)
    return {
      assistance: null,
      issues: [
        issue("INTAKE_PERIOD_UNRESOLVED", "Statement period was not extracted"),
      ],
      sourceDocumentClass: "unsupported",
    };
  const balances = openingClosing(text, "positive_is_liability");
  const lines = locatedLines(text);
  const rows: AssistanceRow[] = [];
  const issues: IntakeIssue[] = [];
  let dateLines = 0;
  let section = "";
  let debitColumn: number | null = null;
  let creditColumn: number | null = null;
  for (const located of lines) {
    if (/Account transaction details/i.test(located.text)) section = "account";
    if (/Card transaction details/i.test(located.text)) section = "card";
    if (/Interest rates and facility details/i.test(located.text)) section = "";
    if (!section) continue;
    const headerDebit = located.text.search(/\bDebits?\b/i);
    const headerCredit = located.text.search(/\bCredits?\b/i);
    if (headerDebit >= 0 && headerCredit > headerDebit) {
      debitColumn = headerDebit;
      creditColumn = headerCredit;
      continue;
    }
    if (/^\s*\d{2}\/\d{2}\/\d{4}\s+/.test(located.text)) dateLines += 1;
    const match = located.text.match(
      /^\s*(\d{2}\/\d{2}\/\d{4})\s+(?:(\d{20,})\s+)?(.+?)\s{2,}(R[\d,]+\.\d{2})(?:\s{2,}(R[\d,]+\.\d{2}))?\s*$/,
    );
    if (!match || /Description\s+/i.test(located.text)) continue;
    const date = parsePrintedDate(match[1]!);
    if (!date) continue;
    const description = match[3]!.trim();
    const first = Math.abs(exactMinor(match[4]!));
    const second = match[5] ? Math.abs(exactMinor(match[5])) : 0;
    const firstColumn = located.text.lastIndexOf(match[4]!);
    const secondColumn = match[5] ? located.text.lastIndexOf(match[5]!) : -1;
    const columnBoundary =
      debitColumn !== null && creditColumn !== null
        ? (debitColumn + creditColumn) / 2
        : null;
    const firstIsCredit =
      columnBoundary !== null && firstColumn >= columnBoundary;
    const secondIsCredit =
      columnBoundary !== null && secondColumn >= columnBoundary;
    const debitMinor =
      (firstIsCredit ? 0 : first) +
      (second > 0 && !secondIsCredit ? second : 0);
    const creditMinor =
      (firstIsCredit ? first : 0) + (second > 0 && secondIsCredit ? second : 0);
    const locator = { page: located.page, line: located.line };
    const components: AssistanceComponent[] = [];
    if (
      columnBoundary === null ||
      (second > 0 && firstIsCredit === secondIsCredit)
    ) {
      issues.push(
        issue(
          "INTAKE_DIRECTION_UNRESOLVED",
          "Printed debit and credit column structure is unavailable or ambiguous",
        ),
      );
    }
    if (debitMinor > 0)
      components.push(
        component({
          key: "principal",
          kind: /fee|charge|interest|vat/i.test(description)
            ? "bank_fee"
            : "principal",
          date,
          description,
          amountMinor: debitMinor,
          effectMinor: debitMinor,
          direction: "debit",
          flow: "outflow",
          locator,
        }),
      );
    if (creditMinor > 0)
      components.push(
        component({
          key: "principal-credit",
          kind: "principal",
          date,
          description,
          amountMinor: creditMinor,
          effectMinor: -creditMinor,
          direction: "credit",
          flow: "inflow",
          locator,
        }),
      );
    rows.push({
      rowKey: `row-${String(rows.length + 1).padStart(4, "0")}`,
      rowNumber: rows.length + 1,
      rowKind: components.length > 1 ? "composite" : "movement",
      transactionDate: date,
      postingDate: null,
      valueDate: null,
      rawText: located.text.trim(),
      sourceReference: match[2] ?? null,
      reportedBalanceMinor: null,
      locator,
      confidence: 0.9,
      components,
    });
  }
  const movementEffect = rows
    .flatMap((row) => row.components)
    .reduce((sum, item) => sum + item.balanceEffectMinor, 0);
  if (
    balances.opening !== null &&
    balances.closing !== null &&
    balances.opening + movementEffect !== balances.closing
  ) {
    issues.push(
      issue(
        "INTAKE_STATEMENT_EQUATION_MISMATCH",
        "Printed movements do not reproduce the reported closing balance",
      ),
    );
  }
  const complete =
    rows.length > 0 &&
    rows.length === dateLines &&
    balances.opening !== null &&
    balances.closing !== null &&
    issues.length === 0;
  if (!complete)
    issues.push(
      issue(
        "INTAKE_SOURCE_INCOMPLETE",
        "Full monetary row and balance coverage was not proved",
      ),
    );
  return {
    assistance: assistance({
      profileHint: "nedbank-credit",
      period,
      convention: "positive_is_liability",
      opening: balances.opening,
      closing: balances.closing,
      pageCount,
      rows,
      complete,
      // A revolving credit facility can retain one account while physical card
      // numbers change. The original PDF remains authoritative for every printed
      // identifier; account binding is the separately reviewed structural choice.
      accountHint: null,
      sourceAccountType: "personal credit",
    }),
    issues,
    sourceDocumentClass: "bank_statement",
  };
}

function parseInvestment(text: string, pageCount: number): ExtractionResult {
  const period = parsePeriod(text);
  const issues = [
    issue(
      "INTAKE_INVESTMENT_PROFILE_REVIEW_REQUIRED",
      "Investment evidence requires a reviewed source-specific movement profile",
    ),
  ];
  if (!period)
    issues.push(
      issue("INTAKE_PERIOD_UNRESOLVED", "Statement period was not extracted"),
    );
  if (!period)
    return { assistance: null, issues, sourceDocumentClass: "unsupported" };
  const balances = openingClosing(text, "positive_is_asset");
  return {
    assistance: assistance({
      profileHint: "normalized-json-v1",
      period,
      convention: "positive_is_asset",
      opening: balances.opening,
      closing: balances.closing,
      pageCount,
      rows: [],
      complete: false,
      accountHint: maskedAccountHint(text),
      sourceAccountType: "personal investment",
    }),
    issues,
    sourceDocumentClass: "bank_statement",
  };
}

export function extractStatementAssistance(input: {
  text: string;
  pageCount: number;
  accountClass: AccountClass;
}): ExtractionResult {
  if (/annual financial statements|annual financial report/i.test(input.text)) {
    return {
      assistance: null,
      issues: [],
      sourceDocumentClass: "accountant_compilation",
    };
  }
  if (input.pageCount < 1)
    return {
      assistance: null,
      issues: [
        issue("INTAKE_PAGE_COVERAGE_UNKNOWN", "PDF page count is unavailable"),
      ],
      sourceDocumentClass: "unsupported",
    };
  if (input.accountClass === "business")
    return parseFnbBusiness(input.text, input.pageCount);
  if (
    input.accountClass === "personal_current" ||
    input.accountClass === "personal_savings"
  )
    return parseNedbankAsset(input.text, input.pageCount, input.accountClass);
  if (input.accountClass === "personal_credit")
    return parseNedbankCredit(input.text, input.pageCount);
  if (input.accountClass === "personal_investment")
    return parseInvestment(input.text, input.pageCount);
  return {
    assistance: null,
    issues: [
      issue(
        "INTAKE_ACCOUNT_CLASS_UNRESOLVED",
        "Source Account class is unresolved",
      ),
    ],
    sourceDocumentClass: "unsupported",
  };
}

export function inventoryAggregate(inventory: SourceInventory) {
  const authoritative = inventory.occurrences.filter(
    (item) => !item.compatibilityOnly,
  );
  const unique = new Set(authoritative.map((item) => item.fingerprint));
  const classes = Object.fromEntries(
    (
      [
        "business",
        "personal_current",
        "personal_credit",
        "personal_savings",
        "personal_investment",
      ] as AccountClass[]
    ).map((accountClass) => [
      accountClass,
      authoritative.filter(
        (item) =>
          item.accountClass === accountClass && item.sourceKind === "pdf",
      ).length,
    ]),
  );
  return {
    totalInventoryFiles: inventory.occurrences.length,
    sourceEvidenceFiles: authoritative.length,
    uniqueSourceEvidenceFiles: unique.size,
    duplicateSourceEvidenceFiles: authoritative.length - unique.size,
    compatibilityOnlyFiles: inventory.occurrences.filter(
      (item) => item.compatibilityOnly,
    ).length,
    pdfsByAccountClass: classes,
  };
}

export function exactTransferCandidates(
  components: readonly Readonly<{
    componentRef: string;
    accountRef: string;
    currency: string;
    date: string;
    amountMinor: number;
    sourceFlow: "inflow" | "outflow" | "unknown";
  }>[],
) {
  const candidates: Array<{
    leftComponentRef: string;
    rightComponentRef: string;
    evidenceClass: "exact_magnitude_opposite_flow_bounded_date";
    reviewState: "pending";
    authority: typeof PROVISIONAL_AUTHORITY;
  }> = [];
  const dated = components
    .filter((item) => item.sourceFlow !== "unknown")
    .sort((left, right) => left.componentRef.localeCompare(right.componentRef));
  for (let leftIndex = 0; leftIndex < dated.length; leftIndex += 1) {
    const left = dated[leftIndex]!;
    for (
      let rightIndex = leftIndex + 1;
      rightIndex < dated.length;
      rightIndex += 1
    ) {
      const right = dated[rightIndex]!;
      if (
        left.accountRef === right.accountRef ||
        left.currency !== right.currency ||
        left.amountMinor !== right.amountMinor ||
        left.sourceFlow === right.sourceFlow
      )
        continue;
      const days =
        Math.abs(
          new Date(`${left.date}T00:00:00Z`).getTime() -
            new Date(`${right.date}T00:00:00Z`).getTime(),
        ) / 86_400_000;
      if (days > 3) continue;
      candidates.push({
        leftComponentRef: left.componentRef,
        rightComponentRef: right.componentRef,
        evidenceClass: "exact_magnitude_opposite_flow_bounded_date",
        reviewState: "pending",
        authority: PROVISIONAL_AUTHORITY,
      });
    }
  }
  return candidates;
}

export const internal = {
  canonicalJson,
  exactMinor,
  parsePeriod,
  sha256,
};
