#!/bin/bash

source app.cfg


#sudo docker pull dmoraschi/data-app
#sudo docker pull dmoraschi/centos-php
#sudo docker pull dmoraschi/centos-phpcomposer
#sudo docker pull dmoraschi/centos-nginx


cd /home/dmoraschi/Sites/docker/nginx
sudo docker build -t dmoraschi/centos-nginx .

cd /home/dmoraschi/Sites/docker/data
sudo docker build -t dmoraschi/data-app .

cd /home/dmoraschi/Sites/docker/php
sudo docker build -t dmoraschi/centos-php .

cd /home/dmoraschi/Sites/docker/php-composer
sudo docker build -t dmoraschi/centos-phpcomposer .



echo "Create Symfony project? [symfony|silex|laravel|kohana|n]:"
read create


sudo docker run -tid --name ${APP_NAME}-app \
    -v ${APP_ROOT}/app:/data/app -v ${APP_ROOT}/log:/data/log dmoraschi/data-app


if [ $create = 'symfony' ]; then
    sudo docker run --privileged=true --volumes-from ${APP_NAME}-app \
        --rm dmoraschi/centos-phpcomposer create-project symfony/framework-standard-edition ${APP_NAME}
fi

if [ $create = 'silex' ]; then
    sudo docker run --privileged=true --volumes-from ${APP_NAME}-app \
        --rm dmoraschi/centos-phpcomposer create-project fabpot/silex-skeleton ${APP_NAME}
fi

if [ $create = 'laravel' ]; then
    sudo docker run --privileged=true --volumes-from ${APP_NAME}-app \
        --rm dmoraschi/centos-phpcomposer create-project laravel/laravel ${APP_NAME}
fi

if [ $create = 'kohana' ]; then
    sudo docker run --privileged=true --volumes-from ${APP_NAME}-app \
        --rm dmoraschi/centos-phpcomposer create-project despark/kohana ${APP_NAME}
fi

sudo docker run --privileged=true --name ${APP_NAME}-php \
    --volumes-from ${APP_NAME}-app -d dmoraschi/centos-php

sudo docker run --privileged=true --name ${APP_NAME}-nginx \
    --volumes-from ${APP_NAME}-app -p ${APP_WEB}:80 --link ${APP_NAME}-php:fpm -d dmoraschi/centos-nginx

sudo chmod 777 -R ${APP_ROOT}