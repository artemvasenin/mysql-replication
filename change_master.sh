#!/bin/bash

while ! mysqladmin ping -h mysql-master --silent; do
    sleep 1
done

MASTER_FILE=$(eval "mysql --host mysql-master -uroot -e 'show master status \G' | grep File | sed -n -e 's/^.*: //p'")
MASTER_POSITION=$(eval "mysql --host mysql-master -uroot -e 'show master status \G' | grep Position | sed -n -e 's/^.*: //p'")

mysql -uroot -AN -e "CHANGE MASTER TO master_host='mysql-master', master_port=3306, \
        master_user='replication', master_password='password', \
       	master_log_file='$MASTER_FILE', master_log_pos=$MASTER_POSITION;"

