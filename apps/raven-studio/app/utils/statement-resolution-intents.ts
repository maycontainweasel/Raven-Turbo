export type ReviewedCommandIntents = Readonly<{
  begin(scope: string, reviewedPayload: unknown): string;
  clear(scope: string): void;
  clearAll(): void;
}>;

export function createReviewedCommandIntents(
  createKey: () => string = () => crypto.randomUUID(),
): ReviewedCommandIntents {
  const intents = new Map<string, { signature: string; key: string }>();
  return {
    begin(scope, reviewedPayload) {
      const signature = JSON.stringify(reviewedPayload);
      const current = intents.get(scope);
      if (current?.signature === signature) return current.key;
      const key = createKey();
      intents.set(scope, { signature, key });
      return key;
    },
    clear(scope) {
      intents.delete(scope);
    },
    clearAll() {
      intents.clear();
    },
  };
}
