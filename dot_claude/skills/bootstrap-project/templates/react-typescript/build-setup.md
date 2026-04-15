# React TypeScript Build Setup

## Instructions

1. Scaffold with Vite:
   - Use `npm create vite@latest . -- --template react-ts` (or set up manually if the directory isn't empty)
   - Verify `vite.config.ts` exists with React plugin

2. Update `tsconfig.json` with strict settings:
   - `"strict": true`
   - `"noUncheckedIndexedAccess": true`
   - `"noImplicitOverride": true`

3. Set up directory structure:
   ```
   src/
     components/       # Reusable UI components
     pages/            # Route-level components (if using routing)
     hooks/            # Custom hooks
     types/            # Shared type definitions
     utils/            # Utility functions
     App.tsx           # Root component
     main.tsx          # Entry point
   ```

4. Create `.nvmrc` with the Node.js version

5. Ask about:
   - State management (React Context, Zustand, Redux Toolkit, etc.)
   - Routing needs (React Router, TanStack Router, etc.)
   - UI component library (none, shadcn/ui, MUI, etc.)
   - Styling approach (CSS Modules, Tailwind, styled-components, etc.)
   - API layer (fetch, Axios, TanStack Query, etc.)

## Default dependencies

- React + React DOM
- TypeScript (dev)
- Vite with `@vitejs/plugin-react` (dev)
- Vitest + React Testing Library (dev)
- ESLint with TypeScript and React plugins (dev)

## Scripts

```json
{
  "dev": "vite",
  "build": "tsc && vite build",
  "preview": "vite preview",
  "test": "vitest",
  "lint": "eslint src/"
}
```
