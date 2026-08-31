import test from 'node:test'
import assert from 'node:assert/strict'

import {
  createHeliosRecordRef,
  decodeHeliosRecordKey,
  normalizeHeliosRecordRef,
} from '../src/index.ts'

test('creates opaque keys for special string record ids', () => {
  const ref = createHeliosRecordRef('helios_node', 'mike-someone@gmail.com')

  assert.equal(ref.table, 'helios_node')
  assert.equal(ref.id, 'mike-someone@gmail.com')
  assert.match(ref.key, /^hrec_/)
  assert.equal(ref.display, 'helios_node:`mike-someone@gmail.com`')
  assert.deepEqual(decodeHeliosRecordKey(ref.key), {
    table: 'helios_node',
    id: 'mike-someone@gmail.com',
  })
})

test('reads legacy full ids only as a fallback path', () => {
  const full = normalizeHeliosRecordRef('helios_node:abc123', 'helios_node')
  const colonSubId = normalizeHeliosRecordRef('abc:123', 'helios_node')

  assert.equal(full?.table, 'helios_node')
  assert.equal(full?.id, 'abc123')
  assert.equal(colonSubId?.table, 'helios_node')
  assert.equal(colonSubId?.id, 'abc:123')
})

test('supports numeric, array, and object id parts', () => {
  assert.equal(createHeliosRecordRef('helios_node', 42).id, 42)
  assert.deepEqual(createHeliosRecordRef('helios_node', ['page:home', 'zone-main']).id, [
    'page:home',
    'zone-main',
  ])
  assert.deepEqual(createHeliosRecordRef('helios_node', { document: 'page:home', zone: 'main' }).id, {
    document: 'page:home',
    zone: 'main',
  })
  assert.notEqual(
    createHeliosRecordRef('helios_node', '42').key,
    createHeliosRecordRef('helios_node', 42).key,
  )
})

test('creates stable opaque keys for object ids regardless of key order', () => {
  const first = createHeliosRecordRef('helios_node', {
    document: 'page:home',
    zone: 'main',
  })
  const second = createHeliosRecordRef('helios_node', {
    zone: 'main',
    document: 'page:home',
  })
  const arrayA = createHeliosRecordRef('helios_node', ['page:home', 'zone-main'])
  const arrayB = createHeliosRecordRef('helios_node', ['zone-main', 'page:home'])

  assert.equal(first.key, second.key)
  assert.deepEqual(first.id, {
    document: 'page:home',
    zone: 'main',
  })
  assert.notEqual(arrayA.key, arrayB.key)
})

test('preserves object ids shaped like id wrappers', () => {
  const objectId = createHeliosRecordRef('helios_node', { id: 'abc123' })
  const normalized = normalizeHeliosRecordRef({ id: 'abc123' }, 'helios_node')

  assert.deepEqual(objectId.id, { id: 'abc123' })
  assert.deepEqual(normalized?.id, { id: 'abc123' })
  assert.equal(normalized?.key, objectId.key)
})

test('opaque record keys roundtrip object ids that look like SDK scalar wrappers', () => {
  const stringObject = createHeliosRecordRef('helios_node', { String: 'abc123' })
  const numberObject = createHeliosRecordRef('helios_node', { Number: 123 })
  const nestedObject = createHeliosRecordRef('helios_node', {
    scope: { String: 'page:home' },
    order: { Number: 3 },
  })

  assert.deepEqual(decodeHeliosRecordKey(stringObject.key), {
    table: 'helios_node',
    id: { String: 'abc123' },
  })
  assert.deepEqual(decodeHeliosRecordKey(numberObject.key), {
    table: 'helios_node',
    id: { Number: 123 },
  })
  assert.deepEqual(decodeHeliosRecordKey(nestedObject.key), {
    table: 'helios_node',
    id: {
      order: { Number: 3 },
      scope: { String: 'page:home' },
    },
  })
})

test('normalizes SDK-like Surreal record objects', () => {
  assert.deepEqual(
    normalizeHeliosRecordRef({ tb: 'helios_node', id: 'abc123' }),
    createHeliosRecordRef('helios_node', 'abc123'),
  )
  assert.deepEqual(
    normalizeHeliosRecordRef({ tb: 'helios_node', id: ['page:home', 'zone-main'] }),
    createHeliosRecordRef('helios_node', ['page:home', 'zone-main']),
  )
  assert.deepEqual(
    normalizeHeliosRecordRef({ table: { name: 'helios_node' }, id: { String: 'nested-id' } }),
    createHeliosRecordRef('helios_node', 'nested-id'),
  )
  assert.deepEqual(
    normalizeHeliosRecordRef({ table: { name: 'helios_node' }, id: { Number: 123 } }),
    createHeliosRecordRef('helios_node', 123),
  )
})
