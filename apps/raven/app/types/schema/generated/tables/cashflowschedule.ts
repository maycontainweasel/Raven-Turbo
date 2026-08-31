import { z } from 'zod';
import { RecordID_z } from '../core';

export const CashflowScheduleIdSubId_z = z.string();

export const CashflowScheduleId_z = RecordID_z.extend({
  tb: z.literal('cashflowSchedule'),
  id: CashflowScheduleIdSubId_z,
});
export type CashflowScheduleIdSubId = z.infer<typeof CashflowScheduleIdSubId_z>;
export type CashflowScheduleId = z.infer<typeof CashflowScheduleId_z>;

export const Z_CashflowSchedule = z.object({
  id: CashflowScheduleId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]).optional(),
  category: z.union([z.string(), z.number(), RecordID_z]).optional(),
  key: z.string(),
  title: z.string(),
  direction: z.enum(["outflow", "inflow"]),
  certainty: z.enum(["committed", "confirmed", "expected", "possible"]),
  amountMinor: z.number().int(),
  currency: z.string(),
  timezone: z.string(),
  cadence: z.enum(["once", "weekly", "monthly", "quarterly", "yearly"]),
  interval: z.number().int(),
  startDate: z.string(),
  endDate: z.string().optional(),
  onceDueOn: z.string().optional(),
  dayOfWeek: z.number().int().optional(),
  dayOfMonth: z.number().int().optional(),
  monthOfYear: z.number().int().optional(),
  status: z.enum(["active", "paused", "ended", "cancelled"]),
  revision: z.number().int(),
  materializedThrough: z.string().optional(),
  termsEffectiveFrom: z.string(),
  pausedOn: z.string().optional(),
  resumedOn: z.string().optional(),
  endedOn: z.string().optional(),
  cancelledOn: z.string().optional(),
  createdOperation: z.union([z.string(), z.number(), RecordID_z]),
  lastOperation: z.union([z.string(), z.number(), RecordID_z]),
  recordedAt: z.string(),
  updatedAt: z.string(),
  notes: z.string().optional(),
});

export type CashflowSchedule = z.infer<typeof Z_CashflowSchedule>;
