#!/bin/sh
set -x
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
#sleep 2s;
#echo "webmin is starting"
#/usr/bin/touch /var/webmin/miniserv.log && /usr/sbin/service webmin restart && /usr/bin/tail -f /var/webmin/miniserv.log
