#!/usr/bin/env bash

function get_whost_ip_single() {
  output=$(wget --spider --connect-timeout=1 -t 1 http://172.17.0.$1:1180/$2 2>&1)
  result=$?
  if [ $result -eq 0 ]; then
    eval "$3='172.17.0.$1'"

    wget -qO /tmp/ip_hostname http://172.17.0.$1:1180/$2
    hostname=$(</tmp/ip_hostname)
    eval "$4=$hostname"
    rm -rf /tmp/ip_hostname
    return
  fi
  if [[ $output == *"No route to host"*  ]]; then
    eval "$3='STOP'"
    return
  fi
}

function get_whost_ip() {
  max_ip=15
  seeking_ip=""
  for i in $(seq 1 $max_ip);
  do
    get_whost_ip_single $i $1 seeking_ip
    if [ $seeking_ip ] && [ "$seeking_ip" != "STOP" ]; then
      echo "seeking_ip=$seeking_ip"
      eval "$2='$seeking_ip'"
      return
    fi
  done
}
 
function get_whost_ips() {
  max_ip=15
  declare -A hostname2ip
  for i in $(seq 1 $max_ip);
  do
    echo ""
    echo "get_whost_ip i=$i"
    unset seeking_ip
    unset seeking_hostname
    get_whost_ip_single $i $1 seeking_ip seeking_hostname
    if [ $seeking_ip ] && [ "$seeking_ip" != "STOP" ]; then
      echo "seeking_ip=$seeking_ip seeking_hostname=$seeking_hostname"
      hostname2ip["$seeking_hostname"]=$seeking_ip
    fi
  done

  echo "whole hostnames:"
  for key in ${!hostname2ip[@]}; 
  do 
     echo "  $key ${hostname2ip["$key"]}"
  done

  echo "create files"
  for key in ${!hostname2ip[@]}; 
  do
    hostname=$key
    ip=${hostname2ip["$key"]}
    echo "  $hostname $ip"

    echo "zone \"$hostname\" {" >> /etc/bind/named.conf.local
    echo '	type master;' >> /etc/bind/named.conf.local
    echo "	file \"/etc/bind/db.$hostname\";" >> /etc/bind/named.conf.local
    echo '};' >> /etc/bind/named.conf.local
    echo '' >> /etc/bind/named.conf.local

    echo '$TTL	604800' >> /etc/bind/db.$hostname
    echo "@	IN	SOA	$hostname. root.$hostname. (" >> /etc/bind/db.$hostname
    echo '			      2		; Serial' >> /etc/bind/db.$hostname
    echo '			 604800		; Refresh' >> /etc/bind/db.$hostname
    echo '			  86400		; Retry' >> /etc/bind/db.$hostname
    echo '			2419200		; Expire' >> /etc/bind/db.$hostname
    echo '			 604800 )	; Negative Cache TTL' >> /etc/bind/db.$hostname
    echo ';' >> /etc/bind/db.$hostname
    echo "@	IN	NS	$hostname." >> /etc/bind/db.$hostname
    echo "@	IN	A	$ip" >> /etc/bind/db.$hostname
    echo '@	IN	AAAA	::1' >> /etc/bind/db.$hostname
  done
}


