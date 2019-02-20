FROM lejianwen/mariadb:1.0.2 as mariadb-builder
MAINTAINER lejianwen <84855512@qq.com>
WORKDIR /rootfs
RUN  mkdir lib64 && cp /lib64/*.so* lib64/ && rm lib64/*.so.*.* && rm /data/apps/mysql/mysql-test -rf
FROM busybox
MAINTAINER lejianwen <84855512@qq.com>
RUN echo mysql:x:1001:1001:mysql:/:/bin/sh >> etc/passwd \
        && echo mysql:x:1001: >> etc/group \
        && mkdir /lib \
        && ln -s /lib /lib64
COPY --from=mariadb-builder /etc/nsswitch.conf /etc/
COPY --from=mariadb-builder /rootfs/* /lib64/
COPY --from=mariadb-builder /data /data
COPY --from=mariadb-builder /usr/sbin/mysqld  /usr/sbin/mysqld
EXPOSE 3306
ENV MYSQL_ROOT_PASSWORD 123456

COPY mariadb_init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb_init.sh
CMD ["mariadb_init.sh"]