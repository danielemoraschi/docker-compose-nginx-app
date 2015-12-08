#!/bin/bash

source app.cfg

echo "Remove project directory? [y/n]"
read remove

if [ $remove = 'y' ]; then
    sudo rm -Rf ${APP_ROOT}/*
fi

docker kill ${APP_NAME}-app
docker kill ${APP_NAME}-php
docker kill ${APP_NAME}-nginx

docker rm ${APP_NAME}-app
docker rm ${APP_NAME}-php
docker rm ${APP_NAME}-nginx
