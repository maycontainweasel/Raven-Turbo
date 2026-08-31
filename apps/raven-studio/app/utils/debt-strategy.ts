import type { TransactionView } from "@raven/domain";

export type DebtFacilityKind = "credit_card" | "overdraft";

export type BankCostCategory =
  | "interest"
  | "maintenance_fee"
  | "facility_fee"
  | "service_fee"
  | "fee_vat"
  | "electronic_payment_fee"
  | "declined_fee"
  | "returned_repayment_fee"
  | "cash_advance_fee"
  | "cross_border_fee"
  | "statement_fee"
  | "notification_fee";

export type ClassifiedBankCost = Readonly<{
  transaction: TransactionView;
  category: BankCostCategory;
  signedMinorUnits: number;
}>;

export type DebtProjectionInput = Readonly<{
  creditBalanceMinor: number;
  overdraftBalanceMinor: number;
  creditAnnualRate: number;
  overdraftAnnualRate: number;
  creditMonthlyFeeReserveMinor: number;
  overdraftMonthlyFeeReserveMinor: number;
  monthlyPaymentMinor: number;
}>;

export type DebtProjection = Readonly<{
  months: number;
  totalInterestMinor: number;
  totalFeeReserveMinor: number;
  totalPaidMinor: number;
  completed: boolean;
}>;

export const bankCostLabels: Record<BankCostCategory, string> = {
  interest: "Interest / finance charges",
  maintenance_fee: "Maintenance fees",
  facility_fee: "Facility fees",
  service_fee: "Service fees",
  fee_vat: "VAT on bank fees",
  electronic_payment_fee: "Electronic payment fees",
  declined_fee: "Declined / insufficient-funds fees",
  returned_repayment_fee: "Returned repayment fees",
  cash_advance_fee: "Cash advance fees",
  cross_border_fee: "Cross-border fees",
  statement_fee: "Statement fees",
  notification_fee: "Notification fees",
};

function normalizedDescription(description: string): string {
  return description
    .toLocaleUpperCase()
    .replace(/[^A-Z0-9]+/g, " ")
    .trim();
}

export function classifyBankCost(
  facilityKind: DebtFacilityKind,
  description: string,
): BankCostCategory | null {
  const value = normalizedDescription(description);
  const compactValue = value.replace(/\s+/g, "");

  if (facilityKind === "credit_card") {
    if (value.includes("FINANCE CHARGE")) return "interest";
    if (value.includes("TOTAL V A T") || value.includes("VAT ON FEE")) {
      return "fee_vat";
    }
    if (value.includes("MAINTENANCE FEE")) return "maintenance_fee";
    if (
      value.includes("CREDIT FACILITY SERVIC") ||
      value.includes("CREDIT FACILITY FEE") ||
      value.includes("FACILITY SERVICE FEE")
    ) {
      return "facility_fee";
    }
    if (value.includes("ELECTRONIC PAYMENT FEE")) {
      return "electronic_payment_fee";
    }
    if (value.includes("DECLINED") && value.includes("INSUFFICIENT")) {
      return "declined_fee";
    }
    if (compactValue.includes("RETURNEDAPO") && value.includes("FEE")) {
      return "returned_repayment_fee";
    }
    if (value.includes("CASH ADVANCE FEE")) return "cash_advance_fee";
    if (value.includes("CROSS BORDER") && value.includes("FEE")) {
      return "cross_border_fee";
    }
    return null;
  }

  if (value.includes("INTEREST")) return "interest";
  if (value.includes("MAINTENANCE FEE")) return "maintenance_fee";
  if (value.includes("FACILITY FEE")) return "facility_fee";
  if (value.includes("SERVICE FEE")) return "service_fee";
  if (value.includes("DIGITAL STATEMENT FEE")) return "statement_fee";
  if (
    (value.includes("NO FUNDS") || value.includes("NOFUNDS")) &&
    (value.includes("ALERT") || value.includes("SMS"))
  ) {
    return "notification_fee";
  }
  if (
    value.includes("NOTIFICATION") ||
    value.includes("EMAIL FEE") ||
    value.includes("E MAIL FEE")
  ) {
    return "notification_fee";
  }
  return null;
}

export function classifyStatementBackedCosts(
  facilityKind: DebtFacilityKind,
  transactions: readonly TransactionView[],
  statementCutoff: string | null,
): ClassifiedBankCost[] {
  return transactions.flatMap((transaction) => {
    if (transaction.ledgerAuthority !== "active") return [];
    const category = classifyBankCost(facilityKind, transaction.description);
    if (!category || !transaction.amount || !transaction.financialDate)
      return [];

    const statementBacked = transaction.evidenceState === "statement_backed";
    const postStatementObservation =
      facilityKind === "credit_card" &&
      transaction.evidenceState === "provisional" &&
      Boolean(statementCutoff) &&
      transaction.financialDate > statementCutoff!;
    if (!statementBacked && !postStatementObservation) return [];

    const reversal =
      facilityKind === "overdraft" &&
      normalizedDescription(transaction.description).includes("REVERSAL");
    return [
      {
        transaction,
        category,
        signedMinorUnits:
          Math.abs(transaction.amount.minorUnits) * (reversal ? -1 : 1),
      },
    ];
  });
}

export function monthSequence(
  fromMonth: string,
  throughMonth: string,
): string[] {
  const [fromYear, fromValue] = fromMonth.split("-").map(Number);
  const [throughYear, throughValue] = throughMonth.split("-").map(Number);
  const months: string[] = [];
  const cursor = new Date(Date.UTC(fromYear!, fromValue! - 1, 1));
  const end = new Date(Date.UTC(throughYear!, throughValue! - 1, 1));
  while (cursor <= end) {
    months.push(
      `${cursor.getUTCFullYear()}-${String(cursor.getUTCMonth() + 1).padStart(2, "0")}`,
    );
    cursor.setUTCMonth(cursor.getUTCMonth() + 1);
  }
  return months;
}

export function simulateCreditFirstPayoff(
  input: DebtProjectionInput,
): DebtProjection {
  let creditBalance = Math.max(0, input.creditBalanceMinor);
  let overdraftBalance = Math.max(0, input.overdraftBalanceMinor);
  let totalInterestMinor = 0;
  let totalFeeReserveMinor = 0;
  let totalPaidMinor = 0;
  let months = 0;

  while ((creditBalance > 0 || overdraftBalance > 0) && months < 360) {
    months += 1;
    const creditInterest = Math.round(
      (creditBalance * input.creditAnnualRate) / 12,
    );
    const overdraftInterest = Math.round(
      (overdraftBalance * input.overdraftAnnualRate) / 12,
    );
    const creditFees =
      creditBalance > 0 ? input.creditMonthlyFeeReserveMinor : 0;
    const overdraftFees =
      overdraftBalance > 0 ? input.overdraftMonthlyFeeReserveMinor : 0;

    creditBalance += creditInterest + creditFees;
    overdraftBalance += overdraftInterest + overdraftFees;
    totalInterestMinor += creditInterest + overdraftInterest;
    totalFeeReserveMinor += creditFees + overdraftFees;

    let payment = Math.max(0, input.monthlyPaymentMinor);
    if (creditBalance > 0 && overdraftBalance > 0) {
      const overdraftHold = Math.min(
        payment,
        overdraftBalance,
        overdraftInterest + overdraftFees,
      );
      overdraftBalance -= overdraftHold;
      payment -= overdraftHold;
      totalPaidMinor += overdraftHold;
    }

    const creditPayment = Math.min(payment, creditBalance);
    creditBalance -= creditPayment;
    payment -= creditPayment;
    totalPaidMinor += creditPayment;

    const overdraftPayment = Math.min(payment, overdraftBalance);
    overdraftBalance -= overdraftPayment;
    totalPaidMinor += overdraftPayment;

    if (
      input.monthlyPaymentMinor <= 0 ||
      (creditPayment === 0 && overdraftPayment === 0)
    ) {
      break;
    }
  }

  return {
    months,
    totalInterestMinor,
    totalFeeReserveMinor,
    totalPaidMinor,
    completed: creditBalance <= 0 && overdraftBalance <= 0,
  };
}
