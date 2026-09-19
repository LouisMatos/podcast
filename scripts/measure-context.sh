#!/bin/bash
# Measure .claude/*.md file sizes to track context bloat over time.

set -e

CLAUDE_DIR=".claude"
MULTIPLIER=1.3  # Rough word-to-token ratio

echo "📊 Context Measurement (.claude/*.md)"
echo "======================================"
echo ""

TOTAL_WORDS=0
TOTAL_TOKENS=0

# Process each markdown file
for file in "$CLAUDE_DIR"/*.md; do
    if [ -f "$file" ]; then
        WORDS=$(wc -w < "$file")
        TOKENS=$(awk "BEGIN {print int($WORDS * $MULTIPLIER)}")
        TOTAL_WORDS=$((TOTAL_WORDS + WORDS))
        TOTAL_TOKENS=$((TOTAL_TOKENS + TOKENS))

        printf "%-40s %5d words  ≈ %5d tokens\n" "$(basename "$file")" "$WORDS" "$TOKENS"
    fi
done

echo ""
echo "======================================"
printf "%-40s %5d words  ≈ %5d tokens\n" "TOTAL" "$TOTAL_WORDS" "$TOTAL_TOKENS"
echo ""

# Optional: show session-context breakdown (prioritization metric)
if [ -f "$CLAUDE_DIR/SESSION_CONTEXT.md" ]; then
    SESSION_WORDS=$(wc -w < "$CLAUDE_DIR/SESSION_CONTEXT.md")
    OTHERS=$((TOTAL_WORDS - SESSION_WORDS))
    echo "✨ Session Start Load: $(awk "BEGIN {print int($SESSION_WORDS * $MULTIPLIER)}") tokens (SESSION_CONTEXT.md)"
    echo "📚 Reference (on-demand): $(awk "BEGIN {print int($OTHERS * $MULTIPLIER)}") tokens (other .md files)"
fi
