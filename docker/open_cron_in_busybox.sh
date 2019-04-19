#!/bin/sh

# 在busybox中开启crond


mkdir -p /var/spool/cron/crontabs
touch /var/spool/cron/crontabs/root

echo '* * * * * echo `date` > /dev/null 2>&1' > /var/spool/cron/crontabs/root

crond