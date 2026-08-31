# Distillation - RAVEN-INGEST-0001 - Elgiz Buckets Lab Prototype

## Source

- Raw source: `brain/source-material/backfill/RAVEN-INGEST-0001-elgiz-buckets-lab.md`
- Backfill record: `brain/backfill/RAVEN-INGEST-0001.md`
- Source date: 2026-05-31
- Ingest date: 2026-05-31

## Executive Distillation

This source gives Raven its first deep product-memory anchor. Raven is not just a statement importer or budget app. It is a private, deeply personal financial operating system intended to establish cent-level truth about the past, support present control, and enable future planning through exploratory but serious financial models.

The major product lane in this source is a buckets/flow planning environment: money enters at the top, flows through configurable buckets, gates, expenses, savings containers, sub-buckets, and rules, and can be projected across time. The intended experience should feel visual, fast, interactive, and almost game-like while still being rigorous enough to drive real financial choices.

## Identity Signals

- Raven is a personal project first, not initially a public product.
- Raven is emotionally important to the user and carries family-significance in its name.
- Raven's purpose is to become a single source of truth for financial mastery.
- Raven should help the user understand every rand and cent coming in and going out before optimizing future decisions.
- The application is intended to be used over time during evenings and iterative personal work, not as a one-off dashboard.

## Vision Deltas

- Raven has three temporal facets:
  - Past: statement truth, account history, transaction classification, fee/category discovery, and observed financial reality.
  - Present: command/control over current obligations, buckets, expenses, and decisions.
  - Future: targets, projections, scenarios, and strategies.
- The buckets/flow system sits between present and future.
- Buckets represent planned allocation containers or micro-accounts, not necessarily physical bank accounts.
- Buckets may have children, rules, gates, target amounts, overflow behavior, priorities, and policies.
- The planning UI should support both a visual node/canvas view and a nested table/list view.
- Projections should answer questions like what a bucket will hold in 3, 6, or 12 months, and how long it will take to reach a target.
- Raven should eventually support versioned financial structures so old bucket models remain traceable when the strategy changes.

## Tenets Extracted

- Cent-level clarity comes before meaningful optimization.
- Observed money and planned money must stay conceptually separate even when they inform each other.
- Planning tools should be exploratory, fast, and tactile while remaining accurate and explainable.
- Financial automation should show why money moved, which rule applied, and what changed.
- The user wants purposeful money allocation, including security, debt pressure, long-term savings, expenses, and a deliberate life/fun component.

## Decisions

No new accepted repo-level decision is inferred solely from this source.

The response reports a prototype implementation, but the current ingest does not confirm that it should be merged as-is into the active Raven app. Treat the prototype as a strong design reference and candidate implementation source.

## Decisions Needing Confirmation

- Whether the `Elgiz Buckets Lab` name should remain, be renamed, or become an internal prototype label only.
- Whether the prototype route should be `/future/buckets`, another URL, or folded into a broader planning area.
- Whether the initial implementation should use hand-built pointer interactions, `interact.js`, or another lightweight approach.
- Which bucket types are canonical: income, savings, expense, gate, debt, reserve, buffer, goal, or another set.
- Whether bucket versioning should be part of the first persistence model or deferred.

## Open Loops

- Turn the prototype folder into an reviewed integration plan for the current repo without importing private financial source files.
- Define the first schema-backed model for bucket flows, allocation rules, projections, and versions.
- Decide how actual observed statements feed into bucket planning without mixing observed ledger truth with scenario projections.
- Define shortage behavior: when projected income is insufficient, which buckets take the hit and why.
- Define overflow behavior: when a target bucket is full, where excess money flows.
- Resolve tax ordering and savings ordering: before-tax, after-tax, pay-yourself-first, debt-first, or configurable layers.
- Decide how the node canvas and nested table view stay synchronized.

## Risks

- The prototype folder contains private financial source material and should not be treated as a safe bulk-ingest source.
- The source includes sensitive personal context; active Brain memory should preserve only project-relevant signals unless the user requests deeper personal-history capture.
- It would be easy to over-model the bucket engine before the interaction model is understood.
- The UI can become visually playful at the expense of trust unless explainability, arithmetic, and provenance are first-class.

## Opportunities

- Make Buckets Lab the first signature Raven planning surface.
- Use the buckets model to connect statement-derived reality to future strategy without letting projections rewrite reality.
- Build an explainability ledger for every allocation so Raven can answer "why did this money go there?"
- Use versioned bucket structures for month-to-month strategy changes and historical comparison.
- Support quick scenario tinkering with a table-grade report underneath the canvas.

## Repeated Themes

- Single source of truth.
- Past / present / future.
- Every cent accounted for.
- Money flow as circuits, gates, funnels, and trees.
- Buckets as micro-accounts.
- Visual canvas plus structured table.
- Playful exploration plus serious execution.
- Start front-end-first, then persist once the model is clearer.

## Orbit Sync Candidates

- Add a planning/clarification item for reviewing and integrating the Buckets Lab prototype.
- Add a sequencing item for a bucket-flow data model after the prototype is inspected.
- Add a design-context card for Raven's past/present/future product model.
- Add a design-context card for observed ledger vs planning/projection separation.

## Routine Items Intentionally Ignored

- Exact seed bucket names from the prototype are not treated as canonical.
- The reported localStorage implementation is not treated as a production architecture decision.
- The assistant's inability to run a full Nuxt build is not preserved as a durable project signal.
- Statement PDFs and financial export files present in the prototype folder were not ingested.
