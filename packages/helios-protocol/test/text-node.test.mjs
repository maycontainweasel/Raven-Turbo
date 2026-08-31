import assert from 'node:assert/strict'
import test from 'node:test'
import {
  createDefaultTextContent,
  createDefaultImageContent,
  createHeliosPageManifest,
  createHeliosRecordRef,
  HELIOS_IMAGE_OBJECT_FITS,
  HELIOS_TEXT_TAGS,
  normalizeImageContentInput,
  normalizeImageObjectFit,
  normalizeTextContentInput,
  normalizeTextTag,
  upsertBackgroundQuality,
  upsertGridCellQuality,
  upsertGridContainerQuality,
} from '../src/index.ts'

test('normalizes supported text tags', () => {
  assert.equal(normalizeTextTag('h1'), 'h1')
  assert.equal(normalizeTextTag('SPAN'), 'span')
  assert.equal(normalizeTextTag('unknown'), 'p')
  assert.deepEqual([...HELIOS_TEXT_TAGS], ['p', 'span', 'div', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'])
})

test('normalizes text node content', () => {
  assert.deepEqual(normalizeTextContentInput('Hello'), {
    text: 'Hello',
    tag: 'p',
  })
  assert.deepEqual(normalizeTextContentInput({ text: 'Headline', tag: 'h2' }), {
    text: 'Headline',
    tag: 'h2',
  })
  assert.deepEqual(normalizeTextContentInput({ value: 42, tag: 'script' }), {
    text: '42',
    tag: 'p',
  })
})

test('creates default text content', () => {
  assert.deepEqual(createDefaultTextContent(), {
    text: 'Text',
    tag: 'p',
  })
})

test('normalizes image node content', () => {
  assert.equal(normalizeImageObjectFit('CONTAIN'), 'contain')
  assert.equal(normalizeImageObjectFit('unknown'), 'cover')
  assert.deepEqual([...HELIOS_IMAGE_OBJECT_FITS], ['cover', 'contain', 'fill', 'none', 'scale-down'])
  assert.deepEqual(normalizeImageContentInput({
    url: '/ets-campus.jpg',
    alt: 'ETS campus',
    fit: 'contain',
    position: 'center top',
  }), {
    src: '/ets-campus.jpg',
    alt: 'ETS campus',
    objectFit: 'contain',
    objectPosition: 'center top',
  })
  assert.deepEqual(createDefaultImageContent(), {
    src: '',
    alt: '',
    objectFit: 'cover',
    objectPosition: '50% 50%',
  })
})

test('builds a mixed frame, text, and image manifest tree', () => {
  const frameRecord = createHeliosRecordRef('helios_node', 'frame-1')
  const textRecord = createHeliosRecordRef('helios_node', 'text-1')
  const imageRecord = createHeliosRecordRef('helios_node', 'image-1')
  const frameCell = upsertGridCellQuality(undefined, {
    cols: 24,
    rows: 72,
    colStart: 1,
    colEnd: 13,
    rowStart: 1,
    rowEnd: 20,
  })
  const frameGrid = upsertGridContainerQuality(frameCell, {
    cols: 24,
    rows: 24,
  })
  const frameQualities = upsertBackgroundQuality(frameGrid, '#ffffff')
  const textQualities = upsertGridCellQuality(undefined, {
    cols: 24,
    rows: 24,
    colStart: 2,
    colEnd: 12,
    rowStart: 3,
    rowEnd: 5,
  })
  const imageQualities = upsertGridCellQuality(undefined, {
    cols: 24,
    rows: 24,
    colStart: 13,
    colEnd: 23,
    rowStart: 3,
    rowEnd: 12,
  })

  const manifest = createHeliosPageManifest({
    pageId: 'page:home',
    cols: 24,
    rows: 72,
    canvasHeight: 2304,
    nodes: [
      {
        id: frameRecord.key,
        record: frameRecord,
        parent: null,
        parentId: null,
        documentId: 'page:home',
        zoneId: 'home-main',
        kind: 'frame',
        order: 1,
        label: 'Frame 1',
        qualities: frameQualities,
      },
      {
        id: textRecord.key,
        record: textRecord,
        parent: frameRecord,
        parentId: frameRecord.key,
        documentId: 'page:home',
        zoneId: 'home-main',
        kind: 'text',
        order: 1,
        label: 'Text 1',
        content: {
          text: 'Hello Helios',
          tag: 'h2',
        },
        qualities: textQualities,
      },
      {
        id: imageRecord.key,
        record: imageRecord,
        parent: frameRecord,
        parentId: frameRecord.key,
        documentId: 'page:home',
        zoneId: 'home-main',
        kind: 'image',
        order: 2,
        label: 'Image 1',
        content: {
          src: '/images/ets-hero.jpg',
          alt: 'ETS hero image',
          objectFit: 'contain',
          objectPosition: 'center top',
        },
        qualities: imageQualities,
      },
    ],
  })

  assert.equal(manifest.pageId, 'page:home')
  assert.deepEqual(manifest.canvas.classes, [
    'page',
    'canvas',
    'min-h-100vh',
    'h-[2304px]',
    'grid',
    'grid-cols-24',
    'grid-rows-72',
  ])
  assert.equal(manifest.nodes.length, 1)
  assert.equal(manifest.nodes[0].kind, 'frame')
  assert.deepEqual(manifest.nodes[0].outerClasses, [
    'h-frame',
    'h-frame-layer',
    'col-start-1',
    'col-end-13',
    'row-start-1',
    'row-end-20',
    'bg-[#ffffff]',
  ])
  assert.equal(manifest.nodes[0].children.length, 2)
  assert.deepEqual(manifest.nodes[0].children[0], {
    id: textRecord.key,
    subId: textRecord.display,
    kind: 'text',
    label: 'Text 1',
    dataHeliosNode: textRecord.key,
    tag: 'h2',
    text: 'Hello Helios',
    classes: [
      'h-text',
      'col-start-2',
      'col-end-12',
      'row-start-3',
      'row-end-5',
    ],
  })
  assert.deepEqual(manifest.nodes[0].children[1], {
    id: imageRecord.key,
    subId: imageRecord.display,
    kind: 'image',
    label: 'Image 1',
    dataHeliosNode: imageRecord.key,
    src: '/images/ets-hero.jpg',
    alt: 'ETS hero image',
    objectFit: 'contain',
    objectPosition: 'center top',
    classes: [
      'h-image',
      'col-start-13',
      'col-end-23',
      'row-start-3',
      'row-end-12',
    ],
  })
})

test('preserves long canvas rows in manifest output', () => {
  const manifest = createHeliosPageManifest({
    pageId: 'page:long',
    cols: 24,
    rows: 240,
    canvasHeight: 7680,
    nodes: [],
  })

  assert.deepEqual(manifest.canvas.classes, [
    'page',
    'canvas',
    'min-h-100vh',
    'h-[7680px]',
    'grid',
    'grid-cols-24',
    'grid-rows-240',
  ])
})
