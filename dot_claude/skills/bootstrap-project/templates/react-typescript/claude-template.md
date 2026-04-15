# AI Coding Guidelines
CODEBASE IS SOURCE OF TRUTH. If this doc disagrees with code, code wins.

## Stack
**React TypeScript frontend**
- Framework: React with TypeScript
- Build tool: Vite
- Package manager: npm (or yarn/pnpm — specify)

### Libraries
**List libraries used by the project here**
- Dependencies defined in `package.json`
- Key libraries: (state management, routing, UI components, etc.)

### External Services
**List all external APIs/services consumed by the frontend, how they are accessed, and authentication approach**

## Programming Standards
**REQUIRED:**
- Strict TypeScript: `strict: true` in `tsconfig.json`
- Functional components only — no class components
- Prefer `const` over `let`, never use `var`
- Props must be typed with explicit interfaces (not inline)
- Custom hooks for reusable logic — prefix with `use`
- After changes: `npm run build` to verify (catches type errors and unused imports)
- Before changing logic: describe current behavior, compare changes, confirm no regression

**AVOID:** `any` type, `@ts-ignore`, `console.log` in production code, prop drilling beyond 2 levels (use context or state management), inline styles (use CSS modules or styled components), code duplication

**Component structure:**
- One component per file
- File name matches component name: `ComponentName.tsx`
- Co-locate styles, tests, and types with the component when practical

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
- **Architecture**: Application architecture, design decisions, and patterns -> `REPLACE_DOCS_DIR/architecture/`
    - **MUST read** `REPLACE_DOCS_DIR/architecture/CLAUDE.md` before working with architecture docs
    - **MUST follow** documentation-first development process for architectural changes
- **Tasks**: Task descriptions and implementation plans -> `REPLACE_DOCS_DIR/tasks/`

**Guidelines:**
- Each subdirectory has its own `CLAUDE.md` with specific requirements
- Always consult the appropriate `CLAUDE.md` before creating or editing documents in that directory

## Testing

### Critical Constraints
- Use Vitest (or Jest — specify preference) with React Testing Library
- Tests should mirror the main source structure, co-located as `*.test.tsx`
- Test file naming: `<ComponentName>.test.tsx`
- Test groups: `describe('ComponentName', ...)` — describe the component/feature
- Test cases: `it('should <expected behavior>', ...)` — describe expected behavior
- Test user behavior, not implementation details
- Use `screen` queries (getByRole, getByText) over `container.querySelector`
- Use `userEvent` over `fireEvent` for user interactions

### Incremental Test Development Loop
When writing tests in this project, follow this workflow:
1. Don't create all tests all at once.
2. When creating a new type of test (new component test / new hook test / new integration test), start by creating only ONE test.
3. Always check if the tests compile with `npx tsc --noEmit` before you try to run them.
4. Run `npm test` (or `npx vitest <testFile>`) and confirm the first test passes.
5. Only after the first test passes, create the rest of the tests for that type.
6. If tests are failing for a reason you haven't seen before, update the test documentation with the learnings.
7. Repeat this loop for each type of test.
