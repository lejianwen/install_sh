#!/bin/sh

# 备份数据库
if [ -z $1 ]
then
    echo "请输入要还原的数据库"
    exit 1
fi
docker-compose -f mini-nmpr-compose.yml exec mariadb /bin/sh -c "/data/apps/mysql/bin/mysql -e 'CREATE DATABASE IF NOT EXISTS $1 DEFAULT CHARSET utf8 COLLATE utf8_general_ci;'"
docker-compose -f mini-nmpr-compose.yml exec mariadb /bin/sh -c "gunzip < /data/mysql_dump/$1.sql.gz | /data/apps/mysql/bin/mysql -u root $1"