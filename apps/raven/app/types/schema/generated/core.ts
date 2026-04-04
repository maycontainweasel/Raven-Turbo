import { z } from 'zod';

export const RecordID_z = z.object({
  tb: z.string(),
  id: z.any(),
});

export const uuid_z = z.string().uuid();

export type RecordID = z.infer<typeof RecordID_z>;
