# Image de base — debian bookworm-slim = avant-dernière version stable de Debian (oldstable), version "slim" = minimale
FROM debian:bookworm-slim

# Met à jour les paquets et installe mariadb-server
# Le && rm -rf /var/lib/apt/lists/* supprime le cache apt pour réduire la taille de l'image
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Remplace la config par défaut de Debian qui force bind-address=127.0.0.1
# On copie dans mariadb.conf.d/ qui est lu après conf.d/ et prend la priorité
COPY conf/my.cnf /etc/mysql/mariadb.conf.d/99-custom.cnf

# Copie le script d'initialisation dans le PATH pour pouvoir l'appeler directement
COPY tools/init.sh /usr/local/bin/init.sh

# Rend le script exécutable
RUN chmod +x /usr/local/bin/init.sh

# Crée le dossier du socket MariaDB et donne les droits à l'utilisateur mysql
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Documente que le conteneur écoute sur le port 3306 (port standard MariaDB)
EXPOSE 3306

# Lance init.sh au démarrage du conteneur — init.sh se termine par "exec mysqld"
# ce qui fait que mysqld devient PID 1 (requis par le sujet)
ENTRYPOINT ["init.sh"]
