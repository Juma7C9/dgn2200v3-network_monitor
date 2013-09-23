#!/bin/sh

export logfile="/mnt/usb/rrdtool/rrdtool.log"

./1min_cronlike.sh &
./5min_cronlike.sh &
./30min_cronlike.sh &
./2h_cronlike.sh &
./day_cronlike.sh &
