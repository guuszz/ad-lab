# 05 — AD CS ESC1

## Premissa

ESC1 ocorre quando uma template de certificado permite que o solicitante forneça o Subject e usuários comuns podem se inscrever. O exercício usa uma CA Enterprise de laboratório e o template `LabUserEnrollment`.

## Execução

```bash
pwsh /opt/attacks/05-esc1-adcs.ps1 192.168.56.10
```

## Resultado esperado

`certipy find` lista uma template vulnerável e mostra `ENROLLEE_SUPPLIES_SUBJECT` como indicador.

## Defesa

Desabilitar essa flag quando não for necessária, restringir enrollment, exigir aprovação e auditar emissão de certificados.
