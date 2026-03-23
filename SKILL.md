---
name: skill-conductor
description: "Plan, track, and ship skills for Claude Code. Orchestrates the full development lifecycle: setup project context, write specs, create plans, implement, review quality, and publish to GitHub. Use this whenever creating new skills, iterating on existing skills, managing skill development projects, reviewing SKILL.md files, or publishing skill releases. Works for both single skills and skill collections. Triggers: skill conductor, new skill, create skill, skill planning, skill workflow, skill development, skill review, skill publish, skill track, 做计划, 技能开发, 流程管理, 技能审查, 发布技能, ship skill, deploy skill, release skill, manage skills, skill project, skill iteration, write SKILL.md, plan a skill, review my skill."
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch, WebSearch
---

# Skill Conductor

Skill development workflow orchestrator. Inspired by [Conductor](https://github.com/gemini-cli-extensions/conductor).

**Workflow**: Context → Spec → Plan → Implement → Review → Publish

## Command Details

Detailed instructions for each command are in `${CLAUDE_SKILL_DIR}/docs/commands/`:

| Command | File | When to use |
|---------|------|-------------|
| `setup` | [setup.md](docs/commands/setup.md) | First time configuring a project for skill development |
| `new` | [new.md](docs/commands/new.md) | Starting a new skill or iteration |
| `implement` | [implement.md](docs/commands/implement.md) | Executing tasks from a plan |
| `status` | [status.md](docs/commands/status.md) | Checking progress across projects |
| `review` | [review.md](docs/commands/review.md) | Quality checks before publishing |
| `publish` | [publish.md](docs/commands/publish.md) | Version bump + Git + GitHub release |
| `validate` | [validate.md](docs/commands/validate.md) | Quick check of a single SKILL.md |

Read the relevant command file when that command is invoked.

## Multi-Project Support

Each project maintains its **own independent workspace**. The workspace name is configurable (default: `skill-conductor/`). Set it in your project's `.claude/CLAUDE.md`.

```
project-a/                          project-b/
├── skill-conductor/                ├── conductor/          ← custom name
│   ├── index.md                    │   ├── index.md
│   ├── product.md                  │   ├── product.md
│   ├── guidelines.md               │   ├── guidelines.md
│   ├── workflow.md                 │   ├── workflow.md
│   ├── references.md               │   ├── references.md
│   ├── tracks.md                   │   ├── tracks.md
│   └── tracks/                     │   └── tracks/
│       └── <track-id>/             │       └── <track-id>/
│           ├── index.md            │           ├── index.md
│           ├── spec.md             │           ├── spec.md
│           ├── plan.md             │           ├── plan.md
│           └── metadata.json       │           └── metadata.json
└── some-skill/                     └── src/
    └── SKILL.md
```

Track directories use the user-specified name (e.g., `musculoskeletal-care`), not a date prefix. The creation date is stored in `metadata.json`.

To find the workspace, check the current working directory for the configured workspace directory. If it doesn't exist, `setup` will create it.

**CLAUDE.md**: The `.claude/CLAUDE.md` file (included with this skill) provides file resolution protocol and default paths. Copy it into your project's `.claude/` directory.

Templates: `${CLAUDE_SKILL_DIR}/templates/`
Scripts: `${CLAUDE_SKILL_DIR}/scripts/`

## Design Principles

### 1. Intent Recognition

Understand what the user **means**, not the exact words they use. A user saying "I need something to track my bunions and knee pain" intends to create a new skill (`new`), even though they didn't say "new" or "skill". Parse intent semantically before falling back to literal command parsing.

### 2. Progressive Disclosure

Load context incrementally. SKILL.md is always in context. Command-specific details, templates, and scripts load only when the relevant command is invoked. This keeps the base context lean.

### 3. Adaptive Checkpoints

Simple tracks (≤3 tasks) need a checkpoint only at the end. Medium tracks (4-8 tasks) checkpoint at phase boundaries. Complex tracks (9+ tasks) checkpoint at each phase plus mid-phase for risky tasks. Read plan.md first to count tasks, then set the strategy.

### 4. External Verification

Claude Code's SKILL.md format rules may change. Before validating, use `WebSearch` to verify current requirements (description length limit, required fields, format constraints). Don't rely on cached knowledge — it can become stale.

### 5. Socratic Questioning

Before generating any file, ask questions to understand the user's context. One question at a time. The quality of generated files depends on the quality of gathered context.

## Key Format Rules

These rules prevent the most common failure mode — skills that silently don't get discovered by Claude Code:

- `description` must be a **single-line string** in double quotes. YAML multi-line format (`|` or `>`) causes silent discovery failure.
- `description` must be ≤ 1024 characters. Longer descriptions get truncated.
- `name` must be lowercase with hyphens only, ≤ 64 characters.
- SKILL.md should stay under 500 lines. Move detailed reference material to separate files.

Always verify these rules externally via WebSearch before applying them — the limits may have changed.

## Content Creation

When creating or editing `.md` files, prefer Obsidian-compatible Markdown if the project runs in Obsidian:

- **obsidian-markdown** — Wikilinks, callouts, embeds, properties, Mermaid, math
- **obsidian-bases** — Database-like views with filters and formulas
- **obsidian-json-canvas** — Visual mind maps and flowcharts
- **obsidian-cli** — Vault operations from CLI

For non-Obsidian users, fall back to standard Markdown (no wikilinks, no callouts, no `%%comments%%`). All templates include YAML frontmatter which works in both Obsidian and standard Markdown processors.
