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
    && deluser www-data \
    && if getent group www-data ; then groupdel www-data; fi \
    && addgroup -g ${GROUP_ID} -S www-data \
	  && adduser -u ${USER_ID} -D -S -G www-data www-data \
    && chown -RhPf ${USER_ID}:${GROUP_ID} /var/www/html /home/www-data
fi

exec "$@"