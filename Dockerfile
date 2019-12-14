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

# Install PHP 7.4
RUN add-apt-repository ppa:ondrej/php
RUN apt-get install -y php7.4 php7.4-dom php7.4-gd php7.4-curl php7.4-intl php7.4-mbstring php7.4-mysql php7.4-xdebug php7.4-fpm php7.4-zip

#Check php-modules
RUN php -m

# Adjust php-fpm conf so that it does not daemonize
RUN sed -i "/;daemonize = yes/c\daemonize = no" /etc/php/7.4/fpm/php-fpm.conf

# Install supervisor
RUN apt-get install -y supervisor

# Configure xDebug
COPY xdebug.ini /etc/php/7.4/mods-available/xdebug.ini

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
    && curl -sL $(curl -sL https://api.github.com/repos/cdr/code-server/releases/latest \
    | jq -r ".assets[] | select(.name | test(\"linux-x86_64.tar.gz\")) | .browser_download_url" ) \
    | tar -xvz

RUN find . -type f -name "code-server" -exec mv -t /usr/bin {} + 
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

# copy the entrypoint script for the image
COPY docker-entrypoint.sh /usr/local/bin/

# ensure the entrypoint is executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# set the entrypoint to our custom script
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
VOLUME ["/var/www/html"]

# Fix permissions
RUN chmod -R 0777 /tmp /var/lib/php/sessions  
RUN chown -R www-data:www-data /var/www/html /var/lib/php/sessions /tmp

# Copy gitignore template to remote
COPY .gitignore /var/www/html/.gitignore