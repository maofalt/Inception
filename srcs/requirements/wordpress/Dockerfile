# use debian as the base image change, penultimate veersion is bullseye
FROM debian:bullseye

# Create the directory for the php-fpm socket and enable php start
RUN mkdir -p /var/www/html/ && \
    mkdir -p /run/php && \
    chmod -R 755 /var/www/html/

# Update & Install necessary packages
RUN apt-get update && apt-get install -y \
    php \
    php-cgi \
    php-fpm \
    php-common \
    php-cgi \
    php-mysql \
    php-gd \
    php-xml \
    php-mbstring \
    wget \
    unzip \
    default-mysql-server \
    mariadb-client


# Download and extract WordPress
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xvzf latest.tar.gz && \
    mv wordpress/* /var/www/html/ && \
    rmdir wordpress && \
    rm latest.tar.gz

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy the php-fpm configuration file in the html directory
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# ensure that the web server(nginx) has the necessary permissions 
# to read and execute the files within the web root directory
RUN chown -R www-data:www-data /var/www/* \
    && chmod -R 755 /var/www/*

# Copy additional configurations
COPY ./tools/wpscript.sh  /usr/local/bin/
RUN chmod +x /usr/local/bin/wpscript.sh

# Set the working directory
#WORKDIR /var/www/html/

# Expose port for php-fpm
EXPOSE 9000

# Set the appropriate command to run php-fpm
#RUN php-fpm
CMD ["bash", "/usr/local/bin/wpscript.sh"]
