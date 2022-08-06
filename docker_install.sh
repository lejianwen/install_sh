#!/bin/sh
# docker安装脚本

yum remove docker \
docker-client \
docker-client-latest \
docker-common \
docker-latest \
docker-latest-logrotate \
docker-logrotate \
docker-engine

yum install -y yum-utils \
device-mapper-persistent-data \
lvm2

# 官方
# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 阿里云镜像
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum install -y docker-ce docker-ce-cli containerd.io

#
#mkdir -p /etc/docker
#tee /etc/docker/daemon.json <<-'EOF'
#{
#  "registry-mirrors": ["https://t6fb7rlr.mirror.aliyuncs.com"]
#}
#EOF
systemctl daemon-reload
systemctl start docker
docker run hello-world

echo -e "是否安装docker-compose,输入 \033[32m yes \033[0m 安装, 默认安装"

read dcisyes

if [ -z "$dcisyes" ]; then
  dcisyes='yes'
fi

if [ $dcisyes = "yes" ]; then
  ./docker_compose_install.sh
fi
