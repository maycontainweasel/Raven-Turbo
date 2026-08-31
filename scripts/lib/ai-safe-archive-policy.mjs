import { basename } from "node:path";

const BLOCKED_DIRECTORY_PATTERNS = [
  ["orbit-mirror", /(^|\/)\.orbit(\/|$)/],
  ["private-workpad", /(^|\/)\.raven-private(\/|$)/],
  ["private-statements", /(^|\/)docs\/statements(\/|$)/],
  [
    "private-prototype-archive",
    /(^|\/)docs\/raven-buckets-lab-prototype-[^/]+(\/|$)/,
  ],
  ["mediation-export", /(^|\/)mediation-financial-export[^/]*(\/|$)/],
  ["mail-export", /(^|\/)(mailbox|mail-exports?|email-exports?)(\/|$)/i],
  [
    "brain-raw-source",
    /(^|\/)brain\/(source-material|backfill|sessions)(\/|$)/,
  ],
  [
    "local-data",
    /(^|\/)(data|backups?|dumps?)\/(surreal|database|local)(\/|$)/i,
  ],
];

const BLOCKED_BASENAMES = new Map([
  ["dev.toml", "local-service-config"],
  ["sr.toml", "local-service-config"],
  ["database.md", "credential-bearing-config"],
  ["surreal.md", "credential-bearing-config"],
  ["surreal-mcp.toml", "credential-bearing-config"],
  ["env.yaml", "environment-config"],
  ["env.config.cjs", "environment-config"],
  ["nuxt.config.runtime.ts", "generated-runtime-config"],
  ["history.txt", "history-dump"],
]);

const BLOCKED_EXACT_PATHS = new Map([
  ["apps/schema/docs/EXTENSIONS.md", "credential-example"],
  [
    "apps/schema/schema-docs/test/capabilities/helpers.ts",
    "test-credential-fixture",
  ],
]);

const BLOCKED_FILE_PATTERNS = [
  ["environment-file", /(^|\/)\.env(?:\..*)?$/i],
  ["environment-file", /(^|\/)[^/]+\.env(?:\..*)?$/i],
  ["credential-file", /(^|\/)[^/]*(credentials?|secrets?)[^/]*$/i],
  ["certificate-or-key", /\.(pem|key|p12|pfx|jks|keystore)$/i],
  ["mail-message", /\.(eml|msg)$/i],
  ["private-pdf", /\.pdf$/i],
  ["database-or-backup", /\.(db|sqlite|sqlite3|dump|backup|bak)$/i],
  ["database-or-backup", /\.(sql|surql)\.(gz|zip|tar)$/i],
  ["docker-local-config", /(^|\/)docker-compose(?:\.[^/]+)?\.ya?ml$/i],
  ["history-dump", /(^|\/)[^/]*(history|transcript)[^/]*\.(txt|json|ndjson)$/i],
];

const PLACEHOLDER_MARKERS = [
  "process.env",
  "import.meta.env",
  "runtimeconfig",
  "placeholder",
  "changeme",
  "change-me",
  "example",
  "dummy",
  "redacted",
  "password",
  "username",
  "your_",
  "your-",
  "<",
  "${",
  "***",
];

function normalizePath(pathName) {
  return String(pathName).replaceAll("\\", "/").replace(/^\.\//, "");
}

export function classifyAiSafePath(pathName) {
  const normalized = normalizePath(pathName);

  const exactReason = BLOCKED_EXACT_PATHS.get(normalized);
  if (exactReason) return { allowed: false, reason: exactReason };

  for (const [reason, pattern] of BLOCKED_DIRECTORY_PATTERNS) {
    if (pattern.test(normalized)) return { allowed: false, reason };
  }

  const blockedBasename = BLOCKED_BASENAMES.get(
    basename(normalized).toLowerCase(),
  );
  if (blockedBasename) return { allowed: false, reason: blockedBasename };

  for (const [reason, pattern] of BLOCKED_FILE_PATTERNS) {
    if (pattern.test(normalized)) return { allowed: false, reason };
  }

  return { allowed: true };
}

export function hasPrivateDocumentStatus(text) {
  const frontmatter = String(text).match(
    /^---\r?\n([\s\S]*?)\r?\n---(?:\r?\n|$)/,
  );
  if (!frontmatter) return false;
  return /^status:\s*private\s*$/im.test(frontmatter[1]);
}

function isPlaceholderValue(value) {
  const normalized = value
    .trim()
    .replace(/^['"]|['"]$/g, "")
    .toLowerCase();
  if (!normalized) return true;
  return PLACEHOLDER_MARKERS.some((marker) => normalized.includes(marker));
}

export function detectSecretCodes(text) {
  const source = String(text);
  const codes = new Set();

  if (/-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----/.test(source)) {
    codes.add("private-key");
  }
  if (/\bsk-[A-Za-z0-9_-]{20,}\b/.test(source)) codes.add("openai-token");
  if (/\bgh[pousr]_[A-Za-z0-9]{20,}\b/.test(source)) codes.add("github-token");
  if (/\bxox[baprs]-[A-Za-z0-9-]{20,}\b/.test(source)) codes.add("slack-token");
  if (/\bAKIA[A-Z0-9]{16}\b/.test(source)) codes.add("aws-access-key");

  const credentialUrlPattern =
    /\b(?:postgres(?:ql)?|mysql|mongodb(?:\+srv)?|redis|rediss|https?|wss?):\/\/([^\s/:@]+):([^\s/@]+)@/gi;
  for (const match of source.matchAll(credentialUrlPattern)) {
    if (!isPlaceholderValue(match[2])) {
      codes.add("credentialed-url");
    }
  }

  const assignmentPattern =
    /\b(?:password|passwd|passphrase|api[_-]?key|access[_-]?token|auth[_-]?token|client[_-]?secret|session[_-]?secret)\b\s*[:=]\s*(['"`])([^'"`\r\n]+)\1/gi;
  for (const match of source.matchAll(assignmentPattern)) {
    if (!isPlaceholderValue(match[2])) codes.add("credential-assignment");
  }

  return [...codes].sort();
}

export function assertNoDetectedSecrets(entries) {
  const failures = [];
  for (const entry of entries) {
    const codes = detectSecretCodes(entry.text);
    if (codes.length) failures.push({ path: normalizePath(entry.path), codes });
  }

  if (!failures.length) return;

  const details = failures
    .map((failure) => `- ${failure.path}: ${failure.codes.join(", ")}`)
    .join("\n");
  throw new Error(`AI-safe archive blocked by secret preflight:\n${details}`);
}
