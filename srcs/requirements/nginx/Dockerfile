# Image de base — debian bookworm-slim = avant-dernière version stable (oldstable)
FROM debian:bookworm-slim

# Installe NGINX et openssl (pour générer le certificat TLS auto-signé)
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Crée le dossier qui contiendra le certificat et la clé TLS
RUN mkdir -p /etc/nginx/ssl

# Génère un certificat TLS auto-signé valable 365 jours
# -x509      : génère directement un certificat auto-signé (pas une CSR)
# -newkey    : crée une nouvelle clé RSA 4096 bits
# -keyout    : chemin de la clé privée
# -out       : chemin du certificat
# -days      : durée de validité
# -nodes     : pas de passphrase sur la clé (nécessaire pour que NGINX démarre sans interaction)
# -subj      : informations du certificat (pays, organisation, nom de domaine)
RUN openssl req -x509 -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/key.pem \
    -out    /etc/nginx/ssl/cert.pem \
    -days   365 \
    -nodes  \
    -subj   "/C=FR/ST=IDF/L=Paris/O=42/CN=abbouras.42.fr"

# Copie notre config NGINX en remplacement de la config par défaut
COPY conf/nginx.conf /etc/nginx/sites-available/default

# Documente que NGINX écoute sur le port 443
EXPOSE 443

# Lance NGINX en foreground — devient PID 1
# "daemon off" empêche NGINX de se mettre en arrière-plan (sinon le conteneur s'arrête immédiatement)
CMD ["nginx", "-g", "daemon off;"]
