---
name: init-stage
description: Pre-seed a new stage summary in `initial` status inside the active task so the user can flesh it out before running /start-stage.
argument-hint: "[task-id]"
---

# Init Stage

Pre-seed the next stage directory inside the currently active task so the user can draft the goal manually before `/start-stage` finalizes it. Does NOT update the task summary, update `Overview.md`, or commit.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>`.

## Input

`$0` — optional task ID. If omitted, the active task is auto-detected.

## Instructions

### 1. Determine the active task

If `$0` is provided, use it directly. Otherwise, auto-detect:

1. Read `<DOCS_DIR>/tasks/Overview.md` and collect every task whose status is `in-progress`, `created`, or `stage-<N>-complete`.
2. Read the current git branch (`git rev-parse --abbrev-ref HEAD`). If it matches `*/<TASK-ID>-*` (e.g. `feat/AP-20564-...`), extract the task ID.
3. Resolve:
   - If exactly one candidate matches across both signals, use it.
   - If multiple candidates exist (or the branch-derived ID isn't in Overview), list them and ask the user to pick.
   - If none are found, stop and tell the user to run `/init-task` or `/start-task` first.

Verify the chosen `<DOCS_DIR>/tasks/<TASK-ID>/` directory exists; stop with a clear error if not.

### 2. Warn if prior stage is not complete

Scan `<DOCS_DIR>/tasks/<TASK-ID>/` for existing `stage-N-*` directories. Find the highest-numbered stage whose status is NOT `initial` and read its `Status`.

- If that status is `documented` (or no non-initial stage exists), proceed silently.
- Otherwise, tell the user which stage is still at which status and ask whether to continue pre-seeding a new stage. Only proceed on an explicit affirmative.

### 3. Ask the user

- **Short description** of the new stage — one or two sentences describing what this stage aims to accomplish.

### 4. Derive the slug and stage number

- **Slug**: lowercase, hyphen-separated, 2-4 words derived from the description (e.g. `add-validation`, `fix-edge-cases`). Confirm with the user if ambiguous.
- **Stage number `<N>`**: `(count of existing stage-N-* directories) + 1`.

If `<DOCS_DIR>/tasks/<TASK-ID>/stage-<N>-<slug>/` already exists, append a disambiguator to the slug or ask the user for a different one.

### 5. Create the stage summary

Create `<DOCS_DIR>/tasks/<TASK-ID>/stage-<N>-<slug>/summary.md`:

```markdown
---
Stage: <N>
Slug: <slug>
Status: initial
Created: <YYYY-MM-DD>
---

# Stage <N>: <Brief Description>

## Goal
<Populate from the user's short description. Leave clear placeholders for any detail the user needs to fill in.>
```

### 6. Stop

Do NOT:
- Update `<DOCS_DIR>/tasks/<TASK-ID>/summary.md` (its `CurrentStage` / `Status` stay as-is until `/start-stage` runs)
- Update `<DOCS_DIR>/tasks/Overview.md`
- Commit anything

Tell the user:
- The file created, with its relative path
- To edit the summary to flesh out the `## Goal`
- When ready, flip `Status: initial` to `Status: created` (or simply let `/start-stage <TASK-ID>` adopt the pre-seeded content — it will normalize the frontmatter) and run `/start-stage <TASK-ID>`

## Guidance
- Keep this step lightweight — do NOT read source code or architecture docs
- Ask minimal clarifying questions; the user will flesh out the summary manually
- Each stage should be small enough to complete in a focused session
- DO NOT create a branch — the task branch already exists
- DO NOT MAKE CHANGES TO THE CODE
- DO NOT COMMIT
