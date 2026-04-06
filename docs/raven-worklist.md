# Raven Worklist

## Open Review

- Identify the underlying service behind the December 2025 `PayPal *Help` charge for `R520.27`.
- Inspect the unlabeled FNB fee rows from 27 Nov and 9 Dec to understand what FNB is charging for and why.
- Identify the unknown `Alana Banana` credit-card merchant from January 2026.

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
