#!/bin/bash


# Start the MariaDB service
service mariadb start;

while ! mysqladmin ping --silent; do
    echo "Waiting for MariaDB to start..."
    sleep 4
done
# Using the provided environment variables
echo "Creating database ${DB_NAME}..."
MYSQL_ROOT_PWD=${DB_ROOT_PASSWORD}  
MYSQL_DATABASE=${DB_NAME}      
MYSQL_USER=${DB_USER}          
MYSQL_USER_PWD=${DB_PASSWORD}  

echo "Creating user ${MYSQL_USER}..."
mysql -u root -p${MYSQL_ROOT_PWD} <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'localhost' IDENTIFIED BY '${MYSQL_USER_PWD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'localhost';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PWD}';
FLUSH PRIVILEGES;
EOF

echo "User done "

# Shutdown MariaDB service
echo "Shutting down MariaDB..."
mysqladmin -u root -p${MYSQL_ROOT_PWD} shutdown

# Start MariaDB in safe mode
echo "Starting MariaDB in safe mode..."
exec mysqld_safe
