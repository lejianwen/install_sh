#!/bin/sh
mkdir -p /data/etc
mkdir -p /data/htdocs
mkdir -p /data/logs

cp -a ./data/etc/* /data/etc/

cd ./docker

cp .env.example .env

docker-compose -f mini-nmpr-compose.yml up -d