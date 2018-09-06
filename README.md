# Contao
Repository for Contao CMS Extension Development as Docker Container

# Contao Docker Container
- Based on Ubuntu 18.04 Bionic Beaver
- Nginx Webserver
- PHP 7.2
- Preinstalled Contao 4.4 LTS Managed Edition
- Preinstalled Contao-Manager
- Preinstalled composer
- adjusted DocumentRoot for Contao 4
- Configured for Contao CMS
- Includes some useful tools and presets like git, curl, vim and rsync


# Quick Start
---

copy docker-compose.yml to your project folder and run
```
docker-compose up -d
```

--or--

run the following commands from the shell
```
docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=contao mysql
docker run -d --name contao -p 80:80 --link mysql:mysql fkasy/contao
docker run -d --name contao -p 8080:80 --link mysql:mysql phpmyadmin/phpmyadmin
```

Point your browser to `http://127.0.0.1/`

Point your browser to `http://localhost:8080/` for phpmyadmin

Contao Installation
---

Point your browser to `http://127.0.0.1/contao/install` to complete Contao-Installation

Once you're up and running, you'll arrive at the configuration wizard page. At the `Database connection` step, please enter the following:

- Host: `mysql`
- Login: `root`
- Password: `password`
- Database Name: `contao`

Contao Manager
---
This setup also provides the Contao Manager. You can access it via calling http://127.0.0.1/contao-manager.php

Console
---

    docker exec -i -t contao /bin/bash

Extension Development
---

1. Develop your bundle in workspace
2.      docker exec --user www-data contao bash -c "composer config repositories.BUNDLENAME path ../workspace"
3.      docker exec --user www-data contao bash -c "composer require VENDOR/BUNDLENAME:*"
    OR
1. Add new volume to docker-composer.yml, maybe root
2.      - ./:/var/www/html/src:ro
3.      docker exec --user www-data contao bash -c "composer config repositories.BUNDLENAME path ../workspace"
4.      docker exec --user www-data contao bash -c "composer require VENDOR/BUNDLENAME:*"

License
---

MIT

Special Thanks
--------------
- pdir https://github.com/pdir/contao-docker
- psitrax https://github.com/psi-4ward/docker-contao
- Medialta https://github.com/medialta/docker-contao
- Comolo https://github.com/comolo/contao-docker
- CTSMEDIA https://github.com/ctsmedia/docker-contao
