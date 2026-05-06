---
name: commit-changes-light
description: Commit all working-copy changes with a conventional commit message. Use in the modular workflow when there is no task document driving the commit.
argument-hint: "[type] [message]"
---

# Commit Changes (Light)

Stage and commit everything in the working copy with a conventional commit message that matches the project's commit standards. Use this for ad-hoc commits in the modular workflow.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>` (used to look up project commit conventions).

## Input

`$0` — optional commit type (`feat`, `fix`, `refactor`, `chore`, `docs`, `test`). If omitted, infer from the diff or ask the user.

`$1` — optional one-line description for the commit subject. If omitted, write one based on the diff.

## Instructions

### 1. Inspect the working copy

Run in parallel:
- `git status --porcelain` — staged, unstaged, untracked
- `git diff --stat` — magnitude
- `git diff` and `git diff --cached` — actual content
- `git log -5 --oneline` — match recent commit style

If there is nothing to commit, stop and tell the user.

### 2. Determine the type

Check `<DOCS_DIR>/architecture/CLAUDE.md` for project commit conventions. Otherwise default to Conventional Commits.

If `$0` was provided, use it. Otherwise infer from the diff:
- New feature → `feat`
- Bug fix → `fix`
- Internal restructuring (no behavior change) → `refactor`
- Tooling, config, version bumps → `chore`
- Doc-only changes → `docs`
- Test-only changes → `test`

If the diff mixes types, prefer the most user-visible one and ask the user when ambiguous.

### 3. Build the message

Format: `<type>: <description>`. There is no task or ticket ID in the modular workflow, so omit the parenthesized scope entirely. (Skills that run inside a task workflow — e.g. stage skills, `/start-task-simple` — use `<type>(<TASK-ID>): <description>`.)

- Description ≤ 72 characters, imperative mood, no trailing period
- If `$1` was provided, use it as the description (validate length; reword if needed)
- Otherwise write one based on the diff

If the change is large enough to warrant a body, add one or two short paragraphs after a blank line — focus on the *why*, not the *what*.

### 4. Stage files safely

Stage relevant files by name. Avoid `git add -A` / `git add .` unless the working copy is clean of files that should not be committed. Watch for and warn the user about:
- Secrets / credentials (`.env`, `credentials.json`, key files)
- Large binaries
- Untracked debug scratch files

When in doubt, ask before staging.

### 5. Show the plan and commit

Show the user:
- Files to be staged
- The full commit message (subject + body)

Wait for explicit approval, then commit. If a hook fails, fix the underlying issue and create a NEW commit (do not amend).

## Completion

Show the resulting commit. Suggest:
- `/review-changes-light` if you want a self-review pass before pushing
- `/update-docs-light` to sync architecture docs
- `/create-pr-light` when ready to open a PR

## Guidance

- Never use `--no-verify` unless the user explicitly asks
- Never amend an existing commit unless the user explicitly asks
- One logical change per commit — if the working copy mixes unrelated work, suggest splitting before committing
- If the user is in a task-document workflow, the per-stage skills already commit at each step — this skill is for the modular flow only
