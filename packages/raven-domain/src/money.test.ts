import assert from 'node:assert/strict'
import test from 'node:test'
import { RavenDomainError } from './errors.js'
import { addMoney, parseDecimalMoney } from './money.js'

test('parses ZAR without floating point arithmetic', () => {
  assert.deepEqual(parseDecimalMoney('123.45', 'ZAR'), { currency: 'ZAR', minorUnits: 12345 })
  assert.deepEqual(parseDecimalMoney('1,000.00', 'zar'), { currency: 'ZAR', minorUnits: 100000 })
})

test('rejects unsupported precision and unsafe range', () => {
  assert.throws(() => parseDecimalMoney('1.001', 'ZAR'), (error) => error instanceof RavenDomainError)
  assert.throws(
    () => parseDecimalMoney('900719925474099.99', 'ZAR'),
    (error) => error instanceof RavenDomainError,
  )
})

test('rejects arithmetic overflow and currency mismatch', () => {
  assert.throws(
    () => addMoney({ currency: 'ZAR', minorUnits: Number.MAX_SAFE_INTEGER }, { currency: 'ZAR', minorUnits: 1 }),
    (error) => error instanceof RavenDomainError,
  )
  assert.throws(
    () => addMoney({ currency: 'ZAR', minorUnits: 1 }, { currency: 'USD', minorUnits: 1 }),
    (error) => error instanceof RavenDomainError,
  )
})
