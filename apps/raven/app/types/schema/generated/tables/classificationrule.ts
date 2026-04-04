import { z } from 'zod';
import { RecordID_z } from '../core';

export const ClassificationRuleIdSubId_z = z.string();

export const ClassificationRuleId_z = RecordID_z.extend({
  tb: z.literal('classificationRule'),
  id: ClassificationRuleIdSubId_z,
});
export type ClassificationRuleIdSubId = z.infer<typeof ClassificationRuleIdSubId_z>;
export type ClassificationRuleId = z.infer<typeof ClassificationRuleId_z>;

export const Z_ClassificationRule = z.object({
  id: ClassificationRuleId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  name: z.string(),
  matcher: z.string(),
  scope: z.enum(["description", "merchant", "reference", "amount"]),
  targetMerchant: z.union([z.string(), z.number(), RecordID_z]).optional(),
  targetCategory: z.union([z.string(), z.number(), RecordID_z]).optional(),
  priority: z.number().optional(),
  active: z.boolean(),
  notes: z.string().optional(),
});

export type ClassificationRule = z.infer<typeof Z_ClassificationRule>;
