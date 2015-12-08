#!/bin/bash

source app.cfg


sudo docker pull dmoraschi/app-volume
sudo docker pull dmoraschi/centos-php
sudo docker pull dmoraschi/centos-phpcphalcon
sudo docker pull dmoraschi/centos-phpcomposer
sudo docker pull dmoraschi/centos-nginx


echo "Create composer project? [symfony|silex|laravel|kohana|n]:"
read create


docker run -tid --name ${APP_NAME}-app \
    -v ${APP_ROOT}/app:/data/app dmoraschi/app-volume


if [ $create = 'symfony' ]; then
    docker run --privileged=true --volumes-from ${APP_NAME}-app \
        --rm dmoraschi/centos-phpcomposer create-project symfony/framework-standard-edition .
fi

if [ $create = 'silex' ]; then
    docker run --privileged=true --volumes-from ${APP_NAME}-app \
        --rm dmoraschi/centos-phpcomposer create-project fabpot/silex-skeleton .
fi

if [ $create = 'laravel' ]; then
    docker run --privileged=true --volumes-from ${APP_NAME}-app \
        --rm dmoraschi/centos-phpcomposer create-project laravel/laravel .
fi

if [ $create = 'kohana' ]; then
    docker run --privileged=true --volumes-from ${APP_NAME}-app \
        --rm dmoraschi/centos-phpcomposer create-project despark/kohana .
fi

docker run --privileged=true --name ${APP_NAME}-php \
    --volumes-from ${APP_NAME}-app -d dmoraschi/centos-phpcphalcon

docker run --privileged=true --name ${APP_NAME}-nginx \
    --volumes-from ${APP_NAME}-app -p ${APP_WEB}:80 --link ${APP_NAME}-php:fpm -d dmoraschi/centos-nginx


sudo chmod 777 -R ${APP_ROOT}
