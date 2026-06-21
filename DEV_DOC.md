# Developer Documentation

## Prerequisites

- Docker Engine and Docker Compose plugin installed
- Linux machine or VM
- Domain `abbouras.42.fr` pointing to localhost:

```bash
echo "127.0.0.1 abbouras.42.fr" | sudo tee -a /etc/hosts
```

---

## Project structure

```
.
├── Makefile                          # Build and lifecycle commands
├── secrets/                          # Passwords (ignored by Git)
│   ├── credentials.txt               # WordPress admin and user passwords
│   ├── db_password.txt               # MariaDB user password
│   ├── db_root_password.txt          # MariaDB root password
│   ├── wp_admin_password.txt         # WordPress admin password
│   └── wp_user_password.txt          # WordPress user password
└── srcs/
    ├── .env                          # Environment variables (ignored by Git)
    ├── docker-compose.yml            # Infrastructure definition
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/my.cnf           # MariaDB config (bind-address, port)
        │   └── tools/init.sh         # DB initialization script
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/nginx.conf       # NGINX TLS + FastCGI config
        └── wordpress/
            ├── Dockerfile
            ├── conf/www.conf         # php-fpm pool config
            └── tools/setup.sh        # WordPress installation script
```

---

## Configuration files

### `srcs/.env`

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

### `secrets/`

Each file contains a single password on one line:

```
secrets/db_password.txt         → MariaDB user password
secrets/db_root_password.txt    → MariaDB root password
secrets/wp_admin_password.txt   → WordPress admin password
secrets/wp_user_password.txt    → WordPress user password
```

---

## Build and launch

```bash
make        # creates /home/abbouras/data/, builds images, starts containers
make down   # stops and removes containers
make re     # full rebuild from scratch
make logs   # follow logs from all containers
make status # show container status
```

---

## Useful container commands

```bash
# Enter MariaDB shell
docker exec -it mariadb mysql -uroot -p

# Check WordPress files
docker exec -it wordpress ls /var/www/html

# Check NGINX config
docker exec -it nginx nginx -t

# Inspect volumes (verify /home/abbouras/data/ path)
docker volume inspect srcs_mariadb_data
docker volume inspect srcs_wordpress_data
```

---

## Data persistence

WordPress files and the MariaDB database are stored on the host machine at:

```
/home/abbouras/data/
├── db/         → MariaDB data files
└── wordpress/  → WordPress files (wp-content, wp-config.php, etc.)
```

These directories are mounted as named Docker volumes. Data persists across container restarts and reboots.

---

## How startup order works

1. `mariadb` starts first and initializes the database (only on first run)
2. `wordpress` waits for MariaDB to respond (ping loop), then configures WordPress via wp-cli
3. `nginx` starts after WordPress and proxies HTTPS requests to php-fpm on port 9000
