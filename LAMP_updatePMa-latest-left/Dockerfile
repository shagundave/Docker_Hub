
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
RUN apt-get install -y zip
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
RUN touch /var/www/html/index.php
RUN echo "<?php echo '<h1>It\'s Works!</h1>'; ?>" > /var/www/html/index.php

ENV LOG_STDOUT **Boolean**
ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC
ENV TERM dumb

#COPY index.php /var/www/html/
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html


# Install MariaDB and set default root password

RUN echo 'mysql-server mysql-server/root_password  password root' | debconf-set-selections
RUN echo 'mysql-server mysql-server/root_password_again password root' | debconf-set-selections
RUN apt-get install mysql-server -y
RUN sed -ie "s/^bind-address\s*=\s*127\.0\.0\.1$/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# PHPMyAdmin
#RUN echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
#RUN echo 'phpmyadmin phpmyadmin/app-password-confirm password root ' | debconf-set-selections
#RUN echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections
#RUN echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections
#RUN echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
RUN /etc/init.d/mysql start; apt-get -y install phpmyadmin --no-install-recommends
RUN PHPMYADMIN_VERSION=4.8.3 && \
# Install libbz2-dev and zlib1g-dev packages to support *.sql.bz2 and *.sql.zip compressed files during imports

	apt-get update && \
	apt-get install -y --no-install-recommends libbz2-dev zlib1g-dev && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
# Download and extract phpMyAdmin

	curl https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.gz | tar --extract --gunzip --file - --strip-components 1 && \
	rm -rf examples && \
	rm -rf setup && \
	rm -rf sql

COPY config.inc.php /var/www/html/config.inc.php

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

RUN a2dissite 000-default
RUN a2enmod ssl


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

COPY start.sh /start.sh
CMD ["./start.sh"]
#CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
#CMD ["/usr/bin/mysqld_safe", "-D", "FOREGROUND"]
#CMD /usr/bin/touch /var/webmin/miniserv.log && /usr/sbin/service webmin restart && /usr/bin/tail -f /var/webmin/miniserv.log

