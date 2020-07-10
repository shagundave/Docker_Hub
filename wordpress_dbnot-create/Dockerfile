
# Ubuntu LAMP stack with Apache, MariaDB, PHP, and SSL

FROM ubuntu:16.04

MAINTAINER DockerFan version 1.0 
LABEL Description="Cutting-edge LAMP stack, based on Ubuntu 16.04 LTS. Includes .htaccess support and popular PHP7 features, including composer and mail() function." \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST WWW PORT NUMBER]:80 -p [HOST DB PORT NUMBER]:3306 -v [HOST WWW DOCUMENT ROOT]:/var/www/html -v [HOST DB DOCUMENT ROOT]:/var/lib/mysql fauria/lamp" \
	Version="1.0"

ENV DEBIAN_FRONTEND noninteractive

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

RUN apt-get update
RUN apt-get upgrade -y

# Install Apache, SSL, PHP, and some PHP modules
RUN apt-get install -y apt-utils pwgen psmisc tar supervisor software-properties-common aptitude screen htop nano nmap net-tools wget zip vim bash-completion debconf-utils
RUN apt-get install -y \
	php7.0 \
	php7.0-bz2 \
	php7.0-cgi \
	php7.0-cli \
	php7.0-common \
	php7.0-curl \
	php7.0-dev \
	php7.0-enchant \
	php7.0-fpm \
	php7.0-gd \
	php7.0-gmp \
	php7.0-imap \
	php7.0-interbase \
	php7.0-intl \
	php7.0-json \
	php7.0-ldap \
	php7.0-mbstring \
	php7.0-mcrypt \
	php7.0-mysql \
	php7.0-odbc \
	php7.0-opcache \
	php7.0-pgsql \
	php7.0-phpdbg \
	php7.0-pspell \
	php7.0-readline \
	php7.0-recode \
	php7.0-snmp \
	php7.0-sqlite3 \
	php7.0-sybase \
	php7.0-tidy \
	php7.0-xmlrpc \
	php7.0-xsl \
	php7.0-zip

RUN apt-get install apache2 libapache2-mod-php7.0 -y
RUN touch /var/www/html/info.php
RUN echo '<?php phpinfo(); ?>' > /var/www/html/info.php

ENV LOG_STDOUT **Boolean**
ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC
ENV TERM dumb
ENV TERM xterm

#COPY index.php /var/www/html/
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html

# Here we generate random passwords (thank you pwgen!). The first two are for mysql users, the last batch for random keys in wp-config.php
ENV WORDPRESS_DB wordpress
ENV MYSQL_PASSWORD  pwgen -c -n -1 12
ENV WORDPRESS_PASSWORD $(pwgen -c -n -1 12)
# This is so the passwords show up in logs. 
RUN echo mysql root password: ${MYSQL_PASSWORD}
RUN echo wordpress password: ${WORDPRESS_PASSWORD}
RUN echo ${MYSQL_PASSWORD} > /mysql-root-pw.txt
#RUN echo ${WORDPRESS_PASSWORD} > /wordpress-db-pw.txt



# Install MariaDB and set default root password

RUN echo 'mysql-server mysql-server/root_password  password ${MYSQL_PASSWORD}' | debconf-set-selections
RUN echo 'mysql-server mysql-server/root_password_again password ${MYSQL_PASSWORD}' | debconf-set-selections
RUN apt-get install mysql-server -y --no-install-recommends
RUN sed -ie "s/^bind-address\s*=\s*127\.0\.0\.1$/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
RUN sed -i 's/^key_buffer\s*=/key_buffer_size =/' /etc/mysql/mysql.conf.d/mysqld.cnf

# PHPMyAdmin
RUN cd /var/www/html
RUN apt-get install unzip -y
ENV PHPMYADMIN_VERSION 4.8.3
RUN wget https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.zip
RUN unzip phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.zip -d /var/www/html
RUN mv /var/www/html/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages /var/www/html/phpmyadmin
RUN rm -rf /var/www/html/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.zip
COPY config.inc.php /var/www/html/phpmyadmin
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R  755 /var/www/html

# Webmin Installation
RUN echo root:pass | chpasswd && \
	echo "Acquire::GzipIndexes \"false\"; Acquire::CompressionTypes::Order:: \"gz\";" >/etc/apt/apt.conf.d/docker-gzip-indexes && \
	apt-get update && \
	apt-get install -y \
	wget \
	locales && \
	dpkg-reconfigure locales && \
	wget http://www.webmin.com/jcameron-key.asc && \
	apt-key add jcameron-key.asc && \
	echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list && \
	echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get install -y webmin && \
	apt-get clean

# Diable SSL in Webmin's http server
RUN perl -p -i -e 's/ssl=1/ssl=0/' /etc/webmin/miniserv.conf
RUN echo 'no_testing_cookie=1' >> /etc/webmin/miniserv.conf

# Disable the default Apache site config
# Install your site's Apache configuration and activate SSL

RUN a2enmod ssl

## Wordpress Installation
RUN mkdir -p /var/www/html/wordpress
ADD ./start.sh /start.sh
ADD ./supervisord.conf /etc/supervisord.conf
ADD http://wordpress.org/latest.tar.gz /wordpress.tar.gz
RUN tar xvzf /wordpress.tar.gz 
RUN mv /wordpress/* /var/www/html/wordpress/.
RUN chown -R www-data:www-data /var/www/html
RUN chmod 755 /start.sh
COPY wp-config.php /var/www/html/wordpress/
RUN chown -R www-data:www-data /var/www/html/wordpress/wp-config.php
#RUN sed -i  "s|database_name_here|${WORDPRESS_DB} |g"  /var/www/html/wordpress/wp-config.php
#RUN sed -i "s/username_here/root/g"   /var/www/html/wordpress/wp-config.php
#RUN sed -i "s/password_here/${MYSQL_PASSWORD}/g"  /var/www/html/wordpress/wp-config.php
#RUN sed -i  "/'AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/g"  /var/www/html/wordpress/wp-config.php
#RUN sed -i  "/'SECURE_AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/g"  /var/www/html/wordpress/wp-config.php
#RUN sed -i  "/'LOGGED_IN_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/g"  /var/www/html/wordpress/wp-config.php
#RUN sed -i  "/'NONCE_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/g"  /var/www/html/wordpress/wp-config.php
#RUN sed -i  "/'AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/g"  /var/www/html/wordpress/wp-config.php
#RUN sed -i  "/'SECURE_AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/g"  /var/www/html/wordpress/wp-config.php
#RUN sed -i  "/'LOGGED_IN_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/g"  /var/www/html/wordpress/wp-config.php
#RUN sed -i  "/'NONCE_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/g"  /var/www/html/wordpress/wp-config.php 

ADD ./config_mysql.sh /config_mysql.sh
RUN chmod 755 /config_mysql.sh
RUN /config_mysql.sh

## Create Database for Wordpress
ENV MYSQL_RUN_DIR /run/mysqld
RUN   rm -rf ${MYSQL_RUN_DIR}/mysqld.sock.lock
#RUN mysql -u root -p${MYSQL_PASSWORD} -e "CREATE DATABASE ${WORDPRESS_DB}; GRANT ALL PRIVILEGES ON ${WORDPRESS_DB}.* TO '${WORDPRESS_DB}'@'localhost' IDENTIFIED BY '${WORDPRESS_PASSWORD}'; FLUSH PRIVILEGES;"
#RUN killall mysqld
#RUN sleep 10
#RUN /etc/init.d/mysql start; do sleep 1; done && \
   # ./mysql -uroot -p${MYSQL_PASSWORD} -e "CREATE DATABASE ${WORDPRESS_DB};" && \
   # ./mysql -uroot -p${MYSQL_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${WORDPRESS_DB}.* TO 'root'@'localhost';"
#RUN /etc/init.d/mysql restart

# Remove APT files
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
VOLUME ["/var/www/html"]
VOLUME ["/var/lib/mysql"]
VOLUME ["/var/log/mysql"]
VOLUME ["/etc/apache2"]
VOLUME ["/etc/webmin"]

EXPOSE 443
EXPOSE 80
EXPOSE 3306
EXPOSE 10000

#COPY start.sh /start.sh
#CMD ["./start.sh"]
CMD ["/bin/bash", "/start.sh"]
