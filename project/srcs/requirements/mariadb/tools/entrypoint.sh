 ##   #!/bin/sh
 ##   
 ##   log_info() {
 ##     echo "$@" >> /proc/1/fd/1
 ##   }
 ##   
 ##   log_error() {
 ##     echo "ERROR: $@" >> /proc/1/fd/2
 ##   }
 ##   
 ##   # mariadb_install_db (mysql_install_db is a symlink to mariadb version) initializes MariaDB data directory
 ##   # Being run as root, it requires --user=mysql so that it can be further run by user mysql
 ##   if [ ! -d /var/lib/mysql ]; then
 ##   	echo "Initializing MariaDB data directory..."
 ##   	mysql_install_db --datadir=/var/lib/mysql --user=mysql
##   	echo "MariaDB: Database initialized."
 ##   fi
 ##   
 ##    ## # Set folders and permissions
 ##    ## mkdir -p /run/mysqld
 ##    ## chown -R mysql:mysql /run/mysqld
 ##    ## chown -R mysql:mysql /var/lib/mysql
 ##    ## mkdir -p /var/log/mysql
 ##    ## touch /var/log/mysql/error.log
 ##    ## chown -R mysql:mysql /var/log/mysql
 ##    ## mkdir -p /data/mariadb
 ##    ## chown -R mysql:mysql /data/mariadb
 ##   # Set folders and permissions
 ##   
 ##   
 ##   
 ##   echo "MariaDB: Folders and permissions should be set"
 ##   
 ##   # Configure MySQL
 ##   mysqld --user=mysql --bootstrap << EOF
 ##   CREATE DATABASE IF NOT EXISTS ${DB_NAME};
 ##   CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%';
 ##   SET PASSWORD FOR '${MYSQL_USER}'@'%' = PASSWORD('${MYSQL_PASSWORD}');
 ##   GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${MYSQL_USER}'@'%';
 ##   ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
 ##   FLUSH PRIVILEGES;
 ##   EOF
 ##   
 ##   echo "MariaDB: MySQL configured with:"
 ##   
 ##   echo "\t* CREATE DATABASE IF NOT EXISTS ${DB_NAME};
 ##   \t* CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%';
 ##   \t* SET PASSWORD FOR '${MYSQL_USER}'@'%' = PASSWORD('${MYSQL_PASSWORD}');
 ##   \t* GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${MYSQL_USER}'@'%';
 ##   \t* ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
 ##   
 ##   log_info "Starting mariadb server"
 ##   # ln -sf /proc/1/fd/2 /var/log/mysql/error.log
 ##   # chown mysql:mysql /var/log/mysql/error.log
 ##   
 # #   exec mysqld_safe

 #!/bin/bash

# Create necessary directories and set permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql
mkdir -p /var/log/mysql
chown -R mysql:mysql /var/log/mysql

# Initialize MySQL data directory
mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null

# Configure MySQL
mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

DELETE FROM	mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';

CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED by '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'%';


# Flush privileges to apply changes
FLUSH PRIVILEGES;
EOF

# Start MariaDB server with custom configuration file
exec mariadbd
