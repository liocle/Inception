#!/bin/sh

# Downloads and installs WordPress using 'wp core'
# SOURCE: https://developer.wordpress.org/cli/commands/
#

sed -i "s/user = nobody/user = www/" /etc/php82/php-fpm.d/www.conf
sed -i "s/group = nobody/group = www/" /etc/php82/php-fpm.d/www.conf
sed -i "s/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/" /etc/php82/php-fpm.d/www.conf
sed -i "s/;listen.owner = nobody/listen.owner = www/" /etc/php82/php-fpm.d/www.conf

mv /wp-config.php /var/www/html/wp-config.php

echo "WordPress setup script started"

# Check if wordpress is already installed
# SOURCE: https://developer.wordpress.org/cli/commands/core/is-installed/
if ! /wordpress/wp core is-installed --path=/var/www/html; then
	echo "Wordpress is not installed, installing it." 
	# https://developer.wordpress.org/cli/commands/core/install/
	/wordpress/wp core install  --url=${DOMAIN_NAME} \
		--title=${WP_SITE_TITLE} \
		--admin_user=${WP_ADMIN_USER} \
		--admin_password=${WP_ADMIN_PASSWORD} \
		--admin_email=${WP_ADMIN_EMAIL} \
		--path=/var/www/html \
		--skip-email

	/wordpress/wp user create ${WP_USER} \
		${WP_EMAIL} \
		--role=author \
		--user_pass=${WP_PASSWORD}

	/wordpress/wp option update siteurl "https://${DOMAIN_NAME}"
	/wordpress/wp option update home "https://${DOMAIN_NAME}"
	
fi

chown -R www:www /var/www/html

exec /usr/sbin/php-fpm82 -F 
