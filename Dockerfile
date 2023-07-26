FROM debian:buster

MAINTAINER Christopher <christopher@chris-latza.de>

RUN apt-get update && apt-get install -y --fix-missing nano apache2 php php-cli php-curl php-ldap php-mysql php-imap php-xml php-xml php-mbstring php-intl php-apcu php-gd php-sqlite3 php-xmlrpc php-imagick wget curl ffmpeg unzip git php-mongodb php-redis && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite
RUN a2enmod remoteip
RUN a2enmod expires
RUN a2enmod http2

RUN rm -r -f /var/www/html/*
RUN chown -R www-data:www-data /var/www/html
  
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && php composer-setup.php --install-dir=/usr/local/bin --filename=composer

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /tmp
ENV APACHE_RUN_DIR .
ENV APACHE_PID_FILE /tmp/apache.pid

COPY 999-main.conf /etc/apache2/conf-enabled/999-main.conf
COPY 99-upload.ini /etc/php/7.3/apache2/conf.d/99-upload.ini
  
EXPOSE 80

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]