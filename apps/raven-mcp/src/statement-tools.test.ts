import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";
import {
  createStatementTruthTransportHandlers,
  RavenDomainError,
  statementTruthInputSchemas,
  type StatementTruthApi,
} from "@raven/domain/server";
import { createStatementMcpHandlers } from "./statement-tools.js";

test("Statement Truth tRPC and MCP peers are contract-equivalent for all 31 operations", async () => {
  const output = (operation: string, input: unknown = null) => ({
    operation,
    input,
  });
  const service = {
    stageStatementSource: async (input: unknown) =>
      output("stageStatementSource", input),
    listStatementProfiles: async () => output("listStatementProfiles"),
    detectStatementProfile: async (input: unknown) =>
      output("detectStatementProfile", input),
    previewStatementImport: async (input: unknown) =>
      output("previewStatementImport", input),
    validateStatementPreview: async (input: unknown) =>
      output("validateStatementPreview", input),
    commitStatementImport: async (input: unknown) =>
      output("commitStatementImport", input),
    listStatementImports: async (input: unknown) =>
      output("listStatementImports", input),
    getStatementImport: async (input: unknown) =>
      output("getStatementImport", input),
    listStatementRows: async (input: unknown) =>
      output("listStatementRows", input),
    getStatementRow: async (input: unknown) => output("getStatementRow", input),
    listStatementRowComponents: async (input: unknown) =>
      output("listStatementRowComponents", input),
    getStatementRowComponent: async (input: unknown) =>
      output("getStatementRowComponent", input),
    listStatementImportIssues: async (input: unknown) =>
      output("listStatementImportIssues", input),
    getStatementImportIssue: async (input: unknown) =>
      output("getStatementImportIssue", input),
    listStatementMatchCandidates: async (input: unknown) =>
      output("listStatementMatchCandidates", input),
    listStatementTransactionMatches: async (input: unknown) =>
      output("listStatementTransactionMatches", input),
    getStatementTransactionMatch: async (input: unknown) =>
      output("getStatementTransactionMatch", input),
    getStatementReconciliation: async (input: unknown) =>
      output("getStatementReconciliation", input),
    proposeStatementTransactionMatch: async (input: unknown) =>
      output("proposeStatementTransactionMatch", input),
    confirmStatementTransactionMatch: async (input: unknown) =>
      output("confirmStatementTransactionMatch", input),
    materializeStatementComponentTransaction: async (input: unknown) =>
      output("materializeStatementComponentTransaction", input),
    rejectStatementTransactionMatch: async (input: unknown) =>
      output("rejectStatementTransactionMatch", input),
    supersedeStatementTransactionMatch: async (input: unknown) =>
      output("supersedeStatementTransactionMatch", input),
    acknowledgeStatementIssue: async (input: unknown) =>
      output("acknowledgeStatementIssue", input),
    supersedeStatementImport: async (input: unknown) =>
      output("supersedeStatementImport", input),
    recalculateStatementReconciliation: async (input: unknown) =>
      output("recalculateStatementReconciliation", input),
    attestStatementReconciled: async (input: unknown) =>
      output("attestStatementReconciled", input),
    reopenStatementReconciliation: async (input: unknown) =>
      output("reopenStatementReconciliation", input),
    previewLegacyStatementResolution: async (input: unknown) =>
      output("previewLegacyStatementResolution", input),
    applyLegacyStatementResolution: async (input: unknown) =>
      output("applyLegacyStatementResolution", input),
    reverseLegacyStatementResolution: async (input: unknown) =>
      output("reverseLegacyStatementResolution", input),
  } as unknown as StatementTruthApi;
  const trpc = createStatementTruthTransportHandlers(service).trpc;
  const mcp = createStatementMcpHandlers(service);
  const source = {
    transport: "local_path" as const,
    originalPath: "/configured/fictional-inbox/source.pdf",
    mimeType: "application/pdf",
    sourceKind: "pdf" as const,
  };
  const selection = {
    sourceRef: "stmt-src-00000000-0000-4000-8000-000000000000",
    spaceKey: "fictional-space",
    accountKey: "fictional-account",
    profileId: "fnb-business" as const,
    profileVersion: "1" as const,
  };
  const validation = { ...selection, previewHash: "a".repeat(64) };
  const commit = {
    ...validation,
    idempotencyKey: "fictional-statement-001",
    channel: "mcp" as const,
  };
  const importFilter = {
    spaceKey: "fictional-space",
    accountKey: "fictional-account",
  };
  const importRead = { statementImportId: "statementImport:fictional" };
  const rowRead = { statementRowId: "statementRow:fictional" };
  const components = { statementRowId: "statementRow:fictional" };
  const componentRead = {
    statementRowComponentId: "statementRowComponent:fictional",
  };
  const issueRead = { statementIssueId: "statementIssue:fictional" };

  assert.deepEqual(
    await mcp.stage_statement_source(source),
    await trpc.stageStatementSource(source),
  );
  assert.deepEqual(
    await mcp.list_statement_profiles(),
    await trpc.listStatementProfiles(),
  );
  assert.deepEqual(
    await mcp.detect_statement_profile({ sourceRef: selection.sourceRef }),
    await trpc.detectStatementProfile({ sourceRef: selection.sourceRef }),
  );
  assert.deepEqual(
    await mcp.preview_statement_import(selection),
    await trpc.previewStatementImport(selection),
  );
  assert.deepEqual(
    await mcp.validate_statement_preview(validation),
    await trpc.validateStatementPreview(validation),
  );
  assert.deepEqual(
    await mcp.commit_statement_import(commit),
    await trpc.commitStatementImport(commit),
  );
  assert.deepEqual(
    await mcp.list_statement_imports(importFilter),
    await trpc.listStatementImports(importFilter),
  );
  assert.deepEqual(
    await mcp.get_statement_import(importRead),
    await trpc.getStatementImport(importRead),
  );
  assert.deepEqual(
    await mcp.list_statement_rows(importRead),
    await trpc.listStatementRows(importRead),
  );
  assert.deepEqual(
    await mcp.get_statement_row(rowRead),
    await trpc.getStatementRow(rowRead),
  );
  assert.deepEqual(
    await mcp.list_statement_row_components(components),
    await trpc.listStatementRowComponents(components),
  );
  assert.deepEqual(
    await mcp.get_statement_row_component(componentRead),
    await trpc.getStatementRowComponent(componentRead),
  );
  assert.deepEqual(
    await mcp.list_statement_import_issues(importRead),
    await trpc.listStatementImportIssues(importRead),
  );
  assert.deepEqual(
    await mcp.get_statement_import_issue(issueRead),
    await trpc.getStatementImportIssue(issueRead),
  );
  const componentIds = ["statementRowComponent:fictional"];
  const candidateInput = { ...importRead, componentIds };
  const matchesInput = { ...importRead, includeSuperseded: true };
  const matchRead = {
    statementTransactionMatchId: "statementTransactionMatch:fictional",
  };
  const commandMeta = {
    idempotencyKey: "fictional-st02-command",
    channel: "mcp" as const,
  };
  const reconciliationExpectation = {
    expectedReconciliationRevision: 1,
    expectedReconciliationHash: "b".repeat(64),
  };
  const proposeInput = {
    ...commandMeta,
    ...candidateInput,
    transactionId: "transaction:fictional",
    ...reconciliationExpectation,
  };
  const revisionInput = {
    ...commandMeta,
    ...matchRead,
    expectedRevision: 1,
    ...reconciliationExpectation,
  };
  const materializeInput = {
    ...commandMeta,
    ...candidateInput,
    ...reconciliationExpectation,
  };
  const rejectInput = { ...revisionInput, reason: "Fictional rejection" };
  const supersedeMatchInput = {
    ...proposeInput,
    ...matchRead,
    expectedRevision: 1,
    reason: "Fictional replacement",
  };
  const acknowledgeInput = {
    ...commandMeta,
    ...issueRead,
    expectedRevision: 1,
    note: "Fictional acknowledgement",
    ...reconciliationExpectation,
  };
  const supersedeImportInput = {
    ...commandMeta,
    ...importRead,
    expectedSourceRevision: 1,
    expectedReconciliationRevision: 1,
    expectedReconciliationHash: "b".repeat(64),
    replacement: validation,
    reason: "Fictional source replacement",
  };
  const recalculateInput = {
    ...commandMeta,
    ...importRead,
    expectedRevision: 1,
    expectedHash: "b".repeat(64),
  };
  const attestInput = {
    ...commandMeta,
    ...importRead,
    expectedRevision: 1,
    calculationHash: "b".repeat(64),
  };
  const reopenInput = {
    ...commandMeta,
    ...importRead,
    expectedRevision: 1,
    calculationHash: "b".repeat(64),
    reason: "Fictional reopening",
  };
  const legacyPreviewInput = {
    ...validation,
    legacyStatementImportId: "statementImport:legacy-fictional",
  };
  const legacyApplyInput = {
    ...legacyPreviewInput,
    previewIdentityHash: "c".repeat(64),
    expectedDatabaseFingerprint: "d".repeat(64),
    expectedSourceIdentityHash: "e".repeat(64),
    expectedLegacyEvidenceHash: "f".repeat(64),
    expectedAccountContextFingerprint: "1".repeat(64),
    expectedCrosswalkHash: "2".repeat(64),
    expectedRevisionClaimHash: "3".repeat(64),
    strategy: "A" as const,
    decisions: [],
    idempotencyKey: "fictional-hp04-apply",
    channel: "mcp" as const,
  };
  const legacyReverseInput = {
    statementLegacyResolutionId: "statementLegacyResolution:fictional",
    expectedDatabaseFingerprint: "d".repeat(64),
    expectedTargetRequestHash: "4".repeat(64),
    expectedAuthorityHash: "5".repeat(64),
    idempotencyKey: "fictional-hp04-reverse",
    channel: "mcp" as const,
  };
  const parityPairs: Array<[() => Promise<unknown>, () => Promise<unknown>]> = [
    [
      () => mcp.list_statement_match_candidates(candidateInput),
      () => trpc.listStatementMatchCandidates(candidateInput),
    ],
    [
      () => mcp.list_statement_transaction_matches(matchesInput),
      () => trpc.listStatementTransactionMatches(matchesInput),
    ],
    [
      () => mcp.get_statement_transaction_match(matchRead),
      () => trpc.getStatementTransactionMatch(matchRead),
    ],
    [
      () => mcp.get_statement_reconciliation(importRead),
      () => trpc.getStatementReconciliation(importRead),
    ],
    [
      () => mcp.propose_statement_transaction_match(proposeInput),
      () => trpc.proposeStatementTransactionMatch(proposeInput),
    ],
    [
      () => mcp.confirm_statement_transaction_match(revisionInput),
      () => trpc.confirmStatementTransactionMatch(revisionInput),
    ],
    [
      () => mcp.materialize_statement_component_transaction(materializeInput),
      () => trpc.materializeStatementComponentTransaction(materializeInput),
    ],
    [
      () => mcp.reject_statement_transaction_match(rejectInput),
      () => trpc.rejectStatementTransactionMatch(rejectInput),
    ],
    [
      () => mcp.supersede_statement_transaction_match(supersedeMatchInput),
      () => trpc.supersedeStatementTransactionMatch(supersedeMatchInput),
    ],
    [
      () => mcp.acknowledge_statement_issue(acknowledgeInput),
      () => trpc.acknowledgeStatementIssue(acknowledgeInput),
    ],
    [
      () => mcp.supersede_statement_import(supersedeImportInput),
      () => trpc.supersedeStatementImport(supersedeImportInput),
    ],
    [
      () => mcp.recalculate_statement_reconciliation(recalculateInput),
      () => trpc.recalculateStatementReconciliation(recalculateInput),
    ],
    [
      () => mcp.attest_statement_reconciled(attestInput),
      () => trpc.attestStatementReconciled(attestInput),
    ],
    [
      () => mcp.reopen_statement_reconciliation(reopenInput),
      () => trpc.reopenStatementReconciliation(reopenInput),
    ],
    [
      () => mcp.preview_legacy_statement_resolution(legacyPreviewInput),
      () => trpc.previewLegacyStatementResolution(legacyPreviewInput),
    ],
    [
      () => mcp.apply_legacy_statement_resolution(legacyApplyInput),
      () => trpc.applyLegacyStatementResolution(legacyApplyInput),
    ],
    [
      () => mcp.reverse_legacy_statement_resolution(legacyReverseInput),
      () => trpc.reverseLegacyStatementResolution(legacyReverseInput),
    ],
  ];
  for (const [mcpCall, trpcCall] of parityPairs) {
    assert.deepEqual(await mcpCall(), await trpcCall());
  }
  assert.equal(Object.keys(trpc).length, 31);
  assert.equal(Object.keys(mcp).length, 31);
  const inventory = JSON.parse(
    await readFile(
      new URL(
        "../../../docs/operations/raven-statement-truth-operations-v0.1.json",
        import.meta.url,
      ),
      "utf8",
    ),
  ) as {
    operationCount: number;
    operations: Array<{
      name: string;
      classification: string;
      requiredInputs: string[];
      outputs: string[];
      errors: string[];
    }>;
  };
  assert.equal(inventory.operationCount, 31);
  assert.deepEqual(
    inventory.operations.map((operation) => operation.name).sort(),
    Object.keys(mcp).sort(),
  );
  assert.equal(
    inventory.operations.every(
      (operation) =>
        [
          "no-write",
          "source-write",
          "resolution-write",
          "attestation-write",
          "resolution-read",
          "authority-write",
        ].includes(operation.classification) &&
        Array.isArray(operation.requiredInputs) &&
        operation.outputs.length > 0 &&
        Array.isArray(operation.errors),
    ),
    true,
  );
});

test("shared Statement Truth schemas and transport peers reject representative invalid input equivalently", async () => {
  const valid = {
    sourceRef: "stmt-src-fictional",
    spaceKey: "fictional-space",
    accountKey: "fictional-account",
    profileId: "fnb-business" as const,
    profileVersion: "1" as const,
    previewHash: "a".repeat(64),
    idempotencyKey: "fictional-statement-002",
  };
  assert.equal(
    statementTruthInputSchemas.commitClient.safeParse(valid).success,
    true,
  );
  const invalid = {
    ...valid,
    previewHash: "short",
    unreviewedMeaning: true,
  };
  const first = statementTruthInputSchemas.commitClient.safeParse(invalid);
  const second = statementTruthInputSchemas.commitClient.safeParse(invalid);
  assert.equal(first.success, false);
  assert.deepEqual(
    first.success ? [] : first.error.issues.map((item) => item.code),
    second.success ? [] : second.error.issues.map((item) => item.code),
  );
  const forgedMatchEvidence = statementTruthInputSchemas.proposeMatch.safeParse(
    {
      idempotencyKey: "fictional-forged-match",
      statementImportId: "statementImport:fictional",
      componentIds: ["statementRowComponent:fictional"],
      transactionId: "transaction:fictional",
      expectedReconciliationRevision: null,
      expectedReconciliationHash: null,
      method: "explicit",
      reasonCodes: ["EXPLICIT_OPERATOR_SELECTION"],
      confidence: 1,
    },
  );
  assert.equal(forgedMatchEvidence.success, false);

  const failure = new RavenDomainError(
    "STATEMENT_PREVIEW_STALE",
    "Fictional stale preview",
  );
  const service = new Proxy(
    {},
    {
      get: () => async () => {
        throw failure;
      },
    },
  ) as StatementTruthApi;
  const trpc = createStatementTruthTransportHandlers(service).trpc;
  const mcp = createStatementMcpHandlers(service);
  await assert.rejects(
    trpc.getStatementImport({ statementImportId: "statementImport:fictional" }),
    (error: unknown) => error === failure,
  );
  await assert.rejects(
    mcp.get_statement_import({
      statementImportId: "statementImport:fictional",
    }),
    (error: unknown) => error === failure,
  );
});
