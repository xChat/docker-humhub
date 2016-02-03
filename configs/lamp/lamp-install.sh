#!/bin/bash

echo 'mysql-server mysql-server/root_password password' ${DB_ROOT_PASSWORD} | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password' ${DB_ROOT_PASSWORD} | debconf-set-selections
apt-get --yes --force-yes install lamp-server^
