# Humhub
#
# VERSION               0.0.1
#


FROM     xChat/docker-humhub
MAINTAINER Jerry Li

ENV DEBIAN_FRONTEND noninteractive

# updates & packages install

RUN (apt-get update && apt-get upgrade -y -q && apt-get dist-upgrade -y -q && apt-get -y -q autoclean && apt-get -y -q autoremove)
RUN mysqld_safe start
RUN apt-get install -y -q php5-gd php5-curl php5-sqlite php5-ldap php-apc wget unzip cron
RUN wget https://github.com/humhub/humhub/archive/master.zip
RUN unzip master.zip
RUN mv humhub-master /var/www/humhub
RUN chown www-data:www-data -R /var/www/


# config 

ADD default-ssl /etc/apache2/sites-available/default-ssl
ADD pre-conf.sh /pre-conf.sh
RUN chmod 750 /pre-conf.sh
RUN (/bin/bash -c /pre-conf.sh)
RUN service apache2 stop
RUN a2enmod ssl
RUN a2enmod rewrite
RUN a2dissite default
RUN a2ensite default-ssl


# start services

ADD supervisor-humhub.conf /etc/supervisor/conf.d/supervisor-humhub.conf
CMD ["supervisord", "-n"]


# pure-ftpd
# properly setup debian sources
RUN echo "deb http://http.debian.net/debian jessie main\n\
deb-src http://http.debian.net/debian jessie main\n\
deb http://http.debian.net/debian jessie-updates main\n\
deb-src http://http.debian.net/debian jessie-updates main\n\
deb http://security.debian.org jessie/updates main\n\
deb-src http://security.debian.org jessie/updates main\n\
" > /etc/apt/sources.list
RUN apt-get -y update

# install package building helpers
RUN apt-get -y --force-yes install dpkg-dev debhelper

# install dependancies
RUN apt-get -y build-dep pure-ftpd

# build from source
RUN mkdir /tmp/pure-ftpd/ && \
	cd /tmp/pure-ftpd/ && \
	apt-get source pure-ftpd && \
	cd pure-ftpd-* && \
	sed -i '/^optflags=/ s/$/ --without-capabilities/g' ./debian/rules && \
	dpkg-buildpackage -b -uc

# install the new deb files
RUN dpkg -i /tmp/pure-ftpd/pure-ftpd-common*.deb
RUN apt-get -y install openbsd-inetd
RUN dpkg -i /tmp/pure-ftpd/pure-ftpd_*.deb

# prevent pure-ftpd upgrading
RUN apt-mark hold pure-ftpd pure-ftpd-common

# setup ftpgroup and ftpuser
RUN groupadd ftpgroup
RUN useradd -g ftpgroup -d /home/ftpusers -s /dev/null ftpuser

ENV PUBLICHOST ftp.foo.com

VOLUME /home/ftpusers

# add ftp user
RUN pure-pw useradd bob -u ftpuser -d /var/www/humhub
RUN pure-pw mkdb

# startup
CMD /usr/sbin/pure-ftpd -c 50 -C 10 -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R -P $PUBLICHOST -p 30000:30009

EXPOSE 80 443 21 30000-30009
