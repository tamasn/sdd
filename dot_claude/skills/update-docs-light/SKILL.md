---
name: update-docs-light
description: Update architecture docs from the current branch diff and conversation, without requiring a task document. Light variant of /update-docs.
argument-hint: ""
---

# Update Documentation (Light)

Update `<DOCS_DIR>/architecture/` to reflect changes on the current branch. No task documents read or written. Use this in the modular workflow when there is no `<DOCS_DIR>/tasks/<TASK-ID>/` to draw from.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>` and `<DEFAULT_BRANCH>`.

## Reads

- Branch diff (`git diff <DEFAULT_BRANCH>...HEAD` plus any uncommitted changes)
- `<DOCS_DIR>/architecture/` — current docs
- Conversation context — what the user asked for and what was implemented

## Writes

- Updated files in `<DOCS_DIR>/architecture/`

## Instructions

### 1. Determine the diff scope

Identify everything that should be reflected in docs:

- Committed: `git diff <DEFAULT_BRANCH>...HEAD` (or `git diff @{u}...HEAD` if the branch tracks an upstream)
- Staged: `git diff --cached`
- Unstaged: `git diff`
- Untracked: `git status --porcelain` (read `??` files when relevant)

A convenient single view is `git diff <DEFAULT_BRANCH>` (or `git diff @{u}`), which covers committed + staged + unstaged. Layer untracked files on top.

If nothing is pending, stop and tell the user there is nothing to document.

### 2. Update architecture documentation

Read `<DOCS_DIR>/architecture/CLAUDE.md` for guidelines, then read and update affected docs:

- Update descriptions of modified components, interfaces, or data models
- Add documentation for new components or patterns
- Update file paths and line number references
- Remove documentation for deleted code

Treat uncommitted and committed changes equally — the goal is that architecture docs match the current working tree state.

Use the conversation context as a tiebreaker for *intent* when the diff alone is ambiguous (e.g. why a function was extracted, what the new abstraction is for).

### 3. Commit or leave staged

Ask the user whether to commit the documentation updates now or leave them staged for review alongside other pending changes.

On approval, commit only the documentation changes. Use message: `docs: update architecture docs`. Or run `/commit-changes-light` if you want to bundle the docs with related code changes.

## Completion

Summarize which architecture files changed. Suggest:
- `/review-changes-light` before pushing
- `/create-pr-light` or `/create-pr-doc` when ready

## Guidance

- Documentation must accurately represent the code as it exists locally right now, including uncommitted edits
- Use specific references (file paths, line numbers, fully qualified names)
- Cover one area per file, reference other files instead of repeating
- Keep docs compact and useful for AI code generation
- Do NOT delete `CLAUDE.md`, core architectural decisions, or context about why things work a certain way
- If the user is working in the task-document workflow, suggest `/update-docs` (stage-aware) instead
