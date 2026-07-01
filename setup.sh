#!/bin/sh

mkdir -p secrets

echo "" > secrets/db_password.txt
echo "" > secrets/db_root_password.txt
echo "" > secrets/wp_admin_password.txt
echo "" > secrets/wp_user_password.txt
echo "" > secrets/credentials.txt

cat > srcs/.env << EOF
DOMAIN_NAME=
MYSQL_HOST=
MYSQL_DATABASE=
MYSQL_USER=
WP_TITLE=
WP_ADMIN_USER=
WP_ADMIN_EMAIL=
WP_USER=
WP_USER_EMAIL=
EOF

echo "127.0.0.1 abbouras.42.fr" | sudo tee -a /etc/hosts > /dev/null

echo "Files created. Fill in secrets/ and srcs/.env before running make."
