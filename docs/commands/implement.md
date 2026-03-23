---
title: "Command: implement"
tags:
  - skill-conductor
  - command
date: 2026-03-23
---

# Command: implement

Execute the next pending task in the active track's plan.

## Steps

1. **Find active track**: Read metadata.json for `status: "in_progress"`
2. **Determine checkpoint strategy**: Count tasks in plan.md
   - ≤ 3 tasks: checkpoint at end only
   - 4-8 tasks: checkpoint at each phase boundary
   - 9+ tasks: checkpoint at each phase + mid-phase for risky tasks
3. **Execute**: Find first `[ ]` task, perform it
4. **SKILL.md format rules** (when creating/modifying):
   - `description` must be single-line string (double quotes, no `|` or `>`)
   - `description` ≤ 1024 characters
   - `name` lowercase + hyphens, ≤ 64 characters
   - Include natural language trigger patterns
   - Verify format rules via WebSearch if unsure
5. **Update checklist**: `[ ]` → `[x]`, pause at checkpoint boundaries for user verification
6. **Show state**: Display progress visualization with percentage bar
