#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}/.." )" >/dev/null 2>&1 && pwd )"
SYNC = rsync -rv -e ssh

set -o allexport
[[ -f $(DIR)/.env ]] && source $(DIR)/.env 
set +o allexport

read -p "Creating database dumb from remote server"
# Backup
ssh ${SSH_USER}@${SSH_HOST} "mysqldump -h localhost -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}" > $(DIR)/backup.sql \
    && echo "Created Database Dumb from Remote Server"

echo "Copying files from remote"
read -p "Press enter to continue"

$(SYNC) ${SSH_USER}@${SSH_HOST}:${SSH_DEPLOY_PATH}/composer.json $(DIR)/composer.json
$(SYNC) ${SSH_USER}@${SSH_HOST}:${SSH_DEPLOY_PATH}/composer.lock $(DIR)/composer.lock
$(SYNC) ${SSH_USER}@${SSH_HOST}:${SSH_DEPLOY_PATH}/app/ $(DIR)/app/
$(SYNC) ${SSH_USER}@${SSH_HOST}:${SSH_DEPLOY_PATH}/system/ $(DIR)/system/
$(SYNC) ${SSH_USER}@${SSH_HOST}:${SSH_DEPLOY_PATH}/files/ $(DIR)/files/
$(SYNC) ${SSH_USER}@${SSH_HOST}:${SSH_DEPLOY_PATH}/src/ $(DIR)/src/
$(SYNC) ${SSH_USER}@${SSH_HOST}:${SSH_DEPLOY_PATH}/templates/ $(DIR)/templates/

echo "Restore database on localhost"
read -p "Press enter to continue"
mysql -h mysql_${PROJECT} -u root -p${MYSQL_ROOT_PASSWORD}  ${MYSQL_DATABASE} < $(DIR)/backup.sql

# Execute composer install
cd $(DIR); composer install --no-interaction

# Clear cache
cd $(DIR); php vendor/bin/contao-console cache:clear

#Create Symlinks
cd $(DIR); php vendor/bin/contao-console contao:symlinks




