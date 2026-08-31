import test from 'node:test'
import assert from 'node:assert/strict'

import {
  DEFAULT_FRAME_GRID,
  GRID_CELL_QUALITY_KEY,
  GRID_CONTAINER_QUALITY_KEY,
  compileGridCellClasses,
  compileGridContainerClasses,
  createDefaultFrameGrid,
  gridCellQualityDefinition,
  gridContainerQualityDefinition,
  normalizeGridCellInput,
  normalizeGridContainerInput,
  resolveGridPreviewRect,
  upsertGridCellQuality,
  upsertGridContainerQuality,
} from '../src/index.ts'

test('normalizes grid container values', () => {
  assert.deepEqual(normalizeGridContainerInput({ cols: 24, rows: 24 }), {
    mode: 'division',
    cols: 24,
    rows: 24,
    unit: 'fr',
  })
  assert.deepEqual(normalizeGridContainerInput('64x32'), {
    mode: 'division',
    cols: 64,
    rows: 32,
    unit: 'fr',
  })
  assert.deepEqual(normalizeGridContainerInput({ grid: { cols: 256, rows: -4 } }), {
    mode: 'division',
    cols: 96,
    rows: 1,
    unit: 'fr',
  })
  assert.deepEqual(normalizeGridContainerInput({ mode: 'rhythm', cols: 12, rows: 18 }), {
    mode: 'rhythm',
    cols: 12,
    rows: 18,
    unit: 'gu',
  })
})

test('keeps default frame grid independent from canvas tapestry rows', () => {
  const canvasPlacementCell = normalizeGridCellInput({
    cols: 24,
    rows: 72,
    colStart: 1,
    colEnd: 25,
    rowStart: 1,
    rowEnd: 25,
  })
  const frameGrid = createDefaultFrameGrid()

  assert.deepEqual(DEFAULT_FRAME_GRID, {
    mode: 'division',
    cols: 24,
    rows: 24,
    unit: 'fr',
  })
  assert.deepEqual(frameGrid, DEFAULT_FRAME_GRID)
  assert.equal(canvasPlacementCell?.rows, 72)
  assert.equal(frameGrid.rows, 24)
})

test('normalizes grid cell values and legacy layout shape', () => {
  assert.deepEqual(normalizeGridCellInput({
    cols: 24,
    rows: 24,
    colStart: 1,
    colEnd: 13,
    rowStart: 1,
    rowEnd: 20,
  }), {
    cols: 24,
    rows: 24,
    colStart: 1,
    colEnd: 13,
    rowStart: 1,
    rowEnd: 20,
  })

  assert.deepEqual(normalizeGridCellInput({
    grid: { cols: 24, rows: 24 },
    cell: {
      topLeft: { col: 0, row: 0 },
      topRight: { col: 30 },
      bottomLeft: { row: 30 },
    },
  }), {
    cols: 24,
    rows: 24,
    colStart: 1,
    colEnd: 25,
    rowStart: 1,
    rowEnd: 25,
  })
})

test('compiles rhythm grid container qualities', () => {
  const container = upsertGridContainerQuality(undefined, { mode: 'rhythm', cols: 12, rows: 18 })

  assert.deepEqual(compileGridContainerClasses(container), [
    'grid',
    'grid-cols-[repeat(12,var(--h-gu))]',
    'grid-rows-[repeat(18,var(--h-gu))]',
  ])
  assert.deepEqual(gridContainerQualityDefinition.preview({ mode: 'rhythm', cols: 12, rows: 18 }), {
    gridTemplateColumns: 'repeat(12, var(--h-gu, 1.4rem))',
    gridTemplateRows: 'repeat(18, var(--h-gu, 1.4rem))',
  })
})

test('compiles grid container and cell qualities', () => {
  const container = upsertGridContainerQuality(undefined, { cols: 24, rows: 24 })
  const cell = upsertGridCellQuality(undefined, {
    cols: 24,
    rows: 24,
    colStart: 1,
    colEnd: 13,
    rowStart: 1,
    rowEnd: 20,
  })

  assert.deepEqual(compileGridContainerClasses(container), [
    'grid',
    'grid-cols-24',
    'grid-rows-24',
  ])
  assert.deepEqual(compileGridCellClasses(cell), [
    'col-start-1',
    'col-end-13',
    'row-start-1',
    'row-end-20',
  ])
})

test('compiles breakpoint grid qualities after base classes', () => {
  const base = upsertGridCellQuality(undefined, {
    cols: 24,
    rows: 24,
    colStart: 1,
    colEnd: 13,
    rowStart: 1,
    rowEnd: 20,
  })
  const responsive = upsertGridCellQuality(base, {
    cols: 24,
    rows: 24,
    colStart: 3,
    colEnd: 21,
    rowStart: 2,
    rowEnd: 12,
  }, 'tablet')

  assert.deepEqual(compileGridCellClasses(responsive), [
    'col-start-1',
    'col-end-13',
    'row-start-1',
    'row-end-20',
    'tablet:col-start-3',
    'tablet:col-end-21',
    'tablet:row-start-2',
    'tablet:row-end-12',
  ])
})

test('reads canonical grid qualities before legacy layout values', () => {
  const qualities = upsertGridCellQuality(undefined, {
    cols: 24,
    rows: 24,
    colStart: 1,
    colEnd: 13,
    rowStart: 1,
    rowEnd: 20,
  })
  const legacy = {
    grid: { cols: 24, rows: 24 },
    cell: {
      colStart: 5,
      colEnd: 7,
      rowStart: 5,
      rowEnd: 7,
    },
  }

  assert.deepEqual(compileGridCellClasses(qualities, legacy), [
    'col-start-1',
    'col-end-13',
    'row-start-1',
    'row-end-20',
  ])
  assert.deepEqual(compileGridCellClasses(undefined, legacy), [
    'col-start-5',
    'col-end-7',
    'row-start-5',
    'row-end-7',
  ])
})

test('exposes grid quality definitions and preview rects', () => {
  const cell = normalizeGridCellInput({
    cols: 24,
    rows: 24,
    colStart: 1,
    colEnd: 13,
    rowStart: 1,
    rowEnd: 13,
  })

  assert.equal(gridContainerQualityDefinition.key, GRID_CONTAINER_QUALITY_KEY)
  assert.equal(gridCellQualityDefinition.key, GRID_CELL_QUALITY_KEY)
  assert.deepEqual(gridContainerQualityDefinition.compile({ cols: 12, rows: 8 }, 'base'), [
    'grid',
    'grid-cols-12',
    'grid-rows-8',
  ])
  assert.deepEqual(resolveGridPreviewRect(cell), {
    left: '0%',
    top: '0%',
    width: '50%',
    height: '50%',
  })
})
