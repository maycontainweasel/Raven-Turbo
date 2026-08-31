// Local overrides for arrays like modules/css/transpile.
// This file is safe to edit and will be merged into the generated config.
export default {
  css: ['~/helios/scss/index.scss'],
  modules: [
    '@nuxt/fonts',
    '@unocss/nuxt',
    '@pinia/nuxt'
  ],
  fonts: {
    provider: 'google',
  },
  // Enables layer-aware UnoCSS config merging when @unocss/nuxt is installed.
  unocss: {
    preflight: true,
    nuxtLayers: true,
    configFile: './uno.config.ts',
  },
}
