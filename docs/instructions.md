# Instructions — Déploiement sur la VM 42

## Avant de commencer

Le projet a des chemins hardcodés vers `/home/abbouras/data/`.
**Le user Linux de la VM doit obligatoirement s'appeler `abbouras`.**
Ce n'est pas le hostname qui compte, c'est le nom d'utilisateur.

---

## 1. Créer la VM

- Logiciel : VirtualBox ou VMware
- OS : Debian ou Ubuntu (version récente)
- **Username : `abbouras`** (obligatoire)
- RAM : 2 Go minimum recommandé
- Disque : 20 Go minimum

---

## 2. Installer Docker

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

Ferme et rouvre le terminal pour appliquer le groupe, puis vérifie :

```bash
docker --version
docker compose version
```

---

## 3. Cloner le repo

```bash
git clone <url_du_repo>
cd inception
```

---

## 4. Créer les fichiers secrets (non trackés par Git)

```bash
mkdir -p secrets

echo "wp_db_password"    > secrets/db_password.txt
echo "root_db_password"  > secrets/db_root_password.txt
echo "wp_admin_password" > secrets/wp_admin_password.txt
echo "wp_user_password"  > secrets/wp_user_password.txt

cat > secrets/credentials.txt << EOF
WP_ADMIN_USER=abbouras
WP_ADMIN_PASSWORD=wp_admin_password
WP_ADMIN_EMAIL=abbouras@student.42.fr
WP_USER=wpuser
WP_USER_PASSWORD=wp_user_password
WP_USER_EMAIL=wpuser@student.42.fr
EOF
```

---

## 5. Créer le fichier .env (non tracké par Git)

```bash
cat > srcs/.env << EOF
DOMAIN_NAME=abbouras.42.fr
MYSQL_HOST=mariadb
MYSQL_DATABASE=wordpress
MYSQL_USER=abbouras
WP_TITLE=Inception
WP_ADMIN_USER=abbouras
WP_ADMIN_EMAIL=abbouras@student.42.fr
WP_USER=wpuser
WP_USER_EMAIL=wpuser@student.42.fr
EOF
```

---

## 6. Configurer le domaine

```bash
echo "127.0.0.1 abbouras.42.fr" | sudo tee -a /etc/hosts
```

---

## 7. Lancer le projet

```bash
make
```

---

## 8. Vérifier

```bash
docker ps
# Les 3 containers doivent être Up : nginx, wordpress, mariadb
```

Ouvre ensuite `https://abbouras.42.fr` dans le navigateur de la VM.
Il y aura une alerte SSL (certificat auto-signé), c'est normal — clique sur "Avancer quand même".

Le site WordPress doit s'afficher.
Le panel admin est accessible sur `https://abbouras.42.fr/wp-admin` avec `abbouras` / `wp_admin_password`.

---

## 9. Configurer WordPress (avant le snapshot)

- Connecte-toi sur `https://abbouras.42.fr/wp-admin`
- Édite une page (ex: modifie le contenu de "Sample Page")
- Vérifie que le changement est visible sur le site

---

## 10. Tester la persistance (avant le snapshot)

```bash
sudo reboot
```

Après le redémarrage :

```bash
make
```

Vérifie que :
- `https://abbouras.42.fr` fonctionne encore
- Le changement fait sur la page WordPress est toujours là

---

## 11. Prendre le snapshot

**C'est maintenant que tu prends le snapshot dans VirtualBox/VMware.**

Le snapshot capture un état propre : tout tourne, reboot testé, WordPress configuré.
Si un correcteur casse quelque chose, tu restaures le snapshot en 30 secondes et tu es prêt pour le suivant.

---

## Pour la correction

Tu fais le setup **une seule fois** pour tes 3 correcteurs. Ils viennent les uns après les autres sur ta machine, ils voient tous la même VM qui tourne. Tu ne reclones pas entre chaque correction.
