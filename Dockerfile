FROM centos:7
MAINTAINER Felix Kästner
ENV REFRESHED_AT="2018-03-27"
ENV TIMEZONE="Europe/Berlin" \
    RUN_ID="" \
    RUN_UID=""\
    XDEBUG="false" \
    PHP_VALUE="" \
    PHP_ADMIN_VALUE=""

# Set it to a fix version number if you want to run a specific version
ARG CONTAO_VERSION='4.4*'

RUN yum install epel-release -y \
  && yum -y install https://centos7.iuscommunity.org/ius-release.rpm \
  && yum upgrade -y \
  && yum install -y \
      git \
      less \
      vim \
      wget \
      net-tools \
      locales \
      sendmail \
      openssl \
      ca-certificates \
      bzip2 \
      httpd \
      php72u-bcmath \
      php72u-cli \
      php72u-fpm \
      php72u-fpm-httpd \
      php72u-gd \
      php72u-pecl-imagick \
      php72u-intl \
      php72u-json \
      php72u-mbstring \
      php72u-mcryp \
      php72u-mysqlnd \
      php72u-snmp \
      php72u-soap \
      php72u-xml \
      php72u-pecl-xdebug \
  && wget https://getcomposer.org/download/1.6.4/composer.phar -O /usr/bin/composer \
  && chmod +x /usr/bin/composer \
  && rm -rf /var/www/* \
  && chsh -s /bin/bash apache \
  && yum clean all

##Download and Install Contao Managed Edition##
RUN rm -rf /var/www/html/ && composer create-project contao/managed-edition /var/www/html/ $CONTAO_VERSION

# Link the console cmd
RUN mkdir /var/www/html/bin \
    && ln -s /var/www/html/vendor/bin/contao-console /var/www/html/bin/console \
    && chown -R www-data:www-data /var/www/html/bin/console

ADD rootfs /

# Install Contao Manager
RUN curl -o /var/www/html/web/contao-manager.php -L https://download.contao.org/contao-manager.phar

RUN chown apache /usr/share/httpd

EXPOSE 80
VOLUME ["/var/www"]
WORKDIR /var/www/html
HEALTHCHECK CMD curl -f http://localhost/ || exit 1

##fix permissions##
RUN chown -R apache /var/www
RUN chmod -R 0777 /tmp && chown -R www-data:www-data /tmp
RUN chown -R www-data:www-data /var/www/html/web

CMD ["/init"]

