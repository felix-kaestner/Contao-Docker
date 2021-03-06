#!/bin/sh

HOST_DOMAIN="host.docker.internal"
ping -q -c1 $HOST_DOMAIN > /dev/null 2>&1
if [ $? -ne 0 ]; then
  HOST_IP=$(ip route | awk 'NR==1 {print $3}')
  echo -e "$HOST_IP\t$HOST_DOMAIN" >> /etc/hosts
fi

if [ -n "$USER_ID" ] ; then
  USERID=$(id -u www-data)
  [[ $USERID != "$USER_ID" ]] \
    && usermod -u $USER_ID www-data \
    && chown --changes --silent --no-dereference --recursive --from=$USERID:$USERID ${USER_ID}:${GROUP_ID} \
        /var/www/html \
        /.composer \
        /var/run/php-fpm \
        /var/lib/php/sessions
fi

exec "$@"