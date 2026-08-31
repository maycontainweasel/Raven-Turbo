import { z } from 'zod';
import { RecordID_z } from '../core';

export const StatementLegacyResolutionItemIdSubId_z = z.string();

export const StatementLegacyResolutionItemId_z = RecordID_z.extend({
  tb: z.literal('statementLegacyResolutionItem'),
  id: StatementLegacyResolutionItemIdSubId_z,
});
export type StatementLegacyResolutionItemIdSubId = z.infer<typeof StatementLegacyResolutionItemIdSubId_z>;
export type StatementLegacyResolutionItemId = z.infer<typeof StatementLegacyResolutionItemId_z>;

export const Z_StatementLegacyResolutionItem = z.object({
  id: StatementLegacyResolutionItemId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  statementLegacyResolution: z.union([z.string(), z.number(), RecordID_z]),
  canonicalStatementImport: z.union([z.string(), z.number(), RecordID_z]),
  legacyStatementImport: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  compatibilityClass: z.enum(["exact_existing_transaction_adoption", "exact_grouped_component_adoption", "canonical_component_requires_materialization", "legacy_transaction_historical_only", "transfer_review_required", "informational_non_movement", "ambiguous_or_conflicting"]),
  activeLedgerOutcome: z.enum(["adopted_existing", "adopted_grouped", "materialized", "historical_only", "confirmed_transfer", "informational_only", "authority_released"]),
  canonicalComponent: z.union([z.string(), z.number(), RecordID_z]).optional(),
  canonicalComponentIds: z.array(z.string()),
  legacyStatementRow: z.union([z.string(), z.number(), RecordID_z]).optional(),
  legacyTransaction: z.union([z.string(), z.number(), RecordID_z]).optional(),
  legacyTransactionIds: z.array(z.string()),
  accountTransfer: z.union([z.string(), z.number(), RecordID_z]).optional(),
  itemEvidenceHash: z.string(),
  expectedClaimHash: z.string(),
  operation: z.union([z.string(), z.number(), RecordID_z]),
  recordedAt: z.string(),
});

export type StatementLegacyResolutionItem = z.infer<typeof Z_StatementLegacyResolutionItem>;
