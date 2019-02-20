FROM lejianwen/php:70fpm as php70-fpm
MAINTAINER lejianwen <84855512@qq.com>
WORKDIR /rootfs
RUN mkdir -p bin etc lib proc sys tmp dev/pts usr/lib64 usr/bin usr/local/bin \
    && chmod 777 ./tmp -R && touch etc/resolv.conf && cp /etc/nsswitch.conf etc/nsswitch.conf  \
    && echo root:x:0:0:root:/:/bin/sh > etc/passwd \
    && echo root:x:0: > etc/group \
    && echo www:x:1001:1001:root:/:/bin/sh >> etc/passwd \
    && echo www:x:1001: >> etc/group \
    && ln -s lib lib64 && ln -s bin sbin
RUN curl -L https://busybox.net/downloads/binaries/1.21.1/busybox-x86_64 -o /sbin/busybox \
    && chmod +x /sbin/busybox && cp /sbin/busybox bin && busybox --install -s bin
RUN cp  /lib64/*.so* lib64/ && rm lib64/*.so.*.*\
    && cp -a /etc/pki etc/ \
    && cp -a /data ./ \
    && sed -i 's/user = nobody/user = www/' data/apps/php/etc/php-fpm.d/www.conf \
    && sed -i 's/group = nobody/group = www/' data/apps/php/etc/php-fpm.d/www.conf
# RUN tar -cf /rootfs.tar .
FROM scratch
MAINTAINER lejianwen <84855512@qq.com>
COPY --from=php70-fpm /rootfs /
EXPOSE 9000
CMD ["/data/apps/php/sbin/php-fpm", "--nodaemonize", "--fpm-config", "/data/apps/php/etc/php-fpm.conf"]