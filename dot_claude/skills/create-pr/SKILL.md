---
name: create-pr
description: Validate, push, and create or update a draft pull request using gh CLI.
---

# Create Pull Request

Validate the build, push the branch, and create (or update) a draft PR. One PR per task, covering all stages.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>` and `<DEFAULT_BRANCH>`.

## Prerequisites

- Current branch has commits on a feature/bugfix branch
- `gh` CLI is installed and authenticated

## Instructions

1. **Locate task directory**: Find the `<DOCS_DIR>/tasks/<TASK-ID>/` directory for the current branch. Read task `summary.md`.
2. **Collect stage summaries**: Scan all `stage-N-*` directories. For each stage, read `summary.md` and `implementation.md` (if present).
3. **Validate build**: Check `<DOCS_DIR>/architecture/CLAUDE.md` or `Tech-Stack.md` for the project's build/test commands. Run them. Fix errors or ask for guidance.
4. **Check PR conventions**: Look for conventions in `<DOCS_DIR>/architecture/CLAUDE.md`. Default title: `<type>(<scope>): <description>`.
5. **Push branch**: `git push origin HEAD`
6. **Check for existing PR**: Run `gh pr list --head $(git branch --show-current) --json number,url --jq '.[0]'` to see if a PR already exists for this branch.
7. **Create or update PR**:
   - **If no existing PR**: `gh pr create --draft` with:
     - Base branch: `<DEFAULT_BRANCH>`
     - Title following project conventions
     - Body generated from all stages (see PR body format below)
   - **If PR exists**: `gh pr edit <number>` with updated body regenerated from all stages.
8. **Update task status**: Set `Status: pr-created` in task `summary.md`.
9. **Update Overview**: In `<DOCS_DIR>/tasks/Overview.md`, update the task's status to `pr-created`.
10. **Share PR URL**

## PR body format

```markdown
## Summary
<Overall task goal from task summary.md>

## Stages

### Stage 1: <slug>
<Goal and key changes from stage-1 summary.md and implementation.md>

### Stage 2: <slug>
<Goal and key changes from stage-2 summary.md and implementation.md>
...

## Testing
<Testing performed across all stages>

## Breaking changes
<Any breaking changes, or "None">
```
