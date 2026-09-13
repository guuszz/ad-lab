FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 python3-pip git ldap-utils smbclient \
                krb5-user dnsutils netcat-openbsd curl jq crackmapexec \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --break-system-packages --ignore-installed --no-cache-dir \
        bloodyAD ldapdomaindump

COPY krb5.conf /etc/krb5.conf
WORKDIR /opt
CMD ["sleep", "infinity"]
