import { z } from 'zod';
import { RecordID_z } from '../core';

export const TransactionIdSubId_z = z.string();

export const TransactionId_z = RecordID_z.extend({
  tb: z.literal('transaction'),
  id: TransactionIdSubId_z,
});
export type TransactionIdSubId = z.infer<typeof TransactionIdSubId_z>;
export type TransactionId = z.infer<typeof TransactionId_z>;

export const Z_Transaction = z.object({
  id: TransactionId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  sourceRow: z.union([z.string(), z.number(), RecordID_z]).optional(),
  postedAt: z.string(),
  effectiveAt: z.string().optional(),
  description: z.string(),
  normalizedDescription: z.string().optional(),
  amount: z.number(),
  balance: z.number().optional(),
  currency: z.string(),
  direction: z.enum(["debit", "credit", "transfer"]),
  status: z.enum(["imported", "normalized", "matched", "classified", "clarified", "ignored"]),
  confidence: z.number().optional(),
  merchantName: z.string().optional(),
  merchant: z.union([z.string(), z.number(), RecordID_z]).optional(),
  category: z.union([z.string(), z.number(), RecordID_z]).optional(),
  isTransfer: z.boolean().optional(),
  manualOverride: z.boolean().optional(),
  notes: z.string().optional(),
});

export type Transaction = z.infer<typeof Z_Transaction>;
