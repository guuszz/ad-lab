# ad-lab

[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![Make](https://img.shields.io/badge/Build-Make-427819?logo=gnu&logoColor=white)](https://www.gnu.org/software/make/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Laboratório reproduzível de Active Directory para estudo autorizado de ataques ofensivos. O modo padrão usa Samba 4 como Domain Controller dentro de Docker.

> **Aviso:** rede isolada e uso exclusivamente educacional. Não use estas técnicas contra alvos reais.

## O que este lab demonstra

- Infraestrutura como código com Docker Compose e scripts idempotentes.
- Provisionamento em camadas: domínio, usuários, GPP e ACL.
- GPP real com `cpassword` no SYSVOL usando a chave AES pública da Microsoft.
- Abuso efetivo de `GenericAll` para resetar a senha de `svc_backup`.
- Execução automatizada e relatório consolidado em `attacks/report.md`.

## Demonstração

Para gravar uma demonstração terminal com [asciinema](https://asciinema.org/):

```bash
asciinema rec demo.cast -c ./demo-asciinema.sh
```

O script executa `make down`, `make up`, a cadeia de ataques, `make report` e `make down`. Publique o arquivo `.cast` no asciinema.org e substitua este bloco pelo embed gerado:

```text
https://asciinema.org/a/SEU_ID
```

## Arquitetura

```text
Docker bridge: lab_net (172.30.0.0/24)

DC01 Samba AD       172.30.0.10  lab.local
Attacker Kali       172.30.0.50  Impacket, bloodyAD, smbclient
```

O lab é portátil, gratuito e não exige virtualização aninhada nem licenças Windows.

## Pré-requisitos

- Docker Desktop/Engine com Compose v2
- GNU Make
- Aproximadamente 2 GB livres

## Uso

```bash
make up
make logs
make attack
make report
make shell
make attack-shell
make down
make reset
```

A primeira execução pode levar alguns minutos para baixar as imagens e provisionar o domínio.

## Domínio

- Realm: `LAB.LOCAL`
- Base DN: `DC=lab,DC=local`
- Admin: `Administrator@lab.local` / `Lab@2024!`

| Usuário | Senha | Grupo | Vetor |
|---|---|---|---|
| `joao.silva` | `Senha@123` | TI | DONT_REQ_PREAUTH configurado |
| `maria.santos` | `Senha@123` | TI | Nenhum |
| `carlos.pereira` | `Senha@123` | Financeiro | Nenhum |
| `ana.costa` | `Senha@123` | Financeiro | GPP em `Groups.xml` |
| `svc_backup` | `Backup@2024!` | Nenhum | SPN registrado |

## Cobertura atual

| Ataque | Status | Ferramenta |
|---|---|---|
| GPP Password | PASSOU ponta a ponta | `smbclient` + AES-256 |
| ACL Abuse | PASSOU ponta a ponta | `bloodyAD` + SMB |
| AS-REP Roasting | Limitado no Samba | Impacket/Rubeus experimental |
| Kerberoasting | Limitado no Samba | Impacket/Rubeus experimental |
| AD CS ESC1 | Não suportado | Requer Windows AD |

**Resultado validado: 2/4 ataques ponta a ponta no modo Samba.**

## Limitações conhecidas

AS-REP Roasting e Kerberoasting apresentaram `KRB_AP_ERR_INAPP_CKSUM` ou recusa de preautenticação mesmo após configurar `msDS-SupportedEncryptionTypes: 28` e `rc4-hmac`. Isso decorre da incompatibilidade entre a implementação Kerberos do Samba/Heimdal e as expectativas do cliente Impacket.

Rubeus é uma implementação Windows/.NET. A tentativa de compilá-lo no Kali com Mono falha porque `System.DirectoryServices.AccountManagement` não está disponível no runtime Mono/Linux. O Dockerfile mantém essa integração como experimental e o build só deve ser considerado válido quando produzir `/opt/Rubeus.exe`.

Samba não implementa Enterprise AD CS, portanto ESC1 não pode ser reproduzido neste modo. Técnicas dependentes de workstations Windows, como `AlwaysInstallElevated`, serviços vulneráveis e tarefas agendadas, também ficam fora do escopo.

## Roadmap

- [ ] Windows AD real via Terraform + Azure, cobrindo AS-REP, Kerberoast e ADCS ESC1.
- [ ] CI/CD com GitHub Actions para validar `make up && make attack`.
- [ ] Shadow credentials, RBCD e delegações.

## Referências

- [MS14-025](https://learn.microsoft.com/en-us/security-updates/securitybulletins/2014/ms14-025)
- [MITRE ATT&CK T1558](https://attack.mitre.org/techniques/T1558/)
- [Samba AD DC](https://wiki.samba.org/index.php/Setting_up_Samba_as_an_AD_DC)
