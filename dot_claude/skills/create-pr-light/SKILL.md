---
name: create-pr-light
description: Validate, push, and create or update a draft pull request without requiring a task document. Use in the modular workflow when there is no `<DOCS_DIR>/tasks/<TASK-ID>/` to draw from.
argument-hint: "[title]"
---

# Create Pull Request (Light)

Validate the build, push the branch, and create (or update) a draft PR. The body is generated from the branch's commits and the diff — no task documents required.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>` and `<DEFAULT_BRANCH>`.

## Prerequisites

- Current branch has commits ahead of `<DEFAULT_BRANCH>`
- `gh` CLI installed and authenticated

## Input

`$0` — optional PR title. If omitted, derive one from the branch name and commits.

## Instructions

### 1. Verify the branch

Run `git rev-parse --abbrev-ref HEAD`. If on `<DEFAULT_BRANCH>` (or `main`/`develop`/`master`), stop and tell the user to create a feature branch first via `/create-branch-light`.

### 2. Inspect the work

Run in parallel:
- `git status --porcelain` — confirm clean (or note uncommitted)
- `git log <DEFAULT_BRANCH>..HEAD --oneline` — commit list
- `git diff <DEFAULT_BRANCH>...HEAD --stat` — magnitude

If the working tree has uncommitted changes, ask the user whether to commit them first via `/commit-changes-light` or proceed (uncommitted changes will not appear in the PR).

### 3. Validate build

Check `<DOCS_DIR>/architecture/CLAUDE.md` or `<DOCS_DIR>/architecture/Tech-Stack.md` for the project's build/test commands. Run them. Fix errors or ask for guidance. Skip only with the user's explicit approval if the project has no build/test commands.

### 4. Determine PR title

Check `<DOCS_DIR>/architecture/CLAUDE.md` for PR conventions. Default: `<type>(<scope>): <description>`.

If `$0` was provided, use it. Otherwise derive the title from:
- The branch name prefix (`feat/`, `fix/`, `refactor/`, etc.) for the type
- The most representative commit (or a synthesis of commits) for the description

Keep the title under 70 characters.

### 5. Push the branch

`git push origin HEAD` (use `-u` if no upstream is configured). Never force-push to a shared branch.

### 6. Check for existing PR

`gh pr list --head $(git branch --show-current) --json number,url --jq '.[0]'`

### 7. Create or update the PR

**No existing PR:** `gh pr create --draft` with base `<DEFAULT_BRANCH>`, the title from step 4, and the body format below.

**Existing PR:** `gh pr edit <number>` with regenerated body.

### 8. Share the PR URL

## PR body format

```markdown
## Summary
<1-3 sentence summary of the change, derived from commits and the diff>

## Changes
- <bullet per logical change, derived from commits and grouped where possible>

## Testing
<Tests added and/or build commands run, derived from the diff and step 3>

## Breaking changes
<Any breaking changes, or "None">
```

## Completion

Share the PR URL. Suggest:
- `/update-docs-light` if architecture docs need a follow-up sync (or `/create-pr-doc` for a docs-only follow-up PR)
- `/review-changes-light` if the user wants a self-review pass before requesting reviewers

## Guidance

- Always create draft PRs unless the user asks otherwise
- One PR per branch — update existing rather than open a duplicate
- Never force-push to a shared branch
- If the branch has a `<DOCS_DIR>/tasks/<TASK-ID>/` directory associated with it, suggest `/create-pr` instead — it produces a richer body from the task and stage documents
