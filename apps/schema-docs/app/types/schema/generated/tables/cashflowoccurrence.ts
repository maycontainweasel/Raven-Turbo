import { z } from 'zod';
import { RecordID_z } from '../core';

export const CashflowOccurrenceIdSubId_z = z.string();

export const CashflowOccurrenceId_z = RecordID_z.extend({
  tb: z.literal('cashflowOccurrence'),
  id: CashflowOccurrenceIdSubId_z,
});
export type CashflowOccurrenceIdSubId = z.infer<typeof CashflowOccurrenceIdSubId_z>;
export type CashflowOccurrenceId = z.infer<typeof CashflowOccurrenceId_z>;

export const Z_CashflowOccurrence = z.object({
  id: CashflowOccurrenceId_z.optional(),
  schedule: z.union([z.string(), z.number(), RecordID_z]),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]).optional(),
  category: z.union([z.string(), z.number(), RecordID_z]).optional(),
  scheduledDueOn: z.string(),
  dueOn: z.string(),
  scheduleRevision: z.number().int(),
  revision: z.number().int(),
  title: z.string(),
  direction: z.enum(["outflow", "inflow"]),
  certainty: z.enum(["committed", "confirmed", "expected", "possible"]),
  cadence: z.enum(["once", "weekly", "monthly", "quarterly", "yearly"]),
  scheduledAmountMinor: z.number().int(),
  amountMinor: z.number().int(),
  currency: z.string(),
  status: z.enum(["due", "settled", "skipped", "waived", "cancelled"]),
  settledAt: z.string().optional(),
  transaction: z.union([z.string(), z.number(), RecordID_z]).optional(),
  overrideReason: z.string().optional(),
  statusReason: z.string().optional(),
  notes: z.string().optional(),
  lastOperation: z.union([z.string(), z.number(), RecordID_z]),
  recordedAt: z.string(),
  updatedAt: z.string(),
});

export type CashflowOccurrence = z.infer<typeof Z_CashflowOccurrence>;
