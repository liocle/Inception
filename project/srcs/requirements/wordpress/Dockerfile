# ~/project/srcs/requirements/wordpress/Dockerfile

# Sources:
# https://wiki.alpinelinux.org/wiki/Nginx_with_PHP
# https://developer.wordpress.org/advanced-administration/wordpress/wp-config/

FROM alpine:3.19.1

RUN apk update && apk upgrade
RUN apk add php82 php82-fpm php82-mysqli php82-mbstring curl libcurl php82-curl libzip php82-zip php82-phar

WORKDIR /var/www/html

COPY ./conf/wp-config.php /wp-config.php
COPY ./tools/entrypoint.sh /entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]


