#!/bin/bash
set -euo pipefail

PROVISIONED_FLAG="/var/lib/samba/.provisioned"

if [ ! -f "$PROVISIONED_FLAG" ]; then
    echo "[*] Primeira execução - provisionando domínio ${SAMBA_REALM}"
    /setup/01-provision.sh
    /setup/02-users.sh
    /setup/03-gpp.sh
    /setup/04-acl.sh
    if [ -f /tmp/samba_setup.pid ]; then
        kill "$(cat /tmp/samba_setup.pid)" 2>/dev/null || true
        wait "$(cat /tmp/samba_setup.pid)" 2>/dev/null || true
        rm -f /tmp/samba_setup.pid
    fi
    touch "$PROVISIONED_FLAG"
    echo "[+] Domínio provisionado e populado"
else
    echo "[*] Domínio já existe - subindo serviços"
fi

exec samba --foreground --no-process-group
