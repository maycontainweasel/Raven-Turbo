import assert from 'node:assert/strict'
import test from 'node:test'

import { createHeliosRecordRef } from '@helios/protocol'
import { RecordId } from 'surrealdb'
import {
  assertHeliosRecordTable,
  toHeliosRecordTarget,
} from './record-id.ts'
import { toSurrealHeliosRecordId } from './surreal.ts'

test('resolves opaque record keys and legacy ids into record targets', () => {
  const ref = createHeliosRecordRef('helios_node', 'mike-someone@gmail.com')

  assert.deepEqual(toHeliosRecordTarget(ref.key, 'helios_node'), ref)
  assert.deepEqual(toHeliosRecordTarget('helios_node:abc123', 'helios_node'), createHeliosRecordRef('helios_node', 'abc123'))
  assert.deepEqual(toHeliosRecordTarget('abc:123', 'helios_node'), createHeliosRecordRef('helios_node', 'abc:123'))
})

test('normalizes SDK-like Surreal record targets', () => {
  assert.deepEqual(
    toHeliosRecordTarget({ tb: 'helios_node', id: ['page:home', 'zone-main'] }, 'helios_node'),
    createHeliosRecordRef('helios_node', ['page:home', 'zone-main']),
  )
  assert.deepEqual(
    toHeliosRecordTarget({ table: { name: 'helios_node' }, id: { document: 'page:home', zone: 'main' } }, 'helios_node'),
    createHeliosRecordRef('helios_node', { document: 'page:home', zone: 'main' }),
  )
})

test('guards Helios record table mismatches', () => {
  assert.doesNotThrow(() => assertHeliosRecordTable(
    createHeliosRecordRef('helios_node', 'abc123'),
    'helios_node',
  ))
  assert.throws(
    () => assertHeliosRecordTable(createHeliosRecordRef('other_table', 'abc123'), 'helios_node'),
    /Helios node table mismatch/,
  )
})

test('constructs real Surreal record ids for parent pointers', () => {
  const ref = createHeliosRecordRef('helios_node', 'mike-someone@gmail.com')
  const parent = toSurrealHeliosRecordId(ref, 'helios_node')

  assert.ok(parent instanceof RecordId)
  assert.equal(parent.table.name, 'helios_node')
  assert.equal(parent.id, 'mike-someone@gmail.com')
  assert.match(String(parent), /^helios_node:/)
  assert.match(String(parent), /mike-someone@gmail\.com/)
})
