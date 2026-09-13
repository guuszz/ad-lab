#!/bin/bash
set -euo pipefail

SYSVOL="/var/lib/samba/sysvol/lab.local"
CPASSWORD=$(python3 - <<'PYEOF'
import base64
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend

key = bytes([
    0x4e, 0x99, 0x06, 0xe8, 0xfc, 0xb6, 0x6c, 0xc9,
    0xfa, 0xf4, 0x93, 0x10, 0x62, 0x0f, 0xfe, 0xe8,
    0xf4, 0x96, 0xe8, 0x06, 0xcc, 0x05, 0x79, 0x90,
    0x20, 0x9b, 0x09, 0xa4, 0x33, 0xb6, 0x6c, 0x1b,
])
plaintext = "SenhaGPP@2024".encode("utf-16-le")
padlen = 16 - (len(plaintext) % 16)
plaintext += bytes([padlen]) * padlen
cipher = Cipher(algorithms.AES(key), modes.CBC(b"\x00" * 16), backend=default_backend())
encryptor = cipher.encryptor()
print(base64.b64encode(encryptor.update(plaintext) + encryptor.finalize()).decode())
PYEOF
)

POLICY_GUID="{11111111-2222-3333-4444-555555555555}"
POLICY_DIR="${SYSVOL}/Policies/${POLICY_GUID}/Machine/Preferences/Groups"
mkdir -p "$POLICY_DIR"
cat > "${POLICY_DIR}/Groups.xml" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<Groups clsid="{3125E937-EB16-4b4c-9934-544FC6D24D26}">
  <User clsid="{DF5F1855-51E5-4d24-8B1A-D9BDE98BA1D1}" name="ana.costa" image="2" changed="2024-01-01 12:00:00" uid="{${POLICY_GUID}}">
    <Properties action="U" newName="" fullName="Ana Costa" description="" cpassword="${CPASSWORD}" changeLogon="0" noChange="0" neverExpires="0" acctDisabled="0" userName="ana.costa"/>
  </User>
</Groups>
EOF

chmod -R 755 "${SYSVOL}/Policies"
samba-tool ntacl sysvolreset 2>/dev/null || true
echo "[+] Groups.xml GPP plantado em ${POLICY_DIR}"
