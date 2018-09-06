FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
# Set it to a fix version number if you want to run a specific version
ARG CONTAO_VERSION=~4.4

RUN apt-get update
RUN apt-get install -y curl zip unzip

# Install Nginx Webserver
RUN apt-get install -y nginx
# check status of Nginx
RUN systemctl status nginx

#In order to install php7.2 add PPA repository
RUN add-apt-repository ppa:ondrej/php

#Install php7.2 including submodules
RUN apt install php7.2-cli \
                php7.2-dev \
                php7.2-fpm \
                php7.2-curl \
                php7.2-gd \
                php7.2-mysql \
                php7.2-mbstring \
                php-gettext \
                php7.2-zip \
                php7.2-xmlrpc \
                php7.2-xml \
                php7.2-intl \
                php7.2-bz2 \
                php7.2-json \
                php7.2-pspell \
                php7.2-tidy \
                php-pear \
                php-redis \
                mcrypt \
                php-soap \
                php-dom
RUN apt-get install -y php-fpm

#Check php-version
RUN php -v
RUN systemctl status php7.2-fpm

#Install other dependencies
RUN apt-get install -y supervisor
RUN apt-get install -y mysql-client
RUN apt-get install -y vim rsync git

#Install Composer and make it global
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

#Install Contao Managed Edition
RUN rm -rf /var/www/html/ && composer create-project contao/managed-edition:$CONTAO_VERSION /var/www/html/

# Link the console cmd
RUN mkdir /var/www/html/bin \
    && ln -s /var/www/html/vendor/bin/contao-console /var/www/html/bin/console \
    && chown -R www-data:www-data /var/www/html/bin/console

# Install Contao Manager
RUN curl -o /var/www/html/web/contao-manager.php -L https://download.contao.org/contao-manager.phar

# Supervisor
RUN mkdir -p /var/log/supervisor /run/php
COPY ./build/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./build/nginx.conf /etc/nginx/sites-enabled/default

EXPOSE 80
WORKDIR /var/www/html
HEALTHCHECK CMD curl --fail http://localhost/ || exit 1

CMD ["/usr/bin/supervisord", "-n"]

# Fix permissions
RUN chmod -R 0777 /tmp && chown -R www-data:www-data /tmp
RUN chown -R www-data:www-data /var/www/html