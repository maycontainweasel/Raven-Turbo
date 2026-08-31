<script setup lang="ts">
import type {
  StatementPreviewResult,
  StatementProfileRef,
  StatementSourceDescriptor,
  PreviewLegacyStatementResolutionResult,
  StatementLegacyResolutionResult,
} from "@raven/domain";
import { createCommandIntent } from "@raven/domain";

const route = useRoute();
const api = useStatementTruthApi();
const spaceKey = computed(() => String(route.params.spaceKey ?? ""));
const accountKey = computed(() => String(route.params.accountKey ?? ""));
const originalFile = ref<File | null>(null);
const extractionAssistFile = ref<File | null>(null);
const stagedSource = ref<StatementSourceDescriptor | null>(null);
const profileId = ref<StatementProfileRef["profileId"] | "">("");
const preview = ref<StatementPreviewResult | null>(null);
const detection = ref<any>(null);
const legacyPreview = ref<PreviewLegacyStatementResolutionResult | null>(null);
const reviewedLegacyItems = ref<string[]>([]);
const legacyApplyConfirmed = ref(false);
const legacyReverseConfirmed = ref(false);
const appliedLegacyResolution = ref<StatementLegacyResolutionResult | null>(
  null,
);
const busy = ref<
  | "stage"
  | "preview"
  | "commit"
  | "legacy-preview"
  | "legacy-apply"
  | "legacy-reverse"
  | null
>(null);
const errorMessage = ref("");
const commitIntent = createCommandIntent(
  () => `studio-statement-${crypto.randomUUID()}`,
);
const legacyApplyIntent = createCommandIntent(
  () => `studio-legacy-apply-${crypto.randomUUID()}`,
);
const legacyReverseIntent = createCommandIntent(
  () => `studio-legacy-reverse-${crypto.randomUUID()}`,
);
const selectedLegacyImportId = computed(() =>
  preview.value?.duplicateImports.length === 1
    ? preview.value.duplicateImports[0]!
    : null,
);
const reviewableLegacyItems = computed(
  () =>
    legacyPreview.value?.plan.items.filter(
      (item) => item.compatibilityClass !== "informational_non_movement",
    ) ?? [],
);
const legacyReviewComplete = computed(
  () =>
    reviewableLegacyItems.value.length === reviewedLegacyItems.value.length &&
    reviewableLegacyItems.value.every((item) =>
      reviewedLegacyItems.value.includes(item.key),
    ),
);

useHead({
  title: computed(() => `Import statement · ${accountKey.value} · Raven`),
});

const { data: profilesData } = await useAsyncData(
  "statement-profiles",
  () => api.listStatementProfiles(),
  { server: false },
);

const sourceKind = (file: File) => {
  const extension = file.name.split(".").pop()?.toLowerCase();
  if (file.type === "application/pdf" || extension === "pdf")
    return "pdf" as const;
  if (
    file.type.startsWith("image/") ||
    ["png", "jpg", "jpeg"].includes(extension ?? "")
  ) {
    return "image" as const;
  }
  if (extension === "ofx") return "ofx" as const;
  if (extension === "qif") return "qif" as const;
  return "csv" as const;
};
const sourceMimeType = (file: File) => {
  const kind = sourceKind(file);
  if (kind === "pdf") return "application/pdf";
  if (kind === "ofx") return "application/x-ofx";
  if (kind === "qif") return "application/qif";
  if (kind === "image") {
    return file.name.toLowerCase().endsWith(".png")
      ? "image/png"
      : "image/jpeg";
  }
  return file.type === "text/plain" ? "text/plain" : "text/csv";
};

const selectFile = (event: Event, target: "original" | "assist") => {
  const file = (event.target as HTMLInputElement).files?.[0] ?? null;
  if (target === "original") originalFile.value = file;
  else extractionAssistFile.value = file;
  stagedSource.value = null;
  preview.value = null;
  profileId.value = "";
  detection.value = null;
  commitIntent.clear();
  legacyPreview.value = null;
  reviewedLegacyItems.value = [];
  appliedLegacyResolution.value = null;
  legacyApplyIntent.clear();
  legacyReverseIntent.clear();
};

const stage = async () => {
  if (!originalFile.value) return;
  busy.value = "stage";
  errorMessage.value = "";
  try {
    const assist = extractionAssistFile.value;
    stagedSource.value = await api.stageStatementSource({
      originalBytes: new Uint8Array(await originalFile.value.arrayBuffer()),
      mimeType: sourceMimeType(originalFile.value),
      sourceKind: sourceKind(originalFile.value),
      extractionAssistBytes: assist
        ? new Uint8Array(await assist.arrayBuffer())
        : undefined,
      extractionAssistMimeType: assist ? "application/json" : undefined,
    });
    detection.value = await api.detectStatementProfile({
      sourceRef: stagedSource.value.sourceRef,
    });
  } catch (error: any) {
    errorMessage.value = error?.message ?? "The source could not be staged.";
  } finally {
    busy.value = null;
  }
};

const runPreview = async () => {
  if (!stagedSource.value || !profileId.value) return;
  busy.value = "preview";
  errorMessage.value = "";
  preview.value = null;
  commitIntent.clear();
  try {
    preview.value = await api.previewStatementImport({
      sourceRef: stagedSource.value.sourceRef,
      spaceKey: spaceKey.value,
      accountKey: accountKey.value,
      profileId: profileId.value,
      profileVersion: "1",
    });
    commitIntent.begin();
  } catch (error: any) {
    errorMessage.value = error?.message ?? "The source could not be previewed.";
  } finally {
    busy.value = null;
  }
};

const runLegacyPreview = async () => {
  if (!preview.value || !profileId.value || !selectedLegacyImportId.value)
    return;
  busy.value = "legacy-preview";
  errorMessage.value = "";
  legacyPreview.value = null;
  reviewedLegacyItems.value = [];
  legacyApplyConfirmed.value = false;
  appliedLegacyResolution.value = null;
  legacyApplyIntent.clear();
  legacyReverseIntent.clear();
  try {
    legacyPreview.value = await api.previewLegacyStatementResolution({
      sourceRef: preview.value.source.sourceRef,
      spaceKey: spaceKey.value,
      accountKey: accountKey.value,
      profileId: profileId.value,
      profileVersion: "1",
      previewHash: preview.value.previewHash,
      legacyStatementImportId: selectedLegacyImportId.value,
    });
    legacyApplyIntent.begin();
  } catch (error: any) {
    errorMessage.value =
      error?.message ?? "The legacy-resolution preview could not be derived.";
  } finally {
    busy.value = null;
  }
};

const applyLegacyResolution = async () => {
  if (
    !preview.value ||
    !profileId.value ||
    !selectedLegacyImportId.value ||
    !legacyPreview.value ||
    !legacyPreview.value.plan.applyEligible ||
    !legacyReviewComplete.value ||
    !legacyApplyConfirmed.value
  )
    return;
  busy.value = "legacy-apply";
  errorMessage.value = "";
  try {
    const plan = legacyPreview.value.plan;
    appliedLegacyResolution.value = await api.applyLegacyStatementResolution({
      sourceRef: preview.value.source.sourceRef,
      spaceKey: spaceKey.value,
      accountKey: accountKey.value,
      profileId: profileId.value,
      profileVersion: "1",
      previewHash: preview.value.previewHash,
      legacyStatementImportId: selectedLegacyImportId.value,
      previewIdentityHash: legacyPreview.value.previewIdentityHash,
      expectedDatabaseFingerprint: plan.databaseFingerprint,
      expectedSourceIdentityHash: plan.sourceIdentityHash,
      expectedLegacyEvidenceHash: plan.legacyEvidenceHash,
      expectedAccountContextFingerprint: plan.accountContextFingerprint,
      expectedCrosswalkHash: plan.crosswalkHash,
      expectedRevisionClaimHash: plan.expectedRevisionClaimHash,
      strategy: plan.eligibleStrategies[0]!,
      decisions: reviewableLegacyItems.value.map((item) => ({
        itemKey: item.key,
        outcome: item.activeLedgerOutcome!,
        itemEvidenceHash: item.itemEvidenceHash,
        legacyTransactionId: item.primaryLegacyTransactionId ?? undefined,
        accountTransferId: item.accountTransferId ?? undefined,
      })),
      idempotencyKey: legacyApplyIntent.current(),
    });
    legacyReverseIntent.begin();
  } catch (error: any) {
    errorMessage.value =
      error?.message ?? "The exact legacy resolution could not be applied.";
  } finally {
    busy.value = null;
  }
};

const reverseLegacyResolution = async () => {
  const result = appliedLegacyResolution.value;
  if (!result || !legacyReverseConfirmed.value) return;
  busy.value = "legacy-reverse";
  errorMessage.value = "";
  try {
    appliedLegacyResolution.value = await api.reverseLegacyStatementResolution({
      statementLegacyResolutionId: result.resolution.id,
      expectedDatabaseFingerprint: result.resolution.databaseFingerprint,
      expectedTargetRequestHash: result.resolution.requestHash,
      expectedAuthorityHash: result.resolution.resultAuthorityHash,
      idempotencyKey: legacyReverseIntent.current(),
    });
    legacyApplyIntent.clear();
    legacyReverseIntent.clear();
  } catch (error: any) {
    errorMessage.value =
      error?.message ?? "The exact legacy resolution could not be reversed.";
  } finally {
    busy.value = null;
  }
};

const commit = async () => {
  if (!preview.value || !profileId.value) return;
  busy.value = "commit";
  errorMessage.value = "";
  try {
    const result = await api.commitStatementImport({
      sourceRef: preview.value.source.sourceRef,
      spaceKey: spaceKey.value,
      accountKey: accountKey.value,
      profileId: profileId.value,
      profileVersion: "1",
      previewHash: preview.value.previewHash,
      idempotencyKey: commitIntent.current(),
    });
    commitIntent.clear();
    await navigateTo(
      `/accounts/${spaceKey.value}/${accountKey.value}/statements/${result.statementImport.key}`,
    );
  } catch (error: any) {
    errorMessage.value = error?.message ?? "The source could not be committed.";
  } finally {
    busy.value = null;
  }
};

watch(profileId, () => {
  if (!preview.value) return;
  preview.value = null;
  commitIntent.clear();
  legacyPreview.value = null;
  reviewedLegacyItems.value = [];
  appliedLegacyResolution.value = null;
  legacyApplyIntent.clear();
  legacyReverseIntent.clear();
});

watch([spaceKey, accountKey], () => {
  stagedSource.value = null;
  preview.value = null;
  detection.value = null;
  profileId.value = "";
  commitIntent.clear();
  legacyPreview.value = null;
  reviewedLegacyItems.value = [];
  appliedLegacyResolution.value = null;
  legacyApplyIntent.clear();
  legacyReverseIntent.clear();
});

onBeforeRouteLeave(() => {
  commitIntent.clear();
  legacyApplyIntent.clear();
  legacyReverseIntent.clear();
});
onUnmounted(() => {
  commitIntent.clear();
  legacyApplyIntent.clear();
  legacyReverseIntent.clear();
});

const formatMinor = (value: number | null | undefined) =>
  value === null || value === undefined
    ? "Unavailable"
    : new Intl.NumberFormat("en-ZA", {
        style: "currency",
        currency: "ZAR",
      }).format(value / 100);
</script>

<template>
  <main class="statement-workspace">
    <header class="statement-workspace__header">
      <div>
        <NuxtLink :to="`/accounts/${spaceKey}/${accountKey}`">
          <span class="i-lucide-arrow-left" aria-hidden="true" />
          Account
        </NuxtLink>
        <p class="raven-eyebrow">Statement truth</p>
        <h1>Import statement</h1>
        <p>{{ accountKey }} · source preview</p>
      </div>
      <button
        class="raven-button raven-button--primary"
        type="button"
        :disabled="!preview?.commitAllowed || busy !== null"
        @click="commit"
      >
        <span class="i-lucide-database-zap" aria-hidden="true" />
        {{ busy === "commit" ? "Committing…" : "Commit source" }}
      </button>
    </header>

    <div v-if="errorMessage" class="statement-error" role="alert">
      <span class="i-lucide-triangle-alert" aria-hidden="true" />
      {{ errorMessage }}
    </div>

    <section class="source-intake">
      <label>
        <span>Original evidence</span>
        <input
          type="file"
          accept=".pdf,.csv,.ofx,.qif,image/png,image/jpeg"
          @change="selectFile($event, 'original')"
        />
        <small>{{ originalFile?.name ?? "No source selected" }}</small>
      </label>
      <label>
        <span>Extraction assist</span>
        <input
          type="file"
          accept="application/json,.json"
          @change="selectFile($event, 'assist')"
        />
        <small>{{
          extractionAssistFile?.name ?? "No JSON sidecar selected"
        }}</small>
      </label>
      <button
        class="raven-button"
        type="button"
        :disabled="!originalFile || busy !== null"
        @click="stage"
      >
        <span class="i-lucide-lock-keyhole" aria-hidden="true" />
        {{ busy === "stage" ? "Staging…" : "Stage privately" }}
      </button>
    </section>

    <section v-if="stagedSource" class="profile-selection">
      <header>
        <div>
          <p class="raven-eyebrow">Explicit profile</p>
          <h2>Select adapter</h2>
        </div>
        <span
          >{{ stagedSource.sourceKind }} ·
          {{ stagedSource.byteSize.toLocaleString() }} bytes</span
        >
      </header>
      <div class="profile-selection__options">
        <label
          v-for="profile in profilesData?.profiles ?? []"
          :key="profile.profileId"
        >
          <input v-model="profileId" type="radio" :value="profile.profileId" />
          <span>
            <strong>{{ profile.profileId }}</strong>
            <small>
              v{{ profile.profileVersion }} ·
              {{
                detection?.candidates
                  ?.find(
                    (item: any) => item.profile.profileId === profile.profileId,
                  )
                  ?.evidenceCodes?.includes("EXTRACTION_ASSIST_PROFILE_HINT")
                  ? "extraction assistance hint"
                  : "manual selection"
              }}
            </small>
          </span>
        </label>
      </div>
      <button
        class="raven-button"
        type="button"
        :disabled="!profileId || busy !== null"
        @click="runPreview"
      >
        <span class="i-lucide-scan-search" aria-hidden="true" />
        {{ busy === "preview" ? "Validating…" : "Preview source" }}
      </button>
    </section>

    <template v-if="preview">
      <section class="preview-summary">
        <article>
          <span>Evidence</span>
          <strong>{{ preview.source.originalFileSha256.slice(0, 12) }}</strong>
          <small>original source hash</small>
        </article>
        <article>
          <span>Account</span>
          <strong>{{ preview.account.accountKey }}</strong>
          <small>{{ preview.account.currency }}</small>
        </article>
        <article>
          <span>Versions</span>
          <strong>{{ preview.profile.profileVersion }}</strong>
          <small
            >{{ preview.profile.extractorVersion }} ·
            statement-validation-v0.3</small
          >
        </article>
        <article>
          <span>Coverage</span>
          <strong>{{ preview.extraction.coverage.status }}</strong>
          <small
            >{{ preview.extraction.coverage.extractedRowCount }} /
            {{ preview.extraction.coverage.printedRowCount ?? "?" }}
            printed rows</small
          >
        </article>
        <article>
          <span>Period</span>
          <strong>{{ preview.extraction.periodStart }}</strong>
          <small>to {{ preview.extraction.periodEnd }}</small>
        </article>
        <article>
          <span>Opening</span>
          <strong>{{
            formatMinor(preview.extraction.openingBalanceMinor)
          }}</strong>
          <small>source balance</small>
        </article>
        <article>
          <span>Closing</span>
          <strong>{{
            formatMinor(preview.extraction.closingBalanceMinor)
          }}</strong>
          <small>{{
            preview.extraction.closingBalanceEconomicNature ?? "unmapped"
          }}</small>
        </article>
        <article>
          <span>Difference</span>
          <strong>{{ formatMinor(preview.differenceMinor) }}</strong>
          <small>{{ preview.commitAllowed ? "ready" : "blocked" }}</small>
        </article>
      </section>

      <section v-if="preview.issues.length" class="preview-issues">
        <header>
          <p class="raven-eyebrow">Validation</p>
          <h2>Issues</h2>
        </header>
        <div
          v-for="item in preview.issues"
          :key="`${item.code}-${item.rowKey}-${item.componentKey}`"
          :class="['preview-issue', `is-${item.severity}`]"
        >
          <span
            :class="
              item.blocking ? 'i-lucide-circle-x' : 'i-lucide-triangle-alert'
            "
            aria-hidden="true"
          />
          <span
            ><strong>{{ item.code }}</strong
            ><small>{{ item.message }}</small></span
          >
        </div>
      </section>

      <section v-if="selectedLegacyImportId" class="legacy-resolution">
        <header>
          <div>
            <p class="raven-eyebrow">Selected-period compatibility</p>
            <h2>Legacy authority review</h2>
          </div>
          <button
            class="raven-button"
            type="button"
            :disabled="busy !== null"
            @click="runLegacyPreview"
          >
            <span class="i-lucide-git-compare-arrows" aria-hidden="true" />
            {{
              busy === "legacy-preview" ? "Deriving…" : "Derive exact crosswalk"
            }}
          </button>
        </header>

        <template v-if="legacyPreview">
          <div class="legacy-resolution__summary">
            <span>
              Strategy
              <strong>{{ legacyPreview.plan.recommendedStrategy }}</strong>
            </span>
            <span>
              Apply state
              <strong>{{
                legacyPreview.plan.applyEligible ? "Eligible" : "Blocked"
              }}</strong>
            </span>
            <span
              v-for="(count, key) in legacyPreview.aggregateProjection.counts"
              :key="key"
            >
              {{ String(key).replaceAll("_", " ") }}
              <strong>{{ count }}</strong>
            </span>
          </div>

          <div class="legacy-resolution__items">
            <label
              v-for="item in legacyPreview.privateProjection.items"
              :key="item.key"
              :class="{ 'is-blocking': item.blocking }"
            >
              <input
                v-if="item.compatibilityClass !== 'informational_non_movement'"
                v-model="reviewedLegacyItems"
                type="checkbox"
                :value="item.key"
                :disabled="item.blocking || appliedLegacyResolution !== null"
              />
              <span v-else class="i-lucide-info" aria-hidden="true" />
              <span>
                <strong>{{
                  item.compatibilityClass.replaceAll("_", " ")
                }}</strong>
                <small>
                  {{ item.activeLedgerOutcome ?? "Resolution required" }}
                  · {{ item.canonicalComponents.length }} canonical component(s)
                  · {{ item.legacyTransactionIds.length }} legacy movement(s)
                </small>
              </span>
              <code>{{ item.key }}</code>
            </label>
          </div>

          <div
            v-if="!legacyPreview.plan.applyEligible"
            class="legacy-resolution__blocked"
            role="status"
          >
            <span class="i-lucide-shield-alert" aria-hidden="true" />
            Transfer review or conflicting evidence remains unresolved. Apply is
            unavailable.
          </div>

          <div
            v-else-if="!appliedLegacyResolution"
            class="legacy-resolution__intent"
          >
            <label>
              <input v-model="legacyApplyConfirmed" type="checkbox" />
              Apply this exact reviewed item set and no other disposition.
            </label>
            <button
              class="raven-button raven-button--primary"
              type="button"
              :disabled="
                busy !== null || !legacyReviewComplete || !legacyApplyConfirmed
              "
              @click="applyLegacyResolution"
            >
              <span class="i-lucide-shield-check" aria-hidden="true" />
              {{
                busy === "legacy-apply" ? "Applying…" : "Apply exact resolution"
              }}
            </button>
          </div>

          <div v-else class="legacy-resolution__result">
            <div>
              <span>Authority event</span>
              <strong>{{
                appliedLegacyResolution.resolution.resolutionType
              }}</strong>
              <small>{{ appliedLegacyResolution.receipt.status }}</small>
            </div>
            <NuxtLink
              class="raven-button"
              :to="`/accounts/${spaceKey}/${accountKey}/statements/${appliedLegacyResolution.statementImport.key}`"
            >
              Open source
            </NuxtLink>
            <template
              v-if="
                appliedLegacyResolution.resolution.resolutionType === 'apply'
              "
            >
              <label>
                <input v-model="legacyReverseConfirmed" type="checkbox" />
                Restore only the exact pre-apply authority.
              </label>
              <button
                class="raven-button"
                type="button"
                :disabled="busy !== null || !legacyReverseConfirmed"
                @click="reverseLegacyResolution"
              >
                <span class="i-lucide-rotate-ccw" aria-hidden="true" />
                {{
                  busy === "legacy-reverse" ? "Reversing…" : "Reverse authority"
                }}
              </button>
            </template>
          </div>
        </template>
      </section>

      <section class="preview-rows">
        <header>
          <div>
            <p class="raven-eyebrow">Neutral extraction</p>
            <h2>
              {{ preview.rowCount }} rows ·
              {{ preview.componentCount }} components
            </h2>
          </div>
          <span
            >{{ preview.profile.profileId }} v{{
              preview.profile.profileVersion
            }}</span
          >
        </header>
        <article v-for="row in preview.extraction.rows" :key="row.rowKey">
          <div class="preview-row__source">
            <span>{{ row.rowNumber.toString().padStart(2, "0") }}</span>
            <span>
              <strong>{{ row.rawText }}</strong>
              <small>
                {{
                  row.transactionDate ??
                  row.postingDate ??
                  row.valueDate ??
                  "No printed date"
                }}
                · {{ row.rowKind }}
              </small>
            </span>
            <b>{{ formatMinor(row.reportedBalanceMinor) }}</b>
          </div>
          <div v-if="row.components.length" class="preview-components">
            <div
              v-for="component in row.components"
              :key="component.componentKey"
            >
              <span
                :class="
                  component.componentRole === 'movement'
                    ? 'i-lucide-arrow-left-right'
                    : 'i-lucide-info'
                "
              />
              <span>
                <strong>{{ component.description }}</strong>
                <small
                  >{{ component.componentKind }} ·
                  {{ component.componentRole }}</small
                >
              </span>
              <b>{{ formatMinor(component.amountMinor) }}</b>
              <code
                >{{ component.balanceEffectMinor > 0 ? "+" : ""
                }}{{ component.balanceEffectMinor }}</code
              >
            </div>
          </div>
        </article>
      </section>
    </template>
  </main>
</template>

<style scoped>
.statement-workspace {
  width: min(100% - 32px, 1420px);
  margin: 0 auto;
  padding: 42px 0 80px;
}
.statement-workspace__header,
.profile-selection header,
.preview-rows > header,
.preview-issues > header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
}
.statement-workspace__header a {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  margin-bottom: 24px;
  color: var(--raven-muted);
  font-size: 11px;
  text-decoration: none;
}
h1 {
  margin: 6px 0;
  font-size: 32px;
  letter-spacing: 0;
}
h2 {
  margin: 4px 0 0;
  font-size: 18px;
  letter-spacing: 0;
}
.statement-workspace__header p:last-child,
.profile-selection header > span,
.preview-rows > header > span {
  margin: 0;
  color: var(--raven-muted);
  font-size: 11px;
}
.source-intake,
.profile-selection,
.preview-issues,
.legacy-resolution,
.preview-rows {
  border-top: 1px solid var(--raven-border);
  margin-top: 34px;
  padding-top: 24px;
}
.legacy-resolution > header,
.legacy-resolution__intent,
.legacy-resolution__result {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
}
.legacy-resolution__summary {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  margin-top: 18px;
  border-block: 1px solid var(--raven-border);
}
.legacy-resolution__summary span {
  min-height: 62px;
  display: grid;
  align-content: center;
  gap: 5px;
  border-right: 1px solid var(--raven-border);
  padding: 10px;
  color: var(--raven-muted);
  font-size: 9px;
  text-transform: capitalize;
}
.legacy-resolution__summary strong {
  color: var(--raven-text);
  font-size: 13px;
}
.legacy-resolution__items label {
  min-height: 58px;
  display: grid;
  grid-template-columns: 20px minmax(0, 1fr) auto;
  align-items: center;
  gap: 10px;
  border-bottom: 1px solid var(--raven-border);
}
.legacy-resolution__items label.is-blocking {
  color: var(--raven-danger);
}
.legacy-resolution__items strong,
.legacy-resolution__items small {
  display: block;
  font-size: 10px;
}
.legacy-resolution__items small,
.legacy-resolution__items code {
  margin-top: 4px;
  color: var(--raven-muted);
  font-size: 9px;
}
.legacy-resolution__blocked,
.legacy-resolution__intent,
.legacy-resolution__result {
  min-height: 62px;
  border-bottom: 1px solid var(--raven-border);
  padding: 12px 0;
  font-size: 10px;
}
.legacy-resolution__blocked {
  display: flex;
  align-items: center;
  gap: 9px;
  color: var(--raven-danger);
}
.legacy-resolution__intent label,
.legacy-resolution__result label {
  display: flex;
  align-items: center;
  gap: 8px;
}
.legacy-resolution__result > div span,
.legacy-resolution__result > div small,
.legacy-resolution__result > div strong {
  display: block;
  font-size: 9px;
}
.legacy-resolution__result > div span,
.legacy-resolution__result > div small {
  color: var(--raven-muted);
}
.source-intake {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(0, 1fr) auto;
  align-items: end;
  gap: 14px;
}
.source-intake label {
  min-height: 74px;
  display: grid;
  gap: 7px;
  border: 1px solid var(--raven-border);
  border-radius: 6px;
  padding: 12px;
}
.source-intake label > span,
.source-intake small {
  color: var(--raven-muted);
  font-size: 10px;
}
.profile-selection__options {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 1px;
  margin: 18px 0;
  background: var(--raven-border);
}
.profile-selection__options label {
  min-height: 76px;
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px;
  background: #000;
  cursor: pointer;
}
.profile-selection__options strong,
.profile-selection__options small,
.preview-issue strong,
.preview-issue small {
  display: block;
}
.profile-selection__options strong {
  font-size: 11px;
}
.profile-selection__options small {
  margin-top: 4px;
  color: var(--raven-faint);
  font-size: 9px;
}
.preview-summary {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  border-block: 1px solid var(--raven-border);
  margin-top: 34px;
}
.preview-summary article {
  min-height: 98px;
  display: grid;
  align-content: center;
  gap: 7px;
  border-right: 1px solid var(--raven-border);
  padding: 16px;
}
.preview-summary article:last-child {
  border-right: 0;
}
.preview-summary span,
.preview-summary small {
  color: var(--raven-muted);
  font-size: 10px;
}
.preview-summary strong {
  font-size: 16px;
}
.preview-issue {
  min-height: 54px;
  display: grid;
  grid-template-columns: 20px minmax(0, 1fr);
  align-items: center;
  gap: 10px;
  border-bottom: 1px solid var(--raven-border);
  padding: 9px 2px;
}
.preview-issue strong,
.preview-issue small {
  font-size: 10px;
}
.preview-issue small {
  margin-top: 4px;
  color: var(--raven-muted);
}
.preview-issue.is-blocking {
  color: var(--raven-danger);
}
.preview-rows > article {
  border-bottom: 1px solid var(--raven-border);
}
.preview-row__source,
.preview-components > div {
  display: grid;
  align-items: center;
  gap: 12px;
}
.preview-row__source {
  grid-template-columns: 34px minmax(0, 1fr) auto;
  min-height: 68px;
}
.preview-row__source > span:first-child {
  color: var(--raven-faint);
  font-size: 9px;
}
.preview-row__source strong,
.preview-row__source small,
.preview-components strong,
.preview-components small {
  display: block;
}
.preview-row__source strong {
  font-size: 11px;
}
.preview-row__source small,
.preview-components small {
  margin-top: 4px;
  color: var(--raven-muted);
  font-size: 9px;
}
.preview-components {
  margin: 0 0 12px 46px;
  border-left: 1px solid var(--raven-border);
}
.preview-components > div {
  grid-template-columns: 18px minmax(0, 1fr) auto 72px;
  min-height: 52px;
  padding: 6px 12px;
  background: #050505;
}
.preview-components strong,
.preview-components b,
.preview-components code {
  font-size: 10px;
}
.preview-components code {
  color: var(--raven-muted);
  text-align: right;
}
.statement-error {
  display: flex;
  align-items: center;
  gap: 10px;
  border: 1px solid
    color-mix(in srgb, var(--raven-danger) 45%, var(--raven-border));
  margin-top: 24px;
  padding: 12px;
  color: var(--raven-danger);
  font-size: 11px;
}
@media (max-width: 900px) {
  .source-intake,
  .profile-selection__options,
  .legacy-resolution__summary,
  .preview-summary {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
@media (max-width: 620px) {
  .statement-workspace__header,
  .profile-selection header,
  .preview-rows > header {
    align-items: flex-start;
    flex-direction: column;
  }
  .source-intake,
  .profile-selection__options,
  .legacy-resolution__summary,
  .preview-summary {
    grid-template-columns: 1fr;
  }
  .preview-components {
    margin-left: 18px;
  }
  .preview-components > div {
    grid-template-columns: 18px minmax(0, 1fr) auto;
  }
  .preview-components code {
    grid-column: 2 / -1;
    text-align: left;
  }
  .legacy-resolution > header,
  .legacy-resolution__intent,
  .legacy-resolution__result {
    align-items: flex-start;
    flex-direction: column;
  }
  .legacy-resolution__items label {
    grid-template-columns: 20px minmax(0, 1fr);
  }
  .legacy-resolution__items code {
    grid-column: 2;
  }
}
</style>
