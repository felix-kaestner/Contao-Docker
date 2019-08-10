#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}/.." )" >/dev/null 2>&1 && pwd )"

set -o allexport
[[ -f $(DIR)/.env ]] && source $(DIR)/.env 
set +o allexport

echo "Restore contao installation from git repository"
read -p "Press enter to continue"

# remove the folder in the original contao installation
cd $(DIR); rm -rf app files system templates composer.json composer.lock $(DIR)/backup.sql

# clone your remote git repository to get all the files
git clone git@gitlab.com:${GIT_USER}/${GIT_REPO}.git $(DIR)

# restore the bundled database
echo "Restore database on localhost"
read -p "Press enter to continue"
mysql -h mysql_${PROJECT} -u root -p${MYSQL_ROOT_PASSWORD}  ${MYSQL_DATABASE} < $(DIR)/backup.sql

# Execute composer install
cd $(DIR); composer install --no-interaction

# Clear cache
cd $(DIR); php vendor/bin/contao-console cache:clear

#Create Symlinks
cd $(DIR); php vendor/bin/contao-console contao:symlinks





