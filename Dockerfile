FROM ubuntu:latest
LABEL maintainer="Felix Kästner <hello@felix-kaestner.com>"

ARG VERSION=4.4
ARG DEMO_VERSION

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

# Cleanup
RUN apt-get update && apt-get -y upgrade -y && apt-get -y autoremove

# Install common packages
RUN apt-get install -y software-properties-common curl zip unzip wget gnupg mysql-client vim rsync git

# Install Nginx Webserver
RUN apt-get install -y nginx

# Install PHP 7.3
RUN add-apt-repository ppa:ondrej/php
RUN apt-get install -y php7.3 php7.3-dom php7.3-gd php7.3-curl php7.3-intl php7.3-mbstring php7.3-mysql php7.3-xdebug php7.3-fpm php7.3-zip

#Check php-modules
RUN php -m

# Install supervisor
RUN apt-get install -y supervisor

# Configure xDebug
COPY xdebug.ini /etc/php/7.3/mods-available/xdebug.ini

# Install Command Line JSON parser
RUN apt-get install -y jq

#Check php-version
RUN php -v

#Install Composer and make it global
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

#Install Contao Managed Edition
RUN ls -la /var/www/html
RUN rm -rf /var/www/html/*
RUN chown www-data:www-data /var/www/html
RUN su - www-data -s /bin/bash -c  "composer create-project contao/managed-edition /var/www/html/ '${VERSION}'"

# Link the console cmd
RUN mkdir /var/www/html/bin \
   && ln -s /var/www/html/vendor/bin/contao-console /var/www/html/bin/console \
   && chown -R www-data:www-data /var/www/html/bin/console

# Install Contao Manager
RUN curl -o /var/www/html/web/contao-manager.php -L https://download.contao.org/contao-manager.phar

# Install Demo
RUN if [ -n "${DEMO_VERSION}" ] ; then su - www-data -s /bin/bash -c  "composer require --working-dir /var/www/html contao/official-demo:${DEMO_VERSION}" ; fi

# Install code-server, a portable version of vscode editor
RUN cd /var/www/html \
    && curl -s https://api.github.com/repos/cdr/code-server/releases/latest \
    | jq -r ".assets[] | select(.name | test(\"linux-x86_64.tar.gz\")) | .browser_download_url" \
    | wget -i-

RUN tar xfz code-server*
RUN mv code-server*/code-server /usr/bin/code-server
RUN find . -type d -name "code-server*" -exec rm -rf {} + 
RUN find . -type f -name "*.tar.gz" -exec rm -rf {} +

RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get -y install nodejs
RUN npm i -g yarn
RUN node -v
RUN npm -v
RUN yarn -v

# Supervisor
RUN mkdir -p /var/log/supervisor /run/php
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./nginx.conf /etc/nginx/sites-enabled/default

EXPOSE 80 5000 9000
WORKDIR /var/www/html
HEALTHCHECK CMD curl --fail http://localhost/ || exit 1

CMD ["/usr/bin/supervisord", "-n"]
VOLUME ["/var/www/html"]

# Fix permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 0777 /tmp && chown -R www-data:www-data /tmp
RUN chmod -R 0777 /var/lib/php/sessions && chown -R www-data:www-data /var/lib/php/sessions

# Copy gitignore template to remote
COPY .gitignore /var/www/html/.gitignore