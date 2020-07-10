#!/bin/bash
echo "apache2 service is starting"
/etc/init.d/apache2 start
sleep 2s;
echo "mysql service is starting"
/etc/init.d/mysql start
sleep 2s;
echo "webmin is starting"
/usr/bin/touch /var/webmin/miniserv.log && /usr/sbin/service webmin restart && /usr/bin/tail -f /var/webmin/miniserv.log
