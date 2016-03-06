APP_NAME=test
APP_ROOT=/www/docker-nginx-app
APP_WEB=8080

sudo docker ps -a | awk '{print $1}' | sudo xargs docker kill
sudo docker rm $(sudo docker ps -a -q)

docker run -tid --name ${APP_NAME}-app \
    -v ${APP_ROOT}:/data -d dmoraschi/app-volume

docker run --name ${APP_NAME}-php1 \
    --volumes-from ${APP_NAME}-app -d dmoraschi/centos-php

docker run --name ${APP_NAME}-php2 \
    --volumes-from ${APP_NAME}-app -d dmoraschi/centos-php

docker run --name ${APP_NAME}-php3 \
    --volumes-from ${APP_NAME}-app -d dmoraschi/centos-php

docker run --name ${APP_NAME}-nginx \
    --volumes-from ${APP_NAME}-app -p ${APP_WEB}:80 \
    -v ${APP_ROOT}/nginx/:/etc/nginx/conf.d/:ro \
    --link ${APP_NAME}-php1:fpm1 \
    --link ${APP_NAME}-php2:fpm2 \
    --link ${APP_NAME}-php3:fpm3 \
    dmoraschi/centos-nginx
