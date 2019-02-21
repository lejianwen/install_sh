FROM centos
MAINTAINER lejianwen <84855512@qq.com>
RUN yum -y install epel-release make gcc gcc++ \
&& mkdir /data/src/redis -p && cd /data/src && curl -L http://10.2.30.174/redis-5.0.3.tar.gz -o redis.tar.gz \
&& tar -zxf redis.tar.gz -C ./redis --strip-components 1 \
&& cd redis && make && make install && rm /data/src -rf && yum clean all
CMD ["redis-server"]