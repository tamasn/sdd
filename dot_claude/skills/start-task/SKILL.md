---
name: start-task
description: Start a new task from a GitHub issue, JIRA ticket, or user-provided description. Creates the task directory, summary document, branch, and first stage.
argument-hint: "[issue-id | existing-task-id]"
---

# Start Task

Create the task directory, summary document, branch, and the first stage. Captures the specification only — do NOT read source code or architecture docs.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>`, `<DEFAULT_BRANCH>`, and the issue tracker setting.

## Input

`$0` — optional issue ID (GitHub number like `123` or `#123`, JIRA key like `AP-20564`), existing task ID, or omitted for interactive mode.

## Task directory structure

Each task lives in `<DOCS_DIR>/tasks/<TASK-ID>/`. A task contains one or more **stages**. Each stage is a full cycle of research, plan, implement, review, update-docs.

```
<DOCS_DIR>/tasks/<TASK-ID>/
  summary.md                      # Task-level (this skill)
  stage-1-<slug>/
    summary.md                    # Stage-level (this skill)
    research.md                   # /research-stage
    plan.md                       # /plan-stage
    implementation.md             # /implement-stage
    review.md                     # /review-stage
    findings.md                   # /update-docs
  stage-2-<slug>/
    ...
```

## Instructions

### 1. Gather the specification

**If `$0` matches an existing task directory in `<DOCS_DIR>/tasks/`:**

Determine which files already exist inside `<DOCS_DIR>/tasks/<TASK-ID>/`:

- If `summary.md` exists:
  - Read it and ask clarifying questions about scope and non-goals
  - Update if necessary
- If `summary.md` does NOT exist but one or more `stage-*/summary.md` files exist (pre-seeded stage):
  - Read each existing stage `summary.md` for context
  - Ask the user about the overarching goal of the task (what ties the stages together, scope, non-goals)
  - Use that information to create the task-level `summary.md` in step 2
  - Do NOT overwrite or recreate the existing stage directories in step 3 — link them from the task summary and skip stage creation
  - Still update `Overview.md` (step 5) and commit (step 6)

**If the issue tracker is `jira` and `$0` is a JIRA ticket ID:**
- Use the `/read-issue` skill to fetch the ticket details
- Use the ticket ID as the task ID, the ticket assignee as the author

**If the issue tracker is `github` and `$0` is a GitHub issue number:**
- Use the `/read-issue` skill to fetch the issue details
- Use the issue number as the task ID with GH prefix padded to 4 digits (e.g. `GH-0123`)
- Use the issue assignee as the author

**If `$0` is not provided:**
- Ask the user to describe the task
- Ask clarifying questions about scope and non-goals
- Ask if there is an issue ID to use as reference
  - If no issue: generate an ID from the project name (e.g. `AUTH-0001`)
    - 4-letter uppercase prefix based on the project name
    - A number padded to 4 digits, next in sequence
  - If a task directory with the same ID exists, append `-2` (or `-3`, etc.)
- Ask for the author name if unclear

### 2. Create the task directory and summary

If `<DOCS_DIR>/tasks/<TASK-ID>/summary.md` already exists, read it and use its content as the source of information. Ensure the required frontmatter fields and structure below are present, preserving existing content. Move any detailed goal descriptions to the first stage's summary (step 3).

If the file does not exist, create `<DOCS_DIR>/tasks/<TASK-ID>/summary.md`:

```markdown
---
ID: <TASK-ID>
Type: Feature | Bug | Refactor
Author: <author>
Created: <YYYY-MM-DD>
Status: created
CurrentStage: 1
---

# <TASK-ID> - <Brief Summary>

## Overview
Brief context for the task. Detailed goals belong in each stage's summary.

## Stages
- [Stage 1: <slug>](stage-1-<slug>/summary.md)
```

The task-level summary is a table of contents and high-level context. Stage summaries are the primary location for detailed goals.

### 3. Create the first stage

If one or more `stage-*/summary.md` files already exist under `<DOCS_DIR>/tasks/<TASK-ID>/` (pre-seeded stage scenario):
- Skip creation — the stage directories are authoritative
- Ensure each existing stage `summary.md` has the required frontmatter fields and `## Goal` section, preserving existing content
- Make sure the task `summary.md` `## Stages` section lists every existing stage in order
- Continue to step 4

Otherwise, ask the user for a brief slug describing the focus of stage 1 (or derive one from the issue title, e.g. `add-validation`, `fix-timeout`). The slug should be lowercase, hyphen-separated, and 2-4 words.

If `<DOCS_DIR>/tasks/<TASK-ID>/stage-1-<slug>/summary.md` already exists, use it as the starting point. Ensure the required frontmatter fields and `## Goal` section are present, preserving existing content.

If the file does not exist, create `<DOCS_DIR>/tasks/<TASK-ID>/stage-1-<slug>/summary.md`:

```markdown
---
Stage: 1
Slug: <slug>
Status: created
Created: <YYYY-MM-DD>
---

# Stage 1: <Brief Description>

## Goal
Detailed description of what this stage aims to accomplish. This is the primary location for the stage's goals — include all relevant detail here.
```

If the task summary contained detailed goal information, incorporate it into this stage's `## Goal` section.

### 4. Create the branch

Only create a branch if currently on a base branch (`<DEFAULT_BRANCH>`, `main`, `develop`, or `master`); otherwise skip — the branch already exists.

1. Determine the prefix from the task type: `feat/`, `fix/`, `refactor/`, `chore/`, or `docs/`.
2. Build the branch name: `<prefix>/<TASK-ID>-<slug>` (e.g. `feat/AP-20564-email-validation`). Reuse the stage 1 slug.
3. Create the branch: `git checkout -b <branch-name>`.

### 5. Update Overview

Update `<DOCS_DIR>/tasks/Overview.md` (create the file if it doesn't exist, starting with `# Tasks Overview`).

Insert a new entry at the top of the file (below the `# Tasks Overview` heading), in this format:

```markdown
## <TASK-ID> - <Brief Summary>
**Author:** <author> | **Created:** <YYYY-MM-DD> | **Status:** `created`
- [Stage 1: <slug>](<TASK-ID>/stage-1-<slug>/summary.md) — `created`
```

### 6. Commit

Commit with message: `docs(<TASK-ID>): create task document`

## Completion

Suggest the user start a new conversation and run `/research-stage <TASK-ID>`.

## Guidance
- Keep this step lightweight — do NOT read source code or architecture docs
- Ask questions to clarify the goal, scope, and non-goals
- Aim for the smallest possible scope that can be done in a day
- DO NOT MAKE CHANGES TO THE CODE
