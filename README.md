*This project has been created as part of the 42 curriculum by abbouras.*

---

## Description

Inception is a sysadmin project that consists of setting up a small infrastructure with Docker Compose. Three services run in separate containers on a private Docker network:

- **NGINX** — single entry point, TLS on port 443 (TLSv1.2/1.3)
- **WordPress + php-fpm** — the website and admin panel
- **MariaDB** — the database

All Dockerfiles are based on Debian Bookworm (oldstable). No pre-built images from Docker Hub.

### Virtual Machines vs Docker

A VM emulates a full OS with its own kernel — it takes several GB and a few minutes to start. Docker isolates processes via Linux namespaces while sharing the host kernel. The result is images of a few tens of MB and near-instant startup. The trade-off is that isolation is weaker than a VM.

### Secrets vs Environment Variables

Environment variables are visible in process memory and can be exposed via `env` or `docker inspect`. Docker secrets are mounted as files in `/run/secrets/` with restricted permissions — better suited for passwords.

### Docker Network vs Host Network

With a Docker bridge network, each container has its own network namespace and automatic DNS resolution by service name. In `host` mode, the container directly shares the host's network stack — all ports are exposed, no Docker DNS. The subject forbids `network: host`.

### Docker Volumes vs Bind Mounts

Named volumes are managed by Docker, portable and independent of the host path. Bind mounts directly link a folder from the host — convenient in dev but not portable. The subject requires named volumes (bind mounts are forbidden).

---

## Instructions

Requirements: Docker and Docker Compose installed, Linux or VM.

Add the domain to `/etc/hosts`:

```bash
echo "127.0.0.1 abbouras.42.fr" | sudo tee -a /etc/hosts
```

```bash
make          # build images and start everything
make down     # stop containers
make fclean   # full reset (removes everything)
```

---

## Resources

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/)
- [WP-CLI documentation](https://wp-cli.org/)
- [NGINX FastCGI + PHP](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html)
- [Debian releases](https://www.debian.org/releases/)

AI was mainly used to understand how PID 1 works in Docker and the differences between MariaDB startup modes (bootstrap vs normal). All code was reviewed, tested and understood before being integrated.
