export type HistorianReadinessStatus =
  | "blocked"
  | "schema_ready_legacy_compatibility_unresolved"
  | "schema_ready_selection_required";

export type HistorianReadinessPolicy = Readonly<{
  status: HistorianReadinessStatus;
  legacyCompatibility: Readonly<{
    status: "unresolved" | "aggregate_clear";
    activeLegacyImports: number;
    unmappableLegacyImports: number;
  }>;
  selectedPeriodOccupancy: Readonly<{
    established: false;
    status: "not_selected";
  }>;
  controlledPilot: Readonly<{
    authorized: false;
    started: false;
    nextGate: "HP-02";
  }>;
}>;

export function deriveHistorianReadinessPolicy(input: {
  semanticReady: boolean;
  vaultReady: boolean;
  genericReadOnly: boolean;
  databaseSchemaReady: boolean;
  activeLegacyImports: number;
  unmappableLegacyImports: number;
}): HistorianReadinessPolicy {
  const operationallyReady =
    input.semanticReady &&
    input.vaultReady &&
    input.genericReadOnly &&
    input.databaseSchemaReady;
  const legacyUnresolved = input.activeLegacyImports > 0;
  return {
    status: !operationallyReady
      ? "blocked"
      : legacyUnresolved
        ? "schema_ready_legacy_compatibility_unresolved"
        : "schema_ready_selection_required",
    legacyCompatibility: {
      status: legacyUnresolved ? "unresolved" : "aggregate_clear",
      activeLegacyImports: input.activeLegacyImports,
      unmappableLegacyImports: input.unmappableLegacyImports,
    },
    selectedPeriodOccupancy: {
      established: false,
      status: "not_selected",
    },
    controlledPilot: {
      authorized: false,
      started: false,
      nextGate: "HP-02",
    },
  };
}
