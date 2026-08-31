# Distillation - RAVEN-INGEST-0014

## Summary

Michael explicitly authorized the Generated Data Atlas as a bounded documentation/tooling workline. The main agent is implementing it in isolated branch `codex/generated-data-atlas` at `/Users/michaelpeters/Dev/mpd/projects/raven/raven-worktrees/generated-data-atlas`. The atlas must derive from canonical schema authority, expose direct record references and separately registered runtime relation-table edges, preserve human interpretation outside generated markers, and fail when committed generated content is stale.

The packet also supplies an external finding and a separate product-work prompt for one remaining Workline 03 defect. A paused schedule can create or re-expose due rows in the paused gap when later ended or cancelled, and Studio currently conflates future-term and lifecycle effective dates. That closeout is not part of the Data Atlas workline and was not executed here. Workline 03 remains in review; Workline 04 remains blocked and unstarted.

## Observed Facts

- `RAVEN-INGEST-0013` correctly preserved the four sources it received and explicitly recorded that the exact Data Atlas packet was missing.
- The missing human Data Atlas reference and exact workline prompt are now available locally and preserved in this ingest.
- The user has authorized the Data Atlas workline now.
- The user states that the main agent is implementing the workline in an isolated branch and worktree.
- The Data Atlas is bounded to documentation/tooling and must not change product schema, financial semantics, product code, or private data.
- Workline 03 remains in review and has a newly identified paused-to-terminal lifecycle defect requiring a separate bounded implementation closeout.
- Workline 04, Past Truth/Historian, Elgiz, and Earn remain unstarted, proposed, or later.

## Data Atlas Contract

The generated atlas should make the following inspectable from source authority:

- every canonical model and its identity expression;
- descriptions and source-authority status;
- required and optional direct `record<...>` references, including self-relations;
- Context, Observed, Meaning/Review, Accepted Future, Audit, Derived, and Business Reference truth classes;
- whole-graph and Past, Present, Future, and Business/Earn Mermaid views;
- an explicit registry of the eight current runtime import-traversal relation tables;
- deterministic generation and a stale-check command;
- human-maintained interpretation and proposed bridges outside generated markers.

The human draft is explanatory intent. `apps/schema/config/graph.mpdg`, supported by canonical parser/spec metadata and a reviewed runtime-edge registry, remains authoritative.

## Runtime-Only Relationships Named By The Packet

- `FinancialSpaceAccounts`
- `AccountStatementImports`
- `StatementImportRows`
- `StatementRowTransactions`
- `AccountTransactions`
- `TransactionMerchant`
- `TransactionCategory`
- `TransactionClarificationTasks`

These must be labeled as runtime relation-table edges rather than represented as graph-canonical direct references.

## Workline 03 Finding

The attached review and closeout prompt identify two linked problems:

1. A paused schedule that is later ended or cancelled can generate new due occurrences after `pausedOn` or make previously materialized paused-gap due rows visible again.
2. The Studio schedule drawer shares one effective-date field between future term changes and lifecycle commands, allowing historical `termsEffectiveFrom` to become an unsafe retroactive lifecycle default.

The required invariant is that pause preserves accepted dates through `pausedOn`, creates no new dates after it, and later resume, end, or cancel never revives the paused gap. Effective lifecycle truth must distinguish configured status, status effective at explicit `asOf` in the schedule timezone, and the next pending transition.

This is durable risk/context, not implementation evidence. Workline 03 cannot be marked done from this ingest.

## Identity Signals

No Raven identity change. The packet reinforces Raven as a financial operating system whose views and agent operations must be explainable as projections over deliberate financial models and relationships.

## Tenets Reinforced

- Generated documentation must follow schema authority rather than infer financial meaning from UI code.
- Direct references, relation-table edges, derived views, and proposed bridges are different relationship classes and must remain visibly distinct.
- Human interpretation must survive deterministic regeneration.
- Parallel work is acceptable only with bounded scope and isolated authority surfaces.
- Paused future obligations cannot silently reappear because lifecycle status changes.

## Vision Delta

The Data Atlas moves from a conceptual opportunity to an authorized repository capability: a deterministic map of what Raven knows, how records are identified, how truth classes connect, and where bridges remain proposed.

## Accepted Execution Decision

- Authorize the bounded Generated Data Atlas documentation/tooling workline and leave its output in review.

This is workline execution authorization, not final artifact acceptance and not acceptance of the broad parallel-lane operating model.

## Decisions Still Requiring Confirmation

- Whether and when to accept the final generated atlas after implementation review.
- Whether runtime relation-table edges should later become explicit graph canon or remain reproducible secondary indexes.
- Whether to execute and accept the separate Workline 03 paused-lifecycle closeout.
- Whether to authorize the Past Truth/Historian and Elgiz worklines.
- Whether the broad July parallel-lane plan should become accepted sequencing.

## Open Loops

- Complete and review the generated Data Atlas without schema or semantic changes.
- Execute and verify the separate Workline 03 paused-lifecycle closeout before Workline 04.
- Keep Workline 04 unstarted until Workline 03 closes.
- Keep Past Truth/Historian, Elgiz, and Earn out of execution until separately authorized.

## Risks

- A generator that parses only explicit MPDG edges can omit Raven's meaningful direct `record<...>` references.
- A generator that rewrites the whole document can destroy human interpretation and proposed-bridge context.
- Runtime traversal edges can be mistaken for schema-canonical relationships.
- The paused-to-terminal Workline 03 defect can revive obligations that should remain non-due.
- Parallel work can collide if it escapes the supplied isolated worktree boundary.

## Opportunities

- Make Raven's model and relationship authority inspectable to Michael, reviewers, and agents.
- Detect stale architecture documentation deterministically in repository checks.
- Use the atlas to expose missing bridges without silently implementing them.
- Establish a repeatable generated-plus-human documentation pattern for other Raven architecture views.

## Repeated Themes

- Source authority before presentation.
- Financial truth classes remain explicit.
- Generated output must be deterministic and stale-checked.
- Workline authorization and final acceptance are separate gates.
- Parallel lanes require bounded isolation.

## Orbit Sync Candidates

- Record the Generated Data Atlas workline as active and leave it in review on completion.
- Preserve the exact branch/worktree and no-semantic-change boundary in Workboard status.
- Keep Workline 03 in review with the paused-lifecycle closeout as its remaining gate.
- Keep Workline 04 unstarted and Past/Elgiz/Earn outside execution.
- Do not promote the broad parallel-lane plan to accepted sequencing.

## Routine Details Intentionally Excluded

- No implementation file list or test result is asserted before the main workline completes.
- No private database state or financial record content is summarized.
- No speculative proposed bridge is promoted to schema canon.

