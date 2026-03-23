---
title: "Command: status"
tags:
  - skill-conductor
  - command
date: 2026-03-23
---

# Command: status

Show progress overview with state machine visualization.

## Steps

1. **Read tracks-registry**: `<workspace>/tracks.md`
2. **Scan tracks**: `<workspace>/tracks/*/metadata.json` and `<workspace>/tracks/*/plan.md`
3. **Auto-calculate status** from plan.md:
   - All `[x]` → `✅ Complete`
   - Some `[x]`, some `[ ]` → `⏳ In Progress`
   - All `[ ]` → `⬜ Pending`
4. **Update tracks.md**: Refresh Status column based on calculated status
5. **Display visualization**:
```
Track: musculoskeletal-care
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase 1: Research & Design     ✅ Complete
Phase 2: Create SKILL.md       ⏳ In Progress (2/3)
Phase 3: Update Routing        ⬜ Pending
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Overall: ██████████░░░░░░░░░░ 40%
```
6. **Update project status** in tracks-registry if all tracks are complete or pending
