import { z } from 'zod';
import { RecordID_z } from '../core';

export const StatementPeriodClaimIdSubId_z = z.string();

export const StatementPeriodClaimId_z = RecordID_z.extend({
  tb: z.literal('statementPeriodClaim'),
  id: StatementPeriodClaimIdSubId_z,
});
export type StatementPeriodClaimIdSubId = z.infer<typeof StatementPeriodClaimIdSubId_z>;
export type StatementPeriodClaimId = z.infer<typeof StatementPeriodClaimId_z>;

export const Z_StatementPeriodClaim = z.object({
  id: StatementPeriodClaimId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  statementImport: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  periodStart: z.string(),
  periodEnd: z.string(),
  originalFileSha256: z.string(),
  state: z.enum(["active", "released"]),
  claimedAt: z.string(),
  operation: z.union([z.string(), z.number(), RecordID_z]),
});

export type StatementPeriodClaim = z.infer<typeof Z_StatementPeriodClaim>;
