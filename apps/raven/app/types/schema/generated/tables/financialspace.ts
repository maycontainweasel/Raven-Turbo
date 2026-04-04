import { z } from 'zod';
import { RecordID_z } from '../core';

export const FinancialSpaceIdSubId_z = z.string();

export const FinancialSpaceId_z = RecordID_z.extend({
  tb: z.literal('financialSpace'),
  id: FinancialSpaceIdSubId_z,
});
export type FinancialSpaceIdSubId = z.infer<typeof FinancialSpaceIdSubId_z>;
export type FinancialSpaceId = z.infer<typeof FinancialSpaceId_z>;

export const Z_FinancialSpace = z.object({
  id: FinancialSpaceId_z.optional(),
  key: z.string(),
  name: z.string(),
  spaceType: z.enum(["personal", "business", "trading", "family", "other"]),
  currency: z.string(),
  description: z.string().optional(),
  active: z.boolean(),
  archivedAt: z.string().optional(),
});

export type FinancialSpace = z.infer<typeof Z_FinancialSpace>;
