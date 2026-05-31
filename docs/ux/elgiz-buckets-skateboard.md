# Elgiz Buckets Lab Skateboard Notes

## What Shipped In This Slice

This slice adds a front-end-only route at `/future/buckets` for exploring Raven's future-facing buckets system.

It is intentionally not a full persistence-backed engine yet. The purpose is to make the money-flow model tangible quickly:

- a drag-friendly node canvas
- editable bucket rules
- a nested table view
- a simple projection loop
- a ledger explaining why allocations moved
- browser-local draft persistence

## Product Shape

Raven remains the product. Elgiz is the internal flow-engine idea: the rules-driven part that routes money through buckets, gates, targets, caps, and overflows.

The Buckets Lab promise is:

> Before the month begins, I can route every rand on purpose and see the future effect immediately.

## Current Model

Each bucket has:

- name
- type
- parent
- priority
- allocation rule: percent, fixed, or remainder
- current amount
- optional target
- withdrawal policy
- optional overflow target
- optional gate

The source bucket receives the scenario inflow. Children are processed by priority. Fixed and percent allocations consume the parent amount first. Remainder buckets receive what is left.

## Current Gate Behavior

The prototype supports one simple gate shape:

> While bucket X is below amount Y, reroute Z% of this bucket's allocation to bucket T.

The starter scenario uses this to send half of Play/Oxygen to Emergency until Emergency reaches R90,000.

## Current Projection Behavior

For each simulated month:

1. Start with the scenario monthly inflow.
2. Route the inflow through the current bucket tree.
3. Add received amounts to balance-bearing buckets.
4. Stop allocations at target caps where a target exists.
5. Route overflow to the configured overflow bucket where present.
6. Record cumulative received amounts and first completion month.

This is enough for the skateboard, but not yet enough for debt interest, actual spending reconciliation, tax nuance, or versioned historical plans.

## UX Direction

The canvas is for strategy and imagination. The table is for confidence and precision. Both should always describe the same underlying bucket graph.

The intended future split is:

- Canvas: tactile, spatial planning
- Table: nested database-style review and editing
- Inspector: detailed bucket rules and policies
- Ledger: trust layer explaining the math

## Next Engineering Moves

1. Extract the allocation logic from the page into a pure module.
2. Add unit tests for priority order, percent/fixed/remainder rules, gates, caps, and overflow.
3. Create schema models for bucket plans, bucket versions, scenarios, and allocation ledger entries.
4. Persist plans to the database while keeping observed transaction data separate from planned allocations.
5. Add plan versions so a month can remember the exact structure that was active at the time.
6. Wire actual statement categories into buckets later, after the truth layer is stable.

## Important Constraint

Do not let the visual canvas become the source of truth. The source of truth should be the bucket tree and rules. The canvas is an editing and simulation surface derived from that tree.
