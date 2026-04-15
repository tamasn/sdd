---
name: create-branch
description: Create a new feature branch from the current base branch.
---

# Create Branch

Only create a branch if currently on a base branch.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DEFAULT_BRANCH>`.

## Instructions

1. Verify the current branch is a base branch (`<DEFAULT_BRANCH>`, `main`, `develop`, or `master`). If not on a base branch, skip — the branch already exists.
2. Determine branch prefix from task type: `feat/`, `fix/`, or `refactor/`
3. Format: `<prefix>/<ticket-id>-<brief-summary>` (e.g. `feat/AP-20564-email-validation`)
4. Create: `git checkout -b <branch-name>`
