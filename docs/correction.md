# Déroulement de la correction — Mandatory

## 0. Le correcteur nettoie Docker (il le fait lui-même)

```bash
docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null
```

Il va aussi lire le `docker-compose.yml`, le `Makefile`, les `Dockerfile` et les scripts pour vérifier qu'il n'y a rien d'interdit. Tu n'as rien à faire, juste répondre à ses questions.

---

## 1. Lancer le projet

```bash
make
```

---

## 2. Questions théoriques

Il va te demander d'expliquer :

**Comment Docker et docker compose fonctionnent ?**
> Docker lance des applications dans des conteneurs isolés qui partagent le kernel de l'OS. Docker Compose orchestre plusieurs conteneurs définis dans un seul fichier `docker-compose.yml` — il les lance, les connecte et gère leurs dépendances avec une seule commande.

**Différence entre une image Docker avec compose vs sans ?**
> Sans compose tu lances un seul conteneur manuellement avec `docker run`. Avec compose tu définis plusieurs services qui démarrent ensemble, partagent un réseau et des volumes.

**Avantage de Docker vs les VMs ?**
> Les conteneurs partagent le kernel de l'OS hôte — ils sont légers, démarrent en secondes. Une VM embarque un OS complet, c'est plus lourd et plus lent.

**Pourquoi cette structure de dossiers ?**
> Tout dans `srcs/` pour séparer la config du reste. Les secrets hors du repo pour ne jamais exposer les mots de passe. Un Dockerfile par service pour que chaque conteneur soit indépendant.

**C'est quoi un docker network ?**
> Un réseau isolé qui permet aux conteneurs de communiquer entre eux par leur nom de service (ex: `wordpress` parle à `mariadb`), sans être exposés à l'extérieur.

---

## 3. Simple Setup

Ouvrir le navigateur dans la VM :

- `https://abbouras.42.fr` → WordPress s'affiche (pas la page d'installation)
- `http://abbouras.42.fr` → ne répond pas (port 80 fermé)
- Alerte SSL = normal, c'est un certificat auto-signé, cliquer sur "Avancer quand même"

---

## 4. Docker Basics

```bash
docker ps
# nginx, wordpress, mariadb → tous Up

docker images
# les 3 images s'appellent nginx, wordpress, mariadb
```

Montrer les 3 Dockerfiles (un par service, chacun commence par `FROM debian:...`).

---

## 5. Docker Network

```bash
docker network ls
# → voir inception_network
```

Expliquer ce qu'est un docker network (voir réponse au point 2).

---

## 6. NGINX + TLS

```bash
docker compose ps
# nginx → Up
```

- Montrer `https://abbouras.42.fr` dans le navigateur
- Cliquer sur le cadenas → montrer que c'est TLSv1.2 ou TLSv1.3
- Essayer `http://abbouras.42.fr` → ne répond pas

---

## 7. WordPress + Volume

```bash
docker compose ps
# wordpress → Up

docker volume ls
docker volume inspect srcs_wordpress_data
# → "device": "/home/abbouras/data/wordpress"
```

Ensuite dans le navigateur :
- Aller sur `https://abbouras.42.fr` → poster un commentaire avec le user `wpuser`
- Aller sur `https://abbouras.42.fr/wp-admin` → se connecter avec `abbouras` / `wp_admin_password`
- Éditer une page, sauvegarder, vérifier que le changement est visible sur le site

---

## 8. MariaDB + Volume

```bash
docker compose ps
# mariadb → Up

docker volume ls
docker volume inspect srcs_mariadb_data
# → "device": "/home/abbouras/data/db"
```

Se connecter à la base et montrer qu'elle n'est pas vide :

```bash
docker exec -it mariadb mysql -uroot -prootpassword
```

```sql
SHOW DATABASES;
USE wordpress;
SHOW TABLES;
exit
```

---

## 9. Persistance

Le correcteur va reboote la VM :

```bash
sudo reboot
```

Après le redémarrage, attendre 15 secondes puis :

```bash
docker ps
# si les conteneurs sont déjà Up → rien à faire (restart: always)
# sinon :
make
```

Ouvrir `https://abbouras.42.fr` → le site fonctionne, les changements faits à l'étape 7 sont toujours là.
