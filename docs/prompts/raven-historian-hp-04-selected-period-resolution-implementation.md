---
status: ready
owner: Raven
last_reviewed: 2026-08-10
supersedes: []
superseded_by: []
---

# Raven Historian HP-04 - Selected-Period Resolution Implementation

```text
orbit-workline

Execute Raven Historian HP-04 as one bounded compatibility-bridge implementation
workline only after the six HP-03 decisions are explicitly accepted.

Goal

Implement and verify the selected-source legacy-authority bridge defined by
docs/architecture/raven-historian-hp-03-legacy-overlap-contract.md. Use fictional
fixtures and an isolated disposable database for all product verification. After the
implementation artifact is externally accepted, a private selected-source preview may
be rerun. A private apply remains behind a separate exact Michael approval and must
remain blocked while any transfer-review or ambiguous/conflicting disposition exists.

Accepted context

- ST-01, ST-02, and HP-00 through HP-02 are accepted and done.
- HP-03 staged and validated one source, completed a private exact crosswalk, and
  performed zero financial database writes.
- HP-03 recommends Strategy D at the current evidence state.
- The private crosswalk contains exact adoption candidates, transfer-review items,
  informational components, and one conflict. Its details remain outside Git, Brain,
  Orbit prose, fixtures, logs, screenshots, and AI-safe archives.
- No current canonical source commit is authorized.

Hard privacy boundary

- Product implementation and tests use fictional data only.
- Do not copy private Account, period, source, amount, balance, description, filename,
  path, hash, record identity, counterparty, Category, Merchant, note, or crosswalk row
  into Git, fixtures, Brain, Orbit prose, screenshots, logs, or review archives.
- The owner-only HP-03 artifact may be reopened only during the explicitly separated
  local private preview/apply phases.
- Generic Surreal access remains diagnostic and read-only.
- Semantic Raven MCP is the only agent-facing private apply surface.

Phase A - establish accepted architecture

1. Confirm external acceptance of all six HP-03 decisions before editing schema or
   product code.
2. Create or resume the HP-04 Orbit Workline and keep it separate from tax, management
   meaning, ST-03, Today, Elgiz, Earn, and bulk Historian work.
3. Record current root and nested-worktree status. Preserve unrelated changes.
4. Validate the canonical MPDG and regenerate through the existing schema workflow.
5. Do not use the private configured database for implementation tests.

Phase B - canonical compatibility records

Add the smallest accepted schema delta:

1. `StatementLegacyResolution`
   - immutable selected-source plan/apply or explicit reversal record;
   - exact Account, legacy import, canonical import, predecessor/reversal reference,
     strategy, source identity, canonical preview identity, legacy evidence identity,
     Account-context identity, crosswalk hash, expected revision/claim hash, operation,
     actor/channel, and timestamps;
   - deterministic composite identity and append-only semantics.
2. `StatementLegacyResolutionItem`
   - immutable child of one resolution;
   - one approved compatibility class and active-ledger outcome;
   - optional exact canonical component, legacy row, and legacy Transaction references;
   - exact item evidence hash and operation reference;
   - no copied source body or mutable meaning fields.

Update generated schema/runtime artifacts through the canonical schema pipeline. Do
not hand-invent parallel CRUD routers or bypass generated contracts.

Phase C - pure Domain planner

Implement a deterministic planner that:

- requires one Account, one staged source/preview, and one explicit legacy import;
- verifies ZAR, profile/version, complete coverage, exact canonical row order, exact
  signed money, source dates, Account context, and source/assistance/extraction hashes;
- reads exact legacy import/row/Transaction provenance and active authority state;
- never uses fuzzy text similarity, amount tolerance, guessed dates, Category,
  Merchant, notes, management meaning, or tax meaning as identity;
- enforces the accepted grouped-component same-row/same-date/exact-sum rule;
- detects plausible opposite tracked-Account movements as review-only;
- assigns every canonical movement, informational component, and relevant legacy
  Transaction exactly one of the seven HP-03 compatibility classes;
- returns a deterministic crosswalk hash, aggregate-safe class counts, expected
  revisions/claims, and Strategy A-E eligibility;
- permits apply only when the class set and explicit operator dispositions prove one
  active movement per canonical component with no unresolved transfer or conflict.

Add stable Raven errors for stale source, Account-context drift, legacy-evidence drift,
crosswalk drift, unsupported strategy, unresolved transfer, unresolved conflict,
active-claim conflict, duplicate active movement, replay conflict, and rollback
ineligibility.

Phase D - no-write semantic preview

Add `preview_legacy_statement_resolution` across Domain, Surreal read repository,
tRPC, semantic MCP, and Studio.

The operation must:

- perform no repository commit and create no `FinancialOperation`;
- reopen and validate the staged source using the accepted ST-01 pipeline;
- derive all evidence server-side rather than trusting client-provided match reasons;
- produce a private exact projection and an aggregate-safe projection;
- return the deterministic crosswalk and expected-revision hashes;
- redact source paths and never return source bytes;
- remain exact parity across Studio, tRPC, and MCP.

Do not add a force, tolerate, override, bulk, infer-transfer, or skip-conflict option.

Phase E - guarded apply and reversal

Add `apply_legacy_statement_resolution` as one idempotent semantic command. Its input
contains only the exact no-write preview identity, expected evidence/revision hashes,
approved strategy, explicit disposition decisions, actor/channel, and idempotency key.

In one database transaction it must:

1. replay by operation/request hash before private vault access where the accepted
   operation contract permits it;
2. reopen and revalidate source, extraction, Account context, legacy evidence,
   crosswalk, claims, and expected revisions;
3. stop unless every transfer and conflict has an explicit accepted resolution and the
   active-ledger uniqueness proof is complete;
4. commit the canonical replacement source and immutable rows/components;
5. create one immutable compatibility resolution and its exact item set;
6. create canonical confirmed matches and active component/Transaction claims for
   approved exact legacy Transaction adoptions;
7. materialize only an explicitly reviewed unmatched canonical movement when the
   normal ST-02 materialization invariants pass;
8. keep legacy-only/conflicting Transactions immutable and historical-only;
9. calculate one exact reconciliation revision;
10. create one `FinancialOperation` receipt;
11. commit everything or roll back everything.

The current HP-03 aggregate result contains no materialization requirement. Do not
invent one during implementation.

Implement an append-only guarded reversal path. Reversal creates a new resolution and
operation, releases only the authority created by the exact target operation, restores
the previous active projection, recalculates reconciliation, and preserves all source,
row, Transaction, match, claim, resolution, and operation history. It must not delete
or rewrite monetary evidence.

Phase F - Studio, tRPC, and MCP parity

- Preserve the existing Raven Studio visual design.
- Add only the compatibility review states required for exact class inspection,
  transfer/conflict disposition, stale-preview recovery, and separately confirmed
  apply/reversal intent.
- Reuse one retry-stable idempotency key for one reviewed command intent.
- Expose exact tRPC/MCP schemas, operation names, write classifications, outputs, and
  stable errors.
- Update the machine-readable Statement Truth operation catalog and parity tests.
- Keep generic Surreal MCP read-only and outside the apply path.

Phase G - fictional verification

Use fictional fixtures covering at least:

1. all-exact adoption;
2. exact grouped-component adoption within one row/date;
3. unmatched canonical materialization under explicit approval;
4. legacy-only historical evidence;
5. informational-only components;
6. transfer candidate blocking and explicit reviewed release;
7. ambiguous/conflicting evidence blocking;
8. same amount on different dates and same date with different amount;
9. duplicate candidates and multiple active-authority attempts;
10. changed source, extraction assistance, Account context, legacy row, Transaction,
    Category/Merchant meaning, and claim/reconciliation revisions;
11. concurrent apply attempts, exact replay, conflicting replay, and lost response;
12. rollback, rollback replay, stale rollback, and rollback after later authority;
13. zero active duplicate movements before/after apply and reversal;
14. exact reconciliation and attestation remaining blocked until complete resolution;
15. archive, log, path-redaction, and aggregate-output safety.

Run focused Domain, Surreal, MCP, Studio, operation-catalog, schema, Atlas, archive
safety, Brain health, formatting, diff, and disposable live-database checks. Run Atlas
stale checking twice. Clean up all fictional records and stop every database process
started by the workline. Do not start a development server.

Phase H - external implementation acceptance

Produce an AI-safe archive and leave HP-04 in Orbit review. Do not open the private
crosswalk or run the private configured database during packaging. External acceptance
of the implementation is required before Phase I.

Phase I - separately approved private re-preview

Only after implementation acceptance:

1. rerun readiness and target/selection fingerprint checks;
2. verify the owner-only HP-03 evidence and source have not changed;
3. run `preview_legacy_statement_resolution` through semantic Raven MCP;
4. present the exact private result only in the controlled local operator session;
5. stop if any class is `transfer_review_required` or
   `ambiguous_or_conflicting`, if any evidence/revision changed, or if Strategy A/C
   eligibility is not proven.

Do not ask for apply approval while any stop condition remains.

Phase J - separate private apply approval

If and only if Phase I is fully eligible, ask Michael exactly:

"Do you approve applying this exact selected-source legacy resolution using the
reviewed crosswalk hash and expected revisions? This will atomically commit the
canonical source, create the approved compatibility records, matches and claims,
calculate reconciliation, and change active ledger authority for this source only. It
will not classify management or tax meaning, process another source, or run a bulk
migration."

Proceed only after an explicit affirmative response in the same controlled session.
Run one semantic apply command, verify exact replay, reconciliation and aggregate
before/after evidence, then stop. Do not attest unless a separate accepted gate already
authorizes attestation and every ST-02 condition passes.

Current selected-source warning

The accepted HP-03 result is Strategy D with unresolved transfer and conflict classes.
Therefore HP-04 should normally stop after implementation and private re-preview. It
must not weaken the rules or reinterpret the private evidence merely to reach Phase J.

Completion response

Report only aggregate-safe facts:

- architecture decisions implemented;
- exact files and semantic operations added;
- fictional tests and results;
- whether private re-preview ran;
- aggregate class counts only if it ran;
- whether a private apply was eligible, explicitly approved, and executed;
- aggregate before/after invariance and operation counts;
- whether any source commit or active-ledger authority change occurred;
- whether first-pilot reconciliation/attestation remains blocked;
- archive path and checksum when packaging ran.

Never disclose private Account, period, source, value, balance, path, hash, record,
description, counterparty, Category, Merchant, note, or crosswalk detail.
```
