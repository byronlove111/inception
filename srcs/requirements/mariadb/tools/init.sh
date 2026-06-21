#!/bin/sh
set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# initialisation uniquement au premier démarrage — si le dossier existe, les données sont déjà là
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then

    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # mode bootstrap : pas de réseau, exécute le SQL puis s'arrête
    mysqld --user=mysql --bootstrap << EOF
FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';

GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

fi

exec mysqld --user=mysql
