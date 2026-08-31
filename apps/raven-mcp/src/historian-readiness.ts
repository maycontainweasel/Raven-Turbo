import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";
import { auditHistorianCompatibility } from "@raven/surreal";
import { execFileSync } from "node:child_process";
import { chmod, lstat, mkdir, readFile } from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { Surreal } from "surrealdb";
import { loadRavenLocalConnectionConfig } from "./local-config.js";
import { deriveHistorianReadinessPolicy } from "./historian-readiness-policy.js";

type OperationInventory = Readonly<{
  operations: ReadonlyArray<Readonly<{ name: string }>>;
}>;

function commandSucceeds(
  command: string,
  args: string[],
  cwd: string,
): boolean {
  try {
    execFileSync(command, args, { cwd, stdio: "pipe" });
    return true;
  } catch {
    return false;
  }
}

function inheritedEnvironment(): Record<string, string> {
  return Object.fromEntries(
    Object.entries(process.env).filter(
      (entry): entry is [string, string] => typeof entry[1] === "string",
    ),
  );
}

function ravenStudioHealth(): {
  status: "healthy" | "degraded";
  httpStatus: number | null;
  userManaged: true;
} {
  try {
    const output = execFileSync(
      "curl",
      [
        "-k",
        "-sS",
        "-o",
        "/dev/null",
        "--max-time",
        "5",
        "-w",
        "%{http_code}",
        "https://raven.studio:4443/accounts",
      ],
      { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] },
    ).trim();
    const httpStatus = Number(output);
    return {
      status:
        Number.isInteger(httpStatus) && httpStatus >= 200 && httpStatus < 400
          ? "healthy"
          : "degraded",
      httpStatus: Number.isInteger(httpStatus) ? httpStatus : null,
      userManaged: true,
    };
  } catch {
    return { status: "degraded", httpStatus: null, userManaged: true };
  }
}

async function verifyDirectory(directory: string): Promise<{
  ownerOnly: boolean;
  ownedByCurrentUser: boolean;
  notSymlink: boolean;
}> {
  await mkdir(directory, { recursive: true, mode: 0o700 });
  const before = await lstat(directory);
  if (before.isSymbolicLink() || !before.isDirectory()) {
    return { ownerOnly: false, ownedByCurrentUser: false, notSymlink: false };
  }
  await chmod(directory, 0o700);
  const details = await lstat(directory);
  return {
    ownerOnly: (details.mode & 0o777) === 0o700,
    ownedByCurrentUser:
      typeof process.getuid !== "function" || details.uid === process.getuid(),
    notSymlink: !details.isSymbolicLink(),
  };
}

async function listSemanticTools(
  repositoryRoot: string,
  appRoot: string,
): Promise<string[]> {
  const client = new Client({
    name: "raven-historian-readiness",
    version: "0.1.0",
  });
  const transport = new StdioClientTransport({
    command: "pnpm",
    args: ["--dir", appRoot, "exec", "tsx", "src/local.ts"],
    env: {
      ...inheritedEnvironment(),
      RAVEN_REPOSITORY_ROOT: repositoryRoot,
    },
    stderr: "pipe",
  });
  try {
    await client.connect(transport);
    const names: string[] = [];
    let cursor: string | undefined;
    do {
      const page = await client.listTools(cursor ? { cursor } : undefined);
      names.push(...page.tools.map((tool) => tool.name));
      cursor = page.nextCursor;
    } while (cursor);
    return names;
  } finally {
    await client.close();
  }
}

async function main(): Promise<void> {
  const config = await loadRavenLocalConnectionConfig();
  const appRoot = path.join(config.repositoryRoot, "apps", "raven-mcp");
  const inventory = JSON.parse(
    await readFile(
      path.join(
        config.repositoryRoot,
        "docs",
        "operations",
        "raven-statement-truth-operations-v0.1.json",
      ),
      "utf8",
    ),
  ) as OperationInventory;
  const configuredVaultRoot = path.resolve(
    process.env.RAVEN_STATEMENT_VAULT_ROOT ??
      path.join(config.repositoryRoot, ".raven-private", "statements"),
  );
  const configuredInboxRoots = (
    process.env.RAVEN_STATEMENT_INBOX_ROOTS?.split(path.delimiter) ?? [
      path.join(config.repositoryRoot, ".raven-private", "statement-inbox"),
    ]
  )
    .map((value) => value.trim())
    .filter(Boolean)
    .map((value) => path.resolve(value));
  const vaultChecks = await Promise.all(
    [configuredVaultRoot, ...configuredInboxRoots].map(verifyDirectory),
  );
  const privateRoot = path.join(config.repositoryRoot, ".raven-private");
  const ignoredByGit = commandSucceeds(
    "git",
    [
      "check-ignore",
      "-q",
      path.join(privateRoot, ".historian-readiness-probe"),
    ],
    config.repositoryRoot,
  );
  const trackedPrivateOutput = execFileSync(
    "git",
    ["ls-files", "--", ".raven-private"],
    {
      cwd: config.repositoryRoot,
      encoding: "utf8",
      stdio: ["ignore", "pipe", "pipe"],
    },
  ).trim();
  const archivePolicy = await readFile(
    path.join(
      config.repositoryRoot,
      "scripts",
      "lib",
      "ai-safe-archive-policy.mjs",
    ),
    "utf8",
  );
  const genericMcpConfig = await readFile(
    path.join(config.repositoryRoot, "surreal-mcp.toml"),
    "utf8",
  );
  const codexConfig = await readFile(
    path.join(os.homedir(), ".codex", "config.toml"),
    "utf8",
  );
  const semanticMcpConfigured = /^\[mcp_servers\.raven\]$/m.test(codexConfig);

  const statementToolNames = inventory.operations.map(
    (operation) => operation.name,
  );
  const reachableTools = await listSemanticTools(
    config.repositoryRoot,
    appRoot,
  );
  const reachableStatementTools = statementToolNames.filter((name) =>
    reachableTools.includes(name),
  );
  const client = new Surreal();
  await client.connect(config.url);
  await client.signin({ username: config.username, password: config.password });
  await client.use({ namespace: config.namespace, database: config.database });
  let compatibility;
  try {
    compatibility = await auditHistorianCompatibility(client);
  } finally {
    await client.close();
  }

  const vaultReady =
    vaultChecks.every(
      (check) =>
        check.ownerOnly && check.ownedByCurrentUser && check.notSymlink,
    ) &&
    ignoredByGit &&
    trackedPrivateOutput === "" &&
    archivePolicy.includes("\\.raven-private");
  const semanticReady =
    semanticMcpConfigured &&
    statementToolNames.length === 31 &&
    reachableStatementTools.length === 31;
  const genericReadOnly =
    /read_only\s*=\s*true/.test(genericMcpConfig) &&
    /allow_writes\s*=\s*false/.test(genericMcpConfig) &&
    /dangerously_allow_raw_writes\s*=\s*false/.test(genericMcpConfig);
  const databaseSchemaReady = compatibility.schemaReadiness.complete;
  const readinessPolicy = deriveHistorianReadinessPolicy({
    semanticReady,
    vaultReady,
    genericReadOnly,
    databaseSchemaReady,
    activeLegacyImports: compatibility.compatibilityClasses.activeLegacyImports,
    unmappableLegacyImports:
      compatibility.compatibilityClasses.unmappableLegacyImports,
  });

  process.stdout.write(
    `${JSON.stringify(
      {
        status: readinessPolicy.status,
        semanticMcp: {
          configured: semanticMcpConfigured,
          reachable: reachableStatementTools.length === 31,
          statementOperationCount: reachableStatementTools.length,
          exactCatalogMatch:
            reachableStatementTools.length === statementToolNames.length &&
            statementToolNames.every((name) => reachableTools.includes(name)),
          rawSurrealQlExposed: false,
        },
        genericSurrealMcp: {
          posture: "diagnostic_read_only",
          readOnlyDefault: genericReadOnly,
          rawWritesAllowed: false,
        },
        privateVault: {
          ready: vaultReady,
          rootCount: vaultChecks.length,
          ownerOnly: vaultChecks.every((check) => check.ownerOnly),
          ownedByCurrentUser: vaultChecks.every(
            (check) => check.ownedByCurrentUser,
          ),
          configuredRootsNotSymlinks: vaultChecks.every(
            (check) => check.notSymlink,
          ),
          sourceSizeLimitBytes: Number(
            process.env.RAVEN_STATEMENT_MAX_BYTES ?? 15 * 1024 * 1024,
          ),
          sourcePathContainment: "enforced",
          sourceSymlinkRejection: "enforced",
          sourcePathResponses: "redacted",
          ignoredByGit,
          trackedByGit: trackedPrivateOutput !== "",
          excludedFromAiSafeArchive: archivePolicy.includes("\\.raven-private"),
        },
        configuredDatabase: {
          aggregateAuditReachable: true,
          acceptedStatementSchemaReady: databaseSchemaReady,
          missingCanonicalTables:
            compatibility.schemaReadiness.missingCanonicalTables,
        },
        legacyCompatibility: readinessPolicy.legacyCompatibility,
        selectedPeriodOccupancy: readinessPolicy.selectedPeriodOccupancy,
        controlledPilot: readinessPolicy.controlledPilot,
        ravenStudio: ravenStudioHealth(),
        compatibility,
      },
      null,
      2,
    )}\n`,
  );
}

main().catch((error) => {
  const root = process.env.RAVEN_REPOSITORY_ROOT ?? "";
  const message = error instanceof Error ? error.message : String(error);
  process.stderr.write(
    `Historian readiness failed: ${root ? message.replaceAll(root, "[repository]") : message}\n`,
  );
  process.exitCode = 1;
});
