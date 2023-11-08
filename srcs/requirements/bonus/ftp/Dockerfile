# Use the hardened version of stilliard/pure-ftpd as a base image
FROM  fauria/vsftpd

#add vsfpd conf file
#COPY ./conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

# Set default environment variables
ENV FTP_USER=${FTP_USER}
ENV FTP_PASS=${FTP_PASS}
ENV PASV_ADDRESS=${PUBLICHOST}
ENV PASV_MIN_PORT=21000
ENV PASV_MAX_PORT=21010

EXPOSE 21 21000-21010


#CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]