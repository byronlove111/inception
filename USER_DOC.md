# User Documentation

## What services are provided

This stack provides a WordPress website accessible at `https://abbouras.42.fr`.

| Service | Role | Port |
|---|---|---|
| NGINX | Entry point, HTTPS termination | 443 (public) |
| WordPress | Website and admin panel | 9000 (internal) |
| MariaDB | Database | 3306 (internal) |

Only port 443 is accessible from outside. All other ports are internal to the Docker network.

---

## Start the project

```bash
make
```

This builds all images and starts the containers. Wait ~30 seconds for WordPress to finish setup on first run.

## Stop the project

```bash
make down
```

## Check that services are running

```bash
make status
```

All three containers (`nginx`, `wordpress`, `mariadb`) should show status `Up`.

---

## Access the website

Open your browser and go to:

```
https://abbouras.42.fr
```

> A security warning will appear because the TLS certificate is self-signed. Click "Advanced" and proceed.

## Access the administration panel

```
https://abbouras.42.fr/wp-admin
```

---

## Credentials

Credentials are stored in the `secrets/` folder at the root of the repository (not tracked by Git).

| Account | Username | Password file |
|---|---|---|
| WordPress Admin | `wpadmin` | `secrets/credentials.txt` |
| WordPress User | `wpuser` | `secrets/credentials.txt` |
| MariaDB User | `abbouras` | `secrets/db_password.txt` |
| MariaDB Root | `root` | `secrets/db_root_password.txt` |

---

## Check services are running correctly

```bash
# Status of all containers
make status

# Live logs
make logs

# Connect to MariaDB and verify the database is not empty
docker exec -it mariadb mysql -uabbouras -p wordpress -e "SHOW TABLES;"
```
