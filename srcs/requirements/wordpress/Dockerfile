FROM debian:bookworm-slim

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

# wp-cli : outil en ligne de commande utilisé dans setup.sh pour installer et configurer wordpress
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# remplace la config par défaut du pool (écoute sur 127.0.0.1 par défaut, on a besoin de 0.0.0.0)
RUN rm -f /etc/php/8.2/fpm/pool.d/www.conf
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

RUN mkdir -p /run/php

EXPOSE 9000

ENTRYPOINT ["setup.sh"]
