#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}/.." )" >/dev/null 2>&1 && pwd )"

set -o allexport
[[ -f $(DIR)/.env ]] && source $(DIR)/.env 
set +o allexport

# Backup
ssh ${SSH_USER}@${SSH_HOST} "mysqldump -h localhost -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}" > $(DIR)/backup.sql \
    && echo "Created Database Dump from Remote Server";