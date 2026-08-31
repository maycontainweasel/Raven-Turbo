import assert from "node:assert/strict";
import test from "node:test";

import {
  calculateZaCompanyTax,
  calculateZaIndividualTax,
  grossUpZaMonthlyNet,
  ZA_PRIMARY_REBATE,
  ZA_STANDARD_COMPANY_TAX_RATE,
  ZA_UNDER_65_TAX_THRESHOLD,
} from "./zaTax";

test("2027 individual tax applies the primary rebate and progressive brackets", () => {
  assert.equal(
    calculateZaIndividualTax(ZA_UNDER_65_TAX_THRESHOLD).annualTax,
    0,
  );
  assert.equal(
    calculateZaIndividualTax(245_100).annualTax,
    44_118 - ZA_PRIMARY_REBATE,
  );

  const estimate = calculateZaIndividualTax(1_000_000);
  assert.equal(estimate.marginalRate, 0.41);
  assert.equal(estimate.annualTax, 288_293);
});

test("gross-up returns the taxable remuneration needed to fund a net monthly plan", () => {
  const estimate = grossUpZaMonthlyNet(65_433.33);

  assert.ok(Math.abs(estimate.monthlyNetIncome - 65_433.33) < 0.01);
  assert.ok(Math.abs(estimate.grossMonthlyIncome - 93_713.7) < 0.01);
  assert.ok(Math.abs(estimate.monthlyTax - 28_280.37) < 0.01);
  assert.equal(estimate.marginalRate, 0.41);
});

test("general company income tax is calculated on profit rather than revenue", () => {
  assert.equal(calculateZaCompanyTax(0), 0);
  assert.equal(
    calculateZaCompanyTax(100_000),
    100_000 * ZA_STANDARD_COMPANY_TAX_RATE,
  );
});
