#!/bin/sh
mkdir -p /data/etc
mkdir -p /data/htdocs
mkdir -p /data/logs
mkdir -p /data/docker

cp -a ./data/etc/* /data/etc/
cp -a ./docker/mini-nmpr-compose.yml /data/docker/docker-compose.yml
cp -a ./docker/.env.example /data/docker/.env

cd /data/docker && docker-compose up -d