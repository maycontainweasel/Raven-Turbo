import { z } from 'zod';
import { RecordID_z } from '../core';

export const CategoryIdSubId_z = z.string();

export const CategoryId_z = RecordID_z.extend({
  tb: z.literal('category'),
  id: CategoryIdSubId_z,
});
export type CategoryIdSubId = z.infer<typeof CategoryIdSubId_z>;
export type CategoryId = z.infer<typeof CategoryId_z>;

export const Z_Category = z.object({
  id: CategoryId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  name: z.string(),
  categoryKind: z.enum(["income", "expense", "transfer", "tax", "savings", "other"]),
  parentCategory: z.union([z.string(), z.number(), RecordID_z]).optional(),
  active: z.boolean(),
  notes: z.string().optional(),
});

export type Category = z.infer<typeof Z_Category>;
