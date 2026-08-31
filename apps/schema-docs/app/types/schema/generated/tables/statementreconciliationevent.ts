import { z } from 'zod';
import { RecordID_z } from '../core';

export const StatementReconciliationEventIdSubId_z = z.string();

export const StatementReconciliationEventId_z = RecordID_z.extend({
  tb: z.literal('statementReconciliationEvent'),
  id: StatementReconciliationEventIdSubId_z,
});
export type StatementReconciliationEventIdSubId = z.infer<typeof StatementReconciliationEventIdSubId_z>;
export type StatementReconciliationEventId = z.infer<typeof StatementReconciliationEventId_z>;

export const Z_StatementReconciliationEvent = z.object({
  id: StatementReconciliationEventId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  statementImport: z.union([z.string(), z.number(), RecordID_z]),
  statementReconciliation: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  eventType: z.enum(["attested", "reopened"]),
  reconciliationRevision: z.number().int(),
  calculationHash: z.string(),
  calculationSnapshot: z.record(z.string(), z.any()),
  reason: z.string().optional(),
  actorId: z.string().optional(),
  channel: z.enum(["ui", "mcp", "system"]),
  operation: z.union([z.string(), z.number(), RecordID_z]),
  recordedAt: z.string(),
});

export type StatementReconciliationEvent = z.infer<typeof Z_StatementReconciliationEvent>;
