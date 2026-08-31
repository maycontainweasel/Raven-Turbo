// Local overrides for arrays like modules/css/transpile.
// This file is safe to edit and will be merged into the generated config.
export default {
  modules: ['@unocss/nuxt', '@pinia/nuxt'],
  css: ['~/helios/scss/index.scss'],
  unocss: {
    preflight: true,
    nuxtLayers: true,
    configFile: './uno.config.ts',
  },
}
