import { z } from 'zod';
import { RecordID_z } from '../core';

export const AccountTransferIdSubId_z = z.string();

export const AccountTransferId_z = RecordID_z.extend({
  tb: z.literal('accountTransfer'),
  id: AccountTransferIdSubId_z,
});
export type AccountTransferIdSubId = z.infer<typeof AccountTransferIdSubId_z>;
export type AccountTransferId = z.infer<typeof AccountTransferId_z>;

export const Z_AccountTransfer = z.object({
  id: AccountTransferId_z.optional(),
  key: z.string(),
  sourceSpace: z.union([z.string(), z.number(), RecordID_z]),
  sourceAccount: z.union([z.string(), z.number(), RecordID_z]),
  targetSpace: z.union([z.string(), z.number(), RecordID_z]),
  targetAccount: z.union([z.string(), z.number(), RecordID_z]),
  amountMinor: z.number().int(),
  currency: z.string(),
  postedAt: z.string(),
  description: z.string().optional(),
  sourceTransaction: z.union([z.string(), z.number(), RecordID_z]),
  targetTransaction: z.union([z.string(), z.number(), RecordID_z]),
  operation: z.union([z.string(), z.number(), RecordID_z]),
  recordedAt: z.string(),
});

export type AccountTransfer = z.infer<typeof Z_AccountTransfer>;
