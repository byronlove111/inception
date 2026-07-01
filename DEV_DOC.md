# Developer Documentation

## Setup

Docker Engine + Docker Compose plugin installed, Linux or VM.

Run the setup script:
```bash
./setup.sh
```

This will:
- Copy `secrets.example/` → `secrets/`
- Copy `srcs/.env.example` → `srcs/.env`
- Add `127.0.0.1 abbouras.42.fr` to `/etc/hosts`

Then fill in the passwords in each file under `secrets/` and the values in `srcs/.env`.

---

## Structure

```
.
├── Makefile
├── setup.sh
├── secrets.example/              # template — copy to secrets/ and fill in
│   ├── db_password.txt
│   ├── db_root_password.txt
│   ├── wp_admin_password.txt
│   └── wp_user_password.txt
├── secrets/                      # ignored by git — fill in before make
│   ├── db_password.txt
│   ├── db_root_password.txt
│   ├── wp_admin_password.txt
│   └── wp_user_password.txt
└── srcs/
    ├── .env                      # ignored by git — fill in before make
    ├── .env.example              # template
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
make fclean   # stops containers, removes volumes and data
make db       # connects to MariaDB interactively
make db-check # shows databases and tables non-interactively
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
