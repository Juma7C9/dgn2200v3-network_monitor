#!/bin/sh

while true
do
	./print_graph_weekly.sh ./nas1.conf 2>&1 >> $logfile
	sleep 1800
done
