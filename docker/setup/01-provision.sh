#!/bin/bash
set -euo pipefail

if [ -f /var/lib/samba/private/sam.ldb ]; then
    echo "[*] banco AD já existe, pulando provision"
    exit 0
fi

rm -f /etc/samba/smb.conf
samba-tool domain provision \
    --use-rfc2307 \
    --realm="${SAMBA_REALM}" \
    --domain="${SAMBA_DOMAIN}" \
    --server-role=dc \
    --dns-backend=SAMBA_INTERNAL \
    --adminpass="${SAMBA_ADMIN_PASS}" \
    --option="dns forwarder = 1.1.1.1"

cp /var/lib/samba/private/krb5.conf /etc/krb5.conf

echo "[*] Configurando enctype RC4 no computador do DC"
ldbmodify -H /var/lib/samba/private/sam.ldb <<EOF
dn: CN=DC01,OU=Domain Controllers,DC=lab,DC=local
changetype: modify
replace: msDS-SupportedEncryptionTypes
msDS-SupportedEncryptionTypes: 28
EOF

echo "[+] Banco AD provisionado; scripts de objetos podem executar offline"
