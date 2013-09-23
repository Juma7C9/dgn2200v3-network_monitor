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
. $config_file

rrd=$rrdpath/$rrdname

imgname=${iface}_daily.png
img=$imgpath/$imgname

interval=1d

if [[ ! -e $rrd ]]
then
	echo "[ERROR] RRD file not found!"
	exit 0
fi

outcome=`rrdtool graph $img --imgformat PNG --lazy \
	--end now --start end-$interval \
	--title "$iface traffic" --vertical-label 'bits per second' \
	--height 120 --width 500 \
	--alt-autoscale-max --alt-autoscale-min \
	--slope-mode --base 1000 \
	--font TITLE:10:AXIS:7:LEGEND:8:UNIT:7 \
	DEF:rBavg=$rrd:$DS2:AVERAGE \
	DEF:rBmax=$rrd:$DS2:MAX \
	CDEF:ravg='rBavg,8,*' \
	CDEF:rmax='rBmax,8,*' \
	COMMENT:'DOWNSTREAM\c' \
	AREA:ravg\#00CF00FF:"Average" \
	GPRINT:ravg:LAST:" Current\:%8.2lf %s"  \
	GPRINT:ravg:AVERAGE:"Overall\:%8.2lf %s"  \
	LINE1:rmax\#002A97FF:"Maximum" \
	GPRINT:rmax:MAX:" Peak\:%8.2lf %s\n" \
	HRULE:0\#000000FF \
	DEF:tBavg=$rrd:$DS1:AVERAGE \
	DEF:tBmax=$rrd:$DS1:MAX \
	CDEF:tavg='0,tBavg,8,*,-' \
	CDEF:tmax='0,tBmax,8,*,-' \
	COMMENT:'UPSTREAM\c' \
	AREA:tavg\#EA8F00FF:"Average" \
        GPRINT:tavg:LAST:" Current\:%8.2lf %s"  \
        GPRINT:tavg:AVERAGE:"Overall\:%8.2lf %s"  \
        LINE1:tmax\#FF0000FF:"Maximum" \
        GPRINT:tmax:MIN:" Peak\:%8.2lf %s\n"`

echo "`date` [print_graph_daily]: $outcome"

exit 1

