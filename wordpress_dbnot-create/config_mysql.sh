#!/bin/bash

__handle_passwords() {
# Here we generate random passwords (thank you pwgen!). The first two are for mysql users, the last batch for random keys in wp-config.php
#WORDPRESS_DB="wordpress"
#MYSQL_PASSWORD=`pwgen -c -n -1 12`
#MYSQL_PASSWORD="root"
#WORDPRESS_PASSWORD=`pwgen -c -n -1 12`
# This is so the passwords show up in logs. 
#echo mysql root password: $MYSQL_PASSWORD
#echo wordpress password: $WORDPRESS_PASSWORD
#echo $MYSQL_PASSWORD > /mysql-root-pw.txt
#echo $WORDPRESS_PASSWORD > /wordpress-db-pw.txt
# There used to be a huge ugly line of sed and cat and pipe and stuff below,
# but thanks to @djfiander's thing at https://gist.github.com/djfiander/6141138
# there isn't now.
sed -e "s/database_name_here/$WORDPRESS_DB/
s/username_here/root/
s/password_here/$MYSQL_PASSWORD/
/'AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'SECURE_AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'LOGGED_IN_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'NONCE_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'SECURE_AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'LOGGED_IN_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'NONCE_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/" /var/www/html/wordpress/wp-config-sample.php > /var/www/html/wordpress/wp-config.php
}

#__mysql_config() {
## Here we can install mysql-server
#apt-get purge mysql-server* -y
#sleep 2s;
#rm -rf /var/lib/mysql/ /etc/my.cnf
#debconf-set-selections <<< 'mysql-server mysql-server/root_password password $MYSQL_PASSWORD'
#debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD'
#apt-get -y install mysql-server
#sed -ie "s/^bind-address\s*=\s*127\.0\.0\.1$/bind-address = 0.0.0.0/"  /etc/mysql/mysql.conf.d/mysqld.cnf
#sed -i 's/^key_buffer\s*=/key_buffer_size =/' /etc/mysql/mysql.conf.d/mysqld.cnf
#chown -R mysql:mysql /var/lib/mysql
#/etc/init.d/mysql start &
#sleep 5
#}

__start_mysql() {
echo "Running the start_mysql function."
/etc/init.d/mysql start
mysql -uroot password$MYSQL_PASSWORD <<EOF
CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost';
FLUSH PRIVILEGES;
EOF
kill -9 -1
sleep 10
}

__remove_debian_systen_maint_password() {
  #
  # the default password for the debian-sys-maint user is randomly generated
  # during the installation of the mysql-server package.
  #
  # Due to the nature of docker we blank out the password such that the maintenance
  # user can login without a password.
  #
  sed 's/password = .*/password = /g' -i /etc/mysql/debian.cnf
}

# Call all functions
__handle_passwords
__remove_debian_systen_maint_password
__start_mysql
