import { RavenDomainError } from './errors.js'

declare const minorUnitsBrand: unique symbol
export type MinorUnits = number & { readonly [minorUnitsBrand]: true }

export type MoneyWire = Readonly<{
  currency: string
  minorUnits: number
}>

const currencyExponents: Readonly<Record<string, number>> = {
  ZAR: 2,
}

export function currencyExponent(currency: string): number {
  const normalized = currency.trim().toUpperCase()
  const exponent = currencyExponents[normalized]
  if (exponent === undefined) {
    throw new RavenDomainError('UNSUPPORTED_CURRENCY', `Unsupported currency: ${currency}`)
  }
  return exponent
}

export function minorUnits(value: number, options: { nonNegative?: boolean } = {}): MinorUnits {
  if (!Number.isSafeInteger(value)) {
    throw new RavenDomainError('INVALID_MONEY', 'Money minor units must be a safe integer')
  }
  if (options.nonNegative && value < 0) {
    throw new RavenDomainError('INVALID_MONEY', 'Money amount must not be negative')
  }
  return value as MinorUnits
}

export function money(input: MoneyWire, options: { nonNegative?: boolean } = {}): MoneyWire {
  const currency = input.currency.trim().toUpperCase()
  currencyExponent(currency)
  return {
    currency,
    minorUnits: minorUnits(input.minorUnits, options),
  }
}

export function parseDecimalMoney(input: string, currency: string): MoneyWire {
  const normalizedCurrency = currency.trim().toUpperCase()
  const exponent = currencyExponent(normalizedCurrency)
  const value = input.trim().replace(/\s/g, '').replace(/,/g, '')
  const match = /^([+-]?)(\d+)(?:\.(\d+))?$/.exec(value)
  if (!match) {
    throw new RavenDomainError('INVALID_MONEY', 'Enter a valid decimal amount')
  }

  const sign = match[1] === '-' ? -1 : 1
  const whole = match[2] ?? '0'
  const fraction = match[3] ?? ''
  if (fraction.length > exponent && /[1-9]/.test(fraction.slice(exponent))) {
    throw new RavenDomainError(
      'INVALID_MONEY',
      `${normalizedCurrency} supports at most ${exponent} decimal places`,
    )
  }

  const paddedFraction = fraction.slice(0, exponent).padEnd(exponent, '0')
  const scale = BigInt(10) ** BigInt(exponent)
  const exact = BigInt(whole) * scale + BigInt(paddedFraction || '0')
  const signed = exact * BigInt(sign)
  const numeric = Number(signed)
  return money({ currency: normalizedCurrency, minorUnits: numeric })
}

function assertSameCurrency(left: MoneyWire, right: MoneyWire): string {
  const leftMoney = money(left)
  const rightMoney = money(right)
  if (leftMoney.currency !== rightMoney.currency) {
    throw new RavenDomainError('CURRENCY_MISMATCH', 'Money values use different currencies')
  }
  return leftMoney.currency
}

export function addMoney(left: MoneyWire, right: MoneyWire): MoneyWire {
  const currency = assertSameCurrency(left, right)
  return money({ currency, minorUnits: left.minorUnits + right.minorUnits })
}

export function subtractMoney(left: MoneyWire, right: MoneyWire): MoneyWire {
  const currency = assertSameCurrency(left, right)
  return money({ currency, minorUnits: left.minorUnits - right.minorUnits })
}

export function zeroMoney(currency: string): MoneyWire {
  return money({ currency, minorUnits: 0 })
}

export function formatMoney(value: MoneyWire, locale = 'en-ZA'): string {
  const exact = money(value)
  const exponent = currencyExponent(exact.currency)
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency: exact.currency,
    minimumFractionDigits: exponent,
    maximumFractionDigits: exponent,
  }).format(exact.minorUnits / 10 ** exponent)
}
