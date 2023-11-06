COMPOSE_FILE := srcs/docker-compose.yml

all: build up

build:
	mkdir -p ~/data
	mkdir -p ~/data/mariadb
	mkdir -p ~/data/wordpress
	docker compose -f $(COMPOSE_FILE) build

up:
	docker compose -f $(COMPOSE_FILE) up -d

down:
	docker compose -f $(COMPOSE_FILE) down

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

#erase all images and volumes USE WITH CAUTION!!!
clean:
	docker compose -f $(COMPOSE_FILE) down --rmi all --volumes
	docker image prune -a -f

fclean: clean
	sudo rm -rf ~/data
	docker volume prune -f

.PHONY: all build up down logs
