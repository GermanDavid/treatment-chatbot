# Development Guidelines for Claude

## Project Setup & Commands
```bash
npm install            # Install dependencies
npm run chat           # Start local development (Supabase + NextJS)
npm run dev            # Start NextJS development server
npm run build          # Build for production
npm run preview        # Build and start production preview
npm test               # Run Jest tests
npm run type-check     # Check TypeScript types
npm run lint           # Check for linting issues
npm run lint:fix       # Fix linting issues
npm run format:write   # Format code with Prettier
npm run clean          # Run lint:fix and format:write
npm run db-types       # Generate TypeScript types from Supabase
npm run db-migrate     # Run Supabase migrations
npm run db-reset       # Reset Supabase database
```

## Code Style
- Double quotes for strings (no single quotes)
- No semicolons (enforced by Prettier)
- 2 space indentation (no tabs)
- Arrow functions without parentheses for single parameters
- No trailing commas
- Organized imports (follow order in prettier.config.cjs)
- Use React functional components with TypeScript interfaces
- Use React hooks for state and side effects (useState, useContext, useRef)
- Error handling with try/catch and toast for user feedback
- Use absolute imports with @ prefix for project files