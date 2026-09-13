#!/bin/bash
set -euo pipefail

BASE_DN="DC=lab,DC=local"

create_user() {
    local name="$1"
    local pass="$2"
    samba-tool user create "$name" "$pass" \
        --given-name="${name%%.*}" \
        --surname="${name#*.}" \
        --mail-address="${name}@lab.local" 2>/dev/null || true
}

for user in \
    'joao.silva|Senha@123' \
    'maria.santos|Senha@123' \
    'carlos.pereira|Senha@123' \
    'ana.costa|Senha@123' \
    'svc_backup|Backup@2024!'; do
    IFS='|' read -r name pass <<< "$user"
    create_user "$name" "$pass"
done

samba-tool group add TI 2>/dev/null || true
samba-tool group add Financeiro 2>/dev/null || true
samba-tool group addmembers TI joao.silva,maria.santos 2>/dev/null || true
samba-tool group addmembers Financeiro carlos.pereira,ana.costa 2>/dev/null || true

# AS-REP roasting: DONT_REQ_PREAUTH.
JOAO_DN=$(ldbsearch -H /var/lib/samba/private/sam.ldb \
    "(sAMAccountName=joao.silva)" dn 2>/dev/null | \
    awk '/^dn:/ { sub(/^dn: /, ""); print; exit }')

if [ -z "$JOAO_DN" ]; then
    echo "[!] DN de joao.silva não encontrado"
    exit 1
fi

ldbmodify -H /var/lib/samba/private/sam.ldb <<EOF
dn: ${JOAO_DN}
changetype: modify
replace: userAccountControl
userAccountControl: 4194816
EOF

# Kerberoasting: service principal name on the service account.
samba-tool spn add "MSSQLSvc/dc01.lab.local:1433" svc_backup 2>/dev/null || true

SVC_DN=$(ldbsearch -H /var/lib/samba/private/sam.ldb \
    "(sAMAccountName=svc_backup)" dn 2>/dev/null | \
    awk '/^dn:/ { sub(/^dn: /, ""); print; exit }')
ldbmodify -H /var/lib/samba/private/sam.ldb <<EOF
dn: ${SVC_DN}
changetype: modify
replace: msDS-SupportedEncryptionTypes
msDS-SupportedEncryptionTypes: 28
EOF

echo "[+] Usuários, grupos e vetores AS-REP/Kerberoast criados"
