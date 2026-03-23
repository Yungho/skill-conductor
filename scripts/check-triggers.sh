#!/usr/bin/env bash
# check-triggers.sh — Detect trigger word conflicts across all skills in a project
# Usage: bash check-triggers.sh <project-path>
# Project path should contain skill directories, each with SKILL.md

set -euo pipefail

PROJECT_PATH="${1:?Usage: check-triggers.sh <project-path>}"

echo "============================================================"
echo "  Trigger Conflict Detection"
echo "  Project: $PROJECT_PATH"
echo "============================================================"
echo ""

# Find all SKILL.md files
SKILL_FILES=$(find "$PROJECT_PATH" -name "SKILL.md" -type f 2>/dev/null | sort)

if [ -z "$SKILL_FILES" ]; then
  echo "❌ No SKILL.md files found in $PROJECT_PATH"
  exit 1
fi

# Extract triggers from each skill
declare -A TRIGGER_MAP  # trigger -> skill name
CONFLICTS=0
SKILL_COUNT=0

for skill_file in $SKILL_FILES; do
  skill_name=$(basename "$(dirname "$skill_file")")
  SKILL_COUNT=$((SKILL_COUNT + 1))
  
  # Extract description
  DESC=$(sed -n '/^---$/,/^---$/p' "$skill_file" | sed '1d;$d' | grep -E '^description:' | sed 's/^description:\s*//' | sed 's/^"//' | sed 's/"$//')
  
  if [ -z "$DESC" ]; then
    echo "⚠️  $skill_name: no description found"
    continue
  fi
  
  # Extract trigger words (after "Triggers:" or "Use when:" or keywords in description)
  # Simple approach: extract words after "Triggers:" or comma-separated keywords
  TRIGGERS=$(echo "$DESC" | grep -oiE 'triggers?:\s*.+' | sed 's/triggers?:\s*//i' | tr ',' '\n' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//' | tr '[:upper:]' '[:lower:]')
  
  if [ -z "$TRIGGERS" ]; then
    echo "ℹ️  $skill_name: no explicit trigger words found in description"
    continue
  fi
  
  echo "📋 $skill_name:"
  
  while IFS= read -r trigger; do
    [ -z "$trigger" ] && continue
    trigger=$(echo "$trigger" | sed 's/[.!?]*$//')
    
    if [ -n "${TRIGGER_MAP[$trigger]+x}" ]; then
      echo "   ⚠️  CONFLICT: '$trigger' also used by ${TRIGGER_MAP[$trigger]}"
      CONFLICTS=$((CONFLICTS + 1))
    else
      TRIGGER_MAP["$trigger"]="$skill_name"
    fi
    echo "   - $trigger"
  done <<< "$TRIGGERS"
  
  echo ""
done

# Summary
echo "============================================================"
echo "  Skills scanned: $SKILL_COUNT"
echo "  Unique triggers: ${#TRIGGER_MAP[@]}"
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
