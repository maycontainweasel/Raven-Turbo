import { z } from 'zod';
import { RecordID_z } from '../core';

export const StatementRowComponentIdSubId_z = z.string();

export const StatementRowComponentId_z = RecordID_z.extend({
  tb: z.literal('statementRowComponent'),
  id: StatementRowComponentIdSubId_z,
});
export type StatementRowComponentIdSubId = z.infer<typeof StatementRowComponentIdSubId_z>;
export type StatementRowComponentId = z.infer<typeof StatementRowComponentId_z>;

export const Z_StatementRowComponent = z.object({
  id: StatementRowComponentId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  statementImport: z.union([z.string(), z.number(), RecordID_z]),
  statementRow: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  componentKind: z.enum(["principal", "bank_fee", "vat", "interest", "adjustment", "unknown"]),
  componentRole: z.enum(["movement", "informational_breakdown"]),
  transactionDate: z.string().optional(),
  postingDate: z.string().optional(),
  valueDate: z.string().optional(),
  description: z.string(),
  sourceReference: z.string().optional(),
  amountMinor: z.number().int(),
  currency: z.string(),
  sourceDirection: z.enum(["debit", "credit", "unknown"]),
  sourceFlow: z.enum(["inflow", "outflow", "unknown"]),
  balanceEffectMinor: z.number().int(),
  sourceLocator: z.record(z.string(), z.any()).optional(),
  confidence: z.number().optional(),
  sourceChecksum: z.string(),
  sourceState: z.enum(["committed", "superseded"]),
  commitOperation: z.union([z.string(), z.number(), RecordID_z]),
  notes: z.string().optional(),
});

export type StatementRowComponent = z.infer<typeof Z_StatementRowComponent>;
