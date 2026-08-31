import { z } from 'zod';
import { RecordID_z } from '../core';

export const StatementTransactionMatchIdSubId_z = z.string();

export const StatementTransactionMatchId_z = RecordID_z.extend({
  tb: z.literal('statementTransactionMatch'),
  id: StatementTransactionMatchIdSubId_z,
});
export type StatementTransactionMatchIdSubId = z.infer<typeof StatementTransactionMatchIdSubId_z>;
export type StatementTransactionMatchId = z.infer<typeof StatementTransactionMatchId_z>;

export const Z_StatementTransactionMatch = z.object({
  id: StatementTransactionMatchId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  statementImport: z.union([z.string(), z.number(), RecordID_z]),
  primaryComponent: z.union([z.string(), z.number(), RecordID_z]),
  componentIds: z.array(z.string()),
  transaction: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  state: z.enum(["proposed", "confirmed", "rejected", "superseded"]),
  method: z.enum(["explicit", "exact_reference", "exact_description", "exact_date", "bounded_date", "grouped_exact", "created_from_component", "transfer_candidate", "other"]),
  reasonCodes: z.array(z.string()),
  confidence: z.number(),
  signedComponentTotalMinor: z.number().int(),
  currency: z.string(),
  revision: z.number().int(),
  proposedOperation: z.union([z.string(), z.number(), RecordID_z]),
  confirmedOperation: z.union([z.string(), z.number(), RecordID_z]).optional(),
  rejectedOperation: z.union([z.string(), z.number(), RecordID_z]).optional(),
  supersededOperation: z.union([z.string(), z.number(), RecordID_z]).optional(),
  proposedBy: z.string().optional(),
  reviewedBy: z.string().optional(),
  proposedAt: z.string(),
  confirmedAt: z.string().optional(),
  rejectedAt: z.string().optional(),
  supersededAt: z.string().optional(),
  rejectionReason: z.string().optional(),
  supersessionReason: z.string().optional(),
  supersedes: z.union([z.string(), z.number(), RecordID_z]).optional(),
  supersededBy: z.union([z.string(), z.number(), RecordID_z]).optional(),
  sourceState: z.enum(["committed", "superseded"]),
  notes: z.string().optional(),
});

export type StatementTransactionMatch = z.infer<typeof Z_StatementTransactionMatch>;
