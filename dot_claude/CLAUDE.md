# Global Claude Code Preferences

## General

- Use conventional commit messages always
- Never force-push to shared branches
- Prefer gh CLI for all GitHub operations
- Create draft PRs by default
- When unsure about a change, ask before proceeding
- Always ask clarifying questions
- Look for the smallest set of changes
- Always double check for opportunities to dedupe code, try to make it as DRY as possible

## Writing tests

- Try to avoid duplicating helper functions, create reusable fixtures whenever possible
- Write tests iteratively, don't create all of them all at once
- When a new type of test is created or a new feature is tested make sure that a subset of tests compiles and passes before creating the rest
- Once done, go back and always check if test coverage is up to expectations
- Review the tests and look for fake tests that pass without actually testing the code

## AI Workflow Settings

Workflow skills read their configuration from the **project root `CLAUDE.md`**, not this file. This file only documents the defaults. See `skills/_shared/config.md` for details.

**Defaults** (used when a project's CLAUDE.md has no `## AI Workflow Settings` section):
- Docs directory: `.ai`
- Issue tracker: `jira`
- Default branch: `develop`
