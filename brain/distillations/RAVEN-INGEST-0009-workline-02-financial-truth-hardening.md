# Distillation - RAVEN-INGEST-0009 - Workline 02 Acceptance Review And Financial Truth Hardening

## Source

- Raw source directory: `brain/source-material/external-review/RAVEN-INGEST-0009-workline-02-financial-truth-hardening/`
- Ingest record: `brain/sprints/0009-workline-02-financial-truth-hardening/INGEST_RECORD-RAVEN-INGEST-0009.md`
- Source date: 2026-07-11
- Ingest date: 2026-07-12
- Mode: external-validation / pre-work-primer
- Source kind: linked external AI acceptance review and authoritative correction prompt

## Executive Distillation

The external review finds that Workline 02 is genuinely implemented as a working manual observed-money vertical rather than a documentation-only response. It accepts exact manual expense and income, atomic tracked-account transfers, the account-detail Studio experience, and tRPC/MCP parity. It does not accept imported and legacy transaction truth or scoped month calculations as financially safe yet. Workline 02 therefore remains in review, and Workline 03 must not start.

The linked execution prompt is the authoritative instruction for the main agent. It authorizes a bounded correction pass that preserves the accepted manual product loop while hardening canonical transaction authority, statement imports, migration safety, account-scope isolation, Johannesburg-local month-to-date calculations, concurrent command idempotency, and one small account-directory refresh issue. Neither review source proves that these corrections are already present. The reviewer also could not independently rerun tests or the Nuxt production build because the AI-safe archive correctly excluded installed dependencies.

## Externally Accepted Areas

- Manual expense and income commands use exact positive minor units and coherent expense/outflow or income/inflow semantics.
- One tracked-account transfer atomically creates a FinancialOperation, AccountTransfer aggregate, source outflow leg, and target inflow leg.
- Transfer legs remain excluded from income, outflow, and net.
- Recording observed movement does not create, advance, or silently mutate confirmed balance evidence.
- The account-detail ledger route, month controls, filters, pagination, keyboard navigation, transaction details, category selection, dialogs, and command-palette actions are present.
- Shared Studio/tRPC and semantic MCP operation parity is present.

These are external-review findings, not independently rerun verification by this Brainkeeper.

## Required Hardening

### 1. Canonical Authority And Import Safety

- A canonical transaction tuple is authoritative only when its exact money, kind/flow, financial date, entry source, and recording instant are complete, valid, and semantically coherent.
- Optional migration-era canonical fields must not receive economically meaningful generated defaults. A generated default or sentinel cannot establish income, expense, inflow, or outflow truth.
- Complete coherent canonical values outrank conflicting legacy fields. Partial or defaulted canonical fields do not independently outrank coherent source evidence.
- The statement renderer must explicitly emit exact canonical debit and credit semantics, imported provenance, and a reliable recording instant.
- Imported transfers without source-proven flow remain unresolved with `LEGACY_TRANSFER_AMBIGUOUS` rather than inheriting a default direction.
- Missing, malformed, or contradictory legacy direction remains visible as unresolved/invalid evidence and is excluded from totals; it must never silently become expense.

### 2. Partial Canonical Migration Protection

- Audit canonical evidence field by field.
- Migration apply may fill only genuinely missing or explicitly recognized sentinel fields.
- A meaningful populated canonical value that conflicts with a legacy-derived proposal increments an aggregate conflict count and receives no write.
- Apply must never overwrite authoritative exact money, kind, flow, entry source, financial date, or recording time.
- Generated defaults must remain distinguishable from authoritative values so legacy credits are not falsely treated as conflicts.
- Audit remains no-write by default; ambiguous and unresolved rows remain unapplied; reports remain aggregate-only.

### 3. Account-Scope Isolation

- `accountIds === undefined` means intentionally unscoped.
- `accountIds: []` means no resolved accounts and must return no rows without issuing an unscoped transaction query.
- An unmatched Financial Space must return zero scoped movement, never all-account totals.
- Explicit composite account references must exist and match the requested currency. A mismatch returns stable `CURRENCY_MISMATCH` without a transaction query.
- Fake and memory repositories must share production empty-scope semantics so tests cannot hide broadening defects.

### 4. Month-To-Date Financial Truth

- Normalize and preserve Transaction status sufficiently for semantic reads.
- Ignored evidence remains inspectable but is excluded from totals, ordinary movement counts, and uncategorized counts.
- Unresolved/invalid rows are excluded and represented through precise quality warnings.
- Derive the financial cutoff date from `asOf` using explicit `Africa/Johannesburg` configuration, not the host timezone.
- Current-month totals stop at the cutoff date; completed past months include eligible month rows; future months return zero observed movement.
- Transfers remain excluded and calculations remain checked integer minor-unit arithmetic.
- The Studio account-detail progress query must wait for the account and use its actual currency rather than a temporary fallback.

### 5. Concurrent Idempotency

- Sequential replay is accepted, but concurrent first writes need stable handling.
- After a duplicate-looking deterministic write failure, re-read FinancialOperation.
- Matching command and request hash returns the original applied entities as replay.
- A different request hash returns `IDEMPOTENCY_CONFLICT`.
- No matching operation preserves or maps the genuine database failure; it must not claim replay.
- Atomicity and `CREATE ONLY` remain intact, with no duplicate facts, orphan legs, or partial operations.

### 6. Shared Account Refresh

- After account creation, the layout account directory, command palette, and global movement dialogs should refresh through the existing shared data-version mechanism without a full browser reload.
- This is a coherence correction, not a Studio redesign.

## Required Regression Evidence

- Fictional rendered/imported credit and debit become exact income/inflow and expense/outflow respectively.
- A transfer without proven flow remains unresolved, and malformed or missing direction never becomes ordinary expense.
- Generated defaults cannot establish canonical authority.
- Partial exact-money and kind/flow conflicts receive no migration write; compatible partial rows fill missing fields only.
- Empty account arrays and unmatched spaces return no movement; explicit currency mismatch returns `CURRENCY_MISMATCH`; intentional unscoped behavior remains available only when scope is omitted.
- Fixed-clock tests cover Johannesburg midnight, ignored rows, post-`asOf` dates, current/past/future months, and transfer exclusion.
- Concurrent identical commands resolve as stable replay or stable domain error without duplicate facts.
- Use fictional fixtures only. Do not run a private migration audit/apply or inspect private financial data.

## Decisions

- No new Brain decision is created by this sidecar.
- The source packet authoritatively sets the bounded hardening execution contract, but final Workline 02 acceptance remains Michael's gate after implementation and verification.

## Open Loops For Main Agent

- Implement and verify all six bounded corrections without broadening into Workline 03 or another product vertical.
- Determine whether schema canon must change; if so, begin in `graph.mpdg`, validate, regenerate, and inspect generated authority rather than hand-editing generated files.
- Update the Workline 02 implementation note with the final canonical-authority, import, migration, scope, month-to-date, and race behavior.
- Run the required focused tests, build, fictional import regression, disposable live smoke where practical, archive safety, secret scan, and Brain health check.
- After verification, update active Brain and Orbit state honestly while leaving Workline 02 in review for Michael's final acceptance.
- Do not start Workline 03.

## Risks Preserved From The Packet

- Generated semantic defaults can turn imported income into apparent spending or invent transfer direction.
- Unknown legacy direction can be silently misrepresented as ordinary expense.
- Partial canonical migration can overwrite authoritative transaction truth.
- Empty explicit account scope can broaden into all-account totals.
- Ignored, future-dated, or post-`asOf` rows can distort month progress when status and timezone are not enforced.
- Concurrent first-write races can leak unstable persistence errors despite sequential idempotency passing.
- Existing tests can pass while missing the real statement renderer, empty scope, partial migration conflict, fixed-clock cutoff, and concurrent race paths.

## Repeated Themes

- Unknown financial semantics must remain visible and excluded rather than guessed.
- Canonical authority requires a complete, coherent evidence tuple, not merely populated fields.
- Explicitly empty scope must fail closed and never become broad access.
- Financial dates and month cutoffs require an explicit financial timezone.
- Idempotency is a concurrency property as well as a sequential retry property.
- Product implementation, external acceptance, and final user acceptance are separate gates.

## Orbit Sync Candidates For Main Agent

- Keep the existing Workline 02 workline in `review` while the bounded hardening pass is implemented and verified.
- Record phase transitions and final evidence without marking the workline done.
- Keep Workline 03 unopened and unstarted.
- No Orbit or `.orbit` state was inspected or changed by this Brainkeeper sidecar.
