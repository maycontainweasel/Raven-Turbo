---
status: ready
owner: Raven
last_reviewed: 2026-08-09
supersedes: []
superseded_by: []
---

# Raven Historian HP-02 - Private Selection And Compatibility Gate

```text
orbit-workline

Execute Raven Historian HP-02 as one controlled local private operator session after
HP-01 has been externally accepted.

Goal

Select one recent, complete, closed ZAR period and every interacting tracked Account,
determine privately whether legacy or canonical source authority already occupies the
selected account/period set, and authorize at most one first no-write statement preview
only after Michael explicitly approves the selection and compatibility result.

Context

- ST-01, ST-02, HP-00, and the accepted Statement Truth contract are complete.
- HP-01 deployed the accepted schema without changing financial records.
- Semantic Raven MCP exposes the exact approved 28-operation catalog.
- Generic Surreal access is diagnostic/read-only.
- The private vault/inbox is ready.
- Aggregate compatibility remains unresolved: 38 active legacy imports are not
  canonically mappable to periods, and 1,419 source-backed Transactions have no ST-02
  match authority.
- HP-01 does not authorize a private source by itself.

Private boundary

- Account names, account numbers, periods, balances, source filenames, descriptions,
  amounts, record identifiers, statement bodies, notes, and source paths may appear
  only inside this controlled local operator session when required.
- Do not place private facts in Git, Brain, Orbit prose, fixtures, screenshots, normal
  logs, external archives, or the completion response.
- Use semantic Raven MCP for every financial write. Generic Surreal remains read-only.
- Do not start a development server. Studio recovery remains user-managed.

Phase A - private inventory and selection

1. Rerun `pnpm historian:readiness` and stop unless schema, semantic MCP, generic MCP,
   and vault checks pass.
2. List only the minimum private Account metadata needed for selection inside the
   local session.
3. With Michael, select one recent complete closed ZAR period and every tracked Account
   that sent money to or received money from the primary Account during that period.
4. Confirm opening/closing balance availability and an accepted adapter or normalized
   extraction-assistance route for every proposed statement source.
5. Present the proposed account/period set privately and obtain explicit approval
   before inspecting compatibility or touching a source.

Phase B - selected-period compatibility

1. Use a bounded local read-only compatibility query for the approved Account and
   period only.
2. Determine whether canonical source claims, canonical period claims, legacy
   StatementImports, StatementRows, or source-backed Transactions may already represent
   the selected period.
3. Do not infer that a period is clean merely because legacy imports lack canonical
   period fields. Use the minimum private evidence needed to determine overlap.
4. Classify the selected period as exactly one of:
   - clean for first preview;
   - canonical source already occupies the period;
   - legacy overlap confirmed;
   - overlap unresolved;
   - incompatible currency/source/account set.
5. Do not migrate, rewrite, delete, merge, supersede, backfill, replay, match, or
   reconcile any existing record.
6. If overlap is confirmed or unresolved, stop and produce a private local resolution
   proposal. Do not stage a statement.

Phase C - explicit source authorization

If and only if the classification is `clean for first preview`, show Michael the
private selection and compatibility result and ask this exact approval question:

"Do you approve staging one source for this selected Account and closed ZAR period and
running a write-free Statement Truth preview? This will not commit, match, materialize,
reconcile, classify, or attest anything."

No source action is allowed without an explicit affirmative response in this session.

Phase D - first no-write preview

After explicit approval only:

1. Stage one original source inside the configured private vault. If normalized JSON
   assistance is required, preserve it as a separately hashed artifact.
2. Explicitly confirm the Account and exact versioned adapter/profile.
3. Run `preview_statement_import` and then `validate_statement_preview`.
4. Review coverage, source hashes, period, currency, balance convention, opening and
   closing balances, printed-row/component counts, and blocker classes privately.
5. Stop after the preview and validation result. Do not call
   `commit_statement_import` in HP-02.

Hard stops

- Any non-ZAR or FX requirement.
- Any incomplete/open period or missing interacting Account.
- Any unresolved legacy/canonical overlap.
- Any blocking preview issue, source mutation, path escape, MIME/size failure, account
  mismatch, currency mismatch, or adapter uncertainty.
- Any request to migrate, replay, commit, match, materialize, reconcile, classify, apply
  tax meaning, allocate buckets, or begin bulk backfill.

Handoff

Keep the detailed operator record private. Record only aggregate state in Brain and
Orbit: readiness pass/fail, selection completed yes/no, compatibility class, preview
authorized yes/no, preview completed yes/no, blocker classes, and next gate.

Leave HP-02 in review. Do not mark it done until the private operator result is reviewed.
Do not include private Account, period, amount, source, balance, or record details in an
AI-safe archive.
```
