# Atomic Layer Changelog

## 0.2.0 - 2026-06-13

- Added the `orbit-dark` Design System Studio preset v0 with semantic `--ds-*` tokens.
- Added token-backed `ds-*` CSS classes and matching minimal Uno shortcuts for app shells, panels, cards, fields, buttons, and chips.
- Registered the Orbit Dark CSS variable layer from Atomic so apps extending Atomic can opt into `[data-theme='orbit-dark']`.
- Copied apps should refresh their local Atomic layer to receive `orbit-dark`; no migration is required for existing Atomic utility classes.
- Verification: run the host app build/prepare and `git diff --check` after copying this layer.

## 0.1.1 - 2026-06-12

- Added explicit layer version tracking with `VERSION`.
- Added this changelog so copied Atomic layers can be compared against the source layer.
- Added layer-local agent instructions requiring version and changelog updates for future Atomic layer changes.

## 0.1.0 - Initial

- Established Atomic as the design-system and UnoCSS backbone layer for Helios-built Nuxt apps.
- Declared the layer metadata in `layer.yaml`.
