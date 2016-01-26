#!/bin/bash

devname=$1

if [ $# -le 1 ]
then
	echo "usage: sh init_wifi_ad-hoc.sh wifi_device_name wifi_physical_address"
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

ip link set $devname down && sleep 1
iw dev $devname set type ibss && sleep 1 #ibss = Ad-hoc
ip addr flush dev $devname && sleep 1
ip addr add dev $devname 10.0.0.8/24 && sleep 1 #default ip address
iw dev $devname set channel 1 && sleep 1 # set channel
ip link set $devname up && sleep 1
iwconfig $devname rate 1M fixed && sleep 1 # set transmit rate
iw $devname ibss join rockets 2412 #default essid "rockets" && sleep 1
iw phy $2 set rts -1


