---
name: init-task
description: Pre-seed a task directory with task and first-stage summaries in `initial` status so the user can flesh them out before running /start-task.
argument-hint: "[issue-id]"
---

# Init Task

Pre-seed the task directory so the user can draft the specification manually before `/start-task` finalizes it. Captures just enough structure from a short Q&A. Does NOT read source code, create a branch, update `Overview.md`, or commit.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>` and the issue tracker setting.

## Input

`$0` — optional issue ID (GitHub number like `123` or `#123`, JIRA key like `AP-20564`). When provided, skips the linked-ticket question.

## Instructions

### 1. Ask the user

Ask (one at a time or grouped — whichever reads better):

1. **Brief summary** — a one-line description of the task.
2. **Linked ticket** — is there an issue ID? If `$0` was provided, skip.
   - If the issue tracker is `jira` and the answer looks like a JIRA key, or `github` and it looks like a number, use `/read-issue` to fetch details. Use the ticket summary as the brief summary if the user didn't provide one, and the ticket assignee as the author default.
3. **Stage 1 scope** — does the first stage have a separate description? If yes, capture it. If no, the first stage inherits the task's brief summary as its goal.
4. **Author** — infer the default from `git config user.name`. Confirm or let the user override.

### 2. Decide `<TASK-ID>`

- **JIRA ticket**: use the key as-is (e.g. `AP-20564`).
- **GitHub issue**: use `GH-` + the issue number padded to 4 digits (e.g. `GH-0123`).
- **No linked ticket**: generate `<PREFIX>-NNNN` where `<PREFIX>` is a 4-letter uppercase tag derived from the project name and `NNNN` is the next available 4-digit sequence number by scanning `<DOCS_DIR>/tasks/` for existing prefixes.

If a task directory with the chosen ID already exists, stop and tell the user — they should either use `/start-task <existing-id>` to continue it or pick a new ID.

### 3. Decide the stage 1 `<slug>`

Derive a lowercase, hyphen-separated, 2-4 word slug from:
- The stage 1 description if provided, otherwise
- The task brief summary.

Confirm the slug with the user if it's not obvious.

### 4. Create the task summary

Create `<DOCS_DIR>/tasks/<TASK-ID>/summary.md`:

```markdown
---
ID: <TASK-ID>
Type: Feature | Bug | Refactor
Author: <author>
Created: <YYYY-MM-DD>
Status: initial
CurrentStage: 1
---

# <TASK-ID> - <Brief Summary>

## Overview
<Short context for the task. Detailed goals belong in each stage's summary.>

## Stages
- [Stage 1: <slug>](stage-1-<slug>/summary.md)
```

Pick `Type` based on the description (Feature / Bug / Refactor). When uncertain, default to `Feature` and note it so the user can correct it during editing.

### 5. Create the first stage summary

Create `<DOCS_DIR>/tasks/<TASK-ID>/stage-1-<slug>/summary.md`:

```markdown
---
Stage: 1
Slug: <slug>
Status: initial
Created: <YYYY-MM-DD>
---

# Stage 1: <Brief Description>

## Goal
<Detailed description of what this stage aims to accomplish. Populate from the stage 1 description (or the task brief summary if no separate stage description was provided). Leave clear placeholders for any detail the user needs to fill in.>
```

### 6. Stop

Do NOT:
- Create a branch
- Update `<DOCS_DIR>/tasks/Overview.md`
- Commit anything

Tell the user:
- The files created, with relative paths
- To edit `stage-1-<slug>/summary.md` to flesh out the `## Goal` and any task-level context
- When ready, flip `Status: initial` to `Status: created` in both files (or simply let `/start-task <TASK-ID>` adopt the pre-seeded content — it will normalize the frontmatter) and run `/start-task <TASK-ID>`

## Guidance
- Keep this step lightweight — do NOT read source code or architecture docs
- Ask minimal clarifying questions; the user will flesh out the summary manually
- Aim for the smallest possible scope that can be done in a day
- DO NOT MAKE CHANGES TO THE CODE
- DO NOT COMMIT
