# Fictional Statement Import

Source:
- `fictional-statement.pdf`

Account:
- Fictional Daily Account

Statement period:
- `2026-07-01` to `2026-07-31`

Opening balance: `1000.00`
Closing balance: `1100.00`
Environment key: `fictional-space`
Environment name: `Fictional Space`
Environment type: `personal`
Environment currency: `ZAR`
Environment description: `Disposable statement renderer fixture`
Account key: `fictional-daily`
Account name: `Fictional Daily Account`
Account bank: `Example Bank`
Account type: `current`
Account currency: `ZAR`
Account last4: `0000`
Import key: `fictional-2026-07`

## Import Sheet

| row_no | date | raw_row_text | transaction_type | normalized_merchant | category | fee_type | amount_zar | bank_charge_zar | balance_zar | clarification_status | notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 02 Jul | Fictional incoming payment | income | Fictional Payer | Income |  | 123.45 |  | 1123.45 | clarified |  |
| 2 | 03 Jul | Fictional purchase | expense | Fictional Shop | General |  | 20.05 |  | 1103.40 | clarified |  |
| 3 | 04 Jul | Fictional account movement | transfer |  | Transfer |  | 10.00 |  | 1093.40 | matched | Flow is not proven |
| 4 | 05 Jul | Fictional malformed movement | mystery |  | Review |  | 6.78 |  | 1086.62 | matched | Direction is deliberately unknown |

## Notes

Disposable fictional fixture. It contains no private financial data.
