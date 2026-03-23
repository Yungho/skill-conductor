#!/usr/bin/env bash
# validate-workspace.sh — Validate a project workspace setup
# Usage: bash validate-workspace.sh <project-path>

set -euo pipefail

PROJECT_PATH="${1:?Usage: validate-workspace.sh <project-path>}"

echo "============================================================"
echo "  Workspace Validation"
echo "  Project: $PROJECT_PATH"
echo "============================================================"
echo ""

ERRORS=0

# Check required files
for file in product.md guidelines.md workflow.md references.md tracks.md index.md; do
  if [ -f "$PROJECT_PATH/$file" ]; then
    echo "✅ $file exists"
  else
    echo "❌ $file missing"
    ERRORS=$((ERRORS + 1))
  fi
done

# Check tracks directory
if [ -d "$PROJECT_PATH/tracks" ]; then
  TRACK_COUNT=$(find "$PROJECT_PATH/tracks" -maxdepth 1 -type d | wc -l)
  echo "✅ tracks/ directory exists ($((TRACK_COUNT - 1)) tracks)"
else
  echo "ℹ️  tracks/ directory not yet created (will be created on first 'new')"
fi

echo ""
echo "============================================================"
if [ "$ERRORS" -gt 0 ]; then
  echo "  ❌ $ERRORS file(s) missing. Run 'skill-conductor setup' to generate."
  echo "============================================================"
  exit 1
else
  echo "  ✅ Workspace ready"
  echo "============================================================"
  exit 0
fi
