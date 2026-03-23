# Changelog

## v0.7.0 — Multi-Project Support & Template Alignment

### Added
- `.claude/CLAUDE.md` — Universal file resolution protocol for workspace configuration
- `templates/index.md` — New index template aligned with actual usage (wikilinks, Core Documents, Current Focus)

### Changed
- **SKILL.md**: Workspace structure now shows multi-project model (each project has its own independent workspace)
- **README.md**: Installation now includes `.claude/CLAUDE.md` copy instruction; workspace section shows multi-project examples
- **All command docs**: Updated path references from `./skill-conductor/` to `<workspace>/` placeholder
- **templates/tracks-registry.md**: Simplified to match actual `tracks.md` format
- **templates/plan.md**: Fixed `registry.md` → `tracks.md` reference
- **scripts/sync-registry.sh**: Default output renamed to `tracks.md`; fixed grep count bug
- **scripts/validate-workspace.sh**: Validates `tracks.md` instead of `tracks-registry.md`

### Removed
- `templates/index-project.md` — Redundant (replaced by `index.md`)

### Fixed
- `sync-registry.sh` integer comparison error when grep returns 0 matches

## v0.6.0 — Plan Auto-Update, Tracks Registry, Track Naming

- Plan auto-update on task completion
- Renamed Registry → tracks-registry with new table format
- Track naming: no date prefix, name only
- Product.md → product.md naming
- Index files per project and per track

## v0.5.0 — YAML Frontmatter & Obsidian

- YAML frontmatter for all docs/templates
- Obsidian skill preference added to SKILL.md

## v0.4.0 — Project-Relative Workspace

- Workspace path changed to project-relative `./skill-conductor/`

## v0.3.0 — Skill-Creator Review

- Progressive disclosure improvements
- Improved description
- macOS bash 3.x compatibility

## v0.2.0 — Design Principles

- Intent recognition, progressive disclosure, adaptive checkpoints
- State visualization, external verification

## v0.1.0 — Initial Release

- Core workflow: setup → new → implement → status → review → publish → validate
- Template system for workspace generation
- Validation scripts
