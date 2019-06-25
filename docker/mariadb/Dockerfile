FROM centos
MAINTAINER lejianwen <84855512@qq.com>
# 阿里云源
# RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
RUN yum -y install epel-release openssl openssl-devel git gcc gcc++ gcc-c++ bison libxml2-devel libevent-devel cmake ncurses-devel bison \
    && useradd mysql -s /sbin/nologin
VOLUME /data/mysql_data
RUN mkdir /data/src -p && cd /data/src \
    && curl -L http://mirrors.neusoft.edu.cn/mariadb//mariadb-10.3.16/source/mariadb-10.3.16.tar.gz -o mariadb.tar.gz \
    && mkdir mariadb && tar -zxf mariadb.tar.gz -C ./mariadb --strip-components 1 \
    && cd mariadb \
    && cmake \
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
       -DDEFAULT_COLLATION=utf8_general_ci && make -j4 && make install \
       && chown -R mysql.mysql /data/apps/mysql && cp /data/apps/mysql/support-files/mysql.server /usr/sbin/mysqld \
       && /data/apps/mysql/scripts/mysql_install_db --basedir=/data/apps/mysql --datadir=/data/mysql_data --user=mysql \
       && rm /data/src -rf
EXPOSE 3306
ENV MYSQL_ROOT_PASSWORD 123456
COPY mariadb_init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb_init.sh

CMD ["mariadb_init.sh"]