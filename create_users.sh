#!/bin/sh
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


ifgroup=`cat /etc/group|grep mysql|wc -l`
	if [ $ifgroup -eq 0 ]
	then
	   groupadd -g 1001 mysql
	fi
	ifuser=`cat /etc/passwd|grep mysql|wc -l`
	if [ $ifuser -eq 0 ]
	then
	   useradd -g mysql mysql -s /sbin/nologin -u 1001
	fi