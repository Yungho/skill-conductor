#!/usr/bin/env bash
# validate-skill.sh — Validate SKILL.md format
# Usage: bash validate-skill.sh <path-to-SKILL.md>

set -euo pipefail

SKILL_FILE="${1:?Usage: validate-skill.sh <path-to-SKILL.md>}"
ERRORS=0
WARNINGS=0

echo "============================================================"
echo "  SKILL.md Validation: $(basename "$(dirname "$SKILL_FILE")")"
echo "  File: $SKILL_FILE"
echo "============================================================"
echo ""

# Check file exists
if [ ! -f "$SKILL_FILE" ]; then
  echo "❌ FAIL: File not found: $SKILL_FILE"
  exit 1
fi

# Check filename
if [ "$(basename "$SKILL_FILE")" != "SKILL.md" ]; then
  echo "❌ FAIL: File must be named SKILL.md (case-sensitive)"
  ERRORS=$((ERRORS + 1))
fi

# Extract frontmatter (only between first and second --- markers)
FRONTMATTER=$(awk 'BEGIN{c=0} /^---$/{c++; next} c==1{print} c>1{exit}' "$SKILL_FILE")

if [ -z "$FRONTMATTER" ]; then
  echo "❌ FAIL: No YAML frontmatter found (must be between --- markers)"
  ERRORS=$((ERRORS + 1))
  echo ""
  echo "Result: $ERRORS error(s), $WARNINGS warning(s)"
  exit 1
fi

# Check name field
NAME=$(echo "$FRONTMATTER" | grep -E '^name:' | sed 's/^name:\s*//' | tr -d '"' | tr -d "'")
if [ -z "$NAME" ]; then
  echo "❌ FAIL: Missing 'name' field in frontmatter"
  ERRORS=$((ERRORS + 1))
else
  # Check name format (lowercase + hyphens, max 64 chars)
  NAME_LEN=${#NAME}
  if [ "$NAME_LEN" -gt 64 ]; then
    echo "❌ FAIL: name too long ($NAME_LEN chars, max 64)"
    ERRORS=$((ERRORS + 1))
  fi
  if echo "$NAME" | grep -qE '[A-Z_]'; then
    echo "❌ FAIL: name must be lowercase with hyphens only (found: $NAME)"
    ERRORS=$((ERRORS + 1))
  else
    echo "✅ name: $NAME ($NAME_LEN chars)"
  fi
fi

# Check description field
# First, check if description uses multi-line format (| or >)
if echo "$FRONTMATTER" | grep -qE '^description:\s*[|>]'; then
  echo "❌ FAIL: description uses multi-line format (| or >). Must be single-line string."
  echo "   This causes silent discovery failure in Claude Code!"
  ERRORS=$((ERRORS + 1))
else
  # Extract description (single line)
  DESC=$(echo "$FRONTMATTER" | grep -E '^description:' | sed 's/^description:\s*//' | sed 's/^"//' | sed 's/"$//' | sed "s/^'//" | sed "s/'$//")
  
  if [ -z "$DESC" ]; then
    echo "❌ FAIL: Missing 'description' field in frontmatter"
    ERRORS=$((ERRORS + 1))
  else
    DESC_LEN=${#DESC}
    if [ "$DESC_LEN" -gt 1024 ]; then
      echo "❌ FAIL: description too long ($DESC_LEN chars, max 1024)"
      echo "   Longer descriptions get truncated and skills become undiscoverable."
      ERRORS=$((ERRORS + 1))
    elif [ "$DESC_LEN" -gt 800 ]; then
      echo "⚠️  WARN: description is long ($DESC_LEN chars, max 1024). Consider trimming."
      WARNINGS=$((WARNINGS + 1))
    else
      echo "✅ description: $DESC_LEN chars (limit: 1024)"
    fi
    
    # Check if description is quoted
    if echo "$FRONTMATTER" | grep -qE '^description:\s*"[^"]*"$'; then
      echo "✅ description format: properly quoted single-line"
    elif echo "$FRONTMATTER" | grep -qE "^description:\s*'[^']*'$"; then
      echo "✅ description format: single-quote single-line"
    else
      echo "⚠️  WARN: description format may not be properly quoted"
      echo "   Recommended: description: \"your text here\""
      WARNINGS=$((WARNINGS + 1))
    fi
  fi
fi

# Check SKILL.md line count
LINE_COUNT=$(wc -l < "$SKILL_FILE")
if [ "$LINE_COUNT" -gt 500 ]; then
  echo "⚠️  WARN: SKILL.md has $LINE_COUNT lines (recommended: < 500)"
  echo "   Consider splitting into reference files."
  WARNINGS=$((WARNINGS + 1))
else
  echo "✅ line count: $LINE_COUNT (< 500)"
fi

# Check for forbidden XML tags in frontmatter
if echo "$FRONTMATTER" | grep -qE '</?[a-zA-Z][a-zA-Z0-9]*[^>]*>'; then
  echo "❌ FAIL: XML tags found in frontmatter (not allowed)"
  ERRORS=$((ERRORS + 1))
fi

# Summary
echo ""
echo "============================================================"
if [ "$ERRORS" -gt 0 ]; then
  echo "  ❌ FAILED: $ERRORS error(s), $WARNINGS warning(s)"
  echo "============================================================"
  exit 1
elif [ "$WARNINGS" -gt 0 ]; then
  echo "  ⚠️  PASSED with warnings: $WARNINGS warning(s)"
  echo "============================================================"
  exit 0
else
  echo "  ✅ PASSED: All checks passed"
  echo "============================================================"
  exit 0
fi
