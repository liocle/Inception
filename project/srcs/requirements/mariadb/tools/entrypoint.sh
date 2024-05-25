#!/bin/sh


# mariadb_install_db (mysql_install_db is a symlink to mariadb version) initializes MariaDB data directory
# Being run as root, it requires --user=mysql so that it can be further run by user mysql
if [ ! -d /var/lib/mysql ]; then
	echo "Initializing MariaDB data directory..."
/usr/bin/mariadb_install_db --datadir=/var/lib/mysql --user=mysql
	echo "Dabase initialized."
fi

# Set folders and permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql
mkdir -p /var/log/mysql
chown -R mysql:mysql /var/log/mysql

# Configure MySQL
mysqld --user=mysql --bootstrap << EOF
CREATE DATABASE IF NOT EXISTS ${DATABASE};
CREATE USER IF NOT EXISTS '${USER}'@'%';
SET PASSWORD FOR '${USER}'@'%' = PASSWORD('${PASSWORD}');
GRANT ALL PRIVILEGES ON ${DATABASE}.* TO '${USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

EXPOSE 3306

exec mariadb
