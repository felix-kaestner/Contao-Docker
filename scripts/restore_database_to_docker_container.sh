#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}/.." )" >/dev/null 2>&1 && pwd )"

set -o allexport
[[ -f $(DIR)/.env ]] && source $(DIR)/.env 
set +o allexport

echo "Restoring database dump to the docker container"
read -p "Press enter to continue"
# Restore
cat $(DIR)/backup.sql | /usr/bin/mysql \
    -h${MYSQL_HOST}
    -u${MYSQL_USER} \
    -p${MYSQL_PASSWORD} \
    ${MYSQL_DATABASE} \
    && echo "Restored Database in Local Docker Container"
