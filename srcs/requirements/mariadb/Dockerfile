FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# remplace la config debian par défaut qui force bind-address=127.0.0.1
COPY conf/my.cnf /etc/mysql/mariadb.conf.d/99-custom.cnf

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

EXPOSE 3306

ENTRYPOINT ["init.sh"]
