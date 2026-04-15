---
name: research-stage
description: Research a stage by exploring the codebase and architecture docs. Writes distilled findings to research.md so subsequent steps don't need to read code.
argument-hint: "<task-id> [stage-number]"
---

# Research Stage

Explore the codebase and architecture docs, then write a compact `research.md` that captures everything subsequent steps need. This step will fill the context window — that's expected.

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
- `<DOCS_DIR>/architecture/` — system design docs
- Source code — as needed

## Writes

- `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/research.md`
- Updates `Status` in `<STAGE-DIR>/summary.md` to `researched`

## Instructions

### 1. Read task and stage summaries

Read `<STAGE-DIR>/summary.md` for the stage goal — this is the primary source of what to accomplish. Read `<DOCS_DIR>/tasks/<TASK-ID>/summary.md` for high-level context (use as fallback if the stage summary lacks detail). Verify stage `Status` is `created` or `researched` (allow re-runs).

### 2. Explore architecture documentation

Read files in `<DOCS_DIR>/architecture/` for system design, patterns, conventions, and integration points relevant to the stage goal.

### 3. Explore source code

For each area affected by the stage Goal:
- File paths and key line numbers
- Current behavior of code that will be modified
- Interfaces, types, and data structures
- Dependencies (callers and callees)
- How similar features are already implemented (patterns to follow)
- Test locations, frameworks, reusable fixtures
- Constraints: compiler flags, config, external dependencies

### 4. Write research.md

Create `<DOCS_DIR>/tasks/<TASK-ID>/<STAGE-DIR>/research.md`:

```markdown
# Research — <TASK-ID> Stage <N>

## Architecture context
Relevant patterns, components, design decisions, and constraints.

## Code analysis
For each affected area:
- File path and key line numbers
- Current behavior
- Interfaces and types
- Dependencies and call chains

## Test context
- Test locations and patterns
- Reusable fixtures and helpers

## Constraints and risks
- Edge cases, external dependencies, potential breaking changes
```

**Distill, don't dump.** Compact summary with specific file:line references. A developer should understand the full picture in 2-3 minutes. Include enough detail that `/plan-stage` can work without reading source code.

### 5. Update status

Set `Status: researched` in `<STAGE-DIR>/summary.md` frontmatter.

### 6. Ask clarifying questions

Ask the user about anything unclear. Update `research.md` based on answers.

### 7. Commit

Commit with message: `docs(<TASK-ID>): add stage <N> research`

## Completion

Suggest the user start a new conversation and run `/plan-stage <TASK-ID>`.

## Guidance
- Be thorough but concise — read widely, write tightly
- Include specific file paths and line numbers
- Note patterns to follow
- DO NOT create an implementation plan
- DO NOT MAKE CHANGES TO THE CODE
