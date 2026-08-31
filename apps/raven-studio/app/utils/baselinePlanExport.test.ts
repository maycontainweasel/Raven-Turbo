import assert from "node:assert/strict";
import test from "node:test";

import {
  baselinePlanExportFilename,
  buildBaselinePlanMarkdown,
} from "./baselinePlanExport";

test("builds a business-first Markdown plan with category totals, item breakdowns and tax bridge", () => {
  const markdown = buildBaselinePlanMarkdown({
    generatedAt: new Date(2026, 7, 28),
    taxYearLabel: "2027 tax year",
    companyTaxRate: 0.27,
    business: {
      groups: [
        {
          section: {
            title: "Communication",
            note: "Operating communication costs.",
            taxLabel: "Business deductible",
          },
          items: [
            {
              label: "Business phone",
              monthlyRands: 450,
              note: "Monthly phone allowance.",
              subItems: [
                {
                  label: "Voice plan",
                  monthlyRands: 300,
                  note: "Core contract.",
                },
                {
                  label: "Data",
                  monthlyRands: 100,
                  note: "Working allocation.",
                },
              ],
            },
          ],
        },
      ],
      operatingTotal: 450,
      ownerNetFunding: 65_000,
      personalTaxProvision: 28_000,
      plannedTaxableProfit: 0,
      companyTaxProvision: 0,
      requiredRevenue: 93_450,
      annualRevenueTarget: 1_121_400,
    },
    personal: {
      groups: [
        {
          section: {
            title: "Maintenance",
            note: "Shared child obligations.",
            taxLabel: "No direct tax effect",
          },
          items: [
            {
              label: "School fees",
              monthlyRands: 8_333.33,
              note: "Monthly working share.",
            },
          ],
        },
      ],
      netNeed: 65_000,
      personalTaxProvision: 28_000,
      grossRemuneration: 93_000,
    },
  });

  assert.ok(markdown.indexOf("## Business") < markdown.indexOf("## Personal"));
  assert.match(markdown, /### Communication/);
  assert.match(markdown, /Category total: R\s?450,00/);
  assert.match(markdown, /Voice plan.*R\s?300,00/);
  assert.match(markdown, /Data.*R\s?100,00/);
  assert.match(
    markdown,
    /Breakdown: R\s?400,00 detailed; R\s?50,00 unallocated/,
  );
  assert.doesNotMatch(markdown, /Category total: R\s?850,00/);
  assert.match(markdown, /### Maintenance/);
  assert.match(markdown, /## Tax and funding summary/);
  assert.match(markdown, /Required business revenue/);
  assert.match(markdown, /## Orchestrator review brief/);
  assert.match(markdown, /planning model, not a bank-statement record/);
  assert.doesNotMatch(markdown, /No direct tax effect/);
});

test("uses a stable dated Markdown filename", () => {
  assert.equal(
    baselinePlanExportFilename(new Date(2026, 7, 28)),
    "raven-monthly-plan-2026-08-28.md",
  );
});
