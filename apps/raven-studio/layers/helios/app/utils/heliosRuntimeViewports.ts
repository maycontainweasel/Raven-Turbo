export type HeliosRuntimeBreakpoint = 'base' | 'mobile' | 'tablet' | 'desktop' | 'wide'

export type HeliosRuntimeViewport = {
  breakpoint: HeliosRuntimeBreakpoint
  label: string
  width: number | null
}

export const HELIOS_RUNTIME_BREAKPOINTS: HeliosRuntimeBreakpoint[] = [
  'base',
  'mobile',
  'tablet',
  'desktop',
  'wide',
]

export const HELIOS_RUNTIME_VIEWPORTS: Record<HeliosRuntimeBreakpoint, HeliosRuntimeViewport> = {
  base: { breakpoint: 'base', label: 'Base', width: null },
  mobile: { breakpoint: 'mobile', label: 'Mobile', width: 390 },
  tablet: { breakpoint: 'tablet', label: 'Tablet', width: 768 },
  desktop: { breakpoint: 'desktop', label: 'Desktop', width: 1120 },
  wide: { breakpoint: 'wide', label: 'Wide', width: 1440 },
}

export const getHeliosRuntimeViewport = (
  breakpoint: HeliosRuntimeBreakpoint,
) => HELIOS_RUNTIME_VIEWPORTS[breakpoint] ?? HELIOS_RUNTIME_VIEWPORTS.base
