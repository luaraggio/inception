DOCKER_COMPOSE= docker compose -f docker-compose.yml
MARIADB_CONTAINER = mariadb
WP_CONTAINER = wordpress
NGINX_CONTAINER = nginx

all: up

up:
	$(DOCKER_COMPOSE) up -d --build

down:
	$(DOCKER_COMPOSE) down

build:
	$(DOCKER_COMPOSE) build

clean:
	$(DOCKER_COMPOSE) down -v

fclean: clean
		docker system prune -af --volumes

re: fclean up

logs:
	$(DOCKER_COMPOSE) logs -f

ls:
	$(DOCKER_COMPOSE) ls

ps:
	$(DOCKER_COMPOSE) ps

mariadb_bash:
	docker exec -it $(MARIADB_CONTAINER) bash

mariadb_service:
	$(DOCKER_COMPOSE) up $(MARIADB_CONTAINER)

mariadb_logs:
	docker logs $(MARIADB_CONTAINER)

wordpress_bash:
	docker exec -it $(WP_CONTAINER) bash

wordpress_service:
	$(DOCKER_COMPOSE) up $(WP_CONTAINER)

wordpress_logs:
	docker logs $(WP_CONTAINER)

nginx_bash:
	docker exec -it $(NGINX_CONTAINER) bash

nginx_service:
	 $(DOCKER_COMPOSE) up $(NGINX_CONTAINER)

nginx_logs:
	docker logs $(NGINX_CONTAINER)

.PHONY: all up down build clean fclean re logs ps
