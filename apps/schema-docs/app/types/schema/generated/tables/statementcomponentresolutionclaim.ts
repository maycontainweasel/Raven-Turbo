import { z } from 'zod';
import { RecordID_z } from '../core';

export const StatementComponentResolutionClaimIdSubId_z = z.string();

export const StatementComponentResolutionClaimId_z = RecordID_z.extend({
  tb: z.literal('statementComponentResolutionClaim'),
  id: StatementComponentResolutionClaimIdSubId_z,
});
export type StatementComponentResolutionClaimIdSubId = z.infer<typeof StatementComponentResolutionClaimIdSubId_z>;
export type StatementComponentResolutionClaimId = z.infer<typeof StatementComponentResolutionClaimId_z>;

export const Z_StatementComponentResolutionClaim = z.object({
  id: StatementComponentResolutionClaimId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  statementImport: z.union([z.string(), z.number(), RecordID_z]),
  statementRowComponent: z.union([z.string(), z.number(), RecordID_z]),
  statementTransactionMatch: z.union([z.string(), z.number(), RecordID_z]),
  transaction: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  state: z.enum(["active", "released"]),
  claimedAt: z.string(),
  releasedAt: z.string().optional(),
  operation: z.union([z.string(), z.number(), RecordID_z]),
});

export type StatementComponentResolutionClaim = z.infer<typeof Z_StatementComponentResolutionClaim>;
