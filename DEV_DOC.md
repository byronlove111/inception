# Developer Documentation

## Setup

Docker Engine + Docker Compose plugin installés, Linux ou VM.

Ajouter le domaine :
```bash
echo "127.0.0.1 abbouras.42.fr" | sudo tee -a /etc/hosts
```

Créer les fichiers de config avant de builder :

**`srcs/.env`**
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

**`secrets/`** — un mot de passe par fichier, une seule ligne :
```
secrets/db_password.txt
secrets/db_root_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
```

---

## Structure

```
.
├── Makefile
├── secrets/                          # ignoré par git
│   ├── credentials.txt
│   ├── db_password.txt
│   ├── db_root_password.txt
│   ├── wp_admin_password.txt
│   └── wp_user_password.txt
└── srcs/
    ├── .env                          # ignoré par git
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

## Commandes

```bash
make          # crée /home/abbouras/data/, build et démarre
make down     # arrête et supprime les conteneurs
make re       # rebuild complet
make logs     # logs en temps réel
make status   # état des conteneurs
```

Commandes utiles pour déboguer :

```bash
docker exec -it mariadb mysql -uroot -p
docker exec -it wordpress ls /var/www/html
docker exec -it nginx nginx -t
docker volume inspect srcs_mariadb_data
```

---

## Données persistantes

Les données sont stockées sur la machine hôte dans `/home/abbouras/data/` :

```
/home/abbouras/data/
├── db/         → fichiers MariaDB
└── wordpress/  → fichiers WordPress
```

Ces dossiers sont montés via des volumes nommés — les données survivent aux redémarrages des conteneurs.

---

## Ordre de démarrage

mariadb démarre en premier et initialise la BDD si c'est le premier lancement. wordpress attend que MariaDB réponde (boucle de ping), puis lance l'installation via wp-cli. nginx démarre en dernier et proxifie les requêtes HTTPS vers php-fpm sur le port 9000.
