# Command: status

Show progress overview with state machine visualization.

## Steps

1. **Scan tracks**: `./skill-conductor/tracks/*/metadata.json`
2. **Display visualization**:
```
Track: 2026-03-23_musculoskeletal  [family-doctor]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase 1: Research & Design     ✅ Complete
Phase 2: Create SKILL.md       ⏳ In Progress (2/3)
Phase 3: Update Routing        ⬜ Pending
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Overall: ██████████░░░░░░░░░░ 40%
```
3. **Update registry**: Run `sync-registry.sh` on current project
