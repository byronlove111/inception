#!/bin/sh
set -e

# Lit les secrets Docker
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

# Attend que MariaDB soit prêt avant de continuer
# mysqladmin ping envoie un ping à MariaDB — on réessaie toutes les secondes
echo "Waiting for MariaDB..."
until mysqladmin ping -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$DB_PASSWORD" --silent 2>/dev/null; do
    sleep 1
done
echo "MariaDB is ready."

# Vérifie si WordPress est déjà installé (wp-config.php existe)
if [ ! -f /var/www/html/wp-config.php ]; then

    # Télécharge les fichiers WordPress dans /var/www/html
    wp core download --allow-root --path=/var/www/html

    # Crée le fichier wp-config.php avec les infos de connexion à MariaDB
    wp config create \
        --allow-root \
        --path=/var/www/html \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$MYSQL_HOST"

    # Installe WordPress — crée les tables dans MariaDB et configure le site
    wp core install \
        --allow-root \
        --path=/var/www/html \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    # Crée le second utilisateur (non-admin)
    wp user create \
        --allow-root \
        --path=/var/www/html \
        "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author

fi

# Lance php-fpm en foreground — devient PID 1
# -F = foreground (sans ce flag php-fpm se mettrait en daemon et le conteneur s'arrêterait)
exec php-fpm8.2 -F
