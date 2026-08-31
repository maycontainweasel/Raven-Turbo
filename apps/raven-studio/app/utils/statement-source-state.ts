export type StatementSourceState = "committed" | "legacy" | "superseded";
export type StatementPeriodState =
  | "committed_pending"
  | "exceptions"
  | "ready"
  | "reconciled"
  | "reopened";

export type StatementPeriodReconciliation = Readonly<{
  attestationState: "open" | "ready" | "reconciled" | "reopened";
  counts: Readonly<{
    activeIssueCount: number;
    blockingIssueCount: number;
  }>;
}>;

export function statementSourceStateLabel(
  sourceState: StatementSourceState,
): string {
  if (sourceState === "legacy") {
    return "Legacy import — source authority not yet verified";
  }
  if (sourceState === "superseded") return "Superseded source";
  return "ST-01 committed source";
}

export function statementPeriodState(
  sourceState: StatementSourceState,
  reconciliation: StatementPeriodReconciliation | null | undefined,
): StatementPeriodState {
  if (sourceState !== "committed" || !reconciliation) {
    return "committed_pending";
  }
  if (reconciliation.attestationState === "reconciled") return "reconciled";
  if (reconciliation.attestationState === "reopened") return "reopened";
  if (
    reconciliation.counts.blockingIssueCount > 0 ||
    reconciliation.counts.activeIssueCount > 0
  ) {
    return "exceptions";
  }
  if (reconciliation.attestationState === "ready") return "ready";
  return "committed_pending";
}

export function statementPeriodStateLabel(state: StatementPeriodState): string {
  return {
    committed_pending: "Committed — resolution pending",
    exceptions: "Exceptions present",
    ready: "Ready to attest",
    reconciled: "Reconciled",
    reopened: "Reopened",
  }[state];
}
