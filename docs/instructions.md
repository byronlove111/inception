# Instructions — Déploiement sur la VM 42

## 1. Installer Docker

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
# Ferme et rouvre le terminal pour appliquer le groupe
```

## 2. Cloner le repo

```bash
git clone <url_du_repo>
cd inception
```

## 3. Créer les fichiers secrets (non trackés par Git)

```bash
mkdir -p secrets

echo "wp_db_password"    > secrets/db_password.txt
echo "root_db_password"  > secrets/db_root_password.txt
echo "wp_admin_password" > secrets/wp_admin_password.txt
echo "wp_user_password"  > secrets/wp_user_password.txt

cat > secrets/credentials.txt << EOF
WP_ADMIN_USER=wpadmin
WP_ADMIN_PASSWORD=wp_admin_password
WP_ADMIN_EMAIL=abbouras@student.42.fr
WP_USER=wpuser
WP_USER_PASSWORD=wp_user_password
WP_USER_EMAIL=wpuser@student.42.fr
EOF
```

## 4. Créer le fichier .env (non tracké par Git)

```bash
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
```

## 5. Configurer le domaine

```bash
echo "127.0.0.1 abbouras.42.fr" | sudo tee -a /etc/hosts
```

## 6. Lancer le projet

```bash
make
```

## 7. Vérifier

```bash
make status
# Les 3 containers (nginx, wordpress, mariadb) doivent être Up

curl -sk https://abbouras.42.fr -o /dev/null -w "%{http_code}\n"
# Doit retourner 200
```

Ouvre ensuite `https://abbouras.42.fr` dans le navigateur.
