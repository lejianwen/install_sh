FROM centos
MAINTAINER lejianwen <84855512@qq.com>
ADD http://nginx.org/download/nginx-1.15.8.tar.gz /nginx.tar.gz
RUN yum -y install epel-release gcc gcc-c++ automake autoconf libtool make zlib zlib-devel openssl openssl-devel pcre pcre-devel \
    && useradd www -s /sbin/nologin \
    && mkdir /data/src -p && cd /data/src && mv /nginx.tar.gz ./ \
    && mkdir nginx && tar -zxf nginx.tar.gz -C ./nginx --strip-components 1 && cd nginx \
    && ./configure --user=www \
       --group=www --prefix=/data/apps/nginx \
       --with-http_stub_status_module \
       --with-http_ssl_module \
       --with-http_flv_module \
       --with-http_gzip_static_module \
       --with-http_realip_module \
       --with-http_v2_module \
    && make -j4  && make install && cd / && rm /data/src -rf
CMD ["/data/apps/nginx/sbin/nginx"]