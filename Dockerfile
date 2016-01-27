# Humhub
#
# VERSION               0.0.3
#


FROM     ubuntu
MAINTAINER Jerry Li

ENV DEBIAN_FRONTEND noninteractive
ENV GIT_MASTER_URL https://github.com/humhub/humhub/archive/master.zip
ENV ROOT_PASSWORD rboDlyGo!
ENV DB_ROOT_PASSWORD dboDlyGo!
ENV DB_DATABASE humhub
ENV DB_USER humhub
ENV DB_PASSWORD _HuMhUb!

# updates

RUN (apt-get update && apt-get upgrade -y -q && apt-get dist-upgrade -y -q && apt-get -y -q autoclean && apt-get -y -q autoremove)

# lamp

RUN (echo 'mysql-server mysql-server/root_password password' echo $DB_ROOT_PASSWORD | debconf-set-selections)
RUN (echo 'mysql-server mysql-server/root_password_again password' echo $DB_ROOT_PASSWORD | debconf-set-selections)
RUN apt-get --yes --force-yes install lamp-server^

# packages install

RUN mysqld_safe start
RUN apt-get install -y -q php5-gd php5-curl php5-sqlite php5-ldap php-apc wget unzip cron
RUN wget $GIT_MASTER_URL
RUN unzip master.zip
RUN mv humhub-master /var/www/humhub
RUN chown www-data:www-data -R /var/www/


# config 

ADD default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
ADD pre-conf.sh /pre-conf.sh
RUN chmod 750 /pre-conf.sh
RUN (/bin/bash -c /pre-conf.sh)
RUN service apache2 stop
RUN a2enmod ssl
RUN a2enmod rewrite
RUN a2dissite 000-default
RUN a2ensite default-ssl


# start services

ADD supervisor-humhub.conf /etc/supervisor/conf.d/supervisor-humhub.conf
CMD ["supervisord", "-n"]


# openssh

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:'echo $ROOT_PASSWORD | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# phpmyadmin

RUN (echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections)
RUN (echo 'phpmyadmin phpmyadmin/app-password password' echo $DB_ROOT_PASSWORD | debconf-set-selections)
RUN (echo 'phpmyadmin phpmyadmin/app-password-confirm password' echo $DB_ROOT_PASSWORD | debconf-set-selections)
RUN (echo 'phpmyadmin phpmyadmin/mysql/admin-pass password' echo $DB_ROOT_PASSWORD | debconf-set-selections)
RUN (echo 'phpmyadmin phpmyadmin/mysql/app-pass password' echo $DB_ROOT_PASSWORD | debconf-set-selections)
RUN (echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections)
RUN apt-get install phpmyadmin -y
ADD configs/phpmyadmin/config.inc.php /etc/phpmyadmin/conf.d/config.inc.php
RUN chmod 755 /etc/phpmyadmin/conf.d/config.inc.php
ADD configs/phpmyadmin/phpmyadmin-setup.sh /phpmyadmin-setup.sh
RUN chmod +x /phpmyadmin-setup.sh
RUN /phpmyadmin-setup.sh

EXPOSE 22 80 443 30000-30009
