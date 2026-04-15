# Agent Instructions

This directory contains documentation for architecture and task documents.

## **CRITICAL**: Subdirectory-Specific Instructions

When creating or updating files anywhere in this directory tree, you **MUST**:

1. **Check for `CLAUDE.md`** in the target file's directory and all parent directories
2. **Read ALL discovered `CLAUDE.md` files** from the tree
3. **Follow the instructions** from all applicable `CLAUDE.md` files, with more specific (deeper) directories taking precedence

### Examples:
- **Before** creating or editing any file in `architecture/`, read `architecture/CLAUDE.md`
- **Before** creating or editing any file in `tasks/`, read `tasks/CLAUDE.md`
- If a subdirectory has its own `CLAUDE.md`, read both the parent and child `CLAUDE.md`

### Architecture documentation:
- **Before modifying code**, read relevant architecture documentation in `architecture/`
- **After modifying code**, update all affected architecture documentation to prevent drift
- See `architecture/CLAUDE.md` for complete architecture documentation guidelines

**Failure to follow subdirectory-specific instructions will result in inconsistent documentation.**

## General Guidelines

- Keep documents synchronized with code — update documents when code changes
- Use precise references to code locations (file paths and line numbers)
- Include implementation plans before executing significant changes
- Track implementation issues in the "Implementation notes" section

## PR Guidelines

Use this structure for PR body when running `gh pr create`:

```markdown
### Summary
One paragraph: what this PR does and why.

### Changes
- Bullet list of significant changes

### Testing
- What was tested, how, and the result

### Documentation
- What docs were updated
```
