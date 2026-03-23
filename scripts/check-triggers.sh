#!/usr/bin/env bash
# check-triggers.sh — Detect trigger word conflicts across all skills in a project
# Usage: bash check-triggers.sh <project-path>
# Compatible with macOS bash 3.x

PROJECT_PATH="${1:?Usage: check-triggers.sh <project-path>}"

echo "============================================================"
echo "  Trigger Conflict Detection"
echo "  Project: $PROJECT_PATH"
echo "============================================================"
echo ""

SKILL_COUNT=0
CONFLICTS=0
TRIGGER_FILE=$(mktemp)
trap 'rm -f "$TRIGGER_FILE"' EXIT

# Collect all triggers from all skills
for skill_file in $(find "$PROJECT_PATH" -name "SKILL.md" -type f 2>/dev/null | sort); do
  skill_name=$(basename "$(dirname "$skill_file")")
  SKILL_COUNT=$((SKILL_COUNT + 1))

  # Extract description (only between first two --- markers)
  DESC=$(awk 'BEGIN{c=0} /^---$/{c++; next} c==1{print} c>1{exit}' "$skill_file" | grep '^description:' | sed 's/^description: *//' | sed 's/^"//' | sed 's/"$//')

  if [ -z "$DESC" ]; then
    echo "  ⚠️  $skill_name: no description found"
    continue
  fi

  # Extract triggers (after "Triggers on:" or "Triggers:")
  AFTER_COLON=$(echo "$DESC" | sed -E 's/.*[Tt]riggers( on)?://')
  if [ "$AFTER_COLON" = "$DESC" ]; then
    # No "Triggers:" found — skip
    continue
  fi

  # Split by comma, trim spaces, lowercase
  TRIGGERS=$(echo "$AFTER_COLON" | tr ',' '\n' | sed 's/^ *//' | sed 's/ *$//' | tr '[:upper:]' '[:lower:]' | sed 's/\.$//')

  echo "  📋 $skill_name:"
  echo "$TRIGGERS" | while IFS= read -r trigger; do
    [ -z "$trigger" ] && continue

    # Check for conflicts using grep on temp file
    EXISTING=$(grep -F "|${trigger}|" "$TRIGGER_FILE" 2>/dev/null | head -1)
    if [ -n "$EXISTING" ]; then
      OWNER=$(echo "$EXISTING" | cut -d'|' -f3)
      echo "     ⚠️  CONFLICT: '${trigger}' also used by ${OWNER}"
      echo "CONFLICT" >> "${TRIGGER_FILE}.count"
    else
      echo "|${trigger}|${skill_name}|" >> "$TRIGGER_FILE"
    fi
    echo "     - ${trigger}"
  done
  echo ""
done

# Count results
UNIQUE=$(wc -l < "$TRIGGER_FILE" | tr -d ' ')
CONFLICTS=0
if [ -f "${TRIGGER_FILE}.count" ]; then
  CONFLICTS=$(wc -l < "${TRIGGER_FILE}.count" | tr -d ' ')
fi

echo "============================================================"
echo "  Skills scanned: $SKILL_COUNT"
echo "  Unique triggers: $UNIQUE"
if [ "$CONFLICTS" -gt 0 ]; then
  echo "  ⚠️  Conflicts found: $CONFLICTS"
  echo "============================================================"
  echo ""
  echo "  Suggestion: Refine descriptions to differentiate overlapping triggers."
  echo "  Add more specific context words or use 'NOT for X' disambiguation."
  exit 1
else
  echo "  ✅ No conflicts detected"
  echo "============================================================"
  exit 0
fi
