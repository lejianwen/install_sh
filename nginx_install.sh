#!/bin/sh

function addnginxservice
{  
	if [ ! -f "/usr/lib/systemd/system/nginx.service" ]
	then
		echo "是否创建nginx.service，交给sysctemd 管理，输入 yes 是"
		read isyes
		if [ -z "$isyes" ]
		then
		  echo "无输入"
		elif [ $isyes = "yes" ]
		then
			touch /usr/lib/systemd/system/nginx.service
			true > /usr/lib/systemd/system/nginx.service
			echo '[Unit]' 												  >> /usr/lib/systemd/system/nginx.service
			echo 'Description=The Nginx Manager'                          >> /usr/lib/systemd/system/nginx.service
			echo 'After=network.target'                                   >> /usr/lib/systemd/system/nginx.service
	        echo ''                                                       >> /usr/lib/systemd/system/nginx.service
			echo '[Service]'                                              >> /usr/lib/systemd/system/nginx.service
			echo 'Type=forking'                                           >> /usr/lib/systemd/system/nginx.service
			echo "PIDFile=$setuppath/$nginxname/logs/nginx.pid"           >> /usr/lib/systemd/system/nginx.service
			echo "ExecStart=$setuppath/$nginxname/sbin/nginx"             >> /usr/lib/systemd/system/nginx.service
			echo "ExecReload=$setuppath/$nginxname/sbin/nginx -s reload"  >> /usr/lib/systemd/system/nginx.service
			echo "ExecStop=$setuppath/$nginxname/sbin/nginx -s stop"      >> /usr/lib/systemd/system/nginx.service
			echo 'Restart=always'                                         >> /usr/lib/systemd/system/nginx.service
	        echo ''                                                       >> /usr/lib/systemd/system/nginx.service
			echo '[Install]'                                              >> /usr/lib/systemd/system/nginx.service
			echo 'WantedBy=multi-user.target'                             >> /usr/lib/systemd/system/nginx.service
			systemctl enable nginx

		fi
	else
        echo "nginx service is have!"
	fi
	
}

function mkDir #dir
{
	if [ ! -d $1 ]
		then
		mkdir $1 -p
	fi
}

cd /
mkDir 'data'
cd /data
mkDir 'apps'
mkDir 'src'
mkDir 'logs'
cd /data/logs
mkDir 'nginx'

yum -y install gcc gcc-c++
yum -y install automake autoconf libtool make wget
yum -y install zlib zlib-devel openssl openssl-devel pcre pcre-devel

setuppath=/data/apps
xiazaipath=/data/src
cd $xiazaipath


echo "请输入nginx目录名称。默认为nginx"
read nginxname

if [ -z $nginxname ]
	then
	nginxname='nginx'
fi

cd $setuppath
if [ ! -d "$nginxname" ]
then

	cd $xiazaipath

	ifgroup=`cat /etc/group|grep www|wc -l`
	if [ $ifgroup -eq 0 ]
	then
	   groupadd -g 1000 www
	fi
	ifuser=`cat /etc/passwd|grep www|wc -l`
	if [ $ifuser -eq 0 ]
	then
	   useradd -g www www -s /sbin/nologin -u 1000
	fi

	cd $xiazaipath

	if [ ! -f "nginx.tar.gz" ]
	then
	   echo -e "请输入nginx安装包url,比如：\033[32m http://nginx.org/download/nginx-1.15.2.tar.gz \033[0m 不输入则使用示例地址"
	   read url

	   if [ -z $url ]
	   		then
	   		url='http://nginx.org/download/nginx-1.15.2.tar.gz'
	   fi

	   wget $url -O nginx.tar.gz
	# else
	#    rm -rf nginx
	fi

	# luaisyes=''

	echo -e "是否安装ngx_lua,输入 \033[32m yes \033[0m 安装, 默认安装"
	# echo "一个基于ngx_lua的web应用的高性能轻量级防火墙"
	read luaisyes

	if [ -z "$luaisyes" ]
	then
		luaisyes='yes'
	fi

	if [ $luaisyes = "yes" ]
	then
		# luaisyes='yes'
	    if [ ! -f "LuaJIT.tar.gz" ]
	    then
		    echo -e "请输入LuaJIT.tar.gz安装包url,比如：\033[32m http://luajit.org/download/LuaJIT-2.0.5.tar.gz \033[0m , 不输入则使用示例地址"
			read url;

			if [ -z $url ]
		   		then
		   		url='http://luajit.org/download/LuaJIT-2.0.5.tar.gz'
		   	fi

			wget $url -O LuaJIT.tar.gz
		# else
		#     rm -rf LuaJIT
	    fi
		
		if [ ! -f "lua-nginx-module.tar.gz" ]
	    then 
		    echo -e "请输入lua-nginx-module.tar.gz安装包url,比如：\033[32m https://github.com/openresty/lua-nginx-module/archive/v0.10.13.tar.gz \033[0m ， 不输入则使用示例地址"
			read url;


			if [ -z $url ]
		   		then
		   		url='https://github.com/openresty/lua-nginx-module/archive/v0.10.13.tar.gz'
		   	fi

			wget $url -O lua-nginx-module.tar.gz
		# else
		#     rm -rf lua-nginx-module
	    fi
		
		if [ ! -f "ngx_devel_kit.tar.gz" ]
	    then
		    echo -e "请输入ngx_devel_kit.tar.gz安装包url,比如：\033[32m https://github.com/simplresty/ngx_devel_kit/archive/v0.3.1rc1.tar.gz \033[0m 不输入则使用示例地址"
			read url;

			if [ -z $url ]
		   		then
		   		url='https://github.com/simplresty/ngx_devel_kit/archive/v0.3.1rc1.tar.gz'
		   	fi

			wget $url -O ngx_devel_kit.tar.gz
		# else
		#     rm -rf ngx_devel_kit
	    fi
		
		mkDir LuaJIT
		tar -zxvf LuaJIT.tar.gz -C ./LuaJIT --strip-components 1
		cd LuaJIT
		make && make install
		cd ..
		
		mkDir lua-nginx-module
		mkDir ngx_devel_kit
		tar -zxvf lua-nginx-module.tar.gz  -C ./lua-nginx-module --strip-components 1
		tar -zxvf ngx_devel_kit.tar.gz  -C ./ngx_devel_kit --strip-components 1
		
	    
		if [ ! -f /etc/profile.bak ]
		then
		    cp -a /etc/profile /etc/profile.bak
		fi
		
		export LUAJIT_LIB=/usr/local/lib
		export LUAJIT_INC=/usr/local/include/luajit-2.0

		
	else
	    echo "输入无效，无操作"
	fi

	mkDir nginx
	tar -zxvf nginx.tar.gz -C ./nginx --strip-components 1
	cd nginx   
	
    if [ $luaisyes = 'yes' ] 
	then
		echo "请输入ngx_lua安装模式：1 直接载入， 2 动态载入； 默认 1 "
		read lua_add_type

		if [ -z "$lua_add_type" ]
		then
          echo '无输入，默认1'
          lua_add_type=1
		fi

		if [ $lua_add_type = 2 ] 
		then
		./configure --user=www \
		--group=www --prefix=$setuppath/$nginxname \
		--with-http_stub_status_module \
		--with-http_ssl_module \
		--with-http_flv_module \
		--with-http_gzip_static_module \
		--with-http_realip_module \
		--with-http_v2_module \
		--add-dynamic-module=../lua-nginx-module \
		--add-dynamic-module=../ngx_devel_kit  \
		--with-ld-opt="-Wl,-rpath,$LUAJIT_LIB"
		else
		./configure --user=www \
		--group=www --prefix=$setuppath/$nginxname \
		--with-http_stub_status_module \
		--with-http_ssl_module \
		--with-http_flv_module \
		--with-http_gzip_static_module \
		--with-http_realip_module \
		--with-http_v2_module \
		--add-module=../lua-nginx-module \
		--add-module=../ngx_devel_kit  \
		--with-ld-opt="-Wl,-rpath,$LUAJIT_LIB"
		fi
	else
		./configure --user=www \
		--group=www --prefix=$setuppath/$nginxname \
		--with-http_stub_status_module \
		--with-http_ssl_module \
		--with-http_flv_module \
		--with-http_gzip_static_module \
		--with-http_realip_module \
		--with-http_v2_module     
	fi
	make -j2  && make install

fi

#修改配置文件

cd $setuppath/$nginxname/conf
if [ ! -f "nginx.conf.bak" ]
then
   mv $setuppath/$nginxname/conf/nginx.conf $setuppath/$nginxname/conf/nginx.conf.bak
fi


touch $setuppath/$nginxname/conf/php.conf
true > $setuppath/$nginxname/conf/php.conf

echo '        location ~ \.php$ {' >> $setuppath/$nginxname/conf/php.conf
echo '             try_files $uri =404;' >> $setuppath/$nginxname/conf/php.conf
echo '             fastcgi_connect_timeout      180;' >> $setuppath/$nginxname/conf/php.conf
echo '             fastcgi_read_timeout         600;' >> $setuppath/$nginxname/conf/php.conf
echo '             fastcgi_send_timeout         600;' >> $setuppath/$nginxname/conf/php.conf
echo '             fastcgi_buffer_size          4k;' >> $setuppath/$nginxname/conf/php.conf
echo '             fastcgi_buffers 8 4k;' >> $setuppath/$nginxname/conf/php.conf
echo '             fastcgi_busy_buffers_size 8k;' >> $setuppath/$nginxname/conf/php.conf
echo '             fastcgi_temp_file_write_size 8k;' >> $setuppath/$nginxname/conf/php.conf
echo '             #fastcgi_cache TEST;' >> $setuppath/$nginxname/conf/php.conf
echo '             fastcgi_cache_valid 200 302 1h;' >> $setuppath/$nginxname/conf/php.conf
echo '             fastcgi_cache_valid 301 1d;' >> $setuppath/$nginxname/conf/php.conf
echo '             fastcgi_cache_valid any 1m;' >> $setuppath/$nginxname/conf/php.conf
echo '             fastcgi_cache_min_uses 1;' >> $setuppath/$nginxname/conf/php.conf
echo '             #fastcgi_cache_use_stale error timeout invalid_header http_500;' >> $setuppath/$nginxname/conf/php.conf
echo "             #fastcgi_cache_path $setuppath/$nginxname/fastcgi_cache levels=1:2 keys_zone=TEST:10m inactive=5m;" >> $setuppath/$nginxname/conf/php.conf
echo '             fastcgi_pass   127.0.0.1:9000;' >> $setuppath/$nginxname/conf/php.conf
echo '             fastcgi_index  index.php;' >> $setuppath/$nginxname/conf/php.conf
echo '             fastcgi_param  SCRIPT_FILENAME  $document_root/$fastcgi_script_name;' >> $setuppath/$nginxname/conf/php.conf
echo '             include        fastcgi_params;' >> $setuppath/$nginxname/conf/php.conf
echo '        }' >> $setuppath/$nginxname/conf/php.conf



touch $setuppath/$nginxname/conf/static.conf
true > $setuppath/$nginxname/conf/static.conf
echo '        location ~ .*\.(gif|jpg|jpeg|png|bmp|zip|exe|txt|ico|rar|htm|html)$' >> $setuppath/$nginxname/conf/static.conf
echo '        {' >> $setuppath/$nginxname/conf/static.conf
echo '             expires 30d;' >> $setuppath/$nginxname/conf/static.conf
echo '        }' >> $setuppath/$nginxname/conf/static.conf

echo '        location ~ .*\.(swf|mp3|wmv|wma|mp4|mpg|flv)$' >> $setuppath/$nginxname/conf/static.conf
echo '        {' >> $setuppath/$nginxname/conf/static.conf
echo '             expires 30d;' >> $setuppath/$nginxname/conf/static.conf
echo '        }' >> $setuppath/$nginxname/conf/static.conf

echo '        location ~ .*\.(js|css)?$' >> $setuppath/$nginxname/conf/static.conf
echo '        {' >> $setuppath/$nginxname/conf/static.conf
echo '             expires 30h;' >> $setuppath/$nginxname/conf/static.conf
echo '        }' >> $setuppath/$nginxname/conf/static.conf

touch $setuppath/$nginxname/conf/nginx.conf
true > $setuppath/$nginxname/conf/nginx.conf
echo 'user  www  www;' >> $setuppath/$nginxname/conf/nginx.conf
echo 'worker_processes  2;' >> $setuppath/$nginxname/conf/nginx.conf

echo 'error_log  logs/error.log  notice;' >> $setuppath/$nginxname/conf/nginx.conf
echo 'pid        logs/nginx.pid;' >> $setuppath/$nginxname/conf/nginx.conf
echo 'events {' >> $setuppath/$nginxname/conf/nginx.conf
echo '     use epoll;' >> $setuppath/$nginxname/conf/nginx.conf
echo '     worker_connections  65535;' >> $setuppath/$nginxname/conf/nginx.conf
echo '}' >> $setuppath/$nginxname/conf/nginx.conf

echo 'http {' >> $setuppath/$nginxname/conf/nginx.conf
echo '   include       mime.types;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   default_type  application/octet-stream;' >> $setuppath/$nginxname/conf/nginx.conf
echo "   log_format  main  '\$remote_addr - \$remote_user [\$time_local] \"\$request\"'  " >> $setuppath/$nginxname/conf/nginx.conf
echo "                     '\$status \$body_bytes_sent \"\$http_referer\" ' " >> $setuppath/$nginxname/conf/nginx.conf
echo "                     '\"\$http_user_agent\" \"\$http_x_forwarded_for\" $request_time $upstream_response_time ';" >> $setuppath/$nginxname/conf/nginx.conf
echo '   sendfile        on;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   server_names_hash_bucket_size 128;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   client_header_buffer_size 32k;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   large_client_header_buffers 4 32k;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   client_max_body_size 300m;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   tcp_nopush on;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   keepalive_timeout 60;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   tcp_nodelay on;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   server_tokens off;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   client_body_buffer_size 512k;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   proxy_connect_timeout 60;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   proxy_send_timeout 60;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   proxy_read_timeout 60;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   proxy_buffer_size 16k;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   proxy_buffers 4 64k;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   proxy_busy_buffers_size 128k;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   proxy_temp_file_write_size 128k;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   open_file_cache max=204800 inactive=20s;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   open_file_cache_min_uses 1;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   open_file_cache_valid 30s;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   gzip  on;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   gzip_min_length 1k;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   gzip_buffers 4 16k;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   gzip_http_version 1.1;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   gzip_comp_level 2;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   gzip_types text/plain application/x-javascript text/css application/xml;' >> $setuppath/$nginxname/conf/nginx.conf
echo '   gzip_vary on;' >> $setuppath/$nginxname/conf/nginx.conf

echo '   server {' >> $setuppath/$nginxname/conf/nginx.conf
echo '        listen       80;' >> $setuppath/$nginxname/conf/nginx.conf
echo '        #listen       443 ssl http2;' >> $setuppath/$nginxname/conf/nginx.conf
echo '        server_name  localhost;' >> $setuppath/$nginxname/conf/nginx.conf
echo '        access_log  logs/host.access.log  main;' >> $setuppath/$nginxname/conf/nginx.conf
echo '        root   /data/htdocs/52fmz.top;' >> $setuppath/$nginxname/conf/nginx.conf
echo '        index  index.html index.htm index.php;' >> $setuppath/$nginxname/conf/nginx.conf

echo '        location /nginx-status {' >> $setuppath/$nginxname/conf/nginx.conf
echo '              stub_status on;' >> $setuppath/$nginxname/conf/nginx.conf
echo '              access_log off;' >> $setuppath/$nginxname/conf/nginx.conf
echo '        }' >> $setuppath/$nginxname/conf/nginx.conf

echo '        error_page   500 502 503 504  /50x.html;' >> $setuppath/$nginxname/conf/nginx.conf
echo '        location = /50x.html {' >> $setuppath/$nginxname/conf/nginx.conf
echo '            root   html;' >> $setuppath/$nginxname/conf/nginx.conf
echo '        }' >> $setuppath/$nginxname/conf/nginx.conf

echo '        include php.conf;' >> $setuppath/$nginxname/conf/nginx.conf

echo '        include static.conf;' >> $setuppath/$nginxname/conf/nginx.conf

echo '   }' >> $setuppath/$nginxname/conf/nginx.conf
echo '   include vhosts/*.conf;'  >> $setuppath/$nginxname/conf/nginx.conf
echo '}' >> $setuppath/$nginxname/conf/nginx.conf


addnginxservice
