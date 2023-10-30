# use debian as the base image change, penultimate veersion is bullseye
FROM debian:bullseye

# install NGINX and other dependencies
RUN apt-get update -y && \
apt-get install -y nginx vim curl && \
mkdir -p /etc/nginx/ssl && \
apt-get install -y openssl && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*


# 1)create a directory to store certificates and keys 2)generate the keys
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=motero.42.fr/UID=motero"

# copy the provided config file to the container
RUN mkdir -p /var/run/nginx
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
