# Brain Deployment

Project Brain can be installed in any repo as a core-only Brain or an Orbit-connected Brain.

## Core Install

Use when the project is not connected to Orbit.

Install core template files, Brainkeeper skills, and Brain docs. Configure `brain/brain.config.yaml` with Orbit disabled.

## Orbit-Connected Install

Use when `.orbit/` is present or the project is managed by Orbit.

Apply the core template first, then the Orbit overlay. Keep `.orbit/` distinct from `brain/`.

## Existing Brain Update

Use when `brain/` already exists.

Do not overwrite raw source, sessions, backfills, distillations, decisions, or open loops. Add missing files and update instructions additively.
