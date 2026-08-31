# Atomic Layer

Atomic is the future stable design-system and UnoCSS backbone for Helios-built Nuxt apps.

This layer is intentionally small for now. It exists to make the boundary concrete before more authoring work is built on top of it.

## Responsibility

Atomic owns the durable design-system substrate:

- UnoCSS setup
- type scale
- vertical rhythm
- ratio spacing
- color palettes
- semantic tokens
- utility feature toggles
- generated Uno config
- generated SCSS/token output
- optional baseline type sheet

Atomic should be safe to leave installed in a production client app.

## Non-goals

Atomic does not own the visual page-builder runtime:

- no `HeliosRuntimeCanvas`
- no `HeliosZone`
- no overlays
- no Navigator or Options panel
- no Surreal-backed node persistence
- no authoring dock or settings chrome

Those belong to the Helios Authoring layer.

## Current Status

Atomic now registers `@unocss/nuxt` with Nuxt layer-aware defaults:

```ts
modules: ['@unocss/nuxt']
css: [orbitDarkCss]
unocss: {
  preflight: true,
  nuxtLayers: true,
  shortcuts: {
    'ds-app': '...',
    'ds-field': '...',
    'ds-button-primary': '...',
  }
}
```

Atomic also includes the first Design System Studio preset:

```txt
orbit-dark
```

The preset lives under `app/atomic/presets/orbit-dark.ts` and emits a small semantic `--ds-*` token layer through `app/assets/css/orbit-dark.css`. The accompanying `ds-*` classes and shortcuts are v0 semantic hooks for application surfaces, panels, cards, fields, buttons, and chips. They do not replace existing Atomic utility families such as `f-*`, `v-*`, rhythm spacing, or ratio spacing.

Atomic does not yet own the full generated Uno config. The host app still owns the current `uno.config.ts` bridge and generated app artifacts until a dedicated extraction sprint moves the design-system manager.

The current `/helios` design-system manager still lives in `apps/helios/layers/helios`. Conceptually, that manager is Atomic-owned because it manages type, color, theme, breakpoints, generated Uno config, and SCSS/token artifacts.

Do not move the full manager here until a dedicated extraction sprint proves it is safe.

## Intended Dependency Graph

```txt
@helios/protocol
  -> Atomic
      -> Helios Authoring
          -> IO / Thing Builder / Behavior
```

Helios Authoring can be removed after a site is baked/transposed into normal Vue output plus Atomic classes/tokens. Atomic remains as the stable design-system layer.
