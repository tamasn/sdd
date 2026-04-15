---
name: update-docs
description: Update architecture docs and write findings.md for the current stage. Final step of a stage before starting the next stage or creating a PR.
argument-hint: "<task-id> [stage-number]"
---

# Update Documentation

Update `<DOCS_DIR>/architecture/` to reflect code changes and write `findings.md` with learnings. Final step of a stage.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>` and `<DEFAULT_BRANCH>`.

## Input

`$0` — task ID (e.g. `AP-20564`, `GH-0123`). Locates `<DOCS_DIR>/tasks/<TASK-ID>/`.

`$1` — optional stage number (e.g. `2`). If omitted, auto-detects the current stage.

## Stage detection

Follow the [stage detection procedure](../_shared/stage-workflow.md#stage-detection).

## Reads

- `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/implementation.md` — what was done
- `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/review.md` — review findings
- Branch diff (`git diff <DEFAULT_BRANCH>...HEAD`)
- `<DOCS_DIR>/architecture/` — current docs

## Writes

- `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/findings.md`
- Updated files in `<DOCS_DIR>/architecture/`
- Updates `Status` in `<STAGE-DIR>/summary.md` to `documented`
- Updates `Status` in task `summary.md` to `stage-<N>-complete`

## Instructions

### 1. Read task files

Read stage `implementation.md` and `review.md`. Verify stage `Status` is `reviewed` or `documented` (allow re-runs).

### 2. Read the diff

Run `git diff <DEFAULT_BRANCH>...HEAD`.

### 3. Update architecture documentation

Read `<DOCS_DIR>/architecture/CLAUDE.md` for guidelines, then read and update affected architecture docs:
- Update descriptions of modified components, interfaces, or data models
- Add documentation for new components or patterns
- Update file paths and line number references
- Remove documentation for deleted code

### 4. Write findings.md

Create `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/findings.md`:

```markdown
# Findings — <TASK-ID> Stage <N>

## Learnings
Insights useful for future tasks.

## Patterns discovered
Patterns or anti-patterns found during implementation.

## Architectural notes
Information that should inform future decisions.
```

### 5. Update status

Set `Status: documented` in `<STAGE-DIR>/summary.md` frontmatter.
Set `Status: stage-<N>-complete` in task `summary.md` frontmatter.

### 6. Update Overview

Follow the [overview update procedure](../_shared/stage-workflow.md#overview-update):
- Update the task status to `stage-<N>-complete`
- Update the stage line for stage N to show status `documented`

### 7. Commit

Commit with message: `docs(<TASK-ID>): update documentation for stage <N>`

## Completion

Tell the user:
- To add another stage: start a new conversation and run `/start-stage <TASK-ID>`
- To create a PR: run `/create-pr` or `/create-pr-doc`

## Guidance
- Documentation must accurately represent the code
- Use specific references (file paths, line numbers, fully qualified names)
- Cover one area per file, reference other files instead of repeating
- Keep docs compact and useful for AI code generation
- Do NOT delete `CLAUDE.md`, core architectural decisions, or context about why things work a certain way
