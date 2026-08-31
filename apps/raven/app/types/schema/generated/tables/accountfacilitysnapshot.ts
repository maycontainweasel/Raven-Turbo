import { z } from 'zod';
import { RecordID_z } from '../core';

export const AccountFacilitySnapshotIdSubId_z = z.string();

export const AccountFacilitySnapshotId_z = RecordID_z.extend({
  tb: z.literal('accountFacilitySnapshot'),
  id: AccountFacilitySnapshotIdSubId_z,
});
export type AccountFacilitySnapshotIdSubId = z.infer<typeof AccountFacilitySnapshotIdSubId_z>;
export type AccountFacilitySnapshotId = z.infer<typeof AccountFacilitySnapshotId_z>;

export const Z_AccountFacilitySnapshot = z.object({
  id: AccountFacilitySnapshotId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  facilityKind: z.enum(["credit_card", "overdraft", "revolving_credit", "loan", "other"]),
  currency: z.string(),
  asOf: z.string(),
  effectiveFrom: z.string().optional(),
  recordedAt: z.string(),
  evidenceLevel: z.enum(["confirmed", "observed"]),
  sourceKind: z.enum(["statement", "contract", "manual_confirmation", "provider_sync"]),
  sourceRef: z.string().optional(),
  statementImport: z.union([z.string(), z.number(), RecordID_z]).optional(),
  hasFacilityLimit: z.boolean(),
  facilityLimitMinor: z.number().int().optional(),
  hasAvailableCredit: z.boolean(),
  availableCreditMinor: z.number().int().optional(),
  hasMinimumPayment: z.boolean(),
  minimumPaymentMinor: z.number().int().optional(),
  paymentDueOn: z.string().optional(),
  interestRates: z.record(z.string(), z.any()).optional(),
  feeTerms: z.record(z.string(), z.any()).optional(),
  terms: z.record(z.string(), z.any()).optional(),
  operation: z.union([z.string(), z.number(), RecordID_z]).optional(),
  notes: z.string().optional(),
});

export type AccountFacilitySnapshot = z.infer<typeof Z_AccountFacilitySnapshot>;
