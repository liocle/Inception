# ~/project/srcs/requirements/wordpress/Dockerfile

# Sources:
# https://wiki.alpinelinux.org/wiki/Nginx_with_PHP
# https://developer.wordpress.org/advanced-administration/before-install/howto-install/

FROM alpine:3.19.1

WORKDIR /var/www/html

COPY ./conf/wp-config.php /var/www/html/wordpress/wp-config.php
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create a system user and system group 'www' if it doesn't exist
RUN addgroup -S www 
RUN adduser -S -H -G www www

# Setting up environment and install PHP
RUN apk update && apk upgrade 
RUN apk add --no-cache php82 php82-fpm php82-mysqli php82-mbstring curl libcurl php82-curl libzip php82-zip php82-phar mysql-client 

# Installing wp-cli, the command line tool for interacting with and managing WordPress sites.
# https://make.wordpress.org/cli/handbook/guides/installing/
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
RUN chmod +x wp-cli.phar
RUN mkdir /wordpress 
RUN mv wp-cli.phar /usr/local/bin/wp

## RUN /wordpress/wp core download --path=/var/www/html
RUN wget https://wordpress.org/wordpress-6.4.tar.gz -P /var/www/html 
RUN tar -xzf /var/www/html/wordpress-6.4.tar.gz
RUN rm /var/www/html/wordpress-6.4.tar.gz

WORKDIR /var/www/html/wordpress
EXPOSE 9000

ENTRYPOINT ["sh", "/entrypoint.sh"]


