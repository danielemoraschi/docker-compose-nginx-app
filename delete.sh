#!/bin/bash

source app.cfg

#sudo rm -Rf ${APP_ROOT}/*

sudo docker kill ${APP_NAME}-app
sudo docker kill ${APP_NAME}-php
sudo docker kill ${APP_NAME}-nginx

sudo docker rm ${APP_NAME}-app
sudo docker rm ${APP_NAME}-php
sudo docker rm ${APP_NAME}-nginx