#!/bin/bash

devname=$1

if [ $# -eq 0 ]
then
	echo "usage: sh init_wifi_ad-hoc.sh wifi_device_name"
	exit 1
fi

if [ "$(whoami)" != "root" ]
then
	echo "script must be run as root"
	exit 1
fi

if [ -f /usr/bin/systemctl ] #systemd
then
	systemctl stop NetworkManager.service
	systemctl stop NetworkManager.service
fi

if [ -f /usr/sbin/service ] #upstart
then
	service network-manager stop
fi

ip link set $devname down && sleep 1
iw dev $devname set monitor none && sleep 1 #monitor none = monitor with no flags
ip link set $devname up && sleep 1
ip addr flush dev $devname && sleep 1
ip addr add 10.0.0.9/24 broadcast 10.0.0.9 dev $devname && sleep 1


