#!/bin/bash

/usr/sbin/sshd
echo "sshd is started"

MY_IP=$(hostname -I)
MY_IP_NO_TRAIL_SPACE="$(echo -e "${MY_IP}" | sed -e 's/[[:space:]]*$//')"
echo "$HOSTNAME" > /var/www_docker/rabbitmq
service lighttpd reload
service lighttpd restart 
echo "lighttpd is started"

sleep 20


chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
chmod 400 /var/lib/rabbitmq/.erlang.cookie

exec gosu rabbitmq /opt/rabbit/startrabbit2.sh

while true; do sleep 1000; done

