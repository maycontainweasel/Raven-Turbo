import assert from "node:assert/strict";
import test from "node:test";

import type {
  StatementLegacyApplyDraft,
  StatementLegacyReverseDraft,
} from "@raven/domain/server";
import { createSurrealStatementLegacyResolutionRepository } from "./statement-legacy-resolution-repository.js";

const H = "a".repeat(64);

function operation(command: string) {
  return {
    key: `${command}-key`,
    command,
    idempotencyKey: `${command}-fictional-intent`,
    requestHash: H,
    channel: "mcp",
    actorId: "fictional-operator",
    recordedAt: "2026-08-11T00:00:00.000Z",
    warningCodes: [],
    auditMeta: { workline: "HP-04" },
  };
}

function rawOperation(command: string) {
  return {
    id: `financialOperation:${command}-key`,
    key: `${command}-key`,
    command,
    idempotencyKey: `${command}-fictional-intent`,
    requestHash: H,
    channel: "mcp",
    actorId: "fictional-operator",
    status: "applied",
    resultRefs: [`statementLegacyResolution:${command}`],
    warningCodes: [],
    auditMeta: { workline: "HP-04" },
    recordedAt: "2026-08-11T00:00:00.000Z",
    completedAt: "2026-08-11T00:00:00.000Z",
  };
}

function rawResolution(resolutionType: "apply" | "reversal") {
  return {
    id: `statementLegacyResolution:${resolutionType}`,
    key: resolutionType,
    space: "financialSpace:fictional",
    account: "account:fictional",
    legacyStatementImport: "statementImport:legacy",
    canonicalStatementImport: "statementImport:canonical",
    resolutionType,
    strategy: "A",
    authorityEffect:
      resolutionType === "apply" ? "activate_canonical" : "restore_previous",
    previousLegacySourceState: "legacy",
    previousSourceClaimState: "absent",
    previousPeriodClaimState: "absent",
    databaseFingerprint: H,
    sourceIdentityHash: H,
    canonicalPreviewHash: H,
    legacyEvidenceHash: H,
    accountContextFingerprint: H,
    crosswalkHash: H,
    expectedRevisionClaimHash: H,
    resultAuthorityHash: H,
    aggregateCounts: {},
    idempotencyKey: `${resolutionType}-fictional-intent`,
    requestHash: H,
    channel: "mcp",
    actorId: "fictional-operator",
    operation: `financialOperation:${resolutionType}-key`,
    recordedAt: "2026-08-11T00:00:00.000Z",
  };
}

function rawImport(sourceState = "committed") {
  return {
    id: "statementImport:canonical",
    space: "financialSpace:fictional",
    account: "account:fictional",
    key: "canonical",
    originalFileSha256: H,
    canonicalExtractionSha256: H,
    previewHash: H,
    sourceFormat: "pdf",
    sourceMimeType: "application/pdf",
    sourceByteSize: 1,
    profileId: "fnb-business",
    profileVersion: "1",
    extractorVersion: "1",
    validationRulesetVersion: "1",
    periodStart: "2026-06-01",
    periodEnd: "2026-06-30",
    currency: "ZAR",
    accountContextFingerprint: H,
    sourceState,
    importedAt: "2026-08-11T00:00:00.000Z",
    committedAt: "2026-08-11T00:00:00.000Z",
    rowCount: 1,
    componentCount: 1,
    issueCount: 0,
    revision: 1,
  };
}

function rawReconciliation() {
  return {
    id: "statementReconciliation:current",
    key: "current",
    space: "financialSpace:fictional",
    account: "account:fictional",
    statementImport: "statementImport:canonical",
    periodStart: "2026-06-01",
    periodEnd: "2026-06-30",
    currency: "ZAR",
    signedMovementEffectMinor: -5_000,
    printedRowCount: 1,
    extractedRowCount: 1,
    movementComponentCount: 1,
    informationalComponentCount: 0,
    pendingCount: 0,
    proposedCount: 0,
    confirmedExistingCount: 1,
    newlyMaterializedCount: 0,
    unresolvedCount: 0,
    transferCandidateCount: 0,
    activeIssueCount: 0,
    blockingIssueCount: 0,
    calculationState: "balanced",
    coverageState: "complete",
    attestationState: "ready",
    calculationHash: H,
    revision: 1,
    calculatedAt: "2026-08-11T00:00:00.000Z",
    calculationOperation: "financialOperation:apply-key",
    provenance: {},
  };
}

test("legacy-resolution apply is one atomic semantic transaction with no destructive statement", async () => {
  let capturedQuery = "";
  let capturedVars: Record<string, unknown> = {};
  const client = {
    async query(query: string, vars: Record<string, unknown>) {
      capturedQuery = query;
      capturedVars = vars;
      return [
        {
          status: "OK",
          result: {
            resolution: rawResolution("apply"),
            items: [],
            statementImport: rawImport(),
            reconciliation: rawReconciliation(),
            operation: rawOperation("apply_legacy_statement_resolution"),
          },
        },
      ];
    },
  };
  const repository = createSurrealStatementLegacyResolutionRepository(
    client,
    H,
  );
  const draft = {
    source: {
      expectedAccountContext: {
        spaceId: "financialSpace:fictional",
        accountId: "account:fictional",
        spaceKey: "fictional",
        accountKey: "fictional",
        currency: "ZAR",
        normalNature: "asset",
        accountNumberLast4: "0001",
        spaceTimezone: "Africa/Johannesburg",
        accountContextFingerprint: H,
      },
      statementImport: {
        ...rawImport(),
        spaceId: "financialSpace:fictional",
        accountId: "account:fictional",
        spaceKey: "fictional",
        accountKey: "fictional",
        privateSourceRef: "vault:fictional",
        extractionAssistRef: null,
        extractionInputSha256: null,
        sourceKind: "pdf",
        profile: {
          profileId: "fnb-business",
          profileVersion: "1",
          extractorVersion: "1",
        },
        balanceConvention: "positive_is_asset",
        balanceConventionAuthority: "profile",
        coverage: {
          status: "complete",
          printedRowCount: 1,
          extractedRowCount: 1,
        },
        openingBalanceMinor: 10_000,
        closingBalanceMinor: 5_000,
        closingBalanceEconomicNature: "asset",
        replacementOfId: "statementImport:legacy",
        commitOperationId: "financialOperation:apply-key",
      },
      rows: [
        {
          key: "row-1",
          rowKey: "row-1",
          rowNumber: 1,
          rowKind: "movement",
          transactionDate: "2026-06-12",
          postingDate: null,
          valueDate: null,
          rawText: "Fictional movement",
          sourceReference: null,
          reportedBalanceMinor: null,
          locator: null,
          confidence: 1,
          rowHash: H,
          componentCount: 1,
        },
      ],
      components: [
        {
          rowKey: "row-1",
          componentKey: "payment",
          componentKind: "principal",
          componentRole: "movement",
          transactionDate: "2026-06-12",
          postingDate: null,
          valueDate: null,
          description: "Fictional movement",
          sourceReference: null,
          amountMinor: 5_000,
          currency: "ZAR",
          sourceDirection: "debit",
          sourceFlow: "outflow",
          balanceEffectMinor: -5_000,
          locator: null,
          confidence: 1,
          sourceChecksum: H,
        },
      ],
      issues: [],
      operation: operation("apply_legacy_statement_resolution"),
      snapshot: null,
    },
    evidence: {
      legacyStatementImport: {
        id: "statementImport:legacy",
        revision: 1,
        sourceState: "legacy",
      },
    },
    plan: {
      databaseFingerprint: H,
      sourceIdentityHash: H,
      canonicalPreviewHash: H,
      legacyEvidenceHash: H,
      accountContextFingerprint: H,
      crosswalkHash: H,
      expectedRevisionClaimHash: H,
      resultAuthorityHash: H,
      aggregateCounts: {},
      items: [
        {
          key: "exact-one",
          compatibilityClass: "exact_existing_transaction_adoption",
          activeLedgerOutcome: "adopted_existing",
          canonicalComponents: [
            {
              rowKey: "row-1",
              componentKey: "payment",
            },
          ],
          legacyStatementRowId: "statementRow:legacy-row",
          legacyTransactionIds: ["transaction:legacy-transaction"],
          primaryLegacyTransactionId: "transaction:legacy-transaction",
          accountTransferId: null,
          itemEvidenceHash: H,
          expectedClaimHash: H,
        },
      ],
    },
    strategy: "A",
    decisions: [
      {
        itemKey: "exact-one",
        outcome: "adopted_existing",
        itemEvidenceHash: H,
        legacyTransactionId: "transaction:legacy-transaction",
      },
    ],
    operation: operation("apply_legacy_statement_resolution"),
  } as unknown as StatementLegacyApplyDraft;

  const result = await repository.apply(draft);
  assert.equal(result.receipt.status, "applied");
  assert.match(capturedQuery, /^BEGIN TRANSACTION;/);
  assert.match(capturedQuery, /COMMIT TRANSACTION;/);
  assert.match(capturedQuery, /CREATE ONLY \$resolutionId/);
  assert.match(capturedQuery, /statementTransactionResolutionClaim/);
  assert.match(capturedQuery, /STATEMENT_LEGACY_ACTIVE_CLAIM_CONFLICT/);
  assert.doesNotMatch(capturedQuery, /\bDELETE\b/);
  assert.equal(
    (capturedVars.operation as any).command,
    "apply_legacy_statement_resolution",
  );
  assert.equal((capturedVars.operation as any).auditMeta.workline, "HP-04");
});

test("legacy-resolution reversal is append-only, dependency-aware, and releases exact claims", async () => {
  let capturedQuery = "";
  const client = {
    async query(query: string) {
      capturedQuery = query;
      return [
        {
          status: "OK",
          result: {
            resolution: rawResolution("reversal"),
            items: [],
            statementImport: rawImport("legacy"),
            reconciliation: rawReconciliation(),
            operation: rawOperation("reverse_legacy_statement_resolution"),
          },
        },
      ];
    },
  };
  const repository = createSurrealStatementLegacyResolutionRepository(
    client,
    H,
  );
  const draft = {
    target: rawResolution("apply"),
    targetItems: [],
    expectedDatabaseFingerprint: H,
    expectedAuthorityHash: H,
    operation: operation("reverse_legacy_statement_resolution"),
  } as unknown as StatementLegacyReverseDraft;
  const result = await repository.reverse(draft);
  assert.equal(result.resolution.resolutionType, "reversal");
  assert.match(capturedQuery, /\$laterAuthority/);
  assert.match(capturedQuery, /activeLedgerOutcome: "authority_released"/);
  assert.match(capturedQuery, /state = "released"/);
  assert.match(capturedQuery, /CREATE ONLY \$resolutionId/);
  assert.doesNotMatch(capturedQuery, /\bDELETE\b/);
});
