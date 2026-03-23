#!/usr/bin/env bash
# sync-registry.sh — Sync tracks-registry.md with actual track directories
# Usage: bash sync-registry.sh <project-path> [registry-path]
# If registry-path is not provided, defaults to <project-path>/skill-conductor/tracks-registry.md

set -euo pipefail

PROJECT_PATH="${1:?Usage: sync-registry.sh <project-path> [registry-path]}"
REGISTRY_PATH="${2:-$PROJECT_PATH/skill-conductor/tracks-registry.md}"
PROJECT_NAME=$(basename "$PROJECT_PATH")

echo "============================================================"
echo "  Tracks Registry Sync"
echo "  Project: $PROJECT_NAME"
echo "  Registry: $REGISTRY_PATH"
echo "============================================================"
echo ""

# Find all track directories (each has metadata.json)
TRACKS_DIR="$PROJECT_PATH/skill-conductor/tracks"

if [ ! -d "$TRACKS_DIR" ]; then
  echo "ℹ️  No tracks/ directory found. Nothing to sync."
  exit 0
fi

TODAY=$(date +%Y-%m-%d)
ID=0
TABLE_ROWS=""

for track_dir in "$TRACKS_DIR"/*/; do
  [ -d "$track_dir" ] || continue
  track_name=$(basename "$track_dir")
  ID=$((ID + 1))

  # Read metadata.json if exists
  STATUS="⬜ Pending"
  OWNER=""
  CREATED=""

  if [ -f "$track_dir/metadata.json" ]; then
    # Extract status
    META_STATUS=$(grep -o '"status"[[:space:]]*:[[:space:]]*"[^"]*"' "$track_dir/metadata.json" | sed 's/.*"status"[[:space:]]*:[[:space:]]*"//' | sed 's/"$//')
    if [ "$META_STATUS" = "completed" ]; then
      STATUS="✅ Complete"
    elif [ "$META_STATUS" = "in_progress" ]; then
      STATUS="⏳ In Progress"
    fi

    # Extract created_at
    CREATED=$(grep -o '"created_at"[[:space:]]*:[[:space:]]*"[^"]*"' "$track_dir/metadata.json" | sed 's/.*"created_at"[[:space:]]*:[[:space:]]*"//' | sed 's/"$//')
  fi

  # Auto-calculate status from plan.md if exists
  if [ -f "$track_dir/plan.md" ]; then
    TOTAL=$(grep -cE '^\s*- \[[ x]\]' "$track_dir/plan.md" 2>/dev/null || echo 0)
    DONE=$(grep -cE '^\s*- \[x\]' "$track_dir/plan.md" 2>/dev/null || echo 0)

    if [ "$TOTAL" -gt 0 ]; then
      if [ "$DONE" -eq "$TOTAL" ]; then
        STATUS="✅ Complete"
      elif [ "$DONE" -gt 0 ]; then
        STATUS="⏳ In Progress"
      else
        STATUS="⬜ Pending"
      fi
    fi
  fi

  TABLE_ROWS="${TABLE_ROWS}| ${ID} | ${track_name} | ${STATUS} | ${OWNER} | [plan](tracks/${track_name}/plan.md) |"$'\n'
done

# Generate tracks-registry.md
mkdir -p "$(dirname "$REGISTRY_PATH")"
cat > "$REGISTRY_PATH" << EOF
---
title: "Tracks Registry"
tags:
  - skill-conductor
type: tracks-registry
---

# Tracks Registry

<!-- Auto-synced by skill-conductor. Manual edits will be overwritten. -->

## Project: ${PROJECT_NAME}

| ID | Name | Status | Owner | Link |
| :-- | :-- | :-- | :-- | :-- |
${TABLE_ROWS}
*Last synced: ${TODAY}*
EOF

echo "✅ Tracks registry synced: $REGISTRY_PATH"
echo "  Tracks found: $ID"
echo "============================================================"
