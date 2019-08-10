FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update
RUN apt-get install -y curl zip unzip wget

# Install Nginx Webserver
RUN apt-get install -y nginx

#Install php7.2 including submodules
RUN apt-get install -y php7.3 \
    php7.3-cli \
    php7.3-dev \
    php7.3-fpm \
    php7.3-curl \
    php7.3-gd \
    php7.3-mysql \
    php7.3-mbstring \
    php7.3-gettext \
    php7.3-zip \
    php7.3-xmlrpc \
    php7.3-xml \
    php7.3-intl \
    php7.3-bz2 \
    php7.3-json \
    php7.3-pspell \
    php7.3-tidy \
    php-pear \
    php7.3-redis \
    mcrypt \
    php7.3-soap \
    php7.3-dom

# Install Command Line JSON parser
RUN apt-get install -y jq

#Check php-version
RUN php -v

#Install other dependencies
RUN apt-get install -y supervisor
RUN apt-get install -y mysql-client
RUN apt-get install -y vim rsync git

#Install Composer and make it global
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

#Install Contao Managed Edition
RUN rm -rf /var/www/html/ && composer create-project contao/managed-edition /var/www/html/ '4.4.*'

# Link the console cmd
RUN mkdir /var/www/html/bin \
    && ln -s /var/www/html/vendor/bin/contao-console /var/www/html/bin/console \
    && chown -R www-data:www-data /var/www/html/bin/console

# Install Contao Manager
RUN curl -o /var/www/html/web/contao-manager.php -L https://download.contao.org/contao-manager.phar

# Install code-server, a portable version of vscode editor
RUN cd /var/www/html \
    && curl -s https://api.github.com/repos/cdr/code-server/releases/latest \
    | jq -r ".assets[] | select(.name | test(\"linux-x64.tar.gz\")) | .browser_download_url" \
    | wget -i- \
    && tar xfz code-server* \
    && mv code-server*/code-server /usr/bin/code-server \
    && find . -type d -name "code-server*" -exec rm -rf {} + \
    && find . -type f -name "*.tar.gz" -exec rm -rf {} +

# Supervisor
RUN mkdir -p /var/log/supervisor /run/php
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./nginx.conf /etc/nginx/sites-enabled/default

#Scripts
COPY ./scripts var/www/html/scripts

EXPOSE 80 8443 5000
WORKDIR /var/www/html
HEALTHCHECK CMD curl --fail http://localhost/ || exit 1

CMD ["/usr/bin/supervisord", "-n"]

# Fix permissions
RUN chmod -R 0777 /tmp && chown -R www-data:www-data /tmp
RUN chown -R www-data:www-data /var/www/html

# Copy gitignore template to remote
COPY .gitignore /var/www/html/.gitignore
