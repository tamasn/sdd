# Node.js Service Build Setup

## Instructions

1. Create `package.json` with:
   - Project name based on the directory name
   - `"type": "module"` for ESM
   - Scripts: `build`, `start`, `dev`, `test`, `lint`
   - Engine requirement for Node.js version

2. Create `tsconfig.json` with strict settings:
   - `"strict": true`
   - `"noUncheckedIndexedAccess": true`
   - `"noImplicitOverride": true`
   - `"target": "ES2022"`, `"module": "NodeNext"`
   - `"outDir": "./dist"`, `"rootDir": "./src"`

3. Create `.nvmrc` with the Node.js version

4. Set up directory structure:
   - `src/` — application source
   - `src/index.ts` — entry point
   - `src/__tests__/` or co-located test files

5. Ask about:
   - HTTP framework preference (Express, Fastify, Hono, etc.)
   - Database needs
   - Authentication requirements

## Default dependencies

- TypeScript (dev)
- `@types/node` (dev)
- Jest or Vitest (dev, ask preference)
- ESLint with TypeScript plugin (dev)
- HTTP framework (ask preference)

## Scripts

```json
{
  "build": "tsc",
  "start": "node dist/index.js",
  "dev": "tsx watch src/index.ts",
  "test": "jest",
  "lint": "eslint src/"
}
```
