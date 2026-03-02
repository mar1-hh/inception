NAME = inception
COMPOSE = docker compose
COMPOSE_FILE = srcs/docker-compose.yml

DATA_DIR = /home/msaadaou/data
MYSQL_DIR = $(DATA_DIR)/mysql
WP_DIR = $(DATA_DIR)/wordpress
BACKUP_DIR = $(DATA_DIR)/backups


all: up

dirs:
	mkdir -p $(MYSQL_DIR) $(WP_DIR) $(BACKUP_DIR)

up: dirs
	$(COMPOSE) -f $(COMPOSE_FILE) up -d --build

down:
	$(COMPOSE) -f $(COMPOSE_FILE) down

re: down up

clean: down

fclean: down
	$(COMPOSE) -f $(COMPOSE_FILE) down --rmi all -v
	sudo rm -rf $(MYSQL_DIR) $(WP_DIR) $(BACKUP_DIR)

.PHONY: all up down re clean fclean dirs