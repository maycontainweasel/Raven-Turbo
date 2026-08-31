import { z } from 'zod';
import { RecordID_z } from '../core';

export const StatementSourceClaimIdSubId_z = z.string();

export const StatementSourceClaimId_z = RecordID_z.extend({
  tb: z.literal('statementSourceClaim'),
  id: StatementSourceClaimIdSubId_z,
});
export type StatementSourceClaimIdSubId = z.infer<typeof StatementSourceClaimIdSubId_z>;
export type StatementSourceClaimId = z.infer<typeof StatementSourceClaimId_z>;

export const Z_StatementSourceClaim = z.object({
  id: StatementSourceClaimId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  statementImport: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  originalFileSha256: z.string(),
  periodStart: z.string(),
  periodEnd: z.string(),
  state: z.enum(["active", "released"]),
  claimedAt: z.string(),
  operation: z.union([z.string(), z.number(), RecordID_z]),
});

export type StatementSourceClaim = z.infer<typeof Z_StatementSourceClaim>;
