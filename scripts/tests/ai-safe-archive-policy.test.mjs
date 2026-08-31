import assert from "node:assert/strict";
import test from "node:test";

import {
  assertNoDetectedSecrets,
  classifyAiSafePath,
  detectSecretCodes,
  hasPrivateDocumentStatus,
} from "../lib/ai-safe-archive-policy.mjs";

test("allows ordinary source and documentation paths", () => {
  assert.equal(
    classifyAiSafePath("apps/raven-studio/app/pages/index.vue").allowed,
    true,
  );
  assert.equal(classifyAiSafePath("brain/NOW.md").allowed, true);
});

test("rejects every required sensitive path class", () => {
  const paths = [
    "docs/statements/business/latest.pdf",
    "mediation-financial-export-2026-05-08/summary.csv",
    ".raven-private/maintenance/client.md",
    "mail-exports/thread/message.eml",
    "brain/source-material/live/raw.md",
    "apps/raven/.env.staging",
    "apps/raven/env.yaml",
    "apps/raven/nuxt.config.runtime.ts",
    "database.md",
    "surreal-mcp.toml",
    "apps/schema/docs/EXTENSIONS.md",
    "apps/schema/schema-docs/test/capabilities/helpers.ts",
    "history.txt",
    "local-data.sqlite3",
    "certificate.pem",
  ];

  for (const path of paths) {
    assert.equal(classifyAiSafePath(path).allowed, false, path);
  }
});

test("recognizes private document frontmatter", () => {
  assert.equal(
    hasPrivateDocumentStatus("---\nstatus: private\n---\n# Notes\n"),
    true,
  );
  assert.equal(
    hasPrivateDocumentStatus("---\nstatus: reference\n---\n# Notes\n"),
    false,
  );
});

test("detects planted dummy secret without returning its value", () => {
  const planted = `session_secret = "${"z".repeat(36)}"`;
  assert.deepEqual(detectSecretCodes(planted), ["credential-assignment"]);
  assert.throws(
    () =>
      assertNoDetectedSecrets([
        { path: "fixtures/planted-secret.txt", text: planted },
      ]),
    /fixtures\/planted-secret\.txt: credential-assignment/,
  );
});

test("does not reject environment references or documented placeholders", () => {
  const safe = [
    "sessionSecret: process.env.NUXT_SESSION_SECRET",
    'api_key = "YOUR_API_KEY_PLACEHOLDER"',
    'password = "changeme-example"',
  ].join("\n");
  assert.deepEqual(detectSecretCodes(safe), []);
});
