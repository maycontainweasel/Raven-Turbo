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
  sourceFormat: z.enum(["csv", "ofx", "qif", "pdf", "manual"]),
  importedAt: z.string(),
  statementDate: z.string().optional(),
  status: z.enum(["raw", "parsed", "matched", "reviewed", "error"]),
  rowCount: z.number().optional(),
  normalizedCount: z.number().optional(),
  clarificationCount: z.number().optional(),
  sourceChecksum: z.string().optional(),
  notes: z.string().optional(),
});

export type StatementImport = z.infer<typeof Z_StatementImport>;
