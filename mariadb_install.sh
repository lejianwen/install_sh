#!/bin/sh
# mariadb 安装脚本

yum -y install epel-release
yum -y install openssl openssl-devel git gcc gcc-c++ bison libxml2-devel libevent-devel rpm-build cmake ncurses-devel bison bison-devel
groupadd mysql
useradd -g mysql mysql -s /sbin/nologin

function mkDir #dir
{
	if [ ! -d $1 ]
		then
		mkdir $1 -p
	fi
}

cd /
mkDir 'data'
cd /data
mkDir 'apps'
mkDir 'src'
mkDir 'mysql'
mkDir '/data/logs/mysql'

cd /data/src
# download mariadb
if [ ! -f mariadb.tar.gz ]
then
  curl -L http://mirrors.neusoft.edu.cn/mariadb//mariadb-10.3.16/source/mariadb-10.3.16.tar.gz -o mariadb.tar.gz
fi
mkDir mariadb
tar -zxf mariadb.tar.gz -C ./mariadb --strip-components 1
cd mariadb
cmake \
-DCMAKE_INSTALL_PREFIX=/data/apps/mysql \
-DMYSQL_DATADIR=/data/mysql_data \
-DSYSCONFDIR=/etc/mysql \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DWITH_SSL=system \
-DWITH_ZLIB=system \
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
-DMYSQL_TCP_PORT=3306 \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DENABLE_PROFILING=0 \
-DMYSQL_USER=mysql \
-DDEFAULT_COLLATION=utf8_general_ci

make -j2
make install

chown -R mysql.mysql /data/apps/mysql
cp /data/apps/mysql/support-files/mysql.server /usr/sbin/mysqld
/data/apps/mysql/scripts/mysql_install_db --basedir=/data/apps/mysql --datadir=/data/mysql_data --user=mysql
mysqld start
# 添加用户
# /data/apps/mysql/bin/mysql -e  "grant all on *.* to root@'%' identified by '123456'; flush privileges";