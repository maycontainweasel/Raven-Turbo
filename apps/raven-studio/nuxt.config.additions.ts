// Local overrides for arrays like modules/css/transpile.
// This file is safe to edit and will be merged into the generated config.
export default {
  build: {
    transpile: ['@raven/domain', '@raven/surreal'],
  },
  css: ['~/helios/scss/index.scss', '~/assets/css/raven-studio.css'],
  // Enables layer-aware UnoCSS config merging when @unocss/nuxt is installed.
  unocss: {
    preflight: true,
    nuxtLayers: true,
    configFile: './uno.config.ts',
  },
  fonts: {
    families: [
      { name: 'Poppins', provider: 'google' },
    ],
  },
  modules: [
    '@nuxt/fonts',
    '@unocss/nuxt',
    '@pinia/nuxt',
  ],
  extends: [
    './layers/schema-core',
    './layers/atomic',
    './layers/helios',
  ],
}
