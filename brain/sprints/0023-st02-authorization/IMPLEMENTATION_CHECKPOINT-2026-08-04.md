# ST-02 Provisional Matching And Exact Reconciliation Implementation Checkpoint

## Status

- Date: 2026-08-04
- Workline: `financial-mastery:past-historian:st-02:provisional-matching-exact-reconciliation`
- Outcome: implemented; external review required
- Scope: fictional ST-02 matching, materialization, reconciliation, and product parity

## Observed Implementation Facts

- Five canonical models add audited match linkage, deterministic component and Transaction claims, current reconciliation, and immutable reconciliation events.
- Candidate generation is deterministic and no-write. Confirmation links an existing manual Transaction to exact source evidence without creating a duplicate movement.
- Explicit materialization creates exactly one imported Transaction and one confirmed match; replay returns the same records.
- Informational components remain non-movements. Transfer candidates remain proposals and create no AccountTransfer.
- Active component and Transaction claims are acquired transactionally and translate concurrent races into stable Raven errors.
- Exact checked-minor-unit reconciliation supports attestation, automatic/manual append-only reopening, and later re-attestation.
- Source supersession is append-only and transfers source/period claims atomically; forced mid-transaction failure rolls back completely.
- Raven Studio, tRPC, and semantic MCP expose the full review loop with 28 Statement Truth operation pairs.

## Verification

- Canonical graph strict validation, spec generation, 28-model generation, import dry-run, and import into a disposable empty in-memory database passed.
- Raven Domain: `94/94`; Raven Surreal: `36/36`; Raven MCP: `5/5`; all focused typechecks passed.
- Raven Studio statement UI: `4/4`; cashflow intent regression: `3/3`; production build passed without a development server.
- ST-02 and ST-01 disposable live smokes passed; legacy renderer passed `2/2`.
- Data Atlas passed `9/9`, regenerated to 28 models, 108 direct references, four self-references, and ten runtime edges, then passed two stale checks.
- Strict Draft 2020-12 extraction-schema compilation and fictional-example validation passed after adding explicit conditional subschema types.
- The Studio production build passed; standalone Nuxt typecheck was blocked before source analysis by the inherited `vue-tsc`/TypeScript package-export mismatch. The user-managed Studio endpoint returned `502`, so browser viewport QA was not run and no development server was started.

## Boundaries

- No private statement, source path, Account record, financial amount, credential, or configured private database was inspected or changed.
- No management or tax meaning, Historian operation, private ingestion, ST-03, recurrence, bucket, Elgiz, Earn, or Workline 04 work was performed.
- No development server was started and no merge, commit, or push was performed.

## Durable Outcome

ST-02 is implemented and remains in review. External artifact acceptance is required before it can be marked done or any private statement pilot can begin.
