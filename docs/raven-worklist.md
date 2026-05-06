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
- Review the July 2025 FNB fee cluster, including the unlabeled rows on `20 Jun`, `24 Jun`, `1 Jul`, `15 Jul`, and the month-end fee lines on `18 Jul`.
- Review the June 2025 FNB fee cluster, including the unlabeled rows on `19 May`, `20 May`, `27 May`, `12 Jun`, and the month-end fee lines on `18 Jun`.
- Verify the September 2025 `Takealot` credit-card order for `R2,459.00`.
- Identify the September 2025 unknown credit-card merchants:
  - `Bex Paarl`
  - `C*Smw 0751 Paarl`
- Identify the August 2025 unknown credit-card merchant cluster:
  - `Alana Banana Pty Ltd`
- Decide whether to promote the personal fixed deposit / JustInvest flow into its own first-class account in the personal environment.
- Identify the July 2025 unknown holiday merchant:
  - `Bakerlux Ltd`
- Identify the June 2025 client behind `Inv-127566`.
- Identify the June 2025 personal credit merchant:
  - `Yoco *John Martin Ph`
- Identify the June 2025 personal credit merchant cluster:
  - `Bk 3 Arts Dt U`
- Identify the May 2025 business merchant:
  - `Pp*Fsprg.Com`
- Identify the May 2025 business merchant:
  - `Pp*Pad`
- Confirm the May 2025 personal-current transfer destination for the `R3,650.00` transfer on `2 May`.
- Identify the May 2025 personal-credit merchant cluster:
  - `Aegir Project`
- Identify the May 2025 personal-credit spend behind:
  - `Valley Motors` `R167.50`
  - `Squirrel Games` `R250.00`
  - `Takealot` `R425.00`
- Review the April 2025 FNB fee cluster, including the unlabeled rows on `19 Mar`, `24 Mar`, `27 Mar`, `28 Mar`, `4 Apr`, `5 Apr`, `15 Apr`, and the month-end fee lines on `17 Apr`.
- Identify the April 2025 personal-credit merchants:
  - `Yoco *La Concorde So` `R610.00`
  - `Kalahari Slate Waterfront` `R110.00`
  - `Paypal *Paddle.Net` `R1,274.31`
- Verify the April 2025 `Takealot` credit-card order for `R374.00`.

## Data Backlog

- Continue importing statements backwards across business current, personal current, personal credit, and savings.
- Add the business savings account once statements or account details are available.
- Add the UK account and Wise-linked foreign-account flows once the account details are available.
- Backfill missing early-2025 credit-card statements if they can be found locally.
- Break down bundled hosting payments like Elitehost into the underlying services when you are ready to model subscription components.

## Product Tasks

- Build a recurring-payments and subscriptions view in the present dashboard.
- Track billing cycle, expected due date, last seen date, and amount range for recurring merchants.
- Seed the recurring-payments view with `Afrihost` as a mobile phone contract that is currently being paid personally.
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
