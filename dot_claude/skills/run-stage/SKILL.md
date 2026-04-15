---
name: run-stage
description: Run a single stage end-to-end (research, planning, coding, review, documentation) using subagents for context isolation. Each heavy step runs in a fresh context while the orchestrator stays lean.
argument-hint: "<task-id> [stage-number]"
---

# Run Stage (Orchestrator)

Run a single stage from research to documentation. Each heavy step is delegated to a subagent with its own fresh context. The stage directory on disk is the handoff artifact between steps.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>` and `<DEFAULT_BRANCH>`.

## Input

`$0` — task ID (e.g. `AP-20564`, `GH-0123`). Locates `<DOCS_DIR>/tasks/<TASK-ID>/`.

`$1` — optional stage number (e.g. `2`). If omitted, auto-detects the current stage.

## Prerequisites

The task and stage must already exist (created by `/start-task` or `/start-stage`). The stage `Status` should be `created`.

## Stage detection

Follow the [stage detection procedure](../_shared/stage-workflow.md#stage-detection).

## Instructions

### Step 1: Research (subagent)

Verify stage `Status` is `created` or `researched` (allow re-runs).

Spawn multiple Agents with `subagent_type: "Explore"` for parallel research:

**Subagent 1 — Architecture documentation:**
> **Task directory**: `<absolute path to <DOCS_DIR>/tasks/TASK-ID/>`
> **Stage directory**: `<absolute path to <STAGE-DIR>/>`
> **Project root**: `<absolute path to project root>`
>
> Read `summary.md` in the stage directory to understand the Goal. Then read all files in `<DOCS_DIR>/architecture/`. Identify patterns, components, and design decisions relevant to the stage goal. Return a summary of relevant architectural context.

**Subagent 2 — Source code exploration:**
> **Task directory**: `<absolute path to <DOCS_DIR>/tasks/TASK-ID/>`
> **Stage directory**: `<absolute path to <STAGE-DIR>/>`
> **Project root**: `<absolute path to project root>`
>
> Read `summary.md` in the stage directory to understand the Goal. Explore the codebase to find files, interfaces, types, and logic relevant to the stage goal. Identify dependencies, call chains, and data flow. Return specific file paths, line numbers, and a summary of relevant code.

**Subagent 3 (if needed) — Additional research:**
> Explore test patterns, configuration, or external documentation. Only spawn if the stage requires it.

After all subagents return, spawn an Agent with `subagent_type: "general-purpose"` to synthesize:

> You are executing the research phase of a stage. Your job is to synthesize research findings into a compact research file.
>
> **Stage directory**: `<absolute path to <STAGE-DIR>/>`
> **Task directory**: `<absolute path to <DOCS_DIR>/tasks/TASK-ID/>`
> **Project root**: `<absolute path to project root>`
>
> Research findings from subagents:
> <paste subagent summaries here>
>
> Instructions:
> 1. Create `research.md` in the stage directory with four subsections:
>    - **Architecture context**: Relevant patterns, components, design decisions
>    - **Code analysis**: Relevant files with paths and line numbers, current behavior, interfaces, dependencies
>    - **Test context**: Test locations and patterns, reusable fixtures and helpers
>    - **Constraints and risks**: Edge cases, external dependencies, potential breaking changes
> 2. Keep `research.md` compact — distill, don't dump. Include enough detail that planning can work without reading source code.
> 3. Update `Status` in `summary.md` frontmatter to `researched`
> 4. Commit with: `docs(<TASK-ID>): add stage <N> research`
> 5. Return a summary of what was found
> 6. DO NOT create an implementation plan
> 7. DO NOT MAKE CHANGES TO THE CODE

**After the subagent returns**: Show the user the research summary. Ask if anything is missing or if they have additional context to add.

---

### Step 2: Planning (subagent)

Verify `Status` is `researched` or `planned` (allow re-runs).

Spawn an Agent with `subagent_type: "general-purpose"`:

> You are executing the planning phase of a stage. Your job is to create a detailed implementation plan based on the research findings.
>
> **Stage directory**: `<absolute path to <STAGE-DIR>/>`
> **Task directory**: `<absolute path to <DOCS_DIR>/tasks/TASK-ID/>`
> **Project root**: `<absolute path to project root>`
>
> Instructions:
> 1. Read `summary.md` and `research.md` in the stage directory
> 2. Read the task-level `summary.md` for high-level context
> 3. If `research.md` references specific files that need closer inspection, read those files (targeted reads only — do NOT broadly explore)
> 4. Create `plan.md` in the stage directory with:
>    - Numbered steps, each referencing specific file paths from research
>    - Expected behavior change for each step
>    - A testing plan with specific test cases and test file locations
>    - Steps ordered for incremental compilation and testing
> 5. Update `Status` in `summary.md` frontmatter to `planned`
> 6. Commit with: `docs(<TASK-ID>): add stage <N> implementation plan`
> 7. Return the implementation plan text
> 8. DO NOT MAKE CHANGES TO THE CODE

**After the subagent returns**: Show the user the implementation plan. Ask for approval before proceeding.

**IMPORTANT**: Do NOT proceed to Step 3 until the user explicitly approves the plan.

---

### Step 3: Implementation (subagent)

Verify `Status` is `planned` or `implemented` (allow re-runs).

Spawn an Agent with `subagent_type: "general-purpose"`:

> You are executing the implementation phase of a stage. Your job is to implement the code changes described in the plan.
>
> **Stage directory**: `<absolute path to <STAGE-DIR>/>`
> **Task directory**: `<absolute path to <DOCS_DIR>/tasks/TASK-ID/>`
> **Project root**: `<absolute path to project root>`
>
> Instructions:
> 1. Read `summary.md` and `plan.md` in the stage directory
> 2. Follow the plan step by step:
>    - Read only the specific files referenced in the plan
>    - Make the code changes described
>    - After each step, verify the code compiles
>    - Follow coding standards from `CLAUDE.md`
> 3. Write tests following the testing plan:
>    - Write tests iteratively: one test -> compile -> run -> pass -> next
>    - Use existing fixtures and patterns — do not duplicate helpers
> 4. Create `implementation.md` in the stage directory with:
>    - Approach taken and any deviations from the plan
>    - Issues encountered and resolutions
>    - Key decisions not covered by the plan
>    - Follow-up work needed
> 5. Update `Status` in `summary.md` frontmatter to `implemented`
> 6. Commit code changes with a descriptive conventional commit message
> 7. Return a summary of what was implemented and test results
> 8. Stick to the plan. If the plan is wrong or incomplete, note it in `implementation.md` rather than deviating silently
> 9. DO NOT update architecture documentation

**After the subagent returns**: Show the user the implementation summary. Ask if they want to proceed to review.

---

### Step 4: Review (subagent)

Verify `Status` is `implemented` or `reviewed` (allow re-runs).

Spawn an Agent with `subagent_type: "general-purpose"`:

> You are executing the review phase of a stage. Your job is to self-review the code changes and fix any issues.
>
> **Stage directory**: `<absolute path to <STAGE-DIR>/>`
> **Task directory**: `<absolute path to <DOCS_DIR>/tasks/TASK-ID/>`
> **Project root**: `<absolute path to project root>`
>
> Instructions:
> 1. Read `plan.md` and `implementation.md` in the stage directory
> 2. Run `git diff <DEFAULT_BRANCH>...HEAD` and review the full diff
> 3. Check for:
>    - **Plan alignment:** Do changes match the plan? Missing steps? Unplanned changes?
>    - **Code quality:** Unused imports/variables, inconsistent naming, missing error handling, dead code, debug statements, security issues
>    - **Test coverage:** All planned test cases covered? Tests actually testing the code?
>    - **Standards:** Check against `CLAUDE.md` conventions
> 4. Fix any minor issues found
> 5. Create `review.md` in the stage directory with:
>    - Summary and overall assessment
>    - Issues found and fixed
>    - Remaining concerns
> 6. Update `Status` in `summary.md` frontmatter to `reviewed`
> 7. If fixes were made, commit with a descriptive conventional commit message
> 8. Return a summary of what was reviewed and any issues found/fixed
> 9. If something requires rethinking the approach, stop and report it rather than attempting a fix

**After the subagent returns**: Show the user the review results. Ask if the diff is ready for their review or if they want changes.

---

### Step 5: Documentation (subagent)

Verify `Status` is `reviewed` or `documented` (allow re-runs).

Spawn an Agent with `subagent_type: "general-purpose"`:

> You are executing the documentation phase of a stage. Your job is to update architecture documentation and write findings.
>
> **Stage directory**: `<absolute path to <STAGE-DIR>/>`
> **Task directory**: `<absolute path to <DOCS_DIR>/tasks/TASK-ID/>`
> **Docs directory**: `<absolute path to <DOCS_DIR>/>`
> **Project root**: `<absolute path to project root>`
>
> Instructions:
> 1. Read `implementation.md` and `review.md` in the stage directory
> 2. Run `git diff <DEFAULT_BRANCH>...HEAD` to see all code changes
> 3. Read `<DOCS_DIR>/architecture/CLAUDE.md` for documentation guidelines
> 4. Read relevant architecture documents in `<DOCS_DIR>/architecture/`
> 5. Update architecture docs to reflect code changes:
>    - Update descriptions of modified components
>    - Add docs for new components
>    - Update file paths and line numbers
>    - Remove docs for deleted code
> 6. Create `findings.md` in the stage directory with:
>    - Learnings useful for future tasks
>    - Patterns discovered
>    - Architectural notes
> 7. Update `Status` in stage `summary.md` frontmatter to `documented`
> 8. Update `Status` in task `summary.md` frontmatter to `stage-<N>-complete`
> 9. Update `<DOCS_DIR>/tasks/Overview.md` with new statuses
> 10. Commit with: `docs(<TASK-ID>): update documentation for stage <N>`
> 11. Return a summary of what documentation was updated

**After the subagent returns**: Tell the user the stage is complete. Suggest:
- To add another stage: `/start-stage <TASK-ID>`
- To create a PR: `/create-pr`

## General guidance
- Each subagent runs in a fresh context — this is the isolation mechanism
- The main context only accumulates: spec + subagent summaries + user responses (stays lean)
- Always wait for user approval after Step 2 (plan) before proceeding to Step 3 (implementation)
- If any subagent reports a failure, stop and ask the user how to proceed
- DO NOT skip steps — the workflow is sequential and each step depends on the previous one
