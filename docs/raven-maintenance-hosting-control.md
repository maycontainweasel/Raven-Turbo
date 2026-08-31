---
status: working
owner: Raven
last_reviewed: 2026-07-11
supersedes: []
superseded_by: []
---

# Raven Maintenance And Hosting Control

This document defines how Raven agents should handle client maintenance, hosting retainers, provider costs, billing cycles, migrations, and future Raven MCP functions.

## Operating Model

- Orbit is the planning and reminder layer.
- Raven is the long-term structured source of truth.
- `.raven-private/maintenance/` is the private working surface for uncertain client facts, notes, quote drafts, and evidence references.
- Private source evidence should be referenced by stable description, date, sender, filename, or mailbox search term. Do not copy sensitive raw email threads, bank statement rows, or private client material into tracked docs.

## Investigation Flow

1. Start one client at a time.
2. Capture rough notes in a client dossier.
3. Separate every item into:
   - observed fact
   - assumption
   - estimate
   - open question
   - proposed action
4. Build any urgent deliverable from the dossier, such as a quote, provider request, or migration checklist.
5. Move stable facts into Raven records only once the client, retainer, provider, hosting asset, billing expectation, or timeline entry is clear enough to be operationally useful.

## Current First Slice

The first investigation is **Altracare**.

Goal:

- reconstruct current services, billing, and agreement history
- understand current email hosting state
- produce an email-only hosting quote
- produce a migration checklist
- prepare a provider request letter if needed

## Raven Data Direction

The existing schema-backed base is:

- `Client`
- `HostingProvider`
- `Retainer`

Future models should be added through `apps/schema/config/graph.mpdg` before Raven UI/API work:

- `ClientTimelineEntry`: dated agreement, payment, quote, conversation, issue, decision, or action note.
- `HostingAsset`: domain, site, mailbox set, cPanel account, VPS service, DNS zone, or related hosted property.
- `RetainerBillingEvent`: expected invoice, issued invoice, paid/unpaid state, period covered, and payment reference.
- `CostAllocation`: provider or infrastructure cost assigned to a client, asset, retainer, or shared pool.
- `EvidenceSource`: safe source reference without copying private raw content into tracked code or Orbit.

## MCP Qualification Rules

Create Raven MCP tools only when the operation is stable, repeated, and schema-backed.

Good candidates:

- create or update a client
- create or update a retainer
- add a client timeline entry
- record a hosting asset
- create a billing expectation
- link a bank transaction to an invoice, billing event, or retainer
- create a follow-up task or reminder in Orbit
- generate a client maintenance snapshot

Poor candidates:

- one-off exploratory queries
- tools that bypass generated schema contracts
- tools that store raw sensitive evidence without explicit permission
- tools that mix observed transactions with estimates or projections
- tools that make client-facing claims from unconfirmed assumptions

## Acceptance Standard

This work is successful when Raven can answer:

- which clients are on maintenance or hosting retainers
- what each client is paying for
- what is included and excluded
- what is due to be billed next
- what has been billed and paid
- what provider/service each hosted asset is on
- what each client costs to maintain
- what needs migration, review, increase, pause, cancellation, or a new quote
