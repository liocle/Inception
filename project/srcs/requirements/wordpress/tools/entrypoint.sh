 ## #!/bin/sh
 ## 
 ## # Downloads and installs WordPress using 'wp core'
 ## # SOURCE: https://developer.wordpress.org/cli/commands/
 ## #
 ## 
 ## sed -i "s/user = nobody/user = www/" /etc/php82/php-fpm.d/www.conf
 ## sed -i "s/group = nobody/group = www/" /etc/php82/php-fpm.d/www.conf
 ## sed -i "s/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/" /etc/php82/php-fpm.d/www.conf
 ## sed -i "s/;listen.owner = nobody/listen.owner = www/" /etc/php82/php-fpm.d/www.conf
 ## 
 ## mv /wp-config.php /var/www/html/wp-config.php
 ## 
 ## echo "WordPress setup script started"
 ## 
 ## # Check if wordpress is already installed
 ## # SOURCE: https://developer.wordpress.org/cli/commands/core/is-installed/
 ## if ! /wordpress/wp core is-installed --path=/var/www/html; then
 ## 	echo "Wordpress is not installed, installing it." 
 ## 	# https://developer.wordpress.org/cli/commands/core/install/
 ## 	/wordpress/wp core install  --url=${NGINX_HOST_DOMAIN} \
 ## 		--title=${WP_SITE_TITLE} \
 ## 		--admin_user=${WP_ADMIN_USER} \
 ## 		--admin_password=${WP_ADMIN_PASSWORD} \
 ## 		--admin_email=${WP_ADMIN_EMAIL} \
 ## 		--path=/var/www/html \
 ## 		--skip-email
 ## 
 ## 	/wordpress/wp user create ${WP_USER} \
 ## 		${WP_EMAIL} \
 ## 		--role=author \
 ## 		--user_pass=${WP_PASSWORD}
 ## 
 ## 	/wordpress/wp option update siteurl "https://${NGINX_HOST_DOMAIN}"
 ## 	/wordpress/wp option update home "https://${NGINX_HOST_DOMAIN}"
 ## 	
 ## fi
 ## 
 ## chown -R www:www /var/www/html
 ## 
 ## exec /usr/sbin/php-fpm82 -F 
 #
#!/bin/bash

sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/' /etc/php82/php-fpm.d/www.conf
sed -i 's/;listen.owner = nobody/listen.owner = www/' /etc/php82/php-fpm.d/www.conf
sed -i 's/;listen.group = nobody/listen.group = www/' /etc/php82/php-fpm.d/www.conf
sed -i 's/user = nobody/user = www/' /etc/php82/php-fpm.d/www.conf
sed -i 's/group = nobody/group = www/' /etc/php82/php-fpm.d/www.conf

echo "Starting WordPress setup script".

while ! mariadb -h $NGINX_HOST_DOMAIN -u $MYSQL_USER -p$MYSQL_PASSWORD $DB_NAME &>/dev/null;
do
    echo "Waiting for the database to be ready";
    sleep 5;
done
echo "ready!"

if [ -f wp-config.php ]; then
    echo "WordPress: already installed"
else
	wp core download --allow-root

	wp config create --allow-root \
		--dbhost=${NGINX_HOST_DOMAIN} \
		--dbname=${DB_NAME} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASSWORD}

	wp core install \
			--url=https://${NGINX_HOST_DOMAIN} \
			--title=${WP_SITE_TITLE} \
			--admin_user=${WP_ADMIN_USER} \
			--admin_password=${WP_ADMIN_PASSWORD} \
			--admin_email=${WP_ADMIN_EMAIL} \
			--path=/var/www/html/wordpress/ \
			--allow-root;

    # Create an additional user with the role of author
    wp user create \
        ${WP_USER} \
        ${WP_EMAIL} \
        --role=author \
        --user_pass=${WP_PASSWORD} \
        --allow-root \
        --path=/var/www/html/wordpress;
	
	wp cache flush \
        --allow-root;

    # Install a WordPress theme
    wp theme install \
        inspiro \
        --activate \
        --allow-root;

    # Update the WordPress site URL option
    wp option update siteurl "https://${NGINX_HOST_DOMAIN}" \
        --allow-root;

    # Update the WordPress home option
    wp option update home "https://${NGINX_HOST_DOMAIN}" \
        --allow-root;

	chown -R www:www /var/www/html
	chmod -R 775 /var/www/html
	echo "wordpress installation completed"
fi
chown -R www:www /var/www/html
chmod -R 775 /var/www/html

exec php-fpm82 -F -R
