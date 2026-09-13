# Provisioning

O `Vagrantfile` cria quatro VMs em uma rede host-only. O Ansible usa WinRM para as máquinas Windows e SSH para o Kali.

```bash
make up
make provision
```

A ordem é importante: `dc.yml` promove o controlador e cria os objetos; `ws.yml` ingressa as estações; `kali.yml` instala ferramentas e copia os ataques.

Para depuração:

```bash
ansible-inventory -i ansible/inventory.ini --graph
ansible-playbook -i ansible/inventory.ini ansible/dc.yml -vv
```

As boxes Windows podem variar em usuário, senha e suporte a WinRM. Ajuste `ansible/inventory.ini` para a box escolhida antes de provisionar. A automação é idempotente onde possível, mas uma promoção de domínio parcialmente concluída normalmente exige `make reset`.
