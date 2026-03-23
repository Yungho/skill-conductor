---
title: "Command: review"
tags:
  - skill-conductor
  - command
date: 2026-03-23
---

# Command: review

Run the 7-step review pipeline on a track's SKILL.md.

## Steps

1. **Find track**: From args or semantic understanding of user input
2. **Verify format rules externally**: Use WebSearch to confirm current requirements (not cached memory)
3. **Run pipeline**:

### ① Structure Validation (FAIL)
Run `validate-skill.sh`. Checks: frontmatter format, description single-line, description ≤ 1024 chars, name format, line count.

### ② Trigger Conflict Detection
Run `check-triggers.sh`. Scans all skills in project for overlapping trigger words.

### ③ Intent Simulation Testing
Generate 10-15 realistic test queries based on user scenarios (not keywords). Simulate which skill each query would trigger. Include edge cases and ambiguous queries.

### ④ Routing Completeness
For sub-skills: check entry-point routing table, description keywords, cross-references.

### ⑤ Spec Consistency
Compare spec.md requirements against actual SKILL.md. Report gaps and extras.

### ⑥ Content Quality
Check: safety boundaries, output format, cross-references, bilingual triggers.

### ⑦ Description Optimization
Analyze description quality. Suggest improved version (show before/after). Recommend skill-creator eval for complex skills.

4. **Report**: Generate summary with PASS/WARN/FAIL per check + overall status
