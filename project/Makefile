COMPOSE_FILE_PATH		= ./srcs/docker-compose.yml
ENV_FILE_PATH				=	./srcs/.env

COMPOSE_COMMAND_SEQ	=	docker compose --env-file $(ENV_FILE_PATH) -f $(COMPOSE_FILE_PATH)

include $(ENV_FILE_PATH)

.PHONY: all
all: up

.PHONY: up
up: create-data-path build
	$(COMPOSE_COMMAND_SEQ) up --detach

.PHONY: build
build:
	$(COMPOSE_COMMAND_SEQ) build

.PHONY: down
down:
	$(COMPOSE_COMMAND_SEQ) down

.PHONY: stop
stop:
	$(COMPOSE_COMMAND_SEQ) stop

.PHONY: clean
clean: stop
	docker system prune -f

.PHONY: fclean
fclean: stop 
	docker system prune -af --volumes

.PHONY: reup
reup: clean up

.PHONY: wordpress
wordpress:
	$(COMPOSE_COMMAND_SEQ) build --no-cache wordpress
	$(COMPOSE_COMMAND_SEQ) up --force-recreate --no-deps -d wordpress

.PHONY: nginx
nginx:
	$(COMPOSE_COMMAND_SEQ) build --no-cache nginx
	$(COMPOSE_COMMAND_SEQ) up --force-recreate --no-deps -d nginx

.PHONY: mariadb
mariadb:
	$(COMPOSE_COMMAND_SEQ) build --no-cache mariadb
	$(COMPOSE_COMMAND_SEQ) up --force-recreate --no-deps -d mariadb

.PHONY: exec-wordpress
exec-wordpress:
	docker exec -it wordpress sh

.PHONY: exec-nginx
exec-nginx:
	docker exec -it nginx sh

.PHONY: exec-mariadb
exec-mariadb:
	docker exec -it mariadb sh

.PHONY: ps
ps:
	$(COMPOSE_COMMAND_SEQ) ps

.PHONY: clean-data
clean-data: clean remove-data-path create-data-path

.PHONY: create-data-path
create-data-path:
	mkdir -p /data/wordpress
	mkdir -p /data/mariadb
	mkdir -p /data/nginx-logs

.PHONY: remove-data-path
remove-data-path:
	doas rm -rf /data/wordpress
	doas rm -rf /data/mariadb
	doas rm -rf /data/nginx-logs

 # .PHONY: dev
 # dev:
 # 	docker rm -f alpine &> /dev/null
 # 	docker run --rm -it --name alpine alpine:$(ALPINE_PENULTIMATE_VERSION_TAG) /bin/ash # all:
 # 
 # 	if ! grep -q "lclerc.42.fr" /etc/hosts; then \
 # 		echo "127.0.0.1 lclerc.42.fr" >> /etc/hosts; \
 # 	fi
 # 	if ! grep -q "www.lclerc.42.fr" /etc/hosts; then \
 # 		echo "127.0.0.1 www.lclerc.42.fr" >> /etc/hosts; \
 # 	fi
 # 	mkdir -p /data/mariadb
 # 	mkdir -p /data/wordpress
 # 	docker-compose -f srcs/docker-compose.yml build
 # 	docker-compose -f srcs/docker-compose.yml up -d
 # 	
 # clean:
 # 	docker-compose -f srcs/docker-compose.yml down --rmi all -v
 # 
 # fclean: clean
 # 	sed -i '/lclerc\.42\.fr/d' /etc/hosts
 # 	rm -rf /data/mariadb
 # 	rm -rf /data/wordpress
 # 	docker system prune -f
 # 
 # re: fclean all
 # 
 # up:
 # 	docker-compose -f srcs/docker-compose.yml up -d
 # 
 # down:
 # 	docker-compose -f srcs/docker-compose.yml down
 # 
 # .PHONY: all clean fclean re up down
