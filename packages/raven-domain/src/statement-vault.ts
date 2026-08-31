import { createHash, randomUUID } from "node:crypto";
import {
  chmod,
  lstat,
  mkdir,
  readFile,
  realpath,
  rename,
  rm,
  stat,
  writeFile,
} from "node:fs/promises";
import path from "node:path";
import { RavenDomainError } from "./errors.js";
import type {
  StageStatementSourceInput,
  StatementSourceBundle,
  StatementSourceDescriptor,
  StatementSourceKind,
  StatementSourceVault,
} from "./statement-contracts.js";

const SOURCE_REF_PREFIX = "stmt-src-";
const METADATA_FILE = "descriptor.json";
const ORIGINAL_FILE = "original.bin";
const ASSIST_FILE = "extraction-assist.json";

export type LocalStatementSourceVaultOptions = Readonly<{
  vaultRoot: string;
  allowedInboxRoots: readonly string[];
  maxSourceBytes?: number;
  maxExtractionAssistBytes?: number;
}>;

type StoredDescriptor = StatementSourceDescriptor & Readonly<{ version: 1 }>;

function sha256(bytes: Uint8Array): string {
  return createHash("sha256").update(bytes).digest("hex");
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

function sourceSignature(bytes: Uint8Array): StatementSourceKind | null {
  const first = Buffer.from(bytes.subarray(0, Math.min(bytes.length, 512)));
  const text = first
    .toString("utf8")
    .replace(/^\uFEFF/, "")
    .trimStart();
  if (first.subarray(0, 5).toString("ascii") === "%PDF-") return "pdf";
  if (
    first.length >= 8 &&
    first[0] === 0x89 &&
    first.subarray(1, 4).toString("ascii") === "PNG"
  ) {
    return "image";
  }
  if (first[0] === 0xff && first[1] === 0xd8 && first[2] === 0xff)
    return "image";
  if (/^(OFXHEADER:|<\?xml[\s\S]*<OFX|<OFX)/i.test(text)) return "ofx";
  if (/^!Type:/i.test(text)) return "qif";
  if (text.includes(",") || text.includes(";") || text.includes("\t"))
    return "csv";
  return null;
}

function mimeMatches(kind: StatementSourceKind, mimeType: string): boolean {
  const mime = mimeType.toLowerCase().split(";")[0]?.trim();
  if (kind === "pdf") return mime === "application/pdf";
  if (kind === "csv") return mime === "text/csv" || mime === "text/plain";
  if (kind === "ofx")
    return mime === "application/x-ofx" || mime === "text/plain";
  if (kind === "qif")
    return mime === "application/qif" || mime === "text/plain";
  return mime === "image/png" || mime === "image/jpeg";
}

function validateSource(
  bytes: Uint8Array,
  sourceKind: StatementSourceKind,
  mimeType: string,
  maxBytes: number,
): void {
  if (bytes.byteLength === 0 || bytes.byteLength > maxBytes) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "Statement source size is not allowed",
    );
  }
  const detectedKind = sourceSignature(bytes);
  if (
    !detectedKind ||
    detectedKind !== sourceKind ||
    !mimeMatches(sourceKind, mimeType)
  ) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "Statement source type does not match its declared format",
    );
  }
}

function validateAssist(
  bytes: Uint8Array,
  mimeType: string,
  maxBytes: number,
): void {
  if (
    mimeType !== "application/json" ||
    bytes.byteLength === 0 ||
    bytes.byteLength > maxBytes
  ) {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "Extraction assistance must be bounded JSON",
    );
  }
  try {
    JSON.parse(Buffer.from(bytes).toString("utf8"));
  } catch {
    throw new RavenDomainError(
      "STATEMENT_EXTRACTION_INVALID",
      "Extraction assistance is not valid JSON",
    );
  }
}

function safeSourceRef(sourceRef: string): string {
  if (!new RegExp(`^${SOURCE_REF_PREFIX}[a-f0-9-]{36}$`).test(sourceRef)) {
    throw new RavenDomainError(
      "STATEMENT_SOURCE_NOT_FOUND",
      "Statement source was not found",
    );
  }
  return sourceRef;
}

export class LocalStatementSourceVault implements StatementSourceVault {
  readonly #vaultRoot: string;
  readonly #allowedInboxRoots: readonly string[];
  readonly #maxSourceBytes: number;
  readonly #maxExtractionAssistBytes: number;

  constructor(options: LocalStatementSourceVaultOptions) {
    this.#vaultRoot = path.resolve(options.vaultRoot);
    this.#allowedInboxRoots = options.allowedInboxRoots.map((root) =>
      path.resolve(root),
    );
    this.#maxSourceBytes = options.maxSourceBytes ?? 15 * 1024 * 1024;
    this.#maxExtractionAssistBytes =
      options.maxExtractionAssistBytes ?? 2 * 1024 * 1024;
  }

  async #prepareRoot(): Promise<void> {
    await mkdir(this.#vaultRoot, { recursive: true, mode: 0o700 });
    await chmod(this.#vaultRoot, 0o700);
  }

  async #readAllowedFile(
    inputPath: string,
    maxBytes: number,
  ): Promise<Uint8Array> {
    if (!inputPath || inputPath.includes("\0")) {
      throw new RavenDomainError(
        "STATEMENT_SOURCE_NOT_FOUND",
        "Statement source was not found",
      );
    }
    let canonical: string;
    try {
      const direct = await lstat(inputPath);
      if (direct.isSymbolicLink() || !direct.isFile())
        throw new Error("not a regular file");
      canonical = await realpath(inputPath);
      const details = await stat(canonical);
      if (!details.isFile() || details.size <= 0 || details.size > maxBytes) {
        throw new Error("invalid source size");
      }
    } catch {
      throw new RavenDomainError(
        "STATEMENT_SOURCE_NOT_FOUND",
        "Statement source was not found",
      );
    }
    const allowed = await Promise.all(
      this.#allowedInboxRoots.map(async (root) => {
        try {
          return await realpath(root);
        } catch {
          return root;
        }
      }),
    );
    if (!allowed.some((root) => pathContained(root, canonical))) {
      throw new RavenDomainError(
        "STATEMENT_SOURCE_NOT_FOUND",
        "Statement source is outside the configured inbox",
      );
    }
    return new Uint8Array(await readFile(canonical));
  }

  async #stage(
    originalBytes: Uint8Array,
    mimeType: string,
    sourceKind: StatementSourceKind,
    extractionAssistBytes?: Uint8Array,
    extractionAssistMimeType?: string,
  ): Promise<StatementSourceDescriptor> {
    validateSource(originalBytes, sourceKind, mimeType, this.#maxSourceBytes);
    if (extractionAssistBytes) {
      validateAssist(
        extractionAssistBytes,
        extractionAssistMimeType ?? "",
        this.#maxExtractionAssistBytes,
      );
    }
    await this.#prepareRoot();
    const sourceRef = `${SOURCE_REF_PREFIX}${randomUUID()}`;
    const temporaryDirectory = path.join(
      this.#vaultRoot,
      `.tmp-${randomUUID()}`,
    );
    const finalDirectory = path.join(this.#vaultRoot, sourceRef);
    await mkdir(temporaryDirectory, { mode: 0o700 });
    try {
      const descriptor: StoredDescriptor = {
        version: 1,
        sourceRef,
        sourceKind,
        mimeType,
        byteSize: originalBytes.byteLength,
        originalFileSha256: sha256(originalBytes),
        extractionAssistRef: extractionAssistBytes
          ? `${sourceRef}:assist`
          : null,
        extractionAssistMimeType: extractionAssistBytes
          ? "application/json"
          : null,
        extractionAssistByteSize: extractionAssistBytes?.byteLength ?? null,
        extractionInputSha256: extractionAssistBytes
          ? sha256(extractionAssistBytes)
          : null,
      };
      await writeFile(
        path.join(temporaryDirectory, ORIGINAL_FILE),
        originalBytes,
        { mode: 0o600 },
      );
      if (extractionAssistBytes) {
        await writeFile(
          path.join(temporaryDirectory, ASSIST_FILE),
          extractionAssistBytes,
          {
            mode: 0o600,
          },
        );
      }
      await writeFile(
        path.join(temporaryDirectory, METADATA_FILE),
        JSON.stringify(descriptor),
        { mode: 0o600 },
      );
      await rename(temporaryDirectory, finalDirectory);
      await chmod(finalDirectory, 0o700);
      return descriptor;
    } catch (error) {
      await rm(temporaryDirectory, { recursive: true, force: true });
      throw error;
    }
  }

  stageUpload(
    input: Extract<StageStatementSourceInput, { transport: "upload" }>,
  ): Promise<StatementSourceDescriptor> {
    return this.#stage(
      input.originalBytes,
      input.mimeType,
      input.sourceKind,
      input.extractionAssistBytes,
      input.extractionAssistMimeType,
    );
  }

  async stageLocalPath(
    input: Extract<StageStatementSourceInput, { transport: "local_path" }>,
  ): Promise<StatementSourceDescriptor> {
    const originalBytes = await this.#readAllowedFile(
      input.originalPath,
      this.#maxSourceBytes,
    );
    const extractionAssistBytes = input.extractionAssistPath
      ? await this.#readAllowedFile(
          input.extractionAssistPath,
          this.#maxExtractionAssistBytes,
        )
      : undefined;
    return this.#stage(
      originalBytes,
      input.mimeType,
      input.sourceKind,
      extractionAssistBytes,
      input.extractionAssistMimeType,
    );
  }

  async describe(sourceRef: string): Promise<StatementSourceDescriptor> {
    await this.#prepareRoot();
    const safeRef = safeSourceRef(sourceRef);
    try {
      const raw = await readFile(
        path.join(this.#vaultRoot, safeRef, METADATA_FILE),
        "utf8",
      );
      const descriptor = JSON.parse(raw) as StoredDescriptor;
      if (descriptor.sourceRef !== safeRef || descriptor.version !== 1)
        throw new Error("invalid");
      return descriptor;
    } catch {
      throw new RavenDomainError(
        "STATEMENT_SOURCE_NOT_FOUND",
        "Statement source was not found",
      );
    }
  }

  async readBundle(sourceRef: string): Promise<StatementSourceBundle> {
    const descriptor = await this.describe(sourceRef);
    try {
      const directory = path.join(this.#vaultRoot, safeSourceRef(sourceRef));
      const originalBytes = new Uint8Array(
        await readFile(path.join(directory, ORIGINAL_FILE)),
      );
      const extractionAssistBytes = descriptor.extractionAssistRef
        ? new Uint8Array(await readFile(path.join(directory, ASSIST_FILE)))
        : null;
      if (
        sha256(originalBytes) !== descriptor.originalFileSha256 ||
        (extractionAssistBytes &&
          sha256(extractionAssistBytes) !== descriptor.extractionInputSha256)
      ) {
        throw new RavenDomainError(
          "STATEMENT_SOURCE_CHANGED",
          "Statement source changed after staging",
        );
      }
      return { descriptor, originalBytes, extractionAssistBytes };
    } catch (error) {
      if (error instanceof RavenDomainError) throw error;
      throw new RavenDomainError(
        "STATEMENT_SOURCE_NOT_FOUND",
        "Statement source was not found",
      );
    }
  }
}

export function createLocalStatementSourceVault(
  options: LocalStatementSourceVaultOptions,
): StatementSourceVault {
  return new LocalStatementSourceVault(options);
}
