#Download base image ubuntu 16.04
FROM ubuntu:16.04

# Update Ubuntu
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y zip supervisor
RUN apt-get install wget -y
RUN apt-get install unzip -y
RUN apt-get install -y software-properties-common aptitude screen htop nano nmap net-tools
ARG DEBIAN_FRONTEND=noninteractive

# Install Nginx Stable.
RUN \
    add-apt-repository -y ppa:nginx/stable && \
    apt-get update
 
# Install nginx, php-fpm and supervisord from ubuntu repository
RUN apt-get install -y nginx php7.0-fpm php7.0-common php7.0-cli php7.0 php7.0-curl php7.0-intl php7.0-mysql php7.0-gd php7.0-mbstring php7.0-mcrypt && \
    echo 'mysql-server mysql-server/root_password  password root' | debconf-set-selections && \
    echo 'mysql-server mysql-server/root_password_again password root' | debconf-set-selections && \
    apt install -y mysql-server --no-install-recommends 

RUN mkdir /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld

 
#Define the ENV variable
ENV nginx_vhost /etc/nginx/sites-available/default
ENV php_conf /etc/php/7.0/fpm/php.ini
ENV nginx_conf /etc/nginx/nginx.conf
ENV supervisor_conf /etc/supervisor/supervisord.conf

RUN apt-get install -y build-essential curl rlwrap apt-transport-https bzip2

## Nodejs Install
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -  
RUN apt-get install --assume-yes --no-install-recommends nodejs 

# Enable php-fpm on nginx virtualhost configuration
RUN echo "exit 0" > /usr/sbin/policy-rc.d
COPY default ${nginx_vhost}
RUN echo '<?php phpinfo(); ?>' > /var/www/html/info.php
RUN sed -i 's/^key_buffer\s*=/key_buffer_size =/' /etc/mysql/mysql.conf.d/mysqld.cnf
RUN sed -ie "s/^bind-address\s*=\s*127\.0\.0\.1$/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_conf} && \
    echo "\ndaemon off;" >> ${nginx_conf}

## Configuration
#RUN sed -i 's/^listen\s*=.*$/listen = 127.0.0.1:9000/' /etc/php/7.0/fpm/pool.d/www.conf && \
   # sed -i 's/^\;error_log\s*=\s*syslog\s*$/error_log = \/var\/log\/php\/cgi.log/' /etc/php/7.0/fpm/php.ini && \
   # sed -i 's/^\;error_log\s*=\s*syslog\s*$/error_log = \/var\/log\/php\/cli.log/' /etc/php/7.0/cli/php.ini

#phpmyadmin Installation 
RUN cd /var/www/html
RUN apt-get install unzip -y
ENV PHPMYADMIN_VERSION 4.8.3
#RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.8.3/phpMyAdmin-4.8.3-all-languages.zip
RUN wget https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.zip
#RUN unzip phpMyAdmin-4.8.3-all-languages.zip -d /var/www/html
RUN unzip phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.zip -d /var/www/html
#RUN mv /var/www/html/phpMyAdmin-4.8.3-all-languages /var/www/html/phpmyadmin
RUN mv /var/www/html/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages /var/www/html/phpmyadmin
#RUN rm -rf /var/www/html/phpMyAdmin-4.8.3-all-languages.zip
RUN rm -rf /var/www/html/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.zip
COPY config.inc.php /var/www/html/phpmyadmin 
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R  755 /var/www/html 

##PM2 Service Install
RUN npm install -g pm2

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

 
RUN mkdir -p /run/php && \
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /run/php

#Copy supervisor configuration
COPY supervisord.conf ${supervisor_conf}
COPY hello.js /var/www/html/
COPY package.json /var/www/html/
RUN cd /var/www/html; npm install --save
RUN cd /var/www/html; pm2 start hello.js
RUN pm2 startup systemd
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
 
# Volume configuration
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/run/php", "/var/log/nginx", "/var/www/html", "/var/lib/mysql/", "/var/log/mysql", "/etc/webmin"]

# Configure Services and Port
COPY start.sh /start.sh
CMD ["./start.sh"]

EXPOSE 80 443 3306 10000 8080
