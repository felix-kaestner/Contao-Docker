#!/bin/bash

# Backup
docker exec mysql_${PROJECT}  \
    /usr/bin/mysqldump \
    -u${MYSQL_USER} \
    -p${MYSQL_PASSWORD} \
    ${MYSQL_DATABASE} > ./db.sql \
    && echo "Created Database Dumb from Local Docker Container"
