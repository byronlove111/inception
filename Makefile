COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env

# Crée les dossiers de données sur la machine hôte, build les images et lance les conteneurs
all:
	mkdir -p /home/abbouras/data/db /home/abbouras/data/wordpress
	$(COMPOSE) up -d --build

# Arrête et supprime les conteneurs
down:
	$(COMPOSE) down

# Recrée tout depuis zéro (supprime conteneurs, images, volumes et données)
re: fclean all

# Arrête les conteneurs sans les supprimer
stop:
	$(COMPOSE) stop

# Redémarre les conteneurs
start:
	$(COMPOSE) start

# Affiche les logs de tous les conteneurs
logs:
	$(COMPOSE) logs -f

# Affiche le statut des conteneurs
status:
	$(COMPOSE) ps

# Supprime les conteneurs et les images buildées
clean:
	$(COMPOSE) down --rmi all

# Supprime tout — conteneurs, images, volumes et données sur la machine hôte
fclean: clean
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	rm -rf /home/abbouras/data

.PHONY: all down re stop start logs status clean fclean
