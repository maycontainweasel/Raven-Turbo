import { z } from 'zod';
import { RecordID_z } from '../core';

export const UserIdSubId_z = z.string();

export const UserId_z = RecordID_z.extend({
  tb: z.literal('u'),
  id: UserIdSubId_z,
});
export type UserIdSubId = z.infer<typeof UserIdSubId_z>;
export type UserId = z.infer<typeof UserId_z>;

export const Z_User = z.object({
  id: UserId_z.optional(),
  email: z.string(),
  uniqueId: z.string().optional(),
  firstName: z.string(),
  surname: z.string(),
  role: z.union([z.string(), z.number(), RecordID_z]),
});

export type User = z.infer<typeof Z_User>;
