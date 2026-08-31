import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

test("the baseline plan is an editable local plan with reorderable categories, item breakdowns and tax funding", async () => {
  const [page, compactItem, editor, queryInput, planExport, layout] =
    await Promise.all([
      readFile(new URL("../pages/plan.vue", import.meta.url), "utf8"),
      readFile(
        new URL("../components/PlanCompactItem.vue", import.meta.url),
        "utf8",
      ),
      readFile(
        new URL("../components/PlanEditorDialog.vue", import.meta.url),
        "utf8",
      ),
      readFile(
        new URL("../components/RavenQueryInput.vue", import.meta.url),
        "utf8",
      ),
      readFile(new URL("./baselinePlanExport.ts", import.meta.url), "utf8"),
      readFile(new URL("../layouts/default.vue", import.meta.url), "utf8"),
    ]);

  assert.match(page, /raven\.baseline-plan\.v7/);
  assert.match(page, /"raven\.baseline-plan\.v6"/);
  assert.match(page, /"raven\.baseline-plan\.v1"/);
  assert.match(page, /version: 7/);
  assert.match(page, /personalSections: PlanSection\[\]/);
  assert.match(page, /businessSections: PlanSection\[\]/);
  assert.match(page, /taxTreatment: PlanTaxTreatment/);
  assert.match(page, /title: "Maintenance"/);
  assert.match(page, /Shared child and family obligations/);
  assert.match(page, /taxTreatment: "business_deductible"/);

  assert.match(page, /label: "Debt payments"/);
  assert.match(page, /monthlyRands: 20_000/);
  assert.match(page, /label: "Monthly maintenance payment"/);
  assert.match(page, /label: "School fees"/);
  assert.match(page, /monthlyRands: 8_333\.33/);
  assert.match(page, /label: "Play therapy"/);
  assert.match(page, /monthlyRands: 4_350/);
  assert.match(page, /label: "Transportation \/ fuel"/);
  assert.match(page, /label: "Groceries"/);
  assert.match(page, /label: "Medical aid"/);
  assert.match(page, /label: "Supplements"/);
  assert.match(page, /monthlyRands: 1_500/);
  assert.match(page, /label: "Haircuts \/ grooming"/);
  assert.match(page, /monthlyRands: 250/);
  assert.match(page, /label: "Clothing \/ shoes"/);
  assert.match(page, /label: "Business phone \/ data"/);
  assert.match(page, /monthlyRands: 450/);
  assert.doesNotMatch(
    page,
    /label: "(?:Gym|Life policy|Other personal insurance)/i,
  );

  assert.match(page, /<PlanEditorDialog/);
  assert.match(page, /openCreateItem/);
  assert.match(
    page,
    /function openCreateItem\(lane: PlanLane, sectionId = "", parentItemId = ""\)/,
  );
  assert.match(page, /openCreateItem\('personal', group\.section\.id\)/);
  assert.match(page, /openCreateItem\('business', group\.section\.id\)/);
  assert.match(page, /No budget items in this category yet\./);
  assert.match(page, /openCreateSection/);
  assert.match(page, /openEditSection/);
  assert.match(page, /taxTreatmentLabel/);
  assert.match(page, /startItemDrag/);
  assert.match(page, /dropItem/);
  assert.match(page, /startSectionDrag/);
  assert.match(page, /dropSection/);
  assert.match(page, /plan-section__grip/);
  assert.match(page, /normalizeItemHierarchy/);
  assert.match(page, /rootItemsFor/);
  assert.match(page, /subItemsFor/);
  assert.match(page, /subItemBalanceLabel/);
  assert.match(page, /parentItemId/);
  assert.match(page, /if \(existingHasChildren\)/);
  assert.match(page, /item\.sectionId = value\.sectionId/);
  assert.match(page, /allow-sub-items/);
  assert.match(page, /@add-sub-item/);
  assert.match(page, /nested/);
  assert.match(page, /draggable="true"/);
  assert.match(page, /Add\s+item/);
  assert.match(page, /Add\s+category/);
  assert.doesNotMatch(page, /Left column|Right column/);
  assert.doesNotMatch(page, /itemCountLabel/);
  assert.doesNotMatch(page, /class="plan-add"/);

  assert.match(page, /grossUpZaMonthlyNet\(personalTotal\.value\)/);
  assert.match(page, /calculateZaCompanyTax/);
  assert.match(page, /Estimated personal income tax/);
  assert.match(page, /Gross remuneration required/);
  assert.match(page, /PAYE \/ personal tax provision/);
  assert.match(page, /Planned taxable company profit/);
  assert.match(page, /Company income tax/);
  assert.match(page, /Required business revenue/);
  assert.match(page, /ZA_INDIVIDUAL_TAX_SOURCE_URL/);
  assert.match(page, /ZA_COMPANY_TAX_SOURCE_URL/);
  assert.match(page, /does not tax turnover at 27%/);

  assert.match(compactItem, /class="compact-plan-item__grip/);
  assert.match(compactItem, /class="compact-plan-item__summary"/);
  assert.match(compactItem, /class="compact-plan-item__pipe"/);
  assert.match(compactItem, /class="compact-plan-item__description"/);
  assert.match(compactItem, /:title="item\.note \|\| 'No description yet'"/);
  assert.match(compactItem, /class="compact-plan-item__value"/);
  assert.match(compactItem, /i-lucide-pencil/);
  assert.match(compactItem, /allowSubItems\?: boolean/);
  assert.match(compactItem, /nested\?: boolean/);
  assert.match(compactItem, /addSubItem/);
  assert.match(compactItem, /Add sub-item to/);
  assert.match(compactItem, /i-lucide-lock-keyhole/);
  assert.doesNotMatch(compactItem, /<form|<input|<textarea/);

  assert.match(editor, /import \{ Dialog \} from "@ark-ui\/vue\/dialog"/);
  assert.match(editor, /Category name/);
  assert.match(editor, /Category note/);
  assert.match(editor, /Tax treatment/);
  assert.match(editor, /Business-deductible expense/);
  assert.match(editor, /Monthly amount \(ZAR\)/);
  assert.match(editor, /<RavenQueryInput/);
  assert.match(editor, /v-model="form\.sectionId"/);
  assert.match(editor, /v-model="form\.parentItemId"/);
  assert.match(editor, /Parent budget item/);
  assert.match(editor, /v-model="form\.taxTreatment"/);
  assert.match(editor, /@create="createSection"/);
  assert.match(editor, /createdSections/);
  assert.doesNotMatch(editor, /<select/);
  assert.match(editor, /Remove/);

  assert.match(queryInput, /data-rqi/);
  assert.match(queryInput, /role="combobox"/);
  assert.match(queryInput, /role="listbox"/);
  assert.match(queryInput, /role="option"/);
  assert.match(queryInput, /event\.key !== "Enter"/);
  assert.match(queryInput, /emit\("create", label\)/);
  assert.match(queryInput, /Press Enter to create and select it/);
  assert.match(queryInput, /Search existing options/);
  assert.doesNotMatch(queryInput, /Search existing sections/);
  assert.match(page, /createdSections: PlanEditorSectionDraft\[\]/);

  assert.match(page, /@click="exportPlan"/);
  assert.match(page, />\s*Export\s*<\/button>/);
  assert.match(page, /buildBaselinePlanMarkdown/);
  assert.match(page, /baselinePlanExportFilename/);
  assert.match(page, /toggleSection/);
  assert.match(page, /aria-expanded/);
  assert.match(page, /Category total/);
  assert.match(page, /v-if="group\.section\.taxTreatment !== 'none'"/);
  assert.doesNotMatch(page, /Planning estimate, not statement truth/);
  assert.doesNotMatch(page, /Current position:/);
  assert.doesNotMatch(page, /Short-term priority:/);
  assert.doesNotMatch(page, /Saved in this browser/);
  assert.doesNotMatch(page, /A private working model/);
  assert.match(planExport, /## Business/);
  assert.match(planExport, /## Personal/);
  assert.match(planExport, /## Tax and funding summary/);
  assert.match(planExport, /## Orchestrator review brief/);
  assert.match(planExport, /subItems\?: BaselinePlanExportItem\[\]/);
  assert.match(planExport, /Breakdown:/);
  assert.match(planExport, /group\.section \? "Category" : "Uncategorized"/);
  assert.match(page, /window\.localStorage\.setItem/);
  assert.doesNotMatch(page, /\.mutate\(/);
  assert.doesNotMatch(page, /demo|sample data|mock data/i);
  assert.match(layout, /<NuxtLink to="\/plan"> Plan <\/NuxtLink>/);
  assert.match(layout, /route\.path\.startsWith\('\/plan'\)/);
});
