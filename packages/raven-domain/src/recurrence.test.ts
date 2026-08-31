import assert from 'node:assert/strict'
import test from 'node:test'
import { generateRecurrenceDates, isValidTimeZone } from './recurrence.js'

const base = { interval: 1, startDate: '2026-01-01', timezone: 'Africa/Johannesburg' }

test('once generates one bounded occurrence without UTC date drift', () => {
  assert.deepEqual(generateRecurrenceDates({ ...base, cadence: 'once', onceDueOn: '2026-01-31' }, '2026-12-31'), ['2026-01-31'])
})

test('weekly recurrence respects ISO weekday and interval', () => {
  assert.deepEqual(generateRecurrenceDates({ ...base, cadence: 'weekly', interval: 2, dayOfWeek: 1 }, '2026-02-01'), ['2026-01-05', '2026-01-19'])
})

test('monthly day 31 clamps and returns to the configured day', () => {
  assert.deepEqual(generateRecurrenceDates({ ...base, cadence: 'monthly', dayOfMonth: 31 }, '2026-04-30'), ['2026-01-31', '2026-02-28', '2026-03-31', '2026-04-30'])
})

test('quarterly recurrence advances by three calendar months', () => {
  assert.deepEqual(generateRecurrenceDates({ ...base, cadence: 'quarterly', dayOfMonth: 30 }, '2026-10-31'), ['2026-01-30', '2026-04-30', '2026-07-30', '2026-10-30'])
})

test('yearly February 29 clamps and returns in a leap year', () => {
  assert.deepEqual(generateRecurrenceDates({ ...base, cadence: 'yearly', startDate: '2024-01-01', monthOfYear: 2, dayOfMonth: 29 }, '2028-12-31'), ['2024-02-29', '2025-02-28', '2026-02-28', '2027-02-28', '2028-02-29'])
})

test('start and end boundaries exclude dates outside the accepted rule', () => {
  assert.deepEqual(generateRecurrenceDates({ ...base, cadence: 'monthly', startDate: '2026-01-15', endDate: '2026-03-15', dayOfMonth: 10 }, '2026-12-31'), ['2026-02-10', '2026-03-10'])
})

test('invalid recurrence and timezone are rejected', () => {
  assert.equal(isValidTimeZone('Africa/Johannesburg'), true)
  assert.equal(isValidTimeZone('Not/AZone'), false)
  assert.throws(() => generateRecurrenceDates({ ...base, cadence: 'monthly', dayOfMonth: 0 }, '2026-12-31'))
  assert.throws(() => generateRecurrenceDates({ ...base, cadence: 'weekly', dayOfWeek: 8 }, '2026-12-31'))
  assert.throws(() => generateRecurrenceDates({ ...base, cadence: 'once', onceDueOn: '2026-02-30' }, '2026-12-31'))
})

test('generation through the same horizon is deterministic and duplicate free', () => {
  const spec = { ...base, cadence: 'monthly' as const, dayOfMonth: 15 }
  const first = generateRecurrenceDates(spec, '2026-06-30')
  assert.deepEqual(generateRecurrenceDates(spec, '2026-06-30'), first)
  assert.equal(new Set(first).size, first.length)
})
