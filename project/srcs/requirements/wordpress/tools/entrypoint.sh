#!/bin/bash
echo "Starting WordPress setup script."

# Update php-fpm configuration to use correct user and address
sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/' /etc/php82/php-fpm.d/www.conf
sed -i 's/;listen.owner = nobody/listen.owner = www/' /etc/php82/php-fpm.d/www.conf
sed -i 's/;listen.group = nobody/listen.group = www/' /etc/php82/php-fpm.d/www.conf
sed -i 's/user = nobody/user = www/' /etc/php82/php-fpm.d/www.conf
sed -i 's/group = nobody/group = www/' /etc/php82/php-fpm.d/www.conf

echo "Waiting for MariaDB to start..."

# Check for MariaDB readiness
until mysql -h "$DB_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SHOW DATABASES;" > /dev/null 2>&1; do
    echo "MariaDB is unavailable - waiting..."
    sleep 5
done

echo "MariaDB is up - proceeding with WordPress setup."

# Check if WordPress is already installed
if ! wp core is-installed --allow-root --path=/var/www/html; then
    echo "WordPress is not installed. Proceeding with installation."
    
    wp core download --allow-root --path=/var/www/html

    # Configure WordPress
    if [ ! -f /var/www/html/wp-config.php ]; then
        wp config create --allow-root \
            --dbhost="${DB_HOST}" \
            --dbname="${DB_NAME}" \
            --dbuser="${MYSQL_USER}" \
            --dbpass="${MYSQL_PASSWORD}" \
            --path=/var/www/html
    fi

    # Install WordPress
    wp core install --allow-root \
        --url=https://${NGINX_HOST_DOMAIN} \
        --title="${WP_SITE_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --path=/var/www/html

    # Create additional WordPress user
    wp user create "${WP_USER}" "${WP_EMAIL}" \
        --role=author \
        --user_pass="${WP_PASSWORD}" \
        --allow-root \
        --path=/var/www/html

    wp cache flush --allow-root --path=/var/www/html
    wp theme install inspiro --activate --allow-root --path=/var/www/html
    wp option update siteurl "https://${NGINX_HOST_DOMAIN}" --allow-root --path=/var/www/html
    wp option update home "https://${NGINX_HOST_DOMAIN}" --allow-root --path=/var/www/html

    echo "WordPress installation completed"
else
    echo "WordPress is already installed."
fi

chown -R www:www /var/www/html
chmod -R 775 /var/www/html

exec php-fpm82 -F -R

