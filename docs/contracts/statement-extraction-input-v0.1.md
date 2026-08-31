---
status: canonical
owner: Raven
last_reviewed: 2026-07-30
source_authority: docs/contracts/statement-extraction-input-v0.1.schema.json
---

# Statement Extraction Assistance v0.1

This contract describes neutral extraction assistance supplied alongside original bank evidence. It is not bank evidence, accepted management meaning, tax treatment, a Transaction, or reconciliation.

## Artifacts And Identity

Raven keeps three distinct hashes:

1. the original source bytes;
2. the optional extraction-assistance JSON bytes;
3. the canonical normalized extraction.

Changing any artifact changes preview identity. Never place source paths, credentials, account numbers, merchant classification, categories, or tax conclusions in this JSON.

## Production Rules

- Validate against `statement-extraction-input-v0.1.schema.json`.
- `sourceKind` must exactly match the staged original evidence.
- Use integer minor units only. Do not emit decimal money.
- Preserve transaction, posting, and value dates separately.
- Supply `rows` and every `components` value as arrays, including when empty.
- Keep row keys and component keys unique in their scope. Rows remain in source order and use contiguous row numbers `1..N`; Raven rejects reordered arrays even when row numbers are unique.
- Mark account movements as `movement`; printed breakdowns already included in a movement are `informational_breakdown` with zero balance effect.
- A movement has a positive amount, a signed balance effect with the same absolute value, a known source flow, and at least one exact printed date on the component or parent row.
- `positive_is_asset` means a positive effect is an inflow. `positive_is_liability` means a positive effect is an outflow.
- Report coverage honestly. For PDF and image sources, `complete` requires a positive page count and `processedPages` exactly equal to `1..N`. CSV, OFX, and QIF are explicitly nonpaginated and require a null page count and an empty page array. Every declared section and printed row must be represented exactly.
- Page and line locators are positive, page locators must be within the declared page count, and geometry uses nonnegative origins with positive width and height. Nonpaginated sources cannot use page locators.
- A bank-specific profile is authoritative: its balance convention must exactly match the extraction and its economic nature must match the selected account. The generic `normalized-json-v1` profile remains operator-unverified, emits a warning, and cannot create a closing-balance snapshot.
- Use `incomplete` or `indeterminate` when full monetary coverage cannot be proved. Raven will block commit with `STATEMENT_PARTIAL_PERIOD`.
- A zero-row statement is valid only with complete coverage and equal exact opening and closing balances.

The runtime performs stricter semantic checks than JSON Schema can express, including calendar round-trips, arithmetic overflow, running-balance reproduction, cross-field role rules, and profile/account balance-convention compatibility.

## Operator Flow

1. Stage original evidence and the JSON assistance as separate private artifacts.
2. Review the assistance profile hint as a hint, not detection proof.
3. Select the explicit profile.
4. Review source hash, account, currency, versions, coverage, rows, components, and blockers.
5. Commit only the reviewed preview. Retries reuse the same command intent.

The fictional example contains no private financial source material.
