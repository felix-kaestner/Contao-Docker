# Contao
Repository for Contao CMS Extension Development as Docker Container

# Quick Start
---

copy docker-compose.yml and .env.example to your project folder
rename .env.example to .env and edit parameter if needed
and run
```
docker-compose up -d
```

--or--

checkout the whole repository
and run
```
docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=mypass -e MYSQL_DATABASE=contao mysql
docker run -d --name contao -p 80:80 --link mysql:mysql medialta/docker-contao
```

Point your browser to `http://127.0.0.1`

Contao Installation
---

Once you're up and running, you'll arrive at the configuration wizard page. At the `Database connection` step, please enter the following:

- Host: `mysql`
- Login: `root`
- Password: `password`
- Database Name: `project`

Contao Demo
---

    docker exec --user www-data PROJECT_NAME_contao_1 bash -c "php scripts/install-demo.php"

* The install tool password for the demo is contaodocker

Contao Manager
---
This setup also provides the Contao Manager. You can access it via calling http://127.0.0.1/contao-manager.php

Console
---

    docker exec -i -t PROJECT_NAME_contao_1 /bin/bash

Deploy to ALLINKL
---

    docker exec --user www-data PROJECT_NAME_contao_1 bash -c "php scripts/deploy-allinkl.php"

Extension Development
---

1. Develop your bundle in workspace
2.      docker exec --user www-data PROJECT_NAME_contao_1 bash -c "composer config repositories.BUNDLENAME path ../workspace"
3.      docker exec --user www-data PROJECT_NAME_contao_1 bash -c "composer require VENDOR/BUNDLENAME:*"
    OR
1. Add new volume to docker-composer.yml, maybe root
2.      - ./:/var/www/html/src:ro
3.      docker exec --user www-data PROJECT_NAME_contao_1 bash -c "composer config repositories.BUNDLENAME path ../workspace"
4.      docker exec --user www-data PROJECT_NAME_contao_1 bash -c "composer require VENDOR/BUNDLENAME:*"

License
---

MIT

Special Thanks
--------------
- pdir https://github.com/pdir/contao-docker
- Medialta https://github.com/medialta/docker-contao
- Comolo https://github.com/comolo/contao-docker
- CTSMEDIA https://github.com/ctsmedia/docker-contao
