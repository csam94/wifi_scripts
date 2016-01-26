#!/bin/bash

devname=$1

if [ $# -le 1 ]
then
	echo "usage: sh init_wifi_ad-hoc.sh wifi_device_name physical_device_name"
	echo "eg: sudo sh init_wifi_ad-hoc.sh wlan0 phy0"
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


ip link set $devname down && sleep 1 #set device down
iw dev $devname set type ibss && sleep 1 #ad hoc mode
ip addr flush dev $devname && sleep 1 #flush previous config
ip addr add 10.0.0.10/24 dev $devname && sleep #assign static ip
ip link set $devname up && sleep 1 #set device up
iwconfig $devname essid "rockets" && sleep 1
iw phy $2 set rts -1



#################
# DISCLAIMER!!!!
######untested#######
