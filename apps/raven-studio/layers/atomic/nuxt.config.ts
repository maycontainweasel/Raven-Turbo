const orbitDarkCss = new URL('./app/assets/css/orbit-dark.css', import.meta.url).pathname

export default defineNuxtConfig({
  $meta: {
    name: 'atomic',
  },
  css: [orbitDarkCss],
  modules: ['@unocss/nuxt'],
  unocss: {
    preflight: true,
    nuxtLayers: true,
    shortcuts: {
      'ds-app': 'min-h-screen bg-[var(--ds-bg-root)] text-[var(--ds-text-primary)]',
      'ds-surface': 'bg-[var(--ds-bg-surface)] text-[var(--ds-text-primary)]',
      'ds-panel': 'rounded-[var(--ds-radius-xl)] border border-[var(--ds-border-subtle)] bg-[var(--ds-bg-elevated)] text-[var(--ds-text-primary)] shadow-[var(--ds-shadow-md)]',
      'ds-card': 'rounded-[var(--ds-radius-lg)] border border-[var(--ds-border-subtle)] bg-[var(--ds-bg-elevated)] text-[var(--ds-text-primary)] shadow-[var(--ds-shadow-sm)]',
      'ds-control': 'rounded-[var(--ds-radius-lg)] border border-[var(--ds-control-border)] bg-[var(--ds-control-bg)] text-[var(--ds-text-secondary)] hover:bg-[var(--ds-control-bg-hover)]',
      'ds-field': 'min-h-[var(--ds-field-height)] rounded-[var(--ds-field-radius)] border border-[var(--ds-field-border)] bg-[var(--ds-field-bg)] px-[var(--ds-field-padding-x)] text-[var(--ds-field-text)] placeholder:text-[var(--ds-field-placeholder)] outline-none',
      'ds-button': 'inline-flex min-h-[var(--ds-button-height)] items-center justify-center gap-2 rounded-[var(--ds-button-radius)] border border-transparent px-[var(--ds-button-padding-x)] font-[var(--ds-button-font-weight)]',
      'ds-button-primary': 'bg-[var(--ds-bg-inverted)] text-[var(--ds-text-inverted)]',
      'ds-button-secondary': 'border-[var(--ds-border-default)] bg-[var(--ds-control-bg)] text-[var(--ds-text-secondary)] hover:bg-[var(--ds-control-bg-hover)]',
      'ds-text-muted': 'text-[var(--ds-text-muted)]',
      'ds-chip': 'inline-flex min-h-6 items-center rounded-full border border-[var(--ds-border-default)] bg-[var(--ds-control-bg)] px-2.5 text-xs font-700 text-[var(--ds-text-secondary)]',
      'ds-chip-success': 'text-[var(--ds-success)]',
      'ds-chip-warning': 'text-[var(--ds-warning)]',
      'ds-chip-danger': 'text-[#ff8583]',
    },
  },
})
