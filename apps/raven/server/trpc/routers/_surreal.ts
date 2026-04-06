import { TRPCError } from '@trpc/server';
import type { Ctx } from '@schema/server/trpc/context';

type SurrealStatement<T = unknown> = {
  status?: 'OK' | 'ERR';
  result?: T;
  detail?: string;
  description?: string;
  information?: string;
};

const statementError = (statement: SurrealStatement | undefined, index: number) => {
  const detail = statement?.detail || statement?.description || statement?.information || 'Unknown SurrealDB error';
  return new TRPCError({
    code: 'INTERNAL_SERVER_ERROR',
    message: `SurrealDB statement ${index} failed: ${detail}`,
  });
};

export function getStatementResult<T>(response: unknown, index = 0): T {
  const statements = Array.isArray(response) ? response as Array<SurrealStatement<T> | T> : [];
  const statement = statements[index];

  if (!statement) {
    throw new TRPCError({
      code: 'INTERNAL_SERVER_ERROR',
      message: `Missing SurrealDB statement ${index}`,
    });
  }

  if (Array.isArray(statement)) {
    return statement as T;
  }

  if (typeof statement === 'object' && statement !== null && ('status' in statement || 'result' in statement)) {
    const wrapped = statement as SurrealStatement<T>;
    if (wrapped.status && wrapped.status !== 'OK') {
      throw statementError(wrapped, index);
    }
    return (wrapped.result ?? null) as T;
  }

  if ((statement as SurrealStatement<T>).status && (statement as SurrealStatement<T>).status !== 'OK') {
    throw statementError(statement, index);
  }

  return statement as T;
}

export async function surrealQuery<T>(
  ctx: Ctx,
  query: string,
  vars: Record<string, unknown> = {},
  index = 0,
): Promise<T> {
  const response = await ctx.db.query(query, vars);
  return getStatementResult<T>(response, index);
}

export async function surrealSelectMany<T>(
  ctx: Ctx,
  query: string,
  vars: Record<string, unknown> = {},
  index = 0,
): Promise<T[]> {
  const result = await surrealQuery<unknown>(ctx, query, vars, index);
  if (Array.isArray(result)) {
    return result as T[];
  }
  if (result == null) {
    return [];
  }
  return [result as T];
}

export async function surrealSelectOne<T>(
  ctx: Ctx,
  query: string,
  vars: Record<string, unknown> = {},
  index = 0,
): Promise<T | null> {
  const rows = await surrealSelectMany<T>(ctx, query, vars, index);
  return rows[0] ?? null;
}
