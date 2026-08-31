<script setup lang="ts">
import { formatMoney } from "@raven/domain";

import {
  baselinePlanExportFilename,
  buildBaselinePlanMarkdown,
} from "../utils/baselinePlanExport";

import {
  calculateZaCompanyTax,
  grossUpZaMonthlyNet,
  ZA_COMPANY_TAX_SOURCE_URL,
  ZA_INDIVIDUAL_TAX_BRACKETS,
  ZA_INDIVIDUAL_TAX_SOURCE_URL,
  ZA_PRIMARY_REBATE,
  ZA_STANDARD_COMPANY_TAX_RATE,
  ZA_TAX_YEAR_LABEL,
  ZA_UNDER_65_TAX_THRESHOLD,
} from "../utils/zaTax";

type PlanLane = "personal" | "business";
type PlanTaxTreatment = "none" | "personal" | "business_deductible";

type PlanItem = {
  id: string;
  label: string;
  monthlyRands: number;
  note: string;
  sectionId: string;
  parentItemId?: string;
};

type PlanSection = {
  id: string;
  title: string;
  note: string;
  taxTreatment: PlanTaxTreatment;
};

type PlanDraft = {
  version: 7;
  personal: PlanItem[];
  business: PlanItem[];
  personalSections: PlanSection[];
  businessSections: PlanSection[];
};

type PlanItemGroup = {
  key: string;
  section: PlanSection | null;
  items: PlanItem[];
};

type PlanEditorMode = "item" | "section";
type PlanEditorValue = {
  id: string;
  label: string;
  note: string;
  monthlyRands: number;
  sectionId: string;
  parentItemId: string;
  taxTreatment: PlanTaxTreatment;
};

type PlanEditorSectionDraft = {
  id: string;
  title: string;
};

useHead({ title: "Plan · Raven" });

const storageKey = "raven.baseline-plan.v7";
const legacyStorageKeys = [
  "raven.baseline-plan.v6",
  "raven.baseline-plan.v5",
  "raven.baseline-plan.v4",
  "raven.baseline-plan.v3",
  "raven.baseline-plan.v2",
  "raven.baseline-plan.v1",
];
const hydrated = ref(false);
const saveState = ref<"saved" | "saving" | "local">("local");

const defaultPersonalSections: PlanSection[] = [
  {
    id: "personal-section-maintenance",
    title: "Maintenance",
    note: "Shared child and family obligations that form part of the current maintenance picture.",
    taxTreatment: "none",
  },
  {
    id: "personal-section-transport",
    title: "Transport",
    note: "Essential fuel and alternative transport required each month.",
    taxTreatment: "none",
  },
  {
    id: "personal-section-food-household",
    title: "Food & household",
    note: "Minimal food and household needs while living with family.",
    taxTreatment: "none",
  },
  {
    id: "personal-section-health",
    title: "Health",
    note: "Medical cover and health-related personal provisions.",
    taxTreatment: "personal",
  },
  {
    id: "personal-section-personal",
    title: "Personal",
    note: "Minimal clothing, grooming and other direct personal needs.",
    taxTreatment: "none",
  },
];

const defaultBusinessSections: PlanSection[] = [
  {
    id: "business-section-communication",
    title: "Communication",
    note: "Phone, data and communication costs required to operate the business.",
    taxTreatment: "business_deductible",
  },
];

const baselinePersonalItems: PlanItem[] = [
  {
    id: "personal-debt-payments",
    label: "Debt payments",
    monthlyRands: 20_000,
    note: "Rent-equivalent target while living with family, intended to cover debt costs and reduce principal.",
    sectionId: "",
  },
  {
    id: "personal-maintenance-payment",
    label: "Monthly maintenance payment",
    monthlyRands: 20_000,
    note: "Current required maintenance expense: R20,000 per month.",
    sectionId: "personal-section-maintenance",
  },
  {
    id: "personal-maintenance-school-fees",
    label: "School fees",
    monthlyRands: 8_333.33,
    note: "Working maintenance share: R25,000 per term × 4 terms ÷ 12 months = R8,333.33 per month.",
    sectionId: "personal-section-maintenance",
  },
  {
    id: "personal-maintenance-extra-murals",
    label: "Extra murals",
    monthlyRands: 2_000,
    note: "Ballpark allocation for both girls: approximately R1,000 per child per month.",
    sectionId: "personal-section-maintenance",
  },
  {
    id: "personal-maintenance-medical",
    label: "Additional medical expenses",
    monthlyRands: 1_000,
    note: "Provisional monthly allocation; whether this is an additional expense still needs confirmation.",
    sectionId: "personal-section-maintenance",
  },
  {
    id: "personal-maintenance-play-therapy",
    label: "Play therapy",
    monthlyRands: 4_350,
    note: "R1,450 × 2 sessions for one girl, plus one R1,450 parent session per month.",
    sectionId: "personal-section-maintenance",
  },
  {
    id: "personal-transportation-fuel",
    label: "Transportation / fuel",
    monthlyRands: 2_000,
    note: "Combined monthly allowance for petrol and Uber or other alternative transport.",
    sectionId: "personal-section-transport",
  },
  {
    id: "personal-groceries",
    label: "Groceries",
    monthlyRands: 2_000,
    note: "Minimal personal groceries while living with family.",
    sectionId: "personal-section-food-household",
  },
  {
    id: "personal-medical-aid",
    label: "Medical aid",
    monthlyRands: 3_000,
    note: "Current working monthly medical aid allowance from the starting budget.",
    sectionId: "personal-section-health",
  },
  {
    id: "personal-supplements",
    label: "Supplements",
    monthlyRands: 1_500,
    note: "Monthly allowance for supplements such as omegas, creatine and vitamin D3.",
    sectionId: "personal-section-health",
  },
  {
    id: "personal-haircuts",
    label: "Haircuts / grooming",
    monthlyRands: 250,
    note: "Minimal monthly grooming allowance.",
    sectionId: "personal-section-personal",
  },
  {
    id: "personal-clothing",
    label: "Clothing / shoes",
    monthlyRands: 1_000,
    note: "Maximum monthly clothing allowance.",
    sectionId: "personal-section-personal",
  },
];

const baselineBusinessItems: PlanItem[] = [
  {
    id: "business-phone-data",
    label: "Business phone / data",
    monthlyRands: 450,
    note: "Phone cost treated as a business communication expense.",
    sectionId: "business-section-communication",
  },
];

function copyItems(items: PlanItem[]): PlanItem[] {
  return items.map((item) => ({ ...item }));
}

function copySections(sections: PlanSection[]): PlanSection[] {
  return sections.map((section) => ({ ...section }));
}

function defaultDraft(): PlanDraft {
  return {
    version: 7,
    personal: copyItems(baselinePersonalItems),
    business: copyItems(baselineBusinessItems),
    personalSections: copySections(defaultPersonalSections),
    businessSections: copySections(defaultBusinessSections),
  };
}

const draft = ref<PlanDraft>(defaultDraft());

function validAmount(value: unknown): number {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? Math.max(0, parsed) : 0;
}

function slug(value: string): string {
  return value
    .trim()
    .toLocaleLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "");
}

function normalizeTaxTreatment(value: unknown): PlanTaxTreatment {
  if (
    value === "personal" ||
    value === "business_deductible" ||
    value === "none"
  ) {
    return value;
  }
  return "none";
}

function normalizeSections(value: unknown, lane: PlanLane): PlanSection[] {
  if (!Array.isArray(value)) return [];

  return value.flatMap((candidate, index) => {
    if (!candidate || typeof candidate !== "object") return [];
    const section = candidate as Partial<PlanSection>;
    const title = typeof section.title === "string" ? section.title.trim() : "";
    if (!title) return [];

    return [
      {
        id:
          typeof section.id === "string" && section.id.length
            ? section.id
            : `${lane}-section-${slug(title) || index + 1}`,
        title,
        note: typeof section.note === "string" ? section.note : "",
        taxTreatment: normalizeTaxTreatment(section.taxTreatment),
      },
    ];
  });
}

function normalizeItemsV6(value: unknown, lane: PlanLane): PlanItem[] {
  if (!Array.isArray(value)) return [];

  return value.flatMap((candidate, index) => {
    if (!candidate || typeof candidate !== "object") return [];
    const item = candidate as Partial<PlanItem>;

    return [
      {
        id:
          typeof item.id === "string" && item.id.length
            ? item.id
            : `${lane}-${index + 1}`,
        label: typeof item.label === "string" ? item.label : "",
        monthlyRands: validAmount(item.monthlyRands),
        note: typeof item.note === "string" ? item.note : "",
        sectionId: typeof item.sectionId === "string" ? item.sectionId : "",
        parentItemId:
          typeof item.parentItemId === "string" ? item.parentItemId : "",
      },
    ];
  });
}

function appendMissingItems(
  existing: PlanItem[],
  additions: PlanItem[],
): PlanItem[] {
  const knownIds = new Set(existing.map((item) => item.id));
  const knownLabels = new Set(
    existing.map((item) => item.label.trim().toLocaleLowerCase()),
  );
  const missing = additions.filter(
    (item) =>
      !knownIds.has(item.id) &&
      !knownLabels.has(item.label.trim().toLocaleLowerCase()),
  );

  return [...existing, ...copyItems(missing)];
}

function normalizeItemHierarchy(items: PlanItem[]): PlanItem[] {
  const byId = new Map(items.map((item) => [item.id, item]));
  return items.map((item) => {
    const parent = item.parentItemId ? byId.get(item.parentItemId) : undefined;
    const validParent =
      parent &&
      parent.id !== item.id &&
      !parent.parentItemId &&
      parent.sectionId === item.sectionId;
    return {
      ...item,
      parentItemId: validParent ? parent.id : "",
    };
  });
}

function appendMissingSections(
  existing: PlanSection[],
  additions: PlanSection[],
): PlanSection[] {
  const knownIds = new Set(existing.map((section) => section.id));
  const knownTitles = new Set(
    existing.map((section) => section.title.trim().toLocaleLowerCase()),
  );
  return [
    ...existing,
    ...copySections(
      additions.filter(
        (section) =>
          !knownIds.has(section.id) &&
          !knownTitles.has(section.title.trim().toLocaleLowerCase()),
      ),
    ),
  ];
}

function migrateLegacyLane(
  value: unknown,
  lane: PlanLane,
  standardSections: PlanSection[],
): { items: PlanItem[]; sections: PlanSection[] } {
  if (!Array.isArray(value)) return { items: [], sections: [] };
  const sections = copySections(standardSections);
  const sectionByTitle = new Map(
    sections.map((section) => [section.title.toLocaleLowerCase(), section]),
  );

  const items = value.flatMap((candidate, index) => {
    if (!candidate || typeof candidate !== "object") return [];
    const legacy = candidate as Partial<PlanItem> & { section?: unknown };
    const sectionTitle =
      typeof legacy.section === "string" ? legacy.section.trim() : "";
    let sectionId = "";

    if (sectionTitle) {
      const normalizedTitle = sectionTitle.toLocaleLowerCase();
      let section = sectionByTitle.get(normalizedTitle);
      if (!section) {
        section = {
          id: `${lane}-section-${slug(sectionTitle) || sections.length + 1}`,
          title: sectionTitle,
          note: "Migrated from the earlier planning draft.",
          taxTreatment: "none",
        };
        sections.push(section);
        sectionByTitle.set(normalizedTitle, section);
      }
      sectionId = section.id;
    }

    return [
      {
        id:
          typeof legacy.id === "string" && legacy.id.length
            ? legacy.id
            : `${lane}-${index + 1}`,
        label: typeof legacy.label === "string" ? legacy.label : "",
        monthlyRands: validAmount(legacy.monthlyRands),
        note: typeof legacy.note === "string" ? legacy.note : "",
        sectionId,
        parentItemId: "",
      },
    ];
  });

  return { items, sections };
}

function normalizeDraft(value: unknown): PlanDraft | null {
  if (!value || typeof value !== "object") return null;
  const candidate = value as Record<string, unknown>;
  const version = Number(candidate.version);
  if (![1, 2, 3, 4, 5, 6, 7].includes(version)) return null;

  if (version === 6 || version === 7) {
    const personalSections = appendMissingSections(
      normalizeSections(candidate.personalSections, "personal"),
      defaultPersonalSections,
    );
    const businessSections = appendMissingSections(
      normalizeSections(candidate.businessSections, "business"),
      defaultBusinessSections,
    );
    return {
      version: 7,
      personal: normalizeItemHierarchy(
        appendMissingItems(
          normalizeItemsV6(candidate.personal, "personal"),
          baselinePersonalItems,
        ),
      ),
      business: normalizeItemHierarchy(
        appendMissingItems(
          normalizeItemsV6(candidate.business, "business"),
          baselineBusinessItems,
        ),
      ),
      personalSections,
      businessSections,
    };
  }

  const personal = migrateLegacyLane(
    candidate.personal,
    "personal",
    defaultPersonalSections,
  );
  const business = migrateLegacyLane(
    candidate.business,
    "business",
    defaultBusinessSections,
  );

  const migratedPersonal = personal.items.map((item) =>
    version === 4 && item.id === "personal-supplements"
      ? {
          ...item,
          monthlyRands: 1_500,
          note: "Monthly allowance for supplements such as omegas, creatine and vitamin D3.",
        }
      : item,
  );

  return {
    version: 7,
    personal: normalizeItemHierarchy(
      appendMissingItems(migratedPersonal, baselinePersonalItems),
    ),
    business: normalizeItemHierarchy(
      appendMissingItems(business.items, baselineBusinessItems),
    ),
    personalSections: appendMissingSections(
      personal.sections,
      defaultPersonalSections,
    ),
    businessSections: appendMissingSections(
      business.sections,
      defaultBusinessSections,
    ),
  };
}

function groupItems(
  items: PlanItem[],
  sections: PlanSection[],
): PlanItemGroup[] {
  const groups: PlanItemGroup[] = [];
  const unsectioned = items.filter((item) => !item.sectionId);
  if (unsectioned.length) {
    groups.push({ key: "unsectioned", section: null, items: unsectioned });
  }

  for (const section of sections) {
    groups.push({
      key: section.id,
      section,
      items: items.filter((item) => item.sectionId === section.id),
    });
  }

  const knownSectionIds = new Set(sections.map((section) => section.id));
  const orphaned = items.filter(
    (item) => item.sectionId && !knownSectionIds.has(item.sectionId),
  );
  if (orphaned.length) {
    groups.push({ key: "unassigned", section: null, items: orphaned });
  }

  return groups;
}

function totalFor(items: PlanItem[]): number {
  return rootItemsFor(items).reduce(
    (total, item) => total + validAmount(item.monthlyRands),
    0,
  );
}

function rootItemsFor(items: PlanItem[]): PlanItem[] {
  const byId = new Map(items.map((item) => [item.id, item]));
  return items.filter((item) => {
    if (!item.parentItemId) return true;
    const parent = byId.get(item.parentItemId);
    return (
      !parent ||
      Boolean(parent.parentItemId) ||
      parent.sectionId !== item.sectionId
    );
  });
}

function subItemsFor(items: PlanItem[], parentItemId: string): PlanItem[] {
  return items.filter((item) => item.parentItemId === parentItemId);
}

function subItemTotal(items: PlanItem[], parentItemId: string): number {
  return subItemsFor(items, parentItemId).reduce(
    (total, item) => total + validAmount(item.monthlyRands),
    0,
  );
}

function subItemBalanceLabel(parent: PlanItem, items: PlanItem[]): string {
  const detailTotal = subItemTotal(items, parent.id);
  const difference = validAmount(parent.monthlyRands) - detailTotal;
  if (Math.abs(difference) < 0.005) return "Fully allocated";
  return difference > 0
    ? `${formatRands(difference)} unallocated`
    : `${formatRands(Math.abs(difference))} over budget`;
}

function formatRands(value: number): string {
  return formatMoney({
    currency: "ZAR",
    minorUnits: Math.round(validAmount(value) * 100),
  });
}

function formatWholeRands(value: number): string {
  return new Intl.NumberFormat("en-ZA", {
    style: "currency",
    currency: "ZAR",
    maximumFractionDigits: 0,
  }).format(value);
}

function formatBracketRange(lower: number, upper: number | null): string {
  if (upper === null) return `${formatWholeRands(lower + 1)} and above`;
  if (lower === 0) return `Up to ${formatWholeRands(upper)}`;
  return `${formatWholeRands(lower + 1)} – ${formatWholeRands(upper)}`;
}

function sectionsFor(lane: PlanLane): PlanSection[] {
  return lane === "personal"
    ? draft.value.personalSections
    : draft.value.businessSections;
}

function taxTreatmentLabel(value: PlanTaxTreatment): string {
  if (value === "personal") return "Personal tax";
  if (value === "business_deductible") return "Business deductible";
  return "No direct tax effect";
}

const personalTotal = computed(() => totalFor(draft.value.personal));
const businessOperatingTotal = computed(() => totalFor(draft.value.business));
const personalTaxEstimate = computed(() =>
  grossUpZaMonthlyNet(personalTotal.value),
);
const personalTaxMonthly = computed(() => personalTaxEstimate.value.monthlyTax);
const grossRemunerationMonthly = computed(
  () => personalTaxEstimate.value.grossMonthlyIncome,
);
const plannedCompanyProfitMonthly = ref(0);
const companyTaxMonthly = computed(
  () => calculateZaCompanyTax(plannedCompanyProfitMonthly.value * 12) / 12,
);
const requiredBusinessRevenue = computed(
  () =>
    businessOperatingTotal.value +
    grossRemunerationMonthly.value +
    plannedCompanyProfitMonthly.value +
    companyTaxMonthly.value,
);
const annualRequiredRevenue = computed(
  () => requiredBusinessRevenue.value * 12,
);
const personalGroups = computed(() =>
  groupItems(draft.value.personal, draft.value.personalSections),
);
const businessGroups = computed(() =>
  groupItems(draft.value.business, draft.value.businessSections),
);

const collapsedSectionIds = ref<string[]>([]);

function isSectionCollapsed(sectionId: string): boolean {
  return collapsedSectionIds.value.includes(sectionId);
}

function toggleSection(sectionId: string) {
  collapsedSectionIds.value = isSectionCollapsed(sectionId)
    ? collapsedSectionIds.value.filter((id) => id !== sectionId)
    : [...collapsedSectionIds.value, sectionId];
}

const personalTaxRow = computed<PlanItem>(() => ({
  id: "derived-personal-tax",
  label: "Estimated personal income tax",
  monthlyRands: personalTaxMonthly.value,
  note: `${ZA_TAX_YEAR_LABEL}; progressive rates and primary rebate only.`,
  sectionId: "",
}));
const grossRemunerationRow = computed<PlanItem>(() => ({
  id: "derived-gross-remuneration",
  label: "Gross remuneration required",
  monthlyRands: grossRemunerationMonthly.value,
  note: "The gross monthly remuneration needed to leave the full personal plan available after estimated income tax.",
  sectionId: "",
}));
const ownerNetFundingRow = computed<PlanItem>(() => ({
  id: "derived-owner-net-funding",
  label: "Owner net funding",
  monthlyRands: personalTotal.value,
  note: "The net personal plan the business must fund after PAYE.",
  sectionId: "",
}));
const businessPayeRow = computed<PlanItem>(() => ({
  id: "derived-business-paye",
  label: "PAYE / personal tax provision",
  monthlyRands: personalTaxMonthly.value,
  note: "The personal income tax component included in gross owner remuneration.",
  sectionId: "",
}));
const companyProfitRow = computed<PlanItem>(() => ({
  id: "derived-company-profit",
  label: "Planned taxable company profit",
  monthlyRands: plannedCompanyProfitMonthly.value,
  note: "Currently set to zero: required revenue is modeled to cover costs and owner remuneration without surplus profit.",
  sectionId: "",
}));
const companyTaxRow = computed<PlanItem>(() => ({
  id: "derived-company-tax",
  label: "Company income tax",
  monthlyRands: companyTaxMonthly.value,
  note: `Calculated at ${ZA_STANDARD_COMPANY_TAX_RATE * 100}% of planned taxable profit, not revenue.`,
  sectionId: "",
}));

const blankEditorValue = (): PlanEditorValue => ({
  id: "",
  label: "",
  note: "",
  monthlyRands: 0,
  sectionId: "",
  parentItemId: "",
  taxTreatment: "none",
});

const editor = reactive<{
  open: boolean;
  mode: PlanEditorMode;
  lane: PlanLane;
  value: PlanEditorValue;
}>({
  open: false,
  mode: "item",
  lane: "personal",
  value: blankEditorValue(),
});

function closeEditor() {
  editor.open = false;
}

function openCreateItem(lane: PlanLane, sectionId = "", parentItemId = "") {
  Object.assign(editor, {
    open: true,
    mode: "item" as const,
    lane,
    value: {
      ...blankEditorValue(),
      sectionId,
      parentItemId,
    },
  });
}

function openCreateSection(lane: PlanLane) {
  Object.assign(editor, {
    open: true,
    mode: "section" as const,
    lane,
    value: blankEditorValue(),
  });
}

function openEditItem(lane: PlanLane, item: PlanItem) {
  Object.assign(editor, {
    open: true,
    mode: "item" as const,
    lane,
    value: {
      id: item.id,
      label: item.label,
      note: item.note,
      monthlyRands: item.monthlyRands,
      sectionId: item.sectionId,
      parentItemId: item.parentItemId ?? "",
      taxTreatment: "none" as const,
    },
  });
}

function openEditSection(lane: PlanLane, section: PlanSection) {
  Object.assign(editor, {
    open: true,
    mode: "section" as const,
    lane,
    value: {
      id: section.id,
      label: section.title,
      note: section.note,
      monthlyRands: 0,
      sectionId: "",
      parentItemId: "",
      taxTreatment: section.taxTreatment,
    },
  });
}

function newRecordId(lane: PlanLane, kind: "item" | "section"): string {
  return `${lane}-${kind}-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
}

function saveEditor(
  value: PlanEditorValue,
  createdSections: PlanEditorSectionDraft[] = [],
) {
  if (editor.mode === "item") {
    const sections = sectionsFor(editor.lane);
    for (const section of createdSections) {
      if (sections.some((candidate) => candidate.id === section.id)) continue;
      sections.push({
        id: section.id,
        title: section.title,
        note: "",
        taxTreatment: "none",
      });
    }

    const items = draft.value[editor.lane];
    const existing = items.find((item) => item.id === value.id);
    const requestedParent = value.parentItemId
      ? items.find((item) => item.id === value.parentItemId)
      : undefined;
    const existingHasChildren = existing
      ? items.some((item) => item.parentItemId === existing.id)
      : false;
    const parentItemId =
      !existingHasChildren &&
      requestedParent &&
      requestedParent.id !== existing?.id &&
      !requestedParent.parentItemId &&
      requestedParent.sectionId === value.sectionId
        ? requestedParent.id
        : "";
    if (existing) {
      Object.assign(existing, {
        label: value.label,
        note: value.note,
        monthlyRands: validAmount(value.monthlyRands),
        sectionId: value.sectionId,
        parentItemId,
      });
      if (existingHasChildren) {
        for (const item of items) {
          if (item.parentItemId === existing.id) {
            item.sectionId = value.sectionId;
          }
        }
      }
    } else {
      items.push({
        id: newRecordId(editor.lane, "item"),
        label: value.label,
        note: value.note,
        monthlyRands: validAmount(value.monthlyRands),
        sectionId: value.sectionId,
        parentItemId,
      });
    }
  } else {
    const sections = sectionsFor(editor.lane);
    const existing = sections.find((section) => section.id === value.id);
    if (existing) {
      Object.assign(existing, {
        title: value.label,
        note: value.note,
        taxTreatment: value.taxTreatment,
      });
    } else {
      sections.push({
        id: newRecordId(editor.lane, "section"),
        title: value.label,
        note: value.note,
        taxTreatment: value.taxTreatment,
      });
    }
  }

  closeEditor();
}

function removeEditorEntry() {
  if (!editor.value.id) return;
  if (editor.mode === "item") {
    if (!window.confirm(`Remove ${editor.value.label || "this item"}?`)) return;
    for (const item of draft.value[editor.lane]) {
      if (item.parentItemId === editor.value.id) item.parentItemId = "";
    }
    draft.value[editor.lane] = draft.value[editor.lane].filter(
      (item) => item.id !== editor.value.id,
    );
  } else {
    const section = sectionsFor(editor.lane).find(
      (candidate) => candidate.id === editor.value.id,
    );
    if (!section) return;
    if (
      !window.confirm(
        `Remove ${section.title}? Its items will remain uncategorized.`,
      )
    ) {
      return;
    }
    for (const item of draft.value[editor.lane]) {
      if (item.sectionId === section.id) item.sectionId = "";
    }
    if (editor.lane === "personal") {
      draft.value.personalSections = draft.value.personalSections.filter(
        (candidate) => candidate.id !== section.id,
      );
    } else {
      draft.value.businessSections = draft.value.businessSections.filter(
        (candidate) => candidate.id !== section.id,
      );
    }
  }
  closeEditor();
}

function chooseAddAction(
  event: MouseEvent,
  lane: PlanLane,
  mode: PlanEditorMode,
) {
  (event.currentTarget as HTMLElement | null)
    ?.closest("details")
    ?.removeAttribute("open");
  if (mode === "item") openCreateItem(lane);
  else openCreateSection(lane);
}

const draggedItem = ref<{ lane: PlanLane; itemId: string } | null>(null);

function startItemDrag(lane: PlanLane, itemId: string) {
  draggedItem.value = { lane, itemId };
}

function dropItem(lane: PlanLane, targetId: string) {
  const dragged = draggedItem.value;
  draggedItem.value = null;
  if (!dragged || dragged.lane !== lane || dragged.itemId === targetId) return;

  const items = draft.value[lane];
  const sourceIndex = items.findIndex((item) => item.id === dragged.itemId);
  const targetIndex = items.findIndex((item) => item.id === targetId);
  if (sourceIndex < 0 || targetIndex < 0) return;
  if (items[sourceIndex]?.sectionId !== items[targetIndex]?.sectionId) return;
  if (items[sourceIndex]?.parentItemId !== items[targetIndex]?.parentItemId)
    return;

  const [moved] = items.splice(sourceIndex, 1);
  if (!moved) return;
  const revisedTargetIndex = items.findIndex((item) => item.id === targetId);
  items.splice(revisedTargetIndex, 0, moved);
}

function endItemDrag() {
  draggedItem.value = null;
}

const draggedSection = ref<{ lane: PlanLane; sectionId: string } | null>(null);

function startSectionDrag(lane: PlanLane, sectionId: string) {
  draggedSection.value = { lane, sectionId };
}

function dropSection(lane: PlanLane, targetSectionId: string) {
  const dragged = draggedSection.value;
  draggedSection.value = null;
  if (
    !dragged ||
    dragged.lane !== lane ||
    dragged.sectionId === targetSectionId
  ) {
    return;
  }

  const sections = sectionsFor(lane);
  const sourceIndex = sections.findIndex(
    (section) => section.id === dragged.sectionId,
  );
  const targetIndex = sections.findIndex(
    (section) => section.id === targetSectionId,
  );
  if (sourceIndex < 0 || targetIndex < 0) return;

  const [moved] = sections.splice(sourceIndex, 1);
  if (!moved) return;
  const revisedTargetIndex = sections.findIndex(
    (section) => section.id === targetSectionId,
  );
  sections.splice(revisedTargetIndex, 0, moved);
}

function endSectionDrag() {
  draggedSection.value = null;
}

function exportGroups(groups: PlanItemGroup[]) {
  return groups.map((group) => ({
    section: group.section
      ? {
          title: group.section.title,
          note: group.section.note,
          taxLabel: taxTreatmentLabel(group.section.taxTreatment),
        }
      : null,
    items: rootItemsFor(group.items).map((item) => ({
      label: item.label,
      monthlyRands: item.monthlyRands,
      note: item.note,
      subItems: subItemsFor(group.items, item.id).map((subItem) => ({
        label: subItem.label,
        monthlyRands: subItem.monthlyRands,
        note: subItem.note,
      })),
    })),
  }));
}

function exportPlan() {
  const generatedAt = new Date();
  const markdown = buildBaselinePlanMarkdown({
    generatedAt,
    taxYearLabel: ZA_TAX_YEAR_LABEL,
    companyTaxRate: ZA_STANDARD_COMPANY_TAX_RATE,
    business: {
      groups: exportGroups(businessGroups.value),
      operatingTotal: businessOperatingTotal.value,
      ownerNetFunding: personalTotal.value,
      personalTaxProvision: personalTaxMonthly.value,
      plannedTaxableProfit: plannedCompanyProfitMonthly.value,
      companyTaxProvision: companyTaxMonthly.value,
      requiredRevenue: requiredBusinessRevenue.value,
      annualRevenueTarget: annualRequiredRevenue.value,
    },
    personal: {
      groups: exportGroups(personalGroups.value),
      netNeed: personalTotal.value,
      personalTaxProvision: personalTaxMonthly.value,
      grossRemuneration: grossRemunerationMonthly.value,
    },
  });
  const url = URL.createObjectURL(
    new Blob([markdown], { type: "text/markdown;charset=utf-8" }),
  );
  const link = document.createElement("a");
  link.href = url;
  link.download = baselinePlanExportFilename(generatedAt);
  document.body.appendChild(link);
  link.click();
  link.remove();
  window.setTimeout(() => URL.revokeObjectURL(url), 0);
}

onMounted(() => {
  try {
    const currentStored = window.localStorage.getItem(storageKey);
    const legacyStored =
      legacyStorageKeys
        .map((key) => window.localStorage.getItem(key))
        .find((value) => value !== null) ?? null;
    const stored = currentStored ?? legacyStored;
    if (stored) {
      const normalized = normalizeDraft(JSON.parse(stored));
      if (normalized) {
        draft.value = normalized;
        if (!currentStored) {
          window.localStorage.setItem(storageKey, JSON.stringify(normalized));
          saveState.value = "saved";
        }
      }
    }
  } catch {
    saveState.value = "local";
  } finally {
    hydrated.value = true;
  }
});

watch(
  draft,
  (value) => {
    if (!hydrated.value) return;
    saveState.value = "saving";
    try {
      window.localStorage.setItem(storageKey, JSON.stringify(value));
      saveState.value = "saved";
    } catch {
      saveState.value = "local";
    }
  },
  { deep: true },
);
</script>

<template>
  <div class="plan-page">
    <header class="plan-header">
      <div>
        <span class="raven-eyebrow">Working monthly plan</span>
        <h1>What life and the business need</h1>
      </div>

      <button type="button" class="plan-export" @click="exportPlan">
        <span class="i-lucide-download" aria-hidden="true" />
        Export
      </button>
    </header>

    <section class="plan-summary" aria-label="Working monthly baseline">
      <article class="plan-summary__primary raven-surface">
        <span>Required business revenue</span>
        <strong
          >{{ formatRands(requiredBusinessRevenue)
          }}<small>/month</small></strong
        >
        <p>
          Covers business operating costs plus the gross remuneration needed to
          fund the personal plan after estimated income tax.
        </p>
      </article>

      <article class="plan-summary__metric raven-surface">
        <span>Personal net need</span>
        <strong>{{ formatRands(personalTotal) }}</strong>
        <small>Available after tax</small>
      </article>

      <article class="plan-summary__metric raven-surface">
        <span>Personal tax provision</span>
        <strong>{{ formatRands(personalTaxMonthly) }}</strong>
        <small>{{ ZA_TAX_YEAR_LABEL }}</small>
      </article>

      <article class="plan-summary__metric raven-surface">
        <span>Annual revenue target</span>
        <strong>{{ formatRands(annualRequiredRevenue) }}</strong>
        <small>At the current assumptions</small>
      </article>
    </section>

    <section
      class="plan-columns"
      aria-label="Personal and business budget lists"
    >
      <article class="plan-column raven-surface">
        <header class="plan-column__header">
          <h2>Personal</h2>
          <div class="plan-column__actions">
            <div class="plan-column__total">
              <span>Net need</span>
              <strong>{{ formatRands(personalTotal) }}</strong>
            </div>
            <details class="plan-add-menu">
              <summary aria-label="Add personal item or category">
                <span class="i-lucide-plus" aria-hidden="true" />
              </summary>
              <div class="plan-add-menu__popover">
                <button
                  type="button"
                  @click="chooseAddAction($event, 'personal', 'item')"
                >
                  <span class="i-lucide-list-plus" aria-hidden="true" /> Add
                  item
                </button>
                <button
                  type="button"
                  @click="chooseAddAction($event, 'personal', 'section')"
                >
                  <span class="i-lucide-folder-plus" aria-hidden="true" /> Add
                  category
                </button>
              </div>
            </details>
          </div>
        </header>

        <div class="plan-list" aria-label="Personal monthly items">
          <div
            v-for="group in personalGroups"
            :key="group.key"
            class="plan-section"
          >
            <header
              v-if="group.section"
              class="plan-section__heading"
              @dragover.prevent
              @drop.prevent="dropSection('personal', group.section.id)"
            >
              <span
                class="i-lucide-grip-vertical plan-section__grip"
                draggable="true"
                :aria-label="`Reorder ${group.section.title}`"
                :title="`Drag to reorder ${group.section.title}`"
                @dragstart.stop="startSectionDrag('personal', group.section.id)"
                @dragend="endSectionDrag"
              />
              <button
                type="button"
                class="plan-section__toggle"
                :title="group.section.note || `Edit ${group.section.title}`"
                :aria-expanded="!isSectionCollapsed(group.section.id)"
                @click="toggleSection(group.section.id)"
              >
                <span
                  class="i-lucide-chevron-down plan-section__chevron"
                  :class="{
                    'plan-section__chevron--collapsed': isSectionCollapsed(
                      group.section.id,
                    ),
                  }"
                  aria-hidden="true"
                />
                <strong>{{ group.section.title }}</strong>
                <span v-if="group.section.note" aria-hidden="true">|</span>
                <span v-if="group.section.note" class="plan-section__note">
                  {{ group.section.note }}
                </span>
                <small v-if="group.section.taxTreatment !== 'none'">{{
                  taxTreatmentLabel(group.section.taxTreatment)
                }}</small>
                <span class="plan-section__heading-total">
                  {{ formatRands(totalFor(group.items)) }}
                </span>
              </button>
              <button
                type="button"
                class="plan-section__edit"
                :aria-label="`Edit ${group.section.title}`"
                @click="openEditSection('personal', group.section)"
              >
                <span class="i-lucide-pencil" aria-hidden="true" />
              </button>
            </header>

            <div
              v-show="!group.section || !isSectionCollapsed(group.section.id)"
              class="plan-section__body"
            >
              <template
                v-for="item in rootItemsFor(group.items)"
                :key="item.id"
              >
                <PlanCompactItem
                  :item="item"
                  allow-sub-items
                  draggable="true"
                  @dragstart="startItemDrag('personal', item.id)"
                  @dragover.prevent
                  @drop.prevent="dropItem('personal', item.id)"
                  @dragend="endItemDrag"
                  @edit="openEditItem('personal', item)"
                  @add-sub-item="
                    openCreateItem('personal', item.sectionId, item.id)
                  "
                />
                <div
                  v-if="subItemsFor(group.items, item.id).length"
                  class="plan-sub-items"
                >
                  <PlanCompactItem
                    v-for="subItem in subItemsFor(group.items, item.id)"
                    :key="subItem.id"
                    :item="subItem"
                    nested
                    draggable="true"
                    @dragstart="startItemDrag('personal', subItem.id)"
                    @dragover.prevent
                    @drop.prevent="dropItem('personal', subItem.id)"
                    @dragend="endItemDrag"
                    @edit="openEditItem('personal', subItem)"
                  />
                  <footer class="plan-sub-items__summary">
                    <span>{{ subItemBalanceLabel(item, group.items) }}</span>
                    <strong>
                      Detailed
                      {{ formatRands(subItemTotal(group.items, item.id)) }}
                    </strong>
                  </footer>
                </div>
              </template>
              <div
                v-if="group.section && !group.items.length"
                class="plan-section__empty"
              >
                <span>No budget items in this category yet.</span>
                <button
                  type="button"
                  @click="openCreateItem('personal', group.section.id)"
                >
                  <span class="i-lucide-plus" aria-hidden="true" />
                  Add item
                </button>
              </div>
              <footer v-if="group.section" class="plan-section__total">
                <span>Category total</span>
                <strong>{{ formatRands(totalFor(group.items)) }}</strong>
              </footer>
            </div>
          </div>
        </div>

        <div
          class="plan-derived"
          aria-label="Calculated personal tax provision"
        >
          <span class="plan-derived__label">Calculated funding</span>
          <PlanCompactItem :item="personalTaxRow" derived />
          <PlanCompactItem :item="grossRemunerationRow" derived />
        </div>

        <footer class="plan-column__footer">
          <span>Gross personal remuneration required</span>
          <strong>{{ formatRands(grossRemunerationMonthly) }}</strong>
        </footer>
      </article>

      <article class="plan-column raven-surface">
        <header class="plan-column__header">
          <h2>Business</h2>
          <div class="plan-column__actions">
            <div class="plan-column__total">
              <span>Required revenue</span>
              <strong>{{ formatRands(requiredBusinessRevenue) }}</strong>
            </div>
            <details class="plan-add-menu">
              <summary aria-label="Add business item or category">
                <span class="i-lucide-plus" aria-hidden="true" />
              </summary>
              <div class="plan-add-menu__popover">
                <button
                  type="button"
                  @click="chooseAddAction($event, 'business', 'item')"
                >
                  <span class="i-lucide-list-plus" aria-hidden="true" /> Add
                  item
                </button>
                <button
                  type="button"
                  @click="chooseAddAction($event, 'business', 'section')"
                >
                  <span class="i-lucide-folder-plus" aria-hidden="true" /> Add
                  category
                </button>
              </div>
            </details>
          </div>
        </header>

        <div class="plan-list" aria-label="Business monthly items">
          <div
            v-for="group in businessGroups"
            :key="group.key"
            class="plan-section"
          >
            <header
              v-if="group.section"
              class="plan-section__heading"
              @dragover.prevent
              @drop.prevent="dropSection('business', group.section.id)"
            >
              <span
                class="i-lucide-grip-vertical plan-section__grip"
                draggable="true"
                :aria-label="`Reorder ${group.section.title}`"
                :title="`Drag to reorder ${group.section.title}`"
                @dragstart.stop="startSectionDrag('business', group.section.id)"
                @dragend="endSectionDrag"
              />
              <button
                type="button"
                class="plan-section__toggle"
                :title="group.section.note || `Edit ${group.section.title}`"
                :aria-expanded="!isSectionCollapsed(group.section.id)"
                @click="toggleSection(group.section.id)"
              >
                <span
                  class="i-lucide-chevron-down plan-section__chevron"
                  :class="{
                    'plan-section__chevron--collapsed': isSectionCollapsed(
                      group.section.id,
                    ),
                  }"
                  aria-hidden="true"
                />
                <strong>{{ group.section.title }}</strong>
                <span v-if="group.section.note" aria-hidden="true">|</span>
                <span v-if="group.section.note" class="plan-section__note">
                  {{ group.section.note }}
                </span>
                <small v-if="group.section.taxTreatment !== 'none'">{{
                  taxTreatmentLabel(group.section.taxTreatment)
                }}</small>
                <span class="plan-section__heading-total">
                  {{ formatRands(totalFor(group.items)) }}
                </span>
              </button>
              <button
                type="button"
                class="plan-section__edit"
                :aria-label="`Edit ${group.section.title}`"
                @click="openEditSection('business', group.section)"
              >
                <span class="i-lucide-pencil" aria-hidden="true" />
              </button>
            </header>

            <div
              v-show="!group.section || !isSectionCollapsed(group.section.id)"
              class="plan-section__body"
            >
              <template
                v-for="item in rootItemsFor(group.items)"
                :key="item.id"
              >
                <PlanCompactItem
                  :item="item"
                  allow-sub-items
                  draggable="true"
                  @dragstart="startItemDrag('business', item.id)"
                  @dragover.prevent
                  @drop.prevent="dropItem('business', item.id)"
                  @dragend="endItemDrag"
                  @edit="openEditItem('business', item)"
                  @add-sub-item="
                    openCreateItem('business', item.sectionId, item.id)
                  "
                />
                <div
                  v-if="subItemsFor(group.items, item.id).length"
                  class="plan-sub-items"
                >
                  <PlanCompactItem
                    v-for="subItem in subItemsFor(group.items, item.id)"
                    :key="subItem.id"
                    :item="subItem"
                    nested
                    draggable="true"
                    @dragstart="startItemDrag('business', subItem.id)"
                    @dragover.prevent
                    @drop.prevent="dropItem('business', subItem.id)"
                    @dragend="endItemDrag"
                    @edit="openEditItem('business', subItem)"
                  />
                  <footer class="plan-sub-items__summary">
                    <span>{{ subItemBalanceLabel(item, group.items) }}</span>
                    <strong>
                      Detailed
                      {{ formatRands(subItemTotal(group.items, item.id)) }}
                    </strong>
                  </footer>
                </div>
              </template>
              <div
                v-if="group.section && !group.items.length"
                class="plan-section__empty"
              >
                <span>No budget items in this category yet.</span>
                <button
                  type="button"
                  @click="openCreateItem('business', group.section.id)"
                >
                  <span class="i-lucide-plus" aria-hidden="true" />
                  Add item
                </button>
              </div>
              <footer v-if="group.section" class="plan-section__total">
                <span>Category total</span>
                <strong>{{ formatRands(totalFor(group.items)) }}</strong>
              </footer>
            </div>
          </div>
        </div>

        <div class="plan-derived" aria-label="Calculated business funding">
          <span class="plan-derived__label">Calculated funding</span>
          <PlanCompactItem :item="ownerNetFundingRow" derived />
          <PlanCompactItem :item="businessPayeRow" derived />
          <PlanCompactItem :item="companyProfitRow" derived />
          <PlanCompactItem :item="companyTaxRow" derived />
        </div>

        <footer class="plan-column__footer">
          <span>Required monthly business revenue</span>
          <strong>{{ formatRands(requiredBusinessRevenue) }}</strong>
        </footer>
      </article>
    </section>

    <details class="plan-tax-reference raven-surface">
      <summary>
        <span>
          <span class="i-lucide-scale" aria-hidden="true" />
          South African tax assumptions · {{ ZA_TAX_YEAR_LABEL }}
        </span>
        <span class="i-lucide-chevron-down" aria-hidden="true" />
      </summary>
      <div class="plan-tax-reference__body">
        <div>
          <h3>Individual income tax</h3>
          <p>
            Progressive annual rates with a primary rebate of
            {{ formatRands(ZA_PRIMARY_REBATE) }} and an under-65 threshold of
            {{ formatRands(ZA_UNDER_65_TAX_THRESHOLD) }}.
          </p>
          <table>
            <thead>
              <tr>
                <th>Annual taxable income</th>
                <th>Marginal rate</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="bracket in ZA_INDIVIDUAL_TAX_BRACKETS"
                :key="bracket.lower"
              >
                <td>{{ formatBracketRange(bracket.lower, bracket.upper) }}</td>
                <td>{{ Math.round(bracket.rate * 100) }}%</td>
              </tr>
            </tbody>
          </table>
          <a
            :href="ZA_INDIVIDUAL_TAX_SOURCE_URL"
            target="_blank"
            rel="noreferrer"
          >
            SARS individual tax rates
          </a>
        </div>
        <div>
          <h3>Company income tax</h3>
          <p>
            Raven uses the general {{ ZA_STANDARD_COMPANY_TAX_RATE * 100 }}%
            company rate on planned taxable profit. With planned profit at zero,
            the model shows zero company tax; it does not tax turnover at 27%.
          </p>
          <a :href="ZA_COMPANY_TAX_SOURCE_URL" target="_blank" rel="noreferrer">
            SARS 2026 Budget Tax Guide
          </a>
          <p class="plan-tax-reference__caveat">
            Ballpark only. The estimate excludes UIF, medical tax credits,
            retirement deductions, provisional-tax timing, dividends and other
            personal or company adjustments.
          </p>
        </div>
      </div>
    </details>

    <footer class="plan-next-step">
      <span class="i-lucide-corner-down-right" aria-hidden="true" />
      <p>
        <strong>Next:</strong> add one genuine expense at a time. Raven will
        keep recalculating the personal gross-up and business revenue target.
      </p>
    </footer>

    <PlanEditorDialog
      :open="editor.open"
      :mode="editor.mode"
      :lane="editor.lane"
      :value="editor.value"
      :sections="sectionsFor(editor.lane)"
      :items="draft[editor.lane]"
      @close="closeEditor"
      @remove="removeEditorEntry"
      @save="saveEditor"
    />
  </div>
</template>

<style scoped>
.plan-page {
  display: grid;
  gap: 20px;
}

.plan-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
}

.plan-header h1 {
  max-width: 780px;
  margin: 8px 0 9px;
  font-size: clamp(30px, 4vw, 48px);
  line-height: 1.02;
  letter-spacing: -0.045em;
}

.plan-export {
  min-height: 38px;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  flex: 0 0 auto;
  border: 1px solid var(--raven-border);
  border-radius: 9px;
  padding: 0 14px;
  color: var(--raven-text);
  background: var(--raven-panel-raised);
  font: inherit;
  font-size: 12px;
  font-weight: 650;
  cursor: pointer;
}

.plan-export:hover {
  border-color: var(--raven-accent);
  color: var(--raven-accent);
  background: var(--raven-accent-soft);
}

.plan-summary {
  display: grid;
  grid-template-columns: minmax(300px, 1.8fr) repeat(3, minmax(160px, 1fr));
  gap: 12px;
}

.plan-summary article {
  min-height: 140px;
  padding: 19px;
}

.plan-summary article > span {
  color: var(--raven-faint);
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.035em;
  text-transform: uppercase;
}

.plan-summary__primary {
  display: flex;
  flex-direction: column;
  justify-content: center;
  border-color: color-mix(
    in srgb,
    var(--raven-accent) 40%,
    var(--raven-border)
  );
  background:
    radial-gradient(circle at 100% 0, rgb(103 198 152 / 0.13), transparent 48%),
    var(--raven-panel);
}

.plan-summary__primary strong {
  display: flex;
  align-items: baseline;
  gap: 8px;
  margin-top: 5px;
  font-size: clamp(30px, 4vw, 46px);
  line-height: 1;
  letter-spacing: -0.04em;
}

.plan-summary__primary strong small {
  color: var(--raven-muted);
  font-size: 12px;
  letter-spacing: 0;
}

.plan-summary__primary p {
  max-width: 480px;
  margin: 10px 0 0;
  color: var(--raven-muted);
  font-size: 12px;
}

.plan-summary__metric {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.plan-summary__metric strong {
  margin-top: 8px;
  font-size: 23px;
  letter-spacing: -0.025em;
}

.plan-summary__metric small {
  margin-top: 2px;
  color: var(--raven-faint);
  font-size: 11px;
}

.plan-columns {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
  align-items: start;
  gap: 16px;
}

.plan-column {
  overflow: visible;
}

.plan-column__header {
  min-height: 76px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  border-bottom: 1px solid var(--raven-border);
  padding: 14px 16px;
  background: var(--raven-panel-raised);
}

.plan-column__header h2 {
  margin: 0;
  font-size: 24px;
  letter-spacing: -0.025em;
}

.plan-column__actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.plan-column__total {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  flex: 0 0 auto;
}

.plan-column__total span {
  color: var(--raven-faint);
  font-size: 9px;
  font-weight: 700;
  text-transform: uppercase;
}

.plan-column__total strong {
  margin-top: 2px;
  font-size: 18px;
}

.plan-add-menu {
  position: relative;
  z-index: 5;
}

.plan-add-menu summary {
  width: 34px;
  height: 34px;
  display: grid;
  place-items: center;
  border: 1px solid var(--raven-border);
  border-radius: 8px;
  color: var(--raven-accent);
  cursor: pointer;
  list-style: none;
}

.plan-add-menu summary::-webkit-details-marker {
  display: none;
}

.plan-add-menu[open] summary,
.plan-add-menu summary:hover {
  border-color: var(--raven-accent);
  background: var(--raven-accent-soft);
}

.plan-add-menu__popover {
  position: absolute;
  top: calc(100% + 6px);
  right: 0;
  width: 160px;
  display: grid;
  overflow: hidden;
  border: 1px solid var(--raven-border);
  border-radius: 10px;
  background: var(--raven-panel-raised);
  box-shadow: 0 16px 40px rgb(0 0 0 / 0.24);
}

.plan-add-menu__popover button {
  min-height: 40px;
  display: flex;
  align-items: center;
  gap: 8px;
  border: 0;
  padding: 0 12px;
  background: transparent;
  color: var(--raven-text);
  font: inherit;
  font-size: 11px;
  text-align: left;
  cursor: pointer;
}

.plan-add-menu__popover button + button {
  border-top: 1px solid var(--raven-border);
}

.plan-add-menu__popover button:hover {
  background: var(--raven-panel);
  color: var(--raven-accent);
}

.plan-list,
.plan-section {
  display: grid;
}

.plan-section__heading {
  display: grid;
  grid-template-columns: 14px minmax(0, 1fr) 24px;
  align-items: center;
  gap: 5px;
  padding: 9px 11px 5px;
  background: var(--raven-panel);
}

.plan-section__grip {
  color: var(--raven-faint);
  font-size: 13px;
  cursor: grab;
}

.plan-section__grip:active {
  cursor: grabbing;
}

.plan-section__toggle {
  width: 100%;
  min-width: 0;
  display: grid;
  grid-template-columns: 14px auto auto minmax(0, 1fr) auto auto;
  align-items: center;
  gap: 7px;
  border: 0;
  padding: 0;
  background: transparent;
  color: var(--raven-faint);
  text-align: left;
  cursor: pointer;
}

.plan-section__toggle strong {
  color: var(--raven-muted);
  font-size: 9px;
  letter-spacing: 0.055em;
  text-transform: uppercase;
}

.plan-section__note {
  min-width: 0;
  overflow: hidden;
  font-size: 10px;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.plan-section__toggle small {
  border: 1px solid var(--raven-border);
  border-radius: 999px;
  padding: 3px 6px;
  font-size: 8px;
  font-weight: 650;
  white-space: nowrap;
}

.plan-section__chevron {
  color: var(--raven-faint);
  font-size: 12px;
  transition: transform 150ms ease;
}

.plan-section__chevron--collapsed {
  transform: rotate(-90deg);
}

.plan-section__heading-total {
  color: var(--raven-muted);
  font-size: 10px;
  font-weight: 700;
  white-space: nowrap;
}

.plan-section__edit {
  width: 24px;
  height: 24px;
  display: grid;
  place-items: center;
  border: 0;
  border-radius: 6px;
  padding: 0;
  color: var(--raven-faint);
  background: transparent;
  cursor: pointer;
}

.plan-section__edit:hover {
  color: var(--raven-accent);
  background: var(--raven-accent-soft);
}

.plan-section__body {
  display: grid;
}

.plan-sub-items {
  display: grid;
  border-left: 2px solid var(--raven-border-strong);
}

.plan-sub-items__summary {
  min-height: 30px;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 10px;
  border-bottom: 1px solid var(--raven-border);
  padding: 0 12px 0 34px;
  color: var(--raven-faint);
  background: color-mix(
    in srgb,
    var(--raven-panel-raised) 60%,
    var(--raven-panel)
  );
  font-size: 9px;
}

.plan-sub-items__summary strong {
  color: var(--raven-muted);
  font-size: 9px;
  font-weight: 700;
}

.plan-section__empty {
  min-height: 46px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  border-bottom: 1px solid var(--raven-border);
  padding: 10px 13px;
  color: var(--raven-faint);
  font-size: 10px;
}

.plan-section__empty button {
  min-height: 28px;
  display: inline-flex;
  align-items: center;
  gap: 5px;
  flex: 0 0 auto;
  border: 1px solid var(--raven-border);
  border-radius: 7px;
  padding: 0 9px;
  color: var(--raven-muted);
  background: var(--raven-panel-raised);
  font: inherit;
  font-size: 10px;
  font-weight: 650;
  cursor: pointer;
}

.plan-section__empty button:hover {
  border-color: var(--raven-accent);
  color: var(--raven-accent);
  background: var(--raven-accent-soft);
}

.plan-section__total {
  min-height: 36px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  border-bottom: 1px solid var(--raven-border);
  padding: 0 13px;
  color: var(--raven-faint);
  background: color-mix(in srgb, var(--raven-panel) 72%, transparent);
  font-size: 9px;
  font-weight: 700;
  letter-spacing: 0.04em;
  text-transform: uppercase;
}

.plan-section__total strong {
  color: var(--raven-muted);
  font-size: 10px;
  letter-spacing: 0;
}

.plan-derived {
  display: grid;
  border-top: 1px solid var(--raven-border-strong);
}

.plan-derived__label {
  padding: 9px 12px 5px;
  color: var(--raven-accent);
  background: color-mix(
    in srgb,
    var(--raven-accent-soft) 25%,
    var(--raven-panel)
  );
  font-size: 9px;
  font-weight: 750;
  letter-spacing: 0.055em;
  text-transform: uppercase;
}

.plan-column__footer {
  min-height: 62px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  padding: 0 16px;
  background: var(--raven-panel-raised);
}

.plan-column__footer span {
  color: var(--raven-muted);
  font-size: 11px;
  font-weight: 650;
}

.plan-column__footer strong {
  font-size: 18px;
}

.plan-tax-reference {
  overflow: hidden;
}

.plan-tax-reference > summary {
  min-height: 52px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 0 16px;
  color: var(--raven-muted);
  font-size: 12px;
  font-weight: 650;
  cursor: pointer;
  list-style: none;
}

.plan-tax-reference > summary::-webkit-details-marker {
  display: none;
}

.plan-tax-reference > summary > span:first-child {
  display: flex;
  align-items: center;
  gap: 9px;
}

.plan-tax-reference[open] > summary {
  border-bottom: 1px solid var(--raven-border);
}

.plan-tax-reference__body {
  display: grid;
  grid-template-columns: minmax(0, 1.4fr) minmax(260px, 1fr);
  gap: 24px;
  padding: 18px;
}

.plan-tax-reference h3 {
  margin: 0 0 7px;
  font-size: 14px;
}

.plan-tax-reference p {
  margin: 0 0 12px;
  color: var(--raven-muted);
  font-size: 11px;
}

.plan-tax-reference table {
  width: 100%;
  margin-bottom: 10px;
  border-collapse: collapse;
  font-size: 10px;
}

.plan-tax-reference th,
.plan-tax-reference td {
  border-bottom: 1px solid var(--raven-border);
  padding: 5px;
  text-align: left;
}

.plan-tax-reference a {
  color: var(--raven-accent);
  font-size: 11px;
}

.plan-tax-reference__caveat {
  margin-top: 18px !important;
  border-left: 2px solid var(--raven-warning);
  padding-left: 10px;
}

.plan-next-step {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 0 4px;
  color: var(--raven-faint);
}

.plan-next-step > span {
  color: var(--raven-accent);
}

.plan-next-step p {
  margin: 0;
  font-size: 12px;
}

.plan-next-step strong {
  color: var(--raven-text);
}

@media (max-width: 1100px) {
  .plan-summary {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }

  .plan-summary__primary {
    grid-column: 1 / -1;
  }

  .plan-columns {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 820px) {
  .plan-header {
    align-items: flex-start;
    flex-direction: column;
  }

  .plan-summary,
  .plan-tax-reference__body {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 520px) {
  .plan-summary {
    grid-template-columns: 1fr;
  }

  .plan-summary__primary {
    grid-column: auto;
  }

  .plan-column__header {
    align-items: flex-start;
  }

  .plan-column__total {
    display: none;
  }

  .plan-section__toggle {
    grid-template-columns: 14px auto minmax(0, 1fr) auto;
  }

  .plan-section__toggle > span:nth-of-type(2),
  .plan-section__toggle small {
    display: none;
  }
}
</style>
