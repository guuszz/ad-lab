# 02 — Kerberoasting

## Premissa

`svc_backup` possui um SPN CIFS e usa uma senha de treinamento conhecida. Contas de serviço com credenciais fracas podem permitir recuperação offline de senha a partir de tickets TGS.

## Execução

```bash
pwsh /opt/attacks/02-kerberoast.ps1 192.168.56.10
```

## Resultado esperado

Um ticket TGS para o SPN de `svc_backup` em `attacks/output/svc_backup.tgs`.

## Defesa

Preferir gMSA, negar logon interativo para contas de serviço, rotacionar credenciais e alertar sobre solicitações TGS incomuns.
