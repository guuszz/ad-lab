# 03 — Segredo exposto

## Premissa

O lab marca `ana.costa` com um segredo de treinamento no atributo `description` para exercitar descoberta de credenciais expostas em diretório. Isso representa o risco de segredos publicados em políticas ou atributos, sem depender de uma implantação legada de `Groups.xml`.

## Execução

```bash
pwsh /opt/attacks/03-gpp-password.ps1 192.168.56.10
```

## Resultado esperado

O output identifica o objeto de treinamento e orienta a inspeção do atributo.

## Defesa

Remover segredos de atributos/SYSVOL, auditar `Groups.xml` e rotacionar qualquer credencial descoberta.
