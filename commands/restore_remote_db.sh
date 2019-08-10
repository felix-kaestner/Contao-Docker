#!/bin/bash

# Restore
cat ./db.sql | docker exec \
    -i  mysql_${PROJECT} \
    /usr/bin/mysql \
    -u${MYSQL_USER} \
    -p${MYSQL_PASSWORD} \
    ${MYSQL_DATABASE} \
    && echo "Restored Database in Local Docker Container"
