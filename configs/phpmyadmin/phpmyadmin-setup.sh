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

# create the phpmyadmin storage configuration database.
echo "CREATE DATABASE phpmyadmin; GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'root'@'localhost' IDENTIFIED BY '"${DB_ROOT_PASSWORD}"'; FLUSH PRIVILEGES;" | mysql -uroot -p${DB_ROOT_PASSWORD}

# import the configuration storage database.
gunzip < /usr/share/doc/phpmyadmin/examples/create_tables.sql.gz | mysql -uroot -p${DB_ROOT_PASSWORD} phpmyadmin

# shutdown the server.
killall mysqld
