FROM lejianwen/redis:1.0 as redis-builder
MAINTAINER lejianwen <84855512@qq.com>
WORKDIR /rootfs
RUN mkdir -p bin etc lib proc sys tmp dev/pts usr/lib64 usr/bin usr/local/bin usr/sbin\
    && chmod 777 ./tmp -R && touch etc/resolv.conf && cp /etc/nsswitch.conf etc/nsswitch.conf  \
    && echo root:x:0:0:root:/:/bin/sh > etc/passwd \
    && echo root:x:0: > etc/group \
    && ln -s lib lib64 && ln -s bin sbin \
    && curl -L https://busybox.net/downloads/binaries/1.21.1/busybox-x86_64 -o /sbin/busybox \
    && chmod +x /sbin/busybox && cp /sbin/busybox bin && busybox --install -s bin && cp ./bin/busybox ./usr/sbin/busybox
RUN cp /lib64/lib{rt,m,dl,pthread,c}.so.* lib64/ && cp /lib64/ld-linux-x86-64.so.2 lib64/ \
&& cp /usr/local/bin/redis-server ./usr/bin \
&& cp /usr/local/bin/redis-cli ./usr/bin

FROM scratch
MAINTAINER lejianwen <84855512@qq.com>
COPY --from=redis-builder /rootfs /
EXPOSE 6379
CMD ["redis-server"]