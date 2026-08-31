import { z } from 'zod';
import { RecordID_z } from '../core';

export const StatementReconciliationIdSubId_z = z.string();

export const StatementReconciliationId_z = RecordID_z.extend({
  tb: z.literal('statementReconciliation'),
  id: StatementReconciliationIdSubId_z,
});
export type StatementReconciliationIdSubId = z.infer<typeof StatementReconciliationIdSubId_z>;
export type StatementReconciliationId = z.infer<typeof StatementReconciliationId_z>;

export const Z_StatementReconciliation = z.object({
  id: StatementReconciliationId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  statementImport: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  periodStart: z.string(),
  periodEnd: z.string(),
  currency: z.string(),
  openingBalanceMinor: z.number().int().optional(),
  signedMovementEffectMinor: z.number().int(),
  expectedClosingBalanceMinor: z.number().int().optional(),
  reportedClosingBalanceMinor: z.number().int().optional(),
  differenceMinor: z.number().int().optional(),
  printedRowCount: z.number().int(),
  extractedRowCount: z.number().int(),
  movementComponentCount: z.number().int(),
  informationalComponentCount: z.number().int(),
  pendingCount: z.number().int(),
  proposedCount: z.number().int(),
  confirmedExistingCount: z.number().int(),
  newlyMaterializedCount: z.number().int(),
  unresolvedCount: z.number().int(),
  transferCandidateCount: z.number().int(),
  activeIssueCount: z.number().int(),
  blockingIssueCount: z.number().int(),
  calculationState: z.enum(["unavailable", "difference", "balanced"]),
  coverageState: z.enum(["incomplete", "complete"]),
  attestationState: z.enum(["open", "ready", "reconciled", "reopened"]),
  calculationHash: z.string(),
  revision: z.number().int(),
  calculatedAt: z.string(),
  calculationOperation: z.union([z.string(), z.number(), RecordID_z]),
  latestAttestationOperation: z.union([z.string(), z.number(), RecordID_z]).optional(),
  latestReopeningOperation: z.union([z.string(), z.number(), RecordID_z]).optional(),
  attestedAt: z.string().optional(),
  reopenedAt: z.string().optional(),
  provenance: z.record(z.string(), z.any()).optional(),
});

export type StatementReconciliation = z.infer<typeof Z_StatementReconciliation>;
