import { createHash } from "node:crypto";
import { spawnSync } from "node:child_process";
import { existsSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { format as formatDocument } from "prettier";
import {
  MODEL_TRUTH_CLASSES,
  RUNTIME_EDGES,
  SLICE_MODELS,
  TRUTH_CLASSES,
} from "./raven-data-atlas/config.mjs";

export const GENERATED_BEGIN = "<!-- BEGIN GENERATED DATA ATLAS -->";
export const GENERATED_END = "<!-- END GENERATED DATA ATLAS -->";

const SCRIPT_PATH = fileURLToPath(import.meta.url);
const REPO_ROOT = path.resolve(path.dirname(SCRIPT_PATH), "..");
const DEFAULT_GRAPH_PATH = path.resolve(
  process.env.RAVEN_SCHEMA_GRAPH_PATH ??
    path.join(REPO_ROOT, "apps/schema/config/graph.mpdg"),
);
const DEFAULT_OUTPUT_PATH = path.join(
  REPO_ROOT,
  "docs/architecture/raven-data-atlas.md",
);
const TICK = String.fromCharCode(96);
const FENCE = TICK.repeat(3);

function compareText(left, right) {
  return left < right ? -1 : left > right ? 1 : 0;
}

function argument(name) {
  const index = process.argv.indexOf(name);
  return index >= 0 ? process.argv[index + 1] : undefined;
}

function sha256(value) {
  return createHash("sha256").update(value).digest("hex");
}

function code(value) {
  return TICK + String(value ?? "") + TICK;
}

export function escapeMarkdown(value) {
  return String(value ?? "")
    .replaceAll("|", "\\|")
    .replace(/\r?\n/g, " ")
    .trim();
}

export function escapeMermaidLabel(value) {
  return String(value ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll('"', "&quot;")
    .replaceAll("|", "&#124;")
    .replace(/\r?\n/g, " ")
    .trim();
}

export function mermaidNodeId(value) {
  const source = String(value ?? "");
  const safe =
    source
      .normalize("NFKD")
      .replace(/[^A-Za-z0-9_]+/g, "_")
      .replace(/^_+|_+$/g, "")
      .replace(/_+/g, "_") || "node";
  return `m_${safe}_${sha256(source).slice(0, 8)}`;
}

function recordTarget(type) {
  const normalized = String(type ?? "").trim();
  if (!normalized.startsWith("record<") || !normalized.endsWith(">")) {
    return undefined;
  }
  const target = normalized.slice("record<".length, -1).trim();
  return target || undefined;
}

export function extractRecordReferences(fields, sourceModel, prefix = "") {
  const references = [];
  for (const field of fields ?? []) {
    const fieldPath = prefix ? `${prefix}.${field.name}` : field.name;
    const target = recordTarget(field.type);
    if (target) {
      references.push({
        field: fieldPath,
        target,
        required: Boolean(field.required),
        nullable: Boolean(field.nullable),
        selfReference: target === sourceModel,
      });
    }
    if (field.children?.length) {
      references.push(
        ...extractRecordReferences(field.children, sourceModel, fieldPath),
      );
    }
  }
  return references.sort((left, right) => compareText(left.field, right.field));
}

export function identityFromParsedTable(table, spec) {
  const identity = spec?.id?.structure;
  if (identity) return String(identity);
  const idField = table?.fields?.find((field) => field.isId);
  return String(idField?.idSource ?? idField?.defaultValue ?? "unknown");
}

function truthClassFor(model) {
  return MODEL_TRUTH_CLASSES[model] ?? "unclassified";
}

function truthClassLabel(id) {
  return (
    TRUTH_CLASSES.find((item) => item.id === id)?.label ??
    "Unclassified (review required)"
  );
}

function normalizeModels(models) {
  return [...models]
    .map((model) => ({
      ...model,
      truthClass: truthClassFor(model.model),
      references: [...(model.references ?? [])].sort((left, right) =>
        compareText(left.field, right.field),
      ),
    }))
    .sort((left, right) => compareText(left.label, right.label));
}

function assertRegistryIntegrity(models) {
  const modelNames = new Set(models.map((model) => model.model));
  for (const edge of RUNTIME_EDGES) {
    if (!modelNames.has(edge.from) || !modelNames.has(edge.to)) {
      throw new Error(
        `Runtime edge ${edge.table} references missing model ${edge.from} -> ${edge.to}`,
      );
    }
  }
}

export function renderModelCatalog(models) {
  const lines = [
    "| Model | Table | Truth class | Identity expression | Authority | Direct references | Description |",
    "| --- | --- | --- | --- | --- | --- | --- |",
  ];
  for (const model of normalizeModels(models)) {
    const references = model.references.length
      ? model.references
          .map(
            (reference) =>
              code(reference.field) +
              " -> " +
              code(reference.target) +
              ` (${reference.required ? "required" : "optional"})`,
          )
          .join("<br>")
      : "None";
    lines.push(
      `| ${escapeMarkdown(model.label)} | ${code(escapeMarkdown(model.model))} | ${truthClassLabel(model.truthClass)} | ${code(escapeMarkdown(model.identity))} | ${code(escapeMarkdown(model.authority))} (MPDG) | ${references} | ${escapeMarkdown(model.description)} |`,
    );
  }
  return lines.join("\n");
}

export function renderReferenceTable(models) {
  const rows = normalizeModels(models)
    .flatMap((model) =>
      model.references.map((reference) => ({
        sourceLabel: model.label,
        source: model.model,
        ...reference,
      })),
    )
    .sort((left, right) =>
      compareText(
        `${left.source}.${left.field}`,
        `${right.source}.${right.field}`,
      ),
    );
  const lines = [
    "| Source model | Field | Target model | State | Self-reference |",
    "| --- | --- | --- | --- | --- |",
  ];
  for (const reference of rows) {
    lines.push(
      `| ${escapeMarkdown(reference.sourceLabel)} (${code(escapeMarkdown(reference.source))}) | ${code(escapeMarkdown(reference.field))} | ${code(escapeMarkdown(reference.target))} | ${reference.required ? "Required" : "Optional"}${reference.nullable ? ", nullable" : ""} | ${reference.selfReference ? "Yes" : "No"} |`,
    );
  }
  return lines.join("\n");
}

export function renderRuntimeEdgesTable(edges = RUNTIME_EDGES) {
  const lines = [
    "| Runtime relation table | From | To | Registry evidence |",
    "| --- | --- | --- | --- |",
  ];
  for (const edge of [...edges].sort((left, right) =>
    compareText(left.table, right.table),
  )) {
    lines.push(
      `| ${code(escapeMarkdown(edge.table))} | ${code(escapeMarkdown(edge.from))} | ${code(escapeMarkdown(edge.to))} | ${code(escapeMarkdown(edge.source))} |`,
    );
  }
  return lines.join("\n");
}

function renderTruthClassGroups(models) {
  const normalized = normalizeModels(models);
  const classes = [
    ...TRUTH_CLASSES,
    ...(normalized.some((model) => model.truthClass === "unclassified")
      ? [{ id: "unclassified", label: "Unclassified (review required)" }]
      : []),
  ];
  return classes
    .map((truthClass) => {
      const members = normalized
        .filter((model) => model.truthClass === truthClass.id)
        .map((model) => `${code(model.label)} (${code(model.model)})`);
      return `- **${truthClass.label}:** ${
        members.length ? members.join(", ") : "None"
      }`;
    })
    .join("\n");
}

export function renderMermaidGraph(models, includedModels) {
  const normalized = normalizeModels(models);
  const allowed = includedModels
    ? new Set(includedModels)
    : new Set(normalized.map((model) => model.model));
  const visibleModels = normalized.filter((model) => allowed.has(model.model));
  const visibleNames = new Set(visibleModels.map((model) => model.model));
  const lines = [
    "flowchart LR",
    "  classDef context fill:#101418,stroke:#8b949e,color:#fff",
    "  classDef observed fill:#071a12,stroke:#3fb950,color:#fff",
    "  classDef meaning_review fill:#17131f,stroke:#a371f7,color:#fff",
    "  classDef accepted_future fill:#171408,stroke:#d29922,color:#fff",
    "  classDef audit fill:#111827,stroke:#58a6ff,color:#fff",
    "  classDef derived fill:#171717,stroke:#6e7681,color:#ddd",
    "  classDef business_reference fill:#1b1111,stroke:#f85149,color:#fff",
    "  classDef unclassified fill:#111,stroke:#f0f,color:#fff,stroke-dasharray: 5 5",
  ];

  for (const model of visibleModels) {
    lines.push(
      `  ${mermaidNodeId(model.model)}["${escapeMermaidLabel(model.label)} (${escapeMermaidLabel(model.model)})"]:::${model.truthClass}`,
    );
  }

  const directReferences = visibleModels
    .flatMap((model) =>
      model.references
        .filter((reference) => visibleNames.has(reference.target))
        .map((reference) => ({ source: model.model, ...reference })),
    )
    .sort((left, right) =>
      compareText(
        `${left.source}.${left.field}`,
        `${right.source}.${right.field}`,
      ),
    );

  for (const reference of directReferences) {
    lines.push(
      `  ${mermaidNodeId(reference.source)} -->|${escapeMermaidLabel(reference.field)} ${reference.required ? "required" : "optional"}| ${mermaidNodeId(reference.target)}`,
    );
  }

  for (const edge of [...RUNTIME_EDGES]
    .filter((item) => visibleNames.has(item.from) && visibleNames.has(item.to))
    .sort((left, right) => compareText(left.table, right.table))) {
    lines.push(
      `  ${mermaidNodeId(edge.from)} -.->|runtime: ${escapeMermaidLabel(edge.table)}| ${mermaidNodeId(edge.to)}`,
    );
  }

  return lines.join("\n");
}

export function renderGeneratedAtlas({
  models,
  graphChecksum,
  parserWarnings = 0,
}) {
  const normalized = normalizeModels(models);
  assertRegistryIntegrity(normalized);
  const referenceCount = normalized.reduce(
    (total, model) => total + model.references.length,
    0,
  );
  const selfReferenceCount = normalized.reduce(
    (total, model) =>
      total +
      model.references.filter((reference) => reference.selfReference).length,
    0,
  );
  const sections = [
    "_Generated deterministically from schema authority. Edit the human-maintained section outside these markers._",
    "",
    "## Generated Source Summary",
    "",
    "- Schema: " +
      code("apps/schema/config/graph.mpdg") +
      " (SHA-256 " +
      code(graphChecksum) +
      ").",
    "- Parser: " +
      code("apps/schema/scripts/mpdg-to-spec.ts") +
      " (" +
      code("parseFile") +
      " + " +
      code("buildSpec") +
      ").",
    `- Models: ${normalized.length}. Direct record references: ${referenceCount}. Self-references: ${selfReferenceCount}.`,
    `- Runtime relation-table edges: ${RUNTIME_EDGES.length}. Parser warnings: ${parserWarnings}.`,
    "- Relationship legend: solid arrows are direct MPDG " +
      code("record<...>") +
      " fields; dashed arrows are reviewed runtime relation-table edges.",
    "",
    "## Truth-Class Groups",
    "",
    renderTruthClassGroups(normalized),
    "",
    "## Generated Model Catalog",
    "",
    renderModelCatalog(normalized),
    "",
    "## Direct Record References",
    "",
    renderReferenceTable(normalized),
    "",
    "## Runtime Relation-Table Registry",
    "",
    "These edges are created by the import traversal flow and are not declared as canonical MPDG record fields.",
    "",
    renderRuntimeEdgesTable(),
    "",
    "## Whole Graph",
    "",
    FENCE + "mermaid",
    renderMermaidGraph(normalized),
    FENCE,
  ];

  for (const [slice, sliceModels] of Object.entries(SLICE_MODELS)) {
    sections.push(
      "",
      `## ${slice} Slice`,
      "",
      FENCE + "mermaid",
      renderMermaidGraph(normalized, sliceModels),
      FENCE,
    );
  }

  return sections.join("\n").trim() + "\n";
}

export function replaceGeneratedBlock(document, generated) {
  const begin = document.indexOf(GENERATED_BEGIN);
  const end = document.indexOf(GENERATED_END);
  if (begin < 0 || end < 0 || end < begin) {
    throw new Error(
      `Atlas document must contain ${GENERATED_BEGIN} and ${GENERATED_END}`,
    );
  }
  const before = document.slice(0, begin + GENERATED_BEGIN.length);
  const after = document.slice(end);
  return before + "\n\n" + generated.trim() + "\n\n" + after;
}

export function loadSchemaModels(graphPath = DEFAULT_GRAPH_PATH) {
  const schemaDirectory = path.resolve(path.dirname(graphPath), "..");
  const reader = path.join(REPO_ROOT, "scripts/raven-data-atlas/read-mpdg.ts");
  const parser = path.join(schemaDirectory, "scripts/mpdg-to-spec.ts");
  const result = spawnSync(
    "pnpm",
    [
      "-C",
      schemaDirectory,
      "exec",
      "tsx",
      reader,
      "--graph",
      graphPath,
      "--parser",
      parser,
    ],
    {
      cwd: REPO_ROOT,
      encoding: "utf8",
      env: {
        ...process.env,
        PNPM_DISABLE_SELF_UPDATE_CHECK: "1",
      },
    },
  );
  if (result.error) throw result.error;
  if (result.status !== 0) {
    throw new Error(
      `Canonical MPDG parser failed (${result.status}): ${result.stderr.trim()}`,
    );
  }
  try {
    return JSON.parse(result.stdout);
  } catch (error) {
    throw new Error(
      `Canonical MPDG parser returned invalid JSON: ${error.message}\n${result.stdout}`,
    );
  }
}

export async function generateDocument({
  graphPath,
  outputPath,
  check = false,
}) {
  if (!existsSync(graphPath)) {
    throw new Error(`Schema graph not found: ${graphPath}`);
  }
  if (!existsSync(outputPath)) {
    throw new Error(`Atlas document scaffold not found: ${outputPath}`);
  }
  const graphSource = readFileSync(graphPath, "utf8");
  const parsed = loadSchemaModels(graphPath);
  const generated = renderGeneratedAtlas({
    models: parsed.models,
    graphChecksum: sha256(graphSource),
    parserWarnings: parsed.audit?.warnings ?? 0,
  });
  const current = readFileSync(outputPath, "utf8");
  const formattedGenerated = await formatDocument(generated, {
    parser: "markdown",
    proseWrap: "preserve",
  });
  const next = replaceGeneratedBlock(current, formattedGenerated);

  if (check) {
    if (current !== next) {
      throw new Error(
        `Raven Data Atlas is stale. Run pnpm docs:data-atlas and commit ${path.relative(REPO_ROOT, outputPath)}.`,
      );
    }
    return { changed: false, modelCount: parsed.models.length, outputPath };
  }

  writeFileSync(outputPath, next, "utf8");
  return {
    changed: current !== next,
    modelCount: parsed.models.length,
    outputPath,
  };
}

async function main() {
  const check = process.argv.includes("--check");
  const graphPath = path.resolve(
    argument("--graph") ??
      process.env.RAVEN_SCHEMA_GRAPH_PATH ??
      DEFAULT_GRAPH_PATH,
  );
  const outputPath = path.resolve(argument("--output") ?? DEFAULT_OUTPUT_PATH);
  const result = await generateDocument({ graphPath, outputPath, check });
  const relativeOutput = path.relative(REPO_ROOT, result.outputPath);
  console.log(
    check
      ? `Raven Data Atlas is current (${result.modelCount} models): ${relativeOutput}`
      : `Raven Data Atlas generated (${result.modelCount} models): ${relativeOutput}`,
  );
}

if (process.argv[1] && path.resolve(process.argv[1]) === SCRIPT_PATH) {
  main().catch((error) => {
    console.error(error.message);
    process.exitCode = 1;
  });
}
