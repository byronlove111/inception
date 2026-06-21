*This project has been created as part of the 42 curriculum by abbouras.*

---

## Description

Inception est un projet de sysadmin qui consiste à monter une petite infrastructure avec Docker Compose. Trois services tournent dans des conteneurs séparés sur un réseau Docker privé :

- **NGINX** — point d'entrée unique, TLS sur le port 443 (TLSv1.2/1.3)
- **WordPress + php-fpm** — le site et l'admin
- **MariaDB** — la base de données

Tous les Dockerfiles sont basés sur Debian Bookworm (oldstable). Aucune image pre-built depuis Docker Hub.

### Virtual Machines vs Docker

Une VM émule un OS complet avec son propre kernel — ça prend plusieurs Go et quelques minutes à démarrer. Docker isole des processus via les namespaces Linux en partageant le kernel de la machine hôte. Résultat : des images de quelques dizaines de Mo et un démarrage quasi-instantané. La contrepartie c'est que l'isolation est moins forte qu'une VM.

### Secrets vs Environment Variables

Les variables d'environnement sont visibles dans la mémoire du processus et peuvent être exposées via `env` ou `docker inspect`. Les Docker secrets sont montés comme fichiers dans `/run/secrets/` avec des permissions restreintes — mieux adapté pour des mots de passe.

### Docker Network vs Host Network

Avec un réseau bridge Docker, chaque conteneur a son propre namespace réseau et une résolution DNS automatique par nom de service. En mode `host`, le conteneur partage directement la stack réseau de l'hôte — tous les ports sont exposés, pas de DNS Docker. Le sujet interdit `network: host`.

### Docker Volumes vs Bind Mounts

Les volumes nommés sont gérés par Docker, portables et indépendants du chemin hôte. Les bind mounts lient directement un dossier de l'hôte — pratiques en dev mais pas portables. Le sujet impose les volumes nommés (les bind mounts sont interdits).

---

## Instructions

Prérequis : Docker et Docker Compose installés, Linux ou VM.

Ajouter le domaine dans `/etc/hosts` :

```bash
echo "127.0.0.1 abbouras.42.fr" | sudo tee -a /etc/hosts
```

```bash
make          # build les images et démarre tout
make down     # arrête les conteneurs
make fclean   # repart de zéro (supprime tout)
```

---

## Resources

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/)
- [WP-CLI documentation](https://wp-cli.org/)
- [NGINX FastCGI + PHP](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html)
- [Debian releases](https://www.debian.org/releases/)

L'IA a servi principalement pour comprendre le fonctionnement de PID 1 dans Docker et les différences entre les modes de démarrage de MariaDB (bootstrap vs normal). Tout le code a été relu, testé et compris avant d'être intégré.
