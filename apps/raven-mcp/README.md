# Raven Semantic MCP

This stdio MCP exposes Raven's approved Account Control operations, accepted
Statement Truth operations, and the review-state Financial Read Analytics 00 query
catalog. It is separate from the generic
`raven-surreal-local` diagnostic MCP and does not expose raw table CRUD, raw SurrealQL,
or generic update/delete payloads.

Workline 01 tools:

- `list_accounts`
- `get_account`
- `get_current_position`
- `get_account_freshness`
- `create_account`
- `confirm_account_balance`

Statement Truth contains 31 parity-matched camelCase tRPC and snake_case MCP
operations after the fictional HP-04 compatibility bridge. ST-02 added:

- `list_statement_match_candidates`
- `list_statement_transaction_matches`
- `get_statement_transaction_match`
- `get_statement_reconciliation`
- `propose_statement_transaction_match`
- `confirm_statement_transaction_match`
- `materialize_statement_component_transaction`
- `reject_statement_transaction_match`
- `supersede_statement_transaction_match`
- `acknowledge_statement_issue`
- `supersede_statement_import`
- `recalculate_statement_reconciliation`
- `attest_statement_reconciled`
- `reopen_statement_reconciliation`

Candidates are suggestions only. Confirmation is an explicit audited act.
Materialization creates one observed Transaction and no accepted management or tax
meaning. Reconciliation proves source coverage and exact arithmetic; it does not mean
Category, Merchant, recurrence, accounting, or tax completion. Private Historian
operation is governed separately by the HP-00 runbook and approval gates.

Financial Read Analytics 00 adds seven read-only tools:

- `get_period_financial_summary`
- `get_category_spend_summary`
- `get_merchant_spend_summary`
- `get_fee_summary`
- `get_monthly_financial_trend`
- `list_uncategorized_transactions`
- `get_financial_data_quality_summary`

They use checked integer minor units, remain per-currency, exclude transfers from
ordinary totals, separate active/provisional/statement-backed/legacy/unresolved
authority, and infer no tax meaning. Fee totals require explicit reviewed evidence
rules. The operations contain no financial mutation or `FinancialOperation` path.

The process reads connection configuration from `RAVEN_SURREAL_URL`, `RAVEN_SURREAL_USER`, `RAVEN_SURREAL_PASS`, `RAVEN_SURREAL_NAMESPACE`, and `RAVEN_SURREAL_DATABASE`. Do not commit their values.

```bash
pnpm --filter raven-mcp start
```

For the local Raven checkout, `pnpm mcp:raven` reads the existing ignored `surreal.md`
machine data at process start. It does not copy credentials into source or Codex MCP
configuration. The Statement Truth machine-readable inventory is
`docs/operations/raven-statement-truth-operations-v0.1.json`.
