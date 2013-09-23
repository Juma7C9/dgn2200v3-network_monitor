#!/bin/sh
config_file=$1

if [ -z ${config_file} ]
then
	echo "[ERROR]: You must specify config file!"
	echo "Usage: $0 config_file"
	exit 0
fi

if [[ ! -e ${config_file} ]]
then
	echo "[ERROR]: Config file not found!"
	exit 0
fi

# Source config
. ${config_file}

rrd=${rrdpath}/${rrdname}

if [[ ! -e /sys/class/net/${iface} ]]
then
        echo "[ERROR] interface $iface not found!"
        exit 0
fi

if [[ ! -e ${rrd} ]]
then
        echo "[ERROR] RRD not found!"
        exit 0
fi

tx_bytes=`cat /sys/class/net/${iface}/statistics/tx_bytes`
rx_bytes=`cat /sys/class/net/${iface}/statistics/rx_bytes`

outcome=`rrdtool update $rrd N:${tx_bytes}:${rx_bytes}`

echo "`date` [poll_stats]: $outcome ($tx_bytes:$rx_bytes)"

exit 1
