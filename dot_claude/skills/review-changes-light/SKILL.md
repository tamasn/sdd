---
name: review-changes-light
description: Self-review the current branch diff for code quality, standards, and goal alignment without requiring a task document. Light variant of /review-stage.
argument-hint: ""
---

# Review Changes (Light)

Self-review the full local diff (committed and uncommitted) on the current branch. No task documents read or written. Check goal alignment (against the conversation), code quality, test coverage, and standards. May make minor fixes directly. For anything substantive, stop and discuss.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>` and `<DEFAULT_BRANCH>`.

## Reads

- Branch diff (`git diff <DEFAULT_BRANCH>...HEAD` plus any uncommitted changes)
- `CLAUDE.md` at project root and any nested `CLAUDE.md` files in affected directories
- Conversation context — what the user asked for in this conversation

## Writes

- Optional minor code fixes

## Instructions

### 1. Determine the diff scope

Identify the full set of local changes:

- Committed: `git diff <DEFAULT_BRANCH>...HEAD` (or `git diff @{u}...HEAD` if upstream is set)
- Staged: `git diff --cached`
- Unstaged: `git diff`
- Untracked: `git status --porcelain` (read `??` files when relevant)

A convenient single view is `git diff <DEFAULT_BRANCH>` (or `git diff @{u}`). Always also check `git status` for untracked files and overall state.

If nothing is pending, stop and tell the user there is nothing to review.

### 2. Review the diff

Inspect the full diff for:

**Goal alignment:** Do the changes accomplish what the user asked for in this conversation? Anything missing or out of scope? (Use the conversation as the source of truth — there is no `plan.md`.)

**Code quality:** Unused imports/variables, inconsistent naming, missing error handling, null/undefined risks, dead code, debug/print statements left behind, obvious security issues, committed secrets.

**Test coverage:** Are reasonable test cases covered? Are tests real — exercising the code — or fake (asserting on mocks / tautologies)? Are reusable fixtures being used instead of duplicated helpers?

**Standards:** Check against project-root `CLAUDE.md` and any nested `CLAUDE.md` for the directories touched.

**DRY:** Look for duplicated logic across the changes or between new and existing code. Flag opportunities to reuse.

### 3. Fix minor issues

Fix minor issues directly: style, unused imports, stray debug statements, obvious typos, trivial DRY cleanups. For anything substantive — logic changes, reshaping abstractions, altering test strategy — stop and discuss with the user first.

### 4. Summarize inline

Present findings directly in chat (no file written):
- What was reviewed (unpushed commit count, dirty files, untracked files)
- Minor fixes made
- Remaining concerns or questions

### 5. Commit fixes (optional)

If minor fixes were made, ask the user whether to commit them now. On approval, commit with message `chore: review fixes` (or run `/commit-changes-light` for a more tailored message). If no fixes were made, there is nothing to commit.

## Completion

Tell the user the local changes are ready for their review. Summarize findings. Suggest:
- `/update-docs-light` to sync architecture docs
- `/create-pr-light` or `/create-pr-doc` when ready

## Guidance

- Be thorough — this is the last line of defense before reviewers see the code
- Uncommitted and committed changes are treated equally — don't skip uncommitted work
- Only fix minor issues directly. For anything substantive, stop and discuss
- If the user is in the task-document workflow, suggest `/review-stage` (stage-aware) instead
