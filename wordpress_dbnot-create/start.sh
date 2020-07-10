#!/bin/bash
# Run the service
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

