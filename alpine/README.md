docker run --rm \
 -e USER_ID=$(id -u ${USER}) \
 -e GROUP_ID=$(id -g ${USER}) \
 -p 80:80 \
 fkasy/contao:4.8-demo-alpine
