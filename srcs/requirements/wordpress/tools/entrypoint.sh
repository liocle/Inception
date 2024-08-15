#!/bin/bash
echo "Starting WordPress setup script."

echo "Waiting for MariaDB to start..."

# Check for MariaDB readiness
attempts=0
until mysql -h "$DB_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SHOW DATABASES;" > /dev/null 2>&1; do
    attempts=$((attempts + 1))
    if [ $attempts -ge 10 ]; then
        echo "Could not reach MariaDB"
        echo "MariaDB is unavailable - waiting..."
    fi
    sleep 5
done

echo "MariaDB is up - proceeding with WordPress setup."
#
# Set HTTP_HOST and other server variables for CLI commands to avoid PHP warnings
# export SERVER_NAME=$NGINX_HOST_DOMAIN
# export HTTP_HOST=$NGINX_HOST_DOMAIN
# export SERVER_PORT=443
# export SERVER_PROTOCOL=https

# Check if WordPress is already installed
if ! wp core is-installed --path=/var/www/html > /dev/null 2>&1; then
    echo "WordPress is not installed. Proceeding with installation."

    wp core download --allow-root --path=/var/www/html

    # Configure WordPress
    wp config create --allow-root \
        --dbhost="${DB_HOST}" \
        --dbname="${DB_NAME}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --path=/var/www/html

    #wp db create --path=/var/www/html

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

