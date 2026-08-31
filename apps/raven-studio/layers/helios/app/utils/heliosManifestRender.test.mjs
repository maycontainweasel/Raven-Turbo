import assert from 'node:assert/strict'
import test from 'node:test'
import { resolveHeliosManifestClassStyle } from './heliosManifestRender.ts'

test('leaves palette background classes to Uno and Atomic CSS', () => {
  assert.deepEqual(resolveHeliosManifestClassStyle(['bg-red-500']), {})
})

test('inline-resolves arbitrary background values for output preview fallback', () => {
  assert.deepEqual(resolveHeliosManifestClassStyle(['bg-[#ff0000]']), {
    background: '#ff0000',
  })
})
