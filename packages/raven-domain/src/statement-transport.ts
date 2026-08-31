import type { StatementTruthApi } from "./statement-contracts.js";

export function createStatementTruthTransportHandlers(
  service: StatementTruthApi,
) {
  const trpc = {
    stageStatementSource: service.stageStatementSource.bind(service),
    listStatementProfiles: service.listStatementProfiles.bind(service),
    detectStatementProfile: service.detectStatementProfile.bind(service),
    previewStatementImport: service.previewStatementImport.bind(service),
    validateStatementPreview: service.validateStatementPreview.bind(service),
    commitStatementImport: service.commitStatementImport.bind(service),
    listStatementImports: service.listStatementImports.bind(service),
    getStatementImport: service.getStatementImport.bind(service),
    listStatementRows: service.listStatementRows.bind(service),
    getStatementRow: service.getStatementRow.bind(service),
    listStatementRowComponents:
      service.listStatementRowComponents.bind(service),
    getStatementRowComponent: service.getStatementRowComponent.bind(service),
    listStatementImportIssues: service.listStatementImportIssues.bind(service),
    getStatementImportIssue: service.getStatementImportIssue.bind(service),
    listStatementMatchCandidates:
      service.listStatementMatchCandidates.bind(service),
    listStatementTransactionMatches:
      service.listStatementTransactionMatches.bind(service),
    getStatementTransactionMatch:
      service.getStatementTransactionMatch.bind(service),
    getStatementReconciliation:
      service.getStatementReconciliation.bind(service),
    proposeStatementTransactionMatch:
      service.proposeStatementTransactionMatch.bind(service),
    confirmStatementTransactionMatch:
      service.confirmStatementTransactionMatch.bind(service),
    materializeStatementComponentTransaction:
      service.materializeStatementComponentTransaction.bind(service),
    rejectStatementTransactionMatch:
      service.rejectStatementTransactionMatch.bind(service),
    supersedeStatementTransactionMatch:
      service.supersedeStatementTransactionMatch.bind(service),
    acknowledgeStatementIssue: service.acknowledgeStatementIssue.bind(service),
    supersedeStatementImport: service.supersedeStatementImport.bind(service),
    recalculateStatementReconciliation:
      service.recalculateStatementReconciliation.bind(service),
    attestStatementReconciled: service.attestStatementReconciled.bind(service),
    reopenStatementReconciliation:
      service.reopenStatementReconciliation.bind(service),
    previewLegacyStatementResolution:
      service.previewLegacyStatementResolution.bind(service),
    applyLegacyStatementResolution:
      service.applyLegacyStatementResolution.bind(service),
    reverseLegacyStatementResolution:
      service.reverseLegacyStatementResolution.bind(service),
  };
  return {
    trpc,
    mcp: {
      stage_statement_source: trpc.stageStatementSource,
      list_statement_profiles: trpc.listStatementProfiles,
      detect_statement_profile: trpc.detectStatementProfile,
      preview_statement_import: trpc.previewStatementImport,
      validate_statement_preview: trpc.validateStatementPreview,
      commit_statement_import: trpc.commitStatementImport,
      list_statement_imports: trpc.listStatementImports,
      get_statement_import: trpc.getStatementImport,
      list_statement_rows: trpc.listStatementRows,
      get_statement_row: trpc.getStatementRow,
      list_statement_row_components: trpc.listStatementRowComponents,
      get_statement_row_component: trpc.getStatementRowComponent,
      list_statement_import_issues: trpc.listStatementImportIssues,
      get_statement_import_issue: trpc.getStatementImportIssue,
      list_statement_match_candidates: trpc.listStatementMatchCandidates,
      list_statement_transaction_matches: trpc.listStatementTransactionMatches,
      get_statement_transaction_match: trpc.getStatementTransactionMatch,
      get_statement_reconciliation: trpc.getStatementReconciliation,
      propose_statement_transaction_match:
        trpc.proposeStatementTransactionMatch,
      confirm_statement_transaction_match:
        trpc.confirmStatementTransactionMatch,
      materialize_statement_component_transaction:
        trpc.materializeStatementComponentTransaction,
      reject_statement_transaction_match: trpc.rejectStatementTransactionMatch,
      supersede_statement_transaction_match:
        trpc.supersedeStatementTransactionMatch,
      acknowledge_statement_issue: trpc.acknowledgeStatementIssue,
      supersede_statement_import: trpc.supersedeStatementImport,
      recalculate_statement_reconciliation:
        trpc.recalculateStatementReconciliation,
      attest_statement_reconciled: trpc.attestStatementReconciled,
      reopen_statement_reconciliation: trpc.reopenStatementReconciliation,
      preview_legacy_statement_resolution:
        trpc.previewLegacyStatementResolution,
      apply_legacy_statement_resolution: trpc.applyLegacyStatementResolution,
      reverse_legacy_statement_resolution:
        trpc.reverseLegacyStatementResolution,
    },
  };
}
