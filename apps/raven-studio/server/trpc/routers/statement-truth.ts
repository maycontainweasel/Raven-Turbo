import {
  createStatementTruthTransportHandlers,
  RavenDomainError,
  statementTruthInputSchemas,
} from "@raven/domain/server";
import { TRPCError } from "@trpc/server";
import { t } from "@schema/server/trpc/context";
import { getStatementTruthService } from "../../services/statement-truth";

function domainError(error: unknown): never {
  if (!(error instanceof RavenDomainError)) throw error;
  const code =
    error.code === "NOT_FOUND" || error.code === "STATEMENT_SOURCE_NOT_FOUND"
      ? "NOT_FOUND"
      : error.code === "IDEMPOTENCY_CONFLICT" ||
          error.code === "STATEMENT_PREVIEW_STALE" ||
          error.code === "STATEMENT_IMMUTABLE_CONFLICT" ||
          error.code === "STATEMENT_DUPLICATE_SOURCE" ||
          error.code === "STATEMENT_LEGACY_PERIOD_CONFLICT" ||
          error.code === "STATEMENT_LEGACY_COMPATIBILITY_REQUIRED" ||
          error.code === "STATEMENT_MATCH_CONFLICT" ||
          error.code === "STATEMENT_COMPONENT_ALREADY_DISPOSED" ||
          error.code === "STATEMENT_TRANSACTION_ALREADY_MATCHED" ||
          error.code === "STATEMENT_RECONCILIATION_STALE" ||
          error.code === "STATEMENT_RECONCILIATION_ALREADY_ATTESTED" ||
          error.code === "STATEMENT_SOURCE_SUPERSESSION_CONFLICT" ||
          error.code === "STATEMENT_IMPORT_SUPERSEDED" ||
          error.code === "STATEMENT_LEGACY_SOURCE_STALE" ||
          error.code === "STATEMENT_LEGACY_ACCOUNT_CONTEXT_DRIFT" ||
          error.code === "STATEMENT_LEGACY_EVIDENCE_DRIFT" ||
          error.code === "STATEMENT_LEGACY_CROSSWALK_DRIFT" ||
          error.code === "STATEMENT_LEGACY_ACTIVE_CLAIM_CONFLICT" ||
          error.code === "STATEMENT_LEGACY_DUPLICATE_ACTIVE_MOVEMENT" ||
          error.code === "STATEMENT_LEGACY_REPLAY_CONFLICT" ||
          error.code === "STATEMENT_LEGACY_ROLLBACK_INELIGIBLE"
        ? "CONFLICT"
        : error.code === "INTERNAL"
          ? "INTERNAL_SERVER_ERROR"
          : "BAD_REQUEST";
  throw new TRPCError({ code, message: error.message, cause: error });
}

function handlers(ctx: Parameters<typeof getStatementTruthService>[0]) {
  return createStatementTruthTransportHandlers(getStatementTruthService(ctx))
    .trpc;
}

export const statementTruthRouter = t.router({
  stageStatementSource: t.procedure
    .input(statementTruthInputSchemas.stageUpload)
    .mutation(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).stageStatementSource({
          transport: "upload",
          ...input,
        });
      } catch (error) {
        domainError(error);
      }
    }),
  listStatementProfiles: t.procedure.query(async ({ ctx }) => {
    try {
      return await handlers(ctx).listStatementProfiles();
    } catch (error) {
      domainError(error);
    }
  }),
  detectStatementProfile: t.procedure
    .input(statementTruthInputSchemas.sourceRef)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).detectStatementProfile(input);
      } catch (error) {
        domainError(error);
      }
    }),
  previewStatementImport: t.procedure
    .input(statementTruthInputSchemas.selection)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).previewStatementImport(input);
      } catch (error) {
        domainError(error);
      }
    }),
  validateStatementPreview: t.procedure
    .input(statementTruthInputSchemas.validate)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).validateStatementPreview(input);
      } catch (error) {
        domainError(error);
      }
    }),
  commitStatementImport: t.procedure
    .input(statementTruthInputSchemas.commitClient)
    .mutation(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).commitStatementImport({
          ...input,
          channel: "ui",
        });
      } catch (error) {
        domainError(error);
      }
    }),
  listStatementImports: t.procedure
    .input(statementTruthInputSchemas.listImports)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).listStatementImports(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getStatementImport: t.procedure
    .input(statementTruthInputSchemas.importRead)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).getStatementImport(input);
      } catch (error) {
        domainError(error);
      }
    }),
  listStatementRows: t.procedure
    .input(statementTruthInputSchemas.importRead)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).listStatementRows(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getStatementRow: t.procedure
    .input(statementTruthInputSchemas.rowRead)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).getStatementRow(input);
      } catch (error) {
        domainError(error);
      }
    }),
  listStatementRowComponents: t.procedure
    .input(statementTruthInputSchemas.componentsRead)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).listStatementRowComponents(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getStatementRowComponent: t.procedure
    .input(statementTruthInputSchemas.componentRead)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).getStatementRowComponent(input);
      } catch (error) {
        domainError(error);
      }
    }),
  listStatementImportIssues: t.procedure
    .input(statementTruthInputSchemas.importRead)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).listStatementImportIssues(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getStatementImportIssue: t.procedure
    .input(statementTruthInputSchemas.issueRead)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).getStatementImportIssue(input);
      } catch (error) {
        domainError(error);
      }
    }),
  listStatementMatchCandidates: t.procedure
    .input(statementTruthInputSchemas.matchCandidates)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).listStatementMatchCandidates(input);
      } catch (error) {
        domainError(error);
      }
    }),
  listStatementTransactionMatches: t.procedure
    .input(statementTruthInputSchemas.matches)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).listStatementTransactionMatches(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getStatementTransactionMatch: t.procedure
    .input(statementTruthInputSchemas.matchRead)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).getStatementTransactionMatch(input);
      } catch (error) {
        domainError(error);
      }
    }),
  getStatementReconciliation: t.procedure
    .input(statementTruthInputSchemas.reconciliationRead)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).getStatementReconciliation(input);
      } catch (error) {
        domainError(error);
      }
    }),
  proposeStatementTransactionMatch: t.procedure
    .input(statementTruthInputSchemas.proposeMatch)
    .mutation(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).proposeStatementTransactionMatch({
          ...input,
          channel: "ui",
        });
      } catch (error) {
        domainError(error);
      }
    }),
  confirmStatementTransactionMatch: t.procedure
    .input(statementTruthInputSchemas.confirmMatch)
    .mutation(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).confirmStatementTransactionMatch({
          ...input,
          channel: "ui",
        });
      } catch (error) {
        domainError(error);
      }
    }),
  materializeStatementComponentTransaction: t.procedure
    .input(statementTruthInputSchemas.materialize)
    .mutation(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).materializeStatementComponentTransaction({
          ...input,
          channel: "ui",
        });
      } catch (error) {
        domainError(error);
      }
    }),
  rejectStatementTransactionMatch: t.procedure
    .input(statementTruthInputSchemas.rejectMatch)
    .mutation(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).rejectStatementTransactionMatch({
          ...input,
          channel: "ui",
        });
      } catch (error) {
        domainError(error);
      }
    }),
  supersedeStatementTransactionMatch: t.procedure
    .input(statementTruthInputSchemas.supersedeMatch)
    .mutation(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).supersedeStatementTransactionMatch({
          ...input,
          channel: "ui",
        });
      } catch (error) {
        domainError(error);
      }
    }),
  acknowledgeStatementIssue: t.procedure
    .input(statementTruthInputSchemas.acknowledgeIssue)
    .mutation(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).acknowledgeStatementIssue({
          ...input,
          channel: "ui",
        });
      } catch (error) {
        domainError(error);
      }
    }),
  supersedeStatementImport: t.procedure
    .input(statementTruthInputSchemas.supersedeImport)
    .mutation(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).supersedeStatementImport({
          ...input,
          channel: "ui",
        });
      } catch (error) {
        domainError(error);
      }
    }),
  recalculateStatementReconciliation: t.procedure
    .input(statementTruthInputSchemas.recalculate)
    .mutation(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).recalculateStatementReconciliation({
          ...input,
          channel: "ui",
        });
      } catch (error) {
        domainError(error);
      }
    }),
  attestStatementReconciled: t.procedure
    .input(statementTruthInputSchemas.attest)
    .mutation(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).attestStatementReconciled({
          ...input,
          channel: "ui",
        });
      } catch (error) {
        domainError(error);
      }
    }),
  reopenStatementReconciliation: t.procedure
    .input(statementTruthInputSchemas.reopen)
    .mutation(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).reopenStatementReconciliation({
          ...input,
          channel: "ui",
        });
      } catch (error) {
        domainError(error);
      }
    }),
  previewLegacyStatementResolution: t.procedure
    .input(statementTruthInputSchemas.legacyPreview)
    .query(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).previewLegacyStatementResolution(input);
      } catch (error) {
        domainError(error);
      }
    }),
  applyLegacyStatementResolution: t.procedure
    .input(statementTruthInputSchemas.legacyApply)
    .mutation(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).applyLegacyStatementResolution({
          ...input,
          channel: "ui",
        });
      } catch (error) {
        domainError(error);
      }
    }),
  reverseLegacyStatementResolution: t.procedure
    .input(statementTruthInputSchemas.legacyReverse)
    .mutation(async ({ input, ctx }) => {
      try {
        return await handlers(ctx).reverseLegacyStatementResolution({
          ...input,
          channel: "ui",
        });
      } catch (error) {
        domainError(error);
      }
    }),
});

export type StatementTruthRouter = typeof statementTruthRouter;
