import test from 'node:test'
import assert from 'node:assert/strict'

import {
  BACKGROUND_QUALITY_KEY,
  INNER_BOX_BACKGROUND_QUALITY_KEY,
  backgroundQualityDefinition,
  compileBackgroundClasses,
  compileInnerBoxBackgroundClasses,
  innerBoxBackgroundQualityDefinition,
  normalizeBackgroundInput,
  resolveBackgroundInputValue,
  resolveInnerBoxBackgroundInputValue,
  resolveInnerBoxBackgroundPreviewStyle,
  resolveBackgroundPreviewStyle,
  upsertBackgroundQuality,
  upsertInnerBoxBackgroundQuality,
} from '../src/index.ts'

test('normalizes semantic background input', () => {
  assert.deepEqual(normalizeBackgroundInput('bg-surface'), {
    kind: 'semantic-token',
    token: 'surface',
  })
  assert.deepEqual(normalizeBackgroundInput('semantic:surface'), {
    kind: 'semantic-token',
    token: 'surface',
  })
  assert.deepEqual(normalizeBackgroundInput('bg.surface'), {
    kind: 'semantic-token',
    token: 'surface',
  })
})

test('normalizes palette background input forms', () => {
  assert.deepEqual(normalizeBackgroundInput('bg-red-500'), {
    kind: 'palette',
    palette: 'red',
    step: '500',
  })
  assert.deepEqual(normalizeBackgroundInput('palette:red:500'), {
    kind: 'palette',
    palette: 'red',
    step: '500',
  })
})

test('compiles palette background classes from canonical qualities', () => {
  const qualities = upsertBackgroundQuality(undefined, 'bg-red-500')

  assert.equal(resolveBackgroundInputValue(qualities), 'bg-red-500')
  assert.deepEqual(resolveBackgroundPreviewStyle(qualities), {
    background: 'var(--hc-red-500)',
  })
  assert.deepEqual(compileBackgroundClasses(qualities), ['bg-red-500'])
})

test('supports raw hex and gradient background values', () => {
  const hex = upsertBackgroundQuality(undefined, '#ffe0e0')
  assert.deepEqual(resolveBackgroundPreviewStyle(hex), {
    background: '#ffe0e0',
  })
  assert.deepEqual(compileBackgroundClasses(hex), ['bg-[#ffe0e0]'])

  const gradientValue = 'linear-gradient(90deg, red, blue)'
  const gradient = upsertBackgroundQuality(undefined, gradientValue)
  assert.deepEqual(resolveBackgroundPreviewStyle(gradient), {
    background: gradientValue,
  })
  assert.deepEqual(compileBackgroundClasses(gradient), [
    'bg-[linear-gradient(90deg,_red,_blue)]',
  ])
})

test('removes the background quality for empty input', () => {
  const qualities = upsertBackgroundQuality(undefined, 'bg-red-500')
  const next = upsertBackgroundQuality(qualities, '')

  assert.equal(next, undefined)
})

test('preserves breakpoint overrides in the compiled class list', () => {
  const base = upsertBackgroundQuality(undefined, '#ffe0e0')
  const responsive = upsertBackgroundQuality(base, 'bg-surface', 'tablet')

  assert.equal(resolveBackgroundInputValue(responsive), '#ffe0e0')
  assert.deepEqual(compileBackgroundClasses(responsive), [
    'bg-[#ffe0e0]',
    'tablet:bg-surface',
  ])
})

test('keeps the background quality definition aligned with legacy helpers', () => {
  const value = backgroundQualityDefinition.normalize('palette:red:500')

  assert.deepEqual(value, {
    kind: 'palette',
    palette: 'red',
    step: '500',
  })
  assert.equal(backgroundQualityDefinition.key, BACKGROUND_QUALITY_KEY)
  assert.equal(backgroundQualityDefinition.format(value), 'bg-red-500')
  assert.deepEqual(backgroundQualityDefinition.preview(value), {
    background: 'var(--hc-red-500)',
  })
  assert.deepEqual(backgroundQualityDefinition.compile(value, 'tablet'), [
    'tablet:bg-red-500',
  ])
})

test('supports canonical inner box background quality', () => {
  const qualities = upsertInnerBoxBackgroundQuality(undefined, '#2858ff24')

  assert.equal(resolveInnerBoxBackgroundInputValue(qualities), '#2858ff24')
  assert.deepEqual(resolveInnerBoxBackgroundPreviewStyle(qualities), {
    background: '#2858ff24',
  })
  assert.deepEqual(compileInnerBoxBackgroundClasses(qualities), [
    'bg-[#2858ff24]',
  ])
})

test('removes the inner box background quality for empty input', () => {
  const qualities = upsertInnerBoxBackgroundQuality(undefined, 'bg-surface')
  const next = upsertInnerBoxBackgroundQuality(qualities, '')

  assert.equal(next, undefined)
})

test('preserves inner box background breakpoint overrides', () => {
  const base = upsertInnerBoxBackgroundQuality(undefined, '#ffffff')
  const responsive = upsertInnerBoxBackgroundQuality(base, 'palette:blue:500', 'desktop')

  assert.equal(resolveInnerBoxBackgroundInputValue(responsive), '#ffffff')
  assert.deepEqual(compileInnerBoxBackgroundClasses(responsive), [
    'bg-[#ffffff]',
    'desktop:bg-blue-500',
  ])
})

test('keeps the inner box background quality definition aligned with helpers', () => {
  const value = innerBoxBackgroundQualityDefinition.normalize('bg-surface')

  assert.deepEqual(value, {
    kind: 'semantic-token',
    token: 'surface',
  })
  assert.equal(innerBoxBackgroundQualityDefinition.key, INNER_BOX_BACKGROUND_QUALITY_KEY)
  assert.equal(innerBoxBackgroundQualityDefinition.format(value), 'bg-surface')
  assert.deepEqual(innerBoxBackgroundQualityDefinition.preview(value), {
    background: 'var(--hc-bg-surface)',
  })
  assert.deepEqual(innerBoxBackgroundQualityDefinition.compile(value, 'mobile'), [
    'mobile:bg-surface',
  ])
})
