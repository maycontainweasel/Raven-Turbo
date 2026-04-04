import { z } from 'zod';
import { RecordID_z } from '../core';

export const ClarificationTaskIdSubId_z = z.string();

export const ClarificationTaskId_z = RecordID_z.extend({
  tb: z.literal('clarificationTask'),
  id: ClarificationTaskIdSubId_z,
});
export type ClarificationTaskIdSubId = z.infer<typeof ClarificationTaskIdSubId_z>;
export type ClarificationTaskId = z.infer<typeof ClarificationTaskId_z>;

export const Z_ClarificationTask = z.object({
  id: ClarificationTaskId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  transaction: z.union([z.string(), z.number(), RecordID_z]),
  status: z.enum(["open", "suggested", "resolved", "dismissed"]),
  question: z.string(),
  reason: z.string().optional(),
  suggestedSpace: z.union([z.string(), z.number(), RecordID_z]).optional(),
  suggestedMerchant: z.union([z.string(), z.number(), RecordID_z]).optional(),
  suggestedCategory: z.union([z.string(), z.number(), RecordID_z]).optional(),
  resolvedAt: z.string().optional(),
  resolutionNotes: z.string().optional(),
  confidence: z.number().optional(),
  notes: z.string().optional(),
});

export type ClarificationTask = z.infer<typeof Z_ClarificationTask>;
