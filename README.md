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

create a file called `.env` in your project folder with the following content:

```dotenv
PROJECT=project

MYSQL_DATABASE=d0123abc
MYSQL_USER=d0123abc
MYSQL_PASSWORD=GeHeIm
MYSQL_ROOT_PASSWORD=SuPaGeHeIm
```

Afterwards, you can export all of these environment variables so they are available for shell commands

```bash
export $(cat .env | xargs)
```

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
-      docker exec -i -t contao bash
-   www-data
-      docker exec -it --user www-data contao bash  


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

Commands
---
To get the database BackUp, when you are operating from the shell within your contao container, execute
```bash
mysqldump -h mysql_${PROJECT} -u root -p${MYSQL_ROOT_PASSWORD}  ${MYSQL_DATABASE} > db.sql
```
This will get you the database backup in the root directory of your contao installation inside the docker container.

To restore the database from a file inside the contao container, when you are operating from the shell within your contao container, execute:

```bash
mysql -h mysql_${PROJECT} -u root -p${MYSQL_ROOT_PASSWORD}  ${MYSQL_DATABASE} < db.sql
```

Again refer to the commands mentioned above to switch to the [shell](#Console) inside you docker container.

If you wish, you can also copy all your settings, i.e your settings.json or the .vscode directory
and database files from a local folder into docker container. Simply refer to the commad:
```bash
docker cp ${path_on_your_local_machine} contao_${PROJECT}:${path_inside_docker_container}
``` 
to copy files or whole directories to the docker container. Simply switch around the last two arguments to copy in the opposite direction.

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
