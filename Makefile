COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env

all:
	mkdir -p /home/abbouras/data/db /home/abbouras/data/wordpress
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

re: fclean all

fclean: down
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	rm -rf /home/abbouras/data

.PHONY: all down re fclean
