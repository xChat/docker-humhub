#!/bin/bash

# start MySQL
/usr/bin/mysqld_safe > /dev/null 2>&1 &

# wait until the MySQL server is available.
RET=1
while [[ RET -ne 0 ]]; do
    echo " ---> Waiting for MySQL"
    sleep 2
    mysql -uroot -p${DB_ROOT_PASSWORD} -e "status" > /dev/null 2>&1
    RET=$?
done

echo 'CREATE DATABASE' ${DB_DATABASE}';' | mysql -uroot -p${DB_ROOT_PASSWORD}
echo "GRANT ALL ON "${DB_DATABASE}".* TO '"${DB_USER}"'@'localhost' IDENTIFIED BY '"${DB_PASSWORD}"'; flush privileges;" | mysql -u root -p${DB_ROOT_PASSWORD}

#killall mysqld
echo "Database initialized ..."
sleep 10s

# install cron jobs for user www-data
(crontab -u www-data -l ; echo "30 * * * * /var/www/humhub/protected/yii cron/hourly >/dev/null 2>&1") | crontab -u www-data -
(crontab -u www-data -l ; echo "00 18 * * * /var/www/humhub/protected/yii cron/daily >/dev/null 2>&1") | crontab -u www-data -
echo "Installed cron jobs ..." 
