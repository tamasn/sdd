---
name: create-pr-doc
description: Create a draft pull request for documentation-only changes.
---

# Create PR for Documentation

Commit any uncommitted doc changes, push, and create a draft PR. Skips build/test validation by design — this skill is for documentation-only changes that don't affect build output. If the branch contains code changes, use `/create-pr` or `/create-pr-light` instead.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>` and `<DEFAULT_BRANCH>`.

## Prerequisites

- `gh` CLI installed and authenticated
- Current branch has documentation changes

## Instructions

1. If there are uncommitted changes, commit them first
2. Push: `git push origin HEAD`
3. Check PR conventions in `<DOCS_DIR>/architecture/CLAUDE.md`. Default title: `docs: <description>`
4. Create draft PR: `gh pr create --draft` with base branch `<DEFAULT_BRANCH>`, title, and body summarizing what docs changed and why
5. Share PR URL
