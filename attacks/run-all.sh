#!/usr/bin/env bash
set -uo pipefail

DC_IP="${DC_IP:-172.30.0.10}"
OUT="/opt/attacks/output"
REPORT="/opt/attacks/report.md"
mkdir -p "$OUT"

{
    echo '# Relatório de Ataques - AD Lab'
    echo
    echo "**Domínio:** lab.local | **DC:** $DC_IP | **Data:** $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo
} > "$REPORT"

FAILED=0

run_attack() {
    local name="$1"
    local script="$2"
    local log="$OUT/${name}.log"
    echo "[*] Ataque: $name"
    if bash "$script" 2>&1 | tee "$log"; then
        {
            echo "## $name"
            echo
            echo '```text'
            tail -n 40 "$log"
            echo '```'
            echo
        } >> "$REPORT"
        echo "[+] $name concluído"
    else
        FAILED=1
        echo "[!] $name falhou - ver $log"
        {
            echo "## $name (falhou)"
            echo
            echo '```text'
            tail -n 40 "$log"
            echo '```'
            echo
        } >> "$REPORT"
    fi
}

run_attack '01-asrep-roast' /opt/attacks/01-asrep-roast.sh
run_attack '02-kerberoast' /opt/attacks/02-kerberoast.sh
run_attack '03-gpp-password' /opt/attacks/03-gpp-password.sh
run_attack '04-acl-abuse' /opt/attacks/04-acl-abuse.sh

{
    echo '## 05-adcs-esc1 (não suportado)'
    echo
    echo 'Samba AD não fornece Enterprise AD CS. Este vetor requer o modo Windows AD.'
} >> "$REPORT"

echo "[+] Cadeia completa. Relatório: $REPORT"
exit "$FAILED"
