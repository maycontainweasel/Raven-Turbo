import { z } from 'zod';
import { RecordID_z } from '../core';

export const TransactionTaxDeclarationIdSubId_z = z.string();

export const TransactionTaxDeclarationId_z = RecordID_z.extend({
  tb: z.literal('transactionTaxDeclaration'),
  id: TransactionTaxDeclarationIdSubId_z,
});
export type TransactionTaxDeclarationIdSubId = z.infer<typeof TransactionTaxDeclarationIdSubId_z>;
export type TransactionTaxDeclarationId = z.infer<typeof TransactionTaxDeclarationId_z>;

export const Z_TransactionTaxDeclaration = z.object({
  id: TransactionTaxDeclarationId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  transaction: z.union([z.string(), z.number(), RecordID_z]),
  taxCategory: z.union([z.string(), z.number(), RecordID_z]).optional(),
  revision: z.number().int(),
  state: z.enum(["proposed", "user_confirmed", "superseded", "rejected"]),
  isCurrent: z.boolean(),
  declarationSource: z.enum(["manual", "agent", "rule", "import"]),
  taxDescription: z.string().optional(),
  evidenceStatus: z.enum(["not_assessed", "missing", "partial", "available", "not_required"]),
  context: z.record(z.string(), z.any()).optional(),
  supersedes: z.union([z.string(), z.number(), RecordID_z]).optional(),
  operation: z.union([z.string(), z.number(), RecordID_z]).optional(),
  recordedAt: z.string(),
  reviewedAt: z.string().optional(),
  notes: z.string().optional(),
});

export type TransactionTaxDeclaration = z.infer<typeof Z_TransactionTaxDeclaration>;
