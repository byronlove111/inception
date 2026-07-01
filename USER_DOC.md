# User Documentation

## Services

The project exposes a WordPress website at `https://abbouras.42.fr`.

Three containers run in the background:
- **nginx** — handles HTTPS connections on port 443
- **wordpress** — runs the website (port 9000, internal)
- **mariadb** — the database (port 3306, internal)

Only port 443 is accessible from outside.

---

## Start / stop

```bash
make        # start everything
make down   # stop everything
make re     # full rebuild from scratch
```

On first start, WordPress installs automatically — wait ~30 seconds before opening the browser.

To check everything is running:
```bash
docker ps
```
All three containers should show `Up`.

---

## Access

Website: `https://abbouras.42.fr`

WordPress admin panel: `https://abbouras.42.fr/wp-admin`

> The browser will show a security warning because the TLS certificate is self-signed. Click "Advanced" and proceed anyway.

---

## Credentials

Everything is in the `secrets/` folder at the root of the project (not tracked by git).

| Account | Username | File |
|---|---|---|
| WordPress Admin | `wpadmin` | `secrets/wp_admin_password.txt` |
| WordPress User | `wpuser` | `secrets/wp_user_password.txt` |
| MariaDB User | `abbouras` | `secrets/db_password.txt` |
| MariaDB Root | `root` | `secrets/db_root_password.txt` |

---

## Check that everything works

```bash
docker ps

# check that the wordpress database is not empty
make db-check
```
