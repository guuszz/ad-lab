# 01 — AS-REP Roasting

## Premissa

`joao.silva` foi criado com preautenticação Kerberos desabilitada para demonstrar como uma conta pode fornecer um material offline sem uma senha válida.

## Execução

```bash
pwsh /opt/attacks/01-asrep-roast.ps1 192.168.56.10
```

O wrapper chama `GetNPUsers` e salva o resultado em `attacks/output/01-asrep-roast.txt`.

## Resultado esperado

Um hash AS-REP associado a `joao.silva`, passível de auditoria offline no escopo do laboratório.

## Defesa

Reabilitar a preautenticação, usar senhas longas e monitorar eventos 4768 anômalos.
