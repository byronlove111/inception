#!/bin/sh
set -e  # arrête le script immédiatement si une commande échoue

# Lit les mots de passe depuis les fichiers secrets Docker
# Docker monte les secrets dans /run/secrets/ au démarrage du conteneur
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# Vérifie si la base de données a déjà été initialisée
# Si le dossier de la BDD n'existe pas → premier démarrage → on initialise
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then

    # Crée la structure de fichiers initiale de MariaDB dans /var/lib/mysql
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # Lance MariaDB en mode bootstrap (sans réseau, juste pour exécuter du SQL)
    # Le heredoc << EOF permet d'envoyer plusieurs commandes SQL d'un coup
    mysqld --user=mysql --bootstrap << EOF
FLUSH PRIVILEGES;

-- Définit le mot de passe du compte root
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

-- Crée la base de données WordPress
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

-- Crée l'utilisateur WordPress avec son mot de passe
-- Le '%' signifie qu'il peut se connecter depuis n'importe quelle IP (pas seulement localhost)
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';

-- Donne tous les droits à cet utilisateur sur la base WordPress uniquement
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

fi

# Lance MariaDB en remplaçant le process shell par mysqld (exec = pas de process parent)
# Grâce à exec, mysqld devient PID 1 — requis par le sujet
exec mysqld --user=mysql
