# Skill Conductor

**Plan twice, build once.**

A Claude Code skill that orchestrates the complete lifecycle of skill development using a Conductor-inspired workflow: **Context → Spec → Plan → Implement → Review → Publish**.

## What It Does

Skill Conductor helps you develop, track, and publish skills for Claude Code (and compatible platforms). It provides:

- **Socratic questioning** — Guides you through creating project context and skill specifications
- **Structured workflow** — Every change goes through spec → plan → implement → review → publish
- **Automated validation** — Checks SKILL.md format, trigger conflicts, and description quality
- **Multi-project support** — Manage skills across multiple projects from a single workspace
- **Trigger simulation** — Test if your skills will actually be triggered by real user queries

## Installation

```bash
# Clone into your skills directory
git clone https://github.com/Yungho/skill-conductor.git ~/.claude/skills/skill-conductor
```

## Usage

```
/skill-conductor setup          # Initialize project context (once per project)
/skill-conductor new <desc>     # Create a new development track
/skill-conductor implement      # Execute next pending task
/skill-conductor status         # Show progress overview
/skill-conductor review <id>    # Run 7-step review pipeline
/skill-conductor publish <id>   # Version + CHANGELOG + Git + GitHub
/skill-conductor validate <path> # Quick validate a SKILL.md
```

## Workflow

```
setup (Socratic → project-context.md + guidelines.md + workflow.md)
  ↓
new (Socratic → spec.md + plan.md + metadata.json)
  ↓
implement (follow plan, update checklist)
  ↓
review (7-step pipeline: structure, triggers, simulation, routing, spec, quality, optimization)
  ↓
publish (version, changelog, git, github)
```

## Workspace Structure

```
~/.skill-conductor/
├── registry.md                     # Global skill index
└── projects/
    └── <project-name>/
        ├── project-context.md      # Project definition
        ├── guidelines.md           # Writing standards
        ├── workflow.md             # Development process
        ├── references.md           # Reference sources
        └── tracks/
            └── <date>_<name>/
                ├── spec.md         # Requirements
                ├── plan.md         # Task checklist
                └── metadata.json   # Track metadata
```

## Key Rules

1. **Description must be single-line** — Never use `|` or `>` YAML multi-line format
2. **Description ≤ 1024 characters** — Longer descriptions get truncated
3. **References are per-project** — Each project configures its own reference sources

## Inspired By

- [Conductor](https://github.com/gemini-cli-extensions/conductor) — Gemini CLI extension for context-driven development
- [Agent Skills](https://agentskills.io) — Open standard for AI agent skills

## License

MIT
