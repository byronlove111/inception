*This project has been created as part of the 42 curriculum by abbouras.*

---

## Description

This project sets up a small infrastructure using Docker Compose, composed of three services communicating over a private Docker network:

- **NGINX** — reverse proxy and TLS termination (port 443 only, TLSv1.2/1.3)
- **WordPress + php-fpm** — PHP application server
- **MariaDB** — relational database storing WordPress data

All services run in dedicated containers built from custom Dockerfiles based on Debian Bookworm (oldstable). No pre-built images from Docker Hub are used.

### Comparisons

**Virtual Machines vs Docker**

| | Virtual Machine | Docker Container |
|---|---|---|
| Isolation | Full OS emulation | Process-level isolation via Linux namespaces |
| Size | Several GB | Tens of MB |
| Startup time | Minutes | Milliseconds |
| Overhead | High (hypervisor layer) | Near-zero (shares host kernel) |

**Secrets vs Environment Variables**

| | Environment Variables | Docker Secrets |
|---|---|---|
| Storage | Process memory (visible to all processes) | File mounted in `/run/secrets/` |
| Security | Exposed via `env` commands | Restricted file permissions |
| Use case | Non-sensitive config | Passwords, API keys |

**Docker Network vs Host Network**

| | Docker Network (bridge) | Host Network |
|---|---|---|
| Isolation | Containers have their own network namespace | Container shares host's network stack |
| DNS | Automatic service name resolution | No Docker DNS |
| Security | Containers only expose explicitly declared ports | All ports accessible |
| Subject | ✅ Required | ❌ Forbidden |

**Docker Volumes vs Bind Mounts**

| | Named Volumes | Bind Mounts |
|---|---|---|
| Path control | Managed by Docker | Specified by user |
| Portability | Works on any machine | Depends on host path |
| Subject | ✅ Required | ❌ Forbidden |

---

## Instructions

### Prerequisites

- Docker and Docker Compose installed
- VM or Linux machine
- Add `abbouras.42.fr` to `/etc/hosts`: `127.0.0.1 abbouras.42.fr`

### Build and run

```bash
make
```

### Stop

```bash
make down
```

### Full reset (removes all data)

```bash
make fclean
```

---

## Resources

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/)
- [MariaDB Docker environment variables](https://hub.docker.com/_/mariadb)
- [WP-CLI documentation](https://wp-cli.org/)
- [NGINX FastCGI with PHP](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html)
- [Debian releases](https://www.debian.org/releases/)

### AI usage

AI was used to assist with understanding Docker concepts (namespaces, cgroups, PID 1), reviewing Dockerfile best practices, and drafting documentation. All generated content was reviewed, tested, and is fully understood.
