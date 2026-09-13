# Ataques Samba AD

O modo Docker executa quatro técnicas contra o DC Samba e registra a limitação do quinto exercício:

```bash
make up
make attack
make down
```

Também é possível executar a cadeia contra outro alvo autorizado:

```bash
bash attacks/run-all.sh 172.30.0.10
```

| Script | Técnica | Resultado |
|---|---|---|
| `01-asrep-roast.sh` | AS-REP Roasting | Hash via `impacket-GetNPUsers` |
| `02-kerberoast.sh` | Kerberoasting | TGS via `impacket-GetUserSPNs` |
| `03-gpp-password.sh` | GPP Password | Baixa `Groups.xml` do SYSVOL |
| `04-acl-abuse.sh` | ACL Abuse | Reseta a senha de `svc_backup` via `bloodyAD` |
| `05-esc1-adcs.sh` | AD CS ESC1 | Registrado como não suportado no Samba |

Todos os outputs ficam em `attacks/output/`. Use exclusivamente em ambientes próprios e autorizados.
