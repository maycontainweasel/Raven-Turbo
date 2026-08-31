import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import {
  createStatementTruthTransportHandlers,
  RavenDomainError,
  statementTruthInputSchemas,
  type StatementTruthApi,
} from "@raven/domain/server";
import { z } from "zod";

const selection = statementTruthInputSchemas.selection.shape;

function result(value: unknown) {
  return {
    content: [{ type: "text" as const, text: JSON.stringify(value, null, 2) }],
    structuredContent: value as Record<string, unknown>,
  };
}

function errorResult(error: unknown) {
  const payload =
    error instanceof RavenDomainError
      ? { code: error.code, message: error.message, details: error.details }
      : {
          code: "INTERNAL",
          message:
            error instanceof Error ? error.message : "Unknown Raven error",
        };
  return {
    isError: true,
    content: [
      { type: "text" as const, text: JSON.stringify(payload, null, 2) },
    ],
    structuredContent: payload,
  };
}

function register(
  server: McpServer,
  name: string,
  description: string,
  inputSchema: Record<string, z.ZodType>,
  handler: (input: any) => Promise<unknown>,
) {
  server.registerTool(name, { description, inputSchema }, async (input) => {
    try {
      return result(await handler(input));
    } catch (error) {
      return errorResult(error);
    }
  });
}

export function registerStatementTruthTools(
  server: McpServer,
  service: StatementTruthApi,
): void {
  const handlers = createStatementMcpHandlers(service);
  register(
    server,
    "stage_statement_source",
    "Stage a statement file from the configured private inbox. The path is contained and never returned.",
    statementTruthInputSchemas.stageLocalPath.shape,
    (input) =>
      handlers.stage_statement_source({ transport: "local_path", ...input }),
  );
  register(
    server,
    "list_statement_profiles",
    "List supported versioned statement extraction profiles.",
    {},
    () => handlers.list_statement_profiles(),
  );
  register(
    server,
    "detect_statement_profile",
    "Return advisory profile candidates for a staged source without confirming one.",
    statementTruthInputSchemas.sourceRef.shape,
    handlers.detect_statement_profile,
  );
  register(
    server,
    "preview_statement_import",
    "Preview neutral statement rows, components, balances and issues without a database write.",
    selection,
    handlers.preview_statement_import,
  );
  register(
    server,
    "validate_statement_preview",
    "Re-open and revalidate a no-write preview hash.",
    statementTruthInputSchemas.validate.shape,
    handlers.validate_statement_preview,
  );
  register(
    server,
    "commit_statement_import",
    "Atomically commit immutable source rows, components and non-blocking issues without creating Transactions.",
    statementTruthInputSchemas.commitClient.shape,
    (input) => handlers.commit_statement_import({ ...input, channel: "mcp" }),
  );
  register(
    server,
    "list_statement_imports",
    "List committed source imports for one account and optional period.",
    statementTruthInputSchemas.listImports.shape,
    handlers.list_statement_imports,
  );
  register(
    server,
    "get_statement_import",
    "Read one committed source import with its rows, components and issues.",
    statementTruthInputSchemas.importRead.shape,
    handlers.get_statement_import,
  );
  register(
    server,
    "list_statement_rows",
    "List immutable printed rows for one committed source.",
    statementTruthInputSchemas.importRead.shape,
    handlers.list_statement_rows,
  );
  register(
    server,
    "get_statement_row",
    "Read one immutable source row with nested source components and issues.",
    statementTruthInputSchemas.rowRead.shape,
    handlers.get_statement_row,
  );
  register(
    server,
    "list_statement_row_components",
    "List exact neutral source components by import or row.",
    statementTruthInputSchemas.componentsRead.shape,
    handlers.list_statement_row_components,
  );
  register(
    server,
    "get_statement_row_component",
    "Read one exact neutral source component and signed balance effect.",
    statementTruthInputSchemas.componentRead.shape,
    handlers.get_statement_row_component,
  );
  register(
    server,
    "list_statement_import_issues",
    "List source issues separately from management clarification tasks.",
    statementTruthInputSchemas.importRead.shape,
    handlers.list_statement_import_issues,
  );
  register(
    server,
    "get_statement_import_issue",
    "Read one committed non-blocking source issue.",
    statementTruthInputSchemas.issueRead.shape,
    handlers.get_statement_import_issue,
  );
  register(
    server,
    "list_statement_match_candidates",
    "List deterministic source-to-Transaction suggestions. Candidates are advisory only and never write or confirm evidence.",
    statementTruthInputSchemas.matchCandidates.shape,
    handlers.list_statement_match_candidates,
  );
  register(
    server,
    "list_statement_transaction_matches",
    "List audited statement match proposals, confirmations, rejections, and superseded history.",
    statementTruthInputSchemas.matches.shape,
    handlers.list_statement_transaction_matches,
  );
  register(
    server,
    "get_statement_transaction_match",
    "Read one audited source-to-Transaction match and its exact component membership.",
    statementTruthInputSchemas.matchRead.shape,
    handlers.get_statement_transaction_match,
  );
  register(
    server,
    "get_statement_reconciliation",
    "Read the exact source equation, resolution coverage, issues, and append-only attestation history. Reconciliation does not mean Category or tax completion.",
    statementTruthInputSchemas.reconciliationRead.shape,
    handlers.get_statement_reconciliation,
  );
  register(
    server,
    "propose_statement_transaction_match",
    "Persist an audited proposal after exact invariant checks. This is still a suggestion and does not make the Transaction statement-backed.",
    statementTruthInputSchemas.proposeMatch.shape,
    (input) =>
      handlers.propose_statement_transaction_match({
        ...input,
        channel: "mcp",
      }),
  );
  register(
    server,
    "confirm_statement_transaction_match",
    "Explicitly confirm one reviewed match as an audited act. It links bank evidence to one existing Transaction without creating a duplicate movement.",
    statementTruthInputSchemas.confirmMatch.shape,
    (input) =>
      handlers.confirm_statement_transaction_match({
        ...input,
        channel: "mcp",
      }),
  );
  register(
    server,
    "materialize_statement_component_transaction",
    "Explicitly create exactly one observed Transaction and confirmed evidence match from unresolved movement components. It creates no accepted management or tax meaning.",
    statementTruthInputSchemas.materialize.shape,
    (input) =>
      handlers.materialize_statement_component_transaction({
        ...input,
        channel: "mcp",
      }),
  );
  register(
    server,
    "reject_statement_transaction_match",
    "Reject a proposal with audited reason and revision while preserving source and Transaction facts.",
    statementTruthInputSchemas.rejectMatch.shape,
    (input) =>
      handlers.reject_statement_transaction_match({
        ...input,
        channel: "mcp",
      }),
  );
  register(
    server,
    "supersede_statement_transaction_match",
    "Replace a reviewed match through append-only lineage and atomic active-claim transfer.",
    statementTruthInputSchemas.supersedeMatch.shape,
    (input) =>
      handlers.supersede_statement_transaction_match({
        ...input,
        channel: "mcp",
      }),
  );
  register(
    server,
    "acknowledge_statement_issue",
    "Acknowledge one non-blocking source issue under revision. Blocking issues cannot be waived.",
    statementTruthInputSchemas.acknowledgeIssue.shape,
    (input) =>
      handlers.acknowledge_statement_issue({ ...input, channel: "mcp" }),
  );
  register(
    server,
    "supersede_statement_import",
    "Atomically replace one committed source with a separately staged and reviewed source while preserving immutable history. Private Historian operation is not authorised.",
    statementTruthInputSchemas.supersedeImport.shape,
    (input) =>
      handlers.supersede_statement_import({ ...input, channel: "mcp" }),
  );
  register(
    server,
    "recalculate_statement_reconciliation",
    "Recalculate the exact source equation and resolution coverage without assigning Category, management, or tax meaning.",
    statementTruthInputSchemas.recalculate.shape,
    (input) =>
      handlers.recalculate_statement_reconciliation({
        ...input,
        channel: "mcp",
      }),
  );
  register(
    server,
    "attest_statement_reconciled",
    "Explicitly attest an exact, complete, zero-difference statement result. This does not attest management classification or tax treatment.",
    statementTruthInputSchemas.attest.shape,
    (input) =>
      handlers.attest_statement_reconciled({ ...input, channel: "mcp" }),
  );
  register(
    server,
    "reopen_statement_reconciliation",
    "Append an audited reopening event with reason while preserving every prior attestation.",
    statementTruthInputSchemas.reopen.shape,
    (input) =>
      handlers.reopen_statement_reconciliation({ ...input, channel: "mcp" }),
  );
  register(
    server,
    "preview_legacy_statement_resolution",
    "Privately project one exact selected-source legacy crosswalk without a database write. Returns exact reviewed items plus aggregate-safe counts and never returns source bytes or paths.",
    statementTruthInputSchemas.legacyPreview.shape,
    handlers.preview_legacy_statement_resolution,
  );
  register(
    server,
    "apply_legacy_statement_resolution",
    "Atomically apply one exact reviewed legacy-resolution crosswalk. This command has no force, tolerance, inference, or conflict-skipping mode.",
    statementTruthInputSchemas.legacyApply.shape,
    (input) =>
      handlers.apply_legacy_statement_resolution({ ...input, channel: "mcp" }),
  );
  register(
    server,
    "reverse_legacy_statement_resolution",
    "Append an exact guarded reversal of one legacy-resolution apply while preserving all source, movement, match, claim, reconciliation, resolution, and operation history.",
    statementTruthInputSchemas.legacyReverse.shape,
    (input) =>
      handlers.reverse_legacy_statement_resolution({
        ...input,
        channel: "mcp",
      }),
  );
}

export function createStatementMcpHandlers(service: StatementTruthApi) {
  return createStatementTruthTransportHandlers(service).mcp;
}
