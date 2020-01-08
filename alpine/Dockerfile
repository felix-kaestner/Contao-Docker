ARG PHP_FPM_VERSION=7.4
FROM php:${PHP_FPM_VERSION}-fpm-alpine3.11
LABEL Maintainer="Felix Kästner <hello@felix-kaestner.com>" \
      Description="Lightweight Contao CMS container with Nginx & PHP-FPM 7.4 based on Alpine Linux."

ARG VERSION="4.8"
ARG DEMO_VERSION

# Install common packages
RUN apk --no-cache add \
    git \
    nginx \
    supervisor \
    rsync \
    sed \
    zip \
    unzip \
    zlib-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    icu-dev

# Install PHP Extensions
# Preinstalled dependencies from contao: dom, pcre, zlib, json
RUN apk add --no-cache --virtual .build-deps-php-ext \
		$PHPIZE_DEPS \
  && docker-php-ext-install -j$(nproc) intl gd pdo_mysql \
	&& pecl install xdebug \
	&& docker-php-ext-enable xdebug \
	&& apk del .build-deps-php-ext

# Configure xDebug
COPY xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Adjust php-fpm conf so that it does not daemonize
RUN sed -i "/;daemonize = yes/c\daemonize = no" /usr/local/etc/php-fpm.conf

# Disable php memory limit
RUN echo 'memory_limit=-1' > /usr/local/etc/php/conf.d/memory-limit.ini;

#Check php-modules
RUN php -m

#Check php-version
RUN php -v

#Install Composer and make it global
RUN curl -fsSL https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer 

#Install Contao Managed Edition
RUN su -p -l www-data -s /bin/ash -c "composer create-project contao/managed-edition /var/www/html/ ${VERSION} "

# Link the console cmd
RUN su -p -l www-data -s /bin/ash -c \
 "mkdir /var/www/html/bin && ln -s /var/www/html/vendor/bin/contao-console /var/www/html/bin/console"

# Add bin directories to PATH
RUN echo "export PATH='$PATH:/var/www/html/bin:/var/www/html/vendor/bin'" >> /etc/profile

# Install Contao Manager
RUN curl -fsSL --output /var/www/html/web/contao-manager.php -L https://download.contao.org/contao-manager.phar 

# Install Demo
RUN if [ -n "${DEMO_VERSION}" ] ; \
 then su -p -l www-data -s /bin/ash -c "composer require --working-dir /var/www/html contao/official-demo:${DEMO_VERSION}" ; fi

# Install code-server, a portable version of vscode editor
RUN apk add --no-cache --virtual .build-deps-code-server \
    jq \
  && curl -fsSL $(curl -fsSL https://api.github.com/repos/cdr/code-server/releases/latest \
    | jq -r ".assets[] | select(.name | test(\"linux-x86_64.tar.gz\")) | .browser_download_url" ) \
    | tar -xvz \
	&& apk del .build-deps-code-server

RUN find . -type f -name "code-server" -exec mv {} /usr/bin \; 
RUN find . -type d -name "code-server*" -exec rm -rf {} + 

# Install Node.js
ENV NODE_VERSION 13.4.0

RUN apk add --no-cache \
        libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        curl \
    && ARCH= && alpineArch="$(apk --print-arch)" \
      && case "${alpineArch##*-}" in \
        x86_64) \
          ARCH='x64' \
          CHECKSUM="6c4fe31113f92e2c26664f31fbbb3b800b2f6c4548137b5c92988c68ee5328c3" \
          ;; \
        *) ;; \
      esac \
  && if [ -n "${CHECKSUM}" ]; then \
    set -eu; \
    curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz"; \
    echo "$CHECKSUM  node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" | sha256sum -c - \
      && tar -xJf "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
      && ln -s /usr/local/bin/node /usr/local/bin/nodejs; \
  else \
    echo "Building from source" \
    # backup build
    && apk add --no-cache --virtual .build-deps-full \
        binutils-gold \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        python \
    # gpg keys listed at https://github.com/nodejs/node#release-keys
    && for key in \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      FD3A5288F042B6850C66B31F09FE44734EB7990E \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      B9AE9905FFD7803F25714661B63B535A4C206CA9 \
      77984A986EBC2AA786BC0F66B01FBB92821C587A \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      4ED778F539E3634C779C87C6D7062848A1AB005C \
      A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
      B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    ; do \
      gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
      gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
      gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) V= \
    && make install \
    && apk del .build-deps-full \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt; \
  fi \
  && rm -f "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" \
  && apk del .build-deps

# Install Yarn
ENV YARN_VERSION 1.21.1

RUN apk add --no-cache --virtual .build-deps-yarn gnupg \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && apk del .build-deps-yarn

# Check Node, NPM and Yarn Versions
RUN node -v
RUN npm -v
RUN yarn -v

# Supervisor
COPY ./alpine/supervisord.conf /etc/supervisord.conf

# Nginx
COPY ./alpine/nginx.conf /etc/nginx/conf.d/default.conf 
RUN mkdir /run/nginx

# copy the entrypoint script for the image
COPY ./alpine/docker-entrypoint.sh /usr/local/bin/

# ensure the entrypoint is executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# set the entrypoint to our custom script
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
VOLUME ["/var/www/html"]
EXPOSE 80 5000 9000
HEALTHCHECK CMD curl --fail http://localhost/ || exit 1