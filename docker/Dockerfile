FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV SAMBA_REALM=LAB.LOCAL
ENV SAMBA_DOMAIN=LAB
ENV SAMBA_ADMIN_PASS=Lab@2024!
ENV LDB_MODULES_PATH=/usr/lib/x86_64-linux-gnu/samba/ldb

RUN apt-get update && apt-get install -y --no-install-recommends \
        samba samba-common-bin samba-dsdb-modules samba-vfs-modules \
        smbclient ldb-tools ldap-utils krb5-user krb5-kdc winbind \
        libnss-winbind libpam-winbind dnsutils python3 python3-cryptography \
        acl attr vim less procps net-tools \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
COPY setup/ /setup/
RUN chmod +x /entrypoint.sh /setup/*.sh

EXPOSE 53/tcp 53/udp 88/tcp 88/udp 135/tcp 137/udp 138/udp \
       139/tcp 389/tcp 389/udp 445/tcp 464/tcp 464/udp \
       636/tcp 3268/tcp 3269/tcp

ENTRYPOINT ["/entrypoint.sh"]
