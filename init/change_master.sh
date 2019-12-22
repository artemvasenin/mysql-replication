#!/bin/bash

while ! mysqladmin ping -h mysql-master --silent; do
    sleep 1
done

MASTER_FILE=$(eval "mysql --host mysql-master -uroot -e 'show master status \G' | grep File | sed -n -e 's/^.*: //p'")
MASTER_POSITION=$(eval "mysql --host mysql-master -uroot -e 'show master status \G' | grep Position | sed -n -e 's/^.*: //p'")

mysql -uroot -AN -e "CHANGE MASTER TO \
	MASTER_HOST='mysql-master', \
	MASTER_PORT=3306, \
        MASTER_USER='replication', \
	MASTER_PASSWORD='password', \
       	MASTER_LOG_FILE='$MASTER_FILE', \
	MASTER_LOG_POS=$MASTER_POSITION, \
	MASTER_SSL=1, \
	MASTER_SSL_CA='/etc/mysql/certs/ca-cert.pem', \
	MASTER_SSL_CERT='/etc/mysql/certs/client-cert.pem', \
	MASTER_SSL_KEY='/etc/mysql/certs/client-key.pem';"

