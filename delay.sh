# Use sh delay.sh <wireless device name> <delay in ms> to specify a delay time
# i.e. sh delay.sh wlan1 1000ms

# NOTE: This script will delay ALL PACKETS sent or received by the specified wireless device
# This script can be run as sh delay.sh <wireless device name> 0ms to remove any delay

#!/bin/bash

devname=$1
t=$2

if [ $# -lt 2 ]
then
        echo "usage: sh delay.sh <wireless device name> <delay in ms>"
        exit 1
fi

if [ "$(whoami)" != "root" ]
then
        echo "script must be run as root"
        exit 1
fi

tc qdisc replace dev $devname root netem delay $t
