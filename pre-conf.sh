#!/bin/bash

/usr/bin/mysqld_safe &
sleep 10s

mysqladmin -u root password ${DB_PASSWORD}
mysqladmin -u root -p${DB_PASSWORD} reload
mysqladmin -u root -p${DB_PASSWORD} create ${DB_DATABASE}

echo "GRANT ALL ON ${DB_DATABASE}.* TO ${DB_USER}@localhost IDENTIFIED BY '${DB_PASSWORD}'; flush privileges; " | mysql -u root -p${DB_PASSWORD}

killall mysqld
sleep 10s
