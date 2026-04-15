---
name: read-issue
description: Fetch issue details from GitHub Issues or JIRA, based on project configuration.
argument-hint: "<issue-id>"
---

# Read Issue

Fetch issue details from the configured issue tracker.

## Configuration

Read [config.md](../_shared/config.md) to determine the **Issue tracker** setting (`github` or `jira`).

## Input

`$0` — the issue identifier:
- **GitHub**: issue number (e.g. `123` or `#123`)
- **JIRA**: issue key (e.g. `AP-20564`)

## Instructions

### If issue tracker is `github`

1. Strip any `#` prefix from the issue number
2. Run `gh issue view <number> --json number,title,body,state,assignees,labels,comments`
3. Parse and present the results

Output fields:
- `number`: The issue number
- `title`: The issue title (main summary)
- `body`: The full issue description (markdown)
- `state`: Current state (`OPEN` or `CLOSED`)
- `assignees`: List of assigned users
- `labels`: List of labels
- `comments`: List of comments with author and body

### If issue tracker is `jira`

1. Validate the issue key matches `[A-Z]+-[0-9]+`
2. Run `${CLAUDE_SKILL_DIR}/read-jira.sh <issue-key>`
3. Parse and present the results

Output fields:
- `key`: The JIRA issue key
- `summary`: The issue title
- `description`: The full description (may contain HTML)
- `status`: Current status
- `assignee`: Assigned user
- `labels`: List of labels

## Output

Present the issue details in a readable format regardless of the source tracker.
