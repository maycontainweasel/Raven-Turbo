<script setup lang="ts">
import { Tabs } from "@ark-ui/vue/tabs";
import type {
  StatementComponentResolution,
  StatementTransactionCandidate,
  StatementTransactionMatchRecord,
} from "@raven/domain";
import { createReviewedCommandIntents } from "~/utils/statement-resolution-intents";
import {
  statementPeriodState,
  statementPeriodStateLabel,
  statementSourceStateLabel,
} from "~/utils/statement-source-state";

type DetailTab = "source" | "resolution" | "reconciliation" | "history";

const route = useRoute();
const api = useStatementTruthApi();
const spaceKey = computed(() => String(route.params.spaceKey ?? ""));
const accountKey = computed(() => String(route.params.accountKey ?? ""));
const importKey = computed(() => String(route.params.importKey ?? ""));
const activeTab = ref<DetailTab>("source");
const selectedComponentIds = ref<string[]>([]);
const candidateReview = ref<{
  componentIds: string[];
  candidates: StatementTransactionCandidate[];
} | null>(null);
const candidatePending = ref(false);
const mutationPending = ref<string | null>(null);
const mutationMessage = ref<{ tone: "success" | "error"; text: string } | null>(
  null,
);
const rejectionReasons = reactive<Record<string, string>>({});
const issueNotes = reactive<Record<string, string>>({});
const supersedingMatchId = ref<string | null>(null);
const reopenReason = ref("");
const drillFilter = ref<string | null>(null);
const replacement = reactive({
  sourceRef: "",
  profileId: "fnb-business" as
    | "fnb-business"
    | "nedbank-current"
    | "nedbank-savings"
    | "nedbank-credit"
    | "normalized-json-v1",
  previewHash: "",
  reason: "",
});
const intents = createReviewedCommandIntents();

useHead({
  title: computed(() => `Statement · ${accountKey.value} · Raven`),
});

const { data, pending, error, refresh } = await useAsyncData(
  computed(
    () =>
      `statement-detail:${spaceKey.value}:${accountKey.value}:${importKey.value}`,
  ),
  async () => {
    const listing = await api.listStatementImports({
      spaceKey: spaceKey.value,
      accountKey: accountKey.value,
    });
    const summary = listing.imports.find(
      (item: any) => item.key === importKey.value,
    );
    if (!summary) throw new Error("Statement source was not found.");
    const source = await api.getStatementImport({
      statementImportId: summary.id,
    });
    const [resolution, matches] = await Promise.all([
      api.getStatementReconciliation({ statementImportId: summary.id }),
      api.listStatementTransactionMatches({
        statementImportId: summary.id,
        includeSuperseded: true,
      }),
    ]);
    return { ...source, resolution, matches: matches.matches };
  },
  { server: false },
);

const statementImport = computed(() => data.value?.statementImport ?? null);
const isActiveSource = computed(
  () => statementImport.value?.sourceState === "committed",
);
const reconciliation = computed(
  () => data.value?.resolution?.reconciliation ?? null,
);
const componentResolutions = computed<StatementComponentResolution[]>(
  () => data.value?.resolution?.components ?? [],
);
const allMatches = computed<StatementTransactionMatchRecord[]>(
  () => data.value?.matches ?? [],
);
const componentsByRow = computed(() => {
  const groups = new Map<string, any[]>();
  for (const component of data.value?.components ?? []) {
    const values = groups.get(component.statementRowId) ?? [];
    values.push(component);
    groups.set(component.statementRowId, values);
  }
  return groups;
});
const resolutionByComponent = computed(
  () =>
    new Map(
      componentResolutions.value.map((item) => [item.component.id, item]),
    ),
);
const periodState = computed(() =>
  statementImport.value
    ? statementPeriodState(
        statementImport.value.sourceState,
        reconciliation.value,
      )
    : "committed_pending",
);
const filteredResolutions = computed(() =>
  drillFilter.value
    ? componentResolutions.value.filter(
        (item) => item.disposition === drillFilter.value,
      )
    : componentResolutions.value,
);
const operationHistory = computed(() => {
  const operations = new Map<
    string,
    { id: string; kind: string; at: string | null }
  >();
  for (const match of allMatches.value) {
    const entries = [
      [match.proposedOperationId, "Match proposed", match.proposedAt],
      [match.confirmedOperationId, "Match confirmed", match.confirmedAt],
      [match.rejectedOperationId, "Match rejected", match.rejectedAt],
      [match.supersededOperationId, "Match superseded", match.supersededAt],
    ] as const;
    for (const [id, kind, at] of entries) {
      if (id) operations.set(id, { id, kind, at });
    }
  }
  for (const event of data.value?.resolution?.events ?? []) {
    operations.set(event.operationId, {
      id: event.operationId,
      kind:
        event.eventType === "attested"
          ? "Reconciliation attested"
          : "Reconciliation reopened",
      at: event.recordedAt,
    });
  }
  return [...operations.values()].sort((left, right) =>
    String(right.at ?? "").localeCompare(String(left.at ?? "")),
  );
});

const formatMinor = (value: number | null | undefined) =>
  value === null || value === undefined
    ? "Unavailable"
    : new Intl.NumberFormat("en-ZA", {
        style: "currency",
        currency: statementImport.value?.currency ?? "ZAR",
      }).format(value / 100);
const shortHash = (value: string | null | undefined) =>
  value ? `${value.slice(0, 12)}…${value.slice(-8)}` : "Not used";
const titleCase = (value: string) =>
  value
    .replaceAll("_", " ")
    .replace(/\b\w/g, (character) => character.toUpperCase());
const errorMessage = (cause: unknown) =>
  cause instanceof Error
    ? cause.message
    : "The reviewed command could not be applied.";
const operationLabel = (id: string) => id.split(":").at(-1) ?? id;

const toggleComponent = (id: string) => {
  selectedComponentIds.value = selectedComponentIds.value.includes(id)
    ? selectedComponentIds.value.filter((value) => value !== id)
    : [...selectedComponentIds.value, id];
  candidateReview.value = null;
  supersedingMatchId.value = null;
};

const runMutation = async <T,>(input: {
  scope: string;
  payload: unknown;
  execute: (idempotencyKey: string) => Promise<T>;
  success: string;
}) => {
  if (!isActiveSource.value) {
    mutationMessage.value = {
      tone: "error",
      text: "This statement source is historical and cannot be changed.",
    };
    return null;
  }
  mutationMessage.value = null;
  mutationPending.value = input.scope;
  const idempotencyKey = intents.begin(input.scope, input.payload);
  try {
    const result: any = await input.execute(idempotencyKey);
    intents.clear(input.scope);
    mutationMessage.value = {
      tone: "success",
      text: `${input.success}${result?.receipt?.status === "replayed" ? " · safe replay" : ""}`,
    };
    candidateReview.value = null;
    selectedComponentIds.value = [];
    supersedingMatchId.value = null;
    await refresh();
    return result;
  } catch (cause) {
    mutationMessage.value = { tone: "error", text: errorMessage(cause) };
    return null;
  } finally {
    mutationPending.value = null;
  }
};

const reviewCandidates = async (componentIds = selectedComponentIds.value) => {
  if (
    !statementImport.value ||
    !isActiveSource.value ||
    componentIds.length === 0
  )
    return;
  candidatePending.value = true;
  mutationMessage.value = null;
  try {
    const result = await api.listStatementMatchCandidates({
      statementImportId: statementImport.value.id,
      componentIds,
    });
    candidateReview.value = {
      componentIds: [...componentIds],
      candidates: [...result.candidates],
    };
    selectedComponentIds.value = [...componentIds];
  } catch (cause) {
    mutationMessage.value = { tone: "error", text: errorMessage(cause) };
  } finally {
    candidatePending.value = false;
  }
};

const reconciliationExpectation = () => ({
  expectedReconciliationRevision: reconciliation.value?.revision ?? null,
  expectedReconciliationHash: reconciliation.value?.calculationHash ?? null,
});

const proposeCandidate = (candidate: StatementTransactionCandidate) => {
  if (
    !statementImport.value ||
    !candidateReview.value ||
    candidate.transferCandidate
  )
    return;
  const payload = {
    statementImportId: statementImport.value.id,
    componentIds: candidateReview.value.componentIds,
    transactionId: candidate.transactionId,
    ...reconciliationExpectation(),
  };
  return runMutation({
    scope: `propose:${candidate.transactionId}`,
    payload,
    execute: (idempotencyKey) =>
      api.proposeStatementTransactionMatch({ ...payload, idempotencyKey }),
    success: "Match proposal recorded",
  });
};

const confirmMatch = (match: StatementTransactionMatchRecord) => {
  const payload = {
    statementTransactionMatchId: match.id,
    expectedRevision: match.revision,
    ...reconciliationExpectation(),
  };
  return runMutation({
    scope: `confirm:${match.id}`,
    payload,
    execute: (idempotencyKey) =>
      api.confirmStatementTransactionMatch({ ...payload, idempotencyKey }),
    success: "Statement evidence confirmed",
  });
};

const rejectMatch = (match: StatementTransactionMatchRecord) => {
  const reason = rejectionReasons[match.id]?.trim();
  if (!reason) return;
  const payload = {
    statementTransactionMatchId: match.id,
    expectedRevision: match.revision,
    reason,
    ...reconciliationExpectation(),
  };
  return runMutation({
    scope: `reject:${match.id}`,
    payload,
    execute: (idempotencyKey) =>
      api.rejectStatementTransactionMatch({ ...payload, idempotencyKey }),
    success: "Proposal rejected with history preserved",
  });
};

const materializeSelected = () => {
  if (!statementImport.value || !selectedComponentIds.value.length) return;
  const payload = {
    statementImportId: statementImport.value.id,
    componentIds: [...selectedComponentIds.value],
    ...reconciliationExpectation(),
  };
  return runMutation({
    scope: "materialize:selected",
    payload,
    execute: (idempotencyKey) =>
      api.materializeStatementComponentTransaction({
        ...payload,
        idempotencyKey,
      }),
    success: "One statement-backed Transaction materialized",
  });
};

const beginSupersession = async (match: StatementTransactionMatchRecord) => {
  supersedingMatchId.value = match.id;
  selectedComponentIds.value = [...match.componentIds];
  await reviewCandidates(match.componentIds);
};

const supersedeWithCandidate = (candidate: StatementTransactionCandidate) => {
  const old = allMatches.value.find(
    (match) => match.id === supersedingMatchId.value,
  );
  if (!old || !candidateReview.value || candidate.transferCandidate) return;
  const reason = rejectionReasons[old.id]?.trim();
  if (!reason) return;
  const payload = {
    statementTransactionMatchId: old.id,
    expectedRevision: old.revision,
    componentIds: candidateReview.value.componentIds,
    transactionId: candidate.transactionId,
    reason,
    ...reconciliationExpectation(),
  };
  return runMutation({
    scope: `supersede:${old.id}`,
    payload,
    execute: (idempotencyKey) =>
      api.supersedeStatementTransactionMatch({ ...payload, idempotencyKey }),
    success: "Match superseded with append-only lineage",
  });
};

const acknowledgeIssue = (issue: any) => {
  const note = issueNotes[issue.id]?.trim();
  if (!note || issue.blocking) return;
  const payload = {
    statementIssueId: issue.id,
    expectedRevision: issue.revision,
    note,
    ...reconciliationExpectation(),
  };
  return runMutation({
    scope: `issue:${issue.id}`,
    payload,
    execute: (idempotencyKey) =>
      api.acknowledgeStatementIssue({ ...payload, idempotencyKey }),
    success: "Non-blocking issue acknowledged",
  });
};

const recalculate = () => {
  if (!statementImport.value) return;
  const payload = {
    statementImportId: statementImport.value.id,
    expectedRevision: reconciliation.value?.revision ?? null,
    expectedHash: reconciliation.value?.calculationHash ?? null,
  };
  return runMutation({
    scope: "recalculate",
    payload,
    execute: (idempotencyKey) =>
      api.recalculateStatementReconciliation({ ...payload, idempotencyKey }),
    success: "Exact reconciliation recalculated",
  });
};

const attest = () => {
  if (!statementImport.value || !reconciliation.value) return;
  const payload = {
    statementImportId: statementImport.value.id,
    expectedRevision: reconciliation.value.revision,
    calculationHash: reconciliation.value.calculationHash,
  };
  return runMutation({
    scope: "attest",
    payload,
    execute: (idempotencyKey) =>
      api.attestStatementReconciled({ ...payload, idempotencyKey }),
    success: "Statement period attested",
  });
};

const reopen = () => {
  if (
    !statementImport.value ||
    !reconciliation.value ||
    !reopenReason.value.trim()
  )
    return;
  const payload = {
    statementImportId: statementImport.value.id,
    expectedRevision: reconciliation.value.revision,
    calculationHash: reconciliation.value.calculationHash,
    reason: reopenReason.value.trim(),
  };
  return runMutation({
    scope: "reopen",
    payload,
    execute: (idempotencyKey) =>
      api.reopenStatementReconciliation({ ...payload, idempotencyKey }),
    success: "Reconciliation reopened with prior attestation preserved",
  });
};

const supersedeSource = () => {
  if (
    !statementImport.value ||
    replacement.sourceRef.trim().length === 0 ||
    replacement.previewHash.length !== 64 ||
    replacement.reason.trim().length === 0
  )
    return;
  const payload = {
    statementImportId: statementImport.value.id,
    expectedSourceRevision: statementImport.value.revision,
    expectedReconciliationRevision: reconciliation.value?.revision ?? null,
    expectedReconciliationHash: reconciliation.value?.calculationHash ?? null,
    replacement: {
      sourceRef: replacement.sourceRef.trim(),
      spaceKey: spaceKey.value,
      accountKey: accountKey.value,
      profileId: replacement.profileId,
      profileVersion: "1" as const,
      previewHash: replacement.previewHash,
    },
    reason: replacement.reason.trim(),
  };
  return runMutation({
    scope: "source-supersession",
    payload,
    execute: (idempotencyKey) =>
      api.supersedeStatementImport({ ...payload, idempotencyKey }),
    success: "Replacement source committed and prior source preserved",
  });
};
</script>

<template>
  <main class="statement-detail">
    <header class="statement-detail__header">
      <div>
        <NuxtLink :to="`/accounts/${spaceKey}/${accountKey}`">
          <span class="i-lucide-arrow-left" aria-hidden="true" />
          Account
        </NuxtLink>
        <p class="raven-eyebrow">
          {{
            statementImport
              ? statementPeriodStateLabel(periodState)
              : "Statement source"
          }}
        </p>
        <h1>{{ statementImport?.periodEnd ?? importKey }}</h1>
        <p>
          {{ accountKey }} ·
          {{ statementImport?.profile.profileId ?? "Statement" }}
        </p>
      </div>
      <span class="statement-detail__state" :data-state="periodState">
        <i class="i-lucide-shield-check" aria-hidden="true" />
        {{
          statementImport ? statementPeriodStateLabel(periodState) : "Loading"
        }}
      </span>
    </header>

    <div v-if="pending" class="statement-detail__status">
      Loading statement authority…
    </div>
    <div
      v-else-if="error"
      class="statement-detail__status is-error"
      role="alert"
    >
      <span>The statement authority could not be loaded.</span>
      <button class="raven-button" type="button" @click="refresh">Retry</button>
    </div>

    <template v-else-if="data && statementImport">
      <section class="statement-detail__summary" aria-label="Statement summary">
        <article>
          <span>Period</span><strong>{{ statementImport.periodStart }}</strong
          ><small>to {{ statementImport.periodEnd }}</small>
        </article>
        <article>
          <span>Opening</span
          ><strong>{{
            formatMinor(statementImport.openingBalanceMinor)
          }}</strong
          ><small>committed source value</small>
        </article>
        <article>
          <span>Expected closing</span
          ><strong>{{
            formatMinor(reconciliation?.expectedClosingBalanceMinor)
          }}</strong
          ><small>{{
            reconciliation?.calculationState ?? "not calculated"
          }}</small>
        </article>
        <article>
          <span>Difference</span
          ><strong>{{ formatMinor(reconciliation?.differenceMinor) }}</strong
          ><small
            >{{
              reconciliation?.counts.unresolvedCount ??
              statementImport.componentCount
            }}
            unresolved</small
          >
        </article>
      </section>

      <div
        v-if="mutationMessage"
        class="statement-feedback"
        :class="`is-${mutationMessage.tone}`"
        role="status"
      >
        <span
          :class="
            mutationMessage.tone === 'success'
              ? 'i-lucide-circle-check'
              : 'i-lucide-triangle-alert'
          "
          aria-hidden="true"
        />
        <span>{{ mutationMessage.text }}</span>
      </div>

      <Tabs.Root v-model="activeTab" class="statement-tabs">
        <Tabs.List
          class="statement-tabs__list"
          aria-label="Statement detail sections"
        >
          <Tabs.Trigger value="source">Source</Tabs.Trigger>
          <Tabs.Trigger value="resolution">Resolution</Tabs.Trigger>
          <Tabs.Trigger value="reconciliation">Reconciliation</Tabs.Trigger>
          <Tabs.Trigger value="history">History</Tabs.Trigger>
          <Tabs.Indicator class="statement-tabs__indicator" />
        </Tabs.List>

        <Tabs.Content value="source" class="statement-tabs__content">
          <section class="statement-section statement-identity">
            <header>
              <p class="raven-eyebrow">Immutable identity</p>
              <h2>Source provenance</h2>
            </header>
            <dl>
              <div>
                <dt>Original evidence</dt>
                <dd>
                  <code>{{
                    shortHash(statementImport.originalFileSha256)
                  }}</code>
                </dd>
              </div>
              <div>
                <dt>Extraction input</dt>
                <dd>
                  <code>{{
                    shortHash(statementImport.extractionInputSha256)
                  }}</code>
                </dd>
              </div>
              <div>
                <dt>Canonical extraction</dt>
                <dd>
                  <code>{{
                    shortHash(statementImport.canonicalExtractionSha256)
                  }}</code>
                </dd>
              </div>
              <div>
                <dt>Preview</dt>
                <dd>
                  <code>{{ shortHash(statementImport.previewHash) }}</code>
                </dd>
              </div>
              <div>
                <dt>Adapter</dt>
                <dd>
                  {{ statementImport.profile.profileId }} v{{
                    statementImport.profile.profileVersion
                  }}
                  · {{ statementImport.profile.extractorVersion }}
                </dd>
              </div>
              <div>
                <dt>Source state</dt>
                <dd>
                  {{ statementSourceStateLabel(statementImport.sourceState) }} ·
                  revision {{ statementImport.revision }}
                </dd>
              </div>
            </dl>
          </section>

          <section
            v-if="data.issues.length"
            class="statement-section statement-issues"
          >
            <header>
              <p class="raven-eyebrow">Source exceptions</p>
              <h2>{{ data.issues.length }} committed issues</h2>
            </header>
            <article
              v-for="issue in data.issues"
              :key="issue.id"
              class="issue-row"
            >
              <span class="i-lucide-triangle-alert" aria-hidden="true" />
              <span
                ><strong>{{ issue.code }}</strong
                ><small>{{ issue.message }} · {{ issue.state }}</small></span
              >
              <span v-if="issue.blocking" class="status-chip is-danger"
                >Blocking</span
              >
              <div v-else-if="issue.state === 'open'" class="inline-action">
                <input
                  v-model="issueNotes[issue.id]"
                  type="text"
                  maxlength="1000"
                  placeholder="Acknowledgement note"
                  :aria-label="`Acknowledgement note for ${issue.code}`"
                />
                <button
                  class="raven-button"
                  type="button"
                  :disabled="
                    !isActiveSource ||
                    mutationPending !== null ||
                    !issueNotes[issue.id]?.trim()
                  "
                  @click="acknowledgeIssue(issue)"
                >
                  Acknowledge
                </button>
              </div>
            </article>
          </section>

          <section class="statement-section statement-rows">
            <header>
              <p class="raven-eyebrow">Printed source</p>
              <h2>Rows and components</h2>
            </header>
            <article
              v-for="row in data.rows"
              :key="row.id"
              class="source-row-group"
            >
              <div class="statement-row">
                <span>{{ row.rowNumber.toString().padStart(2, "0") }}</span>
                <span
                  ><strong>{{ row.rawText }}</strong
                  ><small
                    >{{
                      row.transactionDate ??
                      row.postingDate ??
                      row.valueDate ??
                      "No printed date"
                    }}
                    · {{ row.rowKind }}</small
                  ></span
                >
                <b>{{ formatMinor(row.reportedBalanceMinor) }}</b>
              </div>
              <div
                v-for="component in componentsByRow.get(row.id) ?? []"
                :key="component.id"
                class="statement-component"
              >
                <span
                  :class="
                    component.componentRole === 'movement'
                      ? 'i-lucide-arrow-left-right'
                      : 'i-lucide-info'
                  "
                  aria-hidden="true"
                />
                <span
                  ><strong>{{ component.description }}</strong
                  ><small
                    >{{ component.componentKind }} ·
                    {{
                      titleCase(
                        resolutionByComponent.get(component.id)?.disposition ??
                          component.componentRole,
                      )
                    }}</small
                  ></span
                >
                <b>{{ formatMinor(component.amountMinor) }}</b>
                <code
                  >{{ component.balanceEffectMinor > 0 ? "+" : ""
                  }}{{ component.balanceEffectMinor }}</code
                >
              </div>
            </article>
          </section>

          <details class="statement-section source-replacement">
            <summary>
              <span
                ><span class="i-lucide-replace" aria-hidden="true" /> Replace
                committed source</span
              ><span class="i-lucide-chevron-down" aria-hidden="true" />
            </summary>
            <p>
              A replacement creates a new immutable source and preserves this
              import, its rows, matches, and attestations.
            </p>
            <div class="guarded-form">
              <label
                ><span>Staged source reference</span
                ><input
                  v-model="replacement.sourceRef"
                  type="text"
                  autocomplete="off"
              /></label>
              <label
                ><span>Adapter</span
                ><select v-model="replacement.profileId">
                  <option value="fnb-business">FNB business</option>
                  <option value="nedbank-current">Nedbank current</option>
                  <option value="nedbank-savings">Nedbank savings</option>
                  <option value="nedbank-credit">Nedbank credit</option>
                  <option value="normalized-json-v1">Normalized JSON</option>
                </select></label
              >
              <label
                ><span>Reviewed preview hash</span
                ><input
                  v-model="replacement.previewHash"
                  type="text"
                  maxlength="64"
                  autocomplete="off"
              /></label>
              <label
                ><span>Replacement reason</span
                ><textarea
                  v-model="replacement.reason"
                  maxlength="500"
                  rows="3"
                />
              </label>
              <button
                class="raven-button is-danger"
                type="button"
                :disabled="
                  !isActiveSource ||
                  mutationPending !== null ||
                  !replacement.sourceRef.trim() ||
                  replacement.previewHash.length !== 64 ||
                  !replacement.reason.trim()
                "
                @click="supersedeSource"
              >
                Commit replacement
              </button>
            </div>
          </details>
        </Tabs.Content>

        <Tabs.Content value="resolution" class="statement-tabs__content">
          <section class="statement-section resolution-workbench">
            <header class="section-heading-with-actions">
              <div>
                <p class="raven-eyebrow">Evidence linkage</p>
                <h2>Movement resolution</h2>
              </div>
              <div class="section-actions">
                <button
                  class="raven-button"
                  type="button"
                  :disabled="
                    !isActiveSource ||
                    candidatePending ||
                    selectedComponentIds.length === 0
                  "
                  @click="reviewCandidates()"
                >
                  <span class="i-lucide-search" aria-hidden="true" /> Review
                  selected
                </button>
                <button
                  class="raven-button"
                  type="button"
                  :disabled="
                    !isActiveSource ||
                    mutationPending !== null ||
                    selectedComponentIds.length === 0
                  "
                  @click="materializeSelected"
                >
                  <span class="i-lucide-file-plus-2" aria-hidden="true" />
                  Materialize
                </button>
              </div>
            </header>
            <p class="section-note">
              Candidates are suggestions. Confirmation is an explicit audited
              act; materialization creates no management or tax meaning.
            </p>
            <div v-if="!componentResolutions.length" class="empty-state">
              Run reconciliation to derive component dispositions.
            </div>
            <article
              v-for="resolution in filteredResolutions"
              v-else
              :key="resolution.component.id"
              class="resolution-row"
            >
              <label class="resolution-select">
                <input
                  v-if="
                    resolution.component.componentRole === 'movement' &&
                    !resolution.activeMatch
                  "
                  type="checkbox"
                  :checked="
                    selectedComponentIds.includes(resolution.component.id)
                  "
                  @change="toggleComponent(resolution.component.id)"
                />
                <span
                  v-else
                  :class="
                    resolution.component.componentRole === 'movement'
                      ? 'i-lucide-link-2'
                      : 'i-lucide-info'
                  "
                  aria-hidden="true"
                />
              </label>
              <span
                ><strong>{{ resolution.component.description }}</strong
                ><small
                  >{{
                    resolution.component.transactionDate ??
                    resolution.component.postingDate ??
                    resolution.component.valueDate
                  }}
                  · {{ resolution.component.componentKind }}</small
                ></span
              >
              <b>{{ formatMinor(resolution.component.balanceEffectMinor) }}</b>
              <span
                class="status-chip"
                :data-disposition="resolution.disposition"
                >{{ titleCase(resolution.disposition) }}</span
              >
              <div v-if="resolution.activeMatch" class="resolution-match">
                <span
                  >Transaction
                  {{ operationLabel(resolution.activeMatch.transactionId) }} ·
                  {{ resolution.activeMatch.method }} · revision
                  {{ resolution.activeMatch.revision }}</span
                >
                <button
                  class="raven-icon-button"
                  type="button"
                  title="Review replacement match"
                  aria-label="Review replacement match"
                  @click="beginSupersession(resolution.activeMatch)"
                >
                  <span class="i-lucide-replace" aria-hidden="true" />
                </button>
              </div>
              <div
                v-for="proposal in resolution.proposals"
                :key="proposal.id"
                class="proposal-row"
              >
                <span
                  ><strong>{{ titleCase(proposal.method) }}</strong
                  ><small
                    >{{ proposal.reasonCodes.map(titleCase).join(" · ") }} ·
                    {{ Math.round(proposal.confidence * 100) }}%</small
                  ></span
                >
                <button
                  class="raven-button"
                  type="button"
                  :disabled="!isActiveSource || mutationPending !== null"
                  @click="confirmMatch(proposal)"
                >
                  <span class="i-lucide-check" aria-hidden="true" /> Confirm
                </button>
                <input
                  v-model="rejectionReasons[proposal.id]"
                  type="text"
                  maxlength="500"
                  placeholder="Rejection reason"
                  :aria-label="`Rejection reason for ${proposal.id}`"
                />
                <button
                  class="raven-icon-button"
                  type="button"
                  title="Reject proposal"
                  aria-label="Reject proposal"
                  :disabled="
                    !isActiveSource ||
                    mutationPending !== null ||
                    !rejectionReasons[proposal.id]?.trim()
                  "
                  @click="rejectMatch(proposal)"
                >
                  <span class="i-lucide-x" aria-hidden="true" />
                </button>
              </div>
            </article>
          </section>

          <section
            v-if="candidatePending || candidateReview"
            class="statement-section candidate-panel"
          >
            <header>
              <p class="raven-eyebrow">Deterministic review</p>
              <h2>
                {{
                  supersedingMatchId
                    ? "Replacement candidates"
                    : "Candidate Transactions"
                }}
              </h2>
            </header>
            <div v-if="candidatePending" class="empty-state">
              Checking exact Account, currency, amount, direction, and date
              invariants…
            </div>
            <div
              v-else-if="!candidateReview?.candidates.length"
              class="empty-state"
            >
              No exact provisional Transaction candidate was found. Explicit
              materialization remains available when no transfer candidate
              exists.
            </div>
            <article
              v-for="candidate in candidateReview?.candidates ?? []"
              v-else
              :key="candidate.transactionId"
              class="candidate-row"
            >
              <span
                ><strong>{{ candidate.description }}</strong
                ><small
                  >{{ candidate.financialDate }} ·
                  {{ candidate.account.accountKey }} ·
                  {{ candidate.evidenceState }}</small
                ></span
              >
              <span
                ><b>{{ formatMinor(candidate.signedComponentTotalMinor) }}</b
                ><small
                  >{{ titleCase(candidate.method) }} ·
                  {{ candidate.reasonCodes.map(titleCase).join(" · ") }}</small
                ></span
              >
              <span class="confidence"
                >{{ Math.round(candidate.confidence * 100) }}%</span
              >
              <span
                v-if="candidate.transferCandidate"
                class="status-chip is-warning"
                >Transfer candidate · review only</span
              >
              <button
                v-else
                class="raven-button"
                type="button"
                :disabled="!isActiveSource || mutationPending !== null"
                @click="
                  supersedingMatchId
                    ? supersedeWithCandidate(candidate)
                    : proposeCandidate(candidate)
                "
              >
                {{ supersedingMatchId ? "Supersede" : "Propose" }}
              </button>
            </article>
            <label v-if="supersedingMatchId" class="supersession-reason"
              ><span>Supersession reason</span
              ><input
                v-model="rejectionReasons[supersedingMatchId]"
                type="text"
                maxlength="500"
            /></label>
          </section>
        </Tabs.Content>

        <Tabs.Content value="reconciliation" class="statement-tabs__content">
          <section class="statement-section reconciliation-equation">
            <header class="section-heading-with-actions">
              <div>
                <p class="raven-eyebrow">Exact period proof</p>
                <h2>Statement reconciliation</h2>
              </div>
              <button
                class="raven-button"
                type="button"
                :disabled="!isActiveSource || mutationPending !== null"
                @click="recalculate"
              >
                <span class="i-lucide-refresh-cw" aria-hidden="true" />
                Recalculate
              </button>
            </header>
            <div v-if="!reconciliation" class="empty-state">
              No reconciliation has been calculated for this committed source.
            </div>
            <template v-else>
              <div class="equation-line" aria-label="Reconciliation equation">
                <span
                  ><small>Opening</small
                  ><strong>{{
                    formatMinor(reconciliation.openingBalanceMinor)
                  }}</strong></span
                ><b>+</b>
                <span
                  ><small>Signed movement</small
                  ><strong>{{
                    formatMinor(reconciliation.signedMovementEffectMinor)
                  }}</strong></span
                ><b>=</b>
                <span
                  ><small>Expected closing</small
                  ><strong>{{
                    formatMinor(reconciliation.expectedClosingBalanceMinor)
                  }}</strong></span
                ><b>→</b>
                <span
                  ><small>Difference</small
                  ><strong>{{
                    formatMinor(reconciliation.differenceMinor)
                  }}</strong></span
                >
              </div>
              <div class="reconciliation-counts">
                <button type="button" @click="drillFilter = 'pending'">
                  <span>Pending</span
                  ><strong>{{ reconciliation.counts.pendingCount }}</strong>
                </button>
                <button type="button" @click="drillFilter = 'proposed'">
                  <span>Proposed</span
                  ><strong>{{ reconciliation.counts.proposedCount }}</strong>
                </button>
                <button type="button" @click="drillFilter = 'matched_existing'">
                  <span>Matched</span
                  ><strong>{{
                    reconciliation.counts.confirmedExistingCount
                  }}</strong>
                </button>
                <button
                  type="button"
                  @click="drillFilter = 'materialized_imported'"
                >
                  <span>Materialized</span
                  ><strong>{{
                    reconciliation.counts.newlyMaterializedCount
                  }}</strong>
                </button>
                <button type="button" @click="drillFilter = 'informational'">
                  <span>Informational</span
                  ><strong>{{
                    reconciliation.counts.informationalComponentCount
                  }}</strong>
                </button>
                <button
                  type="button"
                  @click="
                    activeTab = 'resolution';
                    drillFilter = null;
                  "
                >
                  <span>Transfer candidates</span
                  ><strong>{{
                    reconciliation.counts.transferCandidateCount
                  }}</strong>
                </button>
                <button type="button" @click="activeTab = 'source'">
                  <span>Active issues</span
                  ><strong>{{ reconciliation.counts.activeIssueCount }}</strong>
                </button>
                <button type="button" @click="activeTab = 'source'">
                  <span>Blocking</span
                  ><strong>{{
                    reconciliation.counts.blockingIssueCount
                  }}</strong>
                </button>
              </div>
              <div class="reconciliation-gates">
                <span :data-pass="reconciliation.coverageState === 'complete'"
                  ><i
                    :class="
                      reconciliation.coverageState === 'complete'
                        ? 'i-lucide-check'
                        : 'i-lucide-x'
                    "
                  />
                  Source coverage</span
                >
                <span :data-pass="reconciliation.counts.unresolvedCount === 0"
                  ><i
                    :class="
                      reconciliation.counts.unresolvedCount === 0
                        ? 'i-lucide-check'
                        : 'i-lucide-x'
                    "
                  />
                  One resolution per movement</span
                >
                <span
                  :data-pass="reconciliation.counts.blockingIssueCount === 0"
                  ><i
                    :class="
                      reconciliation.counts.blockingIssueCount === 0
                        ? 'i-lucide-check'
                        : 'i-lucide-x'
                    "
                  />
                  No blocking issue</span
                >
                <span :data-pass="reconciliation.differenceMinor === 0"
                  ><i
                    :class="
                      reconciliation.differenceMinor === 0
                        ? 'i-lucide-check'
                        : 'i-lucide-x'
                    "
                  />
                  Exact zero difference</span
                >
              </div>
              <div class="reconciliation-actions">
                <button
                  v-if="reconciliation.attestationState !== 'reconciled'"
                  class="raven-button"
                  type="button"
                  :disabled="
                    !isActiveSource ||
                    mutationPending !== null ||
                    !['ready', 'reopened'].includes(
                      reconciliation.attestationState,
                    )
                  "
                  @click="attest"
                >
                  <span class="i-lucide-badge-check" aria-hidden="true" />
                  Attest reconciled
                </button>
                <template v-else>
                  <label
                    ><span>Reopening reason</span
                    ><input v-model="reopenReason" type="text" maxlength="500"
                  /></label>
                  <button
                    class="raven-button"
                    type="button"
                    :disabled="
                      !isActiveSource ||
                      mutationPending !== null ||
                      !reopenReason.trim()
                    "
                    @click="reopen"
                  >
                    <span class="i-lucide-lock-open" aria-hidden="true" />
                    Reopen
                  </button>
                </template>
                <span class="calculation-hash"
                  >Revision {{ reconciliation.revision }} ·
                  <code>{{
                    shortHash(reconciliation.calculationHash)
                  }}</code></span
                >
              </div>
              <div v-if="drillFilter" class="reconciliation-drilldown">
                <header>
                  <strong>{{ titleCase(drillFilter) }}</strong
                  ><button
                    class="raven-icon-button"
                    type="button"
                    title="Clear drill-down"
                    aria-label="Clear drill-down"
                    @click="drillFilter = null"
                  >
                    <span class="i-lucide-x" />
                  </button>
                </header>
                <div
                  v-for="item in filteredResolutions"
                  :key="item.component.id"
                >
                  <span>{{ item.component.description }}</span
                  ><b>{{ formatMinor(item.component.balanceEffectMinor) }}</b>
                </div>
                <p v-if="!filteredResolutions.length">
                  No components in this state.
                </p>
              </div>
            </template>
          </section>
        </Tabs.Content>

        <Tabs.Content value="history" class="statement-tabs__content">
          <section class="statement-section history-section">
            <header>
              <p class="raven-eyebrow">Append-only evidence</p>
              <h2>Match and reconciliation history</h2>
            </header>
            <div
              v-if="!allMatches.length && !operationHistory.length"
              class="empty-state"
            >
              No ST-02 history has been recorded.
            </div>
            <article
              v-for="match in allMatches"
              :key="match.id"
              class="history-row"
            >
              <span
                :class="
                  match.state === 'confirmed'
                    ? 'i-lucide-link-2'
                    : match.state === 'superseded'
                      ? 'i-lucide-history'
                      : 'i-lucide-circle-dashed'
                "
                aria-hidden="true"
              />
              <span
                ><strong
                  >{{ titleCase(match.state) }} ·
                  {{ titleCase(match.method) }}</strong
                ><small
                  >{{ match.componentIds.length }} component{{
                    match.componentIds.length === 1 ? "" : "s"
                  }}
                  → {{ operationLabel(match.transactionId) }}</small
                ></span
              >
              <span>revision {{ match.revision }}</span>
              <code>{{ operationLabel(match.id) }}</code>
            </article>
            <h3 v-if="operationHistory.length">Operations and attestations</h3>
            <article
              v-for="operation in operationHistory"
              :key="operation.id"
              class="history-row operation-row"
            >
              <span class="i-lucide-receipt-text" aria-hidden="true" />
              <span
                ><strong>{{ operation.kind }}</strong
                ><small>{{
                  operation.at ?? "Timestamp unavailable"
                }}</small></span
              >
              <code>{{ operationLabel(operation.id) }}</code>
            </article>
          </section>
        </Tabs.Content>
      </Tabs.Root>
    </template>
  </main>
</template>

<style scoped>
.statement-detail {
  width: min(100% - 32px, 1420px);
  margin: 0 auto;
  padding: 42px 0 80px;
}
.statement-detail__header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
}
.statement-detail__header a {
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
  margin: 5px 0 0;
  font-size: 18px;
  letter-spacing: 0;
}
h3 {
  margin: 32px 0 10px;
  font-size: 12px;
  letter-spacing: 0;
}
.statement-detail__header p:last-child,
.section-note {
  margin: 0;
  color: var(--raven-muted);
  font-size: 11px;
}
.statement-detail__state,
.status-chip {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  border: 1px solid
    color-mix(in srgb, var(--raven-accent) 45%, var(--raven-border));
  border-radius: 5px;
  padding: 8px 10px;
  color: var(--raven-accent);
  font-size: 10px;
}
.statement-detail__state[data-state="reopened"],
.status-chip.is-warning {
  border-color: #8d6a19;
  color: #e2b84b;
}
.statement-detail__summary {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  border-block: 1px solid var(--raven-border);
  margin-top: 34px;
}
.statement-detail__summary article {
  min-height: 98px;
  display: grid;
  align-content: center;
  gap: 7px;
  border-right: 1px solid var(--raven-border);
  padding: 16px;
}
.statement-detail__summary article:last-child {
  border-right: 0;
}
.statement-detail__summary span,
.statement-detail__summary small,
.equation-line small {
  color: var(--raven-muted);
  font-size: 10px;
}
.statement-detail__summary strong {
  font-size: 16px;
}
.statement-feedback {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-top: 18px;
  border-block: 1px solid var(--raven-border);
  padding: 12px 0;
  font-size: 11px;
}
.statement-feedback.is-success {
  color: var(--raven-accent);
}
.statement-feedback.is-error,
.status-chip.is-danger {
  color: var(--raven-danger);
}
.statement-tabs {
  margin-top: 24px;
}
.statement-tabs__list {
  position: relative;
  display: flex;
  gap: 3px;
  width: fit-content;
  max-width: 100%;
  border: 1px solid var(--raven-border);
  border-radius: 6px;
  padding: 3px;
  overflow-x: auto;
}
.statement-tabs__list button {
  min-width: 94px;
  border: 0;
  border-radius: 3px;
  padding: 8px 12px;
  color: var(--raven-muted);
  background: transparent;
  font: inherit;
  font-size: 10px;
  cursor: pointer;
}
.statement-tabs__list button[data-selected] {
  color: #fff;
  background: #171717;
}
.statement-tabs__indicator {
  display: none;
}
.statement-tabs__content {
  outline: none;
}
.statement-section {
  border-top: 1px solid var(--raven-border);
  margin-top: 34px;
  padding-top: 24px;
}
.statement-identity dl {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 1px;
  margin: 18px 0 0;
  background: var(--raven-border);
}
.statement-identity dl > div {
  min-height: 76px;
  display: grid;
  align-content: center;
  gap: 7px;
  padding: 12px;
  background: #000;
}
.statement-identity dt,
.statement-identity dd {
  font-size: 10px;
}
.statement-identity dt {
  color: var(--raven-faint);
}
.statement-identity dd {
  margin: 0;
  overflow-wrap: anywhere;
}
.issue-row {
  min-height: 60px;
  display: grid;
  grid-template-columns: 20px minmax(180px, 1fr) auto minmax(260px, auto);
  align-items: center;
  gap: 10px;
  border-bottom: 1px solid var(--raven-border);
}
.issue-row strong,
.issue-row small,
.statement-row strong,
.statement-row small,
.statement-component strong,
.statement-component small,
.candidate-row strong,
.candidate-row small,
.proposal-row strong,
.proposal-row small,
.history-row strong,
.history-row small {
  display: block;
}
.issue-row small,
.statement-row small,
.statement-component small,
.candidate-row small,
.proposal-row small,
.history-row small {
  margin-top: 4px;
  color: var(--raven-muted);
  font-size: 9px;
}
.inline-action {
  display: flex;
  gap: 8px;
  min-width: 0;
}
input,
select,
textarea {
  min-width: 0;
  border: 1px solid var(--raven-border);
  border-radius: 4px;
  padding: 8px 9px;
  color: #fff;
  background: #050505;
  font: inherit;
  font-size: 10px;
}
textarea {
  resize: vertical;
}
.source-row-group {
  border-bottom: 1px solid var(--raven-border);
}
.statement-row,
.statement-component {
  display: grid;
  align-items: center;
  gap: 12px;
}
.statement-row {
  grid-template-columns: 34px minmax(0, 1fr) auto;
  min-height: 68px;
}
.statement-row > span:first-child {
  color: var(--raven-faint);
  font-size: 9px;
}
.statement-row strong {
  font-size: 11px;
}
.statement-component {
  grid-template-columns: 18px minmax(0, 1fr) auto 72px;
  min-height: 52px;
  border-left: 1px solid var(--raven-border);
  margin-left: 46px;
  padding: 6px 12px;
  background: #050505;
}
.statement-component strong,
.statement-component b,
.statement-component code {
  font-size: 10px;
}
.statement-component code {
  color: var(--raven-muted);
  text-align: right;
}
.source-replacement summary {
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: pointer;
  list-style: none;
  font-size: 11px;
}
.source-replacement summary span {
  display: inline-flex;
  align-items: center;
  gap: 8px;
}
.source-replacement > p {
  color: var(--raven-muted);
  font-size: 10px;
}
.guarded-form {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
  margin-top: 18px;
}
.guarded-form label,
.reconciliation-actions label,
.supersession-reason {
  display: grid;
  gap: 6px;
  color: var(--raven-muted);
  font-size: 9px;
}
.guarded-form label:last-of-type {
  grid-column: 1 / -1;
}
.guarded-form button {
  justify-self: start;
}
.section-heading-with-actions {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 18px;
}
.section-actions,
.reconciliation-actions {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}
.section-note {
  margin-top: 10px;
}
.resolution-row {
  display: grid;
  grid-template-columns: 24px minmax(220px, 1fr) auto auto;
  align-items: center;
  gap: 12px;
  border-bottom: 1px solid var(--raven-border);
  padding: 14px 0;
}
.resolution-select {
  display: grid;
  place-items: center;
}
.resolution-select input {
  width: 14px;
  height: 14px;
  padding: 0;
}
.resolution-row > span:nth-child(2) strong {
  font-size: 11px;
}
.resolution-row > span:nth-child(2) small {
  display: block;
  margin-top: 4px;
  color: var(--raven-muted);
  font-size: 9px;
}
.status-chip {
  padding: 5px 7px;
  white-space: nowrap;
}
.status-chip[data-disposition="pending"],
.status-chip[data-disposition="proposed"] {
  color: #e2b84b;
  border-color: #8d6a19;
}
.resolution-match,
.proposal-row {
  grid-column: 2 / -1;
  display: flex;
  align-items: center;
  gap: 8px;
  border-top: 1px dashed var(--raven-border);
  padding-top: 10px;
}
.resolution-match > span,
.proposal-row > span {
  flex: 1;
  color: var(--raven-muted);
  font-size: 9px;
}
.proposal-row input {
  width: min(280px, 30vw);
}
.candidate-row {
  display: grid;
  grid-template-columns: minmax(220px, 1fr) minmax(200px, auto) 54px auto;
  align-items: center;
  gap: 14px;
  border-bottom: 1px solid var(--raven-border);
  padding: 14px 0;
}
.candidate-row b {
  font-size: 11px;
}
.confidence {
  color: var(--raven-accent);
  font-size: 10px;
}
.supersession-reason {
  margin-top: 16px;
  max-width: 520px;
}
.empty-state {
  border-block: 1px solid var(--raven-border);
  margin-top: 18px;
  padding: 22px 0;
  color: var(--raven-muted);
  font-size: 11px;
}
.equation-line {
  display: grid;
  grid-template-columns:
    minmax(130px, 1fr) auto minmax(130px, 1fr) auto minmax(130px, 1fr)
    auto minmax(130px, 1fr);
  align-items: center;
  gap: 14px;
  margin-top: 20px;
  border-block: 1px solid var(--raven-border);
  padding: 20px 0;
}
.equation-line span {
  display: grid;
  gap: 6px;
}
.equation-line > b {
  color: var(--raven-faint);
}
.reconciliation-counts {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  margin-top: 24px;
  border: 1px solid var(--raven-border);
}
.reconciliation-counts button {
  display: flex;
  justify-content: space-between;
  gap: 10px;
  min-height: 48px;
  border: 0;
  border-right: 1px solid var(--raven-border);
  border-bottom: 1px solid var(--raven-border);
  padding: 12px;
  color: var(--raven-muted);
  background: #000;
  font: inherit;
  font-size: 9px;
  cursor: pointer;
}
.reconciliation-counts strong {
  color: #fff;
  font-size: 12px;
}
.reconciliation-gates {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  margin: 18px 0;
}
.reconciliation-gates span {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  border: 1px solid var(--raven-border);
  border-radius: 4px;
  padding: 6px 8px;
  color: var(--raven-danger);
  font-size: 9px;
}
.reconciliation-gates span[data-pass="true"] {
  color: var(--raven-accent);
}
.calculation-hash {
  color: var(--raven-muted);
  font-size: 9px;
}
.reconciliation-drilldown {
  margin-top: 22px;
  border-top: 1px solid var(--raven-border);
}
.reconciliation-drilldown header,
.reconciliation-drilldown > div {
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-height: 44px;
  border-bottom: 1px solid var(--raven-border);
  font-size: 10px;
}
.history-row {
  display: grid;
  grid-template-columns: 18px minmax(200px, 1fr) auto minmax(140px, auto);
  align-items: center;
  gap: 12px;
  min-height: 58px;
  border-bottom: 1px solid var(--raven-border);
}
.history-row > span:nth-child(3),
.history-row code {
  color: var(--raven-muted);
  font-size: 9px;
  overflow-wrap: anywhere;
}
.operation-row {
  grid-template-columns: 18px minmax(200px, 1fr) minmax(140px, auto);
}
.statement-detail__status {
  margin-top: 34px;
  border-block: 1px solid var(--raven-border);
  padding: 20px 0;
  color: var(--raven-muted);
  font-size: 11px;
}
.statement-detail__status.is-error {
  display: flex;
  justify-content: space-between;
  color: var(--raven-danger);
}
@media (max-width: 900px) {
  .statement-detail__summary,
  .statement-identity dl,
  .reconciliation-counts {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
  .guarded-form {
    grid-template-columns: 1fr 1fr;
  }
  .issue-row {
    grid-template-columns: 20px minmax(0, 1fr) auto;
  }
  .issue-row .inline-action {
    grid-column: 2 / -1;
  }
  .candidate-row {
    grid-template-columns: minmax(0, 1fr) auto;
  }
  .candidate-row > *:nth-child(n + 3) {
    justify-self: start;
  }
  .equation-line {
    grid-template-columns: 1fr auto 1fr;
  }
  .equation-line > *:nth-child(n + 4) {
    margin-top: 4px;
  }
}
@media (max-width: 560px) {
  .statement-detail {
    width: min(100% - 24px, 1420px);
    padding-top: 24px;
  }
  .statement-detail__header {
    align-items: flex-start;
    flex-direction: column;
  }
  .statement-detail__summary,
  .statement-identity dl,
  .reconciliation-counts,
  .guarded-form {
    grid-template-columns: 1fr;
  }
  .statement-detail__summary article {
    border-right: 0;
    border-bottom: 1px solid var(--raven-border);
  }
  .statement-tabs__list {
    width: 100%;
  }
  .statement-tabs__list button {
    min-width: 86px;
    flex: 1;
  }
  .statement-component {
    grid-template-columns: 18px minmax(0, 1fr) auto;
    margin-left: 18px;
  }
  .statement-component code {
    grid-column: 2 / -1;
    text-align: left;
  }
  .section-heading-with-actions {
    align-items: flex-start;
    flex-direction: column;
  }
  .resolution-row {
    grid-template-columns: 22px minmax(0, 1fr);
  }
  .resolution-row > b,
  .resolution-row > .status-chip {
    grid-column: 2;
    justify-self: start;
  }
  .resolution-match,
  .proposal-row {
    grid-column: 2;
    align-items: stretch;
    flex-direction: column;
  }
  .proposal-row input {
    width: 100%;
  }
  .candidate-row {
    grid-template-columns: 1fr;
  }
  .equation-line {
    grid-template-columns: 1fr;
  }
  .equation-line > b {
    display: none;
  }
  .history-row,
  .operation-row {
    grid-template-columns: 18px minmax(0, 1fr);
    padding: 10px 0;
  }
  .history-row > span:nth-child(3),
  .history-row code {
    grid-column: 2;
  }
  .inline-action {
    align-items: stretch;
    flex-direction: column;
  }
}
</style>
