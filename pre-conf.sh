#!/bin/bash

/usr/bin/mysqld_safe &
sleep 10s

mysqladmin -u root password ${DB_PASSWORD}
mysqladmin -u root -p${DB_PASSWORD} reload
mysqladmin -u root -p${DB_PASSWORD} create ${DB_DATABASE}

echo "GRANT ALL ON ${DB_DATABASE}.* TO ${DB_USER}@localhost IDENTIFIED BY '${DB_PASSWORD}'; flush privileges; " | mysql -u root -p${DB_PASSWORD}

killall mysqld
echo "Database initialized ..."
sleep 10s

# install cron jobs for user www-data
(crontab -u www-data -l ; echo "30 * * * * /var/www/humhub/protected/yii cron/hourly >/dev/null 2>&1") | crontab -u www-data -
(crontab -u www-data -l ; echo "00 18 * * * /var/www/humhub/protected/yii cron/daily >/dev/null 2>&1") | crontab -u www-data -
echo "Installed cron jobs ..." 

