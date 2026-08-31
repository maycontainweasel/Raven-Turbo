import assert from 'node:assert/strict'
import test from 'node:test'
import { createCommandIntent, createCommandIntentRegistry } from './idempotency.js'

test('a failed submission retry reuses the same command intent key', () => {
  const generated = ['intent-001', 'intent-002']
  const intent = createCommandIntent(() => generated.shift() ?? 'unexpected')

  const firstSubmission = intent.begin()
  const retryAfterLostResponse = intent.current()

  assert.equal(firstSubmission, 'intent-001')
  assert.equal(retryAfterLostResponse, firstSubmission)
  assert.equal(intent.peek(), firstSubmission)
})

test('success or cancellation clears the intent before the next command', () => {
  const generated = ['intent-001', 'intent-002', 'intent-003']
  const intent = createCommandIntent(() => generated.shift() ?? 'unexpected')

  assert.equal(intent.begin(), 'intent-001')
  intent.clear()
  assert.equal(intent.peek(), null)
  assert.equal(intent.begin(), 'intent-002')
  intent.clear()
  assert.equal(intent.begin(), 'intent-003')
})

test('keyed mutation intents reuse retries without sharing keys across actions', () => {
  let sequence = 0
  const intents = createCommandIntentRegistry((action) => `${action}-${++sequence}`)

  assert.equal(intents.current('update'), 'update-1')
  assert.equal(intents.current('update'), 'update-1')
  assert.equal(intents.current('pause'), 'pause-2')

  intents.clear('update')
  assert.equal(intents.current('update'), 'update-3')
  assert.equal(intents.peek('pause'), 'pause-2')

  intents.clearAll()
  assert.equal(intents.peek('pause'), null)
  assert.equal(intents.current('pause'), 'pause-4')
})
