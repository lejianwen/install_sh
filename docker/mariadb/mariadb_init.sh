#!/bin/sh
# mariadb 经过Dockerfile建立后运行的脚本
# 主要是因为第一次启动容器可能/data/mysql_data中没有数据，就是mariadb没有初始化，需要先install
# 或者不使用该sh，将命令写在mariadb-compose.yml中

if [ ! -d /data/mysql_data/mysql ]
then
  /data/apps/mysql/scripts/mysql_install_db --basedir=/data/apps/mysql --datadir=/data/mysql_data --user=mysql
  mysqld start
  # 添加用户
  /data/apps/mysql/bin/mysql -e  "grant all on *.* to root@'%' identified by '123456'; flush privileges";
  mysqld stop
fi
/data/apps/mysql/bin/mysqld_safe --datadir=/data/mysql_data