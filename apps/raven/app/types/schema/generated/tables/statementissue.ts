import { z } from 'zod';
import { RecordID_z } from '../core';

export const StatementIssueIdSubId_z = z.string();

export const StatementIssueId_z = RecordID_z.extend({
  tb: z.literal('statementIssue'),
  id: StatementIssueIdSubId_z,
});
export type StatementIssueIdSubId = z.infer<typeof StatementIssueIdSubId_z>;
export type StatementIssueId = z.infer<typeof StatementIssueId_z>;

export const Z_StatementIssue = z.object({
  id: StatementIssueId_z.optional(),
  space: z.union([z.string(), z.number(), RecordID_z]),
  account: z.union([z.string(), z.number(), RecordID_z]),
  statementImport: z.union([z.string(), z.number(), RecordID_z]),
  statementRow: z.union([z.string(), z.number(), RecordID_z]).optional(),
  statementRowComponent: z.union([z.string(), z.number(), RecordID_z]).optional(),
  key: z.string(),
  code: z.string(),
  severity: z.enum(["info", "warning", "blocking"]),
  blocking: z.boolean(),
  state: z.enum(["open", "acknowledged", "resolved", "superseded"]),
  message: z.string(),
  revision: z.number().int(),
  detectedOperation: z.union([z.string(), z.number(), RecordID_z]),
  dispositionOperation: z.union([z.string(), z.number(), RecordID_z]).optional(),
  detectedAt: z.string(),
  acknowledgedAt: z.string().optional(),
  resolvedAt: z.string().optional(),
  reviewedBy: z.string().optional(),
  notes: z.string().optional(),
});

export type StatementIssue = z.infer<typeof Z_StatementIssue>;
