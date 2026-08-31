import { defineConfig } from 'unocss'

const heliosBreakpoints = {"tablet":"500px","laptop":"1024px","desktop":"1366px"}

export default defineConfig({
  theme: {
    breakpoints: heliosBreakpoints,
    colors: {
      heliosbrand: '#2858ff',
      brand: 'var(--ds-brand, #2858ff)',
      ink: 'var(--ds-text, #0f172a)',
    },
  },
})
