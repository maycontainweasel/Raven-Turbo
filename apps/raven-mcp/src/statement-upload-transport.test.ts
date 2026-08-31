import assert from "node:assert/strict";
import { mkdir, rm } from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import test from "node:test";
import {
  createLocalStatementSourceVault,
  statementTruthInputSchemas,
} from "@raven/domain/server";
import superjson from "superjson";

test("fictional multi-page upload survives client serialization, server validation, and private vault staging", async () => {
  const root = path.join(
    os.tmpdir(),
    `raven-statement-upload-${crypto.randomUUID()}`,
  );
  const vaultRoot = path.join(root, "vault");
  const inbox = path.join(root, "inbox");
  await mkdir(inbox, { recursive: true, mode: 0o700 });
  try {
    const page = Buffer.from(
      "%PDF-1.7\n/Type /Page\nFictional statement page\n",
    );
    const originalBytes = new Uint8Array(
      Buffer.concat(Array.from({ length: 12_000 }, () => page)),
    );
    const extractionAssistBytes = new Uint8Array(
      Buffer.from(
        JSON.stringify({
          contractVersion: "statement-extraction-input-v0.1",
          fictional: true,
        }),
      ),
    );
    const clientPayload = {
      originalBytes,
      mimeType: "application/pdf",
      sourceKind: "pdf" as const,
      extractionAssistBytes,
      extractionAssistMimeType: "application/json" as const,
    };
    const serverPayload = statementTruthInputSchemas.stageUpload.parse(
      superjson.parse(superjson.stringify(clientPayload)),
    );
    const vault = createLocalStatementSourceVault({
      vaultRoot,
      allowedInboxRoots: [inbox],
      maxSourceBytes: 2_000_000,
    });
    const descriptor = await vault.stageUpload({
      transport: "upload",
      ...serverPayload,
    });
    const bundle = await vault.readBundle(descriptor.sourceRef);
    assert.equal(bundle.originalBytes.byteLength, originalBytes.byteLength);
    assert.equal(
      bundle.extractionAssistBytes?.byteLength,
      extractionAssistBytes.byteLength,
    );
    assert.doesNotMatch(JSON.stringify(descriptor), new RegExp(root));
    assert.doesNotMatch(descriptor.sourceRef, /[\\/]/);
  } finally {
    await rm(root, { recursive: true, force: true });
  }
});
