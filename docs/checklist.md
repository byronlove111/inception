# Inception — Checklist

## Structure du projet

- [ ] Créer un `Makefile` à la racine du repo
- [ ] Créer le dossier `srcs/` à la racine
- [ ] Créer `srcs/docker-compose.yml`
- [ ] Créer `srcs/.env` avec les variables d'environnement
- [ ] Créer le dossier `srcs/requirements/`
- [ ] Créer le dossier `secrets/` avec les fichiers de credentials (ignoré par git)
- [ ] Créer `README.md` à la racine
- [ ] Créer `USER_DOC.md` à la racine
- [ ] Créer `DEV_DOC.md` à la racine

---

## README.md

- [ ] Première ligne italique : *This project has been created as part of the 42 curriculum by \<login\>.*
- [ ] Section **Description** (objectif du projet + vue d'ensemble)
- [ ] Section **Instructions** (compilation, installation, exécution)
- [ ] Section **Resources** (docs, articles, tutos + usage de l'IA)
- [ ] Comparaison **Virtual Machines vs Docker**
- [ ] Comparaison **Secrets vs Environment Variables**
- [ ] Comparaison **Docker Network vs Host Network**
- [ ] Comparaison **Docker Volumes vs Bind Mounts**
- [ ] Rédigé en **anglais**

---

## Sécurité

- [ ] Aucun mot de passe dans les Dockerfiles
- [ ] Toutes les variables dans `.env`
- [ ] `.env` et `secrets/` dans `.gitignore`
- [ ] Utiliser des **Docker secrets** pour les informations sensibles
- [ ] Aucune credential dans le repo Git

---

## NGINX

- [ ] Créer `srcs/requirements/nginx/Dockerfile`
- [ ] Créer `srcs/requirements/nginx/.dockerignore`
- [ ] Créer `srcs/requirements/nginx/conf/`
- [ ] Dockerfile commence par `FROM alpine:X.X.X` ou `FROM debian:XXXXX`
- [ ] TLSv1.2 ou TLSv1.3 uniquement (pas de TLS 1.0/1.1)
- [ ] Port 443 uniquement (port 80 bloqué)
- [ ] Certificat SSL/TLS (auto-signé accepté)
- [ ] Image nommée `nginx`
- [ ] Pas de `tail -f`, `bash`, `sleep infinity` dans l'entrypoint
- [ ] Container redémarre en cas de crash (`restart: always` ou équivalent)
- [ ] NGINX est le **seul point d'entrée** de l'infrastructure

---

## WordPress + php-fpm

- [ ] Créer `srcs/requirements/wordpress/Dockerfile`
- [ ] Créer `srcs/requirements/wordpress/.dockerignore`
- [ ] Dockerfile commence par `FROM alpine:X.X.X` ou `FROM debian:XXXXX`
- [ ] php-fpm installé et configuré
- [ ] **Pas de NGINX** dans ce container
- [ ] WordPress installé et configuré (page d'installation ne doit pas apparaître)
- [ ] **Deux utilisateurs** dans la base WordPress :
  - [ ] Un administrateur (username sans `admin`, `Admin`, `administrator`)
  - [ ] Un utilisateur classique
- [ ] Image nommée `wordpress`
- [ ] Pas de `tail -f`, `bash`, `sleep infinity` dans l'entrypoint
- [ ] Container redémarre en cas de crash

---

## MariaDB

- [ ] Créer `srcs/requirements/mariadb/Dockerfile`
- [ ] Créer `srcs/requirements/mariadb/.dockerignore`
- [ ] Dockerfile commence par `FROM alpine:X.X.X` ou `FROM debian:XXXXX`
- [ ] **Pas de NGINX** dans ce container
- [ ] Base de données non vide
- [ ] Image nommée `mariadb`
- [ ] Pas de `tail -f`, `bash`, `sleep infinity` dans l'entrypoint
- [ ] Container redémarre en cas de crash

---

## Volumes

- [ ] Volume pour la **base de données WordPress**
- [ ] Volume pour les **fichiers du site WordPress**
- [ ] Utiliser des **Docker named volumes** (pas de bind mounts)
- [ ] Les deux volumes stockent leurs données dans `/home/login/data/` sur la machine hôte
- [ ] `docker volume inspect` affiche le chemin `/home/login/data/`

---

## Réseau

- [ ] Créer un **docker-network** dans `docker-compose.yml`
- [ ] La clé `networks` est présente dans `docker-compose.yml`
- [ ] Pas de `network: host` dans `docker-compose.yml`
- [ ] Pas de `links:` dans `docker-compose.yml`
- [ ] Pas de `--link` dans le Makefile ou les scripts

---

## docker-compose.yml

- [ ] Chaque service a son propre container dédié
- [ ] Les images sont nommées comme leur service correspondant
- [ ] Le tag `latest` est **interdit**
- [ ] Volumes déclarés
- [ ] Network déclaré
- [ ] Variables d'environnement via `.env`

---

## Makefile

- [ ] Lance le build et le démarrage via `docker compose`
- [ ] Construit les images à partir des Dockerfiles
- [ ] Pas de `--link` dans les commandes

---

## Domaine

- [ ] Configurer `login.42.fr` pour pointer vers l'IP locale
- [ ] Modifier `/etc/hosts` si nécessaire
- [ ] `https://login.42.fr` affiche le site WordPress
- [ ] `http://login.42.fr` est inaccessible

---

## Tests de persistance

- [ ] Reboot de la VM
- [ ] Relancer docker compose
- [ ] WordPress et MariaDB toujours fonctionnels
- [ ] Les modifications précédentes sont conservées

---

## Bonus (optionnel — uniquement si la partie obligatoire est parfaite)

- [ ] **Redis cache** pour WordPress
- [ ] **Serveur FTP** pointant vers le volume WordPress
- [ ] **Site statique** (pas en PHP) avec son propre Dockerfile
- [ ] **Adminer**
- [ ] **Service libre** au choix (justifié pendant la soutenance)

---

## Avant la soutenance

- [ ] `git clone` fonctionne dans un dossier vide
- [ ] La structure du repo est correcte (`srcs/`, `Makefile`, `README.md`, `USER_DOC.md`, `DEV_DOC.md`)
- [ ] Aucune credential visible dans le repo
- [ ] Le `Makefile` construit tout sans erreur
- [ ] Tous les containers tournent sans crash
- [ ] Être capable d'expliquer chaque partie du projet
