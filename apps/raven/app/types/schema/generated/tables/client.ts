import { z } from 'zod';
import { RecordID_z } from '../core';

export const ClientIdSubId_z = z.string();

export const ClientId_z = RecordID_z.extend({
  tb: z.literal('client'),
  id: ClientIdSubId_z,
});
export type ClientIdSubId = z.infer<typeof ClientIdSubId_z>;
export type ClientId = z.infer<typeof ClientId_z>;

export const Z_Client = z.object({
  id: ClientId_z.optional(),
  key: z.string(),
  name: z.string(),
  businessName: z.string().optional(),
  contactPerson: z.string().optional(),
  email: z.string().optional(),
  phoneWhatsapp: z.string().optional(),
  websiteDomain: z.string().optional(),
  status: z.enum(["active", "paused", "inactive", "closed"]),
  relatedProjects: z.string().optional(),
  orbitClientId: z.string().optional(),
  notes: z.string().optional(),
});

export type Client = z.infer<typeof Z_Client>;
