import type {
  FacilitySnapshotRecord,
  FacilitySnapshotView,
} from "./contracts.js";
import { money } from "./money.js";

function optionalMoney(
  currency: string,
  minorUnits?: number | null,
): FacilitySnapshotView["facilityLimit"] {
  return minorUnits == null
    ? null
    : money({ currency, minorUnits }, { nonNegative: true });
}

export function toFacilitySnapshotView(
  snapshot: FacilitySnapshotRecord,
): FacilitySnapshotView {
  return {
    snapshotId: snapshot.id,
    facilityKind: snapshot.facilityKind,
    asOf: snapshot.asOf,
    effectiveFrom: snapshot.effectiveFrom ?? null,
    recordedAt: snapshot.recordedAt,
    evidenceLevel: snapshot.evidenceLevel,
    sourceKind: snapshot.sourceKind,
    sourceRef: snapshot.sourceRef ?? null,
    statementImportId: snapshot.statementImportId ?? null,
    facilityLimit: optionalMoney(
      snapshot.currency,
      snapshot.facilityLimitMinor,
    ),
    availableCredit: optionalMoney(
      snapshot.currency,
      snapshot.availableCreditMinor,
    ),
    minimumPayment: optionalMoney(
      snapshot.currency,
      snapshot.minimumPaymentMinor,
    ),
    paymentDueOn: snapshot.paymentDueOn ?? null,
    interestRates: snapshot.interestRates,
    feeTerms: snapshot.feeTerms,
    terms: snapshot.terms,
    note: snapshot.notes ?? null,
  };
}
