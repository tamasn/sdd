---
name: implement-stage
description: Execute the implementation plan from plan.md for the current stage. Writes implementation.md with notes. Does not update architecture docs.
argument-hint: "<task-id> [stage-number]"
---

# Implement Stage

Execute the plan from `plan.md`. Focus on code changes and testing only. Architecture doc updates happen in `/update-docs`.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>`.

## Input

`$0` — task ID (e.g. `AP-20564`, `GH-0123`). Locates `<DOCS_DIR>/tasks/<TASK-ID>/`.

`$1` — optional stage number (e.g. `2`). If omitted, auto-detects the current stage.

## Stage detection

Follow the [stage detection procedure](../_shared/stage-workflow.md#stage-detection).

## Reads

- `<DOCS_DIR>/tasks/<TASK-ID>/summary.md` — status check
- `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/plan.md` — step-by-step guide with file paths

## Writes

- `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/implementation.md`
- Updates `Status` in `<STAGE-DIR>/summary.md` to `implemented`

## Instructions

### 1. Read task files

Read task `summary.md` and stage `plan.md`. Verify stage `Status` is `planned` or `implemented` (allow re-runs).

### 2. Implement the plan

Follow `plan.md` step by step:
- Read only the specific files referenced in the plan
- Make the code changes described in each step
- After each step, verify the code compiles
- Follow the project's coding standards from `CLAUDE.md`

### 3. Run tests

Follow the testing plan from `plan.md`:
- Write tests iteratively: create one, compile, run, confirm it passes, then the next
- Use existing test fixtures and patterns
- Verify all tests pass before proceeding

### 4. Write implementation.md

Create `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/implementation.md`:

```markdown
# Implementation Notes — <TASK-ID> Stage <N>

## Approach
Actual approach taken. Note any deviations from the plan and why.

## Issues encountered
Problems hit during implementation and how they were resolved.

## Key decisions
Decisions made during implementation that weren't covered by the plan.

## Follow-up
Any technical debt introduced or follow-up work needed.
```

### 5. Update status

Set `Status: implemented` in `<STAGE-DIR>/summary.md` frontmatter.

### 6. Commit

Commit code and documentation changes.

## Completion

Suggest the user start a new conversation and run `/review-stage <TASK-ID>`.

## Guidance
- Ask questions if anything is unclear or a decision is needed
- Always verify code compiles and tests pass
- If compilation fails repeatedly, note it in `implementation.md`
- DO NOT update architecture documentation
- Stick to the plan. If the plan is wrong or incomplete, ask the user before deviating
