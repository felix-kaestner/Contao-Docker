# Contao
Repository for Contao CMS Extension Development as Docker Container

# Contao Docker Container
- Based on CentOS 7
- Apache 2.4 (event)
- PHP 7.2
- Preinstalled Contao-Manager
- Preinstalled composer
- adjusted DocumentRoot for Contao 4
- Configured for Contao CMS
- Ability to change UID of Apache
- Init system based on S6
- Includes some useful tools and presets like git, curl, bashrc and vimrc
- Xdebug (disabled by default), Imagemagick, php-(bcmath,intl,json,mbstring,mcrypt,mysql,snmp,soap,xml)


# Quick Start
---

copy docker-compose.yml and .env.example to your project folder
rename .env.example to .env and edit parameter if needed
and run
```
docker-compose up -d
```

--or--

run the following commands from the shell
```
docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=mypass -e MYSQL_DATABASE=contao mysql
docker run -d --name contao -p 80:80 --link mysql:mysql fkasy/contao
docker run -d --name contao -p 8080:80 --link mysql:mysql phpmyadmin/phpmyadmin
```

Point your browser to `http://127.0.0.1/`

Point your browser to `http://127.0.0.1/contao-manager.phar.php` for Contao Manager

Point your browser to `http://127.0.0.1/contao/install` to complete Contao-Installation

Point your browser to `http://localhost:8080/` for phpmyadmin

Contao Installation
---

Once you're up and running, you'll arrive at the configuration wizard page. At the `Database connection` step, please enter the following:

- Host: `mysql`
- Login: `root` or  `project`
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
