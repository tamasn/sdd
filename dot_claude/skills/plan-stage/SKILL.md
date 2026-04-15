---
name: plan-stage
description: Create an implementation plan from research.md for the current stage. Writes plan.md. Does not read source code.
argument-hint: "<task-id> [stage-number]"
---

# Plan Stage

Create a detailed, actionable implementation plan based on `research.md`. This step should NOT broadly explore the codebase — everything needed is in the research file.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>`.

## Input

`$0` — task ID (e.g. `AP-20564`, `GH-0123`). Locates `<DOCS_DIR>/tasks/<TASK-ID>/`.

`$1` — optional stage number (e.g. `2`). If omitted, auto-detects the current stage.

## Stage detection

Follow the [stage detection procedure](../_shared/stage-workflow.md#stage-detection).

## Reads

- `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/summary.md` — the stage goal (primary source of what to accomplish)
- `<DOCS_DIR>/tasks/<TASK-ID>/summary.md` — high-level task context (fallback if stage summary lacks detail)
- `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/research.md` — distilled code analysis

## Writes

- `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/plan.md`
- Updates `Status` in `<STAGE-DIR>/summary.md` to `planned`

## Instructions

### 1. Read task files

Read stage `summary.md` for the goal (primary), task `summary.md` for context (fallback), and stage `research.md`. Verify stage `Status` is `researched` or `planned` (allow re-runs).

Do NOT read source code. If `research.md` is missing critical information, tell the user to re-run `/research-stage`.

### 2. Ask clarifying questions

Before writing the plan, ask about:
- Implementation approach preferences and trade-offs
- Non-goals and scope boundaries
- Any ambiguity in the research findings
- Ask as many questions as needed until the approach is clear

### 3. Write plan.md

Create `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/plan.md`:

```markdown
# Implementation Plan — <TASK-ID> Stage <N>

## Step 1: <description> (`<file_path>`)
- What to change
- Specific modifications (add/modify/remove)
- Expected behavior after this step

## Step 2: <description> (`<file_path>`)
...

## Testing Plan
- Test cases to cover
- Test file locations and patterns (from research.md)
- Edge cases
```

**Requirements:**
- Every step references specific file paths from `research.md`
- Include expected behavior change per step
- Order steps for incremental compilation and testing
- Keep each step small enough to verify independently

### 4. Present for approval

Show the plan. Explain key decisions. Wait for explicit approval before proceeding.

### 5. Update status

Set `Status: planned` in `<STAGE-DIR>/summary.md` frontmatter.

### 6. Commit

Commit with message: `docs(<TASK-ID>): add stage <N> implementation plan`

## Completion

Suggest the user start a new conversation and run `/implement-stage <TASK-ID>`.

## Guidance
- Rely on `research.md` — do not explore the codebase
- The plan must be detailed enough for `/implement-stage` to execute without additional exploration
- Aim for the smallest possible implementation
- DO NOT MAKE CHANGES TO THE CODE
