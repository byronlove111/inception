#!/bin/sh
set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

echo "Waiting for MariaDB..."
i=0
until mysqladmin ping -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$DB_PASSWORD" --silent 2>/dev/null; do
    i=$((i + 1))
    if [ "$i" -ge 30 ]; then
        echo "MariaDB did not respond after 30 seconds, aborting."
        exit 1
    fi
    sleep 1
done
echo "MariaDB is ready."

# si wp-config.php existe déjà, wordpress est installé (redémarrage du conteneur ou volume existant)
if [ ! -f /var/www/html/wp-config.php ]; then

    wp core download --allow-root --path=/var/www/html

    wp config create \
        --allow-root \
        --path=/var/www/html \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$MYSQL_HOST"

    wp core install \
        --allow-root \
        --path=/var/www/html \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    wp user create \
        --allow-root \
        --path=/var/www/html \
        "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author

fi

exec php-fpm8.2 -F
