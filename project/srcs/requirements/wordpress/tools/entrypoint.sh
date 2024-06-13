#!/bin/sh

## @link https://developer.wordpress.org/cli/commands/core/install/

mv /wp-config.php /var/www/html/wp-config.php

if ! /app/wp core is-installed --path=/var/www/html; then
    echo "Wordpress is not installed, installing it." >> /proc/1/fd/1
    /app/wp core install  --url=${DOMAIN_NAME} \
                          --title=${WP_SITE_TITLE} \
                          --admin_user=${WP_ADMIN_USER} \
                          --admin_password=${WP_ADMIN_PASSWORD} \
                          --admin_email=${WP_ADMIN_EMAIL} \
                          --path=/var/www/html \
			  --skip-email
                          1> /proc/1/fd/1 2> /proc/1/fd/2

    /app/wp user create <EDITOR_USER> <EDITOR_EMAIL> \
                        --role=editor \
                        --user_pass=<EDITOR_PASSWORD> \
                        1> /proc/1/fd/1 2> /proc/1/fd/2

    /app/wp plugin update --all \
        1> /proc/1/fd/1 2> /proc/1/fd/2
    
fi

chown -R www:www /var/www/html

exec /usr/sbin/php-fpm82 -F
