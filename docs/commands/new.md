---
title: "Command: new"
tags:
  - skill-conductor
  - command
date: 2026-03-23
---

# Command: new

Create a new development track with spec and plan. Uses Socratic questioning.

## Steps

1. **Determine project**: Read `.claude/CLAUDE.md` to find workspace directory (default: `skill-conductor/`)
2. **Determine track name**: Ask user for the track name (e.g., `musculoskeletal-care`, `sleep-optimizer`). This becomes the directory name under `<workspace>/tracks/<name>/`. No date prefix — the creation date is recorded in metadata.json.
3. **Read context** (progressive disclosure): Load `product.md`, `guidelines.md`, `workflow.md`, `references.md`
4. **Search references**: Fetch relevant sources from `references.md` via WebFetch. Ask user for additional references.
5. **Socratic Questioning** (one at a time):
   - What kind of change? (new / modify / delete / other)
   - What problem does this solve? Describe the user scenario.
   - What would a user naturally say? (3-5 example phrases — focus on natural language)
   - Does this interact with existing skills?
   - Any similar skills to reference?
   - What should the output look like?
   - Any edge cases or boundary conditions?
6. **Generate spec.md**: Change type, user scenarios, intent patterns, files, cross-references, acceptance criteria
7. **Generate plan.md**: Adaptive phase count based on complexity:
   - Simple (≤3 tasks): 3 phases (create → validate → publish)
   - Medium (4-8 tasks): 4 phases (create → routing → validate → publish)
   - Complex (9+ tasks): 5 phases (research → create → routing → validate → publish)
8. **Generate metadata.json**: track name, project, status: "in_progress", created_at (ISO date), complexity
9. **Update tracks-registry**: Add the new track to `<workspace>/tracks.md`
10. **Present**: Show spec and plan for user review
