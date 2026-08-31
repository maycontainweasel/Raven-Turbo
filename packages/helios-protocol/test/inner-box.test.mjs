import test from 'node:test'
import assert from 'node:assert/strict'

import {
  INNER_BOX_QUALITY_KEY,
  compileInnerBoxClasses,
  formatInnerBoxValue,
  getInnerBoxValue,
  innerBoxQualityDefinition,
  normalizeInnerBoxInput,
  resolveInnerBoxPreviewStyle,
  upsertInnerBoxQuality,
} from '../src/index.ts'

test('normalizes inner box values', () => {
  assert.deepEqual(normalizeInnerBoxInput({
    mode: 'inset',
    snapTo: 'rhythm-grid',
    insetTop: 2,
    insetRight: '3',
    insetBottom: -1,
    insetLeft: '',
    centerX: true,
  }), {
    mode: 'inset',
    snapTo: 'rhythm-grid',
    insetTop: 2,
    insetRight: 3,
    insetBottom: 0,
    centerX: true,
  })

  assert.deepEqual(normalizeInnerBoxInput('container'), {
    mode: 'container',
    snapTo: 'division-grid',
  })
})

test('upserts and reads inner box qualities', () => {
  const qualities = upsertInnerBoxQuality(undefined, {
    mode: 'container',
    snapTo: 'division-grid',
    maxWidth: '64rem',
    centerX: true,
  })

  assert.equal(formatInnerBoxValue(getInnerBoxValue(qualities)), 'container:division-grid')
  assert.deepEqual(getInnerBoxValue(qualities), {
    mode: 'container',
    snapTo: 'division-grid',
    maxWidth: '64rem',
    centerX: true,
  })
})

test('compiles conservative inner box classes', () => {
  const qualities = upsertInnerBoxQuality(undefined, {
    mode: 'container',
    snapTo: 'division-grid',
    maxWidth: '64rem',
    centerX: true,
    insetTop: 2,
    insetRight: 4,
  })

  assert.deepEqual(compileInnerBoxClasses(qualities), [
    'mx-auto',
    'max-w-[64rem]',
    'pt-[2%]',
    'pr-[4%]',
  ])
})

test('compiles numeric inner box max width with a px unit', () => {
  const qualities = upsertInnerBoxQuality(undefined, {
    mode: 'container',
    snapTo: 'division-grid',
    maxWidth: 300,
    centerX: true,
  })

  assert.deepEqual(compileInnerBoxClasses(qualities), [
    'mx-auto',
    'max-w-[300px]',
  ])
  assert.deepEqual(resolveInnerBoxPreviewStyle({
    mode: 'container',
    snapTo: 'division-grid',
    maxWidth: 300,
    centerX: true,
  }), {
    marginLeft: 'auto',
    marginRight: 'auto',
    maxWidth: '300px',
  })
})

test('compiles rhythm-grid inner box insets against the Atomic grid unit', () => {
  const qualities = upsertInnerBoxQuality(undefined, {
    mode: 'inset',
    snapTo: 'rhythm-grid',
    insetTop: 2,
  })

  assert.deepEqual(compileInnerBoxClasses(qualities), [
    'pt-[calc(var(--h-gu)_*_2)]',
  ])
})

test('previews rhythm-grid inner box insets', () => {
  assert.deepEqual(resolveInnerBoxPreviewStyle({
    mode: 'inset',
    snapTo: 'rhythm-grid',
    insetTop: 2,
    insetLeft: 3,
    maxWidth: '80%',
    centerX: true,
  }), {
    paddingTop: 'calc(var(--h-gu, 1.4rem) * 2)',
    paddingLeft: 'calc(var(--h-gu, 1.4rem) * 3)',
    marginLeft: 'auto',
    marginRight: 'auto',
    maxWidth: '80%',
  })
})

test('exposes inner box quality definition', () => {
  assert.equal(innerBoxQualityDefinition.key, INNER_BOX_QUALITY_KEY)
  assert.deepEqual(innerBoxQualityDefinition.normalize({ mode: 'none', snapTo: 'division-grid' }), {
    mode: 'none',
    snapTo: 'division-grid',
  })
  assert.equal(innerBoxQualityDefinition.format({ mode: 'none', snapTo: 'division-grid' }), 'none:division-grid')
  assert.deepEqual(innerBoxQualityDefinition.compile({ mode: 'none', snapTo: 'division-grid' }, 'base'), [])
})
