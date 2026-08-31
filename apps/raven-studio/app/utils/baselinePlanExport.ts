export type BaselinePlanExportItem = {
  label: string;
  monthlyRands: number;
  note: string;
  subItems?: BaselinePlanExportItem[];
};

export type BaselinePlanExportGroup = {
  section: null | {
    title: string;
    note: string;
    taxLabel: string;
  };
  items: BaselinePlanExportItem[];
};

export type BaselinePlanExportInput = {
  generatedAt: Date;
  taxYearLabel: string;
  companyTaxRate: number;
  business: {
    groups: BaselinePlanExportGroup[];
    operatingTotal: number;
    ownerNetFunding: number;
    personalTaxProvision: number;
    plannedTaxableProfit: number;
    companyTaxProvision: number;
    requiredRevenue: number;
    annualRevenueTarget: number;
  };
  personal: {
    groups: BaselinePlanExportGroup[];
    netNeed: number;
    personalTaxProvision: number;
    grossRemuneration: number;
  };
};

function formatRands(value: number): string {
  return new Intl.NumberFormat("en-ZA", {
    style: "currency",
    currency: "ZAR",
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(Number.isFinite(value) ? value : 0);
}

function clean(value: string): string {
  return value.replace(/\s+/g, " ").trim();
}

function tableCell(value: string): string {
  return clean(value).replace(/\|/g, "\\|");
}

function groupTotal(group: BaselinePlanExportGroup): number {
  return group.items.reduce(
    (total, item) =>
      total + (Number.isFinite(item.monthlyRands) ? item.monthlyRands : 0),
    0,
  );
}

function renderGroups(groups: BaselinePlanExportGroup[]): string[] {
  const lines: string[] = [];

  for (const group of groups) {
    if (!group.section && !group.items.length) continue;
    const title = group.section?.title || "Unsectioned";
    lines.push(`### ${clean(title)}`);

    if (group.section?.note) lines.push(clean(group.section.note));
    if (group.section && group.section.taxLabel !== "No direct tax effect") {
      lines.push(`Tax treatment: ${clean(group.section.taxLabel)}.`);
    }
    lines.push("");

    if (!group.items.length) {
      lines.push("- No items yet.");
    } else {
      for (const item of group.items) {
        lines.push(
          `- **${clean(item.label)}** — ${formatRands(item.monthlyRands)} / month`,
        );
        if (item.note) lines.push(`  - ${clean(item.note)}`);
        if (item.subItems?.length) {
          const detailTotal = item.subItems.reduce(
            (total, subItem) => total + subItem.monthlyRands,
            0,
          );
          for (const subItem of item.subItems) {
            lines.push(
              `  - **${clean(subItem.label)}** — ${formatRands(subItem.monthlyRands)} / month`,
            );
            if (subItem.note) lines.push(`    - ${clean(subItem.note)}`);
          }
          const difference = item.monthlyRands - detailTotal;
          const allocation =
            Math.abs(difference) < 0.005
              ? "fully allocated"
              : difference > 0
                ? `${formatRands(difference)} unallocated`
                : `${formatRands(Math.abs(difference))} over budget`;
          lines.push(
            `  - Breakdown: ${formatRands(detailTotal)} detailed; ${allocation}.`,
          );
        }
      }
    }

    lines.push("");
    lines.push(
      `**${group.section ? "Category" : "Uncategorized"} total: ${formatRands(groupTotal(group))} / month**`,
    );
    lines.push("");
  }

  return lines;
}

export function buildBaselinePlanMarkdown(
  input: BaselinePlanExportInput,
): string {
  const generatedDate = new Intl.DateTimeFormat("en-ZA", {
    dateStyle: "long",
  }).format(input.generatedAt);
  const lines = [
    "# Raven monthly plan",
    "",
    `Generated: ${generatedDate}`,
    "",
    "Purpose: a working monthly baseline for reviewing what is essential, what may be missing, and what the business needs to generate to fund the personal plan.",
    "",
    "## Business",
    "",
    `**Required monthly business revenue: ${formatRands(input.business.requiredRevenue)}**`,
    `**Annual revenue target: ${formatRands(input.business.annualRevenueTarget)}**`,
    "",
    ...renderGroups(input.business.groups),
    "## Personal",
    "",
    `**Personal net monthly need: ${formatRands(input.personal.netNeed)}**`,
    "",
    ...renderGroups(input.personal.groups),
    "## Tax and funding summary",
    "",
    "| Measure | Monthly amount |",
    "| --- | ---: |",
    `| ${tableCell("Business operating costs")} | ${formatRands(input.business.operatingTotal)} |`,
    `| ${tableCell("Owner net funding")} | ${formatRands(input.business.ownerNetFunding)} |`,
    `| ${tableCell("PAYE / personal tax provision")} | ${formatRands(input.business.personalTaxProvision)} |`,
    `| ${tableCell("Gross personal remuneration required")} | ${formatRands(input.personal.grossRemuneration)} |`,
    `| ${tableCell("Planned taxable company profit")} | ${formatRands(input.business.plannedTaxableProfit)} |`,
    `| ${tableCell("Company income tax provision")} | ${formatRands(input.business.companyTaxProvision)} |`,
    `| **${tableCell("Required business revenue")}** | **${formatRands(input.business.requiredRevenue)}** |`,
    "",
    `Tax basis: ${clean(input.taxYearLabel)}. Personal income tax is estimated progressively; company tax is modeled at ${Math.round(input.companyTaxRate * 100)}% of planned taxable profit, not turnover.`,
    "",
    "## Orchestrator review brief",
    "",
    "Please review this working plan for:",
    "",
    "- essential expenses that may be missing or understated;",
    "- costs that are optional, deferrable, or belong in a later-life scenario;",
    "- assumptions that need evidence or confirmation; and",
    "- whether the personal funding and business revenue targets are internally coherent.",
    "",
    "This is a planning model, not a bank-statement record or tax return.",
    "",
  ];

  return lines.join("\n");
}

export function baselinePlanExportFilename(date: Date): string {
  const stamp = [
    date.getFullYear(),
    String(date.getMonth() + 1).padStart(2, "0"),
    String(date.getDate()).padStart(2, "0"),
  ].join("-");
  return `raven-monthly-plan-${stamp}.md`;
}
