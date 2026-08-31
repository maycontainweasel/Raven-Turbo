import { z } from 'zod';
import { RecordID_z } from '../core';

export const TaxCategoryIdSubId_z = z.string();

export const TaxCategoryId_z = RecordID_z.extend({
  tb: z.literal('taxCategory'),
  id: TaxCategoryIdSubId_z,
});
export type TaxCategoryIdSubId = z.infer<typeof TaxCategoryIdSubId_z>;
export type TaxCategoryId = z.infer<typeof TaxCategoryId_z>;

export const Z_TaxCategory = z.object({
  id: TaxCategoryId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  name: z.string(),
  parentTaxCategory: z.union([z.string(), z.number(), RecordID_z]).optional(),
  active: z.boolean(),
  notes: z.string().optional(),
});

export type TaxCategory = z.infer<typeof Z_TaxCategory>;
