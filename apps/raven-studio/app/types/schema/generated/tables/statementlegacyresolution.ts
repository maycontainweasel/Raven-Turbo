import { z } from 'zod';
import { RecordID_z } from '../core';

export const StatementLegacyResolutionIdSubId_z = z.string();

export const StatementLegacyResolutionId_z = RecordID_z.extend({
  tb: z.literal('statementLegacyResolution'),
  id: StatementLegacyResolutionIdSubId_z,
});
export type StatementLegacyResolutionIdSubId = z.infer<typeof StatementLegacyResolutionIdSubId_z>;
export type StatementLegacyResolutionId = z.infer<typeof StatementLegacyResolutionId_z>;

export const Z_StatementLegacyResolution = z.object({
  id: StatementLegacyResolutionId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  legacyStatementImport: z.union([z.string(), z.number(), RecordID_z]),
  canonicalStatementImport: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  resolutionType: z.enum(["apply", "reversal"]),
  strategy: z.enum(["A", "B", "C"]),
  authorityEffect: z.enum(["activate_canonical", "restore_previous"]),
  previousLegacySourceState: z.enum(["legacy", "committed"]),
  previousSourceClaimState: z.enum(["absent", "active", "released"]),
  previousPeriodClaimState: z.enum(["absent", "active", "released"]),
  targetResolution: z.union([z.string(), z.number(), RecordID_z]).optional(),
  predecessorResolution: z.union([z.string(), z.number(), RecordID_z]).optional(),
  databaseFingerprint: z.string(),
  sourceIdentityHash: z.string(),
  canonicalPreviewHash: z.string(),
  legacyEvidenceHash: z.string(),
  accountContextFingerprint: z.string(),
  crosswalkHash: z.string(),
  expectedRevisionClaimHash: z.string(),
  resultAuthorityHash: z.string(),
  aggregateCounts: z.record(z.string(), z.any()),
  idempotencyKey: z.string(),
  requestHash: z.string(),
  channel: z.enum(["ui", "mcp", "system"]),
  actorId: z.string().optional(),
  operation: z.union([z.string(), z.number(), RecordID_z]),
  recordedAt: z.string(),
});

export type StatementLegacyResolution = z.infer<typeof Z_StatementLegacyResolution>;
