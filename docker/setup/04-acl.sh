#!/bin/bash
set -euo pipefail

BASE_DN="DC=lab,DC=local"
JOAO_SID=$(ldbsearch -H /var/lib/samba/private/sam.ldb \
    "(sAMAccountName=joao.silva)" objectSid 2>/dev/null | \
    awk '/^objectSid:/ { print $2; exit }')

if [ -z "$JOAO_SID" ]; then
    echo "[!] SID de joao.silva não encontrado"
    exit 1
fi

SVC_DN=$(ldbsearch -H /var/lib/samba/private/sam.ldb \
    "(sAMAccountName=svc_backup)" dn 2>/dev/null | \
    awk '/^dn:/ { sub(/^dn: /, ""); print; exit }')

if [ -z "$SVC_DN" ]; then
    echo "[!] DN de svc_backup não encontrado"
    exit 1
fi

echo "[*] SID de joao.silva: ${JOAO_SID}"
samba-tool dsacl set \
    --objectdn="$SVC_DN" \
    --sddl="(A;CI;GA;;;${JOAO_SID})"

echo "[+] ACL configurada: joao.silva tem GenericAll sobre svc_backup"
