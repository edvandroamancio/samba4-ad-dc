FROM debian:trixie

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    samba \
    samba-dsdb-modules \
    samba-vfs-modules \
    krb5-config \
    krb5-user \
    winbind \
    dnsutils \
    iproute2 \
    net-tools \
    python3 \
    supervisor \
    && apt clean

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 53 88 135 137-138/udp 139 389 445 464 636

ENTRYPOINT ["/entrypoint.sh"]
