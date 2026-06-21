# Image de base — debian bookworm-slim = avant-dernière version stable (oldstable)
FROM debian:bookworm-slim

# Installe php-fpm, les extensions PHP requises par WordPress, le client MariaDB (pour le ping), et curl (pour wp-cli)
RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip \
    mariadb-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Télécharge wp-cli (outil de gestion WordPress en ligne de commande)
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# Remplace la config par défaut de php-fpm par la nôtre
# On supprime le pool www.conf par défaut et on met le nôtre
RUN rm -f /etc/php/8.2/fpm/pool.d/www.conf
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copie le script de configuration WordPress
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# Crée le dossier où seront stockés les fichiers WordPress
# www-data est l'utilisateur de php-fpm — il doit avoir les droits sur ce dossier
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

# Crée le dossier du socket php-fpm
RUN mkdir -p /run/php

# Documente que php-fpm écoute sur le port 9000
EXPOSE 9000

ENTRYPOINT ["setup.sh"]
