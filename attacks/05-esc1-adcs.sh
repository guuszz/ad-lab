#!/usr/bin/env bash
set -euo pipefail
OUT="/opt/attacks/output"
mkdir -p "$OUT"
echo 'SKIPPED: Samba AD não fornece Enterprise AD CS/ESC1.' | tee "$OUT/05-esc1-adcs.log"
