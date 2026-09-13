#!/usr/bin/env bash
set -euo pipefail

make down || true
make up
printf '\n[*] Aguardando provisionamento...\n'
sleep 30
make attack
make report
make down
