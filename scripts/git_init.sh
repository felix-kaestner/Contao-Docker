#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}/.." )" >/dev/null 2>&1 && pwd )"

set -o allexport
[[ -f $(DIR)/.env ]] && source $(DIR)/.env 
set +o allexport

([ -d $(DIR)/.git ] && echo 'Git repository detected') \
    || 	(echo 'No git repository found' \
	&& echo 'Initialising new git Repo' \
	&& git init $(DIR) \
	&& git config --global user.email '${GIT_USERNAME}' \
  	&& git config --global user.name '${GIT_USERMAIL}' \
	&& git status \
	&& git add . \
	&& git commit -m 'Initial Commit'  \
	&& git remote add origin git@gitlab.com:${GIT_USER}/${GIT_REPO}.git \
	&& git push -f --set-upstream git@gitlab.com:${GIT_USER}/${GIT_REPO}.git master \
	&& echo 'Git repository created')