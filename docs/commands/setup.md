---
title: "Command: setup"
tags:
  - skill-conductor
  - command
date: 2026-03-23
---

# Command: setup

Initialize a project for skill development. Uses Socratic questioning to gather context and generate standardized files.

## Steps

1. **Check workspace**: Create `./skill-conductor/` and `./skill-conductor/tracks/` in the current project directory if they don't exist
2. **Socratic Questioning** (one at a time, adapt based on answers):
   - What does this skill project do? (one sentence)
   - Who's the target user?
   - What domains/areas does it cover?
   - Is there a hierarchy? Entry-point + sub-skills?
   - What language? (中文/English/bilingual)
   - Safety boundaries? What should skills NOT do?
   - Reference sources? (GitHub repos, docs, URLs)
   - Trigger strategy? (keywords, semantic, both)
   - Platform? (Obsidian, CLI, web app)
   - Output format? (Markdown, JSON, tables)
3. **Generate files** from templates into `./skill-conductor/`:
   - `product.md` — project definition
   - `guidelines.md` — writing standards
   - `workflow.md` — development process
   - `references.md` — reference sources
   - `tracks-registry.md` — empty tracks registry
   - `index.md` — project index
4. **Verify format rules**: Use WebSearch to confirm current Claude Code SKILL.md requirements
5. **Validate**: Run `validate-workspace.sh ./skill-conductor/` to verify the setup
