# AI Coding Guidelines
CODEBASE IS SOURCE OF TRUTH. If this doc disagrees with code, code wins.

## Stack
**Node.js backend service**
- Runtime: Node.js (specify version in `.nvmrc` or `package.json` engines)
- Language: TypeScript
- Package manager: npm (or yarn/pnpm — specify)

### Libraries
**List libraries used by the service here**
- Dependencies defined in `package.json`
- Key libraries: (framework, ORM, validation, etc.)

### Databases
**List databases used by the service here, whether they are managed by this service or external, and how**

### External Services
**List all external services used by the service, how they are accessed, whether they have a dedicated client, and if it's a dependency or custom built**

## Programming Standards
**REQUIRED:**
- Strict TypeScript: `strict: true` in `tsconfig.json`
- Prefer `const` over `let`, never use `var`
- Use typed errors and explicit error handling — avoid bare `catch(e)`
- All async code uses `async/await` (no raw Promise chains)
- After changes: `npm run build` (or `npx tsc --noEmit`) to verify
- Before changing logic: describe current behavior, compare changes, confirm no regression

**AVOID:** `any` type, `@ts-ignore`, `console.log` in production code, mutable global state, code duplication

## AI Workflow Settings
<!-- These values are filled in by /bootstrap-project or /bootstrap-documentation -->
- **Docs directory**: `REPLACE_DOCS_DIR`
- **Issue tracker**: `REPLACE_ISSUE_TRACKER`
- **Default branch**: `REPLACE_DEFAULT_BRANCH`

## Documentation

**CRITICAL - Documentation Synchronization:**
- **ALWAYS read relevant documentation BEFORE making code changes**
- **ALWAYS update affected documentation AFTER making code changes**
- **NEVER allow drift between documentation and implementation**

**Documentation Structure:**
- **Architecture**: Service architecture, design decisions, and system logic -> `REPLACE_DOCS_DIR/architecture/`
    - **MUST read** `REPLACE_DOCS_DIR/architecture/CLAUDE.md` before working with architecture docs
    - **MUST follow** documentation-first development process for architectural changes
- **Tasks**: Task descriptions and implementation plans -> `REPLACE_DOCS_DIR/tasks/`

**Guidelines:**
- Each subdirectory has its own `CLAUDE.md` with specific requirements
- Always consult the appropriate `CLAUDE.md` before creating or editing documents in that directory

## Testing

### Critical Constraints
- Use Jest (or Vitest — specify preference)
- Tests should mirror the main source structure in `__tests__/` or co-located as `*.test.ts`
- Test file naming: `<ComponentName>.test.ts`
- Test groups: `describe('ComponentName', ...)` — describe the feature/component
- Test cases: `it('should <expected behavior>', ...)` — describe expected behavior
- Use factory functions or fixtures instead of repeating setup

### Incremental Test Development Loop
When writing tests in this project, follow this workflow:
1. Don't create all tests all at once.
2. When creating a new type of test (new suite / new mock setup / new integration test), start by creating only ONE test.
3. Always check if the tests compile with `npx tsc --noEmit` before you try to run them.
4. Run `npm test` (or `npx jest <testFile>`) and confirm the first test passes.
5. Only after the first test passes, create the rest of the tests for that type.
6. If tests are failing for a reason you haven't seen before, update the test documentation with the learnings.
7. Repeat this loop for each type of test.
