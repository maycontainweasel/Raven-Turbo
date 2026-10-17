import assert from 'node:assert/strict'
import test from 'node:test'

import { processGroupTarget, redactDevOutput } from '../dev-stack.mjs'

test('development output redacts SurrealDB password arguments', () => {
  assert.equal(
    redactDevOutput('surreal start --user raven --pass private-value rocksdb://db'),
    'surreal start --user raven --pass [redacted] rocksdb://db',
  )
  assert.equal(
    redactDevOutput('NUXT_SURREALDB_PASS=private-value'),
    'NUXT_SURREALDB_PASS=[redacted]',
  )
})

test('POSIX services are addressed through their isolated process group', () => {
  assert.equal(processGroupTarget(4321, 'darwin'), -4321)
  assert.equal(processGroupTarget(4321, 'linux'), -4321)
  assert.equal(processGroupTarget(4321, 'win32'), 4321)
})
