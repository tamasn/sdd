---
name: review-stage
description: Self-review the branch diff against plan.md for the current stage. Writes review.md. May make minor code fixes.
argument-hint: "<task-id> [stage-number]"
---

# Review Stage

Self-review the full diff, validate alignment with `plan.md`, check code quality. May make minor fixes (style, unused imports, debug statements). For anything requiring rethinking the approach, stop and discuss.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>` and `<DEFAULT_BRANCH>`.

## Input

`$0` — task ID (e.g. `AP-20564`, `GH-0123`). Locates `<DOCS_DIR>/tasks/<TASK-ID>/`.

`$1` — optional stage number (e.g. `2`). If omitted, auto-detects the current stage.

## Stage detection

Follow the [stage detection procedure](../_shared/stage-workflow.md#stage-detection).

## Reads

- `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/plan.md` — intended changes
- `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/implementation.md` — what actually happened
- Branch diff (`git diff <DEFAULT_BRANCH>...HEAD`)

## Writes

- `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/review.md`
- Updates `Status` in `<STAGE-DIR>/summary.md` to `reviewed`

## Instructions

### 1. Read task files

Read stage `plan.md` and `implementation.md`. Verify stage `Status` is `implemented` or `reviewed` (allow re-runs).

### 2. Review the diff

Run `git diff <DEFAULT_BRANCH>...HEAD`. Check for:

**Plan alignment:** Do changes match the plan? Missing steps? Unplanned changes?

**Code quality:** Unused imports/variables, inconsistent naming, missing error handling, null/undefined risks, dead code, debug statements, security issues.

**Test coverage:** All planned test cases covered? Tests actually testing the code?

**Standards:** Check against `CLAUDE.md` conventions.

### 3. Fix minor issues

Fix minor issues directly (style, unused imports, debug statements). For anything substantive, discuss with the user first.

### 4. Write review.md

Create `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/review.md`:

```markdown
# Review — <TASK-ID> Stage <N>

## Summary
What was reviewed and overall assessment.

## Issues found and fixed
- List of minor fixes made

## Concerns
- Any remaining concerns or questions for the user
```

### 5. Update status

Set `Status: reviewed` in `<STAGE-DIR>/summary.md` frontmatter.

### 6. Commit

Always commit — `review.md` and the `Status: reviewed` bump in `summary.md` are written every run, so there is always something to commit. Include any code fixes made in step 3 in the same commit. Use message: `docs(<TASK-ID>): add stage <N> review` (or `chore(<TASK-ID>): stage <N> review fixes` if code fixes are the primary change).

## Completion

Tell the user the diff is ready for their review. Summarize findings. Then suggest starting a new conversation and running `/update-docs <TASK-ID>`.

## Guidance
- Be thorough — last line of defense before user review
- Only fix minor issues. If something requires rethinking, stop and discuss
