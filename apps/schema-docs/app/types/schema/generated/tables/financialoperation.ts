import { z } from 'zod';
import { RecordID_z } from '../core';

export const FinancialOperationIdSubId_z = z.string();

export const FinancialOperationId_z = RecordID_z.extend({
  tb: z.literal('financialOperation'),
  id: FinancialOperationIdSubId_z,
});
export type FinancialOperationIdSubId = z.infer<typeof FinancialOperationIdSubId_z>;
export type FinancialOperationId = z.infer<typeof FinancialOperationId_z>;

export const Z_FinancialOperation = z.object({
  id: FinancialOperationId_z.optional(),
  key: z.string(),
  command: z.string(),
  idempotencyKey: z.string(),
  requestHash: z.string(),
  channel: z.enum(["ui", "mcp", "system"]),
  actorId: z.string().optional(),
  status: z.enum(["applied", "replayed", "failed"]),
  resultRefs: z.array(z.string()).optional(),
  warningCodes: z.array(z.string()).optional(),
  auditMeta: z.record(z.string(), z.any()).optional(),
  recordedAt: z.string(),
  completedAt: z.string().optional(),
  failureCode: z.string().optional(),
});

export type FinancialOperation = z.infer<typeof Z_FinancialOperation>;
