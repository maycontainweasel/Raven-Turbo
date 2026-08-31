import { z } from 'zod';
import { RecordID_z } from '../core';

export const RetainerIdSubId_z = z.string();

export const RetainerId_z = RecordID_z.extend({
  tb: z.literal('retainer'),
  id: RetainerIdSubId_z,
});
export type RetainerIdSubId = z.infer<typeof RetainerIdSubId_z>;
export type RetainerId = z.infer<typeof RetainerId_z>;

export const Z_Retainer = z.object({
  id: RetainerId_z.optional(),
  key: z.string(),
  client: z.union([z.string(), z.number(), RecordID_z]),
  title: z.string(),
  type: z.enum(["hosting", "email_hosting", "maintenance", "support", "seo", "mixed", "other"]),
  status: z.enum(["active", "paused", "overdue", "cancelled", "closed"]),
  startDate: z.string().optional(),
  billingCadence: z.enum(["monthly", "quarterly", "annual", "ad_hoc"]),
  amountCharged: z.number().optional(),
  currency: z.string(),
  quotedAmount: z.number().optional(),
  quotedAt: z.string().optional(),
  quoteReference: z.string().optional(),
  nextBillingDate: z.string().optional(),
  lastBilledDate: z.string().optional(),
  invoiceCount: z.number().optional(),
  amountCollectedToDate: z.number().optional(),
  agreementSourceNotes: z.string().optional(),
  termsConditions: z.string().optional(),
  includedServices: z.string().optional(),
  excludedServices: z.string().optional(),
  supportLevel: z.string().optional(),
  hostingProvider: z.union([z.string(), z.number(), RecordID_z]).optional(),
  providerAccountName: z.string().optional(),
  coveredAssets: z.string().optional(),
  costToMe: z.number().optional(),
  costCadence: z.enum(["monthly", "quarterly", "annual", "ad_hoc"]),
  renewalReviewDate: z.string().optional(),
  recommendedAction: z.enum(["none", "review", "increase", "pause", "cancel", "new_quote", "confirm_terms", "bill_client"]),
  risksIssues: z.string().optional(),
  nextAction: z.string().optional(),
  notes: z.string().optional(),
});

export type Retainer = z.infer<typeof Z_Retainer>;
