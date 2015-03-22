#!/bin/bash

source app.cfg

echo "Remove project directory? [y/n]"
read remove

if [ $remove = 'y' ]; then
    sudo rm -Rf ${APP_ROOT}/*
fi

sudo docker kill ${APP_NAME}-app
sudo docker kill ${APP_NAME}-php
sudo docker kill ${APP_NAME}-nginx

sudo docker rm ${APP_NAME}-app
sudo docker rm ${APP_NAME}-php
sudo docker rm ${APP_NAME}-nginx