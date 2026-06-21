# Samba 4 AD DC com Docker

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Shell Script](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Debian](https://img.shields.io/badge/Debian_Trixie-A81D33?style=for-the-badge&logo=debian&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![LDAP](https://img.shields.io/badge/LDAP%2FAD-0052CC?style=for-the-badge&logo=microsoft&logoColor=white)

Implantação rápida de um **Controlador de Domínio Active Directory** baseado em Samba 4, empacotado em contêiner Docker sobre Debian Trixie.

---

## Visão geral

O projeto provisiona automaticamente um domínio AD na primeira inicialização do contêiner. Nas inicializações seguintes, apenas os serviços do Samba são retomados — sem reprovisionamento.

### Portas expostas

| Porta | Protocolo | Serviço |
|-------|-----------|---------|
| 53 | TCP/UDP | DNS |
| 88 | TCP/UDP | Kerberos |
| 135 | TCP | RPC Endpoint Mapper |
| 137–138 | UDP | NetBIOS |
| 139 | TCP | NetBIOS Session |
| 389 | TCP | LDAP |
| 445 | TCP | SMB |
| 464 | TCP/UDP | Kerberos (troca de senha) |
| 636 | TCP | LDAPS |

---

## Pré-requisitos

- Docker >= 20.x
- Docker Compose >= 2.x
- Host Linux com suporte a `network_mode: host`

---

## Configuração

Edite o arquivo `env.sh` com os parâmetros do seu ambiente antes de subir o contêiner:

```env
REALM=TECHENFIM.FOG       # Realm Kerberos (maiúsculas, geralmente o FQDN do domínio)
DOMAIN=TECHENFIM           # Nome NetBIOS do domínio
ADMIN_PASSWORD=SenhaForte123!  # Senha do administrador (deve atender à política de complexidade)
DNS_FORWARDER=8.8.8.8     # DNS externo para encaminhamento de consultas
```

> **Atenção:** altere `ADMIN_PASSWORD` para uma senha forte antes de usar em produção.

---

## Uso

### Build e inicialização

```bash
docker compose up -d --build
```

### Verificar logs

```bash
docker logs -f samba-ad-dc
```

### Parar o contêiner

```bash
docker compose down
```

### Remover volumes (apaga o domínio provisionado)

```bash
docker compose down -v
```

---

## Estrutura do projeto

```
.
├── dockerfile          # Imagem baseada em Debian Trixie com Samba 4
├── docker-compose.yml  # Definição do serviço e volumes persistentes
├── entrypoint.sh       # Provisionamento do domínio na primeira execução
└── env.sh              # Variáveis de ambiente (realm, domínio, senha, DNS)
```

---

## Volumes persistentes

Os dados do Samba são armazenados em volumes Docker nomeados para sobreviver a reinicializações do contêiner:

| Volume | Caminho no contêiner |
|--------|----------------------|
| `samba_lib` | `/var/lib/samba` |
| `samba_etc` | `/etc/samba` |
| `samba_cache` | `/var/cache/samba` |
| `samba_logs` | `/var/log/samba` |

---

## Comportamento do entrypoint

1. Se o arquivo `/var/lib/samba/private/sam.ldb` **não existir** → executa `samba-tool domain provision` com as variáveis do `env.sh`.
2. Se o arquivo **já existir** → pula o provisionamento e inicia o Samba diretamente.

---

## Pacotes instalados na imagem

- `samba`, `samba-dsdb-modules`, `samba-vfs-modules`
- `krb5-config`, `krb5-user`
- `winbind`
- `dnsutils`, `iproute2`, `net-tools`
- `python3`, `supervisor`

---

## Contribuição e sugestões

Sugestões são bem-vindas! Entre em contato pelo Telegram: [@edvandroas](https://t.me/edvandroas)

---

## Licença

Distribuído sem licença explícita. Uso por conta e risco do operador.
