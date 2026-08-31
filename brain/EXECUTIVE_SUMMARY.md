# Executive Summary

Raven is a private, local-first financial operating system for total financial truth, present-day control, and future financial design. Financial Mastery is the Orbit planning and execution project around it.

Raven's conceptual architecture is:

- Past / Truth: observed accounts, statements, transactions, categories, transfers, and historical patterns.
- Present / Command: balances, obligations, recurring costs, base monthly cost, coverage gaps, budgets, debts, and required earning rates.
- Future / Design: buckets, rules, goals, scenarios, projections, and strategy.

Its product layers are Facts, Meaning, Control, and Guidance. Observed money, accepted future commitments, and simulations must never be mixed.

`apps/raven-studio` is the primary clean UX rebuild. It prioritizes speed, density, legibility, and robust workflows. `apps/raven` remains a behavioral/query reference. Raven is headless-first: Studio, semantic MCP tools, and future clients should share one typed application/domain command and query layer.

Account Balance Truth Workline 01 and Observed Transactions and Transfers Workline 02 are complete. Workline 02 includes exact manual movement, atomic tracked-account transfers, account detail/month progress, Studio/tRPC/MCP parity, scoped statement-import identities, immutable source replay, and aggregate-only migration reporting. Existing private records may require a later explicitly approved composite-ID migration; no private audit or migration was run.

Upcoming Cashflow Workline 03 is accepted and complete. Its final closeout prevents paused-gap obligations during paused-to-terminal transitions, applies one lifecycle-eligibility rule across reads and summaries, exposes configured/effective/pending lifecycle truth at explicit schedule-local `asOf`, and separates Studio term and lifecycle action intents. Workline 04 Today Coverage remains unstarted and must be sequenced separately.

The bounded Generated Data Atlas is externally accepted, integrated, and current. After the HP-04 schema extension it reports 30 models, 125 direct record references, six self-references, and ten registered runtime relation-table edges. `apps/schema/config/graph.mpdg` remains schema authority; the Atlas is its generated documentation projection plus reviewed runtime-edge and interpretation registries.

Tax & Transaction Meaning is a newly preserved proposal, not an accepted lane. Its durable direction is to layer versioned economic meaning, exact allocations, separate accounting/tax treatments, opaque evidence references, and authorized review states above immutable observed transactions. Ground Zero would retain restricted evidence and professional case authority; Orbit would retain work and deadlines. Tax Lane 00 contract/vocabulary work and all later implementation, audit, pilot, and professional-feedback lanes remain unstarted pending explicit approval.

Michael's current Past-lane direction is to make the existing Account Ledger and transaction pages operational without redesigning the Penpot-derived UI. Begin with one recent month across relevant accounts, record current movements provisionally, import statement evidence when available, match and reconcile without double counting, then expand backward month by month. Agents and MCP should support explainable review, categorization, fees, recurrence candidates, period queries, and tax proposals; tax persistence and authority remain blocked behind the separate unapproved contract.

`RAVEN-INGEST-0028` records external acceptance of HP-02, `RAVEN-INGEST-0029` preserves the exact HP-03 governing contract, and `RAVEN-INGEST-0030` records HP-03 external acceptance plus fictional-only HP-04 authorization. `RAVEN-INGEST-0031` records external acceptance of the HP-04 fictional foundation, the separate HP-04A selected-source closeout authorization, and direct authorization of Financial Read Analytics RA-00. HP-04A is not being executed by RA-00 and retains its own private permission gates. RA-00 is a bounded read-only vertical for exact per-currency, transfer-excluding, authority-separated period, category, merchant, fee, trend, uncategorized, and data-quality reads across Domain, Surreal repository, tRPC, MCP, and minimal Studio. `RAVEN-INGEST-0032` records external acceptance of that architecture and six integrity findings. Those findings are implemented and current-main integration is externally accepted. `RAVEN-INGEST-0033` accepts the default `active_ledger` analytics and authorizes RA-00B. RA-00B is now implemented in current main: optional legacy-inclusive reads derive immutable reverse canonical-match history after the active Transaction pointer is cleared, while default contracts remain unchanged. The final artifact remains in external review.

`RAVEN-INGEST-0034` preserves an urgent pre-work proposal for a private emergency statement reconstruction lane. `RAVEN-INGEST-0035` preserves the byte-identical replacement and Michael's governing correction: Phase C must use an owner-only, rebuildable, filesystem-native deterministic JSON/NDJSON index with bounded local query/report commands, no second database, no new schema model, and no canonical financial writes. Recovered source evidence may be inventoried, deduplicated, previewed, and queried provisionally, but it cannot become active ledger truth or accepted management, tax, accounting, or legal meaning automatically. Execution, private access, verified inventory, and canonical activation are not established by either ingest.

Orbit remains planning/control, the repo remains implementation truth, and `brain/` remains portable narrative memory. Private statements, account records, credentials, mediation material, mailbox exports, and dossiers do not belong in Brain.
