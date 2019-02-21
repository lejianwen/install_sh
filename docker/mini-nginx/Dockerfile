FROM lejianwen/nginx:1.0 as nginx-builder
MAINTAINER lejianwen <84855512@qq.com>
WORKDIR /rootfs
RUN mkdir -p bin etc lib proc sys tmp dev/pts usr/lib64 usr/bin usr/local/bin usr/sbin\
    && chmod 777 ./tmp -R && touch etc/resolv.conf && cp /etc/nsswitch.conf etc/nsswitch.conf  \
    && echo root:x:0:0:root:/:/bin/sh > etc/passwd \
    && echo root:x:0: > etc/group \
    && echo www:x:1001:1001:www:/:/bin/sh >> etc/passwd \
    && echo www:x:1001: >> etc/group \
    && ln -s lib lib64 && ln -s bin sbin \
    && curl -L https://busybox.net/downloads/binaries/1.21.1/busybox-x86_64 -o /sbin/busybox \
    && chmod +x /sbin/busybox && cp /sbin/busybox bin && busybox --install -s bin && cp ./bin/busybox ./usr/sbin/busybox
RUN cp  /lib64/*.so* lib64/ && rm lib64/*.so.*.* \
#RUN cp /lib64/libdl.so.2 ./lib64 \
#    && cp /lib64/libpthread.so.0 ./lib64 \
#    && cp /lib64/libcrypt.so.1 ./lib64 \
#    && cp /lib64/libpcre.so.1 ./lib64 \
#    && cp /lib64/libssl.so.10 ./lib64 \
#    && cp /lib64/libcrypto.so.10 ./lib64 \
#    && cp /lib64/libz.so.1 ./lib64 \
#    && cp /lib64/libc.so.6 ./lib64 \
#    && cp /lib64/ld-linux-x86-64.so.2 ./lib64 \
#    && cp /lib64/libfreebl3.so ./lib64 \
#    && cp /lib64/libgssapi_krb5.so.2 ./lib64 \
#    && cp /lib64/libkrb5.so.3 ./lib64 \
#    && cp /lib64/libcom_err.so.2 ./lib64 \
#    && cp /lib64/libk5crypto.so.3 ./lib64 \
#    && cp /lib64/libkrb5support.so.0 ./lib64 \
#    && cp /lib64/libkeyutils.so.1 ./lib64 \
#    && cp /lib64/libresolv.so.2 ./lib64 \
#    && cp /lib64/libselinux.so.1 ./lib64 \
#    && cp /lib64/libuser.so.1 ./lib64 \
#    && cp /lib64/libaudit.so.1 ./lib64 \
#    && cp /lib64/libsemanage.so.1 ./lib64 \
    && cp -a /etc/pki etc/ \
    && cp -a /data ./

FROM scratch
MAINTAINER lejianwen <84855512@qq.com>
COPY --from=nginx-builder /rootfs /
EXPOSE 80
CMD ["/data/apps/nginx/sbin/nginx"]