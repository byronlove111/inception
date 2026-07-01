#!/bin/sh

mkdir -p secrets

echo "" > secrets/db_password.txt
echo "" > secrets/db_root_password.txt
echo "" > secrets/wp_admin_password.txt
echo "" > secrets/wp_user_password.txt

cat > secrets/credentials.txt << EOF
WP_ADMIN_USER=wpadmin
WP_ADMIN_PASSWORD=
WP_ADMIN_EMAIL=abbouras@student.42.fr
WP_USER=wpuser
WP_USER_PASSWORD=
WP_USER_EMAIL=wpuser@student.42.fr
EOF

cat > srcs/.env << EOF
DOMAIN_NAME=abbouras.42.fr
MYSQL_HOST=mariadb
MYSQL_DATABASE=wordpress
MYSQL_USER=abbouras
WP_TITLE=Inception
WP_ADMIN_USER=wpadmin
WP_ADMIN_EMAIL=abbouras@student.42.fr
WP_USER=wpuser
WP_USER_EMAIL=wpuser@student.42.fr
EOF

echo "127.0.0.1 abbouras.42.fr" | sudo tee -a /etc/hosts > /dev/null

echo "Files created. Fill in the passwords in secrets/ before running make."
