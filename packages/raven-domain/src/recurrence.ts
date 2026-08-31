import { RavenDomainError } from './errors.js'

export type CashflowCadence = 'once' | 'weekly' | 'monthly' | 'quarterly' | 'yearly'

export const MAX_CASHFLOW_HORIZON_DAYS = 1_831

export type RecurrenceSpec = Readonly<{
  cadence: CashflowCadence
  interval: number
  startDate: string
  endDate?: string | null
  onceDueOn?: string | null
  dayOfWeek?: number | null
  dayOfMonth?: number | null
  monthOfYear?: number | null
  timezone: string
}>

const DATE_PATTERN = /^(\d{4})-(\d{2})-(\d{2})$/

export function parseFinancialDate(value: string): { year: number; month: number; day: number } {
  const match = DATE_PATTERN.exec(value)
  if (!match) throw new RavenDomainError('INVALID_CASHFLOW_DATE_RANGE', 'Cashflow dates must use YYYY-MM-DD')
  const year = Number(match[1])
  const month = Number(match[2])
  const day = Number(match[3])
  if (month < 1 || month > 12 || day < 1 || day > daysInMonth(year, month)) {
    throw new RavenDomainError('INVALID_CASHFLOW_DATE_RANGE', 'Cashflow date is not a valid calendar date')
  }
  return { year, month, day }
}

export function isValidTimeZone(value: string): boolean {
  try {
    new Intl.DateTimeFormat('en-ZA', { timeZone: value }).format()
    return true
  } catch {
    return false
  }
}

function daysInMonth(year: number, month: number): number {
  return new Date(Date.UTC(year, month, 0)).getUTCDate()
}

function formatDate(year: number, month: number, day: number): string {
  return `${String(year).padStart(4, '0')}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`
}

function epochDay(value: string): number {
  const { year, month, day } = parseFinancialDate(value)
  return Math.floor(Date.UTC(year, month - 1, day) / 86_400_000)
}

function fromEpochDay(value: number): string {
  const date = new Date(value * 86_400_000)
  return formatDate(date.getUTCFullYear(), date.getUTCMonth() + 1, date.getUTCDate())
}

function monthCandidate(start: { year: number; month: number }, offset: number, configuredDay: number): string {
  const absoluteMonth = start.year * 12 + start.month - 1 + offset
  const year = Math.floor(absoluteMonth / 12)
  const month = absoluteMonth - year * 12 + 1
  return formatDate(year, month, Math.min(configuredDay, daysInMonth(year, month)))
}

export function validateRecurrence(spec: RecurrenceSpec): RecurrenceSpec {
  parseFinancialDate(spec.startDate)
  if (spec.endDate) {
    parseFinancialDate(spec.endDate)
    if (spec.endDate < spec.startDate) {
      throw new RavenDomainError('INVALID_CASHFLOW_DATE_RANGE', 'Cashflow end date precedes start date')
    }
  }
  if (!Number.isSafeInteger(spec.interval) || spec.interval < 1) {
    throw new RavenDomainError('INVALID_RECURRENCE', 'Recurrence interval must be a positive safe integer')
  }
  if (!isValidTimeZone(spec.timezone)) {
    throw new RavenDomainError('INVALID_RECURRENCE', 'Cashflow timezone must be a valid IANA timezone')
  }
  if (spec.cadence === 'once') {
    if (!spec.onceDueOn) throw new RavenDomainError('INVALID_RECURRENCE', 'One-off cashflow requires a due date')
    parseFinancialDate(spec.onceDueOn)
    if (spec.onceDueOn < spec.startDate || (spec.endDate && spec.onceDueOn > spec.endDate)) {
      throw new RavenDomainError('INVALID_CASHFLOW_DATE_RANGE', 'One-off due date must fall within the schedule date range')
    }
  }
  if (spec.cadence === 'weekly' && (!Number.isInteger(spec.dayOfWeek) || spec.dayOfWeek! < 1 || spec.dayOfWeek! > 7)) {
    throw new RavenDomainError('INVALID_RECURRENCE', 'Weekly recurrence requires ISO weekday 1 through 7')
  }
  if ((spec.cadence === 'monthly' || spec.cadence === 'quarterly')
    && (!Number.isInteger(spec.dayOfMonth) || spec.dayOfMonth! < 1 || spec.dayOfMonth! > 31)) {
    throw new RavenDomainError('INVALID_RECURRENCE', 'Monthly recurrence requires day 1 through 31')
  }
  if (spec.cadence === 'yearly') {
    if (!Number.isInteger(spec.monthOfYear) || spec.monthOfYear! < 1 || spec.monthOfYear! > 12) {
      throw new RavenDomainError('INVALID_RECURRENCE', 'Yearly recurrence requires month 1 through 12')
    }
    if (!Number.isInteger(spec.dayOfMonth) || spec.dayOfMonth! < 1 || spec.dayOfMonth! > 31) {
      throw new RavenDomainError('INVALID_RECURRENCE', 'Yearly recurrence requires day 1 through 31')
    }
  }
  return spec
}

export function generateRecurrenceDates(
  input: RecurrenceSpec,
  through: string,
  from: string = input.startDate,
  limit = 2_000,
): string[] {
  const spec = validateRecurrence(input)
  parseFinancialDate(from)
  parseFinancialDate(through)
  if (from > through) return []
  const lower = [spec.startDate, from].sort().at(-1)!
  const upper = spec.endDate && spec.endDate < through ? spec.endDate : through
  if (lower > upper) return []
  const values: string[] = []
  const include = (value: string) => {
    if (value >= lower && value <= upper) values.push(value)
    if (values.length > limit) throw new RavenDomainError('INVALID_CASHFLOW_DATE_RANGE', 'Recurrence horizon is too large')
  }

  if (spec.cadence === 'once') {
    include(spec.onceDueOn!)
    return [...new Set(values)]
  }

  if (spec.cadence === 'weekly') {
    const startDay = epochDay(spec.startDate)
    const startWeekday = ((startDay + 3) % 7 + 7) % 7 + 1
    let candidate = startDay + ((spec.dayOfWeek! - startWeekday + 7) % 7)
    const endDay = epochDay(upper)
    while (candidate <= endDay) {
      include(fromEpochDay(candidate))
      candidate += spec.interval * 7
    }
    return [...new Set(values)]
  }

  const start = parseFinancialDate(spec.startDate)
  if (spec.cadence === 'monthly' || spec.cadence === 'quarterly') {
    const step = spec.interval * (spec.cadence === 'quarterly' ? 3 : 1)
    for (let offset = 0; ; offset += step) {
      const candidate = monthCandidate(start, offset, spec.dayOfMonth!)
      if (candidate > upper) break
      include(candidate)
    }
    return [...new Set(values)]
  }

  for (let offset = 0; ; offset += spec.interval) {
    const year = start.year + offset
    const month = spec.monthOfYear!
    const candidate = formatDate(year, month, Math.min(spec.dayOfMonth!, daysInMonth(year, month)))
    if (candidate > upper) break
    include(candidate)
  }
  return [...new Set(values)]
}

export function addCalendarMonths(value: string, months: number): string {
  const date = parseFinancialDate(value)
  return monthCandidate(date, months, date.day)
}

export function endOfMonth(value: string): string {
  const { year, month } = parseFinancialDate(value)
  return formatDate(year, month, daysInMonth(year, month))
}

export function addCalendarDays(value: string, days: number): string {
  return fromEpochDay(epochDay(value) + days)
}

export function calendarDayDistance(from: string, through: string): number {
  return epochDay(through) - epochDay(from)
}
