#!/usr/bin/env node

import {
  existsSync,
  mkdirSync,
  readFileSync,
  readdirSync,
  realpathSync,
  statSync,
  unlinkSync,
} from "node:fs";
import {
  dirname,
  isAbsolute,
  join,
  relative,
  resolve,
  sep,
  basename,
} from "node:path";
import { spawnSync } from "node:child_process";

import {
  assertNoDetectedSecrets,
  classifyAiSafePath,
  hasPrivateDocumentStatus,
} from "./lib/ai-safe-archive-policy.mjs";

const DEFAULT_SKIP_DIRS = new Set([
  ".git",
  "node_modules",
  ".nuxt",
  ".output",
  ".next",
  ".turbo",
  ".cache",
  ".pnpm-store",
  ".vercel",
  "dist",
  "build",
  "coverage",
  "out",
]);

function printHelp() {
  console.log(`Usage:
  pnpm run zip:ai-safe [-- --output <file.zip>]
  pnpm run zip:ai-safe [-- --name <archive-name>]
  pnpm run zip:ai-safe [-- --list] [--show-excluded]
  pnpm run zip:developer-unsafe [-- --output <file.zip>]
  node scripts/share-repo-zip.mjs --profile <ai-safe|developer-unsafe>

What it does:
  - Zips tracked files plus untracked, non-ignored files.
  - Respects each repo's .gitignore recursively.
  - Also discovers nested git repos, such as apps/schema, even if the outer
    repo ignores them.
  - Defaults to the fail-closed ai-safe profile.
  - The ai-safe profile excludes private paths and private document
    frontmatter, then aborts if secret signatures remain in selected files.
  - The developer-unsafe profile preserves the former broad archive behavior.

Examples:
  pnpm run zip:ai-safe -- --list
  pnpm run zip:ai-safe -- --list --show-excluded
  pnpm run zip:ai-safe -- --output /tmp/raven-ai-safe.zip
  pnpm run zip:developer-unsafe -- --output /tmp/raven-developer-unsafe.zip
`);
}

function parseArgs(argv) {
  const options = {
    listOnly: false,
    output: "",
    name: "",
    maxDepth: 6,
    excludes: [],
    profile: "ai-safe",
    showExcluded: false,
    help: false,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];

    if (arg === "--") {
      continue;
    }

    if (arg === "--help" || arg === "-h") {
      options.help = true;
      continue;
    }

    if (arg === "--list" || arg === "--dry-run") {
      options.listOnly = true;
      continue;
    }

    if (arg === "--show-excluded") {
      options.showExcluded = true;
      continue;
    }

    if (arg === "--profile") {
      options.profile = argv[++index] ?? "";
      continue;
    }

    if (arg === "--output") {
      options.output = argv[++index] ?? "";
      continue;
    }

    if (arg === "--name") {
      options.name = argv[++index] ?? "";
      continue;
    }

    if (arg === "--max-depth") {
      const parsed = Number(argv[++index] ?? "");
      if (Number.isFinite(parsed) && parsed >= 0) {
        options.maxDepth = parsed;
      }
      continue;
    }

    if (arg === "--exclude") {
      const raw = argv[++index] ?? "";
      const values = raw
        .split(",")
        .map((value) => value.trim())
        .filter(Boolean);
      options.excludes.push(...values);
      continue;
    }

    throw new Error(`Unknown argument: ${arg}`);
  }

  if (!["ai-safe", "developer-unsafe"].includes(options.profile)) {
    throw new Error(`Unknown archive profile: ${options.profile || "(empty)"}`);
  }

  return options;
}

function runGit(args, cwd, description) {
  const result = spawnSync("git", args, {
    cwd,
    encoding: "utf8",
    maxBuffer: 1024 * 1024 * 50,
  });

  if (result.error) {
    throw new Error(
      `Failed to run git for ${description}: ${result.error.message}`,
    );
  }

  if (result.status !== 0) {
    const stderr = (result.stderr ?? "").trim();
    throw new Error(
      `git ${description} failed with exit code ${result.status}${stderr ? `: ${stderr}` : ""}`,
    );
  }

  return (result.stdout ?? "").trimEnd();
}

function getRepoRoot(startDir) {
  let current = runGit(
    ["rev-parse", "--show-toplevel"],
    startDir,
    "rev-parse --show-toplevel",
  ).trim();

  while (true) {
    const parent = dirname(current);
    if (parent === current) break;
    if (!existsSync(join(parent, ".git"))) break;
    current = parent;
  }

  return current;
}

function safeRealpath(pathName) {
  try {
    return realpathSync(pathName);
  } catch {
    return pathName;
  }
}

function isInsideRoot(root, candidate) {
  const rel = relative(root, candidate);
  return rel !== "" && !rel.startsWith(`..${sep}`) && rel !== "..";
}

function toPosixPath(pathName) {
  return pathName.split(sep).join("/");
}

function normalizeRelative(root, absolutePath) {
  return toPosixPath(relative(root, absolutePath));
}

function resolvePathRelativeToRoot(root, value) {
  if (!value) return "";
  return isAbsolute(value) ? value : resolve(root, value);
}

function resolveOutputPath(root, options) {
  if (options.output) {
    return resolvePathRelativeToRoot(root, options.output);
  }

  const archiveName = options.name
    ? options.name.endsWith(".zip")
      ? options.name
      : `${options.name}.zip`
    : `${basename(root)}-${options.profile}-${new Date().toISOString().replace(/[:]/g, "-")}.zip`;

  return join(root, archiveName);
}

function findRepoRoots(root, maxDepth) {
  const discovered = new Set([root]);
  const visited = new Set();

  const visit = (dir, depth) => {
    if (depth > maxDepth) return;

    const real = safeRealpath(dir);
    if (visited.has(real)) return;
    visited.add(real);

    let entries = [];
    try {
      entries = readdirSync(dir, { withFileTypes: true });
    } catch {
      return;
    }

    for (const entry of entries) {
      if (!entry.isDirectory()) continue;
      if (DEFAULT_SKIP_DIRS.has(entry.name)) continue;

      const child = join(dir, entry.name);
      if (existsSync(join(child, ".git"))) {
        discovered.add(child);
      }

      visit(child, depth + 1);
    }
  };

  visit(root, 0);
  return [...discovered];
}

function listRepoFiles(repoRoot) {
  const output = runGit(
    ["ls-files", "-z", "--cached", "--others", "--exclude-standard"],
    repoRoot,
    "ls-files",
  );

  if (!output) return [];
  return output.split("\0").filter(Boolean);
}

function pathMatchesPrefixes(pathName, prefixes) {
  if (!prefixes.length) return false;

  const normalized = toPosixPath(pathName);
  return prefixes.some((prefix) => {
    const candidate = toPosixPath(prefix).replace(/\/+$/g, "");
    if (!candidate) return false;
    return normalized === candidate || normalized.startsWith(`${candidate}/`);
  });
}

function buildFileSet(root, repoRoots, options) {
  const outputPath = resolveOutputPath(root, options);
  const outputRel = isInsideRoot(root, outputPath)
    ? normalizeRelative(root, outputPath)
    : "";
  const explicitExcludes = options.excludes
    .map((value) => resolvePathRelativeToRoot(root, value))
    .map((value) =>
      isInsideRoot(root, value)
        ? normalizeRelative(root, value)
        : toPosixPath(value),
    );

  const files = new Set();

  for (const repoRoot of repoRoots) {
    const repoFiles = listRepoFiles(repoRoot);
    for (const repoFile of repoFiles) {
      const absoluteFile = join(repoRoot, repoFile);
      if (!existsSync(absoluteFile)) continue;

      const relativeFile = normalizeRelative(root, absoluteFile);
      if (!relativeFile || relativeFile.startsWith("..")) continue;
      if (relativeFile === outputRel) continue;
      if (pathMatchesPrefixes(relativeFile, explicitExcludes)) continue;

      files.add(relativeFile);
    }
  }

  return { files: [...files].sort(), outputPath };
}

function totalBytes(root, files) {
  return files.reduce((sum, file) => {
    try {
      return sum + statSync(join(root, file)).size;
    } catch {
      return sum;
    }
  }, 0);
}

function isBinaryBuffer(buffer) {
  const sampleLength = Math.min(buffer.length, 8192);
  for (let index = 0; index < sampleLength; index += 1) {
    if (buffer[index] === 0) return true;
  }
  return false;
}

function applyAiSafePolicy(root, files) {
  const included = [];
  const excluded = [];
  const textEntries = [];

  for (const file of files) {
    const pathDecision = classifyAiSafePath(file);
    if (!pathDecision.allowed) {
      excluded.push({ path: file, reason: pathDecision.reason });
      continue;
    }

    const buffer = readFileSync(join(root, file));
    const isBinary = isBinaryBuffer(buffer);
    const text = isBinary ? "" : buffer.toString("utf8");

    if (
      !isBinary &&
      file.toLowerCase().endsWith(".md") &&
      hasPrivateDocumentStatus(text)
    ) {
      excluded.push({ path: file, reason: "private-document-status" });
      continue;
    }

    included.push(file);
    if (!isBinary) textEntries.push({ path: file, text });
  }

  assertNoDetectedSecrets(textEntries);

  for (const file of included) {
    const decision = classifyAiSafePath(file);
    if (!decision.allowed) {
      throw new Error(
        `AI-safe archive policy invariant failed for ${file}: ${decision.reason}`,
      );
    }
  }

  return { files: included, excluded };
}

function excludedSummary(excluded) {
  const counts = new Map();
  for (const item of excluded) {
    counts.set(item.reason, (counts.get(item.reason) ?? 0) + 1);
  }
  return [...counts.entries()].sort(([left], [right]) =>
    left.localeCompare(right),
  );
}

function createZip(root, files, outputPath) {
  const zipArgs = ["-q", "-@", outputPath];
  const result = spawnSync("zip", zipArgs, {
    cwd: root,
    input: `${files.join("\n")}\n`,
    encoding: "utf8",
    maxBuffer: 1024 * 1024 * 20,
  });

  if (result.error) {
    throw new Error(`Failed to run zip: ${result.error.message}`);
  }

  if (result.status !== 0) {
    const stderr = (result.stderr ?? "").trim();
    throw new Error(
      `zip failed with exit code ${result.status}${stderr ? `: ${stderr}` : ""}`,
    );
  }
}

function main() {
  const options = parseArgs(process.argv.slice(2));

  if (options.help) {
    printHelp();
    return;
  }

  const cwd = process.cwd();
  const root = getRepoRoot(cwd);
  const repoRoots = findRepoRoots(root, options.maxDepth);
  const selected = buildFileSet(root, repoRoots, options);
  let files = selected.files;
  let excluded = [];
  const outputPath = selected.outputPath;

  if (options.profile === "ai-safe") {
    const filtered = applyAiSafePolicy(root, files);
    files = filtered.files;
    excluded = filtered.excluded;
  } else {
    console.error(
      "WARNING: developer-unsafe profile includes files without Raven privacy preflight.",
    );
  }

  if (!files.length) {
    throw new Error("No files were selected for the archive.");
  }

  const bytes = totalBytes(root, files);
  const archiveDir = dirname(outputPath);
  if (!existsSync(archiveDir)) {
    mkdirSync(archiveDir, { recursive: true });
  }

  if (options.listOnly) {
    console.log(`Profile: ${options.profile}`);
    console.log(`Repo root: ${root}`);
    console.log(
      `Nested repo roots: ${repoRoots.map((repoRoot) => normalizeRelative(root, repoRoot) || ".").join(", ")}`,
    );
    console.log(`Archive path: ${outputPath}`);
    console.log(`Files: ${files.length}`);
    console.log(`Bytes: ${bytes}`);
    if (options.profile === "ai-safe") {
      console.log(`Excluded files: ${excluded.length}`);
      for (const [reason, count] of excludedSummary(excluded)) {
        console.log(`Excluded (${reason}): ${count}`);
      }
    }
    console.log("");
    files.forEach((file) => console.log(file));
    if (options.showExcluded && excluded.length) {
      console.log("");
      console.log("Excluded paths:");
      excluded.forEach((item) => console.log(`${item.path}\t${item.reason}`));
    }
    return;
  }

  if (existsSync(outputPath)) {
    // Remove any previous archive so zip does not prompt or append.
    try {
      unlinkSync(outputPath);
    } catch {
      // Ignore stale output cleanup failures and let zip surface the error.
    }
  }

  createZip(root, files, outputPath);

  console.log(`Created archive: ${outputPath}`);
  console.log(`Profile: ${options.profile}`);
  console.log(`Included files: ${files.length}`);
  console.log(`Included bytes: ${bytes}`);
  if (options.profile === "ai-safe")
    console.log(`Excluded files: ${excluded.length}`);
  console.log(
    `Repo roots: ${repoRoots.map((repoRoot) => normalizeRelative(root, repoRoot) || ".").join(", ")}`,
  );
}

try {
  main();
} catch (error) {
  console.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
}
