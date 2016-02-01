#!/bin/bash

echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password password ${DB_ROOT_PASSWORD}' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password ${DB_ROOT_PASSWORD}' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password ${DB_ROOT_PASSWORD}' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password ${DB_ROOT_PASSWORD}' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
