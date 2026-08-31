export type CommandIntent = Readonly<{
  begin: () => string
  current: () => string
  clear: () => void
  peek: () => string | null
}>

export type CommandIntentRegistry = Readonly<{
  current: (action: string) => string
  clear: (action: string) => void
  clearAll: () => void
  peek: (action: string) => string | null
}>

export function createCommandIntent(
  createKey: () => string = () => globalThis.crypto.randomUUID(),
): CommandIntent {
  let key: string | null = null

  const begin = () => {
    key ??= createKey()
    return key
  }

  return {
    begin,
    current: begin,
    clear: () => {
      key = null
    },
    peek: () => key,
  }
}

export function createCommandIntentRegistry(
  createKey: (action: string) => string = (action) => `${action}-${globalThis.crypto.randomUUID()}`,
): CommandIntentRegistry {
  const intents = new Map<string, CommandIntent>()
  const intent = (action: string) => {
    let current = intents.get(action)
    if (!current) {
      current = createCommandIntent(() => createKey(action))
      intents.set(action, current)
    }
    return current
  }

  return {
    current: (action) => intent(action).current(),
    clear: (action) => {
      intents.get(action)?.clear()
      intents.delete(action)
    },
    clearAll: () => intents.clear(),
    peek: (action) => intents.get(action)?.peek() ?? null,
  }
}
