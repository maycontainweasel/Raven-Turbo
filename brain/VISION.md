# Vision

Raven is a private, local-first financial operating system that records financial truth, creates present-day control, and provides the rules and projections needed to design the future.

## Conceptual Time Model

- Past / Truth: immutable source evidence, accounts, imports, transactions, transfers, categories, merchants, and observed patterns.
- Present / Command: current balances, obligations, recurring costs, debts, budgets, coverage, earning requirements, and next actions.
- Future / Design: buckets, allocation rules, goals, scenarios, projections, and strategy.

## Product Layers

- Facts: immutable source and ledger data.
- Meaning: classification, merchant memory, category, recurrence, confidence, and tax meaning.
- Control: obligations, budgets, debts, buckets, rules, and reserve floors.
- Guidance: transparent alerts, explanations, opportunities, projections, and next actions.

Observed facts, accepted future commitments, and simulated money are separate records and concepts. One may inform another, but none may silently overwrite another.

## Product Surfaces

Raven Studio is the primary product UI. The Raven domain MCP is an equally important semantic operating surface. Both should use one shared application/domain layer over generated schema/runtime contracts. Generic Surreal MCP remains a diagnostic and maintenance tool.

The initial operational areas are Today, Ledger, Plan, Earn, and Review. Past / Present / Future remains the deeper conceptual model rather than a forced navigation structure.

## Near-Term Product Objective

Raven should answer, transparently and with freshness/provenance: what must be paid, what money is available, what is uncertain, what the next 30-day gap is, and what must be earned per workday and planned billable hour.

## Account Ledger Operating Centre

The Account Ledger is the proposed operational centre of the Past lane. A bank statement is authoritative evidence that money moved, not why it moved or how it should be treated. Raven should support provisional current-month observations, immutable statement evidence, explicit matching, and account-period reconciliation so every economic movement is counted exactly once. Management and Tax remain independent meaning lenses above the permanent source ledger.

The current Penpot-derived account and transaction design should be operationalized rather than replaced. Semantic MCP should expose the same review, reconciliation, classification, and reporting operations as Studio once those operations are contracted.

## Proposed Account Control Foundation

The proposed first complete product slice is a daily control loop: capture what is real, see the present position, anticipate what is due, and know the immediate earning requirement. Its initial routes are Today, Accounts, Account detail, and Upcoming. The exact financial invariants and model contract remain subject to explicit approval before implementation.

## Elgiz And Future Planning

The buckets/flow system remains a major Raven capability, but follows dependable present-control semantics. It should eventually provide deterministic allocation rules, targets, gates, shortage and overflow behavior, projections, an explanation ledger, and synchronized structured and visual representations.

The July 13 working plan proposes re-entering Elgiz through a versioned, exact-minor-unit pure allocation engine and compact table/tree before any canvas. Virtual allocation must remain structurally distinct from bank balances, observed transactions, and accepted cashflow settlement. This path remains proposed pending explicit approval.

## Proposed Coordinated Lanes

Raven may progress through Account Control, Data Atlas, Past/Historian, Elgiz, and later Earn lanes over one shared financial graph. The lanes may be clarified concurrently, but shared schema/domain/MCP code should be changed only in isolated worktrees with deliberate merge review. This operating model is working planning input from `RAVEN-INGEST-0013`, not yet an accepted sequence.

## Proposed Tax And Transaction Meaning

`RAVEN-INGEST-0017` proposes a separate Tax & Transaction Meaning lane above immutable observed transaction truth. Its intended progression is observed movement, versioned economic interpretation, exact allocations, separate management/accounting/tax dimensions, opaque evidence references, authorized review, and immutable filed or amended position where applicable.

The proposed system boundary keeps restricted evidence bodies, official documents, professional advice, compliance case state, deadlines, and filings in Ground Zero; keeps financial facts and structured meaning in Raven; and keeps tasks and execution in Orbit. Raven would support lawful compliance planning and workpaper preparation without becoming tax advice, a filing authority, or a repository for restricted evidence.

The charter, model names, authority vocabulary, Tax Lane 00-05 sequence, and private pilot remain proposed. Architecture approval must precede any schema or product implementation.

## Boundaries

- Raven owns financial facts, meaning, control, calculations, and scenarios.
- Orbit owns projects, tasks, time, sequencing, and execution.
- Private financial sources and credentials remain outside Brain and external share archives.
- Restricted Ground Zero evidence bodies remain outside Raven; approved opaque references may cross the boundary only after their metadata and authority contract are accepted.
