FROM lejianwen/mariadb:1.1-10.3.16 as mariadb-builder
MAINTAINER lejianwen <84855512@qq.com>
WORKDIR /rootfs
RUN mv /data/apps/mysql/bin/* /tmp/ \
&& mv /tmp/mysqld /data/apps/mysql/bin/ \
&& mv /tmp/mysqld_safe /data/apps/mysql/bin/ \
&& mv /tmp/my_print_defaults  /data/apps/mysql/bin/ \
&& mv /tmp/mysqldump  /data/apps/mysql/bin/ \
&& mv /tmp/mysql  /data/apps/mysql/bin/ \
&& mv /tmp/mysqladmin  /data/apps/mysql/bin/ \
&& mv /tmp/resolveip  /data/apps/mysql/bin/ \
&& echo `strip /data/apps/mysql/bin/*  > /dev/null` \
&& echo `strip /data/apps/mysql/lib/*/* > /dev/null`
RUN  mkdir lib64 && cp -a /lib64/*.so* lib64/ && rm /data/apps/mysql/mysql-test -rf


FROM busybox
MAINTAINER lejianwen <84855512@qq.com>
RUN echo mysql:x:1001:1001:mysql:/:/bin/sh >> etc/passwd \
        && echo mysql:x:1001: >> etc/group \
        && mkdir /lib \
        && ln -s /lib /lib64 && mkdir /data/mysql_data -p

COPY --from=mariadb-builder /etc/nsswitch.conf /etc/
COPY --from=mariadb-builder /rootfs/* /lib64/
COPY --from=mariadb-builder /usr/sbin/mysqld  /usr/sbin/mysqld
#COPY --from=mariadb-builder /data/apps /data/apps
#RUN mkdir -p /data/apps/mysql/bin  /data/apps/mysql/lib /data/apps/mysql/include /data/apps/mysql/scripts/ /data/apps/mysql/share/
COPY --from=mariadb-builder /data/apps/mysql/bin /data/apps/mysql/bin
COPY --from=mariadb-builder /data/apps/mysql/lib /data/apps/mysql/lib
COPY --from=mariadb-builder /data/apps/mysql/include /data/apps/mysql/include
COPY --from=mariadb-builder /data/apps/mysql/scripts/mysql_install_db /data/apps/mysql/scripts/mysql_install_db
COPY --from=mariadb-builder /data/apps/mysql/share /data/apps/mysql/share
#COPY --from=mariadb-builder /data/apps/mysql/sql-bench /data/apps/mysql/sql-bench
#COPY --from=mariadb-builder /data/apps/mysql/support-files /data/apps/mysql/support-files

EXPOSE 3306
ENV MYSQL_ROOT_PASSWORD 123456
COPY mariadb_init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb_init.sh
CMD ["mariadb_init.sh"]