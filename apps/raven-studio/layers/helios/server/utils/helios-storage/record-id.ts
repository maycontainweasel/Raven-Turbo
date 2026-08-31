import {
  normalizeHeliosRecordRef,
  type HeliosRecordRef,
} from '@helios/protocol'

export type HeliosRecordTarget = HeliosRecordRef

export const toHeliosRecordTarget = (
  value: unknown,
  fallbackTable: string,
) => {
  const ref = normalizeHeliosRecordRef(value, fallbackTable)
  if (!ref) throw new Error('Missing Helios node record reference')
  return ref
}

export const assertHeliosRecordTable = (
  target: Pick<HeliosRecordRef, 'table'>,
  expectedTable: string,
) => {
  if (target.table !== expectedTable) {
    throw new Error(`Helios node table mismatch: expected ${expectedTable}, received ${target.table}`)
  }
}
