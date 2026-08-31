# Agent Protocol

## Brainkeeper Live

Capture current conversations into raw sessions and distillations. Do not implement code.

## Brainkeeper Ingest

Preserve prompt/response pairs and other source material using `brain/INGEST.md`. Route material through backfill, external-validation, live-capture, or pre-work-primer modes. Extract identity, tenets, opportunities, decisions, open loops, questions, risks, repeated themes, and Orbit sync candidates. Do not implement code.

## Brain Assist Mode

Capture durable project signals alongside normal work. Use a Brainkeeper sub-agent when available; otherwise queue signals in `CAPTURE_QUEUE.md` and run a Brain Checkpoint before handoff. Ignore routine implementation noise unless it changes project understanding.

## Full Orchestrator Outputs

Every full orchestrator output triggers a Brainkeeper sidecar when one is available. The sidecar owns raw preservation and durable distillation while the main workline proceeds separately. If no sidecar is available, add the source to `CAPTURE_QUEUE.md` and complete a Brain Checkpoint before handoff.

The local Codex agent is Raven's primary solution developer. It must read full master-orchestrator responses completely and process their implementation prompts as priority main-workline input. Brainkeeper runs in parallel and must not replace, delay, terminate, or duplicate that implementation.

## Brainkeeper Backfill

Ingest historical source material while preserving uncertainty. Do not convert brainstorms into decisions.

## Brain Reviewer

Test whether active Brain files are enough for a fresh human or AI to re-enter the project.

## Brain Health Check

Validate required files, statuses, traceability, and active-context quality.
