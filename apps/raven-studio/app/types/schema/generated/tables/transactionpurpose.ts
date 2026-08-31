import { z } from 'zod';
import { RecordID_z } from '../core';

export const TransactionPurposeIdSubId_z = z.string();

export const TransactionPurposeId_z = RecordID_z.extend({
  tb: z.literal('transactionPurpose'),
  id: TransactionPurposeIdSubId_z,
});
export type TransactionPurposeIdSubId = z.infer<typeof TransactionPurposeIdSubId_z>;
export type TransactionPurposeId = z.infer<typeof TransactionPurposeId_z>;

export const Z_TransactionPurpose = z.object({
  id: TransactionPurposeId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  name: z.string(),
  description: z.string().optional(),
  purposeKind: z.enum(["subscription", "service", "bank_fee", "family_support", "housing", "education", "trading_funding", "transfer_purpose", "income_source", "purchase", "other"]),
  occurrencePattern: z.enum(["one_off", "recurring", "irregular", "unknown"]),
  defaultMerchant: z.union([z.string(), z.number(), RecordID_z]).optional(),
  defaultCategory: z.union([z.string(), z.number(), RecordID_z]).optional(),
  aliases: z.array(z.string()).optional(),
  active: z.boolean(),
  notes: z.string().optional(),
});

export type TransactionPurpose = z.infer<typeof Z_TransactionPurpose>;
