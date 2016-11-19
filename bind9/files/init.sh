#!/bin/bash

source /lighttpd.sh

/usr/sbin/sshd
echo "sshd is started"

MY_IP=$(hostname -I)
MY_IP_NO_TRAIL_SPACE="$(echo -e "${MY_IP}" | sed -e 's/[[:space:]]*$//')"
echo "bind9 IP=$MY_IP_NO_TRAIL_SPACE"

sleep 5

get_whost_ips "rabbitmq"
 
#
# Script options (exit script on command fail).
#
set -e

#
# Define default Variables.
#
USER="named"
GROUP="named"
COMMAND_OPTIONS_DEFAULT="-f"
NAMED_UID_DEFAULT="1000"
NAMED_GID_DEFAULT="101"
COMMAND="/usr/sbin/named -u ${USER} -c /etc/bind/named.conf ${COMMAND_OPTIONS:=${COMMAND_OPTIONS_DEFAULT}}"

NAMED_UID_ACTUAL=$(id -u ${USER})
NAMED_GID_ACTUAL=$(id -g ${GROUP})

#
# Display settings on standard out.
#
echo "named settings"
echo "=============="
echo
echo "  Username:        ${USER}"
echo "  Groupname:       ${GROUP}"
echo "  UID actual:      ${NAMED_UID_ACTUAL}"
echo "  GID actual:      ${NAMED_GID_ACTUAL}"
echo "  UID prefered:    ${NAMED_UID:=${NAMED_UID_DEFAULT}}"
echo "  GID prefered:    ${NAMED_GID:=${NAMED_GID_DEFAULT}}"
echo "  Command:         ${COMMAND}"
echo


echo "Set owner and permissions... "
chown -R ${USER}:${GROUP} /etc/bind
chmod -R o-rwx /etc/bind
echo "[DONE]"

#
# Start named.
#
echo "Start named... "
exec ${COMMAND}

while true; do
  sleep 1
done

