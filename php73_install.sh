#!/bin/sh
function phpsetup #setuppath #xiazaipath
{
	if [ ! -d $1 ]
	then
		mkdir $1 -p
	fi
	if [ ! -d $2 ]
	then
		mkdir $2 -p
	fi
	cd $1
	if [ ! -d "php" ]
	then
		cd $2
		if [ ! -f "php.tar.gz" ]
		then
			echo -e "请输入php下载地址,比如: \033[32m  https://www.php.net/distributions/php-7.3.4.tar.gz \033[0m； 不输入则使用示例地址"
			read url

			if [ -z $url ]
		   	then
		   		url='https://www.php.net/distributions/php-7.3.4.tar.gz'
		   	fi	

			wget $url -O php.tar.gz
		else
			echo "" #rm -rf php.tar.gz
		fi
		if [ ! -d "php" ]
		then
			mkdir php
		fi
		tar -zxvf php.tar.gz -C ./php --strip-components 1
		cd php
		./configure --prefix=$1/php \
		--with-config-file-path=$1/php/etc \
		--with-mysqli=mysqlnd \
		--with-pdo-mysql=mysqlnd \
		--with-mysql-sock=/tmp/mysql.sock \
		--enable-mysqlnd \
		--with-gd \
		--with-iconv \
		--with-zlib \
		--enable-bcmath \
		--enable-shmop \
		--enable-sysvsem \
		--enable-inline-optimization \
		--enable-mbregex \
		--enable-fpm \
		--enable-mbstring \
		--enable-ftp \
		--enable-gd-native-ttf \
		--with-openssl \
		--enable-pcntl \
		--enable-sockets \
		--with-xmlrpc \
		--enable-zip \
		--enable-soap \
		--with-gettext \
		--with-curl \
		--with-jpeg-dir \
		 --enable-opcache \
		--with-freetype-dir
		make && make install
		cp -a ./php.ini-production $1/php/etc/php.ini
		cp -a $1/php/etc/php-fpm.conf.default $1/php/etc/php-fpm.conf
		cp -a $1/php/etc/php-fpm.d/www.conf.default $1/php/etc/php-fpm.d/www.conf
		sed -i 's/user = nobody/user = www/' $1/php/etc/php-fpm.d/www.conf
		sed -i 's/group = nobody/group = www/' $1/php/etc/php-fpm.d/www.conf
		sed -i 's/;rlimit_files = 1024/rlimit_files = 65535/' $1/php/etc/php-fpm.d/www.conf
		sed -i 's/pm.max_children = 5/pm.max_children = 200/' $1/php/etc/php-fpm.d/www.conf
		sed -i 's/;pm.max_requests = 500/pm.max_requests = 65535/' $1/php/etc/php-fpm.d/www.conf
		sed -i 's/pm.start_servers = 2/pm.start_servers = 100/' $1/php/etc/php-fpm.d/www.conf
		sed -i 's/pm.min_spare_servers = 1/pm.min_spare_servers = 10/' $1/php/etc/php-fpm.d/www.conf
		sed -i 's/pm.max_spare_servers = 3/pm.max_spare_servers = 180/' $1/php/etc/php-fpm.d/www.conf
		sed -i 's#;slowlog = log/$pool.log.slow#slowlog = /data/logs/php/$pool.log.slow#' $1/php/etc/php-fpm.d/www.conf
		sed -i 's/;request_terminate_timeout = 0/request_terminate_timeout = 5s/' $1/php/etc/php-fpm.d/www.conf
		sed -i 's/;request_slowlog_timeout = 0/request_slowlog_timeout = 3s/' $1/php/etc/php-fpm.d/www.conf
		sed -i 's/;request_slowlog_timeout = 0/request_slowlog_timeout = 3s/' $1/php/etc/php-fpm.d/www.conf
		cp -a ./sapi/fpm/php-fpm.service /usr/lib/systemd/system/php-fpm.service
		# 开机运行服务
		#systemctl enable php-fpm

	fi
}
function phpset
{
	#sed -i 's/DirectoryIndex index.html/DirectoryIndex index.html index.php/' $1/apache/conf/httpd.conf
	#sed -i '378 i\    AddType application/x-httpd-php-source .phps' $1/apache/conf/httpd.conf
	#sed -i '378 i\    AddType application/x-httpd-php .php .phtml .php3 .inc' $1/apache/conf/httpd.conf
	#sed -i '/ttt/ a input content' $1/apache/conf/httpd.conf
	
	#sed -i 's/disable_functions =/disable_functions =passthru,exec,assert,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,fsocket,popen,pfsockopen,phpinfo/' $1/php/etc/php.ini
	sed -i 's/max_execution_time = 30/max_execution_time = 50/' $1/php/etc/php.ini
	sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 300M/' $1/php/etc/php.ini
	sed -i 's#;error_log = php_errors.log#error_log = /data/logs/php/php_errors.log#' $1/php/etc/php.ini
	sed -i 's/expose_php = On/expose_php = off/' $1/php/etc/php.ini
	
}
function setphpredis
{
    isyou=`cat $setuppath/php/etc/php.ini|grep "redis.so"|wc -l`
	if [ $isyou -eq 0 ]
	then
		cd $xiazaipath
		if [ ! -f "phpredis.tgz" ]
		then
			echo -e "请输入phpredis下载地址,比如: \033[32m http://pecl.php.net/get/redis-4.0.0.tgz \033[0m； 不输入则使用示例地址"
			read url

			if [ -z $url ]
		   	then
		   		url='http://pecl.php.net/get/redis-4.0.0.tgz'
		   	fi	

			wget $url -O phpredis.tgz
		else
			echo "" #rm -rf phpredis.tgz
		fi
		if [ ! -d "phpredis" ]
		then
			mkdir phpredis
		fi
		tar -zxvf phpredis.tgz -C ./phpredis --strip-components 1
		cd phpredis
		$setuppath/php/bin/phpize
		./configure --with-php-config=$setuppath/php/bin/php-config
		make && make install
		isyou1=`cat $setuppath/php/etc/php.ini|grep "no-debug-non-zts-20151012"|wc -l`
		if [ $isyou1 -eq 0 ]
		then
			echo "extension_dir=\"$setuppath/php/lib/php/extensions/no-debug-non-zts-20151012/\"" >> $setuppath/php/etc/php.ini
		fi
		echo 'extension = "redis.so"' >> $setuppath/php/etc/php.ini
	fi
}
function setphpswoole
{

    isyou=`cat $setuppath/php/etc/php.ini|grep "swoole.so"|wc -l`
	if [ $isyou -eq 0 ]
	then
		cd $xiazaipath
		if [ ! -f "phpswoole.tar.gz" ]
		then
			echo -e "请输入swoole下载地址,比如: \033[32m https://github.com/swoole/swoole-src/archive/v1.10.2.tar.gz \033[0m； 不输入则使用示例地址"
			read url

			if [ -z $url ]
		   	then
		   		url='https://github.com/swoole/swoole-src/archive/v1.10.2.tar.gz'
		   	fi	
	
			wget $url -O phpswoole.tar.gz
		else
			echo "" #rm -rf phpswoole.tar.gz
		fi
		if [ ! -d "phpswoole" ]
		then
			mkdir phpswoole
		fi
		tar -zxvf  phpswoole.tar.gz -C ./phpswoole --strip-components 1

		cd phpswoole
		$setuppath/php/bin/phpize
		./configure --with-php-config=$setuppath/php/bin/php-config \
		--enable-openssl
		make && make install
		isyou1=`cat $setuppath/php/etc/php.ini|grep "no-debug-non-zts-20151012"|wc -l`
		if [ $isyou1 -eq 0 ]
		then
			echo "extension_dir=\"$setuppath/php/lib/php/extensions/no-debug-non-zts-20151012/\"" >> $setuppath/php/etc/php.ini
		fi
		echo 'extension = "swoole.so"' >> $setuppath/php/etc/php.ini
	fi
}

function mkDir #dir
{
	if [ ! -d $1 ]
		then
		mkdir $1 -p
	fi
}

function libzipset #xiazaipath
{
cd $1
wget https://libzip.org/download/libzip-1.3.2.tar.gz
tar -zxvf libzip-1.3.2.tar.gz
cd $1/libzip-1.3.2
./configure
make && make install && make clean
ldconfig
}


cd /
mkDir 'data'
cd /data
mkDir 'apps'
mkDir 'src'
mkDir 'logs'
cd /data/logs
mkDir 'php'

setuppath=/data/apps
xiazaipath=/data/src

yum -y install deltarpm
yum -y install epel-release
yum -y install autoconf bison gcc gcc-c++ make openssl openssl-devel curl curl-devel libxml2 libxml2-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel wget re2c

libzipset $xiazaipath
phpsetup $setuppath $xiazaipath
phpset $setuppath

echo "是否安装 phpredis? 输入 yes 安装"
read isyes
if [ -z "$isyes" ]
then
	echo "不安装phpredis"
elif [ $isyes = "yes" ]
then
	setphpredis
fi

echo "是否安装 swoole? 输入 yes 安装"
read isyes
if [ -z "$isyes" ]
then
	echo "不安装 swoole"
elif [ $isyes = "yes" ]
then
	setphpswoole
fi
