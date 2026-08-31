import { z } from 'zod';
import { RecordID_z } from '../core';

export const MonthlySnapshotIdSubId_z = z.string();

export const MonthlySnapshotId_z = RecordID_z.extend({
  tb: z.literal('monthlySnapshot'),
  id: MonthlySnapshotIdSubId_z,
});
export type MonthlySnapshotIdSubId = z.infer<typeof MonthlySnapshotIdSubId_z>;
export type MonthlySnapshotId = z.infer<typeof MonthlySnapshotId_z>;

export const Z_MonthlySnapshot = z.object({
  id: MonthlySnapshotId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  month: z.string(),
  currency: z.string(),
  incomeTotal: z.number(),
  outflowTotal: z.number(),
  netTotal: z.number(),
  transferTotal: z.number().optional(),
  cashAvailable: z.number().optional(),
  recurringTotal: z.number().optional(),
  businessSpendTotal: z.number().optional(),
  personalSpendTotal: z.number().optional(),
  generatedAt: z.string(),
  status: z.enum(["draft", "final"]),
  notes: z.string().optional(),
});

export type MonthlySnapshot = z.infer<typeof Z_MonthlySnapshot>;
