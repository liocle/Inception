#!/bin/sh

# mariadb_install_db (mysql_install_db is a symlink to mariadb version) initializes MariaDB data directory
# Being run as root, it requires --user=mysql so that it can be further run by user mysql
if [ ! -d /var/lib/mysql ]; then
	echo "Initializing MariaDB data directory..."
	mysql_install_db --datadir=/var/lib/mysql --user=mysql
	echo "Database initialized."
fi

# Set folders and permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql
mkdir -p /var/log/mysql
chown -R mysql:mysql /var/log/mysql

# Configure MySQL
mysqld --user=mysql --bootstrap << EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%';
SET PASSWORD FOR '${MYSQL_USER}'@'%' = PASSWORD('${MYSQL_PASSWORD}');
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

exec mysqld_safe
