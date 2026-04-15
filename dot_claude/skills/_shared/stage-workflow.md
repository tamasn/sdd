# Stage Workflow — Shared Procedures

Common procedures used by all stage skills. Each stage skill references this file to avoid duplication.

Read [config.md](config.md) first to resolve `<DOCS_DIR>` and `<DEFAULT_BRANCH>`.

## Stage detection

Given a task ID and optional stage number:

1. Scan `<DOCS_DIR>/tasks/<TASK-ID>/` for directories matching `stage-N-*` (where N is a number).
2. If a stage number argument was provided, use that specific N (do not apply the `initial` filter — the user asked for it explicitly).
3. Otherwise, read the `Status` field from each stage's `summary.md` and **ignore any stage whose `Status` is `initial`** — `initial` means the user is still drafting that stage and it is not ready to be worked on. From the remaining stages, use the highest N.
4. Let `<STAGE-DIR>` = the full directory name (e.g. `stage-2-add-validation`).

If no `stage-N-*` directories exist, stop and tell the user to run `/start-task` first.

If every existing stage has `Status: initial`, stop and tell the user to finalize a stage summary (remove the `initial` status) before running the skill.

## Status verification

Before starting work, read `<STAGE-DIR>/summary.md` and check its `Status` field. Each stage skill defines which statuses are acceptable (current status or the status it would set — to allow re-runs). If the status doesn't match, stop and tell the user which skill to run first.

## Status update

After completing work, update the `Status` field in `<STAGE-DIR>/summary.md` frontmatter to the new value defined by the stage skill.

## Overview update

When a skill updates task or stage status, also update `<DOCS_DIR>/tasks/Overview.md`:
1. Find the entry for `<TASK-ID>`
2. Update the task-level status if changed
3. Update the stage line for stage N to show the new status

## Commit

After completing work, commit changes with a conventional commit message. Use the format:
```
docs(<TASK-ID>): <description of what was written/updated>
```

## Concurrent work

Other stages or tasks may be created concurrently. Do not read or modify documents in other stage directories.

## File references

All stage skills work within this directory structure:

```
<DOCS_DIR>/tasks/<TASK-ID>/
  summary.md                      # Task-level: ID, Type, Author, Created, Status, CurrentStage
  stage-1-<slug>/
    summary.md                    # Stage-level: Stage, Slug, Status, Created, Goal
    research.md                   # research-stage output
    plan.md                       # plan-stage output
    implementation.md             # implement-stage output
    review.md                     # review-stage output
    findings.md                   # update-docs output
```

## CLAUDE.md hierarchy

When working in `<DOCS_DIR>/` directories, check for `CLAUDE.md` in the target directory and parent directories. Follow instructions from all discovered `CLAUDE.md` files, with deeper directories taking precedence.
