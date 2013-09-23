#!/bin/sh

config_file=$1

if [ -z $config_file ]
then
	echo "[ERROR]: no config file specified!"
	echo "Usage: $0 config_file"
	exit 0
fi

if [[ ! -e $config_file ]]
then
	echo "[ERROR]: Config file not found"
	exit 0
fi

# Source config
. ${config_file}

rrd=${rrdpath}/${rrdname}

rrdtool create $rrd --step 60 \
	DS:${DS1}:COUNTER:300:U:U \
	DS:${DS2}:COUNTER:300:U:U \
	RRA:AVERAGE:0.5:1:360 \
	RRA:MAX:0.5:1:360 \
	RRA:AVERAGE:0.5:5:432 \
	RRA:MAX:0.5:5:432 \
	RRA:AVERAGE:0.5:30:504 \
	RRA:MAX:0.5:30:504 \
	RRA:AVERAGE:0.5:120:540 \
	RRA:MAX:0.5:120:540 \
	RRA:AVERAGE:0.5:1440:549 \
	RRA:MAX:0.5:1440:549;

#DS1=up, DS2=down (default)

exit 1
