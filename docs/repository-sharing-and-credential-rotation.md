---
status: canonical
owner: Raven
last_reviewed: 2026-07-11
supersedes: []
superseded_by: []
---

# Repository Sharing And Credential Rotation

## AI-Safe Archives

`pnpm zip` and `pnpm zip:ai-safe` use the fail-closed AI-safe profile.

```bash
pnpm zip:ai-safe -- --list
pnpm zip:ai-safe -- --list --show-excluded
pnpm zip:ai-safe -- --output /tmp/raven-ai-safe.zip
```

The profile:

- selects tracked and untracked non-ignored files from the root and nested schema repositories;
- excludes private financial sources, private document frontmatter, raw Brain sources, Orbit mirrors, environment files, credential-bearing configs, certificates, backups, local data, PDFs, mail exports, and history dumps;
- scans remaining text files for high-confidence secret signatures;
- aborts archive creation when a secret signature remains;
- reports only the path and detection code, never the detected value.

The prior broad behavior remains available only under an explicitly unsafe command:

```bash
pnpm zip:developer-unsafe -- --list
```

Do not use that profile for AI, email, cloud, or external review sharing.

## Verification

```bash
pnpm test:archive-safety
pnpm zip:ai-safe -- --list
```

The test suite covers required path classes, private document frontmatter, environment references, and planted dummy-secret rejection.

## Credential Rotation Checklist

Credential rotation is not performed automatically by repository tooling.

When rotation is required:

1. identify the affected local service or provider without printing the current value;
2. create the replacement through that service's approved local workflow;
3. update only ignored environment/runtime configuration;
4. restart the affected local service;
5. verify connectivity without logging the value;
6. invalidate the previous credential where supported;
7. rerun the AI-safe archive preflight.

Never place old or replacement values in commits, patches, documentation, Brain, Orbit, terminal transcripts, or review archives.
