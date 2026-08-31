# Ingest

Ingest is the canonical process for bringing a prompt/response pair or other source into this Brain.

## Modes

- `backfill`: historical source that predates the Brain.
- `external-validation`: a current external AI review or validation pass.
- `live-capture`: a current conversation or agent session.
- `pre-work-primer`: source material loaded before beginning work.

## Raw Source Format

```md
# Raw Brain Ingest Source - <SOURCE_ID>

## Metadata

- Source id:
- Project:
- Mode:
- Source kind: chatgpt-5.5-pro-prompt-response-pair
- Source date:
- Ingest date:
- Status: raw source preserved verbatim

## Human Prompt - Verbatim

[paste prompt exactly]

## Assistant Response - Verbatim

[paste response exactly]

## Human Notes

[optional]
```

## Brain Patch Requirements

End with sources ingested, files created, identity changes, tenets changed, vision deltas, decisions, open loops, opportunities, Orbit sync candidates, and routine items intentionally ignored.
