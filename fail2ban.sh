#!/bin/sh

yum install -y epel-release
yum install -y fail2ban

echo "# defalut这里是设定全局设置，如果下面的监控没有设置就以全局设置的值设置。
[DEFAULT]
# # 用于指定哪些地址ip可以忽略 fail2ban 防御,以空格间隔。
ignoreip = 127.0.0.1/8
# # ssh客户端主机被禁止的时长（默认单位为秒）
bantime  = 3600
# # 过滤的时长（秒）
findtime  = 600
# # 匹配到的阈值（允许失败次数）
maxretry = 3


[ssh-iptables]
# 是否开启
enabled  = true
# 过滤规则
filter   = sshd
# 动作
action   = iptables[name=SSH, port=ssh, protocol=tcp]
#action   = firewallcmd-ipset
# 日志文件的路径
logpath  = /var/log/secure
# 匹配到的阈值（次数）
maxretry = 3
" > /etc/fail2ban/jail.d/jail.local

systemctl start fail2ban