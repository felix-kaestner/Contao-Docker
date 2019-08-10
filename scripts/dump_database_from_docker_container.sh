#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}/.." )" >/dev/null 2>&1 && pwd )"

set -o allexport
[[ -f $(DIR)/.env ]] && source $(DIR)/.env 
set +o allexport

# Backup
/usr/bin/mysqldump \
    -h${MYSQL_HOST}
    -u${MYSQL_USER} \
    -p${MYSQL_PASSWORD} \
    ${MYSQL_DATABASE} > $(DIR)/backup.sql \
    && echo "Created Database Dumb from Local Docker Container"