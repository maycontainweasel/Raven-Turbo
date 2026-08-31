import { z } from 'zod';
import { RecordID_z } from '../core';

export const StatementTransactionResolutionClaimIdSubId_z = z.string();

export const StatementTransactionResolutionClaimId_z = RecordID_z.extend({
  tb: z.literal('statementTransactionResolutionClaim'),
  id: StatementTransactionResolutionClaimIdSubId_z,
});
export type StatementTransactionResolutionClaimIdSubId = z.infer<typeof StatementTransactionResolutionClaimIdSubId_z>;
export type StatementTransactionResolutionClaimId = z.infer<typeof StatementTransactionResolutionClaimId_z>;

export const Z_StatementTransactionResolutionClaim = z.object({
  id: StatementTransactionResolutionClaimId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  statementImport: z.union([z.string(), z.number(), RecordID_z]),
  statementTransactionMatch: z.union([z.string(), z.number(), RecordID_z]),
  transaction: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  periodStart: z.string(),
  periodEnd: z.string(),
  state: z.enum(["active", "released"]),
  claimedAt: z.string(),
  releasedAt: z.string().optional(),
  operation: z.union([z.string(), z.number(), RecordID_z]),
});

export type StatementTransactionResolutionClaim = z.infer<typeof Z_StatementTransactionResolutionClaim>;
