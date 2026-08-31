import { z } from 'zod';
import { RecordID_z } from '../core';

export const StatementImportIdSubId_z = z.string();

export const StatementImportId_z = RecordID_z.extend({
  tb: z.literal('statementImport'),
  id: StatementImportIdSubId_z,
});
export type StatementImportIdSubId = z.infer<typeof StatementImportIdSubId_z>;
export type StatementImportId = z.infer<typeof StatementImportId_z>;

export const Z_StatementImport = z.object({
  id: StatementImportId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  key: z.string(),
  sourceFileName: z.string(),
  sourceFormat: z.enum(["csv", "ofx", "qif", "pdf", "image", "normalized_json", "manual"]),
  privateSourceRef: z.string().optional(),
  extractionAssistRef: z.string().optional(),
  originalFileSha256: z.string().optional(),
  extractionInputSha256: z.string().optional(),
  canonicalExtractionSha256: z.string().optional(),
  previewHash: z.string().optional(),
  sourceMimeType: z.string().optional(),
  sourceByteSize: z.number().int().optional(),
  profileId: z.string().optional(),
  profileVersion: z.string().optional(),
  extractorVersion: z.string().optional(),
  validationRulesetVersion: z.string().optional(),
  periodStart: z.string().optional(),
  periodEnd: z.string().optional(),
  currency: z.string().optional(),
  balanceConvention: z.string().optional(),
  balanceConventionAuthority: z.enum(["profile", "operator_unverified"]).optional(),
  accountContextFingerprint: z.string().optional(),
  openingBalanceMinor: z.number().int().optional(),
  closingBalanceMinor: z.number().int().optional(),
  closingBalanceEconomicNature: z.enum(["asset", "liability"]).optional(),
  coverage: z.record(z.string(), z.any()).optional(),
  sourceState: z.enum(["legacy", "committed", "superseded"]).optional(),
  commitOperation: z.union([z.string(), z.number(), RecordID_z]).optional(),
  committedAt: z.string().optional(),
  replacementOf: z.union([z.string(), z.number(), RecordID_z]).optional(),
  importedAt: z.string(),
  statementDate: z.string().optional(),
  status: z.enum(["raw", "parsed", "matched", "reviewed", "error"]),
  rowCount: z.number().optional(),
  componentCount: z.number().optional(),
  issueCount: z.number().optional(),
  revision: z.number().int(),
  normalizedCount: z.number().optional(),
  clarificationCount: z.number().optional(),
  sourceChecksum: z.string().optional(),
  notes: z.string().optional(),
});

export type StatementImport = z.infer<typeof Z_StatementImport>;
