#!/bin/bash

# Navigate to the correct directory
cd /var/www/html

# Wait for DB
while ! mysqladmin ping -h"$DB_HOST" --silent; do
    sleep 2
done

sleep 10
# Check if wp-config.php exists
if [ ! -f "wp-config.php" ]; then
    echo "Creating wp-config.php..."
    wp config create --allow-root --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost=mariadb:3306 --path='/var/www/html'
    chmod 644 /var/www/html/wp-config.php
    chown -R root:root /var/www/html
fi

# Check if WordPress is already installed
echo "Checking if WordPress is already installed..."
#if ! $(wp core is-installed --allow-root); then
    # Setting up WordPress
    echo "Installing WordPress..."
    wp core install --allow-root --url="$SITE_URL" --title="$SITE_TITLE" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_EMAIL" --path='/var/www/html'

    # Add another user
    echo "Adding another user..."
    wp user create $SECOND_USER_NAME $SECOND_USER_EMAIL  --allow-root   --role=author --user_pass=$SECOND_USER_PASS --path='/var/www/html'
#fi

# Start PHP-FPM
exec /usr/sbin/php-fpm7.4 -F;