# Atomic Layer Agent Instructions

This file applies to everything inside `apps/helios/layers/atomic`.

Atomic is the stable design-system and UnoCSS backbone layer. Apps may copy this layer into their own build, so its version must make drift obvious.

## Required When Changing This Layer

If any file inside this layer changes, update all of the following in the same commit:

- `VERSION`
- `layer.yaml` `version`
- `CHANGELOG.md`

Use semantic versioning:

- Patch: documentation, metadata, internal cleanup, or backwards-compatible fixes.
- Minor: new backwards-compatible Atomic features, utilities, tokens, presets, or public layer behavior.
- Major: breaking changes to Atomic config, generated artifacts, utility contracts, install expectations, or public layer behavior.

## Changelog Entries

Each changelog entry should include:

- What changed.
- Whether copied apps need to refresh their local Atomic layer.
- Any migration notes.
- Verification commands when relevant.

## Layer Boundary

Atomic should remain safe to leave in production apps. It owns design-system and UnoCSS concerns, not private Helios Authoring UI.
