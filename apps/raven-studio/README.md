# Raven Studio

Raven Studio is the clean rebuild surface for Raven's UX and UI.

It intentionally starts as a blank, schema-driven Nuxt app that shares Raven's local database, Typesense setup, schema-kit runtime contracts, and Helios layer. The current goal is to rebuild the Raven experience from essential views first, then selectively bring back visual richness from the original `apps/raven` app when the product flow is clear.

Raven Studio is the primary product UI. The original Raven app remains a behavioral and query reference. New financial business rules should move into a shared application/domain layer used by Raven Studio, semantic Raven MCP tools, and future clients.

The next product slice is present financial command: balance freshness, obligations, recurring commitments, base monthly cost, 30-day coverage, uncertainty, and required daily/hourly earning rates. Define the shared domain contract before building broad UI.

## Current Surface

Routes at this starting point:

- `/`

The home route is deliberately empty except for a small readiness panel.

## Run

```bash
pnpm -C apps/raven-studio dev
```

The local nginx-facing URL is:

```txt
https://raven:4443
```

## Layers

Raven Studio extends the local schema-core and Helios layers:

- `layers/schema-core`
- `layers/helios`

The Helios baseline owns the `app/helios` generated fragments, Uno bridge, and SCSS token files for this prototype app.

## Build

```bash
pnpm -C apps/raven-studio build
```
