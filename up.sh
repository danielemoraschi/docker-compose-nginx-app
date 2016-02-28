APP_NAME=test
APP_ROOT=/www/docker-nginx-app
APP_WEB=8080

sudo docker ps -a | awk '{print $1}' | sudo xargs docker kill
sudo docker rm $(sudo docker ps -a -q)
exit 0
docker run -tid --name ${APP_NAME}-app \
    -v ${APP_ROOT}:/data dmoraschi/app-volume

docker run --name ${APP_NAME}-php \
    --volumes-from ${APP_NAME}-app -d dmoraschi/centos-php

docker run --name ${APP_NAME}-nginx \
    --volumes-from ${APP_NAME}-app -p ${APP_WEB}:80 \
    --link ${APP_NAME}-php:fpm -d dmoraschi/centos-nginx
