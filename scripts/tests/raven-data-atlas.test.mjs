import assert from "node:assert/strict";
import test from "node:test";
import {
  escapeMermaidLabel,
  extractRecordReferences,
  identityFromParsedTable,
  loadSchemaModels,
  mermaidNodeId,
  replaceGeneratedBlock,
  renderGeneratedAtlas,
  renderMermaidGraph,
  renderModelCatalog,
  renderRuntimeEdgesTable,
} from "../generate-raven-data-atlas.mjs";
import { RUNTIME_EDGES } from "../raven-data-atlas/config.mjs";

const fixtureModels = [
  {
    label: "FinancialSpace",
    model: "financialSpace",
    description: "Context",
    authority: "source",
    identity: "key",
    references: [],
  },
  {
    label: "Account",
    model: "account",
    description: "Account",
    authority: "source",
    identity: "stringID<space, key>",
    references: [
      {
        field: "space",
        target: "financialSpace",
        required: true,
        nullable: false,
        selfReference: false,
      },
    ],
  },
];

const deterministicModels = [
  ...fixtureModels,
  ...[
    "statementImport",
    "statementRow",
    "statementRowComponent",
    "statementIssue",
    "transaction",
    "merchant",
    "category",
    "clarificationTask",
  ].map((model) => ({
    label: model,
    model,
    description: model,
    authority: "source",
    identity: "key",
    references: [],
  })),
];

test("extracts required and optional record references from parsed fields", () => {
  const references = extractRecordReferences(
    [
      { name: "space", type: "record<financialSpace>", required: true },
      { name: "category", type: "record<category>", required: false },
      { name: "title", type: "string", required: true },
    ],
    "transaction",
  );
  assert.deepEqual(references, [
    {
      field: "category",
      target: "category",
      required: false,
      nullable: false,
      selfReference: false,
    },
    {
      field: "space",
      target: "financialSpace",
      required: true,
      nullable: false,
      selfReference: false,
    },
  ]);
});

test("uses canonical composite identity metadata", () => {
  assert.equal(
    identityFromParsedTable(
      { fields: [{ isId: true, idSource: "stringID<space, key>" }] },
      { id: { structure: "stringID<space, key>" } },
    ),
    "stringID<space, key>",
  );
});

test("marks self-references explicitly", () => {
  const [reference] = extractRecordReferences(
    [{ name: "parentCategory", type: "record<category>" }],
    "category",
  );
  assert.equal(reference.selfReference, true);
  assert.equal(reference.field, "parentCategory");
});

test("renders models with no direct references", () => {
  const catalog = renderModelCatalog([fixtureModels[0]]);
  assert.match(catalog, /FinancialSpace/);
  assert.match(catalog, /\| None \|/);
});

test("renders every reviewed runtime relation-table edge", () => {
  const table = renderRuntimeEdgesTable();
  for (const edge of RUNTIME_EDGES) {
    assert.match(table, new RegExp(edge.table));
  }
});

test("generated output is deterministic", () => {
  const input = { models: deterministicModels, graphChecksum: "abc123" };
  assert.equal(renderGeneratedAtlas(input), renderGeneratedAtlas(input));
});

test("regeneration replaces only the generated block", () => {
  const document = [
    "Human prefix",
    "<!-- BEGIN GENERATED DATA ATLAS -->",
    "stale generated content",
    "<!-- END GENERATED DATA ATLAS -->",
    "Human suffix",
  ].join("\n");
  const regenerated = replaceGeneratedBlock(
    document,
    "fresh generated content",
  );
  assert.match(regenerated, /^Human prefix/);
  assert.match(regenerated, /fresh generated content/);
  assert.match(regenerated, /Human suffix$/);
  assert.doesNotMatch(regenerated, /stale generated content/);
});

test("Mermaid IDs and labels are safe and deterministic", () => {
  const id = mermaidNodeId('123 account / "primary"');
  assert.match(id, /^[A-Za-z_][A-Za-z0-9_]*$/);
  assert.equal(id, mermaidNodeId('123 account / "primary"'));
  assert.equal(escapeMermaidLabel('A | "B"'), "A &#124; &quot;B&quot;");
  const graph = renderMermaidGraph(fixtureModels);
  assert.match(graph, /^flowchart LR/m);
  assert.doesNotMatch(graph, /123 account/);
});

test("canonical MPDG parser supplies Raven models, references, and identities", () => {
  const parsed = loadSchemaModels();
  const account = parsed.models.find((model) => model.model === "account");
  const category = parsed.models.find((model) => model.model === "category");
  const user = parsed.models.find((model) => model.model === "u");
  assert.equal(account.identity, "stringID<space, key>");
  assert.equal(
    account.references.find((reference) => reference.field === "space")
      .required,
    true,
  );
  assert.equal(
    category.references.find(
      (reference) => reference.field === "parentCategory",
    ).selfReference,
    true,
  );
  assert.deepEqual(user.references, []);
});
