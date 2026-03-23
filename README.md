# Skill Conductor

**Plan twice, build once.**

A Claude Code skill that orchestrates the complete lifecycle of skill development using a Conductor-inspired workflow: **Context → Spec → Plan → Implement → Review → Publish**.

## What It Does

- **Socratic questioning** — Guides you through creating project context and skill specifications
- **Structured workflow** — Every change goes through spec → plan → implement → review → publish
- **Automated validation** — Checks SKILL.md format, trigger conflicts, and description quality
- **Multi-project support** — Each project maintains its own independent workspace
- **Intent recognition** — Understands what you mean, not just the words you use

## Installation

```bash
git clone https://github.com/Yungho/skill-conductor.git ~/.claude/skills/skill-conductor
```

Then copy the `.claude/CLAUDE.md` content into your project's `.claude/CLAUDE.md` (merge with existing if you have one).

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

You don't need to use exact commands. Natural language works too:
- "I need a new skill for tracking my diet" → `new`
- "Can you check if my skill is formatted correctly?" → `review`
- "Let's ship this to GitHub" → `publish`

## Project Structure

```
skill-conductor/
├── SKILL.md                    # Core instructions (83 lines, lean)
├── docs/commands/              # Detailed per-command instructions
│   ├── setup.md
│   ├── new.md
│   ├── implement.md
│   ├── status.md
│   ├── review.md
│   ├── publish.md
│   └── validate.md
├── templates/                  # File templates for workspace generation
├── scripts/                    # Validation and utility scripts
├── evals/                      # Test cases for trigger accuracy
├── README.md
└── LICENSE
```

## Workspace

Each project maintains its own independent workspace. The workspace directory name is configurable (default: `skill-conductor/`).

```
your-project/                       another-project/
├── skill-conductor/                ├── conductor/          ← custom name
│   ├── index.md                    │   ├── index.md
│   ├── product.md                  │   ├── product.md
│   ├── guidelines.md               │   ├── guidelines.md
│   ├── workflow.md                 │   ├── workflow.md
│   ├── references.md               │   ├── references.md
│   ├── tracks.md                   │   ├── tracks.md
│   └── tracks/                     │   └── tracks/
│       └── <name>/                 │       └── <name>/
│           ├── index.md            │           ├── index.md
│           ├── spec.md             │           ├── spec.md
│           ├── plan.md             │           ├── plan.md
│           └── metadata.json       │           └── metadata.json
└── some-skill/                     └── src/
    └── SKILL.md
```

Set your workspace directory name in `.claude/CLAUDE.md`.

## Design Principles

1. **Intent Recognition** — Semantic understanding, not keyword matching
2. **Progressive Disclosure** — Load context incrementally
3. **Adaptive Checkpoints** — Adjust verification frequency by complexity
4. **External Verification** — WebSearch to verify format rules (not cached memory)
5. **Socratic Questioning** — Ask before generating

## Key Format Rules

- `description` must be single-line string (double quotes, no `|` or `>`)
- `description` ≤ 1024 characters
- `name` lowercase + hyphens, ≤ 64 characters
- SKILL.md under 500 lines

## Inspired By

- [Conductor](https://github.com/gemini-cli-extensions/conductor) — Gemini CLI extension for context-driven development
- [Agent Skills](https://agentskills.io) — Open standard for AI agent skills

## License

MIT — Author: Yungho
