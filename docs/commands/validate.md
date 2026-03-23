---
title: "Command: validate"
tags:
  - skill-conductor
  - command
date: 2026-03-23
---

# Command: validate

Quick validation of a single SKILL.md file.

## Steps

1. **Verify format rules externally**: Use WebSearch to confirm current Claude Code requirements
2. **Run validation**:
```bash
bash "${CLAUDE_SKILL_DIR}/scripts/validate-skill.sh" <path>
```
3. **Report**: Show results and suggestions
