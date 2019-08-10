#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}/.." )" >/dev/null 2>&1 && pwd )"

set -o allexport
[[ -f $(DIR)/.env ]] && source $(DIR)/.env 
set +o allexport

# Restore
cat $(DIR)/backup.sql | ssh ${SSH_USER}@${SSH_HOST} \
    "mysql -h localhost -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}" \
    && echo "Restored Database on Remote Server"