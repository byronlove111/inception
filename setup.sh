#!/bin/sh

# Crée les fichiers de secrets et le .env avec des valeurs vides
# A remplir manuellement avant de lancer make

mkdir -p secrets

printf "Enter db_password: ";      read v; echo "$v" > secrets/db_password.txt
printf "Enter db_root_password: "; read v; echo "$v" > secrets/db_root_password.txt
printf "Enter wp_admin_password: "; read v; echo "$v" > secrets/wp_admin_password.txt
printf "Enter wp_user_password: "; read v; echo "$v" > secrets/wp_user_password.txt

cat > secrets/credentials.txt << EOF
WP_ADMIN_USER=wpadmin
WP_ADMIN_PASSWORD=$(cat secrets/wp_admin_password.txt)
WP_ADMIN_EMAIL=abbouras@student.42.fr
WP_USER=wpuser
WP_USER_PASSWORD=$(cat secrets/wp_user_password.txt)
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

echo "Done. Run 'make' to start the project."
