const BREAKPOINT_PREFIX_RE = /^[a-z][a-z0-9-]*:/i
const ARBITRARY_CLASS_RE = /^\w+(?:-\w+)*-\[(.*)\]$/

const unwrapArbitraryClassValue = (token: string) => {
  const match = token.match(ARBITRARY_CLASS_RE)
  return match?.[1]?.replaceAll('_', ' ') || ''
}

const applyBackgroundClass = (style: Record<string, string>, token: string) => {
  if (token.startsWith('bg-[')) {
    const value = unwrapArbitraryClassValue(token)
    if (value) style.background = value
  }
}

const applySpacingClass = (style: Record<string, string>, token: string) => {
  const value = unwrapArbitraryClassValue(token)
  if (!value) return

  if (token.startsWith('pt-[')) style.paddingTop = value
  if (token.startsWith('pr-[')) style.paddingRight = value
  if (token.startsWith('pb-[')) style.paddingBottom = value
  if (token.startsWith('pl-[')) style.paddingLeft = value
  if (token.startsWith('max-w-[')) style.maxWidth = value
  if (token.startsWith('h-[')) style.height = value
}

const applyGridClass = (style: Record<string, string>, token: string) => {
  if (token === 'grid') {
    style.display = 'grid'
    return
  }
  if (token === 'min-h-100vh') {
    style.minHeight = '100vh'
    return
  }
  if (token === 'mx-auto') {
    style.marginLeft = 'auto'
    style.marginRight = 'auto'
    return
  }
  if (token === 'my-auto') {
    style.marginTop = 'auto'
    style.marginBottom = 'auto'
    return
  }
  if (token.startsWith('grid-cols-[')) {
    const value = unwrapArbitraryClassValue(token)
    if (value) style.gridTemplateColumns = value
    return
  }
  if (token.startsWith('grid-rows-[')) {
    const value = unwrapArbitraryClassValue(token)
    if (value) style.gridTemplateRows = value
    return
  }
  if (token.startsWith('grid-cols-')) {
    const count = Number(token.slice('grid-cols-'.length))
    if (Number.isFinite(count) && count > 0) {
      style.gridTemplateColumns = `repeat(${Math.round(count)}, minmax(0, 1fr))`
    }
    return
  }
  if (token.startsWith('grid-rows-')) {
    const count = Number(token.slice('grid-rows-'.length))
    if (Number.isFinite(count) && count > 0) {
      style.gridTemplateRows = `repeat(${Math.round(count)}, minmax(0, 1fr))`
    }
    return
  }

  const gridLineMatch = token.match(/^(col|row)-(start|end)-(\d+)$/)
  if (!gridLineMatch) return

  const [, axis, edge, rawValue] = gridLineMatch
  const value = Number(rawValue)
  if (!Number.isFinite(value)) return
  if (axis === 'col' && edge === 'start') style.gridColumnStart = String(value)
  if (axis === 'col' && edge === 'end') style.gridColumnEnd = String(value)
  if (axis === 'row' && edge === 'start') style.gridRowStart = String(value)
  if (axis === 'row' && edge === 'end') style.gridRowEnd = String(value)
}

export const resolveHeliosManifestClassStyle = (
  classes: string[] | null | undefined,
) => {
  const style: Record<string, string> = {}
  for (const className of classes || []) {
    const token = String(className || '').trim()
    if (!token || BREAKPOINT_PREFIX_RE.test(token)) continue
    applyGridClass(style, token)
    applySpacingClass(style, token)
    applyBackgroundClass(style, token)
  }
  return style
}
