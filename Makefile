DOCKER-COMPOSE= docker compose -f docker-compose.yml

up:
	$(DOCKER-COMPOSE) up -d --build

down:
	$(DOCKER-COMPOSE) down

logs:
	$(DOCKER-COMPOSE) logs -f

ps:
	$(DOCKER-COMPOSE) ps

.PHONY: up down logs ps
