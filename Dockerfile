FROM ubuntu:18.04
LABEL maintainer="cryptokasm.io"

# Install packages
RUN apt update
RUN apt install apache2 -y
RUN apt install apache2-utils -y
RUN apt clean

# Open Port 80 for webserver
EXPOSE 80

# Start service
CMD ["apache2ctl", "-D", "FOREGROUND"]

# Copy root directory to image
COPY ./dist/ /var/www/html/