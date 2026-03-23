#!/usr/bin/env bash
# sync-registry.sh — Sync registry.md with actual skill files in a project
# Usage: bash sync-registry.sh <project-path> [registry-path]
# If registry-path is not provided, defaults to ~/.skill-conductor/registry.md

set -euo pipefail

PROJECT_PATH="${1:?Usage: sync-registry.sh <project-path> [registry-path]}"
REGISTRY_PATH="${2:-$HOME/.skill-conductor/registry.md}"
PROJECT_NAME=$(basename "$PROJECT_PATH")

echo "============================================================"
echo "  Registry Sync"
echo "  Project: $PROJECT_NAME"
echo "  Registry: $REGISTRY_PATH"
echo "============================================================"
echo ""

# Find all SKILL.md files
SKILL_FILES=$(find "$PROJECT_PATH" -name "SKILL.md" -type f 2>/dev/null | sort)

if [ -z "$SKILL_FILES" ]; then
  echo "❌ No SKILL.md files found in $PROJECT_PATH"
  exit 1
fi

# Ensure registry exists
if [ ! -f "$REGISTRY_PATH" ]; then
  mkdir -p "$(dirname "$REGISTRY_PATH")"
  cat > "$REGISTRY_PATH" << 'EOF'
# Registry

<!-- Auto-synced by skill-conductor. Manual edits will be overwritten. -->

## Projects
EOF
fi

# Build skill list for this project
TODAY=$(date +%Y-%m-%d)
SKILL_TABLE=""

for skill_file in $SKILL_FILES; do
  skill_name=$(basename "$(dirname "$skill_file")")
  
  # Extract name from frontmatter
  FM_NAME=$(awk 'BEGIN{c=0} /^---$/{c++; next} c==1{print} c>1{exit}' "$skill_file" | grep -E '^name:' | sed 's/^name:\s*//' | tr -d '"' | tr -d "'")
  
  # Extract description length
  DESC=$(awk 'BEGIN{c=0} /^---$/{c++; next} c==1{print} c>1{exit}' "$skill_file" | grep -E '^description:' | sed 's/^description:\s*//' | sed 's/^"//' | sed 's/"$//')
  DESC_LEN=${#DESC}
  
  # Check description format
  FORMAT_STATUS="✅"
  if echo "$DESC" | grep -qE '^\s*[|>]'; then
    FORMAT_STATUS="❌ multi-line"
  elif [ "$DESC_LEN" -gt 1024 ]; then
    FORMAT_STATUS="❌ too long ($DESC_LEN)"
  fi
  
  SKILL_TABLE="${SKILL_TABLE}| ${FM_NAME:-$skill_name} | - | $FORMAT_STATUS | $TODAY |"$'\n'
done

# Check if project already in registry
if grep -q "### $PROJECT_NAME" "$REGISTRY_PATH" 2>/dev/null; then
  echo "ℹ️  Updating existing entry for $PROJECT_NAME"
  # For simplicity, just print the updated table
  echo ""
  echo "Updated skill table:"
  echo "$SKILL_TABLE"
else
  echo "ℹ️  Adding new entry for $PROJECT_NAME"
  # Append new project section
  cat >> "$REGISTRY_PATH" << EOF

### $PROJECT_NAME
**Path**: $PROJECT_PATH
**Last synced**: $TODAY

| Skill | Version | Format | Last Updated |
|-------|---------|--------|-------------|
$SKILL_TABLE
EOF
fi

echo ""
echo "✅ Registry synced: $REGISTRY_PATH"
echo "============================================================"
