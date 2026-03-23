# Command: new

Create a new development track with spec and plan. Uses Socratic questioning.

## Steps

1. **Determine project**: Use the only project, or ask user to choose
2. **Read context** (progressive disclosure): Load `project-context.md`, `guidelines.md`, `workflow.md`, `references.md`
3. **Search references**: Fetch relevant sources from `references.md` via WebFetch. Ask user for additional references.
4. **Socratic Questioning** (one at a time):
   - What kind of change? (new / modify / delete / other)
   - What problem does this solve? Describe the user scenario.
   - What would a user naturally say? (3-5 example phrases — focus on natural language)
   - Does this interact with existing skills?
   - Any similar skills to reference?
   - What should the output look like?
   - Any edge cases or boundary conditions?
5. **Generate spec.md**: Change type, user scenarios, intent patterns, files, cross-references, acceptance criteria
6. **Generate plan.md**: Adaptive phase count based on complexity:
   - Simple (≤3 tasks): 3 phases (create → validate → publish)
   - Medium (4-8 tasks): 4 phases (create → routing → validate → publish)
   - Complex (9+ tasks): 5 phases (research → create → routing → validate → publish)
7. **Generate metadata.json**: track_id, project, status, date, complexity
8. **Present**: Show spec and plan for user review
