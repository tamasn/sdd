---
name: start-stage
description: Start a new stage within an existing task. Creates the stage directory and summary document.
argument-hint: "<task-id>"
---

# Start Stage

Create a new stage within an existing task. A stage is a full cycle of research, plan, implement, review, update-docs.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>`.

## Input

`$0` — task ID (e.g. `AP-20564`, `GH-0123`). Locates `<DOCS_DIR>/tasks/<TASK-ID>/`.

## Instructions

### 1. Validate the task

Read `<DOCS_DIR>/tasks/<TASK-ID>/summary.md`. Verify the task exists and has at least one completed stage (or the user explicitly wants to add a new stage).

### 2. Determine stage number

Scan `<DOCS_DIR>/tasks/<TASK-ID>/` for existing `stage-N-*` directories.

Check if the highest-numbered stage directory already has a `summary.md` with `Status: created`. If so, this stage was created manually and should be adopted as-is — skip to step 4 (adopt) instead of creating a new directory.

Otherwise, the new stage number is `max(N) + 1`.

### 3. Gather stage details

Skip this step if adopting a pre-existing stage (step 2).

Ask the user:
- What is the goal of this stage?
- A brief slug describing the focus (e.g. `add-validation`, `fix-edge-cases`). The slug should be lowercase, hyphen-separated, and 2-4 words. Derive from the user's description if not explicitly provided.

### 4. Create the stage directory and summary

**Adopting a pre-existing stage:** If step 2 found a manually created stage, read its `summary.md` and use it as the starting point. Ensure the required frontmatter fields (`Stage`, `Slug`, `Status`, `Created`) and `## Goal` section are present, preserving existing content. Do not overwrite the goal or other content the user wrote.

**Creating a new stage:** If no pre-existing stage was found, create `<DOCS_DIR>/tasks/<TASK-ID>/stage-<N>-<slug>/summary.md`:

```markdown
---
Stage: <N>
Slug: <slug>
Status: created
Created: <YYYY-MM-DD>
---

# Stage <N>: <Brief Description>

## Goal
Detailed description of what this stage aims to accomplish. This is the primary location for the stage's goals — include all relevant detail here.
```

### 5. Update task summary

In `<DOCS_DIR>/tasks/<TASK-ID>/summary.md`, update:
- `CurrentStage: <N>`
- `Status: in-progress`

### 6. Update Overview

In `<DOCS_DIR>/tasks/Overview.md`, find the entry for `<TASK-ID>` and:
- Update the task status to `in-progress`
- Add a new stage line at the end of the task's stage list:
  ```
  - [Stage <N>: <slug>](<TASK-ID>/stage-<N>-<slug>/summary.md) — `created`
  ```

### 7. Commit

Commit with message: `docs(<TASK-ID>): create stage <N>`

## Completion

Suggest the user start a new conversation and run `/research-stage <TASK-ID>`.

## Guidance
- Keep this step lightweight — do NOT read source code or architecture docs
- Ask questions to clarify the stage goal and scope
- Each stage should be small enough to complete in a focused session
- DO NOT create a branch — the task branch already exists
- DO NOT MAKE CHANGES TO THE CODE
