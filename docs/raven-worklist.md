# Raven Worklist

## Open Review

- Identify the underlying service behind the December 2025 `PayPal *Help` charge for `R520.27`.
- Inspect the unlabeled FNB fee rows from 27 Nov and 9 Dec to understand what FNB is charging for and why.
- Identify the unknown `Alana Banana` credit-card merchant from January 2026.
- Identify the October 2025 unknown credit-card merchants:
  - `Sunset B51000002213225 Western Cape Za`
  - `Vsa_Inner-Theliven.Com Limassol Cy`
  - `Pbrands Warsaw`
- Review the October 2025 FNB fee cluster, including the `R123.80` row on `18 Oct`.
- Review the September 2025 FNB fee cluster, including the unlabeled rows on `23 Aug`, `2 Sep`, `17 Sep`, and the `18 Sep` month-end fee lines.
- Review the August 2025 FNB fee cluster, including the unlabeled rows on `22 Jul`, `23 Jul`, `24 Jul`, and the month-end fee lines on `18 Aug`.
- Verify the September 2025 `Takealot` credit-card order for `R2,459.00`.
- Identify the September 2025 unknown credit-card merchants:
  - `Bex Paarl`
  - `C*Smw 0751 Paarl`
- Identify the August 2025 unknown credit-card merchant cluster:
  - `Alana Banana Pty Ltd`

## Data Backlog

- Continue importing statements backwards across business current, personal current, personal credit, and savings.
- Add the business savings account once statements or account details are available.
- Add the UK account and Wise-linked foreign-account flows once the account details are available.
- Backfill missing early-2025 credit-card statements if they can be found locally.
- Break down bundled hosting payments like Elitehost into the underlying services when you are ready to model subscription components.

## Product Tasks

- Build a recurring-payments and subscriptions view in the present dashboard.
- Track billing cycle, expected due date, last seen date, and amount range for recurring merchants.
- Add a lightweight task or follow-up model in the app so transactions and investigations can create actionable items.
- Add editable clarification actions in the UI so categories and merchant mappings can be resolved directly from the queue.
- Add support for modeling business-to-personal transfers explicitly rather than folding them into generic internal transfers.

## Early Recurring Candidates

- Trade Travel Chill
- OpenAI
- Google Workspace
- Atlassian
- Afrihost
- Elitehost
- Spotify
- Audible
- Showmax
- Notion
- IVE Cloud
- Vecteezy
- Screencast-O-Matic

## Notes

- Keep fees granular at import time and roll them up in reporting.
- Keep transfers separate from true income and true spending.
- Preserve raw statement wording even when the normalized meaning changes later.
- The `R6.00` FNB fee pattern can represent an insufficient-funds charge when the account could not cover a card attempt.
