FROM lejianwen/php:70fpm-1.1 as php70-fpm
MAINTAINER lejianwen <84855512@qq.com>
WORKDIR /rootfs
RUN mkdir -p bin etc lib proc sys tmp dev/pts usr/lib64 usr/bin usr/local/bin usr/sbin usr/include \
    && chmod 777 ./tmp -R && touch etc/resolv.conf && cp /etc/nsswitch.conf etc/nsswitch.conf  \
    && echo root:x:0:0:root:/:/bin/sh > etc/passwd \
    && echo root:x:0: > etc/group \
    && echo www:x:1000:1000:www:/:/bin/sh >> etc/passwd \
    && echo www:x:1000: >> etc/group \
    && ln -s lib lib64 && ln -s bin sbin
RUN curl -L https://busybox.net/downloads/binaries/1.21.1/busybox-x86_64 -o /sbin/busybox \
    && chmod +x /sbin/busybox && cp /sbin/busybox bin && busybox --install -s bin && cp ./bin/busybox ./usr/sbin/busybox
#RUN cp -a /lib64/*.so* lib64/ \
RUN	cp /lib64/libcrypt.so.1 ./lib64 \
	&& cp /lib64/libz.so.1 ./lib64 \
	&& cp /lib64/libresolv.so.2 ./lib64 \
	&& cp /lib64/librt.so.1 ./lib64 \
	&& cp /lib64/libpng15.so.15 ./lib64 \
	&& cp /lib64/libjpeg.so.62 ./lib64 \
	&& cp /lib64/libcurl.so.4 ./lib64 \
	&& cp /lib64/libm.so.6 ./lib64 \
	&& cp /lib64/libdl.so.2 ./lib64 \
	&& cp /lib64/libnsl.so.1 ./lib64 \
	&& cp /lib64/libxml2.so.2 ./lib64 \
	&& cp /lib64/libssl.so.10 ./lib64 \
	&& cp /lib64/libcrypto.so.10 ./lib64 \
	&& cp /lib64/libfreetype.so.6 ./lib64 \
	&& cp /lib64/libc.so.6 ./lib64 \
	&& cp /lib64/libfreebl3.so ./lib64 \
	&& cp /lib64/libpthread.so.0 ./lib64 \
	&& cp /lib64/libidn.so.11 ./lib64 \
	&& cp /lib64/libssh2.so.1 ./lib64 \
	&& cp /lib64/libssl3.so ./lib64 \
	&& cp /lib64/libsmime3.so ./lib64 \
	&& cp /lib64/libnss3.so ./lib64 \
	&& cp /lib64/libnssutil3.so ./lib64 \
	&& cp /lib64/libplds4.so ./lib64 \
	&& cp /lib64/libplc4.so ./lib64 \
	&& cp /lib64/libnspr4.so ./lib64 \
	&& cp /lib64/libgssapi_krb5.so.2 ./lib64 \
	&& cp /lib64/libkrb5.so.3 ./lib64 \
	&& cp /lib64/libk5crypto.so.3 ./lib64 \
	&& cp /lib64/libcom_err.so.2 ./lib64 \
	&& cp /lib64/liblber-2.4.so.2 ./lib64 \
	&& cp /lib64/libldap-2.4.so.2 ./lib64 \
	&& cp /lib64/ld-linux-x86-64.so.2 ./lib64 \
	&& cp /lib64/liblzma.so.5 ./lib64 \
	&& cp /lib64/libbz2.so.1 ./lib64 \
	&& cp /lib64/libkrb5support.so.0 ./lib64 \
	&& cp /lib64/libkeyutils.so.1 ./lib64 \
	&& cp /lib64/libsasl2.so.3 ./lib64 \
	&& cp /lib64/libselinux.so.1 ./lib64 \
	&& cp /lib64/libpcre.so.1 ./lib64 \
	&& cp /lib64/libnssckbi.so ./lib64 \
	&& cp /lib64/libstdc++.so.6 ./lib64 \
    && cp /lib64/libgcc_s.so.1 ./lib64 \
	&& cp -a /lib64/libnss*.so* ./lib64 \
	&& cp -a /lib64/libsqlite3* ./lib64 \
	&& cp -a /lib64/libsoftokn3* ./lib64 \
	&& cp -a /lib64/libfreeblpriv3* ./lib64 \
    && cp -a /etc/pki etc/ \
    && ln -s /etc/pki /etc/ssl/certs \
    && strip /data/apps/php/bin/php-cgi \
    && strip /data/apps/php/sbin/php-fpm \
    && cp -a /data ./ \
    && sed -i 's/user = nobody/user = www/' data/apps/php/etc/php-fpm.d/www.conf \
    && sed -i 's/group = nobody/group = www/' data/apps/php/etc/php-fpm.d/www.conf
# RUN tar -cf /rootfs.tar .
FROM scratch
MAINTAINER lejianwen <84855512@qq.com>
COPY --from=php70-fpm /rootfs /
EXPOSE 9000
CMD ["/data/apps/php/sbin/php-fpm", "--nodaemonize", "--fpm-config", "/data/apps/php/etc/php-fpm.conf"]