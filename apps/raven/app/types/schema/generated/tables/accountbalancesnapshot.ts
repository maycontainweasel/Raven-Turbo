import { z } from 'zod';
import { RecordID_z } from '../core';

export const AccountBalanceSnapshotIdSubId_z = z.string();

export const AccountBalanceSnapshotId_z = RecordID_z.extend({
  tb: z.literal('accountBalanceSnapshot'),
  id: AccountBalanceSnapshotIdSubId_z,
});
export type AccountBalanceSnapshotIdSubId = z.infer<typeof AccountBalanceSnapshotIdSubId_z>;
export type AccountBalanceSnapshotId = z.infer<typeof AccountBalanceSnapshotId_z>;

export const Z_AccountBalanceSnapshot = z.object({
  id: AccountBalanceSnapshotId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  balanceKind: z.enum(["available", "ledger", "statement", "market_value", "outstanding"]),
  amountMinor: z.number().int(),
  currency: z.string(),
  economicNature: z.enum(["asset", "liability", "informational"]),
  asOf: z.string(),
  recordedAt: z.string(),
  evidenceLevel: z.enum(["confirmed", "observed"]),
  sourceKind: z.enum(["manual_confirmation", "statement_closing", "transaction_observation", "provider_sync", "market_quote"]),
  sourceRef: z.string().optional(),
  operation: z.union([z.string(), z.number(), RecordID_z]).optional(),
  notes: z.string().optional(),
});

export type AccountBalanceSnapshot = z.infer<typeof Z_AccountBalanceSnapshot>;
