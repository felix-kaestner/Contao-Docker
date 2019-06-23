# Contao
Repository for Contao CMS Extension Development as Docker Container

[![Build Status](https://travis-ci.org/FKasy/Contao-Docker.svg?branch=master)](https://travis-ci.org/FKasy/Contao-Docker)

# Contao Docker Container
- Based on Ubuntu 18.04 Bionic Beaver
- Nginx Webserver
- PHP 7.3
- Preinstalled Contao 4.4 LTS Managed Edition
- Preinstalled Contao-Manager
- Preinstalled composer
- adjusted DocumentRoot for Contao 4
- Configured for Contao CMS
- Includes some useful tools and presets like git, curl, vim and rsync
- Preinstalled Visual Studio Code Editor inside the docker container, ready to use


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
-   root
-      docker exec -i -t contao /bin/bash
-   www-data
-      docker exec -it --user www-data contao /bin/bash  


Visual Studio Code Editor
---
Point your browser to `http://127.0.0.1:5000` to use the Visual Studio Code Editor.
It is preinstalled and executed upon server start. This great feature is achieved through
[Code-Server](https://github.com/cdr/code-server). Please head to their site to support the
project. This enables use to have a complete development environment inside the docker container
which is easy to scale and adjusts to individual needs.

If you already use Visual Studio Code on your local machine and which to get all your installed
extensions also to this docker instace, simply execute:
- Linux and MacOS:
```bash
code --list-extensions | xargs -L 1 echo code --install-extension
```
- Windows (PowerShell, e. g. using VSCode's integrated Terminal):
```bash
code --list-extensions | % { "code --install-extension $_" }
```

- Copy the produced output from the command line.
- Open `http://127.0.0.1:5000` in your browser of choice.
- Click on the `terminal` tab and the select `new terminal`.
- Paste the commands and hit enter ! All your Extension are installed.

If you wish, you can also copy all your settings, i.e your settings.json or the .vscode directory
from a local folder into docker container. Simply refer to the commad:

```bash
docker cp ${path_to_your_local_machine} contao_${PROJECT}:${path_inside_docker_container}
```

Extension Development
---

**Customize (Optional)**

Bundle Development is taking place inside of ./src/ _VENDOR_ / _BUNDLENAME_ . 

This repository provides an example  as fkasy/base-bundle.

To develop your own bundle simply change the vendor and bundle name 
according to the official [Symfony naming-conventions](https://symfony.com/doc/current/contributing/code/standards.html#naming-conventions) in the following way.

First adjust the following files:

 * `.php_cs.php`
 * `composer.json`
 * `phpunit.xml.dist`
 * `README.md`

Then rename the following files and/or the references to `BaseBundle` in
the following files:

 * `src/ContaoManager/Plugin.php`
 * `src/DependencyInjection/FKasyBaseExtension.php`
 * `src/FKasyBaseBundle.php`
 * `tests/FKasyBaseBundleTest.php`

Finally add your custom classes and resources.

---

**Install**

Develop your bundle in local directory.
-      docker exec --user www-data contao bash -c "composer config repositories.BUNDLENAME path ./src/VENDOR/BUNDLENAME"
-      docker exec --user www-data contao bash -c "composer require VENDOR/BUNDLENAME:dev-master"


In case of the example bundle provided which is called fkasy/base-bundle this will be
-      docker exec --user www-data contao bash -c "composer config repositories.base-bundle path ./src/fkasy/base-bundle"
-      docker exec --user www-data contao bash -c "composer require fkasy/base-bundle:dev-master"

License
---

- [MIT](https://github.com/FKasy/Contao/blob/master/LICENSE)

Special Thanks
--------------
- [Coder Technologies Inc.](https://github.com/cdr/code-server)
- [pdir](https://github.com/pdir/contao-docker)
- [psitrax](https://github.com/psi-4ward/docker-contao)
- [Medialta](https://github.com/medialta/docker-contao)
- [Comolo](https://github.com/comolo/contao-docker)
- [CTSMEDIA](https://github.com/ctsmedia/docker-contao)
