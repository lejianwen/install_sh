#!/bin/sh

# 备份数据库
if [ -z $1 ]
then
    echo "请输入要备份的数据库"
    exit 1
fi

docker-compose -f mini-nmpr-compose.yml exec mariadb /bin/sh -c "/data/apps/mysql/bin/mysqldump -u root $1 | gzip > /data/mysql_dump/$1.sql.gz"