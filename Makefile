COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env

all:
	mkdir -p /home/abbouras/data/db /home/abbouras/data/wordpress
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

re: fclean all

fclean: down
	-docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	sudo rm -rf /home/abbouras/data

db:
	docker exec -it mariadb mysql -uroot -p$$(cat secrets/db_root_password.txt)

db-check:
	docker exec -it mariadb mysql -uroot -p$$(cat secrets/db_root_password.txt) -e "SHOW DATABASES; USE wordpress; SHOW TABLES;"

.PHONY: all down re fclean db db-check
