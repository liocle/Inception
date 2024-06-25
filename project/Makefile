all:
	if ! grep -q "lclerc.42.fr" /etc/hosts; then \
		echo "127.0.0.1 lclerc.42.fr" >> /etc/hosts; \
	fi
	if ! grep -q "www.lclerc.42.fr" /etc/hosts; then \
		echo "127.0.0.1 www.lclerc.42.fr" >> /etc/hosts; \
	fi
	mkdir -p /home/lclerc/data/mariadb-data
	mkdir -p /home/lclerc/data/wordpress-data
	docker-compose -f srcs/docker-compose.yml build
	docker-compose -f srcs/docker-compose.yml up -d
	
clean:
	docker-compose -f srcs/docker-compose.yml down --rmi all -v

fclean: clean
	sed -i '/lclerc\.42\.fr/d' /etc/hosts
	rm -rf /home/lclerc/data/mariadb-data
	rm -rf /home/lclerc/data/wordpress-data
	docker system prune -f

re: fclean all

up:
	docker-compose -f srcs/docker-compose.yml up -d

down:
	docker-compose -f srcs/docker-compose.yml down

.PHONY: all clean fclean re up down
