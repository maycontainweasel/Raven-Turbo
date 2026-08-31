import { z } from 'zod';
import { RecordID_z } from '../core';

export const TransactionPurposeAssignmentIdSubId_z = z.string();

export const TransactionPurposeAssignmentId_z = RecordID_z.extend({
  tb: z.literal('transactionPurposeAssignment'),
  id: TransactionPurposeAssignmentIdSubId_z,
});
export type TransactionPurposeAssignmentIdSubId = z.infer<typeof TransactionPurposeAssignmentIdSubId_z>;
export type TransactionPurposeAssignmentId = z.infer<typeof TransactionPurposeAssignmentId_z>;

export const Z_TransactionPurposeAssignment = z.object({
  id: TransactionPurposeAssignmentId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  transaction: z.union([z.string(), z.number(), RecordID_z]),
  purpose: z.union([z.string(), z.number(), RecordID_z]),
  revision: z.number().int(),
  state: z.enum(["proposed", "confirmed", "superseded", "rejected"]),
  isCurrent: z.boolean(),
  assignmentSource: z.enum(["manual", "agent", "rule", "import"]),
  confidence: z.number().optional(),
  occurrenceLabel: z.string().optional(),
  context: z.record(z.string(), z.any()).optional(),
  rule: z.union([z.string(), z.number(), RecordID_z]).optional(),
  supersedes: z.union([z.string(), z.number(), RecordID_z]).optional(),
  operation: z.union([z.string(), z.number(), RecordID_z]).optional(),
  recordedAt: z.string(),
  reviewedAt: z.string().optional(),
  notes: z.string().optional(),
});

export type TransactionPurposeAssignment = z.infer<typeof Z_TransactionPurposeAssignment>;
