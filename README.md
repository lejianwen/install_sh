# install_sh
nginx and php install sh

## 2019-02-15 添加Dockerfile
* 使用docker创建时，请根据自己需求挂载相关的卷。或者直接使用 data ，将data 复制到根目录/

### data目录结构
~~~

data
├── etc                                  配置文件目录
│   ├── mysql                            mysql配置目录
│   │   └── my.cnf
│   ├── nginx                            nginx配置目录
│   │   ├── fastcgi.conf
│   │   ├── fastcgi.conf.default
│   │   ├── fastcgi_params
│   │   ├── fastcgi_params.default
│   │   ├── koi-utf
│   │   ├── koi-win
│   │   ├── mime.types
│   │   ├── mime.types.default
│   │   ├── nginx.conf
│   │   ├── nginx.conf.bak
│   │   ├── nginx.conf.default
│   │   ├── php.conf
│   │   ├── scgi_params
│   │   ├── scgi_params.default
│   │   ├── static.conf
│   │   ├── uwsgi_params
│   │   ├── uwsgi_params.default
│   │   ├── vhosts
│   │   │   └── fmz.com.conf
│   │   └── win-utf
│   ├── php                             php配置目录      
│   │   ├── php-fpm.conf
│   │   ├── php-fpm.conf.default
│   │   ├── php-fpm.d
│   │   │   └── www.conf                php-fpm配置
│   │   └── php.ini
│   └── redis                           redis配置
│       └── redis.conf
├── htdocs                              网站项目目录
├── logs                                日志目录
│   ├── redis
│   ├── nginx
│   └── php
│       └── www.log.slow
├── mysql_data                          mysql数据目录
└── redis_data                          redis数据目录

~~~
