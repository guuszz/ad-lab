#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REPORT="$ROOT/attacks/report.md"
{
  echo '# AD Lab attack report'
  echo
  echo "Generated: $(date -Iseconds)"
  echo
  for file in "$ROOT"/attacks/output/*.txt; do
    [ -e "$file" ] || continue
    echo "## $(basename "${file%.txt}")"
    echo
    echo '```text'
    cat "$file"
    echo '```'
    echo
  done
} > "$REPORT"
echo "Wrote $REPORT"
