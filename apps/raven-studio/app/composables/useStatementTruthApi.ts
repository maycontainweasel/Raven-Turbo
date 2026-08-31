import type {
  CommitStatementImportInput,
  AcknowledgeStatementIssueInput,
  AttestStatementReconciledInput,
  ConfirmStatementTransactionMatchInput,
  DetectStatementProfileInput,
  GetStatementImportInput,
  GetStatementImportIssueInput,
  GetStatementRowComponentInput,
  GetStatementRowInput,
  ListStatementImportIssuesInput,
  ListStatementImportsInput,
  ListStatementRowComponentsInput,
  ListStatementRowsInput,
  ListStatementMatchCandidatesInput,
  ListStatementTransactionMatchesInput,
  MaterializeStatementComponentTransactionInput,
  PreviewStatementImportInput,
  ProposeStatementTransactionMatchInput,
  RecalculateStatementReconciliationInput,
  RejectStatementTransactionMatchInput,
  ReopenStatementReconciliationInput,
  SupersedeStatementImportInput,
  SupersedeStatementTransactionMatchInput,
  ValidateStatementPreviewInput,
  ApplyLegacyStatementResolutionInput,
  PreviewLegacyStatementResolutionInput,
  ReverseLegacyStatementResolutionInput,
} from "@raven/domain";

export function useStatementTruthApi() {
  const { $api } = useNuxtApp() as any;
  return {
    stageStatementSource: (input: {
      originalBytes: Uint8Array;
      mimeType: string;
      sourceKind: "pdf" | "csv" | "ofx" | "qif" | "image";
      extractionAssistBytes?: Uint8Array;
      extractionAssistMimeType?: "application/json";
    }) => $api.statementTruth.stageStatementSource.mutate(input),
    listStatementProfiles: () =>
      $api.statementTruth.listStatementProfiles.query(),
    detectStatementProfile: (input: DetectStatementProfileInput) =>
      $api.statementTruth.detectStatementProfile.query(input),
    previewStatementImport: (input: PreviewStatementImportInput) =>
      $api.statementTruth.previewStatementImport.query(input),
    validateStatementPreview: (input: ValidateStatementPreviewInput) =>
      $api.statementTruth.validateStatementPreview.query(input),
    commitStatementImport: (
      input: Omit<CommitStatementImportInput, "channel">,
    ) => $api.statementTruth.commitStatementImport.mutate(input),
    listStatementImports: (input: ListStatementImportsInput) =>
      $api.statementTruth.listStatementImports.query(input),
    getStatementImport: (input: GetStatementImportInput) =>
      $api.statementTruth.getStatementImport.query(input),
    listStatementRows: (input: ListStatementRowsInput) =>
      $api.statementTruth.listStatementRows.query(input),
    getStatementRow: (input: GetStatementRowInput) =>
      $api.statementTruth.getStatementRow.query(input),
    listStatementRowComponents: (input: ListStatementRowComponentsInput) =>
      $api.statementTruth.listStatementRowComponents.query(input),
    getStatementRowComponent: (input: GetStatementRowComponentInput) =>
      $api.statementTruth.getStatementRowComponent.query(input),
    listStatementImportIssues: (input: ListStatementImportIssuesInput) =>
      $api.statementTruth.listStatementImportIssues.query(input),
    getStatementImportIssue: (input: GetStatementImportIssueInput) =>
      $api.statementTruth.getStatementImportIssue.query(input),
    listStatementMatchCandidates: (input: ListStatementMatchCandidatesInput) =>
      $api.statementTruth.listStatementMatchCandidates.query(input),
    listStatementTransactionMatches: (
      input: ListStatementTransactionMatchesInput,
    ) => $api.statementTruth.listStatementTransactionMatches.query(input),
    getStatementTransactionMatch: (input: {
      statementTransactionMatchId: string;
    }) => $api.statementTruth.getStatementTransactionMatch.query(input),
    getStatementReconciliation: (input: { statementImportId: string }) =>
      $api.statementTruth.getStatementReconciliation.query(input),
    proposeStatementTransactionMatch: (
      input: Omit<ProposeStatementTransactionMatchInput, "channel">,
    ) => $api.statementTruth.proposeStatementTransactionMatch.mutate(input),
    confirmStatementTransactionMatch: (
      input: Omit<ConfirmStatementTransactionMatchInput, "channel">,
    ) => $api.statementTruth.confirmStatementTransactionMatch.mutate(input),
    materializeStatementComponentTransaction: (
      input: Omit<MaterializeStatementComponentTransactionInput, "channel">,
    ) =>
      $api.statementTruth.materializeStatementComponentTransaction.mutate(
        input,
      ),
    rejectStatementTransactionMatch: (
      input: Omit<RejectStatementTransactionMatchInput, "channel">,
    ) => $api.statementTruth.rejectStatementTransactionMatch.mutate(input),
    supersedeStatementTransactionMatch: (
      input: Omit<SupersedeStatementTransactionMatchInput, "channel">,
    ) => $api.statementTruth.supersedeStatementTransactionMatch.mutate(input),
    acknowledgeStatementIssue: (
      input: Omit<AcknowledgeStatementIssueInput, "channel">,
    ) => $api.statementTruth.acknowledgeStatementIssue.mutate(input),
    supersedeStatementImport: (
      input: Omit<SupersedeStatementImportInput, "channel">,
    ) => $api.statementTruth.supersedeStatementImport.mutate(input),
    recalculateStatementReconciliation: (
      input: Omit<RecalculateStatementReconciliationInput, "channel">,
    ) => $api.statementTruth.recalculateStatementReconciliation.mutate(input),
    attestStatementReconciled: (
      input: Omit<AttestStatementReconciledInput, "channel">,
    ) => $api.statementTruth.attestStatementReconciled.mutate(input),
    reopenStatementReconciliation: (
      input: Omit<ReopenStatementReconciliationInput, "channel">,
    ) => $api.statementTruth.reopenStatementReconciliation.mutate(input),
    previewLegacyStatementResolution: (
      input: PreviewLegacyStatementResolutionInput,
    ) => $api.statementTruth.previewLegacyStatementResolution.query(input),
    applyLegacyStatementResolution: (
      input: Omit<ApplyLegacyStatementResolutionInput, "channel">,
    ) => $api.statementTruth.applyLegacyStatementResolution.mutate(input),
    reverseLegacyStatementResolution: (
      input: Omit<ReverseLegacyStatementResolutionInput, "channel">,
    ) => $api.statementTruth.reverseLegacyStatementResolution.mutate(input),
  };
}
