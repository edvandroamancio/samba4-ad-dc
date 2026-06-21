#!/bin/bash
set -e

REALM=${REALM:-TECHENFIM.FOG}
DOMAIN=${DOMAIN:-TECHENFIM}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-SenhaForte123!}
DNS_FORWARDER=${DNS_FORWARDER:-192.168.18.1}

SAMBA_DB="/var/lib/samba/private/sam.ldb"

echo "[INFO] Iniciando Samba AD DC..."

# Se já existe base, apenas inicia serviço
if [ -f "$SAMBA_DB" ]; then
    echo "[INFO] Domínio já provisionado. Iniciando serviços..."
    exec /usr/sbin/samba --foreground --no-process-group
fi

echo "[INFO] Provisionando novo domínio AD..."

rm -rf /etc/samba/smb.conf || true

samba-tool domain provision \
  --use-rfc2307 \
  --realm="$REALM" \
  --domain="$DOMAIN" \
  --server-role=dc \
  --dns-backend=SAMBA_INTERNAL \
  --adminpass="$ADMIN_PASSWORD" \
  --option="dns forwarder = $DNS_FORWARDER"

echo "[INFO] Provisionamento concluído."

exec /usr/sbin/samba --foreground --no-process-group
