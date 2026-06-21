FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# génère un certificat TLS auto-signé au build (-nodes = sans passphrase pour que nginx démarre)
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/key.pem \
    -out    /etc/nginx/ssl/cert.pem \
    -days   365 \
    -nodes  \
    -subj   "/C=FR/ST=IDF/L=Paris/O=42/CN=abbouras.42.fr"

COPY conf/nginx.conf /etc/nginx/sites-available/default

EXPOSE 443

# daemon off = nginx reste en foreground, sinon le conteneur s'arrête immédiatement
CMD ["nginx", "-g", "daemon off;"]
