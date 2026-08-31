# Helios Layer Agent Instructions

This file applies to everything inside `apps/helios/layers/helios`.

Helios is the removable authoring/runtime page-builder layer. Apps may copy this layer into their own build, so its version must make drift obvious.

## Required When Changing This Layer

If any file inside this layer changes, update all of the following in the same commit:

- `VERSION`
- `layer.yaml` `version`
- `CHANGELOG.md`

Use semantic versioning:

- Patch: documentation, metadata, internal cleanup, or backwards-compatible fixes.
- Minor: new backwards-compatible runtime/editor features, APIs, qualities, routes, panels, or public layer behavior.
- Major: breaking changes to runtime APIs, storage expectations, protocol compatibility, generated output contracts, install expectations, or public layer behavior.

## Changelog Entries

Each changelog entry should include:

- What changed.
- Whether copied apps need to refresh their local Helios layer.
- Any migration notes.
- Verification commands when relevant.

## Layer Boundary

Helios Authoring can depend on Atomic concepts, but it should remain removable from production apps after output is baked or rendered through an approved production path.
