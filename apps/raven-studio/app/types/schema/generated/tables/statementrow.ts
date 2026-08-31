import { z } from 'zod';
import { RecordID_z } from '../core';

export const StatementRowIdSubId_z = z.string();

export const StatementRowId_z = RecordID_z.extend({
  tb: z.literal('statementRow'),
  id: StatementRowIdSubId_z,
});
export type StatementRowIdSubId = z.infer<typeof StatementRowIdSubId_z>;
export type StatementRowId = z.infer<typeof StatementRowId_z>;

export const Z_StatementRow = z.object({
  id: StatementRowId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  statementImport: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  rowNumber: z.number(),
  rowKind: z.enum(["movement", "informational", "composite", "unresolved"]).optional(),
  transactionDate: z.string().optional(),
  postingDate: z.string().optional(),
  valueDate: z.string().optional(),
  sourceReference: z.string().optional(),
  sourceLocator: z.record(z.string(), z.any()).optional(),
  reportedBalanceMinor: z.number().int().optional(),
  componentCount: z.number().int().optional(),
  extractionConfidence: z.number().optional(),
  rowHash: z.string().optional(),
  commitOperation: z.union([z.string(), z.number(), RecordID_z]).optional(),
  postedAt: z.string().optional(),
  description: z.string(),
  normalizedDescription: z.string().optional(),
  amount: z.number(),
  balance: z.number().optional(),
  currency: z.string(),
  direction: z.enum(["debit", "credit", "transfer", "unknown"]),
  status: z.enum(["raw", "normalized", "matched", "clarified", "ignored"]),
  confidence: z.number().optional(),
  rawData: z.record(z.string(), z.any()).optional(),
  sourceChecksum: z.string().optional(),
  transaction: z.union([z.string(), z.number(), RecordID_z]).optional(),
  notes: z.string().optional(),
});

export type StatementRow = z.infer<typeof Z_StatementRow>;
