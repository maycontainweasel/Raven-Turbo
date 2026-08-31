import { z } from "zod";

export const statementDateOnlySchema = z.string().regex(/^\d{4}-\d{2}-\d{2}$/);
export const statementSourceKindSchema = z.enum([
  "pdf",
  "csv",
  "ofx",
  "qif",
  "image",
]);
export const statementProfileIdSchema = z.enum([
  "nedbank-current",
  "nedbank-savings",
  "nedbank-credit",
  "fnb-business",
  "normalized-json-v1",
]);
export const statementSelectionInputSchema = z.strictObject({
  sourceRef: z.string().min(1),
  spaceKey: z.string().min(1),
  accountKey: z.string().min(1),
  profileId: statementProfileIdSchema,
  profileVersion: z.literal("1"),
});
export const statementStageUploadInputSchema = z.strictObject({
  originalBytes: z.instanceof(Uint8Array),
  mimeType: z.string().min(1),
  sourceKind: statementSourceKindSchema,
  extractionAssistBytes: z.instanceof(Uint8Array).optional(),
  extractionAssistMimeType: z.literal("application/json").optional(),
});
export const statementStageLocalPathInputSchema = z.strictObject({
  originalPath: z.string().min(1),
  mimeType: z.string().min(1),
  sourceKind: statementSourceKindSchema,
  extractionAssistPath: z.string().min(1).optional(),
  extractionAssistMimeType: z.literal("application/json").optional(),
});
export const statementValidateInputSchema =
  statementSelectionInputSchema.extend({
    previewHash: z.string().length(64),
  });
export const statementCommitClientInputSchema =
  statementValidateInputSchema.extend({
    idempotencyKey: z.string().min(8).max(128),
    actorId: z.string().min(1).optional(),
  });
export const statementListImportsInputSchema = z.strictObject({
  spaceKey: z.string().min(1),
  accountKey: z.string().min(1),
  periodStart: statementDateOnlySchema.optional(),
  periodEnd: statementDateOnlySchema.optional(),
});
export const statementImportReadInputSchema = z.strictObject({
  statementImportId: z.string().min(1),
});
export const statementRowReadInputSchema = z.strictObject({
  statementRowId: z.string().min(1),
});
export const statementComponentsReadInputSchema = z
  .strictObject({
    statementImportId: z.string().min(1).optional(),
    statementRowId: z.string().min(1).optional(),
  })
  .refine(
    (input) => Boolean(input.statementImportId || input.statementRowId),
    "A statement import or row is required",
  );
export const statementComponentReadInputSchema = z.strictObject({
  statementRowComponentId: z.string().min(1),
});
export const statementIssueReadInputSchema = z.strictObject({
  statementIssueId: z.string().min(1),
});
export const statementSourceRefInputSchema = z.strictObject({
  sourceRef: z.string().min(1),
});
const statementResolutionCommandMetaSchema = z.strictObject({
  idempotencyKey: z.string().min(8).max(128),
  actorId: z.string().min(1).optional(),
});
export const statementComponentIdsSchema = z
  .array(z.string().min(1))
  .min(1)
  .refine(
    (ids) => new Set(ids).size === ids.length,
    "Component IDs must be unique",
  );
export const statementMatchMethodSchema = z.enum([
  "explicit",
  "exact_reference",
  "exact_description",
  "exact_date",
  "bounded_date",
  "grouped_exact",
  "created_from_component",
  "transfer_candidate",
  "other",
]);
export const statementMatchReasonCodeSchema = z.enum([
  "ACTIVE_CONFIRMED_SOURCE_LINK",
  "EXPLICIT_OPERATOR_SELECTION",
  "EXACT_SOURCE_REFERENCE",
  "EXACT_NORMALIZED_DESCRIPTION",
  "EXACT_FINANCIAL_DATE",
  "BOUNDED_FINANCIAL_DATE",
  "EXACT_COMPONENT_GROUP_TOTAL",
  "OPPOSITE_ACCOUNT_EFFECT",
  "CREATED_FROM_COMPONENT",
]);
export const statementMatchCandidatesInputSchema = z.strictObject({
  statementImportId: z.string().min(1),
  componentIds: statementComponentIdsSchema,
  explicitTransactionId: z.string().min(1).optional(),
});
export const statementMatchesInputSchema = z.strictObject({
  statementImportId: z.string().min(1),
  statementRowComponentId: z.string().min(1).optional(),
  transactionId: z.string().min(1).optional(),
  includeSuperseded: z.boolean().optional(),
});
export const statementMatchReadInputSchema = z.strictObject({
  statementTransactionMatchId: z.string().min(1),
});
const statementReconciliationExpectationShape = {
  expectedReconciliationRevision: z.number().int().positive().nullable(),
  expectedReconciliationHash: z.string().length(64).nullable(),
};
export const statementProposeMatchInputSchema =
  statementResolutionCommandMetaSchema.extend({
    statementImportId: z.string().min(1),
    componentIds: statementComponentIdsSchema,
    transactionId: z.string().min(1),
    ...statementReconciliationExpectationShape,
  });
export const statementConfirmMatchInputSchema =
  statementResolutionCommandMetaSchema.extend({
    statementTransactionMatchId: z.string().min(1),
    expectedRevision: z.number().int().positive(),
    ...statementReconciliationExpectationShape,
  });
export const statementMaterializeInputSchema =
  statementResolutionCommandMetaSchema.extend({
    statementImportId: z.string().min(1),
    componentIds: statementComponentIdsSchema,
    ...statementReconciliationExpectationShape,
  });
export const statementRejectMatchInputSchema =
  statementConfirmMatchInputSchema.extend({
    reason: z.string().trim().min(1).max(500),
  });
export const statementSupersedeMatchInputSchema =
  statementResolutionCommandMetaSchema.extend({
    statementTransactionMatchId: z.string().min(1),
    expectedRevision: z.number().int().positive(),
    componentIds: statementComponentIdsSchema,
    transactionId: z.string().min(1),
    reason: z.string().trim().min(1).max(500),
    ...statementReconciliationExpectationShape,
  });
export const statementAcknowledgeIssueInputSchema =
  statementResolutionCommandMetaSchema.extend({
    statementIssueId: z.string().min(1),
    expectedRevision: z.number().int().positive(),
    note: z.string().trim().min(1).max(1000),
    ...statementReconciliationExpectationShape,
  });
export const statementSupersedeImportInputSchema =
  statementResolutionCommandMetaSchema.extend({
    statementImportId: z.string().min(1),
    expectedSourceRevision: z.number().int().positive(),
    expectedReconciliationRevision: z.number().int().positive().nullable(),
    expectedReconciliationHash: z.string().length(64).nullable(),
    replacement: statementValidateInputSchema,
    reason: z.string().trim().min(1).max(500),
  });
export const statementRecalculateInputSchema =
  statementResolutionCommandMetaSchema.extend({
    statementImportId: z.string().min(1),
    expectedRevision: z.number().int().positive().nullable(),
    expectedHash: z.string().length(64).nullable(),
  });
export const statementAttestInputSchema =
  statementResolutionCommandMetaSchema.extend({
    statementImportId: z.string().min(1),
    expectedRevision: z.number().int().positive(),
    calculationHash: z.string().length(64),
  });
export const statementReopenInputSchema =
  statementResolutionCommandMetaSchema.extend({
    statementImportId: z.string().min(1),
    expectedRevision: z.number().int().positive(),
    reason: z.string().trim().min(1).max(500),
    calculationHash: z.string().length(64),
  });
export const statementLegacyPreviewInputSchema = statementValidateInputSchema.extend({
  legacyStatementImportId: z.string().min(1),
});
export const statementLegacyDecisionSchema = z.strictObject({
  itemKey: z.string().min(1),
  outcome: z.enum([
    "adopted_existing",
    "adopted_grouped",
    "materialized",
    "historical_only",
    "confirmed_transfer",
  ]),
  itemEvidenceHash: z.string().length(64),
  legacyTransactionId: z.string().min(1).optional(),
  accountTransferId: z.string().min(1).optional(),
});
export const statementLegacyApplyInputSchema =
  statementLegacyPreviewInputSchema.extend({
    previewIdentityHash: z.string().length(64),
    expectedDatabaseFingerprint: z.string().length(64),
    expectedSourceIdentityHash: z.string().length(64),
    expectedLegacyEvidenceHash: z.string().length(64),
    expectedAccountContextFingerprint: z.string().length(64),
    expectedCrosswalkHash: z.string().length(64),
    expectedRevisionClaimHash: z.string().length(64),
    strategy: z.enum(["A", "B", "C"]),
    decisions: z
      .array(statementLegacyDecisionSchema)
      .refine(
        (items) => new Set(items.map((item) => item.itemKey)).size === items.length,
        "Legacy-resolution item keys must be unique",
      ),
    idempotencyKey: z.string().min(8).max(128),
    actorId: z.string().min(1).optional(),
  });
export const statementLegacyReverseInputSchema = z.strictObject({
  statementLegacyResolutionId: z.string().min(1),
  expectedDatabaseFingerprint: z.string().length(64),
  expectedTargetRequestHash: z.string().length(64),
  expectedAuthorityHash: z.string().length(64),
  idempotencyKey: z.string().min(8).max(128),
  actorId: z.string().min(1).optional(),
});

export const statementTruthInputSchemas = Object.freeze({
  stageUpload: statementStageUploadInputSchema,
  stageLocalPath: statementStageLocalPathInputSchema,
  sourceRef: statementSourceRefInputSchema,
  selection: statementSelectionInputSchema,
  validate: statementValidateInputSchema,
  commitClient: statementCommitClientInputSchema,
  listImports: statementListImportsInputSchema,
  importRead: statementImportReadInputSchema,
  rowRead: statementRowReadInputSchema,
  componentsRead: statementComponentsReadInputSchema,
  componentRead: statementComponentReadInputSchema,
  issueRead: statementIssueReadInputSchema,
  matchCandidates: statementMatchCandidatesInputSchema,
  matches: statementMatchesInputSchema,
  matchRead: statementMatchReadInputSchema,
  reconciliationRead: statementImportReadInputSchema,
  proposeMatch: statementProposeMatchInputSchema,
  confirmMatch: statementConfirmMatchInputSchema,
  materialize: statementMaterializeInputSchema,
  rejectMatch: statementRejectMatchInputSchema,
  supersedeMatch: statementSupersedeMatchInputSchema,
  acknowledgeIssue: statementAcknowledgeIssueInputSchema,
  supersedeImport: statementSupersedeImportInputSchema,
  recalculate: statementRecalculateInputSchema,
  attest: statementAttestInputSchema,
  reopen: statementReopenInputSchema,
  legacyPreview: statementLegacyPreviewInputSchema,
  legacyApply: statementLegacyApplyInputSchema,
  legacyReverse: statementLegacyReverseInputSchema,
});
