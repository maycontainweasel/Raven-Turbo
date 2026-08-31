export const ZA_TAX_YEAR_LABEL =
  "2027 tax year (1 March 2026 – 28 February 2027)";
export const ZA_PRIMARY_REBATE = 17_820;
export const ZA_UNDER_65_TAX_THRESHOLD = 99_000;
export const ZA_STANDARD_COMPANY_TAX_RATE = 0.27;
export const ZA_INDIVIDUAL_TAX_SOURCE_URL =
  "https://www.sars.gov.za/tax-rates/income-tax/rates-of-tax-for-individuals/";
export const ZA_COMPANY_TAX_SOURCE_URL =
  "https://www.sars.gov.za/budget-tax-guide-2026-web-version/";

export type ZaTaxBracket = {
  lower: number;
  upper: number | null;
  baseTax: number;
  rate: number;
};

export const ZA_INDIVIDUAL_TAX_BRACKETS: ZaTaxBracket[] = [
  { lower: 0, upper: 245_100, baseTax: 0, rate: 0.18 },
  { lower: 245_100, upper: 383_100, baseTax: 44_118, rate: 0.26 },
  { lower: 383_100, upper: 530_200, baseTax: 79_998, rate: 0.31 },
  { lower: 530_200, upper: 695_800, baseTax: 125_599, rate: 0.36 },
  { lower: 695_800, upper: 887_000, baseTax: 185_215, rate: 0.39 },
  { lower: 887_000, upper: 1_878_600, baseTax: 259_783, rate: 0.41 },
  { lower: 1_878_600, upper: null, baseTax: 666_339, rate: 0.45 },
];

export type ZaIndividualTaxEstimate = {
  annualTaxableIncome: number;
  annualTax: number;
  monthlyTax: number;
  marginalRate: number;
  annualNetIncome: number;
  monthlyNetIncome: number;
};

export type ZaGrossUpEstimate = ZaIndividualTaxEstimate & {
  targetMonthlyNet: number;
  grossMonthlyIncome: number;
};

function finiteNonNegative(value: number): number {
  return Number.isFinite(value) ? Math.max(0, value) : 0;
}

export function calculateZaIndividualTax(
  annualTaxableIncome: number,
): ZaIndividualTaxEstimate {
  const annualIncome = finiteNonNegative(annualTaxableIncome);
  const bracket =
    ZA_INDIVIDUAL_TAX_BRACKETS.find(
      (candidate) =>
        candidate.upper === null || annualIncome <= candidate.upper,
    ) ?? ZA_INDIVIDUAL_TAX_BRACKETS.at(-1)!;
  const grossTax =
    bracket.baseTax + (annualIncome - bracket.lower) * bracket.rate;
  const annualTax = Math.max(0, grossTax - ZA_PRIMARY_REBATE);
  const annualNetIncome = annualIncome - annualTax;

  return {
    annualTaxableIncome: annualIncome,
    annualTax,
    monthlyTax: annualTax / 12,
    marginalRate: bracket.rate,
    annualNetIncome,
    monthlyNetIncome: annualNetIncome / 12,
  };
}

export function grossUpZaMonthlyNet(
  targetMonthlyNet: number,
): ZaGrossUpEstimate {
  const targetNet = finiteNonNegative(targetMonthlyNet);
  const targetAnnualNet = targetNet * 12;

  if (targetAnnualNet === 0) {
    return {
      ...calculateZaIndividualTax(0),
      targetMonthlyNet: 0,
      grossMonthlyIncome: 0,
    };
  }

  let lower = targetAnnualNet;
  let upper = Math.max(targetAnnualNet * 2, ZA_UNDER_65_TAX_THRESHOLD);

  while (calculateZaIndividualTax(upper).annualNetIncome < targetAnnualNet) {
    upper *= 1.5;
  }

  for (let iteration = 0; iteration < 80; iteration += 1) {
    const midpoint = (lower + upper) / 2;
    const estimate = calculateZaIndividualTax(midpoint);

    if (estimate.annualNetIncome < targetAnnualNet) lower = midpoint;
    else upper = midpoint;
  }

  const estimate = calculateZaIndividualTax(upper);
  return {
    ...estimate,
    targetMonthlyNet: targetNet,
    grossMonthlyIncome: estimate.annualTaxableIncome / 12,
  };
}

export function calculateZaCompanyTax(annualTaxableProfit: number): number {
  return finiteNonNegative(annualTaxableProfit) * ZA_STANDARD_COMPANY_TAX_RATE;
}
