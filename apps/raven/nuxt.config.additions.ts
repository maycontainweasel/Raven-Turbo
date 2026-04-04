// Local overrides for arrays like modules/css/transpile.
// This file is safe to edit and will be merged into the generated config.
export default {
  modules: ['@nuxt/fonts'],
  fonts: {
    provider: 'google',
  },
  // Enables layer-aware UnoCSS config merging when @unocss/nuxt is installed.
  unocss: {
    nuxtLayers: true,
  },
}
