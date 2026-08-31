# Distillation - RAVEN-INGEST-0027 - HP-01 Acceptance And HP-02 Authorization

## Source

- Packet: `brain/source-material/external-review/RAVEN-INGEST-0027-hp01-acceptance-and-hp02-authorization/`
- Manifest: `brain/source-material/external-review/RAVEN-INGEST-0027-hp01-acceptance-and-hp02-authorization/SOURCE_MANIFEST.md`
- Ingest record: `brain/sprints/0027-historian-hp01-schema-deployment/INGEST_RECORD-RAVEN-INGEST-0027.md`
- Source date: 2026-08-09
- Ingest date: 2026-08-09
- Mode: external-validation / pre-work-primer

## Source Roles And Authority

- SOURCE-01 is external acceptance evidence. It accepts HP-01 as complete based on an independently identified AI-safe archive, available archive-safety/renderer checks, source inspection, redacted deployment evidence, and the reported successful local run.
- SOURCE-02 is the exact governing HP-02 authorization and execution prompt. It authorizes a later controlled private operator session but does not prove that selection, compatibility classification, staging, preview, validation, or any write occurred.
- The user's current instruction is narrower than the embedded execution prompt: ingest both sources, record status, and do not execute HP-02, inspect private data or services, modify Orbit, or touch non-Brain files.

## Executive Distillation

HP-01 Canonical Schema Deployment is externally accepted and done. The external reviewer reports AI-safe archive SHA-256 `1b5a08eccfba7d92e830595a28b137e6060a3d1ec176f36a66885e2c05bb5486`, 2,805 entries, ZIP integrity passed, legacy renderer `2/2`, archive safety `5/5`, and no prohibited private or dependency-tree content. The review accepts the deployment as genuinely bounded: nine canonical Statement Truth tables, nine generated admin views, and 27 generated functions were deployed additively with recovery/fingerprint preconditions, destructive-plan rejection, empty-new-object proof, and invariant pre-existing aggregate counts. The reviewer explicitly did not inspect the private live database or cold recovery artifact, which is an appropriate privacy boundary rather than a hidden verification claim.

HP-02 Private Selection and Compatibility is now authorized under the exact governing prompt but remains unexecuted. It is a local private operator session, not a product-development or architecture workline. It must use the configured Raven database and semantic Raven MCP, pass readiness, privately select one recent complete closed ZAR period and the full interacting-Account set, obtain Michael's approval of that set before the selected-period compatibility pass, and classify the exact set as one of five prescribed compatibility outcomes. Only `clean_for_first_preview` permits a separate explicit request to stage one source and run write-free preview/validation. HP-02 must stop before source commit, matching, materialization, reconciliation, attestation, migration, classification, tax work, later lanes, or bulk backfill.

No HP-02 preflight, service check, database read, Account/period selection, compatibility pass, approval request, source staging, preview, validation, or write was performed during this ingest. The first private statement remains unopened.

## Authoritative Status

```text
ST-01 Source Preview and Atomic Commit         accepted and done
ST-02 Matching and Exact Reconciliation        accepted and done
HP-00 Controlled Pilot Readiness               accepted and done
HP-01 Canonical Schema Deployment              externally accepted and done
HP-02 Private Selection and Compatibility      authorized; not executed
First private source                           unopened and unstaged
First no-write preview                         not authorized in-session or run
First private write                            unauthorized and not performed
ST-03 / tax / buckets / Today / Earn           separate and unstarted
```

## Identity Signals

- No Raven product-identity change.
- Reinforces Raven as a private financial operating system that separates product capability, configured schema readiness, selected-period compatibility, source-preview approval, and financial mutation authority.
- The Historian is a local approval-gated operator over semantic Raven commands, not a raw-database writer, autonomous classifier, or tax authority.
- Brainkeeper remains a non-implementing memory sidecar; authorization capture is not execution.

## Tenets And Repeated Themes

- Acceptance evidence and governing authorization are different source roles.
- External acceptance may rely on redacted aggregate/control evidence while private database and recovery bodies remain appropriately unavailable.
- Configured schema readiness does not establish selected-period cleanliness.
- Missing canonical period claims do not prove that legacy authority is absent.
- Compatibility must be classified for one explicitly approved complete Account/period set before source action.
- Workline authorization does not authorize source staging; source staging and write-free preview require a later explicit in-session approval.
- A no-write preview authorizes no commit, matching, materialization, reconciliation, attestation, classification, tax meaning, or backfill.
- Private Account, period, amount, balance, description, filename, path, hash, record identity, and source content stay out of Brain, Orbit, Git, screenshots, fixtures, normal logs, and external artifacts.

## Accepted HP-01 Outcome

- HP-01 is externally accepted and complete.
- The externally reviewed archive identity is SHA-256 `1b5a08eccfba7d92e830595a28b137e6060a3d1ec176f36a66885e2c05bb5486` with 2,805 entries and passing ZIP integrity.
- The reviewer independently reran the available dependency-free renderer and archive-safety checks and inspected the deployment controls and redacted record.
- The accepted scope remains schema-only: nine canonical tables, nine generated views, and 27 generated functions, with no migration, replay, matching, reconciliation, classification, or private-source access.
- The private recovery artifact must be retained through HP-02 and acceptance of the first private pilot.

## Governing HP-02 Scope

1. Use only the configured Raven database and semantic Raven MCP; do not create a parallel database, environment, or replacement development server.
2. Rerun readiness and stop unless schema, semantic MCP, generic-MCP read-only posture, vault containment, Git exclusion, and archive exclusion pass.
3. Privately select one recent complete closed ZAR period and every tracked Account needed to explain transfers.
4. Obtain Michael's explicit approval of the proposed Account/period set before source-file reads or selected-period compatibility inspection.
5. Inspect only the minimum private metadata needed and classify the set as exactly one of `clean_for_first_preview`, `canonical_source_occupies_period`, `legacy_overlap_confirmed`, `overlap_unresolved`, or `incompatible_currency_source_or_account_set`.
6. Stop on every outcome except `clean_for_first_preview`; produce only an aggregate external handoff.
7. For a clean set, request the exact separate approval to stage one source and run write-free preview/validation.
8. After that approval only, stage one source privately, confirm the exact Account and versioned profile, run `preview_statement_import` and `validate_statement_preview`, review results privately, and stop.
9. Perform no write or later-lane operation and disclose externally only the prescribed aggregate statuses and blocker classes.

## Decisions

- `DEC-0020` accepts HP-01 as done and authorizes HP-02 as the next controlled local-private gate.
- HP-02 authorization is not source-staging authorization and is not pilot-write authorization.
- This Brainkeeper pass deliberately does not execute HP-02 under the user's explicit current-turn boundary.

## Open Loops

- `OL-0030` closes with HP-01 externally accepted and complete.
- `OL-0031` is authorized but unexecuted and tracks the private selection, compatibility classification, and possible separately approved no-write preview.
- The first private source, source commit, controlled pilot, legacy resolution, and bulk backfill remain unopened later gates.

## Risks

- Treating authorization as execution could create a false record of private selection or preview.
- Treating missing canonical period claims as cleanliness could duplicate legacy source authority.
- Incomplete interacting-Account coverage could hide transfers and corrupt period interpretation.
- Workline authorization could be conflated with source-staging or mutation approval.
- Private selection facts could leak into durable collaboration artifacts or normal logs.
- Starting replacement services could target the wrong environment or disturb the user-managed Studio process.

## Opportunities

- Use one tightly bounded selected-period classification to unlock the first real no-write preview without bulk migration.
- Preserve a reusable separation among readiness, compatibility, staging approval, preview validation, commit, and reconciliation.
- Keep external handoff useful through aggregate statuses while private facts remain local and owner-only.

## Orbit Sync Candidates

- Mark HP-01 accepted/done and HP-02 authorized/waiting for a separate controlled local operator run.
- Keep the private source and pilot unauthorized until the exact in-session gates are satisfied.
- Sync only aggregate status and no private selection or source details.

No Orbit or `.orbit` state was inspected or changed by this ingest.

## Attributed Verification And Uncertainty

Brainkeeper did not independently open the HP-01 review archive, rerun its checks, query the database, inspect the recovery artifact, recount private records, or validate service state. Archive identity, entry count, tests, deployment facts, and database invariance are attributed to SOURCE-01 and the existing HP-01 implementation checkpoint. SOURCE-01 explicitly states that the reviewer could not inspect the private live database or recovery artifact. HP-02 has not produced any readiness, selection, compatibility, staging, preview, validation, or write evidence.

## Routine Items Intentionally Excluded

- No HP-02 execution, private-data inspection, database/MCP/service access, source-vault action, statement preview, product/schema implementation, test run, archive generation, Orbit write, commit, merge, push, or non-Brain file change.
- No private target, recovery reference, Account, period, amount, balance, description, filename, path, source hash, record identifier, credential, statement row, or source body.
