#!/bin/bash

echo 'CREATE DATABASE' ${DB_DATABASE}';'
echo 'GRANT ALL ON '${DB_DATABASE}'.* TO '${DB_USER}'@localhost IDENTIFIED BY '${DB_PASSWORD}'; flush privileges;'
exit 1;

echo 'mysql-server mysql-server/root_password password' ${DB_ROOT_PASSWORD} | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password' ${DB_ROOT_PASSWORD} | debconf-set-selections
apt-get --yes --force-yes install lamp-server^
