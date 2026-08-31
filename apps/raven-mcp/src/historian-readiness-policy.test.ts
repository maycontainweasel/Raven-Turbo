import assert from "node:assert/strict";
import test from "node:test";
import { deriveHistorianReadinessPolicy } from "./historian-readiness-policy.js";

const readySurfaces = {
  semanticReady: true,
  vaultReady: true,
  genericReadOnly: true,
  databaseSchemaReady: true,
};

test("schema completeness does not authorize a pilot with legacy imports", () => {
  const result = deriveHistorianReadinessPolicy({
    ...readySurfaces,
    activeLegacyImports: 38,
    unmappableLegacyImports: 38,
  });
  assert.equal(result.status, "schema_ready_legacy_compatibility_unresolved");
  assert.equal(result.legacyCompatibility.status, "unresolved");
  assert.equal(result.selectedPeriodOccupancy.established, false);
  assert.equal(result.controlledPilot.authorized, false);
  assert.equal(result.controlledPilot.started, false);
});

test("even an aggregate-clear environment still requires period selection", () => {
  const result = deriveHistorianReadinessPolicy({
    ...readySurfaces,
    activeLegacyImports: 0,
    unmappableLegacyImports: 0,
  });
  assert.equal(result.status, "schema_ready_selection_required");
  assert.equal(result.controlledPilot.authorized, false);
});

test("an incomplete operational surface remains blocked", () => {
  const result = deriveHistorianReadinessPolicy({
    ...readySurfaces,
    databaseSchemaReady: false,
    activeLegacyImports: 0,
    unmappableLegacyImports: 0,
  });
  assert.equal(result.status, "blocked");
  assert.equal(result.controlledPilot.authorized, false);
});
