# Use a base image that has a simple http server, such as httpd
FROM httpd:2.4-alpine

# Copy the static content into the Nginx image
COPY ./conf/site /usr/local/apache2/htdocs/

#The default httpd image exposes port 80, so we do not need to explicitly expose it