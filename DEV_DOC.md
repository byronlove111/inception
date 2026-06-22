# Developer Documentation

## Setup

Docker Engine + Docker Compose plugin installed, Linux or VM.

Add the domain:
```bash
echo "127.0.0.1 abbouras.42.fr" | sudo tee -a /etc/hosts
```

Create the config files before building:

**`srcs/.env`**
```env
DOMAIN_NAME=abbouras.42.fr
MYSQL_HOST=mariadb
MYSQL_DATABASE=wordpress
MYSQL_USER=abbouras
WP_TITLE=Inception
WP_ADMIN_USER=wpadmin
WP_ADMIN_EMAIL=abbouras@student.42.fr
WP_USER=wpuser
WP_USER_EMAIL=wpuser@student.42.fr
```

**`secrets/`** — one password per file, single line:
```
secrets/db_password.txt
secrets/db_root_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
```

---

## Structure

```
.
├── Makefile
├── secrets/                          # ignored by git
│   ├── credentials.txt
│   ├── db_password.txt
│   ├── db_root_password.txt
│   ├── wp_admin_password.txt
│   └── wp_user_password.txt
└── srcs/
    ├── .env                          # ignored by git
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/my.cnf
        │   └── tools/init.sh
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/nginx.conf
        └── wordpress/
            ├── Dockerfile
            ├── conf/www.conf
            └── tools/setup.sh
```

---

## Commands

```bash
make          # creates /home/abbouras/data/, builds and starts
make down     # stops and removes containers
make re       # full rebuild from scratch
```

Useful commands for debugging:

```bash
docker exec -it mariadb mysql -uroot -p
docker exec -it wordpress ls /var/www/html
docker exec -it nginx nginx -t
docker volume inspect srcs_mariadb_data
```

---

## Persistent data

Data is stored on the host machine under `/home/abbouras/data/`:

```
/home/abbouras/data/
├── db/         → MariaDB data files
└── wordpress/  → WordPress files
```

These directories are mounted as named volumes — data survives container restarts.

---

## Startup order

mariadb starts first and initializes the database on first run. wordpress waits for MariaDB to respond (ping loop), then installs WordPress via wp-cli. nginx starts last and proxies HTTPS requests to php-fpm on port 9000.
