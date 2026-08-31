import { z } from 'zod';
import { RecordID_z } from '../core';

export const HostingProviderIdSubId_z = z.string();

export const HostingProviderId_z = RecordID_z.extend({
  tb: z.literal('hostingProvider'),
  id: HostingProviderIdSubId_z,
});
export type HostingProviderIdSubId = z.infer<typeof HostingProviderIdSubId_z>;
export type HostingProviderId = z.infer<typeof HostingProviderId_z>;

export const Z_HostingProvider = z.object({
  id: HostingProviderId_z.optional(),
  key: z.string(),
  name: z.string(),
  providerType: z.enum(["reseller", "shared_hosting", "vps", "domain", "email", "cloud", "other"]),
  accountName: z.string().optional(),
  accountReference: z.string().optional(),
  websiteUrl: z.string().optional(),
  billingCadence: z.enum(["monthly", "quarterly", "annual", "ad_hoc"]),
  monthlyCost: z.number().optional(),
  currency: z.string(),
  status: z.enum(["active", "paused", "inactive", "closed"]),
  notes: z.string().optional(),
});

export type HostingProvider = z.infer<typeof Z_HostingProvider>;
