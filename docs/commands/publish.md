# Command: publish

Version bump + CHANGELOG + Git + GitHub release.

## Steps

1. **Pre-flight**: Verify review passed, Git clean, confirm repo path
2. **Version bump**: Ask user (major/minor/increment). Update SKILL.md version.
3. **CHANGELOG**: Generate entry from spec.md + plan.md. Append to project CHANGELOG.md.
4. **Registry**: Sync `~/.skill-conductor/registry.md`
5. **Git**: `git add -A && git commit && git tag v<version> && git push --tags`
6. **GitHub Release** (if `gh` available): `gh release create v<version>`
7. **Update track**: Set metadata.json status to "completed". Show final state visualization.
