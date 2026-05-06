---
name: start-task-simple
description: Collapsed task workflow for small iterations — gathers spec, researches, plans, and implements in a single conversation. Creates a feature branch only if currently on a base branch; otherwise reuses the current branch. Only commits at the end, with user approval.
argument-hint: "[task-id] [stage-number]"
---

# Start Task (Simple)

Run the full research → plan → implement loop for a small task in one conversation. Creates a feature branch only if currently on a base branch; otherwise reuses the current branch. Use this for simple iterations where staging ceremony and context isolation are overkill. Optimizes for smooth, quick back-and-forth over context size.

Differences from `/start-task` + `/research-stage` + `/plan-stage` + `/implement-stage`:
- Branch is created only if currently on a base branch — otherwise the current branch is reused
- No intermediate commits — ask for a single commit only when implementation is done
- All clarifying questions are asked upfront (spec + plan) before any code is written
- Still writes `summary.md`, `research.md`, `plan.md`, `implementation.md` so the task remains compatible with `/review-stage` and `/update-docs` afterward

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>` and the issue tracker setting.

## Input

`$0` — optional task ID: existing task directory name, GitHub issue number (`123` / `#123`), JIRA key (`AP-20564`), or omitted for interactive mode.

`$1` — optional stage number. If omitted, auto-detects using the [stage detection procedure](../_shared/stage-workflow.md#stage-detection) or creates stage 1.

## Task directory structure

Same as `/start-task`. Each task lives in `<DOCS_DIR>/tasks/<TASK-ID>/` with one or more `stage-N-<slug>/` subdirectories.

## Instructions

### 1. Gather the specification

**If `$0` matches an existing task directory in `<DOCS_DIR>/tasks/`:**
- Read `summary.md` (if present) and any existing `stage-*/summary.md`
- If `$1` is provided, target that stage number (create if missing, adopt if pre-seeded)
- If `$1` is omitted, auto-detect the current stage (ignore `initial` status); if none exists, create stage 1
- Ask clarifying questions about scope, non-goals, and anything ambiguous in the existing docs

**If issue tracker is `jira` and `$0` is a JIRA key:**
- Use `/read-issue` to fetch the ticket
- Use the ticket ID as the task ID, the assignee as the author

**If issue tracker is `github` and `$0` is a GitHub issue number:**
- Use `/read-issue` to fetch the issue
- Use `GH-<padded-4-digit>` as the task ID (e.g. `GH-0123`), the assignee as the author

**If `$0` is not provided:**
- Ask the user to describe the task
- Ask clarifying questions about scope and non-goals
- Ask if there is an issue ID to use as reference
- If no issue: generate an ID from the project name (e.g. `AUTH-0001`) — 4-letter uppercase prefix, 4-digit counter, append `-2` / `-3` if a directory with that ID already exists
- Ask for the author name if unclear

### 2. Create or update the task summary

If `<DOCS_DIR>/tasks/<TASK-ID>/summary.md` already exists, read it and ensure the required frontmatter fields and structure are present, preserving existing content.

If it does not exist, create it:

```markdown
---
ID: <TASK-ID>
Type: Feature | Bug | Refactor
Author: <author>
Created: <YYYY-MM-DD>
Status: in-progress
CurrentStage: <N>
---

# <TASK-ID> - <Brief Summary>

## Overview
Brief context for the task. Detailed goals belong in each stage's summary.

## Stages
- [Stage <N>: <slug>](stage-<N>-<slug>/summary.md)
```

### 3. Create or adopt the stage

Determine stage number `<N>`:
- If `$1` was provided, use it
- Else, if any `stage-*/summary.md` exist with a non-`initial` status, use the highest (auto-detect)
- Else, if a pre-seeded `stage-*/summary.md` exists (any status), adopt it
- Else, create stage 1

Ask the user for a slug if creating a new stage (or derive from the task description / issue title — lowercase, hyphen-separated, 2-4 words).

If `<STAGE-DIR>/summary.md` already exists, read it and preserve its `## Goal`. Otherwise create:

```markdown
---
Stage: <N>
Slug: <slug>
Status: in-progress
Created: <YYYY-MM-DD>
---

# Stage <N>: <Brief Description>

## Goal
Detailed description of what this stage aims to accomplish.
```

Set the stage `Status` to `in-progress`.

### 4. Create the branch (if needed)

Run `git rev-parse --abbrev-ref HEAD`. If the current branch is a base branch (`<DEFAULT_BRANCH>`, `main`, `develop`, or `master`), create a new feature branch:

1. Determine the prefix from the task type: `feat/`, `fix/`, `refactor/`, `chore/`, or `docs/`.
2. Build the branch name: `<prefix>/<TASK-ID>-<slug>` (e.g. `feat/AP-20564-email-validation`). Reuse the stage `<slug>`.
3. Create the branch: `git checkout -b <branch-name>`.

Otherwise (already on a feature branch), reuse the current branch — do not create a new one.

### 5. Update the Overview

Update `<DOCS_DIR>/tasks/Overview.md` (create with `# Tasks Overview` if missing) following the [overview update procedure](../_shared/stage-workflow.md#overview-update). For a newly created task, insert a new entry at the top. For an existing task, update the task status to `in-progress` and ensure the stage line for `<N>` is present.

**Do NOT commit yet.** All documentation and code changes will be committed together at the end.

### 6. Research the codebase

Explore the areas relevant to the stage goal:
- Architecture docs in `<DOCS_DIR>/architecture/`
- Source files that will be modified
- Test locations, frameworks, and reusable fixtures
- Patterns already used for similar features

Write `<STAGE-DIR>/research.md` following the format from `/research-stage` (architecture context, code analysis with file:line references, test context, constraints and risks). Distill, don't dump.

Set stage `Status: researched`.

### 7. Ask clarifying questions about the approach

Before planning, ask about:
- Implementation approach preferences and trade-offs
- Non-goals and scope boundaries
- Any ambiguity in the research findings

Ask as many questions as needed until the approach is clear.

### 8. Write and present the plan

Write `<STAGE-DIR>/plan.md` following the format from `/plan-stage` — numbered steps with file paths, expected behavior per step, and a testing plan.

Present the plan to the user. Explain key decisions. **Wait for explicit approval before writing any code.**

If the user requests changes, update `plan.md` and re-present until approved.

Set stage `Status: planned`.

### 9. Implement

Execute the plan step by step:
- Read only the specific files referenced in the plan
- Make the code changes described in each step
- Verify the code compiles after each step
- Follow `CLAUDE.md` conventions

Follow the testing plan:
- Write tests iteratively — create one, compile, run, confirm it passes, then the next
- Use existing test fixtures and patterns
- Verify all tests pass

If the plan turns out wrong or incomplete, stop and discuss with the user before deviating.

### 10. Write implementation notes

Write `<STAGE-DIR>/implementation.md` following the format from `/implement-stage` (approach, issues encountered, key decisions, follow-up).

Set stage `Status: implemented` and task `Status: stage-<N>-implemented`.

Update `Overview.md` to reflect the new stage status.

### 11. Ask for commit approval

Show the user a summary of:
- Files changed
- Tests added and their status
- Any deviations from the plan

Ask for approval to commit. On approval, create a single commit that includes the task docs, stage docs, code changes, and tests. Use a conventional commit message: `<type>(<TASK-ID>): <brief summary>` (e.g. `feat(AP-20564): add email validation`, `fix(GH-0123): handle login timeout`).

If the user wants to split the commit, follow their guidance.

## Completion

Tell the user the task is implemented on the current branch. Suggest:
- `/review-changes-light` to review unpushed changes before pushing
- `/update-docs-light` to update architecture docs for unpushed changes
- `/create-pr` or `/create-pr-doc` when ready to open a PR

## Guidance

- Aim for the smallest possible scope that fits the request
- Create a branch only if currently on a base branch — otherwise reuse the current branch
- Do NOT commit between phases — only at the end, with user approval
- Keep research tight enough to inform the plan without ballooning the conversation
- If the work is large enough to warrant context isolation, tell the user to use `/start-task` instead and stop
- Ask clarifying questions freely — smoothness beats silence
