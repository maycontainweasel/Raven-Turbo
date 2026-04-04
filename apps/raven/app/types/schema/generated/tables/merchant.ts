import { z } from 'zod';
import { RecordID_z } from '../core';

export const MerchantIdSubId_z = z.string();

export const MerchantId_z = RecordID_z.extend({
  tb: z.literal('merchant'),
  id: MerchantIdSubId_z,
});
export type MerchantIdSubId = z.infer<typeof MerchantIdSubId_z>;
export type MerchantId = z.infer<typeof MerchantId_z>;

export const Z_Merchant = z.object({
  id: MerchantId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  name: z.string(),
  normalizedName: z.string().optional(),
  active: z.boolean(),
  notes: z.string().optional(),
});

export type Merchant = z.infer<typeof Z_Merchant>;
