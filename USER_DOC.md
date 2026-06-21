# User Documentation

## Services

Le projet expose un site WordPress sur `https://abbouras.42.fr`.

Trois conteneurs tournent en arrière-plan :
- **nginx** — reçoit les connexions HTTPS sur le port 443
- **wordpress** — fait tourner le site (port 9000, interne)
- **mariadb** — la base de données (port 3306, interne)

Seul le port 443 est accessible depuis l'extérieur.

---

## Démarrer / arrêter

```bash
make        # démarre tout
make down   # arrête tout
```

Au premier démarrage, WordPress s'installe automatiquement — attendre ~30 secondes avant d'ouvrir le navigateur.

Pour vérifier que tout tourne :
```bash
make status
```
Les trois conteneurs doivent afficher `Up`.

---

## Accès

Site : `https://abbouras.42.fr`

Admin WordPress : `https://abbouras.42.fr/wp-admin`

> Le navigateur va afficher un avertissement de sécurité car le certificat TLS est auto-signé. Cliquer sur "Avancé" puis continuer.

---

## Identifiants

Tout est dans le dossier `secrets/` à la racine du projet (non tracké par git).

| Compte | Login | Fichier |
|---|---|---|
| WordPress Admin | `wpadmin` | `secrets/credentials.txt` |
| WordPress User | `wpuser` | `secrets/credentials.txt` |
| MariaDB User | `abbouras` | `secrets/db_password.txt` |
| MariaDB Root | `root` | `secrets/db_root_password.txt` |

---

## Vérifier que tout fonctionne

```bash
make logs

# vérifier que la BDD wordpress n'est pas vide
docker exec -it mariadb mysql -uabbouras -p wordpress -e "SHOW TABLES;"
```
