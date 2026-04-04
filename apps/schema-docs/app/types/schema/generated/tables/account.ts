import { z } from 'zod';
import { RecordID_z } from '../core';

export const AccountIdSubId_z = z.string();

export const AccountId_z = RecordID_z.extend({
  tb: z.literal('account'),
  id: AccountIdSubId_z,
});
export type AccountIdSubId = z.infer<typeof AccountIdSubId_z>;
export type AccountId = z.infer<typeof AccountId_z>;

export const Z_Account = z.object({
  id: AccountId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  name: z.string(),
  bankName: z.string(),
  accountType: z.enum(["current", "credit_card", "savings", "loan", "debt", "investment", "cash", "other"]),
  currency: z.string(),
  accountNumberLast4: z.string().optional(),
  openingBalance: z.number().optional(),
  active: z.boolean(),
  notes: z.string().optional(),
});

export type Account = z.infer<typeof Z_Account>;
