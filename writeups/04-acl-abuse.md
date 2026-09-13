# 04 — ACL abuse

## Premissa

O grupo `TI` recebeu `GenericAll` sobre `carlos.pereira`. Essa relação permite demonstrar por que permissões delegadas devem ser pequenas, explícitas e auditadas.

## Execução

```bash
pwsh /opt/attacks/04-acl-abuse.ps1 192.168.56.10
```

## Resultado esperado

A enumeração LDAP e uma consulta em BloodHound evidenciam a aresta de controle entre `TI` e o usuário-alvo.

## Defesa

Remover `GenericAll`, revisar ACLs de objetos sensíveis e monitorar alterações 5136/4670.
