---
name: create-branch-light
description: Create a feature branch from a brief summary and optional ticket ID. Use for ad-hoc work in the modular workflow when there is no task document.
argument-hint: "<summary> [ticket-id]"
---

# Create Branch (Light)

Create a feature branch using the same naming strategy as `/start-task`, without requiring a task document. Use this for fully manual flows where no task or stage document is involved.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DEFAULT_BRANCH>`.

## Input

`$0` — short summary of the work. Slugified into the branch name.

`$1` — optional ticket identifier:
- GitHub issue number (`123` or `#123`) — normalized to `GH-0123` (4-digit padded)
- JIRA key (`AP-20564`) — used verbatim
- Any other identifier — used verbatim

## Instructions

### 1. Verify the current branch

Run `git rev-parse --abbrev-ref HEAD`. If the current branch is **not** a base branch (`<DEFAULT_BRANCH>`, `main`, `develop`, or `master`), stop and tell the user a feature branch is already checked out — they should commit or stash first, then check out the base branch.

### 2. Check the working tree

Run `git status --porcelain`. If there are uncommitted changes, ask the user whether to abort or carry them onto the new branch (they will move with `git checkout -b`). Wait for explicit confirmation.

### 3. Determine the prefix

Pick a Conventional Commits-style prefix from the summary:
- `feat/` — new feature
- `fix/` — bug fix
- `refactor/` — internal restructuring
- `chore/` — tooling, config, dependency bumps
- `docs/` — documentation only

If the type is not obvious from `$0`, ask the user.

### 4. Build the slug

Slugify `$0` to lowercase, hyphen-separated. Cap at ~5 words. Strip stop words and punctuation.

### 5. Build the branch name

- With ticket: `<prefix>/<TICKET-ID>-<slug>` — e.g. `feat/AP-20564-email-validation`, `fix/GH-0123-timeout-on-login`
- Without ticket: `<prefix>/<slug>` — e.g. `feat/email-validation`

### 6. Create the branch

`git checkout -b <branch-name>`

## Completion

Tell the user the branch was created. Suggest `/commit-changes-light` once changes are ready, then `/review-changes-light`, `/update-docs-light`, and `/create-pr-light`.

## Guidance

- Do NOT push the branch — that happens when the PR is created
- Match the naming strategy used by `/start-task` and `/start-task-simple` so all workflows produce comparable branch names
- If the user is starting a structured task workflow, suggest `/start-task` instead — it creates the branch as part of task setup
