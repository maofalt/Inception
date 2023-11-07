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

    # Setting up WordPress
    echo "Installing WordPress..."
    wp core install --allow-root --url="$SITE_URL" --title="$SITE_TITLE" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_EMAIL" --path='/var/www/html'

    # Add another user
    echo "Adding another user..."
    wp user create $SECOND_USER_NAME $SECOND_USER_EMAIL  --allow-root   --role=author --user_pass=$SECOND_USER_PASS --path='/var/www/html'

#CODE INTEGRATION FROM HERE --------------------------------------------------------------------------------
# Wait for the database to be fully ready
echo "Waiting for database to be fully ready..."
MAX_TRIES=10
TRIES=0
while ! wp db check --allow-root --path='/var/www/html' > /dev/null 2>&1; do
    sleep 5
    TRIES=$((TRIES+1))
    if [ "$TRIES" -ge "$MAX_TRIES" ]; then
        echo "Database did not become ready in time."
        exit 1
    fi
done

echo "Checking if a static front page is set..."
HOMEPAGE_ID=$(wp option get page_on_front --allow-root --path='/var/www/html')

if [ "$HOMEPAGE_ID" -eq 0 ]; then
    echo "No static front page set. Creating a new homepage..."

    # Create a new homepage
    HOMEPAGE_ID=$(wp post create --post_type=page --post_title='Home' --post_content='Welcome to my website!' --post_status=publish --allow-root --path='/var/www/html' --porcelain)
    echo "New homepage created with ID: $HOMEPAGE_ID"

    # Set the newly created page as the front page
    wp option update show_on_front 'page' --allow-root --path='/var/www/html'
    wp option update page_on_front "$HOMEPAGE_ID" --allow-root --path='/var/www/html'
else
    echo "Static front page already set with ID: $HOMEPAGE_ID"
fi

# Replace the placeholder with the iframe
echo "Adding iframe and button to the homepage content..."
IFRAME_CODE='<iframe src="https://motero.42.fr/doom" width="600" height="400"></iframe>'
BUTTON_CODE='<button onclick="window.location.href='\'https://motero.42.fr/?page_id=0\''">Go to ID 0</button>'
BUTTON_CODE_STATIC='<button onclick="window.location.href='\''https://motero.42.fr/static/'\''">Visit Static Site</button>'

NEW_CONTENT="Welcome to my website! $IFRAME_CODE $BUTTON_CODE $BUTTON_CODE_STATIC"

wp post update $HOMEPAGE_ID --post_content="$NEW_CONTENT" --post_status=publish --allow-root --path='/var/www/html'


#CODE INTEGRATION UNTIL HERE --------------------------------------------------------------------------------

# Start PHP-FPM
exec /usr/sbin/php-fpm7.4 -F;